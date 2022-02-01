table 50601 CompanySearchResult
{
    Caption = 'Company Search Results';
    DataClassification = CustomerContent;
    TableType = Normal;

    fields
    {
        field(1; HitHorizonsId; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(2; CompanyName; Text[150])
        {
            DataClassification = CustomerContent;
        }

        field(3; AddressStreetLine1; Text[150])
        {
            DataClassification = CustomerContent;
        }

        field(4; PostalCode; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(5; City; Text[150])
        {
            DataClassification = CustomerContent;
        }

        field(6; Country; Text[150])
        {
            DataClassification = CustomerContent;
        }

        field(7; Industry; Text[150])
        {
            DataClassification = CustomerContent;
        }

        field(8; EstablishmentOfOwnership; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(9; SalesEUR; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(10; EmployeesNumber; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(11; CustomerId; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(12; Id; Code[70])
        {
            DataClassification = CustomerContent;
        }

        field(13; VatId; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(14; OrderNumber; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }

        key(Key2; CustomerId)
        {

        }

        key(Key3; OrderNumber)
        {

        }
    }

    trigger OnInsert()
    begin

    end;
}