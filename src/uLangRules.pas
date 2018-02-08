unit uLangRules;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ProfGrid, StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit,
  RzEdit, RzSpnEdt, ImgList, ComCtrls, ToolWin,IniFiles;

const
  LogLangOrderAdd='Добавление шаблона %s групп рейсов для очереди языковых сообщений';
  LogLangOrderEdit='Редактирование шаблона %s групп рейсов для очереди языковых сообщений';
  LogLangOrderDelete='Удаление шаблона %s групп рейсов для очереди языковых сообщений';
  LogLangPriorEdit='Редактирование приоритета %s языка для шаблона %s';
  LogLangPriorDelete='Удаление %s языка из языковой очереди для шаблона %s';

type
  TfrmLangRules = class(TForm)
    gbReisFilter: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    rgShed: TRadioGroup;
    deBegin: TDateEdit;
    deEnd: TDateEdit;
    rgDirect: TRadioGroup;
    gbReisList: TGroupBox;
    Panel2: TPanel;
    btSave: TBitBtn;
    btDelete: TBitBtn;
    btClear: TBitBtn;
    pgTemplList: TProfGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    cbxLang: TComboBox;
    Label7: TLabel;
    RsSpnOrder: TRzSpinEdit;
    Label11: TLabel;
    btnAddLang: TBitBtn;
    btnDelLang: TBitBtn;
    mpgLang: TProfGrid;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    lbCompanyList: TListBox;
    sbAirCompanyAdd: TSpeedButton;
    sbAirCompanyDel: TSpeedButton;
    Label8: TLabel;
    lbAirList: TListBox;
    sbAirportAdd: TSpeedButton;
    sbAirportDel: TSpeedButton;
    Label6: TLabel;
    lbTypeVSList: TListBox;
    sbTypeVSAdd: TSpeedButton;
    sbTypeVSDel: TSpeedButton;
    Label4: TLabel;
    eComments: TEdit;
    ilist: TImageList;
    ToolBar1: TToolBar;
    tbUp: TToolButton;
    tbDown: TToolButton;
    Timer1: TTimer;
    procedure sbAirCompanyAddClick(Sender: TObject);
    procedure sbAirportAddClick(Sender: TObject);
    procedure sbTypeVSAddClick(Sender: TObject);
    procedure sbAirCompanyDelClick(Sender: TObject);
    procedure sbAirportDelClick(Sender: TObject);
    procedure sbTypeVSDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgTemplListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure deBeginExit(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btnDelLangClick(Sender: TObject);
    procedure btnAddLangClick(Sender: TObject);
    procedure mpgLangSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbxLangChange(Sender: TObject);
    procedure tbUpClick(Sender: TObject);
    procedure tbDownClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure eCommentsChange(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    procedure SetSaved(AValue:boolean);
  public
    { Public declarations }
    IdTempl:integer;
    DtFrm:integer;
    procedure InitMpgLang;
    procedure InitpgTemplList;
    procedure FillLanguages;
    procedure SelectTemplateParams;
    procedure SetMainFunctionsEnabled;
    procedure FillApAkTvs;
    function GetTemplNameById(Id:integer):string;
    function GetLangGen(Id:integer):string;
    property NotSaved : boolean read fNotSaved write SetSaved;
  end;

implementation

uses AirportList,uDM,intf_access,HSDialogs,DB,ADODB;

{$R *.dfm}


procedure TfrmLangRules.SetSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
    Caption:='Приоритет языков сообщений для групп рейсов ***'
  else
  begin
    Caption:='Приоритет языков сообщений для групп рейсов';
    btSave.Font.Color:=clMenuHighlight;
    btSave.Font.Style:=[];  
  end;
end;

function TfrmLangRules.GetTemplNameById(Id:integer):string;
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:='select COM from dbo.ANN_Lang_Rules_Group where id='+IntToStr(Id);
    Open;
    result:=Fields[0].AsString;
  finally
    Free;
  end;  
end;

function TfrmLangRules.GetLangGen(Id:integer):string;
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:='select caption from dbo.ANN_LANGUAGES where id='+IntToStr(Id);
    Open;
    result:=Fields[0].AsString;
    System.Delete(result,length(result)-1,2);
    result:=result+'ого';
  finally
    Free;
  end;
end;

procedure TfrmLangRules.SelectTemplateParams;
const
  SQLText = 'select ID,DST,DFN,COM,COP,DK from dbo.ANN_Lang_Rules_Group where id=1 or (direct = %s and id_zone = %s and DST<=%s and DFN>=%s)';
  SQLText1 ='select ID,DST,DFN,COM,COP,DK from dbo.ANN_Lang_Rules_Group where id=1 or (direct = %s and id_zone = %s and DST>=%s and DFN<=%s)';
var
  itm,i,old:integer;
  bt:TBitMap;
  
  function SQLDateFormat(D:TDateTime):string;
  var
    s:string;
  begin
    s:=DateToStr(D);
    if DtFrm=0 then
      result:=#39+copy(S,7,4)+'-'+copy(S,4,2)+'-'+copy(S,1,2)+#39
    else
      result:=#39+copy(S,7,4)+'-'+copy(S,1,2)+'-'+copy(S,4,2)+#39;
  end;


begin
  if IdTempl<>0 then
    old:=pgTemplList.Row
  else
    old:=1;  
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    if DtFrm=0 then
      SQL.Text:=Format(SQLText,[IntToStr(rgDirect.ItemIndex),IntToStr(rgShed.ItemIndex),SQLDateFormat(deBegin.Date),SQLDateFormat(deEnd.Date)])
    else
      SQL.Text:=Format(SQLText1,[IntToStr(rgDirect.ItemIndex),IntToStr(rgShed.ItemIndex),SQLDateFormat(deBegin.Date),SQLDateFormat(deEnd.Date)]);

    Open;
    pgTemplList.RowCount:=0;
    bt:=TBitMap.Create;
    while not Eof do
    begin
      itm:=pgTemplList.RowCount;
      pgTemplList.RowCount:=pgTemplList.RowCount+1;
      if FieldByName('Id').AsInteger=1 then
      begin
        ilist.GetBitmap(1,bt);
        for i:=0 to 5 do
          pgTemplList.Cells[i,itm].Color:=clTeal;
      end
      else
        ilist.GetBitmap(0,bt);
      pgTemplList.Cells[0,itm].Graphic:=bt;
      pgTemplList.Cells[1,itm].Text:=FieldByName('ID').AsString;
      pgTemplList.Cells[2,itm].Text:=FieldByName('DST').AsString+' - '+FieldByName('DFN').AsString;
      pgTemplList.Cells[3,itm].Text:=FieldByName('COM').AsString;
      pgTemplList.Cells[4,itm].Text:=FieldByName('COP').AsString;
      pgTemplList.Cells[5,itm].Text:=FieldByName('DK').AsString;
      Next;
    end;
  finally
    Free;
  end;
  if old>=pgTemplList.RowCount then old:=1; 
  pgTemplList.Row:=old;
  IdTempl:=pgTemplList.Cols[1].Cells[old].Value; 
end; 

procedure TfrmLangRules.InitpgTemplList;
const
  _widths:array[0..5] of integer = (20,50,160,150,100,70);
  _captions:array[0..5] of string = ('','Номер','Период','Комментарий','Добавил','Дата');
var
  i:integer;
begin
  pgTemplList.ColCount:=6;
  for i:=0 to 5 do
  begin
    pgTemplList.Cells[i,0].Text:=_captions[i];
    pgTemplList.Cells[i,0].TextAlignment:=taCenter;
    pgTemplList.Cols[i].ReadOnly:=true;
    pgTemplList.Cols[i].Width:=_widths[i];    
  end;
end;

procedure TfrmLangRules.SetMainFunctionsEnabled;
var
  E:boolean;
begin
  E:=intf_access.IsAccess('ANN_LangOrders','kobra_ann');
  //E:=true;
  btSave.Enabled:=E;
  btDelete.Enabled:=E;
  btClear.Enabled:=E;
  GroupBox4.Enabled:=E; 
  btnAddLang.Enabled:=E;
  btnDelLang.Enabled:=E;
  tbUp.Enabled:=E;
  tbDown.Enabled:=E;
end;

procedure TfrmLangRules.InitMpgLang;
begin
  with mpgLang do
  begin
    ColCount:=3;
    HideColumn(0);
    Cells[0,0].Text:='Порядок';
    Cells[1,0].Text:='Язык';
    Cells[0,0].TextAlignment:=taCenter;
    Cells[1,0].TextAlignment:=taCenter;
    Cols[0].TextAlignment:=taCenter;
    Cols[1].TextAlignment:=taCenter;
    Cols[0].ReadOnly:=true;
    Cols[1].ReadOnly:=true;
    Cols[0].Width:=70;
    Cols[1].Width:=120;  
    RowCount:=0;  
  end;
end;

procedure TfrmLangRules.FillLanguages;
const
  SQLTextL = 'select AL.caption, LO.ID_LANG,LO.LANG_ORDER from 	dbo.ANN_LANG_ORDERS LO inner join dbo.ANN_LANGUAGES AL on LO.ID_LANG = AL.id where (LO.ID_TEMPL = %s) and (LO.ID_TEMPL<>1) order by LO.LANG_ORDER';

var
  itm:integer;

  procedure SubFillLanguages;
  const
    SQLText='select AL.caption from  dbo.ANN_LANGUAGES AL  order by AL.caption';
  begin
    cbxLang.Items.Clear;
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[IntToStr(rgShed.ItemIndex+1)]);
      Open;
      while not Eof do
      begin
        cbxLang.Items.Add(FieldByName('caption').AsString);
        Next;
      end;
    finally
      Free;
    end;
  end;

  function GetMaxOrder:integer;
  const
    SQLText='select COUNT(*)+1 from dbo.ANN_LANG_ORDERS where ID_Templ=%s';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[IntToStr(IdTempl)]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

begin
  SubFillLanguages;
  RsSpnOrder.IntValue:=GetMaxOrder;
  RsSpnOrder.Max:=RsSpnOrder.IntValue;
  
  with TADOQuery.Create(nil) do
  try
    mpgLang.RowCount:=1;
    Connection:=DM.con;
    SQL.Text:=Format(SQLTextL,[IntToStr(IdTempl)]);
    Open;
    while not Eof do
    begin
      itm:=mpgLang.RowCount;
      mpgLang.RowCount:=mpgLang.RowCount+1;
      mpgLang.HiddenCols[0].Cells[itm].Value:=FieldByName('id_lang').Value;
      mpgLang.Cells[0,itm].Text:=FieldByName('Lang_Order').AsString;
      mpgLang.Cells[1,itm].Text:=FieldByName('caption').AsString;
      Next;
    end;
  finally
    Free;
  end; 
end;

procedure TfrmLangRules.sbAirCompanyAddClick(Sender: TObject);
var i : integer;
    pnt : TPoint;
    str : string;
    SP : TADOStoredProc;
begin
    Cursor:=crHourGlass;
    Application.ProcessMessages;
    pnt.X := 0;
    pnt.Y := 0;
    pnt := (Sender as TSpeedButton).ClientToScreen(pnt);

    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_GetAirCompanyList';
        Parameters.Refresh;

        if TfmAirportList.MyShowModal1(lbCompanyList.Items, Rect(pnt.X,
                                                            pnt.Y,
                                                            pnt.X + (Sender as TSpeedButton).Width,
                                                            pnt.Y + (Sender as TSpeedButton).Height),
                                                            SP,
                                                            nil,
                                                            'Список авиакомпаний') > 0 then  FillApAkTvs;
                                                            //SelectTemplateParams;
    finally
        Free;

    end;
    Cursor:=crDefault;
    Application.ProcessMessages;
    for i:=0 to lbCompanyList.Items.Count-1 do
    begin
      str:=lbCompanyList.Items.Strings[i];
      if pos('=',str)>0 then System.Delete(str,1,pos('=',str));
      lbCompanyList.Items.Strings[i]:=str;
    end;
    lbCompanyList.SetFocus;
    NotSaved:=true;
end;

procedure TfrmLangRules.sbAirportAddClick(Sender: TObject);
var pnt : TPoint;
    str : string;
    SP : TADOStoredProc;
    i:integer;
begin
    Cursor:=crHourGlass;
    Application.ProcessMessages;
    pnt.X := 0;
    pnt.Y := 0;
    pnt := (Sender as TSpeedButton).ClientToScreen(pnt);

    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_GetApListGR';
        Parameters.Refresh;
        // Parameters.ParamByName('@id_lang').Value := 1;

        if TfmAirportList.MyShowModal1(lbAirList.Items, Rect(pnt.X,
                                                            pnt.Y,
                                                            pnt.X + (Sender as TSpeedButton).Width,
                                                            pnt.Y + (Sender as TSpeedButton).Height),
                                                            SP,
                                                            nil,
                                                            'Список аэропортов') > 0 then FillApAkTvs;//SelectTemplateParams;
    finally
        Free;

    end;
    Cursor:=crDefault;
    Application.ProcessMessages;
    for i:=0 to lbAirList.Items.Count-1 do
    begin
      str:=lbAirList.Items.Strings[i];
      if pos('=',str)>0 then System.Delete(str,1,pos('=',str));
      lbAirList.Items.Strings[i]:=str;
    end;

    lbAirList.SetFocus;
    NotSaved:=true;
end;

procedure TfrmLangRules.sbTypeVSAddClick(Sender: TObject);
var i : integer;
    pnt : TPoint;
    str : string;
    SP : TADOStoredProc;
begin
    Cursor:=crHourGlass;
    Application.ProcessMessages;
    pnt.X := 0;
    pnt.Y := 0;
    pnt := (Sender as TSpeedButton).ClientToScreen(pnt);

    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_GetTypeVSList';
        Parameters.Refresh;

        if TfmAirportList.MyShowModal1(lbTypeVSList.Items, Rect(pnt.X,
                                                                pnt.Y,
                                                                pnt.X + (Sender as TSpeedButton).Width,
                                                                pnt.Y + (Sender as TSpeedButton).Height),
                                                                SP,
                                                                nil,
                                                                'Список типов ВС') > 0 then FillApAkTvs;//SelectTemplateParams;
    finally
        Free;

    end;
    Cursor:=crDefault;
    Application.ProcessMessages;
    for i:=0 to lbTypeVSList.Items.Count-1 do
    begin
      str:=lbTypeVSList.Items.Strings[i];
      if pos('=',str)>0 then System.Delete(str,1,pos('=',str));
      if pos('-',str)>0 then System.Delete(str,pos('-',str),1);
      lbTypeVSList.Items.Strings[i]:=str;
    end;

    lbTypeVSList.SetFocus;
    NotSaved:=true;
end;

procedure TfrmLangRules.sbAirCompanyDelClick(Sender: TObject);
begin
  lbCompanyList.DeleteSelected;
  NotSaved:=true;
end;

procedure TfrmLangRules.sbAirportDelClick(Sender: TObject);
begin
  lbAirList.DeleteSelected;
  NotSaved:=true;
end;

procedure TfrmLangRules.sbTypeVSDelClick(Sender: TObject);
begin
  lbTypeVSList.DeleteSelected;
  NotSaved:=true;
end;

procedure TfrmLangRules.FormShow(Sender: TObject);
  function DefineDateFormat:integer;
  var
    F:TiniFile;
  begin
    F:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'AnnManager.ini');
    result:=F.ReadInteger('Settings','DtFrm',0);
    F.Free; 
  end;

