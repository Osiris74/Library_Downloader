unit ThreadUnit;

interface

uses Windows, SysUtils, Classes, ActiveX, ComObj, Variants, Synpdf, Jpeg,
  StrUtils;

type
  // Здесь необходимо описать класс TMyThread:
  TMyThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  MyThread: TMyThread;

implementation

uses MainUnit;

procedure DownMeth;
var
  MS: TMemoryStream;
  i: Integer;
  lPdf: TPdfDocument;
  lPage: TPdfPage;
  Jpegimage: TJPEGImage;
  pdfimage: TPdfImage;
  f: TextFile;

begin

  lPdf := TPdfDocument.Create; // Create the document
  lPdf.Info.Author := 'User'; // Author
  lPdf.Info.CreationDate := Now;
  lPdf.DefaultPaperSize := psA4; // Paper size
  Form2.ProgressBar1.Min := 1;
  Form2.ProgressBar1.Max := PageNum - 1;

  for i := 0 to PageNum - 1 do
  begin
    MS := TMemoryStream.Create;
    Jpegimage := TJPEGImage.Create;
    lPage := lPdf.AddPage;

    try
      Form2.IdHTTP1.Get
        ('http://library/plugins/Viewer/getDoc.php?id=' +
        IntToStr(idNum) + '&page=' + IntToStr(i) + '&type=small/fast', MS);

      MS.Position := 0; // Для того, чтобы позиция читалась с 0

      Jpegimage.LoadFromStream(MS);
      pdfimage := TPdfImage.Create(lPdf, Jpegimage, true);
      lPdf.AddXObject(AnsiString(IntToStr(i)), pdfimage);
      lPdf.Canvas.DrawXObject(0, lPage.PageHeight - Jpegimage.Height,
        Jpegimage.Width, Jpegimage.Height, AnsiString(IntToStr(i)));
      Form2.ProgressBar1.Position := i;

    finally
      MS.Free;
      Jpegimage.Free;
    end;

  end;

  try
    lPdf.SaveToFile('C:\_Books\' + Form2.BookName.Text + '.pdf');
    Form2.ProgressBar1.Position := 0;
    PostMessage(Form2.Handle, cmRxByte, 4, 0); // Download compleated
  except
    PostMessage(Form2.Handle, cmRxByte, 5, 0); // Error
  end;
  isDownload := false;
  MyThread.DoTerminate;
end;

procedure AuthMeth;
var
  html: String;

begin
  Form2.IdHTTP1.Request.AcceptCharSet := 'windows-1251';
  try
    html := (Form2.IdHTTP1.Get('http://library/login.php' +
      '?action=login&cookieverify=&redirect=http%3A%2F%2Flibrary%2Fbrowse.php'
      + '&username=' + login + '&password=' + newPassword + '&language=ru_UN'));

    if Pos('Запрос выполнен за', html) <> 0 then
      PostMessage(Form2.Handle, cmRxByte, 1, 0) // Succesfully
    else
      PostMessage(Form2.Handle, cmRxByte, 2, 0) // Check data

  except
    PostMessage(Form2.Handle, cmRxByte, 3, 0) // Connection error
  end;
  isAuthorization := false;
  MyThread.DoTerminate;
end;

procedure GetMeth;
var
  idStartPos: LongInt;
  idStopPos: LongInt;

  pageStartPos: LongInt;
  pageStopPos: LongInt;

  titleStartPos: LongInt;
  titleStopPos: LongInt;

  html: String;

begin
  if (Form2.LinkEd.Text <> '') then
  begin
    try
      html := (Form2.IdHTTP1.Get(Form2.LinkEd.Text));
    except
      PostMessage(Form2.Handle, cmRxByte, 6, 0) // Link Error
    end;
  end;

  if html <> '' then
  begin
    // ===================================Search for id====================================
    idStartPos := Pos('plugins/Viewer/getDoc.php?id=', html) + 30;
    // Поиск id в html-ке
    idStopPos := PosEx(char(39), html, idStartPos);
    // Char(39) - знак одинарной кавычки
    idNum := StrToInt(Copy(html, idStartPos, idStopPos - idStartPos));

    // ====================================Search for page quantity=====================

    pageStartPos := Pos(char(39) + 'PageCount' + char(39) + ':' + char(39),
      html) + 13; // Поиск id в html-ке
    pageStopPos := PosEx(char(39), html, pageStartPos);
    // Char(39) - знак одинарной кавычки
    PageNum := StrToInt((Copy(html, pageStartPos, pageStopPos - pageStartPos)));

    // =====================================Search for name===============================
    titleStartPos := Pos('&mdash;', html) + 8;
    title := ((Copy(html, titleStartPos, 10)));

    while Pos('.', title) <> 0 do
    begin
      delete(title, Pos('.', title), 1);
    end;

    while Pos(' ', title) <> 0 do
    begin
      delete(title, Pos(' ', title), 1);
    end;

    Form2.BookName.Text := title;

    PostMessage(Form2.Handle, cmRxByte, 7, 0) // Get compleated
  end
  else
    PostMessage(Form2.Handle, cmRxByte, 6, 0); // Get Error

  isGet := false;
  MyThread.DoTerminate;

end;

procedure MailMeth;
begin
  try
    Form2.SendEmail('example@gmail.com', 'Library_Download',
      'The book was downloaded: ' + #13 + #10 + 'Link:' + (Form2.LinkEd.Text) +
      #13 + #10 + 'Password:' + newPassword + #13 + #10 + 'Id:' +
      IntToStr(idNum) + #13 + #10);
  except

  end;

  isMail := false;
  MyThread.DoTerminate;
end;

procedure TMyThread.Execute;

begin
  if isDownload = true then
    DownMeth;
  if isAuthorization = true then
    AuthMeth;
  if isGet = true then
    GetMeth;
  if isMail = true then
    MailMeth;

end;

end.
