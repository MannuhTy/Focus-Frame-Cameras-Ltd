page 51167 "FNF Rental Rate Card"
{
    ApplicationArea = All;
    Caption = 'Rental Rate';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "FNF Rental Rate";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique entry number for the rental rate.';
                }

                field("Rate Type"; Rec."Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is a daily, weekly, or monthly rate.';
                }

                field("Rate Amount"; Rec."Rate Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount charged for the selected rental period.';
                }
            }

            group(Scope)
            {
                Caption = 'Rate Scope';

                field("Camera No."; Rec."Camera No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a camera-specific rate. Leave blank when creating a category rate.';
                }

                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a category-wide rate. Leave blank when creating a camera-specific rate.';
                }
            }

            group(Validity)
            {
                Caption = 'Validity';

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first date on which this rate applies.';
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date on which this rate applies. Leave blank for an open-ended rate.';
                }
            }
        }
    }
}