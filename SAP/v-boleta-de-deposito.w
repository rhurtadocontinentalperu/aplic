&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cb-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-cndvta-validos AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.FchAte CcbCDocu.FlgAte CcbCDocu.CodCta CcbCDocu.CodMon ~
CcbCDocu.TpoCmb CcbCDocu.CodAge CcbCDocu.NroRef CcbCDocu.TpoFac ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FmaPgo CcbCDocu.ImpTot 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 RECT-29 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.FchAte CcbCDocu.FlgAte CcbCDocu.CodCta CcbCDocu.Glosa ~
CcbCDocu.CodMon CcbCDocu.TpoCmb CcbCDocu.CodAge CcbCDocu.NroRef ~
CcbCDocu.TpoFac CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FmaPgo ~
CcbCDocu.ImpTot CcbCDocu.SdoAct CcbCDocu.FlgUbi CcbCDocu.FchUbi ~
CcbCDocu.usuario 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado x-Nombr 

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

DEFINE VARIABLE x-Nombr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94 BY 1.35.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94 BY 7.81.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 17 COLON-ALIGNED WIDGET-ID 14
          LABEL "Numero Correlativo" FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     F-Estado AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 66
     CcbCDocu.FchDoc AT ROW 1.27 COL 71 COLON-ALIGNED WIDGET-ID 44
          LABEL "Fecha de Registro" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.FchAte AT ROW 2.62 COL 17 COLON-ALIGNED HELP
          "Máximo hasta el día de hoy" WIDGET-ID 6
          LABEL "Fecha de Depósito"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.FlgAte AT ROW 3.42 COL 17 COLON-ALIGNED WIDGET-ID 22
          LABEL "Banco" FORMAT "x(5)"
          VIEW-AS COMBO-BOX INNER-LINES 15
          LIST-ITEM-PAIRS "a","a"
          DROP-DOWN-LIST
          SIZE 62 BY 1
     CcbCDocu.CodCta AT ROW 4.23 COL 17 COLON-ALIGNED WIDGET-ID 4
          LABEL "Código de Cuenta" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.Glosa AT ROW 4.23 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 32 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.CodMon AT ROW 5.04 COL 19 NO-LABEL WIDGET-ID 26
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 13 BY .81
     CcbCDocu.TpoCmb AT ROW 5.04 COL 51 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.CodAge AT ROW 5.85 COL 19 NO-LABEL WIDGET-ID 46
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lima", "Lima":U,
"Provincia", "Provincia":U,
"Otros", "Otros":U
          SIZE 27 BY .77
     CcbCDocu.NroRef AT ROW 6.65 COL 17 COLON-ALIGNED HELP
          "Ingrese los últimos 6 dígitos de la derecha" WIDGET-ID 16
          LABEL "Nro. de Depósito" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.TpoFac AT ROW 6.65 COL 33 NO-LABEL WIDGET-ID 38
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Efectivo", "EFE":U,
"Cheque", "CHQ":U
          SIZE 18.72 BY .81
     CcbCDocu.CodCli AT ROW 7.46 COL 17 COLON-ALIGNED WIDGET-ID 2 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.NomCli AT ROW 7.46 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 12 FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.FmaPgo AT ROW 8.27 COL 17 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     x-Nombr AT ROW 8.27 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     CcbCDocu.ImpTot AT ROW 9.08 COL 17 COLON-ALIGNED WIDGET-ID 10 FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.SdoAct AT ROW 9.08 COL 71 COLON-ALIGNED WIDGET-ID 58
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.FlgUbi AT ROW 10.42 COL 17 COLON-ALIGNED WIDGET-ID 54
          LABEL "Autorizó" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.FchUbi AT ROW 10.42 COL 71 COLON-ALIGNED WIDGET-ID 52
          LABEL "Fecha Autorizacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbCDocu.usuario AT ROW 11.23 COL 17 COLON-ALIGNED WIDGET-ID 56
          LABEL "Solicitante"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.15 COL 11 WIDGET-ID 30
     "Plaza:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.92 COL 14 WIDGET-ID 50
     RECT-27 AT ROW 1 COL 2 WIDGET-ID 60
     RECT-28 AT ROW 2.35 COL 2 WIDGET-ID 62
     RECT-29 AT ROW 10.15 COL 2 WIDGET-ID 64
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
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.65
         WIDTH              = 96.43.
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
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCta IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAte IN FRAME F-Main
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchUbi IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX CcbCDocu.FlgAte IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FlgUbi IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN CcbCDocu.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-Nombr IN FRAME F-Main
   NO-ENABLE                                                            */
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
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE gn-clie THEN DO:
      RUN vtagn/p-fmapgo-valido.r (SELF:SCREEN-VALUE, "N", s-CodDiv, OUTPUT s-cndvta-validos).
      DISPLAY gn-clie.nomcli @ Ccbcdocu.NomCli WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
