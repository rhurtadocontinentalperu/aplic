
/* Feedback to: David.James@earthlink.net */
&scoped-define progver [ProProc.p (20080925)]
&Scoped-define WINDOW-NAME wProProc
&Scoped-define WINDOW-WIDTH 76
define variable {&WINDOW-NAME} as widget-handle no-undo.
/*========================================================================================================================*/
define variable pline as character no-undo. /* parse line */
define variable oline as character no-undo. /* output line */
define variable lenline as integer no-undo. /* length of parse line */
define variable ploc as integer no-undo. /* parse location */
define variable nploc as integer no-undo. /* next parse location */
define variable nwloc as integer no-undo. /* next word location */
define variable pchar as character no-undo. /* character at parse location */
define variable pword as character no-undo. /* word at parse location */
define variable kword as character no-undo. /* keyword at parse location */
define variable pkword as character no-undo. /* previous keyword */
define variable blevel as integer no-undo. /* block  / statement level */
define variable word as character extent 23 no-undo. /* word for block level */
define variable ifblock as logical extent 23 no-undo. /* current block is an 'if' block */
define variable spaces as integer extent 23 no-undo. /* indent spaces for block level */
define variable ielevel as integer no-undo. /* 'if' expression level */
define variable ieindent as integer extent 23 no-undo. /* indentation for 'if' expression level */
define variable ielevelp as integer extent 23 no-undo. /* parenthesis level for 'if' expression level */
define variable ielevele as logical extent 23 no-undo. /* processed 'else' for 'if' expression level */
define variable plevel as integer no-undo. /* parenthesis level */
define variable clevel as integer no-undo. /* comment level */
define variable pplevel as integer no-undo. /* preprocessor level */ /*2bimplemented*/
define variable trigchars as character no-undo. /* trigger characters */
define variable cpair as character no-undo. /* character pair */
define variable qchar as character no-undo. /* quote character */
define variable bwlistes as character no-undo. /* block word list - end with statement */
define variable bwlisteb as character no-undo. /* block word list - end with block or statement */
define variable bwlistk1 as character no-undo. /* block word list - effective only if first keyword of statement */
define variable cwlist as character no-undo. /* comparison and concatenation word list */
define variable isfirstkwordl as logical no-undo. /* current keyword is first keyword of line */
define variable firstkwordl as character no-undo. /* first keyword of line */
define variable firstkwords as character no-undo. /* current keyword is first keyword of statement */
define variable isfirstkwords as logical no-undo. /* first keyword of statement */
define variable diagnostic as logical no-undo. /* diagnostic mode */
define variable locsp as integer no-undo. /* location of space */
define variable loclp as integer no-undo. /* location of left parenthesis */
define variable locrp as integer no-undo. /* location of right parenthesis */
define variable ifthenelse as character no-undo. /* kword if one of if, then, else */
assign
 trigchars
   = "/"
   + "*"
   + '"'
   + "'"
   + "&"
   + "("
   + ")"
 bwlistes = "assign,compile,define,display,disable,enable,find,import,message,output,run,update"
 bwlisteb = "case,do,for,function,procedure,repeat,triggers," + bwlistes
 bwlistk1 = "case,for,function,message,output,procedure,run,triggers" /* start of block keywords only if first keyword of statement */
 cwlist = "=,eq,<>,ne,<,lt,>,gt,<=,le,>=,ge,begins,matches,+"
 .
define variable cs as character no-undo. /* 'comment start' character pair */
assign cs = "/" + "*".
define variable ce as character no-undo. /* 'comment end' character pair */
assign ce = "*" + "/".

define temp-table tKeySetNames no-undo
 field KeySetName as character
 index KeySetName
   is primary
   KeySetName ascending
 .


/*=========================================================================================================================*/

define variable cMode as character initial "Compile":U
    view-as radio-set horizontal expand size 30 by 1
    radio-buttons "Compile", "Compile", "Reformat", "Reformat"
    no-undo.
define variable lSaveRCode as logical
    label "Save R-Code"
    view-as toggle-box
    no-undo.
define variable lPP as logical
    label "PreProcess"
    view-as toggle-box
    no-undo.
define variable lListing as logical
    label "Listing"
    view-as toggle-box
    no-undo.
define variable lXref as logical
    label "Xref"
    view-as toggle-box
    no-undo.
define variable lDebugList as logical
    label "DebugList"
    view-as toggle-box
    no-undo.
define variable cInDir as character format "x(128)":U
    label "Input Directory"
    view-as fill-in
    size 60 by 1 no-undo.
define variable cOutDir as character format "x(128)":U
    label "Output Directory"
    view-as fill-in
    size 60 by 1 no-undo.
define variable cLstDir as character format "x(128)":U
    label "List Directory"
    view-as fill-in
    size 60 by 1 no-undo.
define variable lSkipDSM as logical
    label "Skip DateStamped"
    view-as toggle-box
    no-undo.
define variable cOneMod as character format "x(24)":U
    view-as fill-in
    size 24 by 1 no-undo.

define variable lCancel as logical no-undo.
define variable cSetOptions as character no-undo.
define variable cKeySet as character no-undo.
define variable cKeyValues as character no-undo.
define variable cProgBase as character no-undo.
define variable cProgRoot as character no-undo.
define variable cProgPath as character no-undo.
define variable cProgExt as character no-undo.
define variable cProgAttr as character no-undo.
define variable cPathSep as character initial "\" no-undo. /* 2bdone: Change for unix */
define variable cStatus as character no-undo.
define variable cTimeStamp as character no-undo.
define variable lDSM as logical no-undo.
define variable iWork as integer no-undo.
define variable eWork as decimal no-undo.
define variable cWork as character no-undo.
define variable hbAct as handle no-undo.
define stream sLine.

