unit net_module;

interface

uses
  SysUtils,Dialogs, Classes,ShellApi,Windows,ComCtrls,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent,IdCookieManager, idHTTP,IdException, IdIOHandlerStack;

    {Запросы}
  function IsInternetConnected: Boolean; //Проверка соединения с Интернетом
  procedure Get(url:WideString; response:TStream);
  procedure Post(url:WideString; source:TStringList; response:TStream);
{Улучшенные запросы GET и Post при котором не вылазят некоторые ошибки}

   {Парсинг}
  function TextBetweenInc(WholeText: string; BeforeText: string; AfterText: string): string;
{TextBetweenInc(исходный текст,слово с которого начать поиск,
слово которым закончить поиск) - Поиск определённого текста и
если оно найдено вывод его в результат в месте со строками поиска}
  function TextBetween(WholeText: string; BeforeText: string; AfterText: string): string;
{TextBetween(исходный текст,слово с которого начать поиск,
слово которым закончить поиск) - Поиск определённого текста и вывод его в результат}

  {Работа с кодировками}
  function URLEncode(const AStr: string): string; //Кодировка в формат URL
  function URLDecode(const AStr: string): string; //Разгодировка из формата URL
  function HTMLRemoveTags(const Value: WideString): WideString;
  function HTMLDecodeW(const Value: String): WideString;
  function HTMLDecode(const Value: string): string;

  {Разное}
  procedure openURL(url:string); //Открытие ссылки в стандартном браузере
  procedure openURL_browser(url,browser:string); //Открытие ссылки в определённом браузере

    var
    RemainingText: string;
    HTTPResponse: TStringStream;
    HTTPParms: TStringList;

implementation

uses main_f; //Если нужно добавляем форму которую будим использовать

   {Запросы}
function IsInternetConnected: Boolean;
begin
 Result := GetSystemMetrics(SM_NETWORK) and 1 > 0;
end;

procedure Get(url:WideString; response:TStream);
 var
 FH: TidHTTP;
 FS: TIdIOHandlerStack;
 AF:  TIdAntiFreeze;    //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
 begin if IsInternetConnected = true then
 try
      FH := TidHTTP.Create(nil);
      FS := TIdIOHandlerStack.Create(nil);
      AF := TIdAntiFreeze.Create(nil); //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
      FH.CookieManager := main_form.IdCookieManager1; //Путь к статичному TIdCookieManager на форме
      AF.Active := True;  //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
      FH.AllowCookies := true;
      FH.HandleRedirects := true;
      FH.Request.BasicAuthentication := true;
      FH.HTTPOptions := [];
      FH.IOHandler := FS;
      FH.Request.AcceptLanguage := 'ru';
      FH.Request.AcceptCharset:= 'windows-1251,utf-8;q=0.7,*;q=0.7';
      FH.Request.UserAgent :='Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2';
      FH.Request.Connection := 'keep-alive';
      FH.Request.CustomHeaders.Text := 'Keep-Alive: 300';
      FH.Request.CacheControl :='no-cache';
      FH.Request.Pragma := 'no-cache';

      if response<>nil then FH.Get(url,response);
      FS.Free;
      FH.Free;
      AF.Free; //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
except
 end;
 end;

procedure Post(url:WideString; source:TStringList; response:TStream);
var
 FH: TidHTTP;
 FS: TIdIOHandlerStack;
 AF:  TIdAntiFreeze; //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
 I:integer;
 begin if IsInternetConnected = true then        
 try
     FH := TidHTTP.Create(nil);
      FS := TIdIOHandlerStack.Create(nil);
      AF := TIdAntiFreeze.Create(nil);  //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
      FH.CookieManager := main_form.IdCookieManager1; //Путь к статичному TIdCookieManager на форме
      AF.Active := True;  //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
      FH.AllowCookies := true;
      FH.HTTPOptions := [];
      FH.IOHandler := FS;
      FH.HandleRedirects := true;
      FH.Request.BasicAuthentication := true;
      FH.Request.AcceptLanguage := 'ru';
      FH.Request.AcceptCharset:= 'windows-1251,utf-8;q=0.7,*;q=0.7';
      FH.Request.UserAgent :='Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2';
      FH.Request.Connection := 'keep-alive';
      FH.Request.CustomHeaders.Text := 'Keep-Alive: 300';
      FH.Request.CacheControl :='no-cache';
      FH.Request.Pragma := 'no-cache';
      
      if (response<>nil) or (source<>nil) then
      begin
      for I := 0 to source.Count - 1 do urlencode(utf8encode(source.Strings[i]));
      FH.Post(url,source,response);
      end;
      FS.Free;
      FH.Free;
      AF.Free;  //Если вылазит ошибка убираем отсюда и добавляем компонент AntiFreeze на форму
   except
 end;
 end;

    {Парсинг}