OR F8 OF CcbCDocu.CodCli DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?
        output-var-2 = ''
        output-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEAVE OF CcbCDocu.CodCta IN FRAME F-Main /* Código de Cuenta */
DO:
  FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
      AND  cb-ctas.Codcta = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE cb-ctas THEN DO:
      Ccbcdocu.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.Codmon).
      Ccbcdocu.Glosa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-ctas.Nomcta. 
      DISPLAY 
          cb-ctas.Codcta @ Ccbcdocu.Codcta 
          cb-ctas.Nomcta @ Ccbcdocu.Glosa WITH FRAME {&FRAME-NAME}.  
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCta IN FRAME F-Main /* Código de Cuenta */
OR F8 OF CcbCDocu.CodCta DO:
  ASSIGN 
      input-var-1 = "10" 
      input-var-2 = Ccbcdocu.FlgAte:SCREEN-VALUE
      input-var-3 = ''
      output-var-1 = ?.
  RUN lkup/c-cuenta.w ('Cuentas').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FlgAte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FlgAte V-table-Win
ON VALUE-CHANGED OF CcbCDocu.FlgAte IN FRAME F-Main /* Banco */
DO:
/*   FIND cb-tabl WHERE cb-tabl.tabla = '04' AND cb-tabl.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR NO-WAIT. */
/*   IF AVAILABLE cb-tabl THEN x-NomBco:SCREEN-VALUE = cb-tabl.Nombre.                                        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Condicion de ventas */
DO:
  x-Nombr:SCREEN-VALUE = ''.
  FIND Gn-convt WHERE Gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-convt THEN x-Nombr:SCREEN-VALUE = Gn-convt.nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.FmaPgo IN FRAME F-Main /* Condicion de ventas */
