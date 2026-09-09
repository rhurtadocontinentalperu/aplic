&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
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
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE SHARED VARIABLE s-codmon AS INT.
DEFINE SHARED VARIABLE S-FLGIGV AS LOGICAL.
DEFINE SHARED VARIABLE S-PORIGV AS DECIMAL.
DEFINE SHARED VAR s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE s-import-ibc AS LOG.
DEFINE SHARED VARIABLE s-import-cia AS LOG.

DEFINE VARIABLE s-cndvta-validos AS CHAR.
DEFINE VARIABLE s-pendiente-ibc AS LOG.

FIND FIRST Faccfggn WHERE codcia = s-codcia NO-LOCK.

/* CONFIGURACIONS GENERALES POR U.N. */
DEF VAR s-FlgAprCot LIKE gn-divi.flgaprcot NO-UNDO.
DEF VAR s-DiasVtoCot LIKE gn-divi.diasvtocot NO-UNDO.
DEF VAR s-DiasAmpCot LIKE gn-divi.diasampcot NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.
ASSIGN
    s-FlgAprCot = gn-divi.flgaprcot
    s-DiasVtoCot = gn-divi.diasvtocot
    s-DiasAmpCot = gn-divi.diasampcot.

DEFINE TEMP-TABLE t-lgcocmp NO-UNDO LIKE LG-COCmp.
DEFINE TEMP-TABLE t-lgdocmp NO-UNDO LIKE LG-DOCmp.

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
&Scoped-Define ENABLED-FIELDS VtaCDocu.CodCli VtaCDocu.RucCli ~
VtaCDocu.DniCli VtaCDocu.NomCli VtaCDocu.DirCli VtaCDocu.Sede ~
VtaCDocu.LugEnt VtaCDocu.NroCard VtaCDocu.CodVen VtaCDocu.FmaPgo ~
VtaCDocu.FchPed VtaCDocu.FchVen VtaCDocu.FchEnt VtaCDocu.NroOrd ~
VtaCDocu.Cmpbnte VtaCDocu.FlgIgv VtaCDocu.CodMon VtaCDocu.TpoCmb 
&Scoped-define ENABLED-TABLES VtaCDocu
&Scoped-define FIRST-ENABLED-TABLE VtaCDocu
&Scoped-Define DISPLAYED-FIELDS VtaCDocu.NroPed VtaCDocu.CodCli ~
VtaCDocu.RucCli VtaCDocu.DniCli VtaCDocu.NomCli VtaCDocu.DirCli ~
VtaCDocu.Sede VtaCDocu.LugEnt VtaCDocu.NroCard VtaCDocu.CodVen ~
VtaCDocu.FmaPgo VtaCDocu.FchPed VtaCDocu.FchVen VtaCDocu.FchEnt ~
VtaCDocu.NroOrd VtaCDocu.Usuario VtaCDocu.Cmpbnte VtaCDocu.FlgIgv ~
VtaCDocu.CodMon VtaCDocu.TpoCmb 
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
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE f-NomTar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-NomTar AT ROW 7.46 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     f-Estado AT ROW 1 COL 50 COLON-ALIGNED WIDGET-ID 72
     VtaCDocu.NroPed AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 32
          LABEL "No. Cotizacion"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY 1
     VtaCDocu.CodCli AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 4
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
     VtaCDocu.RucCli AT ROW 2.08 COL 40 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
     VtaCDocu.DniCli AT ROW 2.08 COL 62 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaCDocu.NomCli AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 70 BY 1
     VtaCDocu.DirCli AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 8
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1
     VtaCDocu.Sede AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 9.43 BY 1
     VtaCDocu.LugEnt AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 70 BY 1
     VtaCDocu.NroCard AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaCDocu.CodVen AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
     VtaCDocu.FmaPgo AT ROW 9.62 COL 19 COLON-ALIGNED WIDGET-ID 20
          LABEL "Condicion de venta"
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
     f-NomVen AT ROW 8.54 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     f-CndVta AT ROW 9.62 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 54
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
         HEIGHT             = 10.77
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
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN f-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomTar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FchPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX VtaCDocu.FlgIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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


