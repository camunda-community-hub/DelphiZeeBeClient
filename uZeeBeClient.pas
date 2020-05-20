unit uZeeBeClient;

interface

uses
  System.SysUtils, System.Classes,
  gateway_protocol.Proto, gateway_protocol.Client;

type
  EZeeBeError = class(Exception);
  ECompleteJobError = class(EZeeBeError);
  EDoJobError = class(EZeeBeError);
  EProcessMessageError = class(EZeeBeError);

Type
  TWorkerProc = procedure(JobInfo: TActivatedJob) of object;

  TdmZeeBeClient = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);

  private
    FClient: IGateway_Client;
    fServer: string;
    fPort: Integer;
    procedure SetPort(const Value: Integer);
    procedure SetServer(const Value: string);
    function GetTopologie: string;
    function GetClient: IGateway_Client;

  public
    property Server: string read FServer write SetServer;
    property Port: Integer read FPort write SetPort;
    property Client: IGateway_Client read GetClient;
    property Topology: string read GetTopologie;
    procedure RestartClient; //after port changed etc.

    Function DeployWorkflow(const ZeeBeFileName: string): string;
    Function StartCase(const BPMNID, CaseVars: String): UInt64; //Result: WFInstanceID
    procedure ActivateJob(const JobType: string; BusinessLogic: TWorkerProc;
      IsAutoComplete: Boolean);
    procedure CompleteJobRequest(JobKey: UInt64; const Variables: string = '');
    procedure PublishMessage(const aName, correlationKey: String; WFInstance: UInt64);
    procedure SetVariables(WFInstance: UInt64; const aVars: string; local: Boolean = false);

  end;

var
 ZeeBeClient: TdmZeeBeClient;

 function IZeeBeClient: IGateway_Client;

implementation
uses
  System.IOUtils, System.Threading,
  Superobject, Grijjy.ProtocolBuffers;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmZeeBeClient }

function IZeeBeClient: IGateway_Client;
begin
  if not Assigned(ZeeBeClient.fClient)
    then ZeeBeClient.fClient := TGateway_Client.Create(ZeeBeClient.Server, ZeeBeClient.Port);
  Result := ZeeBeClient.fClient;
end;

procedure TdmZeeBeClient.ActivateJob(const JobType: string;
  BusinessLogic: TWorkerProc; IsAutoComplete: Boolean);
var
  aActivateJobsRequest: TActivateJobsRequest;
begin
  aActivateJobsRequest._type := JobType;
  aActivateJobsRequest.worker := 'PMM';
  aActivateJobsRequest.timeout := 100000;
  aActivateJobsRequest.maxJobsToActivate := 10;
  aActivateJobsRequest.fetchVariable := []; {[] = all / [JobVars];}
  aActivateJobsRequest.requestTimeout := 10000;
  try
    Client.ActivateJobs(aActivateJobsRequest,
      procedure(const aResponse: TActivatedJobArray; const aHasData, aClosed: Boolean)
      begin
      TParallel.For(0, High(aResponse),
        procedure(I: Integer)
        var aRes: TActivatedJob;
        begin
          aRes := aResponse[I];
          BusinessLogic(aRes);  // >>> do the business logic <<<
          if IsAutoComplete
            then CompleteJobRequest(UInt64(aRes.Key));
        end);
      end);
  except
    on e: Exception do
      raise EDoJobError.CreateFmt('Error in ActivateJobs "%s": %s',[JobType,e.Message])
  end;
end;

procedure TdmZeeBeClient.CompleteJobRequest(JobKey: UInt64; const Variables: string);
var
  aCJob: TCompleteJobRequest;
begin
  aCJob.jobKey := UInt64(JobKey);
  aCJob.variables := Variables;
  try
    TGateway_Client.Create(FServer, FPort).CompleteJob(aCJob);
  except
    on E: EgoSerializationError do;
    on e: Exception do
       raise ECompleteJobError.CreateFmt('Exception in CompleteJobRequest(#%s): %s.',[JobKey,e.Message]);
  end;