OR F8 OF INTEGRAL.CcbCDocu.FmaPgo DO:
  ASSIGN
      input-var-1 = s-cndvta-validos
      input-var-2 = ''
      input-var-3 = ''.
  RUN vta/d-cndvta.r.
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
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
  
  RUN Capture_Division IN lh_handle (OUTPUT s-coddiv).
  IF TRUE <> (s-coddiv > '') THEN RETURN 'ADM-ERROR'.

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
      AND Faccorre.coddoc = s-coddoc
      AND Faccorre.coddiv = s-coddiv
      AND Faccorre.flgest = YES
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
      MESSAGE 'La division(' + s-Coddiv + ") y Documento (" + s-coddoc + ") no configurado de correlativos!!!"
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  s-NroSer = Faccorre.nroser.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      CcbCDocu.TpoFac:SCREEN-VALUE = "EFE".
      CcbCDocu.CodAge:SCREEN-VALUE = "Lima".
      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
      DISPLAY 
          STRING(s-NroSer, '999') + STRING(Faccorre.correlativo, '999999') @ Ccbcdocu.nrodoc
          TODAY @ Ccbcdocu.FchAte
          TODAY @ Ccbcdocu.FchDoc
          gn-tcmb.compra @ Ccbcdocu.TpoCmb
          .
      Ccbcdocu.FlgAte:DELETE(1).
      Ccbcdocu.FlgAte:DELIMITER = ":".
      FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
          Ccbcdocu.FlgAte:ADD-LAST(cb-tabl.codigo + " - " + cb-tabl.nombre,cb-tabl.codigo).
      END.
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
  Ccbcdocu.FchDoc = TODAY. /* Modificado */
  ASSIGN
      CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
      Ccbcdocu.usuario= s-user-id
      Ccbcdocu.SdoAct = Ccbcdocu.ImpTot
      Ccbcdocu.Nomcli = Ccbcdocu.Nomcli:screen-value in frame {&frame-name}
      Ccbcdocu.Glosa = Ccbcdocu.Glosa:screen-value in frame {&frame-name}
      Ccbcdocu.Codmon = INTEGER (Ccbcdocu.Codmon:screen-value in frame {&frame-name}).
  ASSIGN
      Ccbcdocu.Libre_c01 = cb-ctas.nrocta.
  /* Código de banco SAP */
  FIND cb-tabl WHERE cb-tabl.tabla = '04' AND 
      cb-tabl.codigo = Ccbcdocu.FlgAte NO-LOCK NO-ERROR.
  IF AVAILABLE(cb-tabl) THEN ASSIGN Ccbcdocu.Libre_c02 = cb-tabl.Codcta.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
      AND  FacCorre.CodDiv = s-CodDiv
      AND  FacCorre.CodDoc = s-coddoc 
      AND  FacCorre.NroSer = s-NroSer
      EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1
      Ccbcdocu.CodCia = s-codcia
      Ccbcdocu.CodDiv = s-coddiv
      Ccbcdocu.CodDoc = s-coddoc
      Ccbcdocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  RELEASE FacCorre.
  ASSIGN
      Ccbcdocu.FlgEst = "E"       /* OJO -> Emitido */
      Ccbcdocu.FlgSit = "Pendiente"
      Ccbcdocu.FchUbi = ?
      Ccbcdocu.FlgUbi = ""
      .

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
  
  IF Ccbcdocu.FlgEst = "A" THEN
  DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "C" THEN
  DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "X" THEN
  DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.FlgEst = "P" THEN DO:
      MESSAGE "El Documento se encuentra Autorizado" VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.ImpTot <> Ccbcdocu.SdoAct THEN DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
  END.
  IF s-user-id <> 'ADMIN' THEN DO:
      DEF VAR dFchCie AS DATE.
      dFchCie = TODAY - 3.
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

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
      FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
          Ccbcdocu.FlgAte:ADD-LAST(cb-tabl.codigo + " - " + cb-tabl.Nombre, cb-tabl.codigo).
      END.

      RUN gn/fFlgEstCCBv2 (Ccbcdocu.coddoc, Ccbcdocu.flgest, OUTPUT F-Estado).
      DISPLAY F-Estado WITH FRAME {&FRAME-NAME}.

      x-Nombr:SCREEN-VALUE = ''.
      FIND Gn-convt WHERE Gn-convt.codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE GN-convt THEN x-Nombr:SCREEN-VALUE = gn-ConVt.Nombr.
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
      ASSIGN
          CcbCDocu.NomCli:SENSITIVE = NO
          CcbCDocu.CodMon:SENSITIVE = NO
          CcbCDocu.FchDoc:SENSITIVE = NO
          CcbCDocu.NroDoc:SENSITIVE = NO
          CcbCDocu.TpoCmb:SENSITIVE = NO
          CcbCDocu.TpoFac:SENSITIVE = NO
          Ccbcdocu.Glosa:SENSITIVE = NO
          .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_filters V-table-Win 
PROCEDURE set_filters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcCodDoc AS CHAR NO-UNDO.

s-coddoc = pcCodDoc.


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

