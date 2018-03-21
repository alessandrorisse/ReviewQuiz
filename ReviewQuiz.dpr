program ReviewQuiz;

uses
  Vcl.Forms,
  UCadastroPerguntas in 'UCadastroPerguntas.pas' {FCadastroPerguntas},
  UConexao in 'UConexao.pas' {FConexao: TDataModule},
  UConfiguracoes in 'UConfiguracoes.pas' {FConfiguracoes},
  UPrincipal in 'UPrincipal.pas' {FPrincipal},
  UResultadoFinal in 'UResultadoFinal.pas' {FResultadoFinal},
  UTipos in 'UTipos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
