unit uZeeBeTestGRPC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Mask, JvExMask,
  JvToolEdit, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls,
  gateway_protocol.Proto,
  uZeeBeClient;

type
  TfrmZeeBeTestgRPC = class(TForm)
    pnlZeeBeConnection: TPanel;
    lbledtServer: TLabeledEdit;
    lbledtPort: TLabeledEdit;
    btnGetTopology: TButton;
    pnlNsvBrowser: TPanel;
    edtZeeBeURL: TEdit;
    btnShowInDefaultBrowser: TButton;
    pnlWorkFlow: TPanel;
    edFileNameBPMN: TJvFilenameEdit;
    btnDeployWorkFlow: TButton;
    lbledtBPMNID: TLabeledEdit;
    pnlWFInstance: TPanel;
    spl1: TSplitter;
    mmoLOG: TMemo;
    pnlZeeBeGUI: TPanel;
    spl2: TSplitter;
    pnlWFITree: TPanel;
    grpCase: TGroupBox;
    lblCaseVar: TLabel;
    btnStartNewCase: TButton;
    lbledtCaseID: TLabeledEdit;
    stgrdCaseVars: TStringGrid;
    grpActivity: TGroupBox;
    lbl1: TLabel;
    btnActivateJob: TButton;
    btnCompleteJob: TButton;
    btnPublishMessage: TButton;
    cbbJobName: TComboBox;
    lbledtJobID: TLabeledEdit;
    lbledtMessageKey: TLabeledEdit;
    lbledtMessage: TLabeledEdit;
    stgrdJobVars: TStringGrid;
    chkAutoComplete: TCheckBox;
    btnSetVariables: TButton;
    lbledtWorkFlowId: TLabeledEdit;
    tvWorkFlow: TTreeView;
    procedure btnGetTopologyClick(Sender: TObject);
    procedure btnShowInDefaultBrowserClick(Sender: TObject);
    procedure btnDeployWorkFlowClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbledtPortChange(Sender: TObject);
    procedure lbledtServerChange(Sender: TObject);
    procedure btnStartNewCaseClick(Sender: TObject);
    procedure btnActivateJobClick(Sender: TObject);
    procedure btnCompleteJobClick(Sender: TObject);
    procedure btnPublishMessageClick(Sender: TObject);
    procedure btnSetVariablesClick(Sender: TObject);

  private
    procedure WriteToMemo(const aText: string);
    function GetVarsFromStrGrid(const aStrGrid: TStringGrid): String;
    function GetWFTreeNodeByID(aKey: UInt64): TTreeNode;
    function CurrWFInstance: UInt64;

    procedure DeployWorkflow;
    procedure StartNewCase;
    procedure SetWFVariables(const aVars: String);

    procedure GUIUpdateJob(aJobResponse: TActivatedJob);
    procedure DoJob(JobInfo: TActivatedJob);

  public
    { Public-Deklarationen }
  end;

var
  frmZeeBeTestgRPC: TfrmZeeBeTestgRPC;

implementation
uses
  Winapi.ShellAPI,
  Superobject;

{$R *.dfm}

procedure TfrmZeeBeTestgRPC.btnActivateJobClick(Sender: TObject);
var aJobName: string;
begin
  WriteToMemo('Create Job...');
  aJobName := cbbJobName.Text;
  WriteToMemo(Format('JOB: %s',[aJobName]));
  ZeeBeClient.ActivateJob(aJobName,DoJob,chkAutoComplete.Checked);
  WriteToMemo('Create Job done.');
end;

procedure TfrmZeeBeTestgRPC.btnCompleteJobClick(Sender: TObject);
begin
  WriteToMemo('Completing JOB...');
  try
    ZeeBeClient.CompleteJobRequest(StrToUInt64(lbledtJobID.Text));
  except
    on e: Exception do WriteToMemo('Error in CompleteJob: '+E.Message)
  end;
  WriteToMemo('Complete JOB done.');
end;

procedure TfrmZeeBeTestgRPC.btnDeployWorkFlowClick(Sender: TObject);
begin
  WriteToMemo('Deploy Workflow...');
  DeployWorkflow;
  WriteToMemo('Deploy WF done');
end;

procedure TfrmZeeBeTestgRPC.btnGetTopologyClick(Sender: TObject);
var aStr: String;
begin
  WriteToMemo('Get Topology...');
  aSTR := ZeeBeClient.Topology;
  WriteToMemo(aStr);
  WriteToMemo('Topology DONE');
end;


procedure TfrmZeeBeTestgRPC.btnPublishMessageClick(Sender: TObject);
var aPMRequest: TPublishMessageRequest;
  CaseNode, MsgNode: TTreeNode;
