program HtmlReader;

uses
  Forms,
  main_f in 'main_f.pas' {main_form},
  net_module in 'net_module.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmain_form, main_form);
  Application.Run;
end.
