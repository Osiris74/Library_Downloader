unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdMessage, IdSocks, IdServerIOHandler, IdSSLOpenSSL,
  IdIOHandler, IdIOHandlerSocket, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, StdCtrls, ComCtrls,
  Menus;

  const
  cmRxByte = wm_User + $55;



type
  TForm1 = class(TForm)
    logEd: TEdit;
    pasEd: TEdit;
    LinkEd: TEdit;
    BookName: TEdit;
    AuthBut: TButton;
    GetBut: TButton;
    downBut: TButton;
    IdHTTP1: TIdHTTP;
    IdIOHandlerSocket1: TIdIOHandlerSocket;
    IdSocksInfo1: TIdSocksInfo;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Label5: TLabel;
    procedure AuthButClick(Sender: TObject);
    procedure GetButClick(Sender: TObject);
    procedure downButClick(Sender: TObject);
    procedure RecivBytes(var Msg: TMessage); message cmRxByte;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  idNum: Integer; // ����� Id
  pageNum: Integer; // ���������� ������� � �����
  title: String; // �������� �����
  Msg: TIdMessage;
  dataName: String;
  newPassword, login, password: String;
  isDownload, isAuthorization, isGet, isMail: bool;


implementation

uses ThreadUnit;


{$R *.dfm}

procedure TForm1.About1Click(Sender: TObject);
begin
   ShowMessage('������� �� �� ��� ����������� �����������' + #13+#10 +
                '���� ���� ����� ���� �����������/��������� � ����������� ��������� �� ���� - ������!' +#13+#10 +
                '����� ������� ��������� ������ �� �������� ���� :)))' +#13+#10 +
                'QIWI:https://qiwi.com/n/AGOOM395' + #13+#10+
                '���������� �� ��������:AGOOM395' +#13+#10+
                '������� �� ��������� � ������������' +#13+#10 +
                '����� ��������� ����������!');
end;

procedure TForm1.AuthButClick(Sender: TObject);
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

      if (temp < 1088) or (temp > 1103) then // �������� �������� E0 � EF
      begin
        pasBytes[i] := '%D0%' + IntToHex(((temp) - 896), 2);
        // + 128 - 1024 ��� ����������
        newPassword := newPassword + pasBytes[i];
      end
      else
      begin
        pasBytes[i] := '%D1%' + IntToHex(((temp) - 960), 2);
        // +64 -1024 ��� ����������
        newPassword := newPassword + pasBytes[i];
      end;
    end;

    isAuthorization := true;
    MyThread := TMyThread.Create(true);
    MyThread.FreeOnTerminate := true;
    MyThread.Priority := tpNormal;
    MyThread.Resume;

  end
  else
    ShowMessage('��������� ����� � ������');
end;

procedure TForm1.GetButClick(Sender: TObject);
begin
  isGet := true;
  MyThread := TMyThread.Create(true);
  MyThread.FreeOnTerminate := true;
  MyThread.Priority := tpNormal;
  MyThread.Resume;

end;


procedure TForm1.Help1Click(Sender: TObject);
begin
ShowMessage('������� ���� ������: ����� � ������ -> ������� ������ �����������' +#13+#10+
            '����� ��������� �� ������, ���������� ������ �� ����� � ������ -> ������� ������ Get' +#13+#10+
            '������� ������ Download -> ����� ����� ��������');
end;

procedure TForm1.downButClick(Sender: TObject);
begin
  if BookName.Text <> '' then
  begin
    isDownload := true;
    MyThread := TMyThread.Create(true);
    MyThread.FreeOnTerminate := true;
    MyThread.Priority := tpNormal;
    MyThread.Resume;

  end
  else
    ShowMessage('������� �������� �����');
end;


procedure TForm1.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if not DirectoryExists('C:\_Books') then
    CreateDir('C:\_Books');
end;

procedure TForm1.RecivBytes(var Msg: TMessage); // Messages from second thread
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
          'C:\_Books\' + Form1.BookName.Text + '.pdf' + #13 + #10 +
          'Succesfully');
        isMail := true;
        MyThread := TMyThread.Create(true);
        MyThread.FreeOnTerminate := true;
        MyThread.Priority := tpNormal;
        MyThread.Resume;
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
