table 51154 "FNF Rental Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate()
            begin
                CalcFields("Customer Name");
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
        }
        field(4; "Rental Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                ValidateRentalDates();
            end;
        }
        field(5; "Rental End Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                ValidateRentalDates();
            end;
        }
        field(6; Status; Enum "FNF Rental Status")
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Deposit Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Deposit Refunded"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Pickup Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Return Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("FNF Rental Line"."Line Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
        }
        field(13; "Posted Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(14; "Created Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser"."Code";
        }
        field(16; "Rental Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(18; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Version No."; BigInteger)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(20; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        FNFSetup: Record "FNF Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            FNFSetup.Get();
            FNFSetup.TestField("Rental Nos");

            "No. Series" := FNFSetup."Rental Nos";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

        "Created Date" := WorkDate();
        "Rental Order Date" := WorkDate();
    end;

    trigger OnModify()
    begin
        ValidateRentalDates();

        if xRec.Status <> Status then
            ValidateStatusTransition(xRec.Status, Status);
    end;

    local procedure ValidateRentalDates()
    begin
        if ("Rental Start Date" <> 0D) and
           ("Rental End Date" <> 0D) and
           ("Rental End Date" < "Rental Start Date")
        then
            Error('Rental End Date must be on or after Rental Start Date.');
    end;

    local procedure ValidateStatusTransition(
        OldStatus: Enum "FNF Rental Status";
        NewStatus: Enum "FNF Rental Status")
    begin
        if OldStatus = NewStatus then
            exit;

        case OldStatus of
            OldStatus::Quote:
                if not (NewStatus in [OldStatus::Confirmed, OldStatus::Cancelled]) then
                    Error('From Quote, status can only change to Confirmed or Cancelled.');
            OldStatus::Confirmed:
                if not (NewStatus in [OldStatus::Active, OldStatus::Cancelled]) then
                    Error('From Confirmed, status can only change to Active or Cancelled.');
            OldStatus::Active:
                if not (NewStatus in [OldStatus::Returned, OldStatus::Cancelled]) then
                    Error('From Active, status can only change to Returned or Cancelled.');
            OldStatus::Returned:
                if NewStatus <> OldStatus::Closed then
                    Error('From Returned, status can only change to Closed.');
            OldStatus::Closed, OldStatus::Cancelled:
                Error('Cannot change status from %1.', OldStatus);
        end;
    end;
}