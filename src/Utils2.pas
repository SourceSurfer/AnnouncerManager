unit Utils2;

interface

uses
  SysUtils, Math, //PlanningMain,
  Classes, Graphics, Windows, StdCtrls, ADODB,
  ComCtrls, VirtualTrees, variants;

type
  TPeriods = record
    rNN: TDateTime;
    rKN: TDateTime;
    rCD: string[7];
  end;

  TFlightForRecalc = record
    rPeriods: array of TPeriods;//periods of perfoming
  end;

  TLeg = record
    UL   : string[1];
    VR   : string[1];
    AP1  : string[3];
    AP2  : string[3];
    DTA1 : TDateTime;
    DTA2 : TDateTime;
    VO   : string[4];
    VP   : string[4];
    PO   : integer;
    PP   : integer;
  end;

  TTypeTable = (ttFormaR, // ����� �
                ttRPL); // RPL

  TScale = array of Boolean;//scale of performing the flight

  TarDTAs = array of TDateTime;

    // ��������� ��� ����� VirtualSmallTree
    TDataArray = array of Variant;

    PDataInfo = ^TDataInfo;
    TDataInfo = record
        id,
        NodeName : String;
        ImageIndex,
        SelectedIndex : integer;
        parent_id : String;
        checked : integer;
        ExData : TDataArray; // �������������� ������
    end;

    PSeasonInfo = ^TSeasonInfo;
    TSeasonInfo = record
        idn : string[6];
        BeginDate,
        EndDate : TDateTime;
        Caption : string[30];
    end;

    TComboBoxData = record
        id : string[20];
        text : string[50];
    end;
    PComboBoxData = ^TComboBoxData;

  TNewProc = procedure(p : pointer); // RIVC_Navbatov 03.06.2009
  TNewObjProc = procedure(p : pointer) of object; // RIVC_Navbatov 28.08.2009
  TParamProc = procedure(var Params : array of OleVariant) of object;
const
  CRLF = #13#10;

function CheckCD(cSTR: string): string; forward;         //�-��� ��� �������� ������� �������� (1234567)
function RoundMin(cMin: integer): integer; forward;      //�-��� ��� ���������� ����� �� 5 � 0
function APExists(cAP, cVR: string): boolean; forward;   //��������� ���� ������ �/� � �����������
                                                         //port_n ��� ���. �� 3-� ����. ����.
function GetICAOFlight(cNR: string): string; forward;   //�-��� �������������� ������ ����� IATA
                                                        //� ����� ����� ICAO

function GetICAO_M_Flight(cNR: string): string; forward;   //�-��� �������������� ������ ����� IATA
                                                           //� ����� ����� ICAO (����. �/� �������)

function GetIATAFlight(cNR: string): string; forward;   //�-��� �������������� ������ ����� ICAO
                                                        //� ����� ����� IATA

{*** �-��� �������������� ������ ����� UG � ����� ����� IATA ***}
function GetIATAFlightFromUG(cNR: string): string; forward;

{*** �-��� �������������� ������ ����� ICAO � ����� ����� IATA ***}
{*** ��� SCR � ������ �/� ������� ***}
function GetIATAFlightForSCR(cNR: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� ���� �� � 4-� ����. ����. ***}
function GetLSOType(cTS: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� ���� �� � 4-� ����. ���. ***}
function GetLSO_RUSType(cTS: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� ���� �� � NAME_TYP (�����.)  ��154� ***}
function GetNameTypRus(cTS: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� ���� �� � NAME_M (����.)  TU-154 ***}
function GetNameTypEng(cTS: string): string; forward;

{*** �-��� �������������� 4-� ����. ���� ���� �� � 3-� ����. ***}
function GetIATAType(cTS: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � 4-� ����. ��� ����***}
function GetICAOAP(cAP: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � 4-� ����. ��� ����***}
function GetIATAAP(cAP: string): string; forward;

{*** �-��� �������������� 4-� ����. ���� �/� ICAO � 3-� ����. ��� ��� ***}
function GetCRTAP(cAP: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � 4-� ����. ��� ���� ***}
function GetAFTNAP(cAP: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� '������� (����)' ***}
function GetAPForFormaR(cAP: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'ST.PETERSBURG (ULLI)' ***}
function GetAPForFormaR_ENG(cAP: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� '�������(LICC-������)' ***}
function GetAPForGSGA_Planning(cAP: string): string;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'ST.PETERSBURG (ULLI)' ***}
function GetAP_CForIRRegRequestFormat(cAP: string): string; forward;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'LARNACA' (NL) ***}
function GetAP_NL(cAP: string): string;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� '�������' (NAME_AP) ***}
function GetNAME_AP(cAP: string; Rpls: boolean): string;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'STOCKHOLM(ARLANDA)' (NL PORT_N) ***}
function GetEnglishNAME_AP(cAP: string): string;

{*** �-��� ��� �������� ��������������� �������� ***}
function CheckForOverlapping(PerArray: array of TPeriod): boolean; forward;

{*** ���������� ���� ������, ������������ �� ������� ***}
function GetDayOfWeek(cDTA: TDateTime): integer;

{*** build the scale of performing the flight ***}
procedure ScaleBuilder(var aFlight: TFlightForRecalc);

{*** turn the scale into complete periods ***}
procedure PeriodsMaker(var aFlight: TFlightForRecalc;
           Scale: TScale;//the array of the scale of performing
           NNR: TDateTime;//the date of beginning of the scale
           KNR: TDateTime//the date of the end of the scale
           );

{*** create period of perfoming the flight ***}
procedure WritePeriod(var aFlight: TFlightForRecalc; BegDate, EndDate: TDateTime; Frequency: string);

{*** ������� ��� ��������� ������ � ��������� ����� � �������� �� UTC � ������� ����� � ������� ***}
procedure RecalcLegs(var arLegs: array of TLeg);

{*** ������� ��� ��������� IDNR ***}
function GenerateIDNR(cNN: TDateTime; cDigitNR, cVR: string): string;

{*** ������� ��� �������� ������� �� 1246 � 12.4.6. ***}
function DottedCD(cCD: string): string;

{*** ������� ��� �������� ������� �� 246 � 0204060 ***}
function ZeroCD(CD: string): string;

{*** ������� ��� ������ �������. ����: (246, 3) - ����� 257 ***}
function SdvigCD(CD: string; sdv: integer): string;

{*** �-��� ��� �������������� TDateTime � ������ ������  ***}
function GetInvertDate (cDTA: TDateTime): string;

{*** �-��� ��� �������������� TDateTime � ������ ����-��  ***}
function GetYear (cDTA: TDateTime): string;

{*** �-��� ��� �������������� TDateTime � ������ '24 ����� 2001'  ***}
function GetRusDate(cDTA: TDateTime): string;

{*** �-��� ��� �������������� TDateTime � ������ '24���01'  ***}
function GetShortRusDate(cDTA: TDateTime): string;

{*** �-��� ��� �������������� TDateTime � ������ '24 APR'  ***}
function GetEngDate(cDTA: TDateTime): string;

{*** ���������, ����������� ����������� ����� DELETE ��� ����� ***}
procedure MyStrDelete(cI, cC: integer; var cS: string);

{*** ����������� ������ ���� ��9551/Z86701/Z86702 � ���: ���9551/PLK6701/PLK6702 ***}
function ConvertStringOfFlightsInICAO(cSTR: string): string;

{*** ����������� ������� ��������� '01W' � ��� 'W01' ***}
function ReversePref(cSTR: string): string;

{*** �-��� ��� ��������� 3-� �����. ���� �/� ����, � �� ����������� �� ���� ��� �������� �� ����,
     �� �� ���� ��� ����_� ***}
function GetEnglishAP(cAP: string): string;
function GetRussianAP(cAP: string): string;

{*** �-��� ��� ��������� 3-� �����. �/� ���� ���� ��, � �� ����������� �� ���� ��� �������� �� ����,
     �����. ��� �/� ��� ***}
function GetEnglishTS(cTS: string): string;

{*** �-��� ��� ��������� 3-� �����. �����. ���� ���� ��, � �� ����������� �� ���� ��� �������� �� ����,
     �����. ��� �/� ��� ***}
function GetRussianTS(const cTS: string): string;

{*** �-��� ��� �������������� ������� TDateTime � ������ ���� '3,11,24 ������ 15 �������'
     ����� ���������� ������� ����� ��������� � ������ ���� �� �������������� ***}
function GetDatesForGSGA_Planning(arDTAs: array of TDateTime; sdv: integer): string;

{*** �-��� ��� �������������� ���� �������� TDateTime � ������ ���� '3/5, 11/13, 24/26 ������ 15/17 �������' ***}
function GetDatesForNewPLMN_Planning(arDTAs1, arDTAs2: array of TDateTime): string;

{*** ��������� ������� ������� �� ���� ������ � ������� ����
     ������ ������� � ���� ��:�� ***}
function GetTimeDiff(cTIME1, cTIME2: string): string;

{*** ��������� ���������� � ���������� � ������������� ���� �/�         ***
 *** cAP - ����� ��� �/� (����); cAPv - ��. ���, cAPm - �/� ��� (�����) ***}
procedure GetAPTogether(cAP: string; var cAPv, cAPm: string);

procedure CheckTLGForAFTN(var cStrngs: TStrings);

{*** ������� ��� �������������� ������ � ��������� WIN1251 � ������ � ��������� DOS ***}
function StrFromWinToDos(st: string): string;

function AnTheSameIntArrays(AR1, AR2: array of integer): boolean;
function AnTheSameStrArrays(AR1, AR2: array of string): boolean;

{*** �������� ���� ��������� �������� ������� '0630' + '0135' = '0805' ***}
function AddTime(cTIME, cDUR: string): string;

const EMonth: array[1..12] of string[3] = ('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');
const RMonth: array[1..12] of string = ('������', '�������', '�����', '������', '���', '����', '����', '�������', '��������', '�������', '������', '�������');
const RSMonth: array[1..12] of string = ('���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���');

(* SAS *)  // ���-��� ��

{���� lOk ����� ������ ����� ������}
function IIFS( lOk: boolean; const s1, s2: string ): string;
function IIFI( lOk: boolean; s1, s2: integer ): integer;
function IIFD( lOk: boolean; s1, s2: double ): double;
function IIFB( lOk: boolean; b1, b2: boolean ): boolean;
function IIFP( lOk: boolean; p1, p2: pointer ): pointer;

{�������� �� ������ �������}
function EmptS( const cStr: string ): boolean;

{*** �-��� ��� �������������� ������� TDateTime � ������ ���� '3,11,24 MAR 15 MAY'
     ����� ���������� ������� ����� ��������� � ������ ���� �� �������������� ***}
function GetDatesForGSGA_PlanningE(arDTAs: array of TDateTime; sdv: integer): string;
function GetDatesForGSGA_PlanningR(arDTAs: array of TDateTime; sdv: integer): string;

{���������� 3-� ��������� ���������� ��� UGA �� 3-� ���������� ��������}
function GetEnglishUga( const cUga: string ): string;

{���������� 2-� ��������� ���������� ��� UGA �� 3-� ���������� ��������}
function GetEnglishUga2( const cUga: string ): string;

{��������� ������ Len ��������}
function Left( const StrSource: string; Len: integer ): string;

{���������� nPos-��� ��������� �� ������ cStr, cDelim - ����������� ��������}
{nPos ���������� � ���� (������ - 0!!!)}
function GetSubStr( cDelim: char; const cStr: string; nPos: integer ): string;

(* SAS *)

{*** �������� 2-� ����. ���� ������ �� ����������� � ��� ***}
function CheckCCExists(cCC: string): boolean;

