unit gateway_protocol.Client;

// This is a generated unit! Do NOT edit!

interface

uses Ultraware.Grpc.Client, gateway_protocol.Proto;

type
   TActivateJobsCallback = TProtoCallback<TActivatedJobArray>;

   IGateway_Client = interface
      procedure ActivateJobs(const aActivateJobsRequest: TActivateJobsRequest; const aActivateJobsCallback: TActivateJobsCallback);
      procedure CancelWorkflowInstance(const aworkflowInstanceKey: Int64);
      procedure CompleteJob(const aCompleteJobRequest: TCompleteJobRequest);
      function CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest): TCreateWorkflowInstanceResponse; overload;
{
      function CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest_N): TCreateWorkflowInstanceResponse; overload;
      function CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest_0): TCreateWorkflowInstanceResponse; overload;
}
      function CreateWorkflowInstanceWithResult(const aCreateWorkflowInstanceWithResultRequest: TCreateWorkflowInstanceWithResultRequest): TCreateWorkflowInstanceWithResultResponse;
      function DeployWorkflow(const aworkflows: TWorkflowRequestObjectArray): TDeployWorkflowResponse;
      procedure FailJob(const aFailJobRequest: TFailJobRequest);
      procedure PublishMessage(const aPublishMessageRequest: TPublishMessageRequest);
      procedure ResolveIncident(const aincidentKey: Int64);
      procedure SetVariables(const aSetVariablesRequest: TSetVariablesRequest);
{      function Topology(const aTopologyRequest: TTopologyRequest): TTopologyResponse; }
      function Topology(): TTopologyResponse;
      procedure UpdateJobRetries(const aUpdateJobRetriesRequest: TUpdateJobRetriesRequest);
   end;

   TGateway_Client = class(TBaseGrpcClient,IGateway_Client)
      procedure ActivateJobs(const aActivateJobsRequest: TActivateJobsRequest; const aActivateJobsCallback: TActivateJobsCallback);
      procedure CancelWorkflowInstance(const aworkflowInstanceKey: Int64);
      procedure CompleteJob(const aCompleteJobRequest: TCompleteJobRequest);
{
      function CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest_N): TCreateWorkflowInstanceResponse; overload;
      function CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest_0): TCreateWorkflowInstanceResponse; overload;
}
      function CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest): TCreateWorkflowInstanceResponse; overload;

      function CreateWorkflowInstanceWithResult(const aCreateWorkflowInstanceWithResultRequest: TCreateWorkflowInstanceWithResultRequest): TCreateWorkflowInstanceWithResultResponse;
      function DeployWorkflow(const aworkflows: TWorkflowRequestObjectArray): TDeployWorkflowResponse;
      procedure FailJob(const aFailJobRequest: TFailJobRequest);
      procedure PublishMessage(const aPublishMessageRequest: TPublishMessageRequest);
      procedure ResolveIncident(const aincidentKey: Int64);
      procedure SetVariables(const aSetVariablesRequest: TSetVariablesRequest);
{      function Topology(const aTopologyRequest: TTopologyRequest): TTopologyResponse;  }
      function Topology(): TTopologyResponse;
      procedure UpdateJobRetries(const aUpdateJobRetriesRequest: TUpdateJobRetriesRequest);
      function BasePath: string; override;
   end;

implementation

 { TGateway_Client }

function TGateway_Client.BasePath: string;
begin
   Result := '/gateway_protocol.Gateway/';
end;

procedure TGateway_Client.ActivateJobs(const aActivateJobsRequest: TActivateJobsRequest; const aActivateJobsCallback: TActivateJobsCallback);
var SubCallback: TProtoCallback<TActivateJobsResponse>;
begin
   SubCallback := procedure(const aInput: TActivateJobsResponse; const aHasData, aClosed: Boolean)
      begin
         aActivateJobsCallback(aInput.jobs, aHasData, aClosed);
      end;
   DoOuputStreamRequest<TActivateJobsRequest,TActivateJobsResponse>(aActivateJobsRequest, 'ActivateJobs', SubCallback);
end;

