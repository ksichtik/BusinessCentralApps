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
                        Handler.Detail(Selected.HitHorizonsId, Rec."No.");
                        Detail.Reset();
                        if Detail.Get(Selected.Id) then begin
                            Rec.HitHorizonsId := Detail.HitHorizonsId;
                            if NOT (Detail.CompanyName = '') then Rec.Name := Truncate(Detail.CompanyName, 100);
                            if NOT (Detail.Country = '') then begin
                                Country.Reset();
                                Country.SetFilter(Name, '@' + Detail.Country);
                                if Country.FindFirst() then begin
                                    Rec."Country/Region Code" := Country.Code;
                                end;
                            end;
                            if NOT (Detail.City = '') then Rec.City := Truncate(Detail.City, 30);
                            if NOT (Detail.PostalCode = '') then Rec."Post Code" := Detail.PostalCode;
                            if NOT (Detail.AddressStreetLine1 = '') then Rec.Address := Truncate(Detail.AddressStreetLine1, 100);
                            if NOT (Detail.Industry = '') then begin
                                Rec.Industry := Handler.GetIndustryName(Detail.Industry);
                            end;
                            if NOT (Detail.SICText = '') then Rec.SICText := Truncate(Detail.SICText, 150);
                            Rec.EstablishmentOfOwnership := Detail.EstablishmentOfOwnership;
                            Rec.SalesEUR := Detail.SalesEUR;
                            Rec.EmployeesNumber := Detail.EmployeesNumber;
                            if NOT (Detail.VatId = '') then rec."VAT Registration No." := Truncate(Detail.VatId, 20);
                            if NOT (Detail.Website = '') then Rec.Website := Truncate(Detail.Website, 150);
                            if NOT (Detail.EmailDomain = '') then Rec.EmailDomain := Truncate(Detail.EmailDomain, 150);
                            Rec.SalesLocal := Detail.SalesLocal;
                            if NOT (Detail.LocalCurrencyName = '') then begin
                                Rec.LocalCurrencyName := Handler.GetLocalCurrencyName(Detail.LocalCurrencyName);
                            end;
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
                    Caption = 'Industry';
                    Editable = false;
                }

                field(SICText; Rec.SICText)
                {
                    ApplicationArea = All;
                    Caption = 'SIC';
                    Editable = false;
                }

                field(SalesEUR; Rec.SalesEUR)
                {
                    ApplicationArea = All;
                    Caption = 'Sales (EUR)';
                    Editable = false;
                }

                field(SalesLocal; Rec.SalesLocal)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + SalesLocalCaption;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        SetSalesLocalCaption();
                    end;


                }

                field(EmployeesNumber; Rec.EmployeesNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Employees';
                    Editable = false;
                }

                field(Website; Rec.Website)
                {
                    ApplicationArea = All;
                    Caption = 'Website';
                    Editable = false;
                }

                field(EmailDomain; Rec.EmailDomain)
                {
                    ApplicationArea = All;
                    Caption = 'Email Domain';
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

    var
        SalesLocalCaption: Text[150];

    trigger OnAfterGetRecord();
    begin
        SetSalesLocalCaption();
    end;

    procedure Truncate(textValue: Text; length: Integer) ReturnValue: Text
    var
    begin
        if StrLen(textValue) > length then textValue := textValue.Substring(1, length);
        ReturnValue := textValue;
    end;

    local procedure SetSalesLocalCaption()
    var
        localName: Text;
    begin
        if Rec.LocalCurrencyName = '' then localName := 'Euro' else localName := Rec.LocalCurrencyName;
        SalesLocalCaption := 'Sales local (' + localName + ')';
    end;
}