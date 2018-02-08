unit uStruct;

interface

uses   Classes, Contnrs, SysUtils, ADODB;

type
  TEvent = class
    id: integer;
    event: String;
    caption: String;
    bArr: Boolean;
  end;

  TEventList = class(TObjectList)
  private
    function GetItem(Index: Integer): TEvent;
  public
    property Items[Index: Integer]: TEvent read GetItem; default;
  end;

  TMess = class
    id: Integer;
    id_spp: Integer;
    nr: String;
    dt: TDateTime;
    mtext: String;
    voice: string;
    id_sched_templ : integer;
    id_zone : integer;
    zone : string;
    constructor Create;
  end;

  TMessList = class(TObjectList)
  private
    function GetItem(Index: Integer): TMess;
  public
    property Items[Index: Integer]: TMess read GetItem; default;
  end;

  TMessInfo = record
    id : Integer;
    id_spp : integer;
    id_sched_templ : integer;
    voice: string;
    id_zone: integer;
    zone : string;
  end;

  PMessInfo = ^TMessInfo;

  TDepEvents = (deNULL,deRB, deRC, deRF, deRE, deGB, deGC, deGF, deGE);

  TFlightDep = class
  public
    iIdSpp: Integer;
    cNR: String;
    cNR2: String;
    cAK: String;
    cAP: String;
    iVR: integer;
    dtDTM: TDateTime;
    dtRB: TDateTime;
    dtRE: TDateTime;
    dtEB: TDateTime;
    dtEE: TDateTime;
    Event: TDepEvents;
    bSounded: Boolean;
    bRegAuto: Boolean;
    bExitAuto: Boolean;
    constructor Create;
  end;

  TListFD = class(TObjectList)
  private
    function GetItem(Index: Integer): TFlightDep;
  public
    constructor Create; reintroduce;
    property Items[Index: Integer]: TFlightDep read GetItem; default;
  end;

  TGlobalStruct = class;

  TLang = class
  public
    id: Integer;
    caption: String;
    lang: String[3];
    default: Boolean;
    constructor Create;
    destructor Destroy;
  end;

  TVoice = class
    id: Integer;
    voice: String;
    language: TLang;
  end;

  TZone = class(TObjectList)
  private
    Owner: TGlobalStruct;
    fOnOff: Integer;  // Boolean -> Integer
    fLoaded: Boolean;
    function GetItem(Index: Integer): TLang;
    procedure SetOnOff(AValue: Integer);  // Boolean -> Integer
    function SaveOnOff: Boolean;
  public
    id: Integer;
    name: String;
    IsNull: Boolean;
    property OnOff: Integer read fOnOff write SetOnOff; // Boolean -> Integer
    constructor Create(AOwner: TGlobalStruct);
    destructor Destroy; override;
    property Items[Index: Integer]: TLang read GetItem; default;
  end;

  TGlobalStruct = class(TObjectList)
  private
    fConStr: String;
    function GetItem(Index: Integer): TZone;
  public
    property Items[Index: Integer]: TZone read GetItem; default;
    property ConStr: String read fConStr write fConStr;
    constructor Create;
    destructor Destroy; override;
    procedure LoadData(ACon: TADOConnection);
    function GetIndexById (Id: Integer): Integer;
    function GetById(Id: Integer): TZone;
  end;


implementation

uses uAppInfo, DB;

{ TZone }

constructor TZone.Create(AOwner: TGlobalstruct);
begin
  id:=0;
  Owner:=AOwner;
  fLoaded:=false;
end;

destructor TZone.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TZone.GetItem(Index: Integer): TLang;
begin
  Result:=TLang(inherited Items[Index]);
end;



function TZone.SaveOnOff: Boolean;
var
  _sp: TADOStoredProc;
  _con: TADOConnection;
