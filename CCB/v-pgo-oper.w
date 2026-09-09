&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  Description: from VIEWER.W - Template for SmartViewer Objects

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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR s-NroSer LIKE Faccorre.nroser.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR pv-codcia AS INTE.

DEFINE VAR W-TpoFac AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF BUFFER b-Ccbcdocu FOR Ccbcdocu.
DEF BUFFER x-vtactabla FOR vtactabla.

DEFINE STREAM report.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia no-lock.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.FchAte ~
CcbCDocu.CodCob CcbCDocu.NroRef CcbCDocu.TpoFac CcbCDocu.CodMon ~
CcbCDocu.CodAge CcbCDocu.TpoCmb CcbCDocu.ImpTot CcbCDocu.CodCli ~
CcbCDocu.NomCli CcbCDocu.Libre_c01 CcbCDocu.Libre_c02 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-40 RECT-29 RECT-39 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.FchAte CcbCDocu.CodCob CcbCDocu.NroRef CcbCDocu.TpoFac ~
CcbCDocu.CodMon CcbCDocu.CodAge CcbCDocu.TpoCmb CcbCDocu.ImpTot ~
CcbCDocu.SdoAct CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.Libre_c01 ~
CcbCDocu.usuario CcbCDocu.Libre_c02 CcbCDocu.FlgUbi CcbCDocu.FchUbi 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN_NomOper FILL-IN-Moneda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "S/." 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomOper AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 2.42.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 4.58.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 4.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.35 COL 6.43 COLON-ALIGNED WIDGET-ID 36 FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .81
          FONT 0
     F-Estado AT ROW 1.35 COL 30.43 COLON-ALIGNED WIDGET-ID 20
     CcbCDocu.FchDoc AT ROW 1.35 COL 59.43 COLON-ALIGNED WIDGET-ID 24
          LABEL "Fecha de Registro"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.FchAte AT ROW 2.42 COL 59.43 COLON-ALIGNED WIDGET-ID 22
          LABEL "Fecha de Depósito"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.CodCob AT ROW 3.77 COL 14.43 COLON-ALIGNED WIDGET-ID 2
          LABEL "Operador" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     FILL-IN_NomOper AT ROW 3.77 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     CcbCDocu.NroRef AT ROW 4.85 COL 14.43 COLON-ALIGNED WIDGET-ID 38
          LABEL "Nro. Deposito" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81 TOOLTIP "Ingrese los últimos 6 dígitos de la derecha"
     CcbCDocu.TpoFac AT ROW 4.85 COL 31.43 NO-LABEL WIDGET-ID 54
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Efectivo", "EFE":U,
"Cheque", "CHQ":U
          SIZE 18.72 BY .81
     CcbCDocu.CodMon AT ROW 4.85 COL 63.43 NO-LABEL WIDGET-ID 16
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     CcbCDocu.CodAge AT ROW 5.92 COL 16.43 NO-LABEL WIDGET-ID 10
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lima", "Lima":U,
"Provincia", "Provincia":U,
"Otros", "Otros":U
          SIZE 27 BY .77
     CcbCDocu.TpoCmb AT ROW 5.92 COL 61.43 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-Moneda AT ROW 7 COL 14.43 COLON-ALIGNED WIDGET-ID 28
     CcbCDocu.ImpTot AT ROW 7 COL 19.43 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.SdoAct AT ROW 7 COL 61.43 COLON-ALIGNED WIDGET-ID 46
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.CodCli AT ROW 8.35 COL 14.43 COLON-ALIGNED WIDGET-ID 14
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.NomCli AT ROW 8.38 COL 29.14 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 45.29 BY .81
     CcbCDocu.Libre_c01 AT ROW 9.35 COL 14.43 COLON-ALIGNED WIDGET-ID 8
          LABEL "Nro. Contrato" FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 21 BY .81
     CcbCDocu.usuario AT ROW 9.42 COL 59.43 COLON-ALIGNED WIDGET-ID 58
          LABEL "Solicitante"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.Libre_c02 AT ROW 10.42 COL 14.29 COLON-ALIGNED WIDGET-ID 60
          LABEL "# Pedido Venta" FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     CcbCDocu.FlgUbi AT ROW 10.5 COL 59.43 COLON-ALIGNED WIDGET-ID 30
          LABEL "Autorizó" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.FchUbi AT ROW 11.58 COL 59.43 COLON-ALIGNED WIDGET-ID 26
          LABEL "Fecha Autorizacion"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Plaza:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.92 COL 11.43 WIDGET-ID 48
     "Moneda" VIEW-AS TEXT
          SIZE 6.57 BY .81 AT ROW 4.85 COL 56.43 WIDGET-ID 50
     RECT-40 AT ROW 8.08 COL 1.43 WIDGET-ID 44
     RECT-29 AT ROW 1.08 COL 1.43 WIDGET-ID 40
     RECT-39 AT ROW 3.5 COL 1.43 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 16.5
         WIDTH              = 89.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCob IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchUbi IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomOper IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FlgUbi IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
      DISPLAY "" @ Ccbcdocu.NomCli WITH FRAME {&FRAME-NAME}.
      RETURN.
  END.    
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND  gn-clie.codcli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY gn-clie.nomcli @ Ccbcdocu.NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCob V-table-Win
ON LEAVE OF CcbCDocu.CodCob IN FRAME F-Main /* Operador */
DO:
  FILL-IN_NomOper:SCREEN-VALUE = ''.
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
      gn-prov.CodPro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN_NomOper:SCREEN-VALUE = gn-prov.NomPro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodMon IN FRAME F-Main /* Moneda */