define button bChgKeySet
 label "Chg Set"
 size 11 by 1
 .

define frame fMode
 "Processing Mode: "
 cMode
 cStatus    format "x(10)" no-label
 bChgKeySet
 with no-box no-labels at row 1 column 1 size {&WINDOW-WIDTH} by 1.

define frame fAct
 lSkipDSM   at row 1 col 16 colon-aligned
 "One Module: " at row 1 col 41
 cOneMod    at row 1 col 51 colon-aligned help "(find on PROPATH + Input Directory)"
 with no-box no-labels at row 2 column 1 size {&WINDOW-WIDTH} by 1.

create button hbAct assign
 label = "Compile"
 height-pixels = 20
 frame = frame fAct:handle
 sensitive = true
 triggers:
   on choose do:
     apply "ENTRY":U to hbAct.
     apply "GO":U to frame fAct.
     return no-apply.
   end. /* on choose */
 end triggers.

define frame fFileSpecs
 cInDir     at row 1 col 15 colon-aligned help "DblClick to browse"
 cOutDir    at row 2 col 15 colon-aligned help "DblClick to browse"
 cLstDir    at row 3 col 15 colon-aligned help "DblClick to browse"
 with no-box side-labels at row 3 column 1 size {&WINDOW-WIDTH} by 3.

define frame fCompileSpecs
 lSaveRCode
 lPP
 lListing
 lXref
 lDebugList
 with no-box side-labels at row 6 column 1 size {&WINDOW-WIDTH} by 2.

define variable indentl as logical
 label "Indent Lines"
 view-as toggle-box
 no-undo.

define variable expkeys as logical
 label "Expand Keywords"
 view-as toggle-box
 no-undo.

define variable capkeys as logical
 label "Capitalize Keywords"
 view-as toggle-box
 no-undo.

define variable indent as integer initial 2
 label "Spaces per indent"
 view-as fill-in
 no-undo.

define variable omax as integer initial 126
 label "Output line max length"
 view-as fill-in
 no-undo.

define frame fReformatSpecs
 indentl
 expkeys
 capkeys
 skip
 indent
 omax
 with no-box side-labels at row 6 column 1 size {&WINDOW-WIDTH} by 3.

on value-changed of cMode in frame fMode do:
 run putSetParameters.
 assign cMode.
 put-key-value section "ProProc" key "Mode" value cMode.
 if cMode eq "Compile":U then do:
   hide frame fReformatSpecs no-pause.
   view frame fCompileSpecs in window {&WINDOW-NAME}.
 end. /* cMode eq "Compile":U */
 if cMode eq "Reformat":U then do:
   hide frame fCompileSpecs no-pause.
   view frame fReformatSpecs in window {&WINDOW-NAME}.
 end. /* cMode eq "Reformat":U */
 run getSetParameters.
 assign
   cStatus = cKeySet
   hbAct:label = cMode
   .
 display cStatus with frame fMode in window {&WINDOW-NAME}.
 case cMode:
   when "Compile":U then enable all with frame fCompileSpecs in window {&WINDOW-NAME}.
   when "Reformat":U then enable all with frame fReformatSpecs in window {&WINDOW-NAME}.
 end case. /* cMode */
end.

on "TAB":U of cMode in frame fMode do:
 apply "ENTRY":U to cInDir in frame fFileSpecs.
 return no-apply.
end.

define frame fKeySetFI
 cKeySet format "x(10)" help "New Compile Set Parameter name"
 with size 16 by 3 no-labels.

define frame fKeySet
 cKeySet format "x(10)" view-as selection-list scrollbar-vertical size 16 by 20
 with no-labels.
define variable hKeySet as handle no-undo.
assign hKeySet = cKeySet:handle.

on mouse-select-dblclick of cKeySet in frame fKeySet do:
 apply "RETURN":U to cKeySet in frame fKeySet.
 return no-apply.
end.

on choose of bChgKeySet in frame fMode do:
 define variable lRunCKSagain as logical initial true no-undo.
 do while lRunCKSagain:
   run ChangeKeySet (input-output lRunCKSagain).
 end. /* while lRunCKSagain */
end. /* choose of bChgKeySet */

