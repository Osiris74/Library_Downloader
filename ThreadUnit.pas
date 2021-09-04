unit ThreadUnit;

interface

uses Windows, SysUtils, Classes, ActiveX, ComObj, Variants, SynPdf, Jpeg,
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

uses Unit2;

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

  lPdf := TPdfDocument.Create; // создали документ
  lPdf.Info.Author := 'User'; // задали автора
  lPdf.Info.CreationDate := Now; // задали дату создания документа
  lPdf.DefaultPaperSize := psA4; // указали формат страниц (А4)
  Form1.ProgressBar1.Min := 0;
  Form1.ProgressBar1.Max := PageNum;
  Form1.Memo1.Lines.Add('Downloading process have been started...');

  for i := 0 to PageNum - 1 do
  begin
    MS := TMemoryStream.Create;
    Jpegimage := TJPEGImage.Create;
    lPage := lPdf.AddPage;

    try

    try
        (Form1.IdHTTP1.Get
        ('http://elibrary.misis.ru/plugins/SecView/getDoc.php?id=' +
        IntToStr(idNum) + '&page=' + IntToStr(i) + '&type=small/fast', MS));
    except
      Form1.Memo1.Lines.Add('ERROR!!!!');
    end;
      Form1.Memo1.Lines.Add('Downloaded page:' + IntToStr(i));
      MS.Position := 0; // Для того, чтобы позиция читалась с 0

      Jpegimage.LoadFromStream(MS);
      pdfimage := TPdfImage.Create(lPdf, Jpegimage, true);


      lPdf.AddXObject(AnsiString(IntToStr(i)), pdfimage);
      lPdf.Canvas.DrawXObject(0, lPage.PageHeight - Jpegimage.Height,
        Jpegimage.Width, Jpegimage.Height, AnsiString(IntToStr(i)));
      Form1.ProgressBar1.Position := i;

    finally
      MS.Free;
      Jpegimage.Free;
    end;

  end;

  try
    lPdf.SaveToFile('C:\_Books\' + Form1.BookName.Text + '.pdf');
    Form1.ProgressBar1.Position := 0;
    PostMessage(Form1.Handle, cmRxByte, 4, 0); // Download compleated
  except
    PostMessage(Form1.Handle, cmRxByte, 5, 0); // Error
  end;
  isDownload := false;
  MyThread.DoTerminate;
  // Здесь описывается код, который будет выполняться в потоке
end;

procedure AuthMeth;
var
  html: String;
  stringList : TStringList;

begin

  Form1.Memo1.Lines.Add('Waiting for authentication...');

  Form1.IdHTTP1.Request.AcceptCharSet := 'windows-1251';
  try
    html := (Form1.IdHTTP1.Get('http://elibrary.misis.ru/login.php' +
      '?action=login&cookieverify=&redirect='
      + '&username=' + login + '&password=' + newPassword + '&language=ru_UN'));

    if Pos('Запрос выполнен за', html) <> 0 then
      PostMessage(Form1.Handle, cmRxByte, 1, 0) // Succesfully
    else
      PostMessage(Form1.Handle, cmRxByte, 2, 0) // Check data

  except
    PostMessage(Form1.Handle, cmRxByte, 3, 0) // Connection error
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
  Form1.Memo1.Lines.Add('Waiting for book...');
  if (Form1.LinkEd.Text <> '') then
  begin
    try
      html := (Form1.IdHTTP1.Get(Form1.LinkEd.Text));
    except
      PostMessage(Form1.Handle, cmRxByte, 6, 0) // Link Error
    end;
  end;

  if html <> '' then
  begin
    // ===================================Поиск айди====================================
    idStartPos := Pos('plugins/SecView/getDoc.php?id=', html) + 30;
    // Поиск id в html-ке
    idStopPos := PosEx(char(39), html, idStartPos);
    // Char(39) - знак одинарной кавычки
    idNum := StrToInt(Copy(html, idStartPos, idStopPos - idStartPos));

    // ====================================Поиск количества страниц=====================

    pageStartPos := Pos(char(39) + 'PageCount' + char(39) + ':' + char(39),
      html) + 13; // Поиск id в html-ке
    pageStopPos := PosEx(char(39), html, pageStartPos);
    // Char(39) - знак одинарной кавычки
    PageNum := StrToInt((Copy(html, pageStartPos, pageStopPos - pageStartPos)));

    // =====================================Поиск названия===============================
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

    Form1.BookName.Text := title;

    PostMessage(Form1.Handle, cmRxByte, 7, 0) // Get compleated
  end
  else
    PostMessage(Form1.Handle, cmRxByte, 6, 0); // Get Error

  isGet := false;
  MyThread.DoTerminate;

end;

// Нужно создать процедуру Execute, уже описанную в классе TMyThread
procedure TMyThread.Execute;

begin
  if isDownload = true then
    DownMeth;
  if isAuthorization = true then
    AuthMeth;
  if isGet = true then
    GetMeth;

end;

end.

