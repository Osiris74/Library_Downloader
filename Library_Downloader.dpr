program Library_Downloader;

uses
  Vcl.Forms,
  Unit2 in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Unit2.pas' {Form2},
  SynPdf in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynPdf.pas',
  SynGdiPlus in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynGdiPlus.pas',
  SynZip in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynZip.pas',
  SynCrypto in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynCrypto.pas',
  SynLZ in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynLZ.pas',
  SynCommons in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynCommons.pas',
  SynTable in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\Win32\Debug\SynPDF-master\SynTable.pas',
  ThreadUnit in 'C:\For_Alex\Project_MISIS\MyHackProgs\MisisLibraryHack\temp\ThreadUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;

end.