&Scoped-define SELF-NAME VtaCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodCli V-table-Win
ON F8 OF VtaCDocu.CodCli IN FRAME F-Main /* Cliente */
OR left-mouse-dblclick OF Vtacdocu.codcli
DO:
    RUN vtagn/c-gn-clie-01 ('Clientes válidos').
    IF output-var-1 <> ? THEN DO:
        VtaCDocu.CodCli:SCREEN-VALUE = output-var-2.
        VtaCDocu.NomCli:SCREEN-VALUE = output-var-3.
        APPLY 'ENTRY':U TO VtaCDocu.CodCli.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodCli V-table-Win
ON LEAVE OF VtaCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
      AND  gn-clie.CodCli = Vtacdocu.CodCli:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    /* BLOQUEO DEL CLIENTE */
    RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-codped).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
    /*
    IF gn-clie.FlgSit = "I" THEN DO:
        MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
        MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    */
    IF LOOKUP(TRIM(SELF:SCREEN-VALUE), FacCfgGn.CliVar) > 0 THEN DO:
        MESSAGE 'Clientes varios NO permitidos' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* Cargamos las condiciones de venta válidas */
    RUN vtagn/p-fmapgo-01 (gn-clie.codcli, OUTPUT s-cndvta-validos).

    DO WITH FRAME {&FRAME-NAME} :
       DISPLAY 
           gn-clie.NomCli @ Vtacdocu.NomCli
           gn-clie.Ruc    @ Vtacdocu.RucCli
           gn-clie.DirCli @ Vtacdocu.DirCli
           gn-clie.DirCli @ Vtacdocu.LugEnt
           ENTRY(1, s-cndvta-validos) @ Vtacdocu.fmapgo. 
        ASSIGN
            S-CODCLI = Vtacdocu.CodCli:SCREEN-VALUE
            S-CNDVTA = Vtacdocu.FmaPgo:SCREEN-VALUE.
       IF gn-clie.CodCli <> FacCfgGn.CliVar THEN DO: 
           ASSIGN
               Vtacdocu.NomCli:SENSITIVE = NO
               Vtacdocu.RucCli:SENSITIVE = NO
               Vtacdocu.DirCli:SENSITIVE = NO.
       END.   
       ELSE DO: 
           ASSIGN
               Vtacdocu.NomCli:SENSITIVE = YES
               Vtacdocu.RucCli:SENSITIVE = YES
               Vtacdocu.DirCli:SENSITIVE = YES.
       END. 
       /* Ubica la Condicion Venta */
       FIND gn-convt WHERE gn-convt.Codig = Vtacdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF AVAILABLE gn-convt 
       THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
       ELSE F-CndVta:SCREEN-VALUE = "".

       APPLY "VALUE-CHANGED":U TO VtaCDocu.Cmpbnte.
       RUN Procesa-Handle IN lh_handle ('Recalcula').
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF VtaCDocu.CodMon IN FRAME F-Main /* Cod!mon */
DO:
    IF s-codmon <> INPUT {&self-name} THEN DO:
        s-codmon = INPUT {&self-name}.
        /*RUN Recalcula-Precios.*/
        RUN Procesa-Handle IN lh_handle ('Recalcula').
    END.
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


&Scoped-define SELF-NAME VtaCDocu.FlgIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FlgIgv V-table-Win
ON VALUE-CHANGED OF VtaCDocu.FlgIgv IN FRAME F-Main /* Afecta a IGV */
DO:
    IF s-flgigv <> INPUT {&self-name} THEN DO:
        s-flgigv = INPUT {&self-name}.
        /*RUN Recalcula-Precios.*/
        RUN Procesa-Handle IN lh_handle ('Recalcula').
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON F8 OF VtaCDocu.FmaPgo IN FRAME F-Main /* Condicion de venta */
OR left-mouse-dblclick OF Vtacdocu.FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.
    IF output-var-1 = ? THEN RETURN NO-APPLY.
    Vtacdocu.fmapgo:SCREEN-VALUE = output-var-2.
    f-cndvta:SCREEN-VALUE = output-var-3.
    APPLY 'ENTRY':U TO Vtacdocu.fmapgo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCDocu.FmaPgo V-table-Win
