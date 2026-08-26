page 51174 "FNF Deposit Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Rental Deposit Ledger Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FNF Rental Deposit Ledger";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique ledger entry number.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which this deposit entry was recorded.';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental document related to this deposit entry.';
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer related to this deposit entry.';
                }

                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the deposit was received, refunded, or forfeited.';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deposit amount.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the deposit transaction.';
                }
            }
        }
    }
}