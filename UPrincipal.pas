unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.UITypes, Vcl.MPlayer, UConexao, Vcl.Imaging.jpeg;

type
  TOpcoes = (opNenhum, opA, opB, opC, opD, opE);

  TFPrincipal = class(TForm)
    tmrContagemRegressiva: TTimer;
    tmrResposta: TTimer;
    pnlVideo: TPanel;
    pnlEquipes: TPanel;
    grbClassificacaoGeral: TGroupBox;
    lblPrimeiroColocado: TLabel;
    lblSegundoColocado: TLabel;
    lblTerceiroColocado: TLabel;
    lblQuartoColocado: TLabel;
    pnlTopo: TPanel;
    pnlPerguntaRespostas: TPanel;
    memPergunta: TMemo;
    pnlContagemRegressiva: TPanel;
    pgbContagemRegressiva: TProgressBar;
    grbRespostas: TGroupBox;
    pnlRespostaE: TPanel;
    lblRespostaE: TLabel;
    pnlLetraE: TPanel;
    pnlRespostaA: TPanel;
    lblRespostaA: TLabel;
    pnlLetraA: TPanel;
    pnlRespostaB: TPanel;
    lblRespostaB: TLabel;
    pnlLetraB: TPanel;
    pnlRespostaC: TPanel;
    lblRespostaC: TLabel;
    pnlLetraC: TPanel;
    pnlRespostaD: TPanel;
    lblRespostaD: TLabel;
    pnlLetraD: TPanel;
    lblPergunta: TLabel;
    shpMarcacaoResposta: TShape;
    shpRespostaCorreta: TShape;
    grbEquipeAtual: TGroupBox;
    grbProximaEquipe: TGroupBox;
    btnProximaPergunta: TButton;
    lblEquipeAtual: TLabel;
    lblProximaEquipe: TLabel;
    lblPontosPrimeiroColocado: TLabel;
    lblPontosSegundoColocado: TLabel;
    lblPontosTerceiroColocado: TLabel;
    lblPontosQuartoColocado: TLabel;
    imgCertoErrado: TImage;

    procedure tmrContagemRegressivaTimer(Sender: TObject);
    procedure btnProximaPerguntaClick(Sender: TObject);
    procedure tmrRespostaTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    //MediaPlayer: TMediaPlayer;
    OpcaoSelecionada, OpcaoCorreta: TOpcoes;
    Conexao: TFConexao;
    SeqFaceis, SeqMedias, SeqDificeis: Array of integer;
    EquipeAtual, ProximaEquipe: Integer;

    procedure AtivarOpcoes;
    procedure DesativarOpcoes;
    procedure AtivarOuDesativarComponentesPainel(Painel: TPanel; Ativar: Boolean);
    procedure AtribuirEventoClickSelecaoResposta;
    procedure RemoverEventoClickSelecaoResposta;
    procedure AtribuirEventoAosComponentesPainel(Painel: TPanel; Evento: TNotifyEvent);
    procedure OnClickSelecaoResposta(Sender: TObject);
    procedure AtribuirCursorHand;
    procedure AtribuirCursorDefault;
    procedure AtribuirCursorAosComponentesPainel(Painel: TPanel; Cursor: TCursor);
    procedure AtribuirCorPadraoAoPainel(Painel: TPanel);
    procedure AtribuirCorVerdeAoPainel(Painel: TPanel);
    procedure ExibirOpcaoCorretaEImagem(Painel: TPanel);
    procedure ProximaPergunta;
    function ObterPainelBaseadoEmOpcao(Opcao: TOpcoes): TPanel;
    function ObterOpcaoBaseadoEmPainel(Painel: TPanel): TOpcoes;
    procedure LimparOpcaoSelecionada;
    procedure AtribuirOpcaoCorreta(Opcao: TOpcoes);
    procedure BuscarProximaPergunta;
    procedure GerarSequenciaPerguntas;
    function NumeroJaAdicionado(const Valor: Integer; const Sequencia: Array of Integer): Boolean;
    function ObterPerguntaId: Integer;
    procedure RegistrarAcerto;
    procedure SelecionarProximaEquipe;
    procedure AtualizarClassificacaoGeral;
    procedure AtualizarEquipeAtualEProximaEquipe;
    procedure ExibirImagemCerto;
    procedure ExibirImagemErrado;
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

uses UTipos, UConfiguracoes, UResultadoFinal;

