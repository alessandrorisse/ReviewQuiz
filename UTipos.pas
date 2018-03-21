unit UTipos;

interface

{$M+}

type
  TPergunta = class
  private
    FPerguntaId: Integer;
    FPergunta: String;
  published
    property PerguntaId: Integer read FPerguntaId write FPerguntaId;
    property Pergunta: String read FPergunta write FPergunta;
  end;

  TResposta = class
  private
    FRepostaId: Integer;
    FResposta: String;
    FCorreta: Boolean;
  published
    property RespostaId: Integer read FRepostaId write FRepostaId;
    property Resposta: String read FResposta write FResposta;
    property Correta: Boolean read FCorreta write FCorreta;
  end;

  TRespostas = array of TResposta;

  TEquipe = class
  private
    FNome: String;
    FPontos: Integer;
    FEquipeId: Integer;
  published
    property EquipeId: Integer read FEquipeId write FEquipeId;
    property Nome: String read FNome write FNome;
    property Pontos: Integer read FPontos write FPontos;
  end;

  TEquipes = array of TEquipe;

implementation

end.
