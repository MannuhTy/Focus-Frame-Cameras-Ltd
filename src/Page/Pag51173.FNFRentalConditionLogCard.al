page 51173 "FNF Rental Condition Log Card"
{
    ApplicationArea = All;
    Caption = 'Rental Condition Log';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "FNF Rental Condition Log";

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
                    ToolTip = 'Specifies the unique condition-log entry number.';
                }

                field("Log Date"; Rec."Log Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the inspection was recorded.';
                }

                field("Logged By"; Rec."Logged By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user who recorded this condition log.';
                }
            }

            group("Rental Details")
            {
                Caption = 'Rental Details';

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental document related to this inspection.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental line related to this inspection.';
                }

                field("Camera No."; Rec."Camera No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera being inspected.';
                }
            }

            group("Condition Assessment")
            {
                Caption = 'Condition Assessment';

                field("Condition Before"; Rec."Condition Before")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera condition before the rental or inspection.';
                }

                field("Condition After"; Rec."Condition After")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera condition after the rental or inspection.';
                }

                field("Damage Charge Amount"; Rec."Damage Charge Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any charge raised for camera damage.';
                }

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies notes about the inspection, damage, or required maintenance.';
                }
            }

            group(PhotoEvidence)
            {
                Caption = 'Photo Evidence';

                field(Photo; Rec.Photo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies photo evidence of the equipment condition or damage.';
                }
            }
        }
    }
}