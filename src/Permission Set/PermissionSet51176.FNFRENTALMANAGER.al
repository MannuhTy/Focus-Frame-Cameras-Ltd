permissionset 51176 "FNF RENTAL MANAGER"
{
    Assignable = true;

    Permissions =
        tabledata "FNF Setup" = RIMD,
        tabledata "FNF Camera Category" = RIMD,
        tabledata "FNF Camera Equipment" = RIMD,
        tabledata "FNF Rental Rate" = RIMD,
        tabledata "FNF Rental Header" = RIMD,
        tabledata "FNF Rental Line" = RIMD,
        tabledata "FNF Rental Reservation" = RIMD,
        tabledata "FNF Rental Condition Log" = RIMD,
        tabledata "FNF Rental Deposit Ledger" = RIMD,

        tabledata Customer = R,
        tabledata "No. Series" = R,
        tabledata "G/L Account" = R,
        tabledata "Fixed Asset" = R,
        tabledata "Sales Invoice Header" = R,
        tabledata "Salesperson/Purchaser" = R,
        tabledata User = R,

        page "FNF Setup" = X,
        page "FNF Camera Category List" = X,
        page "FNF Camera Category Card" = X,
        page "FNF Camera Equipment List" = X,
        page "FNF Camera Equipment Card" = X,
        page "FNF Rental Rates" = X,
        page "FNF Rental Rate Card" = X,
        page "FNF Rental List" = X,
        page "FNF Rental Card" = X,
        page "FNF Rental Lines Subform" = X,
        page "FNF Rental Reservations" = X,
        page "FNF Rental Condition Logs" = X,
        page "FNF Rental Condition Log Card" = X,
        page "FNF Deposit Ledger Entries" = X,

        codeunit "FNF Rental Management" = X,
        codeunit "FNF Deposit Management" = X;
}