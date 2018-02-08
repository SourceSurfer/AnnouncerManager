unit uLanguages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ADODB, StdCtrls, Grids, ProfGrid, Buttons,HSDialogs, ExtCtrls,
  ImgList,uGateExit;

const
  LogLangEdit = 'Редактирование %s языка';
  LogLangDel = 'Удаление %s языка';
  LogLangVoice = 'Установка голоса %s для %s языка';

type
  TfrmLanguages = class(TForm)
    GroupBox2: TGroupBox;
    mpgLang: TProfGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edLang: TEdit;
    edCaption: TEdit;
    btSave: TBitBtn;
    btDelete: TBitBtn;
    btClear: TBitBtn;
    imgZone: TImageList;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    cbxVoice: TComboBox;
    btSetVoice: TBitBtn;
    GroupBox5: TGroupBox;
    GroupBox3: TGroupBox;
    Panel1: TPanel;
    btSelectALL: TSpeedButton;
    btDeselectAll: TSpeedButton;
    mpgZones: TProfGrid;
    GroupBox6: TGroupBox;
    btNSI: TBitBtn;
    Timer1: TTimer;
    btGateExit: TBitBtn;
    procedure btClearClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mpgLangSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btSelectALLClick(Sender: TObject);
    procedure mpgZonesDblClick(Sender: TObject);
    procedure btSetVoiceClick(Sender: TObject);
    procedure btNSIClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure edLangChange(Sender: TObject);
    procedure edCaptionChange(Sender: TObject);
    procedure btGateExitClick(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    function LangGenitive(SLang:string):string;
    procedure SetMainFunctionsDisabled;
    procedure SetNotSaved(AValue:boolean);
  public
    { Public declarations }
    procedure InitGrid;
    procedure FillLang;
    procedure InitZones;
    procedure FillZones(Id:integer);
    procedure FillVoices;
    property NotSaved:Boolean read fNotSaved write SetNotSaved;
  end;


implementation

uses uDM,intf_access,Intf_AnnApLib;

{$R *.dfm}

function TfrmLanguages.LangGenitive(SLang:string):string;
begin
  result:=SLang;
  delete(result,length(result)-1,2);
  result:=result+'ого';
end;

procedure TfrmLanguages.SetMainFunctionsDisabled;
var
  E:boolean;
begin
  E:=IsAccess('ANN_EditLanguages','kobra_ann');
  btSave.Enabled:=E;
  btDelete.Enabled:=E;
  btClear.Enabled:=E;
  btSetVoice.Enabled:=E;
  cbxVoice.Enabled:=E;
  btSelectAll.Enabled:=E;
  btDeselectAll.Enabled:=E;
  mpgZones.Enabled:=E;
  btNSI.Enabled:=E;
end;

procedure TfrmLanguages.SetNotSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
  begin
    Caption:='Справочник языков ***';
  end
  else
  begin
    Caption:='Справочник языков';
    btSave.Font.Color:=clMenuHighlight;
    btSave.Font.Style:=[];   
  end;
end; 

procedure TfrmLanguages.InitGrid;
const
  _captions:array[0..1] of string =('Сокращение','Название');
var
  i:integer;
begin
  with mpgLang do
  begin
    ColCount:=3;
    HideColumn(0);
    for i:=0 to VisibleColCount-1 do
    begin
      Cells[i,0].TextAlignment:=taCenter;
      Cells[i,0].TextLayout:=tlCenter;
      Cols[i].TextAlignment:=taCenter;
      Cols[i].TextLayout:=tlCenter;

      Cells[i,0].Value:=_captions[i];
    end;
    Cols[0].Width:=85;
    Cols[1].Width:=120;  
  end;
end;

procedure TfrmLanguages.FillLang;
var
  itm:integer;
begin
  with mpgLang do
  begin
    RowCount:=1;
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:='select id,lang,caption from dbo.ANN_Languages order by Caption';
      Open;
      while not Eof do
      begin
        itm:=RowCount;
        RowCount:=RowCount+1;

        HiddenCols[0].Cells[itm].Value:=FieldByName('ID').AsString;
        Cols[0].Cells[itm].Value:=FieldByName('Lang').AsString;
        Cols[1].Cells[itm].Value:=FieldByName('Caption').AsString;

        Next;
      end;
    finally
      Free;
    end;
  end;
end;


procedure TfrmLanguages.InitZones;
var
  i:integer;
begin
  with mpgZones do
  begin
    ColCount:=4;
    HideColumn(0);
    HideColumn(0);
    for i:=0 to VisibleColCount-1 do
    begin
      Cols[i].TextAlignment:=taCenter;
      Cols[i].TextLayout:=tlCenter;
    end;
    Cols[0].Width:=35;
    Cols[1].Width:=125;  
  end;
end;

procedure TfrmLanguages.FillZones(Id:integer);
var
  itm,i:integer;
  bmSelect:TBitMap;
begin
  with mpgZones do
  begin
    for i:=0 to RowCount-1 do
    begin
      if Assigned(Cells[0,i].Graphic) then
        Cells[0,i].Graphic:=nil;
    end;
    RowCount:=1;
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:='select id_lang,id_zone,used,zone from vANN_LangZones where id_lang = '+IntToStr(Id)+' order by id_lang,zone ';
      Open;
      while not Eof do
      begin
        if RowCount=1 then
          itm:=0
        else
          itm:=RowCount-1;
        RowCount:=RowCount+1;
        HiddenCols[0].Cells[itm].Value:=FieldByName('id_lang').AsString;
        HiddenCols[1].Cells[itm].Value:=FieldByName('id_zone').AsString;
        if FieldByName('used').AsInteger>0 then
        begin
          bmSelect:=TBitmap.Create;
          imgZone.GetBitmap(0,bmSelect);
          Cols[0].Cells[itm].Graphic:=bmSelect;  
        end;
        Cols[1].Cells[itm].Value:=FieldByName('zone').AsString; 
        Next;
      end;
      RowCount:=RowCount-1;
    finally
      Free;
    end;
  end;
end;

procedure TfrmLanguages.FillVoices;
begin
  cbxVoice.Clear;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:='select distinct(name) from dbo.ANN_VOICES_INSTALLED order by name';
    Open;
    while not Eof do
    begin
      cbxVoice.Items.Add(FieldByName('name').AsString);
      Next;
    end;
  finally
    Free;
  end;
  cbxVoice.ItemIndex:=-1;
end;

procedure TfrmLanguages.btClearClick(Sender: TObject);
begin
  edLang.Clear;
  edCaption.Clear;
  cbxVoice.ItemIndex:=-1;
  NotSaved:=true;
end;

procedure TfrmLanguages.btSaveClick(Sender: TObject);
var
  T:integer;
  SAct,SBefore,SAfter:string;
  SLang:string;
begin
  SAfter:='Язык удален';
  SBefore:='';
  SLang:=LangGenitive(edCaption.Text);
  T:=(Sender as TBitBtn).Tag;
  if T=0 then
  begin
    if HSMessageDlg('Удалить выбранный язык?',mtConfirmation,[mbYes,mbNo],0)= mrNo then exit;
    SAct:=Format(LogLangDel,[SLang]);
  end
  else
  begin
    SAct:=Format(LogLangEdit,[SLang]);
    SBefore:='Сокращение: '+edLang.Text+' Название: '+edCaption.Text;
  end;
  if ((edLang.Text ='RUS') or (edLang.Text='ENG')) and (T=0) then
    HSMessageDlg('Русский и английский языки не могут быть удалены из справочника!',mtError,[mbOk],0)
  else  
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyLanguages';
    Parameters.Refresh;
    Parameters.ParamByName('@Lang').Value:=edLang.Text;
    Parameters.ParamByName('@Caption').Value:=edCaption.Text;
    Parameters.ParamByName('@action').Value:=T;
    ExecProc;
    DM.AddToLog(SAct,SBefore,SAfter);
    btClear.Click;
    FillLang;
    NotSaved:=false;
  finally
    Free;
  end;    
end;

procedure TfrmLanguages.FormShow(Sender: TObject);
var
  B:boolean;
begin
  SetMainFunctionsDisabled;
  InitGrid;
  FillLang;
  InitZones;
  FillVoices;
  B:=true;
  mpgLangSelectCell(Sender,mpgLang.Col,mpgLang.Row,B);
  NotSaved:=false;
end;

procedure TfrmLanguages.mpgLangSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);

  function GetLangVoice:string;
  var
    s:string;
  begin
    s:=mpgLang.HiddenCols[0].Cells[ARow].Text;
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:='select name from dbo.ANN_VOICES where id_lang='+s;
      Open;
      result:=FieldByName('name').AsString; 
    finally
      Free;
    end;
  end;