begin
  IDTempl:=0;
  DtFrm:=DefineDateFormat;
  SetMainFunctionsEnabled;
  InitpgTemplList;
  InitMpgLang;
  SelectTemplateParams;
  if deBegin.Date < Now - 10000 then deBegin.Date := Now;
  if deEnd.Date < deBegin.Date then deEnd.Date := deBegin.Date;
  NotSaved:=false;
  cbxLang.Enabled:=false;
  RsSpnOrder.Enabled:=false;
  btnAddLang.Enabled:=false;
  btnDelLang.Enabled:=false;
  mpgLang.Enabled:=false;
  tbUp.Enabled:=false;
  tbDown.Enabled:=false;
end;

procedure TfrmLangRules.pgTemplListSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  E:boolean;

  procedure FillFilterGroupFields;
  const
    SQLText='select Value from dbo.ANN_LANG_RULES_PARAMS where ID_Templ=%s and [Param]='+#39+'%s'+#39;
    SQL1Text='select DST,DFN from dbo.ANN_LANG_RULES_Group where ID=%s';
  begin
    lbCompanyList.Items.Clear;
    lbAirList.Items.Clear;
    lbTypeVSList.Items.Clear;
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;

      SQL.Text:=Format(SQLText,[IntToStr(IdTempl),'Ak']);
      Open;
      while not Eof do
      begin
        lbCompanyList.Items.Add(Fields[0].AsString);
        Next;
      end;
      Close;

      SQL.Text:=Format(SQLText,[IntToStr(IdTempl),'Ap']);
      Open;
      while not Eof do
      begin
        lbAirList.Items.Add(Fields[0].AsString);
        Next;
      end;
      Close;

      SQL.Text:=Format(SQLText,[IntToStr(IdTempl),'Tvs']);
      Open;
      while not Eof do
      begin
        lbTypeVSList.Items.Add(Fields[0].AsString);
        Next;
      end;
      Close;


      eComments.Text:=pgTemplList.Cols[3].Cells[ARow].Text;
      with TADOQuery.Create(nil) do
      try
        Connection:=DM.con;
        SQL.Text:=Format(SQL1Text,[IntToStr(IdTempl)]);
        Open;
        deBegin.Date:=FieldByName('DST').AsDateTime;
        deEnd.Date:=FieldByName('DFN').AsDateTime;
      finally
        Free;
      end;
    finally
      Free;
    end;
  end;

