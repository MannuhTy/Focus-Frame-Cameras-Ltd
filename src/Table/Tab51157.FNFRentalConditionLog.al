table 51157 "FNF Rental Condition Log"
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
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Log Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(6; "Condition Before"; Enum "FNF Camera Condition")
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(7; "Condition After"; Enum "FNF Camera Condition")
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(8; Notes; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Damage Charge Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Photo; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Logged By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Camera; "Camera No.", "Log Date")
        {
        }
        key(Document; "Document No.", "Line No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Log Date" = 0D then
            "Log Date" := WorkDate();

        if "Logged By" = '' then
            "Logged By" := CopyStr(UserId(), 1, MaxStrLen("Logged By"));

        UpdateCameraCondition();

        if "Damage Charge Amount" > 0 then
            CreateDepositForfeitedEntry();
    end;

    local procedure CreateDepositForfeitedEntry()
    var
        Header: Record "FNF Rental Header";
        DepositManagement: Codeunit "FNF Deposit Management";
    begin
        if not Header.Get("Document No.") then
            Error('Rental document %1 does not exist.', "Document No.");

        DepositManagement.RegisterDepositForfeited(
            Header,
            "Damage Charge Amount",
            "Log Date",
            StrSubstNo(
    'Damage charge for rental %1, camera %2',
    "Document No.",
    "Camera No."));
    end;

    local procedure UpdateCameraCondition()
    var
        Camera: Record "FNF Camera Equipment";
    begin
        if not Camera.Get("Camera No.") then
            exit;

        Camera.Condition := "Condition After";

        if "Condition After" = "Condition After"::Damaged then
            Camera.Status := Camera.Status::"In Maintenance";

        Camera.Modify(true);
    end;
}