procedure ChangeKeySet:
 define input-output parameter lRunCKSagain as logical no-undo.
 assign lRunCKSagain = false.
 define variable cKeyNames as character no-undo.
 define variable cKeySetNames as character no-undo.
 run putSetParameters.
 assign cKeySetNames = "New".
 get-key-value section "ProProc" key "" value cKeyNames.
 empty temp-table tKeySetNames.
 do iWork = 1 to num-entries(cKeyNames):
   if entry(iWork,cKeyNames) begins cMode + "Set":U + "_"
   then do:
     create tKeySetNames.
     assign tKeySetNames.KeySetName = substring(entry(iWork,cKeyNames),length(cMode)+ 5).
   end. /* entry(iWork,cKeyNames) begins cMode + "Set":U + "_" */
 end. /* do */ /* iWork = 1 to num-entries(cKeySetNames) */
 for each tKeySetNames:
   if tKeySetNames.KeySetName gt ''
   then assign cKeySetNames = cKeySetNames + "," + tKeySetNames.KeySetName.
 end. /* each tKeySetNames */
 assign
   cKeySetNames = trim(cKeySetNames)
   hKeySet:list-items = cKeySetNames
   .
 update cKeySet
   go-on("RETURN":U,"DELETE":U)
   with frame fKeySet
   view-as dialog-box
   title "Compile Set"
   in window {&WINDOW-NAME}
   .
 hide frame fKeySet no-pause in window {&WINDOW-NAME}.
 hide frame fKeySetNames no-pause in window {&WINDOW-NAME}.
 if cKeySet eq "New":U then do:
   assign cKeySet = "".
   update cKeySet
     with frame fKeySetFI
     view-as dialog-box
     title "New Name"
     in window {&WINDOW-NAME}
     .
   assign cKeySet = caps(cKeySet).
 end. /* cKeySet eq "New":U */
 else if keylabel(lastkey) eq "DEL":U then do:
   put-key-value section "ProProc" key cMode + "Set" + "_" + cKeySet value ? no-error.
   assign cKeySet = "".
   put-key-value section "ProProc" key cMode + "SetSelected" value "".
   assign lRunCKSagain = true.
 end. /* keylabel(lastkey) eq "DEL":U */
 assign cStatus = cKeySet.
 display cStatus with frame fMode in window {&WINDOW-NAME}.
 put-key-value section "ProProc" key cMode + "SetSelected" value cKeySet.
 run getSetParameters.
end procedure. /* ChangeKeySet */

on mouse-select-dblclick of cInDir in frame fFileSpecs do:
 &if integer(entry(1,proversion,'.')) lt 10
 &then
 system-dialog get-file cInDir title "Input directory".
 &else
 system-dialog get-dir cInDir title "Input directory".
 &endif
 display cInDir with frame fFileSpecs in window {&WINDOW-NAME}.
end.

on mouse-select-dblclick of cOutDir in frame fFileSpecs do:
 &if integer(entry(1,proversion,'.')) lt 10
 &then
 system-dialog get-file cOutDir initial-dir cInDir title "Output directory".
 &else
 system-dialog get-dir cOutDir initial-dir cInDir title "Output directory".
 &endif
 display cOutDir with frame fFileSpecs in window {&WINDOW-NAME}.
end.

on mouse-select-dblclick of cLstDir in frame fFileSpecs do:
 &if integer(entry(1,proversion,'.')) lt 10
 &then
 system-dialog get-file cLstDir initial-dir cInDir title "List directory".
 &else
 system-dialog get-dir cLstDir initial-dir cInDir title "List directory".
 &endif
 display cLstDir with frame fFileSpecs in window {&WINDOW-NAME}.
end.

on go of frame fMode do:
 apply "CHOOSE":U to hbAct.
 return no-apply.
end.

on go of frame fAct do:
 disable
   lSkipDSM
   cOneMod
   with frame fAct.
 disable all with frame fFileSpecs.
 disable all with frame fMode.
 run putSetParameters.
 case hbAct:label:
   when "Cancel":U then do:
     assign
       lCancel = true
       hbAct:label = cMode
       .
     enable all with frame fAct in window {&WINDOW-NAME}.
     enable all with frame fFileSpecs in window {&WINDOW-NAME}.
   end. /* "Cancel":U */
   otherwise do:
     assign
       lCancel = false
       hbAct:label = "Cancel":U
       .
   end.
 end case. /* hbAct:label */
 run ProcessFiles.
 enable all with frame fFileSpecs in window {&WINDOW-NAME}.
 display
   cKeySet @ cStatus
   with frame fMode in window {&WINDOW-NAME}.
 enable
   cMode
   bChgKeySet
   with frame fMode in window {&WINDOW-NAME}.
 assign
   hbAct:label = cMode
   .
 enable all with frame fAct in window {&WINDOW-NAME}.
 enable all with frame fFileSpecs in window {&WINDOW-NAME}.
 apply "ENTRY":U to hbAct.
end.

create widget-pool.

CREATE WINDOW {&WINDOW-NAME} ASSIGN
 HIDDEN                 = YES
 TITLE                  = "Process Progress Code"
 COLUMNS                = 1
 ROW                    = 1
 HEIGHT-CHARS           = 7
 WIDTH-CHARS            = 76
 MAX-HEIGHT-CHARS       = 8
 MAX-WIDTH-CHARS        = 320
 VIRTUAL-HEIGHT-CHARS   = 8
 VIRTUAL-WIDTH-CHARS    = 320
 RESIZE                 = no
 SCROLL-BARS            = no
 STATUS-AREA            = yes
 BGCOLOR                = ?
 FGCOLOR                = ?
 MESSAGE-AREA           = no
 THREE-D                = no
 SENSITIVE              = yes
 .
get-key-value section "ProProc" key "Mode" value cMode.
if cMode eq ? then assign cMode = "Compile":U.
run getSetParameters.
assign
 cStatus = cKeySet
 hbAct:label = cMode
 .
display
 cStatus
 cMode with frame fMode in window {&WINDOW-NAME}.
enable
 cMode
 bChgKeySet
 with frame fMode in window {&WINDOW-NAME}.
enable all with frame fAct in window {&WINDOW-NAME}.
enable all with frame fFileSpecs in window {&WINDOW-NAME}.
case cMode:
 when "Compile":U then enable all with frame fCompileSpecs in window {&WINDOW-NAME}.
 when "Reformat":U then enable all with frame fReformatSpecs in window {&WINDOW-NAME}.
