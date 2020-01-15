object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ZeeBe CLI Client'
  ClientHeight = 412
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnCreate = FormCreate
  DesignSize = (
    770
    412)
  PixelsPerInch = 96
  TextHeight = 13
  object lblOrderID: TLabel
    Left = 119
    Top = 68
    Width = 42
    Height = 13
    Caption = 'Order ID'
  end
  object lblAmount: TLabel
    Left = 167
    Top = 68
    Width = 37
    Height = 13
    Caption = 'Amount'
  end
  object lblJob2: TLabel
    Left = 246
    Top = 139
    Width = 93
    Height = 13
    Caption = 'ship-with-insurance'
  end
  object mmoCLIResults: TMemo
    Left = 8
    Top = 213
    Width = 754
    Height = 191
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'mmoCLIResults')
    TabOrder = 0
  end
  object btnDeployBPMFile: TButton
    Left = 8
    Top = 54
    Width = 105
    Height = 25
    Caption = 'DeployBPMFile'
    TabOrder = 1
    OnClick = btnDeployBPMFileClick
  end
  object lbledtBPMNFileFolder: TLabeledEdit
    Left = 536
    Top = 32
    Width = 226
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 79
    EditLabel.Height = 13
    EditLabel.Caption = 'BPMN File Folder'
    LabelPosition = lpLeft
    TabOrder = 2
    OnDblClick = lbledtBPMNFileFolderDblClick
  end
  object lbledtBINFolder: TLabeledEdit
    Left = 536
    Top = 8
    Width = 226
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 69
    EditLabel.Height = 13
    EditLabel.Caption = 'BIN File Folder'
    LabelPosition = lpLeft
    TabOrder = 3
    OnDblClick = lbledtBPMNFileFolderDblClick
  end
  object lbledworkFlowBPMNFile: TLabeledEdit
    Left = 8
    Top = 27
    Width = 106
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 95
    EditLabel.Height = 13
    EditLabel.Caption = 'Workflow BPMN-File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    Text = 'order-process'
    OnDblClick = lbledtBPMNFileFolderDblClick
  end
  object btnCreateWFInstance: TButton
    Left = 8
    Top = 87
    Width = 105
    Height = 25
    Caption = 'Create WF Instance'
    TabOrder = 5
    OnClick = btnCreateWFInstanceClick
  end
  object btnGetStatus: TButton
    Left = 536
    Top = 59
    Width = 226
    Height = 25
    Caption = 'Status'
    TabOrder = 6
    OnClick = btnGetStatusClick
  end
  object medtOrderID: TMaskEdit
    Left = 119
    Top = 87
    Width = 38
    Height = 21
    Alignment = taCenter
    EditMask = '99999;1;_'
    MaxLength = 5
    TabOrder = 7
    Text = '12345'
  end
  object medtAmount: TMaskEdit
    Left = 167
    Top = 87
    Width = 35
    Height = 21
    Alignment = taRightJustify
    EditMask = '999;1;_'
    MaxLength = 3
    TabOrder = 8
    Text = '999'
  end
  object btnCreateWorker: TButton
    Left = 8
    Top = 134
    Width = 105
    Height = 25
    Caption = 'Create Worker'
    TabOrder = 9
    OnClick = btnCreateWorkerClick
  end
  object lbledtJobName: TLabeledEdit
    Left = 119
    Top = 136
    Width = 121
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'Job-Name'
    TabOrder = 10
    Text = 'initiate-payment'
  end
  object btnPublishMessage: TButton
    Left = 8
    Top = 182
    Width = 105
    Height = 25
    Caption = 'Publish Message'
    TabOrder = 11
    OnClick = btnPublishMessageClick
  end
  object lbledtMessage: TLabeledEdit
    Left = 119
    Top = 184
    Width = 121
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Message'
    TabOrder = 12
    Text = 'payment-received'
  end
  object lbledtCorrKey: TLabeledEdit
    Left = 246
    Top = 184
    Width = 67
    Height = 21
    EditLabel.Width = 18
    EditLabel.Height = 13
    EditLabel.Caption = 'Key'
    TabOrder = 13
    Text = '12345'
  end
  object dlgBrowseForFolder: TJvBrowseForFolderDialog
    Left = 672
    Top = 8
  end
end
