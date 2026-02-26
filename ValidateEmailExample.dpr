program ValidateEmailExample;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.JSON,
  IdHTTP,
  IdSSLOpenSSL;

var
  ApiKey: string;
  EmailToValidate: string;
  Status: string;

function UrlEncode(const DecodedStr: string; Pluses: Boolean): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(DecodedStr) do
  begin
    C := DecodedStr[I];
    if CharInSet(C, ['0'..'9', 'a'..'z', 'A'..'Z']) then
      Result := Result + C
    else if C = ' ' then
      Result := Result + IfThen(Pluses, '+', '%20')
    else
      Result := Result + '%' + IntToHex(Ord(C), 2);
  end;
end;

function ValidateEmail(const ApiKey, EmailAddress: string; var Status: string): Boolean;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Url, ResponseBody: string;
  JsonResponse: TJsonObject;
  StatusVal, SubStatusVal: TJSONValue;
begin
  Result := False;
  Status := '';
  HTTP := nil;
  SSLHandler := nil;
  JsonResponse := nil;
  try
    SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    SSLHandler.SSLOptions.Method := sslvTLSv1_2;
    SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];

    HTTP := TIdHTTP.Create(nil);
    HTTP.IOHandler := SSLHandler;
    HTTP.ReadTimeout := 15000;
    HTTP.Request.ContentType := 'application/json';

    Url := 'https://api.zerobounce.net/v2/validate?api_key=' + ApiKey +
           '&email=' + UrlEncode(EmailAddress, False) + '&ip_address=';
    ResponseBody := HTTP.Get(Url);

    JsonResponse := TJSONObject.ParseJSONValue(ResponseBody) as TJSONObject;
    if JsonResponse = nil then
      Exit;

    try
      StatusVal := JsonResponse.GetValue('status');
      if (StatusVal <> nil) and (StatusVal is TJSONString) then
        Status := TJSONString(StatusVal).Value;
      SubStatusVal := JsonResponse.GetValue('sub_status');
      if (SubStatusVal <> nil) and (SubStatusVal is TJSONString) and (TJSONString(SubStatusVal).Value <> '') then
        Status := Status + ', ' + TJSONString(SubStatusVal).Value;
      Result := (Pos('Unknown', Status) = 0) and (Pos('Invalid', Status) = 0);
    finally
      JsonResponse.Free;
    end;
  except
    on E: Exception do
    begin
      Status := 'Error: ' + E.Message;
      Result := False;
    end;
  end;
  if Assigned(HTTP) then
    HTTP.Free;
  if Assigned(SSLHandler) then
    SSLHandler.Free;
end;

begin
  if ParamCount < 1 then
  begin
    WriteLn('Usage: ValidateEmailExample <email_to_validate> [api_key]');
    WriteLn('  Or set ZEROBOUNCE_API_KEY environment variable.');
    ExitCode := 1;
    Exit;
  end;

  EmailToValidate := ParamStr(1);
  if ParamCount >= 2 then
    ApiKey := ParamStr(2)
  else
    ApiKey := GetEnvironmentVariable('ZEROBOUNCE_API_KEY');

  if ApiKey = '' then
  begin
    WriteLn('Error: Provide API key as second argument or set ZEROBOUNCE_API_KEY');
    ExitCode := 1;
    Exit;
  end;

  if ValidateEmail(ApiKey, EmailToValidate, Status) then
    WriteLn('Valid: ', Status)
  else
    WriteLn('Invalid: ', Status);
end.
