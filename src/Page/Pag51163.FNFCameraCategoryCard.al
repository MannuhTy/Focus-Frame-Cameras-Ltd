page 51163 "FNF Camera Category Card"
{
    ApplicationArea = All;
    Caption = 'Camera Category';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "FNF Camera Category";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera category code.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera category description.';
                }
            }

            group("Default Rental Rates")
            {
                Caption = 'Default Rental Rates';

                field("Default Daily Rate"; Rec."Default Daily Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default daily rental rate for this category.';
                }

                field("Default Weekly Rate"; Rec."Default Weekly Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default weekly rental rate for this category.';
                }

                field("Default Monthly Rate"; Rec."Default Monthly Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default monthly rental rate for this category.';
                }
            }
        }
    }
}