begin
  WriteToMemo('Publishing message...');
  try
    ZeeBeClient.PublishMessage(
      lbledtMessage.Text,
      lbledtMessageKey.Text,
      CurrWFInstance);
    WriteToMemo(Format('MESSAGE: %s, Key: %s',[lbledtMessage.Text, lbledtMessageKey.Text]));

    //Update WF-Tree
    tvWorkFlow.Items.BeginUpdate;
    CaseNode := GetWFTreeNodeByID(CurrWFInstance);
    MsgNode := tvWorkFlow.Items.AddChild(CaseNode,'');
    MsgNode.Text := Format('MESSAGE: %s, CorrelitionKey: %s)',
      [lbledtMessageKey.Text, lbledtMessageKey.Text]);
    MsgNode.Data := NIL;
    tvWorkFlow.Items.EndUpdate;
    tvWorkFlow.Items[0].Expand(true);
  except
    on E: Exception do
      WriteToMemo('Error in PublishMessage: '+E.Message)
  end;
  WriteToMemo('Publishing message done.');
end;

procedure TfrmZeeBeTestgRPC.btnSetVariablesClick(Sender: TObject);
var aVars: string;
begin
  WriteToMemo('Set variables...');
  aVars := '{'+GetVarsFromStrGrid(stgrdJobVars)+'}';
  SetWFVariables(aVars);
  WriteToMemo('Set variables done.');
end;

procedure TfrmZeeBeTestgRPC.btnShowInDefaultBrowserClick(Sender: TObject);
var URL: string;
begin
  URL := edtZeeBeURL.Text;
  ShellExecute(0,'open',PChar(URL),nil,nil, SW_SHOWNORMAL);
end;

procedure TfrmZeeBeTestgRPC.btnStartNewCaseClick(Sender: TObject);
begin
  WriteToMemo('Start new WF-Instance running...');
  StartNewCase;
  WriteToMemo('Start new WF-Instance done.');
end;

function TfrmZeeBeTestgRPC.CurrWFInstance: UInt64;
begin
  Result := StrToUInt64(lbledtCaseID.Text);
end;

procedure TfrmZeeBeTestgRPC.DeployWorkflow;
var aStr, bpmnProcessId: string;
  workflowKey: UInt64;
  aNode: TTreeNode;
begin
  aStr := ZeeBeClient.DeployWorkflow(edFileNameBPMN.FileName);
  WriteToMemo(aStr);
  if not Assigned(SO(aStr).A['workflows'].O[0])
    then Begin
    WriteToMemo('Response is empty in DeployWorkflow');
    Exit;
    end;

  workflowKey := SO(aStr).A['workflows'].O[0].I['workflowKey'];
  bpmnProcessId := SO(aStr).A['workflows'].O[0].S['bpmnProcessId'];
  lbledtWorkFlowId.Text := workflowKey.ToString;
  lbledtBPMNID.Text := bpmnProcessId;

  tvWorkFlow.Items.BeginUpdate;
  tvWorkFlow.Items.Clear;
  aNode := tvWorkFlow.Items.AddChildFirst(nil,'');
  aNode.Text := Format('BPMN ID: "%s" - #%d',
    [bpmnProcessId,
     workflowKey]);
  aNode.Data := Pointer(workflowKey);
  tvWorkFlow.Items.EndUpdate;
  tvWorkFlow.Items[0].Expand(true);
  btnStartNewCase.Enabled := true;
end;

procedure TfrmZeeBeTestgRPC.DoJob(JobInfo: TActivatedJob);
begin
   GUIUpdateJob(JobInfo);
end;

procedure TfrmZeeBeTestgRPC.FormActivate(Sender: TObject);
begin
  //Values for ZeeBe testcase "BPM Order-Process "
  stgrdCaseVars.Cells[0,0] := 'Name';
  stgrdCaseVars.Cells[1,0] := 'Value';
  stgrdCaseVars.Cells[0,1] := 'orderId';
  stgrdCaseVars.Cells[1,1] := '123456';
  stgrdCaseVars.Cells[0,2] := 'orderValue';
  stgrdCaseVars.Cells[1,2] := '199';
  stgrdJobVars.Cells[0,0] := 'Name';
  stgrdJobVars.Cells[1,0] := 'Value';
  stgrdJobVars.Cells[0,1] := 'orderId';
  stgrdJobVars.Cells[1,1] := '234567';
  stgrdJobVars.Cells[0,2] := 'orderValue';
  stgrdJobVars.Cells[1,2] := '50';
end;

procedure TfrmZeeBeTestgRPC.FormCreate(Sender: TObject);
begin
  ZeeBeClient.Port := StrToIntDef(lbledtPort.Text,26500); {use port 58772 for testing with grpc-dump}
  ZeeBeClient.Server := lbledtServer.Text;
end;

procedure TfrmZeeBeTestgRPC.lbledtPortChange(Sender: TObject);
begin
  ZeeBeClient.Port := StrToIntDef(lbledtPort.Text,ZeeBeClient.Port);
end;

procedure TfrmZeeBeTestgRPC.lbledtServerChange(Sender: TObject);
begin
  ZeeBeClient.Server := lbledtServer.Text;
end;

