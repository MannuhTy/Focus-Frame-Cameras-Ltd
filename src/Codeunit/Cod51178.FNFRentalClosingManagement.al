codeunit 51178 "FNF Rental Closing Management"
{
    // Adds the missing "Returned -> Closed" transition referenced in the
    // system documentation (step 11: "Header Status -> Closed (manual or
    // auto)"), consistent with the rules:
    //   - Deposit refund only after Returned/Cancelled
    //   - A rental is only truly finished once nothing is left to refund
    //     or forfeit (GetAvailableDepositAmount = 0)
    //
    // Ideally CloseRental would live alongside ConfirmRental / ActivateRental
    // / ReturnRental / CancelRental in Codeunit 51160 "FNF Rental Management"
    // to keep the whole state machine in one place. It's kept here as a
    // separate codeunit because this extension doesn't have access to that
    // codeunit's source — feel free to move CloseRental into 51160 directly.

    /// <summary>
    /// Manually closes a Returned rental. Called from a page action, or by
    /// TryAutoCloseRental below once the deposit is fully settled.
    /// </summary>
    procedure CloseRental(var RentalHeader: Record "FNF Rental Header")
    var
        DepositMgt: Codeunit "FNF Deposit Management";
        AvailableDeposit: Decimal;
    begin
        RentalHeader.TestField(Status, RentalHeader.Status::Returned);

        AvailableDeposit := DepositMgt.GetAvailableDepositAmount(RentalHeader."No.");
        if AvailableDeposit <> 0 then
            Error('Rental %1 cannot be closed: %2 of deposit is still outstanding (not yet refunded or forfeited).',
                RentalHeader."No.", AvailableDeposit);

        RentalHeader.Status := RentalHeader.Status::Closed;
        RentalHeader.Modify(true);
    end;

    /// <summary>
    /// Closes the rental only if it's eligible (Returned, deposit fully
    /// settled). Silently does nothing otherwise — safe to call speculatively
    /// from event subscribers after every deposit-ledger or status change.
    /// </summary>
    procedure TryAutoCloseRental(DocumentNo: Code[20])
    var
        RentalHeader: Record "FNF Rental Header";
        DepositMgt: Codeunit "FNF Deposit Management";
    begin
        if not RentalHeader.Get(DocumentNo) then
            exit;

        if RentalHeader.Status <> RentalHeader.Status::Returned then
            exit;

        if DepositMgt.GetAvailableDepositAmount(RentalHeader."No.") <> 0 then
            exit;

        CloseRental(RentalHeader);
    end;

    // Fires after a Refunded or Forfeited deposit ledger entry is posted;
    // auto-closes the rental once nothing is left outstanding. A "Received"
    // entry never brings the outstanding balance to zero, so it's skipped.
    [EventSubscriber(ObjectType::Table, Database::"FNF Rental Deposit Ledger", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDepositLedgerEntry(var Rec: Record "FNF Rental Deposit Ledger"; RunTrigger: Boolean)
    begin
        if Rec."Entry Type" = Rec."Entry Type"::Received then
            exit;

        TryAutoCloseRental(Rec."Document No.");
    end;

    // Fires after a rental header is modified; covers the zero-deposit case
    // where a rental moves straight to Returned with nothing left to settle,
    // so no deposit ledger entry is ever posted to trigger the check above.
    [EventSubscriber(ObjectType::Table, Database::"FNF Rental Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyRentalHeader(var Rec: Record "FNF Rental Header"; var xRec: Record "FNF Rental Header"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if (Rec.Status = Rec.Status::Returned) and (xRec.Status <> Rec.Status::Returned) then
            TryAutoCloseRental(Rec."No.");
    end;
}
