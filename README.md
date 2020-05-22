# DelphiZeeBeClient
Delphi client for ZeeBe gRPC interface
The client interface is based on DelphiGRPC (see: https://github.com/ultraware/DelphiGrpc) which in turn uses the Grijjy.Http Lib.
Remark:
In order to read BPMN-files longer than BUFFER_SIZE = 32768 Grijjy.Http.pas needs a fix in function TThreadSafeBuffer.Read around line #684 
```delphi 
//        Move(FBuffer[Size], FBuffer[0], FSize - ALength); BUG: read behind buffer!
        Move(FBuffer[ALength], FBuffer[0], FSize - ALength); {PMM 29.04.2020: here is the next portion!}
``` 
The initial code for units "gateway_protocol.Client" and "gateway_protocol.Proto.pas" where generated using the DelphiGrpc Tool "ProtoBufGenerator.exe". However, the generated code needs some modifications:
 - Int64 has to be changed to UInt64
 - empty record needs to be removed (TTopologyRequest so far)
 - Delphi reserved identifiers (FILE, type) has to be renamed
The header part of the units for more details.

# Examples
Includes three test projects:
- ZeeBeTestCLI uses the command line interface to communicate to ZeeBe
- ZeeBeTestClient uses the gRPC interface directly. The test workflow is "order-process.bpmn" used in zeebe-tutorial(https://docs.zeebe.io/getting-started/tutorial-setup.html)
- ZeeBeTestgRPC is a more generic client build arrount the gRPC-Interface encapsulated in the uZeeBeClient.pas unit.
 

# Status
Although it has been used in an prove of concept project, the code is not production ready yet. 
The Example projects are available to show it works with the DelphiGRPC Lib (which in turn isn't production ready yet).  