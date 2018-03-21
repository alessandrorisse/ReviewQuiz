object FResultadoFinal: TFResultadoFinal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Resultado final'
  ClientHeight = 216
  ClientWidth = 449
  Color = 13158600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Padding.Left = 5
  Padding.Right = 5
  Padding.Bottom = 5
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 21
  object grbClassificacaoGeral: TGroupBox
    Left = 5
    Top = 0
    Width = 439
    Height = 211
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    Caption = ' Classifica'#231#227'o final '
    Color = 13158600
    Padding.Left = 10
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    object lblPrimeiroColocado: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 60
      Width = 341
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      AutoSize = False
      Caption = '1'#186' - '
      EllipsisPosition = epEndEllipsis
    end
    object lblSegundoColocado: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 100
      Width = 341
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      AutoSize = False
      Caption = '2'#186' - '
      EllipsisPosition = epEndEllipsis
    end
    object lblTerceiroColocado: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 140
      Width = 341
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      AutoSize = False
      Caption = '3'#186' - '
      EllipsisPosition = epEndEllipsis
    end
    object lblQuartoColocado: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 180
      Width = 341
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      AutoSize = False
      Caption = '4'#186' - '
      EllipsisPosition = epEndEllipsis
    end
    object lblPontos: TLabel
      AlignWithMargins = True
      Left = 368
      Top = 28
      Width = 60
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Alignment = taRightJustify
      Caption = 'Pontos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEquipe: TLabel
      AlignWithMargins = True
      Left = 151
      Top = 28
      Width = 58
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Alignment = taRightJustify
      Caption = 'Equipe'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPontosPrimeiroColocado: TLabel
      AlignWithMargins = True
      Left = 370
      Top = 60
      Width = 61
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
    end
    object lblPontosSegundoColocado: TLabel
      AlignWithMargins = True
      Left = 370
      Top = 100
      Width = 61
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Color = 13158600
      ParentColor = False
    end
    object lblPontosTerceiroColocado: TLabel
      AlignWithMargins = True
      Left = 368
      Top = 140
      Width = 61
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
    end
    object lblPontosQuartoColocado: TLabel
      AlignWithMargins = True
      Left = 368
      Top = 180
      Width = 61
      Height = 21
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
    end
    object Shape1: TShape
      Left = 10
      Top = 90
      Width = 421
      Height = 1
      Pen.Color = clGray
    end
    object Shape2: TShape
      Left = 8
      Top = 130
      Width = 421
      Height = 1
      Pen.Color = clGray
    end
    object Shape3: TShape
      Left = 8
      Top = 170
      Width = 421
      Height = 1
      Pen.Color = clGray
    end
    object Shape4: TShape
      Left = 360
      Top = 30
      Width = 1
      Height = 171
      Pen.Color = clGray
    end
    object Shape5: TShape
      Left = 8
      Top = 50
      Width = 421
      Height = 1
      Pen.Color = clGray
    end
  end
end
