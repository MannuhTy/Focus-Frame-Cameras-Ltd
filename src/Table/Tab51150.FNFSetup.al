table 51150 "FNF Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Primary Key for the FNF Setup table.';
            InitValue = '';
        }
        field(2; "Camera Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Camera Number series relation';
            TableRelation = "No. Series";
        }
        field(3; "Rental Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Rental Number series relation';
            TableRelation = "No. Series";
        }
        field(4; "Default Deposit"; Decimal)
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Default deposit amount for rentals.';
        }
        field(5; "Rental Income Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'General Ledger account relation for rental income.';
            TableRelation = "G/L Account";
        }
        field(6; "Damage Charge Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'General Ledger account relation for damage charges.';
            TableRelation = "G/L Account";
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}