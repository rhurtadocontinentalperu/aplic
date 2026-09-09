&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE BOLETA NO-UNDO LIKE CcbCDocu
       INDEX Llave01 AS PRIMARY NroMes.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR s-coddiv  AS CHAR.

FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.

IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'La division(' + s-coddiv + ") No existe!!!"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

IF gn-divi.campo-log[1] = YES THEN DO:
    MESSAGE 'La division(' + s-coddiv + ") esta INACTIVA!!!"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES BOLETA gn-clie

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 BOLETA.CodDiv BOLETA.FchAte ~
BOLETA.FmaPgo BOLETA.FlgAte BOLETA.NroRef BOLETA.TpoFac BOLETA.CodCta ~
BOLETA.CodAge BOLETA.ImpTot BOLETA.CodCli gn-clie.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH BOLETA NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = BOLETA.CodCli OUTER-JOIN NO-LOCK ~
    BY BOLETA.NroMes INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH BOLETA NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = BOLETA.CodCli OUTER-JOIN NO-LOCK ~
    BY BOLETA.NroMes INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 BOLETA gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 BOLETA
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone BUTTON-Importar BUTTON-Generar ~
BROWSE-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7.57 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Generar 
     LABEL "GENERA BD" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-Importar 
     LABEL "IMPORTAR EXCEL" 
     SIZE 16 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      BOLETA, 
      gn-clie
    FIELDS(gn-clie.NomCli) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      BOLETA.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U WIDTH 6.43
      BOLETA.FchAte COLUMN-LABEL "Fecha de !Depósito" FORMAT "99/99/9999":U
      BOLETA.FmaPgo FORMAT "X(8)":U WIDTH 9.14
      BOLETA.FlgAte COLUMN-LABEL "Banco" FORMAT "x(8)":U WIDTH 5.43
      BOLETA.NroRef COLUMN-LABEL "Nro. de!Depósito" FORMAT "X(12)":U
            WIDTH 11.72
      BOLETA.TpoFac COLUMN-LABEL "Efectivo/!Cheque" FORMAT "X(8)":U
            WIDTH 8.14
      BOLETA.CodCta FORMAT "X(10)":U WIDTH 8.43
      BOLETA.CodAge COLUMN-LABEL "Plaza" FORMAT "X(10)":U
      BOLETA.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 9.86
      BOLETA.CodCli FORMAT "x(11)":U WIDTH 10.86
      gn-clie.NomCli FORMAT "x(50)":U WIDTH 42.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 138 BY 22.88
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1 COL 133 WIDGET-ID 6
     BUTTON-Importar AT ROW 1.27 COL 3 WIDGET-ID 2
     BUTTON-Generar AT ROW 1.27 COL 19 WIDGET-ID 4
     BROWSE-5 AT ROW 2.62 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.43 BY 24.81
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: BOLETA T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY NroMes
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTACION DE BOLETAS DE DEPOSITO"
         HEIGHT             = 24.81
         WIDTH              = 141.43
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-5 BUTTON-Generar F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.BOLETA,INTEGRAL.gn-clie WHERE Temp-Tables.BOLETA ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER USED"
     _OrdList          = "Temp-Tables.BOLETA.NroMes|yes"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = Temp-Tables.BOLETA.CodCli"
     _FldNameList[1]   > Temp-Tables.BOLETA.CodDiv
