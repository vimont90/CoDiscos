report 51100 "Portfolio by Seller"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Portfolio by Seller';
    RDLCLayout = 'Reports/Layout/PortFolioBySeller.rdl';
    Permissions = tabledata 21 = rm;

    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            column(CustomerNo; "Customer No.")
            {

            }
            column(SalespersonCode; "Salesperson Code")
            {

            }
            column(SalesPersonAmount1; SalesPersonAmount[1])
            {

            }
            column(SalesPersonAmount2; SalesPersonAmount[2])
            {

            }
            column(SalesPersonAmount3; SalesPersonAmount[3])
            {

            }
            column(SalesPersonAmount4; SalesPersonAmount[4])
            {

            }
            column(SalesPersonAmount5; SalesPersonAmount[5])
            {

            }
            column(CustomerName; "Customer Name")
            {

            }
            column(DocumentData1; DocumentData[1])
            {

            }
            column(CustomerData1; CustomerData[1])
            {

            }
            column(DocumentData2; DocumentData[2])
            {

            }
            column(CustomerData3; CustomerData[3])
            {

            }
            column(DocumentNo; "Document No.")
            {

            }
            column(PostingDate; "Posting Date")
            {

            }
            column(DueDate; "Due Date")
            {

            }
            column(DocumentData3; DocumentData[3])
            {

            }
            column(OriginalAmount; "Original Amount")
            {

            }
            column(RemainingAmount; "Remaining Amount")
            {

            }
            column(DocumentData4; DocumentData[4])
            {

            }

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Salesperson Code", "Posting Date");
                if SalesPerson <> '' then
                    SetRange("Salesperson Code", SalesPerson);
                SetRange("Posting Date", StarDate, EndDate);
            end;

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

                GetTotalsSalesPerson("Salesperson Code", StarDate, EndDate, SalesPersonAmount);
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
                    field(StarDate; StarDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Star Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(SalesPerson; SalesPerson)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Person Code';
                        TableRelation = "Salesperson/Purchaser";
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

    local procedure GetTotalsSalesPerson(_SalesPerson: Code[20]; _StarDate: Date; _EndDate: Date; VAR _SalesPersonAmount: Array[5] of decimal)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        Clear(_SalesPersonAmount);

        with CustLedgerEntry do begin
            Reset();
            SetCurrentKey("Salesperson Code", "Posting Date");
            SetRange("Salesperson Code", _SalesPerson);
            SetRange("Posting Date", _StarDate, _EndDate);
            if FindSet() then begin
                CalcFields("Remaining Amount");
                //CalcSums("Remaining Amount");

                repeat
                    if "Due Date" >= WorkDate() then
                        SalesPersonAmount[2] += "Remaining Amount"
                    else
                        SalesPersonAmount[3] += "Remaining Amount";
                until Next() = 0;
                SalesPersonAmount[1] := SalesPersonAmount[2] + SalesPersonAmount[3];
                if (SalesPersonAmount[1] <> 0) then begin
                    SalesPersonAmount[4] := (SalesPersonAmount[2] / SalesPersonAmount[1]) * 100;
                    SalesPersonAmount[5] := 100 - SalesPersonAmount[4];
                end;
            end;
        end;
    end;

    var
        SalesPersonAmount: array[5] of Decimal;
        DocumentData: array[5] of Text;
        CustomerData: array[4] of Text;
        SalesPerson: Code[20];
        StarDate: Date;
        EndDate: Date;
}