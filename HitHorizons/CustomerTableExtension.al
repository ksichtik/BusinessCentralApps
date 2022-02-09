tableextension 50101 "Customer Table Extension" extends Customer
{
    fields
    {
        field(50102; HitHorizonsId; Text[50])
        {
            Caption = 'HitHorizons ID';
            DataClassification = CustomerContent;
        }

        field(50103; EstablishmentOfOwnership; Integer)
        {
            Caption = 'Establishment Of Ownership';
            DataClassification = CustomerContent;
        }

        field(50104; SalesEUR; Decimal)
        {
            Caption = 'Sales (EUR)';
            DataClassification = CustomerContent;
        }

        field(50105; EmployeesNumber; Integer)
        {
            Caption = 'Number of Employees';
            DataClassification = CustomerContent;
        }

        field(50106; Industry; Text[50])
        {
            Caption = 'Industry';
            DataClassification = CustomerContent;
        }

        field(50107; SICText; Text[150])
        {
            Caption = 'SIC';
            DataClassification = CustomerContent;
        }

        field(50108; Website; Text[150])
        {
            Caption = 'Website';
            DataClassification = CustomerContent;
        }

        field(50109; EmailDomain; Text[150])
        {
            Caption = 'Email Domain';
            DataClassification = CustomerContent;
        }

        field(50110; SalesLocal; Decimal)
        {
            Caption = 'Sales (local)';
            DataClassification = CustomerContent;
        }

        field(50111; LocalCurrency; Code[10])
        {
            Caption = 'Local Currency';
            DataClassification = CustomerContent;
        }

        field(50112; LocalCurrencyName; Text[150])
        {
            Caption = 'Local Currency Name';
            DataClassification = CustomerContent;
        }
    }
}