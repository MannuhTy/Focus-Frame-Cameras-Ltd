table 51155 "FNF Rental Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Rental Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(3; "Camera No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Camera Equipment"."No.";
            NotBlank = true;
            trigger OnValidate()
            begin
                ValidateCamera();
                UpdateUintRate();
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Description';
        }
        field(5; "Rental Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                ValidateDates();
                UpdateUintRate();
                CalculateLineAmount();
            end;
        }
        field(6; "Rental End Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                ValidateDates();
                UpdateUintRate();
                CalculateLineAmount();
            end;
        }
        field(7; "No. of Days"; Integer)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Number of days for the rental period.';
        }
        field(8; "Rate Type"; Enum "FNF Rate Type")
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                UpdateUintRate();
                CalculateLineAmount();
            end;
        }
        field(9; "Unit Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Rental rate per period.';
            trigger OnValidate()
            begin
                CalculateLineAmount();
            end;
        }
        field(10; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 0;
            trigger OnValidate()
            begin
                ValidateDiscount();
                CalculateLineAmount();
            end;
        }
        field(11; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Damage Charge"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Charge for any damages to the camera equipment.';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Camera; "Camera No.")
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateHeaderAllowsLineChange();
        InitLineDefaults();
        ValidateDates();
        ValidateCamera();
        UpdateUintRate();
        CalculateLineAmount();
    end;

    trigger OnModify()
    begin
        ValidateHeaderAllowsLineChange();
        ValidateDates();
        CalculateLineAmount();
    end;

    trigger OnDelete()
    begin
        ValidateHeaderAllowsLineChange();
    end;

    local procedure ValidateCamera()
    var
        Camera: Record "FNF Camera Equipment";
    begin
        if not Camera.Get("Camera No.") then
            Error('Camera %1 does not exist.', "Camera No.");

        if Camera.Blocked then
            Error('Camera %1 is blocked for rental.', "Camera No.");

        if Camera.Status in [Camera.Status::"In Maintenance", Camera.Status::Retired] then
            Error('Camera %1 is not available for rental because its status is %2.',
                Camera."No.", Camera.Status);

        if (Camera."Next Maintenance Date" <> 0D) and
           ("Rental End Date" <> 0D) and
           (Camera."Next Maintenance Date" <= "Rental End Date")
        then
            Error('Camera %1 requires maintenance on %2 before this rental ends.',
                Camera."No.", Camera."Next Maintenance Date");

        Description := Camera.Description;
    end;

    local procedure ValidateDates()
    begin
        if ("Rental Start Date" <> 0D) and ("Rental End Date" <> 0D) then begin
            if "Rental End Date" < "Rental Start Date" then
                Error('Rental End Date must be on or after Rental Start Date.');
        end;
    end;

    local procedure ValidateDiscount()
    begin
        if "Discount %" < 0 then
            "Discount %" := 0;
        if "Discount %" > 100 then
            "Discount %" := 100;
    end;

    local procedure CalculateLineAmount()
    var
        Days: Integer;
        BillablePeriods: Integer;
    begin
        if ("Rental Start Date" = 0D) or ("Rental End Date" = 0D) then begin
            "No. of Days" := 0;
            "Line Amount" := 0;
            exit;
        end;

        Days := "Rental End Date" - "Rental Start Date" + 1;
        "No. of Days" := Days;

        case "Rate Type" of
            "Rate Type"::Daily:
                BillablePeriods := Days;
            "Rate Type"::Weekly:
                BillablePeriods := (Days + 6) div 7;
            "Rate Type"::Monthly:
                BillablePeriods := (Days + 29) div 30;
        end;

        "Line Amount" :=
            Round("Unit Rate" * BillablePeriods * (1 - "Discount %" / 100), 0.01);
    end;


    local procedure InitLineDefaults()
    var
        Header: Record "FNF Rental Header";
    begin
        if Header.Get("Document No.") then begin
            if "Rental Start Date" = 0D then
                "Rental Start Date" := Header."Rental Start Date";
            if "Rental End Date" = 0D then
                "Rental End Date" := Header."Rental End Date";
        end;
        if "Discount %" = 0 then
            "Discount %" := 0;
    end;

    local procedure ValidateHeaderAllowsLineChange()
    var
        Header: Record "FNF Rental Header";
    begin
        if Header.Get("Document No.") then begin
            if Header.Status in [Header.Status::Active, Header.Status::Returned, Header.Status::Closed, Header.Status::Cancelled] then
                Error('Cannot modify lines when rental is %1.', Header.Status);
        end;
    end;

    local procedure UpdateUintRate()
    var
        Camera: Record "FNF Camera Equipment";
        Category: Record "FNF Camera Category";
        RateAmount: Decimal;

    begin
        if ("Camera No." = '') or ("Rental Start Date" = 0D) then
            exit;
        if TryGetRate("Camera No.", '', "Rental Start Date", "Rate Type", RateAmount) then begin
            "Unit Rate" := RateAmount;
            exit;
        end;

        Camera.Get("Camera No.");

        if TryGetRate('', Camera."Category Code", "Rental Start Date", "Rate Type", RateAmount) then begin
            "Unit Rate" := RateAmount;
            exit;
        end;

        Category.Get(Camera."Category Code");

        case "Rate Type" of
            "Rate Type"::Daily:
                "Unit Rate" := Category."Default Daily Rate";
            "Rate Type"::Weekly:
                "Unit Rate" := Category."Default Weekly Rate";
            "Rate Type"::Monthly:
                "Unit Rate" := Category."Default Monthly Rate";
        end;

        if "Unit Rate" <= 0 then
            Error('No rental rate is configured for camera %1.', "Camera No.");
    end;

    local procedure TryGetRate(
        CameraNo: Code[20];
        CategoryCode: Code[20];
        RateDate: Date;
        RateType: Enum "FNF Rate Type";

        var RateAmount: Decimal): Boolean

    var
        RentalRate: Record "FNF Rental Rate";

    begin
        RentalRate.SetCurrentKey("Camera No.", "Category Code", "Rate Type", "Starting Date");
        RentalRate.SetRange("Camera No.", CameraNo);
        RentalRate.SetRange("Category Code", CategoryCode);
        RentalRate.SetRange("Rate Type", RateType);
        RentalRate.SetFilter("Starting Date", '<=%1', RateDate);
        RentalRate.SetFilter("Ending Date", '%1|>=%2', 0D, RateDate);

        if not RentalRate.FindLast() then
            exit(false);

        RateAmount := RentalRate."Rate Amount";
        exit(true);
    end;

}