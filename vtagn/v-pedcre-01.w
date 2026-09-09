&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR VtaCDocu.
DEFINE BUFFER B-DDocu FOR VtaDDocu.
DEFINE BUFFER COTIZACION FOR VtaCDocu.
DEFINE SHARED TEMP-TABLE T-DDocu NO-UNDO LIKE VtaDDocu.
DEFINE SHARED TEMP-TABLE T-DPEDI NO-UNDO LIKE VtaDDocu.



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

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-coddiv AS CHAR.
DEFINE SHARED VARIABLE cl-codcia AS INT.
DEFINE SHARED VARIABLE cb-codcia AS INT.
DEFINE SHARED VARIABLE s-user-id AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE s-codped AS CHAR.
DEFINE SHARED VARIABLE s-nroped AS CHAR.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE SHARED VARIABLE s-codmon AS INT.
DEFINE SHARED VARIABLE S-FLGIGV AS LOGICAL.
DEFINE SHARED VARIABLE S-PORIGV AS DECIMAL.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE s-codref AS CHAR.
DEFINE SHARED VARIABLE s-nroref AS CHAR.

FIND FIRST Faccfggn WHERE codcia = s-codcia NO-LOCK.

/* CONFIGURACIONS GENERALES POR U.N. */
DEF VAR s-FlgAprPed LIKE gn-divi.flgaprped NO-UNDO.
DEF VAR s-DiasVtoPed LIKE gn-divi.diasvtoped NO-UNDO.
DEF VAR s-DiasAmpCot LIKE gn-divi.diasampcot NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.
ASSIGN
    s-FlgAprPed = gn-divi.flgaprped
    s-DiasVtoPed = gn-divi.diasvtoped
    s-DiasAmpCot = gn-divi.diasampcot.

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
&Scoped-define EXTERNAL-TABLES VtaCDocu
&Scoped-define FIRST-EXTERNAL-TABLE VtaCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCDocu.Sede VtaCDocu.LugEnt VtaCDocu.FchVen ~
VtaCDocu.FchEnt 
&Scoped-define ENABLED-TABLES VtaCDocu
&Scoped-define FIRST-ENABLED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-FIELDS VtaCDocu.NroPed VtaCDocu.CodCli ~
VtaCDocu.RucCli VtaCDocu.DniCli VtaCDocu.NomCli VtaCDocu.DirCli ~
VtaCDocu.Sede VtaCDocu.LugEnt VtaCDocu.NroCard VtaCDocu.CodVen ~
VtaCDocu.FmaPgo VtaCDocu.FchPed VtaCDocu.FchVen VtaCDocu.FchEnt ~
VtaCDocu.NroOrd VtaCDocu.Usuario VtaCDocu.Cmpbnte VtaCDocu.FlgIgv ~
VtaCDocu.CodMon VtaCDocu.TpoCmb VtaCDocu.CodRef VtaCDocu.NroRef 
&Scoped-define DISPLAYED-TABLES VtaCDocu
&Scoped-define FIRST-DISPLAYED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-OBJECTS f-NomTar f-Estado f-NomVen f-CndVta 

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
DEFINE VARIABLE f-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE f-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE f-NomTar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-NomTar AT ROW 8.54 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     f-Estado AT ROW 1 COL 50 COLON-ALIGNED WIDGET-ID 72
     VtaCDocu.NroPed AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 32
          LABEL "No. Pedido"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY 1
     VtaCDocu.CodCli AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 4
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
     VtaCDocu.RucCli AT ROW 3.15 COL 40 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
     VtaCDocu.DniCli AT ROW 3.15 COL 62 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaCDocu.NomCli AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 70 BY 1
     VtaCDocu.DirCli AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 8
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1
     VtaCDocu.Sede AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 9.43 BY 1
     VtaCDocu.LugEnt AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 70 BY 1
     VtaCDocu.NroCard AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaCDocu.CodVen AT ROW 9.62 COL 19 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
     VtaCDocu.FmaPgo AT ROW 10.69 COL 19 COLON-ALIGNED WIDGET-ID 20
          LABEL "Condicion de venta"
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
     f-NomVen AT ROW 9.62 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     f-CndVta AT ROW 10.69 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     VtaCDocu.FchPed AT ROW 1 COL 111 COLON-ALIGNED WIDGET-ID 14
          LABEL "Fecha de Emision"
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     VtaCDocu.FchVen AT ROW 2.08 COL 111 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     VtaCDocu.FchEnt AT ROW 3.15 COL 111 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11 BY 1
     VtaCDocu.NroOrd AT ROW 4.23 COL 111 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 16.43 BY 1
     VtaCDocu.Usuario AT ROW 5.31 COL 111 COLON-ALIGNED WIDGET-ID 40
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY 1
     VtaCDocu.Cmpbnte AT ROW 6.38 COL 111 COLON-ALIGNED WIDGET-ID 52
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL" 
          DROP-DOWN-LIST
          SIZE 9 BY 1
     VtaCDocu.FlgIgv AT ROW 7.46 COL 113 WIDGET-ID 48
          LABEL "Afecta a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .77
     VtaCDocu.CodMon AT ROW 8.54 COL 113 NO-LABEL WIDGET-ID 44
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 13 BY 1
     VtaCDocu.TpoCmb AT ROW 9.62 COL 111 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     VtaCDocu.CodRef AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 76
          LABEL "Cotizacion Nº"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY 1
     VtaCDocu.NroRef AT ROW 2.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 16.43 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 8.81 COL 105 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL VtaCDocu
      TABLE: B-DDocu B "?" ? INTEGRAL VtaDDocu
      TABLE: COTIZACION B "?" ? INTEGRAL VtaCDocu
      TABLE: T-DDocu T "SHARED" NO-UNDO INTEGRAL VtaDDocu
      TABLE: T-DPEDI T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 11.65
         WIDTH              = 140.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX VtaCDocu.Cmpbnte IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET VtaCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.CodRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.DirCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.DniCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomTar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX VtaCDocu.FlgIgv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroCard IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroOrd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCDocu.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.Usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME VtaCDocu.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Cmpbnte V-table-Win
