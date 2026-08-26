table 51156 "FNF Rental Reservation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Camera No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Camera Equipment"."No.";
            NotBlank = true;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Rental Header"."No.";
            NotBlank = true;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Rental Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(5; "Reservation Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(6; "Reservation End Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(7; Status; Enum "FNF Reservation Status")
        {
            DataClassification = ToBeClassified;
            InitValue = Reserved;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(CameraDate; "Camera No.", "Reservation Start Date", "Reservation End Date")
        {
        }
        key(Document; "Document No.", "Line No.")
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateOverlap();
    end;

    trigger OnModify()
    begin
        ValidateOverlap();
    end;

    local procedure ValidateOverlap()
    var
        Reservation: Record "FNF Rental Reservation";
    begin
        if ("Reservation Start Date" <> 0D) and ("Reservation End Date" <> 0D) then begin
            if "Reservation End Date" < "Reservation Start Date" then
                Error('Reservation End Date must be on or after Start Date.');
        end;

        // Check for overlapping reservations for the same camera (excluding self)
        Reservation.SetRange("Camera No.", "Camera No.");
        Reservation.SetFilter("Reservation Start Date", '<= %1', "Reservation End Date");
        Reservation.SetFilter("Reservation End Date", '>= %1', "Reservation Start Date");
        Reservation.SetFilter(Status, '<> %1', Status::Released);
        Reservation.SetFilter("Entry No.", '<> %1', "Entry No.");
        if Reservation.FindFirst() then
            Error('Camera %1 is already reserved for the overlapping period.', "Camera No.");
    end;
}