DO:
  IF SELF:SCREEN-VALUE = "1"
  THEN FILL-IN-Moneda:SCREEN-VALUE = 'S/.'.
  ELSE FILL-IN-Moneda:SCREEN-VALUE = 'US$'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchDoc V-table-Win
ON LEAVE OF CcbCDocu.FchDoc IN FRAME F-Main /* Fecha de Registro */
DO:
    FIND gn-tcmb WHERE gn-tcmb.fecha = DATE(Ccbcdocu.FchDoc:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL gn-tcmb THEN 
    DISPLAY 
        gn-tcmb.compra @ Ccbcdocu.TpoCmb WITH FRAME {&FRAME-NAME}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroRef V-table-Win
ON LEAVE OF CcbCDocu.NroRef IN FRAME F-Main /* Nro. Deposito */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND Faccorre WHERE Faccorre.codcia = s-codcia
      AND Faccorre.coddiv = s-coddiv
      AND Faccorre.coddoc = s-coddoc
      AND Faccorre.nroser = s-nroser
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
      MESSAGE 'No pudo encontrar el control de correlativos'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
      DISPLAY 
          STRING(s-NroSer, '999') + STRING(Faccorre.correlativo, '999999') @ Ccbcdocu.nrodoc
          TODAY @ Ccbcdocu.FchAte
          TODAY @ Ccbcdocu.FchDoc
          gn-tcmb.compra @ Ccbcdocu.TpoCmb. 
      ASSIGN
          Ccbcdocu.TpoFac:SCREEN-VALUE = 'EFE'
          FILL-IN-Moneda:SCREEN-VALUE = 'S/.'
          CcbCDocu.CodMon:SCREEN-VALUE = '1'
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE ('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {lib/lock-genericov3.i ~
          &Tabla="FacCorre" ~
          &Alcance="FIRST" ~
          &Condicion="FacCorre.CodCia = s-codcia ~
          AND  FacCorre.CodDiv = s-coddiv ~
          AND  FacCorre.CodDoc = s-coddoc ~
          AND  FacCorre.NroSer = s-NroSer" ~ 
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="YES" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'"}
      ASSIGN
          Ccbcdocu.CodCia = s-codcia
          Ccbcdocu.CodDiv = s-coddiv
          Ccbcdocu.CodDoc = s-coddoc
          Ccbcdocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
          NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ASSIGN
      Ccbcdocu.FchDoc = TODAY
      Ccbcdocu.FlgEst = "E"       /* OJO -> Emitido */
      Ccbcdocu.FlgSit = "Pendiente"
      Ccbcdocu.FchUbi = ?
      Ccbcdocu.FlgUbi = ""
      CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
      Ccbcdocu.usuario= s-user-id
      Ccbcdocu.SdoAct = Ccbcdocu.ImpTot
      Ccbcdocu.Codmon = INTEGER (Ccbcdocu.Codmon:screen-value in frame {&frame-name}).

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  IF AVAILABLE FacCorre THEN RELEASE faccorre.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR s-rpta-1 AS CHAR NO-UNDO.
  
  IF Ccbcdocu.FlgEst = "A" THEN DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "C" THEN
  DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "X" THEN
  DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "P" THEN DO:
      MESSAGE "El Documento se encuentra Autorizado" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.ImpTot <> Ccbcdocu.SdoAct THEN DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.

  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> 'ADMIN' THEN DO:
      DEF VAR dFchCie AS DATE.
      /*RUN gn/fecha-de-cierre (OUTPUT dFchCie).*/
      dFchCie = TODAY - 3.
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.
  ASSIGN
    CcbCDocu.UsuAnu = s-user-id
    CcbCDocu.FchAnu = TODAY
    Ccbcdocu.FlgEst = 'A'
    Ccbcdocu.SdoAct = 0.
  FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
      RUN gn/fFlgEstCCBv2 (Ccbcdocu.coddoc, Ccbcdocu.flgest, OUTPUT F-Estado).
      DISPLAY F-Estado WITH FRAME {&FRAME-NAME}.

      IF Ccbcdocu.codmon = 1 THEN FILL-IN-Moneda:SCREEN-VALUE = 'S/.'.
      ELSE FILL-IN-Moneda:SCREEN-VALUE = 'US$'.

      FILL-IN_NomOper:SCREEN-VALUE = ''.
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
          gn-prov.CodPro = CcbCDocu.CodCob
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN FILL-IN_NomOper:SCREEN-VALUE = gn-prov.NomPro.
 END.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      Ccbcdocu.fchdoc:SENSITIVE = NO.
      CcbCDocu.TpoCmb:SENSITIVE = NO.
      CcbCDocu.NomCli:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :

    DEFINE VAR x-contrato AS CHAR.
    DEFINE VAR x-tabla AS CHAR.
    DEFINE VAR x-tipo AS CHAR.
    DEFINE VAR x-operador AS CHAR.

    x-tabla = "PAGOXOPERADOR".
    x-tipo = "CONTRATO".
    x-contrato = CcbCDocu.libre_c01:SCREEN-VALUE.
    x-operador = CcbCDocu.codcob:SCREEN-VALUE.

    IF TRUE <> (CcbCDocu.CodCob:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'NO debe dejar el Operador en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.CodCob.
        RETURN 'ADM-ERROR'.
    END.
    FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
        gn-prov.CodPro = CcbCDocu.CodCob:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Código del Operador no esta registrado como PROVEEDOR' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.CodCob.
        RETURN 'ADM-ERROR'.
    END.

    RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY "ENTRY" TO Ccbcdocu.CodCli.
        RETURN "ADM-ERROR".   
    END.
    IF Ccbcdocu.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
        MESSAGE 'NO se puede registrar a un cliente genérico'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF DEC(Ccbcdocu.ImpTot:SCREEN-VALUE) = 0 THEN DO:
        MESSAGE "El Importe Total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.ImpTot.
        RETURN "ADM-ERROR".   
    END.      
    IF TRUE <> (Ccbcdocu.NroRef:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Registre el Nro. del Depósito' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U to Ccbcdocu.NroRef.
        RETURN 'ADM-ERROR'.
    END.
    DEF VAR iValue AS INTE NO-UNDO.
    ASSIGN iValue = INTEGER(Ccbcdocu.NroRef:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR = NO AND iValue = 0 THEN DO:
        MESSAGE 'El Nro. de Depósito NO puede ser cero' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U to Ccbcdocu.NroRef.
        RETURN 'ADM-ERROR'.
    END.

    /* RHC 20/04/2018 Fecha de Depósito */
    DEF VAR pFchCie AS DATE NO-UNDO.
    RUN gn/fFchCieCbd.p ("CREDITOS", OUTPUT pFchCie).
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        IF INPUT CcbCDocu.FchAte > TODAY OR INPUT CcbCDocu.FchAte < pFchCie THEN DO:
            MESSAGE 'Fecha de Depósito errada' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO CcbCDocu.FchAte.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        IF INPUT CcbCDocu.FchAte > CcbCDocu.FchDoc OR INPUT CcbCDocu.FchAte < pFchCie THEN DO:
            MESSAGE 'Fecha de Depósito errada' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO CcbCDocu.FchAte.
            RETURN 'ADM-ERROR'.
        END.
    END.

    IF TRUE <> (x-contrato > "")  THEN DO:
        MESSAGE 'Ingrese el CONTRATO por favor' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.libre_c01.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST x-vtactabla WHERE x-vtactabla.codcia = s-codcia AND 
                            x-vtactabla.tabla = x-tabla AND
                            x-vtactabla.llave = x-operador NO-LOCK NO-ERROR.
                            
    IF NOT AVAILABLE x-vtactabla THEN DO:
        MESSAGE 'El OPERADOR no existe ' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.codcob.
        RETURN 'ADM-ERROR'.
    END.

    /*
    FIND FIRST x-vtadtabla WHERE x-vtadtabla.codcia = s-codcia AND 
                            x-vtadtabla.tabla = x-tabla AND
                            x-vtadtabla.llave = x-operador AND
                            x-vtadtabla.tipo = x-tipo AND 
                            x-vtadtabla.llavedetalle = x-contrato NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-vtadtabla THEN DO:
        MESSAGE 'El contrato no existe para el operador' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.libre_c01.
        RETURN 'ADM-ERROR'.
    END.

    IF NOT (TODAY >= x-vtadtabla.libre_f01 AND TODAY <= x-vtadtabla.libre_f02) THEN DO:
        MESSAGE 'El contrato esta fuera de vigencia' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CcbCDocu.libre_c01.
        RETURN 'ADM-ERROR'.
    END.
    */
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF Ccbcdocu.FlgEst = "A" THEN DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "C" THEN DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "P" THEN DO:
    MESSAGE "El Documento se encuentra Autorizado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "X" THEN DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* IF NOT LOOKUP(Ccbcdocu.FlgEst, 'E,R') > 0 THEN DO:     */
/*     MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR. */
/*     RETURN "ADM-ERROR".                                */
/* END.                                                   */
IF Ccbcdocu.ImpTot <> Ccbcdocu.SdoAct THEN DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* consistencia de la fecha del cierre del sistema */
DEF VAR dFchCie AS DATE.
/*RUN gn/fecha-de-cierre (OUTPUT dFchCie).*/
dFchCie = TODAY - 7.
IF ccbcdocu.fchdoc <= dFchCie THEN DO:
    MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
/* fin de consistencia */

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

