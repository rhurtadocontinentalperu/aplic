&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DATOS NO-UNDO LIKE AlmCatVtaD
       Fields ImpUnit AS DEC
       Fields PreUniRef AS DEC.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR S-CODCIA AS INT.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

DEFINE SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotImp AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotCan AS DECIMAL     NO-UNDO.

DEFINE VARIABLE x-canPed AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-factor AS DECIMAL     INIT 1  NO-UNDO.
DEFINE VARIABLE f-PreBas AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-PreVta AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE y-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE z-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE s-undvta AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER  NO-UNDO FORMAT 'x(35)'.


/*DEFINE VARIABLE x-task-no AS INTEGER    NO-UNDO.*/
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE FRAME F-Mensaje
    x-mensaje SKIP
    " Espere un momento por favor..." SKIP
    WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaCatVenta
&Scoped-define FIRST-EXTERNAL-TABLE VtaCatVenta


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCatVenta.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DATOS Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DATOS.NroPag DATOS.NroSec ~
DATOS.codmat Almmmatg.DesMat DATOS.PreAlt[4] DATOS.UndBas DATOS.Libre_d01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DATOS.Libre_d01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DATOS
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DATOS
&Scoped-define QUERY-STRING-br_table FOR EACH DATOS OF VtaCatVenta WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF DATOS NO-LOCK ~
    BY DATOS.NroPag ~
       BY DATOS.NroSec
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DATOS OF VtaCatVenta WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF DATOS NO-LOCK ~
    BY DATOS.NroPag ~
       BY DATOS.NroSec.
&Scoped-define TABLES-IN-QUERY-br_table DATOS Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DATOS
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS x-TotCan x-TotImp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-TotCan AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE x-TotImp AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY 1
     BGCOLOR 8  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DATOS, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DATOS.NroPag FORMAT "9999":U
      DATOS.NroSec FORMAT "9999":U
      DATOS.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      DATOS.PreAlt[4] COLUMN-LABEL "P. Unitario" FORMAT "->>,>>9.99":U
      DATOS.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U
      DATOS.Libre_d01 COLUMN-LABEL "Cantidad" FORMAT ">>>,>>9":U
  ENABLE
      DATOS.Libre_d01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 95 BY 12.12
         FONT 4
         TITLE "Detalle Articulos por Pagina" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     x-TotCan AT ROW 13.31 COL 61.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     x-TotImp AT ROW 13.31 COL 77.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     "Totales:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 13.5 COL 50 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.VtaCatVenta
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DATOS T "SHARED" NO-UNDO INTEGRAL AlmCatVtaD
      ADDITIONAL-FIELDS:
          Fields ImpUnit AS DEC
          Fields PreUniRef AS DEC
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 13.54
         WIDTH              = 96.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-TotCan IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-TotImp IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.DATOS OF INTEGRAL.VtaCatVenta,INTEGRAL.Almmmatg OF Temp-Tables.DATOS"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "Temp-Tables.DATOS.NroPag|yes,Temp-Tables.DATOS.NroSec|yes"
     _FldNameList[1]   = Temp-Tables.DATOS.NroPag
     _FldNameList[2]   = Temp-Tables.DATOS.NroSec
     _FldNameList[3]   > Temp-Tables.DATOS.codmat
"Temp-Tables.DATOS.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DATOS.PreAlt[4]
"Temp-Tables.DATOS.PreAlt[4]" "P. Unitario" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DATOS.UndBas
"Temp-Tables.DATOS.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.DATOS.Libre_d01
"Temp-Tables.DATOS.Libre_d01" "Cantidad" ">>>,>>9" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DATOS.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DATOS.Libre_d01 br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF DATOS.Libre_d01 IN BROWSE br_table /* Cantidad */
DO:
    DATOS.NroPag:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.NroSec:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    Almmmatg.DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.UndBas:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.PreAlt[4]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DATOS.Libre_d01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DATOS.Libre_d01 IN BROWSE br_table /* Cantidad */
