&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER Destino FOR almtabla.
DEFINE BUFFER Origen FOR almtabla.
DEFINE TEMP-TABLE t-FacTabla NO-UNDO LIKE FacTabla.
DEFINE TEMP-TABLE t-flete_sugerido NO-UNDO LIKE flete_sugerido.



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

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INTE.

DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR x-Actual-Peso AS DECI NO-UNDO.
DEF VAR x-Actual-Volumen AS DECI NO-UNDO.

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES flete_sugerido Origen Destino

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table flete_sugerido.Origen Origen.Nombre ~
flete_sugerido.Destino Destino.Nombre flete_sugerido.Peso ~
flete_sugerido.Flete_Total_Peso ~
fACtualPeso(flete_sugerido.Origen,flete_sugerido.Destino)@ x-Actual-Peso ~
flete_sugerido.Flete_Promedio_Peso flete_sugerido.Flete_Sugerido_Peso ~
flete_sugerido.Volumen flete_sugerido.Flete_Total_Volumen ~
fActualVolumen(flete_sugerido.Origen,flete_sugerido.Destino)@ x-Actual-Volumen ~
flete_sugerido.Flete_Promedio_Volumen flete_sugerido.Flete_Sugerido_Volumen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ~
flete_sugerido.Flete_Sugerido_Peso flete_sugerido.Flete_Sugerido_Volumen 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table flete_sugerido
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table flete_sugerido
&Scoped-define QUERY-STRING-br_table FOR EACH flete_sugerido WHERE ~{&KEY-PHRASE} ~
      AND flete_sugerido.FlgEst = "P" ~
  NO-LOCK, ~
      FIRST Origen WHERE Origen.Codigo = flete_sugerido.Origen ~
      AND Origen.Tabla = "ZG" NO-LOCK, ~
      FIRST Destino WHERE Destino.Codigo = flete_sugerido.Destino ~
      AND Destino.Tabla = "ZG" NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH flete_sugerido WHERE ~{&KEY-PHRASE} ~
      AND flete_sugerido.FlgEst = "P" ~
  NO-LOCK, ~
      FIRST Origen WHERE Origen.Codigo = flete_sugerido.Origen ~
      AND Origen.Tabla = "ZG" NO-LOCK, ~
      FIRST Destino WHERE Destino.Codigo = flete_sugerido.Destino ~
      AND Destino.Tabla = "ZG" NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table flete_sugerido Origen Destino