ON LEAVE OF VtaCDocu.FmaPgo IN FRAME F-Main /* Condicion de venta */
DO:
  FIND gn-convt WHERE gn-convt.codig = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt
  THEN f-cndvta:SCREEN-VALUE = gn-ConVt.Nombr.
  ELSE f-cndvta:SCREEN-VALUE = ''.
  IF s-cndvta <> INPUT {&self-name} THEN DO:
      s-cndvta = SELF:SCREEN-VALUE.
      /*RUN Recalcula-Precios.*/
      RUN Procesa-Handle IN lh_handle ('Recalcula').
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
    BUFFER-COPY Vtaddocu 
        EXCEPT VtaDDocu.CanAte VtaDDocu.CanPick
        TO T-DDOCU.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-IBC V-table-Win 
PROCEDURE Control-IBC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rpta AS CHAR.
                                  
/* Cargamos el temporal con las diferencias */
s-pendiente-ibc = NO.
RUN Procesa-Handle IN lh_handle ('IBC').
FIND FIRST T-DPEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DPEDI THEN RETURN 'OK'.

RUN vtagn/d-ibc-dif (OUTPUT x-Rpta).
IF x-Rpta = "ADM-ERROR" THEN RETURN "ADM-ERROR".

{adm/i-DocPssw.i s-CodCia 'IBC' ""UPD""}

/* Continua la grabacion */
s-pendiente-ibc = YES.

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

