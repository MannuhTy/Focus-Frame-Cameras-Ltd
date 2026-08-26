page 51161 "FNF Setup"
{
    ApplicationArea = All;
    Caption = 'Focus & Frame Setup';
    PageType = Card;
    SourceTable = "FNF Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Camera Nos"; Rec."Camera Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used when creating camera equipment.';
                }

                field("Rental Nos"; Rec."Rental Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used when creating rental documents.';
                }

                field("Default Deposit"; Rec."Default Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default deposit amount for a rental.';
                }
            }

            group(Posting)
            {
                Caption = 'Posting';

                field("Rental Income Account"; Rec."Rental Income Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account intended for rental income.';
                }

                field("Damage Charge Account"; Rec."Damage Charge Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account intended for damage charges.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}