{*** �������� 3-� ����. ���� �/� �� ����������� � ��� ***}
function CheckAPExists(cAP: string): boolean;

{*** ��������� ��� �������������� ������ 25.03.03$30.03.03 � ������ TDateTime
     ���������� ����������� ***}
function GetArrOfDatesFromString(cSTR, cDELIM: string): TarDTAs;

function finUTC (cDPM : TDateTime; cVPM : string): string;

function SumTime(cT1, cT2: string): string;

{�������� �������� ����� aColor �� aValue ������ (0..255)}
function ObscureColor(aColor: tColor; aValue: integer): tColor;

{��������������� ���-�� ����� � ������ ���� ��:��}
function MiToHhMm(AMin: integer): string;

function AddChar(C: Char; const S: string; N: Integer): string;
function DelChars(const S: string; Chr: Char): string;
function AddCharR(C: Char; const S: string; N: Integer): string;

function Translit(AStr: string): string;
function TranslitWholeWords(AStr: string): string;

function ComputerName: string;
function UserName: string;
function GetLocalIP:string;

 // ����� � ������ ������� Item 
procedure SelectComboBoxIndex(CB : TComboBox; Str : string);
procedure TreeViewDataClear(TV : TTreeView; NP : TNewProc); // RIVC_Navbatov 03.06.2009
procedure TreeViewDataClear_Ext(TV : TTreeView); //; NP : TNewProc); // RIVC_Navbatov 06.02.2009

// ������� ������ ���� � VirtualStringTree
function FindNodeEx(VT : TVirtualStringTree; ANode: PVirtualNode;
                    const APattern: String; Param : integer): PVirtualNode;

// ������� ��� ��������� ������ �� �����
// ������ : ������� �.
function GetTimeFromStr(StrTime, Sep: string): TDateTime;

// ��������� �������� ��������� ��� �������
function GetTemplateDataParams(ADDR, OVF : string; NP : TParamProc) : string;

// ���������� ������ � ������� SQL - �������
procedure VirtualTreeFill(SP : TADOStoredProc; VT : TVirtualStringTree);
procedure VirtualTreeFill_Ex(SP : TADOStoredProc; VT : TVirtualStringTree);

// ���������� �� ������ �� ���� 
function VirtualTreeNodeAssigned(Sender : TBaseVirtualTree;
                                Node : PVirtualNode;
                                var Data : PDataInfo) : boolean;

// ������� ����
procedure VirtualTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);

// ������������ ��� ���������� ���� �� ������
procedure VirtualTreeExecCheck(VT : TVirtualStringTree;
                                    Node : PVirtualNode;
                                    TreeProc : TNewObjProc);

// ����� ���������� ���� � ������
function NextNode(Node : TTreeNode) : TTreeNode;

// ����� ���� � ������
function FindNode(Tree : TTreeView; Node : TTreeNode; Str : string) : TTreeNode;

// ������������� �������
procedure SetSeasonsForComboBox(SP : TADOStoredProc; CB : TComboBox);

// �������� ������� �������
procedure ClearSeasonsCB(CB : TComboBox);

// ���������� ������ � ComboBox
procedure ComboBoxUpdate(CB : TComboBox; SPName : string; NP : TParamProc);

var
  trans_eng : array [0..25] of char = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','Y','X','Z');
  trans_cyr : array [0..25] of char = ('�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�');
  whw_eng : array [0..6] of string = ('VADSA', 'AVADI', 'VINLI', 'RANVA', 'AVRAL', 'BALAV', 'VASAV');
  whw_cyr : array [0..6] of string = ('�����', '�����', '�����', '�����', '�����', '�����', '�����');

implementation

uses DM, Main, AirCoInfo, WinSock, DB;

function ComputerName: string;
var
   _comp: PAnsiChar;
   _sz: cardinal;
begin
  _sz := MAX_COMPUTERNAME_LENGTH+1;
  _comp := StrAlloc(_sz);
  if GetComputerName(_comp, _sz) and (_sz > 0) then
   Result := _comp
  else
   Result := '�/�';
  StrDispose(_comp)
end;

function UserName: string;
var
   _user: pchar;
   _sz: cardinal;
begin
  _sz := 255;
  _user := StrAlloc(_sz);
  if GetUserName(_user, _sz) and (_sz > 0) then
   Result := _user
  else
   Result := '�/�';
  StrDispose(_user)
end;

function GetLocalIP:string;
var
   _wsa : TWSAData;
   _p   : PHostEnt;
   _name: array [0..$FF] of Char;
begin
  WSAStartup($0101, _wsa);
  gethostname(_name, $FF);
  _p := gethostbyname(_name);
  Result := (inet_ntoa(PInAddr(_p^.h_addr_list^)^));
  WSACleanup;
end;

function Translit(AStr: string): string;
var
  _i, _j: integer;
begin
  AStr:=AnsiUpperCase(AStr);
  Result:='';
  for _i:=1 to length(AStr) do
    if (AStr[_i] in ['A'..'Z']) or (AStr[_i] in ['a'..'z']) then begin
      for _j:=Low(trans_eng) to High(trans_cyr) do
        if AStr[_i] = trans_eng[_j] then Result:=Result + trans_cyr[_j]
    end else
      Result:=Result + AStr[_i];
end;

function TranslitWholeWords(AStr: string): string;
var
  _i: integer;
begin
  AStr:=AnsiUpperCase(AStr);
  for _i:=Low(whw_eng) to High(whw_eng) do
    AStr:=StringReplace(AStr, whw_eng[_i], whw_cyr[_i], [rfReplaceAll]);
  Result:=AStr;
end;

{��������������� ���-�� ����� � ������ ���� ��:��}
function MiToHhMm(AMin: integer): string;
var
  ih, im: integer;
begin
  ih:=Trunc(AMin/60);
  im:=AMin - ih*60;
  if im < 10 then Result:=IntToStr(ih) + '�.0' + IntToStr(im) + '�.'
             else Result:=IntToStr(ih) + '�.'  + IntToStr(im) + '�.'
end;

function SumTime(cT1, cT2: string): string;
var
  cH1, cH2: integer;
  cM1, cM2: integer;
begin
  if cT2 = '' then Result:=cT1
              else if cT1 = '' then Result:=cT2
                               else begin
                                 cH1:=StrToIntDef(copy(cT1,1,2), 0);
                                 cM1:=StrToIntDef(copy(cT1,3,2), 0);
                                 cH2:=StrToIntDef(copy(cT2,1,2), 0);
                                 cM2:=StrToIntDef(copy(cT2,3,2), 0);
                                 cH1:=cH1 + cH2;
                                 cM1:=cM1 + cM2;
                                 if cM1 >= 60 then begin
                                   cH1:=cH1 + 1;
                                   cM1:=cM1 - 60;
                                 end;
                                 if cH1 < 10 then if cM1 < 10 then Result:='0' + IntToStr(cH1) +
                                                                           '0' + IntToStr(cM1)
                                                              else Result:='0' + IntToStr(cH1) +
                                                                                 IntToStr(cM1)
                                             else if cM1 < 10 then Result:=      IntToStr(cH1) +
                                                                           '0' + IntToStr(cM1)
                                                              else Result:=      IntToStr(cH1) +
                                                                                 IntToStr(cM1)
                               end;
end;

function finUTC (cDPM : TDateTime; cVPM : string): string;
var
  strGod : string;
  intGod : word;
  intMM  : word;
  intDD  : word;
  cDateBeginSummer : TDateTime;
  cDateBeginWinter : TDateTime;
  cDiff : integer;
  cVPU : string;
  cDPU : TDateTime;
  i : integer;
begin
  DecodeDate(cDPM,intGod,intMM,intDD);
  strGod:=copy(IntToStr(intGod),3,2); { ��� }

  cDateBeginSummer:=EnCodeDate(intGod, 03, 31);      { '31.03'}
  cDateBeginWinter:=EnCodeDate(intGod, 10, 31);      { '31.10'}

  cDateBeginSummer:=cDateBeginSummer-DayOfWeek(cDateBeginSummer)+1;
  cDateBeginWinter:=cDateBeginWinter-DayOfWeek(cDateBeginWinter)+1;

  if cDPM < cDateBeginSummer then begin
    strGod:=copy(IntToStr(intGod-1),3,2);
    cDiff:=3;
  end else begin
    if cDPM < cDateBeginWinter then cDiff:=4
                               else cDiff:=3;
  end;
  cVPU:=IntToStr(StrToInt(cVPM) - 100*cDiff);
  if StrToInt(cVPU) < 0 then cVPU:=IntToStr(StrToInt(cVPU) + 2400);
  if length(cVPU) < 4 then for i:=1 to (4-length(cVPU)) do cVPU:='0' + cVPU;
  if StrToInt(cVPU) > StrToInt(cVPM) then cDPU:=cDPM - 1
                                     else cDPU:=cDPM;
  if (cDPU=cDateBeginWinter-1) and (cDPM=cDateBeginWinter) and (cVPM<='0300') then
      cVPU:=IntToStr(StrToInt(cVPU)-100);
  if (cDPU=cDateBeginSummer-1) and (cDPM=cDateBeginSummer) and (cVPM<='0300') then
      cVPU:=IntToStr(StrToInt(cVPU)+100);
  if cVPU = '2400' then begin
    cVPU:='0000';
//    cDPU:=cDPU + 1;
  end;
  RESULT:=cVPU;
end;

{*** ������� ��� �������������� ������ � ��������� WIN1251 � ������ � ��������� DOS ***}
function StrFromWinToDos(st: string): string;
var
  i: integer;
  ch: char;
  nch: integer;
begin
  for i:=1 to Length(st) do begin
    ch:=st[i];
    nch:=Ord(ch);
    If (nch >= 192) and (nch <= 239) then begin
      nch:=nch-64;
      ch:=Chr(nch);
      st[i]:=ch;
      continue;
    end;
    If (nch >= 240) {and (nch <= 255)} then begin
      nch:=nch-16;
      ch:=Chr(nch);
      st[i]:=ch;
      continue;
    end;
  end;
  result:=st;
end;

{*** �-��� ��� �������������� ������� TDateTime � ������ ���� '3,11,24 ������ 15 �������'
     ����� ���������� ������� ����� ��������� � ������ ���� �� �������������� ***}
function GetDatesForGSGA_Planning(arDTAs: array of TDateTime; sdv: integer): string;
var
  i: integer;
  Day, Month, Year, PrevMonth: word;
  cDTAs: string;
begin
  cDTAs:='';
  for i:=0 to High(arDTAs) do arDTAs[i] := arDTAs[i] + sdv;
  DecodeDate(arDTAs[0], Year, Month, Day);
  cDTAs:=IntToStr(Day);
  prevMonth:=Month;
  if High(arDTAs) > 0 then for i:=1 to High(arDTAs) do begin
    DecodeDate(arDTAs[i], Year, Month, Day);
    if Month <> prevMonth then cDTAs:=cDTAs + ' ' + RMonth[prevMonth] + ', ';
    if copy(cDTAs, length(cDTAs), 1) = ' ' then cDTAs:=cDTAs + IntToStr(Day)
                                           else cDTAs:=cDTAs + ',' + IntToStr(Day);
     prevMonth:=Month;
  end;
  cDTAs:=cDTAs + ' ' + RMonth[prevMonth];
  Result:=cDTAs;
end;


{*** �-��� ��� �������������� ���� �������� TDateTime � ������ ���� '3/5, 11/13, 24/26 ������ 15/17 �������' ***}
function GetDatesForNewPLMN_Planning(arDTAs1, arDTAs2: array of TDateTime): string;
type
  TDecDates = record
    Day, Month, Year: integer
  end;
