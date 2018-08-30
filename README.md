# zerobounce-delphi-api-v2
Delphi wrapper class example for the ZeroBounce API v2


```pascal
Function ValidateEmail(emailaddress : string;var status : string) : boolean;
var
stir : string;
url,apiKey : string;

Reader: TJsonTextReader;
procedure CreateReader(Str: string);
    begin
    if Reader <> nil then
        Reader.Free;
    if Sr <> nil then
        Sr.Free;
    Sr := TStringReader.Create(Str);
    Reader := TJsonTextReader.Create(Sr);
    end;

    function UrlEncode(const DecodedStr: String; Pluses: Boolean): String;
        var
        I: Integer;
        begin
        Result := '';
        if Length(DecodedStr) > 0 then
        for I := 1 to Length(DecodedStr) do
        begin
        if not (DecodedStr[I] in ['0'..'9', 'a'..'z',
                                        'A'..'Z', ' ']) then
            Result := Result + '%' + IntToHex(Ord(DecodedStr[I]), 2)
        else if not (DecodedStr[I] = ' ') then
            Result := Result + DecodedStr[I]
        else
            begin
            if not Pluses then
                Result := Result + '%20'
            else
                Result := Result + '+';
            end;
        end;
    end;

    begin
    try
    //2 DLLS are needed for the SSL to run (they need to be in one directory with the EXE)
    //openssl-1.0.2o-i386-win32.zip is the current one
    //Download from https://indy.fulgan.com/SSL/
    apiKey := 'yourZEROBOUNCEapikeyXXXX';

    url :='https://api.zerobounce.net/v2/validate?api_key='+apiKey+'&email='+UrlEncode(emailaddress,false)+'&ip_address=';
    form1.IdHTTP1.ReadTimeout := 15000;
    form1.idhttp1.IOHandler := form1.IdSSLIOHandlerSocketOpenSSL1;
    form1.IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1_2;
    form1.IdSSLIOHandlerSocketOpenSSL1.SSLOptions.SSLVersions := [sslvTLSv1_2];
    stir := form1.IdHTTP1.Get(url);
    CreateReader(stir);
    status := '';
    while Reader.read do
    case Reader.TokenType of
        TJsonToken.string:
        begin
            if reader.path='status' then status := 
    status+reader.value.tostring;
            if reader.path='sub_status' then
            if reader.value.tostring<>'' then status := status+', 
    '+reader.value.tostring;
        end;
    end;
    result := (pos('Unknown',status)=0) and (pos('Invalid',status)=0);
    except
    status := '';
    result := true;
    end;w
end;
```
