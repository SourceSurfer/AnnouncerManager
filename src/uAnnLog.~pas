unit uAnnLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ADODB, Grids, ProfGrid, ExtCtrls, Mask, ToolEdit,
  Buttons, IniFiles,intf_access;

type
  TfrmAnnLog = class(TForm)
    gpFilter: TGroupBox;
    GroupBox1: TGroupBox;
    mpgLog: TProfGrid;
    tmRefresh: TTimer;
    GroupBox2: TGroupBox;
    cbNotUse: TCheckBox;
    deBegin: TDateEdit;
    deEnd: TDateEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    cbxEvent: TComboBox;
    cbTemplOnly: TCheckBox;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    cbxZone: TComboBox;
    Label3: TLabel;
    cbxLang: TComboBox;
    btClear: TBitBtn;
    btFilter: TBitBtn;
    cbToday: TCheckBox;
    Label4: TLabel;
    cbxStatus: TComboBox;
    btOn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure tmRefreshTimer(Sender: TObject);
    procedure mpgLogSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbNotUseClick(Sender: TObject);
    procedure cbTemplOnlyClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure btFilterClick(Sender: TObject);
    procedure cbTodayClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IsTurnedOn:boolean;
    FilterCondition:string;
    CurrRow:integer;
    DtFrm:integer;
    procedure InitGrids;
    procedure FillLog;
    procedure PrepareFilterSettings;
    function BuildFilterCondition(dtfrm:integer):string;
    procedure LoadFilterCondition;
    procedure SaveFilterCondition;
    procedure SetMainFunctionsDisabled;
  end;

var
  F:TIniFile;  

implementation

uses uDM,Utils;

{$R *.dfm}

procedure TfrmAnnLog.SetMainFunctionsDisabled;
var
  E:boolean;
begin
  E:=isAccess('ANN_CancelMsg','kobra_ann');
  btOn.Enabled:=E; 
end; 

procedure TfrmAnnLog.InitGrids;
const
  _captions:array[0..8] of string =('Дата','Запущено','Закончено','Текст','Зона','Язык','Событие','Шаблон','Статус');
var
  i:integer;
begin
  with mpgLog do
  begin
    ColCount:=10;
    HideColumn(0);
    for i:=0 to 8 do
    begin
      Cells[i,0].TextAlignment:=taCenter;
      Cells[i,0].TextLayout:=tlCenter;
      Cols[i].TextAlignment:=taCenter;
      Cols[i].TextLayout:=tlCenter;

      Cells[i,0].Value:=_captions[i];
      case i of
      0,1,2,4,5: Cols[i].Width:=85;
      3: Cols[i].Width:=300;
      6,7,8: Cols[i].Width:=150;
      end;  
    end;
  end;
end;

procedure TfrmAnnLog.FillLog;
var
  i,itm:integer;
  Color:TColor;
  _s:string;
begin
  mpgLog.RowCount:=0;
  with TADOQuery.Create(nil) do
  try
    Connection := DM.con;
    SQL.Text:='SELECT TOP 100 PERCENT dt, dt_beg,dt_end,mtext,zone,lcaption,ecaption,templ,status,id FROM dbo.vANN_MESS_LOG (nolock) '+FilterCondition;
    _s:=SQL.Text;
    Open;


    while not Eof do
    begin
      itm:=mpgLog.RowCount;
      mpgLog.RowCount:=mpgLog.RowCount+1;

      if FieldByName('Status').AsString='Озвучено' then
        Color:=clMoneyGreen
      else
        Color:=clInfoBk;


      for i:=0 to FieldCount-2 do
      begin
        mpgLog.Cells[i,itm].Value:=Fields[i].AsString;
        mpgLog.Cells[i,itm].Color:=Color;
      end;
      mpgLog.HiddenCols[0].Cells[itm].Value:=FieldByName('id').AsString;
      Next;
    end;

  finally
    Free;
  end;
end;

