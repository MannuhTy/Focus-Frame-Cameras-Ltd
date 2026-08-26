page 51169 "FNF Rental Lines Subform"
{
    ApplicationArea = All;
    Caption = 'Rental Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "FNF Rental Line";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Camera No."; Rec."Camera No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera being rented.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the description of the selected camera.';
                }

                field("Rental Start Date"; Rec."Rental Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first day of the rental period.';
                }

                field("Rental End Date"; Rec."Rental End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last day of the rental period.';
                }

                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the calculated number of rental days.';
                }

                field("Rate Type"; Rec."Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the rental is billed daily, weekly, or monthly.';
                }

                field("Unit Rate"; Rec."Unit Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate charged per billing period.';
                }

                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount percentage applied to this line.';
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the calculated rental amount for this line.';
                }

                field("Damage Charge"; Rec."Damage Charge")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any damage charge recorded against this rental line.';
                }
            }
        }
    }
}