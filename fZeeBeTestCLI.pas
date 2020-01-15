unit fZeeBeTestCLI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvBaseDlg,
  JvBrowseFolder, Vcl.Mask;

type
  TForm1 = class(TForm)
    dlgBrowseForFolder: TJvBrowseForFolderDialog;
    mmoCLIResults: TMemo;
    btnDeployBPMFile: TButton;
    lbledtBPMNFileFolder: TLabeledEdit;
    lbledtBINFolder: TLabeledEdit;
    lbledworkFlowBPMNFile: TLabeledEdit;
    btnCreateWFInstance: TButton;
    btnGetStatus: TButton;
    medtOrderID: TMaskEdit;
    lblOrderID: TLabel;
    medtAmount: TMaskEdit;
    lblAmount: TLabel;
    btnCreateWorker: TButton;
    lbledtJobName: TLabeledEdit;
    btnPublishMessage: TButton;
    lbledtMessage: TLabeledEdit;
    lbledtCorrKey: TLabeledEdit;
    lblJob2: TLabel;
    procedure btnDeployBPMFileClick(Sender: TObject);
    procedure lbledtBPMNFileFolderDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCreateWFInstanceClick(Sender: TObject);
    procedure btnGetStatusClick(Sender: TObject);
    procedure btnCreateWorkerClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure btnPublishMessageClick(Sender: TObject);
  private
    { Private-Deklarationen }
    fCLIResult: string;
    fPathToCLI: string;
    fBPMNFolder: string;
    FBINFolder: string;
    fAbort: Boolean;
    procedure setBPMNFolder(const Value: string);
    procedure SetBINFolder(const Value: string);
    procedure CallZeBeeCLI_Async(const aCommand, aPara: string);
    procedure CallZeBeeCLI(const aCommand, aPara: string);
    procedure LogText(const aText: string);

  public
    { Public-Deklarationen }
    ZeeBeCLI: string;
    property BPMNFolder: string read fBPMNFolder write setBPMNFolder;
    property BINFolder:string read FBINFolder write SetBINFolder;
  end;

var
  Form1: TForm1;

implementation
uses Winapi.ShellAPI,
   JclSysUtils;

{$R *.dfm}

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer; Handle:THandle = 0): THandle;
var
  aParams,aFileName: String;
  zFileName, zParams, zDir: array[0..259] of Char; //7.11.01 259Zeichen aus TFileRec SysUtils
  aHandle: THandle;
begin
  aParams := Params;
  aFileName := FileName;
{
  If (Params = '')
    then ParseExeFile(FileName,aFileName,aParams);
}
  if Handle=0
    then aHandle := Application.MainForm.Handle
    else aHandle := Handle;
  Result := ShellExecute(aHandle, nil,
    StrPCopy(zFileName, aFileName), StrPCopy(zParams, aParams),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

procedure TForm1.btnCreateWFInstanceClick(Sender: TObject);
Var ErrorMessage: string;
  aCommand: String;
begin
  aCommand :=
    Format('%sZBCtl.exe --insecure create instance %s'+
      ' --variables "{\"orderId\": %s, \"orderValue\": %s}"',
      [BINFolder,
       'order-process',
       medtOrderID.Text,
       medtAmount.Text]);
  mmoCLIResults.Lines.Add(format('COMMAND %s',[aCommand]));
  if JclSysUtils.Execute(
       aCommand,
       fCLIResult,
       ErrorMessage) = ERROR_SUCCESS
    then mmoCLIResults.Lines.Add(fCLIResult)
    else mmoCLIResults.Lines.Add(ErrorMessage)
end;

procedure TForm1.btnCreateWorkerClick(Sender: TObject);
 Var aCommand, aParas: String;
begin
{ aCommand := Format('create worker %s --handler "findstr .*"',[lbledtJobName.Text]); }
  aCommand := Format('create worker %s --handler "ZeeBeWorkerGeneric.exe"',[lbledtJobName.Text]);
  aParas := '';
  CallZeBeeCLI_Async(aCommand,aParas);
end;

procedure TForm1.btnDeployBPMFileClick(Sender: TObject);
Var ErrorMessage: string;
begin
  if JclSysUtils.Execute(
       Format('%sZBCtl.exe --insecure deploy  %s%s',
            [BINFolder,
             fBPMNFolder,
             'order-process.bpmn']),
             fCLIResult,
             ErrorMessage) = ERROR_SUCCESS
    then mmoCLIResults.Lines.Add(fCLIResult)
    else mmoCLIResults.Lines.Add(ErrorMessage);
end;

procedure TForm1.btnGetStatusClick(Sender: TObject);
Var ErrorMessage: string;
begin
  if JclSysUtils.Execute(
       Format('%sZBCtl.exe --insecure status',
            [BINFolder]),
             fCLIResult,
             ErrorMessage) = ERROR_SUCCESS
    then mmoCLIResults.Lines.Add(fCLIResult)
    else mmoCLIResults.Lines.Add(ErrorMessage);
end;

procedure TForm1.btnPublishMessageClick(Sender: TObject);
begin
  CallZeBeeCLI(Format('publish message "%s"',[lbledtMessage.Text]), Format('--correlationKey="%s"',[lbledtCorrKey.Text]));
end;

procedure TForm1.CallZeBeeCLI(const aCommand, aPara: string);
Var ErrorMessage: string;
  bCommand: String;

begin
  bCommand := Format('%sZBCtl.exe --insecure %s %s',
    [BINFolder, aCommand, aPara]);
 fAbort := False;
  mmoCLIResults.Lines.Add(format('COMMAND: %s',[bCommand]));
  if JclSysUtils.Execute(
       bCommand ,
       fCLIResult,
       ErrorMessage,
       False, False,
       @fAbort) = ERROR_SUCCESS
    then mmoCLIResults.Lines.Add(fCLIResult)
    else mmoCLIResults.Lines.Add(ErrorMessage)
end;

procedure TForm1.CallZeBeeCLI_Async(const aCommand, aPara: string);
Var ErrorMessage: string;
  bCommand, aParas: String;

begin
  bCommand := Format('%sZBCtl.exe --insecure %s %s',
    [BINFolder, aCommand, aPara]);
  mmoCLIResults.Lines.Add(format('COMMAND: %s',[bCommand]));
  fAbort := False;

  bCommand := Format('%sZBCtl.exe',
    [BINFolder]);
  aParas := Format('--insecure %s %s',
    [aCommand, aPara]);
   ExecuteFile(bCommand,aParas,BINFolder,SHOW_ICONWINDOW,Self.Handle);

end;

procedure TForm1.FormClick(Sender: TObject);
begin
  fAbort := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BPMNFolder := 'c:\Users\pmm\zeebe-docker-compose\bpmn\';
  BINFolder := 'c:\Users\pmm\zeebe-docker-compose\bin\';
end;

procedure TForm1.lbledtBPMNFileFolderDblClick(Sender: TObject);
begin
  if dlgBrowseForFolder.Execute(self.Handle)
    then BPMNFolder := dlgBrowseForFolder.Directory;
end;

procedure TForm1.LogText(const aText: string);
begin
   mmoCLIResults.Lines.Add(aText)
end;

procedure TForm1.SetBINFolder(const Value: string);
begin
  FBINFolder := Value;
  lbledtBINFolder.Text := Value;
end;

procedure TForm1.setBPMNFolder(const Value: string);
begin
  fBPMNFolder := Value;
  lbledtBPMNFileFolder.Text := Value;
end;

end.
