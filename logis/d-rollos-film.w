&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-VtaTabla FOR VtaTabla.
DEFINE TEMP-TABLE tVtaTabla NO-UNDO LIKE VtaTabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE SHARED VAR s-codcia AS INT.

DEF OUTPUT PARAMETER pRollos AS DEC.
DEF OUTPUT PARAMETER pOk AS LOG NO-UNDO.
DEF INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.    /* HPK, O/D, OTR*/
DEF INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.

DEFINE VAR cCodOrden AS CHAR NO-UNDO.
DEFINE VAR cNroOrden AS CHAR NO-UNDO.
DEFINE VAR iTotalBultosOrden AS INT NO-UNDO.

DEFINE BUFFER xvtacdocu FOR vtacdocu.

cCodOrden = pCodDoc.     /* O/D OTR */
cNroOrden = pNroDoc.

IF pCodDoc = "HPK"  THEN DO:
    FIND FIRST xvtacdocu WHERE xvtacdocu.codcia = s-codcia AND 
        xvtacdocu.codped = pCoddoc AND
        xvtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xvtacdocu THEN DO:
        MESSAGE "No existe el documento " + pCodDoc + " - " + pNroDoc SKIP
                "en la tabla vtacdocu" VIEW-AS ALERT-BOX INFORMATION.
        RETURN ERROR.
    END.
    cCodOrden = xvtacdocu.codref.     /* O/D OTR */
    cNroOrden = xvtacdocu.nroref.
    
    FOR EACH Ccbcbult WHERE CcbCBult.CodCia = xVtaCDocu.CodCia 
        AND CcbCBult.CodDoc = xVtaCDocu.CodRef 
        AND CcbCBult.NroDoc = xVtaCDocu.NroRef
        AND ENTRY(1,CcbCBult.Chr_05) = pCodDoc
        AND ENTRY(2,CcbCBult.Chr_05) = pNroDoc:
        iTotalBultosOrden = iTotalBultosOrden + CcbCBult.Bultos.
    END.
END.
ELSE DO:
    FOR EACH Ccbcbult WHERE CcbCBult.CodCia = xVtaCDocu.CodCia 
        AND CcbCBult.CodDoc = pCodDoc
        AND CcbCBult.NroDoc = pNroDoc NO-LOCK:
        iTotalBultosOrden = iTotalBultosOrden + CcbCBult.Bultos.
    END.
    IF iTotalBultosOrden = 0 THEN iTotalBultosOrden = -1.
END.
pOk = NO.
pRollos = 0.

DEFINE VAR x-vtatabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "LOGISTICA".
DEFINE VAR x-llave_c2 AS CHAR INIT "PICKING".
DEFINE VAR x-llave_c3 AS CHAR INIT "EMBALADO-ESPECIAL".

DEFINE BUFFER xtvtatabla FOR tvtatabla.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-17

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tVtaTabla

/* Definitions for BROWSE BROWSE-17                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-17 tVtaTabla.Llave_c4 ~
tVtaTabla.Llave_c5 tVtaTabla.Valor[1] tVtaTabla.Valor[2] tVtaTabla.Valor[3] ~
tVtaTabla.Valor[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-17 tVtaTabla.Valor[3] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-17 tVtaTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-17 tVtaTabla
&Scoped-define QUERY-STRING-BROWSE-17 FOR EACH tVtaTabla NO-LOCK ~
    BY tVtaTabla.Llave_c5 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-17 OPEN QUERY BROWSE-17 FOR EACH tVtaTabla NO-LOCK ~
    BY tVtaTabla.Llave_c5 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-17 tVtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-17 tVtaTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-17}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-17 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Rollos FILL-IN-bultos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "Cancel" 
     SIZE 15 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "OK" 
     SIZE 15 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-16 
     LABEL "Refrescar referencia de consumo" 
     SIZE 27.14 BY 1.12.

DEFINE VARIABLE FILL-IN-bultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1.73
     BGCOLOR 10 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Rollos AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY 1.73
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-17 FOR 
      tVtaTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-17 W-Win _STRUCTURED
  QUERY BROWSE-17 NO-LOCK DISPLAY
      tVtaTabla.Llave_c4 COLUMN-LABEL "Sec" FORMAT "x(8)":U WIDTH 7.57
      tVtaTabla.Llave_c5 COLUMN-LABEL "Descripcion" FORMAT "x(80)":U
            WIDTH 45.43
      tVtaTabla.Valor[1] COLUMN-LABEL "Por cada!(Unidades)" FORMAT ">>>,>>9.99":U
            WIDTH 7.43
      tVtaTabla.Valor[2] COLUMN-LABEL "Usar!(Metros)" FORMAT "->>,>>9.99":U
            WIDTH 7.43
      tVtaTabla.Valor[3] COLUMN-LABEL "Bultos" FORMAT ">>>,>>9":U
            COLUMN-FONT 6
      tVtaTabla.Valor[4] COLUMN-LABEL "Total mts." FORMAT ">>>,>>>,>>9":U
            WIDTH 9.43 COLUMN-FONT 6 LABEL-FONT 6
  ENABLE
      tVtaTabla.Valor[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 17.5
         FONT 4
         TITLE "Referencias de consumo de FILM" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Rollos AT ROW 1.81 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-bultos AT ROW 1.88 COL 87.86 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BROWSE-17 AT ROW 4.23 COL 3.86 WIDGET-ID 300
     Btn_OK AT ROW 6.38 COL 97 WIDGET-ID 10
     Btn_Cancel AT ROW 8.54 COL 97 WIDGET-ID 8
     BUTTON-16 AT ROW 22.27 COL 4 WIDGET-ID 14
     "Bultos" VIEW-AS TEXT
          SIZE 12 BY 1.92 AT ROW 1.81 COL 77 WIDGET-ID 18
          FONT 8
     "Metros de Film usados" VIEW-AS TEXT
          SIZE 39.14 BY 1.92 AT ROW 1.73 COL 4.86 WIDGET-ID 12
          FONT 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.57 BY 22.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-VtaTabla B "?" ? INTEGRAL VtaTabla
      TABLE: tVtaTabla T "?" NO-UNDO INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Cierre de embalaje"
         HEIGHT             = 22.77
         WIDTH              = 116.57
         MAX-HEIGHT         = 22.77
         MAX-WIDTH          = 127.43
         VIRTUAL-HEIGHT     = 22.77
         VIRTUAL-WIDTH      = 127.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-17 FILL-IN-bultos F-Main */
