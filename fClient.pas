unit fClient;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  gateway.Proto, gateway_protocol.Client, gateway_protocol.Proto, FMX.Effects,
  FMX.Filter.Effects, FMX.Edit, FMX.Layouts, FMX.TreeView;

type
  TfrmClient = class(TForm)
    Memo1: TMemo;
    btnTopology: TButton;
    btnCreateWFInstance: TButton;
    lblServer: TLabel;
    edtServer: TEdit;
    edtPort: TEdit;
    lblPort: TLabel;
    MaskToAlphaEffect1: TMaskToAlphaEffect;
    dlgOpenBPMNFile: TOpenDialog;
    edtBPMFile: TEdit;
    lblBMPFile: TLabel;
    edtProcessID: TEdit;
    lblProcessID: TLabel;
    edtOrderID: TEdit;
    lblOrderID: TLabel;
    lblAmount: TLabel;
    edtAmount: TEdit;
    btnCreateJob: TButton;
    edtJobName: TEdit;
    lblJobName: TLabel;
    lblJob2: TLabel;
    edtMessage: TEdit;
    lblMessage: TLabel;
    btnPublishMessage: TButton;
    edtKey: TEdit;
    lblKey: TLabel;
    btnDeploy: TButton;
    btnCompleteJob: TButton;
    edtJobID: TEdit;
    lblJobID: TLabel;
    tvWorkFlow: TTreeView;
    lblWorkFlow: TLabel;
    edtWFInstanceKey: TEdit;
    lblWFInstance: TLabel;
    trviRoot: TTreeViewItem;
    procedure btnTopologyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCreateWFInstanceClick(Sender: TObject);
    procedure edtPortChange(Sender: TObject);
    procedure edtServerChange(Sender: TObject);
    procedure edtBPMFileDblClick(Sender: TObject);
    procedure edtPortValidate(Sender: TObject; var Text: string);
    procedure edtAmountValidate(Sender: TObject; var Text: string);
    procedure btnDeployClick(Sender: TObject);
    procedure btnCreateJobClick(Sender: TObject);
    procedure btnCompleteJobClick(Sender: TObject);
    procedure btnPublishMessageClick(Sender: TObject);

  private
    FServer: String;
    FPort: Integer;
    FClient: IGateway_Client;
    procedure Log(const aText: string);
    procedure UpDateJobs(const aResponse: TActivatedJobArray);
    procedure CreateClient;
  end;

var
  frmClient: TfrmClient;

implementation

uses
  System.IOUtils, IdURI, System.Net.HttpClient,
  JclSysInfo,
  SuperObject,
  Ultraware.Grpc,
  Grijjy.Http, Grijjy.ProtocolBuffers;

{$R *.fmx}

procedure TfrmClient.FormCreate(Sender: TObject);
begin
// FClient := TGateway_Client.Create('localhost',26500);
// Use grpc-dump:
// c:\Users\pmm\gRPC-Tools\grpc-dump --destination 127.0.0.1:26500 --port=58772

  FPort := StrToIntDef(edtPort.Text,58772); {58772: test mit grpc-dump}
  FServer := edtServer.Text;
  CreateClient;
end;

procedure TfrmClient.Log(const aText: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      Memo1.Lines.Add(aText);
      Application.ProcessMessages;
    end);
end;

procedure TfrmClient.UpDateJobs(const aResponse: TActivatedJobArray);
Var
  aTvItem: TTreeViewItem;
Begin
  TThread.Queue(nil,
    procedure
    begin
      if High(aResponse) > -1
        then begin
          edtJobID.Text := aResponse[0].Key.ToString;
          tvWorkFlow.BeginUpdate;
          aTvItem := TTreeViewItem.Create(self);
          aTvItem.Text := Format('JOB Item#: %d (WF-Instance#: %d) Worker: %s)',
            [aResponse[0].key , aResponse[0].workflowInstanceKey,aResponse[0].worker]);
          aTvItem.Parent := tvWorkFlow.Items[0].Items[0];
          tvWorkFlow.EndUpdate;
          tvWorkFlow.ExpandAll;
        end
        else edtJobID.Text := '-1';
    end);
End;

procedure TfrmClient.CreateClient;
begin
  FClient := TGateway_Client.Create(FServer, FPort);
end;

