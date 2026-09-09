&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-User-Id AS CHAR.
DEF VAR x-SubLinea AS CHAR NO-UNDO.

DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES VtaCTabla
&Scoped-define FIRST-EXTERNAL-TABLE VtaCTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCTabla.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaDTabla Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaDTabla.LlaveDetalle ~
Almmmatg.DesMat VtaDTabla.Libre_l05 VtaDTabla.Libre_l01 VtaDTabla.Libre_l02 ~
VtaDTabla.Libre_l03 VtaDTabla.Libre_l04 VtaDTabla.Libre_c05 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaDTabla.LlaveDetalle ~
VtaDTabla.Libre_l05 VtaDTabla.Libre_l01 VtaDTabla.Libre_l02 ~
VtaDTabla.Libre_l03 VtaDTabla.Libre_l04 VtaDTabla.Libre_c05 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaDTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaDTabla
&Scoped-define QUERY-STRING-br_table FOR EACH VtaDTabla OF VtaCTabla WHERE ~{&KEY-PHRASE} ~
      AND VtaDTabla.Tipo = "A" NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia ~
  AND Almmmatg.codmat = VtaDTabla.LlaveDetalle OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaDTabla OF VtaCTabla WHERE ~{&KEY-PHRASE} ~
      AND VtaDTabla.Tipo = "A" NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia ~
  AND Almmmatg.codmat = VtaDTabla.LlaveDetalle OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaDTabla Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaDTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-Plantilla BUTTON-Importar 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSubLinea B-table-Win 
FUNCTION fSubLinea RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Importar 
     LABEL "IMPORTAR  XLS" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-Plantilla 
     LABEL "PLANTILLA XLS" 
     SIZE 17 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaDTabla, 
      Almmmatg
    FIELDS(Almmmatg.DesMat) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaDTabla.LlaveDetalle COLUMN-LABEL "Artículo" FORMAT "x(14)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.86
      VtaDTabla.Libre_l05 COLUMN-LABEL "Precio!Mostrador" FORMAT "yes/no":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SI",yes ,
                                      "NO",no
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_l01 COLUMN-LABEL "AFECTA LISTA DE!xCondic. de Venta" FORMAT "yes/no":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SI",yes ,
                                      "NO",no
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_l02 COLUMN-LABEL "PRECIOS!xClasific. Cliente" FORMAT "yes/no":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SI",yes ,
                                      "NO",no
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_l03 COLUMN-LABEL "DESCUENTOS POR!Dcto. x Volumen" FORMAT "yes/no":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SI",yes ,
                                      "NO",no
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_l04 COLUMN-LABEL "PRODUCTO!Dcto. Promocional" FORMAT "yes/no":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SI",yes ,
                                      "NO",no
                      DROP-DOWN-LIST 
      VtaDTabla.Libre_c05 COLUMN-LABEL "Tipo" FORMAT "x(15)":U
            WIDTH 10.57 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "NO DEFINIDO","",
                                      "EXCLUYENTES","E",
                                      "ACUMULADOS","A"
                      DROP-DOWN-LIST 
  ENABLE
      VtaDTabla.LlaveDetalle
      VtaDTabla.Libre_l05
      VtaDTabla.Libre_l01
      VtaDTabla.Libre_l02
      VtaDTabla.Libre_l03
      VtaDTabla.Libre_l04
      VtaDTabla.Libre_c05
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 158 BY 14.81
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-Plantilla AT ROW 12.85 COL 160 WIDGET-ID 2
     BUTTON-Importar AT ROW 14.19 COL 160 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.VtaCTabla
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 16.88
         WIDTH              = 179.14.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaDTabla OF INTEGRAL.VtaCTabla,INTEGRAL.Almmmatg WHERE INTEGRAL.VtaDTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED, OUTER"
     _Where[1]         = "VtaDTabla.Tipo = ""A"""
     _JoinCode[2]      = "Almmmatg.CodCia = VtaDTabla.CodCia
  AND Almmmatg.codmat = VtaDTabla.LlaveDetalle"
     _FldNameList[1]   > INTEGRAL.VtaDTabla.LlaveDetalle
