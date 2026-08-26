page 51171 "FNF Rental Reservations"
{
    ApplicationArea = All;
    Caption = 'Rental Reservations';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FNF Rental Reservation";
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
                    ToolTip = 'Specifies the unique reservation entry number.';
                }

                field("Camera No."; Rec."Camera No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reserved camera.';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental document that owns this reservation.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental line that owns this reservation.';
                }

                field("Reservation Start Date"; Rec."Reservation Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the reservation starts.';
                }

                field("Reservation End Date"; Rec."Reservation End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the reservation ends.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the reservation is reserved, active, or released.';
                }
            }
        }
    }
}