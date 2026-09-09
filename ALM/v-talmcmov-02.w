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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.

DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.

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
&Scoped-define EXTERNAL-TABLES Almcmov
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.NroSer Almcmov.NroDoc Almcmov.CodCli ~
Almcmov.CodMon Almcmov.CodPro Almcmov.NroRf1 Almcmov.AlmDes Almcmov.NroRf2 ~
Almcmov.Observ Almcmov.NroRf3 Almcmov.CodTra Almcmov.cco 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-6 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroSer Almcmov.NroDoc ~
Almcmov.FchDoc Almcmov.CodCli Almcmov.CodMon Almcmov.CodPro Almcmov.NroRf1 ~
Almcmov.AlmDes Almcmov.NroRf2 Almcmov.Observ Almcmov.NroRf3 Almcmov.CodTra ~
Almcmov.usuario Almcmov.cco 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-Situacion FILL-IN-NomCli ~
FILL-IN-NomPro F-AlmRef 

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
DEFINE VARIABLE F-AlmRef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-Situacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 5.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroSer AT ROW 1.27 COL 20 COLON-ALIGNED WIDGET-ID 48
          LABEL "Numero Documento"
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .69
     Almcmov.NroDoc AT ROW 1.27 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 50 FORMAT "999999999"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     F-Estado AT ROW 1.27 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     F-Situacion AT ROW 1.27 COL 58 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     Almcmov.FchDoc AT ROW 1.27 COL 86 COLON-ALIGNED WIDGET-ID 22 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Almcmov.CodCli AT ROW 2.08 COL 20 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-NomCli AT ROW 2.08 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     Almcmov.CodMon AT ROW 2.08 COL 89.14 NO-LABEL WIDGET-ID 8
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .69
     Almcmov.CodPro AT ROW 2.88 COL 20 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-NomPro AT ROW 2.88 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     Almcmov.NroRf1 AT ROW 2.88 COL 86 COLON-ALIGNED WIDGET-ID 30
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.AlmDes AT ROW 3.69 COL 20 COLON-ALIGNED WIDGET-ID 2
          LABEL "Almacen Destino"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     F-AlmRef AT ROW 3.69 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     Almcmov.NroRf2 AT ROW 3.69 COL 86 COLON-ALIGNED WIDGET-ID 32
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.Observ AT ROW 4.5 COL 20 COLON-ALIGNED WIDGET-ID 36 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 49.72 BY .69
     Almcmov.NroRf3 AT ROW 4.5 COL 86 COLON-ALIGNED WIDGET-ID 34
          LABEL "O/T" FORMAT "xxx-xxxxxx"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.CodTra AT ROW 5.31 COL 20 COLON-ALIGNED WIDGET-ID 14
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Almcmov.usuario AT ROW 5.31 COL 58 COLON-ALIGNED WIDGET-ID 44
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.cco AT ROW 5.31 COL 86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 2.08 COL 82 WIDGET-ID 42
     RECT-6 AT ROW 1 COL 1 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 0 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almcmov
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
         HEIGHT             = 5.69
         WIDTH              = 102.57.
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

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.CodTra IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-AlmRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Situacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroSer IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almcmov.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME Almcmov.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodCli V-table-Win
ON LEAVE OF Almcmov.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Almcmov.CodCli:VISIBLE THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-CodCia 
                      AND  gn-clie.CodCli = INPUT Almcmov.CodCli 
                     NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodPro V-table-Win
ON LEAVE OF Almcmov.CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF Almcmov.CodPro:VISIBLE THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
                        AND  gn-prov.CodPro = INPUT Almcmov.CodPro
                       NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodTra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodTra V-table-Win
ON LEAVE OF Almcmov.CodTra IN FRAME F-Main /* Transportista */
DO:

  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AdmRutas WHERE AdmRutas.CodPro = Almcmov.CodTra:SCREEN-VALUE
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AdmRutas THEN DO:
     MESSAGE " Código de Transportista no existe " VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
/*  F-NomTra:SCREEN-VALUE = AdmRutas.NomTra.*/
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
  {src/adm/template/row-list.i "Almcmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          Almcmov.NroRf1:LABEL = ""
          Almcmov.NroRf2:LABEL = ""
          Almcmov.NroRf3:LABEL = ""
          F-AlmRef:SCREEN-VALUE = ""
          F-Estado:SCREEN-VALUE = ""
          FILL-IN-NomPro:SCREEN-VALUE = ""
          FILL-IN-NomCli:SCREEN-VALUE = ""
          f-Situacion:SCREEN-VALUE = "".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
      FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
          AND  Almtmovm.Tipmov = Almcmov.TipMov 
          AND  Almtmovm.Codmov = Almcmov.CodMov 
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtmovm THEN DO:
          ASSIGN 
              Almcmov.CodCli:VISIBLE = Almtmovm.PidCli
              Almcmov.CodPro:VISIBLE = Almtmovm.PidPro
              Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
              Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
              Almcmov.AlmDes:VISIBLE = Almtmovm.MovTrf
              F-AlmRef:VISIBLE = Almtmovm.MovTrf
              Almcmov.cco:VISIBLE = Almtmovm.PidCCt.
          Almcmov.Nrorf3:VISIBLE = FALSE.
          IF Almtmovm.Codmov = 50 OR Almtmovm.Codmov = 51 
              THEN Almcmov.Nrorf3:VISIBLE = TRUE.
          IF Almtmovm.CodMon <> 3 THEN DO:
              ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(Almtmovm.CodMon,'9').
          END.
          IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
          IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
          IF Almtmovm.TipMov = "S" THEN DO:
              ASSIGN Almcmov.CodMon:SCREEN-VALUE = '1'.
          END.
      END.
     F-Estado:SCREEN-VALUE = "".
     IF Almcmov.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "  ANULADO   ".  
     IF Almcmov.CodPro:VISIBLE THEN DO:
             FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
                           AND  gn-prov.CodPro = Almcmov.CodPro 
                          NO-LOCK NO-ERROR.
             IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
     END.
     IF Almcmov.CodCli:VISIBLE THEN DO:
             FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                           AND  gn-clie.CodCli = Almcmov.CodCli 
                          NO-LOCK NO-ERROR.
             IF AVAILABLE gn-clie AND Almcmov.CodCli <> "11111111111" THEN 
                  DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
             ELSE DISPLAY Almcmov.NomRef @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
     END.
     IF Almcmov.AlmDes:VISIBLE THEN DO:
        F-AlmRef = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                      AND  Almacen.CodAlm = Almcmov.AlmDes 
                     NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN F-AlmRef = Almacen.Descripcion.
        DISPLAY F-AlmRef.
     END.
    /* RHC 27.10.04 Solo para movimiento 10 */
    DEF VAR x-CanDes AS DEC INIT 0.
    DEF VAR x-CanDev AS DEC INIT 0.
    f-Situacion:SCREEN-VALUE = ''.
    IF Almcmov.codmov = 10
    THEN DO:
        FOR EACH Almdmov OF Almcmov NO-LOCK:
            ASSIGN
                x-CanDes = x-CanDes + Almdmov.candes
                x-CanDev = x-CanDev + Almdmov.candev.
        END.
        IF x-CanDev = 0 THEN f-Situacion:SCREEN-VALUE = 'POR DEVOLVER'.
        ELSE IF x-CanDev < x-CanDes THEN f-Situacion:SCREEN-VALUE = 'DEV. PARCIAL'.
            ELSE f-Situacion:SCREEN-VALUE = 'DEV. TOTAL'.
    END.
    /* *********************************** */
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
  {src/adm/template/snd-list.i "Almcmov"}

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
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

