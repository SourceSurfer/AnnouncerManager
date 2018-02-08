unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzStatus, RzSplit, Grids, ProfGrid, MyPrGrid,
  ComCtrls, ExListView, Buttons, RzButton, Menus, ActnList, ImgList, ADODB,
  StdCtrls, Mask, ToolEdit,{ SqlTree, }RzCmboBx, DateUtils, ActiveX,
  RzTabs, RzGroupBar, uStruct, Contnrs, Exceptor, RzEdit, DB,
  IniFiles,WinSock, RXCtrls, StrUtils, SAPIInterface, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient;


const
  LogMsgFormAuto = 'Автоматическое формирование сообщений рейса %s';
  LogMsgDeleteAll = 'Снятие с озвучки всех сообщений рейса %s';
  LogMsgAddOne = 'Формирование сообщения по рейсу %s для события %s';
  LogMsgDeleteOne = 'Снятие с озвучки сообщения по рейсу %s для события %s';
  LogMsgDeleteSingle = 'Удаление информационного сообщения %s из очереди ';

type
  TZoneItem = record
    IdZone:integer;
    IP:string;
end;

type
  TZoneList = class
  private
    fItems:array of TZoneItem;
    fCount:integer;
    procedure fAdd(fIdZone:integer; fIP:string);
    procedure fLoad;
  public
    constructor Create;
    function GetIPByZone(IdZone:integer):string;
end;