end case. /* cMode */
view {&WINDOW-NAME}.
wait-for window-close of {&WINDOW-NAME} focus cMode.
run putSetParameters.
delete widget {&WINDOW-NAME}.
return.

/*===============================================================================*/
procedure getSetParameters:
 get-key-value section "ProProc" key cMode + "SetSelected" value cKeySet.
 if cKeySet ne ?
 then get-key-value section "ProProc" key cMode + "Set" + "_" + cKeySet value cKeyValues.
 else assign cKeyValues = ?.
 if cKeyValues eq ?
 then return.
 assign
   cInDir          = entry(1,cKeyValues,chr(31))
   cOutDir         = entry(2,cKeyValues,chr(31))
   cLstDir         = entry(3,cKeyValues,chr(31))
   .
 assign
   lSkipDSM        = logical(entry(4,cKeyValues,chr(31)),"1/0")
   cOneMod         = entry(5,cKeyValues,chr(31))
   .
 assign
   cSetOptions = entry(6,cKeyValues,chr(31))
   .
 if cMode eq "Compile":U
 then assign
   lSaveRCode      = logical(substring(cSetOptions,1,1),"1/0")
   lPP             = logical(substring(cSetOptions,2,1),"1/0")
   lListing        = logical(substring(cSetOptions,3,1),"1/0")
   lXref           = logical(substring(cSetOptions,4,1),"1/0")
   lDebugList      = logical(substring(cSetOptions,5,1),"1/0")
   .
 else if cMode eq "Reformat":U
 then assign
   indentl = logical(substring(cSetOptions,1,1),"1/0")
   expkeys = logical(substring(cSetOptions,2,1),"1/0")
   capkeys = logical(substring(cSetOptions,3,1),"1/0")
   indent  = integer(entry(7,cKeyValues,chr(31)))
   omax    = integer(entry(8,cKeyValues,chr(31)))
   .
 display
   cInDir
   cOutDir
   cLstDir
   with frame fFileSpecs in window {&WINDOW-NAME}.
 display
   lSkipDSM
   cOneMod
   with frame fAct in window {&WINDOW-NAME}.
 if cMode eq "Compile":U
 then display
   lSaveRCode
   lPP
   lListing
   lXref
   lDebugList
   with frame fCompileSpecs in window {&WINDOW-NAME}.
 else if cMode eq "Reformat":U
 then display
   indentl
   expkeys
   capkeys
   indent
   omax
   with frame fReformatSpecs in window {&WINDOW-NAME}.
end procedure. /* getSetParameters */

procedure putSetParameters:
 assign frame fFileSpecs
   cInDir
   cOutDir
   cLstDir
   .
 if cMode eq "Compile":U then do:
   assign frame fCompileSpecs
     lSaveRCode
     lPP
     lListing
     lXref
     lDebugList
     .
   assign
     cSetOptions
       = (if lSaveRCode then '1' else '0')
       + (if lPP        then '1' else '0')
       + (if lListing   then '1' else '0')
       + (if lXref      then '1' else '0')
       + (if lDebugList then '1' else '0')
     .
 end. /* cMode eq "Compile":U */
 else if cMode eq "Reformat":U then do:
   assign frame fReformatSpecs
     indentl
     expkeys
     capkeys
     indent
     omax
     .
   assign
     cSetOptions
       = (if indentl    then '1' else '0')
       + (if expkeys    then '1' else '0')
       + (if capkeys    then '1' else '0')
       + chr(31) + string(indent)
       + chr(31) + string(omax)
     .
 end. /* cMode eq "Reformat":U */
 assign frame fAct
   lSkipDSM
   cOneMod
   .
 assign
   cKeyValues
     = cInDir + chr(31) + cOutDir + chr(31) + cLstDir + chr(31) + (if lSkipDSM then '1' else '0')
     + chr(31) + cOneMod + chr(31) + cSetOptions
   .
 put-key-value section "ProProc" key cMode + "Set" + "_" + cKeySet value cKeyValues no-error.
end procedure. /* putSetParameters */

function DateString returns character (input dDate as date, cFormat as character):
 define variable cDateString as character no-undo.
 define variable cHoldFormat as character no-undo.
 assign
   cHoldFormat = session:date-format
   cFormat = "ymd" when lookup(cFormat,"ymd,ydm,mdy,myd,dmy,dym") eq 0
   session:date-format = cFormat
   cDateString = string(dDate,"99999999")
   session:date-format = cHoldFormat
   .
 return cDateString.
end function. /* DateString */

