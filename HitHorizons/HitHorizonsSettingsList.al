page 50401 HitHorizonsSettingsList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = HitHorizonsSettings;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ApiKey; rec.ApiKey)
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
            }
        }
    }
}