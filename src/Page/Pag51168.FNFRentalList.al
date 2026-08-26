page 51168 "FNF Rental List"
{
    ApplicationArea = All;
    Caption = 'Rentals';
    PageType = List;
    CardPageId = "FNF Rental Card";
    SourceTable = "FNF Rental Header";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental document number.';
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer renting the equipment.';
                }

                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the rental customer.';
                }

                field("Rental Start Date"; Rec."Rental Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the rental starts.';
                }

                field("Rental End Date"; Rec."Rental End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the rental ends.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current rental status.';
                }

                field("Deposit Amount"; Rec."Deposit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the required deposit amount.';
                }

                field("Deposit Received"; Rec."Deposit Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the deposit has been received.';
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total rental amount, excluding any damage charges.';
                }

                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salesperson responsible for the rental.';
                }
            }
        }
    }
}