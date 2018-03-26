unit UConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, UTipos, FireDAC.Comp.UI, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Comp.DataSet;

type
  TFConexao = class(TDataModule)
    Conexao: TFDConnection;
    WaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private
    class var _Conexao: TFConexao;

    function ExecutarConsulta(const sql: String): TFDQuery;
    procedure ExecutarComando(const sql: String);
    function TratarCaracteresEspeciais(const Texto: String): String;

  public
    class function GetInstancia: TFConexao;
    function BuscarPerguntaERespostas(const PerguntaId: Integer;
      out Pergunta: TPergunta; out Respostas: TRespostas): Boolean;
    procedure RegistrarAcerto(const Equipe: Integer);
    procedure LimparDadosEquipes;
    procedure CadastrarEquipes(const Equipes: TEquipes);
    procedure AlterarEquipes(const Equipes: TEquipes);
    function ObterClassificacaoAtual: TEquipes;
    function ObterNomeEquipe(const EquipeId: Integer): String;
    function ObterListaPerguntas: TFDQuery;
    function ObterRespostas(const PerguntaId: Integer): TFDQuery;
    procedure ApagarPergunta(const PerguntaId: Integer);
    function SalvarPergunta(const Pergunta: String): Integer; overload;
    procedure SalvarPergunta(const PerguntaId: Integer; const Pergunta: String); overload;
    procedure SalvarRespostas(const PerguntaId: Integer; Respostas: TRespostas);

    destructor Destroy; Override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TFConexao }

procedure TFConexao.AlterarEquipes(const Equipes: TEquipes);
var
  Equipe: TEquipe;
  sql: String;
begin
  sql := EmptyStr;
  for Equipe in Equipes do
    sql := sql + ' UPDATE equipe' +
                 '    SET nome = "' + TratarCaracteresEspeciais(Equipe.Nome) + '"' +
                 ' WHERE equipe_id = ' + Equipe.EquipeId.ToString + ';' + sLineBreak;

  ExecutarComando(sql);
end;

procedure TFConexao.ApagarPergunta(const PerguntaId: Integer);
var
  sql: string;
begin
  sql := ' DELETE FROM resposta' +
         ' WHERE pergunta_id = ' + IntToStr(PerguntaId);
  ExecutarComando(sql);

  sql := ' DELETE FROM pergunta' +
         ' WHERE pergunta_id = ' + IntToStr(PerguntaId);
  ExecutarComando(sql);
end;

function TFConexao.BuscarPerguntaERespostas(const PerguntaId: Integer;
  out Pergunta: TPergunta; out Respostas: TRespostas): Boolean;
var
  sql: String;
  ds: TFDQuery;
  Resp: TResposta;
begin
  Result := False;

  sql := ' SELECT texto' +
         ' FROM pergunta' +
         ' WHERE pergunta_id = ' + IntToStr(PerguntaId);
  ds := ExecutarConsulta(sql);

  if (ds.IsEmpty) then
  begin
    FreeAndNil(ds);
    Exit;
  end;

  Pergunta := TPergunta.Create;
  Pergunta.PerguntaId := PerguntaId;
  Pergunta.Pergunta := ds.FieldByName('texto').AsString;
  FreeAndNil(ds);

  sql := ' SELECT resposta_id' +
         '      , texto' +
         '      , correta' +
         ' FROM resposta' +
         ' WHERE pergunta_id = ' + IntToStr(PerguntaId) +
         ' ORDER BY resposta_id';
  ds := ExecutarConsulta(sql);

  if (ds.IsEmpty) then
  begin
    FreeAndNil(ds);
    FreeAndNil(Pergunta);
    Exit;
  end;

  SetLength(Respostas, ds.RecordCount);

  while not(ds.Eof) do
  begin
    Resp := TResposta.Create;
    Resp.RespostaId := ds.FieldByName('resposta_id').AsInteger;
    Resp.Resposta := ds.FieldByName('texto').AsString;
    Resp.Correta := ds.FieldByName('correta').AsBoolean;

    Respostas[ds.RecNo - 1] := Resp;

    ds.Next;
  end;
  FreeAndNil(ds);

  Result := True;
end;

procedure TFConexao.CadastrarEquipes(const Equipes: TEquipes);
var
  Equipe: TEquipe;
  sql: String;
begin
  sql := 'INSERT INTO equipe (nome) VALUES';

  for Equipe in Equipes do
    sql := sql + ' ("' + TratarCaracteresEspeciais(Equipe.Nome) + '"),' + sLineBreak;

  sql := Trim(sql);
  sql := Copy(sql, 1, Length(sql) - 1);
  ExecutarComando(sql);
end;

procedure TFConexao.DataModuleCreate(Sender: TObject);
begin
  Conexao.Params.Database := '.\DLL\reviewquiz.db';
  Conexao.Connected := True;
end;

procedure TFConexao.DataModuleDestroy(Sender: TObject);
begin
  Conexao.Connected := False;
end;