ON VALUE-CHANGED OF VtaCDocu.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:
  CASE INPUT {&self-name}:
      WHEN 'FAC' THEN DO:
          ASSIGN
              VtaCDocu.DniCli:SCREEN-VALUE = ''
              VtaCDocu.DniCli:SENSITIVE = NO
              VtaCDocu.NomCli:SENSITIVE = NO
              VtaCDocu.DirCli:SENSITIVE = NO.
          IF VtaCDocu.RucCli:SCREEN-VALUE = '' THEN DO:
              FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                  AND gn-clie.codcli = Vtacdocu.codcli:SCREEN-VALUE 
                  NO-LOCK NO-ERROR.
              IF AVAILABLE gn-clie THEN VtaCDocu.RucCli:SCREEN-VALUE = gn-clie.ruc.
          END.
      END.
      WHEN 'BOL' THEN DO:
          ASSIGN
              VtaCDocu.RucCli:SCREEN-VALUE = ''
              VtaCDocu.DniCli:SENSITIVE = YES
              VtaCDocu.NomCli:SENSITIVE = YES
              VtaCDocu.DirCli:SENSITIVE = YES.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodVen V-table-Win
ON LEAVE OF VtaCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  FIND gn-ven WHERE gn-ven.codcia = s-codcia
      AND gn-ven.codven = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven 
  THEN f-nomven:SCREEN-VALUE = gn-ven.NomVen.
  ELSE f-nomven:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FchEnt V-table-Win
ON LEAVE OF VtaCDocu.FchEnt IN FRAME F-Main /* Fecha Entrega */
DO:
  IF INPUT {&self-name} < TODAY THEN RETURN NO-APPLY.
  IF ( INPUT {&self-name} - TODAY ) > 365 THEN DO:
      MESSAGE 'La fecha de entrega es de más de un año' SKIP
          'Continuamos?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.NroCard V-table-Win
ON LEAVE OF VtaCDocu.NroCard IN FRAME F-Main /* Tarjeta */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Card 
    THEN f-NomTar:SCREEN-VALUE = "".
    ELSE f-NomTar:SCREEN-VALUE = gn-card.NomClie[1].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Sede V-table-Win
ON F8 OF VtaCDocu.Sede IN FRAME F-Main /* Sede */
OR left-mouse-dblclick OF Vtacdocu.Sede
DO:
    ASSIGN
      input-var-1 = s-CodCli
      input-var-2 = Vtacdocu.NomCli:SCREEN-VALUE
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN vta/c-clied.
    IF output-var-2 <> '' THEN DO:
        Vtacdocu.LugEnt:SCREEN-VALUE = output-var-2.
        VTacdocu.sede:SCREEN-VALUE = output-var-3.
        APPLY 'entry':U TO Vtacdocu.sede.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.Sede V-table-Win
