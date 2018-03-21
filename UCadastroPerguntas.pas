unit UCadastroPerguntas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, UConexao;

type
  TFCadastroPerguntas = class(TForm)
    dbgListaPerguntas: TDBGrid;
    grbRespostas: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnFechar: TButton;
    pnlOpcaoCorreta: TPanel;
    rdbOpcaoCorretaA: TRadioButton;
    rdbOpcaoCorretaB: TRadioButton;
    rdbOpcaoCorretaC: TRadioButton;
    rdbOpcaoCorretaD: TRadioButton;
    rdbOpcaoCorretaE: TRadioButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    btnNovaPergunta: TButton;
    btnSalvar: TButton;
    btnDescartar: TButton;
    Bevel1: TBevel;
    memPergunta: TDBMemo;
    Label1: TLabel;
    edtRespostaA: TEdit;
    edtRespostaB: TEdit;
    edtRespostaC: TEdit;
    edtRespostaD: TEdit;
    edtRespostaE: TEdit;
    btnApagar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnNovaPerguntaClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnDescartarClick(Sender: TObject);

  private
    Conexao: TFConexao;
    dsPergunta: TDataSource;

    procedure PerguntaBeforePost(DataSet: TDataSet);
    procedure PerguntaAfterScroll(DataSet: TDataSet);
    procedure PerguntaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure LimparCampos;
    procedure SalvarAlteracoes(const ExibirPergunta: Boolean = False);
    procedure EditChange(Sender: TObject);
    procedure AtribuirEventoAosEdits;
    procedure RemoverEventoDosEdits;
    procedure RadioButtonClick(Sender: TObject);
    procedure AtribuirEventoAosRadioButtons;
    procedure RemoverEventoDosRadioButtons;
    function ValidarRespostas: Boolean;
    function EstaInserindoOuEditando: Boolean;
    function EstaInserindo: Boolean;

  public
    class procedure Execute(AOwner: TComponent);
  end;

implementation

{$R *.dfm}

uses UTipos;

procedure TFCadastroPerguntas.AtribuirEventoAosEdits;
begin
  edtRespostaA.OnChange := EditChange;
  edtRespostaB.OnChange := EditChange;
  edtRespostaC.OnChange := EditChange;
  edtRespostaD.OnChange := EditChange;
  edtRespostaE.OnChange := EditChange;
end;

procedure TFCadastroPerguntas.AtribuirEventoAosRadioButtons;
begin
  rdbOpcaoCorretaA.OnClick := RadioButtonClick;
  rdbOpcaoCorretaB.OnClick := RadioButtonClick;
  rdbOpcaoCorretaC.OnClick := RadioButtonClick;
  rdbOpcaoCorretaD.OnClick := RadioButtonClick;
  rdbOpcaoCorretaE.OnClick := RadioButtonClick;
end;

