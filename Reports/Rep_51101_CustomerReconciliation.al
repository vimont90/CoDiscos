report 51101 "Customer Reconciliation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Customer Reconciliation';
    RDLCLayout = 'Reports/Layout/CustomerReconciliation.rdl';

    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            column(ColumnName1; "Customer No.")
            {

            }
            column(ColumnName2; "Salesperson Code")
            {

            }
            column(ColumnName3; SalesPersonAmount[1])
            {

            }
            column(ColumnName4; SalesPersonAmount[2])
            {

            }
            column(ColumnName5; SalesPersonAmount[3])
            {

            }
            column(ColumnName6; SalesPersonAmount[4])
            {

            }
            column(ColumnName7; SalesPersonAmount[5])
            {

            }
            column(ColumnName8; "Customer Name")
            {

            }
            column(ColumnName9; DocumentData[1])
            {

            }
            column(ColumnName10; CustomerData[1])
            {

            }
            column(ColumnName11; DocumentData[2])
            {

            }
            column(ColumnName12; CustomerData[3])
            {

            }
            column(ColumnName13; "Document No.")
            {

            }
            column(ColumnName14; "Posting Date")
            {

            }
            column(ColumnName15; "Due Date")
            {

            }
            column(ColumnName16; DocumentData[3])
            {

            }
            column(ColumnName17; "Original Amount")
            {

            }
            column(ColumnName18; "Remaining Amount")
            {

            }
            column(ColumnName19; DocumentData[4])
            {

            }

            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                Customer: Record Customer;
            begin
                Clear(DocumentData);
                Clear(SalesPersonAmount);
                Clear(CustomerData);

                if SalesInvoiceHeader.GET("Document No.") then begin
                    DocumentData[1] := SalesInvoiceHeader."Payment Terms Code";
                    DocumentData[2] := FORMAT(SalesInvoiceHeader."Invoice Discount Amount");
                    DocumentData[3] := FORMAT(0);
                    if Today > "Due Date" then
                        DocumentData[3] := FORMAT(Today - "Due Date");
                    DocumentData[4] := SalesInvoiceHeader."Sell-to Address" + SalesInvoiceHeader."Sell-to Address 2";
                    DocumentData[5] := SalesInvoiceHeader."Sell-to City";
                end;
                if Customer.GET("Customer No.") then begin
                    CustomerData[1] := FORMAT(Customer."Credit Limit (LCY)");
                    CustomerData[2] := Customer."Customer Price Group";
                    CustomerData[3] := '';
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(DateFilter; CustLedgerEntry."Date Filter")
                    {
                        ApplicationArea = All;

                    }
                    field(SalesPerson; CustLedgerEntry."Salesperson Code")
                    {
                        ApplicationArea = All;
                    }

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        SalesPersonAmount: array[5] of Decimal;
        DocumentData: array[5] of Text;
        CustomerData: array[4] of Text;
}