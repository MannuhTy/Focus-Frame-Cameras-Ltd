page 51165 "FNF Camera Equipment Card"
{
    ApplicationArea = All;
    Caption = 'Camera Equipment Card';
    PageType = Card;
    SourceTable = "FNF Camera Equipment";

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
            }

            group("Rental Status")
            {
                Caption = 'Rental Status';

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current rental status. It is updated by the rental workflow.';
                }

                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current physical condition of the camera.';
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the camera is blocked from rental.';
                }
            }

            group("Asset Details")
            {
                Caption = 'Asset Details';

                field("Replacement Value"; Rec."Replacement Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the replacement value of the camera.';
                }

                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase date of the camera.';
                }

                field("Fixed Asset No."; Rec."Fixed Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the linked fixed-asset record.';
                }
            }

            group(Maintenance)
            {
                Caption = 'Maintenance';

                field("Last Maintenance Date"; Rec."Last Maintenance Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the camera was last maintained.';
                }

                field("Next Maintenance Date"; Rec."Next Maintenance Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the camera is next due for maintenance.';
                }
            }

            group(Picture)
            {
                Caption = 'Picture';

                field(Image; Rec.Image)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an image of the camera equipment.';
                }
            }

            group(Numbering)
            {
                Caption = 'Numbering';

                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number series that created this camera number.';
                }
            }
        }
    }
}