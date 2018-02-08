unit uTemplates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, SqlTree, ExtCtrls, RzPanel, RzSplit, uDM,
  StdCtrls, RzEdit;

type
  TfmTemplates = class(TForm)
    RzSplitter1: TRzSplitter;
    st: TSqlTree;
    RzSplitter2: TRzSplitter;
    mmText: TRzMemo;
    procedure FormCreate(Sender: TObject);
    procedure stBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure stChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTemplates: TfmTemplates;

implementation

{$R *.dfm}

uses Utils;

procedure TfmTemplates.FormCreate(Sender: TObject);
begin
  DM.spTemplates.Open;
  DM.spTemplates.Close;  
end;

procedure TfmTemplates.stBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  BigGrad, SmallGrad: TRect;
  _p: PSqlTreeEntry;
begin
  if not Assigned(Node) then exit;
  _p:=st.GetNodeData(Node);
  if (Column = 0) and (Node.Parent=Sender.RootNode) then
  begin
    // Рисуем фон градиентный фон в стиле заголовка Студии
    BigGrad := CellRect;
    Dec(BigGrad.Bottom, 2);
    SmallGrad := BigGrad;
    SmallGrad.Top := SmallGrad.Bottom;
    Inc(SmallGrad.Bottom, 2);
    GradFill(TargetCanvas.Handle, BigGrad, clSkyBlue, clWindow, gkHorz);
    GradFill(TargetCanvas.Handle, SmallGrad, clBlack, clWindow, gkHorz);
  end
  else if (Column = 0) and (Node.Parent.Parent=Sender.RootNode) and (_p^.txt^[1]='0') then
  begin
    // Рисуем фон градиентный фон в стиле заголовка Студии
    BigGrad := CellRect;
    Dec(BigGrad.Bottom, 2);
    SmallGrad := BigGrad;
    SmallGrad.Top := SmallGrad.Bottom;
    Inc(SmallGrad.Bottom, 2);
    GradFill(TargetCanvas.Handle, BigGrad, clMoneyGreen, clWindow, gkHorz);
    GradFill(TargetCanvas.Handle, SmallGrad, clBlack, clWindow, gkHorz);
  end;

end;

procedure TfmTemplates.stChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  _p: PSqlTreeEntry;
begin
  if not Assigned(Node) then exit;
  _p:=st.GetNodeData(Node);
  if _p^.txt^[1]='1' then
  begin
    mmText.Text:=_p^.txt^[2];
  end
  else
  begin
    mmText.Clear;
  end;
end;


end.