FOR EACH T-DDOCU BY T-DDOCU.NroItm:
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-entre-companias V-table-Win 
PROCEDURE Importar-entre-companias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Cab AS CHAR NO-UNDO.
  DEF VAR x-Det AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  
  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
    IF VtaCDocu.CodCli:SCREEN-VALUE  = '' OR VtaCDocu.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
        MESSAGE 'Debe ingresar primero el cliente' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO VtaCDocu.CodCli.
        RETURN.
    END.
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.FmaPgo.
      RETURN.
    END.
  END.
  IF NOT ( Vtacdocu.codcli:SCREEN-VALUE = '20511358907'
      OR Vtacdocu.codcli:SCREEN-VALUE = '20100038146' )
      THEN RETURN.

  ASSIGN
    x-Cab = '\\inf251\intercambio\OCC*' + TRIM(VtaCDocu.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}) +
            "*.*".

  SYSTEM-DIALOG GET-FILE x-Cab
  FILTERS 'Ordenes de compra' 'OCC*.*'
  INITIAL-DIR "\\inf251\intercambio"
  RETURN-TO-START-DIR
  TITLE 'Selecciona la Orden de compra'
  MUST-EXIST
  USE-FILENAME
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.

  x-Det = REPLACE(x-Cab, 'OCC', 'OCD').

  /* Datos de Cabecera */
  FOR EACH t-lgcocmp:
    DELETE t-lgcocmp.
  END.
  FOR EACH t-lgdocmp:
    DELETE t-lgdocmp.
  END.
  
  INPUT FROM VALUE(x-cab).
  REPEAT:
    CREATE t-lgcocmp.
    IMPORT t-lgcocmp.
  END.
  INPUT CLOSE.
  INPUT FROM VALUE(x-det).
  REPEAT:
    CREATE t-lgdocmp.
    IMPORT t-lgdocmp.
  END.
  INPUT CLOSE.

  FIND FIRST t-lgcocmp WHERE t-lgcocmp.codpro <> ''.

  DO WITH FRAME {&FRAME-NAME}:
    RUN Borra-Detalle.
    ASSIGN
        VtaCDocu.CodMon:SCREEN-VALUE = STRING(t-lgcocmp.codmon, '9')
        VtaCDocu.NroOrd:SCREEN-VALUE = STRING(t-lgcocmp.nrodoc, '999999').

    FOR EACH t-lgdocmp WHERE t-lgdocmp.codmat <> '':
        CREATE T-DDOCU.
        ASSIGN 
            T-DDOCU.CodCia = s-codcia
            T-DDOCU.codmat = t-lgdocmp.CodMat
            T-DDOCU.Factor = 1
            T-DDOCU.CanPed = t-lgdocmp.CanPedi
            T-DDOCU.NroItm = x-Item
            T-DDOCU.UndVta = t-lgdocmp.UndCmp
            T-DDOCU.AftIgv = (IF t-lgdocmp.IgvMat > 0 THEN YES ELSE NO)
            T-DDOCU.ImpIgv = (IF t-lgdocmp.igvmat > 0 THEN t-lgdocmp.ImpTot / (1 + t-lgdocmp.IgvMat / 100) * t-lgdocmp.IgvMat / 100 ELSE 0)
            T-DDOCU.ImpLin = t-lgdocmp.ImpTot
            T-DDOCU.PreUni = T-DDOCU.ImpLin / T-DDOCU.CanPed.

        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = T-DDOCU.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            MESSAGE 'Producto:' T-DDOCU.codma 'NO registrado'
                VIEW-AS ALERT-BOX WARNING.
            NEXT.
        END.
        IF s-FlgIgv = YES THEN DO:
            T-DDOCU.PorIgv = s-PorIgv.
            IF T-DDOCU.AftIgv = NO THEN DO:
                T-DDOCU.PorIgv = 0.
            END.
        END.
        ELSE DO:
            T-DDOCU.AftIgv = NO.
            T-DDOCU.PorIgv = 0.
        END.
        /* IMPORTE VENTA */
        T-DDOCU.ImpIgv = IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpIgv ELSE 0.
        IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpVta = T-DDOCU.ImpLin - T-DDOCU.ImpIgv.
        IF T-DDOCU.AftIgv = NO  THEN T-DDOCU.ImpVta = 0.
        /* IMPORTE EXONERADO */
        IF T-DDOCU.AftIgv = NO  THEN T-DDOCU.ImpExo = T-DDOCU.ImpLin.
        IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpExo = 0.
        /* IMPORTE BRUTO */
        T-DDOCU.ImpBrt = T-DDOCU.ImpDto + T-DDOCU.ImpExo + T-DDOCU.ImpVta.

        x-Item = x-Item + 1.
    END.
  END.
  
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FlgIgv:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  RUN Procesa-Handle IN lh_handle ('Disable-botones').
  RUN Procesa-Handle IN lh_handle ('browse').
  s-import-cia = YES.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      s-adm-new-record = 'YES'
      s-import-ibc = NO
      s-pendiente-ibc = NO
      s-import-cia = NO.

  {vtagn/i-v-cotcre-01.i}

  RUN Procesa-Handle IN lh_handle ('Enable-botones').
  APPLY "ENTRY":U TO Vtacdocu.codcli IN FRAME {&FRAME-NAME}.

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
      ASSIGN
          Vtacdocu.codcia = s-codcia
          Vtacdocu.codped = s-codped
          Vtacdocu.coddiv = s-coddiv
          /*Vtacdocu.nroped = STRING(Vtacordiv.nroser, '999') + STRING(Vtacordiv.nrocor, '999999')*/
          Vtacdocu.nroped = STRING(Vtacordiv.nroser, '999') + STRING(vNroCor, '999999')
          VtaCDocu.FchCre = TODAY
          Vtacdocu.usuario = s-user-id.
