unit uAppInfo;

interface

uses
  Windows,LMWksta,lmglobal,lmaccess,SysUtils,WinSock,IniFiles,Registry;

const
  C_SQLLogin='kobra_ann';           // sql логин
  C_SQLPass='k@78p$';               // sql пароль
  C_PROG = 'kobra_ann';            // имя программы ac_p_programs
  strConn =
  'Provider=SQLOLEDB.1;'+
  'Persist Security Info=True;'+
  'Data Source=%s;'+
  'Initial Catalog=%s;'+
  'Use Procedure for Prepare=1;'+
  'Auto Translate=True;'+
  'Packet Size=4096;'+
  'Workstation ID=%s;'+
  'Application Name=%s;'+
  'User ID=%s;'+
  'Password=%s;'+
  'Use Encryption for Data=False;'+
  'Tag with column collation when possible=False';

  strMessList =
  'select id, mtext, dt, CONVERT(varchar(8),dt,8) as dtm, voice=''111'', sounded from %s (nolock) where id_zo=%s and sounded=0 order by YEAR(dt), MONTH(dt), DAY(dt), DATEPART(HH,dt), dbo.fnANN_DatePartMinute(10,dt), prt ';//DATEPART(MI,dt),prt';// dt'; 01.11.2010

  strLanguages =
  'select l.id as l_id, l.lang as l_lang, l.caption as l_caption, v.id as v_id, v.name as v_name from ANN_ZONE_VOICE z (nolock) '+
  'left join ANN_VOICES v (nolock) on z.id_voice=v.id '+
  'left join ANN_LANGUAGES l (nolock) on l.id=v.id_lang '+
  'where z.id_zone=%s';

  strSounded =
  'update %s set sounded=1 where id=%s';

  strReadOnOff=
  'select on_off from ANN_ON_OFF (nolock) where (id_zone=%s) or (id_zone=0)';

  strSaveOnOff=
  'update ANN_ON_OFF set on_off=%s, dk=getdate() where (id_zone=%s) or (id_zone=0)';

  strZones = 'select z.id as z_id,z.zone,zv.[default],l.id as l_id,l.caption,l.lang, o.on_off from ANN_ZONES z (nolock) '+
             'left join ANN_ZONE_VOICE zv (nolock) on z.id=zv.id_zone '+
             'left join ANN_VOICES v (nolock) on zv.id_voice=v.id '+
             'left join ANN_LANGUAGES l (nolock) on l.id=v.id_lang '+
             'left join ANN_ON_OFF o (nolock) on o.id_zone=z.id';

type

  TIniData = record
    Server: String;
    Base: String;
    MainBase: String; //RDS -> ANN
    Table: String;
    ID_ZONE: String;
  end;

  TFileVersionNum = packed record
    case Integer of
    0: (MinorVer: Word;
        MajorVer: Word;
        Build: Word;
        Release: Word);
    1: (QWord: Int64);
    2: (DWords: array[0..1] of DWord);
    3: (Words: array[0..3] of Word);
  end;

  TRights = record
    EditStands: Boolean;
    CapAn     : Boolean;
  end;

  TFileVersionInfo = record
    FileVersionNum: TFileVersionNum;
    CompanyName: String;
    FileDescription: String;
    FileVersion: String;
    InternalName: String;
    LegalCopyright: String;
    LegalTrademarks: String;
    OriginalFilename: String;
    ProductName: String;
    ProductVersion: String;
    Comments: String;
  end;

  TAppInfo = record
    VR: String;
    Rights: TRights;
    Workstation: String;
    IP: String;
    NTDomain: String;
    NTServer: String;
    NTUser: String;
    NTUserQualifiedName: String;
    NTUserFullName: String;
    SQLLogin: String;
    SQLPass: String;
    AccessProg: String;
    AccessLogin: String;
    AccessFIO: String;
    CurrentDir: String;
    AppDir: String;
    AppName: String;
    FileVer: TFileVersionInfo;
    AppNameWithVer: String;
    IniFileName: String;
    IniData: TIniData;
  end;

  var
    AppInfo: TAppInfo;

  procedure InitApp;
  procedure GetFileVersion(aFileName: String; var aFileVersionInfo: TFileVersionInfo);
  function GetLocalIP: string;
  procedure ReadIniFile;
//  procedure LoadFromRegistry;
//  procedure SaveToRegistry;


implementation

procedure InitApp;

  function _GetComputerName: string;
  var
    _sz: cardinal;
  begin
    _sz := 255;
    SetLength(Result, _sz);
    GetComputerName(PChar(Result), _sz);
    SetLength(Result, _sz)
  end;

var
  _FullAppName: String;
  p: Pointer;
  w: WKSTA_USER_INFO_1;