begin
  Result:=False;
  _con:=TADOConnection.Create(nil);
  _con.ConnectionString:=Owner.ConStr;
  _con.LoginPrompt := false;
  _con.ConnectOptions := coAsyncConnect;
  _con.Mode := cmRead;
  _sp:=TADOStoredProc.Create(nil);
  _sp.Connection:=_con;
  _sp.ProcedureName:='[dbo].[spANN_SaveOnOff]';
  _sp.CursorType := ctStatic;
  _sp.LockType := ltReadOnly;
  _sp.Parameters.Refresh;
  _sp.Parameters.ParamByName('@id_zone').Value:=id;
  _sp.Parameters.ParamByName('@bOnOff').Value:=OnOff;
  _sp.Parameters.ParamByName('@aEngine').Value:='';
  try
    _sp.ExecProc;
    Result:=True;
  except

  end;
end;

procedure TZone.SetOnOff(AValue: Integer); //Boolean ->Integer
begin
  fOnOff:=AValue;
  if fLoaded then
    SaveOnOff;
end;

{ TGlobalStruct }

constructor TGlobalStruct.Create;
begin

end;

destructor TGlobalStruct.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TGlobalStruct.GetById(Id: Integer): TZone;
var
  i: Integer;
begin
  i := GetIndexById(Id);
  if i <> -1 then
    Result := TZone(List^[i])
  else
    Result := Nil;
end;

function TGlobalStruct.GetIndexById(Id: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if TZone(List^[i]).Id = Id then
    begin
      Result := i;
      Break;
    end;
end;

function TGlobalStruct.GetItem(Index: Integer): TZone;
begin
  Result:=TZone(inherited Items[Index]);
end;

procedure TGlobalStruct.LoadData(ACon: TADOConnection);
var
  _q: TADOQuery;
  _z: TZone;
  _l: TLang;
  _id: Integer;
begin
    ConStr:=ACon.ConnectionString;
    _id:=0;
    try
        _q:=TADOQuery.Create(nil);
        _q.Connection:=ACon;
        _q.SQL.Clear;
        _q.SQL.Text:=strZones;
        try
            _q.Open;
            while not _q.Eof do
            begin
                if _id<>_q.Fields.FieldByName('z_id').AsInteger then
                begin
                    _z:=TZone.Create(Self);
                    _z.id:=_q.Fields.FieldByName('z_id').AsInteger;
                    _z.name:=_q.Fields.FieldByName('zone').AsString;
                    _z.OnOff:=_q.Fields.FieldByName('on_off').AsInteger;   //Boolean -> Integer
                    Add(_z);
                    _id:=_q.Fields.FieldByName('z_id').AsInteger;
                    _z.fLoaded:=True;
                end;
                _l:=TLang.Create;
                _l.id:=_q.Fields.FieldByName('l_id').AsInteger;
                _l.caption:=_q.Fields.FieldByName('caption').AsString;
                _l.default:=_q.Fields.FieldByName('default').AsBoolean;
                _l.lang:=_q.Fields.FieldByName('lang').AsString;
                Items[Count-1].Add(_l);
                _q.Next;
            end;
        except
        end;
    finally
        _q.Free;
    end;

    // Стартовая установка времени изменения списка рейсов
{    with TADOStoredProc.Create(nil) do
    try
        Connection := ACon;
        ProcedureName := 'dbo.spANN_SetStartDate';
        Parameters.Refresh;
        Parameters.ParamByName('@COP').Value := AppInfo.AccessLogin;
        ExecProc;
    finally
        Free;
    end; }
end;




{ TLang }

constructor TLang.Create;
begin
  id:=0;
end;

destructor TLang.Destroy;
begin

end;

{ TFlightsDep }

constructor TListFD.Create;
begin
  inherited Create;
end;

function TListFD.GetItem(Index: Integer): TFlightDep;
begin
  Result:=TFlightDep(inherited Items[Index]);
end;

{ TFlightDep }

constructor TFlightDep.Create;
begin
  Event:=deNULL;
end;

function TMessList.GetItem(Index: Integer): TMess;
begin
  Result:=TMess(inherited Items[Index]);
end;

{ TMess }

constructor TMess.Create;
begin
  mtext:='';
end;

{ TEventList }

function TEventList.GetItem(Index: Integer): TEvent;
begin
  Result:=TEvent(inherited Items[Index]);
end;

end.