"BOLETA.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.BOLETA.FchAte
"BOLETA.FchAte" "Fecha de !Depósito" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.BOLETA.FmaPgo
"BOLETA.FmaPgo" ? ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.BOLETA.FlgAte
"BOLETA.FlgAte" "Banco" "x(8)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.BOLETA.NroRef
"BOLETA.NroRef" "Nro. de!Depósito" ? "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.BOLETA.TpoFac
"BOLETA.TpoFac" "Efectivo/!Cheque" "X(8)" "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.BOLETA.CodCta
"BOLETA.CodCta" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.BOLETA.CodAge
"BOLETA.CodAge" "Plaza" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.BOLETA.ImpTot
"BOLETA.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.BOLETA.CodCli
"BOLETA.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(50)" "character" ? ? ? ? ? ? no ? no no "42.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTACION DE BOLETAS DE DEPOSITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTACION DE BOLETAS DE DEPOSITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Generar W-Win
ON CHOOSE OF BUTTON-Generar IN FRAME F-Main /* GENERA BD */
DO:
   MESSAGE 'Procedemos a generar las boletas?'
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.
   RUN Genera-Boletas.
   {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Importar W-Win
ON CHOOSE OF BUTTON-Importar IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
   RUN Importar-Excel.
   {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  ENABLE BtnDone BUTTON-Importar BUTTON-Generar BROWSE-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Boletas W-Win 
PROCEDURE Genera-Boletas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR s-NroSer LIKE Faccorre.nroser NO-UNDO.
DEF VAR s-coddoc  AS CHAR INIT "BD" NO-UNDO.

SESSION:SET-WAIT-STATE("General").

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE VAR x-nrodoc AS CHAR.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH BOLETA:
        ASSIGN
            s-CodDiv = BOLETA.CodDiv.
        FIND FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
            AND FacCorre.CodDiv = s-coddiv 
            AND FacCorre.CodDoc = s-coddoc 
            AND FacCorre.FlgEst = YES
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN DO:
            pMensaje = "NO configurado el correlativo para " + s-coddoc + " en la división " + s-coddiv.
            UNDO RLOOP, LEAVE RLOOP.
        END.
        s-NroSer = FacCorre.NroSer.
        /* Grabación */
        {lib/lock-genericov3.i
            &Tabla="Faccorre"
            &Condicion="FacCorre.CodCia = s-codcia ~
                AND FacCorre.CodDiv = s-coddiv ~
                AND FacCorre.CodDoc = s-coddoc ~
                AND FacCorre.NroSer = s-NroSer"
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
            &Accion="RETRY"
            &Mensaje="NO"
            &txtMensaje="pMensaje"
            &TipoError="UNDO RLOOP, LEAVE RLOOP"}
        /* Ic - 27Abr2018 - Verificar si el documento no se vaya a repetir */
        REPEAT:
            x-nrodoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999").
            FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                b-ccbcdocu.coddiv = s-CodDiv AND
                b-ccbcdocu.coddoc = s-CodDoc AND
                b-ccbcdocu.nrodoc = x-nrodoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE b-ccbcdocu THEN LEAVE.
            ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
        END.
        /* ************************************************************************************ */
        /* RHC 28/11/2019 Duplicados */
        /* ************************************************************************************ */
        DEF VAR pDuplicado AS LOG NO-UNDO.
        RUN ccb/p-estado-bd (INPUT "YES",
                             INPUT s-CodDoc,
                             INPUT "",
                             INPUT BOLETA.FlgAte,
                             INPUT BOLETA.NroRef,
                             INPUT BOLETA.FchAte,
                             INPUT BOLETA.ImpTot,
                             OUTPUT pDuplicado,
                             OUTPUT pMensaje).
        IF pDuplicado = YES THEN DO:
            UNDO RLOOP, LEAVE RLOOP.
        END.
        /* ************************************************************************************ */
        /* - */
        CREATE Ccbcdocu.
        BUFFER-COPY BOLETA TO Ccbcdocu
            ASSIGN
            Ccbcdocu.CodDoc = s-CodDoc
            Ccbcdocu.CodDiv = s-CodDiv
            Ccbcdocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
            Ccbcdocu.FchDoc = TODAY.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN
            Ccbcdocu.FlgEst = "E"       /* OJO -> Emitido */
            Ccbcdocu.FlgSit = "Pendiente"
            Ccbcdocu.FchUbi = ?
            Ccbcdocu.FlgUbi = ""
            CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
            Ccbcdocu.usuario= s-user-id
            Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN Ccbcdocu.TpoCmb = gn-tcmb.compra.
        /* FIN DE GRABACION */
        DELETE BOLETA.
    END.
END.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
RELEASE FacCorre.
RELEASE Ccbcdocu.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel W-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFIleXls   AS CHAR NO-UNDO.
DEF VAR x-Archivo  AS CHAR NO-UNDO.

DEFINE VAR OKpressed AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
    MUST-EXIST
    TITLE "Seleccione archivo..."
    UPDATE OKpressed.   

IF OKpressed = NO THEN RETURN.
lFileXls = x-Archivo.
lNuevoFile = NO.

{lib/excel-open-file.i}
chExcelApplication:Visible = FALSE.
lMensajeAlTerminar = YES.
lCerrarAlTerminar = YES.

DEF VAR t-Col AS INT NO-UNDO.
DEF VAR t-Row AS INT NO-UNDO.
DEF VAR cValue AS CHAR NO-UNDO.
DEF VAR fValue AS DATE NO-UNDO.
DEF VAR dValue AS DEC  NO-UNDO.

ASSIGN
    t-Col = 0
    t-Row = 1.    
EMPTY TEMP-TABLE BOLETA.
SESSION:SET-WAIT-STATE('GENERAL').
REPEAT:
    ASSIGN
        t-Col = 0
        t-Row = t-Row + 1.
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* División */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = cValue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN NEXT.
    CREATE BOLETA.
    ASSIGN
        BOLETA.nromes = t-Row
        BOLETA.codcia = s-codcia
        BOLETA.coddiv = cValue
        BOLETA.coddoc = "BD"
        BOLETA.fchdoc = TODAY.
    /* Fecha de depósito */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN fValue = DATE(cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Fecha de Depósito errada' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    ASSIGN
        BOLETA.FchAte = fValue.
    /* Condición de Venta */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    IF cValue > '' AND NOT CAN-FIND(gn-ConVt WHERE gn-ConVt.Codig = cValue NO-LOCK) THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Condición de Venta errada' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    ASSIGN
        BOLETA.FmaPgo = cValue.
    /* Banco */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    IF NOT CAN-FIND(cb-tabl WHERE cb-tabl.tabla = '04' AND cb-tabl.codigo = cValue NO-LOCK)
        THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Banco errado' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    ASSIGN
        BOLETA.FlgAte = cValue.
    /* Nro depósito */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    /* Tomamos los 6 caracteres de la derecha */
    cValue = TRIM(cValue).
    IF LENGTH(cValue) > 6 THEN DO:
        cValue = SUBSTRING(cValue, LENGTH(cValue) - 5, 6).
    END.
    ASSIGN
        BOLETA.NroRef = cValue.
    /* Efectivo o Cheque */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    CASE TRUE:
        WHEN CAPS(cValue) = "EFECTIVO" THEN cValue = "EFE".
        WHEN CAPS(cValue) = "CHEQUE"   THEN cValue = "CHQ".
        OTHERWISE DO:
            MESSAGE 'ERROR en la línea' t-Row SKIP
                'Efectivo/Cheque errada' VIEW-AS ALERT-BOX ERROR.
            DELETE BOLETA.
            NEXT.
        END.
    END CASE.
    ASSIGN
        BOLETA.TpoFac = cValue.
    /* Cuenta */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.Codcta = cValue
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Cuenta errada' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    BOLETA.CodCta = cValue.
    BOLETA.CodMon = cb-ctas.Codmon.
    BOLETA.Glosa = cb-ctas.Nomcta. 
    /* Plaza */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    IF LOOKUP(cValue, 'Lima,Provincia,Otros') = 0 THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Plaza errada' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    ASSIGN
        BOLETA.CodAge = cValue.
    /* Importe */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR OR dValue <= 0 THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Importe errado' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    ASSIGN
        BOLETA.ImpTot = dValue.
    /* Cliente */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN cValue = STRING(INT64(CVALUE),'99999999999') NO-ERROR.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND gn-clie.CodCli = cValue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'ERROR en la línea' t-Row cValue SKIP
            'Cliente errado' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    BOLETA.CodCli = cValue.
    BOLETA.NomCli = gn-clie.nomcli.
    BOLETA.DirCli = gn-clie.dircli.
    BOLETA.RucCli = gn-clie.ruc.
    /* Consistencias finales */
    IF CAN-FIND(FIRST Ccbcdocu WHERE Ccbcdocu.CodCia = S-CODCIA 
                AND Ccbcdocu.CodDoc = "BD"
                AND Ccbcdocu.FlgAte = BOLETA.FlgAte
                AND Ccbcdocu.NroRef = BOLETA.NroRef
                AND Ccbcdocu.FchAte = BOLETA.FchAte
                AND LOOKUP(Ccbcdocu.FlgEst, "A,X") = 0 
                NO-LOCK)
        THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Número de depósito ya existe ' BOLETA.NroRef VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
    DEF VAR pFchCie AS DATE NO-UNDO.
    RUN gn/fFchCieCbd.p ("CREDITOS", OUTPUT pFchCie).
    IF BOLETA.FchAte > TODAY OR BOLETA.FchAte < pFchCie THEN DO:
        MESSAGE 'ERROR en la línea' t-Row SKIP
            'Fecha de Depósito errada' VIEW-AS ALERT-BOX ERROR.
        DELETE BOLETA.
        NEXT.
    END.
END.
SESSION:SET-WAIT-STATE('').

{lib/excel-close-file.i}

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
  {src/adm/template/snd-list.i "BOLETA"}
  {src/adm/template/snd-list.i "gn-clie"}

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

