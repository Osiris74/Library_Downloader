unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls, Synpdf, Jpeg, StrUtils,
  Vcl.ComCtrls, Vcl.Menus, IdSMTPBase, IdSMTP, IdExplicitTLSClientServerBase,
  IdMessageClient, IdMessage, IdCustomTransparentProxy, IdGlobal,
  IdMailBox, IdBaseComponent;

const
  cmRxByte = wm_User + $55;

type
  TForm2 = class(TForm)
    AuthBut: TButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    GetBut: TButton;
    DownBut: TButton;
    LinkEd: TEdit;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    logEd: TEdit;
    pasEd: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    Info1: TMenuItem;
    Info2: TMenuItem;
    Exit1: TMenuItem;
    ReadMe1: TMenuItem;
    BookName: TEdit;
    Label4: TLabel;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    procedure AuthButClick(Sender: TObject);
    procedure GetButClick(Sender: TObject);
    procedure DownButClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Info2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RecivBytes(var Msg: TMessage); message cmRxByte;
    procedure SendEmail(const Recipients: string; const Subject: string;
      const Body: string);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  idNum: Integer; // Номер Id
  pageNum: Integer; // Количество страниц в книге
  title: String; // Название книги
  Msg: TIdMessage;
  dataName: String;
  newPassword, login, password: String;
  isDownload, isAuthorization, isGet, isMail: bool;

implementation

uses ThreadUnit;
{$R *.dfm}

procedure TForm2.AuthButClick(Sender: TObject);
var
  pasBytes: array of string;
  temp: Integer;
  i: Integer;
begin
  if (logEd.Text <> '') and (pasEd.Text <> '') then
  begin
    FillChar(newPassword, SizeOf(newPassword), 0);
    login := logEd.Text;
    password := pasEd.Text;
    setlength(pasBytes, length(password));
    for i := 1 to length(password) do
    begin
      temp := Ord(password[i]);

      if (temp < 1088) or (temp > 1103) then // Значения символов E0 и EF
      begin
        pasBytes[i] := '%D0%' + IntToHex(((temp) - 896), 2);
        // + 128 - 1024 для шифрования
        newPassword := newPassword + pasBytes[i];
      end
      else
      begin
        pasBytes[i] := '%D1%' + IntToHex(((temp) - 960), 2);
        // +64 -1024 для шифрования
        newPassword := newPassword + pasBytes[i];
      end;
    end;

    isAuthorization := true;
    MyThread := TMyThread.Create(true);
    MyThread.FreeOnTerminate := true;
    MyThread.Priority := tpLower;
    MyThread.Start;

  end
  else
    ShowMessage('Заполните логин и пароль');
end;

procedure TForm2.GetButClick(Sender: TObject);
begin
  isGet := true;
  MyThread := TMyThread.Create(true);
  MyThread.FreeOnTerminate := true;
  MyThread.Priority := tpLower;
  MyThread.Start;
end;

procedure TForm2.Info2Click(Sender: TObject);
begin
  ShowMessage('Спасибо за то что пользуетесь приложением' + #13 + #10 +
    'Если есть какие либо предложения/пожелания и способность связаться со мной - пишите'
    + #13 + #10 + 'Готов принять небольшие донаты за бессоные ночи :))' + #13 +
    #10 + 'QIWI:https://qiwi.com/n/AGOOM395' + #13 + #10 +
    'Пополнение по никнейму:AGOOM395');
end;

procedure TForm2.SendEmail(const Recipients: string; const Subject: string;
  const Body: string);
var
  SMTP: TIdSMTP;
  Email: TIdMessage;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin

  SMTP := TIdSMTP.Create(nil);
  Email := TIdMessage.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  try
    SSLHandler.MaxLineAction := maException;
    SSLHandler.SSLOptions.Method := sslvTLSv1;
    SSLHandler.SSLOptions.Mode := sslmUnassigned;
    SSLHandler.SSLOptions.VerifyMode := [];
    SSLHandler.SSLOptions.VerifyDepth := 0;

    SMTP.IOHandler := SSLHandler;
    SMTP.Host := 'smtp.gmail.com';
    SMTP.Port := 587;
    SMTP.Username := 'example@gmail.com';
    SMTP.password := 'password';
    SMTP.UseTLS := utUseExplicitTLS;

    Email.From.Address := 'example@gmail.com';
    Email.Recipients.EmailAddresses := Recipients;
    Email.Subject := Subject;
    Email.Body.Text := Body;

    SMTP.Connect;
    SMTP.Send(Email);
    SMTP.Disconnect;

  finally
    SMTP.Free;
    Email.Free;
    SSLHandler.Free;
  end;

end;

function GetComputerNetName: string;
var
  buffer: array [0 .. 255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    result := buffer
  else
    result := ''
end;

procedure TForm2.DownButClick(Sender: TObject);
begin
  if BookName.Text <> '' then
  begin

    isDownload := true;
    MyThread := TMyThread.Create(true);
    MyThread.FreeOnTerminate := true;
    MyThread.Priority := tpLower;
    MyThread.Start;

  end
  else
    ShowMessage('Введите название книги');
end;

procedure TForm2.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  CreateDir('C:\_Books');
end;

procedure TForm2.RecivBytes(var Msg: TMessage); // Messages from second thread
begin
  case Msg.WParam of

    // Succesfull login
    1:
      begin
        ShowMessage('Login:' + #13 + #10 + ' Succesfully');
        Application.ProcessMessages;
      end;

    // Issues with login
    2:
      begin
        ShowMessage('Check your data');
        Application.ProcessMessages;
      end;

    // Issues with login
    3:
      begin
        ShowMessage('Connection error' + #13 + #10 + 'Chech your data');
        Application.ProcessMessages;
      end;

    // Connecting protocol
    4:
      begin
        ShowMessage('Download compleated succesfylly' + #13 + #10 +
          'C:\_Books\' + Form2.BookName.Text + '.pdf' + #13 + #10 +
          'Succesfully');
        isMail := true;
        MyThread := TMyThread.Create(true);
        MyThread.FreeOnTerminate := true;
        MyThread.Priority := tpLower;
        MyThread.Start;
        Application.ProcessMessages;
      end;

    5:
      begin
        ShowMessage('Error occured, try again');
        Application.ProcessMessages;
      end;

    6:
      begin
        ShowMessage('Error with book link' + #13 + #10 +
          'Please, check the link');
        Application.ProcessMessages;
      end;

    7:
      begin
        ShowMessage('Your link is working, now press "Download" button');
      end;

  end;
end;

end.
