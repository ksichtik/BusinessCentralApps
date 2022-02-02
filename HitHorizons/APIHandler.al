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
                                Commit();

                                Index := Index + 1;
                            end;
                        end;
                    end;
                end;
            end else begin
                Message('HitHorizons Search Failed: %1 %2', Result.HttpStatusCode, Result.ReasonPhrase);
            end;
        end;
    end;

    procedure Detail(HitHorizonsId: Text; CustomerNo: Code[20])
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
        New: Boolean;
    begin
        Init();
        Client.DefaultRequestHeaders.Add('Ocp-Apim-Subscription-Key', ApiKey);
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        if NOT (HitHorizonsId = '') then Params += 'HitHorizonsId=' + HitHorizonsId;

        if NOT (Params = '') then begin
            Client.Get('https://api.hithorizons.com/Company/Detail?' + Params, Result);
            if Result.IsSuccessStatusCode then begin
                Content := Result.Content;
                Content.ReadAs(Data);
                JObject.ReadFrom(Data);
                if JObject.Get('Success', JToken) and JToken.AsValue().AsBoolean() = true then begin
                    if JObject.Get('Result', JResult) then begin
                        SearchResult.Reset();
                        SearchResult.SetFilter(HitHorizonsId, HitHorizonsId);
                        IF NOT SearchResult.FindFirst() then begin
                            SearchResult.Init();
                            New := true;
                        end else begin
                            New := false;
                        end;

                        JResult.AsObject().Get('HitHorizonsId', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.HitHorizonsId := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('CompanyName', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.CompanyName := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('AddressStreetLine1', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.AddressStreetLine1 := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('PostalCode', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.PostalCode := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('City', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.City := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('Country', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.Country := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('Industry', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.Industry := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('EstablishmentOfOwnership', JResultToken);
                        if CanParseInteger(JResultToken) then SearchResult.EstablishmentOfOwnership := JResultToken.AsValue().AsInteger();
                        JResult.AsObject().Get('SalesEUR', JResultToken);
                        if CanParseDecimal(JResultToken) then SearchResult.SalesEUR := JResultToken.AsValue().AsDecimal();
                        JResult.AsObject().Get('EmployeesNumber', JResultToken);
                        if CanParseInteger(JResultToken) then SearchResult.EmployeesNumber := JResultToken.AsValue().AsInteger();
                        SearchResult.CustomerId := CustomerNo;
                        SearchResult.Id := SearchResult.CustomerId + SearchResult.HitHorizonsId;

                        JResult.AsObject().Get('VatId', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.VatId := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('SICText', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.SICText := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('Website', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.Website := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('EmailDomain', JResultToken);
                        if CanParseText(JResultToken) then SearchResult.EmailDomain := JResultToken.AsValue().AsText();
                        JResult.AsObject().Get('SalesLocal', JResultToken);
                        if CanParseDecimal(JResultToken) then SearchResult.SalesLocal := JResultToken.AsValue().AsDecimal();
                        JResult.AsObject().Get('LocalCurrency', JResultToken);
                        if CanParseCode(JResultToken) then SearchResult.LocalCurrency := JResultToken.AsValue().AsCode();
                        if CanParseText(JResultToken) then SearchResult.LocalCurrencyName := JResultToken.AsValue().AsText();

                        if New then SearchResult.Insert() else SearchResult.Modify();
                        Commit();
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

    procedure GetLocalCurrencyName(currencyCode: Text) returnValue: Text
    begin
        if currencyCode = '0410' then returnValue := 'Afghani';
        if currencyCode = '7600' then returnValue := 'Albanian Lek';
        if currencyCode = '0420' then returnValue := 'Algerian Dinar';
        if currencyCode = '5090' then returnValue := 'Angolan Kwanza';
        if currencyCode = '0030' then returnValue := 'Argentine Peso';
        if currencyCode = '8500' then returnValue := 'Armenian Dram';
        if currencyCode = '0040' then returnValue := 'Aruban Florin';
        if currencyCode = '0050' then returnValue := 'Australian Dollar';
        if currencyCode = '0060' then returnValue := 'Austrian Schilling';
        if currencyCode = '8600' then returnValue := 'Azerbaijanian Manat - Old';
        if currencyCode = '9460' then returnValue := 'Azerbaijanian Manat - New';
        if currencyCode = '0450' then returnValue := 'Bahamian Dollar';
        if currencyCode = '0440' then returnValue := 'Bahraini Dinar';
        if currencyCode = '0430' then returnValue := 'Bangladeshi Taka';
        if currencyCode = '0070' then returnValue := 'Barbados Dollar';
        if currencyCode = '8100' then returnValue := 'Belarus Ruble';
        if currencyCode = '0080' then returnValue := 'Belgian Franc';
        if currencyCode = '0460' then returnValue := 'Belize Dollar';
        if currencyCode = '0090' then returnValue := 'Bermudian Dollar';
        if currencyCode = '6100' then returnValue := 'Bhutan Ngultrum';
        if currencyCode = '0470' then returnValue := 'Bolivian Boliviano';
        if currencyCode = '0475' then returnValue := 'Bosnia-Herzegovina Dinar - Old';
        if currencyCode = '0105' then returnValue := 'Bosnia-Herzegovina Convertible Mark';
        if currencyCode = '0480' then returnValue := 'Botswani Pula';
        if currencyCode = '0100' then returnValue := 'Brazilian Cruzeiro (old)';
        if currencyCode = '9300' then returnValue := 'Brazilian Real';
        if currencyCode = '0490' then returnValue := 'Brunei Dollar';
        if currencyCode = '0500' then returnValue := 'Bulgarian Lev';
        if currencyCode = '0520' then returnValue := 'Burundi Franc';
        if currencyCode = '6300' then returnValue := 'Cambodian Riel';
        if currencyCode = '0010' then returnValue := 'Canadian Dollar';
        if currencyCode = '0530' then returnValue := 'Cape Verde Escudo';
        if currencyCode = '0540' then returnValue := 'Cayman Islands Dollar';
        if currencyCode = '0560' then returnValue := 'Chilean Peso';
        if currencyCode = '0110' then returnValue := 'Chinese Yuan Renminbi';
        if currencyCode = '0580' then returnValue := 'Colombian Peso';
        if currencyCode = '0585' then returnValue := 'Comoro Franc';
        if currencyCode = '6030' then returnValue := 'Congolese Franc';
        if currencyCode = '0590' then returnValue := 'Costa Rican Colon';
        if currencyCode = '0595' then returnValue := 'Croatian Dinar - Old';
        if currencyCode = '6800' then returnValue := 'Croatian Kuna';
        if currencyCode = '0605' then returnValue := 'Cuban Peso Convertible';
        if currencyCode = '0600' then returnValue := 'Cuban Peso';
        if currencyCode = '0610' then returnValue := 'Cypriot Pound';
        if currencyCode = '0620' then returnValue := 'Czech Koruna';
        if currencyCode = '0120' then returnValue := 'Danish Krone';
        if currencyCode = '0630' then returnValue := 'Djibouti Franc';
        if currencyCode = '0640' then returnValue := 'Dominican Peso';
        if currencyCode = '6010' then returnValue := 'Ostmark - Former GDR Mark';
        if currencyCode = '9420' then returnValue := 'Timoran Escuda - Old';
        if currencyCode = '0660' then returnValue := 'Ecuador Sucre - Old';
        if currencyCode = '0150' then returnValue := 'Egyptian Pound';
        if currencyCode = '0670' then returnValue := 'El Salvador Colon';
        if currencyCode = '0680' then returnValue := 'Equatorial Guinean Ekule Old';
        if currencyCode = '0155' then returnValue := 'Eritrean Nakfa';
        if currencyCode = '8000' then returnValue := 'Estonian Kroon';
        if currencyCode = '0690' then returnValue := 'Ethiopian Birr';
        if currencyCode = '5080' then returnValue := 'Euro';
        if currencyCode = '6900' then returnValue := 'Falkland Islands Pound';
        if currencyCode = '0700' then returnValue := 'Fiji Dollar';
        if currencyCode = '0170' then returnValue := 'Finnish Markka';
        if currencyCode = '0180' then returnValue := 'French Franc';
        if currencyCode = '7000' then returnValue := 'French Guiana Franc';
        if currencyCode = '0710' then returnValue := 'Dalasi';
        if currencyCode = '6050' then returnValue := 'Lari';
        if currencyCode = '0200' then returnValue := 'German Mark';
        if currencyCode = '0720' then returnValue := 'Ghana Cedi';
        if currencyCode = '0730' then returnValue := 'Gibraltar Pound';
        if currencyCode = '0210' then returnValue := 'Greek Drachma';
        if currencyCode = '7100' then returnValue := 'Guadeloupe Franc';
        if currencyCode = '6200' then returnValue := 'Quetzal';
        if currencyCode = '0750' then returnValue := 'Guinea Franc';
        if currencyCode = '0740' then returnValue := 'Guinea Bisseau Peso';
        if currencyCode = '0760' then returnValue := 'Guyana Dollar';
        if currencyCode = '0770' then returnValue := 'Gourde';
        if currencyCode = '0780' then returnValue := 'Lempira';
        if currencyCode = '0220' then returnValue := 'Hong Kong Dollar';
        if currencyCode = '0790' then returnValue := 'Forint';
        if currencyCode = '0800' then returnValue := 'Icelandic Krona';
        if currencyCode = '0230' then returnValue := 'Indian Rupee';
        if currencyCode = '0820' then returnValue := 'Rupiah';
        if currencyCode = '0840' then returnValue := 'Iranian Rial';
        if currencyCode = '0830' then returnValue := 'Iraqi Dinar';
        if currencyCode = '0240' then returnValue := 'Irish Punt';
        if currencyCode = '0850' then returnValue := 'Irish Pound';
        if currencyCode = '0250' then returnValue := 'Israeli Sheqel - New';
        if currencyCode = '0260' then returnValue := 'Italian Lira';
        if currencyCode = '0270' then returnValue := 'Jamaican Dollar';
        if currencyCode = '0280' then returnValue := 'Yen';
        if currencyCode = '0860' then returnValue := 'Jordanian Dinar';
        if currencyCode = '8700' then returnValue := 'Tenge';
        if currencyCode = '0290' then returnValue := 'Kenyan Shilling';
        if currencyCode = '6400' then returnValue := 'North Korean Won';
        if currencyCode = '3040' then returnValue := 'Won';
        if currencyCode = '0870' then returnValue := 'Kuwaiti Dinar';
        if currencyCode = '8900' then returnValue := 'Som';
        if currencyCode = '0880' then returnValue := 'Kip';
        if currencyCode = '7800' then returnValue := 'Latvian Lats';
        if currencyCode = '0890' then returnValue := 'Lebanese Pound';
        if currencyCode = '0900' then returnValue := 'Loti';
        if currencyCode = '0910' then returnValue := 'Liberian Dollar';
        if currencyCode = '0920' then returnValue := 'Libyan Dinar';
        if currencyCode = '7900' then returnValue := 'Lithuanian Litas';
        if currencyCode = '0930' then returnValue := 'Luxembourg Franc';
        if currencyCode = '7200' then returnValue := 'Pataca';
        if currencyCode = '0095' then returnValue := 'Denar';
        if currencyCode = '0940' then returnValue := 'Malagasy Ariary';
        if currencyCode = '0960' then returnValue := 'Kwacha';
        if currencyCode = '0970' then returnValue := 'Malaysian Ringgit';
        if currencyCode = '6500' then returnValue := 'Rufiyaa';
        if currencyCode = '0980' then returnValue := 'Mali Franc - Old';
        if currencyCode = '0990' then returnValue := 'Maltese Lira';
        if currencyCode = '7400' then returnValue := 'Martinique Franc';
        if currencyCode = '1000' then returnValue := 'Ouguiya';
        if currencyCode = '1010' then returnValue := 'Mauritius Rupee';
        if currencyCode = '7500' then returnValue := 'Mexican Peso New';
        if currencyCode = '0300' then returnValue := 'Mexican Peso Old';
        if currencyCode = '8300' then returnValue := 'Moldovan Leu';
        if currencyCode = '0305' then returnValue := 'Mongolian Tugrik';
        if currencyCode = '0310' then returnValue := 'Moroccan Dirham';
        if currencyCode = '1020' then returnValue := 'Mozambique Metical';
        if currencyCode = '9430' then returnValue := 'Kyat';
        if currencyCode = '9470' then returnValue := 'Namibia Dollar';
        if currencyCode = '0085' then returnValue := 'Rand';
        if currencyCode = '1030' then returnValue := 'Nepalese Rupee';
        if currencyCode = '0650' then returnValue := 'Netherlands Antillean Guilder';
        if currencyCode = '0130' then returnValue := 'Dutch Guilder';
        if currencyCode = '0320' then returnValue := 'New Zealand Dollar';
        if currencyCode = '1040' then returnValue := 'Cordoba Oro';
        if currencyCode = '6600' then returnValue := 'Naira';
        if currencyCode = '0330' then returnValue := 'Norwegian Krone';
        if currencyCode = '1060' then returnValue := 'Rial Omani';
        if currencyCode = '1070' then returnValue := 'Pakistan Rupee';
        if currencyCode = '1080' then returnValue := 'Balboa';
        if currencyCode = '1090' then returnValue := 'Kina';
        if currencyCode = '2000' then returnValue := 'Guarani';
        if currencyCode = '2010' then returnValue := 'Neuvo Sol';
        if currencyCode = '2020' then returnValue := 'Philippine Peso';
        if currencyCode = '9410' then returnValue := 'Polish New Zloty';
        if currencyCode = '2030' then returnValue := 'Zloty - Old';
        if currencyCode = '0340' then returnValue := 'Portuguese Escudo';
        if currencyCode = '0950' then returnValue := 'Madeiran Escudo';
        if currencyCode = '2040' then returnValue := 'Qatari Riyal';
        if currencyCode = '2050' then returnValue := 'Romanian Leu - Old';
        if currencyCode = '9450' then returnValue := 'Romanian Leu - New';
        if currencyCode = '9100' then returnValue := 'Russian Ruble';
        if currencyCode = '3050' then returnValue := 'Soviet Rouble - Old';
        if currencyCode = '2060' then returnValue := 'Rwanda Franc';
        if currencyCode = '5030' then returnValue := 'Tala';
        if currencyCode = '2070' then returnValue := 'Dobra';
        if currencyCode = '2080' then returnValue := 'Saudi Riyal';
        if currencyCode = '0350' then returnValue := 'Scottish Pound';
        if currencyCode = '5040' then returnValue := 'Serbian Dinar';
        if currencyCode = '5050' then returnValue := 'Yugoslavian Dinar - Old';
        if currencyCode = '2090' then returnValue := 'Seychelles Rupee';
        if currencyCode = '6000' then returnValue := 'Leone';
        if currencyCode = '3000' then returnValue := 'Singapore Dollar';
        if currencyCode = '9400' then returnValue := 'Slovak Kruna';
        if currencyCode = '7700' then returnValue := 'Slovenian Tolar';
        if currencyCode = '3010' then returnValue := 'Solomon Islands Dollar';
        if currencyCode = '3020' then returnValue := 'Somali Shilling';
        if currencyCode = '3030' then returnValue := 'Rand';
        if currencyCode = '3075' then returnValue := 'South Sudanese Pound';
        if currencyCode = '6020' then returnValue := 'Yemenese Dinar - Old';
        if currencyCode = '0360' then returnValue := 'Spanish Peseta';
        if currencyCode = '3060' then returnValue := 'Sri Lanka Rupee';
        if currencyCode = '0075' then returnValue := 'St Helena Pound';
        if currencyCode = '3065' then returnValue := 'Sudanese Dinar - Old';
        if currencyCode = '3070' then returnValue := 'Sudanese Pound';
        if currencyCode = '3085' then returnValue := 'Surinam Dollar';
        if currencyCode = '3080' then returnValue := 'Surinam Guilder - Old';
        if currencyCode = '3090' then returnValue := 'Lilangeni';
        if currencyCode = '0370' then returnValue := 'Swedish Krona';
        if currencyCode = '0380' then returnValue := 'Swiss Franc';
        if currencyCode = '4000' then returnValue := 'Syrian Pound';
        if currencyCode = '0390' then returnValue := 'New Taiwanese Dollar';
        if currencyCode = '9200' then returnValue := 'Somoni';
        if currencyCode = '4010' then returnValue := 'Tanzanian Shilling';
        if currencyCode = '0400' then returnValue := 'Baht';
        if currencyCode = '4020' then returnValue := 'Pa`anga';
        if currencyCode = '4030' then returnValue := 'Trinidad & Tobago Dollar';
        if currencyCode = '4040' then returnValue := 'Tunisian Dinar';
        if currencyCode = '4050' then returnValue := 'Turkish Lira-old';
        if currencyCode = '9440' then returnValue := 'Turkish Lira- New ';
        if currencyCode = '8800' then returnValue := 'Turkmenistan Manat';
        if currencyCode = '4070' then returnValue := 'Uganda Shilling';
        if currencyCode = '6060' then returnValue := 'Hryvnia';
        if currencyCode = '8200' then returnValue := 'Ukranian Karbovanet - Old';
        if currencyCode = '4060' then returnValue := 'UAE Dirham';
        if currencyCode = '0160' then returnValue := 'Pound Sterling';
        if currencyCode = '0020' then returnValue := 'U.S. Dollar';
        if currencyCode = '4080' then returnValue := 'Uruguay Peso - Old';
        if currencyCode = '6040' then returnValue := 'Peso Uruguayo';
        if currencyCode = '0140' then returnValue := 'Eastern Caribbean Dollar';
        if currencyCode = '0550' then returnValue := 'CFA Franc BCEAO';
        if currencyCode = '0552' then returnValue := 'CFA Franc BEAC (Franc de la CommunautÚ financiÞre africaine)';
        if currencyCode = '0190' then returnValue := 'CFP Franc';
        if currencyCode = '9000' then returnValue := 'Uzbekistan Sum';
        if currencyCode = '4090' then returnValue := 'Vatu';
        if currencyCode = '5000' then returnValue := 'Bolivar - Old';
        if currencyCode = '5005' then returnValue := 'Bolivar Fuerte';
        if currencyCode = '5010' then returnValue := 'Dong';
        if currencyCode = '5020' then returnValue := 'Yemenese Rial';
        if currencyCode = '5060' then returnValue := 'Zambian Kwacha';
        if currencyCode = '5070' then returnValue := 'Zimbabwe Dollar';
        if currencyCode = '8101' then returnValue := 'Belarusian Ruble';
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

    [TryFunction]
    procedure CanParseText(Token: JsonToken)
    var
        val: Text;
    begin
        val := Token.AsValue().AsText();
    end;

    [TryFunction]
    procedure CanParseCode(Token: JsonToken)
    var
        val: Code[10];
    begin
        val := Token.AsValue().AsCode();
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