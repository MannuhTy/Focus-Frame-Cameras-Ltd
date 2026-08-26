page 51162 "FNF Camera Category List"
{
    PageType = List;
    CardPageId = "FNF Camera Category Card";
    ApplicationArea = All;
    DelayedInsert = true;
    UsageCategory = Lists;
    Caption = 'Camera Categories';
    SourceTable = "FNF Camera Category";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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

                field("Default Daily Rate"; Rec."Default Daily Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default daily rental rate.';
                }

                field("Default Weekly Rate"; Rec."Default Weekly Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default weekly rental rate.';
                }

                field("Default Monthly Rate"; Rec."Default Monthly Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default monthly rental rate.';
                }
            }
        }
    }
}