DO:
    DEFINE VARIABLE x-canPed AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-factor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-PreBas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-PreVta AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-Dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE y-Dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE z-Dsctos AS DECIMAL     NO-UNDO.

    /*Colorea Fila*/
    DATOS.NroPag:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.NroSec:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    Almmmatg.DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.UndBas:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.PreAlt[4]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    
    ASSIGN 
        ImpUnit = ( 
                   DEC( datos.libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
                   datos.prealt[4] *
                   ( 1 - DEC( datos.Por_Dsctos[2] ) / 100 ) *
                    ( 1 - DEC( datos.Por_Dsctos[3] ) / 100 )
                   )
        PreUniRef = ImpUnit / DEC( datos.libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ). 
    IF PreUniRef = ? THEN PreUniRef = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/*     RUN Calcula_Total_Importe.                                                 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaCatVenta"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCatVenta"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula_Total_Importe B-table-Win 
PROCEDURE Calcula_Total_Importe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    dTotImp = 0.
    dTotCan = 0.
    FOR EACH datos WHERE datos.codcia = s-codcia
        AND datos.libre_d01 <> 0 NO-LOCK:
        dTotImp = dTotImp + datos.impuni.
        dTotCan = dTotCan + datos.libre_d01.
    END.
    DISPLAY 
        dTotImp @ x-TotImp 
        dTotCan @ x-TotCan
        WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel B-table-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Catalogo02.xlt".

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
chWorkSheet:Range('B5'):Font:Bold = TRUE.
chWorkSheet:Range('B5'):Value = "CATALOGO DE PRODUCTOS".
chWorkSheet:Range('E5'):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

t-Column = t-Column + 5.
P = t-Column.

x-mensaje = 'Generando Archivo Excel'.
/*VIEW FRAME f-mensaje.*/
DISPLAY 
    x-mensaje NO-LABEL
    WITH FRAME f-mensaje.
FOR EACH datos WHERE datos.codcia = s-codcia
    AND datos.coddiv = s-coddiv
    AND datos.codpro = almcatvtac.codpro 
    AND datos.libre_d01 > 0 NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = datos.codmat NO-LOCK
    BREAK BY datos.nropag DESC
        BY datos.nrosec DESC:
    
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    p = p + 1.   
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.    
    chWorkSheet:Range(cRange):Value = datos.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4].        
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.libre_d01.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4] *  datos.libre_d01.
    /****SubTotales****
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", H' + STRING(t-column) + ', (H' + STRING(t-column) + ' + K' + STRING(t-column - 1) + '))'.         
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", I' + STRING(t-column) + ', (I' + STRING(t-column) + ' + L' + STRING(t-column - 1) + '))'.         
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", K' + STRING(t-column) + ', "" )'.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", L' + STRING(t-column) + ', "" )'.    
    */

END.

HIDE FRAME f-mensaje.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Listado B-table-Win 
PROCEDURE Genera-Listado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Catalogo.xlt".

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
chWorkSheet:Range('D5'):Font:Bold = TRUE.
chWorkSheet:Range('D5'):Value = "CATALOGO DE PRODUCTOS PARA EL PROVEEDOR: " + almcatvtac.codpro.
chWorkSheet:Range('G5'):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".


t-Column = t-Column + 5.
P = t-Column.

x-mensaje = 'Generando Archivo Excel'.
/*VIEW FRAME f-mensaje.*/
DISPLAY 
    x-mensaje NO-LABEL
    WITH FRAME f-mensaje.
FOR EACH datos WHERE datos.codcia = s-codcia
    AND datos.coddiv = s-coddiv
    AND datos.codpro = almcatvtac.codpro /*
    AND datos.nropag = almcatvtac.nropag*/ NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = datos.codmat NO-LOCK
    BREAK BY datos.nropag DESC
        BY datos.nrosec DESC:
    
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    p = p + 1.   
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + datos.codpro.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(datos.nropag,'999').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(datos.nrosec,'999').
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.codmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.DesMat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4].        
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.libre_d01.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = '=H'+ STRING(t-column) + '*I' + STRING(t-column).        
    /****SubTotales****
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", H' + STRING(t-column) + ', (H' + STRING(t-column) + ' + K' + STRING(t-column - 1) + '))'.         
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", I' + STRING(t-column) + ', (I' + STRING(t-column) + ' + L' + STRING(t-column - 1) + '))'.         
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", K' + STRING(t-column) + ', "" )'.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", L' + STRING(t-column) + ', "" )'.    
    */

END.

