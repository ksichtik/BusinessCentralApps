page 50602 CompanySearchResultPage
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = CompanySearchResult;
    SourceTableView = sorting(OrderNumber) order(ascending);
    Caption = 'HitHorizons Serach Results';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(HitHorizonsId; Rec.HitHorizonsId)
                {
                    ApplicationArea = All;
                }

                field(CompanyName; Rec.CompanyName)
                {
                    ApplicationArea = All;
                }

                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                }

                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }

                field(PostalCode; Rec.PostalCode)
                {
                    ApplicationArea = All;
                }

                field(AddressStreetLine1; Rec.AddressStreetLine1)
                {
                    ApplicationArea = All;
                }

                field(Industry; Rec.Industry)
                {
                    ApplicationArea = All;
                }

                field(EstablishmentOfOwnership; Rec.EstablishmentOfOwnership)
                {
                    ApplicationArea = All;
                }

                field(SalesEUR; Rec.SalesEUR)
                {
                    ApplicationArea = All;
                }

                field(EmployeesNumber; Rec.EmployeesNumber)
                {
                    ApplicationArea = All;
                }

                // field(OrderNumber; Rec.OrderNumber)
                // {
                //     ApplicationArea = All;
                //     HideValue = true;
                // }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}