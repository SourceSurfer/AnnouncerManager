unit SingleMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, ActnList, ADODB,DB, CheckLst,
  Mask, ToolEdit, RzEdit, VirtualTrees, ImgList, Math, Menus,DateUtils;

const
  LogITmplAdd = 'Добавление информационного шаблона %s';
  LogITmpEdit = 'Редактирование информационного шаблона %s';
    LogITmpEditDop = 'Название: %s, Текст: %s, Зона: %s, Язык: %s, Расписание: %s';
  LogITmpDelete = 'Удаление информвционного шаблона %s';
  LogITmpAddToList = 'Добавление информационного шаблона %s в очередь для озвучки';
  LogITmpDelFromList = 'Снятие информационного шаблона %s c очереди для озвучки';


type
  TfmSingleMessage = class(TForm)
    Panel1: TPanel;
    ActionList1: TActionList;
    actAdd: TAction;
    actDel: TAction;
    btAdd: TSpeedButton;
    btChange: TSpeedButton;
    btDelete: TSpeedButton;
    actEdit: TAction;
    actClear: TAction;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Label9: TLabel;
    Label2: TLabel;
    cbLanguage: TComboBox;
    MsgText: TMemo;
    vtSchedMessTree: TVirtualStringTree;
    actSchedDay: TAction;
    actSchedWeek: TAction;
    btUpdateControls: TSpeedButton;
    actUpdateControls: TAction;
    rgExecMode: TRadioGroup;
    lExecAfter: TLabel;
    dtpBaseDelta: TDateTimePicker;
    Panel5: TPanel;
    rgSched: TRadioGroup;
    clbWeek: TCheckListBox;
    rgExecMode2: TRadioGroup;
    Panel6: TPanel;
    cbPeriod: TCheckBox;
    dtpBegin: TDateTimePicker;
    lFrom: TLabel;
    lTo: TLabel;
    dtpEnd: TDateTimePicker;
    dtpStart: TDateTimePicker;
    lSatrt: TLabel;
    lInterval: TLabel;
    dtpInterval: TDateTimePicker;
    lTime: TLabel;
    dtpTime: TDateTimePicker;
    btAddTime: TSpeedButton;
    btDeleteTime: TSpeedButton;
    lbTimes: TListBox;
    ilTree: TImageList;
    Label1: TLabel;
    ETemplName: TEdit;
    lZone: TLabel;
    cbZone: TComboBox;
    pmMsg: TPopupMenu;
    NAdd: TMenuItem;
    NChange: TMenuItem;
    NDelete: TMenuItem;
    dtpEndStart: TDateTimePicker;
    LEnd: TLabel;
    NAddToList: TMenuItem;
    btAddToList: TSpeedButton;
    btCancelMess: TSpeedButton;
    Timer1: TTimer;
    Label3: TLabel;
    cbPrt: TComboBox;
    Panel7: TPanel;
    rgSoundType: TRadioGroup;
    Label4: TLabel;
    edMP3: TEdit;
    btMp3Open: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure actAddExecute(Sender: TObject);
    procedure actDelUpdate(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbLanguageDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure actEditExecute(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actClearUpdate(Sender: TObject);
    procedure actUpdateControlsUpdate(Sender: TObject);
    procedure rbDayClick(Sender: TObject);
    procedure rbWeekClick(Sender: TObject);
    procedure rgSchedClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure vtSchedMessTreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vtSchedMessTreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vtSchedMessTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure cbZoneDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure vtSchedMessTreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure btAddTimeClick(Sender: TObject);
    procedure btDeleteTimeClick(Sender: TObject);
    procedure lbTimesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure actDelExecute(Sender: TObject);
    procedure cbZoneChange(Sender: TObject);
    procedure NAddToListClick(Sender: TObject);
    procedure dtpIntervalExit(Sender: TObject);
    procedure btCancelMessClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure rgExecModeClick(Sender: TObject);
    procedure cbLanguageChange(Sender: TObject);
    procedure ETemplNameChange(Sender: TObject);
    procedure MsgTextChange(Sender: TObject);
    procedure dtpBaseDeltaChange(Sender: TObject);
    procedure cbPeriodClick(Sender: TObject);
    procedure dtpBeginChange(Sender: TObject);
    procedure dtpEndChange(Sender: TObject);
    procedure clbWeekClick(Sender: TObject);
    procedure rgExecMode2Click(Sender: TObject);
    procedure dtpStartChange(Sender: TObject);
    procedure dtpTimeChange(Sender: TObject);
    procedure dtpEndStartChange(Sender: TObject);
    procedure dtpIntervalChange(Sender: TObject);
    procedure rgSoundTypeClick(Sender: TObject);
    procedure btMp3OpenClick(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    fSoundType:integer;
    procedure SetLanguageList;
    procedure SetZoneList;
    procedure UpdateSchedMessTree;
    procedure AddTime(iTm : integer);
    procedure SetMainFunctionsDisabled;
    function GetTemplId:integer;
    function IsTemplInList(id_templ:integer):boolean;
    procedure SetNotSaved(AValue:boolean);
    procedure fSetSoundType(AValue:integer);
  public
    { Public declarations }
    id_msg : integer;
    id_sched_templ : integer;
    sched_templ : string;
    id_zone : integer;
    id_act : integer;
    isModified : boolean;
    FuncEnabled:boolean;
    AskForEdit:boolean;
    property notSaved:Boolean read fNotSaved write SetNotSaved;
    property SoundType:Integer read fSoundType write fSetSoundType;
  end;

var
  fmSingleMessage: TfmSingleMessage;

implementation

{$R *.dfm}

uses uDM, HSDialogs, Utils, intf_access;


procedure TfmSingleMessage.SetNotSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
  begin
    Caption:='Шаблоны сообщений по расписанию ***';
  end
  else
  begin
    Caption:='Шаблоны сообщений по расписанию';
    btAdd.NumGlyphs:=3;
    btChange.NumGlyphs:=3;
  end;
end; 

procedure TfmSingleMessage.fSetSoundType(AValue:integer);
begin
  fSoundType:=AValue;
  edMp3.Enabled:=fSoundType=1;
  case fSoundType of
  0: edMP3.Color:=clInactiveBorder;
  1: edMP3.Color:=clWindow; 
  end;
  btMp3Open.Enabled:=fSoundType=1;
end;

function TfmSingleMessage.GetTemplId:integer;
var
  NodeData : PDataInfo;
begin
  result:=0;
    if Assigned(vtSchedMessTree.FocusedNode) then
    begin

      NodeData := vtSchedMessTree.GetNodeData(vtSchedMessTree.FocusedNode);

      result := NodeData^.ExData[0];
      if result > 0 then

    end;
end; 

function TfmSingleMessage.IsTemplInList(id_templ:integer):boolean;
const
  SQLText='select 1 from dbo.ANN_MESS_LIST (nolock) where sounded=0 and id_sched_templ=%s';
begin
  result:=false;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format(SQLText,[IntToStr(id_templ)]);
    Open;
    result:=RecordCount>0;
  finally
    Free;
  end;
end;

procedure TfmSingleMessage.SetMainFunctionsDisabled;
begin
  FuncEnabled:=isAccess('ANN_EditSingleTempl','kobra_ann');
  btAdd.Enabled:=FuncEnabled;
  btChange.Enabled:=FuncEnabled;
 // btClear.Enabled:=FuncEnabled;
  btDelete.Enabled:=FuncEnabled;
  Panel2.Enabled:=FuncEnabled;
  Panel5.Enabled:=FuncEnabled;
  Panel6.Enabled:=FuncEnabled;
  btAddTime.Enabled:=FuncEnabled;
  btDeleteTime.Enabled:=FuncEnabled; 
end;

procedure TfmSingleMessage.actAddExecute(Sender: TObject);
var i, iWeekDays, Weight : integer;
    strTimes : string;
    Node : PVirtualNode;
    WeekCheck : boolean;
    SAfter:string;
begin
   if Round(Frac(dtpInterval.Time) * 86400)<61 then
     dtpInterval.Time:=StrToTime('0:01:01');
   if (dtpStart.Time >= dtpEndStart.Time) and (dtpBegin.Date = dtpEnd.Date) then
     dtpEndStart.Time:=IncSecond(dtpStart.Time,Round(Frac(dtpInterval.Time) * 86400));
   SAfter:='';

    // Запуск хр.процедуры добавления ЗС
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_AddSchedMessage';//02112010
        Parameters.Refresh;
        Parameters.ParamByName('@id_zone').Value := cbZone.Items.ValueFromIndex[cbZone.ItemIndex];
        Parameters.ParamByName('@lang').Value := cbLanguage.Items.ValueFromIndex[cbLanguage.ItemIndex];
        Parameters.ParamByName('@mtext').Value := MsgText.Text;
        Parameters.ParamByName('@prt').Value := cbPrt.ItemIndex+1;
        Parameters.ParamByName('@SoundType').Value := SoundType;
        Parameters.ParamByName('@MP3Path').Value:=edMP3.Text;

        if rgExecMode.ItemIndex = 0 then
            Parameters.ParamByName('@Sched').Value := 0 // единич.
        else
        if rgSched.ItemIndex = 0 then
        begin
            Parameters.ParamByName('@Sched').Value := 1; // недел.

            WeekCheck := False;
            for i := 0 to clbWeek.Count - 1 do
            begin
                if clbWeek.Checked[i] then WeekCheck := True;
            end;

            if not WeekCheck then
            begin
                HSMessageDlg('Не введены дни недели !!!', mtError, [mbOk], 0);
                exit;
            end;
        end
        else
            Parameters.ParamByName('@Sched').Value := 2; // ежедн.

        iWeekDays := 0;
        Weight := 1;
        for i := 0 to clbWeek.Count - 1 do
        begin
            Weight := Weight * 2;
            if clbWeek.Checked[i] then
                iWeekDays := iWeekDays + Round(Weight / 2);
        end;

        Parameters.ParamByName('@WeekDays').Value := iWeekDays;
        Parameters.ParamByName('@ExecMode').Value := rgExecMode2.ItemIndex;



        Parameters.ParamByName('@Interval').Value := Round(Frac(dtpInterval.Time) * 86400);

        if rgExecMode.ItemIndex = 0 then
            Parameters.ParamByName('@StartTime').Value := Round(Frac(dtpBaseDelta.Time) * 86400)
        else
        begin
            Parameters.ParamByName('@StartTime').Value := Round(Frac(dtpStart.Time) * 86400);
            Parameters.ParamByName('@EndTime').Value := Round(Frac(dtpEndStart.Time) * 86400);
        end;

        strTimes := '';
        for i := 0 to lbTimes.Count - 1 do
            strTimes := strTimes + lbTimes.Items.ValueFromIndex[i] + ';';

        Parameters.ParamByName('@Times').Value := strTimes;

        if cbPeriod.Checked then
            Parameters.ParamByName('@IsPeriod').Value := 1
        else
            Parameters.ParamByName('@IsPeriod').Value := 0;

        Parameters.ParamByName('@BeginDate').Value := dtpBegin.Date;
        Parameters.ParamByName('@EndDate').Value := dtpEnd.Date;

       { if cbCancelMsg.Checked then
            Parameters.ParamByName('@IsCanceled').Value := 1
        else 13082010 Романов}
            Parameters.ParamByName('@IsCanceled').Value := 0;

        if Length(ETemplName.Text) > 0 then
            Parameters.ParamByName('@TemplName').Value := ETemplName.Text
        else
        begin
            HSMessageDlg('Ведите название шаблона сообщения !!!', mtError, [mbOk], 0);
            exit;
        end;

        Parameters.ParamByName('@id_msg').Value := 0;

        if MsgText.Text = '' then
        begin
            HSMessageDlg('Ведите текст сообщения !!!', mtError, [mbOk], 0);
            exit;
        end;

        ExecProc;

        {
        if Fields[0].FieldName = 'ErrorMessage' then
        begin
            HSMessageDlg(FieldByName(FieldList.Fields[0].FieldName).AsString, mtError, [mbOk], 0);
            exit;
        end;
        }

        if (Parameters.ParamByName('@return_value').Value <> 0)
        or (Parameters.ParamByName('@id_msg').Value = 0) then
        begin
            SAfter:='Ошибка создания шаблона сообщения !!!';
            HSMessageDlg('Ошибка создания шаблона сообщения !!!' + '('
                        + IntToStr(Parameters.ParamByName('@return_value').Value) + ')'
                        +#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            DM.AddToLog(Format(LogITmplAdd,[ETemplName.Text]),'',SAfter);
            exit;
        end;

        if Parameters.ParamByName('@id_msg').Value = 0 then
        begin
            SAfter:='Ошибка создания шаблона сообщения !!!';
            HSMessageDlg('Ошибка создания шаблона сообщения !!!' + '('
                        + IntToStr(Parameters.ParamByName('@return_value').Value) + ')'
                        +#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            DM.AddToLog(Format(LogITmplAdd,[ETemplName.Text]),'',SAfter);            
            exit;
        end
        else
            id_sched_templ := Parameters.ParamByName('@id_msg').Value;

        DM.AddToLog(Format(LogITmplAdd,[ETemplName.Text]),'',SAfter);
        notSaved:=false;
    finally
        Free;
    end;

    UpdateSchedMessTree;
   // isModified := True;  16092010 Романов А.Н.
    // Добавить установку курсора на узле
    Node := FindNodeEx(vtSchedMessTree, vtSchedMessTree.RootNode, id_sched_templ, 0, 0);

    // Выделяем узел
    if Assigned(Node) then
    begin
        vtSchedMessTree.Selected[Node] := True;
        vtSchedMessTree.FocusedNode := Node;
        vtSchedMessTree.ScrollIntoView(0,false);
    end;

{
    // Запуск хр.процедуры добавления ЗС
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_AddSingleMessage';
        Parameters.Refresh;
        Parameters.ParamByName('@id_zone').Value := id_zone;
        Parameters.ParamByName('@lang').Value := cbLanguage.Items.ValueFromIndex[cbLanguage.ItemIndex];
        Parameters.ParamByName('@mtext').Value := MsgText.Text;
        Parameters.ParamByName('@date_delta').Value := Round(Frac(dtpBaseDelta.Time) * 86400);
        Parameters.ParamByName('@id_msg').Value := 0;

        if MsgText.Text = '' then
        begin
            HSMessageDlg('Ведите текст сообщения !!!', mtError, [mbOk], 0);
            exit;
        end;

        ExecProc;

        if Parameters.ParamByName('@id_msg').Value = 0 then
        begin
            HSMessageDlg('Ошибка создания сообщения !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            exit;
        end
        else
            id_msg := Parameters.ParamByName('@id_msg').Value;
    finally
        Free;

        Self.ModalResult := mrOk;
        Self.id_act := 0; // добавление
    end;
}
end;

procedure TfmSingleMessage.actDelUpdate(Sender: TObject);
var NodeData : PDataInfo;
    Node : PVirtualNode;
    ActFlag : boolean;
begin
    ActFlag := True;

    Node := vtSchedMessTree.FocusedNode;
    if Assigned(Node) then
    begin
        NodeData := vtSchedMessTree.GetNodeData(Node);

        if Assigned(NodeData) then
        begin
            if NodeData^.ExData[0] <= 0 then
                ActFlag := False;
        end
        else
            ActFlag := False;
    end
    else
        ActFlag := False;

    (Sender as TAction).Enabled := ActFlag and FuncEnabled;
end;

procedure TfmSingleMessage.actEditUpdate(Sender: TObject);
var NodeData : PDataInfo;
    Node : PVirtualNode;
    ActFlag : boolean;
begin
    ActFlag := True;

    Node := vtSchedMessTree.FocusedNode;
    if Assigned(Node) then
    begin
        NodeData := vtSchedMessTree.GetNodeData(Node);

        if Assigned(NodeData) then
        begin
            if NodeData^.ExData[0] <= 0 then
                ActFlag := False;
        end
        else
            ActFlag := False;
    end
    else
        ActFlag := False;

    (Sender as TAction).Enabled := ActFlag and FuncEnabled;
end;

procedure TfmSingleMessage.FormCreate(Sender: TObject);
begin
    id_msg := 0;
    id_act := 0;
    isModified := False;
    id_sched_templ := 0;
    btUpdateControls.Height := 0;
    btUpdateControls.Width := 0;

    // Инициализация структуры узла дерева
    vtSchedMessTree.NodeDataSize := sizeof(TDataInfo);
    vtSchedMessTree.Header.Columns[0].Width := 500;
    vtSchedMessTree.FocusedNode := vtSchedMessTree.RootNode;
    notSaved:=false;
    SoundTYpe:=0;
end;

procedure TfmSingleMessage.SetLanguageList;
var SP : TADOStoredProc;
    //APs : string;
    i : integer;
begin
    // Построить список возможных языков сообщений
    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_TemplSettings_16_GetLangList';
        Parameters.Refresh;
        if cbZone.ItemIndex>0 then
          Parameters.ParamByName('@vr').Value:=cbZone.ItemIndex;
        Open;

        cbLanguage.Clear;
        while not Eof do
        begin
            cbLanguage.Items.Values[Fields.FieldByName('caption').AsString] :=
                Fields.FieldByName('lang').AsString;
            Next;
        end;
        if cbLanguage.Items.Count > 0 then
        begin
          cbLanguage.ItemIndex := 0;
            for i:=0 to cbLanguage.Items.Count-1 do
            begin
              if pos('русский',cbLanguage.Items.Strings[i])>0 then
              begin
                cbLanguage.ItemIndex:=i;
                break;
              end;
            end;
        end;
    finally
        Free;
    end;
end;

procedure TfmSingleMessage.SetZoneList;
var SP : TADOStoredProc;
   // APs : string;
   // i : integer;
begin
    // Построить список возможных языков сообщений
    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_GetZoneList';
        Parameters.Refresh;
        Open;

        cbZone.Clear;
        while not Eof do
        begin
            cbZone.Items.Values[Fields.FieldByName('zone').AsString] :=
                Fields.FieldByName('id').AsString;
            Next;
        end;
        if cbZone.Items.Count > 0 then
            cbZone.ItemIndex := 0;
    finally
        Free;
    end;
end;

procedure TfmSingleMessage.FormShow(Sender: TObject);
var i : integer;
    Node : PVirtualNode;

    procedure FillPrt;
    begin
      with TADOQuery.Create(nil) do
      try
        Connection:=DM.con;
        SQL.Text:='select caption from dbo.ANN_Priority (nolock)';
        Open;
        while not Eof do
        begin
          cbPrt.Items.Add(Fields[0].AsString);
          Next;  
        end;
      finally
        Free;
      end;
    end;

begin
    AskForEdit:=true;
    FillPrt; // Заполняем список приоритетов

    SetMainFunctionsDisabled;
    // Заполнить список языков
    SetLanguageList;
    // Заполнить зоны
    SetZoneList;
    dtpBaseDelta.Time := 15 / 86400;

    UpdateSchedMessTree;

    if id_msg > 0 then // получаем ID шаблона
    begin
        with TADOStoredProc.Create(nil) do
        try
            Connection := DM.con;
            ProcedureName := 'dbo.spANN_GetMessageInfo';
            Parameters.Refresh;
            Parameters.ParamByName('@id_msg').Value := id_msg;

            Open;

            if (Parameters.ParamByName('@return_value').Value <> 0)
            or (Fields.FieldByName('id_sched_templ').AsInteger = 0) then
            begin
                HSMessageDlg('Шаблон не найден !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
                exit;
            end;

            id_sched_templ := Fields.FieldByName('id_sched_templ').AsInteger;

            // Находим узел в дереве шаблонов
            Node := FindNodeEx(vtSchedMessTree, vtSchedMessTree.RootNode, id_sched_templ, 0, 0);

            // Выделяем узел
            if Assigned(Node) then
            begin
                vtSchedMessTree.Selected[Node] := True;
                vtSchedMessTree.FocusedNode := Node;
            end;
        finally
            Free;
        end;
    end;
end;

procedure TfmSingleMessage.cbLanguageDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    (Control as TComboBox).Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top, (Control as TComboBox).Items.Names[Index]);
end;

procedure TfmSingleMessage.actEditExecute(Sender: TObject);
var i, iWeekDays, Weight : integer;
    strTimes, id_Node : string;
    NodeData : PDataInfo;
    Node : PVirtualNode;
    SBefore,SAfter,SLog,SSchd:string;


    function GetBeforeData(id:integer):string;
    const
      SQLText='select S.ID, S.TemplName,S.MsgTxt,IsNULL(Z.zone,''Все'') as Zone, L.caption as Lang, '+
               'case S.Sched '+
               'when 0 then ''Единичный'' '+
               'else ''По расписанию'' '+
               'end Sched '+
               'from dbo.ANN_SCHED_MESS_LIST S (nolock) '+
               'left join dbo.ANN_ZONES Z (nolock) on S.id_zone=Z.id  '+
               'left join dbo.ANN_LANGUAGES L (nolock) on S.Lang = L.lang '+
               'where S.id = %s';
    begin
      with TADOQuery.Create(nil) do
      try
        Connection:=DM.con;
        SQL.Text:=Format(SQLText,[IntToStr(id)]);
        Open;
        result:=Format(LogITmpEditDop,[FieldByName('TemplName').AsString,FieldByName('MsgTxt').AsString,FieldByName('Zone').AsString,FieldByName('Lang').AsString,FieldByName('Sched').AsString]);
      finally
        free;
      end;
    end;

begin
   if AskForEdit then
    if HSMessageDlg('Внести изменения в шаблон?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        exit;
    id_sched_templ := GetTemplId;
    SLog:=Format(LogITmpEdit,[ETemplName.Text]);
    SSchd:=iif(rgExecMode.ItemIndex=0,'Единичный','По расписанию');
    SAfter:=Format(LogITmpEditDop,[ETemplName.Text,MsgText.Text,cbZone.Text,cbLanguage.Text,SSchd]);
    SBefore:=GetBeforeData(id_sched_templ);

    if Round(Frac(dtpInterval.Time) * 86400)<61 then
       dtpInterval.Time:=StrToTime('0:01:01');
    if (TimeOf(dtpStart.Time) >= TimeOf(dtpEndStart.Time)) and (DateOf(dtpBegin.Date) = DateOf(dtpEnd.Date)) then
       dtpEndStart.Time:=IncSecond(dtpStart.Time,Round(Frac(dtpInterval.Time) * 86400));

    if id_sched_templ <= 0 then
    begin
      HSMessageDlg('Не выбран шаблон для изменения!!!', mtError, [mbOk], 0);
      exit;
    end;
    if IsTemplInList(id_sched_templ) then
    begin
      if HSMessageDlg('Выбранный шаблон находится в очереди для озвучивания.'+#10+'Сохранить его как новый?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
      begin
        ETemplName.Text:=ETemplName.Text+'(1)';
        btAdd.Click;
      end;
      exit;
    end;

    // Запуск хр.процедуры добавления ЗС
    with TADOStoredProc.Create(nil) do
    try



        Connection := DM.con;
        ProcedureName := 'dbo.spANN_ChangeSchedMessage'; //02112010
        Parameters.Refresh;
        Parameters.ParamByName('@id_msg').Value := id_sched_templ;
        Parameters.ParamByName('@id_zone').Value := cbZone.Items.ValueFromIndex[cbZone.ItemIndex];
        Parameters.ParamByName('@lang').Value := cbLanguage.Items.ValueFromIndex[cbLanguage.ItemIndex];
        Parameters.ParamByName('@mtext').Value := MsgText.Text;
        Parameters.ParamByName('@prt').Value := cbPrt.ItemIndex+1;
        Parameters.ParamByName('@SoundType').Value := SoundType;
        Parameters.ParamByName('@MP3Path').Value:=edMP3.Text;

        if rgExecMode.ItemIndex = 0 then
            Parameters.ParamByName('@Sched').Value := 0 // единич.
        else
        if rgSched.ItemIndex = 0 then
            Parameters.ParamByName('@Sched').Value := 1 // недел.
        else
            Parameters.ParamByName('@Sched').Value := 2; // ежедн.

        iWeekDays := 0;
        Weight := 1;
        for i := 0 to clbWeek.Count - 1 do
        begin
            Weight := Weight * 2;
            if clbWeek.Checked[i] then
                iWeekDays := iWeekDays + Round(Weight / 2);
        end;

        Parameters.ParamByName('@WeekDays').Value := iWeekDays;
        Parameters.ParamByName('@ExecMode').Value := rgExecMode2.ItemIndex;

        SetRoundMode(rmNearest);
        Parameters.ParamByName('@Interval').Value := Round(Frac(dtpInterval.Time) * 86400);

        if rgExecMode.ItemIndex = 0 then
            Parameters.ParamByName('@StartTime').Value := Round(Frac(dtpBaseDelta.Time) * 86400)
        else
        begin
            Parameters.ParamByName('@StartTime').Value := Round(Frac(dtpStart.Time) * 86400);
            Parameters.ParamByName('@EndTime').Value := Round(Frac(dtpEndStart.Time) * 86400);
        end;

        strTimes := '';
        for i := 0 to lbTimes.Count - 1 do
            strTimes := strTimes + lbTimes.Items.ValueFromIndex[i] + ';';

        Parameters.ParamByName('@Times').Value := strTimes;

        if cbPeriod.Checked then
            Parameters.ParamByName('@IsPeriod').Value := 1
        else
            Parameters.ParamByName('@IsPeriod').Value := 0;

        Parameters.ParamByName('@BeginDate').Value := dtpBegin.Date;
        Parameters.ParamByName('@EndDate').Value := dtpEnd.Date;

        {if cbCancelMsg.Checked then
            Parameters.ParamByName('@IsCanceled').Value := 1
        else 13082010 Романов А.Н.}
            Parameters.ParamByName('@IsCanceled').Value := 0;

        if Length(ETemplName.Text) > 0 then
            Parameters.ParamByName('@TemplName').Value := ETemplName.Text
        else
        begin
            HSMessageDlg('Ведите название шаблона сообщения !!!', mtError, [mbOk], 0);
            exit;
        end;





        if MsgText.Text = '' then
        begin
            HSMessageDlg('Ведите текст сообщения !!!', mtError, [mbOk], 0);
            exit;
        end;

        {ShowMessage('id_zone: '+VarToStr(Parameters.ParamByName('@id_zone').Value)+#10
                    +'lang: '+VarToStr(Parameters.ParamByName('@lang').Value)+#10
                    +'mtext: '+VarToStr(Parameters.ParamByName('@mtext').Value)+#10
                    +'Sched: '+VarToStr(Parameters.ParamByName('@Sched').Value)+#10
                    +'WeekDays: '+VarToStr(Parameters.ParamByName('@WeekDays').Value)+#10
                    +'ExecMode: '+VarToStr(Parameters.ParamByName('@ExecMode').Value)+#10
                    +'Interval: '+VarToStr(Parameters.ParamByName('@interval').Value)+#10
                    +'StartTime: '+VarToStr(Parameters.ParamByName('@id_zone').Value)+#10
                    +'EndTime: '+VarToStr(Parameters.ParamByName('@id_zone').Value)+#10
                    +'Times: '+VarToStr(Parameters.ParamByName('@times').Value)+#10
                    +'IsPeriod: '+VarToStr(Parameters.ParamByName('@id_zone').Value)+#10
                    +'BeginDate: '+VarToStr(Parameters.ParamByName('@BeginDate').Value)+#10
                    +'EndDate: '+VarToStr(Parameters.ParamByName('@EndDate').Value)+#10
                    +'IsCanceled: '+VarToStr(Parameters.ParamByName('@IsCanceled').Value)+#10
                    +'TemplName: '+VarToStr(Parameters.ParamByName('@TemplName').Value)+#10
                    +'id_msg: '+VarToStr(Parameters.ParamByName('@id_msg').Value)); }

        ExecProc;

        if Parameters.ParamByName('@return_value').Value <> 0 then
        begin
            SAfter:='Ошибка редактирования шаблона сообщения !!!';
            HSMessageDlg('Ошибка редактирования шаблона сообщения !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            DM.AddToLog(SLog,SBefore,SAfter);
            exit;
        end;
        DM.AddToLog(SLog,SBefore,SAfter);
        notSaved:=false;
    finally
        Free;
    end;

    UpdateSchedMessTree;
    //isModified := True;
    // Добавить установку курсора на узле
    Node := FindNodeEx(vtSchedMessTree, vtSchedMessTree.RootNode, id_sched_templ, 0, 0);

    // Выделяем узел
    if Assigned(Node) then
    begin
        vtSchedMessTree.Selected[Node] := True;
        vtSchedMessTree.FocusedNode := Node;
        vtSchedMessTree.ScrollIntoView(0,false);
    end;

    {
    // Запуск хр.процедуры добавления ЗС
    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_ChangeSingleMessage';
        Parameters.Refresh;
        Parameters.ParamByName('@id_zone').Value := id_zone;
        Parameters.ParamByName('@id_msg').Value := id_msg;
        Parameters.ParamByName('@lang').Value := cbLanguage.Items.ValueFromIndex[cbLanguage.ItemIndex];
        Parameters.ParamByName('@mtext').Value := MsgText.Text;
        Parameters.ParamByName('@date_delta').Value := Round(Frac(dtpBaseDelta.Time) * 86400);

        if MsgText.Text = '' then
        begin
            HSMessageDlg('Ведите текст сообщения !!!', mtError, [mbOk], 0);
            exit;
        end;

        ExecProc;

        if Parameters.ParamByName('@return_value').Value > 0 then
        begin
            HSMessageDlg('Ошибка редактирования сообщения !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            exit;
        end;
    finally
        Free;

        Self.ModalResult := mrOk;
        Self.id_act := 1; // изменение
    end;
    }
end;

//Кнопка Отмена --Удалена
procedure TfmSingleMessage.btCancelClick(Sender: TObject);
begin
  //  Self.ModalResult := mrCancel;
end;

//Кнопка очистить настройки -- Удалена
procedure TfmSingleMessage.actClearExecute(Sender: TObject);
begin
    MsgText.Text := '';
    dtpBaseDelta.Time := 15 / 86400;
    dtpBegin.Date := Now;
    dtpEnd.Date := Now;
    rgSched.ItemIndex := 0;
    rgSched.OnClick(Sender);
    rgExecMode2.ItemIndex := 0;
    dtpStart.Time := 0;
    dtpEndStart.Time := 0;
    dtpInterval.Time := StrToTime('0:01:01'); //60 / 86400; 12082010 Романов А.Н.
    dtpTime.Time := 0;
    lbTimes.Clear;
    ETemplName.Text := '';
    rgSoundType.ItemIndex:=0; 
end;

procedure TfmSingleMessage.actClearUpdate(Sender: TObject);
begin
    //(Sender as TAction).Enabled := (length(MsgText.Text) > 0);
end;

procedure TfmSingleMessage.actUpdateControlsUpdate(Sender: TObject);
var IsExecMode, IsInterval, IsTime : boolean;
begin
    if not FuncEnabled then exit;
    IsExecMode := (rgExecMode.ItemIndex = 1);

    // Единичный запуск
    if lExecAfter.Enabled <> (not IsExecMode) then
        lExecAfter.Enabled := not IsExecMode;

    if dtpBaseDelta.Enabled <> (not IsExecMode) then
        dtpBaseDelta.Enabled := (not IsExecMode);

    // По расписанию
    if cbPeriod.Enabled <> IsExecMode then cbPeriod.Enabled := IsExecMode;
    if lFrom.Enabled <> (IsExecMode and cbPeriod.Checked) then
        lFrom.Enabled := (IsExecMode and cbPeriod.Checked);
    if lTo.Enabled <> (IsExecMode and cbPeriod.Checked) then
        lTo.Enabled := (IsExecMode and cbPeriod.Checked);
    if dtpBegin.Enabled <> (IsExecMode and cbPeriod.Checked) then
        dtpBegin.Enabled := (IsExecMode and cbPeriod.Checked);
    if dtpEnd.Enabled <> (IsExecMode and cbPeriod.Checked) then
        dtpEnd.Enabled := (IsExecMode and cbPeriod.Checked);
    if rgSched.Enabled <> IsExecMode then rgSched.Enabled := IsExecMode;
    if rgExecMode2.Enabled <> IsExecMode then rgExecMode2.Enabled := IsExecMode;
    if rgSched.Enabled <> IsExecMode then rgSched.Enabled := IsExecMode;

    if clbWeek.Enabled <> (IsExecMode and (rgSched.ItemIndex = 0)) then
        clbWeek.Enabled := (IsExecMode and (rgSched.ItemIndex = 0));

    // С интервалом
    IsInterval := (IsExecMode and (rgExecMode2.ItemIndex = 0));
    if lSatrt.Enabled <> IsInterval then lSatrt.Enabled := IsInterval;
    if LEnd.Enabled <> IsInterval then LEnd.Enabled := IsInterval; 
    if dtpStart.Enabled <> IsInterval then dtpStart.Enabled := IsInterval;
    if dtpEndStart.Enabled <> IsInterval then dtpEndStart.Enabled := IsInterval;
    if lInterval.Enabled <> IsInterval then lInterval.Enabled := IsInterval;
    if dtpInterval.Enabled <> IsInterval then dtpInterval.Enabled := IsInterval;

    // По времени
    IsTime := (IsExecMode and (rgExecMode2.ItemIndex = 1));
    if lTime.Enabled <> IsTime then lTime.Enabled := IsTime;
    if dtpTime.Enabled <> IsTime then dtpTime.Enabled := IsTime;
    if lbTimes.Enabled <> IsTime then lbTimes.Enabled := IsTime;
    if btAddTime.Enabled <> IsTime then btAddTime.Enabled := IsTime;

    if btDeleteTime.Enabled <> (IsTime and (lbTimes.Count > 0)) then
    btDeleteTime.Enabled := IsTime and (lbTimes.Count > 0);

    // gbTimes.Top := Panel4.Height;
end;

procedure TfmSingleMessage.rbDayClick(Sender: TObject);
var i : integer;
begin
    for i := 0 to clbWeek.Items.Count - 1 do
        clbWeek.Checked[i] := True;
end;

procedure TfmSingleMessage.rbWeekClick(Sender: TObject);
var i : integer;
begin
    for i := 0 to clbWeek.Items.Count - 1 do
        clbWeek.Checked[i] := False;
end;

procedure TfmSingleMessage.rgSchedClick(Sender: TObject);
var i : integer;
    IsCheck : boolean;
begin
    IsCheck := (rgSched.ItemIndex = 1);

    for i := 0 to clbWeek.Items.Count - 1 do
        clbWeek.Checked[i] := IsCheck;
    notSaved:=true;    
end;

procedure TfmSingleMessage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    vtSchedMessTree.Clear;
end;

procedure TfmSingleMessage.UpdateSchedMessTree;
var
  SP : TADOStoredProc;

begin
    // Построить дерево для базовой привязки
    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_GetSchedMessSQLTree';
        Parameters.Refresh;
        VirtualTreeFill_Ex(SP, vtSchedMessTree);
    finally
        Free;
    end;

end;

procedure TfmSingleMessage.vtSchedMessTreeFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var P : PDataInfo;
begin
    // Освобождаем память, выделенную под каждый узел
    P := (Sender as TVirtualStringTree).GetNodeData(Node);
    if Assigned(P) then
    begin
        Finalize(P^);
    end;
end;

procedure TfmSingleMessage.vtSchedMessTreeGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var PDataNode : PDataInfo;
begin
    PDataNode := (Sender as TVirtualStringTree).GetNodeData(Node);
    if column > 0 then exit;
    if Assigned(PDataNode) then
    begin
        if vsSelected in (Node.States) then
            ImageIndex := PDataNode^.SelectedIndex
        else
            ImageIndex := PDataNode^.ImageIndex;
    end;
end;

procedure TfmSingleMessage.vtSchedMessTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var NewData: PDataInfo;
begin
    // Заполняем текст узла
    NewData := (Sender as TVirtualStringTree).GetNodeData(Node);
    if Assigned(NewData) then
    case Column of
    0 :
    begin
        CellText := NewData^.NodeName; //NodeName;
    end;
    end;
end;

procedure TfmSingleMessage.cbZoneDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    (Control as TComboBox).Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top, (Control as TComboBox).Items.Names[Index]);
end;

procedure TfmSingleMessage.AddTime(iTm : integer);
var t : TTime;
begin
    t := Frac(iTm / 86400);

    if lbTimes.Items.Values[TimeToStr(t)] = '' then // еще нет в списке
    begin
        lbTimes.Items.Values[TimeToStr(t)] := IntToStr(iTm);
    end;
end;

procedure TfmSingleMessage.vtSchedMessTreeFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var NodeData : PDataInfo;
    i, iSched, iWeekDays, Weight, iTime : integer;
    strTimes : string;
begin
    // Получаем информацию о шаблоне
    NodeData := vtSchedMessTree.GetNodeData(Node);

    if not Assigned(NodeData) then exit;


    btClear.OnClick(Sender);
    if NodeData^.ExData[0] > 0 then
    begin
        with TADOStoredProc.Create(nil) do
        try
            Connection := DM.con;
            ProcedureName := 'dbo.spANN_GetSchedTemplInfo'; //20112010
            Parameters.Refresh;
            Parameters.ParamByName('@id_templ').Value := NodeData^.ExData[0];
            Open;

            if Parameters.ParamByName('@return_value').Value > 0 then
            begin
                HSMessageDlg('Невозможно получить информацию о шаблоне!!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
                exit;
            end;

            cbZone.ItemIndex := Fields.FieldByName('id_zone').AsInteger;

            cbLanguage.ItemIndex := -1;
            for i := 0 to cbLanguage.Items.Count - 1 do
            begin
                if cbLanguage.Items.ValueFromIndex[i] = Fields.FieldByName('lang').AsString then
                    cbLanguage.ItemIndex := i;
            end;

            MsgText.Text := Fields.FieldByName('MsgTxt').AsString;

            cbPrt.ItemIndex:=Fields.FieldByName('Prt').AsInteger-1;   

            iSched := Fields.FieldByName('Sched').Value;
            case iSched of
            0 :
            begin
                rgExecMode.ItemIndex := 0;
            end;
            1 :
            begin
                rgExecMode.ItemIndex := 1;
                rgSched.ItemIndex := 0;
            end;
            2 :
            begin
                rgExecMode.ItemIndex := 1;
                rgSched.ItemIndex := 1;
            end;
            end;

            Weight := 1;
            iWeekDays := Fields.FieldByName('WeekDays').AsInteger;

            SetRoundMode(rmTruncate);

            for i := 0 to clbWeek.Count - 1 do
            begin
                Weight := Weight * 2;
                clbWeek.Checked[i] := (Round(2 * iWeekDays / Weight) mod 2) > 0;
            end;

            rgExecMode2.ItemIndex := Fields.FieldByName('ExecMode').AsInteger;

            SetRoundMode(rmNearest);
            dtpInterval.Time := Fields.FieldByName('Interval').AsInteger / 86400;

            if rgExecMode.ItemIndex = 0 then
                dtpBaseDelta.Time := Fields.FieldByName('StartTime').AsInteger / 86400
            else
            begin
                dtpStart.Time := Fields.FieldByName('StartTime').AsInteger / 86400;
                dtpEndStart.Time := Fields.FieldByName('EndTime').AsInteger / 86400;
            end;


            lbTimes.Clear;
            strTimes := Fields.FieldByName('Times').AsString;
            while Length(strTimes) > 0 do
            begin
                iTime := StrToIntDef(Copy(strTimes, 1, Pos(';', strTimes) - 1), -1);
                if iTime < 0 then
                begin
                    HSMessageDlg('Неверное значение времени запуска!!! (' + Copy(strTimes, 1, Pos(';', strTimes) - 1) + ')', mtError, [mbOk], 0);
                end
                else
                    AddTime(iTime);

                strTimes := Copy(strTimes, Pos(';', strTimes) + 1, length(strTimes) - Pos(';', strTimes));
            end;

            if Fields.FieldByName('IsPeriod').AsInteger > 0 then
                cbPeriod.Checked := True
            else
                cbPeriod.Checked := False;

            dtpBegin.Date := Fields.FieldByName('BeginDate').AsDateTime;
            dtpEnd.Date := Fields.FieldByName('EndDate').AsDateTime;

            {if Fields.FieldByName('IsCanceled').AsInteger > 0 then
                cbCancelMsg.Checked := True
            else
                cbCancelMsg.Checked := False; 13082010 Романов А.Н.}

            ETemplName.Text := Fields.FieldByName('TemplName').AsString;
            if ETemplName.Text = '' then
                ETemplName.Text := 'Без названия';

            rgSoundType.ItemIndex:=Fields.FieldByName('SoundType').AsInteger;
            edMp3.Text:=Fields.FieldByName('MP3Path').AsString;    
        finally
            Free;
        end;
    end
    else
        btClear.OnClick(Sender);
    notSaved:=false;
    vtSchedMessTree.ScrollIntoView(0,false);
    //vtSchedMessTree.ScrollBy(0,0);
end;

procedure TfmSingleMessage.btAddTimeClick(Sender: TObject);
begin
    AddTime(Round(Frac(dtpTime.Time) * 86400));
    notSaved:=true;
end;

procedure TfmSingleMessage.btDeleteTimeClick(Sender: TObject);
begin
    if lbTimes.ItemIndex >= 0 then
        lbTimes.Items.Delete(lbTimes.ItemIndex);
    notSaved:=true;
end;

procedure TfmSingleMessage.lbTimesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    (Control as TListBox).Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top, (Control as TListBox).Items.Names[Index]);
end;

procedure TfmSingleMessage.actDelExecute(Sender: TObject);
var NodeData : PDataInfo;
    ParantNode : PVirtualNode;
    SAfter:string;
begin
    SAfter:='';
    // Запуск хр.процедуры добавления ЗC
    if HSMessageDlg('Удалить выбранное сообщение?',mtConfirmation,[mbYes,mbNo],0)=mrNo then exit;
    id_sched_templ := GetTemplId;
    if id_sched_templ <= 0 then
    begin
      HSMessageDlg('Не выбран шаблон для удаления!!!', mtError, [mbOk], 0);
      exit;
    end;
    if IsTemplInList(id_sched_templ) then
    begin
      HSMessageDlg('Нельзя удалить шаблон, который находится в очереди для озвучки!',mtError,[mbOk],0);
      exit;
    end;

    with TADOStoredProc.Create(nil) do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_DeleteSchedMessage';
        Parameters.Refresh;

        if Assigned(vtSchedMessTree.FocusedNode) then
        begin
            ParantNode := vtSchedMessTree.FocusedNode.Parent;

            Parameters.ParamByName('@id_msg').Value := id_sched_templ;
        end
        else
        begin
            HSMessageDlg('Не выбран шаблон для удаления!!!', mtError, [mbOk], 0);
            exit;
        end;

        ExecProc;

        if Parameters.ParamByName('@return_value').Value > 0 then
        begin
            SAfter:='Ошибка удаления шаблона сообщения !!!';
            HSMessageDlg('Ошибка удаления шаблона сообщения !!!'#13#10'Обратитесь к разработчикам', mtError, [mbOk], 0);
            DM.AddToLog(Format(LogITmpDelete,[ETemplName.Text]),'',SAfter);
            exit;
        end;
        DM.AddToLog(Format(LogITmpDelete,[ETemplName.Text]),'',SAfter);

    finally
        Free;
    end;

    UpdateSchedMessTree;
    isModified := True;
    if Assigned(ParantNode) then
      vtSchedMessTree.Selected[ParantNode] := True;
    vtSchedMessTree.ScrollIntoView(0,false);
   { if ParantNode.ChildCount>0 then      //16072010 Романов
    begin
      ParantNode:=ParantNode.FirstChild;
      vtSchedMessTree.Selected[ParantNode] := True;
      vtSchedMessTree.FocusedNode:=ParantNode;
    end;             }
end;

procedure TfmSingleMessage.cbZoneChange(Sender: TObject);
begin
  SetLanguageList;
  notSaved:=true;
end;

procedure TfmSingleMessage.NAddToListClick(Sender: TObject);
var
  SAfter:string;
begin
  SAfter:='';
  ETemplName.Text:=trim(ETemplName.Text+' ');
  AskForEdit:=false;
  btChange.Click;
  AskForEdit:=true;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ExecSchedMessage';
    Parameters.Refresh;

      id_sched_templ := GetTemplId;
      if id_sched_templ <= 0 then
      begin
        HSMessageDlg('Не выбран шаблон для изменения!!!', mtError, [mbOk], 0);
        exit;
      end;
      Parameters.ParamByName('@id_msg').Value := id_sched_templ;

    Parameters.ParamByName('@Manual').Value:=1;
    ExecProc;
    if Parameters.ParamByName('@return_value').Value<>0 then
    begin
      SAfter:='Ошибка добавления шаблона в очередь!!!';
      HSMessageDlg('Ошибка добавления шаблона в очередь!!!',mtError,[mbOk],0);
    end;
    isModified := True;
    DM.AddToLog(Format(LogITmpAddToList,[ETemplName.Text]),'',SAfter);
    HSMessageDlg('Сообщение добавлено в очередь',mtInformation,[mbOK],0);
  finally
    free;
  end;
  isModified:=true;
  //Close;
end;

procedure TfmSingleMessage.dtpIntervalExit(Sender: TObject);
begin
  if Round(Frac(dtpInterval.Time) * 86400)<61 then
    dtpInterval.Time:=StrToTime('0:01:01');  
end;

procedure TfmSingleMessage.btCancelMessClick(Sender: TObject);
begin
  with TADOStoredProc.Create(nil) do
  try
    id_sched_templ := GetTemplId;
    if not IsTemplInList(id_sched_templ) then
    begin
      HSMessageDlg('Шаблон не стоит в очереди для озвучки!',mtInforMation,[mbOk],0);
      exit;
    end;  
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_CancelSchedMessage';
    Parameters.Refresh;
    Parameters.ParamByName('@id_msg').Value:=GetTemplId;
    Parameters.ParamByName('@Canceled').Value:=1;
    ExecProc;
    isModified:=true;
    DM.AddToLog(Format(LogITmpDelFromList,[ETemplName.Text]),'','');
    HSMessageDlg('Шаблон удален из очереди',mtInformation,[mbOK],0);
  finally
    Free;
  end;
end;

procedure TfmSingleMessage.Timer1Timer(Sender: TObject);
begin
  if notSaved then
  begin
    if btAdd.NumGlyphs=1 then
    begin
      btAdd.NumGlyphs:=3;
      btChange.NumGlyphs:=3;
    end
    else
    begin
      btAdd.NumGlyphs:=1;
      btChange.NumGlyphs:=1;  
    end;
  end;
end;

procedure TfmSingleMessage.rgExecModeClick(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.cbLanguageChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.ETemplNameChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.MsgTextChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpBaseDeltaChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.cbPeriodClick(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpBeginChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpEndChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.clbWeekClick(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.rgExecMode2Click(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpStartChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpTimeChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpEndStartChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.dtpIntervalChange(Sender: TObject);
begin
  notSaved:=true;
end;

procedure TfmSingleMessage.rgSoundTypeClick(Sender: TObject);
begin
  SoundType:=rgSoundType.ItemIndex;
end;

procedure TfmSingleMessage.btMp3OpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edMP3.Text:=OpenDialog1.FileName;  
end;

end.
