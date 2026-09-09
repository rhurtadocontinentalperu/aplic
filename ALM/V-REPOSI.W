&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

/* Shared Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-DESALM  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE BUFFER CREQU FOR almcrequ.
DEFINE SHARED VARIABLE C-CODALM  AS CHAR.

DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED TEMP-TABLE DREP LIKE Almdrequ.

DEFINE STREAM Reporte.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA AS LOGICAL NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES Almcrequ
&Scoped-define FIRST-EXTERNAL-TABLE Almcrequ


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcrequ.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcrequ.Almdes Almcrequ.FchVto ~
Almcrequ.Observ 
&Scoped-define ENABLED-TABLES Almcrequ
&Scoped-define FIRST-ENABLED-TABLE Almcrequ
&Scoped-Define ENABLED-OBJECTS RECT-15 
&Scoped-Define DISPLAYED-FIELDS Almcrequ.Almdes Almcrequ.FchDoc ~
Almcrequ.FchVto Almcrequ.Observ Almcrequ.HorGen Almcrequ.HorAte ~
Almcrequ.Usuario 
&Scoped-define DISPLAYED-TABLES Almcrequ
&Scoped-define FIRST-DISPLAYED-TABLE Almcrequ
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
CodAlm||y|integral.Almcrequ.CodAlm
CodCia||y|integral.Almcrequ.CodCia
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "CodAlm,CodCia"':U).
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

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.14 BY 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Fill-in-NroPed AT ROW 1.19 COL 11 COLON-ALIGNED
     F-ESTADO AT ROW 1.19 COL 63.72 COLON-ALIGNED NO-LABEL
     Almcrequ.Almdes AT ROW 1.85 COL 11 COLON-ALIGNED
          LABEL "Alm.Despacho"
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .69
     F-DesAlm AT ROW 1.85 COL 16.86 COLON-ALIGNED NO-LABEL
     Almcrequ.FchDoc AT ROW 1.96 COL 68.14 COLON-ALIGNED
          LABEL "Fecha Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     F-Respon AT ROW 2.58 COL 11 COLON-ALIGNED
     Almcrequ.FchVto AT ROW 2.69 COL 68.29 COLON-ALIGNED
          LABEL "Fecha Entrega"
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .69
     Almcrequ.Observ AT ROW 3.35 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.43 BY .69
     Almcrequ.HorGen AT ROW 3.35 COL 70.43 COLON-ALIGNED
          LABEL "Hora  Generacion"
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .69
     Almcrequ.HorAte AT ROW 4.04 COL 70.43 COLON-ALIGNED
          LABEL "Hora de Atencion"
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .69
     Almcrequ.Usuario AT ROW 4.12 COL 11 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .69
     RECT-15 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcrequ
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
         HEIGHT             = 4
         WIDTH              = 80.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN Almcrequ.Almdes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ESTADO IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Respon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcrequ.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcrequ.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Fill-in-NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcrequ.HorAte IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcrequ.HorGen IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcrequ.Usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME Almcrequ.Almdes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcrequ.Almdes V-table-Win
ON LEAVE OF Almcrequ.Almdes IN FRAME F-Main /* Alm.Despacho */
DO:
  IF Almcrequ.Almdes:SCREEN-VALUE = "" THEN RETURN.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
       Almacen.CodAlm = Almcrequ.Almdes:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN DO:
     F-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
     F-Respon:SCREEN-VALUE = Almacen.EncAlm.
     C-CODALM = Almacen.CodAlm.
  END. 
  ELSE F-DesAlm:SCREEN-VALUE = "".
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Activar-Reposicion V-table-Win 
PROCEDURE Activar-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF AVAILABLE Almcrequ THEN DO WITH FRAME {&FRAME-NAME}:
    IF Almcrequ.FlgEst = "" THEN DO:
       FIND CREQU WHERE ROWID(CREQU) = ROWID(Almcrequ)
            NO-ERROR.
       IF AVAILABLE CREQU THEN CREQU.FlgEst = "P".      
    END.
 END.
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DREP V-table-Win 
PROCEDURE Actualiza-DREP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DREP:
    DELETE DREP.