&Scoped-define FIRST-TABLE-IN-QUERY-br_table flete_sugerido
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Origen
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Destino


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 br_table 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fActualPeso B-table-Win 
FUNCTION fActualPeso RETURNS DECIMAL
  ( INPUT  pOrigen AS CHAR, INPUT pDestino AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fActualVolumen B-table-Win 
FUNCTION fActualVolumen RETURNS DECIMAL
  ( INPUT  pOrigen AS CHAR, INPUT pDestino AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 50 BY 1.08
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 55 BY 1.08
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      flete_sugerido, 
      Origen, 
      Destino SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      flete_sugerido.Origen FORMAT "x(8)":U WIDTH 6.43
      Origen.Nombre FORMAT "x(40)":U WIDTH 25.86
      flete_sugerido.Destino FORMAT "x(8)":U WIDTH 6
      Destino.Nombre FORMAT "x(40)":U WIDTH 26.43
      flete_sugerido.Peso COLUMN-LABEL "Total Peso!en kg" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 7.14
      flete_sugerido.Flete_Total_Peso COLUMN-LABEL "Total Flete!S/ con IGV" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 8.72
      fACtualPeso(flete_sugerido.Origen,flete_sugerido.Destino)@ x-Actual-Peso COLUMN-LABEL "Unit. Actual!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.43
      flete_sugerido.Flete_Promedio_Peso COLUMN-LABEL "Unit. Promedio!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      flete_sugerido.Flete_Sugerido_Peso COLUMN-LABEL "Unit. Sugerido!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      flete_sugerido.Volumen COLUMN-LABEL "Total Volumen!en m3" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.43
      flete_sugerido.Flete_Total_Volumen COLUMN-LABEL "Total Flete!S/ con IGV" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 8.43
      fActualVolumen(flete_sugerido.Origen,flete_sugerido.Destino)@ x-Actual-Volumen COLUMN-LABEL "Unit. Actual!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.14
      flete_sugerido.Flete_Promedio_Volumen COLUMN-LABEL "Unit. Promedio!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      flete_sugerido.Flete_Sugerido_Volumen COLUMN-LABEL "Unit. Sugerido!S/ con IGV" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 9.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
  ENABLE
      flete_sugerido.Flete_Sugerido_Peso
      flete_sugerido.Flete_Sugerido_Volumen
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 174 BY 9.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.08 COL 1
     "P E S O" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.27 COL 89 WIDGET-ID 2
          FONT 8
     "V O L U M E N" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 1.27 COL 138 WIDGET-ID 4
          FONT 8
     RECT-1 AT ROW 1 COL 70 WIDGET-ID 6
     RECT-2 AT ROW 1 COL 120 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: Destino B "?" ? INTEGRAL almtabla
      TABLE: Origen B "?" ? INTEGRAL almtabla
      TABLE: t-FacTabla T "?" NO-UNDO INTEGRAL FacTabla
      TABLE: t-flete_sugerido T "?" NO-UNDO INTEGRAL flete_sugerido
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
         HEIGHT             = 10.65
         WIDTH              = 175.86.
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
/* BROWSE-TAB br_table RECT-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.flete_sugerido,Origen WHERE INTEGRAL.flete_sugerido ...,Destino WHERE INTEGRAL.flete_sugerido ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _Where[1]         = "flete_sugerido.FlgEst = ""P""
 "
     _JoinCode[2]      = "Origen.Codigo = flete_sugerido.Origen"
     _Where[2]         = "Origen.Tabla = ""ZG"""
     _JoinCode[3]      = "Destino.Codigo = flete_sugerido.Destino"
     _Where[3]         = "Destino.Tabla = ""ZG"""
     _FldNameList[1]   > INTEGRAL.flete_sugerido.Origen
"flete_sugerido.Origen" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Origen.Nombre
"Origen.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "25.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.flete_sugerido.Destino
"flete_sugerido.Destino" ? ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Destino.Nombre
"Destino.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "26.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.flete_sugerido.Peso
"flete_sugerido.Peso" "Total Peso!en kg" ? "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.flete_sugerido.Flete_Total_Peso
"flete_sugerido.Flete_Total_Peso" "Total Flete!S/ con IGV" ? "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fACtualPeso(flete_sugerido.Origen,flete_sugerido.Destino)@ x-Actual-Peso" "Unit. Actual!S/ con IGV" ">>>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.flete_sugerido.Flete_Promedio_Peso
"flete_sugerido.Flete_Promedio_Peso" "Unit. Promedio!S/ con IGV" ? "decimal" 14 0 ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.flete_sugerido.Flete_Sugerido_Peso
"flete_sugerido.Flete_Sugerido_Peso" "Unit. Sugerido!S/ con IGV" ? "decimal" 11 0 ? ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.flete_sugerido.Volumen
"flete_sugerido.Volumen" "Total Volumen!en m3" ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.flete_sugerido.Flete_Total_Volumen
"flete_sugerido.Flete_Total_Volumen" "Total Flete!S/ con IGV" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fActualVolumen(flete_sugerido.Origen,flete_sugerido.Destino)@ x-Actual-Volumen" "Unit. Actual!S/ con IGV" ">>>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.flete_sugerido.Flete_Promedio_Volumen
"flete_sugerido.Flete_Promedio_Volumen" "Unit. Promedio!S/ con IGV" ? "decimal" 14 0 ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.flete_sugerido.Flete_Sugerido_Volumen
"flete_sugerido.Flete_Sugerido_Volumen" "Unit. Sugerido!S/ con IGV" ? "decimal" 11 0 ? ? ? ? yes ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    EMPTY TEMP-TABLE t-flete_sugerido.

    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE flete_sugerido:
        FIND CURRENT flete_sugerido EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            flete_sugerido.FchAprobacion = TODAY
            flete_sugerido.FlgEst = "A"
            flete_sugerido.HoraAprobacion = STRING(TIME,'HH:MM:SS') 
            flete_sugerido.UsrAprobacion = s-User-Id.
        /* Por cada una de las Zonas Geográficas actualizamos su flete */
        /* Se va a sacar el promedio aritmético tomando como dato el destino */
        CREATE t-flete_sugerido.
        BUFFER-COPY flete_sugerido TO t-flete_sugerido.

        GET NEXT {&browse-name}.
    END.

    {logis/i-flete-supervisor.i &Fletes="FacTabla"}

/*     DEF VAR x-Flete-Peso AS DECI NO-UNDO.                                                        */
/*     DEF VAR x-Flete-Volumen AS DECI NO-UNDO.                                                     */
/*     DEF VAR x-Cuenta-Peso AS DECI NO-UNDO.                                                       */
/*     DEF VAR x-Cuenta-Volumen AS DECI NO-UNDO.                                                    */
/*                                                                                                  */
/*     FOR EACH t-flete_sugerido BREAK BY t-flete_sugerido.Destino:                                 */
/*         IF FIRST-OF(t-flete_sugerido.Destino) THEN DO:                                           */
/*             x-Flete-Peso = 0.                                                                    */
/*             x-Flete-Volumen = 0.                                                                 */
/*             x-Cuenta-Peso = 0.                                                                   */
/*             x-Cuenta-Volumen = 0.                                                                */
/*         END.                                                                                     */
/*         x-Flete-Peso = x-Flete-Peso + t-flete_sugerido.Flete_Sugerido_Peso.                      */
/*         x-Flete-Volumen = x-Flete-Volumen + t-flete_sugerido.Flete_Sugerido_Volumen.             */
/*         x-Cuenta-Peso = x-Cuenta-Peso + 1.                                                       */
/*         x-Cuenta-Volumen = x-Cuenta-Volumen + 1.                                                 */
/*         IF LAST-OF(t-flete_sugerido.Destino) THEN DO:                                            */
/*             /* Promedio simple */                                                                */
/*             x-Flete-Peso = x-Flete-Peso / x-Cuenta-Peso.                                         */
/*             x-Flete-Volumen = x-Flete-Volumen / x-Cuenta-Volumen.                                */
/*             FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia                           */
/*                 AND TabGener.Clave = 'ZG_DIVI'                                                   */
/*                 AND TabGener.Codigo = t-flete_sugerido.Destino:                                  */
/*                 FIND FacTabla WHERE FacTabla.CodCia = s-CodCia                                   */
/*                     AND FacTabla.Tabla = 'FLETE'                                                 */
/*                     AND FacTabla.Codigo = TabGener.Libre_c01        /* División */               */
/*                     NO-LOCK NO-ERROR.                                                            */
/*                 IF AVAILABLE FacTabla THEN DO:                                                   */
/*                     FIND CURRENT FacTabla EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                       */
/*                     IF ERROR-STATUS:ERROR = YES THEN DO:                                         */
/*                         {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"} */
/*                             UNDO RLOOP, RETURN 'ADM-ERROR'.                                      */
/*                     END.                                                                         */
/*                     ASSIGN                                                                       */
/*                         FacTabla.Valor[1] = x-Flete-Peso                                         */
/*                         FacTabla.Valor[2] = x-Flete-Volumen                                      */
/*                         .                                                                        */
/*                     RELEASE FacTabla.                                                            */
/*                 END.                                                                             */
/*             END.                                                                                 */
/*         END.                                                                                     */
/*     END.                                                                                         */
END.
RETURN 'OK'.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/*
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE flete_sugerido:
        FIND CURRENT flete_sugerido EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            flete_sugerido.FchAprobacion = TODAY
            flete_sugerido.FlgEst = "A"
            flete_sugerido.HoraAprobacion = STRING(TIME,'HH:MM:SS') 
            flete_sugerido.UsrAprobacion = s-User-Id.
        /* Por cada una de las Zonas Geográficas actualizamos su flete */
        /* Por ahora solo se tiene los fletes de ATE a las otras sedes */
        IF flete_sugerido.Origen = "ATE" THEN DO:
            FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = flete_sugerido.codcia 
                AND TabGener.Clave = 'ZG_DIVI'
                AND TabGener.Codigo = flete_sugerido.Destino:
                FIND FacTabla WHERE FacTabla.CodCia = flete_sugerido.CodCia 
                    AND FacTabla.Tabla = 'FLETE'
                    AND FacTabla.Codigo = TabGener.Libre_c01        /* División */
                    NO-LOCK NO-ERROR.
                IF AVAILABLE FacTabla THEN DO:
                    FIND CURRENT FacTabla EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    ASSIGN
                        FacTabla.Valor[1] = flete_sugerido.Flete_Sugerido_Peso
                        FacTabla.Valor[2] = flete_sugerido.Flete_Sugerido_Volumen
                        .
                    RELEASE FacTabla.
                END.
            END.
        END.
        GET NEXT {&browse-name}.
    END.
END.
RETURN 'OK'.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Flete-Sugerido B-table-Win 
PROCEDURE Carga-Flete-Sugerido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER TABLE FOR t-FacTabla.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pCuenta AS INTE NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    EMPTY TEMP-TABLE t-flete_sugerido.

    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE flete_sugerido:
        /* Se va a sacar el promedio aritmético tomando como dato el destino */
        CREATE t-flete_sugerido.
        BUFFER-COPY flete_sugerido TO t-flete_sugerido.

        GET NEXT {&browse-name}.
    END.

    {logis/i-flete-supervisor.i &Fletes="t-FacTabla"}

END.

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
      flete_sugerido.FchModificacion = TODAY
      flete_sugerido.HoraModificacion = STRING(TIME, 'HH:MM:SS')
      flete_sugerido.UsrModificacion = s-user-id
      .

  RUN Procesa-Handle IN lh_handle ('Actualiza-Fletes').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE flete_sugerido:
        FIND CURRENT flete_sugerido EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            flete_sugerido.FchRechazo = TODAY
            flete_sugerido.FlgEst = "R"
            flete_sugerido.HoraRechazo = STRING(TIME,'HH:MM:SS') 
            flete_sugerido.UsrRechazo = s-User-Id.

        GET NEXT {&browse-name}.
    END.
END.
RETURN 'OK'.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "flete_sugerido"}
  {src/adm/template/snd-list.i "Origen"}
  {src/adm/template/snd-list.i "Destino"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fActualPeso B-table-Win 
FUNCTION fActualPeso RETURNS DECIMAL
  ( INPUT  pOrigen AS CHAR, INPUT pDestino AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER b-Sugerido FOR flete_sugerido.

  FIND LAST b-Sugerido USE-INDEX Idx02 WHERE b-Sugerido.codcia = s-codcia
      AND b-Sugerido.origen = pOrigen
      AND b-Sugerido.destino = pDestino
      AND b-Sugerido.flgest = "A"
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-Sugerido THEN RETURN b-Sugerido.flete_sugerido_peso.
  /* Si no hay histórico entonces tomamos el valor de la tabla de fletes */
  FOR EACH TabGener WHERE TabGener.Codigo = pDestino
      AND TabGener.CodCia = s-codcia
      AND TabGener.Clave ='ZG_DIVI' NO-LOCK,
      FIRST GN-DIVI WHERE GN-DIVI.CodCia = TabGener.CodCia
      AND GN-DIVI.CodDiv = TabGener.Libre_c01 NO-LOCK,
      FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia 
          AND FacTabla.Tabla = "FLETE"
          AND FacTabla.Codigo = TabGener.Libre_c01
          AND GN-DIVI.Campo-Log[4] = TRUE NO-LOCK:
      RETURN FacTabla.Valor[1].
  END.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fActualVolumen B-table-Win 
FUNCTION fActualVolumen RETURNS DECIMAL
  ( INPUT  pOrigen AS CHAR, INPUT pDestino AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER b-Sugerido FOR flete_sugerido.

  FIND LAST b-Sugerido USE-INDEX Idx02 WHERE b-Sugerido.codcia = s-codcia
      AND b-Sugerido.origen = pOrigen
      AND b-Sugerido.destino = pDestino
      AND b-Sugerido.flgest = "A"
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-Sugerido THEN RETURN b-Sugerido.flete_sugerido_volumen.
  /* Si no hay histórico entonces tomamos el valor de la tabla de fletes */
  FOR EACH TabGener WHERE TabGener.Codigo = pDestino
      AND TabGener.CodCia = s-codcia
      AND TabGener.Clave ='ZG_DIVI' NO-LOCK,
      FIRST GN-DIVI WHERE GN-DIVI.CodCia = TabGener.CodCia
      AND GN-DIVI.CodDiv = TabGener.Libre_c01 NO-LOCK,
      FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia 
          AND FacTabla.Tabla = "FLETE"
          AND FacTabla.Codigo = TabGener.Libre_c01
          AND GN-DIVI.Campo-Log[4] = TRUE NO-LOCK:
      RETURN FacTabla.Valor[2].
  END.

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

