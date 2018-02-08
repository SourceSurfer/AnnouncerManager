unit Utils;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Consts, AdoDB, DBGrids, Windows,
  ExtCtrls, VCLUtils, ProfGrid, RXDBCtrl, DBTables, ComCtrls, StdCtrls,
  VirtualTrees;

const
  _NULL = 'NULL';
  CR_LF = #13#10;
  SECONDS_PER_DAY = 86400;

type
  TGradientKind = (gkHorz, gkVert);

  TResult = array of string;
  TExecReis = record
    iID  : Integer;
    cNR  : String;
    dtD  : TDateTime;
  end;

  TGridProc = procedure(Grid : TProfGrid) of object;

    // Структура для узлов VirtualSmallTree
    TDataArray = array of Variant;

    PDataInfo = ^TDataInfo;
    TDataInfo = record
        id,
        NodeName : String;
        ImageIndex,
        SelectedIndex : integer;
        parent_id : String;
        checked : integer;
        ExData : TDataArray; // дополнительные данные
    end;
    
{Если lOk тогда AValue1, иначе AValue2}
function iif(AOk: boolean; const AValue1, AValue2: integer): integer; overload;
function iif(AOk: boolean; const AValue1, AValue2: int64): int64; overload;
function iif(AOk: boolean; const AValue1, AValue2: double): double; overload;
function iif(AOk: boolean; const AValue1, AValue2: string): string; overload;
function iif(AOk: boolean; const AValue1, AValue2: boolean): boolean; overload;
function iif(AOk: boolean; const AValue1, AValue2: pointer): pointer; overload;
function iif(AOk: boolean; const AValue1, AValue2: Variant): Variant; overload;

{Trim справа и слева}
function AllTrim(const cStr: string): string;
{Удаление пробелов из строки}
function FullTrim(const cStr: string): string;
{Проверка на пустую строчку}
function EmptS(const cStr: string): boolean;
{преобразование строки для записи в базу}
function StrCheckOnNull(const _Str: string): string;
{преобразование даты для записи в базу}
function DateCheckOnNull(_date: tDateTime): string;
{Инвертировать значение (положительный -> отрицательный) если AInverse}
function InverseValue(AValue: integer; AInverse: boolean = true): integer;

{Выделение первых Len символов}
function Left(const StrSource: string; Len: integer): string;
{Выделение последних Len символов}
function Right(const StrSource: string; Len: integer): string;
{Выделение подстроки}
function Substr(const StrSource: string; nPos, Len: integer): string;
{Возвращает nPos-ную подстроку из строки cStr, cDelim - разделитель подстрок}
{nPos нумеруется с НУЛЯ (первый - 0!!!)}
function GetSubStr(cDelim: char; const cStr: string; nPos: integer): string;
{Добавление слева символа cChar до длины nCount}
function AddLeft(cChar: Char; const cStr: string; nCount: integer): string;
{Добавление справа символа cChar до длины nCount}
function AddRight(cChar: Char; const cStr: string; nCount: integer): string;
{Заменяет символы cFind на cRepl в строке сStr  и возвращает ее}
function CharReplace(cFind, cRepl: char; const cStr: string): string;
{Удаляет символы из строки}
function CharRem(cChr: char; const cStr: string): string;
{Считает кол-во символов cChr в строке сStr и возвращает его}
function CountChars(cChr: char; const cStr: string): integer;
{Поиск в строке сStr подстроки cSubStr начиная с позиции nPos}
{Если найдена - возвращвет номер позиции, иначе 0}
function FindInStr(const cSubStr: string; nPos: integer; const cStr: string): integer;
{Подсчитывает количество подстрок в строке}
function CountSubStr(cStr, cSubStr : String) : Integer;

{Вставить между символами строки strString последовательность strIn}
function InsertStrRepetition(strString, strIn : String) : String;

{Выбрать по дате навигацию}
function GetIDN(ADate: tDateTime): string;
{Получить начало навигации}
function GetBeginIDN(ADate: TDateTime): tDateTime;

{Проверка на валидную дату}
function IsValidDate(const cDate: string): boolean;
{*** Вычисляет разницу времени (VO VP) из двух времен в формате ЧЧММ
     выдает разницу в виде ЧЧ:ММ ***}
function GetTimeDiff(cTIME1, cTIME2: string): string;
function GetTimeDiffEx(Dta1, Dta2: tDate; const Time1, Time2: string): string;

{Вычисляет местное время по UTC времени: aTime - в формате ччмм, результат - чч:мм}
function GetTimeByUTC(const aTime: string; var lCh: boolean): string;

function ChangeTime(number : integer; const tmp : string): string;
{Задержка выполнения на nWait секунд}
procedure Wait(nWait: integer);
{MessageDlg, но всегда с нормальным курсором}
function MessDlg(const Msg: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons;
                  HelpCtx: Longint): Word;

{Преобразует время из формата ЧЧММ в формат ЧЧ:ММ}
function GetCoolTime(const cTime: string): string;
{Преобразует время из формата ЧЧ:ММ в формат ЧЧММ}
function GetUnCoolTime(const cTime: string): string;

{Инвертирует цвет}
function InvertColor(col: tColor): tColor;

{*** Возвращает день недели, переведенный на русский ***}
function GetDayOfWeek(cDTA: TDateTime): byte;
{*** Ф-ЦИЯ ДЛЯ ПРЕОБРАЗОВАНИЯ TDateTime В ФОРМАТ '24 марта 2001'  ***}
function GetRusDate(cDTA: TDateTime): string;

{*** Ф-ЦИЯ ДЛЯ ПРЕОБРАЗОВАНИЯ TDateTime В ФОРМАТ '24 APR'  ***}
function GetEngDate(cDTA: TDateTime): string;

