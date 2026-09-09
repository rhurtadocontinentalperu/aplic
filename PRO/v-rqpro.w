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

DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-DESALM  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.


DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED TEMP-TABLE DRQP LIKE PR-RQPROD.

DEFINE STREAM Reporte.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA AS LOGICAL NO-UNDO.


DEFINE BUFFER B-RQPROC FOR PR-RQPROC.

DEFINE VARIABLE X-ESTADO AS CHAR.

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
&Scoped-define EXTERNAL-TABLES PR-RQPROC
&Scoped-define FIRST-EXTERNAL-TABLE PR-RQPROC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PR-RQPROC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PR-RQPROC.Almdes PR-RQPROC.Observ ~
PR-RQPROC.FchVto 
&Scoped-define ENABLED-TABLES PR-RQPROC
&Scoped-define FIRST-ENABLED-TABLE PR-RQPROC
&Scoped-Define ENABLED-OBJECTS RECT-18 
&Scoped-Define DISPLAYED-FIELDS PR-RQPROC.Almdes PR-RQPROC.NumOrd ~
PR-RQPROC.FchDoc PR-RQPROC.Observ PR-RQPROC.FchVto PR-RQPROC.Usuario ~
PR-RQPROC.HorGen 
&Scoped-define DISPLAYED-TABLES PR-RQPROC
&Scoped-define FIRST-DISPLAYED-TABLE PR-RQPROC
&Scoped-Define DISPLAYED-OBJECTS Fill-in-NroPed F-ESTADO F-DesAlm F-Respon 

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
DEFINE VARIABLE F-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-ESTADO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-Respon AS CHARACTER FORMAT "X(256)":U 
     LABEL "Responsable" 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .69 NO-UNDO.

DEFINE VARIABLE Fill-in-NroPed AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "No.Pedido" 
     VIEW-AS FILL-IN 
     SIZE 15.29 BY .69
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 4.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Fill-in-NroPed AT ROW 1.19 COL 11 COLON-ALIGNED WIDGET-ID 38
     F-ESTADO AT ROW 1.19 COL 71 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     PR-RQPROC.Almdes AT ROW 1.85 COL 11.14 COLON-ALIGNED WIDGET-ID 26
          LABEL "Alm.Despacho"
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .69
     F-DesAlm AT ROW 1.85 COL 16.86 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     PR-RQPROC.NumOrd AT ROW 1.88 COL 74.14 COLON-ALIGNED WIDGET-ID 42
          LABEL "Orden Produccion"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
          BGCOLOR 15 FGCOLOR 1 
     F-Respon AT ROW 2.58 COL 11 COLON-ALIGNED WIDGET-ID 32
     PR-RQPROC.FchDoc AT ROW 2.62 COL 75.43 COLON-ALIGNED WIDGET-ID 34
          LABEL "Fecha Emision"
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .69
     PR-RQPROC.Observ AT ROW 3.38 COL 10.86 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .69
     PR-RQPROC.FchVto AT ROW 3.38 COL 75.43 COLON-ALIGNED WIDGET-ID 36
          LABEL "Fecha Entrega"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .69
     PR-RQPROC.Usuario AT ROW 4.15 COL 10.86 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 15.57 BY .69
     PR-RQPROC.HorGen AT ROW 4.19 COL 77.86 COLON-ALIGNED WIDGET-ID 40
          LABEL "Hora Generacion"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     RECT-18 AT ROW 1.04 COL 1.29 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PR-RQPROC
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
         HEIGHT             = 4.58
         WIDTH              = 88.86.
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

