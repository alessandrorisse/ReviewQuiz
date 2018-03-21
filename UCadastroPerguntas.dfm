object FCadastroPerguntas: TFCadastroPerguntas
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cadastro de perguntas'
  ClientHeight = 629
  ClientWidth = 740
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 21
  object Label9: TLabel
    Left = 10
    Top = 2
    Width = 169
    Height = 21
    Caption = 'Perguntas cadastradas'
  end
  object Bevel1: TBevel
    Left = 10
    Top = 180
    Width = 721
    Height = 1
    Shape = bsTopLine
  end
  object dbgListaPerguntas: TDBGrid
    Left = 10
    Top = 26
    Width = 721
    Height = 105
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'pergunta_id'
        Title.Caption = 'C'#243'digo'
        Width = 59
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'texto'
        Title.Caption = 'Pergunta'
        Width = 637
        Visible = True
      end>
  end
  object grbRespostas: TGroupBox
    Left = 10
    Top = 190
    Width = 721
    Height = 391
    TabOrder = 3
    object Label2: TLabel
      Left = 10
      Top = 158
      Width = 11
      Height = 21
      Caption = 'A'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 10
      Top = 198
      Width = 10
      Height = 21
      Caption = 'B'
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 10
      Top = 238
      Width = 10
      Height = 21
      Caption = 'C'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 10
      Top = 278
      Width = 12
      Height = 21
      Caption = 'D'
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 10
      Top = 318
      Width = 10
      Height = 21
      Caption = 'E'
      Layout = tlCenter
    end
    object Label8: TLabel
      Left = 10
      Top = 122
      Width = 83
      Height = 23
      Caption = 'Respostas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 10
      Top = 0
      Width = 76
      Height = 23
      Caption = 'Pergunta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object pnlOpcaoCorreta: TPanel
      Left = 647
      Top = 110
      Width = 64
      Height = 241
      BevelOuter = bvNone
      Color = 14737632
      ParentBackground = False
      TabOrder = 6
      object Label7: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 1
        Width = 64
        Height = 41
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Op'#231#227'o correta'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 5
        ExplicitTop = 4
        ExplicitWidth = 60
      end
      object rdbOpcaoCorretaA: TRadioButton
        AlignWithMargins = True
        Left = 25
        Top = 52
        Width = 14
        Height = 17
        Margins.Left = 25
        Margins.Top = 10
        Margins.Right = 25
        Margins.Bottom = 13
        Align = alTop
        TabOrder = 0
      end
      object rdbOpcaoCorretaB: TRadioButton
        AlignWithMargins = True
        Left = 25
        Top = 92
        Width = 14
        Height = 17
        Margins.Left = 25
        Margins.Top = 10
        Margins.Right = 25
        Margins.Bottom = 13
        Align = alTop
        TabOrder = 1
      end
      object rdbOpcaoCorretaC: TRadioButton
        AlignWithMargins = True
        Left = 25
        Top = 132
        Width = 14
        Height = 17
        Margins.Left = 25
        Margins.Top = 10
        Margins.Right = 25
        Margins.Bottom = 13
        Align = alTop
        TabOrder = 2
      end
      object rdbOpcaoCorretaD: TRadioButton
        AlignWithMargins = True
        Left = 25
        Top = 172
        Width = 14
        Height = 17
        Margins.Left = 25
        Margins.Top = 10
        Margins.Right = 25
        Margins.Bottom = 13
        Align = alTop
        TabOrder = 3
      end
      object rdbOpcaoCorretaE: TRadioButton
        AlignWithMargins = True
        Left = 25
        Top = 212
        Width = 14
        Height = 17
        Margins.Left = 25
        Margins.Top = 10
        Margins.Right = 25
        Margins.Bottom = 13
        Align = alTop
        TabOrder = 4
      end
    end
    object btnSalvar: TButton
      Left = 30
      Top = 350
      Width = 151
      Height = 31
      Caption = 'Salvar altera'#231#245'es'
      TabOrder = 7
      OnClick = btnSalvarClick
    end
    object btnDescartar: TButton
      Left = 190
      Top = 350
      Width = 171
      Height = 31
      Caption = 'Descartar altera'#231#245'es'
      TabOrder = 8
      OnClick = btnDescartarClick
    end
    object memPergunta: TDBMemo
      Left = 10
      Top = 26
      Width = 701
      Height = 75
      DataField = 'texto'
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object edtRespostaA: TEdit
      Left = 30
      Top = 154
      Width = 611
      Height = 29
      TabOrder = 1
    end
    object edtRespostaB: TEdit
      Left = 30
      Top = 194
      Width = 611
      Height = 29
      TabOrder = 2
    end
    object edtRespostaC: TEdit
      Left = 30
      Top = 234
      Width = 611
      Height = 29
      TabOrder = 3
    end
    object edtRespostaD: TEdit
      Left = 30
      Top = 274
      Width = 611
      Height = 29
      TabOrder = 4
    end
    object edtRespostaE: TEdit
      Left = 30
      Top = 314
      Width = 611
      Height = 29
      TabOrder = 5
    end
  end
  object btnFechar: TButton
    Left = 640
    Top = 590
    Width = 91
    Height = 31
    Caption = 'Fechar'
    TabOrder = 4
    OnClick = btnFecharClick
  end
  object btnNovaPergunta: TButton
    Left = 450
    Top = 139
    Width = 131
    Height = 32
    Caption = 'Nova pergunta'
    TabOrder = 1
    OnClick = btnNovaPerguntaClick
  end
  object btnApagar: TButton
    Left = 590
    Top = 139
    Width = 141
    Height = 32
    Caption = 'Apagar pergunta'
    TabOrder = 2
    OnClick = btnApagarClick
  end
end