"VtaDTabla.LlaveDetalle" "Artículo" "x(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaDTabla.Libre_l05
"VtaDTabla.Libre_l05" "Precio!Mostrador" ? "logical" 10 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SI,yes ,NO,no" 5 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaDTabla.Libre_l01
"VtaDTabla.Libre_l01" "AFECTA LISTA DE!xCondic. de Venta" ? "logical" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SI,yes ,NO,no" 5 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaDTabla.Libre_l02
"VtaDTabla.Libre_l02" "PRECIOS!xClasific. Cliente" ? "logical" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SI,yes ,NO,no" 5 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaDTabla.Libre_l03
"VtaDTabla.Libre_l03" "DESCUENTOS POR!Dcto. x Volumen" ? "logical" 14 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SI,yes ,NO,no" 5 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaDTabla.Libre_l04
"VtaDTabla.Libre_l04" "PRODUCTO!Dcto. Promocional" ? "logical" 14 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SI,yes ,NO,no" 5 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaDTabla.Libre_c05
"VtaDTabla.Libre_c05" "Tipo" "x(15)" "character" ? ? ? ? ? ? yes ? no no "10.57" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "NO DEFINIDO,,EXCLUYENTES,E,ACUMULADOS,A" 5 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDTabla.LlaveDetalle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDTabla.LlaveDetalle br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaDTabla.LlaveDetalle IN BROWSE br_table /* Artículo */
DO:
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    IF TRUE <> (pCodMat > '') THEN RETURN.

    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND
        Almmmatg.codmat = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DISPLAY Almmmatg.desmat WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Importar B-table-Win
ON CHOOSE OF BUTTON-Importar IN FRAME F-Main /* IMPORTAR  XLS */
DO:
  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Import-XLS (OUTPUT pMensaje).
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Plantilla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Plantilla B-table-Win
ON CHOOSE OF BUTTON-Plantilla IN FRAME F-Main /* PLANTILLA XLS */
DO:
  RUN pri/d-param-arti-plantilla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF VtaDTabla.Libre_l01, 
    VtaDTabla.Libre_l02, VtaDTabla.Libre_l03, VtaDTabla.Libre_l04, 
    VtaDTabla.LlaveDetalle DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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
  {src/adm/template/row-list.i "VtaCTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCTabla"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-XLS B-table-Win 
PROCEDURE Import-XLS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR OKpressed AS LOG NO-UNDO.
DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR cValue AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE lFileXls
    FILTERS "*.xls" "*.xls", "*.xlsx" "*.xlsx"
    INITIAL-FILTER 2
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

lNuevoFile = NO.                 
{lib/excel-open-file.i}

ASSIGN
    iRow = 2.
REPEAT:
    ASSIGN
        iColumn = 0
        iRow    = iRow + 1.
    iColumn = iColumn + 1.
    cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* Articulo */
    ASSIGN
        cValue = STRING(DECIMAL(cValue), '999999') NO-ERROR.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(iRow, '>>>9')) + ":"  + CHR(10) 
            + "CODIGO: " + cValue.
        LEAVE.
    END.
    FIND FIRST VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "A" 
        AND VtaDTabla.LlaveDetalle = cValue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaDTabla THEN DO:
        CREATE VtaDTabla.
        ASSIGN
            VtaDTabla.CodCia = VtaCTabla.CodCia 
            VtaDTabla.Tabla  = VtaCTabla.Tabla 
            VtaDTabla.Llave  = VtaCTabla.Llave
            VtaDTabla.Tipo   = "A"      /* Líneas y SubLíneas */
            VtaDTabla.LlaveDetalle = cValue
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            LEAVE.
        END.
    END.
    ELSE DO:
        FIND CURRENT VtaDTabla EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "Artículo " + cValue + " en uso por otro usaurio".
            LEAVE.
        END.
    END.
    /* xCondic. de Venta */
    iColumn = iColumn + 2.
    cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
    IF cValue = 'SI' OR cValue ='NO' THEN VtaDTabla.Libre_l01 = (IF cValue = 'SI' THEN YES ELSE NO).
    /* xClasif. Cliente */
    iColumn = iColumn + 1.
    cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
    IF cValue = 'SI' OR cValue ='NO' THEN VtaDTabla.Libre_l02 = (IF cValue = 'SI' THEN YES ELSE NO).
    /* Dcto. x Volumen */
    iColumn = iColumn + 1.
    cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
    IF cValue = 'SI' OR cValue ='NO' THEN VtaDTabla.Libre_l03 = (IF cValue = 'SI' THEN YES ELSE NO).
    /* Dcto x Prom */
    iColumn = iColumn + 1.
    cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
    IF cValue = 'SI' OR cValue ='NO' THEN VtaDTabla.Libre_l04 = (IF cValue = 'SI' THEN YES ELSE NO).
    /* Tipo */
    iColumn = iColumn + 1.
    cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
    IF cValue = 'EXCLUYENTES' OR cValue = 'ACUMULADOS' OR cValue = ''
        THEN VtaDTabla.Libre_c05 = cValue.
