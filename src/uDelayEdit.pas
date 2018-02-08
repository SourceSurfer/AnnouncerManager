unit uDelayEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, Menus, StdCtrls, ComCtrls, Buttons, ADODB,
  StrUtils;

type
  TDelayEdit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbxCode_Z: TComboBox;
    mmDescribe: TRichEdit;
    chbxDefault: TCheckBox;
    cbxLang: TComboBox;
    rbDir: TRadioGroup;
    pmMsgText: TPopupMenu;
    ActionList1: TActionList;
    PopUpMenuAddItem: TAction;
    ActPopUpMenuDeleteItem: TAction;
    Timer2: TTimer;
    pnlMenu: TPanel;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    acList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    procedure PopUpMenuAddItemClick(Sender: TObject);
    procedure PopUpMenuDeleteItemClick(Sender: TObject);
    procedure mmDescribeChange(Sender: TObject);
    procedure mmDescribeProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure acSaveExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
  private
    { Private declarations }
    fSaved:boolean;
    fNotSaved:boolean;
    EditMsgMode : integer;
    ItemsArray : array of string;
    procedure SetSaved(AValue:boolean);
    procedure SetMsgTextPopupItems;
    function CursorOnKeyWord : boolean;
    procedure fFillCodeZ;
  public
    { Public declarations }
    property Saved: boolean read fSaved;
    property NotSaved: boolean read fNotSaved write SetSaved;
    procedure InitForm;
  end;


implementation

uses uDM;

{$R *.dfm}

procedure TDelayEdit.SetSaved(AValue:boolean);
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

procedure TDelayEdit.fFillCodeZ;
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

procedure TDelayEdit.SetMsgTextPopupItems;
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

function TDelayEdit.CursorOnKeyWord : boolean;
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

procedure TDelayEdit.PopUpMenuAddItemClick(Sender: TObject);
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

procedure TDelayEdit.PopUpMenuDeleteItemClick(Sender: TObject);
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


procedure TDelayEdit.mmDescribeChange(Sender: TObject);
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

procedure TDelayEdit.mmDescribeProtectChange(Sender: TObject; StartPos,
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

procedure TDelayEdit.InitForm;
begin
  fSaved:=false;
  SetMsgTextPopupItems;
  fFillCodeZ;
  NotSaved:=false;
end;

procedure TDelayEdit.acSaveExecute(Sender: TObject);
begin
  fSaved:=true;
  Close;
end;

procedure TDelayEdit.acCancelExecute(Sender: TObject);
begin
  Close;
end;

end.