DO WITH FRAME {&FRAME-NAME}:
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        /* 30/01/2024: S.Leon */
        IF INPUT CcbCDocu.FchAte > TODAY THEN DO:
            MESSAGE 'Fecha de Depósito errada' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO CcbCDocu.FchAte.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        /* 30/01/2024: S.Leon */
        IF INPUT CcbCDocu.FchAte > CcbCDocu.FchDoc THEN DO:
            MESSAGE 'Fecha de Depósito errada' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO CcbCDocu.FchAte.
            RETURN 'ADM-ERROR'.
        END.
    END.

    FIND FIRST cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
        LENGTH(cb-ctas.Codcta) >= 6 AND 
        cb-ctas.codcta BEGINS "10" AND 
        cb-ctas.codbco = CcbCDocu.FlgAte:SCREEN-VALUE AND
        cb-ctas.codcta = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Código de cuenta errada' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.

    IF TRUE <> (Ccbcdocu.NroRef:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Registre el Nro. del Depósito' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U to Ccbcdocu.NroRef.
        RETURN 'ADM-ERROR'.
    END.

    IF TRUE <> (CcbCDocu.CodCli:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Código de cliente en blanco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    /* **********************************************************
    RHC 22/07/2020 Nuevo bloqueo de clientes 
    Ic 26Abr2024, validar el cliente al grabar (Carla Huari) 
    ************************************************************ */
    DEF VAR cClienteValidacion AS CHAR NO-UNDO.
    cClienteValidacion = CcbCDocu.CodCli:SCREEN-VALUE + "|" + "2".
    RUN pri/p-verifica-cliente.r (INPUT cClienteValidacion,
                                  INPUT "",
                                  INPUT s-CodDiv).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        APPLY 'ENTRY':U TO CcbCDocu.CodCli.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.FmaPgo.
        RETURN 'ADM-ERROR'.
    END.
    IF LOOKUP(CcbCDocu.FmaPgo:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
        MESSAGE 'Condición de venta NO autorizada para este cliente'
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.FmaPgo.
        RETURN 'ADM-ERROR'.
    END.

    IF DEC(Ccbcdocu.ImpTot:SCREEN-VALUE) = 0 THEN DO:
        MESSAGE "El Importe Total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.ImpTot.
        RETURN "ADM-ERROR".   
    END.      

    /* ********************************************************************************************** */
    /* CONTROL DE DUPLICADOS */
    /* ********************************************************************************************** */
    DEF VAR pDuplicado AS LOG NO-UNDO.
    DEF VAR pError AS CHAR NO-UNDO.

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    CASE RETURN-VALUE:
        WHEN "YES" THEN DO:
            RUN ccb/p-estado-bd (INPUT "YES",
                                 INPUT s-CodDoc,
                                 INPUT "",
                                 INPUT Ccbcdocu.FlgAte:SCREEN-VALUE,
                                 INPUT Ccbcdocu.NroRef:SCREEN-VALUE,
                                 INPUT DATE(Ccbcdocu.FchAte:SCREEN-VALUE),
                                 INPUT DECIMAL(Ccbcdocu.ImpTot:SCREEN-VALUE),
                                 OUTPUT pDuplicado,
                                 OUTPUT pError).
        END.
        WHEN "NO" THEN DO:
            RUN ccb/p-estado-bd (INPUT "NO",
                                 INPUT s-CodDoc,
                                 INPUT Ccbcdocu.NroDoc,
                                 INPUT Ccbcdocu.FlgAte:SCREEN-VALUE,
                                 INPUT Ccbcdocu.NroRef:SCREEN-VALUE,
                                 INPUT DATE(Ccbcdocu.FchAte:SCREEN-VALUE),
                                 INPUT DECIMAL(Ccbcdocu.ImpTot:SCREEN-VALUE),
                                 OUTPUT pDuplicado,
                                 OUTPUT pError).
        END.
    END CASE.
    IF pDuplicado = YES THEN DO:
        MESSAGE pError VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO Ccbcdocu.NroRef.
        RETURN 'ADM-ERROR'.
    END.
    /* 06/10/2014 Cruzamos contra Cheques Depositados */
    FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia AND
        B-CDOCU.codcli = CcbCDocu.CodCli:SCREEN-VALUE AND
        B-CDOCU.flgest <> 'A' AND
        B-CDOCU.coddoc = 'CHD':
        IF B-CDOCU.nroord = CcbCDocu.NroRef:SCREEN-VALUE AND 
            B-CDOCU.codcta = CcbCDocu.CodCta:SCREEN-VALUE AND 
            B-CDOCU.codage = CcbCDocu.FlgAte:SCREEN-VALUE
            THEN DO:
            MESSAGE 'Se ha detectado un cheque depositado en esta cuenta:' SKIP
                'Cheque Nro:' B-CDOCU.nrodoc SKIP
                'Necesito la confirmación de esta boleta de depósito'
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                UPDATE rpta AS LOG.
            IF rpta = NO THEN DO:
                APPLY 'ENTRY':U to Ccbcdocu.NroRef.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
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

IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

IF Ccbcdocu.FlgEst = "A" THEN DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "C" THEN DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "P" THEN DO:
    MESSAGE "El Documento se encuentra Autorizado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.FlgEst = "X" THEN DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
IF Ccbcdocu.ImpTot <> Ccbcdocu.SdoAct THEN DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* consistencia de la fecha del cierre del sistema */
DEF VAR dFchCie AS DATE.
dFchCie = TODAY - 7.
IF ccbcdocu.fchdoc <= dFchCie THEN DO:
    MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

RUN vtagn/p-fmapgo-valido (CcbCDocu.CodCli, "N", s-CodDiv, OUTPUT s-cndvta-validos).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