procedure TfrmAnnLog.PrepareFilterSettings;
type
  TFieldFilter = (ffEvent,ffZone,ffLang);

  procedure FillList(Fld:TFieldFilter;List:TStrings);
  const
    SQLSelect = 'select distinct(%s) from %s %s';
  var
    s:string;
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;

      case Fld of
      ffLang: SQL.Text:=Format(SQLSelect,['caption','dbo.ANN_LANGUAGES','']);
      ffZone: SQL.Text:=Format(SQLSelect,['zone','dbo.ANN_ZONES','']);
      ffEvent: SQL.Text:=Format(SQLSelect,['caption','dbo.ANN_EVENTS','where used=1']);
      end;
      s:=SQL.Text;
      Open;

      List.Clear;
      while not Eof do
      begin
        List.Add(Fields[0].AsString);
        Next;
      end;

      List.Insert(0,'Все');
      if Fld = ffEvent then
        List.Add('Сообщения по задержке'); 
    finally
      Free;
    end;
  end;

begin
  FillList(ffEvent,cbxEvent.Items);
  FillList(ffZone,cbxZone.Items);
  FillList(ffLang,cbxLang.Items);
end;

function TfrmAnnLog.BuildFilterCondition(dtfrm:integer):string;

  function SQlDateFormat(D:TDateTime):string;
  var
    s:string;
  begin
    s:=DateToStr(D);
    result:=copy(s,7,4)+copy(s,4,2)+copy(s,1,2);
  end;