begin
  IdTempl:=pgTemplList.Cols[1].Cells[ARow].Value;

  E:=IdTempl<>1;

  cbxLang.Enabled:=E;
  RsSpnOrder.Enabled:=E;
  btnAddLang.Enabled:=E;
  btnDelLang.Enabled:=E;
  mpgLang.Enabled:=E;
  tbUp.Enabled:=E;
  tbDown.Enabled:=E;
  
  if IdTempl=1 then
  begin
    lbCompanyList.Items.Clear;
    lbAirList.Items.Clear;
    lbTypeVSList.Items.Clear;
    eComments.Clear; 
    exit;
  end;
  FillFilterGroupFields;

  FillLanguages;
  NotSaved:=false;
end;

procedure TfrmLangRules.deBeginExit(Sender: TObject);
begin
  if idTempl = 1 then
  SelectTemplateParams;
end;

procedure TfrmLangRules.btClearClick(Sender: TObject);
begin
  lbCompanyList.Clear;
  lbAirList.Clear;
  lbTypeVSList.Clear;
  eComments.Clear;
  deBegin.Clear;
  deEnd.Clear;
  SelectTemplateParams;
end;

procedure TfrmLangRules.btDeleteClick(Sender: TObject);
var
  s:string;
begin
  if IdTempl=1 then exit;
  if HSMessageDlg('Удалить выбранный шаблон?',mtWarning,[mbYes,mbNo],0)=mrNo then exit;
  with TADOStoredProc.Create(nil) do
  try
    s:=GetTemplNameById(IdTempl);
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_Lang_Rules_Delete';
    Parameters.Refresh;
    Parameters.ParamByName('@ID').Value:=IdTempl;
    ExecProc;
    HSMessageDlg('Шаблон удален',mtInformation,[mbOk],0);
    DM.AddToLog(Format(LogLangOrderDelete,[s]),'',''); 
    IdTempl:=0;
    SelectTemplateParams;
  finally
    Free;
  end;      
