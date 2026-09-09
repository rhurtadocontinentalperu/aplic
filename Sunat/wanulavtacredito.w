&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.

&SCOPED-DEFINE Condicion Ccbcdocu.codcia = s-codcia ~
AND Ccbcdocu.coddiv = s-coddiv ~
AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 ~
AND Ccbcdocu.fchdoc = TODAY ~
AND Ccbcdocu.flgest = "P" ~
AND Ccbcdocu.imptot = Ccbcdocu.sdoact    

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR ix AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-6 BUTTON-7 COMBO-NroSer BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer FILL-IN-Correlativo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-6 
     LABEL "ANULACION DOCUMENTARIA" 
     SIZE 31 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Seleccione la Serie de la N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Correlativo AS INTEGER FORMAT "99999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10
      CcbCDocu.NomCli FORMAT "x(60)":U WIDTH 51.43
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 9.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 21.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-6 AT ROW 1 COL 26 WIDGET-ID 4
     BUTTON-7 AT ROW 1 COL 57 WIDGET-ID 6
     COMBO-NroSer AT ROW 2.35 COL 24 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Correlativo AT ROW 2.35 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     BROWSE-2 AT ROW 3.5 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.57 BY 24.58
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: T-CDOCU T "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ANULACION Y REGENERACION DE COMPROBANTES POR VENTA CREDITO"
         HEIGHT             = 24.58
         WIDTH              = 94.57
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
/* BROWSE-TAB BROWSE-2 FILL-IN-Correlativo F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Correlativo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "51.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ANULACION Y REGENERACION DE COMPROBANTES POR VENTA CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANULACION Y REGENERACION DE COMPROBANTES POR VENTA CREDITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* ANULACION DOCUMENTARIA */
DO:
  ASSIGN COMBO-NroSer.
  MESSAGE 'Se va a Proceder a la anulación documentaria' SKIP
      'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Genera-Comprobantes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* REFRESCAR */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Seleccione la Serie de la N/C */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = "N/C" AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN FILL-IN-Correlativo = FacCorre.Correlativo.
    DISPLAY FILL-IN-Correlativo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY COMBO-NroSer FILL-IN-Correlativo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-6 BUTTON-7 COMBO-NroSer BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobantes W-Win 
PROCEDURE Genera-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Filtros de Control */
IF NOT AVAILABLE Ccbcdocu THEN RETURN.

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

pMensaje = "".
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Bloqueamos el comprobante */
    FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(Ccbcdocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        pMensaje = "NO se pudo bloquear el Comprobante".
        UNDO, LEAVE.
    END.

    EMPTY TEMP-TABLE T-CDOCU.
    pMensaje = ''.
    /* 1ro. N/C x Devolucion */
    RUN Genera-NC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = '' THEN pMensaje = 'ERROR al generar la N/C x devolución'.
        UNDO, LEAVE.
    END.

    /* 2do. Nuevas FAC */
    RUN Genera-FAC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = '' THEN pMensaje = 'ERROR al generar la N/C x devolución'.
        UNDO, LEAVE.
    END.

    /* 3ro Cancelamos el comprobante orginal */
    ASSIGN
        B-CDOCU.FlgEst = "C"
        B-CDOCU.SdoAct = 0
        B-CDOCU.FchCan = TODAY.
    FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.coddoc = "N/C":
        /* Cancelamos el Comprobante */
        CREATE Ccbdcaja.
        ASSIGN
            CcbDCaja.CodCia = B-CDOCU.codcia
            CcbDCaja.CodDiv = s-coddiv
            CcbDCaja.CodDoc = T-CDOCU.coddoc
            CcbDCaja.NroDoc = T-CDOCU.nrodoc
            CcbDCaja.CodRef = B-CDOCU.coddoc
            CcbDCaja.NroRef = B-CDOCU.nrodoc
            CcbDCaja.CodCli = B-CDOCU.codcli
            CcbDCaja.CodMon = B-CDOCU.codmon
            CcbDCaja.FchDoc = TODAY
            CcbDCaja.ImpTot = B-CDOCU.imptot
            CcbDCaja.TpoCmb = B-CDOCU.tpocmb.
        /* Cancelamos N/C */
        CREATE Ccbdmov.
        ASSIGN
            CCBDMOV.CodCia = T-CDOCU.codcia
            CCBDMOV.CodDiv = T-CDOCU.coddiv
            CCBDMOV.CodDoc = T-CDOCU.coddoc
            CCBDMOV.NroDoc = T-CDOCU.nrodoc
            CCBDMOV.CodRef = T-CDOCU.coddoc
            CCBDMOV.NroRef = T-CDOCU.nrodoc
            CCBDMOV.FchDoc = T-CDOCU.fchdoc
            CCBDMOV.FchMov = TODAY
            CCBDMOV.CodCli = T-CDOCU.codcli
            CCBDMOV.CodMon = T-CDOCU.codmon
            CCBDMOV.HraMov = STRING(TIME, 'HH:MM:SS')
            CCBDMOV.ImpTot = T-CDOCU.imptot
            CCBDMOV.TpoCmb = T-CDOCU.tpocmb
            CCBDMOV.usuario = s-user-id.
    END.
END.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
IF AVAILABLE(Almcmov)  THEN RELEASE Almcmov.
IF AVAILABLE(Almdmov)  THEN RELEASE Almdmov.
IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.

IF pMensaje <> '' THEN DO:
    MESSAGE pMensaje SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
    
pMensaje = 'Se han generado los siguientes documentos:' + CHR(10).
FOR EACH T-CDOCU NO-LOCK:
    pMensaje = pMensaje + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10).
