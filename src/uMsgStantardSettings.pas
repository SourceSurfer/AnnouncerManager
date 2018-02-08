unit uMsgStantardSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ADODB, Grids, ProfGrid, Buttons, ExtCtrls, RzPanel,HSDialogs,
  Menus, ActnList,StrUtils, ComCtrls, IniFiles, Spin,
  uCheckinTempl;

const
  LogMsgEdit = 'Редактирование стандартного сообщения на %s языке для события: %s';

type
  TfmMsgStantardSettings = class(TForm)
    gpMsgList: TGroupBox;
    mpgStandart: TProfGrid;
    gpText: TGroupBox;
    msgText: TRichEdit;
    pmMsgText: TPopupMenu;
    ActionList1: TActionList;
    ActPopUpMenuDeleteItem: TAction;
    PopUpMenuAddItem: TAction;
    gpFilter: TGroupBox;
    Label1: TLabel;
    cbxEvent: TComboBox;
    Label2: TLabel;
    cbxLang: TComboBox;
    btFilter: TBitBtn;
    btFilterClear: TBitBtn;
    Timer2: TTimer;
    Label3: TLabel;
    cbxVR: TComboBox;
    Panel1: TPanel;
    btSave: TBitBtn;
    btClear: TBitBtn;
    Splitter1: TSplitter;
    gbVPSettings: TGroupBox;
    Label4: TLabel;
    spAfter: TSpinEdit;
    Label5: TLabel;
    spDelta: TSpinEdit;
    acMsgMenu: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    btAdd: TBitBtn;
    btEdit: TBitBtn;
    btClean: TBitBtn;
    acCheckinTemplate: TAction;
    btCheckinTempl: TBitBtn;
    procedure PopUpMenuAddItemClick(Sender: TObject);
    procedure PopUpMenuDeleteItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure mpgStandartSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btSaveClick(Sender: TObject);
    procedure msgTextChange(Sender: TObject);
    procedure msgTextProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btFilterClearClick(Sender: TObject);
    procedure btFilterClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acCheckinTemplateExecute(Sender: TObject);
  private
    { Private declarations }
    fNotSaved:boolean;
    function CursorOnKeyWord : boolean;
    procedure SetSaved(AValue:boolean);
    function fGetChangeVPname:string;
  public
    { Public declarations }
    FilterCondition:string;
    EditMsgMode : integer;
    ItemsArray : array of string;
    procedure InitGrids;
    procedure FillTemplList;
    procedure SetMsgTextPopupItems;
    function BuildFilterCondition:string;
    procedure LoadFilterCondition;
    procedure SaveFilterCondition;
    procedure PrepareFilterSettings;
    procedure SetMainFunctionsDisabled;
    property NotSaved: boolean read fNotSaved write SetSaved;
    procedure SaveData(Event,Lang:string; VR:boolean; Text:string; After,Delta:integer);
  end;

var
  F:TIniFile;

implementation

{$R *.dfm}

uses uDM, uTemplateEdit, Utils,intf_access;




procedure TfmMsgStantardSettings.SetSaved(AValue:boolean);
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

function TfmMsgStantardSettings.fGetChangeVPname:string;
const
  SQLText = 'select TOP 1 caption  from dbo.ANN_EVENTS (nolock) where event = 22 and used = 1';
begin
  with TADOQuery.Create(nil) do
  try
    Connection:=DM.con;
    SQL.Text:=SQLText;
    Open;
    result:=Fields[0].AsString;   
  finally
    Free;
  end;
end;

procedure TfmMsgStantardSettings.SetMainFunctionsDisabled;
var
  E:boolean;
begin
  E:=IsAccess('ANN_EditStandartMess','kobra_ann');
  btSave.Enabled:=E;
end;

procedure TfmMsgStantardSettings.InitGrids;
const
  _captions:array[0..3] of string = ('Событие','Язык','Расписание','Текст сообщения');
var
  i:integer;
begin
  with mpgStandart do
  begin
    ColCount:=10;
    for i:=1 to 6 do
      HideColumn(0);
    for i:=0 to VisibleColCount-1 do
    begin
      Cells[i,0].TextAlignment:=taCenter;
      Cells[i,0].TextLayout:=tlCenter;
      Cols[i].TextAlignment:=taCenter;
      Cols[i].TextLayout:=tlCenter;

      Cells[i,0].Value:=_captions[i];
    end;
    Cols[0].Width:=100;
    Cols[1].Width:=85;
    Cols[2].Width:=110;
    Cols[3].Width:=1000;
  end;