end;

  procedure TfrmLangRules.FillApAkTvs;
  var
    i:integer;
    s:string;
  begin
    with TADOStoredProc.Create(nil) do
    try
      Connection:=DM.con;
      ProcedureName:='dbo.spANN_LANG_RULES_AkApTvs';
      Parameters.Refresh;
      Parameters.ParamByName('@ID_TEMPL').Value:=IdTempl;
      Parameters.ParamByName('@Action').Value:=0;
      ExecProc;
      for i:=0 to lbCompanyList.Items.Count-1 do
      begin
        Parameters.Refresh;
        Parameters.ParamByName('@ID_TEMPL').Value:=IdTempl;
        Parameters.ParamByName('@Param').Value:='Ak';
        s:=lbCompanyList.Items.Strings[i];
        if pos('=',s)>0 then System.Delete(s,1,pos('=',s));
        Parameters.ParamByName('@Value').Value:=s;
        Parameters.ParamByName('@Action').Value:=1;
        ExecProc;
      end;
      for i:=0 to lbAirList.Items.Count-1 do
      begin
        Parameters.Refresh;
        Parameters.ParamByName('@ID_TEMPL').Value:=IdTempl;
        Parameters.ParamByName('@Param').Value:='Ap';
        s:=lbAirList.Items.Strings[i];
        if pos('=',s)>0 then System.Delete(s,1,pos('=',s));
        Parameters.ParamByName('@Value').Value:=s;
        Parameters.ParamByName('@Action').Value:=1;
        ExecProc;
      end;
      for i:=0 to lbTypeVSList.Items.Count-1 do
      begin
        Parameters.Refresh;
        Parameters.ParamByName('@ID_TEMPL').Value:=IdTempl;
        Parameters.ParamByName('@Param').Value:='Tvs';
        s:=lbTypeVSList.Items.Strings[i];
        if pos('=',s)>0 then System.Delete(s,1,pos('=',s));
        if pos('-',s)>0 then System.Delete(s,pos('-',s),1);
        Parameters.ParamByName('@Value').Value:=s;
        Parameters.ParamByName('@Action').Value:=1;
        ExecProc;
      end;
    finally
      Free;
    end;
  end;