begin
  edLang.Text:=mpgLang.Cols[0].Cells[ARow].Text;
  edCaption.Text:=mpgLang.Cols[1].Cells[ARow].Text;
  FillZones(mpgLang.HiddenCols[0].Cells[ARow].Value);
  cbxVoice.ItemIndex:=cbxVoice.Items.IndexOf(GetLangVoice);
  NotSaved:=false;
end;

procedure TfrmLanguages.btSelectALLClick(Sender: TObject);
const
  error_text:array[0..1] of string = ('Ошибка удаления языка из зон!','Ошибка добавления языка в зоны!');
  log_text:array[0..1] of string = ('Удаление %s языка из зон','Добавление %s языка в зоны');
var
  T:integer;
  B:boolean;
  SAfter,SLang,SLog:string;
begin
  T:=(Sender as TSpeedButton).Tag;
  SAfter:='';
  SLang:=LangGenitive(edCaption.Text);  
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyLangRules';
    Parameters.Refresh;
    Parameters.ParamByName('@action').Value:=T;
    Parameters.ParamByName('@id_zone').Value:=NULL;
    Parameters.ParamByName('@id_lang').Value:=mpgLang.HiddenCols[0].Cells[mpgLang.Row].Value;
    ExecProc;
    if Parameters.ParamByName('@return_value').Value=-1 then
    begin
      SAfter:=error_text[T];
      HSMessageDlg(error_text[T],mtError,[mbOk],0);
      exit;
    end;
    SLog:=Format(log_text[T],[SLang]);
    DM.AddToLog(SLog,'',SAfter);
    B:=true;
    mpgLangSelectCell(Sender,mpgLang.Col,mpgLang.Row,B);
  finally
    Free;
  end;