begin
  with AppInfo do
  begin
    Workstation := _GetComputerName;

    if NetWkstaUserGetInfo(nil, 1, p) = NERR_Success then begin
      w := PWKSTA_USER_INFO_1(p)^;
      with w do begin;
        NTDomain := wkui1_logon_domain;
        NTServer := wkui1_logon_server;
        NTUser := wkui1_username;
      end;

      if NetUserGetInfo(w.wkui1_logon_server, w.wkui1_username, 10, p) = NERR_Success then
        with PUSER_INFO_10(p)^ do
          NTUserFullName := usri10_full_name;

      NTUserQualifiedName := NTDomain + '\' + NTUser;
      if NTUserFullName = EmptyStr then
        NTUserFullName := 'Полное имя не задано';
    end;

    CurrentDir := IncludeTrailingPathDelimiter(ExpandUNCFileName(GetCurrentDir));
    _FullAppName := ExpandUNCFileName(ParamStr(0));
    AppDir := ExtractFilePath(_FullAppName);
    AppName := ExtractFileName(_FullAppName);

    IniFileName := ChangeFileExt(AppName, '.ini');
    if FileExists(CurrentDir + IniFileName) then
      IniFileName := CurrentDir + IniFileName
    else if FileExists(AppDir + IniFileName) then
      IniFileName := AppDir + IniFileName
    else
      IniFileName := CurrentDir + IniFileName;

    GetFileVersion(_FullAppName, FileVer);
    with FileVer do
      AppNameWithVer := Format('Cobra/%s.v.%s', [InternalName, FileVersion]);
    try
      IP := GetLocalIP;
    except
      IP := 'Ошибка при определении IP';
    end;
    SQLLogin:=C_SQLLogin;
    SQLPass:=C_SQLPass;
    AccessProg:=C_PROG;
  end;
  ReadIniFile;
end;

procedure GetFileVersion(aFileName: String; var aFileVersionInfo: TFileVersionInfo);
var
  _Buf: PChar;
  _Size: DWORD;
  _Handle: DWORD;
  _Length: DWORD;
  _VSFixedFileInfo: PVSFixedFileInfo;
  _String: PChar;
begin
  FillChar(aFileVersionInfo, SizeOf(aFileVersionInfo), 0);

  _Size := GetFileVersionInfoSize(PChar(aFileName), _Handle);
  if _Size > 0 then begin
    _Buf := AllocMem(_Size);
    try
      if GetFileVersionInfo(PChar(aFileName), 0, _Size, _Buf) then
        with aFileVersionInfo do begin
          if VerQueryValue(_Buf, '\', Pointer(_VSFixedFileInfo), _Length) then
            with _VSFixedFileInfo^ do begin
              FileVersionNum.DWords[0] := dwFileVersionMS;
              FileVersionNum.DWords[1] := dwFileVersionLS;
            end;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\CompanyName', Pointer(_String), _Length) then
            CompanyName := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\FileDescription', Pointer(_String), _Length) then
            FileDescription := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\FileVersion', Pointer(_String), _Length) then
            FileVersion := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\InternalName', Pointer(_String), _Length) then
            InternalName := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\LegalCopyright', Pointer(_String), _Length) then
            LegalCopyright := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\LegalTrademarks', Pointer(_String), _Length) then
            LegalTrademarks := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\OriginalFilename', Pointer(_String), _Length) then
            OriginalFilename := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\ProductName', Pointer(_String), _Length) then
            ProductName := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\ProductVersion', Pointer(_String), _Length) then
            ProductVersion := _String;

          if VerQueryValue(_Buf, '\StringFileInfo\041904E3\Comments', Pointer(_String), _Length) then
            Comments := _String;
        end;
    finally
      FreeMem(_Buf, _Size);
    end;
  end;
end;

function GetLocalIP: string;
type
  PArrOfPtr = ^TArrOfPtr;
  TArrOfPtr = array [0..$FF] of PInAddr;
var
  _WSA: TWSAData;
  _Name: array[0..$FF] of Char;
  _PHostEnt: PHostEnt;
  _List: TArrOfPtr;
  i: Integer;
begin
  Result := EmptyStr;
  WSAStartup($0101, _WSA);
  GetHostName(_Name, $FF);
  _PHostEnt := GetHostByName(_Name);
  if _PHostEnt <> nil then begin
    _List := PArrOfPtr(_PHostEnt^.h_addr_list)^;
    for i := Low(TArrOfPtr) to High(TArrOfPtr) do begin
      if _List[i] = nil then Break;
      if Result = EmptyStr then
        Result := inet_ntoa(_List[i]^)
      else
        Result := Result + ListSeparator + ' ' + inet_ntoa(_List[i]^);
    end;
  end;
  WSACleanup;
end;

procedure ReadIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetCurrentDir+'\'+AppInfo.FileVer.OriginalFilename+'.ini');
  with AppInfo.IniData do
    try
      Server := IniFile.ReadString('Connection', 'Server', '.');
      Base := IniFile.ReadString('Connection', 'Base', 'RDS');
      MainBase := IniFile.ReadString('Connection','MainBase','ANN'); 
      TABLE := IniFile.ReadString('Connection', 'Table', '111');
      ID_ZONE := IniFile.ReadString('Settings', 'ID_ZONE', '111');
    finally
      IniFile.Free;
    end;
end;
{
procedure LoadFromRegistry;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKeyReadOnly('\Software\РИВЦ-Пулково\Schedule\'+AppInfo.AccessFIO+'\Settings') then
    begin
      if ValueExists('VR') then
        AppInfo.VR:=ReadString('VR')
    end;
  finally
    CloseKey;
    Free;
  end;
end;
procedure SaveToRegistry;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey('\Software\РИВЦ-Пулково\Schedule\'+AppInfo.AccessFIO+'\Settings', true) then
    begin
      WriteString('VR',AppInfo.VR);
   end
  finally
    CloseKey;
    Free;
  end;
end;
}




end.
 