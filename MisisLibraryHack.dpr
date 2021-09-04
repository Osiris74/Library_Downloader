program MisisLibraryHack;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  ThreadUnit in 'ThreadUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
