program AnnManager;

uses
  ShareMem,
  Forms,
  Windows,
  Dialogs,
  HSDialogs,
  SysUtils,
  uMain in 'uMain.pas' {fmAnnManager},
  Utils in 'Utils.pas',
  uAppInfo in 'uAppInfo.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  intf_access in 'intf_access.pas',
  uStruct in 'uStruct.pas',
  Intf_fi in 'intf_fi.pas',
  EventSettings in 'EventSettings.pas' {fmEventSettings},
  AirportList in 'AirportList.pas' {fmAirportList},
  SingleMessage in 'SingleMessage.pas' {fmSingleMessage},
  uMsgStantardSettings in 'uMsgStantardSettings.pas' {fmMsgStantardSettings},
  uAnnLog in 'uAnnLog.pas' {frmAnnLog},
  uSeconds in 'uSeconds.pas' {frmSeconds},
  uLanguages in 'uLanguages.pas' {frmLanguages},
  uZones in 'uZones.pas' {frmZones},
  Intf_AnnApLib in 'intf_AnnApLib.pas',
  uLangRules in 'uLangRules.pas' {frmLangRules},
  uZoneDef in 'uZoneDef.pas' {frmZoneDef},
  uGateExit in 'uGateExit.pas' {frmGateExit},
  uDelayReason in 'uDelayReason.pas' {fmDelayReason},
  uTemplateEdit in 'uTemplateEdit.pas' {fmTemplateEdit},
  uDelayEdit in 'uDelayEdit.pas' {DelayEdit},
  SAPIInterface in 'SAPIInterface.pas',
  uCheckinTempl in 'uCheckinTempl.pas' {fmCheckinTempl},
  uCheckinTemplEdit in 'uCheckinTemplEdit.pas' {fmCheckinTemplEdit},
  EventSettingsDemo in 'EventSettingsDemo.pas' {TfmEventSettingsDemo},
  uAdd in 'uAdd.pas' {Form1};

{$R *.res}

const
  RES_LOGIN_DLL = 'LoginDLL.dll';

var
  HM: THandle;
  LoginDllHandle: THandle;
  ModulesPath, strCon: String;

  Proc: function (ParentApp: TApplication; const strCon: PChar;
                  const strProg: PChar): String; stdcall;


function Check: boolean;
begin
  HM := OpenMutex(MUTEX_ALL_ACCESS, false, 'MyOwnMutex');
  Result := (HM <> 0);
  if HM = 0 then
    HM := CreateMutex(nil, false, 'MyOwnMutex');
end;


begin
  if Check then
    if HSMessageDlg('AnnManager уже запущен. Продолжить запуск?',mtConfirmation,[mbYes,mbNo],0)=7 then exit;
  Application.Initialize;

  //ShowMessage('1');

  Application.Title := 'Звуковое информирование пассажиров';
  DM:=TDM.Create(Application);

  DM.InitConnections;
  strCon:=DM.Rdscon.ConnectionString;

  LoginDllHandle:= 0;
  ModulesPath:= ExtractFilePath(Application.ExeName);

    if FileExists(ModulesPath + '\' + RES_LOGIN_DLL) then
    begin
      LoginDllHandle:= LoadLibrary(PChar(ModulesPath + '\' + RES_LOGIN_DLL));
         // ShowMessage('3');
      Assert(LoginDllHandle > 0, 'ERROR' + ' ' + RES_LOGIN_DLL);
      @Proc:= GetProcAddress(LoginDllHandle, 'Login');
         // ShowMessage('4');
      Assert(Assigned(Proc), 'ERROR' + ' Login in DLL: ' + RES_LOGIN_DLL);

         // ShowMessage(strCon);
      AppInfo.AccessLogin:=Proc(Application, PChar(strCon), PChar(C_PROG));
        //  ShowMessage('6');
      if AppInfo.AccessLogin = '' then
        Exit
      else
      begin
        Application.CreateForm(TfmAnnManager, fmAnnManager);
  Application.CreateForm(TTfmEventSettingsDemo, TfmEventSettingsDemo);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
      end;
    end
    else
    begin
      MessageBox(Application.Handle, PChar('Не найдена библиотека Login.dll'), PChar('Ошибка при загрузке Login.dll'), MB_OK);
      DM.Free;
     // Application.Terminate;
      //exit;
    end;

{  if DM.lgn.Execute then
  begin
//    DM.InitConnections('ggv'); {временно}
    {Application.CreateForm(TfmAnnManager, fmAnnManager);
  //  Application.CreateForm(TfmFlightMessage, fmFlightMessage);
//  Application.CreateForm(TfmTemplates, fmTemplates);
  Application.Run;
  end
  else
  begin
    DM.Free;
    Application.Terminate;
  end; }
end.