ON LEAVE OF VtaCDocu.Sede IN FRAME F-Main /* Sede */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-clied WHERE gn-clied.codcia = cl-codcia
      AND Gn-ClieD.CodCli = s-codcli 
      AND gn-clied.sede = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clied
  THEN Vtacdocu.lugent:SCREEN-VALUE = Gn-ClieD.DirCli.
  ELSE Vtacdocu.lugent:SCREEN-VALUE = ''.
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
  {src/adm/template/row-list.i "VtaCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Vtaddocu OF Vtacdocu:
    DELETE Vtaddocu.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-DDOCU:
    DELETE T-DDOCU.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Borra-Temporal.
FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
    CREATE T-DDOCU.
    BUFFER-COPY Vtaddocu TO T-DDOCU.
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle V-table-Win 
PROCEDURE Graba-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-NroItm AS INT INIT 1 NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-StkDis AS DEC NO-UNDO.
DEF VAR x-StkComprometido AS DEC NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FOR EACH T-DDOCU BY T-DDOCU.NroItm:
    FIND Almmmatg WHERE Almmmatg.CodCia = s-CODCIA 
        AND Almmmatg.codmat = T-DDOCU.CodMat
        USE-INDEX matg01 NO-LOCK.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Almmmatg.Chr__01 
        NO-LOCK NO-ERROR.
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = T-DDOCU.AlmDes
        AND Almmmate.codmat = T-DDOCU.CodMat
        NO-LOCK NO-ERROR .
    x-StkAct = Almmmate.StkAct.
    f-Factor = T-DDOCU.Factor.
    RUN vtagn/p-Stock-Comprometido (T-DDOCU.CodMat, T-DDOCU.AlmDes, OUTPUT x-StkComprometido).
    x-StkDis = x-StkAct - x-StkComprometido.
    IF x-StkDis <= 0 THEN NEXT.
    x-CanPed = T-DDOCU.CanPed * f-Factor.
    IF x-StkDis < x-CanPed THEN DO:
        /* Ajustamos los valores de acuerdo a la cantidad */
        /* por multiplos de la unidad */
        IF Almtconv.Multiplos <> 0 THEN DO:
            x-StkDis = (TRUNCATE((x-StkDis / Almtconv.Multiplos),0) * Almtconv.Multiplos).
            IF x-StkDis <= 0 THEN NEXT.
        END.
        /* por paquetes de supermercados */
        FIND FIRST supmmatg WHERE supmmatg.codcia = Vtacdocu.CodCia
            AND supmmatg.codcli = Vtacdocu.CodCli
            AND supmmatg.codmat = T-DDOCU.codmat 
            NO-LOCK NO-ERROR.
        IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
            x-StkDis = (TRUNCATE((x-StkDis / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
            IF x-StkDis <= 0 THEN NEXT.
        END.
        x-StkDis = x-StkDis / f-Factor.      /* UND de venta */

        /* CALCULO GENERAL DE LOS IMPORTES POR LINEA */
        T-DDOCU.CanPed = x-StkDis.
        {vtagn/i-vtaddocu-01.i}
    END.
    /* ************************************************************************************** */
    CREATE Vtaddocu.
    BUFFER-COPY T-DDOCU TO Vtaddocu
        ASSIGN
            Vtaddocu.nroitm = x-NroItm
            Vtaddocu.codcia = Vtacdocu.codcia
            Vtaddocu.coddiv = Vtacdocu.coddiv
            Vtaddocu.codped = Vtacdocu.codped
            Vtaddocu.nroped = Vtacdocu.nroped.
    x-NroItm = x-NroItm + 1.
END.
/* verificamos que al menos exista 1 item grabado */
FIND FIRST Vtaddocu OF Vtacdocu NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtaddocu 
THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.

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
  RUN Borra-Temporal.
  ASSIGN
      input-var-1 = s-codref
      input-var-2 = "P".
  RUN vtagn/c-vtacdocu-01 ("COTIZACIONES VALIDAS").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  FIND COTIZACION WHERE ROWID (COTIZACION) = output-var-1 NO-LOCK.
  ASSIGN
      s-nroped = ""
      s-nroref = COTIZACION.nroped
      s-codcli = COTIZACION.codcli
      s-codmon = COTIZACION.codmon
      s-cndvta = COTIZACION.fmapgo
      s-flgigv = COTIZACION.flgigv
      s-porigv = COTIZACION.porigv.
  RUN vtagn/p-genera-pedido ( ROWID(COTIZACION) ).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      s-adm-new-record = 'YES'.


  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO */
      FIND Vtacordiv WHERE Vtacordiv.codcia = s-codcia
          AND Vtacordiv.coddiv = s-coddiv
          AND Vtacordiv.coddoc = s-codped
          AND Vtacordiv.nroser = s-nroser
          NO-LOCK NO-ERROR.
      DISPLAY
          STRING(Vtacordiv.nroser, '999') + STRING(Vtacordiv.nrocor, '999999') @ Vtacdocu.nroped
          COTIZACION.codped @ vtacdocu.codref
          COTIZACION.nroped @ vtacdocu.nroref
          cotizacion.codcli @ vtacdocu.codcli
          COTIZACION.RucCli @ vtacdocu.ruccli
          COTIZACION.DniCli @ vtacdocu.dnicli
          COTIZACION.NomCli @ vtacdocu.nomcli
          COTIZACION.NroCard @ vtacdocu.nrocard
          COTIZACION.DirCli @ vtacdocu.dircli
          COTIZACION.Sede @ vtacdocu.sede
          COTIZACION.LugEnt @ vtacdocu.lugent
          COTIZACION.CodVen @ vtacdocu.codven
          COTIZACION.FmaPgo @ vtacdocu.fmapgo
          COTIZACION.CodCli @ vtacdocu.codcli
          TODAY + s-DiasVtoPed @ vtacdocu.fchent
          TODAY + s-DiasVtoPed @ vtacdocu.fchven
          COTIZACION.NroOrd @ vtacdocu.nroord
          COTIZACION.TpoCmb @ Vtacdocu.tpocmb.
      ASSIGN
          vtacdocu.codmon:SCREEN-VALUE = STRING (COTIZACION.CodMon)
          vtacdocu.flgigv:SCREEN-VALUE = STRING (COTIZACION.flgigv).
      ASSIGN
          Vtacdocu.FchEnt:SENSITIVE = NO
          Vtacdocu.FchVen:SENSITIVE = NO.
      FIND gn-ven WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = COTIZACION.codven
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven 
      THEN f-nomven:SCREEN-VALUE = gn-ven.NomVen.
      ELSE f-nomven:SCREEN-VALUE = ''.
      FIND gn-convt WHERE gn-convt.codig = COTIZACION.fmapgo
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt
      THEN f-cndvta:SCREEN-VALUE = gn-ConVt.Nombr.
      ELSE f-cndvta:SCREEN-VALUE = ''.
      f-Estado:SCREEN-VALUE = ''.
      FIND Gn-Card WHERE Gn-Card.NroCard = COTIZACION.nrocard NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-Card 
      THEN f-NomTar:SCREEN-VALUE = "".
      ELSE f-NomTar:SCREEN-VALUE = gn-card.NomClie[1].
  END.
  RUN Procesa-Handle IN lh_handle ('pagina2').
  RUN Procesa-Handle IN lh_handle ('Enable-botones').
  RUN Procesa-Handle IN lh_handle ('browse').
  APPLY "ENTRY":U TO Vtacdocu.sede IN FRAME {&FRAME-NAME}.

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
  RUN GET-ATTRIBUTE ("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      {vtagn/i-vtacordiv-01.i}
      BUFFER-COPY COTIZACION
          EXCEPT 
            COTIZACION.CodPed
            COTIZACION.NroPed
            COTIZACION.Sede 
            COTIZACION.LugEnt
            COTIZACION.FchEnt
            COTIZACION.FchVen
          TO Vtacdocu
          ASSIGN
            Vtacdocu.codcia = s-codcia
            Vtacdocu.codped = s-codped
            /*Vtacdocu.nroped = STRING(Vtacordiv.nroser, '999') + STRING(Vtacordiv.nrocor, '999999')*/
            Vtacdocu.nroped = STRING(Vtacordiv.nroser, '999') + STRING(vNroCor, '999999')
            Vtacdocu.coddiv = s-coddiv
            VtaCDocu.FchCre = TODAY
            Vtacdocu.usuario = s-user-id
            Vtacdocu.codref = COTIZACION.CodPed
            Vtacdocu.nroref = COTIZACION.NroPed
            Vtacdocu.flgest = "X".          /* POR APROBAR */
/*       ASSIGN                                       */
/*           Vtacordiv.nrocor = Vtacordiv.nrocor + 1. */
  END.
  ELSE DO:
      RUN vtagn/p-actualiza-cotizacion ( ROWID(Vtacdocu), -1).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
      RUN Borra-Detalle.
  END.
  ASSIGN
      Vtacdocu.PorIgv = ( IF s-FlgIgv THEN Faccfggn.porigv ELSE 0 )
      VtaCDocu.FchMod = TODAY
      VtaCDocu.UsrMod = s-user-id.

  RUN Graba-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO se pudo generar el pedido' SKIP
          'NO hay stock suficiente en los almacenes' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Verifica-Cliente.

  RUN vtagn/p-actualiza-cotizacion ( ROWID(Vtacdocu), +1).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

  RELEASE Vtaddocu.
  RELEASE Vtacordiv.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('pagina1').
  RUN Procesa-Handle IN lh_handle ('Disable-botones').

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
  IF Vtacdocu.FlgEst = "P" THEN DO:
      /* consistencia de atenciones */
      FIND FIRST Vtaddocu OF Vtacdocu WHERE VtaDDocu.CanAte > 0 NO-LOCK NO-ERROR.
      IF AVAILABLE Vtaddocu THEN DO:
          MESSAGE 'El Pedido ya tiene Ordenes de Despacho'
              VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
  END.
  ELSE DO:
      IF Vtacdocu.FlgEst <> "X" THEN DO:
          MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
      END.
  END.

  /* Dispatch standard ADM method.                             */
  /*
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  */

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Vtacdocu THEN RETURN "ADM-ERROR".
      ASSIGN
          VtaCDocu.FchAnu = TODAY
          VtaCDocu.FlgEst = "A"
          VtaCDocu.UsrAnu = s-user-id.
      RUN vtagn/p-actualiza-cotizacion ( ROWID(Vtacdocu), -1).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
      FIND CURRENT Vtacdocu NO-LOCK NO-ERROR.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields').

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
  DEF VAR pEstado AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Vtacdocu THEN DO WITH FRAME {&FRAME-NAME}:
      FIND gn-ven WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = Vtacdocu.codven
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven 
      THEN f-nomven:SCREEN-VALUE = gn-ven.NomVen.
      ELSE f-nomven:SCREEN-VALUE = ''.
      FIND gn-convt WHERE gn-convt.codig = Vtacdocu.fmapgo
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt
      THEN f-cndvta:SCREEN-VALUE = gn-ConVt.Nombr.
      ELSE f-cndvta:SCREEN-VALUE = ''.
      RUN vtagn/p-vtacdocu-flgest (Vtacdocu.flgest, Vtacdocu.codped, OUTPUT pEstado).
      f-Estado:SCREEN-VALUE = pEstado.
      FIND Gn-Card WHERE Gn-Card.NroCard = Vtacdocu.nrocard NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-Card 
      THEN f-NomTar:SCREEN-VALUE = "".
      ELSE f-NomTar:SCREEN-VALUE = gn-card.NomClie[1].
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
  IF RETURN-VALUE <> 'ADM-ERROR' THEN DO:
      RUN Procesa-Handle IN lh_handle ('pagina1').
      RUN Procesa-Handle IN lh_handle ('Disable-botones').
      RUN dispatch IN THIS-PROCEDURE ('display-fields').
  END.

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
  {src/adm/template/snd-list.i "VtaCDocu"}

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

DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
    FOR EACH T-DDOCU NO-LOCK:
        F-Tot = F-Tot + T-DDOCU.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
       MESSAGE "** Importe total debe ser mayor a cero **" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".   
    END.
    /* RHC 20.09.05 Transferencia gratuita */
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = '900' AND VtaCDocu.NroCar:SCREEN-VALUE <> '' THEN DO:
        MESSAGE 'En caso de transferencia gratuita NO es válido el Nº de Tarjeta' 
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* VERIFICAMOS LA LINEA DE CREDITO */
    DEF VAR t-Resultado AS CHAR NO-UNDO.
    DEF VAR f-Saldo AS DEC NO-UNDO.

    f-Saldo = f-Tot.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN F-Saldo = F-Tot - Vtacdocu.Imptot.
    RUN vtagn/p-linea-de-credito ( s-CodCli,
                              f-Saldo,
                              s-CodMon,
                              s-CndVta,
                              TRUE,
                              OUTPUT t-Resultado).
    IF t-Resultado = 'ADM-ERROR' THEN DO:
        RETURN "ADM-ERROR".   
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
  IF Vtacdocu.FlgEst <> "X" THEN DO:
      MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('pagina2').
  /* Cargamos las condiciones de venta válidas */
  ASSIGN
      s-codcli = Vtacdocu.codcli
      s-codmon = Vtacdocu.codmon
      s-cndvta = Vtacdocu.fmapgo
      s-flgigv = Vtacdocu.flgigv
      s-porigv = Vtacdocu.porigv
      s-adm-new-record = 'NO'
      s-nroped = Vtacdocu.nroped
      s-nroref = Vtacdocu.nroref.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Cliente V-table-Win 
PROCEDURE Verifica-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vtagn/i-verifica-cliente.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