END.

lCerrarAlTerminar = YES.
lMensajeAlTerminar = YES.
{lib/excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaDTabla.CodCia = VtaCTabla.CodCia 
      VtaDTabla.Tabla  = VtaCTabla.Tabla 
      VtaDTabla.Llave  = VtaCTabla.Llave
      VtaDTabla.Tipo   = "A".     /* Líneas y SubLíneas */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Header').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      VtaDTabla.LlaveDetalle:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  END.
  ELSE DO:
      VtaDTabla.LlaveDetalle:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  END.
  RUN Procesa-Handle IN lh_handle ('Disable-Header').


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
  {src/adm/template/snd-list.i "VtaCTabla"}
  {src/adm/template/snd-list.i "VtaDTabla"}
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

IF TRUE <> (VtaDTabla.LlaveDetalle:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '') 
    THEN DO:
    MESSAGE 'Artículo NO debe estar en blanco' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDTabla.LlaveDetalle.
    RETURN 'ADM-ERROR'.
END.
FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND
    Almmmatg.codmat = VtaDTabla.LlaveDetalle:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDTabla.LlaveDetalle.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia AND 
                VtaTabla.Tabla = "LP" AND 
                VtaTabla.Llave_c1 = s-User-Id AND 
                VtaTabla.Llave_c2 = Almmmatg.CodFam NO-LOCK)
    THEN DO:
    MESSAGE 'Artículo pertenece a una Línea NO autorizada para su usuario' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDTabla.LlaveDetalle.
    RETURN 'ADM-ERROR'.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    IF CAN-FIND(FIRST VtaDTabla WHERE VtaDTabla.CodCia = VtaCTabla.CodCia 
                AND VtaDTabla.Tabla  = VtaCTabla.Tabla 
                AND VtaDTabla.Llave  = VtaCTabla.Llave
                AND VtaDTabla.Tipo   = "A"
                AND VtaDTabla.LlaveDetalle = VtaDTabla.LlaveDetalle:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                NO-LOCK)
        THEN DO:
        MESSAGE 'Artículo repetido' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaDTabla.LlaveDetalle.
        RETURN 'ADM-ERROR'.
    END.
END.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSubLinea B-table-Win 
FUNCTION fSubLinea RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND AlmSFami WHERE AlmSFami.CodCia = s-CodCia AND 
      AlmSFami.codfam = VtaDTabla.LlaveDetalle AND
      AlmSFami.subfam = (VtaDTabla.Libre_c01 + VtaDTabla.Libre_c02)
      NO-LOCK NO-ERROR.
  IF AVAILABLE AlmSFami THEN RETURN AlmSFami.dessub.
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