procedure TGateway_Client.CancelWorkflowInstance(const aworkflowInstanceKey: Int64);
var CancelWorkflowInstanceRequest_In: TCancelWorkflowInstanceRequest;
begin
   CancelWorkflowInstanceRequest_In.workflowInstanceKey := aworkflowInstanceKey;
   DoRequest<TCancelWorkflowInstanceRequest,TCancelWorkflowInstanceResponse>(CancelWorkflowInstanceRequest_In, 'CancelWorkflowInstance');
end;

procedure TGateway_Client.CompleteJob(const aCompleteJobRequest: TCompleteJobRequest);
begin
   DoRequest<TCompleteJobRequest,TCompleteJobResponse>(aCompleteJobRequest, 'CompleteJob');
end;

{
function TGateway_Client.CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest_N): TCreateWorkflowInstanceResponse;
begin
   Result := DoRequest<TCreateWorkflowInstanceRequest_N,TCreateWorkflowInstanceResponse>(aCreateWorkflowInstanceRequest, 'CreateWorkflowInstance');
end;

function TGateway_Client.CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest_0): TCreateWorkflowInstanceResponse;
begin
   Result := DoRequest<TCreateWorkflowInstanceRequest_0,TCreateWorkflowInstanceResponse>(aCreateWorkflowInstanceRequest, 'CreateWorkflowInstance');
end;
}
function TGateway_Client.CreateWorkflowInstance(const aCreateWorkflowInstanceRequest: TCreateWorkflowInstanceRequest): TCreateWorkflowInstanceResponse;
begin
   Result := DoRequest<TCreateWorkflowInstanceRequest,TCreateWorkflowInstanceResponse>(aCreateWorkflowInstanceRequest, 'CreateWorkflowInstance');
end;

function TGateway_Client.CreateWorkflowInstanceWithResult(const aCreateWorkflowInstanceWithResultRequest: TCreateWorkflowInstanceWithResultRequest): TCreateWorkflowInstanceWithResultResponse;
begin
   Result := DoRequest<TCreateWorkflowInstanceWithResultRequest,TCreateWorkflowInstanceWithResultResponse>(aCreateWorkflowInstanceWithResultRequest, 'CreateWorkflowInstanceWithResult');
end;

function TGateway_Client.DeployWorkflow(const aworkflows: TWorkflowRequestObjectArray): TDeployWorkflowResponse;
var DeployWorkflowRequest_In: TDeployWorkflowRequest;
begin
   DeployWorkflowRequest_In.workflows := aworkflows;
   Result := DoRequest<TDeployWorkflowRequest,TDeployWorkflowResponse>(DeployWorkflowRequest_In, 'DeployWorkflow');
end;

procedure TGateway_Client.FailJob(const aFailJobRequest: TFailJobRequest);
begin
   DoRequest<TFailJobRequest,TFailJobResponse>(aFailJobRequest, 'FailJob');
end;

procedure TGateway_Client.PublishMessage(const aPublishMessageRequest: TPublishMessageRequest);
begin
   DoRequest<TPublishMessageRequest,TPublishMessageResponse>(aPublishMessageRequest, 'PublishMessage');
end;

procedure TGateway_Client.ResolveIncident(const aincidentKey: Int64);
var ResolveIncidentRequest_In: TResolveIncidentRequest;
begin
   ResolveIncidentRequest_In.incidentKey := aincidentKey;
   DoRequest<TResolveIncidentRequest,TResolveIncidentResponse>(ResolveIncidentRequest_In, 'ResolveIncident');
end;

procedure TGateway_Client.SetVariables(const aSetVariablesRequest: TSetVariablesRequest);
begin
   DoRequest<TSetVariablesRequest,TSetVariablesResponse>(aSetVariablesRequest, 'SetVariables');
end;

function TGateway_Client.Topology({const aTopologyRequest: TTopologyRequest}): TTopologyResponse;
begin
{   Result := DoRequest<TTopologyRequest,TTopologyResponse>(aTopologyRequest, 'Topology'); }
   Result := DoRequestNoInput<TTopologyResponse>('Topology');
end;

procedure TGateway_Client.UpdateJobRetries(const aUpdateJobRetriesRequest: TUpdateJobRetriesRequest);
begin
   DoRequest<TUpdateJobRetriesRequest,TUpdateJobRetriesResponse>(aUpdateJobRetriesRequest, 'UpdateJobRetries');
end;

end.