/*       ASSIGN                                       */
/*           Vtacordiv.nrocor = Vtacordiv.nrocor + 1. */
      IF s-import-ibc = YES THEN VtaCDocu.CodOri = "IBC".
      IF s-import-cia = YES THEN VtaCDocu.CodOri = "O/C".
  END.
  ELSE DO:
      RUN Borra-Detalle.
  END.
  ASSIGN
      Vtacdocu.PorIgv = ( IF s-FlgIgv THEN Faccfggn.porigv ELSE 0 )
      VtaCDocu.FchMod = TODAY
      VtaCDocu.UsrMod = s-user-id.

  RUN Graba-Detalle.

  RUN Verifica-Cotizacion.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF VtaCDocu.CodOri = "IBC" THEN DO:
      MESSAGE "NO se puede copiar una cotización de SUPERMERCADOS"
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  IF VtaCDocu.CodOri = "O/C" THEN DO:
      MESSAGE "NO se puede copiar una cotización de venta entre empresas"
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {vtagn/i-v-cotcre-01.i}

  /*RUN Recalcula-Precios.*/
  RUN Procesa-Handle IN lh_handle ('Recalcula').

  APPLY "ENTRY":U TO Vtacdocu.codcli IN FRAME {&FRAME-NAME}.

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
          MESSAGE 'La Cotización ya tiene Pedidos'
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
  FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Vtacdocu THEN RETURN "ADM-ERROR".
  ASSIGN
      VtaCDocu.FchAnu = TODAY
      VtaCDocu.FlgEst = "A"
      VtaCDocu.UsrAnu = s-user-id.
  FIND CURRENT Vtacdocu NO-LOCK NO-ERROR.
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
          VtaCDocu.FchPed:SENSITIVE = NO
          VtaCDocu.FchVen:SENSITIVE = NO
          VtaCDocu.CodVen:SENSITIVE = NO
          VtaCDocu.CodCli:SENSITIVE = NO
          VtaCDocu.DirCli:SENSITIVE = NO
          VtaCDocu.DniCli:SENSITIVE = NO
          VtaCDocu.FchPed:SENSITIVE = NO
          VtaCDocu.FchVen:SENSITIVE = NO
          VtaCDocu.NomCli:SENSITIVE = NO
          VtaCDocu.RucCli:SENSITIVE = NO
          VtaCDocu.TpoCmb:SENSITIVE = NO.
      RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
      IF RETURN-VALUE = "NO" THEN DO:
          IF VtaCDocu.CodOri = "IBC" THEN DO:
              /* BLOQUEAMOS CAMPOS */
              ASSIGN
                  VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.FlgIgv:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.CodVen:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
          END.
          IF VtaCDocu.CodOri = "O/C" THEN DO:
              /* BLOQUEAMOS CAMPOS */
              ASSIGN
                  VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.FlgIgv:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
          END.
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Supermercados V-table-Win 
PROCEDURE Supermercados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
  DEF VAR x-CodMat LIKE T-DDOCU.codmat NO-UNDO.
  DEF VAR x-CanPed LIKE T-DDOCU.canped NO-UNDO.
  DEF VAR x-ImpLin LIKE T-DDOCU.implin NO-UNDO.
  DEF VAR x-ImpIgv LIKE T-DDOCU.impigv NO-UNDO.
  DEF VAR x-Encabezado AS LOG INIT FALSE.
  DEF VAR x-Detalle    AS LOG INIT FALSE.
  DEF VAR x-NroItm AS INT INIT 0.
  DEF VAR x-Ok AS LOG.
  DEF VAR x-Item AS CHAR NO-UNDO.
  
/*ML01*/ DEFINE VARIABLE cSede AS CHARACTER NO-UNDO.

  /* CONSISTENCIA PREVIA */
  DO WITH FRAME {&FRAME-NAME}:
      IF VtaCDocu.CodCli:SCREEN-VALUE = ''
      THEN DO:
        MESSAGE 'Debe ingresar primero el código del cliente'
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO VtaCDocu.CodCli.
        RETURN.
      END.
    IF VtaCDocu.CodVen:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero el codigo del vendedor'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.CodVen.
      RETURN.
    END.
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = ''
    THEN DO:
      MESSAGE 'Debe ingresar primero condicion de venta'
          VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO VtaCDocu.FmaPgo.
      RETURN.
    END.
  END.

  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS 'Archivo texto (.txt)' '*.txt'
      RETURN-TO-START-DIR
      TITLE 'Selecciona al archivo texto'
      MUST-EXIST
      USE-FILENAME
      UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Borra-Temporal.
    
  INPUT FROM VALUE(x-Archivo).
  TEXTO:
  REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' 
    THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        x-Item = ENTRY(6,x-Linea).
        VtaCDocu.nroord:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(x-Item,11,10).
    END.
    IF x-Linea BEGINS 'DTM' 
    THEN DO:
        x-Item = ENTRY(5,x-Linea).
        ASSIGN
            VtaCDocu.fchven:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DATE(SUBSTRING(x-Item,7,2) + '/' +
                                                                                  SUBSTRING(x-Item,5,2) + '/' +
                                                                                 SUBSTRING(x-Item,1,4)) )
            NO-ERROR.
    END.
