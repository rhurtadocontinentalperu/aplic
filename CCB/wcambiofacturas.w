&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE Condicion B-CDOCU.codcia = s-codcia ~
AND LOOKUP(B-CDOCU.coddoc, 'FAC,BOL') > 0 ~
AND B-CDOCU.flgest = 'P' ~
AND B-CDOCU.imptot = B-CDOCU.sdoact ~
AND B-CDOCU.codcli = FILL-IN-CodCli:SCREEN-VALUE

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
&Scoped-define INTERNAL-TABLES B-CDOCU

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 B-CDOCU.FchDoc B-CDOCU.CodDoc ~
B-CDOCU.NroDoc B-CDOCU.NomCli B-CDOCU.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH B-CDOCU ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH B-CDOCU ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 B-CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 B-CDOCU


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-NroSerNC COMBO-BOX-CodMat ~
COMBO-BOX-CodDoc COMBO-BOX-NroSerFac FILL-IN-CodCli FILL-IN-FchDoc BROWSE-2 ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-NroSerNC FILL-IN-NroDocNC ~
COMBO-BOX-CodMat COMBO-BOX-CodDoc COMBO-BOX-NroSerFac FILL-IN-NroDocFac ~
FILL-IN-CodCli FILL-IN-NomCli FILL-IN-FchDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprobante a Generar" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Concepto" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSerFac AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSerNC AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie de la N/C" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Nuevos Comprobantes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDocFac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDocNC AS CHARACTER FORMAT "X(256)":U 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      B-CDOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      B-CDOCU.FchDoc FORMAT "99/99/9999":U
      B-CDOCU.CodDoc FORMAT "x(3)":U
      B-CDOCU.NroDoc FORMAT "X(12)":U
      B-CDOCU.NomCli FORMAT "x(50)":U
      B-CDOCU.ImpTot FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 103 BY 16.73
         TITLE "SELECCIONE LOS COMPROBANTES A CANJEAR" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-NroSerNC AT ROW 1.19 COL 30 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NroDocNC AT ROW 1.19 COL 50 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX-CodMat AT ROW 2.15 COL 30 COLON-ALIGNED WIDGET-ID 30
     COMBO-BOX-CodDoc AT ROW 3.12 COL 30 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-NroSerFac AT ROW 3.12 COL 46 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NroDocFac AT ROW 3.12 COL 66 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-CodCli AT ROW 4.08 COL 30 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NomCli AT ROW 4.08 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-FchDoc AT ROW 5.04 COL 30 COLON-ALIGNED WIDGET-ID 28
     BROWSE-2 AT ROW 6.19 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 1.38 COL 109 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 132.86 BY 22.27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 22.27
         WIDTH              = 132.86
         MAX-HEIGHT         = 22.27
         MAX-WIDTH          = 132.86
         VIRTUAL-HEIGHT     = 22.27
         VIRTUAL-WIDTH      = 132.86
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 FILL-IN-FchDoc F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDocFac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDocNC IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "B-CDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = Temp-Tables.B-CDOCU.FchDoc
     _FldNameList[2]   = Temp-Tables.B-CDOCU.CodDoc
     _FldNameList[3]   = Temp-Tables.B-CDOCU.NroDoc
     _FldNameList[4]   = Temp-Tables.B-CDOCU.NomCli
     _FldNameList[5]   = Temp-Tables.B-CDOCU.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* FILTRAR */
