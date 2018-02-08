unit uCheckinTempl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDM, ADODB, ExtCtrls, StdCtrls, Grids, ProfGrid, ActnList,
  Buttons, Utils, HSDialogs, uAppInfo, uCheckinTemplEdit;

type
  TRecItems = (trLang, trServClass);

type
  TRecItem = record
    id:integer;
    caption:string;
end;

type
  TArrRec = class
  private
    fItems:array of TRecItem;
    fCount:integer;
    procedure fAddItem(fRI:TRecItem);
    function fGetItem(fIndex:integer):TRecItem;
  public
    property Count:integer read fCount;
    property Items[Index:integer]:TRecItem read fGetItem;
    constructor Create;
    procedure LoadItems(_type:TRecItems);
    procedure ShowItems(List:TStrings);
    function GetItem(Caption:string):integer;
end;

type
  TTempl = record
    id:integer;
    mtext:string;
    ServClassId:integer;
    ID_lang:integer;
end;

type
  TfmCheckinTempl = class(TForm)
    pgTempl: TProfGrid;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    acList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acFilter: TAction;
    acFilterCancel: TAction;
    acExit: TAction;
    Label1: TLabel;
    cbxServClass: TComboBox;
    Label2: TLabel;
    cbxLang: TComboBox;
    btFilter: TBitBtn;
    btFilterCancel: TBitBtn;
    btAdd: TBitBtn;
    btEdit: TBitBtn;
    btDelete: TBitBtn;
    procedure acExitExecute(Sender: TObject);
    procedure acFilterCancelExecute(Sender: TObject);
    procedure acFilterExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure pgTemplDblClick(Sender: TObject);
  private
    { Private declarations }

    fAllowDelEdit:boolean;
    fLangList:TArrRec;
    fServClassList:TArrRec;

    procedure fSetAllowDelEdit(fValue:boolean);
    procedure fInitGrid;
    procedure fFillGrid;
    procedure fSaveData(Act:integer; Tmpl:TTempl); // 0 - добавить; 1 - редактировать; 2 - удалить
  public
    { Public declarations }
    property AllowDelEdit:boolean read fAllowDelEdit write fSetAllowDelEdit;
    procedure IniForm;
  end;


implementation

{$R *.dfm}

{ *** TArrRec *** }

procedure TArrRec.fAddItem(fRI:TRecItem);
begin
  inc(fCount);
  SetLength(fItems,fCount);
  fItems[fCount-1]:=fRI;
end;

function TArrRec.fGetItem(fIndex:integer):TRecItem;
begin
  result:=fItems[fIndex];
end;

constructor TArrRec.Create;
begin
  inherited Create;
  fCount:=0;
end;


procedure TArrRec.LoadItems(_type:TRecItems);
const
  SQLText = 'select id, %s as caption from %s (nolock)';
var
  TableName:string;
  FieldName:string;
  con:TAdoConnection;
  RI:TRecItem;
begin
  case _type of
  trLang:
          begin
            con:=DM.con;
            TableName:='dbo.ANN_Languages';
            FieldName:='caption';
          end;
  trServClass:
          begin
            con:=DM.RDScon;
            TableName:='dbo.NetPlan2_ServClasses';
            FieldName:='NameRus';
          end;
  end;
  if _type = trServClass then
  begin
    RI.id:=0;
    RI.caption:='Без привязки к классу';
    fAddItem(RI);
  end;
  with TADOQuery.Create(nil) do
  try
    Connection:=con;
    SQL.Text:=Format(SQLText,[FieldName,TableName]);
    Open;
    while not Eof do
    begin
      RI.id:=FieldByName('id').AsInteger;
      RI.caption:=FieldByName('caption').AsString;
      fAddItem(RI);
      next;
    end;
  finally
    Free;
  end;
end;

procedure TArrRec.ShowItems(List:TStrings);
var
  i:integer;
begin
  List.Clear;
  for i:=0 to fCount-1 do
    List.Add(fItems[i].caption);
  List.Insert(0,'Все');
end;

function TArrRec.GetItem(Caption:string):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to fCount-1 do
  begin
    if fItems[i].caption = Caption then
    begin
      result:=i;
      break;
    end;
  end;
end;


{ *** TfmCheckinTempl ***}


procedure TfmCheckinTempl.fSetAllowDelEdit(fValue:boolean);
begin
  fAllowDelEdit:=fValue;
  acEdit.Enabled:=fValue;
  acDelete.Enabled:=fValue; 
end;

procedure TfmCheckinTempl.fInitGrid;
const
  nCol = 4;
  captions:array[0..nCol-2] of string = ('Шаблон','Класс обслуживания','Язык');
var
  c:integer;
begin
  with pgTempl do
  begin
    ColCount:=nCol;
    HideColumn(0);
    for c:=0 to nCol-2 do
    begin
      Cells[c,0].Value:=captions[c];
      Cells[c,0].TextAlignment:=taCenter;
      Cells[c,0].Font.Style:=[fsBold];
      Cols[c].ReadOnly:=true;
    end;
  end;
end;

procedure TfmCheckinTempl.fFillGrid;
const
  SQLText = 'declare @ServiceClassID int = %s, @id_lang int = %s '+
            'select id, mtext, ServiceClassID, id_lang from dbo.ANN_ServClassTempl (nolock) '+
            'where (ServiceClassID = @ServiceClassID or @ServiceClassID is NULL) '+
            '  and (id_lang = @id_lang or @id_lang is NULL)';
var
  r:integer;
  sci,li:integer;
