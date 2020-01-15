program ZeeBeTestClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Superobject in 'C:\Delphi\DelphiGrpc\Demos\SimpleDemo\delphi\Superobject.pas',
  fClient in 'fClient.pas' {frmClient},
  Ultraware.Grpc in 'C:\Delphi\DelphiGrpc\gRPC\Ultraware.Grpc.pas',
  Grijjy.Http2 in 'C:\Delphi\DelphiGrpc\gRPC\Grijjy.Http2.pas',
  gateway.Proto in 'gateway.Proto.pas',
  gateway_protocol.Client in 'gateway_protocol.Client.pas',
  gateway_protocol.Proto in 'gateway_protocol.Proto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmClient, frmClient);
  Application.Run;
end.
