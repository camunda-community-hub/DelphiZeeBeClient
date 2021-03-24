[![Community extension badge](https://img.shields.io/badge/Community%20Extension-An%20open%20source%20community%20maintained%20project-FF4700)](https://github.com/camunda-community-hub/community) [![Lifecycle: Abandoned badge](https://img.shields.io/badge/Lifecycle-Abandoned-lightgrey)](https://github.com/Camunda-Community-Hub/community/blob/main/extension-lifecycle.md#abandoned-) [![Needs Maintainer badge](https://img.shields.io/badge/Lifecycle-Needs%20Maintainer%20-ff69b4)](https://github.com/Camunda-Community-Hub/community/blob/main/extension-lifecycle.md#abandoned-)

# DelphiZeeBeClient
Delphi client for ZeeBe (https://docs.zeebe.io/index.html) - CLI and gRPC interface.   

# Dependencies
The client interface is based on DelphiGRPC (see: https://github.com/ultraware/DelphiGrpc) which in turn uses the Grijjy.Http library.   
Remark:  
In order to read BPMN-files longer than `BUFFER_SIZE = 32768` Grijjy.Http.pas needs a fix in function `TThreadSafeBuffer.Read` around line #684:
```delphi 
//        Move(FBuffer[Size], FBuffer[0], FSize - ALength); BUG: read behind buffer!
        Move(FBuffer[ALength], FBuffer[0], FSize - ALength); {PMM 29.04.2020: here is the next portion!}
``` 
The initial code for units "gateway_protocol.Client" and "gateway_protocol.Proto.pas" where generated using the DelphiGrpc Tool "ProtoBufGenerator.exe". However, the generated code needs some modifications:
 - `Int64` has to be changed to `UInt64`
 - empty record needs to be removed (`TTopologyRequest` so far)
 - Delphi reserved identifiers (FILE, type) have to be renamed
See the header part of the units mentioned for more details.

# Examples
The reository includes three test projects. The first two are very closely related to the test workflow "order-process.bpmn" used in the [ZeeBe-tutorial](https://docs.zeebe.io/getting-started/tutorial-setup.html)
- ZeeBeTestCLI: Uses the command line interface to communicate to ZeeBe
- ZeeBeTestClient: Uses the gRPC interface directly. 
- ZeeBeTestgRPC: Uses the gRPC interface via the uZeeBeClient.pas unit. This example uses an more generic approach build arrount the gRPC-Interface encapsulated in the uZeeBeClient.pas unit.  

# Status
Although this client has been used successfully in an proof-of-concept project, the code should not be considered as production ready yet. The demo projects are made available to show it works with the DelphiGRPC Lib (which in turn isn't production ready yet) and to play around with ZeeBe workflow modells.  