var
  _i: integer;
  Day, Month, Year: word;
  cDTAs: string;
  DecDTAs1, DecDTAs2: array of TDecDates;
begin
  cDTAs:='';
  SetLength(DecDTAs1, High(arDTAs1)+1);
  for _i:=0 to High(DecDTAs1) do begin
    DecodeDate(arDTAs1[_i], Year, Month, Day);
    DecDTAs1[_i].Year:=Year;
    DecDTAs1[_i].Month:=Month;
    DecDTAs1[_i].Day:=Day;
  end;
  SetLength(DecDTAs2, High(arDTAs2)+1);
  for _i:=0 to High(DecDTAs2) do begin
    DecodeDate(arDTAs2[_i], Year, Month, Day);
    DecDTAs2[_i].Year:=Year;
    DecDTAs2[_i].Month:=Month;
    DecDTAs2[_i].Day:=Day;
  end;
  for _i:=0 to High(DecDTAs1) do begin
    cDTAs:=cDTAs + IntToStr(DecDTAs1[_i].Day);
    if DecDTAs1[_i].Day <> DecDTAs2[_i].Day then begin
      if DecDTAs1[_i].Month <> DecDTAs2[_i].Month
        then cDTAs:=cDTAs + ' ' + RMonth[DecDTAs1[_i].Month] + '/' + IntToStr(DecDTAs2[_i].Day) + ' ' + RMonth[DecDTAs2[_i].Month] + ', '
        else cDTAs:=cDTAs + '/' + IntToStr(DecDTAs2[_i].Day) + ' ' + RMonth[DecDTAs2[_i].Month] + ', ';
    end else begin
// RIVC Nabatov 29.01.2009 ������� ��������� ������� ������ �� ������� ���������     
      if (_i <> High(DecDTAs1)) and (DecDTAs1[_i].Month = DecDTAs1[_i+1].Month)
        then cDTAs:=cDTAs + ', '
        else cDTAs:=cDTAs + ' ' + RMonth[DecDTAs1[_i].Month] + ', ';
    end;
  end;
  if copy(cDTAs, length(cDTAs)-1, 2) = ', ' then delete(cDTAs, length(cDTAs)-1, 2);

{  DecodeDate(arDTAs1[0], Year1, Month1, Day1);
  DecodeDate(arDTAs2[0], Year2, Month2, Day2);
  prevMonth1:=Month1;
  prevMonth2:=Month2;
  if High(arDTAs1) >= 0 then for i:=0 to High(arDTAs1) do begin
    DecodeDate(arDTAs1[i], Year1, Month1, Day1);
    DecodeDate(arDTAs2[i], Year2, Month2, Day2);
    cDTAs:=cDTAs + IntToStr(Day1);
    if Day2 <> Day1 then begin
      if prevMonth2 <> prevMonth1 then begin
        cDTAs:=cDTAs + ' ' + RMonth[prevMonth1] + '/' + IntToStr(Day2) + ' ' + RMonth[prevMonth2] + ', ';
      end else begin
        cDTAs:=cDTAs + '/' + IntToStr(Day2) + ' ' + RMonth[prevMonth2] + ', ';
      end;
    end else begin
      if Month1 <> prevMonth1 then cDTAs:=cDTAs + ' ' + RMonth[prevMonth1] + ', '
                              else begin
                                if i = High(arDTAs1) then cDTAs:=cDTAs + ' ' + RMonth[prevMonth1] + ', '
                                                     else cDTAs:=cDTAs + ',';
                              end;
    end;
    prevMonth1:=Month1;
    prevMonth2:=Month2;
  end;
  if copy(cDTAs, length(cDTAs)-1, 2) = ', ' then delete(cDTAs, length(cDTAs)-1, 2);}
  Result:=cDTAs;
end;

{*** �-��� ��� �������� ������� �������� (1234567) ***}
function CheckCD(cSTR: string): string;
var
  i: integer;
begin
  for i:=1 to length(cSTR) do if cSTR[i] > cSTR[i+1] then begin
    Insert(cSTR[i], cSTR, i+3);
    Delete(cSTR, i, 1);
  end;
  try
    StrToInt(cSTR);
  except
    on EConvertError do Delete(cSTR, length(cSTR), 1);
  end;
  if copy(cSTR, length(cSTR), 1) > '7' then Delete(cSTR, length(cSTR), 1);
  if copy(cSTR, 1, 1) = '0' then Delete(cSTR, 1, 1);
  for i:=1 to length(cSTR) do if cSTR[i] = cSTR[i+1] then Delete(cSTR, i, 1);
  Result:=cSTR;
end;

{*** �-��� ��� ���������� ����� �� 5 � 0 ***}
function RoundMin(cMin: integer): integer;
begin
  case cMin of
    0  : cMin:=0;
    1  : cMin:=0;
    2  : cMin:=0;
    3  : cMin:=5;
    4  : cMin:=5;
    5  : cMin:=5;
    6  : cMin:=5;
    7  : cMin:=5;
    8  : cMin:=10;
    9  : cMin:=10;
    10 : cMin:=10;
    11 : cMin:=10;
    12 : cMin:=10;
    13 : cMin:=15;
    14 : cMin:=15;
    15 : cMin:=15;
    16 : cMin:=15;
    17 : cMin:=15;
    18 : cMin:=20;
    19 : cMin:=20;
    20 : cMin:=20;
    21 : cMin:=20;
    22 : cMin:=20;
    23 : cMin:=25;
    24 : cMin:=25;
    25 : cMin:=25;
    26 : cMin:=25;
    27 : cMin:=25;
    28 : cMin:=30;
    29 : cMin:=30;
    30 : cMin:=30;
    31 : cMin:=30;
    32 : cMin:=30;
    33 : cMin:=35;
    34 : cMin:=35;
    35 : cMin:=35;
    36 : cMin:=35;
    37 : cMin:=35;
    38 : cMin:=40;
    39 : cMin:=40;
    40 : cMin:=40;
    41 : cMin:=40;
    42 : cMin:=40;
    43 : cMin:=45;
    44 : cMin:=45;
    45 : cMin:=45;
    46 : cMin:=45;
    47 : cMin:=45;
    48 : cMin:=50;
    49 : cMin:=50;
    50 : cMin:=50;
    51 : cMin:=50;
    52 : cMin:=50;
    53 : cMin:=55;
    54 : cMin:=55;
    55 : cMin:=55;
    56 : cMin:=55;
    57 : cMin:=55;
    58 : cMin:=60;
    59 : cMin:=60;
  end;
  Result:=cMin;
end;

