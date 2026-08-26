page 51172 "FNF Rental Condition Logs"
{
    ApplicationArea = All;
    Caption = 'Rental Condition Logs';
    DelayedInsert = true;
    PageType = List;
    CardPageId = "FNF Rental Condition Log Card";
    SourceTable = "FNF Rental Condition Log";
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
                    Editable = false;
                    ToolTip = 'Specifies the unique condition-log entry number.';
                }

                field("Log Date"; Rec."Log Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the inspection was recorded.';
                }

                field("Camera No."; Rec."Camera No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera that was inspected.';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related rental document.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related rental line.';
                }

                field("Condition Before"; Rec."Condition Before")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera condition before inspection or return.';
                }

                field("Condition After"; Rec."Condition After")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the camera condition after inspection or return.';
                }

                field("Damage Charge Amount"; Rec."Damage Charge Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the charge resulting from equipment damage.';
                }

                field("Logged By"; Rec."Logged By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user who recorded the condition log.';
                }

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies notes about the camera condition or damage.';
                }
            }
        }
    }
}