/* SETTINGS FOR BUTTON BUTTON-16 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-16:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-bultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Rollos IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-17
/* Query rebuild information for BROWSE BROWSE-17
     _TblList          = "Temp-Tables.tVtaTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tVtaTabla.Llave_c5|yes"
     _FldNameList[1]   > Temp-Tables.tVtaTabla.Llave_c4
"tVtaTabla.Llave_c4" "Sec" ? "character" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tVtaTabla.Llave_c5
"tVtaTabla.Llave_c5" "Descripcion" "x(80)" "character" ? ? ? ? ? ? no ? no no "45.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tVtaTabla.Valor[1]
"tVtaTabla.Valor[1]" "Por cada!(Unidades)" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tVtaTabla.Valor[2]
"tVtaTabla.Valor[2]" "Usar!(Metros)" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tVtaTabla.Valor[3]
"tVtaTabla.Valor[3]" "Bultos" ">>>,>>9" "decimal" ? ? 6 ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tVtaTabla.Valor[4]
"tVtaTabla.Valor[4]" "Total mts." ">>>,>>>,>>9" "decimal" ? ? 6 ? ? 6 no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-17 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Cierre de embalaje */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Cierre de embalaje */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-17
&Scoped-define SELF-NAME BROWSE-17
&Scoped-define SELF-NAME tVtaTabla.Valor[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tVtaTabla.Valor[3] BROWSE-17 _BROWSE-COLUMN W-Win
ON LEAVE OF tVtaTabla.Valor[3] IN BROWSE BROWSE-17 /* Bultos */
OR RETURN OF tvtatabla.Valor[3]
DO:

 DEFINE VAR iBultos AS INT.

 iBultos = DECIMAL(tVtaTabla.Valor[3]:SCREEN-VALUE IN BROWSE browse-17).
 IF iBultos >= 0 THEN DO:
     FIND FIRST xtVtaTabla WHERE ROWID(xtVtaTabla) = ROWID(tVtaTabla) EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE xtVtatabla THEN DO:
         xtVtaTabla.Valor[3] = DECIMAL(tVtaTabla.Valor[3]:SCREEN-VALUE IN BROWSE browse-17).
         xtVtaTabla.Valor[4] = DECIMAL(tVtaTabla.Valor[2]:SCREEN-VALUE IN BROWSE browse-17) *
             DECIMAL(tVtaTabla.Valor[3]:SCREEN-VALUE IN BROWSE browse-17).      
         DISPLAY xtVtaTabla.Valor[4] @ tVtaTabla.Valor[4] WITH BROWSE browse-17 NO-ERROR.

         RUN Totales.
     END.
 END.
 ELSE DO:
     MESSAGE "Ingrese valores positivos" 
         VIEW-AS ALERT-BOX INFORMATION.
 END.

END.
/*
  FIND b-VtaTabla WHERE ROWID(b-VtaTabla) = ROWID(VtaTabla) EXCLUSIVE-LOCK.
  b-VtaTabla.Valor[4] = DECIMAL(VtaTabla.Valor[2]:SCREEN-VALUE IN BROWSE {&browse-name}) *
      DECIMAL(VtaTabla.Valor[3]:SCREEN-VALUE IN BROWSE {&browse-name}).
  DISPLAY b-VtaTabla.Valor[4] @ VtaTabla.Valor[4] WITH BROWSE {&browse-name}.
  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancel */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* OK */
DO:
  ASSIGN FILL-IN-Rollos fill-in-bultos.
  IF FILL-IN-Rollos <= 0 THEN DO:
      MESSAGE 'NO ha ingresado la cantidad de rollos' SKIP
          'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN NO-APPLY.
  END.

  IF iTotalBultosOrden > 0 THEN DO:
      IF FILL-IN-bultos <> iTotalBultosOrden THEN DO:
          MESSAGE 'La cantidad de bultos de la orden difiere del checking' VIEW-AS ALERT-BOX INFORMATION.
          RETURN NO-APPLY.
      END.
  END.

 RUN grabar-datos.

  pOk = YES.
  pRollos = FILL-IN-Rollos.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  /*RETURN NO-APPLY.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* Refrescar referencia de consumo */
DO:
  {&query-open-browse-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-referencias W-Win 
PROCEDURE carga-referencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tVtatabla.

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = x-vtatabla AND
                        vtatabla.llave_c1 = x-llave_c1 AND vtatabla.llave_c2 = x-llave_c2 AND
                        vtatabla.llave_c3 = x-llave_c3 NO-LOCK:

    CREATE tVtatabla.
    BUFFER-COPY vtatabla TO tVtatabla.
    ASSIGN tVtatabla.valor[3] = 0
            tVtatabla.valor[4] = 0.
END.

{&open-query-browse-17}


/*
DEFINE VAR x-vtatabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "LOGISTICA".
DEFINE VAR x-llave_c2 AS CHAR INIT "PICKING".
DEFINE VAR x-llave_c3 AS CHAR INIT "EMBALADO-ESPECIAL".
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-Rollos FILL-IN-bultos 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-17 Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-datos W-Win 
PROCEDURE grabar-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER bFacDliqu FOR facdliqu.

FOR EACH facdliqu WHERE facdliqu.codcia = 1 AND facdliqu.coddoc = cCodOrden AND
                        facdliqu.nrodoc = cNroOrden NO-LOCK:
    IF facdliqu.codref = pCodDoc AND facdliqu.nroref = pNroDoc  THEN DO:
        FIND FIRST bfacdliqu WHERE ROWID(bfacdliqu) = ROWID(facdliqu) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE bfacdliqu THEN DO:
            DELETE bfacdliqu.
        END.
        RELEASE bfacdliqu.
    END.
END.

FOR EACH tVtatabla WHERE tVtatabla.valor[3] > 0 NO-LOCK:
    CREATE bFacDliqu.
    ASSIGN  bFacDliqu.codcia = 1
        bFacDliqu.coddoc = cCodOrden
        bFacDliqu.nrodoc = cNroOrden
        bFacDliqu.codmat = tvtatabla.llave_c4
        bFacDliqu.fchdoc = TODAY
        bFacDliqu.flg_Factor = STRING(TIME,"HH:MM:SS")
        bFacDliqu.codcli = USERID("DICTDB")
        bFacDliqu.codref = pCodDoc
        bFacDliqu.nroref = pNroDoc
        bFacDliqu.UndVta = tvtatabla.llave_c5
        bFacDliqu.prevta[1] = tvtatabla.valor[1]
        bFacDliqu.prevta[2] = tvtatabla.valor[2]
        bFacDliqu.prevta[3] = tvtatabla.valor[3]
        bFacDliqu.implin = tvtatabla.valor[4]
        .
END.


/*
DEF INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.    /* HPK */
DEF INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.

DEFINE BUFFER xvtacdocu FOR vtacdocu.

FIND FIRST xvtacdocu WHERE xvtacdocu.codcia = s-codcia AND 
    xvtacdocu.codped = pCoddoc AND
    xvtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE xvtacdocu THEN DO:
    MESSAGE "No existe el documento " + pCodDoc + " - " + pNroDoc SKIP
            "en la tabla vtacdocu" VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

DEFINE VAR cCodOrden AS CHAR NO-UNDO.
DEFINE VAR cNroOrden AS CHAR NO-UNDO.
DEFINE VAR iTotalBultosOrden AS INT NO-UNDO.

cCodOrden = xvtacdocu.codref.     /* O/D OTR */
cNroOrden = xvtacdocu.nroref.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN carga-referencias.
  RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tVtaTabla"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-Rollos = 0.    
FILL-IN-bultos = 0.    
/*
FOR EACH b-VtaTabla NO-LOCK WHERE b-VtaTabla.codcia = s-codcia and
    b-VtaTabla.tabla = x-VtaTabla and
    b-VtaTabla.llave_c1 = x-llave_c1 and
    b-VtaTabla.llave_c2 = x-llave_c2 and
    b-VtaTabla.llave_c3 = x-llave_c3:
    FILL-IN-Rollos = FILL-IN-Rollos + b-VtaTabla.Valor[4].
END.
*/
FOR EACH xtVtaTabla NO-LOCK:    
    FILL-IN-Rollos = FILL-IN-Rollos + xtVtaTabla.Valor[4].
    FILL-IN-bultos = FILL-IN-bultos + xtVtaTabla.Valor[3].
END.

DISPLAY FILL-IN-Rollos WITH FRAME {&FRAME-NAME}.
DISPLAY FILL-IN-bultos WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

