unit uSeconds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Mask, RzEdit, RzSpnEdt, Grids, ProfGrid, ADODB,
  uDM, uAppInfo;

type
  TOneLD = record
    ID:integer;
    LD:string;
    LDName:string;
    Selected:boolean;
end;

type
  TLDList = class
  private
    fCount:integer;


    function fGetItemByLD(LD:string):integer;
    procedure fClear;
    procedure fLoad;
    procedure fShow(pg:TProfGrid);
  public
    fItems:array of TOneLD;
    property Count:integer read fCount;

    function AllSelected:boolean;
    procedure Refresh(pg:TProfGrid);
    procedure SelectAll(Selected:boolean);
    procedure SetFiltered;
end;

type
  TfrmSeconds = class(TForm)
    btnOk: TButton;
    btCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    spnSeconds: TRzSpinEdit;
    spnEarly: TRzSpinEdit;
    spnLate: TRzSpinEdit;
    pgLD: TProfGrid;
    chbxShowVisin: TCheckBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    spnRowHeight: TRzSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgLDButtonClicked(Sender: TProfGrid; ACol, ARow: Integer);
    procedure pgLDCheckBoxChanged(Sender: TProfGrid; ACol, ARow: Integer;
      Checked: Boolean);
  private
    { Private declarations }
    procedure fInitGrid;
  public
    { Public declarations }
    Selected:boolean;
    LDList:TLDList;
    procedure SetMainFunctionsDisabled;
  end;


implementation

{$R *.dfm}

uses intf_access;

{ ***** TLDList ***** }

function TLDList.fGetItemByLD(LD:string):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to fCount-1 do
  begin
    if trim(fItems[i].LD) = trim(LD) then
    begin
      result:=i;
      break;
    end;
  end;
end;

procedure TLDList.fClear;
begin
  fCount:=0;
  SetLength(fItems,fCount);
end;

procedure TLDList.fLoad;
const
  SQLTextLD = 'select LD, NAME_LD from NSI.dbo.VID_LD (nolock)';
  SQLTextFiltered = 'select LD from dbo.ANN_LD (nolock)';
var
  OneLD:TOneLD;
  i:integer;
begin
  fClear;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLTextLD;
    Open;
    while not EOF do
    begin
      OneLD.ID:=fCount; 
      OneLD.LD:=FieldByName('LD').AsString;
      OneLD.LDName:=FieldByName('NAME_LD').AsString;
      OneLD.Selected:=false;
      fCount:=fCount+1;
      SetLength(fItems,fCount);
      fItems[fCount-1]:=OneLD;
      Next;
    end;
    Close;
    SQL.Text:=SQLTextFiltered;
    Open;
    while not EOF do
    begin
      i:=fGetItemByLD(FieldByName('LD').AsString);
      if i<>-1 then
        fItems[i].Selected:=true;

      Next;   
    end;
  finally
    Free;
  end;
end;

procedure TLDList.fShow(pg:TProfGrid);
var
  i,r:integer;
begin
  pg.RowCount:=2;
  for i:=0 to fCount-1 do
  begin
    r:=pg.RowCount;
    pg.RowCount:=r+1;
    pg.HiddenCols[0].Cells[r].Value:=fItems[i].ID;
    pg.Cells[0,r].CheckBoxChecked:=fItems[i].Selected;
    pg.Cells[1,r].Text:=fItems[i].LDName;
  end;
  pg.AutoSizeColumns;
  pg.AutoSizeRows;  
end;

function TLDList.AllSelected:boolean;
var
  i:integer;
begin
  result:=true;
  for i:=0 to fCount-1 do
    if not fItems[i].Selected then
    begin
      result:=false;
      break;
    end;
end;

procedure TLDList.Refresh(pg:TProfGrid);
begin
  fLoad;
  fShow(pg);
end;

procedure TLDList.SelectAll(Selected:boolean);
var
  i:integer;
begin
  for i:=0 to fCount-1 do
    fItems[i].Selected:=Selected; 
end;

procedure TLDList.SetFiltered;
var
  strXML:string;
  i:integer;
begin
  strXML:='<?xml version="1.0" encoding="WINDOWS-1251"?><root>';
  for i:=0 to fCount-1 do
    if fItems[i].Selected then
      strXML:=strXML+'<list LD="'+fItems[i].LD+'" />';
  strXML:=strXML+'</root>';
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='[dbo].[spANN_LDEdit]';
    Parameters.Refresh;
    Parameters.ParamByName('@strXML').Value:=strXML;
    Parameters.ParamByName('@cCOp').Value:=AppInfo.AccessLogin;
    ExecProc;
  finally
    Free;
  end;
end;

{ ***** TfrmSeconds ***** }

procedure TfrmSeconds.fInitGrid;
begin
  pgLD.HideColumn(0);
  pgLD.Cells[0,0].Text:='     ';
  pgLD.Cells[1,0].Text:='Вид рейса';
  pgLD.Cells[1,0].TextAlignment:=taCenter;
  pgLD.Cols[0].CheckBox:=true;
  pgLD.Cols[1].ReadOnly:=true;
  pgLD.MergeHoriz(0,1,1);
  pgLD.Cells[0,1].Button:=true;
  pgLD.Cells[0,1].Text:='Выбрать все';
end;

procedure TfrmSeconds.SetMainFunctionsDisabled;
var
  E:boolean;
begin
  E:=IsAccess('ANN_EditStartTime','kobra_ann');
  btnOk.Enabled:=E;
end;

procedure TfrmSeconds.FormShow(Sender: TObject);
begin
  fInitGrid;
  LDList:=TLDList.Create;
  LDList.Refresh(pgLD);  
  SetMainFunctionsDisabled;
  Selected:=false;
  spnSeconds.SetFocus;
end;

procedure TfrmSeconds.btnOkClick(Sender: TObject);
begin
  LDList.SetFiltered; 
  Selected:=true;
  Close;
end;

procedure TfrmSeconds.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSeconds.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LDList.Free; 
end;

procedure TfrmSeconds.pgLDButtonClicked(Sender: TProfGrid; ACol,
  ARow: Integer);
var
  AllSelected:boolean;
  i:integer;
begin
  if pgLD.RowCount=2 then exit;
  AllSelected:=not LDList.AllSelected;
  LDList.SelectAll(AllSelected);
  for i:=2 to pgLD.RowCount-1 do
    pgLD.Cells[0,i].CheckBoxChecked:=AllSelected;  
end;

procedure TfrmSeconds.pgLDCheckBoxChanged(Sender: TProfGrid; ACol,
  ARow: Integer; Checked: Boolean);
var
  i,r:integer;
begin
  if (pgLD.Col<>0) or (pgLD.Row<2) then exit;
  r:=pgLD.Row;
  i:=pgLD.HiddenCols[0].Cells[r].Value;
  LDList.fItems[i].Selected:=pgLD.Cells[0,r].CheckBoxChecked; 
end;

end.
