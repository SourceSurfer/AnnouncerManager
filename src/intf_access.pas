unit intf_access;

interface

uses
  Windows;

type
  TInitUserStatus = (iusSuccess,      //вход разрешен
                     iusError,        //ошибка
                     iusUnknownUser,  //несуществующий пользователь
                     iusRefusal);     //запрет на вход в программу

const
  // Default_ConStr='Provider=SQLOLEDB.1;Password=k%1g0;Persist Security Info=True;Initial Catalog=RDS;Data Source=SQL022B\SRVR022B;User ID=kobra_schedule';
  Default_ConStr='Provider=SQLOLEDB.1;Password=k%1g0;Persist Security Info=True;Initial Catalog=RDS;Data Source=SQL052B\SRVR052B;User ID=kobra_schedule';
  ProgrammName = 'sched';

function InitUser(const uname, pname_exe: ShortString; constr: string = Default_ConStr; ShowError: boolean = true): TInitUserStatus;
function IsAccess(const Func, pname_exe: ShortString; ShowError: boolean = true): boolean;
function ViewPermissions(AppHandle: THandle; constr: string = Default_ConStr; ShowError: boolean = true): boolean;
function FIO(const uname: ShortString; constr: string = Default_ConStr; ShowError: boolean = true) : ShortString; stdcall;

implementation

uses
  SysUtils;

type
  TInitUserFunc = function (const uname, pname_exe: ShortString; constr: PChar): TInitUserStatus; stdcall;
  TIsAccessFunc = function (const Func, pname_exe: ShortString): Boolean; stdcall;
  TViewPermissionsFunc = function (AppHande: THandle; constr: PChar): boolean; stdcall;
  TFIOFunc = function (const uname: ShortString; constr: PChar) : ShortString; stdcall;

const
  DLL_NAME = 'access.dll';
  INIT_USER_NAME = 'InitUser';
  IS_ACCESS_NAME = 'IsAccess';
  VIEW_PERMISSIONS_NAME = 'ViewPermissions';
  FIO_NAME = 'FIO';
var
  DllHandle: THandle = 0;
  InitUserF: TInitUserFunc = nil;
  IsAccessF: TIsAccessFunc = nil;
  ViewPermissionsF: TViewPermissionsFunc = nil;
  FIOF: TFIOFunc = nil;

function LoadLibrary: boolean;
begin
 Result := DllHandle > 0;
 if not Result then begin
  DllHandle := windows.LoadLibrary(DLL_NAME);
  Result := DllHandle > 0
 end
end;

procedure RaiseNotDll;
begin
 raise Exception.create('Не найдена необходимая библиотека: ' + DLL_NAME + '!'#13#10'Код ошибки: ' + IntToStr(GetLastError))
end;

procedure RaiseNotFunction(const FuncName: string);
begin
 raise Exception.create('В библиотеке: ' + DLL_NAME + ' не найдена необходимая функция: ' + FuncName + '!' +
                        #13#10'Код ошибки: ' + IntToStr(GetLastError))
end;

function InitUser(const uname, pname_exe: ShortString; constr: string = Default_ConStr; ShowError: boolean = true): TInitUserStatus;
begin
 Result := iusError;
 if LoadLibrary then begin
  if not Assigned(@InitUserF) then
   @InitUserF := GetProcAddress(DllHandle, INIT_USER_NAME);
  if Assigned(@InitUserF) then
   Result := InitUserF(uname, pname_exe, PChar(constr))
  else if ShowError then
   RaiseNotFunction(INIT_USER_NAME)
 end
 else if ShowError then
  RaiseNotDll
end;

function IsAccess(const Func, pname_exe: ShortString; ShowError: boolean = true): boolean;
begin
 Result := false;
 if LoadLibrary then begin
  if not Assigned(@IsAccessF) then
   @IsAccessF := GetProcAddress(DllHandle, IS_ACCESS_NAME);
  if Assigned(@IsAccessF) then
   Result := IsAccessF(Func, pname_exe)
  else if ShowError then
   RaiseNotFunction(IS_ACCESS_NAME)
 end
 else if ShowError then
  RaiseNotDll
end;

function FIO(const uname: ShortString; constr: string = Default_ConStr; ShowError: boolean = true): Shortstring;
begin
 Result := '';
 if LoadLibrary then begin
  if not Assigned(@FIOF) then
   @FIOF := GetProcAddress(DllHandle, FIO_NAME);
  if Assigned(@FIOF) then
   Result := FIOF(uname, PChar(constr))
  else if ShowError then
   RaiseNotFunction(FIO_NAME)
 end
 else if ShowError then
  RaiseNotDll
end;

function ViewPermissions(AppHandle: THandle; constr: string = Default_ConStr; ShowError: boolean = true): boolean;
begin
 Result := false;
 if LoadLibrary then begin
  if not Assigned(@ViewPermissionsF) then
   @ViewPermissionsF := GetProcAddress(DllHandle, VIEW_PERMISSIONS_NAME);
  if Assigned(@ViewPermissionsF) then
   Result := ViewPermissionsF(AppHandle, PChar(constr))
  else if ShowError then
   RaiseNotFunction(VIEW_PERMISSIONS_NAME)
 end
 else if ShowError then
  RaiseNotDll
end;

initialization

finalization

 if DllHandle > 0 then
  FreeLibrary(DllHandle);

end.