procedure TFCadastroPerguntas.btnApagarClick(Sender: TObject);
begin
  if (Application.MessageBox(PWideChar('Deseja realmente apagar esta pergunta?' + sLineBreak +
                                       'Esta operação não poderá ser desfeita.'),
                             PWideChar('Atenção...'),
                             MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = mrYes) then
  begin
    Conexao.ApagarPergunta(dsPergunta.DataSet.FieldByName('pergunta_id').AsInteger);
    dsPergunta.DataSet.Refresh;
  end;
end;

procedure TFCadastroPerguntas.btnDescartarClick(Sender: TObject);
begin
  dsPergunta.DataSet.Cancel;
  PerguntaAfterScroll(dsPergunta.DataSet);
end;

procedure TFCadastroPerguntas.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFCadastroPerguntas.btnNovaPerguntaClick(Sender: TObject);
begin
  SalvarAlteracoes(True);
  LimparCampos;
  dsPergunta.DataSet.Append;
  memPergunta.SetFocus;
end;

procedure TFCadastroPerguntas.btnSalvarClick(Sender: TObject);
begin
  SalvarAlteracoes;
end;

procedure TFCadastroPerguntas.EditChange(Sender: TObject);
begin
  if not(EstaInserindoOuEditando) then
    dsPergunta.DataSet.Edit;
end;

function TFCadastroPerguntas.EstaInserindo: Boolean;
begin
  Result := (dsPergunta.DataSet.State = dsInsert);
end;

function TFCadastroPerguntas.EstaInserindoOuEditando: Boolean;
begin
  Result := (dsPergunta.DataSet.State in [dsInsert, dsEdit]);
end;

class procedure TFCadastroPerguntas.Execute(AOwner: TComponent);
var
  Tela: TFCadastroPerguntas;
begin
  Tela := TFCadastroPerguntas.Create(AOwner);
  try
    Tela.ShowModal;
  finally
    FreeAndNil(Tela);
  end;
end;

procedure TFCadastroPerguntas.FormCreate(Sender: TObject);
begin
  Conexao := TFConexao.GetInstancia;
  dsPergunta := TDataSource.Create(Self);
  dbgListaPerguntas.DataSource := dsPergunta;
  memPergunta.DataSource := dsPergunta;
end;

procedure TFCadastroPerguntas.FormDestroy(Sender: TObject);
begin
  dsPergunta.DataSet.Free;
  FreeAndNil(dsPergunta);
end;

procedure TFCadastroPerguntas.FormShow(Sender: TObject);
begin
  dsPergunta.DataSet := Conexao.ObterListaPerguntas;
  dsPergunta.DataSet.BeforePost := PerguntaBeforePost;
  dsPergunta.DataSet.AfterScroll := PerguntaAfterScroll;
  dsPergunta.DataSet.FieldByName('texto').OnGetText := PerguntaGetText;
  PerguntaAfterScroll(dsPergunta.DataSet);
end;

procedure TFCadastroPerguntas.LimparCampos;
begin
  try
    RemoverEventoDosEdits;
    RemoverEventoDosRadioButtons;
    edtRespostaA.Clear;
    edtRespostaB.Clear;
    edtRespostaC.Clear;
    edtRespostaD.Clear;
    edtRespostaE.Clear;
    rdbOpcaoCorretaA.Checked := False;
    rdbOpcaoCorretaB.Checked := False;
    rdbOpcaoCorretaC.Checked := False;
    rdbOpcaoCorretaD.Checked := False;
    rdbOpcaoCorretaE.Checked := False;
  finally
    AtribuirEventoAosEdits;
    AtribuirEventoAosRadioButtons;
  end;
end;

procedure TFCadastroPerguntas.PerguntaAfterScroll(DataSet: TDataSet);
var
  ds: TDataSet;
begin
  LimparCampos;
  ds := Conexao.ObterRespostas(dsPergunta.DataSet.FieldByName('pergunta_id').AsInteger);
  try
    RemoverEventoDosEdits;
    RemoverEventoDosRadioButtons;
    while not(ds.Eof) do
    begin
      case ds.RecNo of
        1: begin
             edtRespostaA.Text := ds.FieldByName('texto').AsString;
             rdbOpcaoCorretaA.Checked := ds.FieldByName('correta').AsBoolean;
           end;
        2: begin
             edtRespostaB.Text := ds.FieldByName('texto').AsString;
             rdbOpcaoCorretaB.Checked := ds.FieldByName('correta').AsBoolean;
           end;
        3: begin
             edtRespostaC.Text := ds.FieldByName('texto').AsString;
             rdbOpcaoCorretaC.Checked := ds.FieldByName('correta').AsBoolean;
           end;
        4: begin
             edtRespostaD.Text := ds.FieldByName('texto').AsString;
             rdbOpcaoCorretaD.Checked := ds.FieldByName('correta').AsBoolean;
           end;
        5: begin
             edtRespostaE.Text := ds.FieldByName('texto').AsString;
             rdbOpcaoCorretaE.Checked := ds.FieldByName('correta').AsBoolean;
           end;
      end;
      ds.Next;
    end;
  finally
    AtribuirEventoAosEdits;
    AtribuirEventoAosRadioButtons;
    FreeAndNil(ds);
  end;
end;

procedure TFCadastroPerguntas.PerguntaBeforePost(DataSet: TDataSet);
begin
  case (Application.MessageBox(PWideChar('Deseja realmente salvar as alterações?'),
                               PWideChar('Pergunta...'),
                               MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3)) of
    mrNo: dsPergunta.DataSet.Cancel;
    mrCancel: Abort;
  end;
end;

procedure TFCadastroPerguntas.PerguntaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Trim(Copy(Sender.AsString, 1, 85));

  if (Length(Trim(Sender.AsString)) > 85) then
    Text := Text + '...';
end;

procedure TFCadastroPerguntas.RadioButtonClick(Sender: TObject);
begin
  if not(EstaInserindoOuEditando) then
    dsPergunta.DataSet.Edit;
end;

procedure TFCadastroPerguntas.RemoverEventoDosEdits;
begin
  edtRespostaA.OnChange := nil;
  edtRespostaB.OnChange := nil;
  edtRespostaC.OnChange := nil;
  edtRespostaD.OnChange := nil;
  edtRespostaE.OnChange := nil;
end;

procedure TFCadastroPerguntas.RemoverEventoDosRadioButtons;
begin
  rdbOpcaoCorretaA.OnClick := nil;
  rdbOpcaoCorretaB.OnClick := nil;
  rdbOpcaoCorretaC.OnClick := nil;
  rdbOpcaoCorretaD.OnClick := nil;
  rdbOpcaoCorretaE.OnClick := nil;
end;

procedure TFCadastroPerguntas.SalvarAlteracoes(const ExibirPergunta: Boolean);
var
  Salvar, Inserindo: Boolean;
  PerguntaId: Integer;
  Respostas: TRespostas;
  Resposta: TResposta;
begin
  if (EstaInserindoOuEditando) then
  begin
    Salvar := True;

    if (ExibirPergunta) then
      case (Application.MessageBox(PWideChar('Deseja realmente salvar as alterações?'),
                                   PWideChar('Pergunta...'),
                                   MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3)) of
        mrYes: Salvar := True;
        mrNo: Salvar := False;
        mrCancel: Abort;
      end;

    if (Salvar) and (ValidarRespostas) then
    begin
      Inserindo := EstaInserindo;
      if (Inserindo) then
        PerguntaId := Conexao.SalvarPergunta(Trim(memPergunta.Text))
      else
      begin
        PerguntaId := dsPergunta.DataSet.FieldByName('pergunta_id').AsInteger;
        Conexao.SalvarPergunta(PerguntaId, Trim(memPergunta.Text));
      end;

      SetLength(Respostas, 5);
      Resposta := TResposta.Create;
      Resposta.Resposta := Trim(edtRespostaA.Text);
      Resposta.Correta := rdbOpcaoCorretaA.Checked;
      Respostas[0] := Resposta;

      Resposta := TResposta.Create;
      Resposta.Resposta := Trim(edtRespostaB.Text);
      Resposta.Correta := rdbOpcaoCorretaB.Checked;
      Respostas[1] := Resposta;

      Resposta := TResposta.Create;
      Resposta.Resposta := Trim(edtRespostaC.Text);
      Resposta.Correta := rdbOpcaoCorretaC.Checked;
      Respostas[2] := Resposta;

      Resposta := TResposta.Create;
      Resposta.Resposta := Trim(edtRespostaD.Text);
      Resposta.Correta := rdbOpcaoCorretaD.Checked;
      Respostas[3] := Resposta;

      Resposta := TResposta.Create;
      Resposta.Resposta := Trim(edtRespostaE.Text);
      Resposta.Correta := rdbOpcaoCorretaE.Checked;
      Respostas[4] := Resposta;

      Conexao.SalvarRespostas(PerguntaId, Respostas);

      for Resposta in Respostas do
        Resposta.Free;

      dspergunta.DataSet.Cancel;
      dsPergunta.DataSet.Refresh;

      if (Inserindo) then
        dsPergunta.DataSet.Last;
    end;
  end;
end;

function TFCadastroPerguntas.ValidarRespostas: Boolean;
var
  Mensagens: TStringList;
begin
  Result := False;
  Mensagens := TStringList.Create;
  try
    if (Trim(memPergunta.Text) = EmptyStr) then
      Mensagens.Add('  - A pergunta não pode ficar em branco.');

    if (Trim(edtRespostaA.Text) = EmptyStr) then
      Mensagens.Add('  - A resposta A não pode ficar em branco.');
    if (Trim(edtRespostaB.Text) = EmptyStr) then
      Mensagens.Add('  - A resposta B não pode ficar em branco.');
    if (Trim(edtRespostaC.Text) = EmptyStr) then
      Mensagens.Add('  - A resposta C não pode ficar em branco.');
    if (Trim(edtRespostaD.Text) = EmptyStr) then
      Mensagens.Add('  - A resposta D não pode ficar em branco.');
    if (Trim(edtRespostaE.Text) = EmptyStr) then
      Mensagens.Add('  - A resposta E não pode ficar em branco.');

    if not(rdbOpcaoCorretaA.Checked) and
       not(rdbOpcaoCorretaB.Checked) and
       not(rdbOpcaoCorretaC.Checked) and
       not(rdbOpcaoCorretaD.Checked) and
       not(rdbOpcaoCorretaE.Checked) then
      Mensagens.Add('  - Selecione qual é a opção correta.');

    if (Mensagens.Count = 0) then
      Result := True
    else
      Application.MessageBox(PWideChar('É necessário resolver as seguintes pendências antes de continuar:' + sLineBreak +
                                       Mensagens.Text),
                             PWideChar('Atenção...'),
                             MB_ICONWARNING);
  finally
    FreeAndNil(Mensagens);
  end;
end;

end.