procedure ProcessFiles:
 if cOneMod gt "" then do:
   define variable cSavePropath as character no-undo.
   assign
     cSavePropath = propath
     propath = propath + "," + cInDir
     .
   assign
     cProgPath = search(cOneMod)
     propath = cSavePropath
     .
   if cProgPath eq ? then return.
   assign cProgBase = substring(cProgPath,(r-index(cProgPath,cPathSep) + 1)).
   run SetProgRootExt.
   run ProcessOneFile (cProgBase).
   return.
 end. /* cOneMod gt "" */
 input stream sLine from os-dir(cInDir).
 FileLoop:
 do while not lCancel on error undo,leave:
   import stream sLine cProgBase cProgPath cProgAttr.
   if not substring(cProgAttr,1,1) eq "F" then next.
   assign cWork = entry(num-entries(cProgBase,"."),cProgBase,".").
   if not lookup(cWork,"f,i,ii,iii,p,pp,set,t,tt,tpl,trn,w":U) gt 0
   then next FileLoop.
   run SetProgRootExt.
   do iWork = 1 to num-entries(cProgRoot,"."):
     assign cWork = entry(iWork,cProgRoot,".").
     if length(cWork) ge 6 then do:
       assign eWork = decimal(cWork) no-error.
       if not error-status:error
       then assign lDSM = true.
     end. /* length(cWork) ge 6 */
   end. /* do */
   if lDSM and lSkipDSM then next FileLoop.
   run ProcessOneFile (cProgBase).
   process events.
 end. /* do */ /* while not lCancel */
 assign lCancel = false.
 input stream sLine close.
end procedure. /* ProcessFiles */

procedure ProcessOneFile:
 define input parameter cProgBase as character no-undo.
 define variable cProgName as character no-undo.
 assign cProgName = entry(num-entries(cProgBase,".") - 1,cProgBase,".").
 display cProgName @ cStatus
   with frame fMode in window {&WINDOW-NAME}.
 if cMode eq "Compile":U then run CompileFile.
 else if cMode eq "Reformat":U then run ReformatFile.
end. /* ProcessOneFile */

procedure SetProgRootExt:
 assign
   cProgRoot = if (length(cProgBase) - r-index(cProgBase,".")) ge 1
               then substring(cProgBase,1,(r-index(cProgBase,".") - 1))
               else cProgBase
   cProgExt = if r-index(cProgBase,".") gt 0 and (length(cProgBase) - r-index(cProgBase,".")) ge 1
              then substring(cProgBase,r-index(cProgBase,".") + 1)
              else ""
   lDSM = false
   .
end procedure. /* SetProgRootExt */

procedure CompileFile:
 assign
   current-language = current-language /* Clear old objects from cache. */
   cTimeStamp = DateString(today,"ymd") + replace(string(TIME,"hh:mm:ss"),":","")
   .
 case substring(cSetOptions,2): /* Character string of '1' or '0' values for each of: lPP lListing lXref lDebugList */
   when '1111' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '1111' */
   when '1110' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       .
   end. /* '1110' */
   when '1101' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '1101' */
   when '1100' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       .
   end. /* '1100' */
   when '1011' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '1011' */
   when '1010' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       .
   end. /* '1010' */
   when '1001' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '1001' */
   when '1000' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       preprocess value(cOutDir + "/" + cProgRoot + ".pre")
       .
   end. /* '1000' */
   when '0111' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '0111' */
   when '0110' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       .
   end. /* '0110' */
   when '0101' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '0101' */
   when '0100' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       listing value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".lst")
       .
   end. /* '0100' */
   when '0011' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '0011' */
   when '0010' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       xref value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".xrf")
       .
   end. /* '0010' */
   when '0001' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       debug-list value(cLstDir + "/" + cProgRoot + "." + cTimeStamp + ".dbg")
       .
   end. /* '0001' */
   when '0000' then do:
     compile value(cProgPath) no-error
       save = (lSaveRCode and not lDSM) into value(cOutDir)
       .
   end. /* '0000' */
 end case. /* substring(cSetOptions,2) */
 if compiler:error
 then do:
   output to value(cOutDir + "/" + cProgRoot + ".err").
   put unformatted substitute("File &1 Line &2 Column &3",compiler:filename,compiler:error-row,compiler:error-col) skip.
   do iWork = 1 to error-status:num-messages:
     put unformatted substitute("&1 &2",error-status:get-number(iWork),error-status:get-message(iWork)) skip.
   end.
   output close.
 end.
end procedure. /* CompileFile */

/*========================================================================================================================*/

&global-define GENERIC_WRITE 1073741824   /* &H40000000 */
&global-define CREATE_NEW 1
&global-define CREATE_ALWAYS 2
&global-define OPEN_EXISTING 3
&global-define OPEN_ALWAYS 4
&global-define FILE_SHARE_READ 1          /* = &H1 */
&global-define FILE_ATTRIBUTE_NORMAL 128  /* = &H80 */

procedure CreateFileA external "kernel32":
   define input parameter lpFileName as character.
   define input parameter dwDesiredAccess as long.
   define input parameter dwShareMode as long.
   define input parameter lpSecurityAttributes as long.
   define input parameter dwCreationDisposition as long.
   define input parameter dwFlagsAndAttributes as long.
   define input parameter hTemplateFile as long.
   define return parameter ReturnValue as long.
end procedure. /* CreateFileA */

procedure CloseHandle external "kernel32" :
 define input  parameter hObject     as long.
 define return parameter ReturnValue as long.
end procedure. /* CloseHandle */

procedure GetFileTime external "kernel32" :
 define input  parameter hObject              as long.
 define output parameter lpCreationTime       as memptr.
 define output parameter lpLastAccessTime     as memptr.
 define output parameter lpLastWriteTime      as memptr.
 /*define return parameter ReturnValue          as long.*/
end procedure. /* GetFileTime */

procedure SetFileTime external "kernel32" :
 define input  parameter hObject              as long.
 define input  parameter lpCreationTime       as memptr.
 define input  parameter lpLastAccessTime     as memptr.
 define input  parameter lpLastWriteTime      as memptr.
 define return parameter ReturnValue          as long.
end procedure. /* SetFileTime */