end; 

procedure TfmMsgStantardSettings.FillTemplList;   // Заполняем список стандартных сообщений
var
  itm:integer;
  c:boolean;
begin
  mpgStandart.RowCount:=1;
  
  with TADOQuery.Create(nil) do
  try
    Connection := DM.con;
    SQL.Text:='SELECT TOP 1000 id_event,id_lang,Ecaption,Lcaption,mtext,vr, vp, after, delta '+
              'FROM dbo.vANN_GetTemplates (nolock) '+FilterCondition;
    Open;

    while not Eof do
    begin
       itm:= mpgStandart.RowCount;
       mpgStandart.RowCount:= mpgStandart.RowCount+1;

       mpgStandart.HiddenCols[0].Cells[itm].Value:=FieldByName('id_event').AsString;
       mpgStandart.HiddenCols[1].Cells[itm].Value:=FieldByName('id_lang').AsString;
       mpgStandart.HiddenCols[2].Cells[itm].Value:=FieldByName('vr').AsString;
       mpgStandart.HiddenCols[3].Cells[itm].Value:=FieldByName('vp').AsBoolean;
       mpgStandart.HiddenCols[4].Cells[itm].Value:=FieldByName('after').AsInteger;
       mpgStandart.HiddenCols[5].Cells[itm].Value:=FieldByName('delta').AsInteger;

       mpgStandart.Cells[0,itm].Value:=FieldByName('Ecaption').AsString;
       mpgStandart.Cells[1,itm].Value:=FieldByName('Lcaption').AsString;
       mpgStandart.Cells[2,itm].Value:=iif(FieldByName('vr').AsString='Ц','Внутреннее','Международное');
       mpgStandart.Cells[3,itm].Value:=FieldByName('mtext').AsString;

       Next;
    end;
    c:=true;
    if mpgStandart.RowCount>1 then
      mpgStandartSelectCell(nil,0,1,c);
  finally
    Free;
  end;

end;

procedure TfmMsgStantardSettings.SetMsgTextPopupItems; 
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

function TfmMsgStantardSettings.BuildFilterCondition:string;
const
  VR:array[1..2] of string = ('Ц','M');
begin
  result:='';
  if cbxEvent.ItemIndex>0 then
    result:='Ecaption = '+#39+cbxEvent.Text+#39;
  if cbxLang.ItemIndex>0 then
    result:=iif(result='','',result+' and ')+'Lcaption = '+#39+cbxLang.Text+#39;
  if cbxVR.ItemIndex>0 then
    result:=iif(result='','',result+' and ')+'VR = '+#39+VR[cbxVR.ItemIndex]+#39;
  if result<>'' then
    result:='WHERE '+result;  
end;

procedure TfmMsgStantardSettings.LoadFilterCondition;
begin
  cbxEvent.ItemIndex:=F.ReadInteger('FilterSettings','StdEvent',0);
  cbxLang.ItemIndex:=cbxLang.Items.IndexOf(F.ReadString('FilterSettings','StdLang','русский'));     //F.ReadInteger('FilterSettings','StdLang',0);
  cbxVR.ItemIndex:=F.ReadInteger('FilterSettings','StdVR',0);
end;

procedure TfmMsgStantardSettings.SaveFilterCondition;
begin
  F.WriteInteger('FilterSettings','StdEvent',cbxEvent.ItemIndex);
  F.WriteString('FilterSettings','StdLang',cbxLang.Text);
  F.WriteInteger('FilterSettings','Std',cbxVR.ItemIndex);
end;

procedure TfmMsgStantardSettings.PrepareFilterSettings;
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

      List.Insert(0,'Все');
    finally
      Free;
    end;
  end;

begin
  FillList(ffEvent,cbxEvent.Items);
  FillList(ffLang,cbxLang.Items);
end;


procedure TfmMsgStantardSettings.PopUpMenuAddItemClick(Sender: TObject);
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

