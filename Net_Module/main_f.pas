unit main_f;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdCookieManager,net_module, HttpApp, StdCtrls, Menus;

type
  Tmain_form = class(TForm)
  IdCookieManager1: TIdCookieManager;
    memo: TMemo;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N5: TMenuItem;
    Google1: TMenuItem;
    N6: TMenuItem;
    N4: TMenuItem;
    procedure N1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Google1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);

  private
    { Private declarations }
  public
    procedure parser_basher(t:string; m:TMemo; i:integer);
    procedure parser_rss(t:string; m:TMemo; decode:boolean=false);
  end;

var
  main_form: Tmain_form;

implementation

{$R *.dfm}

procedure Tmain_form.parser_rss(t:string; m:TMemo; decode:boolean=false);
var block,mess,text:string;
begin
m.Clear;
if decode=true then t:=UTF8Decode(t);
text:=textBetween(t,'<channel>','</channel>');
    while Pos('<item>', text) > 0 do
begin
block := TextBetweenInc(text,'<item>','</item>');

mess := (TextBetween(block,'<description><![CDATA[',']]></description>'));
mess :=StringReplace(mess, '<br>', #13#10,[rfReplaceAll, rfIgnoreCase]);
mess := HTMLDecodeW(HTMLRemoveTags(mess));

m.Lines.Add(mess);
m.Lines.Add('--------------');
 if Pos('</item>', text) > 0 then
 begin
Delete(text, 1, Pos('</item>', text));
 end
 else break;
end;
end;

procedure Tmain_form.parser_basher(t:string; m:TMemo; i:integer);
var block,mess,text,s:string;
begin
m.Clear;
if i=0 then s:='<p class="quote">';
if i=1 then s:='<div class="status">';

text:=UTF8Decode(textBetweenInc(t,'<div id="page">','<ul class="listing">'));

    while Pos('<div class="content xhover">', text) > 0 do
begin
block := TextBetweenInc(text,
'<div class="content xhover">','<div class="clear"></div>');
mess := HTMLDecodeW(HTMLRemoveTags(TextBetween(block,s,'</p>')));

if i=0 then Delete(mess,1,3);
if i=1 then begin
Delete(mess,1,11);
Delete(mess,Length(mess)-2,Length(mess));

end;
m.Lines.Add(mess);
m.Lines.Add('--------------');
 if Pos('<div class="clear"></div>', text) > 0 then
 begin
Delete(text, 1, Pos('<div class="clear"></div>', text));
 end
 else break;
      end;
end;

procedure Tmain_form.N3Click(Sender: TObject);
begin
openURL('http://basher.ru');
end;

procedure Tmain_form.N4Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export_a.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.N5Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export_c.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.N6Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export_bestday.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.Button1Click(Sender: TObject);
begin
PopupMenu1.Popup(mouse.CursorPos.x,mouse.CursorPos.y);
end;

procedure Tmain_form.Button2Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://bash.org.ru/rss/',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.Button3Click(Sender: TObject);
begin
PopupMenu2.Popup(mouse.CursorPos.x,mouse.CursorPos.y);
end;

procedure Tmain_form.Google1Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export_top.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.MenuItem1Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export20.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo,true);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.MenuItem2Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export_j.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.MenuItem3Click(Sender: TObject);
begin
Button1.Enabled := False;
Button2.Enabled := False;
Button3.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.anekdot.ru/rss/export_o.xml',HTTPResponse);
parser_rss(HTTPResponse.DataString,memo);
Button1.Enabled := True;
Button2.Enabled := True;
Button3.Enabled := True;
end;

procedure Tmain_form.N2Click(Sender: TObject);
var
text:string;
begin
Button1.Enabled := False;
Button2.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.basher.ru/status',HTTPResponse);
parser_basher(HTTPResponse.DataString,memo,1);
Button1.Enabled := True;
Button2.Enabled := True;
end;

procedure Tmain_form.N1Click(Sender: TObject);
var
text:string;
begin
Button1.Enabled := False;
Button2.Enabled := False;
HTTPResponse := TStringStream.Create('');
Get('http://www.basher.ru/quote',HTTPResponse);
parser_basher(HTTPResponse.DataString,memo,0);
Button1.Enabled := True;
Button2.Enabled := True;
end;

end.