function TextBetweenInc(WholeText: string; BeforeText: string; AfterText: string): string;
var
  FoundPos: Integer;
  WorkText: string;
begin
  RemainingText := WholeText;
  Result := '';
  FoundPos := Pos(BeforeText, WholeText);
  if FoundPos = 0 then
    Exit;
  WorkText := Copy(WholeText, FoundPos, Length(WholeText));
  FoundPos := Pos(AfterText, WorkText);
  if FoundPos = 0 then
    Exit;
  Result := Copy(WorkText, 1, FoundPos - 1 + Length(AfterText));
  RemainingText := Copy(WorkText, FoundPos + Length(AfterText), Length(WorkText));
end;

function TextBetween(WholeText: string; BeforeText: string; AfterText: string): string;
var
  FoundPos: Integer;
  WorkText: string;
begin
  RemainingText := WholeText;
  Result := '';
  FoundPos := Pos(BeforeText, WholeText);
  if FoundPos = 0 then
    Exit;
  WorkText := Copy(WholeText, FoundPos + Length(BeforeText), Length(WholeText));
  FoundPos := Pos(AfterText, WorkText);
  if FoundPos = 0 then
    Exit;
  Result := Copy(WorkText, 1, FoundPos - 1);
  RemainingText := Copy(WorkText, FoundPos + Length(AfterText), Length(WorkText));
end;

  {Работа с кодировками}