procedure GradFill(DC: HDC; ARect: TRect; ClrTopLeft, ClrBottomRight: TColor;
  Kind: TGradientKind);

const EMonth: array[1..12] of string[3] =
             ('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');
const RMonth: array[1..12] of string =
             ('ЯНВАРЯ', 'ФЕВРАЛЯ', 'МАРТА', 'АПРЕЛЯ', 'МАЯ', 'ИЮНЯ', 'ИЮЛЯ', 'АВГУСТА', 'СЕНТЯБРЯ', 'ОКТЯБРЯ', 'НОЯБРЯ', 'ДЕКАБРЯ');


{Понижает значение цвета aColor на aValue единиц (0..255)}
function ObscureColor(aColor: tColor; aValue: byte): tColor;
{Повышает значение цвета aColor на aValue единиц (0..255)}
function RaiseColor(aColor: tColor; aValue: byte): tColor;

type
  TCanal = (tcRed, tcGreen, tcBlue);
  TCanals = set of TCanal;

{Понижает значение цвета AColor на AValue единиц (0..255) для каналов ACanals}
function ObscureColorEx(AColor: TColor; AValue: byte; ACanals: TCanals = [tcRed, tcGreen, tcBlue]): TColor;


function SumTime(cT1, cT2: string): string;

function finUTC (cDPM : TDateTime; cVPM : string): string;

function NormalizeName(const AName: string): string;
function DoubleToDegree(AVal: double): string;
function BuildDate(ADate: TDateTime; ATime: string): TDateTime;
{Вычисляет местное время по UTC времени: aTime - в формате ччмм, результат - ччмм,
 aDate - дата вычисления, lCh - произошла ли смена суток}
function GetTimeByUTCEx(const aTime: string; aDate: tDateTime; var lCh: boolean): string;
{Вычисляет UTC время по местное времени: aTime - в формате ччмм, результат - ччмм,
 aDate - дата вычисления, lCh - произошла ли смена суток}
function GetTimeByLocalEx(const aTime: string; aDate: tDateTime; var lCh: boolean): string;
function MinStrToInt(const AMin: string): integer;
function MinIntToStr(AMin: integer): string;
{Получаем кол-во минут по времени в формате ЧЧ:ММ, в случае ошибки возвр. nDef}
function MinutesByTime( const cTime: string; nDef: integer ): integer;
{Получаем кол-во минут по времени в формате ЧЧММ, в случае ошибки возвр. nDef}
function MinutesByTimeShort( const cTime: string; nDef: integer ): integer;
{Преобразование из минут в строку ЧЧ:ММ}
function TimeByMinutes(mn: integer): string;
{Преобразование из минут в строку: mn = 90, result = '1ч.30мин.'}
function TimeByMinutesEx(mn: integer): string;
{Усовершенствованный MessageDialog}
function MyMessageDialog(const Msg: string; DlgType: TMsgDlgType;
   Buttons: TMsgDlgButtons; Captions: array of string; Caption: String): Integer;

function MinutesBetweenEx(const AFrom, ATill: TDateTime): integer;
function SecondsBetweenEx(const AFrom, ATill: TDateTime): integer;

procedure VirtualTreeFill_Ex(SP : TADOStoredProc; VT : TVirtualStringTree);
function FindNodeEx(VT : TVirtualStringTree; ANode: PVirtualNode;
                    const APattern: Variant; Param : integer; ExNum : integer = 0): PVirtualNode;

implementation

uses
  Math, DateUtils, StrUtils;

{Если lOk тогда AValue1, иначе AValue2}
{function iif(AOk: boolean; const AValue1, AValue2: Variant): Variant;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;}

function iif(AOk: boolean; const AValue1, AValue2: integer): integer;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

function iif(AOk: boolean; const AValue1, AValue2: int64): int64;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

function iif(AOk: boolean; const AValue1, AValue2: double): double;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

function iif(AOk: boolean; const AValue1, AValue2: string): string;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

function iif(AOk: boolean; const AValue1, AValue2: boolean): boolean;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

function iif(AOk: boolean; const AValue1, AValue2: pointer): pointer;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

function iif(AOk: boolean; const AValue1, AValue2: Variant): Variant;
begin
 if AOk then
  Result := AValue1
 else
  Result := AValue2
end;

{Trim справа и слева}
function AllTrim(const cStr: string): string;
begin
 Result := TrimLeft(TrimRight(cStr))
end;

{Удаление пробелов из строки}
function FullTrim(const cStr: string): string;
var
  cTmp : string;
  _i   : integer;
begin
 cTmp := AllTrim(cStr);
 Result := cTmp;
 if cTmp <> EmptyStr then
  for _i := 1 to Length(cTmp) do
   if cTmp[_i] <> ' ' then
    Result := Result + cTmp[_i]
end;

{Проверка на пустую строчку}
function EmptS(const cStr: string): boolean;
begin
 Result := AllTrim(cStr) = EmptyStr
end;