end;

procedure TdmZeeBeClient.DataModuleCreate(Sender: TObject);
begin
  fServer := '127.0.0.1';
  fPort := 26500;
end;

Function TdmZeeBeClient.DeployWorkflow(const ZeeBeFileName: string): string;
var
  aWFRequest:TWorkflowRequestObject;
  aWFs: TWorkflowRequestObjectArray;
  aWFResponse: TDeployWorkflowResponse;

begin
  try
    aWFRequest.name := ZeeBeFileName;
    aWFRequest._type := BPMN;
    aWFRequest.definition := TFile.ReadAllBytes(aWFRequest.name);
    aWFs := [aWFRequest];
    aWFResponse := Client.DeployWorkflow(aWFs);
    RESULT := TSuperRttiContext.Create.AsJson<TDeployWorkflowResponse>(aWFResponse).AsJSon();
  except
    on e: exception
      do RESULT := e.Message;
  end;

end;

function TdmZeeBeClient.GetClient: IGateway_Client;
begin
  if not Assigned(fClient)
    then fClient := TGateway_Client.Create(self.Server, self.Port);
  Result := fClient;
end;

function TdmZeeBeClient.GetTopologie: string;
var aTR: TTopologyResponse;
begin
  aTR := IZeeBeClient.Topology();
  Result := TSuperRttiContext.Create.AsJson<TTopologyResponse>(aTR).AsJSon();
end;

procedure TdmZeeBeClient.PublishMessage(const aName, correlationKey: String;
  WFInstance: UInt64);
var aPMRequest: TPublishMessageRequest;
begin
  try
    aPMRequest.name := aName;
    aPMRequest.correlationKey := correlationKey;
    aPMRequest.timeToLive := 10000;
    aPMRequest.messageId := IntToStr(WFInstance);
    aPMRequest.variables := '';
    Client.PublishMessage(aPMRequest);
  except
    on E: EgoSerializationError do; //happens because of returned empty record type
    on E: Exception do raise EProcessMessageError.CreateFmt('Error in PublishMessage: %s',[E.Message]);
  end;
end;

procedure TdmZeeBeClient.RestartClient;
begin
  FClient := nil;
end;

procedure TdmZeeBeClient.SetPort(const Value: Integer);
begin
  if FPort <> Value
    then Begin
    RestartClient;
    FPort := Value;
    End;
end;

procedure TdmZeeBeClient.SetServer(const Value: string);
begin
  if FServer <> Value
    then Begin
    RestartClient;
    FServer := Value;
    End;
end;

procedure TdmZeeBeClient.SetVariables(WFInstance: UInt64; const aVars: string;
  local: Boolean);
var aRequest: TSetVariablesRequest;
begin
  try
    aRequest.elementInstanceKey := WFInstance;
    aRequest.variables := aVars;
    aRequest.local := local;
    Client.SetVariables(aRequest);
  except
    on E: EgoSerializationError do; //passiert, weil Rückgabe-Type ein leerer Record ist.
    on E: Exception do raise EProcessMessageError.CreateFmt('Error in SetMessage: %s',[E.Message]);
  end;
end;

function TdmZeeBeClient.StartCase(const BPMNID, CaseVars: String): UInt64;
var
  aWFIRequest: TCreateWorkflowInstanceRequest;
begin
  aWFIRequest.workflowKey := UInt64(-1); //-1 = NULL / must be casted to UInt
  aWFIRequest.bpmnProcessId := BPMNID;
  aWFIRequest.version := UInt32(-1);     //-1 = latest / must be casted to UInt
  aWFIRequest.variables := CaseVars;
  Result := Client.CreateWorkflowInstance(aWFIRequest).workflowInstanceKey;
end;

initialization

finalization

end.
