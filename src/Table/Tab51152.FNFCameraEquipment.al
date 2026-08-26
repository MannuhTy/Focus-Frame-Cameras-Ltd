table 51152 "FNF Camera Equipment"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Description';
        }
        field(3; "Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Category';
            TableRelation = "FNF Camera Category"."No.";
            NotBlank = true;
        }
        field(4; Brand; Text[50])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Brand';
        }
        field(5; Model; Text[50])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Model';
        }
        field(6; "Serial No."; Text[50])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Serial Number';
        }
        field(7; Status; Enum "FNF Camera Status")
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Status';
            InitValue = Available;
        }
        field(8; Condition; Enum "FNF Camera Condition")
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Condition';
            InitValue = New;
        }
        field(9; "Replacement Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Replacement Value';
        }
        field(10; "Purchase Date"; Date)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Purchase Date';
        }
        field(11; "Fixed Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Fixed Asset Number';
            TableRelation = "Fixed Asset"."No.";
        }
        field(12; Image; Media)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Image';
        }
        field(13; "Last Maintenance Date"; Date)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Last Maintenance Date';
        }
        field(14; "Next Maintenance Date"; Date)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Next Maintenance Date';
        }
        field(15; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Indicates whether the camera is blocked for rental.';
        }
        field(16; "No. Series"; Code[20])
        {
            DataClassification = SystemMetadata;
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
            FNFSetup.TestField("Camera Nos");

            "No. Series" := FNFSetup."Camera Nos";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
    end;
}