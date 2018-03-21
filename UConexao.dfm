object FConexao: TFConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 78
  Width = 156
  object Conexao: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\alessandro.risse\Desktop\ReviewQuiz\Win32\Debu' +
        'g\DLL\reviewquiz.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 20
    Top = 20
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrHourGlass
    Left = 98
    Top = 20
  end
end
