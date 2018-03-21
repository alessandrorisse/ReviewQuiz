object FConfiguracoes: TFConfiguracoes
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configura'#231#245'es'
  ClientHeight = 381
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 21
  object grbEquipe: TGroupBox
    Left = 10
    Top = 60
    Width = 341
    Height = 271
    Caption = ' Equipes '
    TabOrder = 1
    object Label1: TLabel
      Left = 10
      Top = 20
      Width = 72
      Height = 21
      Caption = '1'#170' Equipe'
    end
    object Label2: TLabel
      Left = 10
      Top = 80
      Width = 72
      Height = 21
      Caption = '2'#170' Equipe'
    end
    object Label3: TLabel
      Left = 10
      Top = 140
      Width = 72
      Height = 21
      Caption = '3'#170' Equipe'
    end
    object Label4: TLabel
      Left = 10
      Top = 200
      Width = 72
      Height = 21
      Caption = '4'#170' Equipe'
    end
    object edtNomeEquipe1: TEdit
      Left = 10
      Top = 44
      Width = 321
      Height = 29
      TabOrder = 0
    end
    object edtNomeEquipe2: TEdit
      Left = 10
      Top = 104
      Width = 321
      Height = 29
      TabOrder = 1
    end
    object edtNomeEquipe3: TEdit
      Left = 10
      Top = 164
      Width = 321
      Height = 29
      TabOrder = 2
    end
    object edtNomeEquipe4: TEdit
      Left = 10
      Top = 224
      Width = 321
      Height = 29
      TabOrder = 3
    end
  end
  object btnIniciarNovoJogo: TButton
    Left = 10
    Top = 340
    Width = 171
    Height = 31
    Caption = 'Iniciar um novo jogo'
    TabOrder = 4
    WordWrap = True
    OnClick = btnIniciarNovoJogoClick
  end
  object btnSalvar: TButton
    Left = 190
    Top = 340
    Width = 71
    Height = 31
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 270
    Top = 340
    Width = 81
    Height = 31
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = btnCancelarClick
  end
  object btnCadastroPerguntas: TButton
    Left = 10
    Top = 10
    Width = 341
    Height = 41
    Caption = 'Cadastro de perguntas'
    TabOrder = 0
    OnClick = btnCadastroPerguntasClick
  end
end
