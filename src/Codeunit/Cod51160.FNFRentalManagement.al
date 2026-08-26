codeunit 51160 "FNF Rental Management"
{

    //Confirm Rental
    procedure ConfirmRental(var RentalHeader: Record "FNF Rental Header")
    begin
        if RentalHeader.Status <> RentalHeader.Status::Quote then
            Error('Only rental quotes can be confirmed.');

        RentalHeader.TestField("Customer No.");
        RentalHeader.TestField("Rental Start Date");
        RentalHeader.TestField("Rental End Date");

        CreateReservations(RentalHeader);

        RentalHeader.Validate(Status, RentalHeader.Status::Confirmed);
        RentalHeader.Modify(true);

        UpdateCameraStatus(RentalHeader, Enum::"FNF Camera Status"::Reserved);
    end;


    //Activate Rental
    procedure ActivateRental(var RentalHeader: Record "FNF Rental Header")
    begin
        if RentalHeader.Status <> RentalHeader.Status::Confirmed then
            Error('Only confirmed rentals can be activated.');

        UpdateReservationStatus(RentalHeader, Enum::"FNF Reservation Status"::Active);

        RentalHeader.Validate(Status, RentalHeader.Status::Active);
        RentalHeader.Modify(true);

        UpdateCameraStatus(RentalHeader, Enum::"FNF Camera Status"::Rented);
    end;


    //Return Rental
    procedure ReturnRental(var RentalHeader: Record "FNF Rental Header")
    begin
        if RentalHeader.Status <> RentalHeader.Status::Active then
            Error('Only active rentals can be returned.');

        UpdateReservationStatus(RentalHeader, Enum::"FNF Reservation Status"::Released);

        RentalHeader.Validate(Status, RentalHeader.Status::Returned);
        RentalHeader.Modify(true);

        UpdateCameraStatus(RentalHeader, Enum::"FNF Camera Status"::Available);
    end;


    //Cancel Rental
    procedure CancelRental(var RentalHeader: Record "FNF Rental Header")
    begin
        if not (RentalHeader.Status in [RentalHeader.Status::Quote, RentalHeader.Status::Confirmed]) then
            Error('Only quote or confirmed rentals can be cancelled.');

        UpdateReservationStatus(RentalHeader, Enum::"FNF Reservation Status"::Released);

        RentalHeader.Validate(Status, RentalHeader.Status::Cancelled);
        RentalHeader.Modify(true);

        UpdateCameraStatus(RentalHeader, Enum::"FNF Camera Status"::Available);
    end;

    local procedure CreateReservations(RentalHeader: Record "FNF Rental Header")
    var
        RentalLine: Record "FNF Rental Line";
        Reservation: Record "FNF Rental Reservation";
    begin
        RentalLine.SetRange("Document No.", RentalHeader."No.");

        if not RentalLine.FindSet() then
            Error('Rental %1 must contain at least one line.', RentalHeader."No.");

        repeat
            RentalLine.TestField("Camera No.");
            RentalLine.TestField("Rental Start Date");
            RentalLine.TestField("Rental End Date");

            Reservation.SetRange("Document No.", RentalLine."Document No.");
            Reservation.SetRange("Line No.", RentalLine."Line No.");

            if not Reservation.FindFirst() then begin
                Reservation.Init();
                Reservation."Camera No." := RentalLine."Camera No.";
                Reservation."Document No." := RentalLine."Document No.";
                Reservation."Line No." := RentalLine."Line No.";
                Reservation."Reservation Start Date" := RentalLine."Rental Start Date";
                Reservation."Reservation End Date" := RentalLine."Rental End Date";
                Reservation.Status := Reservation.Status::Reserved;
                Reservation.Insert(true);
            end;
        until RentalLine.Next() = 0;
    end;

    local procedure UpdateReservationStatus(
        RentalHeader: Record "FNF Rental Header";
        NewStatus: Enum "FNF Reservation Status")
    var
        Reservation: Record "FNF Rental Reservation";
    begin
        Reservation.SetRange("Document No.", RentalHeader."No.");

        if Reservation.FindSet(true) then
            repeat
                Reservation.Status := NewStatus;
                Reservation.Modify(true);
            until Reservation.Next() = 0;
    end;

    local procedure UpdateCameraStatus(
        RentalHeader: Record "FNF Rental Header";
        NewStatus: Enum "FNF Camera Status")
    var
        RentalLine: Record "FNF Rental Line";
        Camera: Record "FNF Camera Equipment";
    begin
        RentalLine.SetRange("Document No.", RentalHeader."No.");

        if RentalLine.FindSet() then
            repeat
                if Camera.Get(RentalLine."Camera No.") then begin
                    if not ((NewStatus = NewStatus::Available) and
                            (Camera.Status = Camera.Status::"In Maintenance"))
                    then
                        Camera.Status := NewStatus;

                    Camera.Modify(true);
                end;
            until RentalLine.Next() = 0;
    end;
}