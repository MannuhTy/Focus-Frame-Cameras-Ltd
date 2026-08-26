page 51170 "FNF Rental Card"
{
    ApplicationArea = All;
    Caption = 'Rental';
    PageType = Document;
    SourceTable = "FNF Rental Header";

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
                    ToolTip = 'Specifies the rental document number.';
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer renting the equipment.';
                }

                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the rental customer.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current rental status.';
                }

                field("Rental Order Date"; Rec."Rental Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the rental was created.';
                }

                field("Rental Start Date"; Rec."Rental Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first day of the rental.';
                }

                field("Rental End Date"; Rec."Rental End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last day of the rental.';
                }

                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salesperson responsible for this rental.';
                }

                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer or external reference number.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an internal description for the rental.';
                }
            }

            group("Pickup and Return")
            {
                Caption = 'Pickup and Return';

                field("Pickup Location"; Rec."Pickup Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies where the equipment will be collected.';
                }

                field("Return Location"; Rec."Return Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies where the equipment must be returned.';
                }
            }

            part(RentalLines; "FNF Rental Lines Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }

            group(Deposit)
            {
                Caption = 'Deposit';

                field("Deposit Amount"; Rec."Deposit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the required rental deposit.';
                }

                field("Deposit Received"; Rec."Deposit Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the rental deposit has been received.';
                }

                field("Deposit Refunded"; Rec."Deposit Refunded")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the rental deposit has been refunded.';
                }
            }

            group(Totals)
            {
                Caption = 'Totals';

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total amount of all rental lines.';
                }

                field("Posted Invoice No."; Rec."Posted Invoice No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the posted sales invoice created for this rental.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConfirmRental)
            {
                ApplicationArea = All;
                Caption = 'Confirm Rental';
                ToolTip = 'Confirms the rental and creates equipment reservations.';

                trigger OnAction()
                var
                    RentalManagement: Codeunit "FNF Rental Management";
                begin
                    RentalManagement.ConfirmRental(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(ActivateRental)
            {
                ApplicationArea = All;
                Caption = 'Activate Rental';
                ToolTip = 'Marks the rental as active and marks its equipment as rented.';

                trigger OnAction()
                var
                    RentalManagement: Codeunit "FNF Rental Management";
                begin
                    RentalManagement.ActivateRental(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(ReturnRental)
            {
                ApplicationArea = All;
                Caption = 'Return Rental';
                ToolTip = 'Marks the rental as returned and releases its equipment.';

                trigger OnAction()
                var
                    RentalManagement: Codeunit "FNF Rental Management";
                begin
                    RentalManagement.ReturnRental(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(CancelRental)
            {
                ApplicationArea = All;
                Caption = 'Cancel Rental';
                ToolTip = 'Cancels the rental and releases any reservations.';

                trigger OnAction()
                var
                    RentalManagement: Codeunit "FNF Rental Management";
                begin
                    RentalManagement.CancelRental(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(ReceiveDeposit)
            {
                ApplicationArea = All;
                Caption = 'Receive Deposit';
                ToolTip = 'Registers receipt of the full deposit amount for this rental.';

                trigger OnAction()
                var
                    DepositManagement: Codeunit "FNF Deposit Management";
                begin
                    Rec.TestField("Deposit Amount");

                    if not Confirm(
                        StrSubstNo(
                            'Register a deposit receipt of %1 for rental %2?',
                            Rec."Deposit Amount",
                            Rec."No."),
                        false)
                    then
                        exit;

                    DepositManagement.RegisterDepositReceived(
                        Rec,
                        Rec."Deposit Amount",
                        WorkDate(),
                        StrSubstNo('Deposit received for rental %1', Rec."No."));

                    CurrPage.Update(false);
                end;
            }

            action(RefundDeposit)
            {
                ApplicationArea = All;
                Caption = 'Refund Deposit';
                ToolTip = 'Refunds the remaining available deposit balance for this rental.';

                trigger OnAction()
                var
                    DepositManagement: Codeunit "FNF Deposit Management";
                    AvailableDepositAmount: Decimal;
                begin
                    AvailableDepositAmount :=
                        DepositManagement.GetAvailableDepositAmount(Rec."No.");

                    if AvailableDepositAmount <= 0 then
                        Error('There is no available deposit balance to refund.');

                    if not Confirm(
                        StrSubstNo(
                            'Refund the available deposit balance of %1 for rental %2?',
                            AvailableDepositAmount,
                            Rec."No."),
                        false)
                    then
                        exit;

                    DepositManagement.RegisterDepositRefunded(
                        Rec,
                        AvailableDepositAmount,
                        WorkDate(),
                        StrSubstNo('Deposit refunded for rental %1', Rec."No."));

                    CurrPage.Update(false);
                end;
            }
        }
    }
}