procedure TfrmLangRules.btSaveClick(Sender: TObject);
var
  s:string;

  function GetNewIdTempl:integer;
  const
    SQLText='select MAX(ID) from dbo.ANN_LANG_RULES_Group';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=SQLText;
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

begin
  if IdTempl=1 then
  begin
    with TADOStoredProc.Create(nil) do
    try
      Connection:=DM.con;
      ProcedureName:='dbo.spANN_Lang_Rules_ADD';
      Parameters.Refresh;
      Parameters.ParamByName('@DST').Value:=deBegin.Date;
      Parameters.ParamByName('@DFN').Value:=deEnd.Date;
      Parameters.ParamByName('@id_zone').Value:=rgShed.ItemIndex;
      Parameters.ParamByName('@direct').Value:=rgDirect.ItemIndex; 
      Parameters.ParamByName('@COM').Value:=eComments.Text;
      Parameters.ParamByName('@COP').Value:=DM.COP;
      ExecProc;
      HSMessageDlg('Шаблон добавлен',mtInformation,[mbOK],0);
      idTempl:=GetNewIdTempl;
      FillApAkTvs;
      s:=GetTemplNameById(IdTempl);
      DM.AddToLog(Format(LogLangOrderAdd,[s]),'','');
      SelectTemplateParams;
      pgTemplList.Row:=pgTemplList.RowCount-1;
      IdTempl:=pgTemplList.Cols[1].Cells[pgTemplList.Row].Value;
    finally
      Free;
    end;
  end
  else
  begin
    with TADOStoredProc.Create(nil) do
    try
      Connection:=DM.con;
      ProcedureName:='dbo.spANN_Lang_Rules_Change';
      s:=GetTemplNameById(IdTempl);
      Parameters.Refresh;
      Parameters.ParamByName('@ID').Value:=IdTempl;
      Parameters.ParamByName('@DST').Value:=deBegin.Date;
      Parameters.ParamByName('@DFN').Value:=deEnd.Date;
      Parameters.ParamByName('@id_zone').Value:=rgShed.ItemIndex;
      Parameters.ParamByName('@direct').Value:=rgDirect.ItemIndex;
      Parameters.ParamByName('@COM').Value:=eComments.Text;
      Parameters.ParamByName('@COP').Value:=DM.COP;
      ExecProc;
      FillApAkTvs;
      HSMessageDlg('Шаблон отредактирован',mtInformation,[mbOK],0);
      DM.AddToLog(Format(LogLangOrderEdit,[s]),'',''); 
      SelectTemplateParams;
      NotSaved:=false;
    finally
      Free;
    end;
  end;