END.
IF NOT L-CREA THEN DO:
   FOR EACH Almdreq OF Almcrequ NO-LOCK :
       CREATE DREP.
       ASSIGN DREP.CodCia = Almdrequ.CodCia 
              DREP.CodAlm = Almdrequ.CodAlm 
              DREP.codmat = Almdrequ.codmat 
              DREP.CanReq = Almdrequ.CanReq.
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
  {src/adm/template/row-list.i "Almcrequ"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcrequ"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato V-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE S-Tit  AS CHAR NO-UNDO.
  DEFINE VARIABLE S-Item AS INTEGER INIT 0.
  DEFINE VAR S-DesSol AS CHAR FORMAT "X(60)" NO-UNDO.
  DEFINE VAR S-CODUBI AS CHAR NO-UNDO.
  DEFINE VAR F-STOCK AS DECIMAL NO-UNDO.
  DEFINE FRAME F-FMT
         S-Item AT 2 FORMAT "Z9"
         Almdrequ.codmat AT 6   FORMAT "X(6)"
         S-CODUBI        AT 13  FORMAT "X(6)"
         Almmmatg.DesMat AT 21  FORMAT "X(40)"
         Almmmatg.DesMar AT 63  FORMAT "X(12)"
         Almmmatg.UndStk AT 76  FORMAT "X(4)"
         Almmmate.Stkmin AT 81  FORMAT ">>,>>9.99"
         Almmmatg.CanEmp AT 92  FORMAT ">>,>>9.99"
         F-STOCK         AT 104  FORMAT ">>>,>>>.99"
         Almdrequ.CanReq AT 116 FORMAT ">,>>>,>>9.99"
         HEADER
         S-NOMCIA AT 1 "REPOSICION No. : " AT 103 Almcrequ.NroDoc AT 123 SKIP
         "( " + S-CODALM + " )" AT 2 "SOLICITUD DE REPOSICION INTERNO" AT 50  "PAG. " AT 103 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         "Solicitado      : "   AT 1 S-DESSOL AT 21 "Fecha      : " AT 87 Almcrequ.FchDoc AT 105 SKIP
         "Responsable     : "   AT 1 Almacen.EncAlm AT 21 "Hora       : " AT 87 Almcrequ.HorGen AT 105 SKIP
         "Observaciones   : "   AT 1 Almcrequ.Observ  AT 21 SKIP 
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO UB.FIS.               DESCRIPCION                    MARCA     UND   STOCK MINIMO U.Min.Tras STOCK ACTUAL  SOLICITADO" SKIP    
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.

  FIND FIRST Almdrequ WHERE 
             Almdrequ.CodCia = Almcrequ.CodCia AND
             Almdrequ.CodAlm = Almcrequ.CodAlm AND
             Almdrequ.NroDoc = Almcrequ.NroDoc NO-LOCK NO-ERROR.
  IF AVAILABLE Almdrequ THEN DO:
     S-DesSol = Almcrequ.AlmDes.
     FIND Almacen WHERE Almacen.CodCia = Almdrequ.CodCia AND
          Almacen.CodAlm = Almcrequ.AlmDes NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN  S-DesSol = S-DesSol + " " + Almacen.Descripcion.
     PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(33).
     PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
     FOR EACH Almdrequ NO-LOCK WHERE AVAILABLE Almdrequ
                                AND  Almdrequ.CodCia = Almcrequ.CodCia
                                AND  Almdrequ.CodAlm = Almcrequ.CodAlm
                                AND  Almdrequ.NroSer = Almcrequ.NroSer
                                AND  Almdrequ.NroDoc = Almcrequ.NroDoc,
         FIRST Almmmatg OF Almdrequ NO-LOCK
                               BREAK /*BY Almdrequ.AlmDes
                                     BY Almmmatg.DesMat*/
                                     BY Almdrequ.CodCia
                                     BY Almdrequ.CodMat:
         S-Item = S-Item + 1.
         S-CODUBI = "".
         F-STOCK  = 0.
         FIND Almmmate OF Almdrequ NO-LOCK NO-ERROR.
         IF AVAILABLE Almmmate THEN 
            ASSIGN S-CODUBI = Almmmate.CodUbi
                   F-STOCK  = Almmmate.StkAct.
         
         DISPLAY STREAM Reporte 
                   S-Item
                   Almdrequ.Codmat 
                   S-CODUBI 
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   Almmmate.Stkmin
                   Almmmatg.CanEmp
                   F-STOCK  
                   Almdrequ.CanReq WITH FRAME F-FMT.
         DOWN STREAM Reporte WITH FRAME F-FMT.
     END.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "        ------------------                ------------------              ------------------  " AT 10 SKIP.
  PUT STREAM Reporte "             Operador                         Supervisor                        Vo.Bo.        " AT 10 SKIP.
  PUT STREAM Reporte Almcrequ.Usuario AT 24 " JEFE ALMACEN " AT 86 SKIP.     

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
  FOR EACH Almdrequ OF Almcrequ EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE Almdrequ.
  END.
  FOR EACH DREP WHERE DREP.canreq > 0 ON ERROR UNDO, RETURN "ADM-ERROR":
      CREATE Almdrequ.
      ASSIGN Almdrequ.CodCia = Almcrequ.CodCia
             Almdrequ.CodAlm = Almcrequ.CodAlm
             Almdrequ.NroSer = Almcrequ.NroSer
             Almdrequ.NroDoc = Almcrequ.NroDoc
             Almdrequ.codmat = DREP.codmat
             Almdrequ.CanReq = DREP.canreq
             Almdrequ.AlmDes = Almcrequ.AlmDes.
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
          FacCorre.CodDoc = "REP"    AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        ASSIGN Fill-in-NroPed = STRING(S-NROSER,"999") + STRING(FacCorre.Correlativo,"999999").
     END.
     
     DISPLAY Fill-in-NroPed
                TODAY  @ Almcrequ.FchDoc 
             S-USER-ID @ Almcrequ.Usuario.
  END.
  
  RUN Actualiza-DREP.
  
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
  RUN VALIDA.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO:
     ASSIGN Almcrequ.CodCia = S-CODCIA
            Almcrequ.CodAlm = S-CODALM
            Almcrequ.NroSer = S-NROSER
            Almcrequ.FchDoc = TODAY
/*            Almcrequ.FlgEst = "P" */
            Almcrequ.HorGen = STRING(TIME,"HH:MM").
     /*** CORRELATIVO AUTOMATICO  ***/
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = "REP"    AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        ASSIGN Almcrequ.NroDoc = FacCorre.Correlativo
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
     END.
     RELEASE FacCorre.
  END.
  ASSIGN Almcrequ.Usuario = S-USER-ID.
  
  RUN Genera-Reposicion.
  
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
  IF Almcrequ.FlgEst = "C" THEN DO:
     MESSAGE "El pedido ya fue atendido no puede ser eliminado" VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
/*
  IF Almcrequ.FlgEst = "P" THEN DO:
     MESSAGE "El pedido presenta atenciones no puede ser eliminado" VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
*/
  FOR EACH Almdrequ EXCLUSIVE-LOCK WHERE 
           Almdrequ.CodCia = Almcrequ.CodCia AND
           Almdrequ.CodAlm = Almcrequ.CodAlm AND
           Almdrequ.NroSer = Almcrequ.NroSer AND
           Almdrequ.NroDoc = Almcrequ.NroDoc
           ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE Almdrequ.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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
  IF AVAILABLE Almcrequ THEN DO WITH FRAME {&FRAME-NAME}:
     CASE Almcrequ.FlgEst:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY " ATENDIDO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN " " THEN DISPLAY "         " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "X" THEN DISPLAY "CERRADO"   @ F-Estado WITH FRAME {&FRAME-NAME}.
     END CASE. 
     Fill-in-NroPed:SCREEN-VALUE = STRING(Almcrequ.NroSer,"999") + STRING(Almcrequ.NroDoc,"999999").
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
          Almacen.CodAlm = Almcrequ.Almdes NO-LOCK NO-ERROR.
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
  
  /* Definimos impresoras */
/*   DEFINE VAR s-printer-list AS CHAR.             */
/*   DEFINE VAR s-port-list AS CHAR.                */
/*   DEFINE VAR s-port-name AS CHAR format "x(20)". */
/*   DEFINE VAR s-printer-count AS INTEGER.         */

  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.
  
/*   {lib/_printer-stream-to.i 30 REPORTE PAGED} */
  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORTE TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORTE TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      RUN Formato.
      PAGE STREAM REPORTE.
      OUTPUT STREAM reporte CLOSE.
  END.
  OUTPUT STREAM reporte CLOSE.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN VALIDA.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
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
        WHEN "" THEN.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "CodAlm" "Almcrequ" "CodAlm"}
  {src/adm/template/sndkycas.i "CodCia" "Almcrequ" "CodCia"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "Almcrequ"}

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
  
  IF p-state = 'update-begin':U THEN RUN Valida-Update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     C-Codalm = Almcrequ.codalm.
     RUN Actualiza-DREP.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   IF Almcrequ.Almdes:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcrequ.Almdes.
         RETURN "ADM-ERROR".   
   END.
   FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
        Almacen.CodAlm = Almcrequ.Almdes:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN  DO:
      MESSAGE "Codigo de almacen no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcrequ.Almdes.
      RETURN "ADM-ERROR".   
   END.
   IF Almcrequ.Almdes:SCREEN-VALUE = S-CODALM THEN DO:
      MESSAGE "No puede solicitarse asi mismo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcrequ.Almdes.
      RETURN "ADM-ERROR".   
   END.

   FIND FIRST DREP NO-LOCK NO-ERROR.
   IF NOT AVAIL DREP THEN DO:
      MESSAGE "No puede grabar sin haber ingresado al menos un Item" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcrequ.Almdes.
      RETURN "ADM-ERROR".   
   END.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Update V-table-Win 
PROCEDURE Valida-Update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE Almcrequ THEN RETURN "ADM-ERROR".
IF Almcrequ.FlgEst = "C" THEN DO:
   MESSAGE "El pedido ya fue atendido no puede ser modificado" VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.
/*IF Almcrequ.FlgEst = "P" THEN DO:
   MESSAGE "El pedido presenta atenciones no puede ser modificado" VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