function outline returns logical (input bumplength as integer):
 if diagnostic and bumplength ne omax then return true.
 if length(oline) + bumplength gt omax
 then do:
   assign oline = right-trim(oline).
   if (ifblock[blevel] and ifthenelse eq "IF":U and lookup(firstkwordl,"ELSE,IF":U) eq 0)
     or ((lookup(firstkwords,"IF,ELSE":U) gt 0 and lookup(firstkwordl,"IF,THEN,ELSE":U) eq 0)
          and lookup(word[blevel],bwlistes) eq 0)
   then assign oline = fill(" ",indent) + oline.
   put unformatted oline skip(if length(oline) gt 0 then 0 else 1).
   if not diagnostic then assign
     oline = if clevel eq 0
             then (fill(" ",spaces[blevel]) + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else ""))
             else ""
     .
   else assign
     oline = fill(" ",length(pline) - length(left-trim(pline)))
     .
 end. /* length(oline) + bumplength ge omax */
end function. /* outline */

function putout returns logical (input specifiedtext as character):
/*
Append specified text to output line, or if no text specified then append text between previous and current parse locations.
Then bump previous parse location to current parse location.
*/
 define variable addtext as character no-undo.
 assign
   addtext
     = if length(specifiedtext) eq 0
       then if (nploc - ploc) gt 0
            then substring(pline,ploc,(nploc - ploc))
            else ''
       else specifiedtext
   ploc = nploc
   .
 outline(length(addtext)). /* output line if length with additional text would exceed maximum */
 assign
   oline = oline + addtext
   .
end function. /* putout */

function putkey returns logical:
 if expkeys then do:
   if capkeys or compare(pword,"eq":U,caps(pword),"case-sensitive")
   then putout(kword).
   else putout(lc(kword)).
   if substring(pword,length(pword)) eq " " then putout(' ').
 end. /* expkeys */
 else putout('').
end function. /* putkey */

procedure ReformatFile:
 assign
   oline = ""
   clevel = 0
   pplevel = 0
   plevel = 0
   ielevel = 0
   blevel = 1
   firstkwords = ""
   isfirstkwords = false
   .

 define variable iReturn as integer no-undo.
 define variable mCreat   as memptr no-undo.
 define variable mAcces   as memptr no-undo.
 define variable mWrite   as memptr no-undo.

 set-size(mCreat) =  8.
 set-size(mAcces) =  8.
 set-size(mWrite) =  8.

 define variable lpSecurityAtt as integer   no-undo.
 define variable ihObject      as integer   no-undo.
 define variable cOutputFile   as character no-undo.

 /* Get Windows File Handle */
 run CreateFileA (input cProgPath,
                  input {&GENERIC_WRITE},
                  {&FILE_SHARE_READ},
                  lpSecurityAtt,
                  {&OPEN_EXISTING},
                  {&FILE_ATTRIBUTE_NORMAL},
                  0,
                  output ihObject).

 /* Preserve File Time Attributes */
 run GetFileTime (ihObject,
                  output mCreat,
                  output mAcces,
                  output mWrite
                  ).

 /* Release Windows File Handle */
 run CloseHandle (input ihObject,
                  output iReturn).

 assign cWork = cOutDir + "/" + cProgBase.
 if cOutDir eq cInDir
 then do:
   assign
     cTimeStamp = DateString(today,"ymd") + replace(string(TIME,"hh:mm:ss"),":","")
     cOutputFile
       = cOutDir + "/" + cProgRoot + ".parsed."
       + ((if cWork eq cProgPath then cTimeStamp + "." else "") + cProgExt)
     .
 end. /* cOutDir eq cInDir */
 else do: /* not (cOutDir eq cInDir) */
   assign cOutputFile =
     if cWork eq cProgPath
     then (cOutDir + "/" + cProgRoot + ".parsed." + cTimeStamp + "." + cProgExt)
     else cWork
     .
 end. /* not (cOutDir eq cInDir) */
 input from value(cProgPath).
 output to value(cOutputFile).
 do while true on error undo,leave on endkey undo,leave:
   import unformatted pline.
   if indentl and clevel eq 0 then assign pline = left-trim(pline).
   assign
     ploc = 1
     nwloc = ploc
     firstkwordl = ""
     isfirstkwordl = false
     .
   if pline eq "" then outline(omax). /* force output */
   else do:
     assign
       pline = pline + " " /* Enable detection of keyword at the end of the line. */
       lenline = length(pline)
       .
     run parseline.
   end.
 end.
 input close.
 output close.

 /* Lock file against writing / get Windows File Handle */
 run CreateFileA (input cOutputFile,
                  input {&GENERIC_WRITE},
                  {&FILE_SHARE_READ},
                  lpSecurityAtt,
                  {&OPEN_ALWAYS},
                  {&FILE_ATTRIBUTE_NORMAL},
                  0,
                  OUTPUT ihObject).

 /* Apply preserved File Time Attributes */
 RUN SetFileTime (ihObject,
                  mCreat,
                  mAcces,
                  mWrite,
                  output iReturn
                  ).

 /* Release Windows File Handle */
 run CloseHandle (input ihObject,
                  output iReturn).

 /* Release memory. */
 SET-SIZE(mCreat) =  0.
 SET-SIZE(mAcces) =  0.
 SET-SIZE(mWrite) =  0.

end procedure. /* ReformatFile */