procedure TfrmClient.btnCreateJobClick(Sender: TObject);
(*
   TActivateJobsRequest = record
      [Serialize(1)] _type: string;
      [Serialize(2)] worker: string;
      [Serialize(3)] timeout: Int64;
      [Serialize(4)] maxJobsToActivate: Integer;
      [Serialize(5)] fetchVariable: TStringArray;
      [Serialize(6)] requestTimeout: Int64;
   end;
   TActivateJobsRequestArray =  Array of TActivateJobsRequest;

   TActivatedJob = record
      [Serialize(1)] key: Int64;
      [Serialize(2)] _type: string;
      [Serialize(3)] workflowInstanceKey: Int64;
      [Serialize(4)] bpmnProcessId: string;
      [Serialize(5)] workflowDefinitionVersion: Integer;
      [Serialize(6)] workflowKey: Int64;
      [Serialize(7)] elementId: string;
      [Serialize(8)] elementInstanceKey: Int64;
      [Serialize(9)] customHeaders: string;
      [Serialize(10)] worker: string;
      [Serialize(11)] retries: Integer;
      [Serialize(12)] deadline: Int64;
      [Serialize(13)] variables: string;
   end;
   TActivatedJobArray =  Array of TActivatedJob;

   TActivateJobsResponse = record
      [Serialize(1)] jobs: TActivatedJobArray;
   end;

   TProtoCallback<T> = reference to procedure(const aInput: T; const aHasData, aClosed: Boolean);
   TActivateJobsCallback = TProtoCallback<TActivatedJobArray>;

   procedure ActivateJobs(const aActivateJobsRequest: TActivateJobsRequest; const aActivateJobsCallback: TActivateJobsCallback);
*)
var
  aActivateJobsRequest: TActivateJobsRequest;
  aFetchVars: string;

  aTvItem: TTreeViewItem;

begin
  Log('Create Job...');

  aActivateJobsRequest._type := edtJobName.Text; { 'initiate-payment' ;}
  aActivateJobsRequest.worker := GetLocalComputerName;
  aActivateJobsRequest.timeout := 10000;
  aActivateJobsRequest.maxJobsToActivate := 1;
  aFetchVars := string.format('"orderId": "%s","orderValue": %s',
    [edtOrderID.Text, edtAmount.Text]);
  aActivateJobsRequest.fetchVariable := [aFetchVars];
  aActivateJobsRequest.requestTimeout := 10000;

  try
    FClient.ActivateJobs(aActivateJobsRequest,
      procedure(const aResponse: TActivatedJobArray; const aHasData, aClosed: Boolean)
      begin
      Log(TSuperRttiContext.Create.AsJson<TActivatedJobArray>(aResponse).AsJSon());
      UpDateJobs(aResponse);
      end
    );

  except
    on e: Exception do
      Log('Error in ActivateJobs: '+E.Message)
  end;
  Log('Create Job done.');
end;

procedure TfrmClient.btnDeployClick(Sender: TObject);
var
  aWFRequest:TWorkflowRequestObject;
  aWFs: TWorkflowRequestObjectArray;
  aWFResponse: TDeployWorkflowResponse;
  aTvItem: TTreeViewItem;

begin
  Log('Deploy Workflow...');
  try
    aWFRequest.name := edtProcessID.Text;
    aWFRequest._type := BPMN;
    aWFRequest.definition := TFile.ReadAllBytes(edtBPMFile.Text);
    aWFs := [aWFRequest];
    aWFResponse := FClient.DeployWorkflow(aWFs);

    Log(TSuperRttiContext.Create.AsJson<TDeployWorkflowResponse>(aWFResponse).AsJSon());

    tvWorkFlow.BeginUpdate;
    tvWorkFlow.Clear;
    aTvItem := TTreeViewItem.Create(self);
    aTvItem.Text := Format('BPMN ID: "%s" - Key: %d',
      [aWFResponse.workflows[0].bpmnProcessId,
       aWFResponse.workflows[0].workflowKey]);
    aTvItem.Parent := tvWorkFlow;
    tvWorkFlow.EndUpdate;
    tvWorkFlow.ExpandAll;

  except
    on e: Exception do
      Log('Error in Deploy WorkFlow: '+E.Message);
  end;

  Log('Deploy WF done');
end;

