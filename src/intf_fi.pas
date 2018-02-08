unit Intf_fi;

interface

uses
  Windows,  Forms;

const
 Default_ConStr='Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=NSI;Data Source=sql052b\srvr052b';

procedure RunFlightInfo(AHandle: THandle; ID_SPP, ID_MRSHR: Integer; AConnString, ALogin, AProgName: PChar);

implementation
uses
  SysUtils;

type

  TrFI = procedure (AHandle: THandle; ID_SPP, ID_MRSHR: Integer; AConnString, ALogin, AProgName: PChar); stdcall;

const
  DLL_NAME = 'FlightInfo.dll';

var
  DllHandle: THandle = 0;
  tr1: TrFI = nil;

function LoadLibrary(AError: boolean = false): boolean;
begin
 Result := DllHandle > 0;
 if not Result then
 begin
  DllHandle := windows.LoadLibrary(DLL_NAME);
  Result := DllHandle > 0;
  if not Result and AError then
   RaiseLastWin32Error
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

procedure RunFlightInfo(AHandle: THandle; ID_SPP, ID_MRSHR: Integer; AConnString, ALogin, AProgName: PChar);
begin
  if LoadLibrary then
  begin
    if not Assigned(@tr1) then
      @tr1 := GetProcAddress(DllHandle, 'RunFlightInfo1');
    if Assigned(tr1) then
      tr1(AHandle,ID_SPP,ID_MRSHR,AConnString,ALogin,AProgName);
  end;
end;

initialization

finalization
 if DllHandle > 0 then
  FreeLibrary(DllHandle);
end.