type
  TLoadStatus = (lsNone, lsBegin);

  TfmAnnManager = class;

  TListFlights = class;

  TFlight = class
  private
    Owner: TListFlights;
    iIdSpp: Integer;
    cNR: String;
    cNR_cs: String;
    cAK: String;
    cAK_cs: String;
    cAP: String;
    cAP_other: String;
    cVR: String;
    cKODK: String;
    dtDVZ: TDateTime;
    dtDTU: TDateTime;
    cPRICH: string;
    bDelayed: boolean;
    bArr: Boolean;
    dt1: TDateTime;
    dt2: TDateTime;
    dt3: TDateTime;
    dt4: TDateTime;
    dt5: TDateTime;
    Event: TDepEvents;
    bSounded: Boolean;
    FAuto: Boolean;
    bVisinAuto : boolean;
    iExecuteMode : integer;
    FExecuteMode : integer;
    sModeName : string;
    iport:integer;
    icompany:integer;
    ShowVPChange:boolean;
    procedure SetAuto(AValue: Boolean);
    procedure SetStatus(AValue : integer);
    function GetAuto: Boolean;
    procedure SaveAuto(ACon: TADOConnection);
  public
    constructor Create(AOwner: TListFlights);
    property Auto: Boolean read GetAuto write SetAuto;
    property ExecuteMode : integer read FExecuteMode write SetStatus;
  end;

  TListFlights = class(TObjectList)
  private
    Owner: TfmAnnManager;
    function GetItem(Index: Integer): TFlight;
  public
    constructor Create(AOwner: TfmAnnManager); reintroduce;
    property Items[Index: Integer]: TFlight read GetItem; default;
  end;

  TCurrentMess = class
  private
    fVoice:string;
    fMessText:string;
    fPlaying:boolean;
  public
    property Voice:string read fVoice write fVoice;
    property MessText:string read fMessText write fMessText;
    property Playing:boolean read fPlaying;
    constructor Create;
    procedure MessSpeak;
    procedure MessStop;
  end;


  TfmAnnManager = class(TForm)
    RzStatusBar1: TRzStatusBar;
    RzPanel1: TRzPanel;
    RzSplitter1: TRzSplitter;
    RzSplitter2: TRzSplitter;
    mpgDep: TMyProfGrid;
    al: TActionList;
    acRefresh: TAction;
    il: TImageList;
    tRefresh: TTimer;
    acFlightInfo: TAction;
    acStartStop: TAction;
    mpgArr: TMyProfGrid;
    acCreateMessRegExit: TAction;
    pmMessList: TPopupMenu;
    NDeleteMsg: TMenuItem;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    mpgAnn: TMyProfGrid;
    RzGroupBar1: TRzGroupBar;
    RzGroup1: TRzGroup;
    mpgEvents: TMyProfGrid;
    Panel1: TPanel;
    tbAuto: TRzToolButton;
    Exceptor1: TExceptor;
    ilSmall: TImageList;
    sbExecAll: TSpeedButton;
    sbStopAll: TSpeedButton;
    acExecAll: TAction;
    acStopAll: TAction;
    acShowLabel: TAction;
    lStatus: TLabel;
    mmSettings: TMainMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    NAddMsg: TMenuItem;
    NChangeMsg: TMenuItem;
    actMsgAdd: TAction;
    actMsgChange: TAction;
    actMsgDelete: TAction;
    tbMain: TRzToolbar;
    RzClockStatus1: TRzClockStatus;
    tbRefresh: TRzToolbarButton;
    tbFI: TRzToolButton;
    tbReisTemplates: TRzToolbarButton;
    tbSchedMsg: TRzToolbarButton;                                  
    tbCurrReis: TRzToolbarButton;
    RzSpacer1: TRzSpacer;
    RzGroupBox1: TRzGroupBox;
    RzReisEdit: TRzEdit;
    RzSpacer2: TRzSpacer;
    RzGroupBox2: TRzGroupBox;
    cbZone: TRzComboBox;
    tbStartStop: TRzToolButton;
    tUpdateVisinform: TTimer;
    VisinformADO: TADOStoredProc;
    RzGroupBox3: TRzGroupBox;
    lvCurrReis: TListView;
    Splitter1: TSplitter;
    RzGroupBox4: TRzGroupBox;
    lv: TListView;
    tbStdMsgEdit: TRzToolbarButton;
    tbLog: TRzToolbarButton;
    tAlert: TTimer;
    tbAlerts: TRzToolButton;
    tbStartTime: TRzToolButton;
    tbLanguages: TRzToolButton;
    RzGroup2: TRzGroup;
    mmMesText: TMemo;
    tbZones: TRzToolbarButton;
    actZoneOnOff: TAction;
    imgStop: TImageList;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    Label1: TLabel;
    Label2: TLabel;
    rzZonesBarCommon: TRzToolbar;
    NCancelMsg: TMenuItem;
    tStatus: TTimer;
    ppMain: TPopupMenu;
    pmRefresh: TMenuItem;
    pmAlerts: TMenuItem;
    pmReisInfo: TMenuItem;
    pmCurrentReis: TMenuItem;
    pmEditStandartMsg: TMenuItem;
    pmInfoTemplates: TMenuItem;
    pmGroupTemplates: TMenuItem;
    pmSoundedCancelledMsg: TMenuItem;
    pmPause: TMenuItem;
    pmLanguages: TMenuItem;
    pmZones: TMenuItem;
    pmMinimize: TMenuItem;
    pmExit: TMenuItem;
    tbLangRules: TRzToolButton;
    N1: TMenuItem;
    tSpeak: TTimer;
    rzZonesBar: TRzToolbar;
    Label3: TLabel;
    lbNextMess: TRxLabel;
    tbDelay: TRzToolButton;
    sbDelay: TSpeedButton;
    ppMenuDelay: TPopupMenu;
    acDelayExec: TAction;
    Label4: TLabel;
    tbSearch: TRzToolButton;
    Panel2: TPanel;
    btListen: TBitBtn;
    NCancelAllMsg: TMenuItem;
    udpClient: TIdUDPClient;
    Panel3: TPanel;
    btStop: TBitBtn;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbZone_Change(Sender: TObject);
    procedure tRefreshTimer(Sender: TObject);
    procedure acFlightInfoExecute(Sender: TObject);
    procedure mpgDepKeyPress(Sender: TObject; var Key: Char);
    procedure mpgDepDblClick(Sender: TObject);
    procedure acStartStopExecute(Sender: TObject);
    procedure mpgArrShowHint(Sender: TProfGrid; ACol, ARow: Integer;
      var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure mpgDepShowHint(Sender: TProfGrid; ACol, ARow: Integer;
      var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure mpgAnnShowHint(Sender: TProfGrid; ACol, ARow: Integer;
      var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure mpgAnnSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mpgEventsDblClick(Sender: TObject);
    procedure tbAutoClick(Sender: TObject);
    procedure cbModeChange(Sender: TObject);
    procedure tAutoModeRefreshTimer(Sender: TObject);
    procedure acExecAllUpdate(Sender: TObject);
    procedure acStopAllUpdate(Sender: TObject);
    procedure acShowLabelUpdate(Sender: TObject);
    procedure acShowLabelExecute(Sender: TObject);
    procedure sbExecAllClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure acStopAllExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NAddMsgClick(Sender: TObject);
    procedure NChangeMsgClick(Sender: TObject);
    procedure NDeleteMsgClick(Sender: TObject);
    procedure actMsgAddExecute(Sender: TObject);
    procedure actMsgChangeExecute(Sender: TObject);
    procedure actMsgDeleteExecute(Sender: TObject);
    procedure actMsgChangeUpdate(Sender: TObject);
    procedure actMsgDeleteUpdate(Sender: TObject);
    procedure cbZoneChange(Sender: TObject);
    procedure RzReisEditChange(Sender: TObject);
    procedure tbReisTemplatesClick(Sender: TObject);
    procedure tbCurrReisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tUpdateVisinformTimer(Sender: TObject);
    procedure mpgDepClick(Sender: TObject);
    procedure tbStdMsgEditClick(Sender: TObject);
    procedure tbLogClick(Sender: TObject);
    procedure mpgArrEnter(Sender: TObject);
    procedure mpgDepEnter(Sender: TObject);
    procedure tbAlertsClick(Sender: TObject);
    procedure tAlertTimer(Sender: TObject);
    procedure tbStartTimeClick(Sender: TObject);
    procedure tbLanguagesClick(Sender: TObject);
    procedure RzPageControl1Change(Sender: TObject);
    procedure lvSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure tbZonesClick(Sender: TObject);
    procedure actZoneOnOffExecute(Sender: TObject);
    procedure NCancelMsgClick(Sender: TObject);
    procedure tStatusTimer(Sender: TObject);
    procedure pmMinimizeClick(Sender: TObject);
    procedure pmExitClick(Sender: TObject);
    procedure tbLangRulesClick(Sender: TObject);
    procedure tSpeakTimer(Sender: TObject);
    procedure tbDelayClick(Sender: TObject);
    procedure sbDelayClick(Sender: TObject);
    procedure acDelayExecExecute(Sender: TObject);
    procedure tbSearchClick(Sender: TObject);
    procedure btListenClick(Sender: TObject);
    procedure NCancelAllMsgClick(Sender: TObject);
    procedure mpgAnnColumnResized(Sender: TProfGrid; Index, OldSize,
      NewSize: Integer);
    procedure btStopClick(Sender: TObject);
  private
    ActiveMpg: TMyProfGrid; //26072010 Романов, чтобы можно на вкладке СПП выбирать рейсы
    LS: TLoadStatus;
    fGS: TGlobalStruct;
    ListF  : TListFlights;
    fIdZone: Integer;
    fIdMode: Integer;
    FZoneChange : boolean;
    Curr_id_spp : Integer;
    UpdatedReises : integer;
    Curr_Alert:string;
    fRowHeight:integer;
    fZoneList:TZoneList;
    procedure RefreshDep;
    procedure RefreshArr;
    procedure RefreshMainGrid;
    procedure RefreshMessList;
    procedure InitGrids;
    procedure InitZones;
    procedure SetIdZone(AValue: Integer);
    procedure SetIdMode(AValue: Integer);
    function StartStop: Boolean;
   // procedure CreateMessage;
    procedure GetCodeShareInfo(_f:TFlight);
    procedure GetOtherPorts(_f:TFlight);
    procedure RefreshStruct(AIdZone: Integer; ACon: TADOConnection);
    procedure RefreshStructOptim(AIdZone: Integer; ACon: TADOConnection);
    procedure ExecuteListMessage(ACon : TADOConnection; AStart : integer);
    procedure RefreshMpgAnnRecord(id_spp : integer);
    procedure UpdateVisinform;
    procedure CurrReisMessList(spp_id : integer);
    function ReadOnOff:string; // узнать состояние AnnService
    procedure SetMainFunctionsDisabled; //В зависимости от прав доступа делать активными функции редактирования
    procedure BrushMpg(Mpg:TMyProfGrid);
    procedure RefreshZoneStatus;
    procedure RefreshDelays;
    procedure PgAutoSizeCells(pg:TProfGrid);
    procedure fSetRowHeight(fValue:integer);
    procedure fGetEvents(mpg:TMyProfGrid);
  public
    Alerted:boolean;
    Seconds:integer;
    ShowVisin:boolean;
    HoursBefore:integer;
    HoursAfter:integer;
    BeforeSpeak:integer;
    CurrentMess:TCurrentMess;
    property IdZone: Integer read fIdZone write SetIdZone;
    property IdMode: Integer read fIdMode write SetIdMode;
    property RowHeight: integer read fRowHeight write fSetRowHeight;
    property AnnServiceStatus: String read ReadOnOff;
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  end;

var
  fmAnnManager: TfmAnnManager;
  F:TIniFile;

implementation

{$R *.dfm}

uses uDM, uAppInfo, Utils, intf_fi,intf_access, HSDialogs, EventSettings, AirportList, // DB,
  Types, SingleMessage,uMsgStantardSettings,uAnnLog,uSeconds,uLanguages,uZones, uLangRules,
  uDelayReason, EventSettingsDemo, uAdd;


{For Graphic}  
    procedure MixBMP(BM1, BM2: TBitMap; var BM: TBitMap);  // для статуса запущенности AnnService на различных рабочих станциях
    var
      I, J: Integer;
      MinW, MinH: Integer;
    begin
      BM := TBitMap.Create;
      if BM1.Width < BM2.Width then
        MinW := BM1.Width
      else
        MinW := BM2.Width;
      if BM1.Height < BM2.Height then
        MinH := BM1.Height
      else
        MinH := BM2.Height;
      BM.Width := MinW;
      BM.Height := MinH;
      for I := 0 to MinW do
        for J := 0 to MinH do
          if (Odd(I) and Odd(J)) or ((not (Odd(I))) and (not (Odd(J)))) then
            BM.Canvas.Pixels[I, J] := BM1.Canvas.Pixels[I, J]
          else
            BM.Canvas.Pixels[I, J] := BM2.Canvas.Pixels[I, J];
    end;





{ TFlight }

constructor TFlight.Create(AOwner: TListFlights);
begin
  Owner:=AOwner;
  bSounded:=False;
  FAuto:=False;
end;

function TFlight.GetAuto: Boolean;
begin
  Result:=FAuto;
  Owner.Owner.tbAuto.Color:=iif(FAuto,clMoneyGreen,clBtnFace);
  Owner.Owner.tbAuto.Caption:=iif(FAuto,'Запущено','Старт авто');
  // Owner.Owner.mpgEvents.Enabled:=not FAuto; // RIVC_Nabatov 07042010 Убрал за ненадобностью
end;

procedure TFlight.SaveAuto(ACon: TADOConnection);
var
  _sp : TADOStoredProc;
begin
    try
        _sp := TADOStoredProc.Create(nil);
        _sp.Connection := ACon;
        _sp.ProcedureName:='[dbo].[spANN_SetAutoStart]'; //02112010
        _sp.Parameters.Refresh;
        _sp.Parameters.ParamByName('@id_zone').Value := Owner.Owner.IdZone;
        _sp.Parameters.ParamByName('@id_spp').Value := iIdSpp;
        _sp.Parameters.ParamByName('@id_event').Value := 0;
        _sp.Parameters.ParamByName('@seconds').Value := fmAnnManager.Seconds;
        _sp.Parameters.ParamByName('@start').Value := iif(Auto, 1, 0);
        _sp.ExecProc;

        if _sp.Parameters.ParamByName('@RETURN_VALUE').Value < 0 then
        begin
            HSMessageDlg('Ошибка обновления данных !!!', mtError, [mbOk], 0);
        end;
    finally
        _sp.Free;
    end;
end;

procedure TFlight.SetStatus(AValue : integer);
begin
    FExecuteMode := AValue;

    if Owner.Owner.LS = lsNone then
    begin
        DM.RefreshMessList(Owner.Owner.IdZone);
        Owner.Owner.RefreshMessList;
    end;
end;

procedure TFlight.SetAuto(AValue: Boolean);
begin
    FAuto := AValue;
    if Owner.Owner.LS = lsNone then
    begin
        SaveAuto(DM.con);
        DM.RefreshMessList(Owner.Owner.IdZone);
        Owner.Owner.RefreshMessList;
    end;
    Owner.Owner.tbAuto.Caption := iif(FAuto, 'Запущено', 'Старт авто');
    Owner.Owner.tbAuto.Color := iif(FAuto, clMoneyGreen, clBtnFace);
    // Owner.Owner.mpgEvents.Enabled := not FAuto; // RIVC_Nabatov 07042010 Убрал за ненадобностью

    // Проверка, режим ручной или полуавтомат.
    // В зависимости от результата устанавливаем иконку в графе Статус
end;

{ TListFlights }
constructor TListFlights.Create(AOwner: TfmAnnManager);
begin
  inherited Create;
  Owner:=AOwner;
end;

function TListFlights.GetItem(Index: Integer): TFlight;
begin
  Result:=TFlight(inherited Items[Index]);
end;


{ TCurrentMess}

constructor TCurrentMess.Create;
begin
  inherited Create;
  CreateSpeech;
  fPlaying:=false;
end;

procedure TCurrentMess.MessSpeak;
begin
  SelectEngine(fVoice);
  SetVolume(150);
  fPlaying:=true;
  fmAnnManager.btListen.Caption:='Остановить';
  Speak(fMessText);
end;

procedure TCurrentMess.MessStop;
begin
  fPlaying:=false;
  Stop;
  fmAnnManager.btListen.Caption:='Прослушать';
end;

{TZoneList}

procedure TZoneList.fAdd(fIdZone:integer; fIP:string);
begin
  inc(fCount);
  SetLength(fItems,fCount);
  fItems[fCount-1].IdZone:=fIdZone;
  fItems[fCount-1].IP:=fIP;
end;

procedure TZoneList.fLoad;
const
  SQLText = 'select id_zone, ip_address from dbo.ANN_ZONE_RULES (nolock) order by id_zone';
begin
  fItems:=nil;
  fCount:=0;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      fAdd(FieldByName('id_zone').AsInteger,
           FieldByName('ip_address').AsString);
      Next;
    end;
  finally
    Free;
  end;
end;

constructor TZoneList.Create;
begin
  inherited Create;
  fLoad;
end;

function TZoneList.GetIPByZone(IdZone:integer):string;
var
  i:integer;
begin
  result:='';
  for i:=0 to fCount-1 do
    if fItems[i].IdZone = IdZone then
    begin
      result:=fItems[i].IP;
      break; 
    end;
end;

{TfmAnnManager}
procedure TfmAnnManager.acRefreshExecute(Sender: TObject);
var
  AlSt:string;
  amp:TMyProfGrid;
  CanSelect:boolean;
begin
    try
        amp:=ActiveMpg;
        mpgAnn.DisableControls;
        mpgDep.DisableControls;
        mpgArr.DisableControls;

        fGs.Destroy;
        fGs:=TGlobalStruct.Create;
        fGs.LoadData(DM.con);
        //ShowMessage('Загрузили данные');

        LS:=lsBegin;
        DM.RefreshMessList(IdZone);
       // ShowMessage(IntToStr(IdZone));
       //ShowMessage('Обновили список сообщений');

        if FZoneChange then
        begin
            RefreshStruct(IdZone,DM.con);
         //   ShowMessage('RefreshStruct');
            RefreshDep;
            RefreshArr;
            RefreshMainGrid;
        end
        else
        begin
            RefreshStruct(IdZone,DM.con);
            //RefreshStructOptim(IdZone,DM.con);
           // ShowMessage('RefreshStructOptim');
            // Попытка предотвращения ненужной переделки списка // RIVC_Nabatov 02062010
           // if UpdatedReises > 0 then
         //   begin
                RefreshDep;
                RefreshArr;
                RefreshMainGrid;
         //   end;
        end;

        RefreshMessList;
   //   ShowMessage('Опять обновили список сообщений');

        AlSt:=AnnServiceStatus;
        Alerted:=(AlSt<>Curr_Alert) and (AlSt<>'');

        if not Alerted then tbAlerts.ImageIndex:=4;

        if RzPageControl1.ActivePageIndex = 0 then
          BrushMpg(mpgAnn)
        else
        begin
          BrushMpg(mpgDep);
          BrushMpg(mpgArr);
        end;
     //   ShowMessage('Расскрасили все');
        ActiveMpg:=amp;
        if ActiveMpg.RowCount>0 then
          ActiveMpg.OnSelectCell(ActiveMpg, ActiveMpg.Col, ActiveMpg.TopRow, CanSelect);
        if RzPageControl1.ActivePageIndex = 0 then
        begin
          mpgAnn.OnSelectCell(mpgAnn, mpgAnn.Col, mpgAnn.TopRow, CanSelect);
          fGetEvents(mpgAnn);
          BrushMpg(mpgAnn);
        end
        else
        begin
          if amp = mpgDep then
          begin
            mpgDep.OnSelectCell(mpgDep, mpgDep.Col, mpgDep.TopRow, CanSelect);
            fGetEvents(mpgDep);
            BrushMpg(mpgDep);
          end
          else
          begin
            mpgArr.OnSelectCell(mpgArr, mpgArr.Col, mpgArr.TopRow, CanSelect);
            fGetEvents(mpgArr);
            BrushMpg(mpgArr);
          end;
        end;

        if lv.Items.Count=0 then  mmMesText.Clear;
        //RefreshZoneStatus; // 18082010 Романов
       // ShowMessage('Обновили статус зон');
    finally
        LS := lsNone;
        mpgAnn.EnableControls;
        mpgDep.EnableControls;
        mpgArr.EnableControls;  
    end;
end;

constructor TfmAnnManager.Create(AOwner: TComponent);
begin

end;

//Запускаем сообщения в полуавтоматическом режиме, нажимаем на "Молнию" 
procedure TfmAnnManager.ExecuteListMessage(ACon : TADOConnection; AStart : integer);
var _sp : TADOStoredProc;
    _id_spp, _i : integer;
begin
    if LS = lsNone then
    try
        _i := ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value;  //mpgAnn -> ActiveMpg
        _id_spp := ListF[_i].iIdSpp;

        _sp := TADOStoredProc.Create(nil);
        _sp.Connection := ACon;
        _sp.ProcedureName:='[dbo].[spANN_SetAutoStart]';  //02112010
        _sp.Parameters.Refresh;
        _sp.Parameters.ParamByName('@id_zone').Value := IdZone;
        _sp.Parameters.ParamByName('@id_spp').Value := _id_spp;
        _sp.Parameters.ParamByName('@id_event').Value := 0;
        _sp.Parameters.ParamByName('@seconds').Value := Seconds; //04.08.2010
        _sp.Parameters.ParamByName('@start').Value := AStart;

        _sp.Open;

        if _sp.Fields[0].FieldName = 'ErrorMessage' then
        begin
            HSMessageDlg(_sp.FieldByName(_sp.FieldList.Fields[0].FieldName).AsString, mtError, [mbOk], 0);
            exit;
        end;

        if _sp.RecordCount > 0 then
        begin
            ListF[_i].cNR := _sp.Fields.FieldByName('nr').AsString;
            ListF[_i].cAP := _sp.Fields.FieldByName('ap').AsString;
            ListF[_i].cAK := _sp.Fields.FieldByName('ak').AsString;
            ListF[_i].bArr := iif(_sp.Fields.FieldByName('pv').AsString='В',False,True);
            ListF[_i].dt1 := _sp.Fields.FieldByName('dt1').AsDateTime;
            ListF[_i].dt2 := _sp.Fields.FieldByName('dt2').AsDateTime;
            ListF[_i].dt3 := _sp.Fields.FieldByName('dt3').AsDateTime;
            ListF[_i].dt4 := _sp.Fields.FieldByName('dt4').AsDateTime;
            ListF[_i].dt5 := _sp.Fields.FieldByName('dt5').AsDateTime;
            ListF[_i].FAuto := (_sp.Fields.FieldByName('start').AsInteger > 0);
            ListF[_i].bVisinAuto := _sp.Fields.FieldByName('visin_start').AsInteger>0;
            ListF[_i].ExecuteMode := _sp.Fields.FieldByName('ExecuteMode').AsInteger;
            ListF[_i].sModeName := _sp.Fields.FieldByName('ExecuteModeName').AsString;


            RefreshMpgAnnRecord(_id_spp);
        end;

        {
        _sp.ExecProc;
        if _sp.Parameters.ParamByName('@RETURN_VALUE').Value < 0 then
        begin
            HSMessageDlg('Ошибка обновления данных !!!', mtError, [mbOk], 0);
        end
        else
            result := _sp.Parameters.ParamByName('@RETURN_VALUE').Value;
        }
    finally
        _sp.Free;
    end;
end;

procedure TfmAnnManager.InitGrids;
var
  _i: Integer;

  procedure InitMpgInfo(var Mpg:TMyProfGrid);
  var
    _i:integer;
  begin
    with mpg do
    begin
      ColCount:=16;
      for _i:=1 to 4 do
        HideColumn(0);
      MergeHoriz(9,10,0);
      MergeHoriz(4,8,0);
      for _i:=0 to VisibleColCount do
      begin
        Cells[_i,0].TextAlignment:=taCenter;
        Cells[_i,0].TextLayout:=tlCenter;
        Cols[_i].TextAlignment:=taCenter;
        Cols[_i].TextLayout:=tlCenter;
      end;
      for _i:=0 to 11 do
      begin
        case _i of
        0: Cols[_i].Width:=10;
        1: Cols[_i].Width:=70;
        2: Cols[_i].Width:=150;
        3: Cols[_i].Width:=200;
        4,5,6,7,8,9: Cols[_i].Width:=40;
        10: Cols[_i].Width:=150;
        11: Cols[_i].Width:=48;
        end;
      end;
      Cols[4].Color:=clInfoBk;
      Cells[1,0].Value:='Рейс';
      Cells[2,0].Value:='Направление';
      Cells[3,0].Value:='Авиакомпания';
      Cells[4,0].Value:='Времена';
      Cells[9,0].Value:='Задержка';
      Cells[11,0].Value:='Статус';
    end;
  end;

begin

    with mpgDep do
    begin
        ColCount:=17;  //11 26072010 Романов
        HideColumn(0);
        HideColumn(0);
        HideColumn(0);  //26072010 Романов
        HideColumn(0);
        HideColumn(0);
        for _i:=0 to VisibleColCount do
        begin
            Cells[_i,0].TextAlignment:=taCenter;
            Cells[_i,0].TextLayout:=tlCenter;
            Cols[_i].TextAlignment:=taCenter;
            Cols[_i].TextLayout:=tlCenter;
        end;
        Cols[0].Width:=10;
        Cols[1].Width:=80;
        Cols[2].Width:=150;
        Cols[3].Width:=40;
        Cols[4].Width:=40;
        Cols[5].Width:=40;
        Cols[6].Width:=40;
        Cols[7].Width:=40;
        Cols[8].Width:=40;
        Cols[9].Width:=150;

        //Cols[7].Color:=clInfoBk;  09.08.2010 Романов
        Cells[1,0].Value:='рейс';
        Cells[2,0].Value:='направление';
        Cells[3,0].Value:='внр';
        Cells[4,0].Value:='вор';
        Cells[5,0].Value:='внп';
        Cells[6,0].Value:='воп';
        Cells[7,0].Value:='ввр';
        Cells[8,0].Value:='овв';
        Cells[9,0].Value:='причина задержки';
    end;
  with mpgArr do
  begin
    ColCount:=17;     //было 8 26072010 Романов
    HideColumn(0);
    HideColumn(0);
    HideColumn(0);   //26072010 Романов
    HideColumn(0);
    HideColumn(0);
    for _i:=0 to VisibleColCount-1 do
    begin
      Cells[_i,0].TextAlignment:=taCenter;
      Cells[_i,0].TextLayout:=tlCenter;
      Cols[_i].TextAlignment:=taCenter;
      Cols[_i].TextLayout:=tlCenter;
    end;
    Cols[0].Width:=10;
    Cols[1].Width:=80;
    Cols[2].Width:=150;
    Cols[3].Width:=40;
    Cols[4].Width:=40;
    Cols[5].Width:=40;
    Cols[6].Width:=40;
    Cols[7].Width:=150;
    //Cols[3].Color:=clInfoBk;  09.08.2010 Романов
    Cells[1,0].Value:='рейс';
    Cells[2,0].Value:='направление';
    Cells[3,0].Value:='впр';
    Cells[4,0].Value:='внб';
    Cells[5,0].Value:='воб';
    Cells[6,0].Value:='овп';
    Cells[7,0].Value:='причина задержки';
  end;
  with mpgAnn do
  begin
    ColCount:=17; // 12  // RIVC_Nabatov 29032010 Колонка режима обработки
    HideColumn(0);
    HideColumn(0);
    HideColumn(0);
    HideColumn(0);
    HideColumn(0);
    MergeHoriz(9,10,0);
    MergeHoriz(4,8,0);
    for _i:=0 to VisibleColCount-1 do
    begin
      Cells[_i,0].TextAlignment:=taCenter;
      Cells[_i,0].TextLayout:=tlCenter;
      Cols[_i].TextAlignment:=taCenter;
      Cols[_i].TextLayout:=tlCenter;
      Cols[_i].GraphicAlignment:=taCenter;
      Cols[_i].GraphicLayout:=tlCenter;
    end;
    Cols[0].Width:=10;
    Cols[1].Width:=80;
    Cols[2].Width:=150;
    Cols[3].Width:=200;
    Cols[4].Width:=40;
    Cols[5].Width:=40;
    Cols[6].Width:=40;
    Cols[7].Width:=40;
    Cols[8].Width:=40;
    Cols[9].Width:=40;
    Cols[10].Width:=150;
    Cols[11].Width:=48; // RIVC_Nabatov 29032010 Колонка режима обработки
    Cols[4].Color:=clInfoBk;
    Cells[1,0].Value:='Рейс';
    Cells[2,0].Value:='Направление';
    Cells[3,0].Value:='Авиакомпания';
    Cells[4,0].Value:='Времена';
    Cells[9,0].Value:='Задержка';
    Cells[11,0].Value:='Статус';
  end;
    with mpgEvents do
    begin
        ColCount := 9;
        HideColumn(0);
        HideColumn(0); // RIVC_Nabatov 01042010 Колонка для отметки запущенных ЗС
        HideColumn(0); // RIVC_Nabatov 01042010 Колонка для отметки озвученных ЗС
        HideColumn(0); // RIVC_Nabatov 07042010 Колонка для идентификатора ЗС
        HideColumn(0); // RIVC_Nabatov 07042010 Колонка для идентификатора ЗС
        HideColumn(0); //              14012014 Колонка для (де)активации события в зависимости от зоны
        Cols[0].Width := 20;
        Cols[0].GraphicAlignment := taCenter;
        Cols[0].GraphicLayout := tlCenter;

        Cols[1].Width := 180;
        Cols[1].TextAlignment := taLeftJustify;
        Cols[1].TextLayout := tlCenter;

        Cols[2].Width := 20;
        Cols[2].TextAlignment := taLeftJustify;
        Cols[2].TextLayout := tlCenter;
    end
end;

// Обновляем таблицу по отправлениям (вкладка СПП)
procedure TfmAnnManager.RefreshDep;
var
  _i: Integer;
  _k: Integer;
  _r: Integer;
  _curr_idSPP:integer;
  _Found:boolean;
  CanSelect:boolean;
  _tr:Integer;
begin
  _tr:=mpgDep.TopRow;
  if mpgDep.Row>0 then
    _curr_idSPP:=mpgDep.HiddenCols[0].Cells[mpgDep.Row].Value;
  mpgDep.RowCount:=1;
  _r:=-1;
  _k:=1;
  for _i:=0 to ListF.Count-1 do
    if not ListF.Items[_i].bArr then
    begin
      mpgDep.RowCount:=mpgDep.RowCount+1;
      mpgDep.Cells[1,_k].Value:=ListF.Items[_i].cNR;
      if ListF.Items[_i].cNR_cs<>'' then
        mpgDep.Cells[1,_k].Value:=mpgDep.Cells[1,_k].Value+#13#10+ListF.Items[_i].cNR_cs;

      mpgDep.Cells[2,_k].Value:=ListF.Items[_i].cAP;
      if ListF.Items[_i].cAP_other<>'' then
        mpgDep.Cells[2,_k].Value:=mpgDep.Cells[2,_k].Value+' '+#13#10+ListF.Items[_i].cAP_other;

      mpgDep.Cells[3,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt1);
      mpgDep.Cells[4,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt2);
      mpgDep.Cells[5,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt3);
      mpgDep.Cells[6,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt4);
      mpgDep.Cells[7,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt5);
      mpgDep.Cells[8,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dtDVZ);
      mpgDep.Cells[9,_k].Value:=ListF.Items[_i].cPRICH;

      mpgDep.HiddenCols[0].Cells[_k].Value:=ListF.Items[_i].iIdSpp;
      mpgDep.HiddenCols[1].Cells[_k].Value:=_i;
      mpgDep.HiddenCols[3].Cells[_k].Value:=ListF.Items[_i].bDelayed;
      mpgDep.HiddenCols[4].Cells[_k].Value:=ListF.Items[_i].ShowVPChange;
      if (_r=-1) and (ListF.Items[_i].dt1>Now) then
        _r:=_k; //_r:=_i; 24082010 Романов
      _k:=_k+1;
    end;
//  PgAutoSizeCells(mpgDep);
 // if mpgDep.RowCount>=_r then exit;
  _Found:=false;
  for _i:=1 to mpgDep.RowCount-1 do
    if mpgDep.HiddenCols[0].Cells[_i].Value = _curr_idSPP then
    begin
      _Found:=true;
      mpgDep.TopRow:=_tr;
      mpgDep.Row:=_i;
      mpgDep.FocusCell(0,_i);
//      if (ActiveMPG = mpgDep) and (mpgDep.RowCount>1) then
//        mpgDep.OnSelectCell(mpgDep, mpgDep.Col, mpgDep.TopRow, CanSelect);
      break;
    end;
  if not _Found then
  begin
    mpgDep.TopRow:=_r;
    mpgDep.FocusCell(0,_r);
  end;
end;

// Обновляем таблицу по прибытиям (вкладка СПП)
procedure TfmAnnManager.RefreshArr;
var
  _i: Integer;
  _k: Integer;
  _r: Integer;
  _curr_idSPP:integer;
  _Found:boolean;
  CanSelect:boolean;
  _tr:Integer;
begin
  _tr:=mpgArr.TopRow;
  if mpgArr.Row>0 then
    _curr_idSPP:=mpgArr.HiddenCols[0].Cells[mpgArr.Row].Value;
  mpgArr.RowCount:=1;
  _r:=-1;
  _k:=1;
  for _i:=0 to ListF.Count-1 do
    if ListF.Items[_i].bArr then
    begin
      mpgArr.RowCount:=mpgArr.RowCount+1;
      mpgArr.Cells[1,_k].Value:=ListF.Items[_i].cNR;
      if ListF.Items[_i].cNR_cs<>'' then
        mpgArr.Cells[1,_k].Value:=mpgArr.Cells[1,_k].Value+' '+#13#10+ListF.Items[_i].cNR_cs;

      mpgArr.Cells[2,_k].Value:=ListF.Items[_i].cAP;
      if ListF.Items[_i].cAP_other<>'' then
        mpgArr.Cells[2,_k].Value:=mpgArr.Cells[2,_k].Value+' '+#13#10+ListF.Items[_i].cAP_other;

      mpgArr.Cells[3,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt1);
      mpgArr.Cells[4,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt2);
      mpgArr.Cells[5,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dt3);
      mpgArr.Cells[6,_k].Value:=FormatDateTime('hhmm', ListF.Items[_i].dtDVZ);
      mpgArr.Cells[7,_k].Value:=ListF.Items[_i].cPRICH;  

      mpgArr.HiddenCols[0].Cells[_k].Value:=ListF.Items[_i].iIdSpp;
      mpgArr.HiddenCols[1].Cells[_k].Value:=_i;
      mpgArr.HiddenCols[2].Cells[_k].Value:=ListF.Items[_i].bArr; //26072010 Романов
      mpgArr.HiddenCols[3].Cells[_k].Value:=ListF.Items[_i].bDelayed;
      mpgArr.HiddenCols[4].Cells[_k].Value:=false;
      if (_r=-1) and (ListF.Items[_i].dt1>Now) then
        _r:=_k;//_r:=_i; 24082010 Романов
      _k:=_k+1;
    end;
//  PgAutoSizeCells(mpgArr);
 // if mpgArr.RowCount>=_r then exit;
  _Found:=false;
  for _i:=1 to mpgArr.RowCount-1 do
    if mpgArr.HiddenCols[0].Cells[_i].Value = _curr_idSPP then
    begin
      _Found:=true;
      mpgArr.TopRow:=_tr;
      mpgArr.Row:=_i;
      mpgArr.FocusCell(0,_i);
//      if (ActiveMPG = mpgArr) and (mpgArr.RowCount>1) then
//        mpgArr.OnSelectCell(mpgArr, mpgArr.Col, mpgArr.TopRow, CanSelect);

      break;
    end;
  if not _Found then
  begin
    mpgArr.TopRow:=_r;
    mpgArr.FocusCell(0,_r);
  end;
end;


procedure TfmAnnManager.FormCreate(Sender: TObject);
begin
{
    fGS:=TGlobalStruct.Create;
    fGS.LoadData(DM.con);
    ListF:=TListFlights.Create(Self);
    InitGrids;
    InitZones;

    fmTemplates := nil;
    Exceptor1.ServerFromConnectionString(DM.con.ConnectionString);
    tbAuto.Height := 0;
    tbAuto.Width := 0;
}
//  fListMessThread:=TListMessThread.Create(Self,DM.con.ConnectionString);
  CurrentMess:=TCurrentMess.Create;
  fZoneList:=TZoneList.Create;
  ActiveMpg:=mpgAnn;
end;

destructor TfmAnnManager.Destroy;
begin
  fGS.Free;
  ListF.Free;
  fZoneList.Free; 
//  fListMessThread.Terminate;
  inherited;
end;

procedure TfmAnnManager.InitZones;
var
  _i: Integer;
  _s: String;
  _k: Integer;
  //OnOff:boolean;

  procedure GetZoneButtons;
  var
    i,n:integer;
    tb:TRzToolBarButton;
    f:System.Text;
    s:string;
  begin
    System.Assign(f,ExtractFilePath(Application.ExeName)+'Протокол.txt');
      System.Rewrite(f);

    i:=-1;
    //rzZonesBar.DestroyComponents;
    n:=rzZonesBar.ComponentCount;
    s:='---------------'+#10+DateToStr(now)+TimeToStr(now);
    System.Writeln(f,s);
    s:='В rzZonesBar '+IntToStr(n)+' компонентов';
    System.Writeln(f,s);
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:='select id,zone,pict from dbo.ANN_ZONES (nolock) order by id';
      Open;
      First;
      while not Eof do
      begin
        i:=i+1;
        if i>=n then
        begin
          tb:=TRzToolBarButton.Create(rzZonesBar);
          tb.Name:='tbZone'+IntToStr(i);
          tb.SetBounds(i*30,0,30,30);
          tb.ShowHint:=true;
          tb.Flat:=false;
          tb.OnClick:=actZoneOnOffExecute;
          rzZonesBar.InsertControl(tb);
        end
        else
          tb:=(rzZonesBar.Controls[i] as TRzToolBarButton);
          
        tb.Hint:=Fields[1].AsString;


        tb.Tag:=Fields[0].AsInteger;

        tb.Glyph.Assign(Fields[2]);
        s:='Обработан компонент для зоны '+Fields[1].AsString;
        System.Writeln(f,s);

        Next;
      end;
    finally
      Free;
    end;
    System.Close(f);
    System.Erase(f); 
  end;

begin
  _k:=cbZone.ItemIndex;

  cbZone.Items.Clear;
  cbZone.Values.Clear;
  cbZone.Items.Add('Все');

  cbZone.Values.Add('0');

  for _i:=0 to fGS.Count-1 do
  begin
    _s:=fGS.Items[_i].name;
    //OnOff:=(fGS.Items[_i].OnOff=1) or (fGS.Items[_i].OnOff=-2);
    //cbZone.Items.Add(iif(OnOff,_s+' (+)',_s)); //Boolean->Integer
    cbZone.Items.Add(_s);
    cbZone.Values.Add(IntToStr(fGS.Items[_i].id));
  end;
  //IdZone:=iif(_k>-1,_k,0);
  cbZone.ItemIndex:=iif(_k>-1,_k,0);
  GetZoneButtons;
end;

procedure TfmAnnManager.cbZone_Change(Sender: TObject);
begin
  IdZone := StrToIntDef(cbZone.Values[cbZone.ItemIndex],0);
end;

procedure TfmAnnManager.SetIdZone(AValue: Integer);
begin
    fIdZone:=AValue;
    FZoneChange := True; // Для отслеживания флага изменения зоны

    try
        //UpdateVisinform;
        //cbZone.ItemIndex:=AValue; 18082010 Романов

        {if Assigned(fGS.GetById(AValue)) then
        begin
            {OnOff:=(fGS.GetById(AValue).OnOff = -2) or (fGS.GetById(AValue).OnOff = 1);
            tbStartStop.ImageIndex:=iif(OnOff,2,3);
            tbStartStop.Hint:=iif(OnOff,'Сервис запущен','Сервис остановлен');
            tbStartStop.Enabled:=True;    }
       { end
        else
        begin
            tbStartStop.ImageIndex:=-1;
            tbStartStop.Enabled:=False;
        end;        }
        acRefreshExecute(nil);
    finally
        FZoneChange := False;
    end;
end;

// Меняем режим выполнения ЗС
procedure TfmAnnManager.SetIdMode(AValue: Integer);
begin
    fIdMode := AValue;
    //cbMode.ItemIndex := AValue;
end;

procedure TfmAnnManager.tRefreshTimer(Sender: TObject);
begin
  tRefresh.Enabled:=false;
  acRefreshExecute(nil);
  tRefresh.Enabled:=true;
end;

procedure TfmAnnManager.acFlightInfoExecute(Sender: TObject);
var
  _IdSpp: Integer;
  _s: String;
begin
  _IdSpp:=0;
  _s:=DM.RDScon.ConnectionString;
  if mpgDep.Focused then
    _IdSpp:=mpgDep.HiddenCols[0].Cells[mpgDep.Row].Value
  else if mpgArr.Focused then
    _IdSpp:=mpgArr.HiddenCols[0].Cells[mpgArr.Row].Value
  else if mpgAnn.Focused then
    _IdSpp:=mpgAnn.HiddenCols[0].Cells[mpgAnn.Row].Value;
  if _IdSpp>0 then
    RunFlightInfo(Handle, _IdSpp, 0, PChar(_s), PChar(AppInfo.AccessLogin), PChar(AppInfo.AppName));
end;

procedure TfmAnnManager.mpgDepKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='i' then
    acFlightInfoExecute(nil);
end;

procedure TfmAnnManager.mpgDepDblClick(Sender: TObject);
begin
{
  with TfmFlightMessage.Create(True, mpgDep.HiddenCols[1].Cells[mpgDep.Row].Value) do
  try
    ShowModal;
  finally
    Free;
  end
}
//  CreateMessage;
//  fmFlightMessage:=TfmFlightMessage.Create(nil);
//  fmFlightMessage.ShowModal;
end;

function TfmAnnManager.StartStop: Boolean;
begin
end;

procedure TfmAnnManager.acStartStopExecute(Sender: TObject);
var
  St:integer;
begin
  St:=fGS.GetById(IdZone).OnOff;
  if St=-1 then
  begin
    HSMessageDlg('AnnService не запущен для зоны '+cbZone.Text,mtError,[mbOk],0);
    exit;
  end;
  St:=iif(St=0,1,0);
  fGS.GetById(IdZone).OnOff:=St;
  InitZones;
end;

procedure TfmAnnManager.mpgArrShowHint(Sender: TProfGrid; ACol,
  ARow: Integer; var HintStr: String; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  if ARow=0 then
  case ACol of
    1: HintStr:='Номер рейса';
    2: HintStr:='Направление';
    3: HintStr:='Время прибытия';
    4: HintStr:='Время начала выдачи багажа';
    5: HintStr:='Время окончания выдачи багажа';
    6: HintStr:='Ориентировочное время прилета по задержке';
  end
end;

procedure TfmAnnManager.mpgDepShowHint(Sender: TProfGrid; ACol,
  ARow: Integer; var HintStr: String; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  if ARow=0 then
  case ACol of
    1: HintStr:='Номер рейса';
    2: HintStr:='Направление';
    3: HintStr:='Время начала регистрации';
    4: HintStr:='Время окончания регистрации';
    5: HintStr:='Время начала посадки';
    6: HintStr:='Время окончания посадки';
    7: HintStr:='Время отправления';
    8: HintStr:='Ориентировочное время вылета по задержке';
  end
end;

{procedure TfmAnnManager.CreateMessage;
var
  _sp: TADOStoredProc;
begin
  try
    _sp:= TADOStoredProc.Create(nil);
    _sp.CursorType := ctStatic;
    _sp.LockType := ltReadOnly;
    _sp.Connection:=DM.con;
    _sp.ProcedureName:='[dbo].[spANN_CreateMess]';
    _sp.Parameters.Refresh;
    _sp.Parameters.ParamByName('@dt').Value:=IncMinute(Now,1);
    _sp.Parameters.ParamByName('@id_zone').Value:=IdZone;
    _sp.Parameters.ParamByName('@id_spp').Value:=mpgDep.HiddenCols[0].Cells[mpgDep.Row].Value;
    _sp.Parameters.ParamByName('@id_event').Value:=5;
    _sp.Parameters.ParamByName('@cNR').Value:=mpgDep.Cells[1,mpgDep.Row].Value;
    _sp.Parameters.ParamByName('@cAP').Value:=mpgDep.Cells[2,mpgDep.Row].Value;
    _sp.Parameters.ParamByName('@cAK').Value:='Россия';
    _sp.Parameters.ParamByName('@lang').Value:='RUS';
    _sp.ExecProc;
  finally
    _sp.Free;
  end;
end;  }

// Обновление очереди сообщений (в самом низу)
procedure TfmAnnManager.RefreshMessList;
var
  _i : Integer;
  PID : ^integer;
  PMessInfo : ^TMessInfo;
begin
  lv.Items.BeginUpdate;
  try
    lv.Clear;
    for _i := 0 to DM.ListMess.Count-1 do
      with DM.ListMess[_i], lv.Items.Add do
      begin
        Caption := FormatDateTime('hh:mm:ss',dt);
        SubItems.Add(nr);
        SubItems.Add(mtext);
        SubItems.Add(zone);

        New(PMessInfo);
        PMessInfo^.id := TMess(DM.ListMess[_i]).id;
        PMessInfo^.id_spp := TMess(DM.ListMess[_i]).id_spp;
        PMessInfo^.id_sched_templ := TMess(DM.ListMess[_i]).id_sched_templ;
        PMessInfo^.voice:=DM.ListMess[_i].voice;
        PMessInfo^.id_zone:=DM.ListMess[_i].id_zone;
        PMessInfo^.zone:=DM.ListMess[_i].zone;
//        PID := @ID;
//        Data := PID; // TObject(ID);
        Data := PMessInfo;
      end;
  finally
    lv.Items.EndUpdate;
  end;
end;

procedure TfmAnnManager.RefreshMainGrid;
var
  _i, _j, _id_spp, _id, _tr : Integer;
  _r,_iArr,_iDep: Integer;
  _b, _bm : TBitmap;
  ModeHint : string;
  fFind, CanSelect : boolean;
begin
  //ShowMessage('1');
  _tr:=mpgANN.TopRow;
  if (mpgANN.RowCount>1) and (mpgAnn.Row>0) then
  begin
    _id := mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value;
    Curr_id_spp := mpgAnn.HiddenCols[0].Cells[mpgAnn.Row].Value; //09022011
  end;
  //ShowMessage('2');
    if (ListF.Count >= _id) and (ListF.Count >0 ) then
        _id_spp := ListF[_id].iIdSpp
    else
        _id_spp := 0;

    fFind := false;
  //ShowMessage('3');
    // Очищаем список от картинок
    for _i := 0 to mpgAnn.RowCount - 1 do
    begin
        if Assigned(mpgAnn.Cells[0, _i].Graphic) then
            mpgAnn.Cells[0, _i].Graphic := nil;

        if Assigned(mpgAnn.Cells[11, _i].Graphic) then
            mpgAnn.Cells[11, _i].Graphic := nil;
   end;
  // ShowMessage('4');
   //ShowMessage('Очистили');

    mpgAnn.RowCount:=1;
    _r:=-1;
    try
        _iArr:=-1; _iDep:=-1;
        for _i:=0 to ListF.Count-1 do
        begin
            if ListF.Items[_i].bArr then
              _iArr:=_iArr+1
            else
              _iDep:=_iDep+1;   
            mpgAnn.RowCount:=mpgAnn.RowCount+1;
            mpgAnn.Cells[1,_i+1].Value := ListF.Items[_i].cNR;
            if ListF.Items[_i].cNR_cs<>'' then
              mpgAnn.Cells[1,_i+1].Value:=mpgAnn.Cells[1,_i+1].Value+' '+#13#10+ListF.Items[_i].cNR_cs;
            mpgAnn.Cells[2,_i+1].Value := ListF.Items[_i].cAP;
            if ListF.Items[_i].cAP_other<>'' then
              mpgAnn.Cells[2,_i+1].Value := mpgAnn.Cells[2,_i+1].Value+' '+#13#10+ListF.Items[_i].cAP_other;
            mpgAnn.Cells[3,_i+1].Value := ListF.Items[_i].cAK;
            if ListF.Items[_i].cAK_cs<>'' then
              mpgAnn.Cells[3,_i+1].Value := mpgAnn.Cells[3,_i+1].Value+' '+#13#10+ListF.Items[_i].cAK_cs;
            mpgAnn.Cells[4,_i+1].Value := FormatDateTime('hhmm', ListF.Items[_i].dt1);
            mpgAnn.Cells[5,_i+1].Value := FormatDateTime('hhmm', ListF.Items[_i].dt2);
            mpgAnn.Cells[6,_i+1].Value := FormatDateTime('hhmm', ListF.Items[_i].dt3);

            _b := TBitmap.Create;
            if not ListF.Items[_i].bArr then
            begin
                ilSmall.GetBitmap(1,_b);
                mpgAnn.Cells[7,_i+1].Value := FormatDateTime('hhmm', ListF.Items[_i].dt4);
                mpgAnn.Cells[8,_i+1].Value := FormatDateTime('hhmm', ListF.Items[_i].dt5);
                mpgAnn.Cells[0,_i+1].Hint := 'Вылет';
            end
            else
            begin
                ilSmall.GetBitmap(0,_b);
                mpgAnn.Cells[0,_i+1].Hint := 'Посадка';
            end;

            mpgAnn.Cells[9,_i+1].Value := FormatDateTime('hhmm', ListF.Items[_i].dtDVZ);
            mpgAnn.Cells[10,_i+1].Value := ListF.Items[_i].cPRICH;

            mpgAnn.Cells[0,_i+1].Graphic:=_b;
            _b.Free;
            mpgAnn.HiddenCols[0].Cells[_i+1].Value := ListF.Items[_i].iIdSpp;
            mpgAnn.HiddenCols[1].Cells[_i+1].Value := _i;
            mpgAnn.HiddenCols[2].Cells[_i+1].Value := ListF.Items[_i].bArr;
            mpgAnn.HiddenCols[3].Cells[_i+1].Value := ListF.Items[_i].bDelayed;
            mpgAnn.HiddenCols[4].Cells[_i+1].Value := ListF.Items[_i].ShowVPChange;

            if (_r = -1) and (ListF.Items[_i].dt1 > Now) then _r := _i;

            // RIVC_Nabatov 26032010 Проверка обработки рейса в автоматич.режиме (особая закраска)
            _bm := TBitmap.Create;

            case ListF.Items[_i].ExecuteMode of
            1 :
            begin
                ilSmall.GetBitmap(7, _bm);
            end;
            2 :
            begin
                ilSmall.GetBitmap(8, _bm);
            end;
            3 :
            begin
                ilSmall.GetBitmap(6, _bm);
            end;
            else
                ilSmall.GetBitmap(9, _bm);
            end;

            mpgAnn.Cells[11, _i+1].Graphic := _bm;
            _bm.Free;
            mpgAnn.Cells[11, _i+1].Hint := ListF.Items[_i].sModeName;

            // if ListF.Items[_i].bVisinAuto then
            if ListF.Items[_i].ExecuteMode = 2 then
            begin
                for _j := 0 to mpgAnn.ColCount - 1 do
                begin
                    mpgAnn.Cells[_j, _i + 1].Color := clSkyBlue;
                    mpgAnn.Cells[_j, _i + 1].Font.Color := clRed;
                end;
                if ListF.Items[_i].bArr then
                for _j := 0 to mpgArr.ColCount - 1 do
                begin
                    mpgArr.Cells[_j, _iArr + 1].Color := clSkyBlue;
                    mpgArr.Cells[_j, _iArr + 1].Font.Color := clRed;
                end
                else
                for _j := 0 to mpgDep.ColCount - 1 do
                begin
                    mpgDep.Cells[_j, _iDep + 1].Color := clSkyBlue;
                    mpgDep.Cells[_j, _iDep + 1].Font.Color := clRed;
                end;  
            end
            else
            begin
                for _j := 0 to mpgAnn.ColCount - 1 do
                begin
                    mpgAnn.Cells[_j, _i + 1].Color := clWindow;
                    mpgAnn.Cells[_j, _i + 1].Font.Color := clWindowText;
                end;
                if ListF.Items[_i].bArr then
                for _j := 0 to mpgArr.ColCount - 1 do
                begin
                    mpgArr.Cells[_j, _iArr + 1].Color := clWindow;
                    mpgArr.Cells[_j, _iArr + 1].Font.Color := clWindowText;
                end;
                for _j := 0 to mpgDep.ColCount - 1 do
                begin
                    mpgDep.Cells[_j, _iDep + 1].Color := clWindow;
                    mpgDep.Cells[_j, _iDep + 1].Font.Color := clWindowText;
                end;
            end;

            Application.ProcessMessages;
            // Sleep(50);
        end;

        //ShowMessage('Прописали');

        // Возвращаем позицию на последний рейс
        if (Curr_id_spp > 0) and (mpgAnn.RowCount>1) then // and (mpgAnn.RowCount>1) - 15.10.2010 Романов
        for _i := 1 to mpgAnn.RowCount do
        begin
            if mpgAnn.HiddenCols[0].Cells[_i - 1].Value = Curr_id_spp then // _id_spp
            begin
                mpgAnn.Cells[0, _i - 1].Selected := True;
                mpgAnn.Row := _i - 1;
                mpgAnn.TopRow := _tr;//_i - 1;
                fFind := true;
                break;
            end;
        end;

        Application.ProcessMessages;
        Sleep(50);

        if (not fFind) and (mpgAnn.RowCount>1)  then
        begin
            mpgAnn.Cells[0, 1].Selected := True;
            mpgAnn.Row := 1;
            mpgAnn.TopRow := _tr;//1;
        end;

        //ShowMessage('Нашли');

        // После перепостроения списка запоминаем ID рейса (при правильном алгоритме он не должен меняться)
         if mpgAnn.RowCount>1 then
         begin
            if Assigned(mpgAnn.HiddenCols[0].Cells[mpgAnn.Row]) then
                Curr_id_spp := mpgAnn.HiddenCols[0].Cells[mpgAnn.Row].Value
            else Curr_id_spp := 0;
         end
         else Curr_id_spp := 0;
//        if RzPageControl1.ActivePageIndex = 0 then
//          mpgAnn.OnSelectCell(mpgAnn, mpgAnn.Col, mpgAnn.TopRow, CanSelect);

        Application.ProcessMessages;
        Sleep(50);
        //PgAutoSizeCells(mpgAnn);
    finally
        // if Assigned(_b) then _b.Free;
        // if Assigned(_bm) then _bm.Free;
    end;
end;


procedure TfmAnnManager.mpgAnnShowHint(Sender: TProfGrid; ACol,
  ARow: Integer; var HintStr: String; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  if ARow = -1 then exit;
  if mpgAnn.Cells[7,ARow].Text='' then
    case ACol of
      4: HintStr:='Время прибытия рейса';
      5: HintStr:='Время начала выдачи багажа';
      6: HintStr:='Время окончания выдачи багажа';
    end
  else
    case ACol of
      4: HintStr:='Время начала регистрации';
      5: HintStr:='Время окончания регистрации';
      6: HintStr:='Время начала посадки';
      7: HintStr:='Время окончания посадки';
      8: HintStr:='Время отправления рейса';
    end

end;

// заполнение списка сообщений по выбранному рейсу
procedure TfmAnnManager.CurrReisMessList(spp_id : integer);
var i : Integer;
    PID : ^integer;
    PMessInfo : ^TMessInfo;
begin
    try
        lvCurrReis.Items.BeginUpdate;
        lvCurrReis.Clear;
        for i := 0 to lv.Items.Count - 1 do
        begin
            if (TMessInfo(lv.Items.Item[i].Data^).id_spp = spp_id) then
            begin
                with lvCurrReis.Items.Add do
                begin
                    Caption := lv.Items.Item[i].Caption;
                    SubItems.Add(lv.Items.Item[i].SubItems.Strings[0]);
                    SubItems.Add(lv.Items.Item[i].SubItems.Strings[1]);
                    SubItems.Add(lv.Items.Item[i].SubItems.Strings[2]);

                    New(PMessInfo);
                    PMessInfo^.id := TMessInfo(lv.Items.Item[i].Data^).id;
                    PMessInfo^.id_sched_templ := TMessInfo(lv.Items.Item[i].Data^).id_sched_templ;
                    PMessInfo^.voice:=TMessInfo(lv.Items.Item[i].Data^).voice;
                    PMessInfo^.id_zone:=TMessInfo(lv.Items.Item[i].Data^).id_zone;
                    PMessInfo^.zone:=TMessInfo(lv.Items.Item[i].Data^).zone;

                    Data := PMessInfo;
                end;
            end;
        end;
    finally
        lvCurrReis.Items.EndUpdate;
    end;
{
  lvCurrReis.Items.BeginUpdate;
  try
    lvCurrReis.Clear;
    for _i := 0 to DM.ListMess.Count-1 do
      with DM.ListMess[_i], lvCurrReis.Items.Add do
      begin
        if TMess(DM.ListMess[_i]).id_spp = spp_id then
        begin
            Caption := FormatDateTime('hh:mm:ss',dt);
            SubItems.Add(nr);
            SubItems.Add(mtext);

            New(PMessInfo);
            PMessInfo^.id := TMess(DM.ListMess[_i]).id;
            PMessInfo^.id_sched_templ := TMess(DM.ListMess[_i]).id_sched_templ;
            Data := PMessInfo;
        end;
      end;
  finally
  lvCurrReis.Items.EndUpdate;
  end;
  }
end;


// Проверка, запущен ли ANN_Service или нет
function TfmAnnManager.ReadOnOff:string;
begin
  result:='';
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:='select id_zone,on_off,caption from dbo.ANN_ON_OFF (nolock)';
    Open;
    while not Eof do
    begin
      if FieldByName('on_off').AsInteger<>1 then
        result:=result+#10+FieldByName('caption').AsString;
      Next;
    end;
  finally
    Free;
  end;
end; 

procedure TfmAnnManager.SetMainFunctionsDisabled;
var
  E:boolean;
//  i:integer;
begin
  E:=isAccess('ANN_RunMess','kobra_ann');

  mpgEvents.Enabled:=E;
  Panel1.Enabled:=E;
  sbExecAll.Enabled:=E;
  sbStopAll.Enabled:=E;
  tbAuto.Enabled:=E;
  E:=isAccess('ANN_CancelMsg','kobra_ann');
  NCancelMsg.Enabled:=E;
  //for i:=0 to ppMain.Items.Count-3 do
    //ppMain.Items[i].Enabled:=E;
end;

procedure TfmAnnManager.BrushMpg(Mpg:TMyProfGrid);
var
  x,y,i:integer;
  Color:TColor;
  DT:TDateTime; // если вылет, то рассматриваем время вылета, если прилет - то время окончания выдачи багажа

  function CurrAct(FT:TFlight):integer;
  var
    dt2,dt3:TDateTime;
  begin
    result:=0;

    if FT.bArr then
    begin

      if (FT.dt1<=now) and (FT.dt2>now) then result:=4
      else
      if (FT.dt2<=now) and (FT.dt3>now) then result:=5
      else
      if (FT.dt3<=now) and (IncMinute(FT.dt3,20)>now) then
        result:=6;
    end
    else
    begin

      if FT.dt3<FT.dt2 then
      begin
        dt2:=FT.dt3;
        dt3:=FT.dt2;
      end
      else
      begin
        dt2:=FT.dt2;
        dt3:=FT.dt3;
      end;

      if (FT.dt1<=now) and (dt2>now) then result:=4
      else
      if (dt2<=now) and (dt3>now) then result:=6
      else
      if (dt3<=now) and (FT.dt4>now) then result:=5
      else
      if (FT.dt4<=now) and (FT.dt5>now) then result:=7
      else
      if (FT.dt5<=now) and (IncMinute(FT.dt5,20)>now)  then
        result:=8;

    end;

  end;

begin
  x:=0;
  if Mpg.RowCount<2 then exit; 
  for i:=0 to ListF.Count-1 do
  begin
    if not ((Mpg=mpgAnn) or ((Mpg=mpgDep)and(not ListF.Items[i].bArr)) or
    ((Mpg=mpgArr)and(ListF.Items[i].bArr))) then continue;

    if ListF.Items[i].bArr then
      DT:=ListF.Items[i].dt3
    else
      DT:=ListF.Items[i].dt5;
    x:=x+1;

    if (ListF.Items[i].dt1 < IncMinute(now,-30)) then
      Color:=clInfoBk
    else
    if (now>=IncMinute(ListF.Items[i].dt1,-30)) and (now<=IncMinute(DT,30)) then  
      Color:=clMoneyGreen
    else
      Color:=clWindow;
    for y:=0 to Mpg.ColCount-1 do
    begin
      Mpg.Cells[y,x].InnerBorder.Width:=0;
      Mpg.Cells[y,x].Color:=Color;
    end;

    y:=CurrAct(ListF.Items[i]);
    if Mpg<>mpgAnn then y:=y-1;
    if y>0 then
    begin
      Mpg.Cells[y,x].InnerBorder.Color:=clRed;
      Mpg.Cells[y,x].InnerBorder.Width:=1;
    end;

    if ListF.Items[i].cVR = 'M' then
      for y:=0 to mpg.ColCount-1 do
        mpg.Cells[y,x].Font.Style:=[fsBold];

    if ListF.Items[i].cKODK = 'О' then
      for y:=0 to mpg.ColCount-1 do
        mpg.Cells[y,x].Color:=$00CE9DFF;
  end;
end;

// Обновление статуса запущенности зон
procedure TfmAnnManager.RefreshZoneStatus;
const
  SQLText = 'select id,pict from dbo.ANN_ZONES (nolock) order by id';
var
  St,id_zone,i:integer;
  bm1,bm2,bm:TBitMap;

begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    i:=-1;
    while not Eof do
    begin
      i:=i+1;
      id_zone:=Fields[0].AsInteger;
      St:=fGs.GetById(id_zone).OnOff;
      if (St=1) or (St=2) then
        (rzZonesBar.Controls[i] as TRzToolBarButton).Glyph.Assign(Fields[1])
      else
      begin
        bm1:=TBitMap.Create;
        bm1.Assign(Fields[1]);
        bm2:=TBitMap.Create;
        imgStop.GetBitmap(St+1,bm2);
        MixBmp(bm1,bm2,bm);
        (rzZonesBar.Controls[i] as TRzToolBarButton).Glyph.Assign(bm);
      end;
      Next;
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.fGetEvents(mpg:TMyProfGrid);
var
  ARow:integer;
  _i, _j, _k: Integer;
    bmStart, bmSounded : TBitmap;
    i_row : integer;
    OldColor:TColor;
begin
  ARow:=mpg.Row;
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName:='dbo.spANN_SPP_Event_List';
        Parameters.Refresh;
        Parameters.ParamByName('@id_spp').Value := MPG.HiddenCols[0].Cells[ARow].Value; // mpgAnn
        Parameters.ParamByName('@pv').Value := iif(MPG.HiddenCols[2].Cells[ARow].Value, 'П', 'В'); // mpgAnn
        Parameters.ParamByName('@VpChanged').Value := MPG.HiddenCols[4].Cells[ARow].Value;
        Parameters.ParamByName('@id_zone').Value := IdZone;
        Open;

        // Освобождаем память, выделенную под иконки
        for _i := 0 to mpgEvents.RowCount - 1 do
        begin
            if Assigned(mpgEvents.Cells[0, _i].Graphic) then
            begin
                // mpgEvents.Cells[0, _i].Graphic.Free;
                mpgEvents.Cells[0, _i].Graphic := nil;
            end;

            if Assigned(mpgEvents.Cells[2, _i].Graphic) then
            begin
                // mpgEvents.Cells[2, _i].Graphic.Free;
                mpgEvents.Cells[2, _i].Graphic := nil;
            end;
        end;

        // Построение списка событий для рейса
        _k := 0;
        mpgEvents.RowCount := 0;
        for _i:=0 to mpgEvents.ColCount-1 do
          mpgEvents.Cells[_i,0].Font.Color:=clWindowText;
        while not EOF do
        begin
           if FieldByName('caption').AsString = '' then
           begin
             next;
             continue;
           end;
            if _k > 0 then mpgEvents.RowCount := mpgEvents.RowCount + 1;
            i_row := mpgEvents.RowCount - 1;
            mpgEvents.HiddenCols[0].Cells[i_row].Value := Fields.FieldByName('id_spp').AsInteger;
            mpgEvents.HiddenCols[1].Cells[i_row].Value := Fields.FieldByName('checked').AsInteger;
            mpgEvents.HiddenCols[2].Cells[i_row].Value := Fields.FieldByName('sounded').AsInteger;
            mpgEvents.Cells[2, i_row].Hint := Fields.FieldByName('SoundHint').AsString;
            mpgEvents.HiddenCols[3].Cells[i_row].Value := Fields.FieldByName('id_event').AsInteger;
            mpgEvents.HiddenCols[4].Cells[i_row].Value := Fields.FieldByName('id_templ').AsInteger;
            mpgEvents.HiddenCols[5].Cells[i_row].Value := Fields.FieldByName('event_enabled').AsInteger;
            mpgEvents.Cols[1].Cells[i_row].Value := Fields.FieldByName('caption').AsString;

            // Если событие запущено, отметить это иконкой. Не забыть по окончании работы удалить объекты
            if mpgEvents.HiddenCols[1].Cells[i_row].Value > 0 then
            begin
                bmStart := TBitmap.Create;

                if mpgEvents.HiddenCols[4].Cells[i_row].Value > 0 then
                begin
                    ilSmall.GetBitmap(11, bmStart);
                end
                else
                begin
                    ilSmall.GetBitmap(4, bmStart);
                end;

                mpgEvents.Cells[0, i_row].Graphic := bmStart;
                bmStart.Free;
            end;

            // Если событие озвучено, отметить это иконкой. Не забыть по окончании работы удалить объекты
            if mpgEvents.HiddenCols[2].Cells[i_row].Value > 0 then
            begin
                bmSounded := TBitmap.Create;
                ilSmall.GetBitmap(10, bmSounded);
                mpgEvents.Cells[2, i_row].Graphic := bmSounded;
            end;

            // Если событие неактивно для данной зоны. Не давать озвучивать
            if mpgEvents.HiddenCols[5].Cells[i_row].Value = 0 then
            begin
              for _i:= 0 to mpgEvents.ColCount-1 do
                mpgEvents.Cells[_i,i_row].Font.Color:=clGray;
            end;

            _k := _k + 1;
            Next;
        end;
    finally
        Free;
    end;

    {
    // RIVC_Nabatov 01042010 Закомментировал ввиду использования другого кода
    mpgEvents.RowCount := 0;
    mpgEvents.Cells[0, 0].Graphic := nil;
    _k := 0;
    for _i := 0 to DM.ListEvent.Count - 1 do
    if DM.ListEvent.Items[_i].bArr = mpgAnn.HiddenCols[2].Cells[ARow].Value then
    begin
        if _k > 0 then mpgEvents.RowCount := mpgEvents.RowCount + 1;
        mpgEvents.HiddenCols[0].Cells[mpgEvents.RowCount - 1].Value := DM.ListEvent.Items[_i].id;
        mpgEvents.Cells[1, mpgEvents.RowCount - 1].Value := DM.ListEvent.Items[_i].caption;
        _k := _k + 1;
    end;
    }

    tbAuto.Down := ListF[MPG.HiddenCols[1].Cells[ARow].Value].Auto;   // mpgAnn

    // if ListF.Items[mpgAnn.HiddenCols[1].Cells[ARow].Value].ExecuteMode = 2 then
    if ListF[MPG.HiddenCols[1].Cells[ARow].Value].ExecuteMode = 2 then   // mpgAnn
    begin
        for _j := 0 to MPG.ColCount - 1 do    // mpgAnn
        begin
            MPG.Cells[_j, ARow].Color := clSkyBlue; // mpgAnn
            MPG.Cells[_j, ARow].Font.Color := clRed; // mpgAnn
        end;
    end
    else
    begin
        for _j := 0 to MPG.ColCount - 1 do   // mpgAnn
        begin
            MPG.Cells[_j, ARow].Color := OldColor;//clWindow; // mpgAnn
            MPG.Cells[_j, ARow].Font.Color := clWindowText;  // mpgAnn
        end;
    end;
    CurrReisMessList(MPG.HiddenCols[0].Cells[ARow].Value);
end;

procedure TfmAnnManager.mpgAnnSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var _i, _j, _k: Integer;
    bmStart, bmSounded : TBitmap;
    i_row : integer;
    OldColor:TColor;
begin
    // Запоминаем текущий ID рейса
try
   if (Sender is TMyProfGrid) then
       ActiveMPG:=(Sender as TMyProfGrid); //26072010 Романов. Установка нового активного табло
    if ActiveMPG.RowCount=1 then exit;
    OldColor:=ActiveMpg.Cells[ACol,ARow].Color;

    Curr_id_spp := ActiveMPG.HiddenCols[0].Cells[ARow].Value;  //mpgAnn

    if ActiveMpg = mpgANN then
      sbDelay.Visible := (ActiveMPG.Cells[9,AROW].Text<>'0000') or (ActiveMPG.Cells[10,AROW].Text<>'')
    else
    if ActiveMpg = mpgDep then
      sbDelay.Visible := (ActiveMPG.Cells[8,AROW].Text<>'0000') or (ActiveMPG.Cells[9,AROW].Text<>'')
    else
    if ActiveMpg = mpgArr then
      sbDelay.Visible := (ActiveMPG.Cells[6,AROW].Text<>'0000') or (ActiveMPG.Cells[7,AROW].Text<>'');

    // RIVC_Nabatov 31032010 Организовать вызов хр.процедуры для получения цепочки ЗС для данного рейса
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName:='dbo.spANN_SPP_Event_List';
        Parameters.Refresh;
        Parameters.ParamByName('@id_spp').Value := ActiveMPG.HiddenCols[0].Cells[ARow].Value; // mpgAnn
        Parameters.ParamByName('@pv').Value := iif(ActiveMPG.HiddenCols[2].Cells[ARow].Value, 'П', 'В'); // mpgAnn
        Parameters.ParamByName('@VpChanged').Value := ActiveMPG.HiddenCols[4].Cells[ARow].Value;
        Parameters.ParamByName('@id_zone').Value := IdZone;  
        Open;

        // Освобождаем память, выделенную под иконки
        for _i := 0 to mpgEvents.RowCount - 1 do
        begin
            if Assigned(mpgEvents.Cells[0, _i].Graphic) then
            begin
                // mpgEvents.Cells[0, _i].Graphic.Free;
                mpgEvents.Cells[0, _i].Graphic := nil;
            end;

            if Assigned(mpgEvents.Cells[2, _i].Graphic) then
            begin
                // mpgEvents.Cells[2, _i].Graphic.Free;
                mpgEvents.Cells[2, _i].Graphic := nil;
            end;
        end;

        // Построение списка событий для рейса
        _k := 0;
        mpgEvents.RowCount := 0;
        for _i:=0 to mpgEvents.ColCount-1 do
          mpgEvents.Cells[_i,0].Font.Color:=clWindowText;  

        while not EOF do
        begin
           if FieldByName('caption').AsString = '' then
           begin
             next;
             continue;
           end;
            if _k > 0 then mpgEvents.RowCount := mpgEvents.RowCount + 1;
            i_row := mpgEvents.RowCount - 1;
            mpgEvents.HiddenCols[0].Cells[i_row].Value := Fields.FieldByName('id_spp').AsInteger;
            mpgEvents.HiddenCols[1].Cells[i_row].Value := Fields.FieldByName('checked').AsInteger;
            mpgEvents.HiddenCols[2].Cells[i_row].Value := Fields.FieldByName('sounded').AsInteger;
            mpgEvents.Cells[2, i_row].Hint := Fields.FieldByName('SoundHint').AsString;
            mpgEvents.HiddenCols[3].Cells[i_row].Value := Fields.FieldByName('id_event').AsInteger;
            mpgEvents.HiddenCols[4].Cells[i_row].Value := Fields.FieldByName('id_templ').AsInteger;
            mpgEvents.HiddenCols[5].Cells[i_row].Value := Fields.FieldByName('event_enabled').AsInteger;
            mpgEvents.Cols[1].Cells[i_row].Value := Fields.FieldByName('caption').AsString;

            // Если событие запущено, отметить это иконкой. Не забыть по окончании работы удалить объекты
            if mpgEvents.HiddenCols[1].Cells[i_row].Value > 0 then
            begin
                bmStart := TBitmap.Create;

                if mpgEvents.HiddenCols[4].Cells[i_row].Value > 0 then
                begin
                    ilSmall.GetBitmap(11, bmStart);
                end
                else
                begin
                    ilSmall.GetBitmap(4, bmStart);
                end;

                mpgEvents.Cells[0, i_row].Graphic := bmStart;
                bmStart.Free;
            end;

            // Если событие озвучено, отметить это иконкой. Не забыть по окончании работы удалить объекты
            if mpgEvents.HiddenCols[2].Cells[i_row].Value > 0 then
            begin
                bmSounded := TBitmap.Create;
                ilSmall.GetBitmap(10, bmSounded);
                mpgEvents.Cells[2, i_row].Graphic := bmSounded;
            end;

            // Если событие неактивно для данной зоны. Не давать озвучивать
            if mpgEvents.HiddenCols[5].Cells[i_row].Value = 0 then
            begin
              for _i:= 0 to mpgEvents.ColCount-1 do
                mpgEvents.Cells[_i,i_row].Font.Color:=clGray;
            end;


            _k := _k + 1;
            Next;
        end;
    finally
        Free;
    end;

    {
    // RIVC_Nabatov 01042010 Закомментировал ввиду использования другого кода
    mpgEvents.RowCount := 0;
    mpgEvents.Cells[0, 0].Graphic := nil;
    _k := 0;
    for _i := 0 to DM.ListEvent.Count - 1 do
    if DM.ListEvent.Items[_i].bArr = mpgAnn.HiddenCols[2].Cells[ARow].Value then
    begin
        if _k > 0 then mpgEvents.RowCount := mpgEvents.RowCount + 1;
        mpgEvents.HiddenCols[0].Cells[mpgEvents.RowCount - 1].Value := DM.ListEvent.Items[_i].id;
        mpgEvents.Cells[1, mpgEvents.RowCount - 1].Value := DM.ListEvent.Items[_i].caption;
        _k := _k + 1;
    end;
    }

    tbAuto.Down := ListF[ActiveMPG.HiddenCols[1].Cells[ARow].Value].Auto;   // mpgAnn

    // if ListF.Items[mpgAnn.HiddenCols[1].Cells[ARow].Value].ExecuteMode = 2 then
    if ListF[ActiveMPG.HiddenCols[1].Cells[ARow].Value].ExecuteMode = 2 then   // mpgAnn
    begin
        for _j := 0 to ActiveMPG.ColCount - 1 do    // mpgAnn
        begin
            ActiveMPG.Cells[_j, ARow].Color := clSkyBlue; // mpgAnn
            ActiveMPG.Cells[_j, ARow].Font.Color := clRed; // mpgAnn
        end;
    end
    else
    begin
        for _j := 0 to ActiveMPG.ColCount - 1 do   // mpgAnn
        begin
            ActiveMPG.Cells[_j, ARow].Color := OldColor;//clWindow; // mpgAnn
            ActiveMPG.Cells[_j, ARow].Font.Color := clWindowText;  // mpgAnn
        end;
    end;

    CurrReisMessList(ActiveMPG.HiddenCols[0].Cells[ARow].Value);  // mpgAnn
 except
 end;
end;

procedure TfmAnnManager.mpgEventsDblClick(Sender: TObject);
var
  _b1, _b2, _bStart, _bStop: TBitmap;
  _i, _id_spp : Integer;
  iStatus, bChecked : integer;
  CanSelect, Adding : boolean;
  SEvent,SForLog:string;
begin
    // if mpgEvents.Col<>1 then exit;
    {
    _b1 := TBitmap.Create;
    _b2 := TBitmap.Create;
    _bStart := TBitmap.Create;
    _bStop := TBitmap.Create;
    ilSmall.GetBitmap(2, _b1);
    ilSmall.GetBitmap(3, _b2);
    ilSmall.GetBitmap(4, _bStart);
    ilSmall.GetBitmap(5, _bStop);
    mpgEvents.Cells[0,mpgEvents.Row].Graphic := _bStart;
    }

    if LS = lsNone then
    try
        tRefresh.Enabled := false;


        // Если событие озвучено, больше не трогать
        if mpgEvents.HiddenCols[2].Cells[mpgEvents.Row].Value > 0 then
        begin
            HSMessageDlg('Звуковое сообщение уже озвучено.'#13#10'Изменение невозможно!', mtError, [mbOk], 0);
            exit;
        end;

        // Если выбранное событие на относится к зоне звучания
        if mpgEvents.HiddenCols[5].Cells[mpgEvents.Row].Value = 0 then exit;    

        try
            if Assigned(ActiveMpg.HiddenCols[1])       // mpgAnn -> ActiveMpg
            and Assigned(ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row])
            and Assigned(ListF[ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value]) then
            begin
                bChecked := mpgEvents.HiddenCols[1].Cells[mpgEvents.Row].Value;
                Adding:= mpgEvents.Cols[0].Cells[mpgEvents.Row].Graphic = nil;
                SEvent:= mpgEvents.Cols[1].Cells[mpgEvents.Row].Text;

                // Нужен вызов хр.процедуры для установки пометки события в БД // RIVC_Nabatov 31032010
                with TADOStoredProc.Create(nil) do
                try
                    Connection := DM.con;
                    ProcedureName:='dbo.spANN_StartMessage'; //02112010
                    Parameters.Refresh;
                    Parameters.ParamByName('@id_spp').Value := ActiveMpg.HiddenCols[0].Cells[ActiveMpg.Row].Value;
                    Parameters.ParamByName('@id_zone').Value := IdZone;
                    Parameters.ParamByName('@id_event').Value := mpgEvents.HiddenCols[3].Cells[mpgEvents.Row].Value;
                    Parameters.ParamByName('@seconds').Value := Seconds;
                    Parameters.ParamByName('@id_templ').Value := mpgEvents.HiddenCols[4].Cells[mpgEvents.Row].Value;
                    Open;

                    if Fields[0].FieldName = 'ErrorMessage' then
                    begin
                        HSMessageDlg(FieldByName(FieldList.Fields[0].FieldName).AsString, mtError, [mbOk], 0);
                        exit;
                    end;

                    {
                    // 1 - Пометить ЗС иконкой
                    if (bChecked > 0) then // было отмечено - снять
                    begin
                        mpgEvents.Cells[0, mpgEvents.Row].Graphic := nil;
                        mpgEvents.HiddenCols[1].Cells[mpgEvents.Row].Value := 0;
                    end
                    else
                    begin
                        _bStart := TBitmap.Create;
                        ilSmall.GetBitmap(4, _bStart);
                        mpgEvents.Cells[0, mpgEvents.Row].Graphic := _bStart;
                        mpgEvents.HiddenCols[1].Cells[mpgEvents.Row].Value := 1;
                    end;
                    }

                    // 2 - Обновить строку рейса
                    _i := ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value;
                    _id_spp := ListF[_i].iIdSpp;

                    if RecordCount > 0 then
                    begin
                        ListF[_i].cNR := Fields.FieldByName('nr').AsString;
                        ListF[_i].cAP := Fields.FieldByName('ap').AsString;
                        ListF[_i].cAK := Fields.FieldByName('ak').AsString;
                        ListF[_i].bArr := iif(Fields.FieldByName('pv').AsString = 'В', False, True);
                        ListF[_i].dt1 := Fields.FieldByName('dt1').AsDateTime;
                        ListF[_i].dt2 := Fields.FieldByName('dt2').AsDateTime;
                        ListF[_i].dt3 := Fields.FieldByName('dt3').AsDateTime;
                        ListF[_i].dt4 := Fields.FieldByName('dt4').AsDateTime;
                        ListF[_i].dt5 := Fields.FieldByName('dt5').AsDateTime;
                        ListF[_i].FAuto := (Fields.FieldByName('start').AsInteger > 0);
                        ListF[_i].bVisinAuto := Fields.FieldByName('visin_start').AsInteger>0;
                        ListF[_i].ExecuteMode := Fields.FieldByName('ExecuteMode').AsInteger;
                        ListF[_i].sModeName := Fields.FieldByName('ExecuteModeName').AsString;

                        RefreshMpgAnnRecord(_id_spp);
                        ActiveMpg.OnSelectCell(ActiveMpg, ActiveMpg.Col, ActiveMpg.Row, CanSelect);  //Sender->mpgANN 26072010 Романов А.Н.
                    end;

                    if Adding then
                    begin
                      SForLog:=Format(LogMsgAddOne,[ListF[_i].cNR,Sevent]);
                      if ActiveMpg=mpgAnn then       //01092010 Романов А.Н.
                      begin
                        _b1:=TBitMap.Create;
                        ilSmall.GetBitmap(6,_b1);
                        mpgAnn.Cells[11,mpgAnn.Row].Graphic:=_b1;
                        mpgAnn.Cells[11,mpgAnn.Row].Hint:='Ручной';   
                      end;  
                    end
                    else
                      SForLog:=Format(LogMsgDeleteOne,[ListF[_i].cNR,Sevent]);
                    DM.AddToLog(SForLog,'','');
                finally
                    Free;
                end;
            end;
        except
            on EInvalidGridOperation do
              if ActiveMpg=MpgAnn then
                HSMessageDlg('Необходимо указать рейс !!!', mtError, [mbOk], 0);
        end;
    finally
        tRefresh.Enabled := True;
    end;

{
  if cbAuto.Checked then
    for _i:=mpgEvents.Row to mpgEvents.RowCount-1 do
      if _i<>mpgEvents.Row then
        mpgEvents.Cells[0,_i].Graphic:=_b1
}
end;

procedure TfmAnnManager.tbAutoClick(Sender: TObject);
begin
    try
        if Assigned(mpgAnn.HiddenCols[1])
        and Assigned(mpgAnn.HiddenCols[1].Cells[mpgAnn.Row])
        and Assigned(ListF[mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value]) then
            ListF[mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value].Auto := not ListF[mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value].Auto;
    except
        on EInvalidGridOperation do
          if ActiveMpg=MpgAnn then
            HSMessageDlg('Необходимо указать рейс !!!', mtError, [mbOk], 0);
    end;
end;

procedure TfmAnnManager.GetCodeShareInfo(_f:TFlight);
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format('select nr_cs,ak_cs from dbo.fnANN_GetCodeShareInfo(%d)',[_f.iIdSpp]);
    Open;
    _f.cNR_cs:=''; _f.cAK_cs:='';
    while not Eof do
    begin
      _f.cNR_cs:=_f.cNR_cs+IfThen(_f.cNR_cs='','',#13#10)+FieldByName('nr_cs').AsString;
      _f.cAK_cs:=_f.cAK_cs+IfThen(_f.cAK_cs='','',#13#10)+FieldByName('ak_cs').AsString;
      next;
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.GetOtherPorts(_f:TFlight);
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format('select port from fnANN_GetOtherPorts(%d)',[_f.iIdSpp]);
    Open;
    _f.cAP_other:='';
    while not Eof do
    begin
      _f.cAP_other:=_f.cAP_other+IfThen(_f.cAP_other='','',#13#10)+FieldByName('port').AsString;
      next;
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.RefreshStruct(AIdZone: Integer; ACon: TADOConnection);
var
  _sp: TADOStoredProc;
  _i: Integer;
  _r: Integer;
  _f: TFlight;
begin
  _r:=-1;
  _i:=1;
  try
    _sp:= TADOStoredProc.Create(nil);
    _sp.CursorType := ctStatic;
    _sp.LockType := ltReadOnly;
    _sp.Connection:=ACon;

    // Попытка предотвращения ненужной переделки списка // RIVC_Nabatov 02062010
    _sp.ProcedureName:='[dbo].[spANN_LoadSppPV]'; //02112010

    _sp.Parameters.Refresh;
    _sp.Parameters.ParamByName('@dt').Value:=now;//Date; 11.10.2010
    _sp.Parameters.ParamByName('@id_zone').Value:=AIdZone;
    _sp.Parameters.ParamByName('@hours_before').Value:=HoursBefore;
    _sp.Parameters.ParamByName('@hours_after').Value:=HoursAfter;
    _sp.Parameters.ParamByName('@IsVoice').Value:=ShowVisin;
    _sp.Open;

   // ShowMessage(IntToStr(_sp.RecordCount)); 
    ListF.Clear;

    while not _sp.Eof do
    begin
      _f := TFlight.Create(ListF);
      _f.iIdSpp := _sp.Fields.FieldByName('id').AsInteger;
      _f.cNR := _sp.Fields.FieldByName('nr').AsString;
      //_f.cNR_cs := _sp.Fields.FieldByName('nr_cs').AsString;
      _f.cAP := _sp.Fields.FieldByName('ap').AsString;
      _f.cAK := _sp.Fields.FieldByName('ak').AsString;
      //_f.cAK_cs := _sp.Fields.FieldByName('ak_cs').AsString;
      _f.bArr := iif(_sp.Fields.FieldByName('pv').AsString='В',False,True);
      _f.dt1 := _sp.Fields.FieldByName('dt1').AsDateTime;
      _f.dt2 := _sp.Fields.FieldByName('dt2').AsDateTime;
      _f.dt3 := _sp.Fields.FieldByName('dt3').AsDateTime;
      _f.dt4 := _sp.Fields.FieldByName('dt4').AsDateTime;
      _f.dt5 := _sp.Fields.FieldByName('dt5').AsDateTime;
      _f.Auto := (_sp.Fields.FieldByName('start').AsInteger > 0); // RIVC_Nabatov 29032010 Для авт.режима
      _f.bVisinAuto := _sp.Fields.FieldByName('visin_start').AsInteger > 0;
      _f.ExecuteMode := _sp.Fields.FieldByName('ExecuteMode').AsInteger;
      _f.sModeName := _sp.Fields.FieldByName('ExecuteModeName').AsString;
      _f.iport := _sp.Fields.FieldByName('id_port').AsInteger;
      _f.icompany := _sp.Fields.FieldByName('id_company').AsInteger;
      _f.cVR := _sp.Fields.FieldByName('vr').AsString;
      _f.cKODK := _sp.Fields.FieldByName('kodk').AsString;
      _f.bDelayed := not _sp.Fields.FieldByName('DVZ').IsNull;
      if _f.bDelayed then
        _f.dtDVZ := _sp.Fields.FieldByName('DVZ').AsDateTime;

      _f.dtDTU := _sp.Fields.FieldByName('DTU').AsDateTime;
      _f.cPRICH := _sp.Fields.FieldByName('PRICH').AsString;
      try
        _f.ShowVPChange := _sp.Fields.FieldByName('ShowVPChange').AsBoolean;
      except
        _f.ShowVPChange := false;
      end;  
//      _f.dtDTM:=_sp.Fields.FieldByName('dtm').AsDateTime;
      GetCodeShareInfo(_f);
      GetOtherPorts(_f);
      ListF.Add(_f);
      _sp.Next;
    end;
  finally
    _sp.Free;
  end;
end;

procedure TfmAnnManager.RefreshStructOptim(AIdZone: Integer; ACon: TADOConnection);
var
  _sp: TADOStoredProc;
  _i: Integer;
  _r: Integer;
  _f: TFlight;
begin
  _r:=-1;
  _i:=1;
  try
    _sp:= TADOStoredProc.Create(nil);
    _sp.CursorType := ctStatic;
    _sp.LockType := ltReadOnly;
    _sp.Connection:=ACon;

    // Попытка предотвращения ненужной переделки списка // RIVC_Nabatov 02062010
    _sp.ProcedureName:='[dbo].[spANN_LoadSppPVOptim]'; //02112010

    _sp.Parameters.Refresh;
    _sp.Parameters.ParamByName('@dt').Value:=now;//Date;
    _sp.Parameters.ParamByName('@id_zone').Value:=AIdZone;
    _sp.Parameters.ParamByName('@COP').Value := DM.COP;
    _sp.Parameters.ParamByName('@hours_before').Value:=HoursBefore;
    _sp.Parameters.ParamByName('@hours_after').Value:=HoursAfter;
    _sp.Parameters.ParamByName('@IsVoice').Value:=ShowVisin;
    _sp.Open;

    // Попытка предотвращения ненужной переделки списка // RIVC_Nabatov 02062010
    UpdatedReises := _sp.RecordCount;

    if UpdatedReises > 0 then ListF.Clear;

    while not _sp.Eof do
    begin
      _f := TFlight.Create(ListF);
      _f.iIdSpp := _sp.Fields.FieldByName('id').AsInteger;
      _f.cNR := _sp.Fields.FieldByName('nr').AsString;
      //_f.cNR_cs := _sp.Fields.FieldByName('nr_cs').AsString;
      _f.cAP := _sp.Fields.FieldByName('ap').AsString;
      _f.cAK := _sp.Fields.FieldByName('ak').AsString;
      //_f.cAK_cs := _sp.Fields.FieldByName('ak_cs').AsString;
      _f.bArr := iif(_sp.Fields.FieldByName('pv').AsString='В',False,True);
      _f.dt1 := _sp.Fields.FieldByName('dt1').AsDateTime;
      _f.dt2 := _sp.Fields.FieldByName('dt2').AsDateTime;
      _f.dt3 := _sp.Fields.FieldByName('dt3').AsDateTime;
      _f.dt4 := _sp.Fields.FieldByName('dt4').AsDateTime;
      _f.dt5 := _sp.Fields.FieldByName('dt5').AsDateTime;
      _f.Auto := (_sp.Fields.FieldByName('start').AsInteger > 0); // RIVC_Nabatov 29032010 Для авт.режима
      _f.bVisinAuto := _sp.Fields.FieldByName('visin_start').AsInteger > 0;
      _f.ExecuteMode := _sp.Fields.FieldByName('ExecuteMode').AsInteger;
      _f.sModeName := _sp.Fields.FieldByName('ExecuteModeName').AsString;
      _f.iport := _sp.Fields.FieldByName('id_port').AsInteger;
      _f.icompany := _sp.Fields.FieldByName('id_company').AsInteger;
      _f.cVR := _sp.Fields.FieldByName('vr').AsString;
      _f.cKODK := _sp.Fields.FieldByName('kodk').AsString;
      if not _sp.Fields.FieldByName('DVZ').IsNull then
        _f.dtDVZ := _sp.Fields.FieldByName('DVZ').AsDateTime;
      _f.dtDTU := _sp.Fields.FieldByName('DTU').AsDateTime;
      _f.cPRICH := _sp.Fields.FieldByName('PRICH').AsString;
      try
        _f.ShowVPChange :=  _sp.Fields.FieldByName('ShowVPChange').AsBoolean;
      except
        _f.ShowVPChange := false;
      end;
      GetCodeShareInfo(_f);
      GetOtherPorts(_f);
      ListF.Add(_f);
      _sp.Next;
    end;
  finally
    _sp.Free;
  end;
end;

procedure TfmAnnManager.cbModeChange(Sender: TObject);
begin
    // IdMode := StrToIntDef(cbMode.Values[cbMode.ItemIndex], 0);
end;

procedure TfmAnnManager.tAutoModeRefreshTimer(Sender: TObject);
begin
    // Обработчик для режима автоматического обработки ЗС
end;

procedure TfmAnnManager.acExecAllUpdate(Sender: TObject);
var i : integer;
    fCheckAll : boolean;
begin
    fCheckAll := True;

    for i := 0 to mpgEvents.RowCount - 1 do
    begin
        if mpgEvents.HiddenCols[1].Cells[i].Value > 0 then
        begin
            fCheckAll := False;
            break;
        end;
    end;

    (Sender as TAction).Enabled := fCheckAll;
end;

procedure TfmAnnManager.acStopAllUpdate(Sender: TObject);
var i : integer;
    fCheckAll : boolean;
begin
    fCheckAll := False;

    for i := 0 to mpgEvents.RowCount - 1 do
    begin
        if mpgEvents.HiddenCols[1].Cells[i].Value > 0 then
        begin
            fCheckAll := True;
            break;
        end;
    end;

    (Sender as TAction).Enabled := fCheckAll;
end;

procedure TfmAnnManager.acShowLabelUpdate(Sender: TObject);
var i : integer;
    fCheck, fUncheck : boolean;
begin
    fCheck := False;
    fUncheck := False;

    for i := 0 to mpgEvents.RowCount - 1 do
    begin
        if mpgEvents.HiddenCols[1].Cells[i].Value > 0 then fCheck := True;
        if mpgEvents.HiddenCols[1].Cells[i].Value = 0 then fUncheck := True;
    end;

    if fCheck and fUncheck then
    begin
        sbExecAll.Enabled := False;
        sbStopAll.Enabled := True;
        lStatus.Caption := 'Частичный запуск';
        lStatus.Font.Color := clBlue;
    end
    else
    if fCheck and not fUncheck then
    begin
        sbExecAll.Enabled := False;
        sbStopAll.Enabled := True;
        lStatus.Caption := 'Запущены все';
        lStatus.Font.Color := clGreen;
    end
    else
    if not fCheck and fUncheck then
    begin
        sbExecAll.Enabled := True;
        sbStopAll.Enabled := False;
        lStatus.Caption := 'Остановлены все';
        lStatus.Font.Color := clRed;
    end;
end;

procedure TfmAnnManager.acShowLabelExecute(Sender: TObject);
begin
    try
        if Assigned(mpgAnn.HiddenCols[1])
        and Assigned(mpgAnn.HiddenCols[1].Cells[mpgAnn.Row])
        and Assigned(ListF[mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value]) then
            // ListF[mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value].ExecuteMode := GetStatus(DM.con, _iStart);
            ExecuteListMessage(DM.con, (Sender as TAction).Tag);
    except
        on EInvalidGridOperation do
          if ActiveMpg=MpgAnn then
            HSMessageDlg('Необходимо указать рейс !!!', mtError, [mbOk], 0);
    end;
end;

procedure TfmAnnManager.sbExecAllClick(Sender: TObject);
var CanSelect : boolean;  _i:integer;
begin
    try
        tRefresh.Enabled := false;

        try
            if Assigned(ActiveMpg.HiddenCols[1])   //mpgAnn -> ActiveMpg 20072010 Романов
            and Assigned(ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row])
            and Assigned(ListF[ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value]) then
                // ListF[mpgAnn.HiddenCols[1].Cells[mpgAnn.Row].Value].ExecuteMode := GetStatus(DM.con, (Sender as TSpeedButton).Tag);
                //ExecuteListMessage(DM.con, (Sender as TSpeedButton).Tag);
                ExecuteListMessage(DM.con, 1);
                _i:=ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value;
            DM.AddToLog(Format(LogMsgFormAuto,[ListF[_i].cNR]),'','');
        except
            on EInvalidGridOperation do
              if ActiveMpg=mpgAnn then
                HSMessageDlg('Необходимо указать рейс !!!', mtError, [mbOk], 0);
        end;

        ActiveMpg.OnSelectCell(ActiveMpg, ActiveMpg.Col, ActiveMpg.Row, CanSelect);  //Sender->mpgAnn;
    finally
        tRefresh.Enabled := True;
    end;
end;

// Обновление рейса в списке
procedure TfmAnnManager.RefreshMpgAnnRecord(id_spp : integer);
var i, j : Integer;
    _b, _bm : TBitmap;
    ModeHint : string;
    FExistReis : boolean;
begin

    // Находим рейс в списке
    FExistReis := False;
    for i := 0 to ListF.Count - 1 do
    begin
        if ListF.Items[i].iIdSpp = id_spp then
        begin
            FExistReis := True;
            break;
        end;
    end;

    if (not FExistReis) or (ActiveMpg<>mpgANN) then exit;

    _b := TBitmap.Create;
    ActiveMpg.Cells[1, i + 1].Value := ListF.Items[i].cNR+IfThen(ListF.Items[i].cNR_cs='','',#13#10+ListF.Items[i].cNR_cs);     // mpgAnn -> ActiveMpg

    ActiveMpg.Cells[2, i + 1].Value := ListF.Items[i].cAP+IfThen(ListF.Items[i].cAP_other='','',#13#10+ListF.Items[i].cAP_other);
    ActiveMpg.Cells[3, i + 1].Value := ListF.Items[i].cAK+IfThen(ListF.Items[i].cAK_cs='','',#13#10+ListF.Items[i].cAK_cs);
    ActiveMpg.Cells[4, i + 1].Value := FormatDateTime('hhmm', ListF.Items[i].dt1);
    ActiveMpg.Cells[5, i + 1].Value := FormatDateTime('hhmm', ListF.Items[i].dt2);
    ActiveMpg.Cells[6, i + 1].Value := FormatDateTime('hhmm', ListF.Items[i].dt3);



    if not ListF.Items[i].bArr then
    begin
        ilSmall.GetBitmap(1, _b);
        ActiveMpg.Cells[7, i + 1].Value := FormatDateTime('hhmm', ListF.Items[i].dt4);
        ActiveMpg.Cells[8, i + 1].Value := FormatDateTime('hhmm', ListF.Items[i].dt5);
        ActiveMpg.Cells[0, i + 1].Hint := 'Вылет';
    end
    else
    begin
        ilSmall.GetBitmap(0, _b);
        ActiveMpg.Cells[0, i + 1].Hint := 'Посадка';
    end;
    ActiveMpg.Cells[0, i + 1].Graphic := _b;
    ActiveMpg.HiddenCols[0].Cells[i + 1].Value := ListF.Items[i].iIdSpp;
    ActiveMpg.HiddenCols[1].Cells[i + 1].Value := i;
    ActiveMpg.HiddenCols[2].Cells[i + 1].Value := ListF.Items[i].bArr;


    // Статус рейса
    _bm := TBitmap.Create;

    case ListF.Items[i].ExecuteMode of
    1 :
    begin
        ilSmall.GetBitmap(7, _bm);
    end;
    2 :
    begin
        ilSmall.GetBitmap(8, _bm);
    end;
    3 :
    begin
        ilSmall.GetBitmap(6, _bm);
    end;
    else
        ilSmall.GetBitmap(9, _bm);
    end;

    ActiveMpg.Cells[11, i + 1].Graphic := _bm;
    ActiveMpg.Cells[11, i + 1].Hint := ListF.Items[i].sModeName;



    if ListF.Items[i].ExecuteMode = 2 then // Из Визинформ
    // if ListF.Items[i].bVisinAuto then
    begin
        for j := 0 to ActiveMpg.ColCount - 1 do
        begin
            ActiveMpg.Cells[j, i + 1].Color := clSkyBlue;
            ActiveMpg.Cells[j, i + 1].Font.Color := clRed;
        end;
    end;
end;

procedure TfmAnnManager.N3Click(Sender: TObject);
begin
    with TfmEventSettings.Create(nil) do
    try
        ShowModal;
    finally
        Free;
    end;
end;

procedure TfmAnnManager.Button1Click(Sender: TObject);
begin
  try
    LS:=lsBegin;
    RefreshMainGrid;
  finally
    LS:=lsNone;
  end;
end;

procedure TfmAnnManager.acStopAllExecute(Sender: TObject);
var CanSelect : boolean; _i:integer;
begin
    try
        tRefresh.Enabled := false;

        try
            if Assigned(ActiveMpg.HiddenCols[1])   // mpgAnn -> ActiveMpg
            and Assigned(ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row])
            and Assigned(ListF[ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value]) then
                ExecuteListMessage(DM.con, 0);
        except
            on EInvalidGridOperation do
              if ActiveMpg=MpgAnn then
                HSMessageDlg('Необходимо указать рейс !!!', mtError, [mbOk], 0);
        end;
        _i:=ActiveMpg.HiddenCols[1].Cells[ActiveMpg.Row].Value;
        DM.AddToLog(Format(LogMsgDeleteAll,[ListF[_i].cNR]),'',''); 
        ActiveMpg.OnSelectCell(ActiveMpg, ActiveMpg.Col, ActiveMpg.Row, CanSelect); //Sender->mpgAnn
    finally
        tRefresh.Enabled := True;
    end;
end;

procedure TfmAnnManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
var _i : integer;
begin
  if HSMessageDlg('Выйти из программы?',mtConfirmation,[mbYes,mbNo],0)=mrNo then
  begin
    Action:=caNone;
    exit;
  end;
    // Очищаем список рейсов от картинок
    F.WriteInteger('Settings','Seconds',Seconds);
    F.WriteBool('Settings','ShowVisin',ShowVisin);
    F.WriteInteger('Settings','HoursBefore',HoursBefore);
    F.WriteInteger('Settings','HoursAfter',HoursAfter);  
    F.Free;
    for _i := 0 to mpgAnn.RowCount - 1 do
    begin
        if Assigned(mpgAnn.Cells[0, _i].Graphic) then
            mpgAnn.Cells[0, _i].Graphic := nil;

        if Assigned(mpgAnn.Cells[11, _i].Graphic) then
            mpgAnn.Cells[11, _i].Graphic := nil;
   end;

   // Освобождаем список событий от картинок
   for _i := 0 to mpgEvents.RowCount - 1 do
   begin
        if Assigned(mpgEvents.Cells[0, _i].Graphic) then
        begin
            mpgEvents.Cells[0, _i].Graphic := nil;
        end;

        if Assigned(mpgEvents.Cells[2, _i].Graphic) then
        begin
            mpgEvents.Cells[2, _i].Graphic := nil;
        end;
    end;
  DM.AddToLog('Закрытие программы ANN-Менеджер','','');
  CurrentMess.Free;    
end;

procedure TfmAnnManager.NAddMsgClick(Sender: TObject);
//var i : integer;
begin
{
    with TfmSingleMessage.Create(nil) do
    try
        id_msg := 0; // новое
        id_zone := self.idZone;
        ShowModal;

        if id_act <> 3 then
        begin
            if id_msg > 0 then
            if LS = lsNone then
            begin
                DM.RefreshMessList(IdZone);
                RefreshMessList;

                // Установить курсор на созданном сообщении
                for i := 0 to lv.Items.Count - 1 do
                begin
                    if id_msg = integer(lv.Items.Item[i].Data^) then
                    begin
                        lv.ItemIndex := i;
                    end;
                end;
            end;
        end;
    finally
        Release;
    end;
}
end;

procedure TfmAnnManager.NChangeMsgClick(Sender: TObject);
//var i : integer;
begin
{
    if (lv.ItemIndex >= 0)
    and Assigned(lv.Items.Item[lv.ItemIndex])
    and lv.Items.Item[lv.ItemIndex].Selected
    and (integer(lv.Items.Item[lv.ItemIndex].Data^) > 0) then
    with TfmSingleMessage.Create(nil) do
    try
        id_zone := self.idZone;
        id_msg := integer(lv.Items.Item[lv.ItemIndex].Data^); // редактируем или удаляем
        ShowModal;

        if id_act = 1 then // изменение
        begin
            if id_msg > 0 then
            if LS = lsNone then
            begin
                DM.RefreshMessList(IdZone);
                RefreshMessList;

                // Установить курсор на измененном сообщении
                lv.ItemIndex := 0;
                for i := 0 to lv.Items.Count - 1 do
                begin
                    if id_msg = integer(lv.Items.Item[i].Data^) then
                    begin
                        lv.ItemIndex := i;
                    end;
                end;
            end;
        end
        else
        if id_act = 2 then // удаление
        begin
            NDeleteMsg.OnClick(Sender);
            exit;
        end;
    finally
        Release;
    end;
}
end;

procedure TfmAnnManager.NDeleteMsgClick(Sender: TObject);
begin
{
    // Запуск хр.процедуры добавления ЗС
    if (lv.ItemIndex >= 0)
    and Assigned(lv.Items.Item[lv.ItemIndex])
    and lv.Items.Item[lv.ItemIndex].Selected
    and (integer(lv.Items.Item[lv.ItemIndex].Data^) > 0) then
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_DeleteSingleMessage';
        Parameters.Refresh;
        Parameters.ParamByName('@id_msg').Value := integer(lv.Items.Item[lv.ItemIndex].Data^);

        ExecProc;

        if Parameters.ParamByName('@return_value').Value > 0 then
        begin
            HSMessageDlg('Ошибка редактирования сообщения !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            exit;
        end;

        if LS = lsNone then
        begin
            DM.RefreshMessList(IdZone);
            RefreshMessList;
            if lv.Items.Count > 0 then lv.ItemIndex := 0;
        end;
    finally
        Free;
    end;
}
end;

procedure TfmAnnManager.actMsgAddExecute(Sender: TObject);
//var i : integer;
begin
    with TfmSingleMessage.Create(nil) do
    try
        id_msg := 0; // новое
        id_zone := self.idZone;
        ShowModal;

        if isModified and (LS = lsNone) then
        begin
            DM.RefreshMessList(IdZone);
            RefreshMessList;
        end;
        {
        if id_act <> 3 then
        begin
            if id_msg > 0 then
            if LS = lsNone then
            begin
                DM.RefreshMessList(IdZone);
                RefreshMessList;

                // Установить курсор на созданном сообщении
                for i := 0 to lv.Items.Count - 1 do
                begin
                    if id_msg = integer(lv.Items.Item[i].Data^) then
                    begin
                        lv.ItemIndex := i;
                    end;
                end;
            end;
        end;
        }
    finally
        Release;
    end;
end;

procedure TfmAnnManager.actMsgChangeExecute(Sender: TObject);
var i : integer;
begin

    if (lv.ItemIndex >= 0)
    and Assigned(lv.Items.Item[lv.ItemIndex])
    and lv.Items.Item[lv.ItemIndex].Selected
    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id > 0)
    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id_sched_templ > 0) then
    with TfmSingleMessage.Create(nil) do
    try
        id_zone := self.idZone;
        id_msg := TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id; // редактируем или удаляем
        ShowModal;

        if isModified and (LS = lsNone) then
        begin
            DM.RefreshMessList(IdZone);
            RefreshMessList;
        end;
    finally
        Release;
    end;
end;

procedure TfmAnnManager.actMsgDeleteExecute(Sender: TObject);
var
  msgtxt:string;
begin
    // Запуск хр.процедуры добавления ЗС
    msgtxt:=lv.Items.Item[lv.ItemIndex].SubItems.Names[1];
    if (lv.ItemIndex >= 0)
    and Assigned(lv.Items.Item[lv.ItemIndex])
    and lv.Items.Item[lv.ItemIndex].Selected
    // and (integer(lv.Items.Item[lv.ItemIndex].Data^) > 0) then
    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id > 0)
    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id_sched_templ > 0) then
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_DeleteSingleMessage';
        Parameters.Refresh;
        Parameters.ParamByName('@id_msg').Value := integer(lv.Items.Item[lv.ItemIndex].Data^);

        ExecProc;

        if Parameters.ParamByName('@return_value').Value > 0 then
        begin
            HSMessageDlg('Ошибка удаления сообщения !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            exit;
        end;

        if LS = lsNone then
        begin
            DM.RefreshMessList(IdZone);
            RefreshMessList;
            if lv.Items.Count > 0 then lv.ItemIndex := 0;
        end;
        DM.AddToLog(Format(LogMsgDeleteSingle,[msgtxt]),'','');
    finally
        Free;
    end;
end;

procedure TfmAnnManager.actMsgChangeUpdate(Sender: TObject);
begin
    (Sender as TAction).Enabled := (lv.ItemIndex >= 0)
                                    and Assigned(lv.Items.Item[lv.ItemIndex])
                                    and lv.Items.Item[lv.ItemIndex].Selected
                                    // and (integer(lv.Items.Item[lv.ItemIndex].Data^) > 0);
                                    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id > 0)
                                    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id_sched_templ > 0);

end;

procedure TfmAnnManager.actMsgDeleteUpdate(Sender: TObject);
begin
    (Sender as TAction).Enabled := (lv.ItemIndex >= 0)
                                    and Assigned(lv.Items.Item[lv.ItemIndex])
                                    and lv.Items.Item[lv.ItemIndex].Selected
                                    // and (integer(lv.Items.Item[lv.ItemIndex].Data^) > 0);
                                    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id > 0)
                                    and (TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id_sched_templ > 0);
end;

procedure TfmAnnManager.cbZoneChange(Sender: TObject);
begin
  IdZone := StrToIntDef(cbZone.Values[cbZone.ItemIndex], 0);
end;

procedure TfmAnnManager.RzReisEditChange(Sender: TObject);
var fo : TFindOptions;
    Col : integer;
    OldRow:integer;
begin
    ActiveMpg.DisableControls;  //mpgAnn->ActiveMpg
    OldRow:=ActiveMpg.Row;
    {if RzReisEdit.Text = '' then} ActiveMpg.Row := 1;
    fo := [frDown];
    Col := 1;
    if (not ActiveMpg.FindEx(RzReisEdit.Text, fo, Col)) and (not(trim(RzReisEdit.Text)=''))  then // 15072010 Романов А.Н.
    begin
      HSMessageDlg('Рейс не найден',mtWarning,[mbOk],0);
      ActiveMpg.Row:=OldRow;
    end;
    ActiveMpg.EnableControls; 
end;

procedure TfmAnnManager.tbReisTemplatesClick(Sender: TObject);
begin
    with TForm1.Create(nil)do
    try
        ShowModal;
    finally
        Free;
    end;
end;

procedure TfmAnnManager.tbCurrReisClick(Sender: TObject);
var i,j : integer;
begin
    j:=-1;
    for i := 0 to ListF.Count - 1 do
    begin

      if (ActiveMpg = mpgAnn) or
      ((ActiveMpg = mpgDep) and (not ListF.Items[i].bArr)) or
      ((ActiveMpg = mpgArr) and ListF.Items[i].bArr) then j:=j+1;

        if (Now > ListF.Items[i].dt1) then
        begin
            if (j = ListF.Count - 1) then // последний рейс в списке   //i->j
            begin
                if (ActiveMpg.RowCount >= j + 1) then ActiveMpg.Row := j + 1  //mpgANN (2) //i->j
                else ActiveMpg.Row := ActiveMpg.RowCount;                     //mpgANN (2)
            end
            else
            begin
                if (Now <= ListF.Items[i + 1].dt1) then
                begin
                    if (ActiveMpg.RowCount >= j + 2) then ActiveMpg.Row := j + 2  //mpgANN (2)  //i->j
                    else  ActiveMpg.Row := ActiveMpg.RowCount;                   //mpgANN (2)
                end;
            end;
        end;
    end;

end;

procedure TfmAnnManager.FormShow(Sender: TObject);

  procedure OldMessageControl;
  const
    SQLText = 'select 1 from dbo.%s (nolock) where sounded=0 and dt<DATEADD(HH,-5,GetDate())';
    MsgText = 'В AnnService есть устаревшие неозвученные сообщения (%s). Отменить их?';
    MsgRes = 'Отменено %s сообщений';
  var
    rc:integer;
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[AppInfo.IniData.Table]);
      Open;
      rc:=RecordCount;
      if rc>0 then
      begin
        if not isAccess('ANN_CancelMsg','kobra_ann') then
        begin
          HSMessageDlg(Format(MsgText,[IntToStr(rc)]),mtWarning,[mbOk],0);
          exit;
        end;
        if HSMessageDlg(Format(MsgText,[IntToStr(rc)]),mtWarning,[mbYes,mbNo],0)=mrYes then
        begin
          with TADOStoredProc.Create(nil) do
          try
            Connection:=DM.con;
            ProcedureName:='dbo.spANN_DeleteOldListMessages';
            ExecProc;
            acRefreshExecute(nil);
            HSMessageDlg(Format(MsgRes,[IntToStr(rc)]),mtInformation,[mbOk],0);
          finally
            Free;
          end;
        end;
      end;
    finally
      Free;
    end;
  end;

begin
//    HSMessageDlg('Открытие формы !!!', mtInformation, [mbOk], 0);

    BeforeSpeak:=0;
    DM.AddToLog('Запуск программы ANN-Менеджер','','');
    Curr_Alert:='';

    SetMainFunctionsDisabled;

   // ShowMessage('1');

    F:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'AnnManager.ini');
    Seconds:=F.ReadInteger('Settings','Seconds',15);
    ShowVisin:=F.ReadBool('Settings','ShowVisin',false);
    HoursBefore:=F.ReadInteger('Settings','HoursBefore',5);
    HoursAfter:=F.ReadInteger('Settings','HoursAfter',5);
    RowHeight:=F.ReadInteger('Settings','RowHeight',20);


    fGS := TGlobalStruct.Create;
    fGS.LoadData(DM.con);
    ListF:=TListFlights.Create(Self);

     //ShowMessage('2');

    InitGrids;
    InitZones;
    RefreshZoneStatus;

      // ShowMessage('3');
IdZone:=0;

           //  ShowMessage('4');
   // fmTemplates := nil;
    Exceptor1.ServerFromConnectionString(DM.con.ConnectionString);
    tbAuto.Height := 0;
    tbAuto.Width := 0;

      //  ShowMessage('5');
    RzPageControl1.ActivePageIndex:=0; //26072010 Романов
    ActiveMpg:=mpgAnn; //26072010 Романов

   // tRefreshTimer(Sender); // 15072010 Романов
    OldMessageControl; //12082010 Романов
    //tStatusTimer(Sender);
    PgAutoSizeCells(mpgAnn);
    PgAutoSizeCells(mpgDep);
    PgAutoSizeCells(mpgArr);
end;

procedure TfmAnnManager.UpdateVisinform;
begin
    with VisinformADO do
    try
        Connection := DM.con;

        // Обновить информацию по ЗС, в том числе инициированным Визинформом.
        ProcedureName := '[dbo].[spAnn_UpdateAutoStartVisinform]';
        Sleep(10);
        Parameters.Refresh;
        Parameters.ParamByName('@dt').Value := Date;
        ExecuteOptions := [eoAsyncExecute];
        ExecProc;

        while (stConnecting in RecordsetState)
            or(stExecuting in RecordsetState)
            or(State = dsOpening) do
        begin
            Application.ProcessMessages;
            Sleep(50);
        end;

//        if Parameters.ParamByName('@RETURN_VALUE').Value <> 0 then
//            HSMessageDlg('Невозможно получить данные из Визинформ !!!', mtError, [mbOk], 0);
    finally
    end;
end;

procedure TfmAnnManager.tUpdateVisinformTimer(Sender: TObject);
begin
    tUpdateVisinform.Enabled := False;
    UpdateVisinform;
    tUpdateVisinform.Enabled := True;
end;

procedure TfmAnnManager.mpgDepClick(Sender: TObject);
begin
  ActiveMpg:=(Sender as TMyProfGrid);
end;

procedure TfmAnnManager.tbStdMsgEditClick(Sender: TObject);
begin
  with TfmMsgStantardSettings.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;     
end;

procedure TfmAnnManager.tbLogClick(Sender: TObject);
begin
  With TfrmAnnLog.Create(nil) do
  try
    ShowModal;
    if isTurnedOn then
    begin
      DM.RefreshMessList(IdZone);
      RefreshMessList;
      if lv.Items.Count > 0 then lv.ItemIndex := 0;
    end; 
  finally
    Free;
  end;     
end;

procedure TfmAnnManager.mpgArrEnter(Sender: TObject);
begin
  mpgArr.SelectionColor:=clHighlight;
  mpgArr.SelectionFontColor:=clHighlightText;
  mpgDep.SelectionColor:=clWindow;
  mpgDep.SelectionFontColor:=clWindowText;
end;

procedure TfmAnnManager.mpgDepEnter(Sender: TObject);
begin
  mpgDep.SelectionColor:=clHighlight;
  mpgDep.SelectionFontColor:=clHighlightText;
  mpgArr.SelectionColor:=clWindow;
  mpgArr.SelectionFontColor:=clWindowText;
end;

procedure TfmAnnManager.tbAlertsClick(Sender: TObject);
begin
  Alerted:=false;
  tbAlerts.ImageIndex:=4;
  Curr_Alert:=AnnServiceStatus;
  if Curr_Alert='' then exit;
  HSMessageDlg(Curr_Alert,mtWarning,[mbOk],0);
end;

procedure TfmAnnManager.tAlertTimer(Sender: TObject);
begin
  if Alerted then
    tbAlerts.ImageIndex:=iif(tbAlerts.ImageIndex=4,5,4);
end;

procedure TfmAnnManager.tbStartTimeClick(Sender: TObject);
begin

  with TfrmSeconds.Create(nil) do
  try
    spnSeconds.Value:=Seconds;
    spnEarly.Value:=HoursBefore;
    spnLate.Value:=HoursAfter;
    chbxShowVisin.Checked:=ShowVisin;
    spnRowHeight.Value:=RowHeight;
    ShowModal;
    if (Selected) and (spnSeconds.Value>0) then
    begin
      Seconds:=spnSeconds.IntValue;
      ShowVisin:=chbxShowVisin.Checked;
      HoursBefore:=spnEarly.IntValue;
      HoursAfter:=spnLate.IntValue;
      tRefresh.Enabled:=false;
      RowHeight:=spnRowHeight.IntValue;
      FZoneChange:=true;
      acRefreshExecute(nil);
      tRefresh.Enabled:=true;
    end;
  finally
    Free;
  end;    
end;

procedure TfmAnnManager.tbLanguagesClick(Sender: TObject);
begin
  with tFrmLanguages.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.RzPageControl1Change(Sender: TObject);
var
  CanSelect:boolean;
begin
  if RzPageControl1.ActivePageIndex = 0 then
  begin
    ActiveMpg:=mpgAnn;
    BrushMpg(mpgAnn);
  end
  else
  begin
    ActiveMpg:=mpgDep;
    BrushMpg(mpgDep);
    BrushMpg(mpgArr);
  end;
  ActiveMpg.OnSelectCell(ActiveMpg, ActiveMpg.Col, ActiveMpg.TopRow, CanSelect);
end;

procedure TfmAnnManager.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  try
    mmMesText.Text:=Item.SubItems.Strings[1];
    //CurrentMess.MessText:=Item.SubItems.Strings[1];
    CurrentMess.Voice:=TMessInfo(Item.Data^).voice;
  except
  end;
end;

procedure TfmAnnManager.tbZonesClick(Sender: TObject);
begin
  with TfrmZones.Create(nil) do
  try
    ShowModal;
    if Changed then
    begin
      try
        fGs.Destroy;
        fGs:=TGlobalStruct.Create;
        fGs.LoadData(DM.con);
        initzones;
        RefreshZoneStatus;
      except
      end;  
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.actZoneOnOffExecute(Sender: TObject);
const
  LogZoneOnOff:array[0..1] of string = ('Запуск озвучки сообщений для зоны %s','Приостановка озвучки сообщений для зоны %s');

var
  tb:TRzToolBarButton;
  id_zone,st:integer;
  szone,slog:string;
  bm1,bm2,bm:TBitMap;

  procedure GetBmp(id_zone:integer;var bm:TBitMap);
  const
    SQLText = 'select pict from dbo.Ann_Zones (nolock) where id = %s';
  begin
    bm:=TBitMap.Create;
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[IntToStr(id_zone)]);
      Open;
      bm.Assign(Fields[0]);
    finally
      Free;
    end;
  end;

begin
  tb:=(Sender as TRzToolBarButton);
  id_zone:=tb.Tag;
  szone:=tb.Hint;
  St:=fGS.GetById(Id_Zone).OnOff;
  slog:=Format(LogZoneOnOff[St],[szone]);
  if St=-1 then
  begin
    HSMessageDlg('AnnService не запущен для зоны '+szone,mtError,[mbOk],0);
    exit;
  end;
  St:=iif(St=0,1,0);
  fGS.GetById(Id_Zone).OnOff:=St;
  GetBmp(Id_Zone,bm1);
  if ST=0 then
  begin
    bm2:=TBitMap.Create;
    imgStop.GetBitmap(1,bm2);
    MixBmp(bm1,bm2,bm);
    tb.Glyph.Assign(bm);
    bm2.Free;
    bm.Free;
  end
  else
    tb.Glyph.Assign(bm1);
  bm1.Free;
  DM.AddToLog(slog,'',''); 
end;

procedure TfmAnnManager.NCancelMsgClick(Sender: TObject);
var
  id:integer;
  id_zone:integer;
  s:string;
begin
  if lv.ItemIndex = -1 then exit;
  if lv.Focused then
  begin
    id:=integer(lv.Items.Item[lv.ItemIndex].Data^);
    id_zone:=TMessInfo(lv.Items.Item[lv.ItemIndex].Data^).id_zone;
    s:=lv.Items.Item[lv.ItemIndex].SubItems.Names[1];
  end
  else
  begin
    id:=integer(lvCurrReis.Items.Item[lvCurrReis.ItemIndex].Data^);
    id_zone:=TMessInfo(lvCurrReis.Items.Item[lv.ItemIndex].Data^).id_zone;
    s:=lvCurrReis.Items.Item[lvCurrReis.ItemIndex].SubItems.Names[1];
  end;

 {
  try
    udpClient.Host:=fZoneList.GetIPByZone(id_zone);
    udpClient.Active:=true;
    udpClient.Send('Stop;'+IntToStr(id));
  finally
    udpClient.Active:=false;
  end;
 }
 
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_RunStopMess';
    Parameters.Refresh;
    Parameters.ParamByName('@id_msg').Value:=id;
    Parameters.ParamByName('@St').Value:=2;
    ExecProc;
    DM.AddToLog('Отмена звукового сообщения '+s,'','');
    if LS = lsNone then
    begin
      DM.RefreshMessList(IdZone);
      RefreshMessList;
      //if lv.Items.Count > 0 then lv.ItemIndex := 0;   23092010 Романов А.Н.
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.tStatusTimer(Sender: TObject);

  function GetLocalIP: String;
  const WSVer = $101;
  var
    wsaData: TWSAData;
    P: PHostEnt;
    Buf: array [0..127] of Char;
  begin
    Result := '';
    if WSAStartup(WSVer, wsaData) = 0 then begin
      if GetHostName(@Buf, 128) = 0 then begin
        P := GetHostByName(@Buf);
        if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
      end;
    WSACleanup;

    end;
  end;


begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_SetStatus';
    Parameters.Refresh;
    Parameters.ParamByName('@tp').Value:='ANN_Manager';
    Parameters.ParamByName('@id_zone').Value:=0;
    Parameters.ParamByName('@ip').Value:=GetLocalIP;
    ExecProc;
  finally
    free;
  end;
end;

procedure TfmAnnManager.pmMinimizeClick(Sender: TObject);
begin
  Application.Minimize; 
end;

procedure TfmAnnManager.pmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmAnnManager.tbLangRulesClick(Sender: TObject);
begin
  with TfrmLangRules.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.tSpeakTimer(Sender: TObject);
const
  SQLText='select TOP 1 dt from dbo.ANN_MESS_LIST (nolock) where sounded=0 order by YEAR(dt), MONTH(dt), DAY(dt), DATEPART(HH,dt), DATEPART(MI,dt), prt';
var
  a,h,m,s: Integer;
  str: String;
begin

  if lv.Items.Count=0 then
  begin
    lbNextMess.Caption:='Список пуст!!!';
    exit;
  end;

  str:=DateToStr(now)+' '+lv.Items.Item[0].Caption;

  if StrToDateTimeDef(str,now)<now then
  begin
    if BeforeSpeak=0 then BeforeSpeak:=15
    else BeforeSpeak:=BeforeSpeak-1;
    a:=BeforeSpeak;
  end
  else
    a:=SecondsBetween(now,StrToDateTimeDef(str,now));
  h:=a div 3600;
  m:=(a-h*3600) div 60;
  s:=(a-h*3600) mod 60;
  str:=iif(h<10,'0','')+IntToStr(h)+':'+iif(m<10,'0','')+IntToStr(m)+':'+iif(s<10,'0','')+IntToStr(s);
  lbNextMess.Caption:=str;

{  if BeforeSpeak=0 then
  begin
   with TADOQuery.Create(nil) do
   try
     Connection:=DM.con;
     SQL.Text:=SQLText;
     Open;
     if not (Fields.FieldByName('dt').IsNull) then
     begin
       if Now>Fields.FieldByName('dt').AsDateTime then
       begin
         a:=15;
         BeforeSpeak:=15;
       end  
       else
         a:=SecondsBetweenEx(Now,Fields.FieldByName('dt').AsDateTime);
       h:=a div 3600;
       m:=(a-h*3600) div 60;
       s:=(a-h*3600) mod 60;
       str:=iif(h<10,'0','')+IntToStr(h)+':'+iif(m<10,'0','')+IntToStr(m)+':'+iif(s<10,'0','')+IntToStr(s);
     end
     else
       str:='Список пуст!!!';
   finally
     Free;
   end;
  end
  else
  begin
    BeforeSpeak:=BeforeSpeak-1;
    str:='00:00:'+iif(BeforeSpeak<10,'0','')+IntToStr(BeforeSpeak);
  end;
  lbNextMess.Caption:=str;}
end;

procedure TfmAnnManager.tbDelayClick(Sender: TObject);
begin
  with TfmDelayReason.Create(nil) do
  try
    ShowModal;
    RefreshDelays;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.sbDelayClick(Sender: TObject);
var
  CanSelect:boolean;
begin
  RefreshDelays;
  ppMenuDelay.Popup(sbDelay.ClientOrigin.X , sbDelay.ClientOrigin.Y);
end;

procedure TfmAnnManager.RefreshDelays;
const
  SQLText = 'select distinct iCode, short_title from dbo.ANN_Delay_Reasons (nolock) '+
            'where ISNULL(short_title,'''')<>'''' and pv = %s order by 2';
var
  mi:TMenuItem;
  pv:string;
begin
  pv:=iif(ActiveMPG.HiddenCols[2].Cells[ActiveMPG.Row].Value, 'П', 'В');
  pv:=#39+pv+#39;
  ppMenuDelay.Items.Clear;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format(SQLText,[pv]);
    Open;
    while not Eof do
    begin
      mi:=TMenuItem.Create(ppMenuDelay);
      ppMenuDelay.Items.Add(mi);
      mi.Caption:=FieldByName('short_title').AsString;
      mi.Tag:=FieldByName('iCode').AsInteger;
      mi.OnClick:=acDelayExecExecute;
      Next;
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.acDelayExecExecute(Sender: TObject);
var
  CanSelect:boolean;
  t:integer;
begin
  CanSelect:=true;
  t:=(Sender as TMenuItem).Tag;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='[dbo].[spANN_StartDelayMessage]';
    with Parameters do
    begin
      Refresh;
      ParamByName('@id_zone').Value:=IdZone;
      ParamByName('@id_spp').Value:=ActiveMpg.HiddenCols[0].Cells[ActiveMpg.Row].Value;
      ParamByName('@seconds').Value:=Seconds;
      ParamByName('@iCode').Value:=t; 
    end;
    ExecProc;
  finally
    Free;
  end;
  try
    acRefreshExecute(nil);
    ActiveMpg.OnSelectCell(ActiveMpg, ActiveMpg.Col, ActiveMpg.Row, CanSelect);
  except
  end;  
end;

procedure TfmAnnManager.tbSearchClick(Sender: TObject);
var
  r:integer;
  f:boolean;
  s:string;
begin
  s:=trim(RzReisEdit.Text);
  f:=false;
  for r:=ActiveMpg.Row+1 to ActiveMpg.RowCount-1 do
  begin
    f:=pos(s,ActiveMpg.Cells[1,r].Text)>0;
    if f then
    begin
      ActiveMpg.Row:=r;
      exit;
    end;
  end;
  for r:=1 to ActiveMpg.Row do
  begin
    f:=pos(s,ActiveMpg.Cells[1,r].Text)>0;
    if f then
    begin
      ActiveMpg.Row:=r;
      exit;
    end;
  end;
  HSMessageDlg('Рейс не найден',mtWarning,[mbOk],0);
end;

procedure TfmAnnManager.PgAutoSizeCells(pg:TProfGrid);
const
  SQLText = 'select col, width from dbo.ANN_ColWidths (nolock) '+
            'where cop = %s and pg = %s order by col';

var
  ArrCol:array of integer;
  ArrSet:array of boolean;
  i:integer;
begin
  ArrCol:=nil;
  SetLength(ArrCol,pg.ColCount);
  SetLength(ArrSet,pg.ColCount);
  for i:=0 to pg.ColCount-1 do
  begin
    ArrCol[i]:=75;
    ArrSet[i]:=false;
  end;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format(SQLText,[#39+AppInfo.AccessLogin+#39, IntToStr(pg.Tag)]);
    Open;
    while not Eof do
    begin
      ArrCol[FieldByName('Col').AsInteger]:=FieldByName('Width').AsInteger;
      ArrSet[FieldByName('Col').AsInteger]:=true;
      next;
    end;
  finally
    Free;
  end;

  with pg do
  begin
    for i:=0 to ColCount-1 do
      if ArrSet[i] then
        ColWidths[i]:=ArrCol[i];
    //AutoSizeColumns;
    //AutoSizeRows;
  end;
end;

procedure TfmAnnManager.btListenClick(Sender: TObject);
begin
  if CurrentMess.Playing then CurrentMess.MessStop
  else
  begin
    CurrentMess.MessText:=mmMesText.Text;  
    CurrentMess.MessSpeak;
  end;
end;

procedure TfmAnnManager.NCancelAllMsgClick(Sender: TObject);
begin
 with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_RunStopMess';
    Parameters.Refresh;
    Parameters.ParamByName('@id_msg').Value:=NULL;
    Parameters.ParamByName('@St').Value:=2;
    Parameters.ParamByName('@id_zone').Value:=IdZone;
    ExecProc;
    btStopClick(nil);
{    if IdZone<>0 then
    begin
      try
        udpClient.Host:=fZoneList.GetIPByZone(IdZone);
        udpClient.Active:=true;
        udpClient.Send('Stop');
      finally
        udpClient.Active:=false;
      end;
    end
    else
    begin
      with TADOQuery.Create(nil) do
      try
        Connection:=Dm.con;
        SQL.Text:='select ip_address from dbo.ANN_ZONE_RULES (nolock)';
        Open;
        while not Eof do
        begin
          try
            udpClient.Host:=FieldByName('ip_address').AsString;
            udpClient.Active:=true;
            udpClient.Send('Stop');
          finally
            udpClient.Active:=false;
          end;
          next;
        end;
      finally
        Free;
      end;
    end;   }

    DM.AddToLog('Отмена всех звуковых сообщений','','');
    if LS = lsNone then
    begin
      DM.RefreshMessList(IdZone);
      RefreshMessList;
      //if lv.Items.Count > 0 then lv.ItemIndex := 0;   23092010 Романов А.Н.
    end;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.fSetRowHeight(fValue:integer);
var
  r:integer;
  F:TIniFile;
begin
  fRowHeight:=fValue;
  F:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'AnnManager.ini');
  F.WriteInteger('Settings','RowHeight',fValue);
  F.Free;  
  for r:=1 to mpgAnn.RowCount-1 do
    mpgAnn.RowHeights[r]:=fRowHeight;
  for r:=1 to mpgDep.RowCount-1 do
    mpgDep.RowHeights[r]:=fRowHeight;
  for r:=1 to mpgArr.RowCount-1 do
    mpgArr.RowHeights[r]:=fRowHeight;
end;

procedure TfmAnnManager.mpgAnnColumnResized(Sender: TProfGrid; Index,
  OldSize, NewSize: Integer);
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_SaveColWidths';
    with Parameters do
    begin
      Refresh;
      ParamByName('@cop').Value:=AppInfo.AccessLogin;
      ParamByName('@pg').Value:=(Sender as TProfGrid).Tag;
      ParamByName('@col').Value:=Index;
      ParamByName('@width').Value:=NewSize;
    end;
    ExecProc;
  finally
    Free;
  end;
end;

procedure TfmAnnManager.btStopClick(Sender: TObject);
var
  id_zone:integer;
begin

  if lv.Items.Count = 0 then exit;
  id_zone:=TMessInfo(lv.Items.Item[0].Data^).id_zone;

  Screen.Cursor:=crHourGlass;
  try
    udpClient.Host:=fZoneList.GetIPByZone(id_zone);
    udpClient.Active:=true;
    udpClient.Send('Stop');
  finally
    udpClient.Active:=false;
    RefreshMessList;
    Screen.Cursor:=crDefault;
  end;
end;

end.
