unit uGateExit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ProfGrid,ADODB,uDM, ExtCtrls, HSDialogs;

type
  TfrmGateExit = class(TForm)
    gbSetValues: TGroupBox;
    Label1: TLabel;
    cbxLang: TComboBox;
    Label2: TLabel;
    cbxType: TComboBox;
    Label3: TLabel;
    edSingle: TEdit;
    Label4: TLabel;
    edPlural: TEdit;
    btSave: TBitBtn;
    btDelete: TBitBtn;
    GroupBox1: TGroupBox;
    mpgConst: TProfGrid;
    Timer1: TTimer;
    procedure mpgConstSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure cbxLangChange(Sender: TObject);
    procedure cbxTypeChange(Sender: TObject);
    procedure edSingleChange(Sender: TObject);
    procedure edPluralChange(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    procedure SetNotSave(AValue:boolean);
  public
    { Public declarations }
    procedure InitGrids;
    procedure FillData;
    procedure FillLang;
    property NotSaved:boolean read fNotSaved write SetNotSave;
  end;

implementation

{$R *.dfm}

procedure TfrmGateExit.SetNotSave(AValue:boolean);
begin
  fNotSaved:=AValue;
  if FNotSaved then
    Caption:='Редактирование констант ***'
  else
  begin
    Caption:='Редактирование констант';
    btSave.Font.Color:=clMenuHighlight;
    btSave.Font.Style:=[];    
  end;
end;

procedure TfrmGateExit.InitGrids;
const
  widths:array[0..3] of integer = (80,80,80,80);
  captions:array[0..3] of string = ('Язык','Тип','Ед.число','Множ.число');
var
  i:integer;
begin
  for i:=0 to 3 do
  begin
    mpgConst.Cells[i,0].Text:=captions[i];
    mpgConst.Cells[i,0].TextAlignment:=taCenter;
    mpgConst.ColWidths[i]:=widths[i];
    mpgConst.Cols[i].ReadOnly:=true;   
  end;
end;

procedure TfrmGateExit.FillData;
const
  SQLText='select AL.caption, case AT.GE when ''SR'' then ''Стойка регистрации'' when ''VP'' then ''Выход'' else ''Транспортер'' end as GE, AT.single, AT.plural  from dbo.ANN_Termins AT inner join dbo.ANN_LANGUAGES AL on AT.id_lang = AL.id';
var
  i,itm:integer;
begin
  mpgConst.RowCount:=0;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      itm:=mpgConst.RowCount;
      mpgConst.RowCount:=mpgConst.RowCount+1;
      for i:=0 to 3 do
        mpgConst.Cells[i,itm].Text:=Fields[i].AsString; 
      Next;
    end;
  finally
    Free;
  end;
end;

procedure TfrmGateExit.FillLang;
const
  SQLText = 'select caption from dbo.ANN_Languages order by id';
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      cbxLang.Items.Add(Fields[0].AsString);
      Next;
    end;
  finally
    Free;
  end;  
end; 

procedure TfrmGateExit.mpgConstSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  cbxLang.ItemIndex:=cbxLang.Items.IndexOf(mpgConst.Cells[0,ARow].Text);
  cbxType.ItemIndex:=cbxType.Items.IndexOf(mpgConst.Cells[1,ARow].Text);
  edSingle.Text:=mpgConst.Cells[2,ARow].Text;
  edPlural.Text:=mpgConst.Cells[3,ARow].Text;
  NotSaved:=false;     
end;

procedure TfrmGateExit.FormShow(Sender: TObject);
begin
  FillLang;
  InitGrids;
  FillData;
  NotSaved:=false;
end;

procedure TfrmGateExit.Timer1Timer(Sender: TObject);
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

procedure TfrmGateExit.btSaveClick(Sender: TObject);

  function iif(expr:integer):string;
  begin
    case expr of
    0: result:='SR';
    1: result:='VP';
    2: result:='TR';
    end;
  end;
  
begin
  if (Sender as TBitBtn).Tag=0 then
    if HSMessageDlg('Удалить эту константу?',mtWarning,[mbYes,mbNo],0)=mrNo then exit;
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ModifyGateExitValues';
    Parameters.Refresh;
    Parameters.ParamByName('@id_lang').Value:=cbxLang.ItemIndex+1;
    Parameters.ParamByName('@GE').Value:=iif(cbxType.ItemIndex);
    Parameters.ParamByName('@single').Value:=edSingle.Text;
    Parameters.ParamByName('@plural').Value:=edPlural.Text;
    Parameters.ParamByName('@act').Value:=(Sender as TBitBtn).Tag;
    ExecProc;
    FillData;
  finally
    Free;
  end;
  NotSaved:=false;
end;

procedure TfrmGateExit.cbxLangChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmGateExit.cbxTypeChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmGateExit.edSingleChange(Sender: TObject);
begin
  NotSaved:=true;
end;

procedure TfrmGateExit.edPluralChange(Sender: TObject);
begin
  NotSaved:=true;
end;

end.