DO:
   {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDoc W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDoc IN FRAME F-Main /* Comprobante a Generar */
DO:
  DEF VAR k AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  j = COMBO-BOX-NroSerFac:NUM-ITEMS.
  DO k = 1 TO j:
      COMBO-BOX-NroSerFac:DELETE(1).
  END.
  FOR EACH faccorre NO-LOCK WHERE faccorre.codcia = s-codcia
      AND faccorre.coddoc = INPUT {&self-name}
      AND faccorre.coddiv = s-coddiv
      AND faccorre.flgest = YES
      BY faccorre.nroser DESC:
      COMBO-BOX-NroSerFac:ADD-LAST(STRING(faccorre.nroser, '999')).
      COMBO-BOX-NroSerFac:SCREEN-VALUE = STRING(faccorre.nroser, '999').
  END.
  APPLY 'VALUE-CHANGED' TO COMBO-BOX-NroSerFac.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerFac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerFac W-Win
ON VALUE-CHANGED OF COMBO-BOX-NroSerFac IN FRAME F-Main /* Serie */
DO:
  FIND faccorre WHERE faccorre.codcia = s-codcia
      AND faccorre.coddiv = s-coddiv
      AND faccorre.coddoc = COMBO-BOX-CodDoc:SCREEN-VALUE
      AND faccorre.nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK NO-ERROR.
  IF AVAILABLE faccorre THEN FILL-IN-NroDocFac:SCREEN-VALUE = STRING(faccorre.correlativo, '999999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerNC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerNC W-Win
ON VALUE-CHANGED OF COMBO-BOX-NroSerNC IN FRAME F-Main /* Serie de la N/C */
DO:
   FIND faccorre WHERE faccorre.codcia = s-codcia
      AND faccorre.coddiv = s-coddiv
      AND faccorre.coddoc = "N/C"
      AND faccorre.nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK NO-ERROR.
  IF AVAILABLE faccorre THEN FILL-IN-NroDocNC:SCREEN-VALUE = STRING(faccorre.correlativo, '999999').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN  FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Comprobantes W-Win 
PROCEDURE Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Bloqueamos correlativo */
    {lib/lock-generico.i &Tabla="FacCorre" ~
        &Condicion="Faccorre.codcia = s-codcia ~
        AND Faccorre.coddoc = COMBO-BOX-CodDoc ~
        AND Faccorre.nroser = COMBO-BOX-NroSerFac" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="ERROR"}

    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU
        TO Ccbcdocu
        ASSIGN
        Ccbcdocu.CodDiv = s-CodDiv
        Ccbcdocu.CodDoc = COMBO-BOX-CodDoc
        Ccbcdocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
        Ccbcdocu.FchDoc = FILL-IN-FchDoc
        Ccbcdocu.FlgEst = "P"
        Ccbcdocu.usuario = S-USER-ID.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FOR EACH Ccbddocu OF B-CDOCU NO-LOCK:
        CREATE B-DDOCU.
        BUFFER-COPY Ccbddocu
            TO B-DDOCU
            ASSIGN
            B-DDOCU.coddiv = Ccbcdocu.coddiv
            B-DDOCU.coddoc = Ccbcdocu.coddoc
            B-DDOCU.nrodoc = Ccbcdocu.nrodoc
            B-DDOCU.fchdoc = Ccbcdocu.fchdoc.
    END.

    {vta2/graba-totales-factura-cred.i}

    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    /* ************************************* */
    /* RHC 30-11-2006 Transferencia Gratuita */
    IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
    IF Ccbcdocu.sdoact <= 0 
    THEN ASSIGN
            Ccbcdocu.fchcan = FILL-IN-FchDoc
            Ccbcdocu.flgest = 'C'.
    /* OJO: NO DESCARGA ALMACEN */
/*     RUN vta2\act_alm (ROWID(CcbCDocu)).                                 */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'. */
    /* RHC 25-06-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */           
    RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES). 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-NC W-Win 
PROCEDURE Crea-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  Tabla: "Almacen"
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: "EXCLUSIVE-LOCK (NO-WAIT)"
  Accion: "RETRY" | "LEAVE"
  Mensaje: "YES" | "NO"
  TipoError: ""ADM-ERROR"" | "ERROR"
*/

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Bloqueamos correlativo */
    {lib/lock-generico.i &Tabla="FacCorre" ~
        &Condicion="Faccorre.codcia = s-codcia ~
        AND Faccorre.coddoc = 'N/C' ~
        AND Faccorre.nroser =  COMBO-BOX-NroSerNC" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="ERROR"}

    /* Crea nueva N/C */
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU TO Ccbcdocu
        ASSIGN
            Ccbcdocu.codcia = s-codcia
            Ccbcdocu.coddoc = 'N/C'
            Ccbcdocu.coddiv = s-coddiv
            Ccbcdocu.nrodoc = STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999')
            Ccbcdocu.fchdoc = FILL-IN-FchDoc       /* OJO */
            Ccbcdocu.usuario = s-user-id
            /*Ccbcdocu.cndcre = 'N'*/
            Ccbcdocu.cndcre = 'D'    /* POR DEVOLUCION: POR LAS ESTADISTICAS DE VENTAS */
            Ccbcdocu.tipo   = "OFICINA"
            Ccbcdocu.flgest = "P"
            Ccbcdocu.libre_c01 = COMBO-BOX-CodMat.
            /*Ccbcdocu.tpofac = "REBATE".*/
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    /* GENERAMOS EL DETALLE SIMILAR A LA FACTURA ORIGINAL */
    FOR EACH Ccbddocu OF B-CDOCU NO-LOCK:
        CREATE B-DDOCU.
        BUFFER-COPY Ccbddocu TO B-DDOCU
            ASSIGN
            B-DDOCU.coddoc = Ccbcdocu.coddoc
            B-DDOCU.nrodoc = Ccbcdocu.nrodoc
            B-DDOCU.coddiv = Ccbcdocu.coddiv
            B-DDOCU.fchdoc = Ccbcdocu.fchdoc.
    END.
    RUN Totales-NC.
    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    /* ************************************* */
    /* APLICAMOS LA NOTA DE CREDITO */
    FIND CURRENT B-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CDOCU THEN UNDO, RETURN ERROR.
    /* 1ro cancelamos el comprobante */
    CREATE Ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = Ccbcdocu.codcia
        CcbDCaja.CodDiv = s-coddiv
        CcbDCaja.CodDoc = Ccbcdocu.coddoc   /* N/C */
        CcbDCaja.NroDoc = Ccbcdocu.nrodoc
        CcbDCaja.CodRef = B-CDOCU.coddoc    /* FAC */
        CcbDCaja.NroRef = B-CDOCU.nrodoc
        CcbDCaja.FchDoc = FILL-IN-FchDoc
        CcbDCaja.CodCli = B-CDOCU.codcli
        CcbDCaja.CodMon = B-CDOCU.codmon
        CcbDCaja.ImpTot = B-CDOCU.sdoact
        CcbDCaja.TpoCmb = B-CDOCU.tpocmb.
    ASSIGN
        B-CDOCU.FchCan = FILL-IN-FchDoc
        B-CDOCU.FlgEst = "C"
        B-CDOCU.SdoAct = 0
        B-CDOCU.UsuAnu = s-user-id.
    /* 2do cancelamos la N/C */
    CREATE Ccbdmov.
    ASSIGN
        CCBDMOV.CodCia = Ccbcdocu.codcia
        CCBDMOV.CodCli = Ccbcdocu.codcli
        CCBDMOV.CodDiv = s-coddiv
        CCBDMOV.CodDoc = Ccbcdocu.coddoc    /* N/C */
        CCBDMOV.CodMon = Ccbcdocu.codmon
        CCBDMOV.CodRef = Ccbcdocu.coddoc    /* N/C */
        CCBDMOV.FchDoc = FILL-IN-FchDoc
        CCBDMOV.ImpTot = Ccbcdocu.imptot
        CCBDMOV.NroDoc = Ccbcdocu.nrodoc
        CCBDMOV.NroRef = Ccbcdocu.nrodoc
        CCBDMOV.TpoCmb = Ccbcdocu.tpocmb
        CCBDMOV.usuario = s-user-id.
    ASSIGN
        Ccbcdocu.FchCan = FILL-IN-FchDoc
        Ccbcdocu.FlgEst = "C"
        Ccbcdocu.SdoAct = 0
        Ccbcdocu.UsuAnu = s-user-id.

    FIND CURRENT B-CDOCU NO-LOCK NO-ERROR.
END.





/* FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia                                                                    */
/*     AND CcbTabla.Tabla  = 'N/C'                                                                                   */
/*     AND CcbTabla.Codigo = x-Concepto NO-LOCK.                                                                     */
/* CREATE t-ddocu.                                                                                                   */
/* BUFFER-COPY Ccbcdocu TO t-ddocu.                                                                                   */
/* ASSIGN                                                                                                            */
/*     t-ddocu.codmat = CcbTabla.Codigo                                                                              */
/*     t-ddocu.factor = 1                                                                                            */
/*     t-ddocu.candes = 1                                                                                            */
/*     t-ddocu.preuni = DOCU.ImpTot                                                                                  */
/*     t-ddocu.implin = t-ddocu.CanDes * t-ddocu.PreUni.                                                             */
/* IF CcbTabla.Afecto THEN                                                                                           */
/*     ASSIGN                                                                                                        */
/*     t-ddocu.AftIgv = Yes                                                                                          */
/*     t-ddocu.ImpIgv = (t-ddocu.CanDes * t-ddocu.PreUni) * ((Ccbcdocu.PorIgv / 100) / (1 + (Ccbcdocu.PorIgv / 100))). */
/* ELSE                                                                                                              */
/*     ASSIGN                                                                                                        */
/*     t-ddocu.AftIgv = No                                                                                           */
/*     t-ddocu.ImpIgv = 0.                                                                                           */
/* t-ddocu.NroItm = 1.                                                                                               */
/* ASSIGN                                                                                                            */
/*   Ccbcdocu.ImpBrt = 0                                                                                              */
/*   Ccbcdocu.ImpExo = 0                                                                                              */
/*   Ccbcdocu.ImpDto = 0                                                                                              */
/*   Ccbcdocu.ImpIgv = 0                                                                                              */
/*   Ccbcdocu.ImpTot = 0.                                                                                             */
/* FOR EACH t-ddocu OF Ccbcdocu NO-LOCK:                                                                              */
/*   ASSIGN                                                                                                          */
/*         Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt + (IF t-ddocu.AftIgv = Yes THEN t-ddocu.PreUni * t-ddocu.CanDes ELSE 0)   */
/*         Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + (IF t-ddocu.AftIgv = No  THEN t-ddocu.PreUni * t-ddocu.CanDes ELSE 0)   */
/*         Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + t-ddocu.ImpDto                                                          */
/*         Ccbcdocu.ImpIgv = Ccbcdocu.ImpIgv + t-ddocu.ImpIgv                                                          */
/*         Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + t-ddocu.ImpLin.                                                         */
/* END.                                                                                                              */
/* ASSIGN                                                                                                            */
/*     Ccbcdocu.ImpVta = Ccbcdocu.ImpBrt - Ccbcdocu.ImpIgv                                                              */
/*     Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt - Ccbcdocu.ImpIgv + Ccbcdocu.ImpDto                                             */
/*     Ccbcdocu.SdoAct = Ccbcdocu.ImpTot                                                                               */
/*     Ccbcdocu.FlgEst = 'X'.   /* POR APROBAR */                                                                     */


    


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
  DISPLAY COMBO-BOX-NroSerNC FILL-IN-NroDocNC COMBO-BOX-CodMat COMBO-BOX-CodDoc 
          COMBO-BOX-NroSerFac FILL-IN-NroDocFac FILL-IN-CodCli FILL-IN-NomCli 
          FILL-IN-FchDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-NroSerNC COMBO-BOX-CodMat COMBO-BOX-CodDoc 
         COMBO-BOX-NroSerFac FILL-IN-CodCli FILL-IN-FchDoc BROWSE-2 BUTTON-1 
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

DEF VAR k AS INT NO-UNDO.

RCICLO:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR WITH FRAME {&FRAME-NAME}:
    /* 1ro generamos las N/C y cancelamos los comprobantes */
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN UNDO RCICLO, RETURN ERROR.
        RUN Crea-NC NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO RCICLO, RETURN ERROR.
    END.
    /* 2do generamos nuevos comprobantes */
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN UNDO RCICLO, RETURN ERROR.
        RUN Crea-Comprobantes NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO RCICLO, RETURN ERROR.
    END.
END.


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
  DO WITH FRAME {&FRAME-NAME}:
      /* N/C */
      COMBO-BOX-NroSerNC:DELETE(1).
      FOR EACH faccorre NO-LOCK WHERE faccorre.codcia = s-codcia
          AND faccorre.coddiv = s-coddiv
          AND faccorre.flgest = YES
          AND faccorre.coddoc = "N/C"
          BY faccorre.nroser DESC:
          COMBO-BOX-NroSerNC:ADD-LAST(STRING(faccorre.nroser, '999')).
          COMBO-BOX-NroSerNC = faccorre.nroser.
      END.
      /* Conceptos */
      COMBO-BOX-CodMat:DELETE(1).
      FOR EACH CcbTabla NO-LOCK WHERE CcbTabla.CodCia = s-codcia
          AND CcbTabla.Tabla = "N/C"
          BY CcbTabla.Codigo DESC:
          COMBO-BOX-CodMat:ADD-LAST(CcbTabla.Codigo + ' ' + CcbTabla.Nombre, CcbTabla.Codigo).
          COMBO-BOX-CodMat = CcbTabla.Codigo.
      END.
      /* Comprobantes válidos */
      FOR EACH faccorre NO-LOCK WHERE faccorre.codcia = s-codcia
          AND faccorre.coddiv = s-coddiv
          AND faccorre.flgest = YES
          AND LOOKUP(faccorre.coddoc, 'FAC,BOL') > 0
          BREAK BY faccorre.coddoc:
          IF FIRST-OF(faccorre.coddoc) THEN DO:
               COMBO-BOX-CodDoc:ADD-LAST(CAPS(faccorre.coddoc)).
               COMBO-BOX-CodDoc = faccorre.coddoc.
          END.
      END.
      FILL-IN-FchDoc = TODAY.
      
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NroSerNC IN FRAME {&FRAME-NAME}.
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-CodDoc IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "B-CDOCU"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Total-Factura W-Win 
PROCEDURE Total-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE F-IGV LIKE Ccbcdocu.ImpIgv NO-UNDO.
  DEFINE VARIABLE F-ISC LIKE Ccbcdocu.ImpIsc NO-UNDO.
  DEFINE VARIABLE F-ImpDtoAdelanto AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-IgvDtoAdelanto AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ImpLin LIKE Ccbddocu.ImpLin NO-UNDO.

  ASSIGN
      CcbCDocu.ImpDto = 0
      CcbCDocu.ImpIgv = 0
      CcbCDocu.ImpIsc = 0
      CcbCDocu.ImpTot = 0
      CcbCDocu.ImpExo = 0
      CcbCDocu.ImpTot2= 0
      F-IGV = 0
      F-ISC = 0
      F-ImpDtoAdelanto = 0
      F-ImpLin = 0.
  /* RHC 14/03/2013 Nuevo cálculo */
  FOR EACH CcbDDocu OF CcbCDocu:
      ASSIGN
          F-Igv = F-Igv + CcbDDocu.ImpIgv
          F-Isc = F-Isc + CcbDDocu.ImpIsc
          CcbCDocu.ImpTot = CcbCDocu.ImpTot + Ccbddocu.ImpLin.
      /* Importe Inafecto o Exonerado */
      IF CcbDDocu.ImpIgv = 0 THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + F-ImpLin.
  END.
  ASSIGN
      CcbCDocu.ImpIsc = ROUND(F-ISC,2)
      CcbCDocu.ImpVta = ROUND( (CcbCDocu.ImpTot - CcbCDocu.ImpExo) / (1 + CcbCDocu.PorIgv / 100), 2).
  IF CcbCDocu.ImpExo = 0 THEN CcbCDocu.ImpIgv = CcbCDocu.ImpTot - CcbCDocu.ImpVta.
  ELSE CcbCDocu.ImpIgv = ROUND(CcbCDocu.ImpVta * CcbCDocu.PorIgv / 100, 2).
  ASSIGN
      CcbCDocu.ImpBrt = CcbCDocu.ImpVta /*+ CcbCDocu.ImpIsc*/ + CcbCDocu.ImpDto /*+ CcbCDocu.ImpExo*/
      CcbCDocu.SdoAct = CcbCDocu.ImpTot.

  IF CcbCDocu.PorIgv = 0.00     /* VENTA INAFECTA */
      THEN ASSIGN
          CcbCDocu.ImpVta = CcbCDocu.ImpExo
          CcbCDocu.ImpBrt = CcbCDocu.ImpExo.

  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion ( ROWID(Ccbcdocu) ).
  FIND CURRENT CcbCDocu.
  /* *********************** */

/*   /* APLICAMOS EL IMPORTE POR FACTURA POR ADELANTOS */      */
/*   ASSIGN                                                    */
/*       Ccbcdocu.SdoAct = Ccbcdocu.SdoAct - Ccbcdocu.ImpTot2. */
  /*RDP 31.01.11 - Parche Tarjetas*/
  ASSIGN 
      CcbcDocu.Imptot = CcbcDocu.ImpTot - CcbcDocu.ImpDto2.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales-NC W-Win 
PROCEDURE Totales-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales-abono.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

