unit uDelayReason;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, Grids, ProfGrid, HSDialogs, uDM, uAppInfo, StdCtrls,
  Menus, ActnList, ComCtrls, StrUtils, Buttons, ExtCtrls, Utils;

type
  TOneLang = record
    ID_lang:integer;
    Lang:string;
end;

type
  TLangList = class
  private
    fCount:integer;
    fItems:array of TOneLang;

    procedure fSetCount(fValue:integer);
    procedure fAddLang(ID_Lang:integer; Lang:string);
  public
    property Count:integer read fCount write fSetCount;

    procedure LoadLanguages(cbx:TComboBox);
    function GetLangID(Lang:string):integer;
end;

type
  TOneDelay = record
    ID:integer;
    SHORT_TITLE:string;
    PRICH:string;
    ID_Lang:integer;
    Lang:string;
    Default:boolean;
    PV:string;
    Act:integer;
end;

type
  TDelayList = class
  private
    fCount:integer;
    fItems:array of TOneDelay;
    procedure fSetCount(fValue:integer);

    procedure fAddDelay(ID:integer;SHORT_TITLE,PRICH:string; ID_Lang:integer; Lang,PV:string; Default:boolean);
    procedure fLoadDelays;
    procedure fShowDelays(pg:TProfGrid);

  public

    property Count: integer read fCount write fSetCount;
    procedure Refresh(pg:TProfGrid);
    function GetDelayByID(ID:integer):integer;
    function GetDelayByName(Name:string):integer;
//    procedure SaveChanges;
end;