end;

procedure TfrmLangRules.btnDelLangClick(Sender: TObject);
var
  st,sl:string;
begin
   st:=GetTemplNameById(IdTempl);
   sl:=GetLangGen(mpgLang.HiddenCols[0].Cells[mpgLang.Row].Value);
    if HSMessageDlg('Удалить язык?',mtWarning,[mbYes,mbNo],0)=mrNo then exit;
    with TADOStoredProc.Create(nil) do
    try
      Connection:=DM.con;
      ProcedureName:='dbo.spANN_Lang_Order_Delete';
      Parameters.Refresh;
      Parameters.ParamByName('@ID_Templ').Value:=IdTempl;
      Parameters.ParamByName('@id_lang').Value:=mpgLang.HiddenCols[0].Cells[mpgLang.Row].Value;
      ExecProc;
      HSMessageDlg('Язык удален из очереди',mtInformation,[mbOk],0);
      DM.AddToLog(Format(LogLangPriorDelete,[sl,st]),'',''); 
      FillLanguages;
    finally
      Free;
    end;
end;

procedure TfrmLangRules.btnAddLangClick(Sender: TObject);
var
  st,sl:string;
  li:integer;

  function DefineLangId:integer;
  const
    SQLText='select id from dbo.ANN_LANGUAGES where caption='+#39+'%s'+#39;
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[cbxLang.Text]);
      Open;
      if RecordCount=0 then
        result:=mpgLang.RowCount 
      else
        result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