HIDE FRAME f-mensaje.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos B-table-Win 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Elimina otros datos*/
/*     DEF VAR x-NroItm AS INT INIT 0 NO-UNDO.                                                                     */
/*                                                                                                                 */
/*     EMPTY TEMP-TABLE PEDI2.                                                                                     */
/*     FOR EACH datos WHERE datos.codcia = s-codcia                                                                */
/*         AND datos.coddiv = pCodDiv                                                                              */
/*         AND datos.libre_d01 <> 0 NO-LOCK,                                                                       */
/*         FIRST almmmatg WHERE almmmatg.codcia = s-codcia                                                         */
/*         AND almmmatg.codmat = datos.codmat NO-LOCK                                                              */
/*         BY DATOS.CodPro BY DATOS.NroPag BY DATOS.NroSec:                                                        */
/*         FIND FIRST pedi2 WHERE pedi2.codcia = s-codcia                                                          */
/*             AND pedi2.coddiv = s-CodDiv                                                                         */
/*             AND pedi2.codped = "PET"                                                                            */
/*             AND pedi2.nroped = s-nrocot                                                                         */
/*             AND pedi2.codmat = datos.codmat NO-ERROR.                                                           */
/*         IF NOT AVAIL pedi2 THEN DO:                                                                             */
/*             f-factor = 1.                                                                                       */
/*             RUN vta2/PrecioListaxMayorCredito (                                                                 */
/*                 s-TpoPed,                                                                                       */
/*                 pCodDiv,                                                                                        */
/*                 s-CodCli,                                                                                       */
/*                 s-CodMon,                                                                                       */
/*                 INPUT-OUTPUT s-UndVta,                                                                          */
/*                 OUTPUT f-Factor,                                                                                */
/*                 Almmmatg.CodMat,                                                                                */
/*                 s-CndVta,                                                                                       */
/*                 x-CanPed,                                                                                       */
/*                 s-NroDec,                                                                                       */
/*                 OUTPUT f-PreBas,                                                                                */
/*                 OUTPUT f-PreVta,                                                                                */
/*                 OUTPUT f-Dsctos,                                                                                */
/*                 OUTPUT y-Dsctos,                                                                                */
/*                 OUTPUT z-Dsctos,                                                                                */
/*                 OUTPUT x-TipDto,                                                                                */
/*                 "",                                                                                             */
/*                 FALSE                                                                                           */
/*                 ).                                                                                              */
/*                                                                                                                 */
/*             CREATE PEDI2.                                                                                       */
/*             ASSIGN                                                                                              */
/*                 PEDI2.NroItm = x-NroItm                                                                         */
/*                 PEDI2.CodCia = s-codcia                                                                         */
/*                 PEDI2.CodDiv = s-coddiv                                                                         */
/*                 PEDI2.AlmDes = s-codalm                                                                         */
/*                 PEDI2.CodMat = datos.codmat                                                                     */
/*                 PEDI2.CodPed = "PET"                                                                            */
/*                 PEDI2.NroPed = s-nrocot                                                                         */
/*                 PEDI2.Factor = f-factor                                                                         */
/*                 PEDI2.UndVta = datos.undbas:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}                               */
/*                 PEDI2.PreBas = f-PreBas                                                                         */
/*                 PEDI2.PreUni = f-prevta                                                                         */
/*                 PEDI2.CanPed = datos.libre_d01                                                                  */
/*                 PEDI2.Libre_d01 = datos.libre_d01                                                               */
/*                 PEDI2.Libre_c01 = STRING(datos.nropag,"9999")                                                   */
/*                 PEDI2.Libre_c02 = STRING(datos.nrosec,"9999")                                                   */
/*                 PEDI2.Libre_c03 = datos.codpro                                                                  */
/*                 PEDI2.PorDto = F-DSCTOS                                                                         */
/*                 PEDI2.Por_DSCTOS[2] = z-Dsctos                                                                  */
/*                 PEDI2.Por_Dsctos[3] = Y-DSCTOS                                                                  */
/*                 PEDI2.AftIgv = Almmmatg.AftIgv                                                                  */
/*                 PEDI2.AftIsc = Almmmatg.AftIsc                                                                  */
/*                 PEDI2.PesMat = PEDI2.CanPed * Almmmatg.PesMat                                                   */
/*                 PEDI2.Libre_c04 = X-TIPDTO.                                                                     */
/*             ASSIGN                                                                                              */
/*                 PEDI2.ImpLin = PEDI2.CanPed * PEDI2.PreUni *                                                    */
/*                             ( 1 - PEDI2.Por_Dsctos[1] / 100 ) *                                                 */
/*                             ( 1 - PEDI2.Por_Dsctos[2] / 100 ) *                                                 */
/*                             ( 1 - PEDI2.Por_Dsctos[3] / 100 ).                                                  */
/*             IF PEDI2.Por_Dsctos[1] = 0 AND PEDI2.Por_Dsctos[2] = 0 AND PEDI2.Por_Dsctos[3] = 0                  */
/*                 THEN PEDI2.ImpDto = 0.                                                                          */
/*             ELSE PEDI2.ImpDto = PEDI2.CanPed * PEDI2.PreUni - PEDI2.ImpLin.                                     */
/*             ASSIGN                                                                                              */
/*                 PEDI2.ImpLin = ROUND(PEDI2.ImpLin, 2)                                                           */
/*                 PEDI2.ImpDto = ROUND(PEDI2.ImpDto, 2).                                                          */
/*             IF PEDI2.AftIsc                                                                                     */
/*                 THEN PEDI2.ImpIsc = ROUND(PEDI2.PreBas * PEDI2.CanPed * (Almmmatg.PorIsc / 100),4).             */
/*             IF PEDI2.AftIgv                                                                                     */
/*                 THEN PEDI2.ImpIgv = PEDI2.ImpLin - ROUND( PEDI2.ImpLin  / ( 1 + (FacCfgGn.PorIgv / 100) ), 4 ). */
/*             x-NroItm = x-NroItm + 1.                                                                            */
/*             /* RHC 03/01/2014 CARGAMOS EL PROMOTOR */                                                           */
/*             FIND FIRST w-report WHERE w-report.task-no = s-task-no                                              */
/*                 AND w-report.llave-c = datos.codpro                                                             */
/*                 NO-LOCK NO-ERROR.                                                                               */
/*             IF AVAILABLE w-report THEN PEDI2.Libre_d02 = w-report.campo-f[1].                                   */
/*         END.                                                                                                    */
/*     END.                                                                                                        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN Calcula_Total_Importe.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    
  RUN Calcula_Total_Importe.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaCatVenta"}
  {src/adm/template/snd-list.i "DATOS"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 
  IF DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) = 0 THEN RETURN 'OK'.

  DEF VAR f-Canped AS DEC NO-UNDO.
  /* EMPAQUE */
  IF s-FlgEmpaque = YES THEN DO:
      IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
          FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
              f-CanPed = DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
              f-CanPed = (TRUNCATE((f-CanPed / Vtalistamay.CanEmp),0) * Vtalistamay.CanEmp).
              IF f-CanPed <> DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' Vtalistamay.CanEmp Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO DATOS.Libre_d01.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
      ELSE DO:      /* LISTA GENERAL */
          IF Almmmatg.DEC__03 > 0 THEN DO:
              f-CanPed = DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
              f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
              IF f-CanPed <> DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO DATOS.Libre_d01.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
  END.
  /* MINIMO DE VENTA */
  IF s-FlgMinVenta = YES /*AND Almmmatg.DEC__03 > 0*/ THEN DO:
      f-CanPed = DECIMAL(Datos.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      IF Datos.Libre_d02 > 0 THEN DO:
          IF f-CanPed < Datos.Libre_d02 THEN DO:
              MESSAGE 'Solo puede vender como mínimo' Datos.Libre_d02 Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY' TO Datos.Libre_d01 IN BROWSE {&browse-name}.
              RETURN 'ADM-ERROR'.
          END.
          /* Múltiplos */
      END.
  END.

  /* PRECIO UNITARIO */
  IF DECIMAL(datos.PreAlt[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO Datos.Libre_d01.
       RETURN "ADM-ERROR".
  END.

  /* CONSISTENCIA DE STOCK */
/*   DEFINE VARIABLE s-StkComprometido AS DECIMAL NO-UNDO.                                                                  */
/*                                                                                                                          */
/*   FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA                                                                         */
/*       AND  Almmmate.CodAlm = ENTRY(1, s-CodAlm)                                                                          */
/*       AND  Almmmate.codmat = DATOS.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}                                          */
/*       NO-LOCK NO-ERROR.                                                                                                  */
/*   IF AVAILABLE Almmmate THEN DO:                                                                                         */
/*       RUN vta2/Stock-Comprometido-Expo (DATOS.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},                              */
/*                                    ENTRY(1, s-CodAlm),                                                                   */
/*                                    OUTPUT s-StkComprometido).                                                            */
/*       IF DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > (Almmmate.StkAct - s-StkComprometido) THEN DO: */
/*           MESSAGE "No hay STOCK disponible en el almacen" ENTRY(1, s-CodAlm) SKIP(1)                                     */
/*               "     STOCK ACTUAL : " almmmate.StkAct SKIP                                                                */
/*               "     COMPROMETIDO : " s-StkComprometido.                                                                  */
/*           APPLY 'ENTRY':U TO Datos.Libre_d01.                                                                            */
/*           RETURN "ADM-ERROR".                                                                                            */
/*       END.                                                                                                               */
/*   END.                                                                                                                   */
        
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