begin
  pgTempl.RowCount:=1;
  AllowDelEdit:=false;
  sci:=cbxServClass.ItemIndex-1;
  li:=cbxLang.ItemIndex;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=Format(SQLText,[iif(cbxServClass.ItemIndex<1,'NULL',IntToStr(sci)),
                              iif(cbxLang.ItemIndex<1,'NULL',IntToStr(li))]);
    Open;
    while not Eof do
    begin
      r:=pgTempl.ROwCount;
      pgTempl.RowCount:=r+1;
      pgTempl.HiddenCols[0].Cells[r].Value:=FieldByName('id').AsInteger;
      pgTempl.Cells[0,r].Value:=FieldByName('mtext').AsString;
      pgTempl.Cells[1,r].Value:=fServClassList.Items[FieldByName('ServiceClassID').AsInteger].Caption;
      pgTempl.Cells[2,r].Value:=fLangList.Items[FieldByName('id_lang').AsInteger-1].Caption;
      next;
    end;
  finally
    Free;
  end;
  if pgTempl.RowCount>1 then
  begin
    pgTempl.Row:=0;
    AllowDelEdit:=true;
  end;
  pgTempl.AutoSizeColumns;
  pgTempl.AutoSizeRows;  
end;

procedure TfmCheckinTempl.fSaveData(Act:integer; Tmpl:TTempl);
begin
  with TADOStoredProc.Create(nil) do
  try
    Connection:=DM.con;
    ProcedureName:='dbo.spANN_ServClassTemplatesEdit';
    with Parameters do
    begin
      Refresh;
      if Act > 0 then
        ParamByName('@id').Value:=Tmpl.id;
      ParamByName('@del').Value:=(Act=2);
      if Act<2 then
      begin
        ParamByName('@mtext').Value:=Tmpl.mtext;
        ParamByName('@id_lang').Value:=Tmpl.ID_lang;
        ParamByName('@ServClassID').Value:=Tmpl.ServClassId;
      end;
      ParamByName('@cop').Value:=AppInfo.AccessLogin;
    end;
    ExecProc;
  finally
    Free;
  end;
end;

procedure TfmCheckinTempl.IniForm;
begin
  fInitGrid;
  fLangList:=TArrRec.Create;
  fLangList.LoadItems(trLang);
  fLangList.ShowItems(cbxLang.Items);
  cbxLang.ItemIndex:=0;
  fServClassList:=TArrRec.Create;
  fServClassList.LoadItems(trServClass);
  fServClassList.ShowItems(cbxServClass.Items);
  cbxServClass.ItemIndex:=0;
  fFillGrid; 
end;

procedure TfmCheckinTempl.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmCheckinTempl.acFilterCancelExecute(Sender: TObject);
begin
  cbxLang.ItemIndex:=0;
  cbxServClass.ItemIndex:=0;
  fFillGrid;
end;

procedure TfmCheckinTempl.acFilterExecute(Sender: TObject);
begin
  fFillGrid;
end;

procedure TfmCheckinTempl.acDeleteExecute(Sender: TObject);
var
  T:TTempl;
begin
  if HSMessageDlg('Удалить шаблон?',mtWarning,[mbYes,mbNo],0) = mrNo then exit;
  T.id:=pgTempl.HiddenCols[0].Cells[pgTempl.Row].Value;
  fSaveData(2,T);
  HSMessageDlg('Шаблон удален',mtInformation,[mbOk],0);
  fFillGrid;
end;

procedure TfmCheckinTempl.acAddExecute(Sender: TObject);
var
  T:TTempl;
begin
  with TfmCheckinTemplEdit.Create(nil) do
  try
    Caption:='Новый шаблон';
    cbxLang.Items:=Self.cbxLang.Items;
    cbxLang.Items.Delete(0);
    cbxServClass.Items:=Self.cbxServClass.Items;
    cbxServClass.Items.Delete(0);
    ShowModal;
    if Saved then
    begin
      T.mtext:=mmText.Text;
      T.ID_lang:=fLangList.GetItem(cbxLang.Text)+1;
      T.ServClassId:=fServClassList.GetItem(cbxServClass.Text);
      fSaveData(0,T);
      HsMessageDlg('Шаблон добавлен',mtInformation,[mbOk],0);
      fFillGrid;
    end;
  finally
    Free;
  end;
end;

procedure TfmCheckinTempl.acEditExecute(Sender: TObject);
var
  T:TTempl;
begin
  with TfmCheckinTemplEdit.Create(nil) do
  try
    Caption:='Изменение шаблона';
    cbxLang.Items:=Self.cbxLang.Items;
    cbxLang.Items.Delete(0);
    cbxLang.ItemIndex:=cbxLang.Items.IndexOf(pgTempl.Cells[2,pgTempl.Row].Value);
    cbxServClass.Items:=Self.cbxServClass.Items;
    cbxServClass.Items.Delete(0);
    cbxServClass.ItemIndex:=cbxServClass.Items.IndexOf(pgTempl.Cells[1,pgTempl.Row].Value);
    mmText.Text:=pgTempl.Cells[0,pgTempl.Row].Value;    
    ShowModal;
    if Saved then
    begin
      T.id:=pgTempl.HiddenCols[0].Cells[pgTempl.Row].Value;    
      T.mtext:=mmText.Text;
      T.ID_lang:=fLangList.GetItem(cbxLang.Text);
      T.ServClassId:=fServClassList.GetItem(cbxServClass.Text);
      fSaveData(1,T);
      HsMessageDlg('Шаблон изменен',mtInformation,[mbOk],0);
      fFillGrid;
    end;
  finally
    Free;
  end;
end;

procedure TfmCheckinTempl.pgTemplDblClick(Sender: TObject);
begin
  if pgTempl.Row>0 then acEditExecute(nil); 
end;

end.
