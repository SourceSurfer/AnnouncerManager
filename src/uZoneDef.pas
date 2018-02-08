unit uZoneDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ADODB, Grids, ProfGrid, StdCtrls, Buttons, ExtCtrls;

type
  TZone = class
    Id_zone:integer;
    NPos:integer;
    Zone:string;
end;

type
  TZoneList = class(TList)
    procedure FillZones;
    procedure ShowZones(List:TStrings);
    procedure ClearZones;
    function GetId(_NPos:integer):integer;
    function GetPos(_Id:integer):integer;
end;

type
  TfrmZoneDef = class(TForm)
    GroupBox1: TGroupBox;
    mpgDef: TProfGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edIpAddress: TEdit;
    Label2: TLabel;
    cbxZone: TComboBox;
    btSave: TBitBtn;
    btDel: TBitBtn;
    Timer1: TTimer;
    procedure mpgDefSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btSaveClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure edIpAddressChange(Sender: TObject);
    procedure cbxZoneChange(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    procedure SetSaved(AValue:boolean);
  public
    { Public declarations }
    ZoneList:TZoneList;
    procedure InitGrids;
    procedure FillData;
    property NotSaved: boolean read fNotSaved write SetSaved;
  end;

implementation

uses uDM;

{$R *.dfm}

procedure TZoneList.FillZones;
const
  SQLText = 'select id,zone from dbo.ANN_ZONES';
var
  Z:TZone;
  n:integer;
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    n:=0;
    while not Eof do
    begin
      Add(TZone.Create);
      Z:=TZone(Items[Count-1]);
      Z.Id_zone:=FieldByName('id').AsInteger;
      Z.NPos:=n;
      Z.Zone:=FieldByName('Zone').AsString;
      n:=n+1;
      Next;    
    end;
  finally
    Free;
  end;
end;

procedure TZoneList.ShowZones(List:TStrings);
var
  i:integer;
begin
  List.Clear;
  for i:=0 to Count-1 do
    List.Add(TZone(Items[i]).Zone);
end;

procedure TZoneList.ClearZones;
begin
  while Count>0 do
    Delete(0);
end;


function TZoneList.GetId(_NPos:integer):integer;
begin
  if (_NPos<0) or (_NPos>=Count) then exit;
  result:=TZone(Items[_NPos]).Id_zone;
end;

function TZoneList.GetPos(_Id:integer):integer;
var
  i:integer;
begin
  for i:=0 to Count-1 do
    if TZone(Items[i]).Id_zone = _Id then break;
  result:=i;  
end;

procedure TfrmZoneDef.SetSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
  begin
    Caption:='Распределение зон по рабочим станциям ***';
  end
  else
  begin
    Caption:='Распределение зон по рабочим станциям';
    btSave.Font.Color:=clMenuHighlight;
    btSave.Font.Style:=[];    
  end;
end;

procedure TfrmZoneDef.InitGrids;
const
  captions:array[0..1] of string =('IP-адрес','Зона озвучивания');
  widths:array[0..1] of integer =(100,150);
var
  i:integer;
begin
  with mpgDef do
  begin
    ColCount:=3;
    HideColumn(0);
    for i:=0 to 1 do
    begin
      Cells[i,0].Text:=captions[i];
      Cells[i,0].TextAlignment:=taCenter;
      Cols[i].Width:=widths[i];
      Cols[i].ReadOnly:=true;
    end;
  end;
end;

procedure TfrmZoneDef.FillData;
const
  SQLText='select AZR.id_zone,AZR.ip_address,AZ.zone from dbo.ANN_ZONE_RULES AZR left join dbo.ANN_ZONES AZ on AZR.id_zone=AZ.id';
var
  itm:integer;
begin
  mpgDef.RowCount:=0;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      itm:=mpgDef.RowCount;
      mpgDef.RowCount:=mpgDef.RowCount+1;
      mpgDef.HiddenCols[0].Cells[itm].Value:=FieldByName('id_zone').AsInteger;
      mpgDef.Cols[0].Cells[itm].Value:=FieldByName('ip_address').AsString;
      mpgDef.Cols[1].Cells[itm].Value:=FieldByName('zone').AsString;                
      Next;
    end;
  finally
    Free;
  end;
end;



procedure TfrmZoneDef.mpgDefSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  id:integer;
begin
  if mpgDef.RowCount<2 then exit; 
  id:=mpgDef.HiddenCols[0].Cells[ARow].Value;
  edIpAddress.Text:=mpgDef.Cols[0].Cells[ARow].Text;
  cbxZone.ItemIndex:=ZoneList.GetPos(id);
  NotSaved:=false;    
end;

procedure TfrmZoneDef.FormShow(Sender: TObject);
begin
  ZoneList:=TZoneList.Create;
  ZoneList.FillZones;
  ZoneList.ShowZones(cbxZone.Items);
  if cbxZone.Items.Count>0 then
    cbxZone.ItemIndex:=0;
  InitGrids;
  FillData;
  NotSaved:=false;
end;

procedure TfrmZoneDef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ZoneList.Free; 
end;

procedure TfrmZoneDef.btSaveClick(Sender: TObject);
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyIDZonesForANNService';
    Parameters.Refresh;
    Parameters.ParamByName('@ip_address').Value:=edIpAddress.Text;
    Parameters.ParamByName('@id_zone').Value:=ZoneList.GetId(cbxZone.ItemIndex);
    Parameters.ParamByName('@act').Value:=1;
    ExecProc;
    ZoneList.ClearZones;
    ZoneList.FillZones;
    FillData;
    NotSaved:=false;
  finally
    Free;
  end;
end;

procedure TfrmZoneDef.btDelClick(Sender: TObject);
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyIDZonesForANNService';
    Parameters.Refresh; 
    Parameters.ParamByName('@ip_address').Value:=edIpAddress.Text;
    Parameters.ParamByName('@id_zone').Value:=NULL;
    Parameters.ParamByName('@act').Value:=0;
    ExecProc;
    ZoneList.ClearZones;
    ZoneList.FillZones;
    FillData;
  finally
    Free;
  end;
end;

procedure TfrmZoneDef.Timer1Timer(Sender: TObject);
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

procedure TfrmZoneDef.edIpAddressChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmZoneDef.cbxZoneChange(Sender: TObject);
begin
  NotSaved:=true;
end;

end.