procedure parseline:
 do while ploc le lenline:
   if ploc eq nwloc
   then do:
     assign
       locsp = if index(pline," ",ploc) eq 0 then lenline else index(pline," ",ploc)
       loclp = if index(pline,"(",ploc) eq 0 then lenline else index(pline,"(",ploc)
       locrp = if index(pline,")",ploc) eq 0 then lenline else index(pline,")",ploc)
       nploc = minimum(locsp,loclp,locrp) + 1
       pword = substring(pline,ploc,nploc - ploc)
       pchar = substring(pword,1,1)
       nwloc = nploc
       .
     if clevel eq 0 and qchar eq "" then do:
       if length(pword) ge 3 then do:
         if (substring(pword,length(pword) - 1,2) eq '. '
           or substring(pword,length(pword) - 1,2) eq ': '
            ) /* word followed by '.' or ':' */
         then assign
           pword = right-trim(pword,".: ")
           nploc = nploc - 2
           nwloc = nploc
           .
       end. /* length(pword) ge 3 */
       if length(pword) ge 2 and lookup(substring(pword,length(pword),1),"(,)") gt 0
       then assign
         pword = right-trim(pword,"()")
         nploc = nploc - 1
         .
       assign cWork = keyword-all(pword).
       if word[blevel] eq "DEFINE":U and kword eq "AS":U then do:
         if lookup(trim(pword),"i,in,int,inte,integ":U) gt 0
         then assign cWork = "INTEGER":U.
         if lookup(trim(pword),"c,ch,cha":U) gt 0
         then assign cWork = "CHARACTER":U.
         if lookup(trim(pword),"de":U) gt 0
         then assign cWork = "DECIMAL":U.
         if lookup(trim(pword),"da,dat":U) gt 0
         then assign cWork = "DATE":U.
         if lookup(trim(pword),"l,lo,log,logi,logic":U) gt 0
         then assign cWork = "LOGICAL":U.
       end. /* word[blevel] eq "DEFINE":U and kword eq "AS":U */
       if cWork ne ?
       then do:
         assign
           pkword = kword
           kword = cWork
           .
         if firstkwords eq "" then assign
           firstkwords = kword
           isfirstkwords = true
           .
         else assign isfirstkwords = false.
         if firstkwordl eq "" then assign
           firstkwordl = kword
           isfirstkwordl = true
           .
         else assign isfirstkwordl = false.
         if isfirstkwords then do:
           if kword eq "=" then do: /* implicit 'assign' */
             assign
               blevel = blevel + 1
               word[blevel] = "ASSIGN":U
               pkword = word[blevel]
               .
           end. /* kword eq "=" */
           if ifblock[blevel] then do:
             if kword ne "ELSE":U
             then assign
               blevel = blevel - 1
               oline
                 = (fill(" ",spaces[blevel])
                 + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else ""))
                 + trim(oline)
               .
           end. /* ifblock[blevel] */
         end. /* isfirstkwords */
         if isfirstkwords and kword eq "FORMAT":U
         then assign kword = "FORM":U. /* Reverse unwanted keyword-all transformation. */
         if lookup(kword,bwlisteb) gt 0
         then do:
           if not (not isfirstkwords and lookup(kword,bwlistk1) gt 0)
           then assign
             blevel = blevel + 1
             ifblock[blevel] = false
             spaces[blevel] = spaces[blevel - 1]
                            + (if isfirstkwords or (not isfirstkwords and lookup(firstkwords,bwlisteb) eq 0)
                               then indent else 0)
             word[blevel] = kword
             .
         end. /* lookup(kword,bwlisteb) gt 0 */
         if kword eq "=" and isfirstkwordl and plevel eq 0 and lookup(word[blevel],bwlistes) gt 0
           and ielevel gt 0 and ifthenelse eq "ELSE":U
         then do:
           assign
             ielevel = ielevel - 1
             oline = fill(" ",spaces[blevel]) + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else "")
               + left-trim(oline)
             .
         end. /* kword eq "=" */
         if kword eq "TRIGGERS":U and pkword ne "END":U then do:
           assign
             word[blevel] = kword /* Replace 'assign' with 'triggers'. */
             spaces[blevel] = spaces[blevel] + indent
             .
         end. /* kword eq "TRIGGERS":U */
         if kword eq "IF":U and (word[blevel] eq "IF":U or (ielevel eq 0 and lookup(pkword,"ELSE,THEN":U) gt 0))
         then do:
           if not lookup(pkword,cwlist) gt 0
           then assign
             blevel = blevel + 1
             word[blevel] = kword
             spaces[blevel] = /*if pkword eq "ELSE":U /* 2bconsidered for option later */
                              then length(oline)
                              else*/ spaces[blevel - 1]
             .
           if isfirstkwords or lookup(pkword,"ELSE,THEN":U) gt 0
           then assign ifblock[blevel] = true.
         end. /* kword eq "IF":U and ... */
         if oline eq "" and lookup(word[blevel],bwlistes) gt 0 and lookup(kword,"=,+":U) gt 0
         then assign oline = oline + fill(" ",indent). /* extra indent */
         if lookup(kword,"IF,THEN,ELSE":U) gt 0 then do:
           if ielevel gt 0 and kword eq "ELSE":U then do:
             if ielevele[ielevel] eq true
             then assign ielevel = ielevel - 1.
             else assign ielevele[ielevel] = true.
           end. /* ielevel gt 0 and kword eq "ELSE":U */
           assign ifthenelse = kword.
           if kword eq "IF":U then do:
             if not isfirstkwords and pkword ne "ELSE":U
             then assign
               ielevel = ielevel + 1
               ielevele[ielevel] = false
               ielevelp[ielevel] = plevel
               ieindent[ielevel] = length(oline) - spaces[blevel]
               .
           end. /* not isfirstkwords and pkword ne "ELSE":U */

