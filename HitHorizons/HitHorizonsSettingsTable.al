table 50301 HitHorizonsSettings
{
    Caption = 'HitHorizons Settings';
    DrillDownPageId = HitHorizonsSettingsList;
    LookupPageId = HitHorizonsSettingsList;

    fields
    {
        field(1; ApiKey; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; ApiKey)
        {
            Clustered = true;
        }
    }
}