procedure TfmMsgStantardSettings.PopUpMenuDeleteItemClick(Sender: TObject);
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
        {CurPos := MsgText.SelStart;

        for i := 0 to High(ItemsArray) do
        begin
            KeyWordPos := PosEx(ItemsArray[i], MsgText.Text);

            while KeyWordPos > 0 do
            begin
                if (KeyWordPos <= CurPos) and (KeyWordPos + Length(ItemsArray[i]) - 2 >= CurPos) then
                begin
                    // Нашли слово под курсором - удаляем его
                    Str1 := copy(MsgText.Text, 1, KeyWordPos - 1);
                    Str2 := copy(MsgText.Text, KeyWordPos + length(ItemsArray[i]), length(MsgText.Text));
                    MsgText.Text := Str1 + Str2;
                    MsgText.SelStart := KeyWordPos - 1;
                    exit;
                end;

                KeyWordPos := PosEx(ItemsArray[i], MsgText.Text, KeyWordPos + 1);
            end;
        end;  }
    finally
        EditMsgMode := 0;
    end;
end;


procedure TfmMsgStantardSettings.FormShow(Sender: TObject);
var
  cs:boolean;
begin
  SetMainFunctionsDisabled;
  SetMsgTextPopupItems;
  PrepareFilterSettings;
  F:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'AnnManager.ini');
  LoadFilterCondition;
  FilterCondition:=BuildFilterCondition;
  InitGrids;
  FillTemplList;

  cs:=true;
  mpgStandart.Row:=1;
  mpgStandartSelectCell(Sender,0,mpgStandart.Row,cs);
  EditMsgMode := 0;
  NotSaved:=false;
end;

procedure TfmMsgStantardSettings.btClearClick(Sender: TObject);
begin
  msgText.Lines.Clear;
  notSaved:=true; 
end;

procedure TfmMsgStantardSettings.mpgStandartSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  msgText.Text:=mpgStandart.Cells[3,ARow].Text;
  gbVPSettings.Visible:=mpgStandart.HiddenCols[3].Cells[ARow].Value;
  spAfter.Value:=mpgStandart.HiddenCols[4].Cells[ARow].Value;
  spDelta.Value:=mpgStandart.HiddenCols[5].Cells[ARow].Value;
  notSaved:=false; 
end;