END.
MESSAGE pMensaje VIEW-AS ALERT-BOX INFORMATION.

{&OPEN-QUERY-{&BROWSE-NAME}}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-FAC W-Win 
PROCEDURE Genera-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF VAR s-CodDoc AS CHAR NO-UNDO.
DEF VAR s-PtoVta AS INT NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    s-CodDoc = B-CDOCU.CodDoc.
    x-Formato = '999-999999'.
    RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
    /* Buscamos correlativo */
    s-PtoVta = INTEGER(SUBSTRING(B-CDOCU.nrodoc,1,3)).
    /* Correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-PtoVta" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'" }
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU
        EXCEPT B-CDOCU.codref B-CDOCU.nroref      /* NO las G/R */
        TO Ccbcdocu
        ASSIGN
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
/*         CcbCDocu.FchDoc = TODAY */
/*         CcbCDocu.FchVto = TODAY */
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm').
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        CREATE Ccbddocu.
        BUFFER-COPY B-DDOCU
            TO Ccbddocu
            ASSIGN
            CcbDDocu.CodCia = Ccbcdocu.codcia
            CcbDDocu.CodDiv = Ccbcdocu.coddiv
            CcbDDocu.CodDoc = Ccbcdocu.coddoc
            CcbDDocu.NroDoc = Ccbcdocu.nrodoc
            CcbDDocu.FchDoc = CcbCDocu.FchDoc.
    END.
    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
    /* ************************************* */
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO trloop, RETURN 'ADM-ERROR'.
    /* *********************************************************** */
    /* Descarga de Almacen */
    RUN vta2/act_almv2 ( INPUT ROWID(CcbCDocu), OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.

    CREATE T-CDOCU.
    BUFFER-COPY Ccbcdocu TO T-CDOCU.
    
    CATCH eBlockError AS PROGRESS.Lang.Error:
        IF pMensaje = '' AND eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
        END.
        DELETE OBJECT eBlockError.
        RETURN 'ADM-ERROR'.
    END CATCH.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC W-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR S-CODDOC AS CHAR INIT "N/C" NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

s-NroSer = COMBO-NroSer.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    pMensaje = "ERROR correlativo " + s-coddoc + " serie " + STRING(s-nroser).
    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
    pMensaje = "".
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU
        EXCEPT B-CDOCu.CodRef B-CDOCU.NroRef B-CDOCU.Glosa B-CDOCU.NroOrd
        TO CcbCDocu
        ASSIGN 
        CcbCDocu.CodCia = S-CODCIA
        CcbCDocu.CodDiv = S-CODDIV
        CcbCDocu.CodDoc = S-CODDOC
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                          STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        CcbCDocu.CodRef = B-CDOCU.coddoc
        CcbCDocu.NroRef = B-CDOCU.nrodoc
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.CndCre = 'D'
        CcbCDocu.Tpofac = ""
        CcbCDocu.Tipo   = "OFICINA"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.SdoAct = B-CDOCU.ImpTot
        CcbCDocu.ImpTot2 = 0
        CcbCDocu.ImpDto2 = 0
        CcbCDocu.CodMov = 09.     /* INGRESO POR DEVOLUCION DEL CLIENTE */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = Ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        CREATE Ccbddocu.
        BUFFER-COPY B-DDOCU
            TO Ccbddocu
            ASSIGN
            CcbDDocu.CodCia = CcbCDocu.CodCia 
            CcbDDocu.Coddiv = CcbCDocu.Coddiv 
            CcbDDocu.CodDoc = CcbCDocu.CodDoc 
            CcbDDocu.NroDoc = CcbCDocu.NroDoc
            CcbDDocu.FchDoc = CcbCDocu.FchDoc.
    END.

    RUN vta2/ing-devo-utilex (ROWID(Ccbcdocu)).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        pMensaje = 'NO se pudo generar el movimiento de devolución el el almacén'.
        UNDO, RETURN "ADM-ERROR".
    END.

    {vta/graba-totales-abono.i}

    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'NO se pudo generar las percepciones'.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Las N/C nacen APLICADAS */
    ASSIGN
        Ccbcdocu.flgest = "C"
        Ccbcdocu.fchcan = TODAY
        Ccbcdocu.sdoact = 0.
    /* ************************************* */
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* *********************************************************** */

    CREATE T-CDOCU.
    BUFFER-COPY Ccbcdocu TO T-CDOCU.
    CATCH eBlockError AS PROGRESS.Lang.Error:
        IF pMensaje = '' AND eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
        END.
        DELETE OBJECT eBlockError.
        RETURN 'ADM-ERROR'.
    END CATCH.
END.
RETURN 'OK'.

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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
      cListItems = "".
    FOR EACH FacCorre NO-LOCK WHERE 
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDiv = s-CodDiv AND 
        FacCorre.CodDoc = "N/C" AND
        FacCorre.FlgEst = YES:
        IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
        ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
    END.
    ASSIGN
        COMBO-NroSer:LIST-ITEMS = cListItems
        COMBO-NroSer = INTEGER(ENTRY(1,COMBO-NroSer:LIST-ITEMS)).
  END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO  COMBO-NroSer.

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

