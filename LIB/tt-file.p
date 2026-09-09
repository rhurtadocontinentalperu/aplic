/*------------------------------------------------------------------------

  File: tt-file.p

  Description: Convert a temp table into a file.

  Input Parameters:
    temp table handle
    filename
    option list

  Output Parameters:
    <none>

  Author: Jeff Pilant

  Usage and documentation: see tt-file.html

  ------------------------------------------------------------------------
  Contributers:
    Who  Full name         <email>
    JTP  Jeff Pilant       <Jeff.Pilant@us.abb.com>
    PT   Patrick Tingen    <p.tingen@vcd.nl>

  ---------------------------------------------------------------------------
  Revision History:

  Ver  Who  Date         Description
  ---- ---- ------------ --------------------------------------------------
  1.0  JTP  06-Mar-2002  Created (TXT, XLS)
       JTP  06-Mar-2002  Added (CSV), prompt for filename
       JTP  ??-???-2002  Added (BRS)
       JTP  11-Apr-2002  Added AutoFit to Excel output
       JTP  23-May-2002  Fixed getExcelColumn()
       JTP  08-May-2002  Changed default column width for excel to a
                         function
                         Added Title Row code to Excel output
       JTP  13-Sep-2002  Added code to fix Title Row to always be row 1
       JTP  10-Oct-2002  Added ability to do csv, txt, or xls files if
                         type not given
       JTP  16-Jul-2003  Added Sylk file type
  1.1  JTP  08-Sep-2003  Fixup Sylk date format for dates before 1/1/1900
                         Added df file type [From code found at:
                           http://www.v9stuff.com/dynexport.htm
                           thanks to Tony Lavinio and Peter van Dam]
       PT   22-Oct-2003  Added ,"character" to substring and length
                         functions to support multi-byte codepages.
                         [JTP: Adds compatability for other Code Pages]
  1.2  PT   31-Oct-2003  Changed parameter cFileType to cOptions to provide
                         more options for the requested behaviour.
                         This is backward compatible.
                         Added options: FileType, FieldList, SkipList,
                                        ExcelAlert and ExcelVisible
       JTP  01-Nov-2003  Folded in PT's changes and rewrote the column
                         autofit portion of the excel code.
       PT   02-Dec-2003  Added options: Grid, GridCharHor, GridCharVer,
                                        GridCharCross, GridInterval, GridField
                         Added options: Append, Labels, FirstOfList, Title
                         Added HTML documentation.
                         Added XML mode.
                         Moved code and vars to internal procedures.
       PT   12-Jan-2004  Use the name of the field as the XML tag, not the label
                         since the label is more likely to hold undesired chars.
                         Added some comments to procedures and functions.
       PT   09-Feb-2004  Added support for writing array fields to XML

------------------------------------------------------------------------*/
define input parameter htt      as handle    no-undo.
define input parameter fn       as character no-undo.
define input parameter cOptions as character no-undo.

/* Excel Constants */
&scoped-define xlExcel9795         43
&scoped-define xlWBATWorksheet    -4167
&scoped-define xlWorkbookNormal   -4143
&scoped-define xlRight            -4152

/* Sylk Constants */
&scoped-define SylkFormat-number  "N"
&scoped-define SylkFormat-string  "S"
&scoped-define SylkFormat-date    "D"
&scoped-define SylkFormat-time    "T"
&scoped-define SylkFormat-logical "L"
&scoped-define sylk-xls-hm        "HH:MM"
&scoped-define sylk-xls-hm-a      "HH:MM AM"
&scoped-define sylk-xls-hms       "HH:MM:SS"
&scoped-define sylk-xls-hms-a     "HH:MM:SS AM"
&scoped-define sylk-xls-mdy       "MM/DD/YY"
&scoped-define sylk-xls-dmy       "DD-MMM-YY"
&scoped-define sylk-xls-md-y      "Month DD, YYYY"
&scoped-define sylk-xls-ymd       "YYMMDD"
&scoped-define sylk-xls-cymd      "YYYYMMDD"
&scoped-define sylk-xls-title     "TITLE"
&scoped-define sylk-xls-body      "BODY"
&scoped-define sylk-fil-picture   "P"
&scoped-define sylk-fil-font      "M"
&scoped-define sylk-fil-c-wid     "W"
&scoped-define sylk-fil-c-fmt     "C"
&scoped-define sylk-fil-c-title   "T"

/* Output constants */
&scoped-define lf  chr(10)
&scoped-define cr  chr(13)
&scoped-define qt  chr(34)

/* Include files */
{lib/tt-file.i}

/* General variables */
define variable nf                   as integer    no-undo.
define variable nx                   as integer    no-undo.
define variable wf                   as integer    no-undo.
define variable nc                   as integer    no-undo.
define variable btt                  as handle     no-undo.
define variable hwf                  as handle     no-undo.
define variable hQuery               as handle     no-undo.
define variable hField               as handle     no-undo.
define variable cFileType            as character  no-undo.
define variable cOutputFile          as character  no-undo.
define variable cBrowseTitle         as character  no-undo initial "tt-browse".
define variable cFieldList           as character  no-undo initial "*". /* by default, include all fields */
define variable cSkipList            as character  no-undo initial "".  /* by default, exclude no fields */
define variable lFirstField          as logical    no-undo. /* var to simulate a first-of */
define variable lAppend              as logical    no-undo. /* append to a file or not */
define variable lPrintLabels         as logical    no-undo initial true. /* show header with labels */
define variable str                  as character  no-undo.
define variable tag                  as character  no-undo.

/* TXT variables */
define variable cFirstOfList         as character  no-undo.
define variable cGridCharHor         as character  no-undo initial "-".
define variable cGridCharVer         as character  no-undo initial "|".
define variable cGridCharCross       as character  no-undo initial "+".
define variable iGridInterval        as integer    no-undo initial 1.
define variable cHorGridFieldName    as character  no-undo.
define variable lHorGrid             as logical    no-undo initial false.
define variable lVerGrid             as logical    no-undo initial false.
define variable cThisRec             as character  no-undo.
define variable cPrevRec             as character  no-undo.

/* Excel variables */
define variable lExcelAlert          as logical    no-undo initial true. /* by default, complain if a file exists */
define variable lExcelVisible        as logical    no-undo initial true. /* by default, show excel */

/* BRS variables */
define variable cReturnString        as character  no-undo.
define variable cReturnFieldList     as character  no-undo.

/* XML variables */
define variable cKeyFieldList        as character  no-undo.

/* Structure for holding Sylk parts */
define temp-table tt-sylk no-undo
  field typ as character
  field seq as integer
  field val as character
  field fmt as character
  index pu-one is primary unique typ seq.

/* Structure & query for the browse */
define temp-table q-help no-undo
  field a as integer.

/*------------------------------------------------------------------------- *\
** function definitions
\*------------------------------------------------------------------------- */

/* Name : getExcelColumn
 * Desc : Get Excel column reference from column number.
 */
function getExcelColumn returns character
  ( input pos as integer ) :
  define variable ifirst  as integer   no-undo.
  define variable isecond as integer   no-undo.
  define variable cols as character no-undo.
  ifirst  = integer(truncate((pos - 1) / 26, 0)).
  isecond = pos - (26 * ifirst).
  cols    = chr(64 + isecond).
  if ifirst > 0 then
    cols = chr(64 + ifirst) + cols.
  return cols.
end function. /* getExcelColumn */


/* Name : getColumnWidth
 * Desc : Get width needed for column using label and format.
 */
