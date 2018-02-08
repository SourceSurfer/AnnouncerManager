unit uZones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ProfGrid, StdCtrls, Buttons, ExtCtrls,DB,ADODB, ImgList, HSDialogs,
  ExtDlgs,intf_access,uZoneDef;

const
  LogZoneAdd = 'Добавление зоны %s';
  LogZoneEdit = 'Редактирование зоны %s';
  LogZoneDelete = 'Удаление зоны %s';

type
  TZoneReg = class
    Id:integer;
    NPos:integer;
    Terminal:string;
    Caption:string;
end;

type
  TZoneRegList = class(TList)
    procedure FillZoneReg;
    procedure ShowZones(List:TStrings);
    function GetZoneId(_NPos:integer):integer;
    function GetPosById(_Id:integer):integer;
end;

type
  TCurrZoneReg = class
    Id:integer;
    AE:integer;
    Terminal:string;
    Zreg:integer;
    Name:string;
    PV: integer; //вылет-прилет
    VR: integer; //вид рейса
end;


type
  TZoneSound = class
    Id:integer;
    Name:string;
    flight:integer; // flight->VR
    dir:integer;    // dir ->PV
    ZoneRegList:TList;
    procedure FillRegZones;
    procedure ShowRegZones(List:TStrings);
    procedure ModifyRegZones(List:TStrings;VPValue,FlightValue:string);
end;

type
  TZoneSoundList = class(TList)
    function GetZoneById(_Id:integer):TZoneSound;
    procedure FillSoundZones;
    procedure ClearSoundZones;
end;

