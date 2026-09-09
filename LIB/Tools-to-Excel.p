&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Sintaxis:

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
/*
rutinas para cargar la información ...
*/

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').


Fin de Sintaxis */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fi-fieldstring) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fi-fieldstring Procedure 
FUNCTION fi-fieldstring RETURNS CHARACTER
  ( p-field as handle)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-browser-to-excel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browser-to-excel Procedure 
PROCEDURE browser-to-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input parameter p-browse as handle no-undo.

   def var h-excel as com-handle no-undo.
   def var h-book as com-handle no-undo.
   def var h-sheet as com-handle no-undo.
   def var v-item as char no-undo.
   def var v-alpha as char extent 26 no-undo init ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","x","y","Z"].
   def var i as int no-undo.
   def var v-line as int no-undo.
   def var v-qu as log no-undo.
   def var v-handle as handle no-undo.
   v-qu = session:set-wait-state("General").
   CREATE "Excel.Application" h-Excel.
   h-book = h-Excel:Workbooks:Add().
   h-Sheet = h-Excel:Sheets:Item(1).
   
   do i = 1 to p-browse:num-columns:
      v-handle = p-browse:get-browse-column(i).
      v-item = v-alpha[i] + "1".
      h-sheet:range(v-item):value = v-handle:label.
   end.
   v-line = 1.
   repeat:
      if v-line = 1 then 
         v-qu = p-browse:select-row(1).
      else v-qu = p-browse:select-next-row().
      if v-qu = no then leave.
      v-line = v-line + 1.
      do i = 1 to p-browse:num-columns:
         v-handle = p-browse:get-browse-column(i).
         v-item = v-alpha[i] + string(v-line).
         if v-handle:data-type begins "dec" then assign
            h-sheet:range(v-item):value = dec(v-handle:screen-value)
            h-sheet:range(v-item):Numberformat = "###.###.##0,00"
            h-sheet:range(v-item):HorizontalAlignment = -4152.
         else if v-handle:data-type begins "int" then assign
            h-sheet:range(v-item):value = int(v-handle:screen-value)
            h-sheet:range(v-item):Numberformat = "###.###.##0"
            h-sheet:range(v-item):HorizontalAlignment = -4152.
         else h-sheet:range(v-item):value = v-handle:screen-value.

      end.
   end.
   do i = 1 to p-browse:num-columns:
      v-qu = h-sheet:Columns(i):AutoFit.
   end.
   h-excel:visible = yes.
   release object h-sheet no-error.
   release object h-book no-error.
   release object h-excel no-error.
   v-qu = session:set-wait-state("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pGeneraExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pGeneraExcel Procedure 
PROCEDURE pGeneraExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 

/*------------------------------------------------------------------------------
  Purpose: Generar Archivo Excel a partir de una TEMP-TABLE o CSV    
  Parameters:  INPUT PARAMETER pihTT             AS HANDLE
               INPUT PARAMETER picProperties     AS CHARACTER                
  Notes:      
------------------------------------------------------------------------------*/

    /* inclucion de constantes de excel*/
    {lib/libConstExcel.i}

    /*--- definicion de parametros ---*/
    DEFINE INPUT PARAMETER pihTT             AS HANDLE                    NO-UNDO.
    DEFINE INPUT PARAMETER picProperties     AS CHARACTER                 NO-UNDO.
  
    /*--- definicion de varibles para invocacion de excel ---*/
    DEFINE VARIABLE chExcelApplication  AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkBook          AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkSheet         AS COM-HANDLE NO-UNDO.
  
    /*--- definicion de variable para la generacion del archivo ---*/
    DEFINE VARIABLE cUniqueFile     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cRuta           AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cArchivo        AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cExtension      AS CHARACTER        NO-UNDO.
  
    /*--- local variable definitions ---*/
    DEFINE VARIABLE picExcelFileName  AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE cColList        AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cRange          AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cRow            AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cPropEntry      AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cPropName       AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cPropValue      AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cFontName       AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE hQueryTT        AS HANDLE            NO-UNDO.
    DEFINE VARIABLE iRow            AS INTEGER           NO-UNDO.
    DEFINE VARIABLE iCol            AS INTEGER           NO-UNDO.
    DEFINE VARIABLE iPropNo         AS INTEGER           NO-UNDO.
    DEFINE VARIABLE iPos            AS INTEGER           NO-UNDO.
    DEFINE VARIABLE iFontSize       AS INTEGER           NO-UNDO.
    DEFINE VARIABLE vRow            AS INTEGER INITIAL 4 NO-UNDO.
    DEFINE VARIABLE cHeaderTitle     AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE cReportTitle    AS CHARACTER         NO-UNDO.
     
    /*--- Validaciones ---*/
    IF NOT VALID-HANDLE(pihTT) THEN
        RETURN.
    /*--- validacion de App Excel ---*/
    CREATE "Excel.Application" chExcelApplication NO-ERROR.
    IF NOT VALID-HANDLE(chExcelApplication) THEN
        RETURN.
  
    /*--- creamos el nuevo libro de trabajo ---*/
    chWorkBook = chExcelApplication:Workbooks:ADD().
    chWorkSheet = chWorkBook:Worksheets(1).
  
  
     /*--- determinamos la version de excel para guardar archivo generado
           en el formato correcto ---*/
    IF INTEGER (chExcelApplication:Version) < 12 THEN
        cExtension = ".xls".
    ELSE
        cExtension = ".xlsx".  
  
    /*--- creamos identificador unico para archivo excel ---*/
    ASSIGN cUniqueFile = replace(STRING(TODAY, "99/99/9999"),"/","") + STRING(TIME).
  
    /*--- genera propiedade del archivo excel ---*/
    DO iPropNo = 1 TO NUM-ENTRIES(picProperties, '|'):
     
        ASSIGN
            cPropEntry = ENTRY(iPropNo, picProperties, '|')
            iPos       = INDEX(cPropEntry, '=')
            cPropName  = SUBSTRING(cPropEntry, 1, iPos - 1)
            cPropValue = IF iPos > 0 THEN SUBSTRING(cPropEntry, iPos + 1) ELSE ''.
     
        CASE cPropName:
            WHEN 'FileName' THEN ASSIGN picExcelFileName = cPropValue.
            WHEN 'PathSave' THEN ASSIGN cRuta = cPropValue.
            WHEN 'HeaderTitle' THEN ASSIGN cHeaderTitle = cPropValue.
            WHEN 'ReportTitle' THEN ASSIGN cReportTitle = cPropValue.
            WHEN 'Font:Name' THEN ASSIGN cFontName = cPropValue.
            WHEN 'Font:Size' THEN ASSIGN iFontSize = INTEGER(cPropValue) NO-ERROR.
            WHEN 'PageSetup:Orientation' THEN
                chWorkSheet:PageSetup:Orientation = INTEGER(cPropValue) NO-ERROR.
            WHEN 'PageSetup:Zoom' THEN
                chWorkSheet:PageSetup:Zoom = cPropValue.
            WHEN 'PageSetup:PrintGridlines' THEN
                chWorkSheet:PageSetup:PrintGridlines = CAN-DO('YES,TRUE,Y,T',cPropValue).
            WHEN 'PageSetup:PrintTitleRows' THEN
                chWorkSheet:PageSetup:PrintTitleRows = cPropValue.
            WHEN 'PageSetup:PrintTitleColumns' THEN
                chWorkSheet:PageSetup:PrintTitleColumns = cPropValue.
            WHEN 'PageSetup:LeftHeader' THEN
                chWorkSheet:PageSetup:LeftHeader = cPropValue.
            WHEN 'PageSetup:CenterHeader' THEN
                chWorkSheet:PageSetup:CenterHeader = cPropValue.
            WHEN 'PageSetup:RightHeader' THEN
                chWorkSheet:PageSetup:RightHeader = cPropValue.
            WHEN 'PageSetup:LeftFooter' THEN
                chWorkSheet:PageSetup:LeftFooter = cPropValue.
            WHEN 'PageSetup:CenterFooter' THEN
                chWorkSheet:PageSetup:CenterFooter = cPropValue.
            WHEN 'PageSetup:RightFooter' THEN
                chWorkSheet:PageSetup:RightFooter = cPropValue.
            WHEN 'PageSetup:CenterHorizontally' THEN
                chWorkSheet:PageSetup:CenterHorizontally = CAN-DO('YES,TRUE,Y,T',cPropValue).
            WHEN 'PageSetup:CenterVertically' THEN
                chWorkSheet:PageSetup:CenterVertically = CAN-DO('YES,TRUE,Y,T',cPropValue).
            WHEN 'PageSetup:FitToPagesWide' THEN
                chWorkSheet:PageSetup:FitToPagesWide = INTEGER(cPropValue) NO-ERROR.
            WHEN 'PageSetup:FitToPagesTall' THEN
                chWorkSheet:PageSetup:FitToPagesTall = INTEGER(cPropValue) NO-ERROR.
            WHEN 'Visible' THEN
                /*--- Mantenemos visible Excel mientras se genera el archivo ---*/
                chExcelApplication:Visible = CAN-DO('YES,TRUE,Y,T',cPropValue).
        END CASE. /* cPropName */
     
    END. /* DO iPropNo = 1 TO NUM-ENTRIES(picProperties): */
     
    /*--- establecemos fuente ---*/
    IF cFontName = '' THEN
    ASSIGN cFontName = "Arial Narrow".
     
     
    /*--- set the column attributes for the Worksheet ---*/
    ASSIGN cColList = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'
                  + ',AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM'
                  + ',AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ'
                  + ',BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM'
                  + ',BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ'
                  + ',CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM'
                  + ',CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ'
                  + ',DA,DB,DC,DD,DE,DF,DG,DH,DI,DJ,DK,DL,DM'
                  + ',DN,DO,DP,DQ,DR,DS,DT,DU,DV,DW,DX,DY,DZ'
                  + ',EA,EB,EC,ED,EE,EF,EG,EH,EI,EJ,EK,EL,EM'
                  + ',EN,EO,EP,EQ,ER,ES,ET,EU,EV,EW,EX,EY,EZ'
                  + ',FA,FB,FC,FD,FE,FF,FG,FH,FI,FJ,FK,FL,FM'
                  + ',FN,FO,FP,FQ,FR,FS,FT,FU,FV,FW,FX,FY,FZ'
                  + ',GA,GB,GC,GD,GE,GF,GG,GH,GI,GJ,GK,GL,GM'
                  + ',GN,GO,GP,GQ,GR,GS,GT,GU,GV,GW,GX,GY,GZ'.    
  
    /*--- validamos nombre de excel---*/
    IF picExcelFileName <> '' THEN DO:
        ASSIGN cArchivo = picExcelFileName.
    END.
    ELSE DO:
        ASSIGN cArchivo = "ReporteGeneraExcel".
    END.
  
    IF cRuta = "" THEN ASSIGN cRuta = SESSION:TEMP-DIR.
        /*ASSIGN cRuta = "C:\tmp\".    */
     
    IF cHeaderTitle <> "" THEN DO:
        chWorkSheet:Range("A1:" + ENTRY(pihTT:NUM-FIELDS,cColList) + "1"):Merge.
        chWorkSheet:Range("A1:" + ENTRY(pihTT:NUM-FIELDS,cColList) + "1"):HorizontalAlignment = 3.
        chWorkSheet:Range("A1"):VALUE = cHeaderTitle.
        chWorkSheet:Range("A1"):FONT:BOLD = TRUE.
        chWorkSheet:Range("A1"):FONT:SIZE = 18.
        chWorkSheet:Range("A1"):FONT:ColorIndex = 55.
    END.
    ELSE DO:
        vRow = vRow - 2.
    END.
     
    IF cReportTitle <> "" THEN DO:
        chWorkSheet:Range("A2:" + ENTRY(pihTT:NUM-FIELDS,cColList) + "2"):Merge.
        chWorkSheet:Range("A2:" + ENTRY(pihTT:NUM-FIELDS,cColList) + "2"):HorizontalAlignment = 3.
        chWorkSheet:Range("A2"):VALUE = cReportTitle.
        chWorkSheet:Range("A2"):FONT:BOLD = TRUE.
        chWorkSheet:Range("A2"):FONT:SIZE = 12.
    END.
    ELSE DO:
        vRow = vRow - 2.
    END.
     
    /*--- Colocamos Panel fijo para titulos y nombre de columnas---*/
    chWorkSheet:Rows(STRING(vRow) + ":" + STRING(vRow)):Font:Bold = TRUE.
    chWorkSheet:Rows(STRING(vRow + 1) + ":" + STRING(vRow + 1)):Activate.
    chExcelApplication:ActiveWindow:FreezePanes = TRUE.
     
    /*--- construimos cabezera de columnas---*/
    DO iCol = 1 TO pihTT:NUM-FIELDS:
        chWorkSheet:Range(ENTRY(iCol,cColList) + STRING(vRow)):Value = pihTT:BUFFER-FIELD(iCol):LABEL.
        chWorkSheet:Columns(ENTRY(iCol,cColList)):Font:Name = cFontName.
        IF iFontSize > 0 THEN
            chWorkSheet:Columns(ENTRY(iCol,cColList)):Font:Size = iFontSize.
        IF pihTT:BUFFER-FIELD(iCol):DATA-TYPE = "DECIMAL" THEN
            chWorkSheet:Columns(ENTRY(iCol,cColList)):Cells:NumberFormat = "#,###,##0.00".
        ELSE IF pihTT:BUFFER-FIELD(iCol):DATA-TYPE = "CHARACTER" THEN
            chWorkSheet:Columns(ENTRY(iCol,cColList)):Cells:NumberFormat = "@".
    END. /* DO iCol = 1 TO pihTT:NUM-FIELDS: */
  
     
    chWorkSheet:Range("A" + STRING(vRow) + ":" + ENTRY(pihTT:NUM-FIELDS,cColList) + STRING(vRow)):borders({&xlEdgeLeft}):LineStyle       = {&xlContinuous}.
    chWorkSheet:Range("A" + STRING(vRow) + ":" + ENTRY(pihTT:NUM-FIELDS,cColList) + STRING(vRow)):borders({&xlEdgeTop}):LineStyle        = {&xlContinuous}.
    chWorkSheet:Range("A" + STRING(vRow) + ":" + ENTRY(pihTT:NUM-FIELDS,cColList) + STRING(vRow)):borders({&xlEdgeBottom}):LineStyle     = {&xlContinuous}.
    chWorkSheet:Range("A" + STRING(vRow) + ":" + ENTRY(pihTT:NUM-FIELDS,cColList) + STRING(vRow)):borders({&xlEdgeRight}):LineStyle      = {&xlContinuous}.
    chWorkSheet:Range("A" + STRING(vRow) + ":" + ENTRY(pihTT:NUM-FIELDS,cColList) + STRING(vRow)):borders({&xlInsideVertical}):LineStyle = {&xlContinuous}.
                           
    /*
     pintamos contenido de la tabla temporal
    */
    /*--- set the query ---*/
    CREATE QUERY hQueryTT.
    hQueryTT:SET-BUFFERS(pihTT).
    hQueryTT:QUERY-PREPARE("FOR EACH " + pihTT:NAME).
    hQueryTT:QUERY-OPEN.
     
    ASSIGN iRow = vRow.
    REPEAT:
        hQueryTT:GET-NEXT.
        IF hQueryTT:QUERY-OFF-END THEN LEAVE.
        ASSIGN iRow = iRow + 1
               cRow = STRING(iRow).
        DO iCol = 1 TO pihTT:NUM-FIELDS:
            chWorkSheet:Range(ENTRY(iCol,cColList) + cRow):Value = pihTT:BUFFER-FIELD(iCol):BUFFER-VALUE.
        END.
    END. /* REPEAT: */
     
    hQueryTT:QUERY-CLOSE.
    DELETE OBJECT hQueryTT.
  
    chWorkSheet:PageSetup:CenterHorizontally = TRUE.
    chWorkSheet:PageSetup:BottomMargin = chExcelApplication:InchesToPoints(0.42).
    chWorkSheet:PageSetup:Zoom = 90.
    chWorkSheet:PageSetup:ORIENTATION = 2.
    chWorkSheet:pagesetup:PrintTitleRows = "$1:$" + STRING(vRow) .
    chWorkSheet:Range('A:' + ENTRY(pihTT:NUM-FIELDS,cColList) ):EntireColumn:AutoFit().
  
    chExcelApplication:DisplayAlerts = FALSE.
    chWorkBook:SaveAs( cRuta + cArchivo + "_" + cUniqueFile  + cExtension,,,,,,,).
  
    IF VALID-HANDLE(chWorkSheet) THEN
        RELEASE OBJECT chWorkSheet.
    IF VALID-HANDLE(chWorkBook) THEN
        RELEASE OBJECT chWorkBook.
    IF VALID-HANDLE(chExcelApplication) THEN
        RELEASE OBJECT chExcelApplication.
  
    MESSAGE "Generacion de Excel Terminada. " SKIP(1)  
            "Directorio: " cRuta  SKIP  
            "Nombre Excel: " (cArchivo + "_" + cUniqueFile + cExtension)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-crea-archivo-csv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-crea-archivo-csv Procedure 
PROCEDURE pi-crea-archivo-csv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     def input  parameter p-buffer  as handle no-undo. /* buffer da temp-table com os dados do relatorio */ 
     def input  parameter p-arquivo as char   no-undo. /* nome completo do arquivo destino do relatorio (.xlsx) */ 
     def output parameter p-arq-csv as char   no-undo. /* arquivo CSV com os dados do relatorio */
 
     def var i-cont          as int    no-undo.
     def var h-query         as handle no-undo.
 
     /* Nome do Arquivo de Destino */ 
     if p-arquivo = "" then do: 
       assign p-arquivo = replace(program-name(1),"/","\"). 
       assign p-arquivo = entry(num-entries(p-arquivo,"\"),p-arquivo,"\"). 
       assign p-arquivo = entry(1,p-arquivo,"."). 
     end. 
     else do: 
         assign p-arq-csv = replace(p-arquivo, ".xlsx", ".csv"). 
     end.
  
     /* Cria o arquivo csv no SO */ 
     output to value(p-arq-csv).
  
     /* Imprime o cabecalho do relatorio */ 
     do i-cont = 1 to p-buffer:num-fields: 
         put unformatted 
             p-buffer:buffer-field(i-cont):column-label 
             if not i-cont = p-buffer:num-fields then ";" else "". 
     end.
 
     put skip.
 
     /* Imprime dados da temp-table */ 
     create query h-query. 
     h-query:set-buffers(p-buffer). 
     h-query:query-prepare("for each " + p-buffer:name). 
     h-query:query-open().
     
     h-query:get-first().
     do while not h-query:query-off-end:
  
         do i-cont = 1 to p-buffer:num-fields:
 
             put unformatted
                 fi-fieldString(input p-buffer:buffer-field(i-cont)).
  
             if i-cont < p-buffer:num-fields then
                 put ";".
 
         end.
 
         put skip.
 
         h-query:get-next().
 
     end.
 
     h-query:query-close() no-error.
 
     output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-crea-archivo-xls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-crea-archivo-xls Procedure 
PROCEDURE pi-crea-archivo-xls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     def input  parameter p-buffer  as handle no-undo. /* buffer da temp-table com os dados do relatorio */
     def input  parameter p-arq-csv as char   no-undo. /* Nome do Arquivo csv com os dados do relatorio */
     def output parameter p-arq-xls as char   no-undo. /* Nome do Arquivo xls criado contendo o relatorio formatado */
 
     def var ch-excel      as com-handle no-undo.
     def var ch-wrk        as com-handle no-undo.
     def var ch-query      as com-handle no-undo.
     def var raw-array     as raw        no-undo.
     def var i-cont        as int        no-undo.
     def var i-num-cols    as int        no-undo.
 
     /* Abre excel */
     create "Excel.Application" ch-excel no-error.
     ch-excel:visible       = no.
     ch-excel:DisplayAlerts = no.
 
     ch-wrk = ch-excel:workbooks:add.
 
     /* Importa arquivo CSV */
     ch-query = ch-wrk:ActiveSheet:QueryTables:add("TEXT;" + p-arq-csv,ch-excel:Range("$A$1")).
 
     assign ch-query:name = "data"
            ch-query:FieldNames = true
            ch-query:RowNumbers = false
            ch-query:FillAdjacentFormulas = false
            ch-query:PreserveFormatting = true
            ch-query:RefreshOnFileOpen = false
            ch-query:RefreshStyle = 1 /* xlInsertDeleteCells */
            ch-query:SavePassword = false
            ch-query:SaveData = true
            ch-query:AdjustColumnWidth = true
            ch-query:RefreshPeriod = 0
            ch-query:TextFilePromptOnRefresh = false
            ch-query:TextFilePlatform = 850
            ch-query:TextFileStartRow = 1
            ch-query:TextFileParseType = 1 /* xlDelimited */
            ch-query:TextFileTextQualifier = -4142 /* xlTextQualifierNone */
            ch-query:TextFileConsecutiveDelimiter = false
            ch-query:TextFileTabDelimiter = false
            ch-query:TextFileSemicolonDelimiter = true
            ch-query:TextFileCommaDelimiter = false
            ch-query:TextFileSpaceDelimiter = false
            ch-query:TextFileTrailingMinusNumbers = true.
 
     /* Configura o tipo de formatacao das colunas, para isso, utiliza o tipo de variavel raw p/ passar array de tipos p/ o Excel */
      do i-cont = 1 to p-buffer:num-fields:
 
         if p-buffer:buffer-field(i-cont):column-label = "" then do:
             put-byte(raw-array, i-cont) = 9. /* 9 = xlSkipColumn */
             next.
         end.
 
         case p-buffer:buffer-field(i-cont):data-type:
             when "character" then put-byte(raw-array, i-cont) = 2. /* 2 = xlTextFormat Excel */
             when "date"      then put-byte(raw-array, i-cont) = 4. /* 4 = xlDMYFormat */
             otherwise  put-byte(raw-array, i-cont) = 1. /* 1 = xlGeneralFormat */
         end case.
 
         assign i-num-cols = i-num-cols + 1.
 
     end.
 
     assign ch-query:TextFileColumnDataTypes = raw-array.
 
     /* Atualiza os dados */
     ch-query:refresh().
 
     /* Configura excel visualmente
      * - Negrito p/ primeira linha e Auto Filtro
      * - Insere borda
      */

     /* Negrito */ 
     ch-excel:range("A1", ch-excel:cells(1, i-num-cols)):select(). 
     ch-excel:selection:font:bold = true. 
     ch-excel:selection:Interior:ColorIndex = 34. 
     ch-excel:selection:Interior:Pattern = 1.
 
     /* Auto Filtro */ 
     ch-excel:selection:AutoFilter(,,).
 
     /* Ajusta as colunas de acordo com tamanho do conteudo */ 
     ch-excel:Cells:select(). 
     ch-excel:selection:columns:AutoFit(). 
     ch-excel:Range("A1"):select(). /* tira selecao */
 
     /* Verifica se pi-customiza-excel esta definido, e caso esteja 
        a excuta p/ customizacoes no arquivo criado */ 
     if lookup("pi-customiza-excel",this-procedure:internal-entries) > 0 then 
         run pi-customiza-excel(input ch-excel).
 
     /* Salva o arquivo XLS */ 
     assign p-arq-xls = replace(p-arq-csv, ".csv", ".xlsx"). 
     ch-wrk:SaveAs(p-arq-xls,51,"","",false,false,). /* 51 = xlOpenXMLWorkbook */
 
     /* Encerra excel e elimna handles */ 
     ch-excel:DisplayAlerts = yes. 
     ch-excel:quit(). 
     release object ch-wrk. 
     release object ch-query. 
     release object ch-excel.
 
     assign ch-wrk   = ? 
            ch-query = ? 
            ch-excel = ?. 
 
     /* Elimina arquivo csv gerado */ 
     os-delete value(p-arq-csv) no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fi-fieldstring) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fi-fieldstring Procedure 
FUNCTION fi-fieldstring RETURNS CHARACTER
  ( p-field as handle) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

     def var c-valor as char no-undo.
     
     if string(p-field:buffer-value) = ? then 
         assign c-valor = "".         
     else if p-field:data-type = "decimal"  or p-field:data-type = "logical" then
         assign c-valor = string(p-field:buffer-value, p-field:format).
     else 
         assign c-valor = string(p-field:buffer-value).
     return c-valor. 


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