begin
  st:=GetTemplNameById(IdTempl);
  li:=DefineLangId;
  sl:=GetLangGen(li);
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_Lang_Order_Change';
    Parameters.Refresh;
    Parameters.ParamByName('@ID_Templ').Value:=IdTempl;
    Parameters.ParamByName('@id_lang').Value:=li;
    Parameters.ParamByName('@Lang_order').Value:=RsSpnOrder.IntValue;
    ExecProc;
    HSMessageDlg('Изменения сохранены',mtInformation,[mbOk],0);
    DM.AddToLog(Format(LogLangPriorEdit,[sl,st]),'','');
    FillLanguages;
  finally
    Free;
  end;
end;

procedure TfrmLangRules.mpgLangSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  cbxLang.ItemIndex:=cbxLang.Items.IndexOf(mpgLang.Cols[1].Cells[ARow].Text);
  RsSpnOrder.IntValue:=mpgLang.Cols[0].Cells[ARow].Value;    
end;

procedure TfrmLangRules.cbxLangChange(Sender: TObject);

  function Find(s:string):boolean;
  var
    i:integer;
  begin
    for i:=0 to mpgLang.RowCount-1 do
    begin
      result:=mpgLang.Cols[1].Cells[i].Text=s;
      if result then break;
    end;
  end;

begin
  if Find(cbxLang.Text) then
    RsSpnOrder.Max:=mpgLang.RowCount-1
  else
    RsSpnOrder.Max:=mpgLang.RowCount;
end;

procedure TfrmLangRules.tbUpClick(Sender: TObject);
var
  lo,li:integer;
  st,sl:string;
begin
  lo:=mpgLang.Cols[0].Cells[mpgLang.Row].Value;
  if lo=1 then exit;
  lo:=lo-1;
  st:=GetTemplNameById(IdTempl);
  li:=mpgLang.HiddenCols[0].Cells[mpgLang.Row].Value;
  sl:=GetLangGen(li);
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_Lang_Order_Change';
    Parameters.Refresh;
    Parameters.ParamByName('@ID_Templ').Value:=IdTempl;
    Parameters.ParamByName('@id_lang').Value:=li;
    Parameters.ParamByName('@Lang_order').Value:=lo;
    ExecProc;
    DM.AddToLog(Format(LogLangPriorEdit,[sl,st]),'','');
    FillLanguages;
  finally
    Free;
  end;

end;

procedure TfrmLangRules.tbDownClick(Sender: TObject);
var
  lo,li:integer;
  st,sl:string;
begin
  lo:=mpgLang.Cols[0].Cells[mpgLang.Row].Value;
  if lo=mpgLang.RowCount-1 then exit;
  lo:=lo+1;
  st:=GetTemplNameById(IdTempl);
  li:=mpgLang.HiddenCols[0].Cells[mpgLang.Row].Value;
  sl:=GetLangGen(li);
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_Lang_Order_Change';
    Parameters.Refresh;
    Parameters.ParamByName('@ID_Templ').Value:=IdTempl;
    Parameters.ParamByName('@id_lang').Value:=li;
    Parameters.ParamByName('@Lang_order').Value:=lo;
    ExecProc;
    DM.AddToLog(Format(LogLangPriorEdit,[sl,st]),'','');
    FillLanguages;
  finally
    Free;
  end;
end;

procedure TfrmLangRules.Timer1Timer(Sender: TObject);
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

procedure TfrmLangRules.eCommentsChange(Sender: TObject);
begin
  NotSaved:=true;
end;

end.
