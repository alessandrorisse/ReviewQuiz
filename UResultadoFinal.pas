unit UResultadoFinal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFResultadoFinal = class(TForm)
    grbClassificacaoGeral: TGroupBox;
    lblPrimeiroColocado: TLabel;
    lblSegundoColocado: TLabel;
    lblTerceiroColocado: TLabel;
    lblQuartoColocado: TLabel;
    lblPontos: TLabel;
    lblEquipe: TLabel;
    lblPontosPrimeiroColocado: TLabel;
    lblPontosSegundoColocado: TLabel;
    lblPontosTerceiroColocado: TLabel;
    lblPontosQuartoColocado: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    procedure FormShow(Sender: TObject);

  private
    procedure ExibirClassificacaoFinal;

  public
    class procedure Execute(AOwner: TComponent);
  end;

implementation

{$R *.dfm}

uses UConexao, UTipos;

{ TFResultadoFinal }

class procedure TFResultadoFinal.Execute(AOwner: TComponent);
var
  Tela: TFResultadoFinal;
begin
  Tela := TFResultadoFinal.Create(AOwner);
  try
    Tela.ShowModal;
  finally
    FreeAndNil(Tela);
  end;
end;

procedure TFResultadoFinal.ExibirClassificacaoFinal;
var
  Equipes: TEquipes;
  Conexao: TFConexao;
begin
  Conexao := TFConexao.GetInstancia;

  Equipes := Conexao.ObterClassificacaoAtual;
  if (Length(Equipes) > 0) then
  begin
    lblPrimeiroColocado.Caption := '1º - ' + Equipes[0].Nome;
    lblPontosPrimeiroColocado.Caption := Equipes[0].Pontos.ToString;
    lblSegundoColocado.Caption := '2º - ' + Equipes[1].Nome;
    lblPontosSegundoColocado.Caption := Equipes[1].Pontos.ToString;
    lblTerceiroColocado.Caption := '3º - ' + Equipes[2].Nome;
    lblPontosTerceiroColocado.Caption := Equipes[2].Pontos.ToString;
    lblQuartoColocado.Caption := '4º - ' + Equipes[3].Nome;
    lblPontosQuartoColocado.Caption := Equipes[3].Pontos.ToString;

    Equipes[0].Free;
    Equipes[1].Free;
    Equipes[2].Free;
    Equipes[3].Free;
  end;
end;

procedure TFResultadoFinal.FormShow(Sender: TObject);
begin
  ExibirClassificacaoFinal;
end;

end.
