codeunit 50501 APIHandler
{
    trigger OnRun()
    begin

    end;

    procedure Search(Customer: Record Customer)
    var
        Params: Text;
        Client: HttpClient;
        Result: HttpResponseMessage;
        Content: HttpContent;
        Data: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        JResults: JsonToken;
        JResult: JsonToken;
        JResultToken: JsonToken;
        SearchResult: Record CompanySearchResult;
        Index: Integer;
    begin
        Init();
        Client.DefaultRequestHeaders.Add('Ocp-Apim-Subscription-Key', ApiKey);
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        if NOT (Customer.Name = '') then Params += 'CompanyName=' + Customer.Name + '&';
        if NOT (Customer.Address = '') then Params += 'AddressStreet=' + Customer.Address + '&';
        if NOT (Customer.City = '') then Params += 'City=' + Customer.City + '&';
        if NOT (Customer."Post Code" = '') then Params += 'PostalCode=' + Customer."Post Code" + '&';
        if NOT (Params = '') then Params := Params.Substring(1, StrLen(Params) - 1);

        if NOT (Params = '') then begin
            Client.Get('https://api.hithorizons.com/Company/Search?' + Params, Result);
            if Result.IsSuccessStatusCode then begin
                Content := Result.Content;
                Content.ReadAs(Data);
                JObject.ReadFrom(Data);
                if JObject.Get('Success', JToken) and JToken.AsValue().AsBoolean() = true then begin
                    if JObject.Get('Result', JToken) then begin
                        if JToken.AsObject().Get('Results', JResults) then begin

                            SearchResult.Reset();
                            SearchResult.SetFilter(CustomerId, Customer."No.");
                            SearchResult.DeleteAll();

                            Index := 1;
                            foreach JResult in JResults.AsArray() do begin
                                SearchResult.Init();
                                JResult.AsObject().Get('HitHorizonsId', JResultToken);
                                SearchResult.HitHorizonsId := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('CompanyName', JResultToken);
                                SearchResult.CompanyName := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('AddressStreetLine1', JResultToken);
                                SearchResult.AddressStreetLine1 := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('PostalCode', JResultToken);
                                SearchResult.PostalCode := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('City', JResultToken);
                                SearchResult.City := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('Country', JResultToken);
                                SearchResult.Country := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('Industry', JResultToken);
                                SearchResult.Industry := JResultToken.AsValue().AsText();
                                JResult.AsObject().Get('EstablishmentOfOwnership', JResultToken);
                                if CanParseInteger(JResultToken) then SearchResult.EstablishmentOfOwnership := JResultToken.AsValue().AsInteger();
                                JResult.AsObject().Get('SalesEUR', JResultToken);
                                if CanParseDecimal(JResultToken) then SearchResult.SalesEUR := JResultToken.AsValue().AsDecimal();
                                JResult.AsObject().Get('EmployeesNumber', JResultToken);
                                if CanParseInteger(JResultToken) then SearchResult.EmployeesNumber := JResultToken.AsValue().AsInteger();
                                SearchResult.CustomerId := Customer."No.";
                                SearchResult.Id := SearchResult.CustomerId + SearchResult.HitHorizonsId;
                                SearchResult.OrderNumber := Index;
                                SearchResult.Insert();

                                Index := Index + 1;
                            end;

                            Commit();
                        end;
                    end;
                end;
            end else begin
                Message('HitHorizons Search Failed: %1 %2', Result.HttpStatusCode, Result.ReasonPhrase);
            end;
        end;
    end;

    procedure Detail(Customer: Record Customer)
    var
        Params: Text;
        Client: HttpClient;
        Result: HttpResponseMessage;
        Content: HttpContent;
        Data: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        JResult: JsonToken;
        JResultToken: JsonToken;
        SearchResult: Record CompanySearchResult;
    begin
        Init();
        Client.DefaultRequestHeaders.Add('Ocp-Apim-Subscription-Key', ApiKey);
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        if NOT (Customer.HitHorizonsId = '') then Params += 'HitHorizonsId=' + Customer.HitHorizonsId;

        if NOT (Params = '') then begin
            Client.Get('https://api.hithorizons.com/Company/Detail?' + Params, Result);
            if Result.IsSuccessStatusCode then begin
                Content := Result.Content;
                Content.ReadAs(Data);
                JObject.ReadFrom(Data);
                if JObject.Get('Success', JToken) and JToken.AsValue().AsBoolean() = true then begin
                    if JObject.Get('Result', JToken) then begin
                        if JToken.AsObject().Get('VatId', JResult) and (NOT (JResult.AsValue().AsText() = '')) then begin
                            SearchResult.Reset();
                            SearchResult.SetFilter(HitHorizonsId, Customer.HitHorizonsId);
                            IF SearchResult.FindFirst() then begin
                                SearchResult.VatId := JResult.AsValue().AsText();
                                SearchResult.Modify();
                                Commit();
                            end;
                        end;
                    end;
                end;
            end else begin
                Message('HitHorizons Detail Failed: %1 %2', Result.HttpStatusCode, Result.ReasonPhrase);
            end;
        end;
    end;

    procedure GetIndustryName(industryCode: Text) returnValue: Text
    begin
        if industryCode = 'A' then returnValue := 'Agriculture, Forestry, and Fishing';
        if industryCode = 'B' then returnValue := 'Mining';
        if industryCode = 'C' then returnValue := 'Construction';
        if industryCode = 'D' then returnValue := 'Manufacturing';
        if industryCode = 'E' then returnValue := 'Trans., Comm., Electric, Gas, and Sanitary';
        if industryCode = 'F' then returnValue := 'Wholesale Trade';
        if industryCode = 'G' then returnValue := 'Retail Trade';
        if industryCode = 'H' then returnValue := 'Finance, Insurance, and Real Estate';
        if industryCode = 'I' then returnValue := 'Services';
        if industryCode = 'J' then returnValue := 'Public Sector';
        if industryCode = 'Y' then returnValue := 'Unknown industry';
    end;

    [TryFunction]
    procedure CanParseDecimal(Token: JsonToken)
    var
        val: Decimal;
    begin
        val := Token.AsValue().AsDecimal();
    end;

    [TryFunction]
    procedure CanParseInteger(Token: JsonToken)
    var
        val: Integer;
    begin
        val := Token.AsValue().AsInteger();
    end;

    local procedure Init()
    var
        HiHorizonsSettings: Record HitHorizonsSettings;
    begin
        if ApiKey = '' then begin
            HiHorizonsSettings.Reset();
            if HiHorizonsSettings.FindFirst() then begin
                ApiKey := HiHorizonsSettings.ApiKey;
            end;
        end;
    end;

    var
        ApiKey: Text;
}