{*** ��������� ���� ������ �/� � ����������e (port_n) ��� ���. �� 3-� ����. ���� IATA/��� ***}
function APExists(cAP, cVR: string): boolean;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('select ap from dbo.port_n where ap = :AP OR iata = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then
      Result:=True
    else
      Result:=False;
    Close;
  end;
end;

{*** �-��� �������������� ������ ����� IATA � ����� ����� ICAO ***}
function GetICAOFlight(cNR: string): string;
var
  _i: integer;
  _str: string;
begin
  _str:='';
  {FV -> PLK}
  for _i:=0 to AirCo.UgaCodesCnt-1 do
    if copy(cNR, 1, 2) = AirCo.UgaCodes[_i].IATA then begin
      _str:=AirCo.UgaCodes[_i].ICAO;
      Break;
    end;
  {�� -> ���}
  if _str = '' then
    for _i:=0 to AirCo.UgaCodesCnt-1 do
      if copy(cNR, 1, 2) = AirCo.UgaCodes[_i].UG then begin
        _str:=AirCo.UgaCodes[_i].AFTN;
        Break;
      end;
  if _str <> '' then begin
    delete(cNR, 1, 2);
    Result := _str + cNR;
  end else
    Result := cNR;
end;

{*** �-��� �������������� ������ ����� IATA � ����� ����� ICAO (����. �/� �������) ***}
function GetICAO_M_Flight(cNR: string): string;
var
  _i: integer;
  _str: string;
begin
  _str:='';
  {FV -> PLK} {�� -> PLK}
  for _i:=0 to AirCo.UgaCodesCnt-1 do
    if (copy(cNR, 1, 2) = AirCo.UgaCodes[_i].IATA) or (copy(cNR, 1, 2) = AirCo.UgaCodes[_i].UG) then begin
      _str:=AirCo.UgaCodes[_i].ICAO;
      Break;
    end;
  if _str <> '' then begin
    delete(cNR, 1, 2);
    Result := _str + cNR;
  end else
    Result := cNR;
end;

{*** �-��� �������������� ������ ����� UG � ����� ����� IATA ***}
function GetIATAFlightFromUG(cNR: string): string;
var
  _i: integer;
  _str: string;
begin
    _str := '';
    for _i:=0 to AirCo.UgaCodesCnt-1 do
    if copy(cNR, 1, 2) = AirCo.UgaCodes[_i].UG then
    begin
        _str := AirCo.UgaCodes[_i].IATA;
        Break;
    end;
    if _str = '' then Result := cNR
    else Result := _str;
end;


{*** �-��� �������������� ������ ����� ICAO � ����� ����� IATA ***}
function GetIATAFlight(cNR: string): string;
var
  _i: integer;
  _str: string;
begin
  _str:='';
  {PLK -> FV}
  for _i:=0 to AirCo.UgaCodesCnt-1 do
    if copy(cNR, 1, 3) = AirCo.UgaCodes[_i].ICAO then begin
      _str:=AirCo.UgaCodes[_i].IATA;
      Break;
    end;
  {��� -> ��}
  if _str = '' then
    for _i:=0 to AirCo.UgaCodesCnt-1 do
      if copy(cNR, 1, 3) = AirCo.UgaCodes[_i].AFTN then begin
        _str:=AirCo.UgaCodes[_i].UG;
        Break;
      end;
  if _str <> '' then begin
    delete(cNR, 1, 3);
    Result := _str + cNR;
  end else
    Result := cNR;
end;


{*** �-��� �������������� ������ ����� ICAO � ����� ����� IATA ***}
{*** ��� SCR � ������ �/� ������� ***}
function GetIATAFlightForSCR(cNR: string): string;
var
  _i: integer;
  _str: string;
begin
  _str:='';
  {PLK -> FV}
  for _i:=0 to AirCo.UgaCodesCnt-1 do
    if copy(cNR, 1, 3) = AirCo.UgaCodes[_i].ICAO then begin
      _str:=AirCo.UgaCodes[_i].IATA;
      Break;
    end;
  {��� -> PLK}
  if _str = '' then
    for _i:=0 to AirCo.UgaCodesCnt-1 do
      if copy(cNR, 1, 3) = AirCo.UgaCodes[_i].AFTN then begin
        _str:=AirCo.UgaCodes[_i].ICAO;
        Break;
      end;
  if _str <> '' then begin
    delete(cNR, 1, 3);
    Result := _str + cNR;
  end else
    Result := cNR;
end;

{*** �-��� �������������� 3-� ����. ���� ���� �� � 4-� ����. ����. ***}
function GetLSOType(cTS: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 ts4_m FROM dbo.type_vs WHERE ts = :TS OR ts_m = :TS');
    Parameters[0].Value:=cTS;
    Parameters[1].Value:=cTS;
    Open;
    if RecordCount > 0 then Result:=FieldByName('TS4_M').AsString
                       else Result:=cTS;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� ���� �� � 4-� ����. ���. ***}
function GetLSO_RUSType(cTS: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 ts4 FROM dbo.type_vs WHERE ts = :TS OR ts_m = :TS');
    Parameters.ParamByName('TS').Value:=cTS;
    Open;
    if RecordCount > 0 then Result:=FieldByName('TS4').AsString
                       else Result:=cTS;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� ���� �� � NAME_TYP (�����.)  ��154� ***}
function GetNameTypRus(cTS: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 name_typ FROM dbo.type_vs WHERE ts = :TS OR ts_m = :TS');
    Parameters[0].Value:=cTS;
    Parameters[1].Value:=cTS;
    Open;
    if RecordCount > 0 then Result:=FieldByName('NAME_TYP').AsString
                       else Result:=cTS;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� ���� �� � NAME_M (���.)  TU-154 ***}
function GetNameTypEng(cTS: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 name_m FROM dbo.type_vs WHERE ts = :TS OR ts_m = :TS');
    Parameters[0].Value:=cTS;
    Parameters[1].Value:=cTS;
    Open;
    if RecordCount > 0 then
      Result:=FieldByName('NAME_M').AsString
    else
      Result:=cTS;
    Close;
  end;
end;

{*** �-��� �������������� 4-� ����. ���� ���� �� � 3-� ����. ***}
function GetIATAType(cTS: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 ts_m FROM dbo.type_vs WHERE ts4 = :TS OR ts4_m = :TS');
    Parameters.ParamByName('TS').Value:=cTS;
    Open;
    if RecordCount > 0 then Result:=FieldByName('TS_M').AsString
                       else Result:=cTS;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � 4-� ����. ��� ���� ***}
function GetICAOAP(cAP: string): string;
begin
  with DataM.qrNSItmp2 do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ik FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters[0].Value := cAP;
    Parameters[1].Value := cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('IK').AsString
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 4-� ����. ���� �/� ICAO � 3-� ����. ��� ��TA ***}
function GetIATAAP(cAP: string): string;
begin
  with DataM.qrNSItmp2 do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT iata FROM dbo.port_n WHERE ik = :AP OR ik_r = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('IATA').AsString
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 4-� ����. ���� �/� ICAO � 3-� ����. ��� ��� ***}
function GetCRTAP(cAP: string): string;
begin
  with DataM.qrNSItmp2 do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ap FROM dbo.port_n WHERE ik = :AP OR ik_r = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('AP').AsString
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � 4-� ����. ��� ���� ***}
function GetAFTNAP(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ik_r FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('IK_R').AsString
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� '������� (����)' ***}
function GetAPForFormaR(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ik, name_8 FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=Trim(FieldByName('NAME_8').AsString) + ' (' + FieldByName('IK').AsString + ') '
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'ST. PETERSBURG (ULLI)' ***}
function GetAPForFormaR_ENG(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ik, nl FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters.ParamByName('AP').Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=Trim(FieldByName('NL').AsString) + ' (' + FieldByName('IK').AsString + ') '
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� '�������(LICC-������)' ***}
function GetAPForGSGA_Planning(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT p.ik, p.name_ap, c.nm');
    SQL.Add('FROM port_n p JOIN dbo.country c ON p.cc = c.cc');
    SQL.Add('WHERE p.ap = :AP OR p.iata = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=Trim(FieldByName('NAME_AP').AsString) + '(' +
                                    FieldByName('IK').AsString + '-' +
                                    Trim(FieldByName('NM').AsString) + ')'
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'ST.PETERSBURG (ULLI)' ***}
function GetAP_CForIRRegRequestFormat(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ik, nl FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('NL').AsString + ' (' +
                                    FieldByName('IK').AsString + ')'
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'LARNACA' (���� NL) ***}
function GetAP_NL(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT nl FROM dbo.port_n WHERE ap = :AP OR iata = :AP OR ik = :AP OR ik_r = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Parameters[2].Value:=cAP;
    Parameters[3].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=Trim(FieldByName('NL').AsString)
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� '�������' (NAME_AP) ***}
function GetNAME_AP(cAP: string; Rpls: boolean): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT name_ap FROM dbo.port_n WHERE ap = :AP OR iata = :AP OR ik = :AP OR ik_r = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Parameters[2].Value:=cAP;
    Parameters[3].Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=Trim(FieldByName('NAME_AP').AsString)
                       else Result:=cAP;
    Close;
  end;
  if (Result = '�����-���������') or (Result = '�����-���������(�������)') then begin
    Result:='�.���������';
    if Rpls then Result:='�������';
  end;
  if (Result = '������(�����������)') or (Result = '������ (�����������)') then begin
    Result:='������(�����������)';
    if Rpls then Result:='�����������';
  end;
end;

{*** �-��� �������������� 3-� ����. ���� �/� � ������ ���� 'STOCKHOLM(ARLANDA)' (NL PORT_N) ***}
function GetEnglishNAME_AP(cAP: string): string;
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT nl FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters.ParamByName('AP').Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('NL').AsString
                       else Result:=cAP;
    Close;
  end;
end;

{*** �-��� ��� �������� ��������������� �������� ***}
function CheckForOverlapping(PerArray: array of TPeriod): Boolean;
var
  i,j: integer;
  CurrPeriod: TPeriod;
  ErrorCode: Boolean;
begin
  ErrorCode:=False;
  for i:=0 to length(PerArray)-1 do begin
    CurrPeriod:=PerArray[i];
    for j:=i+1 to Length(PerArray)-1 do begin
      if (CurrPeriod.PDate1>=PerArray[j].PDate1) and
         (CurrPeriod.PDate1<=PerArray[j].PDate2) then begin
         ErrorCode:=True;
         Break;
      end;
      if (CurrPeriod.PDate1<=PerArray[j].PDate1) and
         (CurrPeriod.PDate2>=PerArray[j].PDate2) then begin
         ErrorCode:=True;
         Break;
      end;
      if (CurrPeriod.PDate1>=PerArray[j].PDate1) and
         (CurrPeriod.PDate2<=PerArray[j].PDate2) then begin
         ErrorCode:=True;
         Break;
      end;
      if (CurrPeriod.PDate1<=PerArray[j].PDate1) and
         (CurrPeriod.PDate2>=PerArray[j].PDate1) then begin
         ErrorCode:=True;
         Break;
      end;
    end;
  end;
  Result:=ErrorCode;
end;//the end of the procedure

{*** ���������� ���� ������, ������������ �� ������� ***}
function GetDayOfWeek(cDTA: TDateTime): integer;
var
  cDOF: integer;
begin
  try
    cDOF:=DayOfWeek(cDTA)-1;
    if cDOF = 0 then cDOF:=7;
    Result:=cDOF;
  except
    on EConvertError do Result:=0;
  end;
end;

{build the scale of performing the flight}
procedure ScaleBuilder(var aFlight: TFlightForRecalc);
var CD: string[7];//Frequency
    Scale: TScale;//scale of performing the flight
    NN: TDateTime;//these are for the concrete
    KN: TDateTime;//periods of the fligth
    NNR, KNR: TDateTime;//beginning and end of the scale
    j: integer;
    i: SmallInt;
    CurrDate: TDateTime;
    CurrDayOfWeek: integer;
begin//beginning of the procedure
    // ������ �������� ����������� ������� [Begin]
    if Length(aFlight.rPeriods) <= 0 then exit;
    // ������ �������� ����������� ������� [End]

    j:=0; //counter of periods
    NNR := aFlight.rPeriods[j].rNN;
    KNR := aFlight.rPeriods[j].rKN;
    while j <= Length(aFlight.rPeriods) - 1 do
    begin
        CD := aFlight.rPeriods[j].rCD;
        NN := aFlight.rPeriods[j].rNN;
        KN := aFlight.rPeriods[j].rKN;
        KNR := aFlight.rPeriods[j].rKN;
        i := Length(Scale);

        if i < 0 then i := 0;

        if Length(Scale) + Floor(KN - NN) + 1 >= 0 then
            SetLength(Scale, Length(Scale) + Floor(KN - NN) + 1)
        else
            SetLength(Scale, 0);

        CurrDate := NN;
        while CurrDate <= KN do
        begin//fill in the scale
            CurrDayOfWeek := GetDayOfWeek(CurrDate);
            if Pos(IntToStr(CurrDayOfWeek),CD) > 0 then
                Scale[i] := True;
            CurrDate := CurrDate + 1; Inc(i);
        end;

        if j < Length(aFlight.rPeriods) - 1 then
        begin
            Inc(j);
            NN:=aFlight.rPeriods[j].rNN;                                  (* <- ���� ����� SAS *)
            if Length(Scale) + (Floor(NN - KN) - 1) > 0 then
                SetLength(Scale,Length(Scale)+(Floor(NN - KN)-1));
            Dec(j);
        end;
        
        { else begin//if this is the last period of this flight
          procedure of recounting periods with aid of the scale
        end;}
        Inc(j);
    end;//the end of the outer while cycle

    aFlight.rPeriods := nil;
    PeriodsMaker(aFlight, Scale, NNR, KNR);
    Scale := nil;
end;//the end of the procedure

procedure PeriodsMaker(var aFlight: TFlightForRecalc;
           Scale: TScale; //the array of the scale of performing
           NNR: TDateTime; //the date of beginning of the scale
           KNR: TDateTime //the date of the end of the scale
           );
var
  Dow: integer;//Day of week
  t: integer;//how many days we need to add/deduct to get monday/sunday
  i: integer;
  BegDate, {PreEndDate, }EndDate, CurrDate: TDateTime;//Beginning and end of the period
  Frequency: string[7];//current frequency
  PreFrequency: string[7];//preliminary frequency
  AtrOfMakedWeek: Boolean;
  FrMadeAtt: Boolean;//if the frequency is made or not
  ArrOfBegDate: Boolean;//if we know the first date of the period
begin//the beginning of the procedure
  BegDate:=NNR;
  EndDate:=NNR; //PreEndDate:=NNR;
  ArrOfBegDate:=False;//we don't know if the begDate is real date
//  Dow:=GetDayOfWeek(NNR);
  AtrOfMakedWeek:=False;//we don't even know the preliminary frequency
  FrMadeAtt:=False;//we don't know frequency
  i:=0; CurrDate:=NNR;
  Frequency:='';
  PreFrequency:='';
  {the cycle through the whole scale}
  while i<=Length(Scale)-1 do begin
    Dow:=GetDayOfWeek(CurrDate);
    if (Dow<=7) and (AtrOfMakedWeek=False) then begin
      if Scale[i]=True then begin
        if ArrOfBegDate=False then begin
          BegDate:=CurrDate;
          ArrOfBegDate:=True;//we've found the beginning of the period
        end;
   //     PreEndDate:=CurrDate;
        EndDate:=CurrDate;
        PreFrequency:=PreFrequency+IntToStr(Dow);
        Frequency:=Frequency+IntToStr(Dow);
      end;
      if (Dow=7) and (PreFrequency<>'') then begin
        if i<Length(Scale)-1 then begin
          AtrOfMakedWeek:=True;
          Inc(i);
          CurrDate:=CurrDate+1;
          Dow:=1;//next day is monday
        end;
      end;
    end;//the end of the condition if (Dow<=7) and (AtrOfMakedWeek=False)
    if AtrOfMakedWeek=True then
      {if the frequency is not made yet}
      if FrMadeAtt=False then begin
        if Scale[i]=True then begin
          if Dow<StrToInt(Copy(PreFrequency,1,1)) then begin
            {insert apropriate day of week in the frequency}
            for t:=1 to Length(Frequency) do begin
              if Dow<StrToInt(Copy(Frequency,t,1)) then begin
                Insert(IntToStr(Dow),Frequency,t);
                Break;
              end;
            end;
            EndDate:=CurrDate;
          end;
          if Dow=StrToInt(Copy(PreFrequency,1,1)) then EndDate:=CurrDate;
          if Dow>StrToInt(Copy(PreFrequency,1,1)) then
            if Pos(IntToStr(Dow),PreFrequency)>0
              then EndDate:=CurrDate
              else begin
                WritePeriod(aFlight, BegDate, EndDate, Frequency);
                PreFrequency:='';
                Frequency:='';
                AtrOfMakedWeek:=False;
                FrMadeAtt:=False;
                BegDate:=CurrDate;
                EndDate:=CurrDate;
                CurrDate:=CurrDate-1; Dec(i);
              end;
        end else begin//the end of the condition "Scale[i]=True"
          {if Scale[i]=False}
          if Pos(IntToStr(Dow),PreFrequency)>0 then begin
          {if it could be in the Frequency}
            WritePeriod(aFlight, BegDate, EndDate, Frequency);
            AtrOfMakedWeek:=False;
            FrMadeAtt:=False;
            ArrOfBegDate:=False;//we don't know the beginning of the period
            PreFrequency:=''; Frequency:='';
          end;
        end;
        if (Dow=7) and (AtrOfMakedWeek=True) then FrMadeAtt:=True;//we've made up the frequency
      end else begin//the end of the condition "FrMadeAtt=False"
        {the frequency is made}
        if Scale[i]=True then begin
          if Pos(IntToStr(Dow),Frequency)>0
            then EndDate:=CurrDate
            else begin
              WritePeriod(aFlight, BegDate, EndDate, Frequency);
              AtrOfMakedWeek:=False;
              FrMadeAtt:=False;
              PreFrequency:=''; Frequency:='';
              BegDate:=CurrDate;
              EndDate:=CurrDate;
              CurrDate:=CurrDate-1; Dec(i);
            end;
        end else if Pos(IntToStr(Dow),Frequency)>0 then begin
          {Scale[i]=False//flight doesn't perform}
          WritePeriod(aFlight, BegDate, EndDate, Frequency);
          AtrOfMakedWeek:=False;
          FrMadeAtt:=False;
          PreFrequency:=''; Frequency:='';
          Dec(i); CurrDate:=CurrDate-1;
          ArrOfBegDate:=False;//we don't know the beginning of the period
        end;
      end;//the frequency is made
      Inc(i); CurrDate:=CurrDate+1;
  end;//the end of the cycle on the scale
  WritePeriod(aFlight, BegDate, EndDate, Frequency);
end;

{*** create period of perfoming the flight ***}
procedure WritePeriod(var aFlight: TFlightForRecalc;
          BegDate, EndDate: TDateTime; Frequency: string);
var
  i: integer;//number of the periods
begin
  SetLength(aFlight.rPeriods,Length(aFlight.rPeriods)+1);
  i:=Length(aFlight.rPeriods)-1;
  aFlight.rPeriods[i].rNN:=BegDate;
  aFlight.rPeriods[i].rKN:=EndDate;
  aFlight.rPeriods[i].rCD:=Frequency;
end;

{*** ������� ��� ��������� ������ � ��������� ����� � �������� �� UTC � ������� ����� � ������� ***}
procedure RecalcLegs(var arLegs: array of TLeg);
var
  i: integer;
  fDTA: TDateTime;
begin
  if arLegs[0].UL = 'U' then with DataM.spGetLocalTimes do begin
    {�������� ���� ������ �� ���������� �/� � ������� ������� ��� ������� ��������� �����}
    Parameters.Refresh;
    Parameters.ParamByName('@VR').Value:=arLegs[0].VR;
    Parameters.ParamByName('@AP1').Value:=arLegs[0].AP1;
    Parameters.ParamByName('@DU').Value:=arLegs[0].DTA1;
    Parameters.ParamByName('@VO').Value:=arLegs[0].VO;
    ExecProc;
    fDTA:=Parameters.ParamByName('@DM').Value;
  end else with DataM.spGetUTCTimes do begin
    {�������� ���� ������ �� ���������� �/� UTC ��� ������� ��������� �����}
    Parameters.Refresh;
    Parameters.ParamByName('@VR').Value:=arLegs[0].VR;
    Parameters.ParamByName('@AP1').Value:=arLegs[0].AP1;
    Parameters.ParamByName('@DM').Value:=arLegs[0].DTA1;
    Parameters.ParamByName('@VOL').Value:=arLegs[0].VO;
    ExecProc;
    fDTA:=Parameters.ParamByName('@DU').Value;
  end;

  DataM.spGetLocalTimes.Parameters.Refresh;
  for i:=0 to High(arLegs) do with arLegs[i] do begin
    if UL = 'U' then with DataM.spGetLocalTimes do begin
      // ���� �� ����� - UTC, � �������� ����� ������� �����
      {������ ����}

      Parameters.ParamByName('@VR').Value:=VR;
      Parameters.ParamByName('@AP1').Value:=AP1;
      Parameters.ParamByName('@DU').Value:=DTA1;
      Parameters.ParamByName('@VO').Value:=VO;
      ExecProc;
      DTA1:=Parameters.ParamByName('@DM').Value;
      VO:=Parameters.ParamByName('@VOL').Value;
      {������ ����}
      Parameters.ParamByName('@VR').Value:=VR;
      Parameters.ParamByName('@AP1').Value:=AP2;
      Parameters.ParamByName('@DU').Value:=DTA2;
      Parameters.ParamByName('@VO').Value:=VP;
      ExecProc;
      DTA2:=Parameters.ParamByName('@DM').Value;
      VP:=Parameters.ParamByName('@VOL').Value;
      PO:=Round(DTA1 - fDTA);
      PP:=Round(DTA2 - fDTA);
    end else with DataM.spGetUTCTimes do begin
      // ���� �� ����� - ������� �����, � �������� ����� UTC
      {������ ����}
      Parameters.Refresh;
      Parameters.ParamByName('@VR').Value:=VR;
      Parameters.ParamByName('@AP1').Value:=AP1;
      Parameters.ParamByName('@DM').Value:=DTA1;
      Parameters.ParamByName('@VOL').Value:=VO;
      ExecProc;
      DTA1:=Parameters.ParamByName('@DU').Value;
      VO:=Parameters.ParamByName('@VO').Value;
      {������ ����}
      Parameters.ParamByName('@VR').Value:=VR;
      Parameters.ParamByName('@AP1').Value:=AP2;
      Parameters.ParamByName('@DM').Value:=DTA2;
      Parameters.ParamByName('@VOL').Value:=VP;
      ExecProc;
      DTA2:=Parameters.ParamByName('@DU').Value;
      VP:=Parameters.ParamByName('@VO').Value;
      PO:=Round(DTA1 - fDTA);
      PP:=Round(DTA2 - fDTA);
    end;
  end;
end;


{*** ������� ��� ��������� IDNR ***}
function GenerateIDNR(cNN: TDateTime; cDigitNR, cVR: string): string;
var
  cYear, cMonth, cDay: word;
  sYear, sMonth, sDay: string[2];
  strNN: string[6];
begin
  DecodeDate(cNN, cYear, cMonth, cDay);
  if cYear > 1000 then sYear:=copy(IntToStr(cYear),3,2)
                  else sYear:=IntToStr(cYear);
  while length(sYear) < 2 do sYear:='0'+sYear;
  sMonth:=IntToStr(cMonth);
  while length(sMonth) < 2 do sMonth:='0'+sMonth;
  sDay:=IntToStr(cDay);
  while length(sDay) < 2 do sDay:='0'+sDay;
  strNN:=sDay+sMonth+sYear;
  if cVR = '�' then Result:=strNN + cDigitNR + '10'
               else Result:=strNN + cDigitNR + '00';
end;

{*** ������� ��� �������� ������� �� 1246 � 12_4_6_ ***}
function DottedCD(cCD: string): string;
var
  DottedCD: string;
begin
  DottedCD:='_______';
  while length(cCD) <> 0 do begin
    delete(DottedCD, StrToInt(copy(cCD,1,1)), 1);
    insert(copy(cCD,1,1), DottedCD, StrToInt(copy(cCD,1,1)));
    delete(cCD,1,1);
  end;
  Result:=DottedCD;
end;

{*** ������� ��� �������� ������� �� 246 � 0204060 ***}
function ZeroCD(CD: string): string;
var
  cCD: string;
  k: integer;
begin
  cCD:='0000000';
  for k:=1 to length(CD) do
  if pos(copy(CD, k, 1), cCD) = 0 then begin
    insert(copy(CD, k, 1), cCD, StrToInt(copy(CD, k, 1)));
    delete(cCD, StrToInt(copy(CD, k, 1))+1, 1)
  end;
  Result:=cCD;
end;

{*** ������� ��� ������ �������. ����: (246, 3) - ����� 257 ***}
function SdvigCD(CD: string; sdv: integer): string;
var
  cCD: string;
  i: integer;
  arCD1, arCD2: array [1..7] of integer;
begin
  for i:=1 to 7 do arCD1[i]:=0;
  for i:=1 to 7 do arCD2[i]:=0;
  for i:=1 to length(CD) do begin
    arCD1[i]:=StrToInt(copy(CD, i, 1));
    arCD1[i]:=arCD1[i] + sdv;
    if arCD1[i] > 7 then arCD1[i]:=arCD1[i] - 7;
  end;
  for i:=1 to 7 do if arCD1[i] <> 0 then arCD2[arCD1[i]]:=arCD1[i];
  cCD:='';
  for i:=1 to 7 do if arCD2[i] <> 0 then cCD:=cCD + IntToStr(arCD2[i]);
  Result:=cCD;
end;

{*** �-��� ��� �������������� TDateTime � ������ ������  ***}
function GetInvertDate (cDTA: TDateTime): string;
var
  cSTR: string;
  Year, Month, Day: word;
begin
  cSTR:='';
  DecodeDate(cDTA, Year, Month, Day);
  cSTR:=copy(IntToStr(Year), 3, 2);
  if Month < 10 then cStr:=cSTR + '0' + IntToStr(Month)
                else cStr:=cSTR + IntToStr(Month);
  if Day < 10 then cStr:=cSTR + '0' + IntToStr(Day)
              else cStr:=cSTR + IntToStr(Day);
  Result:=cSTR;
end;

{*** �-��� ��� �������������� TDateTime � ������ ����-��  ***}
function GetYear (cDTA: TDateTime): string;
var
  cSTR: string;
  Year, Month, Day: word;
begin
  cSTR:='';
  DecodeDate(cDTA, Year, Month, Day);
  cSTR:=IntToStr(Year);
{  if Month < 10 then cStr:=cSTR + '-0' + IntToStr(Month)
                else cStr:=cSTR + '-' + IntToStr(Month);}
  Result:=cSTR;
end;

{*** �-��� ��� �������������� TDateTime � ������ '24 ����� 2001'  ***}
function GetRusDate(cDTA: TDateTime): string;
var
  Day, Month, Year: word;
begin
  DecodeDate(cDTA, Year, Month, Day);
  if Day < 10 then Result:='0' + IntToStr(Day) + ' ' + RMonth[Month] + ' ' + IntToStr(Year)
              else Result:=IntToStr(Day) + ' ' + RMonth[Month] + ' ' + IntToStr(Year);
end;

{*** �-��� ��� �������������� TDateTime � ������ '24���01'  ***}
function GetShortRusDate(cDTA: TDateTime): string;
var
  Day, Month, Year: word;
begin
  DecodeDate(cDTA, Year, Month, Day);
  if Day < 10 then Result:='0' + IntToStr(Day) + RSMonth[Month] + copy(IntToStr(Year),3,2)
              else Result:=IntToStr(Day) + RSMonth[Month] + copy(IntToStr(Year),3,2);
end;

{*** �-��� ��� �������������� TDateTime � ������ '24 APR'  ***}
function GetEngDate(cDTA: TDateTime): string;
var
  Day, Month, Year: word;
begin
  DecodeDate(cDTA, Year, Month, Day);
  Result:=IntToStr(Day) + ' ' + EMonth[Month];
end;

procedure MyStrDelete(cI, cC: integer; var cS: string);
begin
  delete(cS, cI, cC);
end;

{*** ����������� ������ ���� ��9551/Z86701/Z86702 � ���: ���9551/PLK6701/PLK6702 ***}
function ConvertStringOfFlightsInICAO(cSTR: string): string;
var
  i: integer;
  arNRs: array of string;
begin
  i:=0;
  SetLength(arNRs, 1);
  if pos('/', cSTR) > 0 then begin
    while pos('/', cSTR) > 0 do begin
      arNRs[i]:=copy(cSTR, 1, pos('/', cSTR)-1);
      SetLength(arNRs, High(arNRs) + 2);
      MyStrDelete(1, pos('/', cSTR), cSTR);
      Inc(i);
    end;
  end;
  arNRs[i]:=cSTR;
  for i:=0 to High(arNRs) do arNRs[i]:=GetICAOFlight(arNRs[i]);
  cSTR:=arNRs[0];
  for i:=1 to High(arNRs) do cSTR:=cSTR + ' / ' + arNRs[i];
  Result:=cSTR;
end;

{*** ����������� ������� ��������� '01W' � ��� 'W01' ***}
function ReversePref(cSTR: string): string;
var
  cS:string;
begin
  cS:=copy(cSTR, 3, 1);
  delete(cSTR, 3, 1);
  Result:=cS + cSTR;
end;

{*** �-��� ��� ��������� 3-� �����. ���� ����, � �� ����������� �� ���� ��� �������� �� ����,
     �� �� ���� ��� ����_� ***}
function GetEnglishAP(cAP: string): string;
begin
  if cAP > 'zzz' then with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT iata FROM dbo.port_n WHERE ap = :AP');
    Parameters.ParamByName('AP').Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=FieldByName('IATA').AsString
                       else Result:=cAP;
    Close;
  end else Result:=cAP;
end;

function GetRussianAP(cAP: string): string;
begin
    with TADOQuery.Create(nil) do
    begin
        Connection := DataM.RDSConn;
        Close;
        SQL.Clear;
        SQL.Add('SELECT ap FROM nsi.dbo.port_n WHERE iata = :iata');
        Parameters.ParamByName('iata').Value:=cAP;
        Open;
        if RecordCount > 0 then
            Result:=FieldByName('AP').AsString
        else
            Result:=cAP;

        Close;
    end;
end;

{*** �-��� ��� ��������� 3-� �����. �/� ���� ���� ��, � �� ����������� �� ���� ��� �������� �� ����,
     �����. ��� �/� ��� ***}
function GetEnglishTS(cTS: string): string;
begin
  if cTS > 'zzz' then with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ts_m FROM dbo.type_vs WHERE ts = :TS');
    Parameters.ParamByName('TS').Value:=cTS;
    Open;
    if RecordCount > 0 then Result:=FieldByName('TS_M').AsString
                       else Result:=cTS;
    Close;
  end else Result:=cTS;
end;

{*** �-��� ��� ��������� 3-� �����. �����. ���� ���� ��, � �� ����������� �� ���� ��� �������� �� ����,
     �����. ��� �/� ��� ***}
function GetRussianTS(const cTS: string): string;
begin
 Result := cTS;
 with DataM.qrNSItmp do begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT ts FROM dbo.type_vs WHERE ts_m = :ts');
  Parameters.ParamByName('ts').Value:=cTS;
  Open;
  if not Eof then
   Result := FieldByName('ts').AsString;
  Close
 end
end;


{*** ��������� ������� ������� (VO VP) �� ���� ������ � ������� ����
     ������ ������� � ���� ��:�� ***}
function GetTimeDiff(cTIME1, cTIME2: string): string;
var
  iH, iM: integer;
  iT1, iT2, iD: integer;
begin
  iT1:=StrToInt(copy(cTIME1, 1, 2))*60 + StrToInt(copy(cTIME1, 3, 2)); // cTIME1 � �������
  iT2:=StrToInt(copy(cTIME2, 1, 2))*60 + StrToInt(copy(cTIME2, 3, 2)); // cTIME2 � �������
  if iT2 < iT1 then iT2:=iT2 + 24*60;
  iD:=iT2 - iT1;

  iH:=Round(Int(iD/60)); // ����
  iM:=iD - Round(Int(iD/60))*60; // ������
  if iM < 10 then Result:=IntToStr(iH) + ':0' + IntToStr(iM)
             else Result:=IntToStr(iH) + ':' + IntToStr(iM);
end;

{*** ��������� ���������� � ���������� � ������������� ���� �/�         ***
 *** cAP - ����� ��� �/� (����); cAPv - ��. ���, cAPm - �/� ��� (�����) ***}
procedure GetAPTogether(cAP: string; var cAPv, cAPm: string);
begin
  with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ap, iata');
    SQL.Add('FROM nsi.dbo.port_n');
    SQL.Add('WHERE ap = :AP OR iata = :AP');
    Parameters[0].Value:=cAP;
    Parameters[1].Value:=cAP;
    Open;
    cAPv:=FieldByName('AP').AsString;
    cAPm:=FieldByName('IATA').AsString;
    Close;
  end;
end;

procedure CheckTLGForAFTN(var cStrngs: TStrings);
var
  _i, _j, LastSpace: integer;
  cSTR, adSTR: string;
  ccST: TStrings;
begin
  ccST:=cStrngs;
  for _i:=0 to cStrngs.Count-1 do begin
    cSTR:=cStrngs[_i];
    if length(cSTR) > 64 then begin
      _j:=0;
      LastSpace:=0;
      while (_j <= 64) and (_j < Length(cSTR)) and (LastSpace < 64) do begin
        if cSTR[_j] = ' ' then LastSpace:=_j;
        Inc(_j);
      end;
      if LastSpace > 0 then begin
        adSTR:=copy(cSTR, LastSpace+1, Length(cSTR)-LastSpace);
        delete(cSTR, LastSpace+1, Length(cSTR)-LastSpace);
        ccST[_i]:=cSTR;
        ccST.Insert(_i+1, adSTR);
      end;
    end;
  end;
  cStrngs:=ccST;
end;

function AnTheSameIntArrays(AR1, AR2: array of integer): boolean;
var
  _i: integer;
begin
  Result:=True;
  if High(AR1) = High(AR2) then begin
    if High(AR1) = 0 then begin
      if AR1[0] <> AR2[0] then Result:=False;
    end else begin
      for _i:=1 to High(AR1) do if AR1[_i] <> AR2[_i] then begin
        Result:=False;
        Break;
      end;
    end;
  end else Result:=False;
end;

function AnTheSameStrArrays(AR1, AR2: array of string): boolean;
var
  _i: integer;
begin
  Result:=True;
  if High(AR1) = High(AR2) then begin
    if High(AR1) = 0 then begin
      if AR1[0] <> AR2[0] then Result:=False;
    end else begin
      for _i:=0 to High(AR1) do if AR1[_i] <> AR2[_i] then begin
        Result:=False;
        Break;
      end;
    end;
  end else Result:=False;
end;

(* SAS *)

function IIFS( lOk: boolean; const s1, s2: string ): string;
begin
 if lOk then
  Result := s1
 else
  Result := s2
end;

function IIFI( lOk: boolean; s1, s2: integer ): integer;
begin
 if lOk then
  Result := s1
 else
  Result := s2
end;

function IIFD( lOk: boolean; s1, s2: double ): double;
begin
 if lOk then
  Result := s1
 else
  Result := s2
end;

function IIFB( lOk: boolean; b1, b2: boolean ): boolean;
begin
 if lOk then
  Result := b1
 else
  Result := b2
end;

function IIFP( lOk: boolean; p1, p2: pointer ): pointer;
begin
 if lOk then
  Result := p1
 else
  Result := p2
end;

{�������� �� ������ �������}
function EmptS( const cStr: string ): boolean;
begin
 Result := Trim( cStr ) = EmptyStr
end;

{*** �-��� ��� �������������� ������� TDateTime � ������ ���� '03,11,24 MAR, 15 MAY'
     ����� ���������� ������� ����� ��������� � ������ ���� �� �������������� ***}
function GetDatesForGSGA_PlanningE( arDTAs: array of TDateTime; sdv: integer ): string;
var
  i         : integer;
  Day,
  Month,
  Year,
  PrevMonth : word;
  cDTAs     : string;
begin
 cDTAs := EmptyStr;
 for i := 0 to High(arDTAs) do
  arDTAs[i] := arDTAs[i] + sdv;
 DecodeDate( arDTAs[0], Year, Month, Day );
 cDTAs := IIFS( Day <= 9, '0', EmptyStr ) + IntToStr( Day );
 prevMonth := Month;
 if High(arDTAs) > 0 then
  for i := 1 to High(arDTAs) do begin
   DecodeDate( arDTAs[i], Year, Month, Day );
   if Month <> prevMonth then
    cDTAs := cDTAs + ' ' + EMonth[prevMonth] + ', ';
   cDTAs  := cDTAs + IIFS( cDTAs[Length(cDTAs)] = ' ', EmptyStr, ',' ) +
             IIFS( Day <= 9, '0', EmptyStr ) + IntToStr(Day);
   prevMonth := Month
  end;
 cDTAs  := cDTAs + ' ' + EMonth[prevMonth];
 Result := cDTAs
end;

function GetDatesForGSGA_PlanningR( arDTAs: array of TDateTime; sdv: integer ): string;
var
  i         : integer;
  Day,
  Month,
  Year,
  PrevMonth : word;
  cDTAs     : string;
begin
 cDTAs := EmptyStr;
 for i := 0 to High(arDTAs) do
  arDTAs[i] := arDTAs[i] + sdv;
 DecodeDate( arDTAs[0], Year, Month, Day );
 cDTAs := IIFS( Day <= 9, '0', EmptyStr ) + IntToStr( Day );
 prevMonth := Month;
 if High(arDTAs) > 0 then
  for i := 1 to High(arDTAs) do begin
   DecodeDate( arDTAs[i], Year, Month, Day );
   if Month <> prevMonth then
    cDTAs := cDTAs + ' ' + RSMonth[prevMonth] + ', ';
   cDTAs  := cDTAs + IIFS( cDTAs[Length(cDTAs)] = ' ', EmptyStr, ',' ) +
             IIFS( Day <= 9, '0', EmptyStr ) + IntToStr(Day);
   prevMonth := Month
  end;
 cDTAs  := cDTAs + ' ' + RSMonth[prevMonth];
 Result := cDTAs
end;

function GetEnglishUga( const cUga: string ): string;
begin
 Result := cUga;
 if cUga <> EmptyStr then
  if cUga[1] > 'z' then
   with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add( 'SELECT ik FROM dbo.company WHERE ik_r = :UGA' );
    Parameters.ParamByName('UGA').Value := cUga;
    Open;
    if not Eof then
     Result := FieldByName('ik').AsString;
    Close
   end
end;

function GetEnglishUga2( const cUga: string ): string;
begin
 Result := cUga;
 if cUga <> EmptyStr then
   with DataM.qrNSItmp do begin
    Close;
    SQL.Clear;
    SQL.Add( 'SELECT iata FROM dbo.company WHERE (ik_r = :UGA1 OR ik = :UGA2) and (do is null or do >= getdate())' );
    Parameters.ParamByName('UGA1').Value := cUga;
    Parameters.ParamByName('UGA2').Value := cUga;
    Open;
    if not Eof then
     Result := FieldByName('iata').AsString;
    Close
   end
end;

function Left( const StrSource: string; Len: integer ): string;
begin
 if Length(StrSource) <= Len then
  Result:= StrSource
 else
  Result:= Copy(StrSource, 1, Len)
end;

function GetSubStr( cDelim: char; const cStr: string; nPos: integer ): string;
var
  nj,
  jj   : integer;
  cTmp : string;

begin
 cTmp := cStr;
 for nj:= 0 to nPos - 1 do begin
 {���������� �������� �������}
  jj:= Pos(cDelim, cTmp);
  if jj = 0 then begin
   cTmp:= EmptyStr;
   Break
  end;
  Delete(cTmp, 1, jj)
 end;
 if Pos(cDelim, cTmp) > 0 then
  Result:= Left(cTmp, Pos(cDelim, cTmp) - 1)
 else
  Result:= cTmp
end;

(* SAS *)


{*** �������� ���� ��������� �������� ������� '0630' + '0135' = '0805' ***}
function AddTime(cTIME, cDUR: string): string;
var
  cM1, cM2: integer;
  iR: extended;
  cR: string;
begin
  cM1:=StrToInt(copy(cTIME, 1, 2))*60 + StrToInt(copy(cTIME, 3, 2));
  cM2:=StrToInt(copy(cDUR, 1, 2))*60 + StrToInt(copy(cDUR, 3, 2));
  cM1:=cM1 + cM2;
  iR:=Int(cM1/60);
  cR:=FloatToStr(iR);
  if cM1 - Int(cM1/60)*60 < 10 then cR:=cR + '0' + FloatToStr(cM1 - Int(cM1/60)*60)
                               else cR:=cR + FloatToStr(cM1 - Int(cM1/60)*60);
  if length(cR) = 3 then cR:='0' + cR;
  Result:=cR                               
end;

{*** �������� 3-� ����. ���� �/� �� ����������� � ��� ***}
function CheckAPExists(cAP: string): boolean;
begin
  with DataM.qrNSItmp2 do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ap FROM dbo.port_n WHERE ap = :AP OR iata = :AP');
    Parameters.ParamByName('AP').Value:=cAP;
    Open;
    if RecordCount > 0 then Result:=True
                       else Result:=False;
    Close;
  end;
end;

{*** �������� 2-� ����. ���� ������ �� ����������� � ��� ***}
function CheckCCExists(cCC: string): boolean;
begin
  with DataM.qrNSItmp2 do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT cc FROM dbo.country WHERE cc = :CC');
    Parameters.ParamByName('CC').Value:=cCC;
    Open;
    if RecordCount > 0 then Result:=True
                       else Result:=False;
    Close;
  end;
end;

{*** ��������� ��� �������������� ������ 25.03.03$30.03.03 � ������ TDateTime
     ���������� ����������� ***}
function GetArrOfDatesFromString(cSTR, cDELIM: string): TarDTAs;
var
  arDTAs: TarDTAs;
begin
  SetLength(arDTAs, 0);
  if length(cSTR) > 0 then begin
    while pos(cDELIM, cSTR) > 0 do begin
      SetLength(arDTAs, High(arDTAs) + 2);
      arDTAs[High(arDTAs)]:=StrToDate(copy(cSTR, 1, pos(cDELIM, cSTR)-1));
      delete(cSTR, 1, pos(cDELIM, cSTR));
    end;
    SetLength(arDTAs, High(arDTAs) + 2);
    arDTAs[High(arDTAs)]:=StrToDate(cSTR);
  end;
  Result:=arDTAs;
end;

{�������� �������� ����� aColor �� aValue ������ (0..255)}
function ObscureColor(aColor: tColor; aValue: integer): tColor;
var
  _r, _g, _b: integer;
begin
 _r := GetRValue(ColorToRGB(aColor));
 _g := GetGValue(ColorToRGB(aColor));
 _b := GetBValue(ColorToRGB(aColor));
 if _r < aValue then
  _r := 0
 else
  _r := _r - aValue;
 if _g < aValue then
  _g := 0
 else
  _g := _g - aValue;
 if _b < aValue then
  _b := 0
 else
  _b := _b - aValue;
 Result := RGB(_r, _g, _b)
end;

function MakeStr(C: Char; N: Integer): string;
begin
  if N < 1 then Result := ''
  else begin
{$IFNDEF WIN32}
    if N > 255 then N := 255;
{$ENDIF WIN32}
    SetLength(Result, N);
    FillChar(Result[1], Length(Result), C);
  end;
end;

function AddChar(C: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := MakeStr(C, N - Length(S)) + S
  else Result := S;
end;

function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do begin
    if Result[I] = Chr then Delete(Result, I, 1);
  end;
end;

function AddCharR(C: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := S + MakeStr(C, N - Length(S))
  else Result := S;
end;

procedure SelectComboBoxIndex(CB : TComboBox; Str : string);
var i : integer;
begin
    for i := 0 to CB.Items.Count - 1 do
    begin
        if CB.Items[i] = Str then
            CB.ItemIndex := i;
    end;
end;

procedure TreeViewDataClear(TV : TTreeView; NP : TNewProc); // RIVC_Navbatov 03.06.2009
var i : integer;
    TN : TTreeNode;
    P : Pointer;
begin
    for i := 0 to TV.Items.Count - 1 do
    begin
        TN := TV.Items[i];
        P := TN.Data;
        if ((TN <> nil) and (P <> nil)) then
        begin
            NP(P);
            TN.Data:=nil;
        end;
    end;

    TV.Items.Clear;
end;

procedure TreeViewDataClear_Ext(TV : TTreeView); //; NP : TNewProc); // RIVC_Navbatov 06.02.2009
var i : integer;
    TN : TTreeNode;
    P : Pointer;
    DeleteFunc : TNewProc;
begin
    for i := 0 to TV.Items.Count - 1 do
    begin
        TN := TV.Items[i];
        P := TN.Data;
        @DeleteFunc := pointer(TV.Tag);
        if ((TN <> nil) and (P <> nil) and (@DeleteFunc <> nil)) then
        begin
            DeleteFunc(P);
            TN.Data:=nil;
        end;
    end;

    TV.Items.Clear;
end;

// ������� ������ � ����
function FindNodeEx(VT : TVirtualStringTree; ANode: PVirtualNode;
                    const APattern: String; Param : integer): PVirtualNode;
var NextNode: PVirtualNode;
    NodeData: PDataInfo;
begin
    Result := nil;
    NextNode := ANode.FirstChild;
    if Assigned(NextNode) then
    repeat
        NodeData := VT.GetNodeData(NextNode);
        if Assigned(NodeData) then
        begin
            if Param = 1 then
            begin
                if NodeData^.id = APattern then
                begin
                    Result := NextNode;
                    Exit;
                end;
            end
            else
            if Param = 2 then
            begin
                if NodeData^.NodeName = APattern then
                begin
                    Result := NextNode;
                    Exit;
                end;
            end;
        end;

        Result := FindNodeEx(VT, NextNode, APattern, Param);
        if Assigned(Result) then exit;

        // ��������� �� �������� �����
        NextNode := NextNode.NextSibling;
    until
        NextNode = nil;
end;

// ������� ��� ��������� ������ �� �����
// ������ : ������� �.
function GetTimeFromStr(StrTime, Sep: string): TDateTime;
var Hour, Min, Sec, MSec: Word;
    Sign: ShortInt;
begin
    Sign:=0;
    if Copy(StrTime,1,1) = '-' then Sign := 1;

    if Sep = ' ' then
    begin
        Hour := StrToInt(Copy(StrTime, 1 + Sign, 2));
        Min := StrToInt(Copy(StrTime, 3 + Sign, 2));
    end
    else
    begin
        Hour := StrToInt(Copy(StrTime, 1+Sign, Pos(Sep, StrTime) - (1 + Sign)));
        Min := StrToInt(Copy(StrTime, Pos(Sep, StrTime) + 1, 2));
    end;

    Sec := 0;
    MSec := 0;
    if (Hour = 24) and (Min = 0) then Result := 1
    else Result := EncodeTime(Hour, Min, Sec, MSec);

    if Sign = 1 then Result := -1*Result
end;

// ��������� �������� ��������� ��� �������
function GetTemplateDataParams(ADDR, OVF : string; NP : TParamProc) : string;
var
    SP1, SP2 : TADOStoredProc;
    i : integer;
    str1, str2, TemplateDataStr : string;
    arParams : array of OleVariant;
begin
    TemplateDataStr := '';
    SP1 := TADOStoredProc.Create(nil);
    try
        SP1.Connection := DataM.RDSConn;
        SP1.ProcedureName := 'dbo.spGOOP_GetReguestFormat';
        SP1.Close;
        SP1.Parameters.Refresh;

        SP1.Parameters.ParamByName('@ADDR').Value := ADDR;
        SP1.Parameters.ParamByName('@OVF').Value := OVF;
        SP1.Open;
        TemplateDataStr := SP1.FieldByName('TXT').AsString; // ����� �������

        SP2 := TADOStoredProc.Create(nil);
        try
            SP2.Connection := DataM.RDSConn;
            SP2.ProcedureName := SP1.FieldByName('stored_proc_name').AsString;

            if length(SP2.ProcedureName) > 0 then
            begin
                SP2.Close;
                SP2.Parameters.Refresh;

                SetLength(arParams, 0);
                SetLength(arParams, SP2.Parameters.Count);
                NP(arParams); // ������ ��������� ���������

                for i := 1 to SP2.Parameters.Count - 1 do
                begin
                    SP2.Parameters.Items[i].Value := arParams[i];
                end;

                SP2.Open;

                // �������� �� ��������� �� ������
                if SP2.RecordCount = 1 then
                if SP2.Fields[0].FieldName = 'ErrorMessage' then
                begin
                    result := SP2.FieldByName(SP2.FieldList.Fields[0].FieldName).AsString;
                    exit;
                end;

                if SP2.RecordCount > 0 then
                for i := 0 to SP2.Fields.Count - 1 do
                begin
                    str1 := '$'+SP2.FieldList.Fields[i].FieldName+'&';
                    str2 := SP2.FieldByName(SP2.FieldList.Fields[i].FieldName).AsString;
                    TemplateDataStr := StringReplace(TemplateDataStr,
                                                    str1,
                                                    str2,
                                                    [rfReplaceAll]);
                end;

                SP2.Close;
            end;

        finally
            SP2.Free;
        end;

        SP1.Close;
    finally
        SP1.Free;
    end;

    result := TemplateDataStr;
end;

procedure VirtualTreeFill(SP : TADOStoredProc; VT : TVirtualStringTree);
var Node, NewNode, NextRootNode : PVirtualNode;
    NodeData, RootChildNodeData : PDataInfo;
    temp_str : string;

    // ������� ������ � ����
    function FindNode(ANode: PVirtualNode; const APattern: String): PVirtualNode;
    var NextNode: PVirtualNode;
        NodeData: PDataInfo;
    begin
        Result := nil;
        NextNode := ANode.FirstChild;
        if Assigned(NextNode) then
        repeat
            NodeData := VT.GetNodeData(NextNode);
            if Assigned(NodeData) then
            begin
                if NodeData^.id = APattern then
                begin
                    Result := NextNode;
                    Exit;
                end;
            end;

            Result := FindNode(NextNode, APattern);
            if Assigned(Result) then exit;

            // ��������� �� �������� �����
            NextNode := NextNode.NextSibling;
        until
            NextNode = nil;
    end;
begin
    try
        SP.Close;
        SP.Open;

        while not SP.EOF do
        begin
            // ����� ������
            Node := nil;
            if VT.RootNodeCount > 0 then
            begin
                temp_str := SP.FieldByName('parent_id').AsString;
                Node := FindNode(VT.RootNode, temp_str);
            end;

            // ���������� ���� � ������
            NewNode := VT.AddChild(Node);
            NodeData := VT.GetNodeData(NewNode);
            if Assigned(NodeData) then
            begin
                with NodeData^ do
                begin
                    id := SP.FieldByName('id').AsString;
                    NodeName := SP.FieldByName('NodeName').AsString;
                    ImageIndex := SP.FieldByName('ImageIndex').AsInteger;
                    SelectedIndex := SP.FieldByName('SelectedIndex').AsInteger;
                    parent_id := SP.FieldByName('parent_id').AsString;
                end;
            end;

            // ����� ����� ����� � ����� �������� ������������ ����
            Node := VT.RootNode.FirstChild;
            while Assigned(Node) do
            begin
                NextRootNode := Node.NextSibling;

                RootChildNodeData := VT.GetNodeData(Node);
                if Assigned(RootChildNodeData) then
                begin
                    if RootChildNodeData^.parent_id = NodeData^.id then
                    begin
                        // ����������� ���� ������ ����-������
                        if RootChildNodeData.id <> NodeData.id then // ����� ���� !!!
                        begin
                            VT.MoveTo(Node, NewNode, amAddChildLast, False); // True);
                        end;
                    end;
                end;

                // ��������� �� �������� �����
                Node := NextRootNode;
            end;

            SP.Next;
        end; // while not EOF
    finally
        SP.Close;
    end;
end;

procedure VirtualTreeFill_Ex(SP : TADOStoredProc; VT : TVirtualStringTree);
var Node, NewNode, NextRootNode : PVirtualNode;
    NodeData, RootChildNodeData : PDataInfo;
    temp_str : string;
    i  : integer;
    CheckedTree : boolean;

    // ������� ������ � ����
    function FindNode(ANode: PVirtualNode; const APattern: String): PVirtualNode;
    var NextNode: PVirtualNode;
        NodeData: PDataInfo;
    begin
        Result := nil;
        NextNode := ANode.FirstChild;
        if Assigned(NextNode) then
        repeat
            NodeData := VT.GetNodeData(NextNode);
            if Assigned(NodeData) then
            begin
                if NodeData^.id = APattern then
                begin
                    Result := NextNode;
                    Exit;
                end;
            end;

            Result := FindNode(NextNode, APattern);
            if Assigned(Result) then exit;

            // ��������� �� �������� �����
            NextNode := NextNode.NextSibling;
        until
            NextNode = nil;
    end;
begin
    try
        SP.Close;
        SP.Open;

        CheckedTree := False;
        if ((VT.TreeOptions.MiscOptions + [toCheckSupport]) =
            VT.TreeOptions.MiscOptions) then CheckedTree := True; // CheckBox-�

        if SP.RecordCount = 0 then exit;
        while not SP.EOF do
        begin
            // ����� ������
            Node := nil;
            if VT.RootNodeCount > 0 then
            begin
                temp_str := SP.FieldByName('parent_id').AsString;
                Node := FindNode(VT.RootNode, temp_str);
            end;

            // ���������� ���� � ������
            NewNode := VT.AddChild(Node);
            NodeData := VT.GetNodeData(NewNode);
            if Assigned(NodeData) then
            begin
                with NodeData^ do
                begin
                    id := SP.FieldByName('id').AsString;
                    NodeName := SP.FieldByName('NodeName').AsString;
                    ImageIndex := SP.FieldByName('ImageIndex').AsInteger;
                    SelectedIndex := SP.FieldByName('SelectedIndex').AsInteger;
                    parent_id := SP.FieldByName('parent_id').AsString;

                    if CheckedTree then // ��������� CheckBox-��
                    begin
                        checked := SP.Fields[SP.FieldCount - 1].AsInteger;
                        NewNode.CheckType := ctTriStateCheckBox; //ctCheckBox;
                        if checked > 0 then
                            VT.CheckState[NewNode] := csCheckedNormal
                        else
                        if assigned(NewNode.Parent)
                        and Assigned(VT.GetNodeData(NewNode.Parent)) then
                        begin
                            if PDataInfo(VT.GetNodeData(NewNode.Parent))^.checked > 0 then
                            begin
                                VT.CheckState[NewNode] := csCheckedNormal;
                                checked := 1;
                            end
                            else
                            begin
                                VT.CheckState[NewNode] := csUncheckedNormal;
                                checked := 0;
                            end;
                        end;
                    end;
                end;

                SetLength(NodeData^.ExData, 0);
                SetLength(NodeData^.ExData, SP.FieldCount - 5);

                for i := 0 to High(NodeData^.ExData) do
                    NodeData^.ExData[i] := SP.Fields[i + 5].AsVariant;
            end;

            // ����� ����� ����� � ����� �������� ������������ ����
            Node := VT.RootNode.FirstChild;
            while Assigned(Node) do
            begin
                NextRootNode := Node.NextSibling;

                RootChildNodeData := VT.GetNodeData(Node);
                if Assigned(RootChildNodeData) then
                begin
                    if RootChildNodeData^.parent_id = NodeData^.id then
                    begin
                        // ����������� ���� ������ ����-������
                        if RootChildNodeData.id <> NodeData.id then // ����� ���� !!!
                        begin
                            VT.MoveTo(Node, NewNode, amAddChildLast, False); // True);
                        end;
                    end;
                end;

                // ��������� �� �������� �����
                Node := NextRootNode;
            end;

            SP.Next;
        end; // while not EOF
    finally
        SP.Close;
    end;
end;

function VirtualTreeNodeAssigned(Sender : TBaseVirtualTree;
                                Node : PVirtualNode;
                                var Data : PDataInfo) : boolean;
begin
    result := False;
    if Assigned(Node) then
    begin
        Data := Sender.GetNodeData(Node);
        if Assigned(Data) then
            result := True;
    end;
end;

procedure VirtualTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var P : PDataInfo;
    i : integer;
begin
    // ����������� ������, ���������� ��� ������ ����
    P := (Sender as TVirtualStringTree).GetNodeData(Node);
    if Assigned(P) then
    begin
        for i := 0 to High(P^.ExData) do
        begin
            P^.ExData[i] := Unassigned;
        end;

        SetLength(P^.ExData, 0);

        Finalize(P^);
    end;
end;

procedure VirtualTreeExecCheck(VT : TVirtualStringTree;
                                Node : PVirtualNode;
                                TreeProc : TNewObjProc);
var CurrNode, NextNode : PVirtualNode;
begin
    if Assigned (Node) then
    begin
        TreeProc(Node);

        // - �������� ��� ������� ������ ����
        if Node.ChildCount > 0 then
        begin
            CurrNode := Node.FirstChild;
            while Assigned(CurrNode) do
            begin
                NextNode := CurrNode.NextSibling;

                if CurrNode.ChildCount > 0 then
                begin
                    VirtualTreeExecCheck(VT, CurrNode, TreeProc);
                end
                else
                begin
                    TreeProc(CurrNode);
                end;

                // ��������� �� �������� �����
                CurrNode := NextNode;
            end;
        end;
    end;
end;

// ����� ���������� ���� � ������
function NextNode(Node : TTreeNode) : TTreeNode;
var CurrNode : TTreeNode;
begin
    // - ���� ���� ��������, ������ ������
    if Node.HasChildren then
    begin
        Result := Node.getFirstChild;
    end
    else
    begin
        // - ����� ����� ��������� � ���������� ���� �� ������
        CurrNode := Node.getNextSibling;
        if Assigned(CurrNode) then
        begin
            Result := CurrNode;
        end
        else
        begin
            CurrNode := Node.Parent;

            while (Assigned(CurrNode)) and (CurrNode.getNextSibling = nil) do
            begin
                CurrNode := CurrNode.Parent;
            end;

            if Assigned(CurrNode) then
                Result := CurrNode.getNextSibling
            else
                Result := nil;
        end;
    end;
end;

function FindNode(Tree : TTreeView; Node : TTreeNode; Str : string) : TTreeNode;
var CurrNode, ParantNode : TTreeNode;
begin
    CurrNode := NextNode(Node);

    if not Assigned(CurrNode) then
    begin
        Result := CurrNode;
        exit;
    end;

    if Length(CurrNode.Text) < 0 then exit;

    while Assigned(CurrNode) do
    begin
        if pos(Str, CurrNode.Text) > 0 then
        begin
            CurrNode.Selected := True;;
            //Tree.SetFocus;

            ParantNode := CurrNode.Parent;
            while Assigned(ParantNode) do
            begin
                if not ParantNode.Expanded then
                    ParantNode.Expand(False);

                ParantNode := ParantNode.Parent;
            end;

            break;
        end;

        CurrNode := NextNode(CurrNode);
    end;

    Result := CurrNode;
end;

// ������������� �������
procedure SetSeasonsForComboBox(SP : TADOStoredProc; CB : TComboBox);
var i : integer;
    pSeason : PSeasonInfo;
begin
    try
        if not SP.Active then SP.Open;

        SP.First;

        with SP do
        begin
            while not Eof do
            begin
                New(pSeason);
                pSeason.idn := SP.FieldByName('idn').AsString;
                pSeason.BeginDate := SP.FieldByName('BeginDate').AsDateTime;
                pSeason.EndDate := SP.FieldByName('EndDate').AsDateTime;
                pSeason.Caption := SP.FieldByName('Caption').AsString;

                CB.Items.AddObject(pSeason.Caption, pointer(pSeason));

                SP.Next;
            end;
        end;
    finally
    end;
end;

procedure ClearSeasonsCB(CB : TComboBox);
var i : integer;
    pSeason : PSeasonInfo;
begin
    for i := 0 to CB.Items.Count - 1 do
    begin
        pSeason := PSeasonInfo(CB.Items.Objects[i]);
        if assigned(pSeason) then
        begin
            dispose(pSeason);
        end;
    end;
end;

procedure ComboBoxUpdate(CB : TComboBox; SPName : string; NP : TParamProc);
var pData : PComboBoxData;
    i : integer;
    arParams : array of OleVariant;
begin
    with TADOStoredProc.Create(nil) do
    try
        Close;
        Connection := DataM.RDSConn;
        ProcedureName := SPName;
        Parameters.Refresh;

        SetLength(arParams, 0);
        SetLength(arParams, Parameters.Count);
        NP(arParams); // ������ ��������� ���������

        // �������� ������
        for i := 0 to CB.Items.Count - 1 do
        begin
            if CB.Items.Objects[i] <> nil then
            begin
                pData := pointer(CB.Items.Objects[i]);
                dispose(pData);
            end;
        end;
        CB.Clear;

        CB.Items.AddObject('�� ������', nil);

        for i := 1 to min(Parameters.Count - 1, High(arParams)) do
        begin
            Parameters.Items[i].Value := arParams[i];
        end;

        Open;

        while not EOF do
        begin
            New(pData);
            pData.id := FieldByName('id').AsString;
            pData.text := FieldByName('text').AsString;

            CB.Items.AddObject(FieldByName('text').AsString, TObject(pData));
            Next;
        end;

        CB.ItemIndex := 0;
    finally
        Free;
    end;
end;

end.
