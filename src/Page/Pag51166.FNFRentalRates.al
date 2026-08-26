page 51166 "FNF Rental Rates"
{
    ApplicationArea = All;
    Caption = 'Rental Rates';
    DelayedInsert = true;
    PageType = List;
    CardPageId = "FNF Rental Rate Card";
    SourceTable = "FNF Rental Rate";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique entry number for the rental rate.';
                }

                field("Camera No."; Rec."Camera No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a camera-specific rental rate.';
                }

                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a category-wide rental rate.';
                }

                field("Rate Type"; Rec."Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the rate is daily, weekly, or monthly.';
                }

                field("Rate Amount"; Rec."Rate Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount charged per rental period.';
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first date this rate applies.';
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date this rate applies. Leave blank for an open-ended rate.';
                }
            }
        }
    }
}