procedure TfrmZeeBeTestgRPC.SetWFVariables(const aVars: String);
var
  aSVR: TSetVariablesRequest;
  CaseNode, aNode: TTreeNode;
begin
  try
    ZeeBeClient.SetVariables(CurrWFInstance,aVars);
    WriteToMemo(Format('SETVARIABLES: %s',[aVars]));
    tvWorkFlow.Items.BeginUpdate;
    CaseNode := GetWFTreeNodeByID(CurrWFInstance);
    aNode := tvWorkFlow.Items.AddChild(CaseNode,'');
    aNode.Text := Format('VARIABLES: %s)',[aVars]);
    aNode.Data := NIL;
    tvWorkFlow.Items.EndUpdate;
    tvWorkFlow.Items[0].Expand(true);
  except
    on e: Exception do
      WriteToMemo(Format('Exception in SetWFVariables: %s ', [e.Message]));
  end;
end;

procedure TfrmZeeBeTestgRPC.StartNewCase;
var
  aVars: string;
  aWFInstanceID: UInt64;
  aCaseNode: TTreeNode;
begin
  try
    aVars := '{' + GetVarsFromStrGrid(stgrdCaseVars) + '}';
    aWFInstanceID := ZeeBeClient.StartCase(lbledtBPMNID.Text,aVars);
    lbledtCaseID.Text := aWFInstanceID.ToString;
    WriteToMemo(Format('New workflow instance (alias case): #%d ruinnig, CaseVars: %s', [aWFInstanceID, aVars]));
    tvWorkFlow.Items.BeginUpdate;
    aCaseNode := tvWorkFlow.Items.AddChildFirst(tvWorkFlow.TopItem, Format('WORK FLOW Instance: #%d', [aWFInstanceID]));
    aCaseNode.Data := Pointer(aWFInstanceID);
    tvWorkFlow.Items.EndUpdate;
  except
    on e: Exception do
      WriteToMemo(Format('Exception in StartCase: %s ', [e.Message]));
  end;
end;

procedure TfrmZeeBeTestgRPC.WriteToMemo(const aText: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      mmoLog.Lines.Add(aText);
      Application.ProcessMessages;
    end);
end;

function TfrmZeeBeTestgRPC.GetVarsFromStrGrid (const aStrGrid: TStringGrid): String;
var
  aVariables: string;
  I: Integer;
begin
  aVariables := '';
  for I := 1 to aStrGrid.RowCount - 1
    do begin
    if aStrGrid.Cells[0, I] <> ''
      then begin
      if aVariables <> ''
        then aVariables := aVariables + ',';
       aVariables := aVariables + format('"%s": %s', //values enclosed in " "?
             [aStrGrid.Cells[0, I], aStrGrid.Cells[1, I]]);
      end;
    end;
  Result :=  aVariables;
end;


function TfrmZeeBeTestgRPC.GetWFTreeNodeByID(aKey: UInt64): TTreeNode;
var I: Integer;
begin
  if Assigned(tvWorkFlow.Selected)
     and( tvWorkFlow.Selected.Data = Pointer(aKey))
    then Result := tvWorkFlow.Selected
    else begin
    Result := NIL;
    for I := 0 to tvWorkFlow.Items.Count - 1 do
      begin
      if tvWorkFlow.Items[I].Data = Pointer(aKey) then
        begin
        Result := tvWorkFlow.Items[I];
        tvWorkFlow.Selected := Result;
        break;
        end;
      end;
    if not Assigned(Result)
      then begin
      Result :=
        tvWorkFlow.Items.Add(tvWorkFlow.Items[0],Format('UNKNOWN Instance: %d',[aKey]));
      Result.Data := Pointer(aKey);
      end;
    end
end;

procedure TfrmZeeBeTestgRPC.GUIUpdateJob(aJobResponse: TActivatedJob);
var CaseNode, ActivityNode: TTreeNode;
begin
  TThread.Queue(nil,
    procedure
    begin
      try
        lbledtJobID.Text := aJobResponse.Key.ToString;
        WriteToMemo('JOB-RESPONSE:');
        WriteToMemo(TSuperRttiContext.Create.AsJson<TActivatedJob>(aJobResponse).AsJSon());
        //Update WF-Tree
        tvWorkFlow.Items.BeginUpdate;
        CaseNode := GetWFTreeNodeByID(aJobResponse.workflowInstanceKey);
        ActivityNode := tvWorkFlow.Items.AddChild(CaseNode,'');
        ActivityNode.Text := Format('JOB: %s Headers: %s, Variables: %s)',
          [aJobResponse._type , aJobResponse.customHeaders, aJobResponse.variables]);
        ActivityNode.Data := Pointer(aJobResponse.key);
        tvWorkFlow.Items.EndUpdate;
        tvWorkFlow.Items[0].Expand(true);
      except
       on e: Exception do
          WriteToMemo(Format('Exception in DoJob: %s ', [e.Message]))
          end;
    end
    );
end;

end.
