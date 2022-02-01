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
    }
}