/*ML01* Inicio de bloque */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
        FIND FIRST GN-ClieD WHERE GN-ClieD.CodCia = CL-CODCIA
            AND GN-ClieD.CodCli = VtaCDocu.Codcli:SCREEN-VALUE
            AND GN-ClieD.Libre_c01 = cSede
            NO-LOCK NO-ERROR.
        IF AVAILABLE GN-ClieD THEN
            ASSIGN
                Vtacdocu.lugent:SCREEN-VALUE = GN-ClieD.dircli
                VtaCDocu.sede:SCREEN-VALUE = GN-ClieD.sede.
    END.
/*ML01* Fin de bloque */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES
    THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.

        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codbrr = x-codmat
                AND Almmmatg.tpoart <> 'D'
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN x-codmat = almmmatg.codmat.
        END.
        IF NOT AVAILABLE Almmmatg
        THEN DO:
            MESSAGE "El Item" x-Item x-codmat "no esta registrado en el catalogo"
                    VIEW-AS ALERT-BOX ERROR.
            NEXT TEXTO.
        END.

        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            CREATE T-DDOCU.
            ASSIGN 
                T-DDOCU.CodCia = s-codcia
                T-DDOCU.codmat = x-CodMat
                T-DDOCU.Factor = 1 
                T-DDOCU.CanPed = x-CanPed
                T-DDOCU.NroItm = x-NroItm 
                T-DDOCU.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                /*T-DDOCU.ALMDES = S-CODALM*/
                T-DDOCU.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
            /* RHC 09.08.06 IGV de acuerdo al cliente */
            IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
            THEN ASSIGN
                    T-DDOCU.ImpIgv = x-ImpIgv 
                    T-DDOCU.ImpLin = x-ImpLin
                    T-DDOCU.PreUni = (T-DDOCU.ImpLin / T-DDOCU.CanPed).
            ELSE ASSIGN
                    T-DDOCU.ImpIgv = x-ImpIgv 
                    T-DDOCU.ImpLin = x-ImpLin + x-ImpIgv
                    T-DDOCU.PreUni = (T-DDOCU.ImpLin / T-DDOCU.CanPed).
            ASSIGN 
              T-DDOCU.PreBas = T-DDOCU.PreUni
              T-DDOCU.AftIgv = Almmmatg.AftIgv 
              T-DDOCU.AftIsc = Almmmatg.AftIsc.
            IF s-FlgIgv = YES THEN DO:
                T-DDOCU.PorIgv = s-PorIgv.
                IF T-DDOCU.AftIgv = NO THEN DO:
                    T-DDOCU.PorIgv = 0.
                END.
            END.
            ELSE DO:
                T-DDOCU.AftIgv = NO.
                T-DDOCU.PorIgv = 0.
            END.
            /* IMPORTE VENTA */
            T-DDOCU.ImpIgv = IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpIgv ELSE 0.
            IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpVta = T-DDOCU.ImpLin - T-DDOCU.ImpIgv.
            IF T-DDOCU.AftIgv = NO  THEN T-DDOCU.ImpVta = 0.
            /* IMPORTE EXONERADO */
            IF T-DDOCU.AftIgv = NO  THEN T-DDOCU.ImpExo = T-DDOCU.ImpLin.
            IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpExo = 0.
            /* IMPORTE BRUTO */
            T-DDOCU.ImpBrt = T-DDOCU.ImpDto + T-DDOCU.ImpExo + T-DDOCU.ImpVta.
        END.
    END.
  END.
  INPUT CLOSE.
  /* BLOQUEAMOS CAMPOS */
  ASSIGN
      VtaCDocu.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FlgIgv:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.CodVen:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      VtaCDocu.FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  RUN Procesa-Handle IN lh_handle ('Disable-botones').
  RUN Procesa-Handle IN lh_handle ('browse').
  SESSION:SET-WAIT-STATE('').
  
  /* Variable de control */
  s-import-ibc = YES.

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
/*     DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.                                        */
/*     DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.                                        */
/*     FOR EACH T-DDOCU NO-LOCK:                                                               */
/*         F-Tot = F-Tot + T-DDOCU.ImpLin.                                                     */
/*     END.                                                                                    */
/*     IF F-Tot = 0 THEN DO:                                                                   */
/*        MESSAGE "** Importe total debe ser mayor a cero **" VIEW-AS ALERT-BOX ERROR.         */
/*        RETURN "ADM-ERROR".                                                                  */
/*     END.                                                                                    */
/*     /* RHC 20.09.05 Transferencia gratuita */                                               */
/*     IF VtaCDocu.FmaPgo:SCREEN-VALUE = '900' AND VtaCDocu.NroCar:SCREEN-VALUE <> '' THEN DO: */
/*         MESSAGE 'En caso de transferencia gratuita NO es válido el Nº de Tarjeta'           */
/*             VIEW-AS ALERT-BOX WARNING.                                                      */
/*         RETURN 'ADM-ERROR'.                                                                 */
/*     END.                                                                                    */
/*     /* IMPORTE MINIMO */                                                                    */
/*     DEF VAR pImpMin AS DEC NO-UNDO.                                                         */
/*                                                                                             */
/*     FOR EACH T-DDOCU NO-LOCK:                                                               */
/*         f-Bol = f-Bol + T-DDOCU.ImpLin.                                                     */
/*     END.                                                                                    */
/*     IF s-codmon = 2 THEN f-Bol = f-Bol * s-TpoCmb.                                          */
/*     RUN gn/pMinCotPed (s-CodCia,                                                            */
/*                        s-CodDiv,                                                            */
/*                        s-CodPed,                                                            */
/*                        OUTPUT pImpMin).                                                     */
/*     IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:                                             */
/*         MESSAGE 'El importe mínimo para COTIZACIONES es de S/.' pImpMin SKIP                */
/*             'Solo ha cotizacion S/.' f-Bol                                                  */
/*             VIEW-AS ALERT-BOX ERROR.                                                        */
/*         RETURN "ADM-ERROR".                                                                 */
/*     END.                                                                                    */
    
    {vtagn/i-v-cotcre-02.i}

    /* rhc 22.06.09 Control de Precios IBC */
    IF s-Import-IBC = YES THEN DO:
         RUN CONTROL-IBC.
         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
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
  RUN vtagn/p-fmapgo-01 (Vtacdocu.codcli, OUTPUT s-cndvta-validos).
  ASSIGN
      s-codcli = Vtacdocu.codcli
      s-codmon = Vtacdocu.codmon
      s-cndvta = Vtacdocu.fmapgo
      s-flgigv = Vtacdocu.flgigv
      s-porigv = Vtacdocu.porigv
      s-adm-new-record = 'NO'
      s-import-ibc = NO
      s-pendiente-ibc = NO
      s-import-cia = NO.
  IF VtaCDocu.CodOri = "IBC" THEN DO:
      s-import-ibc = YES.
  END.
  IF VtaCDocu.CodOri = "O/C" THEN DO:
      s-import-cia = YES.
  END.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Cotizacion V-table-Win 
PROCEDURE Verifica-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* APROBACION AUTOMATICA */
VtaCDocu.FlgEst = IF s-FlgAprCot = YES THEN "P" ELSE "X".

/* CONSISTENCIAS FINALES */
IF Vtacdocu.flgest = "P" THEN DO:
    /* Margenes */
    FIND FIRST Vtaddocu OF Vtacdocu WHERE VtaDDocu.MrgUti <= 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Vtaddocu THEN Vtacdocu.FlgEst = "X".
    /* PRECIOS SUPERMERCADOS */
    IF s-import-ibc = YES AND s-pendiente-ibc = YES THEN Vtacdocu.flgest = 'X'.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