begin
  result:='';

  if not cbNotUse.Checked then
  begin
    if (deBegin.Text<>'  .  .    ') and (deEnd.Text<>'  .  .    ') then
    begin
      if (deBegin.Text=deEnd.Text) then
        result:='dbo.fn97DateOf(dt) = '+#39+SQlDateFormat(deBegin.Date)+#39
      else
        result:='dt BETWEEN '+#39+SQlDateFormat(deBegin.Date)+#39+' AND '+#39+SQlDateFormat(deEnd.Date)+#39;
    end
    else
    if (deBegin.Text<>'  .  .    ') and (deEnd.Text='  .  .    ') then
      result:='dt >= '+#39+SQlDateFormat(deBegin.Date)+#39
    else
    if (deBegin.Text='  .  .    ') and (deEnd.Text<>'  .  .    ') then
      result:='dt <= '+#39+SQlDateFormat(deEnd.Date)+#39;
  end;

  if cbTemplOnly.Checked then
    result:=iif(result='','Templ is not NULL',result+' and '+'Templ is not NULL')
  else
  begin
    if cbxEvent.ItemIndex>0 then
    begin
      if cbxEvent.Text = 'Сообщения по задержке' then
        result:=iif(result='','Ecaption = '+#39+cbxEvent.Text+#39, result+' and '+'Ecaption is NULL and id_spp is not NULL ')
      else
        result:=iif(result='','Ecaption = '+#39+cbxEvent.Text+#39, result+' and '+'Ecaption = '+#39+cbxEvent.Text+#39);
    end;
  end;    

  if cbxZone.ItemIndex>0 then
    result:=iif(result='','Zone = '+#39+cbxZone.Text+#39,result+' and '+'Zone = '+#39+cbxZone.Text+#39);

  if cbxLang.ItemIndex>0 then
    result:=iif(result='','Lcaption = '+#39+cbxLang.Text+#39,result+' and '+'Lcaption = '+#39+cbxLang.Text+#39);

  if cbxStatus.ItemIndex>0 then
    result:=iif(result='','Status = '+#39+cbxStatus.Text+#39,result+' and '+'Status = '+#39+cbxStatus.Text+#39);

  if result<>'' then
    result:=' WHERE '+result;

end;

procedure TfrmAnnLog.LoadFilterCondition;
begin
  cbNotUse.Checked:=F.ReadBool('FilterSettings','NotUse',true);
  if not cbNotUse.Checked then
  begin
    cbToday.Checked:=F.ReadBool('FilterSettings','Today',false);
    if not cbToday.Checked then
    begin
      deBegin.Date:=F.ReadDate('FilterSettings','Dt_begin',now);
      deEnd.Date:=F.ReadDate('FilterSettings','Dt_end',now);
    end;  
  end;
  cbTemplOnly.Checked:=F.ReadBool('FilterSettings','TemplOnly',false);
  cbxEvent.ItemIndex:=F.ReadInteger('FilterSettings','Event',0);
  cbxZone.ItemIndex:=F.ReadInteger('FilterSettings','Zone',0);
  cbxLang.ItemIndex:=cbxLang.Items.IndexOf(F.ReadString('FilterSettings','Lang','русский'));    //F.ReadInteger('FilterSettings','Lang',0);
  cbxStatus.ItemIndex:=cbxStatus.Items.IndexOf(F.ReadString('FilterSettings','Status','Все'));
end;

procedure TfrmAnnLog.SaveFilterCondition;
begin
  F.WriteBool('FilterSettings','NotUse',cbNotUse.Checked);
  if not cbNotUse.Checked then
  begin
    F.WriteBool('FilterSettings','Today',cbToday.Checked);
    if not cbToday.Checked then
    begin
      F.WriteDate('FilterSettings','Dt_begin',deBegin.Date);
      F.WriteDate('FilterSettings','Dt_end',deEnd.Date);
    end;
  end;
  F.WriteBool('FilterSettings','TemplOnly',cbTemplOnly.Checked);
  F.WriteInteger('FilterSettings','Event',cbxEvent.ItemIndex);
  F.WriteInteger('FilterSettings','Zone',cbxZone.ItemIndex);
  F.WriteString('FilterSettings','Lang',cbxLang.Text);
  F.WriteString('FilterSettings','Status',cbxStatus.Text);
end;

procedure TfrmAnnLog.FormShow(Sender: TObject);
begin
  SetMainFunctionsDisabled;
  isTurnedOn:=false;
  CurrRow:=1;
  PrepareFilterSettings;
  F:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'AnnManager.ini');
  DtFrm:=F.ReadInteger('Settings','Dtfrm',0);
  LoadFilterCondition;
  FilterCondition:=BuildFilterCondition(DtFrm);
  tmRefreshTimer(Sender);
  if mpgLog.RowCount<2 then exit;
  btOn.Enabled:=mpgLog.Cols[7].Cells[mpgLog.Row].Text='Отменено';
end;

procedure TfrmAnnLog.tmRefreshTimer(Sender: TObject);
begin
  InitGrids;
  FillLog;
  if mpgLog.RowCount>1 then
    mpgLog.Row:=CurrRow; 
end;

procedure TfrmAnnLog.mpgLogSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if mpgLog.RowCount<2 then exit; 
  CurrRow:=mpgLog.Row;
  btOn.Enabled:=mpgLog.Cols[7].Cells[CurrRow].Text='Отменено';
end;


procedure TfrmAnnLog.cbNotUseClick(Sender: TObject);
begin
  cbToday.Enabled:=not cbNotUse.Checked;
  deBegin.Enabled:=(not cbNotUse.Checked) and (not cbToday.Checked);
  deEnd.Enabled:=(not cbNotUse.Checked) and (not cbToday.Checked);
end;

procedure TfrmAnnLog.cbTemplOnlyClick(Sender: TObject);
begin
  cbxEvent.Enabled:=not cbTemplOnly.Checked;

end;

procedure TfrmAnnLog.btClearClick(Sender: TObject);
begin
  cbNotUse.Checked:=true;
  cbToday.Checked:=false; 
  deBegin.Clear;
  deEnd.Clear;
  cbTemplOnly.Checked:=false;
  cbxEvent.ItemIndex:=0;
  cbxLang.ItemIndex:=0;
  cbxZone.ItemIndex:=0;
  cbxStatus.ItemIndex:=0; 
  FilterCondition:='';
  FillLog;
end;

procedure TfrmAnnLog.btFilterClick(Sender: TObject);
begin
  FilterCondition:=BuildFilterCondition(DtFrm);
  FillLog;
end;

procedure TfrmAnnLog.cbTodayClick(Sender: TObject);
begin
  deBegin.Enabled:=cbToday.Checked;
  deEnd.Enabled:=cbToday.Checked;    
  if cbToday.Checked then
  begin
    deBegin.Date:=now;
    deEnd.Date:=now;
  end;  
end;

procedure TfrmAnnLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFilterCondition;
  F.Free;
end;

procedure TfrmAnnLog.btOnClick(Sender: TObject);
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con; 
    ProcedureName:='dbo.spANN_RunStopMess';
    Parameters.Refresh;
    Parameters.ParamByName('@id_msg').Value:=mpgLog.HiddenCols[0].Cells[mpgLog.Row].Value;
    Parameters.ParamByName('@st').Value:=0;
    ExecProc;
    FillLog;
    isTurnedOn:=true;
    DM.AddToLog('Включение в очередь отмененного сообщения '+mpgLog.Cols[1].Cells[mpgLog.Row].Text,'',''); 
  finally
    Free;
  end;             
end;

end.
