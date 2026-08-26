table 51151 "FNF Camera Category"
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
            ToolTip = 'Camera Category Description';
        }
        field(3; "Default Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Default Daily Rate for the camera category';
        }
        field(4; "Default Weekly Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Default Weekly Rate for the camera category';
        }
        field(5; "Default Monthly Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Default Monthly Rate for the camera category';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Description; Description)
        {
        }
    }
}