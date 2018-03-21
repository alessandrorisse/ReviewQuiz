unit UConfiguracoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UConexao;

type
  TFConfiguracoes = class(TForm)
    grbEquipe: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtNomeEquipe1: TEdit;
    edtNomeEquipe2: TEdit;
    edtNomeEquipe3: TEdit;
    edtNomeEquipe4: TEdit;
    btnIniciarNovoJogo: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    btnCadastroPerguntas: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnIniciarNovoJogoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCadastroPerguntasClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Conexao: TFConexao;
    Alterando: Boolean;

    procedure CarregarDadosEquipes;

  public
    class procedure Execute(AOwner: TComponent);
  end;

var
  FConfiguracoes: TFConfiguracoes;

implementation

{$R *.dfm}

uses UTipos, UCadastroPerguntas;

procedure TFConfiguracoes.btnCadastroPerguntasClick(Sender: TObject);
begin
  TFCadastroPerguntas.Execute(Self);
end;

procedure TFConfiguracoes.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFConfiguracoes.btnIniciarNovoJogoClick(Sender: TObject);
begin
  if (Application.MessageBox(PWideChar('Deseja realmente iniciar um novo jogo?' + sLineBreak +
                                       'Isto apagará todos os dados do jogo anterior e não poderá ser desfeita.'),
                             PWideChar('Atenção...'),
                             MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = mrYes) then
  begin
    Conexao.LimparDadosEquipes;
    edtNomeEquipe1.Clear;
    edtNomeEquipe2.Clear;
    edtNomeEquipe3.Clear;
    edtNomeEquipe4.Clear;
    edtNomeEquipe1.SetFocus;
  end;
end;

procedure TFConfiguracoes.btnSalvarClick(Sender: TObject);
var
  Equipes: TEquipes;
  Equipe: TEquipe;
begin
  if (Trim(edtNomeEquipe1.Text) <> EmptyStr) and
     (Trim(edtNomeEquipe2.Text) <> EmptyStr) and
     (Trim(edtNomeEquipe3.Text) <> EmptyStr) and
     (Trim(edtNomeEquipe4.Text) <> EmptyStr) then
  begin
    try
      SetLength(Equipes, 4);

      Equipe := TEquipe.Create;
      Equipe.EquipeId := 1;
      Equipe.Nome := Trim(edtNomeEquipe1.Text);
      Equipes[0] := Equipe;

      Equipe := TEquipe.Create;
      Equipe.EquipeId := 2;
      Equipe.Nome := Trim(edtNomeEquipe2.Text);
      Equipes[1] := Equipe;

      Equipe := TEquipe.Create;
      Equipe.EquipeId := 3;
      Equipe.Nome := Trim(edtNomeEquipe3.Text);
      Equipes[2] := Equipe;

      Equipe := TEquipe.Create;
      Equipe.EquipeId := 4;
      Equipe.Nome := Trim(edtNomeEquipe4.Text);
      Equipes[3] := Equipe;

      if (Alterando) then
        Conexao.AlterarEquipes(Equipes)
      else
        Conexao.CadastrarEquipes(Equipes);
    finally
      for Equipe in Equipes do
        Equipe.Free;
    end;

    ModalResult := mrOk;
  end
  else
    Application.MessageBox(PWideChar('É necessário informar o nome das quatro equipes.'),
                           PWideChar('Atenção...'),
                           MB_ICONWARNING);
end;

procedure TFConfiguracoes.CarregarDadosEquipes;
begin
  edtNomeEquipe1.Text := Conexao.ObterNomeEquipe(1);
  edtNomeEquipe2.Text := Conexao.ObterNomeEquipe(2);
  edtNomeEquipe3.Text := Conexao.ObterNomeEquipe(3);
  edtNomeEquipe4.Text := Conexao.ObterNomeEquipe(4);

  Alterando := (edtNomeEquipe1.Text <> EmptyStr);
end;

class procedure TFConfiguracoes.Execute(AOwner: TComponent);
var
  Tela: TFConfiguracoes;
begin
  Tela := TFConfiguracoes.Create(AOwner);
  try
    Tela.ShowModal;
  finally
    FreeAndNil(Tela);
  end;
end;

procedure TFConfiguracoes.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult <> mrOk then
    CanClose := (Application.MessageBox(PWideChar('Deseja realmente cancelar as alterações?'),
                                        PWideChar('Pergunta...'),
                                        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = mrYes);
end;

procedure TFConfiguracoes.FormCreate(Sender: TObject);
begin
  Conexao := TFConexao.GetInstancia;
end;

procedure TFConfiguracoes.FormShow(Sender: TObject);
begin
  CarregarDadosEquipes;
end;

end.
