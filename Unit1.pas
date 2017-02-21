unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ACS_Classes, NewACIndicators, ACS_FLAC, ACS_DXAudio, NewACDSAudio,
  StdCtrls, ACS_Converters, Spin, IdMultipartFormData, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, SSL_OpenSSL, HTTPSend, ACS_Filters,
  ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    ListBox1: TListBox;
    Memo1: TMemo;
    Button3: TButton;
    DXAudioIn1: TDXAudioIn;
    SincFilter1: TSincFilter;
    FLACOut1: TFLACOut;
    FastGainIndicator1: TFastGainIndicator;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function HTTPPostFile(Const URL, FieldName, FileName: String;
      Const Data: TStream; Const ResultData: TStrings): Boolean;
    function GetFileSize(FileName: String): Integer;
    procedure FastGainIndicator1GainData(Sender: TComponent);
  private
    Output: TAuFileOut;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  OutFileName: String = 'out.flac';

implementation

{$R *.dfm}

function TForm1.HTTPPostFile(Const URL, FieldName, FileName: String;
  Const Data: TStream; Const ResultData: TStrings): Boolean;
const
  CRLF = #$0D + #$0A;
var
  HTTP: THTTPSend;
  Bound, Str: String;
begin
  Bound := IntToHex(Random(MaxInt), 8) + '_Synapse_boundary';
  HTTP := THTTPSend.Create;
  HTTP.Clear;
  try
    Str := '--' + Bound + CRLF;
    Str := Str + 'content-disposition: form-data; name="' + FieldName + '";';
    Str := Str + ' filename="' + FileName + '"' + CRLF;
    Str := Str + 'Content-Type: audio/x-flac; rate=8000' + CRLF + CRLF;
    HTTP.Document.Write(Pointer(Str)^, Length(Str));
    HTTP.Document.CopyFrom(Data, 0);
    Str := CRLF + '--' + Bound + '--' + CRLF;
    HTTP.Document.Write(Pointer(Str)^, Length(Str));
    HTTP.MimeType := 'audio/x-flac; rate=8000, boundary=' + Bound;
    Result := HTTP.HTTPMethod('POST', URL);
    ResultData.LoadFromStream(HTTP.Document);
  finally
    HTTP.Free;
  end;
end;

function TForm1.GetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
  Result := 0;
  try
    FS := TFileStream.Create(FileName, fmOpenRead);
  except
    Result := -1;
    FS.Free;
    Exit;
  end;
  if Result <> -1 then
    Result := FS.Size;
  FS.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Ext: String;
begin
  if FileExists(ExtractFilePath(Application.ExeName) + OutFileName) then
    DeleteFile(ExtractFilePath(Application.ExeName) + OutFileName);
  Output := FLACOut1;
  Output.FileName := OutFileName;
  Output.Run;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Output <> nil then
    Output.Stop;
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  StrList: TStringList;
  Stream: TFileStream;
 Str: String;
begin
  if (FileExists(ExtractFilePath(Application.ExeName) + OutFileName)) and
    (GetFileSize(ExtractFilename(OutFileName)) > 0) and
    (FileExists(ExtractFilePath(Application.ExeName) + 'libeay32.dll')) and
    (FileExists(ExtractFilePath(Application.ExeName) + 'ssleay32.dll')) then
  begin
    StrList := TStringList.Create;
    StrList.Clear;
    Memo1.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) +
      ': ∆дите, идет отправка запроса в Google...');
    Stream := TFileStream.Create(ExtractFilename(OutFileName),
      fmOpenRead or fmShareDenyWrite);
    try
      HTTPPostFile
        ('https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=ru-RU',
        'userfile', ExtractFilename(OutFileName), Stream, StrList);
    finally
      Stream.Free;
    end;
    Str := UTF8ToString(StrList.Text);
    Memo1.Lines.Add(Str);
    StrList.Free;
    Memo1.Lines.Add(FormatDateTime('dd.mm.yy hh:mm:ss', Now) +
      ': ∆ду комманды...');
  end;
end;

procedure TForm1.FastGainIndicator1GainData(Sender: TComponent);
begin
  ProgressBar1.Position := FastGainIndicator1.GainValue;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  i: Integer;
begin
  for i := 0 to DXAudioIn1.DeviceCount - 1 do
    ListBox1.Items.Add(DXAudioIn1.DeviceName[i]);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  DXAudioIn1.DeviceNumber := ListBox1.ItemIndex;
end;

end.
