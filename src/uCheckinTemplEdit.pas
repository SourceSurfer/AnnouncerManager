unit uCheckinTemplEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons;

type
  TfmCheckinTemplEdit = class(TForm)
    Label1: TLabel;
    cbxServClass: TComboBox;
    Label2: TLabel;
    cbxLang: TComboBox;
    Label3: TLabel;
    mmText: TMemo;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    acList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure mmTextChange(Sender: TObject);
  private
    { Private declarations }
    fSaved:boolean;
    fAllowSave:boolean;
    procedure fSetAllowSave(fValue:boolean);
  public
    { Public declarations }
    property Saved:boolean read fSaved;
    property AllowSave:boolean read fAllowSave write fSetAllowSave;
  end;


implementation

{$R *.dfm}

procedure TfmCheckinTemplEdit.fSetAllowSave(fValue:boolean);
begin
  fAllowSave:=fValue;
  acSave.Enabled:=fValue;
end;

procedure TfmCheckinTemplEdit.acCancelExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmCheckinTemplEdit.acSaveExecute(Sender: TObject);
begin
  fSaved:=true;
  Close;
end;

procedure TfmCheckinTemplEdit.mmTextChange(Sender: TObject);
begin
  AllowSave:=(trim(mmText.Text)<>'') and (cbxlang.ItemIndex>-1)
             and (cbxServClass.ItemIndex>-1);   
end;

end.