procedure TFPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not(tmrContagemRegressiva.Enabled) and not(tmrResposta.Enabled);
  CanClose := CanClose and (Application.MessageBox(PWideChar('Deseja realmente fechar o ReviewQuiz?'),
                                                   PWideChar('Pergunta...'),
                                                   MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = mrYes);
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  Conexao := TFConexao.GetInstancia;
{
  MediaPlayer := TMediaPlayer.Create(Self);
  MediaPlayer.VisibleButtons := [];
  MediaPlayer.Parent := pnlVideo;
  MediaPlayer.Display := pnlVideo;
  MediaPlayer.DisplayRect := pnlVideo.ClientRect;
 }
  GerarSequenciaPerguntas;
  SelecionarProximaEquipe;
  AtualizarClassificacaoGeral;
end;

procedure TFPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Conexao);
//  FreeAndNil(MediaPlayer);
end;

procedure TFPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and ((Key = Ord('p')) or (Key = Ord('P'))) then
  begin
    TFConfiguracoes.Execute(Self);
    AtualizarClassificacaoGeral;
    AtualizarEquipeAtualEProximaEquipe;
  end;
end;

procedure TFPrincipal.GerarSequenciaPerguntas;
var
  Valor: Integer;
begin
  Randomize;

  repeat
    Valor := Random(41);
    if (Valor = 0) then
      Continue;
      
    if (Valor <= 13) then
    begin
      if (Length(SeqFaceis) < 13) and not(NumeroJaAdicionado(Valor, SeqFaceis)) then
      begin
        SetLength(SeqFaceis, Length(SeqFaceis) + 1);
        SeqFaceis[High(SeqFaceis)] := Valor;
      end;
    end
    else if (Valor > 13) and (Valor <= 26) then
    begin
      if (Length(SeqMedias) < 13) and not(NumeroJaAdicionado(Valor, SeqMedias)) then
      begin
        SetLength(SeqMedias, Length(SeqMedias) + 1);
        SeqMedias[High(SeqMedias)] := Valor;
      end;
    end
    else
    begin
      if (Length(SeqDificeis) < 14) and not(NumeroJaAdicionado(Valor, SeqDificeis)) then
      begin
        SetLength(SeqDificeis, Length(SeqDificeis) + 1);
        SeqDificeis[High(SeqDificeis)] := Valor;
      end;
    end;   
  until (Length(SeqFaceis) = 13) and (Length(SeqMedias) = 13) and (Length(SeqDificeis) = 14);
end;

procedure TFPrincipal.LimparOpcaoSelecionada;
begin
  OpcaoSelecionada := opNenhum;
end;

