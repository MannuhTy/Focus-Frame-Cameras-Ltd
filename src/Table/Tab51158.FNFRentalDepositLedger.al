table 51158 "FNF Rental Deposit Ledger"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FNF Rental Header"."No.";
            NotBlank = true;
        }
        field(3; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            NotBlank = true;
        }
        field(4; "Entry Type"; Enum "FNF Deposit Entry Type")
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(7; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Document; "Document No.")
        {
        }
        key(Customer; "Customer No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();

        TestField("Document No.");
        TestField("Customer No.");

        if Amount <= 0 then
            Error('Deposit ledger amounts must be greater than zero.');
    end;
}