codeunit 51175 "FNF Deposit Management"
{
    procedure RegisterDepositReceived(
        var RentalHeader: Record "FNF Rental Header";
        Amount: Decimal;
        PostingDate: Date;
        Description: Text[100])
    var
        RemainingToReceive: Decimal;
    begin
        EnsureRentalCanReceiveDeposit(RentalHeader);

        if Amount <= 0 then
            Error('The deposit amount must be greater than zero.');

        RemainingToReceive :=
            RentalHeader."Deposit Amount" -
            GetAmountByEntryType(RentalHeader."No.", Enum::"FNF Deposit Entry Type"::Received);

        if RemainingToReceive <= 0 then
            Error('The full deposit has already been received for rental %1.', RentalHeader."No.");

        if Amount > RemainingToReceive then
            Error(
                'The amount %1 exceeds the remaining deposit amount of %2.',
                Amount,
                RemainingToReceive);

        CreateLedgerEntry(
            RentalHeader,
            Enum::"FNF Deposit Entry Type"::Received,
            Amount,
            ResolvePostingDate(PostingDate),
            Description);

        UpdateDepositIndicators(RentalHeader);
    end;

    procedure RegisterDepositRefunded(
        var RentalHeader: Record "FNF Rental Header";
        Amount: Decimal;
        PostingDate: Date;
        Description: Text[100])
    var
        AvailableDepositAmount: Decimal;
    begin
        EnsureRentalCanRefundDeposit(RentalHeader);

        if Amount <= 0 then
            Error('The refund amount must be greater than zero.');

        AvailableDepositAmount := GetAvailableDepositAmount(RentalHeader."No.");

        if Amount > AvailableDepositAmount then
            Error(
                'The refund amount %1 exceeds the available deposit balance of %2.',
                Amount,
                AvailableDepositAmount);

        CreateLedgerEntry(
            RentalHeader,
            Enum::"FNF Deposit Entry Type"::Refunded,
            Amount,
            ResolvePostingDate(PostingDate),
            Description);

        UpdateDepositIndicators(RentalHeader);
    end;

    procedure RegisterDepositForfeited(
        var RentalHeader: Record "FNF Rental Header";
        Amount: Decimal;
        PostingDate: Date;
        Description: Text[100])
    var
        AvailableDepositAmount: Decimal;
    begin
        if Amount <= 0 then
            Error('The forfeited amount must be greater than zero.');

        AvailableDepositAmount := GetAvailableDepositAmount(RentalHeader."No.");

        if Amount > AvailableDepositAmount then
            Error(
                'The damage charge of %1 exceeds the available deposit balance of %2.',
                Amount,
                AvailableDepositAmount);

        CreateLedgerEntry(
            RentalHeader,
            Enum::"FNF Deposit Entry Type"::Forfeited,
            Amount,
            ResolvePostingDate(PostingDate),
            Description);

        UpdateDepositIndicators(RentalHeader);
    end;

    local procedure EnsureRentalCanReceiveDeposit(
        RentalHeader: Record "FNF Rental Header")
    begin
        RentalHeader.TestField("No.");
        RentalHeader.TestField("Customer No.");

        if RentalHeader."Deposit Amount" <= 0 then
            Error('A deposit amount must be specified before receiving a deposit.');

        if RentalHeader.Status in
            [RentalHeader.Status::Cancelled, RentalHeader.Status::Closed]
        then
            Error(
                'A deposit cannot be received for rental %1 because its status is %2.',
                RentalHeader."No.",
                RentalHeader.Status);
    end;

    local procedure EnsureRentalCanRefundDeposit(
        RentalHeader: Record "FNF Rental Header")
    begin
        RentalHeader.TestField("No.");
        RentalHeader.TestField("Customer No.");

        if not (RentalHeader.Status in
            [RentalHeader.Status::Returned, RentalHeader.Status::Closed, RentalHeader.Status::Cancelled])
        then
            Error(
                'A deposit can only be refunded after the rental is returned or cancelled.');
    end;

    local procedure CreateLedgerEntry(
        RentalHeader: Record "FNF Rental Header";
        EntryType: Enum "FNF Deposit Entry Type";
        Amount: Decimal;
        PostingDate: Date;
        Description: Text[100])
    var
        DepositLedger: Record "FNF Rental Deposit Ledger";
    begin
        DepositLedger.Init();
        DepositLedger."Document No." := RentalHeader."No.";
        DepositLedger."Customer No." := RentalHeader."Customer No.";
        DepositLedger."Entry Type" := EntryType;
        DepositLedger.Amount := Amount;
        DepositLedger."Posting Date" := PostingDate;
        DepositLedger.Description := Description;
        DepositLedger.Insert(true);
    end;

    procedure GetAvailableDepositAmount(DocumentNo: Code[20]): Decimal
    var
        ReceivedAmount: Decimal;
        RefundedAmount: Decimal;
        ForfeitedAmount: Decimal;
    begin
        ReceivedAmount :=
            GetAmountByEntryType(DocumentNo, Enum::"FNF Deposit Entry Type"::Received);

        RefundedAmount :=
            GetAmountByEntryType(DocumentNo, Enum::"FNF Deposit Entry Type"::Refunded);

        ForfeitedAmount :=
            GetAmountByEntryType(DocumentNo, Enum::"FNF Deposit Entry Type"::Forfeited);

        exit(ReceivedAmount - RefundedAmount - ForfeitedAmount);
    end;

    local procedure GetAmountByEntryType(
        DocumentNo: Code[20];
        EntryType: Enum "FNF Deposit Entry Type"): Decimal
    var
        DepositLedger: Record "FNF Rental Deposit Ledger";
    begin
        DepositLedger.SetRange("Document No.", DocumentNo);
        DepositLedger.SetRange("Entry Type", EntryType);
        DepositLedger.CalcSums(Amount);

        exit(DepositLedger.Amount);
    end;

    local procedure UpdateDepositIndicators(
        var RentalHeader: Record "FNF Rental Header")
    var
        ReceivedAmount: Decimal;
        RefundedAmount: Decimal;
    begin
        ReceivedAmount :=
            GetAmountByEntryType(RentalHeader."No.", Enum::"FNF Deposit Entry Type"::Received);

        RefundedAmount :=
            GetAmountByEntryType(RentalHeader."No.", Enum::"FNF Deposit Entry Type"::Refunded);

        RentalHeader."Deposit Received" :=
            ReceivedAmount >= RentalHeader."Deposit Amount";

        RentalHeader."Deposit Refunded" :=
            RefundedAmount >= RentalHeader."Deposit Amount";

        RentalHeader.Modify(true);
    end;

    local procedure ResolvePostingDate(PostingDate: Date): Date
    begin
        if PostingDate = 0D then
            exit(WorkDate());

        exit(PostingDate);
    end;
}