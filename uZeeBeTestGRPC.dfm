object frmZeeBeTestgRPC: TfrmZeeBeTestgRPC
  Left = 0
  Top = 0
  Caption = 'Test ZeeBe gRPC Interface'
  ClientHeight = 569
  ClientWidth = 836
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 0
    Top = 433
    Width = 836
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 393
    ExplicitWidth = 176
  end
  object pnlZeeBeConnection: TPanel
    Left = 0
    Top = 0
    Width = 836
    Height = 41
    Align = alTop
    TabOrder = 0
    object lbledtServer: TLabeledEdit
      Left = 9
      Top = 18
      Width = 121
      Height = 21
      EditLabel.Width = 93
      EditLabel.Height = 13
      EditLabel.Caption = 'ZeBee SERVER URL'
      TabOrder = 0
      Text = '127.0.0.1'
      OnChange = lbledtServerChange
    end
    object lbledtPort: TLabeledEdit
      Left = 152
      Top = 14
      Width = 97
      Height = 21
      Alignment = taRightJustify
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = 'PORT(58772/26500)'
      TabOrder = 1
      Text = '26500'
      OnChange = lbledtPortChange
    end
    object btnGetTopology: TButton
      Left = 288
      Top = 12
      Width = 130
      Height = 25
      Caption = 'ZeeBe Server Topology'
      TabOrder = 2
      OnClick = btnGetTopologyClick
    end
  end
  object pnlNsvBrowser: TPanel
    Left = 0
    Top = 41
    Width = 836
    Height = 32
    Align = alTop
    TabOrder = 1
    DesignSize = (
      836
      32)
    object edtZeeBeURL: TEdit
      Left = 152
      Top = 4
      Width = 681
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'http://localhost:8082'
    end
    object btnShowInDefaultBrowser: TButton
      Left = 9
      Top = 4
      Width = 121
      Height = 22
      Caption = 'ShowInDefaultBrowser'
      TabOrder = 1
      OnClick = btnShowInDefaultBrowserClick
    end
  end
  object pnlWorkFlow: TPanel
    Left = 0
    Top = 73
    Width = 836
    Height = 64
    Align = alTop
    TabOrder = 2
    DesignSize = (
      836
      64)
    object edFileNameBPMN: TJvFilenameEdit
      Left = 8
      Top = 2
      Width = 823
      Height = 21
      Filter = 'BPMN files (*.bpmn)|*.bpmn|All files (*.*)|*.*'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '.\order-process.bpmn'
    end
    object btnDeployWorkFlow: TButton
      Left = 9
      Top = 29
      Width = 112
      Height = 25
      Caption = 'Deploy WorkFlow'
      TabOrder = 1
      OnClick = btnDeployWorkFlowClick
    end
    object lbledtBPMNID: TLabeledEdit
      Left = 184
      Top = 29
      Width = 381
      Height = 24
      Hint = 'BPMN Process ID'
      AutoSize = False
      EditLabel.Width = 55
      EditLabel.Height = 13
      EditLabel.Caption = 'Process ID:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 2
    end
    object lbledtWorkFlowId: TLabeledEdit
      Left = 648
      Top = 29
      Width = 183
      Height = 21
      EditLabel.Width = 62
      EditLabel.Height = 13
      EditLabel.Caption = 'WorkFlowID:'
      LabelPosition = lpLeft
      TabOrder = 3
    end
  end
  object pnlWFInstance: TPanel
    Left = 0
    Top = 137
    Width = 836
    Height = 296
    Align = alTop
    Caption = 'pnlWFInstance'
    TabOrder = 3
    object spl2: TSplitter
      Left = 577
      Top = 1
      Height = 294
      ExplicitLeft = 328
      ExplicitTop = 112
      ExplicitHeight = 100
    end
    object pnlZeeBeGUI: TPanel
      Left = 1
      Top = 1
      Width = 576
      Height = 294
      Align = alLeft
      TabOrder = 0
      object grpCase: TGroupBox
        Left = 1
        Top = 1
        Width = 283
        Height = 292
        Align = alLeft
        Caption = 'WF Instance / Case'
        TabOrder = 0
        object lblCaseVar: TLabel
          Left = 3
          Top = 65
          Width = 70
          Height = 13
          Caption = 'Case Variables'
        end
        object btnStartNewCase: TButton
          Left = 3
          Top = 27
          Width = 105
          Height = 25
          Caption = 'Start New Case'
          Enabled = False
          TabOrder = 0
          OnClick = btnStartNewCaseClick
        end
        object lbledtCaseID: TLabeledEdit
          Left = 114
          Top = 29
          Width = 142
          Height = 21
          EditLabel.Width = 53
          EditLabel.Height = 13
          EditLabel.Caption = 'InstanceID'
          TabOrder = 1
        end
        object stgrdCaseVars: TStringGrid
          Left = 3
          Top = 84
          Width = 262
          Height = 173
          ColCount = 2
          DefaultRowHeight = 20
          FixedCols = 0
          RowCount = 7
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          TabOrder = 2
          ColWidths = (
            86
            169)
        end
      end
      object grpActivity: TGroupBox
        Left = 284
        Top = 1
        Width = 291
        Height = 292
        Align = alClient
        Caption = 'Job / Activity'
        TabOrder = 1
        object lbl1: TLabel
          Left = 3
          Top = 142
          Width = 63
          Height = 13
          Caption = 'Job Variables'
        end
        object btnActivateJob: TButton
          Left = 3
          Top = 15
          Width = 97
          Height = 25
          Caption = 'ActivateJobs'
          TabOrder = 0
          OnClick = btnActivateJobClick
        end
        object btnCompleteJob: TButton
          Left = 3
          Top = 53
          Width = 97
          Height = 25
          Caption = 'CompleteJob'
          TabOrder = 1
          OnClick = btnCompleteJobClick
        end
        object btnPublishMessage: TButton
          Left = 3
          Top = 84
          Width = 97
          Height = 25
          Caption = 'Publish Message'
          TabOrder = 2
          OnClick = btnPublishMessageClick
        end
        object cbbJobName: TComboBox
          Left = 105
          Top = 17
          Width = 175
          Height = 21
          ItemIndex = 0
          TabOrder = 3
          Text = 'initiate-payment'
          Items.Strings = (
            'initiate-payment'
            'ship-with-insurance'
            'ship-without-insurance')
        end
        object lbledtJobID: TLabeledEdit
          Left = 130
          Top = 55
          Width = 150
          Height = 21
          EditLabel.Width = 11
          EditLabel.Height = 13
          EditLabel.Caption = 'ID'
          LabelPosition = lpLeft
          TabOrder = 4
        end
        object lbledtMessageKey: TLabeledEdit
          Left = 130
          Top = 86
          Width = 150
          Height = 21
          EditLabel.Width = 22
          EditLabel.Height = 13
          EditLabel.Caption = 'KEY:'
          LabelPosition = lpLeft
          TabOrder = 5
          Text = 'order id'
        end
        object lbledtMessage: TLabeledEdit
          Left = 49
          Top = 115
          Width = 231
          Height = 21
          EditLabel.Width = 42
          EditLabel.Height = 13
          EditLabel.Caption = 'Message'
          LabelPosition = lpLeft
          TabOrder = 6
          Text = 'payment-received'
        end
        object stgrdJobVars: TStringGrid
          Left = 6
          Top = 161
          Width = 277
          Height = 94
          ColCount = 2
          DefaultRowHeight = 20
          FixedCols = 0
          RowCount = 4
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          TabOrder = 7
          ColWidths = (
            106
            162)
        end
        object chkAutoComplete: TCheckBox
          Left = 3
          Top = 40
          Width = 97
          Height = 15
          Caption = 'Auto-Complete'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object btnSetVariables: TButton
          Left = 0
          Top = 261
          Width = 96
          Height = 25
          Caption = 'SetVariables'
          TabOrder = 9
          OnClick = btnSetVariablesClick
        end
      end
    end
    object pnlWFITree: TPanel
      Left = 580
      Top = 1
      Width = 255
      Height = 294
      Align = alClient
      Caption = 'pnlWFITree'
      TabOrder = 1
      object tvWorkFlow: TTreeView
        Left = 1
        Top = 1
        Width = 253
        Height = 292
        Align = alClient
        Indent = 19
        TabOrder = 0
        Items.NodeData = {
          0301000000520000000000000000000000FFFFFFFFFFFFFFFF00000000000000
          0000000000011A540072006500650056006900650077002000520075006E006E
          0069006E006700200049006E007300740061006E00630065007300}
      end
    end
  end
  object mmoLOG: TMemo
    Left = 0
    Top = 436
    Width = 836
    Height = 133
    Align = alClient
    Lines.Strings = (
      'Needs a running ZeeBe Instanz.'
      'Run ZeeBe via Docker (PowerShell):'
      
        'PS C:\Users\pmm> cd c:\Users\pmm\zeebe-docker-compose\operate-si' +
        'mple-monitor\'
      
        'PS C:\Users\pmm\zeebe-docker-compose\operate-simple-monitor> doc' +
        'ker-compose up -d'
      'Stop Crl-C, shut down:'
      #9' docker-compose down -v (-v: mit l'#246'schen der pesistenten Daten)'
      ''
      'Use gRPC Monitor:'
      
        'c:\Users\pmm\gRPC-Tools>grpc-dump --destination 127.0.0.1:26500 ' +
        '--port=58772.'
      
        '----------------------------------------------------------------' +
        '--------------------------------------'
      '')
    TabOrder = 4
  end
end