/* SETTINGS FOR FILL-IN PR-RQPROC.Almdes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ESTADO IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Respon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-RQPROC.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PR-RQPROC.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Fill-in-NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-RQPROC.HorGen IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PR-RQPROC.NumOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PR-RQPROC.Usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME PR-RQPROC.Almdes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-RQPROC.Almdes V-table-Win
ON LEAVE OF PR-RQPROC.Almdes IN FRAME F-Main /* Alm.Despacho */
DO:
  IF PR-RQPROC.Almdes:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
  IF PR-RQPROC.Almdes:SCREEN-VALUE = S-CODALM THEN DO:
      MESSAGE "No puede solicitarse asi mismo" 
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                     Almacen.CodAlm = PR-RQPROC.Almdes:SCREEN-VALUE 
                     NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN DO:
     F-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
     F-Respon:SCREEN-VALUE = Almacen.EncAlm.
     C-CODALM = Almacen.CodAlm.
     PR-RQPROC.Almdes:SENSITIVE = FALSE.
  END.
  ELSE DO:
   MESSAGE "Codigo de almacen no existe" VIEW-AS ALERT-BOX ERROR.
   F-DesAlm:SCREEN-VALUE = "".
   RETURN NO-APPLY.
  END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DRQP V-table-Win 
PROCEDURE Actualiza-DRQP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DRQP:
    DELETE DRQP.
END.
IF NOT L-CREA THEN DO:
   FOR EACH PR-RQPROD OF PR-RQPROC NO-LOCK :
       CREATE DRQP.
       ASSIGN DRQP.CodCia = PR-RQPROD.CodCia 
              DRQP.CodAlm = PR-RQPROD.CodAlm 
              DRQP.codmat = PR-RQPROD.codmat 
              DRQP.CanReq = PR-RQPROD.CanReq.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "PR-RQPROC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PR-RQPROC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Orden-Produccion V-table-Win 
PROCEDURE Asigna-Orden-Produccion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT L-CREA THEN RETURN "ADM-ERROR".

input-var-1 = "A,C,B". 

RUN LKUP\C-OPPEN("Ordenes de Produccion Pendientes").

IF output-var-1 = ? THEN RETURN.

FOR EACH DRQP:
    DELETE DRQP.
END.

FIND PR-ODPC WHERE ROWID(PR-ODPC) = output-var-1 NO-LOCK NO-ERROR.

IF AVAILABLE PR-ODPC THEN DO WITH FRAME {&FRAME-NAME}:
   IF PR-ODPC.CodAlm <> S-CODALM THEN DO:
      MESSAGE "ALMACEN NO ASIGNADO PARA EJECUTAR ORDEN DE PRODUCCION "
              VIEW-AS ALERT-BOX .
      RETURN .
   END.                    

   DISPLAY PR-ODPC.NumOrd @ PR-RQPROC.NumOrd .

   DEFINE VAR X-DISPONE AS DECI INIT 0.        

   FOR EACH PR-ODPD NO-LOCK WHERE PR-ODPD.CodCia = PR-ODPC.CodCia 
                             AND  PR-ODPD.NumOrd = PR-ODPC.NumOrd 
                             AND (PR-ODPD.CanPed - PR-ODPD.CanDes) > 0
                             BREAK BY PR-ODPD.CodMat:
        
        IF FIRST-OF(PR-ODPD.CodMat)
        THEN x-Dispone = 0.
        
       FIND Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                           Almmmate.Codalm = S-CODALM AND
                           Almmmate.Codmat = PR-ODPD.Codmat NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE "Codigo : " + PR-ODPD.Codmat + " No Asignado al Almacen, Verifique " 
          VIEW-AS ALERT-BOX.
          NEXT.
       END.

       FIND Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                           Almmmate.Codalm = C-CODALM AND
                           Almmmate.Codmat = PR-ODPD.Codmat NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE "Codigo : " + PR-ODPD.Codmat + " No Asignado al Almacen Despacho " 
          VIEW-AS ALERT-BOX.
          NEXT.
       END.
       IF Almmmate.StkAct = 0  THEN DO:
          MESSAGE "Codigo : " + PR-ODPD.Codmat + " Sin Stock en Almacen de Despacho" 
          VIEW-AS ALERT-BOX.
          NEXT.
       END.
       /*X-DISPONE = (PR-ODPD.CanPed - PR-ODPD.CanDes).*/
        X-DISPONE = x-Dispone + (PR-ODPD.CanPed - PR-ODPD.CanDes).       
        IF LAST-OF(PR-ODPD.CodMat)
        THEN DO:
            IF Almmmate.StkAct < X-DISPONE THEN X-DISPONE = Almmmate.StkAct. 
            CREATE DRQP.
            ASSIGN DRQP.CodCia = S-CODCIA 
                DRQP.CodAlm = S-CODALM
                DRQP.Codmat = PR-ODPD.Codmat 
                DRQP.Canreq = X-DISPONE 
                DRQP.CanDes = Almmmate.StkAct.
        END.
   END.