function TFPrincipal.NumeroJaAdicionado(const Valor: Integer;
  const Sequencia: array of Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  
  for i := Low(Sequencia) to High(Sequencia) do
    if (Sequencia[i] = Valor) then
    begin
      Result := True;
      Break;
    end;   
end;

procedure TFPrincipal.AtivarOpcoes;
begin
  memPergunta.Enabled := True;
  AtivarOuDesativarComponentesPainel(pnlRespostaA, True);
  AtivarOuDesativarComponentesPainel(pnlRespostaB, True);
  AtivarOuDesativarComponentesPainel(pnlRespostaC, True);
  AtivarOuDesativarComponentesPainel(pnlRespostaD, True);
  AtivarOuDesativarComponentesPainel(pnlRespostaE, True);
end;

procedure TFPrincipal.DesativarOpcoes;
begin
  memPergunta.Enabled := False;
  AtivarOuDesativarComponentesPainel(pnlRespostaA, False);
  AtivarOuDesativarComponentesPainel(pnlRespostaB, False);
  AtivarOuDesativarComponentesPainel(pnlRespostaC, False);
  AtivarOuDesativarComponentesPainel(pnlRespostaD, False);
  AtivarOuDesativarComponentesPainel(pnlRespostaE, False);
end;

procedure TFPrincipal.ExibirImagemCerto;
var
  Numero: Integer;
begin
  repeat
    Numero := Random(5);
  until Numero <> 0;

  imgCertoErrado.Picture.LoadFromFile('.\Imagens\Certo_' + FormatFloat('00', Numero) + '.jpg');
end;

procedure TFPrincipal.ExibirImagemErrado;
var
  Numero: Integer;
begin
  repeat
    Numero := Random(5);
  until Numero <> 0;

  imgCertoErrado.Picture.LoadFromFile('.\Imagens\Errado_' + FormatFloat('00', Numero) + '.jpg');
end;

procedure TFPrincipal.ExibirOpcaoCorretaEImagem(Painel: TPanel);
begin
  shpRespostaCorreta.Top := Painel.Top - 2;
  shpRespostaCorreta.Visible := True;

  AtribuirCorVerdeAoPainel(Painel);
  AtivarOuDesativarComponentesPainel(Painel, True);

  if (OpcaoSelecionada = OpcaoCorreta) then
    ExibirImagemCerto
  else
    ExibirImagemErrado;
//  MediaPlayer.FileName := 'Errou.avi';
//  MediaPlayer.Open;
//  MediaPlayer.Play;
end;

procedure TFPrincipal.AtribuirCursorDefault;
begin
  AtribuirCursorAosComponentesPainel(pnlRespostaA, crDefault);
  AtribuirCursorAosComponentesPainel(pnlRespostaB, crDefault);
  AtribuirCursorAosComponentesPainel(pnlRespostaC, crDefault);
  AtribuirCursorAosComponentesPainel(pnlRespostaD, crDefault);
  AtribuirCursorAosComponentesPainel(pnlRespostaE, crDefault);
end;

procedure TFPrincipal.AtribuirCursorHand;
begin
  AtribuirCursorAosComponentesPainel(pnlRespostaA, crHandPoint);
  AtribuirCursorAosComponentesPainel(pnlRespostaB, crHandPoint);
  AtribuirCursorAosComponentesPainel(pnlRespostaC, crHandPoint);
  AtribuirCursorAosComponentesPainel(pnlRespostaD, crHandPoint);
  AtribuirCursorAosComponentesPainel(pnlRespostaE, crHandPoint);
end;

procedure TFPrincipal.AtribuirEventoClickSelecaoResposta;
begin
  AtribuirEventoAosComponentesPainel(pnlRespostaA, OnClickSelecaoResposta);
  AtribuirEventoAosComponentesPainel(pnlRespostaB, OnClickSelecaoResposta);
  AtribuirEventoAosComponentesPainel(pnlRespostaC, OnClickSelecaoResposta);
  AtribuirEventoAosComponentesPainel(pnlRespostaD, OnClickSelecaoResposta);
  AtribuirEventoAosComponentesPainel(pnlRespostaE, OnClickSelecaoResposta);
end;

procedure TFPrincipal.AtribuirOpcaoCorreta(Opcao: TOpcoes);
begin
  OpcaoCorreta := Opcao;
end;

procedure TFPrincipal.AtualizarClassificacaoGeral;
var
  Equipes: TEquipes;
begin
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
  end
  else
  begin
    lblPrimeiroColocado.Caption := '1º -';
    lblPontosPrimeiroColocado.Caption := '0';
    lblSegundoColocado.Caption := '2º -';
    lblPontosSegundoColocado.Caption := '0';
    lblTerceiroColocado.Caption := '3º -';
    lblPontosTerceiroColocado.Caption := '0';
    lblQuartoColocado.Caption := '4º -';
    lblPontosQuartoColocado.Caption := '0';
  end;
end;

procedure TFPrincipal.AtualizarEquipeAtualEProximaEquipe;
begin
  lblEquipeAtual.Caption := Conexao.ObterNomeEquipe(EquipeAtual);
  lblProximaEquipe.Caption := Conexao.ObterNomeEquipe(ProximaEquipe);
end;

procedure TFPrincipal.RegistrarAcerto;
begin
  Conexao.RegistrarAcerto(EquipeAtual);
end;

procedure TFPrincipal.RemoverEventoClickSelecaoResposta;
begin
  AtribuirEventoAosComponentesPainel(pnlRespostaA, nil);
  AtribuirEventoAosComponentesPainel(pnlRespostaB, nil);
  AtribuirEventoAosComponentesPainel(pnlRespostaC, nil);
  AtribuirEventoAosComponentesPainel(pnlRespostaD, nil);
  AtribuirEventoAosComponentesPainel(pnlRespostaE, nil);
end;

procedure TFPrincipal.SelecionarProximaEquipe;
begin
  if (EquipeAtual = 4) then
  begin
    EquipeAtual := 1;
    ProximaEquipe := 2;
  end
  else
  begin
    Inc(EquipeAtual);
    ProximaEquipe := EquipeAtual + 1;

    if (ProximaEquipe = 5) then
      ProximaEquipe := 1;
  end;

  AtualizarEquipeAtualEProximaEquipe;
end;

procedure TFPrincipal.AtivarOuDesativarComponentesPainel(Painel: TPanel; Ativar: Boolean);
var
  i: Integer;
begin
  for i := 0 to Painel.ControlCount - 1 do
  begin
    if Painel.Controls[i] is TLabel then
      (Painel.Controls[i] as TLabel).Enabled := Ativar
    else if Painel.Controls[i] is TPanel then
      (Painel.Controls[i] as TPanel).Enabled := Ativar;
  end;

  Painel.Enabled := Ativar;
end;

procedure TFPrincipal.AtribuirCorPadraoAoPainel(Painel: TPanel);
begin
  if Assigned(Painel) then
    Painel.Color := $00E5E5E5;
end;

procedure TFPrincipal.AtribuirCorVerdeAoPainel(Painel: TPanel);
begin
  if Assigned(Painel) then
    Painel.Color := $00B9FFB9;
end;

procedure TFPrincipal.AtribuirCursorAosComponentesPainel(Painel: TPanel; Cursor: TCursor);
var
  i: Integer;
begin
  for i := 0 to Painel.ControlCount - 1 do
  begin
    if Painel.Controls[i] is TLabel then
      (Painel.Controls[i] as TLabel).Cursor := Cursor
    else if Painel.Controls[i] is TPanel then
      (Painel.Controls[i] as TPanel).Cursor := Cursor;
  end;

  Painel.Cursor := Cursor;
end;

procedure TFPrincipal.AtribuirEventoAosComponentesPainel(Painel: TPanel; Evento: TNotifyEvent);
var
  i: Integer;
begin
  for i := 0 to Painel.ControlCount - 1 do
  begin
    if Painel.Controls[i] is TLabel then
      (Painel.Controls[i] as TLabel).OnClick := Evento
    else if Painel.Controls[i] is TPanel then
      (Painel.Controls[i] as TPanel).OnClick := Evento;
  end;

  Painel.OnClick := Evento;
end;

procedure TFPrincipal.btnProximaPerguntaClick(Sender: TObject);
begin
  ProximaPergunta;
end;

procedure TFPrincipal.BuscarProximaPergunta;
var
  Pergunta: TPergunta;
  Respostas: TRespostas;
  i: Integer;
  EncontrouPergunta: Boolean;
begin
  Pergunta := nil;
  Respostas := nil;

  memPergunta.Lines.Clear;
  lblRespostaA.Caption := EmptyStr;
  lblRespostaB.Caption := EmptyStr;
  lblRespostaC.Caption := EmptyStr;
  lblRespostaD.Caption := EmptyStr;
  lblRespostaE.Caption := EmptyStr;

  repeat
    i := ObterPerguntaId;
    EncontrouPergunta := Conexao.BuscarPerguntaERespostas(i, Pergunta, Respostas);
  until EncontrouPergunta or (i = 0);

  if (Assigned(Pergunta)) then
  begin
    try
      memPergunta.Text := Pergunta.Pergunta;

      for i := Low(Respostas) to High(Respostas) do
        case i of
          0: begin
              lblRespostaA.Caption := Respostas[i].Resposta;
              if (Respostas[i].Correta) then
                  AtribuirOpcaoCorreta(opA);
             end;
          1: begin
              lblRespostaB.Caption := Respostas[i].Resposta;
              if (Respostas[i].Correta) then
                  AtribuirOpcaoCorreta(opB);
             end;
          2: begin
              lblRespostaC.Caption := Respostas[i].Resposta;
              if (Respostas[i].Correta) then
                  AtribuirOpcaoCorreta(opC);
             end;
          3: begin
              lblRespostaD.Caption := Respostas[i].Resposta;
              if (Respostas[i].Correta) then
                  AtribuirOpcaoCorreta(opD);
             end;
          4: begin
              lblRespostaE.Caption := Respostas[i].Resposta;
              if (Respostas[i].Correta) then
                  AtribuirOpcaoCorreta(opE);
             end;
        end;
    finally
      FreeAndNil(Pergunta);
      for i := Low(Respostas) to High(Respostas) do
        FreeAndNil(Respostas[i]);

      tmrContagemRegressiva.Enabled := True;
    end;
  end
  else
  begin
    lblPrimeiroColocado.Caption := EmptyStr;
    lblSegundoColocado.Caption := EmptyStr;
    lblTerceiroColocado.Caption := EmptyStr;
    lblQuartoColocado.Caption := EmptyStr;
    lblPontosPrimeiroColocado.Caption := EmptyStr;
    lblPontosSegundoColocado.Caption := EmptyStr;
    lblPontosTerceiroColocado.Caption := EmptyStr;
    lblPontosQuartoColocado.Caption := EmptyStr;
    lblEquipeAtual.Caption := EmptyStr;
    lblProximaEquipe.Caption := EmptyStr;
    pgbContagemRegressiva.Position := 0;
    RemoverEventoClickSelecaoResposta;
    AtribuirCursorDefault;

    TFResultadoFinal.Execute(Self);
  end;
end;

function TFPrincipal.ObterOpcaoBaseadoEmPainel(Painel: TPanel): TOpcoes;
begin
  if (Painel = pnlRespostaA) then
    Result := opA
  else if (Painel = pnlRespostaB) then
    Result := opB
  else if (Painel = pnlRespostaC) then
    Result := opC
  else if (Painel = pnlRespostaD) then
    Result := opD
  else if (Painel = pnlRespostaE) then
    Result := opE
  else
    Result := opNenhum;
end;

function TFPrincipal.ObterPainelBaseadoEmOpcao(Opcao: TOpcoes): TPanel;
begin
  case Opcao of
    opA: Result := pnlRespostaA;
    opB: Result := pnlRespostaB;
    opC: Result := pnlRespostaC;
    opD: Result := pnlRespostaD;
    opE: Result := pnlRespostaE;
  else
    Result := nil;
  end;
end;

function TFPrincipal.ObterPerguntaId: Integer;
begin
  Result := 0;
  
  if (Length(SeqFaceis) > 0) then
  begin
    Result := SeqFaceis[High(SeqFaceis)];
    SetLength(SeqFaceis, Length(SeqFaceis) - 1);
  end
  else if (Length(SeqMedias) > 0) then
  begin
    Result := SeqMedias[High(SeqMedias)];
    SetLength(SeqMedias, Length(SeqMedias) - 1);
  end
  else if (Length(SeqDificeis) > 0) then
  begin
    Result := SeqDificeis[High(SeqDificeis)];
    SetLength(SeqDificeis, Length(SeqDificeis) - 1);
  end;
end;

procedure TFPrincipal.OnClickSelecaoResposta(Sender: TObject);
var
  TopoPainel: Integer;
  Painel: TPanel;
begin
  TopoPainel := 0;
  Painel := nil;

  if (Sender is TLabel) then
  begin
    Painel := TPanel((Sender as TLabel).Parent);
    TopoPainel := Painel.Top;
  end
  else if (Sender is TPanel) then
  begin
    if ((Sender as TPanel).Parent is TPanel) then
    begin
      Painel := TPanel((Sender as TPanel).Parent);
      TopoPainel := Painel.Top;
    end
    else if ((Sender as TPanel).Parent is TGroupBox) then
    begin
      Painel := (Sender as TPanel);
      TopoPainel := Painel.Top;
    end;
  end;

  shpMarcacaoResposta.Top := TopoPainel - shpMarcacaoResposta.Pen.Width;

  if not(shpMarcacaoResposta.Visible) then
    shpMarcacaoResposta.Visible := True;

  OpcaoSelecionada := ObterOpcaoBaseadoEmPainel(Painel); 
end;

procedure TFPrincipal.ProximaPergunta;
begin
  try
    btnProximaPergunta.Enabled := False;
    Screen.Cursor := crHourGlass;

    pgbContagemRegressiva.State := pbsNormal;
    pgbContagemRegressiva.Position := pgbContagemRegressiva.Max;
    pgbContagemRegressiva.Position := pgbContagemRegressiva.Position;

    shpMarcacaoResposta.Visible := False;
    shpRespostaCorreta.Visible := False;

    imgCertoErrado.Picture := nil;

    AtribuirCorPadraoAoPainel(ObterPainelBaseadoEmOpcao(OpcaoCorreta));
    AtribuirEventoClickSelecaoResposta;
    AtribuirCursorHand;
    AtivarOpcoes;

    LimparOpcaoSelecionada;
    SelecionarProximaEquipe;
    BuscarProximaPergunta;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFPrincipal.tmrContagemRegressivaTimer(Sender: TObject);
begin
  case pgbContagemRegressiva.Position of
    59: pgbContagemRegressiva.State := pbsNormal;
    19: pgbContagemRegressiva.State := pbsPaused;
    07: pgbContagemRegressiva.State := pbsError;
    00: begin
          tmrContagemRegressiva.Enabled := False;
          DesativarOpcoes;
          RemoverEventoClickSelecaoResposta;
          AtribuirCursorDefault;
          tmrResposta.Enabled := True;
       end;
  end;

  pgbContagemRegressiva.StepBy(-1);
end;

procedure TFPrincipal.tmrRespostaTimer(Sender: TObject);
begin
  tmrResposta.Enabled := False;
  btnProximaPergunta.Enabled := True;
  ExibirOpcaoCorretaEImagem(ObterPainelBaseadoEmOpcao(OpcaoCorreta));

  if (OpcaoSelecionada = OpcaoCorreta) then
  begin
    RegistrarAcerto;
    AtualizarClassificacaoGeral;
  end;
end;

end.
