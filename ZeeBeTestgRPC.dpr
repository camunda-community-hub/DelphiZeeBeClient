program ZeeBeTestgRPC;

uses
  Vcl.Forms,
  uZeeBeTestGRPC in 'uZeeBeTestGRPC.pas' {frmZeeBeTestgRPC},
  Grijjy.Http2 in '..\DelphiGrpc\gRPC\Grijjy.Http2.pas',
  Ultraware.Grpc.Client in '..\DelphiGrpc\gRPC\Ultraware.Grpc.Client.pas',
  Ultraware.Grpc in '..\DelphiGrpc\gRPC\Ultraware.Grpc.pas',
  Superobject in '..\Superobject.pas',
  gateway.Proto in 'gateway.Proto.pas',
  gateway_protocol.Client in 'gateway_protocol.Client.pas',
  gateway_protocol.Proto in 'gateway_protocol.Proto.pas',
  uZeeBeClient in 'uZeeBeClient.pas' {dmZeeBeClient: TDataModule},
  Grijjy.Http in '..\DelphiGrpc\GrijjyFoundation\Grijjy.Http.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TZeeBeClient, ZeeBeClient);
  Application.CreateForm(TfrmZeeBeTestgRPC, frmZeeBeTestgRPC);
  Application.Run;
end.