procedure TfrmClient.btnPublishMessageClick(Sender: TObject);
{
   TPublishMessageRequest = record
      [Serialize(1)] name: string;
      [Serialize(2)] correlationKey: string;
      [Serialize(3)] timeToLive: Int64;
      [Serialize(4)] messageId: string;
      [Serialize(5)] variables: string;
   end;
}
var aPMRequest: TPublishMessageRequest;
begin
  Log('Publishing message...');
  try
    aPMRequest.name := edtMessage.Text;
    aPMRequest.correlationKey := edtOrderID.Text; {'initiate-payment';} //OrderID
    aPMRequest.timeToLive := 10000;
    aPMRequest.messageId := edtWFInstanceKey.Text; { '2251799813685292';} //WF Instance-Key
    aPMRequest.variables := '';
    FClient.PublishMessage(aPMRequest);
  except
    on E: EgoSerializationError do; //passiert, weil Rückgabe-Type ein leerer Record ist.
    on E: Exception do
      Log('Error in PublishMessage: '+E.Message)
  end;
  Log('Publishing message done.');
end;

procedure TfrmClient.btnTopologyClick(Sender: TObject);
var aTR: TTopologyResponse;
begin
  Log('Get Topology...');

  aTR := FClient.Topology();
  Log(TSuperRttiContext.Create.AsJson<TTopologyResponse>(aTR).AsJSon());

  Log('Topology DONE');
end;

procedure TfrmClient.btnCompleteJobClick(Sender: TObject);
var aJob: TCompleteJobRequest;
begin
  Log('Completing JOB...');
  try
    aJob.jobKey := StrToUInt64(edtJobID.Text);
    aJob.variables := string.format('{"orderId": "%s","orderValue": %s}',
      [edtOrderID.Text, edtAmount.Text]);
    FClient.CompleteJob(aJob);
  except
    on E: EgoSerializationError do; //passiert, weil Rückgabe-Type ein leerer Record ist.
    on e: Exception do
      Log('Error in CompleteJob: '+E.Message)
  end;
  Log('Complete JOB done.');
end;

procedure TfrmClient.btnCreateWFInstanceClick(Sender: TObject);
var
  aWFIRequest: TCreateWorkflowInstanceRequest;
  aWFIResponse: TCreateWorkflowInstanceResponse;
  aTvItem: TTreeViewItem;

begin
  Log('Creating Workflow-Instance...');
  aWFIRequest.workflowKey := UInt32(-1);
  aWFIRequest.bpmnProcessId := edtProcessID.Text; {'order-process'}
  aWFIRequest.version := UInt64(-1);
  aWFIRequest.variables := Format('{"orderId": "%s", "orderValue": %s}',
    [edtOrderID.Text,edtAmount.Text]);
  try
    aWFIResponse := FClient.CreateWorkflowInstance(aWFIRequest);
    Log(TSuperRttiContext.Create.AsJson<TCreateWorkflowInstanceResponse >(aWFIResponse).AsJSon());

    tvWorkFlow.BeginUpdate;
    aTvItem := TTreeViewItem.Create(self);
    aTvItem.Text := Format('WORK FLOW Instance#: %d (WF-Key: %d)',
      [aWFIResponse.workflowInstanceKey, aWFIResponse.workflowKey]);
{   aTvItem.Data := aWFIResponse.workflowInstanceKey;     }
    edtWFInstanceKey.Text := aWFIResponse.workflowInstanceKey.ToString;
    aTvItem.Parent := tvWorkFlow.Items[0];
    tvWorkFlow.EndUpdate;

  except
    on e: Exception do
      Log('Error in CreateWorkflowInstance: '+E.Message);
  end;
end;

procedure TfrmClient.edtAmountValidate(Sender: TObject; var Text: string);
var I: Integer;
begin
  if not TryStrToInt(Text,I)
    then Text := '99';
end;

procedure TfrmClient.edtBPMFileDblClick(Sender: TObject);
var aStr: string;
 I: Integer;
begin
  If dlgOpenBPMNFile.Execute
    then Begin
    edtBPMFile.Text := dlgOpenBPMNFile.FileName;
    aStr := ExtractFileName(edtBPMFile.Text);
    I := aStr.LastDelimiter('.');
    edtProcessID.Text := aStr.SubString(0,I);
    End;
end;

procedure TfrmClient.edtPortChange(Sender: TObject);
var I: Integer;
begin
  I := StrToIntDef(edtPort.Text,FPort);
  if I <> FPort
     then begin
     FPort := I;
     CreateClient;
     end;
end;

procedure TfrmClient.edtPortValidate(Sender: TObject; var Text: string);
var I: Integer;
begin
  if not TryStrToInt(Text,I)
    then Text := IntToStr(FPort);

end;

procedure TfrmClient.edtServerChange(Sender: TObject);
begin
  FServer := edtServer.Text;
  CreateClient;
end;

end.