function getColumnWidth returns integer
  ( input hnd as handle ) :
  return integer(max(length(hnd:label,"character"), hnd:width-chars)).
end function. /* getColumnWidth */


/* Name : getExcelColumnWidth
 * Desc : Default column width to set Excel column.
 */
function getExcelColumnWidth returns integer
  ( input hnd as handle ) :
  return integer(min(1.25 * max(length(hnd:label,"character"), hnd:width-chars), 255)).
end function. /* getExcelColumnWidth */


/* Name : getValidFileName
 * Desc : Convert string to valid filename.
 */
function getValidFileName returns character
  ( input ifn as character ) :
  define variable cFileName as character no-undo.
  cFileName = ifn.

  cFileName = entry(num-entries(cFileName, "\":U), cFileName, "\":U).
  cFileName = entry(num-entries(cFileName, "/":U), cFileName, "/":U).

  cFileName = replace(cFileName, "\":U,  "_":U).
  cFileName = replace(cFileName, "/":U,  "_":U).
  cFileName = replace(cFileName, ":":U,  "_":U).
  cFileName = replace(cFileName, "*":U,  "_":U).
  cFileName = replace(cFileName, "?":U,  "_":U).
  cFileName = replace(cFileName, """":U, "_":U).
  cFileName = replace(cFileName, "<":U,  "_":U).
  cFileName = replace(cFileName, ">":U,  "_":U).
  cFileName = replace(cFileName, "|":U,  "_":U).

  if cFileName = "" then cFileName = "[blank]".
  return trim(cFileName).
end function. /* getValidFileName */


/* Name : SylkValue
 * Desc : Get the reference used for a part.
 */
function SylkValue returns character
  ( input p-typ as character,
    input p-fmt as character ) :
  find first tt-sylk where tt-sylk.typ = p-typ
                       and tt-sylk.fmt = p-fmt
                           no-lock no-error.
  if available(tt-sylk) then
    return p-typ + string(tt-sylk.seq).
  else
    return p-typ + "0".
end function. /* SylkValue */


/* Name : FieldRequired
 * Desc : Determine if a given field should be displayed.
 */
function FieldRequired returns logical
  ( input hField as handle ):
  /* cFieldList holds a list of fields to use  (default all)  */
  /* cSkipList  holds a list of fields to skip (default none) */
  return (        can-do(cFieldList, hField:name)
          and not can-do(cSkipList,  hField:name)).
end function. /* FieldRequired */


/* Name : LogicalValue
 * Desc : Logical function for pre 9.1D versions.
 */
function LogicalValue returns logical
  ( input cString as character ):
  return ( cString begins 'Y' or cString begins 'T').
end function. /* LogicalValue */


/* Name : getXMLFriendlyString
 * Desc : Filter out characters that XML dislikes in an element name.
 */
function getXMLFriendlyString returns character
  ( input cString as character ):
  assign
    cString = replace(cString,'#','')
    cString = replace(cString,'$','')
    cString = replace(cString,'%','')
    cString = replace(cString,'&','').
    cString = replace(cString,' ','_').
  return cString.
end function. /* getXMLFriendlyString */


/*------------------------------------------------------------------------- *\
** main code block begin
\*------------------------------------------------------------------------- */

run DecodeOptionString ( input cOptions ).
run GetOutputFile ( output cOutputFile ).

/* Some checks:
   - If an unknown extension is used, exit
   - If no name is specified, exit
*/
if   ( cFileType = "" )
  or ( cFileType <> tt-browse and cOutputFile = "" ) then return.

btt = htt:default-buffer-handle.
nf  = btt:num-fields.

case cFileType:
  when tt-df     then run df_format.
  when tt-text   then run txt_format.
  when tt-excel  then run xls_format.
  when tt-csv    then run csv_format.
  when tt-browse then run brs_format.
  when tt-sylk   then run slk_format.
  when tt-xml    then run xml_format.
  otherwise           run unknown_format.
end case.

return cReturnString.

/*------------------------------------------------------------------------- *\
** main code block end
\*------------------------------------------------------------------------- */


/* Name : DecodeOptionString
 * Desc : Decode option string into variables.
 */
procedure DecodeOptionString:
  define input parameter cOptionList as character no-undo.

  define variable iOption              as integer    no-undo.
  define variable cCurrentOption       as character  no-undo. /* var to pull the option string apart */

  /* Decode option string */
  do iOption = 1 to num-entries(cOptionList,chr(1)):
    cCurrentOption = entry(iOption,cOptionList,chr(1)).

    if num-entries(cCurrentOption,':') = 1 then cFileType = cCurrentOption. /* old way of providing file type */
    else case entry(1,cCurrentOption,':'):
      when 'FileType'      then cFileType         = entry(2,cCurrentOption,':').
      when 'FieldList'     then cFieldList        = entry(2,cCurrentOption,':').
      when 'SkipList'      then cSkipList         = entry(2,cCurrentOption,':').
      when 'Append'        then lAppend           = LogicalValue( entry(2,cCurrentOption,':') ).
      when 'ExcelAlert'    then lExcelAlert       = LogicalValue( entry(2,cCurrentOption,':') ).
      when 'ExcelVisible'  then lExcelVisible     = LogicalValue( entry(2,cCurrentOption,':') ).
      when 'Labels'        then lPrintLabels      = LogicalValue( entry(2,cCurrentOption,':') ).
      when 'FirstOfList'   then cFirstOfList      = entry(2,cCurrentOption,':').
      when 'Title'         then cBrowseTitle      = entry(2,cCurrentOption,':').
      when 'ReturnList'    then cReturnFieldList  = entry(2,cCurrentOption,':').
      when 'AttributeList' then cKeyFieldList     = entry(2,cCurrentOption,':').
      when 'GridCharHor'   then cGridCharHor      = substring(cCurrentOption,index(cCurrentOption,':') + 1, -1, "character").
      when 'GridCharVer'   then cGridCharVer      = substring(cCurrentOption,index(cCurrentOption,':') + 1, -1, "character").
      when 'GridCharCross' then cGridCharCross    = substring(cCurrentOption,index(cCurrentOption,':') + 1, -1, "character").
      when 'GridInterval'  then iGridInterval     = integer( substring(cCurrentOption,index(cCurrentOption,':') + 1, -1, "character") ) no-error.
      when 'GridField'     then assign
                                  cHorGridFieldName = entry(2,cCurrentOption,':')
                                  iGridInterval     = 0.
      when 'Grid'          then
        case entry(2,cCurrentOption,':'):
          when 'hor' then lHorGrid = yes.
          when 'ver' then lVerGrid = yes.
          otherwise if LogicalValue(entry(2,cCurrentOption,':')) then
            assign
              lHorGrid = yes
              lVerGrid = yes.
        end case.
    end case.
  end.

  /* check interval */
  if not iGridInterval ge 0 then iGridInterval = 0.
end procedure. /* DecodeOptionString */


/* Name : GetOutputFile
 * Desc : get the name of the output file
 */
procedure GetOutputFile:
  define output parameter cOutputFile as character no-undo.

  define variable fil-sp              as character  no-undo initial "".
  define variable lOk                 as logical   no-undo.

  /* If output type is blank, allow choice via filename */
  if cFileType = tt-text  or cFileType = "" then fil-sp = fil-sp + ",*.txt":U.
  if cFileType = tt-csv   or cFileType = "" then fil-sp = fil-sp + ",*.csv":U.
  if cFileType = tt-excel or cFileType = "" then fil-sp = fil-sp + ",*.xls":U.
  if cFileType = tt-sylk  or cFileType = "" then fil-sp = fil-sp + ",*.slk":U.
  if cFileType = tt-df    or cFileType = "" then fil-sp = fil-sp + ",*.df":U.
  fil-sp = trim(fil-sp, ",":U).
  cOutputFile = fn.

  if cOutputFile = "" and not cFileType = tt-browse then
  do:
    system-dialog get-file cOutputFile
      filters "Standard (":U + fil-sp + ")":U lc(fil-sp),
              "Any File (*.*)":U                "*.*":U
      ask-overwrite
      create-test-file
      default-extension lc(".":U + entry(1,fil-sp))
      save-as
      update lOk.
    if not lOk then return.
  end.

  /* Process blank type choice */
  if cFileType = "" then
  do:
    fil-sp = substring(cOutputFile, length(cOutputFile, "character") - 2, -1, "character").
    case fil-sp:
      when "txt":U then cFileType = tt-text.
      when "xls":U then cFileType = tt-excel.
      when "csv":U then cFileType = tt-csv.
      when "xls":U then cFileType = tt-excel.
      when "slk":U then cFileType = tt-sylk.
      when "df":U  then cFileType = tt-df.
    end case.
  end.

  /* If an unknown extension is used, exit */
  if cFileType = "" then
    return.
end procedure. /* GetOutputFile */


/* Name : SylkFormat
 * Desc : Add a part to the Sylk structure.
 */
procedure SylkFormat :
  define input parameter p-typ as character no-undo.
  define input parameter p-val as character no-undo.
  define input parameter p-fmt as character no-undo.
  define variable nxt as integer no-undo.

  find last tt-sylk where tt-sylk.typ = p-typ no-lock no-error.
  if available(tt-sylk) then
    nxt = tt-sylk.seq + 1.
  else
    nxt = 0.
  create tt-sylk.
  assign tt-sylk.typ = p-typ
         tt-sylk.seq = nxt
         tt-sylk.val = p-val
         tt-sylk.fmt = p-fmt.
end procedure. /* SylkFormat */


/* Name : df_format
 * Desc : Write in DF style.
 */
procedure df_format:
    if lAppend then
      output to value(cOutputFile) append.
    else
      output to value(cOutputFile).

    /* table */
    put unformatted 'ADD TABLE "':u   htt:name '"' skip
                    '  AREA "Schema Area"':u skip
                    '  DUMP-NAME "':u substring(htt:name, 1, 8, "character") '"' skip(2).
    /* field */
    do wf = 1 to nf:
      assign hwf = btt:buffer-field(wf).
      if FieldRequired(hwf) then
      do:
        put unformatted 'ADD FIELD "':u hwf:name '" OF "':u htt:name '" AS ':u hwf:data-type skip
                        '  FORMAT "':u hwf:format '"'             skip
                        '  INITIAL "':u trim(hwf:initial) '"'     skip
                        '  POSITION ':u trim(string(wf + 1))      skip.
        if hwf:data-type = "CHARACTER" then
          put unformatted '  SQL-WIDTH ' hwf:width-chars * 2 skip.
        else
          put unformatted '  SQL-WIDTH 4' skip.
        put unformatted '  LABEL "':u hwf:label '"'               skip
                        '  COLUMN-LABEL "':u hwf:column-label '"' skip.
        if hwf:help <> ? then put unformatted '  HELP "':u hwf:help '"' skip.
        put unformatted '  ORDER ':u + trim(string(wf * 10)) skip(2).
      end.
    end.

    /* index */
    do wf = 1 to 200:
      if btt:index-information(wf) = ? then leave.
      assign str = btt:index-information(wf).
      if entry(1, str) = "default" then leave.
      put unformatted 'ADD INDEX "':u entry(1, str) '" ON "':u htt:name '"' skip
                      '  AREA "Schema Area"':u skip.
      if entry(2, str) = "1" then put unformatted '  UNIQUE':u  skip.
      if entry(3, str) = "1" then put unformatted '  PRIMARY':u skip.
      if entry(4, str) = "1" then put unformatted '  WORD':u    skip.
      do nx = 5 to num-entries(str) by 2:
        tag = "0".
        tag = entry(nx + 1, str) no-error.
        put unformatted '  INDEX-FIELD "':u entry(nx, str) '" '
          (if tag = "0" then 'ASCENDING ':u else 'DESCENDING ':u) skip.
      end.
      put unformatted skip(1).
    end.

    /* Got this from: http://www.v9stuff.com/dynexport.htm, */
    /* thanks to Tony Lavinio and Peter van Dam             */
    assign nx = seek(output).
    put unformatted "." skip
                    "PSC":u skip
                    "cpstream=":u session:cpstream skip
                    "." skip
                    string(nx, "9999999999") skip.
    output close.
end procedure. /* df_format */


/* Name : txt_format
 * Desc : Write in TXT style.
 */
procedure txt_format:
    define variable cColumnSep           as character  no-undo.
    define variable cCrossChar           as character  no-undo.
    define variable cHorGridLine         as character  no-undo.
    define variable cHorGridFieldValue   as character  no-undo.
    define variable lHorGridFieldChanged as logical    no-undo.
    define variable cPrintLine           as character  no-undo.
    define variable iRecordCounter       as integer    no-undo.

    /* If vertical grid is required, set the seperation char to ' | ' */
    if lVerGrid then
      assign
        cColumnSep   = fill(" ",length(cGridCharHor,'character'))
                       + cGridCharVer
                       + fill(" ",length(cGridCharHor,'character')) /* " | " */

        /* Ic - 13May2014*/
        cColumnSep = cGridCharVer /*"|"*/
        cCrossChar = cGridCharHor + cGridCharCross + cGridCharHor.  /* "-+-" */
    else
      assign
        cColumnSep   = "  "
        cCrossChar = fill(cGridCharHor,2).

    if lAppend then
      output to value(cOutputFile) append.
    else
      output to value(cOutputFile).

    /* Make a line with the names of the columns */
    lFirstField = true.
    cHorGridLine = "".
    do wf = 1 to nf:
      hwf = btt:buffer-field(wf).
      if FieldRequired(hwf) then
      do:
        if lPrintLabels then
          if not lFirstField then put unformatted cColumnSep.
        lFirstField = false.

        nx = hwf:extent.
        if nx = 0 then
        do:
          if lPrintLabels then
            /* Ic - 13May2013 */
            /*put unformatted
              string(replace(hwf:label, "_":U, " ":U), fill("X":U, getColumnWidth(hwf))).*/
          put UNFORMATTED TRIM(hwf:label).          
          cHorGridLine = cHorGridLine + ( if cHorGridLine = '' then '' else cCrossChar)
                       + string(fill(cGridCharHor, getColumnWidth(hwf)),'x(' + string(getColumnWidth(hwf)) + ')').
        end. /* no extent */
        else
        do nx = 1 to hwf:extent:
          if lPrintLabels then do:
            if nx > 1 then put unformatted cColumnSep.
            /* Ic - 13May2013 */
            /*put unformatted
              string(replace(hwf:label, "_":U, " ":U) + "[":U + string(nx) + "]":U, fill("X":U, 3 + getColumnWidth(hwf))).*/
              put UNFORMATTED TRIM(hwf:label) + "[":U + string(nx) + "]".
          end.
          cHorGridLine = cHorGridLine + ( if cHorGridLine = '' then '' else cCrossChar)
                       + string(fill(cGridCharHor, getColumnWidth(hwf)),'x(' + string(getColumnWidth(hwf)) + ')').
        end. /* for each extent */
      end. /* field required in output */
    end. /* for each field */

    if lPrintLabels then
      put unformatted {&lf}.

    create query hQuery.
    hQuery:set-buffers(btt:handle).
    hQuery:query-prepare("FOR EACH " + htt:name).
    hQuery:query-open.

    assign
      cHorGridFieldValue = ''
      iRecordCounter     = 0.

    repeat:
      hQuery:get-next().
      if hQuery:query-off-end then leave.

      assign
        lFirstField = true
        cThisRec    = ''
        cPrintLine  = ''
        lHorGridFieldChanged = no
        .

      do wf = 1 to btt:num-fields:
        hwf = btt:buffer-field(wf).

        if FieldRequired(hwf) then
        do:
          if not lFirstField then
            cPrintLine = cPrintLine + cColumnSep.

          nx = hwf:extent.
          if nx = 0 then
          do:            
            str = hwf:string-value.
            cThisRec = cThisRec + str + chr(1).

            /* See if the field which determines the hor grid line, has changed */
            if cHorGridFieldName = hwf:name
              and cHorGridFieldValue <> str then
              assign lHorGridFieldChanged = true
                     cHorGridFieldValue = str.

            /* check on differences with prev record (not for array fields) */
            if cPrevRec > ""
              and can-do(cFirstOfList,hwf:name)
              and str = entry(wf,cPrevRec,chr(1)) then
              str = "".

            if hwf:buffer-value = ? then str = "?".
            /* Ic - 13May2013 */
            /*cPrintLine = cPrintLine + string(trim(str), fill("X":U, getColumnWidth(hwf))).*/
            cPrintLine = cPrintLine + trim(str).
          end. /* no extent */
          else
          do nx = 1 to hwf:extent:
            if nx > 1 then put unformatted cColumnSep.
            str = hwf:string-value(nx).
            if hwf:buffer-value(nx) = ? then str = "?".
            /* Ic 13May2014*/
            /*cPrintLine = cPrintLine + string(trim(str), fill("X":U, 3 + getColumnWidth(hwf))).*/
            cPrintLine = cPrintLine + trim(str).
          end. /* for each extent */

          lFirstField = false.
        end. /* field required in output */
        else
          cThisRec = cThisRec + chr(1).
      end. /* do wf */

      /* horizontal line? */
      if not (iRecordCounter = 0 and lPrintLabels = false) then
        if (    iGridInterval = 0
            and lHorGridFieldChanged = true)
        or (    iGridInterval > 0
            and lHorGrid = true
            and iRecordCounter MODULO iGridInterval = 0) then
        put unformatted cHorGridLine {&lf}.

      /* print the data */
      put unformatted
        cPrintLine {&lf}.

      /* remember 'prev' record and increase counter */
      assign
        cPrevRec       = cThisRec
        iRecordCounter = iRecordCounter + 1.
    end. /* repeat */

    /* horizontal line? */
    if   (iGridInterval = 0)
      or (iGridInterval > 0 and lHorGrid = true and iRecordCounter MODULO iGridInterval = 0) then
      put unformatted cHorGridLine {&lf}.

    hQuery:query-close().
    delete object hQuery.
    output close.
end procedure. /* txt_format */


/* Name : xls_format
 * Desc : Write in XLS style.
 */
procedure xls_format:
    define variable chExcelApplication   as com-handle no-undo.
    define variable chWorkbook           as com-handle no-undo.
    define variable chWorksheet          as com-handle no-undo.
    define variable chRange              as com-handle no-undo.
    define variable cols                 as character  no-undo.
    define variable cnt                  as integer    no-undo.

    create "Excel.Application" chExcelApplication.
    assign chExcelApplication:Visible = lExcelVisible.
    chExcelApplication:Workbooks:Add({&xlWBATWorksheet}).
    assign chWorkbook  = chExcelApplication:WorkBooks:Item(1)
           chWorkSheet = chExcelApplication:Sheets:Item(1).
    assign chWorkSheet:Name = getValidFileName(cOutputFile).
    assign
      nc          = 0
      lFirstField = true
      cThisRec    = ''.

    do wf = 1 to nf:
      hwf = btt:buffer-field(wf).

      if FieldRequired(hwf) then
      do:
        lFirstField = false.

        nx  = hwf:extent.
        if nx = 0 then
        do:
          nc = nc + 1.
          cols = getExcelColumn(nc).

          if lPrintLabels then do:
            chWorksheet:Range(cols + ":":U + cols):ColumnWidth = getExcelColumnWidth(hwf).
            chWorksheet:Range(cols + "1":U):Value = replace(hwf:label, "_":U, " ":U).
          end.

          case hwf:data-type:
            when "integer" or
            when "date"    OR
            when "decimal" then
              chWorksheet:Range(cols + "1":U):HorizontalAlignment = {&xlRight}.
          end case.
          /*IF hwf:DATA-TYPE = "date" THEN chWorksheet:COLUMNS(cols):NumberFormat = "dd/MM/yyyy".*/
        end. /* no extent */
        else
        do nx = 1 to hwf:extent:
          nc = nc + 1.
          cols = getExcelColumn(nc).

          if lPrintLabels then do:
            chWorksheet:Range(cols + ":":U + cols):ColumnWidth = getExcelColumnWidth(hwf).
            chWorksheet:Range(cols + "1":U):Value = replace(hwf:label, "_":U, " ":U) + "[":U + string(nx) + "]":U.
          end.

          case hwf:data-type:
            when "integer" or
            when "date"    or
            when "decimal" then
              chWorksheet:Range(cols + "1":U):HorizontalAlignment = {&xlRight}.
          end case.
        end. /* for each extent */
      end. /* field required in output */
    end. /* for each field */

    create query hQuery.
    hQuery:set-buffers(btt:handle).
    hQuery:query-prepare("FOR EACH " + htt:name).
    hQuery:query-open.
    cnt = 1.
    repeat:
      cnt = cnt + 1.
      hQuery:get-next().
      if hQuery:query-off-end then leave.
      assign
        nc          = 0
        lFirstField = true
        cThisRec    = ''.

      do wf = 1 to btt:num-fields:
        hwf = btt:buffer-field(wf).

        if FieldRequired(hwf) then
        do:
          if not lFirstField then put unformatted "  ".
          lFirstField = false.

          nx = hwf:extent.
          if nx = 0 then
          do:
            nc = nc + 1.
            cols = getExcelColumn(nc) + string(cnt).
            str = hwf:string-value.

            cThisRec = cThisRec + str + chr(1).

            /* check on differences with prev record (not for array fields) */
            if cPrevRec > ""
              and can-do(cFirstOfList,hwf:name)
              and str = entry(wf,cPrevRec,chr(1)) then
              str = "".

            if hwf:buffer-value = ? then str = "?".
            chWorksheet:Range(cols):Value = right-trim(str).
          end.
          else
          do nx = 1 to hwf:extent:
            nc = nc + 1.
            cols = getExcelColumn(nc) + string(cnt).
            str = hwf:string-value(nx).
            if hwf:buffer-value(nx) = ? then str = "?".
            chWorksheet:Range(cols):Value = right-trim(str).
          end.
        end. /* Field required in output */
        else
          cThisRec = cThisRec + chr(1).
      end. /* for each field */

      /* remember 'prev' record */
      cPrevRec = cThisRec.
    end. /* repeat */
    hQuery:query-close().
    delete object hQuery.

    /* Adjust column sizes */
/*     cols = getExcelColumn(nc).                                   */
/*     chRange = chWorksheet:Range(cols + "A:":U + cols):Columns(). */
/*     chRange:AutoFit().                                           */
/*     release object chRange no-error.                             */

    /* Set first row as title row */
    chWorksheet:Range("A1:A1"):Select.
    chWorkbook:Windows(1):SplitColumn = 0.
    chWorkbook:Windows(1):SplitRow    = 1.
    chWorkbook:Windows(1):FreezePanes = True.

    /* Do we want interaction with excel? */
    chExcelapplication:DisplayAlerts = lExcelAlert.

    /* Save data */
/*     if chExcelapplication:Version begins "8":U                        */
/*       then chWorkBook:SaveAs(cOutputFile, {&xlExcel9795},,,,,,).      */
/*       else chWorkBook:SaveAs(cOutputFile, {&xlWorkbookNormal},,,,,,). */

    IF chExcelapplication:Version < 12 
        THEN chWorkBook:SaveAs(cOutputFile, {&xlWorkbookNormal},,,,,,).
    ELSE chWorkBook:SaveAs(cOutputFile, 56,,,,,,).

    chWorkBook:Close().
    release object chWorkSheet  no-error.
    release object chWorkBook   no-error.
    chExcelApplication:Quit().
    release object chExcelApplication no-error.
end procedure. /* xls_format */


/* Name : csv_format
 * Desc : Write in CSV style.
 */
procedure csv_format:
    if lAppend then
      output to value(cOutputFile) append.
    else
      output to value(cOutputFile).

    lFirstField = true.
    if lPrintLabels then
    do wf = 1 to nf:
      hwf = btt:buffer-field(wf).
      if FieldRequired(hwf) then
      do:
        if not lFirstField then put unformatted ",".
        lFirstField = false.

        nx = hwf:extent.
        if nx = 0 then
        do:
          put unformatted {&qt} trim(replace(hwf:label, "_":U, " ":U)) {&qt}.
        end. /* no extent */
        else
        do nx = 1 to hwf:extent:
          if nx > 1 then put unformatted ",":U.
          put unformatted {&qt} trim(replace(hwf:label, "_":U, " ":U))
            "[":U string(nx) "]":U {&qt}.
        end. /* for each extent */
      end. /* Field required in output */
    end. /* for each field */
    put unformatted {&lf}.

    create query hQuery.
    hQuery:set-buffers(btt:handle).
    hQuery:query-prepare("FOR EACH " + htt:name).
    hQuery:query-open.
    repeat:
      hQuery:get-next().
      if hQuery:query-off-end then leave.
      assign
        lFirstField = true
        cThisRec = ''.

      do wf = 1 to btt:num-fields:
        hwf = btt:buffer-field(wf).
        if FieldRequired(hwf) then
        do:
          if not lFirstField then put unformatted ",".
          lFirstField = false.

          nx = hwf:extent.
          if nx = 0 then
          do:
            str = trim(hwf:string-value).
            cThisRec = cThisRec + str + chr(1).

            /* check on differences with prev record (not for array fields) */
            if cPrevRec > ""
              and can-do(cFirstOfList,hwf:name)
              and str = entry(wf,cPrevRec,chr(1)) then
              str = "".

            if hwf:buffer-value = ? then str = "?".
            if hwf:data-type = "character" then
              put unformatted substitute("&1&2&1",{&qt},str).
            else
              put unformatted str.
          end. /* no extent */
          else
          do nx = 1 to hwf:extent:
            if nx > 1 then put unformatted ",":U.
            if hwf:data-type = "character" then put unformatted {&qt}.
            put unformatted trim(hwf:string-value(nx)).
            if hwf:buffer-value(nx) = ? then put unformatted "?".
            if hwf:data-type = "character" then put unformatted {&qt}.
          end. /* for each extent */
        end. /* Field required in output */
        else
          cThisRec = cThisRec + chr(1).
      end. /* for each field */
      put unformatted {&lf}.

      /* remember 'prev' record */
      cPrevRec = cThisRec.

    end. /* repeat */
    hQuery:query-close().
    delete object hQuery.
    output close.
end procedure. /* csv_format */


/* Name : brs_format
 * Desc : Create a browse window.
 */
procedure brs_format:
  define variable bwin   as handle     no-undo.
  define variable cw     as integer    no-undo.
  define variable mw     as integer    no-undo initial 88.
  define variable hq     as handle     no-undo.
  define variable hb     as handle     no-undo.

  define sub-menu m_File
    menu-item m_Exit   label "E&xit"
    menu-item m_Clip   label "&Clip"
    menu-item m_Choose label "C&hoose".
  define menu   m_Bar  menubar sub-menu m_File label "&File".
  define button btExit   label "E&xit"   size 12 by .92.
  define button btClip   label "&Clip"   size 12 by .92.
  define button btChoose label "C&hoose" size 12 by .92.

  define query qBrowse for q-help scrolling.
  define browse qBrowse
    query qBrowse no-lock display
      with no-row-markers separators size 88 by 13 expandable.

  define frame fMaster
    btExit   at row 1 col 2
    btClip   at row 1 col 15
    btChoose at row 1 col 28
    qBrowse  at row 2 col 2
    with 1 down no-box keep-tab-order overlay
         side-labels no-underline three-d
         at col 1 row 1 size 90 by 15.

  create query hQuery.
  hQuery:set-buffers(btt:handle).
  hQuery:query-prepare("FOR EACH " + htt:name).
  qBrowse:query = hQuery.
  qBrowse:width-chars = 1.
  cw = 2.

  do wf = 1 to btt:num-fields:
    hwf = btt:buffer-field(wf).

    if FieldRequired(hwf) then
    do:
      nx  = hwf:extent.
      if nx = 0 then nx = 1.
      cw  = cw + getColumnWidth(hwf) * nx.
      qBrowse:width-chars = cw.
      qBrowse:add-like-column(hwf).
    end. /* Field required in output */
  end. /* for each field */

  if cw > mw then cw = mw.
  if cw < 20 then cw = 20. /* oom for buttons */
  frame fMaster:width-chars          = cw + 1.
  frame fMaster:virtual-width-chars  = cw + 1.
  qBrowse:width-chars = cw.
  qBrowse:column-scrolling = false.
  hQuery:query-open.

  create window bwin assign
    hidden             = yes
    title              = cBrowseTitle
    height             = 15
    width              = cw + 2
    max-height         = 15
    max-width          = cw + 2
    virtual-height     = 15
    virtual-width      = cw + 2
    resize             = no
    scroll-bars        = no
    status-area        = no
    bgcolor            = ?
    fgcolor            = ?
    keep-frame-z-order = yes
    three-d            = yes
    message-area       = no
    sensitive          = yes.

  assign bwin:menubar = menu m_Bar:handle.
  bwin:hidden = no.
  bwin:top-only = yes.

  on entry of bwin
  do:
    on esc bell.
    on return tab.
  end.

  on leave of bwin
  do:
    on esc end-error.
    on return return.
  end.

  on esc, endkey, end-error, window-close of bwin anywhere do:
    apply "close":U to bwin.
    return no-apply.
  end.

  on choose of btClip /* Clip */
  or choose of menu-item m_Clip
  do:
    output to "clipboard".
    put unformatted replace(qBrowse:tooltip, {&lf}, {&cr} + {&lf}) {&cr} {&lf}.
    output close.
    apply "entry" to qBrowse.
  end.

  on choose of btExit /* Exit */
  or choose of menu-item m_Exit
  do:
    apply "close":U to bwin.
  end.

  on choose of btChoose /* Choose */
  or choose of menu-item m_Choose
  or default-action of qBrowse
  do:
    cReturnString = ''.
    qBrowse:fetch-selected-row(1) no-error.
    hq = qBrowse:query.
    if not hq:get-current(no-lock) then
      return no-apply.
    hb = hq:get-buffer-handle(1).

    do wf = 1 to num-entries(cReturnFieldList):
      hwf = btt:buffer-field(entry(wf,cReturnFieldList)).

      if wf > 1 then cReturnString = cReturnString + chr(1).
      nx = hwf:extent.
      if nx = 0 then
      do:
        cReturnString = cReturnString + trim(hwf:string-value).
        if hwf:buffer-value = ? then cReturnString = cReturnString + "?".
      end.
      else
      do nx = 1 to hwf:extent:
        cReturnString = cReturnString + trim(hwf:string-value(nx)).
        if hwf:buffer-value(nx) = ? then cReturnString = cReturnString + "?".
      end.
    end.

    apply "close":U to bwin.
  end.

  on value-changed of qBrowse
  do:
    qBrowse:fetch-selected-row(1) no-error.
    hq = qBrowse:query.
    if not hq:get-current(no-lock) then
      return no-apply.
    hb = hq:get-buffer-handle(1).
    str = "".
    do wf = 1 to hb:num-fields:
      if wf > 1 then str = str + {&lf}.
      hwf = btt:buffer-field(wf).
      nx = hwf:extent.
      if nx = 0 then
      do:
        str = str + replace(hwf:label, "_":U, " ":U) + ": ":U + hwf:string-value.
        if hwf:buffer-value = ? then str = str + "?".
      end.
      else
      do nx = 1 to hwf:extent:
        if nx = 1 then str = str + replace(hwf:label, "_":U, " ":U) + ": ":U.
                  else str = str + ", ":U.
        str = str + trim(hwf:string-value(nx)).
        if hwf:buffer-value(nx) = ? then str = str + "?".
      end.
    end.
    qBrowse:tooltip = str.
  end.

  enable btClip btExit btChoose qBrowse with frame fMaster in window bwin.
  view frame fMaster in window bwin.
  view bwin.
  qBrowse:select-row(1).
  apply "entry" to qBrowse.
  apply "value-changed" to qBrowse.

  wait-for close of bwin.
  hQuery:query-close().
  delete object hQuery.
  on esc end-error.
  on return return.
  delete widget bwin.
end procedure. /* brs_format */


/* Name : slk_format
 * Desc : Write in SYLK style.
 */
procedure slk_format:
  define variable fmtstr               as character  no-undo.
  define variable fmtkey               as character  no-undo.
  define variable fmttmp               as character  no-undo.
  define variable fmtcol               as integer    no-undo.
  define variable fmtrow               as integer    no-undo.
  define variable fmtsiz               as integer    no-undo.
  define variable fmtwid               as character  no-undo.

  /* Prefill temp table with formats and fonts */
  run SylkFormat({&sylk-fil-picture}, "PGeneral",         "").
  run SylkFormat({&sylk-fil-picture}, "Pdd\-mmm\-yy",     {&sylk-xls-dmy}).
  run SylkFormat({&sylk-fil-picture}, "Pmm/dd/yy",        {&sylk-xls-mdy}).
  run SylkFormat({&sylk-fil-picture}, "Pmmmm\ d\,\ yyyy", {&sylk-xls-md-y}).
  run SylkFormat({&sylk-fil-picture}, "Pyymmdd",          {&sylk-xls-ymd}).
  run SylkFormat({&sylk-fil-picture}, "Pyyyymmdd",        {&sylk-xls-cymd}).
  run SylkFormat({&sylk-fil-picture}, "Ph:mm",            {&sylk-xls-hm}).
  run SylkFormat({&sylk-fil-picture}, "Ph:mm\ AM/PM",     {&sylk-xls-hm-a}).
  run SylkFormat({&sylk-fil-picture}, "Ph:mm:ss",         {&sylk-xls-hms}).
  run SylkFormat({&sylk-fil-picture}, "Ph:mm:ss\ AM/PM",  {&sylk-xls-hms-a}).
  run SylkFormat({&sylk-fil-font},    "ECourier;M200;SB", {&sylk-xls-title}).
  run SylkFormat({&sylk-fil-font},    "ECourier;M200",    {&sylk-xls-body}).

  fmtcol = 0.
  fmtkey = "".
  lFirstField = true.
  do wf = 1 to nf:
    hwf = btt:buffer-field(wf).

    if FieldRequired(hwf) then
    do:
      lFirstField = false.

      fmtstr = hwf:format.
      /* Determine type of data in column */
      case hwf:data-type:
        when "INTEGER"   then fmttmp = {&SylkFormat-number}. /* Number  */
        when "DECIMAL"   then fmttmp = {&SylkFormat-number}. /* Number  */
        when "CHARACTER" then fmttmp = {&SylkFormat-string}. /* String  */
        when "DATE"      then fmttmp = {&SylkFormat-date}.   /* Date    */
        otherwise             fmttmp = " ".                /* Unknown */
      end case.

      /* Determine format to use... */
      /* ...for a number */
      if     (   hwf:data-type = "INTEGER"
              or hwf:data-type = "DECIMAL")
         and not hwf:format begins ":" then
      do:
        fmtstr = replace(fmtstr, "9", "0"). /* Forced character   */
        fmtstr = replace(fmtstr, "Z", "0"). /* Forced character   */
        fmtstr = replace(fmtstr, ">", "#"). /* Optional character */
        fmtstr = replace(fmtstr, "-", "#"). /* Optional character */
        fmtstr = "P" + fmtstr.
        /* Add format if not already there */
        if SylkValue({&sylk-fil-picture}, fmtstr) = "P0" then run SylkFormat({&sylk-fil-picture}, fmtstr, fmtstr).
      end.

      /* ...for a time */
      if hwf:data-type = "INTEGER" then
      do:
        /* check for time formats */
        case hwf:format:
          when {&tt-fmt-hm}    then do: fmtstr = {&sylk-xls-hm}.    fmttmp = {&SylkFormat-time}. end.
          when {&tt-fmt-hm-a}  then do: fmtstr = {&sylk-xls-hm-a}.  fmttmp = {&SylkFormat-time}. end.
          when {&tt-fmt-hms}   then do: fmtstr = {&sylk-xls-hms}.   fmttmp = {&SylkFormat-time}. end.
          when {&tt-fmt-hms-a} then do: fmtstr = {&sylk-xls-hms-a}. fmttmp = {&SylkFormat-time}. end.
        end case.
      end.

      /* ...for a date */
      if hwf:data-type = "DATE" then
      do:
        if fmtstr = {&tt-fmt-mdy}  then fmtstr = {&sylk-xls-mdy}.
        if fmtstr = {&tt-fmt-dmy}  then fmtstr = {&sylk-xls-dmy}.
        if fmtstr = {&tt-fmt-md-y} then fmtstr = {&sylk-xls-md-y}.
        if fmtstr = {&tt-fmt-ymd}  then fmtstr = {&sylk-xls-ymd}.
        if fmtstr = {&tt-fmt-cymd} then fmtstr = {&sylk-xls-cymd}.
      end.

      /* ...for a logical */
      if hwf:data-type = "LOGICAL" then
      do:
        fmtstr = fill("X",
                      max(length(entry(1, hwf:format, "/"), "character"),
                          length(entry(2, hwf:format, "/"), "character"))).
        fmttmp = {&SylkFormat-logical}.
      end.

      fmtkey = fmtkey + fmttmp.
      /* Get data for column formatting and titles */
      nx = hwf:extent.
      /* Two versions: scalar and array */
      if nx = 0 then
      do:
        fmtcol = fmtcol + 1.
        fmtwid = string(fmtcol).
        /* Get column width as max(label width, data width) */
        fmtsiz = length(hwf:label, "character").
        if fmttmp = {&SylkFormat-logical} then fmtsiz = max(fmtsiz, length(fmtstr, "character")).
        if fmttmp = {&SylkFormat-time} then fmtsiz = max(fmtsiz, length(fmtstr, "character")).
                                     else fmtsiz = max(fmtsiz, length(hwf:string-value, "character")).
        if fmttmp = {&SylkFormat-date} and fmtstr = {&sylk-xls-md-y} then
          fmtsiz = max(length(hwf:label, "character"), 18).
        /* Store width info */
        run SylkFormat({&sylk-fil-c-wid},
                     "W" + fmtwid + " " + fmtwid + " " + string(fmtsiz),
                     fmtwid).
        /* Store title info (alignment and text) */
        run SylkFormat({&sylk-fil-c-title},
                     "F;FG0" + (if fmttmp={&SylkFormat-string} then "L" else "R") + ";SD"
                   + SylkValue({&sylk-fil-font}, {&sylk-xls-title}) + ";Y1;X" + fmtwid + {&lf}
                   + "C;K" + {&qt} + trim(replace(hwf:label, "_":U, " ":U)) + {&qt},
                     fmtwid).
        /* Store format info */
        run SylkFormat({&sylk-fil-c-fmt},
                     SylkValue({&sylk-fil-picture}, fmtstr) + ";FG0G;C" + fmtwid,
                     fmtwid).
      end.
      else
      do:
        /* Get column width as max(label width, data width) */
        fmtsiz = length(hwf:label + "[" + string(nx) + "]", "character").
        if fmttmp = {&SylkFormat-logical} then fmtsiz = max(fmtsiz, length(fmtstr, "character")).
        if fmttmp = {&SylkFormat-time} then fmtsiz = max(fmtsiz, length(fmtstr, "character")).
                                     else fmtsiz = max(fmtsiz, length(hwf:string-value[nx], "character")).
        if fmttmp = {&SylkFormat-date} and fmtstr = {&sylk-xls-md-y} then
          fmtsiz = max(fmtsiz, 18).
        do nx = 1 to hwf:extent:
          fmtcol = fmtcol + 1.
          fmtwid = string(fmtcol).
          /* Store width info */
          run SylkFormat({&sylk-fil-c-wid},
                       "W" + fmtwid + " " + fmtwid + " " + string(fmtsiz)
                       , fmtwid).
          /* Store title info (alignment and text) */
          run SylkFormat({&sylk-fil-c-title},
                       "F;FG0" + (if fmttmp={&SylkFormat-string} then "L" else "R") + ";SD"
                     + SylkValue({&sylk-fil-font}, {&sylk-xls-title}) + ";Y1;X" + fmtwid + {&lf}
                     + "C;K" + {&qt} + trim(replace(hwf:label, "_":U, " ":U)) + "[":U + string(nx) + "]":U + {&qt},
                       fmtwid).
          /* Store format info */
          run SylkFormat({&sylk-fil-c-fmt},
                       SylkValue({&sylk-fil-picture}, fmtstr) + ";FG0G;C" + fmtwid,
                       fmtwid).
        end.
      end.
    end. /* Field required in output */
    else
      fmtkey = fmtkey + ' '.
  end.

  /* Write out file */
  output to value(cOutputFile).
  /* BNF: "ID" ";P" <name> ";N" ";E"
   * ;P <name>   authoring-program
   * ;N          File uses ;N style cell protection (not ;P style).
   * ;E          NE records are redundant as formulas support external ref's directly.
   */
  put unformatted "ID;PTT-FILE;N;E" {&lf}.
  /* BNF: "P;P" <xl-pic>
   * "P;P" <xl-pic>   Excel style picture format.  Count from zero.
   */
  for each tt-sylk where tt-sylk.typ = {&sylk-fil-picture} no-lock by tt-sylk.seq:
    put unformatted "P;" tt-sylk.val {&lf}.
  end.
  /* BNF: "P;E" <xl-font> ";M200" [ ";S" ["B"] ["I"] ]
   * "P;E" <xl-font>    Excel font.  Count from zero.
   * ";M200"            ???
   * ";S" ["B"] ["I"]   Style [Bold] [Italic]
   */
  for each tt-sylk where tt-sylk.typ = {&sylk-fil-font} no-lock by tt-sylk.seq:
    put unformatted "P;" tt-sylk.val {&lf}.
  end.
  /* BNF: "F;" <xl-def-fmt> ";D" <fmt> <dig> <ali> <wid> ";S" <xl-def-fnt> ";M240"
   * "P;" <xl-def-fmt>   Default format number.
   * ";D" <fmt> <dig> <ali> <wid>   Default formatting, digits, alignment, and width
   *                                "G0G8" = General Format, 0 digits after the decimal,
   *                                         General (textleft, numbersright) alignment,
   *                                         8 chars wide
   * ";S" <xl-def-fnt>              Default font to use by font number
   * ";M240"                        ???
   */
  put unformatted "F;" SylkValue({&sylk-fil-picture}, "") ";DG0G8;S" SylkValue({&sylk-fil-font}, {&sylk-xls-body}) ";M240" {&lf}.
  /* BNF: "B" ";Y" <num-row> ";X" <num-col> ";D0 0 1 3"
   * "B"              Boundry conditions
   * ";Y" <num-row>   Number of rows? 1 seems to work OK
   * ";X" <num-col>   Number of columns
   * ";D0 0 1 3"      ???
   */
  put unformatted "B;Y1;X" fmtcol ";D0 0 1 3" {&lf}.
  /* BNF: "O" ";L" ";D;V0;K47;G100 0.001"
   * "O"                      Options
   * ";L"                     Use A1 mode references (R1C1 always used in SYLK file expressions).
   * ";D;V0;K47;G100 0.001"   ???
   */
  put unformatted "O;L;D;V0;K47;G100 0.001" {&lf}.
  /* BNF: "F;W" <begin> <end> <wid>
   * "F;W" <begin> <end> <wid>   Column width define columns <begin> to <end> as <wid> wide
   */
  for each tt-sylk where tt-sylk.typ = {&sylk-fil-c-wid} no-lock by tt-sylk.seq:
    put unformatted "F;" tt-sylk.val {&lf}.
  end.
  /* BNF: "F;P" <xl-fmt> ";F" <fmt> <dig> <ali> ";C" <col-num>
   * "F;P" <xl-fmt>           Use format by number
   * ";F" <fmt> <dig> <ali>   formatting, digits, and alignment
   * ";C" <col-num>           Apply to column (A = 1)
   */
  for each tt-sylk
    where tt-sylk.typ = {&sylk-fil-c-fmt} no-lock by tt-sylk.seq:
    put unformatted "F;" tt-sylk.val {&lf}.
  end.
  /* BNF: "F;F" <fmt> <dig> <ali> ";SDM" <xl-font> ";Y" <row-num> ";X" <col-num>
   *      "C;K" <q-value>
   * "F;F" <fmt> <dig> <ali>   formatting, digits, and alignment
   *                           alignment of ("L" | "R")=(Left | Right)
   * ";SDM" <xl-font>          Font to use
   * ";Y" <row-num>            Cell location
   * ";X" <col-num>            Cell location
   * "C;K" <q-value>           Cell value (quoted for text)
   */
  for each tt-sylk
    where tt-sylk.typ = {&sylk-fil-c-title} no-lock by tt-sylk.seq:
    put unformatted tt-sylk.val {&lf}.
  end.

  create query hQuery.
  hQuery:set-buffers(btt:handle).
  hQuery:query-prepare("FOR EACH " + htt:name).
  hQuery:query-open.
  fmtrow = 1.
  repeat:
    hQuery:get-next().
    if hQuery:query-off-end then leave.
    fmtcol = 0.
    fmtrow = fmtrow + 1.
    lFirstField = true.
    do wf = 1 to btt:num-fields:
      hwf = btt:buffer-field(wf).
      if FieldRequired(hwf) then
      do:
        lFirstField = false.

        nx = hwf:extent.
        fmttmp = substring(fmtkey, wf, 1, "character").
        if nx = 0 then
        do:
          fmtcol = fmtcol + 1.
          /* BNF: "C;Y" <row-num> ";X" <col-num> ";K" <q-value>
           * "C;Y" <row-num>   Cell location
           * ";X" <col-num>    Cell location
           * ";K" <q-value>    Cell value (quoted for text)
           */
          put unformatted "C;Y" string(fmtrow) ";X" string(fmtcol) ";K".
          if fmttmp = {&SylkFormat-string} or fmttmp = {&SylkFormat-logical} or hwf:buffer-value = ? then put unformatted {&qt}.
          case fmttmp:
            when {&SylkFormat-date}    then
            do:
              if date(hwf:string-value) >= 1/1/1900 then
                put unformatted integer(date(hwf:string-value) - 1/1/1900) + 2.
              else
                put unformatted {&qt} hwf:string-value {&qt}.
            end.
            when {&SylkFormat-time}    then put unformatted integer(hwf:buffer-value) / 24 / 60 / 60.
            when {&SylkFormat-logical} then put unformatted right-trim(hwf:string-value).
            otherwise                     put unformatted right-trim(hwf:buffer-value).
          end case.
          if hwf:buffer-value = ? then put unformatted "?".
          if fmttmp = {&SylkFormat-string} or fmttmp = {&SylkFormat-logical} or hwf:buffer-value = ? then put unformatted {&qt}.
          put unformatted {&lf}.
        end.
        else
        do nx = 1 to hwf:extent:
          fmtcol = fmtcol + 1.
          put unformatted "C;Y" string(fmtrow) ";X" string(fmtcol) ";K".
          if fmttmp = {&SylkFormat-string} or fmttmp = {&SylkFormat-logical} or hwf:buffer-value(nx) = ? then put unformatted {&qt}.
          case fmttmp:
            when {&SylkFormat-date}    then
            do:
              if date(hwf:string-value(nx)) >= 1/1/1900 then
                put unformatted integer(date(hwf:string-value(nx)) - 1/1/1900) + 2.
              else
                put unformatted {&qt} hwf:string-value {&qt}.
            end.
            when {&SylkFormat-time}    then put unformatted integer(hwf:buffer-value(nx)) / 24 / 60 / 60.
            when {&SylkFormat-logical} then put unformatted right-trim(hwf:string-value(nx)).
            otherwise                     put unformatted right-trim(hwf:buffer-value(nx)).
          end case.
          if hwf:buffer-value(nx) = ? then put unformatted "?".
          if fmttmp = {&SylkFormat-string} or fmttmp = {&SylkFormat-logical} or hwf:buffer-value(nx) = ? then put unformatted {&qt}.
          put unformatted {&lf}.
        end.
      end. /* Field required in output */
    end.
  end.

  hQuery:query-close().
  delete object hQuery.
  /* BNF: "E"
   * "E"   End of file
   */
  put unformatted "E" {&lf}.
  output close.
end procedure. /* slk_format */


/* Name : xml_format
 * Desc : Write in XML style.
 */
procedure xml_format:
  define variable hDoc                 as handle     no-undo.
  define variable hRoot                as handle     no-undo.
  define variable hRow                 as handle     no-undo.
  define variable hText                as handle     no-undo.
  define variable hBuf                 as handle     no-undo.
  define variable hDBFld               as handle     no-undo.
  define variable iKeyField            as integer    no-undo.
  define variable cKeyField            as character  no-undo.
  define variable hKeyField            as handle     no-undo.
  define variable cNodeName            as character  no-undo.

  create query hQuery.
  hQuery:set-buffers(btt:handle).
  hQuery:query-prepare("for each " + htt:name).
  hQuery:query-open.

  create x-document hDoc.
  create x-noderef hRoot.
  create x-noderef hRow.
  create x-noderef hField.
  create x-noderef hText.

  /* set up a root node */
  file-info:file-name = cOutputFile.
  if lAppend and file-info:full-pathname ne ? then do:
    hDoc:load("file",cOutputFile,false).
    /* find root node */
    hDoc:get-document-element(hRoot).
  end.
  else do:
    hDoc:create-node(hRoot,"RecordSet","element").
    hDoc:append-child(hRoot).
  end.

  repeat:
    hQuery:get-next().
    if hQuery:query-off-end then leave.

    hDoc:create-node(hRow,btt:name,"element"). /* create a row node */
    hRoot:append-child(hRow). /*  put the row in the tree */

    /* Filter out keyfields */
    do iKeyField = 1 to num-entries(cKeyFieldList):
      assign
        cKeyField  = entry(iKeyField,cKeyFieldList)
        hKeyField  = btt:buffer-field(cKeyField)

      /* Filter out chars XML does not like */
      cKeyField = getXMLFriendlyString( cKeyField ).

      if valid-handle(hKeyField) then
        hRow:set-attribute(cKeyField,string(hKeyField:buffer-value)).
    end.

    do wf = 1 to btt:num-fields:
      hwf = btt:buffer-field(wf).

      /* Filter out chars XML does not like */
      cNodeName = getXMLFriendlyString( hwf:name ).

      if FieldRequired(hwf)
        and not can-do(cKeyFieldList,hwf:name) then
      do:
        nx = hwf:extent.
        if nx = 0 then
        do:
          /* create a tag with the field name */
          hDoc:create-node(hField, cNodeName , "element").

          /* put the new field as next child of row */
          hRow:append-child(hField).

          /* add a node to hold field value */
          hDoc:create-node(hText, "", "text").

          /* attach the text to the field */
          hField:append-child(hText).
          hText:node-value = string(hwf:buffer-value).
        end.
        else
        do nx = 1 to hwf:extent:
          /* create a tag with the field name */
          hDoc:create-node(hField, substitute("&1_&2",cNodeName, nx) , "element").

          /* put the new field as next child of row */
          hRow:append-child(hField).

          /* add a node to hold field value */
          hDoc:create-node(hText, "", "text").

          /* attach the text to the field */
          hField:append-child(hText).
          hText:node-value = string(hwf:buffer-value(nx)).
        end. /* extent > 1 */
      end. /* field required in output */
    end. /* for each field */
  end. /* repeat */

  hQuery:query-close().
  delete object hQuery.

  /* write the XML node tree to an xml file */
  hDoc:save("file",cOutputFile).
  delete object hDoc.
  delete object hRoot.
  delete object hRow.
  delete object hField.
  delete object hText.
end procedure. /* xml_format */


/* Name : unknown_format
 * Desc : Report unsupported format.
 */
procedure unknown_format.
    output to value(cOutputFile).
    put unformatted "Call to tt-file.p with unknown file type [":U cFileType "]":U {&lf}.
    output close.
end procedure. /* unknown_format */