{преобразование строки для записи в базу}
function StrCheckOnNull(const _Str: string): string;
begin
 Result := iif(EmptS(_Str), _NULL, '''' + _Str + '''')
end;

{преобразование даты для записи в базу}
function DateCheckOnNull(_date: tDateTime): string;
begin
 Result := iif(_date = 0, _NULL, '''' + DateToStr(_date) + '''')
end;

{Инвертировать значение (положительный -> отрицательный) если AInverse}
function InverseValue(AValue: integer; AInverse: boolean = true): integer;
begin
 Result := AValue;
 if AInverse then
  Result := -AValue
end;

{Выделение первых Len символов}
function Left(const StrSource: string; Len: integer): string;
begin
 if Length(StrSource) <= Len then
  Result:= StrSource
 else
  Result:= Copy(StrSource, 1, Len)
end;

{Выделение последних Len символов}
function Right(const StrSource: string; Len: integer): string;
begin
 if Length(StrSource) <= Len then
  Result:= StrSource
 else
  Result:= Copy(StrSource, Length(StrSource) - Len + 1, Len)
end;

{Выделение подстроки}
function Substr(const StrSource: string; nPos, Len: integer): string;
begin
 if nPos >= 0 then
  Result:= Copy(StrSource, nPos, Len)
 else
  Result:= Copy(StrSource, length(StrSource) + nPos + 1, Len)
end;

{Возвращает nPos-ную подстроку из строки cStr, cDelim - разделитель подстрок}
{nPos нумеруется с НУЛЯ (первый - 0!!!)}
function GetSubStr(cDelim: char; const cStr: string; nPos: integer): string;
var
  nj,
  jj   : integer;
  cTmp : string;

begin
 cTmp := cStr;
 for nj:= 0 to nPos - 1 do begin
 {Пропускаем ненужные вначале}
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

{Заменяет символы cFind на cRepl в строке сStr  и возвращает ее}
function CharReplace(cFind, cRepl: char; const cStr: string): string;
var
  _tmp : string;
begin
 _tmp   := cStr;
 if cFind <> cRepl then
  while Pos(cFind, _tmp) > 0 do
   _tmp := Left(_tmp, Pos(cFind, _tmp) - 1) + cRepl + Right(_tmp, Length(_tmp) - Pos(cFind, _tmp));
 Result := _tmp
end;

{Удаляет символы из строки}
function CharRem(cChr: char; const cStr: string): string;
var
 _tmp: string;
begin
 _tmp := cStr;
 while pos(cChr, _tmp) > 0 do
  system.delete(_tmp, pos(cChr, _tmp), 1);
 Result := _tmp
end;

{Добавление слева символа cChar до длины nCount}
function AddLeft(cChar: Char; const cStr: string; nCount: integer): string;
begin
 Result := cStr;
 if (nCount > 0) and (Length(cStr) < nCount) then
  while Length(Result) < nCount do
   Result := cChar + Result
end;

{Добавление справа символа cChar до длины nCount}
function AddRight(cChar: Char; const cStr: string; nCount: integer): string;
begin
 Result := cStr;
 if (nCount > 0) and (Length(cStr) < nCount) then
  while Length(Result) < nCount do
   Result := Result + cChar
end;

{Считает кол-во символов cChr в строке сStr и возвращает его}
function CountChars(cChr: char; const cStr: string): integer;
var
  _i: integer;
begin
 Result := 0;
 if Length(cStr) > 0 then
  for _i := 1 to Length(cStr) do
   if AnsiUpperCase(cChr) = AnsiUpperCase(cStr[_i]) then
    inc(Result)
end;

{Поиск в строке сStr подстроки cSubStr начиная с позиции nPos}
{Если найдена - возвращвет номер позиции, иначе 0}
function FindInStr(const cSubStr: string; nPos: integer; const cStr: string): integer;
var
  _tmp : string;
begin
 Result := 0;
 if nPos + 1 < Length(cStr) then begin
  _tmp := copy(cStr, nPos + 1, Length(cStr) - nPos + 1);
  Result := pos(cSubStr, _tmp);
  if Result > 0 then
   Result := Result + nPos
 end
end;

{Подсчитывает количество подстрок в строке}
function CountSubStr(cStr, cSubStr : String) : Integer;
var
  i : Integer;
  strTemp : String;
begin
  Result := 0;
  strTemp := cStr;
  i := Pos(cSubStr, strTemp);

  while i <> 0 do
  begin
    inc(Result);
    strTemp := RightStr(strTemp, Length(strTemp) - i);
    i := Pos(cSubStr, strTemp);
  end;

end;

{Вставляем между символами последовательность strIn}
function InsertStrRepetition(strString, strIn : String) : String;
var
  strTemp : String;
  i : Integer;
begin
  strTemp := LeftStr(strString, 1); 
  for i := 1 to Length(strString) - 1 do
    strTemp := strTemp  + strIn + MidStr(strString, i + 1, 1);

  Result := strTemp;
end;

(*
{То же, что и RXCopyFile, но исходный открывается как SharyDenyNone,
и всегда без Гауги}
procedure CopyDenyNone(const FileName, DestName: string);
var
  CopyBuffer: Pointer;
  FileDate, BytesCopied: Longint;
  Source, Dest: Integer;
  Destination: TFileName;
const
  ChunkSize: Longint = 8192;
begin
 Destination := DestName;
 if HasAttr(Destination, faDirectory) then
  Destination := NormalDir(Destination) + ExtractFileName(FileName);
 GetMem(CopyBuffer, ChunkSize);
 try
  Source := FileOpen(FileName, fmShareDenyNone);
  if Source < 0 then
   raise EFOpenError.CreateFmt(ResStr(SFOpenError), [FileName]);
  try
   Dest := FileCreate(Destination);
   if Dest < 0 then
    raise EFCreateError.CreateFmt(ResStr(SFCreateError), [Destination]);
   try
    FileDate := FileGetDate(Source);
    repeat
     BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize);
     if BytesCopied > 0 then FileWrite(Dest, CopyBuffer^, BytesCopied);
    until BytesCopied < ChunkSize;
    FileSetDate(Dest, FileDate);
    finally
     FileClose(Dest);
    end;
   finally
    FileClose(Source);
   end;
 finally
  FreeMem(CopyBuffer, ChunkSize);
 end
end;

{Копирование всего содержимого каталога в другой}
procedure CopyDirectory(const SourceDir, DestDir: string);
 var nFindRes : integer;
     SearchRec: TSearchRec;
begin
 if not DirectoryExists(DestDir) then
  try
   ForceDirectories(DestDir)
  except
  end;
 if not DirectoryExists(DestDir) then
  Raise Exception.Create('Ошибка при создании каталога' + CR_LF + DestDir + '!');
 {Начинаем копирование}
 nFindRes:= FindFirst(SourceDir + '*.*', SysUtils.faAnyFile, SearchRec);
 while nFindRes = 0 do begin
  if SearchRec.Attr and faDirectory = 0 {Если не каталог} then
   CopyDenyNone(SourceDir + SearchRec.Name, DestDir + SearchRec.Name);
  nFindRes:= FindNext(SearchRec)
 end
end;

{Функция формирования временного файла по указанному пути}
function _TempPathFile(cPath: string; cExt: string = '.TMP'): string;
 var nHandle: integer;
begin
 if (cPath <> EmptyStr) and (Right(Trim(cPath),1) <> '\') then
  cPath:= Trim(cPath) + '\';
 repeat
  Result:= TimeToStr(SysUtils.Time);
  Result:= CharRem(':', Result);
  Result:= cPath + '~~' + Result + cExt;
  if FileExists(Result) then begin
   Wait(1);
   nHandle:= -1
  end
  else
   nHandle:= FileCreate(Result)
 until nHandle >= 0;
 FileClose(nHandle)
end;

{Так как стандартный SysUtils.DeleteFile вызывает белую рамочку при попытке
 удаления кем-то открытого файла на сети, делаем так}
function TryDeleteFile(cFile: string): boolean;
 var ReOpenBuff: TOfStruct;
     cpFile : array[0..70] of Char;
     nHandle: integer;
begin
 Result:= false;
 if FileExists(cFile) then begin
  StrPCopy(cpFile, cFile);
  nHandle:= OpenFile(cpFile, ReOpenBuff, OF_SHARE_EXCLUSIVE);
  if nHandle <> -1 then begin
   _lclose(nHandle);
   Result:= OpenFile(cpFile, ReOpenBuff, OF_DELETE) <> HFILE_ERROR
  end
 end
end;

{Удаление файла или группы файлов}
procedure DelFiles(cPath: string; cFileMask: string; lMsg: boolean);
 var SearchRec  : TSearchRec;
     DelFileList: TStringList;
     nFindRes   : integer;
     cFile      : string;
begin
 {Все время вызывать FindFirst и сразу удалять плохо, вдруг какой нибудь не удалится}
 {Поэтому работаем через список}
 nFindRes:= FindFirst(cPath + cFileMask, sysutils.faReadOnly + faHidden + faArchive, SearchRec);
 if nFindRes = 0 then begin
  DelFileList:= TStringList.Create;
  try
   while nFindRes = 0 do begin
    DelFileList.Add(SearchRec.Name);
    nFindRes:= FindNext(SearchRec)
   end;
   with DelFileList do
    if Count > 0 then
     for nFindRes:= 0 to Count - 1 do begin
      cFile:= cPath + Strings[nFindRes];
      if FileGetAttr(cFile) and sysutils.faReadOnly > 0 then
       FileSetAttr(cFile, faArchive); {Сброс ReadOnly}
      if not TryDeleteFile(cFile) and FileExists(cFile) and
         lMsg and (MessDlg('Не могу удалить файл ' + cFile + '!' + CR_LF +
         'Продолжение работы может привести к некорректным результатам!' + CR_LF +
         'Прервать обработку?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
       Raise Exception.Create(EmptyStr)
     end
  finally
   SysUtils.FindClose(SearchRec);
   DelFileList.free
  end
 end
end;
*)
function GetIDN(ADate: TDateTime): string;
var
  intGod          : Word;
  intMM           : Word;
  intDD           : Word;
  dateBeginSummer : TDateTime;
  dateBeginWinter : TDateTime;
begin
 DecodeDate(ADate, intGod, intMM, intDD);
 // Хитрые махинации
 dateBeginSummer := EnCodeDate(intGod, 03, 31);      { '31.03'}
 dateBeginWinter := EnCodeDate(intGod, 10, 31);      { '31.10'}

 dateBeginSummer := dateBeginSummer - DayOfWeek(dateBeginSummer) + 1;
 dateBeginWinter := dateBeginWinter - DayOfWeek(dateBeginWinter) + 1;

 if ADate < dateBeginSummer then      // Зима предыдущего года
  Result := Copy(IntToStr(intGod - 1), 3, 2) + 'W'
 else if ADate < dateBeginWinter then // Лето
  Result := Copy(IntToStr(intGod), 3, 2) + 'S'
 else                                 // Зима этого года
  Result := Copy(IntToStr(intGod), 3, 2) + 'W'
end;

{Получить начало навигации}
function GetBeginIDN(ADate: TDateTime): tDateTime;
var
  _y : integer;
  _d1, _d2, _d3 : TDateTime;
begin
 _y := YearOf(ADate);
 // Хитрые махинации
 _d1 := EnCodeDate(_y-1, 10, 31);      { '31.10.2003'}
 _d2 := EnCodeDate(_y, 03, 31);        { '31.03.2004'}
 _d3 := EnCodeDate(_y, 10, 31);        { '31.10.2004'}
 _d1 := _d1 - DayOfWeek(_d1) + 1;
 _d2 := _d2 - DayOfWeek(_d2) + 1;
 _d3 := _d3 - DayOfWeek(_d3) + 1;
 if ADate < _d2 then      // Зима предыдущего года
  Result := _d1
 else if ADate < _d3 then // Лето
  Result := _d2
 else                     // Зима этого года
  Result := _d3
end;

{Проверка на валидную дату}
function IsValidDate(const cDate: string): boolean;
var
  _i : integer;
begin
 Result := false;
 if EmptS(cDate) then
  Exit;
 for _i := 1 to Length(cDate) do
  if not (cDate[_i] in ['0' .. '9', '.', '/', '\']) then
   Exit;
 try
  StrToDate(cDate);
  Result:= true
 except
  on EConvertError do
   Result:= false
 end
end;

{*** Вычисляет разницу времени (VO VP) из двух времен в формате ЧЧММ
     выдает разницу в виде ЧЧ:ММ ***}
function GetTimeDiff(cTIME1, cTIME2: string): string;
var
  iH, iM : byte;
  iT1,
  iT2,
  iD     : word;
begin
 Result :=EmptyStr;
 try
  iT1 := StrToIntDef(copy(cTIME1, 1, 2), 0)*60 + StrToIntDef(copy(cTIME1, 4, 2), 0); // cTIME1 в минутах
  iT2 := StrToIntDef(copy(cTIME2, 1, 2), 0)*60 + StrToIntDef(copy(cTIME2, 4, 2), 0); // cTIME2 в минутах
  if iT2 < iT1 then
   iT2 := iT2 + 24*60;
  iD := iT2 - iT1;
  iH := Round(Int(iD/60)); // часы
  iM := iD - Round(Int(iD/60))*60; // минуты
  if iM < 10 then
   Result := IntToStr(iH) + ':0' + IntToStr(iM)
  else
   Result := IntToStr(iH) + ':' + IntToStr(iM)
 except
 end
end;

function GetTimeDiffEx(Dta1, Dta2: tDate; const Time1, Time2: string): string;
var
  _m : integer;
begin
 _m := Trunc(Abs(Dta2 - Dta1))*1440 + StrToIntDef(copy(Time2, 1, 2), 0)*60 +
       StrToIntDef(copy(Time2, 3, 2), 0) - StrToIntDef(copy(Time1, 1, 2), 0)*60 -
       StrToIntDef(copy(Time1, 3, 2), 0);
 Result := AddLeft('0', IntToStr(_m div 60), 2) + ':' + AddLeft('0', IntToStr(_m mod 60), 2)
end;

{Вычисляет местное время по UTC времени: aTime - в формате ччмм, результат - чч:мм}
function GetTimeByUTC(const aTime: string; var lCh: boolean): string;
var
  _h, _m: word;
begin
 Result := EmptyStr;
 if not EmptS(aTime) then begin
  _h := StrToIntDef(copy(aTime, 1, 2), 0);
  _m := StrToIntDef(copy(aTime, 3, 2), 0);
  _h := _h + iif(Right(GetIDN(Date), 1) = 'W', 3, 4);
  lCh := _h >= 24;
  if lCh then
   _h := _h - 24;
  Result := iif(_h < 10, '0', EmptyStr) + IntToStr(_h) + ':' +
            iif(_m < 10, '0', EmptyStr) + IntToStr(_m)
 end
end;

function ChangeTime(number : integer; const tmp : string): string;
var
  tmpM, tmpH, _tmp : string;
  i, min           : integer;
begin
 Result := EmptyStr;
 try
  min := StrToIntDef(copy(tmp, 1, 2), 0)*60 +
         StrToIntDef(copy(tmp, 3, 2), 0) + number;
  if min < 0 then
   min := min + (24*60);
  tmpH := IntToStr(min div 60);
  if length(tmpH) = 1 then
   tmpH := '0' + tmpH;
  tmpM := IntToStr(min - (min div 60)*60);
  if length(tmpM) = 1 then
   tmpM := '0' + tmpM;
  _tmp := tmpH + tmpM;
  if _tmp = '2400' then
   _tmp := '0000';
  if StrToInt(_tmp) > 2400 then
   _tmp := IntToStr(StrToIntDef(_tmp, 2400) - 2400);
  if length(_tmp) < 4 then
   for i := 1 to (4 - length(_tmp)) do
    _tmp := '0' + _tmp;
  Result := copy(_tmp, 1, 2) + ':' + copy(_tmp, 3, 2)
 except
 end
end;

{Задержка выполнения на nWait секунд}
procedure Wait(nWait: integer);
 var wTemp, Sec, SecNew: Word;
begin
 DecodeTime(SysUtils.Time, wTemp, wTemp, Sec, wTemp);
 repeat
  DecodeTime(SysUtils.Time, wTemp, wTemp, SecNew, wTemp);
  Application.ProcessMessages
 until Abs(Integer(Sec - SecNew)) >= nWait
end;

{MessageDlg, но всегда с нормальным курсором}
function MessDlg(const Msg: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons;
                  HelpCtx: Longint): Word;
var
  SavCur: TCUrsor;
begin
 SavCur:= Screen.Cursor;
 Screen.Cursor:= crDefault;
 Application.NormalizeTopMosts;
 Result:= MessageDlg(Msg, AType, AButtons, HelpCtx);
 Application.RestoreTopMosts;
 Screen.Cursor:= SavCur
end;

{Преобразует время из формата ЧЧММ в формат ЧЧ:ММ}
function GetCoolTime(const cTime: string): string;
begin
 Result := iif(Length(cTime) < 4, cTime,
                 copy(cTime, 1, 2) + ':' + copy(cTime, 3, 2))
end;

{Преобразует время из формата ЧЧ:ММ в формат ЧЧММ}
function GetUnCoolTime(const cTime: string): string;
begin
 Result := CharRem(':', CharReplace('_', ' ', iif(Length(cTime) < 5, cTime,
           copy(cTime, 1, 2) + copy(cTime, 4, 2))))
end;

{Инвертирует цвет}
function InvertColor(col: tColor): tColor;
begin
 Result := RGB(255 - GetRValue(col),
                255 - GetGValue(col),
                255 - GetBValue(col))
end;

{*** Возвращает день недели, переведенный на русский ***}
function GetDayOfWeek(cDTA: TDateTime): byte;
var
  cDOF: byte;
begin
  try
    cDOF:=DayOfWeek(cDTA)-1;
    if cDOF = 0 then cDOF:=7;
    Result:=cDOF;
  except
    on EConvertError do Result:=0;
  end;
end;

{*** Ф-ЦИЯ ДЛЯ ПРЕОБРАЗОВАНИЯ TDateTime В ФОРМАТ '24 марта 2001'  ***}
function GetRusDate(cDTA: TDateTime): string;
var
  Day, Month, Year: word;
begin
  DecodeDate(cDTA, Year, Month, Day);
  if Day < 10 then Result:='0' + IntToStr(Day) + ' ' + RMonth[Month] + ' ' + IntToStr(Year)
              else Result:=IntToStr(Day) + ' ' + RMonth[Month] + ' ' + IntToStr(Year);
end;

{*** Ф-ЦИЯ ДЛЯ ПРЕОБРАЗОВАНИЯ TDateTime В ФОРМАТ '24 APR'  ***}
function GetEngDate(cDTA: TDateTime): string;
var
  Day, Month, Year: word;
begin
  DecodeDate(cDTA, Year, Month, Day);
  Result:=IntToStr(Day) + ' ' + EMonth[Month];
end;


{*** Сложение двух строковых значений времени '0630' + '0135' = '0805' ***}
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

{Понижает значение цвета aColor на aValue единиц (0..255)}
function ObscureColor(aColor: tColor; aValue: byte): tColor;
var
  _r, _g, _b: byte;
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

function RaiseColor(aColor: tColor; aValue: byte): tColor;
var
  _r, _g, _b: byte;
begin
 _r := GetRValue(ColorToRGB(aColor));
 _g := GetGValue(ColorToRGB(aColor));
 _b := GetBValue(ColorToRGB(aColor));
 if _r + aValue > 255 then
  _r := 255
 else
  _r := _r + aValue;
 if _g + aValue > 255 then
  _g := 255
 else
  _g := _g + aValue;
 if _b + aValue > 255 then
  _b := 255
 else
  _b := _b + aValue;
 Result := RGB(_r, _g, _b)
end;

{Понижает значение цвета AColor на AValue единиц (0..255) для каналов ACanals}
function ObscureColorEx(AColor: TColor; AValue: byte; ACanals: TCanals = [tcRed, tcGreen, tcBlue]): TColor;
var
  _r, _g, _b: byte;
begin
 _r := GetRValue(ColorToRGB(AColor));
 _g := GetGValue(ColorToRGB(AColor));
 _b := GetBValue(ColorToRGB(AColor));
 if tcRed in ACanals then
  if _r < AValue then
   _r := 0
  else
   _r := _r - aValue;
 if tcGreen in ACanals then
  if _g < aValue then
   _g := 0
  else
   _g := _g - aValue;
 if tcBlue in ACanals then
  if _b < aValue then
   _b := 0
  else
   _b := _b - aValue;
 Result := RGB(_r, _g, _b)
end;

function SumTime(cT1, cT2: string): string;
var
  cH1, cH2: word;
  cM1, cM2: word;
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
  intGod : Word;
  intMM  : Word;
  intDD  : Word;
  cDateBeginSummer : TDateTime;
  cDateBeginWinter : TDateTime;
  cDiff : integer;
  cVPU : string;
  cDPU : TDateTime;
  i : integer;
begin
  DecodeDate(cDPM,intGod,intMM,intDD);
  strGod:=copy(IntToStr(intGod),3,2); { Год }

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

{}
function NormalizeName(const AName: string): string;
var
  _pos: integer;
begin
 Result := Trim(AnsiUpperCase(AName[1]) + AnsiLowerCase(copy(AName, 2, Length(AName)-1)));
 _pos := Pos('(', Result);
 if (_pos > 0) and (Length(Result) > _pos+1) then
  Result := copy(Result, 1, _pos) + AnsiUpperCase(Result[_pos+1]) + copy(Result, _pos+2, Length(Result)-_pos);
 _pos := Pos('-', Result);
 if (_pos > 1) and (Length(Result) > _pos+1) then
  Result := copy(Result, 1, _pos) + AnsiUpperCase(Result[_pos+1]) + copy(Result, _pos+2, Length(Result)-_pos);
 _pos := Pos('/', Result);
 if (_pos > 1) and (Length(Result) > _pos+1) then
  Result := copy(Result, 1, _pos) + AnsiUpperCase(Result[_pos+1]) + copy(Result, _pos+2, Length(Result)-_pos)
end;

function DoubleToDegree(AVal: double): string;
begin
 Result := IntToStr(Floor(AVal)) + '°' + AddLeft('0', IntToStr(Floor(Abs(AVal*60)) mod 60), 2) + '"' +
           AddLeft('0', IntToStr(Floor(Abs(AVal*3600)) mod 100), 2) + '''' + AddLeft('0', IntToStr(Floor(Abs(AVal*36000)) mod 100), 2)
end;

function BuildDate(ADate: TDateTime; ATime: string): TDateTime;
begin
 Result := ADate + EncodeTime(StrToIntDef(copy(ATime, 1, 2), 0), StrToIntDef(copy(ATime, 3, 2), 0), 0, 0)
end;

{Вычисляет местное время по UTC времени: aTime - в формате ччмм, результат - ччмм,
 aDate - дата вычисления, lCh - произошла ли смена суток}
function GetTimeByUTCEx(const aTime: string; aDate: tDateTime; var lCh: boolean): string;
var
  _h, _m: word;
begin
 Result := EmptyStr;
 if Trim(aTime) <> EmptyStr then begin
  _h := StrToIntDef(copy(aTime, 1, 2), 0);
  _m := StrToIntDef(copy(aTime, 3, 2), 0);
  _h := _h + iif(Right(GetIDN(aDate), 1) = 'W', 3, 4);
  lCh := _h >= 24;
  if lCh then
   _h := _h - 24;
  Result := iif(_h < 10, '0', EmptyStr) + IntToStr(_h) +
            iif(_m < 10, '0', EmptyStr) + IntToStr(_m)
 end
end;

function GetTimeByLocalEx(const aTime: string; aDate: tDateTime; var lCh: boolean): string;
var
  _h, _m: integer;
begin
 Result := EmptyStr;
 if Trim(aTime) <> EmptyStr then begin
  _h := StrToIntDef(copy(aTime, 1, 2), 0);
  _m := StrToIntDef(copy(aTime, 3, 2), 0);
  _h := _h - iif(Right(GetIDN(aDate), 1) = 'W', 3, 4);
  lCh := _h < 0;
  if lCh then
   _h := _h + 24;
  Result := iif(_h < 10, '0', EmptyStr) + IntToStr(_h) +
            iif(_m < 10, '0', EmptyStr) + IntToStr(_m)
 end
end;

function MinStrToInt(const AMin: string): integer;
begin
 Result := StrToIntDef(copy(AMin, 1, integer(iif(Length(AMin) = 3, 1, 2))), 0)*60 +
           StrToIntDef(copy(AMin, integer(iif(Length(AMin) = 3, 2, 3)), 2), 0)
end;

function MinIntToStr(AMin: integer): string;
begin
 Result := AddLeft('0', IntToStr(AMin div 60), 2) +
           AddLeft('0', IntToStr(AMin mod 60), 2)
end;

{Получаем кол-во минут по времени в формате ЧЧ:ММ, в случае ошибки возвр. nDef}
function MinutesByTime( const cTime: string; nDef: integer ): integer;
begin
 Result := nDef;
 if cTime <> 'N/A' then
  try
   Result := StrToInt(copy(cTime, 1, 2))*60 + StrToInt(copy(cTime, 4, 2))
  except
  end
end;

{Получаем кол-во минут по времени в формате ЧЧММ, в случае ошибки возвр. nDef}
function MinutesByTimeShort( const cTime: string; nDef: integer ): integer;
begin
 Result := nDef;
 try
  Result := StrToInt(copy(cTime, 1, 2))*60 + StrToInt(copy(cTime, 3, 2))
 except
 end
end;

{Преобразование из минут в строку: mn = 90, result = '1ч.30мин.'}
function TimeByMinutes(mn: integer): string;
begin
 Result := AddLeft('0', IntToStr(mn div 60), 2) + ':' +
           AddLeft('0', IntToStr(mn mod 60), 2)
end;

{Преобразование из минут в строку: mn = 90, result = '1ч.30мин.'}
function TimeByMinutesEx(mn: integer): string;
begin
 Result := iif(mn div 60 > 0, IntToStr(mn div 60)+ 'ч.', EmptyStr) +
           IntToStr(mn mod 60)+ 'мин.'
end;


function MyMessageDialog(const Msg: string; DlgType: TMsgDlgType;
   Buttons: TMsgDlgButtons; Captions: array of string; Caption: String): Integer;
var
 aMsgDlg: TForm;
 i: Integer;
 dlgButton: TButton;
 CaptionIndex: Integer;
begin
  aMsgDlg := CreateMessageDialog(Msg, DlgType, Buttons);
  captionIndex := 0;
  if length(Captions)>0 then
    for i := 0 to aMsgDlg.ComponentCount - 1 do
    begin
      if (aMsgDlg.Components[i] is TButton) then
      begin
        dlgButton := TButton(aMsgDlg.Components[i]);
        if CaptionIndex > High(Captions) then Break;
        dlgButton.Caption := Captions[CaptionIndex];
        Inc(CaptionIndex);
      end;
    end;
  aMsgDlg.Caption:=Caption;
  Result := aMsgDlg.ShowModal;
end;

function MinutesBetweenEx(const AFrom, ATill: TDateTime): integer;
begin
 Result := Round(Abs(AFrom-ATill)*SECONDS_PER_DAY) div 60;
end;

function SecondsBetweenEx(const AFrom, ATill: TDateTime): integer;
begin
 Result := Round(Abs(AFrom-ATill)*SECONDS_PER_DAY);
end;

procedure GradFill(DC: HDC; ARect: TRect; ClrTopLeft, ClrBottomRight: TColor;
  Kind: TGradientKind);
var
  GradientCache: array [0..16] of array of Cardinal;
  NextCacheIndex: Integer;

  function FindGradient(Size: Integer; CL, CR: Cardinal): Integer;
  begin
    Assert(Size > 0);
    Result := 16 - 1;
    while Result >= 0 do
    begin
      if (Length(GradientCache[Result]) = Size) and
        (GradientCache[Result][0] = CL) and
        (GradientCache[Result][Length(GradientCache[Result]) - 1] = CR) then Exit;
      Dec(Result);
    end;
  end;

  function MakeGradient(Size: Integer; CL, CR: Cardinal): Integer;
  var
    R1, G1, B1: Integer;
    R2, G2, B2: Integer;
    R, G, B: Integer;
    I: Integer;
    Bias: Integer;
  begin
    Assert(Size > 0);
    Result := NextCacheIndex;
    Inc(NextCacheIndex);
    if NextCacheIndex >= 16 then NextCacheIndex := 0;
    R1 := CL and $FF;
    G1 := CL shr 8 and $FF;
    B1 := CL shr 16 and $FF;
    R2 := Integer(CR and $FF) - R1;
    G2 := Integer(CR shr 8 and $FF) - G1;
    B2 := Integer(CR shr 16 and $FF) - B1;
    SetLength(GradientCache[Result], Size);
    Dec(Size);
    Bias := Size div 2;
    if Size > 0 then
      for I := 0 to Size do
      begin
        R := R1 + (R2 * I + Bias) div Size;
        G := G1 + (G2 * I + Bias) div Size;
        B := B1 + (B2 * I + Bias) div Size;
        GradientCache[Result][I] := R + G shl 8 + B shl 16;
      end
    else
    begin
      R := R1 + R2 div 2;
      G := G1 + G2 div 2;
      B := B1 + B2 div 2;
      GradientCache[Result][0] := R + G shl 8 + B shl 16;
    end;
  end;

  function GetGradient(Size: Integer; CL, CR: Cardinal): Integer;
  begin
    Result := FindGradient(Size, CL, CR);
    if Result < 0 then Result := MakeGradient(Size, CL, CR);
  end;

var
  Size, I, Start, Finish: Integer;
  GradIndex: Integer;
  R, CR: TRect;
  Brush: HBRUSH;
begin
  NextCacheIndex := 0;
  if not RectVisible(DC, ARect) then
    Exit;
  ClrTopLeft := ColorToRGB(ClrTopLeft);
  ClrBottomRight := ColorToRGB(ClrBottomRight);
  GetClipBox(DC, CR);
  if Kind = gkHorz then
  begin
    Size := ARect.Right - ARect.Left;
    if Size <= 0 then Exit;
    Start := 0; Finish := Size - 1;
    if CR.Left > ARect.Left then Inc(Start, CR.Left - ARect.Left);
    if CR.Right < ARect.Right then Dec(Finish, ARect.Right - CR.Right);
    R := ARect; Inc(R.Left, Start); R.Right := R.Left + 1;
  end
  else begin
    Size := ARect.Bottom - ARect.Top;
    if Size <= 0 then Exit;
    Start := 0; Finish := Size - 1;
    if CR.Top > ARect.Top then Inc(Start, R.Top - ARect.Top);
    if CR.Bottom < ARect.Bottom then Dec(Finish, ARect.Bottom - CR.Bottom);
    R := ARect; Inc(R.Top, Start); R.Bottom := R.Top + 1;
  end;
  GradIndex := GetGradient(Size, ClrTopLeft, ClrBottomRight);
  for I := Start to Finish do
  begin
    Brush := CreateSolidBrush(GradientCache[GradIndex][I]);
    Windows.FillRect(DC, R, Brush);
    OffsetRect(R, Integer(Kind = gkHorz), Integer(Kind = gkVert));
    DeleteObject(Brush);
  end;
end;

procedure VirtualTreeFill_Ex(SP : TADOStoredProc; VT : TVirtualStringTree);
var Node, NewNode, NextRootNode : PVirtualNode;
    NodeData, RootChildNodeData : PDataInfo;
    temp_str : string;
    i  : integer;
    CheckedTree : boolean;

    // Функция поиска в узле
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

            // Переходим на соседнюю ветку
            NextNode := NextNode.NextSibling;
        until
            NextNode = nil;
    end;
begin
    try
        SP.Close;
        SP.Open;
        VT.Clear;

        CheckedTree := False;
        if ((VT.TreeOptions.MiscOptions + [toCheckSupport]) =
            VT.TreeOptions.MiscOptions) then CheckedTree := True; // CheckBox-ы

        if SP.RecordCount = 0 then exit;
        while not SP.EOF do
        begin
            // Поиск предка
            Node := nil;
            if VT.RootNodeCount > 0 then
            begin
                temp_str := SP.FieldByName('parent_id').AsString;
                Node := FindNode(VT.RootNode, temp_str);
            end;

            // Добавление узла в дерево
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

                    if CheckedTree then // поддержка CheckBox-ов
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

            // Поиск среди узлов в корне потомков добавленного узла
            Node := VT.RootNode.FirstChild;
            while Assigned(Node) do
            begin
                NextRootNode := Node.NextSibling;

                RootChildNodeData := VT.GetNodeData(Node);
                if Assigned(RootChildNodeData) then
                begin
                    if RootChildNodeData^.parent_id = NodeData^.id then
                    begin
                        // Перемещение узла внутрь узла-предка
                        if RootChildNodeData.id <> NodeData.id then // нашел себя !!!
                        begin
                            VT.MoveTo(Node, NewNode, amAddChildLast, False); // True);
                        end;
                    end;
                end;

                // Переходим на соседнюю ветку
                Node := NextRootNode;
            end;

            SP.Next;
        end; // while not EOF
    finally
        SP.Close;
    end;
end;

// Функция поиска в узле
function FindNodeEx(VT : TVirtualStringTree; ANode: PVirtualNode;
                    const APattern: Variant; Param : integer; ExNum : integer = 0): PVirtualNode;
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
            if Param = 0 then
            begin
                if NodeData^.ExData[ExNum] = APattern then
                begin
                    Result := NextNode;
                    Exit;
                end;
            end
            else
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

        // Переходим на соседнюю ветку
        NextNode := NextNode.NextSibling;
    until
        NextNode = nil;
end;

end.
