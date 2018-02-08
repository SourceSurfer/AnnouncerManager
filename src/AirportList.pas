unit AirportList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, VirtualTrees, {SqlTree,} ExtCtrls, Grids, ProfGrid,
  StdCtrls, Utils,HSDialogs;

type
  TfmAirportList = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOK: TButton;
    btCancel: TButton;
    pgParamList: TProfGrid;
    Panel3: TPanel;
    Label1: TLabel;
    mmSelectedAPs: TMemo;
    spAirportList: TADOStoredProc;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    CaptionPanel: TPanel;
    gpSearch: TGroupBox;
    mSearch: TMemo;
    procedure pgParamListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mSearchChange(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    FormSP : TADOStoredProc;
    GridString : string;
    KeyNum, ValNum : integer;
    procedure PaintLine(AIndex: integer;AFonColor, AtextColor:TColor);
    procedure ShowGrid;
    { Private declarations }
  public
    { Public declarations }
    class function MyShowModal (AList : TStrings; ARect : TRect;
                                ASP : TADOStoredProc; GP : TGridProc;
                                GridCaption : string) : integer; 
    class function MyShowModal1 (AList : TStrings; ARect : TRect;
                                ASP : TADOStoredProc; GP : TGridProc;
                                GridCaption : string) : integer;
  end;

implementation

uses uDM, Types;

{$R *.dfm}

procedure TfmAirportList.ShowGrid;
var i, FormLen : integer;
begin
    with FormSP do
    try
        Open;

        pgParamList.RowCount := 1;

        CaptionPanel.Caption := GridString;

        for i := 1 to pgParamList.ColCount - 1 do
        begin
            pgParamList.Cells[i, 0].Text := FormSP.Fields[i - 1].FieldName;
            pgParamList.Cells[i, 0].WordWrap := false;
        end;

        if not Eof then
        begin
            KeyNum := FormSP.FieldByName('KeyNum').AsInteger;
            ValNum := FormSP.FieldByName('ValNum').AsInteger;
        end;

        pgParamList.ColCount := FormSP.Fields.Count + 1 - 2; // -2 - 2 последних поля, с номерами ключа и значения для списка
         
        while not Eof do
        begin
            pgParamList.RowCount := pgParamList.RowCount + 1;
            pgParamList.Cells[0, pgParamList.RowCount - 1].CheckBox := True;

            for i := 1 to pgParamList.ColCount - 1 do
            begin
                pgParamList.Cells[i, pgParamList.RowCount - 1].Text := FormSP.Fields[i - 1].AsString;
                pgParamList.Cells[i, pgParamList.RowCount - 1].WordWrap := false;
            end;

            Next;
        end;

        pgParamList.AutoSizeColumns;
        pgParamList.Cols[0].Width := 20;

        FormLen := 0;
        for i := 0 to pgParamList.ColCount - 1 do
            FormLen := FormLen + pgParamList.Cols[i].Width;

        if pgParamList.RowCount >= 12 then
            self.Height := self.Height + pgParamList.DefaultRowHeight * 12 + pgParamList.GridLineWidth * 12 - pgParamList.ClientHeight + 10
        else
            self.Height := self.Height + pgParamList.DefaultRowHeight * pgParamList.RowCount
                            + pgParamList.GridLineWidth * pgParamList.RowCount - pgParamList.Height + 3;

        self.Width := FormLen + 27;

        btCancel.Left := self.ClientWidth - btCancel.Width - 15;
    finally
        Close;
    end;
end;

procedure TfmAirportList.PaintLine(AIndex:integer; AFonColor, AtextColor:TColor);
var i:integer;
begin
  for i := 0 to pgParamList.ColCount - 1 do
  begin
      pgParamList.Cells[i, AIndex].Color := AFonColor;
      pgParamList.Cells[i, AIndex].Font.Color := AtextColor;
  end;
end;

procedure TfmAirportList.pgParamListClick(Sender: TObject);
var i : integer;
begin
    if (pgParamList.Col = 0) then
        pgParamList.Cells[0, pgParamList.Row].CheckBoxChecked :=
            not pgParamList.Cells[0, pgParamList.Row].CheckBoxChecked;

    if pgParamList.Cells[0, pgParamList.Row].CheckBoxChecked then
        PaintLine(pgParamList.Row, clTeal, clAqua );
//    else PaintLine(pgParamList.Row, clWindow, clWindowText );

    mmSelectedAPs.Text := '';

    for i := 1 to pgParamList.RowCount - 1 do
    begin
        if pgParamList.Cells[0, i].CheckBoxChecked then
            mmSelectedAPs.Text := mmSelectedAPs.Text + pgParamList.Cells[ValNum, i].Text + '; ';
    end;
end;

class function TfmAirportList.MyShowModal (AList : TStrings; ARect : TRect;
                                            ASP : TADOStoredProc; GP : TGridProc;
                                            GridCaption : string) : integer;
var fmAirportList : TfmAirportList;
    pnt : TPoint;
    i : integer;
begin
    Result := 0;

    pnt := ARect.TopLeft;
    fmAirportList := TfmAirportList.Create(nil);

    with fmAirportList do
    try
        FormSP := ASP;
        GridString := GridCaption;
        if Assigned(GP) then GP(pgParamList); // Ф-ция обратного вызова для доп. настроек
        ShowGrid;

        // Если возможно поместить справа внизу
        if (pnt.X + (ARect.Right - ARect.Left) + Width < Screen.Width) and (pnt.Y + Height < Screen.Height) then
        begin
            Left := pnt.X + (ARect.Right - ARect.Left);
            Top := pnt.y;
        end
        else
        // Если возможно поместить справа вверху
        if (pnt.X + Width < Screen.Width) and (pnt.Y - Height > 0) then
        begin
            Left := pnt.X;
            Top := pnt.Y - Height;
        end
        else
        // Если возможно поместить слева внизу
        if (pnt.X - Width > 0) and (pnt.Y + Height < Screen.Height) then
        begin
            Left := pnt.X - Width;
            Top := pnt.Y;
        end
        else
        // Если возможно поместить слева вверху
        if (pnt.X - Width > 0) and (pnt.Y - Height > 0) then
        begin
            Left := pnt.X - Width;
            Top := pnt.y - Height;
        end;

        //загрузить галочки из листа AList
        mmSelectedAPs.Text := '';
        for i := 1 to pgParamList.RowCount - 1 do
        begin
            // pgParamList.Cells[0, i].CheckBoxChecked := AList.Values[pgParamList.Cells[2, i].Text] <> '';
            pgParamList.Cells[0, i].CheckBoxChecked := AList.Values[pgParamList.Cells[KeyNum, i].Text] <> '';

            if pgParamList.Cells[0, i].CheckBoxChecked then
            begin
                mmSelectedAPs.Text := mmSelectedAPs.Text + pgParamList.Cells[ValNum, i].Text + '; ';
                PaintLine(i, clTeal, clAqua);
            end
            else
                // PaintLine(i, clWindow, clWindowText);
                PaintLine(i, clGradientInactiveCaption, clWindowText);
        end;

        if ShowModal = mrOk then
        begin
            Result := 1;
            // записать все в лист AList
            AList.Clear;
            for i := 1 to pgParamList.RowCount - 1 do
            if pgParamList.Cells[0, i].CheckBoxChecked then
                AList.Values[pgParamList.Cells[KeyNum, i].Text] := pgParamList.Cells[ValNum, i].Text;
        end;
    finally
        Free;
    end;
end;

class function TfmAirportList.MyShowModal1 (AList : TStrings; ARect : TRect;
                                            ASP : TADOStoredProc; GP : TGridProc;
                                            GridCaption : string) : integer;
var fmAirportList : TfmAirportList;
    pnt : TPoint;
    i : integer;
begin
    Result := 0;

    pnt := ARect.TopLeft;
    fmAirportList := TfmAirportList.Create(nil);

    with fmAirportList do
    try
        FormSP := ASP;
        GridString := GridCaption;
        if Assigned(GP) then GP(pgParamList); // Ф-ция обратного вызова для доп. настроек
        ShowGrid;

        // Если возможно поместить справа внизу
        if (pnt.X + (ARect.Right - ARect.Left) + Width < Screen.Width) and (pnt.Y + Height < Screen.Height) then
        begin
            Left := pnt.X + (ARect.Right - ARect.Left);
            Top := pnt.y;
        end
        else
        // Если возможно поместить справа вверху
        if (pnt.X + Width < Screen.Width) and (pnt.Y - Height > 0) then
        begin
            Left := pnt.X;
            Top := pnt.Y - Height;
        end
        else
        // Если возможно поместить слева внизу
        if (pnt.X - Width > 0) and (pnt.Y + Height < Screen.Height) then
        begin
            Left := pnt.X - Width;
            Top := pnt.Y;
        end
        else
        // Если возможно поместить слева вверху
        if (pnt.X - Width > 0) and (pnt.Y - Height > 0) then
        begin
            Left := pnt.X - Width;
            Top := pnt.y - Height;
        end;

        //загрузить галочки из листа AList
        mmSelectedAPs.Text := '';
        for i := 1 to pgParamList.RowCount - 1 do
        begin
            // pgParamList.Cells[0, i].CheckBoxChecked := AList.Values[pgParamList.Cells[2, i].Text] <> '';
            pgParamList.Cells[0, i].CheckBoxChecked := AList.IndexOf(pgParamList.Cells[3, i].Text)>-1;//  Values[pgParamList.Cells[3, i].Text] <> '';

            if pgParamList.Cells[0, i].CheckBoxChecked then
            begin
                mmSelectedAPs.Text := mmSelectedAPs.Text + pgParamList.Cells[ValNum, i].Text + '; ';
                PaintLine(i, clTeal, clAqua);
            end
            else
                // PaintLine(i, clWindow, clWindowText);
                PaintLine(i, clGradientInactiveCaption, clWindowText);
        end;

        if ShowModal = mrOk then
        begin
            Result := 1;
            // записать все в лист AList
            AList.Clear;
            for i := 1 to pgParamList.RowCount - 1 do
            if pgParamList.Cells[0, i].CheckBoxChecked then
                AList.Values[pgParamList.Cells[KeyNum, i].Text] := pgParamList.Cells[ValNum, i].Text;
        end;
    finally
        Free;
    end;
end;


procedure TfmAirportList.btCancelClick(Sender: TObject);
begin

end;

procedure TfmAirportList.btOKClick(Sender: TObject);
begin

end;

procedure TfmAirportList.FormShow(Sender: TObject);
begin
  SetFocus;
end;

procedure TfmAirportList.mSearchChange(Sender: TObject);
var fo : TFindOptions;
    Col : integer;
    OldRow:integer;
begin
  pgParamList.DisableControls;
  OldRow:=pgParamList.Row;
  pgParamList.Row:=1;
  Col:=pgParamList.ColCount-1;
  fo:=[frDown];
  if (not pgParamList.FindEx(mSearch.Text, fo, Col)) and (not(trim(mSearch.Text)=''))  then
  begin
    HSMessageDlg('Наименование не найдено',mtWarning,[mbOk],0);
    pgParamList.Row:=OldRow;
  end;
  pgParamList.EnableControls;
end;

end.


