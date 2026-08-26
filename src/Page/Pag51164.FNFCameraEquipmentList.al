page 51164 "FNF Camera Equipment List"
{
    ApplicationArea = All;
    Caption = 'Camera Equipment';
    PageType = List;
    CardPageId = "FNF Camera Equipment Card";
    SourceTable = "FNF Camera Equipment";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera equipment number.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera equipment description.';
                }

                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category assigned to the camera.';
                }

                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera brand.';
                }

                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera model.';
                }

                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturer serial number.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current availability status.';
                }

                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current physical condition.';
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the camera is blocked from rental.';
                }

                field("Next Maintenance Date"; Rec."Next Maintenance Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the next scheduled maintenance date.';
                }
            }
        }
    }
}