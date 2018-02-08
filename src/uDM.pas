unit uDM;

interface

uses
  SysUtils, Classes, DB, ADODB, Login, intf_access, uAppInfo, Forms, Windows, uStruct;

type
  TDM = class(TDataModule)
    con: TADOConnection;
    qQry: TADOQuery;
    spRefresh: TADOStoredProc;
    spTemplates: TADOStoredProc;
    RDScon: TADOConnection;
    procedure lgnLogin(ALoginName: String; var ALogOn: Boolean);
    procedure lgnLoginChange(ALoginName: String; var AEnabled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function CheckDoubleUsers(ALogin: String): Boolean;
    procedure SaveAccessControl;
  protected
    FCOP : string;
  public
    ListFD : TListFD;
    ListMess: TMessList;
    ListEvent: TEventList;
    property COP : string read FCOP write FCOP; // логин
    procedure InitConnections(ALogin: String); overload;
    procedure InitConnections; overload;
    procedure RefreshDep(AIdZone: Integer);
    procedure RefreshMessList(AIdZone: Integer);
    procedure RefreshListEvent;
    procedure AddToLog(_Act,_Before,_After:string);
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

uses Utils, Dialogs, HSDialogs;

procedure TDM.lgnLogin(ALoginName: String; var ALogOn: Boolean);
  procedure ReadRights;
  begin

    //AppInfo.Rights.FI := IsAccess('flightinfo', AppAccessAlias);
  end;
var
  _loginResult: Boolean;
begin
  ALogOn:=False;
  InitConnections(ALoginName);
  case InitUser(ALoginName,AppInfo.AccessProg,DM.RDScon.ConnectionString,True) of
  iusSuccess:
  begin
    if CheckDoubleUsers(ALoginName) then
    begin
      Application.MessageBox('Извините, но в данный момент, под введенным Вами именем, уже кто-то работает с программой','Ошибка авторизации',MB_ICONERROR);
      exit;
    end;
    AppInfo.AccessLogin:=ALoginName;
    AppInfo.AccessFIO:=FIO(AppInfo.AccessLogin,DM.RDScon.ConnectionString,True);
    ALogOn:=True;
    COP := ALoginName;
    SaveAccessControl;
  end;
  iusUnknownUser:
    Application.MessageBox('Пользователя с таким именем не существует','Ошибка авторизации',MB_ICONERROR);
  iusRefusal:
    Application.MessageBox('Отсутствуют права на запуск приложения','Ошибка авторизации',MB_ICONERROR);
  iusError:
    Application.MessageBox('Неизвестная ошибка','Ошибка авторизации',MB_ICONERROR);
  end;
end;

procedure TDM.lgnLoginChange(ALoginName: String; var AEnabled: Boolean);
begin
  AEnabled:=length(ALoginName)>2;
end;

procedure TDM.InitConnections(ALogin: String);
begin
  DM.con.Connected:=False;
  DM.con.ConnectionString:=Format(strConn, [AppInfo.IniData.Server, AppInfo.IniData.MainBase, AppInfo.Workstation, AppInfo.AppNameWithVer+' ('+LowerCase(Trim(ALogin))+')', AppInfo.SQLLogin, AppInfo.SQLPass]);
  DM.RDScon.Connected:=False;
  DM.RDScon.ConnectionString:=Format(strConn, [AppInfo.IniData.Server, AppInfo.IniData.Base, AppInfo.Workstation, AppInfo.AppNameWithVer+' ('+LowerCase(Trim(ALogin))+')', AppInfo.SQLLogin, AppInfo.SQLPass]);
  RefreshListEvent;
end;

procedure TDM.InitConnections;
begin
  DM.con.Connected:=False;
  DM.con.ConnectionString:=Format(strConn, [AppInfo.IniData.Server, AppInfo.IniData.MainBase, AppInfo.Workstation, AppInfo.AppNameWithVer, AppInfo.SQLLogin, AppInfo.SQLPass]);
  DM.RDScon.Connected:=False;
  DM.RDScon.ConnectionString:=Format(strConn, [AppInfo.IniData.Server, AppInfo.IniData.Base, AppInfo.Workstation, AppInfo.AppNameWithVer, AppInfo.SQLLogin, AppInfo.SQLPass]);
  RefreshListEvent;
end;


function TDM.CheckDoubleUsers(ALogin: String): Boolean;
begin
  Result:=False;
  qQry.Sql.Clear;
  qQry.SQL.Add(Format('SELECT DISTINCT hostprocess FROM master..sysprocesses WHERE RTRIM(program_name) LIKE ''%s''', ['Cobra/Schedule.v.% (' + ALogin + ')']));
  qQry.Open;
  if qQry.RecordCount > 1 then
    Result:=True
end;

procedure TDM.SaveAccessControl;
var
  _user : array[0..255] of char;
  _comp : array[0..255] of char;
  _size : Cardinal;
  strCompany  : String;
  strComment  : String;
  strDescription : String;
  spAccess : TADOStoredProc;
begin

  spAccess := TADOStoredProc.Create(nil);
  spAccess.Connection := RDScon;
  spAccess.ProcedureName := 'spAP_SCHED_SaveAccessControl';
  try
    with spAccess do
    begin
      Parameters.Refresh;
      Parameters.ParamByName('@wks').Value := AppInfo.Workstation;
      Parameters.ParamByName('@application').Value := AppInfo.AppNameWithVer;
      Parameters.ParamByName('@uname').Value := AppInfo.AccessLogin;
      Parameters.ParamByName('@version').Value := AppInfo.FileVer.FileVersion;
      Parameters.ParamByName('@ip').Value := AppInfo.IP;

      ExecProc;
    end;
  finally
    spAccess.Free;
  end;

end;


procedure TDM.DataModuleCreate(Sender: TObject);
begin
    InitApp;

    // Здесь вызвать ф-цию аутентификации пользователя
    // UserLogin;

    ListMess:=TMessList.Create;
    ListFD:=TListFD.Create;
    ListEvent:=TEventList.Create;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  ListMess.Free;
  ListFD.Free;
  ListEvent.Free;
end;

procedure TDM.RefreshDep(AIdZone: Integer);
var
  _sp: TADOStoredProc;
  _i: Integer;
  _r: Integer;
  _f: TFlightDep;
begin
  _r:=-1;
  _i:=1;
  try
    ListFD.Clear;
    _sp:= TADOStoredProc.Create(nil);
    _sp.CursorType := ctStatic;
    _sp.LockType := ltReadOnly;
    _sp.Connection:=DM.con;
    _sp.ProcedureName:='[dbo].[spANN_LoadSpp]';
    _sp.Parameters.Refresh;
    _sp.Parameters.ParamByName('@dt').Value:=Date;
    _sp.Parameters.ParamByName('@id_zone').Value:=AIdZone;
    _sp.Parameters.ParamByName('@bArr').Value:=0;
    _sp.Open;
    while not _sp.Eof do
    begin
      _f:=TFlightDep.Create;
      _f.iIdSpp:=_sp.Fields.FieldByName('id').AsInteger;
      _f.cNR:=_sp.Fields.FieldByName('nr').AsString;
      _f.cAP:=_sp.Fields.FieldByName('ap').AsString;
      _f.dtRB:=_sp.Fields.FieldByName('vnr').AsDateTime;
      _f.dtRE:=_sp.Fields.FieldByName('vor').AsDateTime;
      _f.dtEB:=_sp.Fields.FieldByName('vnp').AsDateTime;
      _f.dtEE:=_sp.Fields.FieldByName('vop').AsDateTime;
      _f.dtDTM:=_sp.Fields.FieldByName('dtm').AsDateTime;
      ListFD.Add(_f);
      _sp.Next;
    end;
  finally
    _sp.Free;
  end;
end;

procedure TDM.RefreshMessList(AIdZone: Integer);
var
  _sp  : TADOStoredProc;
  _i   : integer;
  _m   : TMess;
begin
    _sp := TADOStoredProc.Create(nil);
    ListMess.Clear;
    with _sp do
    try
        CursorType := ctStatic;
        LockType := ltReadOnly;
        Connection := DM.con;

        {
        // Обновить информацию по ЗС, в том числе инициированным Визинформом.
        // ProcedureName:='[dbo].[spAnn_UpdateAutoStartMessages]';
        ProcedureName := '[dbo].[spAnn_UpdateAutoStartVisinform]';
        Parameters.Refresh;
        Parameters.ParamByName('@dt').Value := Date;
        ExecProc;

        if Parameters.ParamByName('@RETURN_VALUE').Value <> 0 then
            HSMessageDlg('Невозможно получить данные из Визинформ !!!', mtError, [mbOk], 0);
        }

        ProcedureName:='[dbo].[spANN_LoadMessList]';
        Parameters.Refresh;
        Parameters.ParamByName('@id_zone').Value:=AIdZone;
        Open;
        while not Eof do
        begin
            _m := TMess.Create;
            _m.id := FieldByNaME('id').AsInteger;
            _m.mtext := FieldByNaME('mtext').AsString;
            _m.dt := FieldByNaME('dt').AsDateTime;
            _m.nr := FieldByNaME('nr').ASString;
            _m.id_spp := FieldByNaME('id_spp').AsInteger;
            _m.id_sched_templ := FieldByNaME('id_sched_templ').AsInteger;
            _m.voice := FieldByNaME('voice').AsString;
            _m.id_zone := FieldByNaME('id_zo').AsInteger;
            _m.zone := FieldByNaME('zone').AsString;
            DM.ListMess.Add(_m);
            Next;
        end;
    finally
        _sp.Free;
    end;
end;



procedure TDM.RefreshListEvent;
var
  _sp: TADOStoredProc;
  _i: Integer;
  _r: Integer;
  _e: TEvent;
 // f:System.Text;
begin
  _r:=-1;
  _i:=1;
  try
    ListEvent.Clear;
    _sp:= TADOStoredProc.Create(nil);
    _sp.CursorType := ctStatic;
    _sp.LockType := ltReadOnly;
    _sp.Connection:=DM.con;
    //System.Assign(f,'1.txt');
   // System.Rewrite(f);
  //  System.Writeln(f,DM.con.ConnectionString);
  //  System.Close(f);
    _sp.ProcedureName:='[dbo].[spANN_LoadEvents]';
    _sp.Parameters.Refresh;
    _sp.Open;
    while not _sp.Eof do
    begin
      _e:=TEvent.Create;
      _e.id:=_sp.Fields.FieldByName('id').AsInteger;
      _e.event:=_sp.Fields.FieldByName('event').AsString;
      _e.caption:=_sp.Fields.FieldByName('caption').AsString;
      _e.bArr:=iif(_sp.Fields.FieldByName('pv').AsString='В',False,True);
      ListEvent.Add(_e);
      _sp.Next;
    end;
  finally
    _sp.Free;
  end;
end;

procedure TDM.AddToLog(_Act,_Before,_After:string);
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=con;
    ProcedureName:='[dbo].[spANN_AddToLogActions]';
    Parameters.Refresh;
    Parameters.ParamByName('@cop').Value:=Cop;
    Parameters.ParamByName('@act').Value:=_Act;
    Parameters.ParamByName('@before').Value:=_Before;
    Parameters.ParamByName('@after').Value:=_After;
    ExecProc;      
  finally
    Free;
  end;
end;


end.
