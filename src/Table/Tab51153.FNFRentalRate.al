table 51153 "FNF Rental Rate"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = True;
        }
        field(2; "Camera No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Camera Equipment"."No.";
        }
        field(3; "Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Camera Category"."No.";
        }
        field(4; "Rate Type"; Enum "FNF Rate Type")
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Rate Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Starting Date"; Date)
        {
        }
        field(7; "Ending Date"; Date)
        {
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Uniq; "Camera No.", "Category Code", "Rate Type", "Starting Date")
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateRate();
    end;

    trigger OnModify()
    begin
        ValidateRate();
    end;

    local procedure ValidateRate()
    var
        ExistingRate: Record "FNF Rental Rate";
    begin
        if ("Camera No." = '') and ("Category Code" = '') then
            Error('Either Camera No. or Category Code must be specified.');

        if ("Camera No." <> '') and ("Category Code" <> '') then
            Error('Specify either Camera No. or Category Code, not both.');

        if "Starting Date" = 0D then
            Error('Starting Date must be specified.');

        if ("Ending Date" <> 0D) and ("Ending Date" < "Starting Date") then
            Error('Ending Date must be on or after Starting Date.');

        ExistingRate.SetRange("Camera No.", "Camera No.");
        ExistingRate.SetRange("Category Code", "Category Code");
        ExistingRate.SetRange("Rate Type", "Rate Type");

        if ExistingRate.FindSet() then
            repeat
                if (ExistingRate."Entry No." <> "Entry No.") and
                   DateRangesOverlap(
                       "Starting Date", "Ending Date",
                       ExistingRate."Starting Date", ExistingRate."Ending Date")
                then
                    Error('An overlapping rental rate already exists.');
            until ExistingRate.Next() = 0;
    end;

    local procedure DateRangesOverlap(
        FirstStartDate: Date;
        FirstEndDate: Date;
        SecondStartDate: Date;
        SecondEndDate: Date): Boolean
    begin
        if (FirstEndDate <> 0D) and (SecondStartDate > FirstEndDate) then
            exit(false);

        if (SecondEndDate <> 0D) and (FirstStartDate > SecondEndDate) then
            exit(false);

        exit(true);
    end;
}