unit uTemplateEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, StdCtrls, ComCtrls, Buttons, ExtCtrls, ActnList, ADODB, Menus,
  Spin;

type
  TfmTemplateEdit = class(TForm)
    gbParams: TGroupBox;
    Label1: TLabel;
    cbxEvent: TComboBox;
    Label2: TLabel;
    cbxLang: TComboBox;
    Label3: TLabel;
    cbxVR: TComboBox;
    gbMsgText: TGroupBox;
    msgText: TRichEdit;
    pnlMenu: TPanel;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    acList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    pmMsgText: TPopupMenu;
    Timer2: TTimer;
    gbVPSettings: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    spAfter: TSpinEdit;
    spDelta: TSpinEdit;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure PopUpMenuAddItemClick(Sender: TObject);
    procedure PopUpMenuDeleteItemClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure msgTextProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure msgTextChange(Sender: TObject);
    procedure cbxEventChange(Sender: TObject);
  private
    { Private declarations }
    fSaved:boolean;
    fNotSaved:boolean;
    ItemsArray : array of string;
    EditMsgMode : integer;
    fChangeVPEvent: string;

    procedure SetSaved(AValue:boolean);
    procedure fFillParams;
    procedure SetMsgTextPopupItems;
    function CursorOnKeyWord : boolean;
  public
    { Public declarations }
    property Saved: boolean read fSaved;
    property NotSaved: boolean read fNotSaved write SetSaved;
    property ChangeVPEvent: string read fChangeVPEvent write fChangeVPEvent;
    procedure InitForm;
  end;

implementation

uses uDM;

{$R *.dfm}

procedure TfmTemplateEdit.SetSaved(AValue:boolean);
begin
  fNotSaved:=AValue;
  if fNotSaved then
  begin
    Caption:='Редактирование стандартных сообщений ***';
  end
  else
  begin
    btSave.Font.Color:=clMenuHighlight;
    btSave.Font.Style:=[];
    Caption:='Редактирование стандартных сообщений';
  end;
end;

procedure TfmTemplateEdit.fFillParams;
type
  TFieldFilter = (ffEvent,ffLang);

  procedure FillList(Fld:TFieldFilter;List:TStrings);
  const
    SQLSelect = 'select distinct(%s) from %s (nolock) %s';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;

      case Fld of
      ffLang: SQL.Text:=Format(SQLSelect,['caption','dbo.ANN_LANGUAGES','']);
      ffEvent: SQL.Text:=Format(SQLSelect,['caption','dbo.ANN_EVENTS','where used=1']);
      end;

      Open;

      List.Clear;
      while not Eof do
      begin
        List.Add(Fields[0].AsString);
        Next;
      end;
      
    finally
      Free;
    end;    
  end;

begin
  FillList(ffEvent,cbxEvent.Items);
  FillList(ffLang,cbxLang.Items);
end;

procedure TfmTemplateEdit.acCancelExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmTemplateEdit.acSaveExecute(Sender: TObject);
begin
  fSaved:=true;
  Close;
end;


procedure TfmTemplateEdit.PopUpMenuAddItemClick(Sender: TObject);
var Str1, Str2 : string;
    CurPos : integer;
begin
    try
        EditMsgMode := 1; //Признак вставки

        Str1 := (Sender as TMenuItem).Caption;
        with Sender as TMenuItem do
        begin
            CurPos := MsgText.SelStart;
            Str1 := copy(MsgText.Text, 1, MsgText.SelStart);
            Str2 := copy(MsgText.Text, MsgText.SelStart + 1,
                        length(MsgText.Text) - MsgText.SelStart);

            MsgText.Text := Str1 + ItemsArray[Tag] + Str2;
            if Length(MsgText.Text) > Length(Str1 + Str2) then
                MsgText.SelStart := CurPos + Length(ItemsArray[Tag]);
        end;
        notSaved:=true;
    finally
        EditMsgMode := 0;
    end;
end;

procedure TfmTemplateEdit.PopUpMenuDeleteItemClick(Sender: TObject);
var Str1, Str2 : string;
    CurPos, KeyWordPos, i : integer;
begin
    // если позиция курсора на ключевом слове, редактирование невозможно.
    try
        EditMsgMode := 2; //Признак удаления

        Str1:=MsgText.SelText;                                  //2907210 Романов А.Н.
        i:=pmMsgText.Items.IndexOf(pmMsgText.Items.Find(Str1));
        if i<>-1 then MsgText.SelText:='';
        notSaved:=true;

    finally
        EditMsgMode := 0;
    end;
end;


procedure TfmTemplateEdit.SetMsgTextPopupItems; 
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
            if pos('задержке', SP.Fields.FieldByName('caption').AsString)>0 then
            begin
              next;
              continue;
            end;
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


procedure TfmTemplateEdit.Timer2Timer(Sender: TObject);
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

function TfmTemplateEdit.CursorOnKeyWord : boolean;
var KeyWordPos, i, CurPos, res : integer;
begin
    result := False;

    CurPos := MsgText.SelStart;

    // Проверка положения курсора (AllowChange = false - на ключ.слове)
    for i := 0 to High(ItemsArray) do
    begin
        KeyWordPos := PosEx(ItemsArray[i], MsgText.Text);

        while KeyWordPos > 0 do
        begin
            if (KeyWordPos <= CurPos) and (KeyWordPos + Length(ItemsArray[i]) - 2 >= CurPos) then
            begin
                result := True;
                break;
            end;

            if result then break;

            KeyWordPos := PosEx(ItemsArray[i], MsgText.Text, KeyWordPos + 1);
        end;
    end;
end;


procedure TfmTemplateEdit.msgTextProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
   if trim(MsgText.Text)='' then
   begin
     AllowChange := True;
     exit;
   end;
    if not MsgText.Focused then
        AllowChange := True
    else
    if (MsgText.Focused)
    and ((not CursorOnKeyWord) and (EditMsgMode = 1)) then
        AllowChange := True
    else
    if EditMsgMode = 2 then
        AllowChange := True
    else AllowChange := False;
end;

procedure TfmTemplateEdit.msgTextChange(Sender: TObject);
var Str1, Str2 : string;
    CurPos, KeyWordPos, i : integer;
begin
  if trim(MsgText.Text)='' then exit;
    CurPos := MsgText.SelStart;
    // если позиция курсора на ключевом слове, редактирование невозможно.
    for i := 0 to High(ItemsArray) do
    begin
        KeyWordPos := PosEx(ItemsArray[i], MsgText.Text);

        while KeyWordPos > 0 do
        begin
            MsgText.SelStart := KeyWordPos - 1;
            MsgText.SelLength := length(ItemsArray[i]);
            MsgText.SelAttributes.Color := clRed;
            MsgText.SelAttributes.Protected := True;
            notSaved:=false;

            KeyWordPos := PosEx(ItemsArray[i], MsgText.Text, KeyWordPos + 1);
        end;
    end;
    MsgText.SelStart := CurPos;
    notSaved:=true;
end;

procedure TfmTemplateEdit.cbxEventChange(Sender: TObject);
begin
  gbVPSettings.Visible:=cbxEvent.Text = fChangeVPEvent; 
end;

procedure TfmTemplateEdit.InitForm;
begin
  fSaved:=false;
  fFillParams;
  SetMsgTextPopupItems;
  cbxEventChange(nil);
end;

end.
