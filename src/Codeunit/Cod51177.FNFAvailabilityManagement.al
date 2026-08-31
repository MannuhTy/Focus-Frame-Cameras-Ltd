codeunit 51177 "FNF Availability Management"
{
    // Availability checks for the rental portal, combining:
    //   - Camera Equipment status / condition / maintenance schedule
    //   - Rental Reservation overlap checks (same logic as FNF Rental
    //     Reservation.ValidateOverlap, but read-only — no record inserted)
    //
    // Matches the "CheckAvailability(CameraNo, StartDate, EndDate)" contract
    // described for the portal's Custom API in the system documentation.

    /// <summary>
    /// Full availability check with a human-readable reason on failure.
    /// Use this from the API layer so the portal can show *why* a camera
    /// is unavailable, not just that it is.
    /// </summary>
    procedure CheckAvailability(CameraNo: Code[20]; StartDate: Date; EndDate: Date; var ErrorMessage: Text): Boolean
    var
        Camera: Record "FNF Camera Equipment";
    begin
        ErrorMessage := '';

        if (StartDate = 0D) or (EndDate = 0D) then begin
            ErrorMessage := 'Start Date and End Date must be specified.';
            exit(false);
        end;

        if EndDate < StartDate then begin
            ErrorMessage := 'End Date cannot be before Start Date.';
            exit(false);
        end;

        if not Camera.Get(CameraNo) then begin
            ErrorMessage := StrSubstNo('Camera %1 does not exist.', CameraNo);
            exit(false);
        end;

        if Camera.Blocked then begin
            ErrorMessage := StrSubstNo('Camera %1 is blocked for rental.', CameraNo);
            exit(false);
        end;

        case Camera.Status of
            Camera.Status::"In Maintenance":
                begin
                    ErrorMessage := StrSubstNo('Camera %1 is currently in maintenance.', CameraNo);
                    exit(false);
                end;
            Camera.Status::Retired:
                begin
                    ErrorMessage := StrSubstNo('Camera %1 has been retired.', CameraNo);
                    exit(false);
                end;
        end;

        if (Camera."Next Maintenance Date" <> 0D) and (Camera."Next Maintenance Date" <= EndDate) then begin
            ErrorMessage := StrSubstNo('Camera %1 is scheduled for maintenance on %2, before the requested return date.',
                CameraNo, Camera."Next Maintenance Date");
            exit(false);
        end;

        if HasOverlappingReservation(CameraNo, StartDate, EndDate) then begin
            ErrorMessage := StrSubstNo('Camera %1 is already reserved for part or all of the requested period.', CameraNo);
            exit(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Simple boolean wrapper around CheckAvailability, for callers that
    /// don't need the reason (e.g. building a browse list quickly).
    /// </summary>
    procedure IsCameraAvailable(CameraNo: Code[20]; StartDate: Date; EndDate: Date): Boolean
    var
        ErrorMessage: Text;
    begin
        exit(CheckAvailability(CameraNo, StartDate, EndDate, ErrorMessage));
    end;

    /// <summary>
    /// Same as IsCameraAvailable, but excludes one specific rental line's own
    /// reservation from the overlap check. Use this when a customer or staff
    /// member is editing the dates on an existing, not-yet-active line —
    /// otherwise the line would always conflict with itself.
    /// </summary>
    procedure IsCameraAvailableExcludingLine(CameraNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeDocumentNo: Code[20]; ExcludeLineNo: Integer): Boolean
    var
        Camera: Record "FNF Camera Equipment";
    begin
        if not Camera.Get(CameraNo) then
            exit(false);
        if Camera.Blocked then
            exit(false);
        if Camera.Status in [Camera.Status::"In Maintenance", Camera.Status::Retired] then
            exit(false);
        if (Camera."Next Maintenance Date" <> 0D) and (Camera."Next Maintenance Date" <= EndDate) then
            exit(false);

        exit(not HasOverlappingReservationExcludingLine(CameraNo, StartDate, EndDate, ExcludeDocumentNo, ExcludeLineNo));
    end;

    /// <summary>
    /// Returns every camera (optionally filtered to one category) that is
    /// available for the whole requested period. Intended for the portal's
    /// "browse available cameras for these dates" search.
    /// </summary>
    procedure GetAvailableCameras(CategoryCode: Code[20]; StartDate: Date; EndDate: Date; var TempCamera: Record "FNF Camera Equipment" temporary)
    var
        Camera: Record "FNF Camera Equipment";
    begin
        TempCamera.Reset();
        TempCamera.DeleteAll();

        Camera.SetRange(Blocked, false);
        Camera.SetFilter(Status, '<>%1&<>%2', Camera.Status::"In Maintenance", Camera.Status::Retired);
        if CategoryCode <> '' then
            Camera.SetRange("Category Code", CategoryCode);

        if Camera.FindSet() then
            repeat
                if (Camera."Next Maintenance Date" = 0D) or (Camera."Next Maintenance Date" > EndDate) then
                    if not HasOverlappingReservation(Camera."No.", StartDate, EndDate) then begin
                        TempCamera := Camera;
                        TempCamera.Insert();
                    end;
            until Camera.Next() = 0;
    end;

    local procedure HasOverlappingReservation(CameraNo: Code[20]; StartDate: Date; EndDate: Date): Boolean
    var
        Reservation: Record "FNF Rental Reservation";
    begin
        Reservation.SetRange("Camera No.", CameraNo);
        Reservation.SetFilter(Status, '<>%1', Reservation.Status::Released);
        Reservation.SetFilter("Reservation Start Date", '<=%1', EndDate);
        Reservation.SetFilter("Reservation End Date", '>=%1', StartDate);
        exit(not Reservation.IsEmpty());
    end;

    local procedure HasOverlappingReservationExcludingLine(CameraNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeDocumentNo: Code[20]; ExcludeLineNo: Integer): Boolean
    var
        Reservation: Record "FNF Rental Reservation";
    begin
        Reservation.SetRange("Camera No.", CameraNo);
        Reservation.SetFilter(Status, '<>%1', Reservation.Status::Released);
        Reservation.SetFilter("Reservation Start Date", '<=%1', EndDate);
        Reservation.SetFilter("Reservation End Date", '>=%1', StartDate);
        if Reservation.FindSet() then
            repeat
                if not ((Reservation."Document No." = ExcludeDocumentNo) and (Reservation."Line No." = ExcludeLineNo)) then
                    exit(true);
            until Reservation.Next() = 0;
        exit(false);
    end;
}