END.


RUN Procesa-Handle IN lh_Handle ('Browse').

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
    FOR EACH PR-RQPROD OF PR-RQPROC EXCLUSIVE-LOCK 
             ON ERROR UNDO, RETURN "ADM-ERROR":
        DELETE PR-RQPROD.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Reposicion V-table-Win 
PROCEDURE Genera-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH PR-RQPROD WHERE PR-RQPROD.Codcia = PR-RQPROC.Codcia AND
                               PR-RQPROD.CodAlm = PR-RQPROC.CodAlm AND
                               PR-RQPROD.NroSer = PR-RQPROC.NroSer AND
                               PR-RQPROD.NroDoc = PR-RQPROC.NroDoc:
          DELETE PR-RQPROD.
      END.
      FOR EACH DRQP WHERE DRQP.canreq > 0:
          CREATE PR-RQPROD.
          ASSIGN PR-RQPROD.CodCia = PR-RQPROC.CodCia
                 PR-RQPROD.CodAlm = PR-RQPROC.CodAlm
                 PR-RQPROD.NroSer = PR-RQPROC.NroSer
                 PR-RQPROD.NroDoc = PR-RQPROC.NroDoc
                 PR-RQPROD.codmat = DRQP.codmat
                 PR-RQPROD.CanReq = DRQP.canreq
                 PR-RQPROD.AlmDes = PR-RQPROC.AlmDes.
          RELEASE PR-RQPROD.
      END.
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  C-CODALM = "".
  
  DO WITH FRAME {&FRAME-NAME}:
     /*** CORRELATIVO AUTOMATICO  ***/
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        ASSIGN Fill-in-NroPed = STRING(S-NROSER,"999") + STRING(FacCorre.Correlativo,"999999").
     END.

     DISPLAY Fill-in-NroPed
              TODAY  @ PR-RQPROC.FchDoc 
              TODAY  @ PR-RQPROC.FchVto
           S-USER-ID @ PR-RQPROC.Usuario.
     ASSIGN
     PR-RQPROC.AlmDes:SCREEN-VALUE = ""
     PR-RQPROC.Observ:SCREEN-VALUE = "".      
  END.
  
  RUN Actualiza-DRQP.
  
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

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
  IF L-CREA THEN DO:
      /*** CORRELATIVO AUTOMATICO  ***/
      FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV AND
           FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
     ASSIGN PR-RQPROC.CodCia = S-CODCIA
            PR-RQPROC.CodAlm = S-CODALM
            PR-RQPROC.NroSer = S-NROSER
            PR-RQPROC.FchDoc = TODAY
            PR-RQPROC.FlgEst = "P" 
            PR-RQPROC.HorGen = STRING(TIME,"HH:MM")
            PR-RQPROC.Usuario = S-USER-ID
            PR-RQPROC.NumOrd = PR-RQPROC.NumOrd:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            PR-RQPROC.AlmDes = PR-RQPROC.AlmDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            PR-RQPROC.Observ = PR-RQPROC.Observ:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            PR-RQPROC.FchVto = DATE(PR-RQPROC.FchVto:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
            
    ASSIGN 
        PR-RQPROC.NroDoc = FacCorre.Correlativo
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
  END.
  
  RUN Genera-Reposicion.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Verifica-Requerimiento.

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  IF PR-RQPROC.FlgEst = "C" THEN DO:
     MESSAGE "El Requerimiento ya fue atendido no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  FOR EACH PR-RQPROD OF PR-RQPROC NO-LOCK:
      IF PR-RQPROD.CanDes > 0 THEN DO:
         MESSAGE "El Requerimiento esta en proceso de Atencion"
         VIEW-AS ALERT-BOX.
         RETURN "ADM-ERROR".
      END.
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":

    RUN Borra-Detalle.
      
    FIND B-RQPROC WHERE B-RQPROC.Codcia = PR-RQPROC.Codcia AND
                        B-RQPROC.CodAlm = PR-RQPROC.CodAlm AND
                        B-RQPROC.NroSer = PR-RQPROC.NroSer AND
                        B-RQPROC.NroDoc = PR-RQPROC.NroDoc EXCLUSIVE-LOCK NO-ERROR. 
    ASSIGN 
      B-RQPROC.FlgEst = "A".
    
    RELEASE B-RQPROC.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
  IF AVAILABLE PR-RQPROC THEN DO WITH FRAME {&FRAME-NAME}:
     CASE PR-RQPROC.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY " ATENDIDO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "B" THEN DISPLAY "X APROBAR" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
     END CASE. 
     Fill-in-NroPed:SCREEN-VALUE = STRING(PR-RQPROC.NroSer,"999") + STRING(PR-RQPROC.NroDoc,"999999").
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                        Almacen.CodAlm = PR-RQPROC.Almdes NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN DO:
        F-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
        F-Respon:SCREEN-VALUE = Almacen.EncAlm.
     END.   
     ELSE F-DesAlm:SCREEN-VALUE = "".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CASE PR-RQPROC.FlgEst:
       WHEN "A" THEN X-ESTADO = " ANULADO " .
       WHEN "C" THEN X-ESTADO = " ATENDIDO" .
       WHEN "B" THEN X-ESTADO = "X APROBAR" .
       WHEN "P" THEN X-ESTADO = "PENDIENTE" .

  END. 

  DEFINE VARIABLE S-Tit  AS CHAR NO-UNDO.
  DEFINE VARIABLE S-Item AS INTEGER INIT 0.
  DEFINE VAR S-DesSol AS CHAR FORMAT "X(60)" NO-UNDO.
  DEFINE VAR S-CODUBI AS CHAR NO-UNDO.
  DEFINE VAR F-STOCK AS DECIMAL NO-UNDO.
  DEFINE FRAME F-FMT
         S-Item AT 2 FORMAT "Z9"
         PR-RQPROD.codmat AT 6   FORMAT "X(6)"
         S-CODUBI        AT 13  FORMAT "X(6)"
         Almmmatg.DesMat AT 21  FORMAT "X(40)"
         Almmmatg.DesMar AT 63  FORMAT "X(12)"
         Almmmatg.UndStk AT 76  FORMAT "X(4)"
         Almmmatg.CanEmp AT 81  FORMAT ">>,>>9.99"
         F-STOCK         AT 92  FORMAT ">>>,>>>.99"
         PR-RQPROD.CanReq AT 104 FORMAT ">,>>>,>>9.99"
         "------------" AT 118
         HEADER
         S-NOMCIA AT 1 "REPOSICION No. : " AT 103 PR-RQPROC.NroDoc AT 123 SKIP
         "( " + S-CODALM + " )" AT 2 "SOLICITUD DE REPOSICION INTERNO" AT 50  "PAG. " AT 103 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         X-ESTADO AT 103 SKIP
         "Solicitado      : "   AT 1 S-DESSOL AT 21 "Fecha      : " AT 87 PR-RQPROC.FchDoc AT 105 SKIP
         "Responsable     : "   AT 1 Almacen.EncAlm AT 21 "Hora       : " AT 87 PR-RQPROC.HorGen AT 105 SKIP
         "Observaciones   : "   AT 1 PR-RQPROC.Observ  AT 21 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO UB.FIS.               DESCRIPCION                    MARCA     UND   EMPAQUE   STOCK ACTUAL  SOLICITADO    APROBADO  " SKIP    
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.
/*
 *   OUTPUT STREAM Reporte TO VALUE( s-port-name ) PAGED PAGE-SIZE 30.
 * */

    DEF VAR lOk AS LOGICAL NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE lOk.
    IF lOk <> TRUE THEN RETURN.
    OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.

  FIND FIRST PR-RQPROD WHERE 
             PR-RQPROD.CodCia = PR-RQPROC.CodCia AND
             PR-RQPROD.CodAlm = PR-RQPROC.CodAlm AND
             PR-RQPROD.NroDoc = PR-RQPROC.NroDoc NO-LOCK NO-ERROR.
  IF AVAILABLE PR-RQPROD THEN DO:
     S-DesSol = PR-RQPROC.AlmDes.
     FIND Almacen WHERE Almacen.CodCia = PR-RQPROD.CodCia AND
          Almacen.CodAlm = PR-RQPROC.AlmDes NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN  S-DesSol = S-DesSol + " " + Almacen.Descripcion.
     PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(33).
     PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
     FOR EACH PR-RQPROD NO-LOCK WHERE AVAILABLE PR-RQPROD
                                AND  PR-RQPROD.CodCia = PR-RQPROC.CodCia
                                AND  PR-RQPROD.CodAlm = PR-RQPROC.CodAlm
                                AND  PR-RQPROD.NroSer = PR-RQPROC.NroSer
                                AND  PR-RQPROD.NroDoc = PR-RQPROC.NroDoc,
         FIRST Almmmatg OF PR-RQPROD NO-LOCK
                               BREAK /*BY PR-RQPROD.AlmDes
                                     BY Almmmatg.DesMat*/
                                     BY PR-RQPROD.CodCia
                                     BY PR-RQPROD.CodMat:
         S-Item = S-Item + 1.
         S-CODUBI = "".
         F-STOCK  = 0.
         FIND Almmmate OF PR-RQPROD NO-LOCK NO-ERROR.
         IF AVAILABLE Almmmate THEN 
            ASSIGN S-CODUBI = Almmmate.CodUbi
                   F-STOCK  = Almmmate.StkAct.
         
         DISPLAY STREAM Reporte 
                   S-Item
                   PR-RQPROD.Codmat 
                   S-CODUBI 
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   Almmmatg.CanEmp
                   F-STOCK  
                   PR-RQPROD.CanReq WITH FRAME F-FMT.
         DOWN STREAM Reporte WITH FRAME F-FMT.
     END.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "        ------------------                ------------------              ------------------  " AT 10 SKIP.
  PUT STREAM Reporte "             Operador                         Supervisor                        Vo.Bo.        " AT 10 SKIP.
  PUT STREAM Reporte PR-RQPROC.Usuario AT 24 " JEFE ALMACEN " AT 86 SKIP.     
  OUTPUT STREAM Reporte CLOSE.

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
  {src/adm/template/snd-list.i "PR-RQPROC"}

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
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     RUN Actualiza-DRQP.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.

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
   IF PR-RQPROC.Almdes:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO PR-RQPROC.Almdes.
         RETURN "ADM-ERROR".   
   END.
   FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                      Almacen.CodAlm = PR-RQPROC.Almdes:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN  DO:
      MESSAGE "Codigo de almacen no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-RQPROC.Almdes.
      RETURN "ADM-ERROR".   
   END.
   /*
   IF PR-RQPROC.Almdes:SCREEN-VALUE = S-CODALM THEN DO:
      MESSAGE "No puede solicitarse asi mismo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-RQPROC.Almdes.
      RETURN "ADM-ERROR".   
   END.
  */
   FIND FIRST DRQP NO-LOCK NO-ERROR.
   IF NOT AVAIL DRQP THEN DO:
      MESSAGE "No puede grabar sin haber ingresado al menos un Item" 
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-RQPROC.Almdes.
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
IF NOT AVAILABLE PR-RQPROC THEN RETURN "ADM-ERROR".
RETURN "ADM-ERROR".

IF PR-RQPROC.FlgEst = "C" THEN DO:
   MESSAGE "El Requerimiento ya fue atendido no puede ser modificado" 
   VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Requerimiento V-table-Win 
PROCEDURE Verifica-Requerimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH PR-RQPROD OF PR-RQPROC:
    FOR EACH PR-ODPD NO-LOCK WHERE PR-ODPD.CodCia = PR-RQPROC.CodCia 
                              AND  PR-ODPD.NumOrd = PR-RQPROC.NumOrd 
                              AND  PR-ODPD.CodMat = PR-RQPROD.CodMat:

       IF (PR-ODPD.CanPed - PR-ODPD.CanDes - PR-RQPROD.CanReq) < 0 
       THEN DO:
            ASSIGN 
                PR-RQPROC.FlgEst = "B".
            RETURN.
       END.       
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