function URLEncode(const AStr: string): string;
const
  NoConversion = ['0'..'9','A'..'Z','a'..'z'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Sp^
    else
    begin
      FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
      Inc(Rp,2);
    end;

    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function URLDecode(const AStr: string): string;
const HexChar = '0123456789ABCDEF';
var I,J: integer;
begin
  SetLength(Result, Length(AStr));
  I:=1;
  J:=1;
  while (I <= Length(AStr)) do
  begin
    if (AStr[I] = '%') and (I+2 < Length(AStr)) then
    begin
      Result[J] := chr(((pred(Pos(AStr[I+1],HexChar)))shl 4) or (pred(Pos(AStr[I+2],HexChar))));
      Inc(I, 2);
    end
    else
      Result[J] := AStr[I];
    Inc(I);
    Inc(J);
  end;
  SetLength(Result, pred(J));
end;

function HTMLRemoveTags(const Value: WideString): WideString;
var
  i, Max: Integer;
begin
  result := '';
  Max := Length(Value);
  i := 1;
  while i <= Max do
  begin
    if Value[i] = '<' then
    begin
      repeat
        inc(i);
      until (i > Max) or (Value[i-1] = '>');
    end else
    begin
      result := result + Value[i];
      inc(i);
    end;
  end;
end;

function HTMLDecode(const Value: string): string;
const
  Symbols: array [32..255] of string = (
                        'nbsp',   '',       'quot',   '',       '',       '',       'amp',    '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    'lt',     '',       'gt',     '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       'iexcl',  'cent',   'pound',  'curren', 'yen',    'brvbar', 'sect',   'uml',    'copy',
    'ordf',   'laquo',  'not',    'shy',    'reg',    'macr',   'deg',    'plusmn', 'sup2',   'sup3',
    'acute',  'micro',  'para',   'middot', 'cedil',  'sup1',   'ordm',   'raquo',  'frac14', 'frac12',
    'frac34', 'iquest', 'Agrave', 'Aacute', 'Acirc',  'Atilde', 'Auml',   'Aring',  'AElig',  'Ccedil',
    'Egrave', 'Eacute', 'Ecirc',  'Euml',   'Igrave', 'Iacute', 'Icirc',  'Iuml',   'ETH',    'Ntilde',
    'Ograve', 'Oacute', 'Ocirc',  'Otilde', 'Ouml',   'times',  'Oslash', 'Ugrave', 'Uacute', 'Ucirc',
    'Uuml',   'Yacute', 'THORN',  'szlig',  'agrave', 'aacute', 'acirc',  'atilde', 'auml',   'aring',
    'aelig',  'ccedil', 'egrave', 'eacute', 'ecirc',  'euml',   'igrave', 'iacute', 'icirc',  'iuml',
    'eth',    'ntilde', 'ograve', 'oacute', 'ocirc',  'otilde', 'ouml',   'divide', 'oslash', 'ugrave',
    'uacute', 'ucirc',  'uuml',   'yacute', 'thorn',  'yuml'
  );
var
  i, Max, p1, p2: Integer;
  Symbol: string;
  SymbolLength: Integer;

  function IndexStr(const AText: string; const AValues: array of string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := Low(AValues) to High(AValues) do
      if AText = AValues[i] then
      begin
        Result := i;
        Break;
      end;
  end;

begin
  result := '';
  Max := Length(Value);
  i := 1;
  while i <= Max do
  begin
    if (Value[i] = '&') and (i + 1 < Max) then
    begin
      Symbol := copy(Value, i + 1, Max);
      p1 := Pos(' ', Symbol);
      p2 := Pos(';', Symbol);
      if (p2 > 0) and ((p2 < p1) xor (p1 = 0)) then
      begin
        Symbol := Copy(Symbol, 1, pos(';', Symbol) - 1);
        SymbolLength := Length(Symbol) + 1;
        if Symbol[1] <> '#' then
        begin
          Symbol := IntToStr(IndexStr(Symbol, Symbols) + 32);
        end else
          Delete(Symbol, 1, 1);
        Symbol := char(StrToIntDef(Symbol, 0));
        result := result + Symbol;
        inc(i, SymbolLength);
      end else
        result := result + Value[i];
    end else
      result := result + Value[i];
    inc(i);
  end;
end;

function HTMLDecodeW(const Value: String): WideString;
const
  Symbols: array [32..255] of string = (
                        'nbsp',   '',       'quot',   '',       '',       '',       'amp',    '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    'lt',     '',       'gt',     '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       '',       '',       '',       '',       '',       '',       '',       '',       '',
    '',       'iexcl',  'cent',   'pound',  'curren', 'yen',    'brvbar', 'sect',   'uml',    'copy',
    'ordf',   'laquo',  'not',    'shy',    'reg',    'macr',   'deg',    'plusmn', 'sup2',   'sup3',
    'acute',  'micro',  'para',   'middot', 'cedil',  'sup1',   'ordm',   'raquo',  'frac14', 'frac12',
    'frac34', 'iquest', 'Agrave', 'Aacute', 'Acirc',  'Atilde', 'Auml',   'Aring',  'AElig',  'Ccedil',
    'Egrave', 'Eacute', 'Ecirc',  'Euml',   'Igrave', 'Iacute', 'Icirc',  'Iuml',   'ETH',    'Ntilde',
    'Ograve', 'Oacute', 'Ocirc',  'Otilde', 'Ouml',   'times',  'Oslash', 'Ugrave', 'Uacute', 'Ucirc',
    'Uuml',   'Yacute', 'THORN',  'szlig',  'agrave', 'aacute', 'acirc',  'atilde', 'auml',   'aring',
    'aelig',  'ccedil', 'egrave', 'eacute', 'ecirc',  'euml',   'igrave', 'iacute', 'icirc',  'iuml',
    'eth',    'ntilde', 'ograve', 'oacute', 'ocirc',  'otilde', 'ouml',   'divide', 'oslash', 'ugrave',
    'uacute', 'ucirc',  'uuml',   'yacute', 'thorn',  'yuml'
  );
var
  i, Max, p1, p2: Integer;
  Symbol: WideString;
  SymbolLength: Integer;

  function IndexStr(const AText: string; const AValues: array of string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := Low(AValues) to High(AValues) do
      if AText = AValues[i] then
      begin
        Result := i;
        Break;
      end;
  end;

begin
  result := '';
  Max := Length(Value);
  i := 1;
  while i <= Max do
  begin
    if (Value[i] = '&') and (i + 1 < Max) then
    begin
      Symbol := Copy(Value, i + 1, Max);
      p1 := Pos(' ', Symbol);
      p2 := Pos(';', Symbol);
      if (p2 > 0) and ((p2 < p1) xor (p1 = 0)) then
      begin
        Symbol := Copy(Symbol, 1, pos(';', Symbol) - 1);
        SymbolLength := Length(Symbol) + 1;
        if Symbol[1] <> '#' then
        begin
          Symbol := IntToStr(IndexStr(Symbol, Symbols) + 32);
        end else
          Delete(Symbol, 1, 1);
        Symbol := WideChar(StrToIntDef(Symbol, 0));
        result := result + Symbol;
        inc(i, SymbolLength);
      end else
        result := result + Value[i];
    end else
      result := result + Value[i];
    inc(i);
  end;
end;

  {Разное}
procedure openURL(url:string);
begin
openURL_browser('',pchar(url));
end;

procedure openURL_browser(url,browser:string);
begin
ShellExecute(0,nil, PChar(browser), PChar(URL), nil, 5);
end;

end.
