unit EventSettingsDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid, StdCtrls, Buttons,
  ExtCtrls, RzBorder, dxLayoutContainer, cxGridCustomLayoutView,
  cxGridLayoutView, ADODB, ComCtrls;

type
  TTfmEventSettingsDemo = class(TForm)
    gbReisList: TGroupBox;
    Panel2: TPanel;
    grTemplGridDBTableView1: TcxGridDBTableView;
    grTemplGridLevel1: TcxGridLevel;
    grTemplGrid: TcxGrid;
    grTemplGridDBTableView1Column1: TcxGridDBColumn;
    grTemplGridDBTableView1Column2: TcxGridDBColumn;
    grTemplGridDBTableView1Column3: TcxGridDBColumn;
    grTemplGridDBTableView1Column4: TcxGridDBColumn;
    grTemplGridDBTableView1Column5: TcxGridDBColumn;
    ADOStoredProc1: TADOStoredProc;
    DataSource1: TDataSource;
    Edit1: TEdit;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Procedure myFirstProc(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  TfmEventSettingsDemo: TTfmEventSettingsDemo;

implementation

uses uMain, uDM;

{$R *.dfm}



Procedure TTfmEventSettingsDemo.myFirstProc(Sender: TObject);
begin
 // grTemplGrid.Views[grTemplGridDBTableView1]
end;



end.