/*may not be needed - 2bdetermined*/

           else
           if isfirstkwordl and not isfirstkwords then do:
             if kword eq "ELSE":U
             then assign oline
               = (fill(" ",spaces[blevel]) + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else "")) + trim(oline).
           end. /* isfirstkwordl and not isfirstkwords */


         end. /* lookup(kword,"IF,THEN,ELSE":U) gt 0 */
         else if isfirstkwords and ifblock[blevel] and kword ne "ELSE":U then do:
           assign blevel = blevel - 1.
           if ifblock[blevel] then assign blevel = blevel - 1.
           assign oline
             = (fill(" ",spaces[blevel]) + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else "")) + trim(oline).
         end. /* isfirstkwords and ifblock[blevel] and kword ne "ELSE":U */
         if kword eq "END":U then do:
           if ifblock[blevel] then assign blevel = blevel - 1.
           if blevel gt 1 then assign blevel = blevel - 1.
           if word[blevel + 1] ne "TRIGGERS":U
           then assign
             oline = fill(" ",spaces[blevel]) + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else "")
               + left-trim(oline)
               .
         end. /* if kword eq "END":U */
         putkey().
       end. /* cWork ne ? */
       if (pword eq ". " or pword eq ": ") then do:
         if plevel eq 0 and lookup(word[blevel],bwlistes) gt 0
           and ielevel gt 0 and ifthenelse eq "ELSE":U
         then do:
           assign
             ielevel = ielevel - 1
             oline = fill(" ",spaces[blevel]) + (if ielevel gt 0 then fill(" ",ieindent[ielevel]) else "")
               + left-trim(oline)
             .
         end. /* plevel eq 0 ... */
         if blevel gt 1 then do:
           if lookup(word[blevel],bwlistes + ",FUNCTION,IF":U) gt 0
           then do:
             if pkword eq "FORWARDS":U then do:
               assign blevel = blevel - 1.
             end. /* pkword eq "FORWARDS":U */
             else do: /* not (pkword eq "FORWARDS":U) */
               if ifblock[blevel] then do:
                 if not lookup(firstkwords,"ELSE,END":U) gt 0
                 then assign blevel = blevel - 1.
               end. /* ifblock[blevel] */
               else assign blevel = blevel - 1.
             end. /* not (pkword eq "FORWARDS":U) */
           end. /* lookup(word[blevel],bwlistes + "FUNCTION,IF":U) gt 0 */ /* do */
         end. /* blevel gt 1 */
         if ielevel gt 0 and ifthenelse eq "ELSE":U
         then assign ielevel = ielevel - 1.
         assign firstkwords = ''.
       end. /* (pword eq ". " or pword eq ": ") */
       if pchar eq "&" then do:
         if firstkwords eq ""
         then assign firstkwords = pchar.
       end. /* pchar eq "&" */
     end. /* clevel eq 0 and qchar eq "" */
   end. /* ploc eq nwloc */
   else do: /* not (ploc eq nwloc) */
     assign
       nploc = ploc + 1
       pword = substring(pline,ploc,nploc - ploc)
       .
     if index(trigchars,pword) gt 0 then do:
       assign
         cpair = substring(pline,ploc,2)
         pchar = substring(pline,ploc,1)
         .
       case pchar:
         when "(" then do:
           if qchar eq "" and clevel eq 0 then do:
             assign plevel = plevel + 1.
           end. /* qchar eq "" and clevel eq 0 */
         end. /* "(" */
         when ")" then do:
           if qchar eq "" and clevel eq 0 then do:
             assign plevel = plevel - 1.
             if ielevel gt 0 and plevel lt ielevelp[ielevel]
             then assign ielevel = ielevel - 1.
           end. /* qchar eq "" and clevel eq 0 */
         end. /* ")" */
         otherwise do:
           case cpair:
             when cs then do:
               assign clevel = clevel + 1.
               if oline eq "" then assign oline = "".
             end. /* cs */
             when ce then assign clevel = clevel - 1.
           end case. /* cpair */
           if (cpair eq cs or cpair eq ce)
           then assign nploc = ploc + 2.
           else assign nploc = ploc + 1.
           if qchar gt '' then do:
             if pchar eq qchar then assign qchar = ''.
           end. /* qchar gt '' */
           else if clevel eq 0 then assign qchar = if can-do("'" + "," + '"',pchar) then pchar else ''.
         end. /* otherwise */ /* do */
       end case. /* pchar */
     end. /* index(trigchars,pword) gt 0 */
     if (length(oline) + (nwloc - ploc) ge omax) and firstkwords ne "&" then outline(omax).
     putout('').
   end. /* not (ploc eq nwloc) */
   if clevel eq 0 and qchar eq ""
     and pword eq "." and substring(pline,ploc,1) eq " "
     and lookup(word[blevel],bwlistes) gt 0 and word[blevel] ne "IF":U
   then assign blevel = blevel - 1.
 end. /* do */ /* while ploc le lenline */
 outline(omax). /* force output */
 if firstkwords eq "&" then assign firstkwords = "".
end procedure. /* parseline */