type
  TfrmZones = class(TForm)
    mpgZones: TProfGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edZone: TEdit;
    btAdd: TBitBtn;
    btEdit: TBitBtn;
    btDelete: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    GroupBox3: TGroupBox;
    Image1: TImage;
    btFind: TBitBtn;
    rgpFlight: TRadioGroup;
    rgpDir: TRadioGroup;
    GroupBox2: TGroupBox;
    lsbxZonesSelected: TListBox;
    lsbxZonesAll: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    btAdd1: TBitBtn;
    btDel1: TBitBtn;
    btAddAll: TBitBtn;
    btDelAll: TBitBtn;
    Label4: TLabel;
    edId: TEdit;
    btZoneDef: TBitBtn;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btFindClick(Sender: TObject);
    procedure mpgZonesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btAddClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btAdd1Click(Sender: TObject);
    procedure btDel1Click(Sender: TObject);
    procedure btAddAllClick(Sender: TObject);
    procedure btDelAllClick(Sender: TObject);
    procedure btZoneDefClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure edZoneChange(Sender: TObject);
    procedure rgpFlightClick(Sender: TObject);
    procedure rgpDirClick(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    procedure SetMainFunctionsDisabled;
    function GetFlightValue:string;
    function GetVPValue:string;
    function GetZReg(S:string):integer;
    procedure SetSaved(AValue:boolean);
  public
    { Public declarations }
    Changed:boolean;
    ZRList:TZoneRegList;
    ZSList:TZoneSoundList;
    procedure InitGrids;
    procedure FillZones;
    property NotSaved: boolean read fNotSaved write SetSaved; 
  end;

implementation

{$R *.dfm}

uses uDM;

procedure TZoneRegList.FillZoneReg;
const
  SQLText='select id,terminal,caption from dbo.vANN_RegZones';
var
  ZR:TZoneReg;
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      Add(TZoneReg.Create);
      ZR:=TZoneReg(Items[Count-1]);
      ZR.Id:=FieldByName('Id').AsInteger;
      ZR.NPos:=Count-1;
      ZR.Terminal:=FieldByName('terminal').AsString;
      ZR.Caption:=FieldByName('caption').AsString;
      Next;
    end;
  finally
    Free;
  end;
end;

procedure TZoneRegList.ShowZones(List:TStrings);
var
  i:integer;
  ZR:TZoneReg;
  s:string;
begin
  List.Clear;
  for i:=0 to Count-1 do
  begin
    ZR:=TZoneReg(Items[i]);
    s:='('+ZR.Terminal+') '+ZR.Caption;
    List.Add(s);
  end;
end;

function TZoneRegList.GetZoneId(_NPos:integer):integer;
var
  ZR:TZoneReg;
begin
  ZR:=TZoneReg(Items[_NPos]);
  result:=ZR.Id; 
end;

function TZoneRegList.GetPosById(_Id:integer):integer;
var
  i:integer;
begin
  for i:=0 to Count-1 do
  begin
    if TZoneReg(Items[i]).Id = _Id then
      break;
  end;
  result:=i; 
end; 

function TZoneSoundList.GetZoneById(_ID:integer):TZoneSound;
var
  i:integer;
begin
  for i:=0 to Count-1 do
    if TZoneSound(Items[i]).Id=_ID then break;
  result:=TZoneSound(Items[i]);
end;

procedure TZoneSoundList.FillSoundZones;
const
  SQLText='select * from dbo.vANN_SoundZones';
var
  SZ:TZoneSound;
  s:string;
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      Add(TZoneSound.Create);
      SZ:=TZoneSound(Items[Count-1]);

      SZ.Id:=FieldByName('Id').AsInteger;
      SZ.Name:=FieldByName('zone').AsString;

      s:=FieldByName('flight_type').AsString;
      if s='Ц' then SZ.flight:=1
      else if s='М' then SZ.flight:=2
      else  SZ.flight:=0;

      s:=FieldByName('zone_dir').AsString;
      if s='В' then SZ.dir:=1
      else if s='П' then SZ.dir:=2
      else SZ.dir:=0;

      SZ.ZoneRegList:=TList.Create;
      SZ.FillRegZones;

      Next; 
    end;
  finally
    Free;
  end;
end;

procedure TZoneSoundList.ClearSoundZones;
begin
  while Count>0 do
    delete(0);
end;

procedure TZoneSound.FillRegZones;
const
  SQLText = 'select * from dbo.vANN_CurrZone where id_zone=%s';
var
  CZR:TCurrZoneReg;
  s:string;
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format(SQLtext,[IntToStr(ID)]);
    Open;
    ZoneRegList.Clear;
    while not Eof do
    begin
      ZoneRegList.Add(TCurrZoneReg.Create);
      CZR:=TCurrZoneReg(ZoneRegList.Items[ZoneRegList.Count-1]);
      CZR.Id:=FieldByName('id_zone').AsInteger;
      CZR.AE:=FieldByName('AE').AsInteger;
      CZR.Terminal:=FieldByName('terminal').AsString;
      CZR.Zreg:=FieldByName('zreg_id').AsInteger;
      CZR.Name:=FieldByName('zone_reg').AsString;

      s:=FieldByName('PV').AsString;
      if s='В' then
        CZR.PV:=1
      else if s='П' then
        CZR.PV:=2
      else CZR.PV:=0;

      s:=FieldByName('VR').AsString;
      if s='Ц' then
        CZR.VR:=1
      else if s='М' then
        CZR.VR:=2
      else CZR.VR:=0;
            
      Next;
    end;
  finally
    Free;
  end;
end;

procedure TZoneSound.ShowRegZones(List:TStrings);
var
  s:string;
  i:integer;
begin
  List.Clear;
  for i:=0 to ZoneRegList.Count-1 do
  begin
    s:='('+TCurrZoneReg(ZoneRegList.Items[i]).Terminal+') '+TCurrZoneReg(ZoneRegList.Items[i]).Name;
    List.Add(s); 
  end;
end;

procedure TZoneSound.ModifyRegZones(List:TStrings;VPValue,FlightValue:string);
var
  i:integer;

  function GetZReg(S:string):integer;
  const
    SQLText='select id from dbo.vANN_RegZones where terminal = '+#39+'%s'+#39+' and caption = '+#39+'%s'+#39;
  var
    STerminal,SCaption:string;
  begin
    STerminal:=copy(S,2,pos(')',S)-2);
    SCaption:=trim(copy(S,pos(')',S)+2,length(S)-pos(')',S)+1));
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[STerminal,SCaption]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;
  
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyZoneRules';
    Parameters.Refresh;
    Parameters.ParamByName('@id_zone').Value:=ID;
    Parameters.ParamByName('@zone_reg').Value:=NULL;
    Parameters.ParamByName('@pv').Value:=NULL;
    Parameters.ParamByName('@vr').Value:=NULL;
    Parameters.ParamByName('@act').Value:=0;
    ExecProc;
    for i:=0 to List.Count-1 do
    begin
      Parameters.Refresh;
      Parameters.ParamByName('@id_zone').Value:=ID;
      Parameters.ParamByName('@zone_reg').Value:=GetZReg(List.Strings[i]);//TCurrZoneReg(ZoneRegList.Items[i]).Id;
      Parameters.ParamByName('@pv').Value:=VpValue;
      Parameters.ParamByName('@vr').Value:=FlightValue;
      Parameters.ParamByName('@act').Value:=1;
      ExecProc;
    end;
  finally
    Free;
  end;    
end;

procedure TfrmZones.SetMainFunctionsDisabled;
var
  E:boolean;
begin
  E:=IsAccess('ANN_EditZones','kobra_ann');
  btAdd.Enabled:=E;
  btEdit.Enabled:=E;
  btDelete.Enabled:=E;
  btFind.Enabled:=E;
  btZoneDef.Enabled:=E;
end;

procedure TfrmZones.SetSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
    Caption:='Справочник зон озвучивания ***'
  else
  begin
    Caption:='Справочник зон озвучивания';
    btAdd.Font.Color:=clMenuHighlight;
    btAdd.Font.Style:=[];
    btEdit.Font.Color:=clMenuHighlight;
    btEdit.Font.Style:=[];      
  end;
end;

function TfrmZones.GetFlightValue:string;
begin
  case rgpFlight.ItemIndex of
  1: result:='Ц';
  2: result:='M';
  else
    result:='';
  end;  
end;

function TfrmZones.GetVPValue:string;
begin
  case rgpDir.ItemIndex of
  1: result:='В';
  2: result:='П';
  else
    result:='';
  end;
end;

  function TfrmZones.GetZReg(S:string):integer;
  const
    SQLText='select id from dbo.vANN_RegZones where terminal = '+#39+'%s'+#39+' and caption = '+#39+'%s'+#39;
  var
    STerminal,SCaption:string;
  begin
    STerminal:=copy(S,2,pos(')',S)-2);
    SCaption:=trim(copy(S,pos(')',S)+2,length(S)-pos(')',S)+1));
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text:=Format(SQLText,[STerminal,SCaption]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

procedure TfrmZones.InitGrids;
const
  titles:array[0..1] of string = ('Картинка','Наименование');//,'Терминал','Тип зоны','Вид рейса','Направление рейса');
  widthes:array[0..1] of integer = (80,200);//,120,120,120,120);
var
  i:integer;
begin
  with mpgZones do
  begin
    ColCount:=3;
    HideColumn(0);
    for i:=0 to 1 do
    begin
      Cells[i,0].TextAlignment:=taCenter;
      Cells[i,0].TextLayout:=tlCenter;
      Cols[i].TextAlignment:=taCenter;
      Cols[i].TextLayout:=tlCenter;
      Cols[i].GraphicAlignment:=taCenter;
      Cols[i].GraphicLayout:=tlCenter;

      Cells[i,0].Value:=titles[i];
      Cols[i].Width:=widthes[i];
    end;
  end;
end;

procedure TfrmZones.FillZones;
var
  itm:integer;
  bm:TBitMap;
begin

  with TADOQuery.Create(nil) do
  try
    mpgZones.RowCount:=1;
    Connection:=DM.con;
    SQL.Text:='select id, zone,pict,flight_type,zone_dir from dbo.vANN_SoundZones';
    Open;
    while not Eof do
    begin
      itm:=mpgZones.RowCount;
      mpgZones.RowCount:=mpgZones.RowCount+1;

      mpgZones.HiddenCols[0].Cells[itm].Value:=FieldByName('ID').AsString;
      //mpgZones.HiddenCols[1].Cells[itm].Value:=FieldByName('zone_type').AsString;
      mpgZones.Cols[1].Cells[itm].Value:=FieldByName('Zone').AsString;

      bm:=TBitMap.Create;
      bm.Assign(FieldByName('pict'));

      mpgZones.Cols[0].Cells[itm].Graphic:=bm;

     { mpgZones.Cols[2].Cells[itm].Value:=FieldByName('terminal').AsString;
      mpgZones.Cols[3].Cells[itm].Value:=FieldByName('zreg').AsString;
      mpgZones.Cols[4].Cells[itm].Value:=FieldByName('flight').AsString;    
      mpgZones.Cols[5].Cells[itm].Value:=FieldByName('dir').AsString;   }
      Next;
    end;
  finally
    Free;
  end;
end;  

procedure TfrmZones.FormShow(Sender: TObject);
var
  b:boolean;
begin
  Changed:=false;
  ZRList:=TZoneRegList.Create;
  ZRList.FillZoneReg;
  ZRList.ShowZones(lsbxZonesAll.Items);
  ZSList:=TZoneSoundList.Create;
  ZSList.FillSoundZones;
  InitGrids;
  FillZones;
  SetMainFunctionsDisabled;
  if mpgZones.RowCount<2 then exit; 
  b:=true;
  mpgZonesSelectCell(Sender,mpgZones.Col,mpgZones.Row,b);
  NotSaved:=false;
end;

procedure TfrmZones.btFindClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
      NotSaved:=true;
  end;    
end;

procedure TfrmZones.mpgZonesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  i:integer;
  CZS:TZoneSound;
begin
  edZone.Text:=mpgZones.Cols[1].Cells[ARow].Text;
  Image1.Picture.Graphic:=mpgZones.Cols[0].Cells[ARow].Graphic;
  i:=mpgZones.HiddenCols[0].Cells[ARow].Value;
  edId.Text:=IntToStr(i);
  CZS:=ZSList.GetZoneById(i);
  CZS.ShowRegZones(lsbxZonesSelected.Items);
  rgpFlight.ItemIndex:=CZS.flight;
  rgpDir.ItemIndex:=CZS.dir;
  NotSaved:=false;
 { cbxRegZones.ItemIndex:=ZRList.GetPosById(mpgZones.HiddenCols[1].Cells[ARow].Value);
  s:=mpgZones.Cols[4].Cells[ARow].Text;
  if s='Внутренний' then
    rgpFlight.ItemIndex:=1
  else
  if s='Международный' then
    rgpFlight.ItemIndex:=2
  else
    rgpFlight.ItemIndex:=0;
  s:=mpgZones.Cols[5].Cells[ARow].Text;
  if s='Вылет' then
    rgpDir.ItemIndex:=1
  else
  if s='Прилет' then
    rgpDir.ItemIndex:=2
  else
    rgpDir.ItemIndex:=0;    }
end;

procedure TfrmZones.btAddClick(Sender: TObject);
var
  i,id:integer;
 // z:TZoneSound;
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyZones';
    Parameters.Refresh;
    Parameters.ParamByName('@id_zone').Value:=0;
    Parameters.ParamByName('@zone').Value:=edZone.Text;
    Parameters.ParamByName('@flight_type').Value:=GetFlightValue;
    Parameters.ParamByName('@zone_dir').Value:=GetVpValue;
    Parameters.ParamByName('@act').Value:=1;
    ExecProc;
  finally
    Free;
  end;
  with TADODataSet.Create(nil) do
  try
    Connection:=DM.con;
    CommandText:='select id,pict from dbo.ANN_ZONES';
    Open;
    Last;
    id:=FieldByName('id').AsInteger;
    Edit;
    TBlobField(FieldByName('pict')).Assign(Image1.Picture);
    Post;
  finally
    Free;
  end;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyZoneRules';
    for i:=0 to lsbxZonesSelected.Items.Count-1 do
    begin
      Parameters.Refresh;
      Parameters.ParamByName('@id_zone').Value:=ID;
      Parameters.ParamByName('@zone_reg').Value:=GetZReg(lsbxZonesSelected.Items.Strings[i]);//TCurrZoneReg(ZoneRegList.Items[i]).Id;
      Parameters.ParamByName('@pv').Value:=GetVPValue;
      Parameters.ParamByName('@vr').Value:=GetFlightValue;
      Parameters.ParamByName('@act').Value:=1;
      ExecProc;
    end;
  finally
    Free;
  end;
  ZSList.ClearSoundZones;
  ZSList.FillSoundZones;
  InitGrids;
  FillZones;
  Changed:=true;
  NotSaved:=false;
end;

procedure TfrmZones.btEditClick(Sender: TObject);
var
  SBefore,SAfter:string;
  i:integer;
begin
  SBefore:='Старое название: '+mpgZones.Cols[1].Cells[mpgZones.Row].Text;
  SAfter:='Новое название: '+edZone.Text;
  if mpgZones.Cols[0].Cells[mpgZones.Row].Graphic<>Image1.Picture.Graphic then
    SAfter:=SAfter+' изменилась картинка';  
  if HSMessageDlg('Изменить зону?',mtWarning,[mbYes,mbNo],0)=mrNo then
  begin
    edZone.Text:=mpgZones.Cols[1].Cells[mpgZones.Row].Text;
    Image1.Picture.Graphic:=mpgZones.Cols[0].Cells[mpgZones.Row].Graphic;
    exit;
  end;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyZones';
    Parameters.Refresh;
    i:=mpgZones.HiddenCols[0].Cells[mpgZones.Row].Value;
    Parameters.ParamByName('@id_zone').Value:=i;
    Parameters.ParamByName('@zone').Value:=edZone.Text;
    Parameters.ParamByName('@flight_type').Value:=GetFlightValue;
    Parameters.ParamByName('@zone_dir').Value:=GetVpValue;
    Parameters.ParamByName('@act').Value:=2;
    ExecProc;
    DM.AddToLog(Format(LogZoneAdd,[edZone.Text]),SBefore,SAfter);
  finally
    Free;
  end;
  ZSList.GetZoneById(i).ModifyRegZones(lsbxZonesSelected.Items,GetFlightValue,GetVPValue);
  with TADODataSet.Create(nil) do
  try
    Connection:=DM.con;
    CommandText:='select id,pict from dbo.ANN_ZONES';
    Open;
    RecNo:=mpgZones.Row; 
    Edit;
    TBlobField(FieldByName('pict')).Assign(Image1.Picture);
    Post;
  finally
    Free;
  end;
  ZSList.ClearSoundZones;
  ZSList.FillSoundZones;
  InitGrids;
  FillZones;
  Changed:=true;
  NotSaved:=false;
end;

procedure TfrmZones.btDeleteClick(Sender: TObject);
begin
  if HSMessageDlg('Удалить зону?',mtWarning,[mbYes,mbNo],0)=mrNo then exit;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyZones';
    Parameters.Refresh;
    Parameters.ParamByName('@id_zone').Value:=mpgZones.HiddenCols[0].Cells[mpgZones.Row].Value;
    Parameters.ParamByName('@zone').Value:=edZone.Text;
    Parameters.ParamByName('@flight_type').Value:=GetFlightValue;
    Parameters.ParamByName('@zone_dir').Value:=GetVpValue;
    Parameters.ParamByName('@act').Value:=0;
    ExecProc;
    DM.AddToLog(Format(LogZoneDelete,[edZone.Text]),'','');
  finally
    Free;
  end;
  ZSList.ClearSoundZones;
  ZSList.FillSoundZones;  
  InitGrids;
  FillZones;
  Changed:=true;
end;

procedure TfrmZones.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ZRList.Free;
  ZSList.Free;
end;

procedure TfrmZones.btAdd1Click(Sender: TObject);
var
  s:string;
begin
  if (lsbxZonesAll.ItemIndex=-1) or (lsbxZonesAll.Items.Count=0) then exit;
  s:=lsbxZonesAll.Items.Strings[lsbxZonesAll.ItemIndex];
  if lsbxZonesSelected.Items.IndexOf(s)=-1 then
  begin
    lsbxZonesSelected.Items.Add(s);
    NotSaved:=true;
  end;  
end;

procedure TfrmZones.btDel1Click(Sender: TObject);
begin
  if (lsbxZonesSelected.ItemIndex=-1) or (lsbxZonesSelected.Items.Count=0) then exit;
  lsbxZonesSelected.Items.Delete(lsbxZonesSelected.ItemIndex);
  NotSaved:=true;
end;

procedure TfrmZones.btAddAllClick(Sender: TObject);
var
  i:integer;
  s:string;
begin
  lsbxZonesSelected.Items.Clear;
  for i:=0 to lsbxZonesAll.Items.Count-1 do
  begin
    s:=lsbxZonesAll.Items.Strings[i];
    lsbxZonesSelected.Items.Add(s);  
  end;
  NotSaved:=true;
end;

procedure TfrmZones.btDelAllClick(Sender: TObject);
begin
  lsbxZonesSelected.Items.Clear;
  NotSaved:=true;
end;

procedure TfrmZones.btZoneDefClick(Sender: TObject);
begin
  with TfrmZoneDef.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmZones.Timer1Timer(Sender: TObject);
begin
  if NotSaved then
  begin
    if btAdd.Font.Color=clRed then
    begin
      btAdd.Font.Color:=clMenuHighlight;
      btAdd.Font.Style:=[];
      btEdit.Font.Color:=clMenuHighlight;
      btEdit.Font.Style:=[];
    end
    else
    begin
      btAdd.Font.Color:=clRed;
      btAdd.Font.Style:=[fsBold];
      btEdit.Font.Color:=clRed;
      btEdit.Font.Style:=[fsBold];        
    end;
  end;  
end;

procedure TfrmZones.edZoneChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmZones.rgpFlightClick(Sender: TObject);
begin
    NotSaved:=true;
end;

procedure TfrmZones.rgpDirClick(Sender: TObject);
begin
    NotSaved:=true;
end;

end.
