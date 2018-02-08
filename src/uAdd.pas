unit uAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ToolEdit, ExtCtrls, Grids, ProfGrid,
  DB, ADODB;

type
TAdd = record
      i : integer;
      BDATE, EDATE : TDateTime;
      local, international, OUTfly, INfly: integer;
    end;
  TForm1 = class(TForm)
    gbReisFilter: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    rgShed: TRadioGroup;
    deBegin: TDateEdit;
    deEnd: TDateEdit;
    rgDirect: TRadioGroup;
    BitBtn2: TBitBtn;
    ADOStoredProc1: TADOStoredProc;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    sbAirCompanyAdd: TSpeedButton;
    sbAirCompanyDel: TSpeedButton;
    Label8: TLabel;
    sbAirportAdd: TSpeedButton;
    sbAirportDel: TSpeedButton;
    Label6: TLabel;
    sbTypeVSAdd: TSpeedButton;
    sbTypeVSDel: TSpeedButton;
    Label4: TLabel;
    lbCompanyList: TListBox;
    lbAirList: TListBox;
    lbTypeVSList: TListBox;
    eComments: TEdit;



    procedure Save;
    procedure BitBtn2Click(Sender: TObject);
  private
  Add : TAdd;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uDM;

{$R *.dfm}

procedure Tform1.Save;

 var AD : TADOStoredProc;

begin

  add.BDATE := deBegin.Date;
  add.EDATE := deEnd.Date;
  add.local := rgShed.ItemIndex;
  add.outfly := rgDirect.ItemIndex;
  add.i := 2;


 AD :=TADOStoredProc.Create(nil);
 with AD  do
            try
             Connection := DM.con;
             ProcedureName := 'dbo.spANN_MyFirstProcedure';
             Parameters.Refresh;

             Parameters.ParamByName('@ID').Value := 5;
             Parameters.ParamByName('@raspisanie').Value := add.local;
             Parameters.ParamByName('@napravlenie').Value := add.OUTfly;


             Parameters.ParamByName('@Period_c').Value := add.BDATE;
             Parameters.ParamByName('@Period_po').Value := add.EDATE;
             ExecProc;

         finally
            Free;
         end;


end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
 save;
end;

end.