type
  TfmDelayReason = class(TForm)
    pgDelay: TProfGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbxCode_Z: TComboBox;
    Label2: TLabel;
    pmMsgText: TPopupMenu;
    ActionList1: TActionList;
    PopUpMenuAddItem: TAction;
    ActPopUpMenuDeleteItem: TAction;
    mmDescribe: TRichEdit;
    btSave: TBitBtn;
    btClear: TBitBtn;
    Timer2: TTimer;
    chbxDefault: TCheckBox;
    Label3: TLabel;
    cbxLang: TComboBox;
    rbDir: TRadioGroup;
    acMsgMenu: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    btAdd: TBitBtn;
    btEdit: TBitBtn;
    btClean: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mmDescribeChange(Sender: TObject);
    procedure PopUpMenuAddItemClick(Sender: TObject);
    procedure PopUpMenuDeleteItemClick(Sender: TObject);
    procedure mmDescribeProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure btClearClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure pgDelaySelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure pgDelayClick(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    procedure SetSaved(AValue:boolean);

    procedure fInitGrid;
    procedure fFillCodeZ;
    procedure SetMsgTextPopupItems;
    function CursorOnKeyWord : boolean;
    procedure fSaveData(Lang,Code_Z,PV,Text:string);
  public
    { Public declarations }
    LangList :TLangList;
    EditMsgMode : integer;
    DelayList:TDelayList;
    ItemsArray : array of string;
    property NotSaved: boolean read fNotSaved write SetSaved;
  end;

implementation

uses uDelayEdit;

{$R *.dfm}

{ ***** TLangList ***** }

procedure TLangList.fSetCount(fValue:integer);
begin
  fCount:=fValue;
  SetLength(fItems,fCount);
end;

procedure TLangList.fAddLang(ID_Lang:integer; Lang:string);
var
  L:TOneLang;
begin
  L.ID_lang:=ID_Lang;
  L.Lang:=Lang;
  Count:=Count+1;
  fItems[Count-1]:=L;
end;

procedure TLangList.LoadLanguages(cbx:TComboBox);
const
  SQLText = 'select ID, Caption from dbo.ANN_LANGUAGES (nolock)';
var
  i:integer;
begin
  Count:=0;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not EOF do
    begin
      fAddLang(FieldByName('ID').AsInteger, FieldByName('Caption').AsString);
      Next;  
    end;
  finally
    Free;
  end;
  cbx.Clear;
  for i:=0 to Count-1 do
    cbx.Items.Add(fItems[i].Lang);  
end;

function TLangList.GetLangID(Lang:string):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to Count-1 do
  begin
    if fItems[i].Lang = Lang then
    begin
      result:=fItems[i].ID_lang;
      break;
    end;
  end;
end;

{ ***** TDelayList ***** }

procedure TDelayList.fSetCount(fValue:integer);
begin
  fCount:=fValue;
  SetLength(fItems,fValue);
end;

procedure TDelayList.fAddDelay(ID:integer;SHORT_TITLE,PRICH:string; ID_Lang:integer; Lang,PV:string; Default:boolean);
var
  OD:TOneDelay;
begin
  OD.ID := ID;
  OD.SHORT_TITLE := SHORT_TITLE;
  OD.PRICH := PRICH;
  OD.ID_Lang := ID_Lang;
  OD.Lang := Lang;
  OD.Default := Default;
  OD.PV := PV;
  OD.Act := -1; 
  Count:=Count+1;
  fItems[Count-1]:=OD;
end;

procedure TDelayList.fLoadDelays;
const
  SQLText = 'select r.ID, SHORT_TITLE, dbo.fnANN_ConstCaption(PRICH,1) PRICH, l.id as id_lang, l.caption as lang, pv,  [Default] '+
            'from dbo.ANN_DELAY_REASONS r (nolock) left join dbo.ANN_LANGUAGES l (nolock) on r.ID_Lang = l.id order by [Default] desc, PRICH asc, ID_Lang asc';
begin
  Count:=0;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      fAddDelay(FieldByName('ID').AsInteger,
                FieldByName('SHORT_TITLE').AsString, FieldByName('PRICH').AsString,
                FieldByName('id_lang').AsInteger, FieldByName('lang').AsString,
                FieldByName('pv').AsString, FieldByName('Default').AsBoolean);
      next;
    end;
  finally
    Free;
  end;
end;

procedure TDelayList.fShowDelays(pg:TProfGrid);
var
  i,r,c:integer;
begin
  pg.RowCount:=1;
  for i:=0 to fCount-1 do
  begin
    r:=pg.RowCount;
    pg.RowCount:=r+1;
    pg.HiddenCols[0].Cells[r].Value:=fItems[i].ID;
    pg.Cells[0,r].Text:=fItems[i].SHORT_TITLE;
    pg.Cells[1,r].Text:=fItems[i].Lang;
    pg.Cells[2,r].Text:=fItems[i].PV;
    pg.Cells[3,r].Text:=fItems[i].PRICH;
  end;
end;

procedure TDelayList.Refresh(pg:TProfGrid);
begin
  fLoadDelays;
  fShowDelays(pg);
end;

function TDelayList.GetDelayByID(ID:integer):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to fCount-1 do
  begin
    if fItems[i].ID = ID then
    begin
      result:=i;
      break;
    end;
  end;
end;

function TDelayList.GetDelayByName(Name:string):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to fCount-1 do
  begin
    if fItems[i].SHORT_TITLE = Name then
    begin
      result:=i;
      break;
    end;
  end;
end;

{ ***** TfmDelayReason ***** }

procedure TfmDelayReason.SetSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
  begin
    Caption:='Шаблон задержек ***';
  end
  else
  begin
    btSave.Font.Color:=clMenuHighlight;
    btSave.Font.Style:=[];
    Caption:='Шаблон задержек';
  end;
end;

procedure TfmDelayReason.fInitGrid;
const
  captions:array[0..3] of string = ('Название','Язык','Нарпавление','Причина');
var
  i:integer;
begin
  pgDelay.HideColumn(0);
  for i:=0 to 3 do
  begin
    pgDelay.Cells[i,0].Text:=captions[i];
    pgDelay.Cells[i,0].TextAlignment:=taCenter;
    pgDelay.Cells[i,0].Font.Style:=[fsBold];  
    pgDelay.Cols[i].ReadOnly:=true;
    pgDelay.Cols[i].TextAlignment:=taCenter;      
  end;
end;

procedure TfmDelayReason.fFillCodeZ;
const
  SQLText = 'select distinct short_title '+
            'from dbo.ANN_Delay_Reasons (nolock) '+
            'where ISNULL(short_title,'''')<>'''' order by 1';
begin
  cbxCODE_Z.Clear;
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    while not Eof do
    begin
      cbxCODE_Z.Items.Add(FieldByName('short_title').AsString);
      Next;
    end;
  finally
    Free;
    cbxCODE_Z.ItemIndex:=-1; 
  end;
end;

procedure TfmDelayReason.SetMsgTextPopupItems;
var SP : TADOStoredProc;
    NewItem: TMenuItem;
    i : integer;
begin
    pmMsgText.Items.Clear;

    i := 0;
    SP := TADOStoredProc.Create(nil);
    with SP do
    try
        Connection := DM.con;
        ProcedureName := 'dbo.spANN_ConstList';
        Parameters.Refresh;
        Open;

        SetLength(ItemsArray, 0);
        while not Eof do
        begin
            SetLength(ItemsArray, i + 1);
            NewItem := TMenuItem.Create(pmMsgText);
            pmMsgText.Items.Add(NewItem);
            // NewItem.Action :=  ActPopUpMenuAddItem;
            NewItem.OnClick := PopUpMenuAddItemClick;
            NewItem.Caption := SP.Fields.FieldByName('caption').AsString;
            NewItem.Tag := i;
            ItemsArray[i] := SP.Fields.FieldByName('caption').AsString;

            i := i + 1;
            Next;
        end;

        NewItem := TMenuItem.Create(pmMsgText);
        pmMsgText.Items.Add(NewItem);
        // NewItem.Action := ActPopUpMenuDeleteItem;
        NewItem.OnClick := PopUpMenuDeleteItemClick;
        NewItem.Tag := i;
        NewItem.Caption := 'Удалить';
    finally
        Free;
    end;
end;

function TfmDelayReason.CursorOnKeyWord : boolean;
var KeyWordPos, i, CurPos, res : integer;
begin
    result := False;

    CurPos := mmDescribe.SelStart;

    // Проверка положения курсора (AllowChange = false - на ключ.слове)
    for i := 0 to High(ItemsArray) do
    begin
        KeyWordPos := PosEx(ItemsArray[i], mmDescribe.Text);

        while KeyWordPos > 0 do
        begin
            if (KeyWordPos <= CurPos) and (KeyWordPos + Length(ItemsArray[i]) - 2 >= CurPos) then
            begin
                result := True;
                break;
            end;

            if result then break;

            KeyWordPos := PosEx(ItemsArray[i], mmDescribe.Text, KeyWordPos + 1);
        end;
    end;
end;



procedure TfmDelayReason.PopUpMenuAddItemClick(Sender: TObject);
var Str1, Str2 : string;
    CurPos : integer;
begin
    try
        EditMsgMode := 1; //Признак вставки

        Str1 := (Sender as TMenuItem).Caption;
        with Sender as TMenuItem do
        begin
            CurPos := mmDescribe.SelStart;
            Str1 := copy(mmDescribe.Text, 1, mmDescribe.SelStart);
            Str2 := copy(mmDescribe.Text, mmDescribe.SelStart + 1,
                        length(mmDescribe.Text) - mmDescribe.SelStart);

            mmDescribe.Text := Str1 + ItemsArray[Tag] + Str2;
            if Length(mmDescribe.Text) > Length(Str1 + Str2) then
                mmDescribe.SelStart := CurPos + Length(ItemsArray[Tag]);
        end;
        notSaved:=true;
    finally
        EditMsgMode := 0;
    end;
end;

procedure TfmDelayReason.PopUpMenuDeleteItemClick(Sender: TObject);
var Str1, Str2 : string;
    CurPos, KeyWordPos, i : integer;
begin
    // если позиция курсора на ключевом слове, редактирование невозможно.
    try
        EditMsgMode := 2; //Признак удаления

        Str1:=mmDescribe.SelText;                                  //2907210 Романов А.Н.
        i:=pmMsgText.Items.IndexOf(pmMsgText.Items.Find(Str1));
        if i<>-1 then mmDescribe.SelText:='';
        notSaved:=true;
    finally
        EditMsgMode := 0;
    end;
end;


procedure TfmDelayReason.FormShow(Sender: TObject);
begin
  SetMsgTextPopupItems;
  LangList:=TLangList.Create; 
  DelayList:=TDelayList.Create;
  fFillCodeZ;
  fInitGrid;
  LangList.LoadLanguages(cbxLang);
  DelayList.Refresh(pgDelay);
  NotSaved:=false;
end;

procedure TfmDelayReason.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LangList.Free; 
  DelayList.Free;
end;

procedure TfmDelayReason.mmDescribeChange(Sender: TObject);
var Str1, Str2 : string;
    CurPos, KeyWordPos, i : integer;
begin
  if trim(mmDescribe.Text)='' then exit;
    CurPos := mmDescribe.SelStart;
    // если позиция курсора на ключевом слове, редактирование невозможно.
    for i := 0 to High(ItemsArray) do
    begin
        KeyWordPos := PosEx(ItemsArray[i], mmDescribe.Text);

        while KeyWordPos > 0 do
        begin
            mmDescribe.SelStart := KeyWordPos - 1;
            mmDescribe.SelLength := length(ItemsArray[i]);
            mmDescribe.SelAttributes.Color := clRed;
            mmDescribe.SelAttributes.Protected := True;
            notSaved:=false;
            KeyWordPos := PosEx(ItemsArray[i], mmDescribe.Text, KeyWordPos + 1);
        end;
    end;
    mmDescribe.SelStart := CurPos;
    notSaved:=true;
end;

procedure TfmDelayReason.mmDescribeProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
   if trim(mmDescribe.Text)='' then
   begin
     AllowChange := True;
     exit;
   end;
    if not mmDescribe.Focused then
        AllowChange := True
    else
    if (mmDescribe.Focused)
    and ((not CursorOnKeyWord) and (EditMsgMode = 1)) then
        AllowChange := True
    else
    if EditMsgMode = 2 then
        AllowChange := True
    else AllowChange := False;
end;

procedure TfmDelayReason.btClearClick(Sender: TObject);
begin
//  cbxCODE_Z.ItemIndex:=-1;
  mmDescribe.Clear;
  notSaved:=true; 
end;

procedure TfmDelayReason.fSaveData(Lang,Code_Z,PV,Text:string);
var
  asp:TADOStoredProc;
begin
  if Lang='' then
  begin
    HSMessageDlg('Не указан язык!',mtError,[mbOK],0);
    exit;
  end;
  if Code_Z='' then
  begin
    HSMessageDlg('Не указана причина задержки!',mtError,[mbOK],0);
    exit;
  end;
  Screen.Cursor:=crHourGlass;
  try
    asp:=TADOStoredProc.Create(nil);
    asp.Connection:=DM.con;
    asp.ProcedureName:='dbo.spANN_EditDelay';
    with asp.Parameters do
    begin
        Refresh;
        ParamByName('@Act').Value:=iif(trim(Text)='',0,1);
        ParamByName('@SHORT_TITLE').Value:=Code_Z;
        ParamByName('@PRICH').Value:=Text;
        ParamByName('@ID_Lang').Value:=LangList.GetLangID(Lang);
        ParamByName('@pv').Value:=PV;
        ParamByName('@Cop').Value:=AppInfo.AccessLogin;
    end;
    asp.ExecProc;
  finally
    asp.Free;
    Screen.Cursor:=crDefault;
  end;
  notSaved:=false;
  fFillCodeZ;
  DelayList.Refresh(pgDelay);

  HSMessageDlg('Изменения сохранены',mtInformation,[mbOK],0);
end;

procedure TfmDelayReason.btSaveClick(Sender: TObject);
var
  asp:TADOStoredProc;
begin
  if cbxLang.ItemIndex = -1 then
  begin
    HSMessageDlg('Выберите язык!',mtError,[mbOK],0);
    cbxLang.SetFocus;
    exit;
  end;
  if trim(cbxCode_Z.Text)='' then
  begin
    HSMessageDlg('Укажите название причины задержки!',mtError,[mbOK],0);
    cbxCode_Z.SetFocus;
    exit;
  end;
  Screen.Cursor:=crHourGlass;
  try
    asp:=TADOStoredProc.Create(nil);
    asp.Connection:=DM.con;
    asp.ProcedureName:='dbo.spANN_EditDelay';
    with asp.Parameters do
    begin
        Refresh;
        ParamByName('@Act').Value:=iif(trim(mmDescribe.Text)='',0,1);
        ParamByName('@SHORT_TITLE').Value:=cbxCode_Z.Text;
        ParamByName('@PRICH').Value:=mmDescribe.Text;
        ParamByName('@ID_Lang').Value:=LangList.GetLangID(cbxLang.Text);
        ParamByName('@pv').Value:=IfThen(rbDir.ItemIndex = 0,'В','П');
        ParamByName('@Cop').Value:=AppInfo.AccessLogin;
    end;
    asp.ExecProc;
  finally
    asp.Free;
    Screen.Cursor:=crDefault;
  end;
  notSaved:=false;
  fFillCodeZ;
  DelayList.Refresh(pgDelay);

  HSMessageDlg('Изменения сохранены',mtInformation,[mbOK],0);

end;

procedure TfmDelayReason.pgDelaySelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
{var
  OD:TOneDelay;
  i,id:integer;}
begin
{  id:=pgDelay.HiddenCols[0].Cells[ARow].Value;
  i:=DelayList.GetDelayByID(id);
  cbxCode_Z.ItemIndex:=cbxCode_z.Items.IndexOf(DelayList.fItems[i].SHORT_TITLE);
  mmDescribe.Text:=DelayList.fItems[i].PRICH;
  chbxDefault.Checked:=DelayList.fItems[i].Default;
  cbxLang.ItemIndex:=cbxLang.Items.IndexOf(DelayList.fItems[i].Lang);
  notSaved:=false;}
end;

procedure TfmDelayReason.Timer2Timer(Sender: TObject);
begin
  if notSaved then
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
    end
  end;
end;

procedure TfmDelayReason.pgDelayClick(Sender: TObject);
var
  OD:TOneDelay;
  i,id:integer;
begin
  id:=pgDelay.HiddenCols[0].Cells[pgDelay.Row].Value;
  i:=DelayList.GetDelayByID(id);
  cbxCode_Z.ItemIndex:=cbxCode_z.Items.IndexOf(DelayList.fItems[i].SHORT_TITLE);
  mmDescribe.Text:=DelayList.fItems[i].PRICH;
  cbxLang.ItemIndex:=cbxLang.Items.IndexOf(DelayList.fItems[i].Lang);
  if DelayList.fItems[i].PV = 'В' then rbDir.ItemIndex:=0 else rbDir.ItemIndex:=1;    
  notSaved:=false;
end;

procedure TfmDelayReason.acAddExecute(Sender: TObject);
begin
  with TDelayEdit.Create(nil) do
  try
    Caption:='Новый шаблон задержки';
    InitForm;
    LangList.LoadLanguages(cbxLang);
    ShowModal;
    if Saved then
      fSaveData(cbxLang.Text, cbxCode_Z.Text,
                IfThen(rbDir.ItemIndex = 0,'В','П'),
                mmDescribe.Text);
  finally
    Free;
  end;
end;

procedure TfmDelayReason.acEditExecute(Sender: TObject);
begin
  with TDelayEdit.Create(nil) do
  try
    Caption:='Редактировать шаблон задержки';
    InitForm;
    LangList.LoadLanguages(cbxLang);
    cbxCode_z.ItemIndex:=Self.cbxCode_Z.ItemIndex;
    cbxLang.ItemIndex:=Self.cbxLang.ItemIndex;
    mmDescribe.Text:=Self.mmDescribe.Text;
    ShowModal;
    if Saved then
      fSaveData(cbxLang.Text, cbxCode_Z.Text,
                IfThen(rbDir.ItemIndex = 0,'В','П'),
                mmDescribe.Text);
  finally
    Free;
  end;
end;

procedure TfmDelayReason.acDeleteExecute(Sender: TObject);
begin
  if HSMessageDlg('Очистить выбранный шаблон?',mtWarning,[mbYes,mbNo],0) = mrNo then exit;
  fSaveData(cbxLang.Text, cbxCode_Z.Text,
                IfThen(rbDir.ItemIndex = 0,'В','П'),
                '');
end;

end.