end;

procedure TfrmLanguages.mpgZonesDblClick(Sender: TObject);
const
  error_text:array[0..1] of string = ('Ошибка удаления языка из зоны!','Ошибка добавления языка для зоны!');
var
  T:integer;
  B:boolean;
begin
  if Assigned(mpgZones.Cells[0,mpgZones.Row].Graphic) then
    T:=0
  else
    T:=1;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyLangRules';
    Parameters.Refresh;
    Parameters.ParamByName('@action').Value:=T;
    Parameters.ParamByName('@id_zone').Value:=mpgZones.HiddenCols[1].Cells[mpgZones.Row].Value;
    Parameters.ParamByName('@id_lang').Value:=mpgLang.HiddenCols[0].Cells[mpgLang.Row].Value;
    ExecProc;
    if Parameters.ParamByName('@return_value').Value=-1 then
    begin
      HSMessageDlg(error_text[T],mtError,[mbOk],0);
      exit;
    end;
    B:=true;
    mpgLangSelectCell(Sender,mpgLang.Col,mpgLang.Row,B);
    //FillZones(mpgLang.HiddenCols[0].Cells[0].Value);
  finally
    Free;
  end;
end;

procedure TfrmLanguages.btSetVoiceClick(Sender: TObject);
var
  SLang:string;
begin
  SLang:=LangGenitive(edCaption.Text);
  if cbxVoice.ItemIndex=-1 then
  begin
    HSMessageDlg('Необходимо выбрать голос из списка!',mtError,[mbOk],0);
    cbxVoice.SetFocus;
    exit;
  end;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    Procedurename:='dbo.spANN_SetLangVoice';
    Parameters.Refresh;
    Parameters.ParamByName('@id_lang').Value:=mpgLang.HiddenCols[0].Cells[mpglang.Row].Value;
    Parameters.ParamByName('@voice').Value:=cbxVoice.Text;
    ExecProc;
    DM.AddToLog(Format(LogLangVoice,[cbxVoice.Text,SLang]),'','');
    HSMessageDlg('Голос установлен',mtInformation,[mbOk],0);
  finally
    Free;
  end;
end;

procedure TfrmLanguages.btNSIClick(Sender: TObject);
const
  ConStr1='Provider=SQLOLEDB.1;Password=k@78p$;Persist Security Info=True;Initial Catalog=RDS;Data Source=sql052b\srvr052b;User ID=kobra_ann';
var
  ConStr,Cop:string;
begin
  ConStr:=DM.con.ConnectionString;
  Cop:=DM.COP; 
  RunAnnApLib(Application.Handle,PChar(ConStr),PChar(Cop));
end;

procedure TfrmLanguages.Timer1Timer(Sender: TObject);
begin
  if NotSaved then
  begin
    if btSave.Font.Color=clRed then
    begin
      btSave.Font.Color:=clMenuHighlight;
      btSave.Font.Style:=[];
    end
    else
    begin
      btSave.Font.Color:=clRed;
      btSave.Font.Style:=[fsBold];    
    end;
  end;
end;

procedure TfrmLanguages.edLangChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmLanguages.edCaptionChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmLanguages.btGateExitClick(Sender: TObject);
begin
  with TfrmGateExit.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;   
end;

end.