destructor TFConexao.Destroy;
begin
  if (Assigned(_Conexao)) then
    FreeAndNil(_Conexao);

  inherited;
end;

procedure TFConexao.ExecutarComando(const sql: String);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  Query.Connection := Conexao;
  Query.SQL.Text := sql;
  Query.ExecSQL;
  FreeAndNil(Query);
end;

function TFConexao.ExecutarConsulta(const sql: String): TFDQuery;
begin
  Result := TFDQuery.Create(Self);
  Result.Connection := Conexao;
  Result.Open(sql);
end;

class function TFConexao.GetInstancia: TFConexao;
begin
  if not Assigned(_Conexao) then
    _Conexao := TFConexao.Create(nil);

  Result := _Conexao;
end;

procedure TFConexao.LimparDadosEquipes;
var
  sql: string;
begin
  sql := 'DELETE FROM equipe;';
  sql := sql + 'UPDATE sqlite_sequence SET seq = 0 WHERE name = ''equipe'';';
  sql := sql + 'VACUUM;';
  ExecutarComando(sql);
end;

function TFConexao.ObterClassificacaoAtual: TEquipes;
var
  sql: String;
  ds: TFDQuery;
  Equipe: TEquipe;
begin
  sql := ' SELECT nome' +
         '      , acertos' +
         ' FROM equipe' +
         ' ORDER BY acertos DESC';
  ds := ExecutarConsulta(sql);

  if not(ds.IsEmpty) then
    SetLength(Result, 4);
    while not(ds.Eof) do
    begin
      Equipe := TEquipe.Create;
      Equipe.Nome := ds.FieldByName('nome').AsString;
      Equipe.Pontos := ds.FieldByName('acertos').AsInteger;

      Result[ds.RecNo - 1] := Equipe;

      ds.Next;
    end;

  FreeAndNil(ds);
end;

function TFConexao.ObterListaPerguntas: TFDQuery;
var
  sql: String;
begin
  sql := ' SELECT pergunta_id' +
         '      , texto' +
         ' FROM pergunta' +
         ' ORDER BY pergunta_id';
  Result := ExecutarConsulta(sql);
end;

function TFConexao.ObterNomeEquipe(const EquipeId: Integer): String;
var
  sql: String;
  ds: TFDQuery;
begin
  sql := ' SELECT nome' +
         ' FROM equipe' +
         ' WHERE equipe_id = ' + IntToStr(EquipeId);
  ds := ExecutarConsulta(sql);
  Result := ds.FieldByName('nome').AsString;
  FreeAndNil(ds);
end;

function TFConexao.ObterRespostas(const PerguntaId: Integer): TFDQuery;
var
  sql: String;
begin
  sql := ' SELECT texto' +
         '      , correta' +
         ' FROM resposta' +
         ' WHERE pergunta_id = ' + PerguntaId.ToString +
         ' ORDER BY resposta_id';
  Result := ExecutarConsulta(sql);
end;

procedure TFConexao.RegistrarAcerto(const Equipe: Integer);
var
  sql: string;
begin
  sql := ' UPDATE equipe' +
         ' SET acertos = acertos + 1' +
         ' WHERE equipe_id = ' + IntToStr(Equipe);
  ExecutarComando(sql);
end;

function TFConexao.SalvarPergunta(const Pergunta: String): Integer;
var
  sql: String;
  ds: TFDQuery;
begin
  sql := ' INSERT INTO pergunta (texto)' +
         ' VALUES ("' + TratarCaracteresEspeciais(Pergunta) + '")';
  ExecutarComando(sql);

  sql := 'SELECT last_insert_rowid()';
  ds := ExecutarConsulta(sql);
  Result := ds.Fields[0].AsInteger;
  ds.Free;
end;

procedure TFConexao.SalvarPergunta(const PerguntaId: Integer; const Pergunta: String);
var
  sql: String;
begin
  sql := ' UPDATE pergunta' +
         ' SET texto = "' + TratarCaracteresEspeciais(Pergunta) + '"' +
         ' WHERE pergunta_id = ' + PerguntaId.ToString;
  ExecutarComando(sql);
end;

procedure TFConexao.SalvarRespostas(const PerguntaId: Integer; Respostas: TRespostas);
var
  Resposta: TResposta;
  sql: String;
begin
  sql := ' DELETE FROM resposta' +
         ' WHERE pergunta_id = ' + PerguntaId.ToString;
  ExecutarComando(sql);

  for Resposta in Respostas do
  begin
    sql := ' INSERT INTO resposta (pergunta_id, texto, correta)' +
           ' VALUES (' + PerguntaId.ToString + ', "' + TratarCaracteresEspeciais(Resposta.Resposta) + '", ' + Resposta.Correta.ToString + ')';
    ExecutarComando(sql);
  end;
end;

function TFConexao.TratarCaracteresEspeciais(const Texto: String): String;
begin
  Result := StringReplace(Texto, '''', '''''', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '''', [rfReplaceAll]);
end;

end.
