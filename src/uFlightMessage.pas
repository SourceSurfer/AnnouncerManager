unit uFlightMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzButton, ExtCtrls, RzPanel, ImgList,
  RzDlgBtn, GGVMaskEdit, Buttons, ActnList, ADODB;

type
  TfmFlightMessage = class(TForm)
    RzPanel1: TRzPanel;
    RzDialogButtons1: TRzDialogButtons;
    gbReg: TRzGroupBox;
    meRB: TGGVMaskEdit;
    meRE: TGGVMaskEdit;
    tbR1: TRzToolbarButton;
    RzToolbarButton2: TRzToolbarButton;
    RzToolbarButton3: TRzToolbarButton;
    RzToolbarButton4: TRzToolbarButton;
    cbRegAuto: TCheckBox;
    gbExit: TRzGroupBox;
    cbE1: TRzToolbarButton;
    cbE2: TRzToolbarButton;
    cbE3: TRzToolbarButton;
    cbE4: TRzToolbarButton;
    meEB: TGGVMaskEdit;
    meEE: TGGVMaskEdit;
    cbExitAuto: TCheckBox;
    ActionList1: TActionList;
    acCreateMessRegExit: TAction;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acCreateMessRegExitExecute(Sender: TObject);
  private
    FArrDep: Boolean;
    FIndex: Integer;
    Fx, Fy: Integer;
  public
    constructor Create(bArrDep: Boolean; AIndex: Integer); reintroduce;
  end;

var
  fmFlightMessage: TfmFlightMessage;

implementation

{$R *.dfm}

uses uDM, uStruct;

{ TfmFlightMessage }

constructor TfmFlightMessage.Create(bArrDep: Boolean; AIndex: Integer);
begin
  inherited Create(nil);
  FArrDep:=bArrDep;
  FIndex:=AIndex;
  cbRegAuto.Checked:=DM.ListFD.Items[AIndex].bRegAuto;
  cbExitAuto.Checked:=DM.ListFD.Items[AIndex].bExitAuto;  
  meRB.Text:=FormatDateTime('hh:mm',DM.ListFD.Items[AIndex].dtRB);
  meRE.Text:=FormatDateTime('hh:mm',DM.ListFD.Items[AIndex].dtRE);
  meEB.Text:=FormatDateTime('hh:mm',DM.ListFD.Items[AIndex].dtEB);
  meEE.Text:=FormatDateTime('hh:mm',DM.ListFD.Items[AIndex].dtEE);
end;

procedure TfmFlightMessage.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
{
  IF ssLeft in Shift then
  begin
    Left:=Fx-X;
    Top:=Fy-Y;
  end;
}
end;

procedure TfmFlightMessage.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{
  Fx:=X;
  Fy:=Y;
}
end;

procedure TfmFlightMessage.acCreateMessRegExitExecute(Sender: TObject);
var
  _i: Integer;
  _sp: TADOStoredProc;
begin
  DM.ListFD.Items[FIndex].bRegAuto:=cbRegAuto.Checked;
  DM.ListFD.Items[FIndex].bExitAuto:=cbExitAuto.Checked;
  for _i:=0 to gbReg.ControlCount-1 do
    if (gbReg.Controls[_i] is TRzToolbarButton) then
      if (gbReg.Controls[_i] as TRzToolbarButton).Down then
        DM.ListFD.Items[FIndex].Event:=TDepEvents((gbReg.Controls[_i] as TRzToolbarButton).Tag);
  _sp:=TADOStoredProc.Create(nil);
  try
//    _sp.ProcedureName:='[dbo].[spANN_LoadMessList]';
//    _sp.Parameters.Refresh;
//    _sp.Parameters[0].Value:=
  finally
    _sp.Free;
  end;
end;

end.