procedure TfmMsgStantardSettings.btSaveClick(Sender: TObject);   // Меняем текст сообщения
var
  CurrRow,Del, idevent:integer;
  SAfter,SBefore:string;
  SLang:string;

  function GetIdEvent:integer;
  const
    SQLText = 'select id  from dbo.ANN_EVENTS (nolock) where caption = %s';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text := Format(SQLText,[#39+cbxEvent.Text+#39]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

  function GetIdLang:integer;
  const
    SQLText = 'select id  from dbo.ANN_Languages (nolock) where caption like %s';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text := Format(SQLText,[#39+'%'+cbxLang.Text+'%'+#39]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

  function GetVR:string;
  const
    VR:array[0..2] of string =('','Ц','M');
  begin
    result:=VR[cbxVR.ItemIndex];
  end;

begin
  Del:=0;
  if mpgStandart.RowCount>1 then
  begin
    CurrRow:=mpgStandart.Row;
    SBefore:=mpgStandart.Cols[3].Cells[CurrRow].Text;
  end
  else
  begin
    CurrRow:=-1;
    SBefore:='';
  end;
  SAfter:=msgText.Text;
  SLang:=cbxLang.Text;
  delete(SLang,length(SLang)-1,2);
  SLang:=SLang+'ом';
  if HSMessageDlg('Изменить текст сообщения?',mtConfirmation,[mbYes,mbNo],0)=mrNo then
  begin
    msgText.Text:=mpgStandart.Cells[3,CurrRow].Text;
    exit;
  end;
  if CurrRow<>-1 then
    if trim(msgText.Text)=mpgStandart.Cells[3,CurrRow].Text then exit;
  if trim(msgText.Text)='' then
    Del:=HSMessageDlg('Текст сообщения пустой! '+#10+
                      'Нажмите Yes - если хотите удалить это сообщение'+#10+
                      'Нажмите Cancel - если хотите отказаться от изменений текста сообщения',
                      mtConfirmation,[mbYes,mbNo,mbCancel],0);
  if Del=mrCancel then
  begin
    msgText.Text:=mpgStandart.Cells[3,CurrRow].Text;
    exit;
  end;
  if Del=mrYes then begin Del:=1; SAfter:='Сообщение удалено'; end
  else Del:=0;

  with TADOStoredProc.Create(nil) do
  try
    Connection := DM.con;
    ProcedureName := 'dbo.spANN_ChangeStandartMessage';
    Parameters.Refresh;

    if CurrRow = -1 then
    begin
      idevent:=GetIdEvent;
      Parameters.ParamByName('@id_event').Value := idevent;
      Parameters.ParamByName('@id_lang').Value := GetIdLang;
      Parameters.ParamByName('@vr').Value := GetVR;
      Parameters.ParamByName('@vp').Value := gbVPSettings.Visible;
      Parameters.ParamByName('@after').Value := spAfter.Value;
      Parameters.ParamByName('@delta').Value := spDelta.Value;
      //ShowMessage('id_event = '+IntToStr(GetIdEvent)+#13#10+'id_lang = '+IntToStr(GetIdLang)+#13#10+'vr = '+GetVR);
    end
    else
    begin
      Parameters.ParamByName('@id_event').Value := mpgStandart.HiddenCols[0].Cells[CurrRow].Value;
      Parameters.ParamByName('@id_lang').Value := mpgStandart.HiddenCols[1].Cells[CurrRow].Value;
      Parameters.ParamByName('@vr').Value := mpgStandart.HiddenCols[2].Cells[CurrRow].Value;
      Parameters.ParamByName('@vp').Value := mpgStandart.HiddenCols[3].Cells[CurrRow].Value;
      Parameters.ParamByName('@after').Value := mpgStandart.HiddenCols[4].Cells[CurrRow].Value;
      Parameters.ParamByName('@delta').Value := mpgStandart.HiddenCols[5].Cells[CurrRow].Value;
    end;
    Parameters.ParamByName('@mtext').Value := msgText.Text;
    Parameters.ParamByName('@COP').Value := DM.COP;
    Parameters.ParamByName('@del').Value := Del;

    ExecProc;
    if Parameters.ParamByName('@RETURN_VALUE').Value=-1 then
    begin
      HSMessageDlg('Ошибка редактирования текста сообщения! Обратитесь к разработчикам.',mtError,[mbOk],0);
      if SAfter='Сообщение удалено' then
        SAfter:='Ошибка удаления сообщения'
      else
        SAfter:='Ошибка редактирования текста сообщения';
    end
    else
    begin
      FillTemplList;//FormShow(Sender);
      mpgStandart.Row:=iif(CurrRow=-1,0,CurrRow);
      notSaved:=false;
    end;

    DM.AddToLog(Format(LogMsgEdit,[SLang,cbxEvent.Text]),SBefore,SAfter);
  finally
    Free;
  end;
end;

procedure TfmMsgStantardSettings.msgTextChange(Sender: TObject);
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

function TfmMsgStantardSettings.CursorOnKeyWord : boolean;
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


procedure TfmMsgStantardSettings.msgTextProtectChange(Sender: TObject;
  StartPos, EndPos: Integer; var AllowChange: Boolean);
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

procedure TfmMsgStantardSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFilterCondition;
  F.Free; 
end;

procedure TfmMsgStantardSettings.btFilterClearClick(Sender: TObject);
begin
  cbxEvent.ItemIndex:=0;
  cbxLang.ItemIndex:=0;
  FilterCondition:=BuildFilterCondition;
  FillTemplList;
end;

procedure TfmMsgStantardSettings.btFilterClick(Sender: TObject);
begin
  FilterCondition:=BuildFilterCondition;
  FillTemplList;
end;

procedure TfmMsgStantardSettings.Timer2Timer(Sender: TObject);
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

procedure TfmMsgStantardSettings.acAddExecute(Sender: TObject);
begin
  with TfmTemplateEdit.Create(nil) do
  try
    ChangeVPEvent:=fGetChangeVPname;
    Caption:='Новый шаблон';
    InitForm;
    ShowModal;
    if Saved then
    begin
      SaveData(cbxEvent.Text,
               cbxLang.Text,
               cbxVR.ItemIndex = 0,
               msgText.Text,
               spAfter.Value,
               spDelta.Value);
      HSMessageDlg('Шаблон добавлен',mtInformation,[mbOK],0);
    end;
  finally
    Free;
  end;
end;

procedure TfmMsgStantardSettings.acEditExecute(Sender: TObject);
var
  r:integer;
begin
  r:=mpgStandart.Row;
  if r=0 then exit; 
  with TfmTemplateEdit.Create(nil) do
  try
    ChangeVPEvent:=fGetChangeVPname;
    Caption:='Редактировать шаблон';
    InitForm;
    cbxEvent.ItemIndex:=cbxEvent.Items.IndexOf(mpgStandart.Cells[0,r].Text);
    cbxLang.ItemIndex:=cbxLang.Items.IndexOf(mpgStandart.Cells[1,r].Text);
    cbxVR.ItemIndex:=iif(mpgStandart.Cells[2,r].Text='Внутреннее',0,1);
    msgText.Text:=mpgStandart.Cells[3,r].Text;   
    ShowModal;
    if Saved then
    begin
      SaveData(cbxEvent.Text,
               cbxLang.Text,
               cbxVR.ItemIndex = 0,
               msgText.Text,
               spAfter.Value,
               spDelta.Value);
      HSMessageDlg('Шаблон отредактирован',mtInformation,[mbOK],0);
    end;
  finally
    Free;
  end;
end;

procedure TfmMsgStantardSettings.acDeleteExecute(Sender: TObject);
begin
  if HSMessageDlg('Очистить шаблон?',mtWarning,[mbYes,mbNo],0)=mrNo then exit;
  SaveData(cbxEvent.Text,
           cbxLang.Text,
           cbxVR.ItemIndex = 0,
           msgText.Text,
           spAfter.Value,
           spDelta.Value);
  HSMessageDlg('Шаблон очищен',mtInformation,[mbOK],0); 
end;

procedure TfmMsgStantardSettings.SaveData(Event,Lang:string; VR:boolean; Text:string; After,Delta:integer);
var
  CurrRow,Del, idevent:integer;
  SAfter,SBefore:string;
  SLang:string;

  function GetIdEvent:integer;
  const
    SQLText = 'select id  from dbo.ANN_EVENTS (nolock) where caption = %s';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text := Format(SQLText,[#39+Event+#39]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

  function GetIdLang:integer;
  const
    SQLText = 'select id  from dbo.ANN_Languages (nolock) where caption like %s';
  begin
    with TADOQuery.Create(nil) do
    try
      Connection:=DM.con;
      SQL.Text := Format(SQLText,[#39+'%'+Lang+'%'+#39]);
      Open;
      result:=Fields[0].AsInteger;
    finally
      Free;
    end;
  end;

  function GetVR:string;
  const
    //VR:array[0..2] of string =('','Ц','M');
    cVR:array[boolean] of string = ('M','Ц');
  begin
    result:=cVR[VR];
  end;

begin
  Del:=0;
  SAfter:=Text;
  SLang:=Lang;
  delete(SLang,length(SLang)-1,2);
  SLang:=SLang+'ом';
  if trim(Text)='' then
  begin
    Del:=1;
    SAfter:='Сообщение удалено';
  end;
  with TADOStoredProc.Create(nil) do
  try
    Connection := DM.con;
    ProcedureName := 'dbo.spANN_ChangeStandartMessage';
    with Parameters do
    begin
      Refresh;
      idevent:=GetIdEvent;
      Parameters.ParamByName('@id_event').Value := idevent;
      Parameters.ParamByName('@id_lang').Value := GetIdLang;
      Parameters.ParamByName('@vr').Value := GetVR;
      Parameters.ParamByName('@vp').Value := ((After<>0) and (Delta<>0));
      Parameters.ParamByName('@after').Value := After;
      Parameters.ParamByName('@delta').Value := Delta;
      Parameters.ParamByName('@mtext').Value := Text;
      Parameters.ParamByName('@COP').Value := DM.COP;
      Parameters.ParamByName('@del').Value := Del;
    end;
    ExecProc;
    if Parameters.ParamByName('@RETURN_VALUE').Value=-1 then
    begin
      HSMessageDlg('Ошибка редактирования текста сообщения! Обратитесь к разработчикам.',mtError,[mbOk],0);
      if SAfter='Сообщение удалено' then
        SAfter:='Ошибка удаления сообщения'
      else
        SAfter:='Ошибка редактирования текста сообщения';
    end
    else
    begin
      FillTemplList;//FormShow(Sender);
      mpgStandart.Row:=iif(CurrRow=-1,0,CurrRow);
      notSaved:=false;
    end;
    DM.AddToLog(Format(LogMsgEdit,[SLang,cbxEvent.Text]),SBefore,SAfter);
  finally
    Free;
  end;

{  if mpgStandart.RowCount>1 then
  begin
    CurrRow:=mpgStandart.Row;
    SBefore:=mpgStandart.Cols[3].Cells[CurrRow].Text;
  end
  else
  begin
    CurrRow:=-1;
    SBefore:='';
  end;
  SAfter:=msgText.Text;
  SLang:=cbxLang.Text;
  delete(SLang,length(SLang)-1,2);
  SLang:=SLang+'ом';
  if HSMessageDlg('Изменить текст сообщения?',mtConfirmation,[mbYes,mbNo],0)=mrNo then
  begin
    msgText.Text:=mpgStandart.Cells[3,CurrRow].Text;
    exit;
  end;
  if CurrRow<>-1 then
    if trim(msgText.Text)=mpgStandart.Cells[3,CurrRow].Text then exit;
  if trim(msgText.Text)='' then
    Del:=HSMessageDlg('Текст сообщения пустой! '+#10+
                      'Нажмите Yes - если хотите удалить это сообщение'+#10+
                      'Нажмите Cancel - если хотите отказаться от изменений текста сообщения',
                      mtConfirmation,[mbYes,mbNo,mbCancel],0);
  if Del=mrCancel then
  begin
    msgText.Text:=mpgStandart.Cells[3,CurrRow].Text;
    exit;
  end;
  if Del=mrYes then begin Del:=1; SAfter:='Сообщение удалено'; end
  else Del:=0;

  with TADOStoredProc.Create(nil) do
  try
    Connection := DM.con;
    ProcedureName := 'dbo.spANN_ChangeStandartMessage';
    Parameters.Refresh;

    if CurrRow = -1 then
    begin
      idevent:=GetIdEvent;
      Parameters.ParamByName('@id_event').Value := idevent;
      Parameters.ParamByName('@id_lang').Value := GetIdLang;
      Parameters.ParamByName('@vr').Value := GetVR;
      Parameters.ParamByName('@vp').Value := gbVPSettings.Visible;
      Parameters.ParamByName('@after').Value := spAfter.Value;
      Parameters.ParamByName('@delta').Value := spDelta.Value;
      //ShowMessage('id_event = '+IntToStr(GetIdEvent)+#13#10+'id_lang = '+IntToStr(GetIdLang)+#13#10+'vr = '+GetVR);
    end
    else
    begin
      Parameters.ParamByName('@id_event').Value := mpgStandart.HiddenCols[0].Cells[CurrRow].Value;
      Parameters.ParamByName('@id_lang').Value := mpgStandart.HiddenCols[1].Cells[CurrRow].Value;
      Parameters.ParamByName('@vr').Value := mpgStandart.HiddenCols[2].Cells[CurrRow].Value;
      Parameters.ParamByName('@vp').Value := mpgStandart.HiddenCols[3].Cells[CurrRow].Value;
      Parameters.ParamByName('@after').Value := mpgStandart.HiddenCols[4].Cells[CurrRow].Value;
      Parameters.ParamByName('@delta').Value := mpgStandart.HiddenCols[5].Cells[CurrRow].Value;
    end;
    Parameters.ParamByName('@mtext').Value := msgText.Text;
    Parameters.ParamByName('@COP').Value := DM.COP;
    Parameters.ParamByName('@del').Value := Del;

    ExecProc;
    if Parameters.ParamByName('@RETURN_VALUE').Value=-1 then
    begin
      HSMessageDlg('Ошибка редактирования текста сообщения! Обратитесь к разработчикам.',mtError,[mbOk],0);
      if SAfter='Сообщение удалено' then
        SAfter:='Ошибка удаления сообщения'
      else
        SAfter:='Ошибка редактирования текста сообщения';
    end
    else
    begin
      FillTemplList;//FormShow(Sender);
      mpgStandart.Row:=iif(CurrRow=-1,0,CurrRow);
      notSaved:=false;
    end;

    DM.AddToLog(Format(LogMsgEdit,[SLang,cbxEvent.Text]),SBefore,SAfter);
  finally
    Free;
  end;   }
end;

procedure TfmMsgStantardSettings.acCheckinTemplateExecute(Sender: TObject);
begin
  with TfmCheckinTempl.Create(nil) do
  try
    IniForm;
    ShowModal;
  finally
    Free;
  end;
end;

end.
