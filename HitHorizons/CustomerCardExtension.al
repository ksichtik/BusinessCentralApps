pageextension 50201 "Customer Card Extension" extends "Customer Card"
{
    //PromotedActionCategories = 'New, Process, Report, New Document, Approve, Request Approval, Prices & Discounts, Navigate, Customer, HitHorizons Search';

    layout
    {
        addafter(Name)
        {
            field(HitHorizonsId; Rec.HitHorizonsId)
            {
                ApplicationArea = All;
                Caption = 'HitHorizons Id';

                trigger OnLookup(var Text: Text): Boolean
                var
                    Handler: Codeunit APIHandler;
                    Selected: Record CompanySearchResult;
                    Detail: Record CompanySearchResult;
                    Country: Record "Country/Region";
                    TmpText: Text;
                begin
                    Handler.Search(Rec);
                    Selected.Reset();
                    Selected.SetFilter(CustomerId, Rec."No.");
                    if Page.RunModal(Page::CompanySearchResultPage, Selected) = Action::LookupOK then begin
                        Handler.Detail(Rec);
                        Rec.HitHorizonsId := Selected.HitHorizonsId;
                        if NOT (Selected.CompanyName = '') then Rec.Name := Truncate(Selected.CompanyName, 100);
                        if NOT (Selected.Country = '') then begin
                            Country.Reset();
                            Country.SetFilter(Name, '@' + Selected.Country);
                            if Country.FindFirst() then begin
                                Rec."Country/Region Code" := Country.Code;
                            end;
                        end;
                        if NOT (Selected.City = '') then Rec.City := Truncate(Selected.City, 30);
                        if NOT (Selected.PostalCode = '') then Rec."Post Code" := Selected.PostalCode;
                        if NOT (Selected.AddressStreetLine1 = '') then Rec.Address := Truncate(Selected.AddressStreetLine1, 100);
                        if NOT (Selected.Industry = '') then begin
                            Rec.Industry := Handler.GetIndustryName(Selected.Industry);
                        end;
                        Rec.EstablishmentOfOwnership := Selected.EstablishmentOfOwnership;
                        Rec.SalesEUR := Selected.SalesEUR;
                        Rec.EmployeesNumber := Selected.EmployeesNumber;

                        Detail.Reset();
                        Detail.SetFilter(HitHorizonsId, Selected.HitHorizonsId);
                        if Detail.FindFirst() then begin
                            if NOT (Detail.VatId = '') then rec."VAT Registration No." := Truncate(Detail.VatId, 20);
                        end;
                    end;
                end;
            }
        }

        addafter("Address & Contact")
        {
            group("HitHorizons")
            {
                field(EstablishmentOfOwnership; Rec.EstablishmentOfOwnership)
                {
                    ApplicationArea = All;
                    Caption = 'Establishment Of Ownership';
                    Editable = false;
                }

                field(Industry; Rec.Industry)
                {
                    ApplicationArea = All;
                    Caption = 'Establishment Of Ownership';
                    Editable = false;
                }

                field(SalesEUR; Rec.SalesEUR)
                {
                    ApplicationArea = All;
                    Caption = 'Sales (EUR)';
                    Editable = false;
                }

                field(EmployeesNumber; Rec.EmployeesNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Employees';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addfirst(navigation)
        {
            // action(HitHorizonsSearch)
            // {
            //     Caption = 'HitHorizons Search';
            //     Tooltip = 'Link Customer with HitHorizons database';
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Category10;

            //     trigger OnAction();
            //     var
            //         Handler: Codeunit APIHandler;
            //         Selected: Record CompanySearchResult;
            //     begin
            //         Handler.Search(Rec);
            //         //Page.Run(Page::CompanySearchResultPage, Selected);
            //         Selected.Reset();
            //         Selected.SetFilter(CustomerId, Rec."No.");
            //         Report.RunModal(Report::CompanySearchResultReport, false, false, Selected);
            //     end;
            // }
        }
    }

    trigger OnAfterGetRecord();
    begin
    end;

    procedure Truncate(textValue: Text; length: Integer) ReturnValue: Text
    var
    begin
        if StrLen(textValue) > length then textValue := textValue.Substring(1, length);
        ReturnValue := textValue;
    end;
}