unit Intf_AnnApLib;

interface
uses
  Windows,  Forms;

const
 Default_ConStr='Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=RDS;Data Source=dvlpkobra';

procedure RunAnnApLib(AHandle: THandle; AConnString: PChar; ACOP: PChar);

implementation
uses
  SysUtils;

type
  TrAP = procedure (AHandle: THandle; AConnString: PChar; ACOP: PChar); stdcall;

const
  DLL_NAME = 'AnnApLib.dll';

var
  DllHandle: THandle = 0;
  tr1: TrAP = nil;

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

procedure RunAnnApLib(AHandle: THandle; AConnString: PChar; ACOP: PChar);
begin
  if LoadLibrary then
  begin
    if not Assigned(@tr1) then
      @tr1 := GetProcAddress(DllHandle, 'RunAnnApLib1');
    if Assigned(tr1) then
      tr1(AHandle, AConnString, ACOP);
  end;
end;

initialization

finalization

 if DllHandle > 0 then
  FreeLibrary(DllHandle);
end.
