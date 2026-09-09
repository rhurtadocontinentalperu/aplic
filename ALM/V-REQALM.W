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

/* SHARED Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle   AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA    AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA    AS CHAR.
DEFINE SHARED VARIABLE s-aplic-id  AS CHARACTER.
DEFINE SHARED VARIABLE S-USER-ID   AS CHAR.
DEFINE SHARED TEMP-TABLE DREQ LIKE LG-DRequ.
DEFINE SHARED VARIABLE S-CODALM    AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV    AS CHAR.
DEFINE SHARED VARIABLE S-NROSER    AS INTEGER.

DEFINE BUFFER CREQ FOR LG-CRequ.

/* Local Variable Definitions ---                                       */
DEFINE VAR TipoBien AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR I-NRO    AS INTEGER INIT 0 NO-UNDO.
DEFINE VAR L-CREA   AS LOGICAL        NO-UNDO.

DEFINE STREAM Reporte.

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
&Scoped-define EXTERNAL-TABLES LG-CRequ
&Scoped-define FIRST-EXTERNAL-TABLE LG-CRequ


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-CRequ.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-CRequ.FchReq LG-CRequ.FchVto ~
LG-CRequ.Observ 
&Scoped-define ENABLED-TABLES LG-CRequ
&Scoped-define FIRST-ENABLED-TABLE LG-CRequ
&Scoped-Define ENABLED-OBJECTS RECT-23 
&Scoped-Define DISPLAYED-FIELDS LG-CRequ.Solicita LG-CRequ.FchReq ~
LG-CRequ.FchVto LG-CRequ.Observ LG-CRequ.HorEmi LG-CRequ.Userid-Sol ~
LG-CRequ.HorAte 
&Scoped-define DISPLAYED-TABLES LG-CRequ
&Scoped-define FIRST-DISPLAYED-TABLE LG-CRequ
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroReq F-Situacion F-DesAlm ~
F-Respon 

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
CodCia||y|integral.LG-CRequ.CodCia
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "CodCia"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-DesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .73 NO-UNDO.

DEFINE VARIABLE F-Respon AS CHARACTER FORMAT "X(256)":U 
     LABEL "Responsable" 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-Situacion AS CHARACTER FORMAT "X(15)" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .69
     FONT 0.

DEFINE VARIABLE FILL-IN-NroReq AS CHARACTER FORMAT "XXX-XXXXXX" 
     LABEL "No.Requisicion" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .69
     FONT 1.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.72 BY 3.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroReq AT ROW 1.12 COL 10.86 COLON-ALIGNED
     F-Situacion AT ROW 1.12 COL 60.29 COLON-ALIGNED NO-LABEL
     LG-CRequ.Solicita AT ROW 1.88 COL 10.86 COLON-ALIGNED FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
     F-DesAlm AT ROW 1.88 COL 18 COLON-ALIGNED NO-LABEL
     LG-CRequ.FchReq AT ROW 1.96 COL 65.14 COLON-ALIGNED
          LABEL "Emision      ."
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     F-Respon AT ROW 2.58 COL 10.86 COLON-ALIGNED
     LG-CRequ.FchVto AT ROW 2.58 COL 65.14 COLON-ALIGNED
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .65
     LG-CRequ.Observ AT ROW 3.27 COL 10.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40.43 BY .69
     LG-CRequ.HorEmi AT ROW 3.27 COL 65.14 COLON-ALIGNED
          LABEL "Hora  Emision"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .65
     LG-CRequ.Userid-Sol AT ROW 4 COL 10.86 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-CRequ.HorAte AT ROW 4 COL 65.29 COLON-ALIGNED
          LABEL "Hora Atencion"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .65
     RECT-23 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.LG-CRequ
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
         HEIGHT             = 3.88
         WIDTH              = 76.72.
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

/* SETTINGS FOR FILL-IN F-DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Respon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Situacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.FchReq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroReq IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.HorAte IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-CRequ.HorEmi IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-CRequ.Solicita IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CRequ.Userid-Sol IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DReq V-table-Win 
PROCEDURE Actualiza-DReq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DREQ:
    DELETE DREQ.
END.
IF NOT L-CREA THEN DO:
   FOR EACH LG-DRequ NO-LOCK WHERE 
       LG-DRequ.CodCia = LG-CRequ.CodCia AND 
       LG-DRequ.NroSer = LG-CRequ.NroSer AND 
       LG-DRequ.NroReq = LG-CRequ.NroReq:
       CREATE DREQ.
       ASSIGN DREQ.CodCia  = LG-DRequ.CodCia 
              DREQ.NroReq  = LG-DRequ.NroReq
              DREQ.codmat  = LG-DRequ.Codmat 
              DREQ.CanPedi = LG-DRequ.CanPedi 
              DREQ.UndCmp  = LG-DRequ.UndCmp
              DREQ.TpoBien = LG-DRequ.TpoBien.
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
  {src/adm/template/row-list.i "LG-CRequ"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-CRequ"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Requisicion V-table-Win 
PROCEDURE Genera-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH LG-DRequ EXCLUSIVE-LOCK WHERE 
           LG-DRequ.CodCia = LG-CRequ.CodCia AND 
           LG-DRequ.NroSer = LG-CRequ.NroSer AND 
           LG-DRequ.NroReq = LG-CRequ.NroReq
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE LG-DRequ.
  END.
  FOR EACH DREQ WHERE DREQ.CanPedi > 0
      ON ERROR UNDO, RETURN "ADM-ERROR":
      CREATE LG-DRequ.
      ASSIGN LG-DRequ.CodCia  = LG-CRequ.CodCia
             LG-DRequ.NroSer  = LG-CRequ.NroSer
             LG-DRequ.NroReq  = LG-CRequ.NroReq
             LG-DRequ.Codmat  = DREQ.Codmat
             LG-DRequ.CanPedi = DREQ.CanPedi
             LG-DRequ.tpobien = TipoBien
             LG-DRequ.UndCmp  = DREQ.UndCmp.
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
  DO WITH FRAME {&FRAME-NAME}:
     /*** CORRELATIVO AUTOMATICO  ***/
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND 
          FacCorre.CodDoc = "REQ"    AND 
          FacCorre.CodDiv = S-CODDIV AND 
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        ASSIGN FILL-IN-NroReq = STRING(S-NROSER,"999") + STRING(FacCorre.Correlativo,"999999").
     END.
     DISPLAY TODAY                @ LG-CRequ.FchReq 
             TODAY                @ LG-CRequ.FchVto
             S-USER-ID            @ LG-CRequ.Userid-Sol
             STRING(TIME,"HH:MM") @ LG-CRequ.HorEmi
             S-CODALM             @ LG-CRequ.Solicita
             FILL-IN-NroReq. 
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
          Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN DO:
        F-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
        F-Respon:SCREEN-VALUE = Almacen.EncAlm.
     END. 
     ELSE ASSIGN F-DesAlm:SCREEN-VALUE = ""
                 F-Respon:SCREEN-VALUE = "".
  END.
  RUN Actualiza-DREQ.
  RUN Procesa-Handle IN lh_Handle ("Pagina2").
  RUN Procesa-Handle IN lh_Handle ('Browse').
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ).
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF L-CREA THEN DO:
     ASSIGN LG-CRequ.CodCia = S-CODCIA
            LG-CRequ.NroSer = S-NROSER
            LG-CRequ.HorEmi = STRING(TIME,"HH:MM")
            LG-CRequ.TpoReq = "N"
            LG-Crequ.Solicita = S-CODALM.
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = "REQ"    AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        ASSIGN LG-CRequ.NroReq = FacCorre.Correlativo
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
     END.
     RELEASE FacCorre.
     FILL-IN-NroReq = STRING(LG-CRequ.NroSer,"999") + STRING(LG-CRequ.NroReq,"999999").
  END.
  ASSIGN LG-CRequ.Userid-Sol = S-USER-ID.
  
  RUN Genera-Requisicion.
  
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
  RUN Procesa-Handle IN lh_Handle ("Pagina1").

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
  IF LOOKUP(LG-CRequ.FlgSit,"R,C") > 0  THEN RETURN ERROR.
  /* EN EL CASO DE LAS APROBADAS PREGUNTAMOS SI DESEA ELIMINAR */
  IF LG-CRequ.FlgSit = "A"  THEN  DO:
     MESSAGE "Requisicion esta Aprobada, " SKIP
             "desea continuar" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
             UPDATE Rpta AS LOGICAL.
     IF NOT Rpta THEN RETURN ERROR.
  END.
  FOR EACH LG-DRequ EXCLUSIVE-LOCK WHERE 
           LG-DRequ.CodCia = LG-CRequ.CodCia AND 
           LG-DRequ.NroSer = LG-CRequ.NroSer AND
           LG-DRequ.NroReq = LG-CRequ.NroReq
           ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE LG-DRequ.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  IF AVAILABLE LG-CRequ THEN DO WITH FRAME {&FRAME-NAME}:
     CASE LG-CRequ.FlgSit:
          WHEN "S" THEN F-Situacion:SCREEN-VALUE = "Solicitada".
          WHEN "R" THEN F-Situacion:SCREEN-VALUE = "Rechazada".
          WHEN "A" THEN F-Situacion:SCREEN-VALUE = "Aprobada".
          WHEN "C" THEN F-Situacion:SCREEN-VALUE = "Atendida".
     END CASE.
     FILL-IN-NroReq:SCREEN-VALUE = STRING(LG-CRequ.NroSer,"999") + STRING(LG-CRequ.NroReq,"999999").
     FILL-IN-NroReq = STRING(LG-CRequ.NroSer,"999") + STRING(LG-CRequ.NroReq,"999999").
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
          Almacen.CodAlm = LG-CRequ.Solicita NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN DO:
        F-DesAlm:SCREEN-VALUE = Almacen.Descripcion.
        F-Respon:SCREEN-VALUE = Almacen.EncAlm.
     END.   
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
  DEFINE VAR s-printer-list AS CHAR.
  DEFINE VAR s-port-list AS CHAR.
  DEFINE VAR s-port-name AS CHAR format "x(20)".
  DEFINE VAR s-printer-count AS INTEGER.

/*MLR* ***
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
*MLR* ***/
    
  FIND FIRST FacCorre WHERE 
       FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = "REQ"    AND
       FacCorre.CodDiv = S-CODDIV AND
       FacCorre.NroSer = S-NROSER  NO-LOCK NO-ERROR.

/*MLR* 29/10/07 Nueva librearía de impresión ***/
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

/*MLR* ***
  IF NOT AVAILABLE FacCorre OR LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
     MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
      
  s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
*MLR* ***/

  DEFINE VARIABLE S-Tit  AS CHAR NO-UNDO.
  DEFINE VARIABLE S-Item AS INTEGER INIT 0.
  DEFINE VAR S-DesSol AS CHAR FORMAT "X(60)" NO-UNDO.
  DEFINE FRAME F-FMT
         S-Item AT 2 FORMAT "Z9"
         LG-DRequ.codmat  AT 6   FORMAT "X(6)"
         Almmmate.CodUbi  AT 13  FORMAT "X(6)"        
         Almmmatg.DesMat  AT 21  FORMAT "X(40)"
         Almmmatg.DesMar  AT 63  FORMAT "X(12)"
         Almmmatg.UndStk  AT 76  FORMAT "X(4)"
         Almmmatg.CanEmp  AT 81  FORMAT ">>,>>9.99"
         Almmmate.StkAct  AT 92  FORMAT ">>>,>>>.99"  
         LG-DRequ.CanPedi AT 104 FORMAT ">,>>>,>>9.99"
         "------------" AT 118
         HEADER
         S-NOMCIA AT 1 "REQUISICION No. : " AT 103 FILL-IN-NroReq AT 123 SKIP
         "( " + S-CODALM + " )" AT 2 "PRE - REQUISICION DE COMPRA" AT 53  "PAG. " AT 103 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         "Solicitado      : "   AT 1 S-DESSOL AT 21 "Fecha      : " AT 87 LG-CRequ.FchReq AT 105 SKIP
         "Responsable     : "   AT 1 Almacen.EncAlm AT 21 "Hora       : " AT 87 LG-CRequ.HorEmi AT 105 SKIP
         "Observaciones   : "   AT 1 LG-CRequ.Observ  AT 21 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO UB.FIS.               DESCRIPCION                    MARCA     UND   EMPAQUE   STOCK ACTUAL  SOLICITADO    APROBADO  " SKIP    
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.
  
  /*OUTPUT STREAM Reporte TO VALUE( s-port-name ) PAGED PAGE-SIZE 30.*/

  {lib/_printer-stream-to.i 30 REPORTE PAGED}

  FIND FIRST LG-DRequ WHERE 
             LG-DRequ.CodCia = LG-CRequ.CodCia AND
             LG-DRequ.NroSer = LG-CRequ.NroSer AND
             LG-DRequ.NroReq = LG-CRequ.NroReq NO-LOCK NO-ERROR.
  IF AVAILABLE LG-DRequ THEN DO:
     S-DesSol = LG-CRequ.Solicita.
     FIND Almacen WHERE 
          Almacen.CodCia = LG-DRequ.CodCia AND
          Almacen.CodAlm = LG-CRequ.Solicita NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN S-DesSol = S-DesSol + " " + Almacen.Descripcion.
     PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(33).
     PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
     FOR EACH LG-DRequ NO-LOCK WHERE AVAILABLE LG-DRequ AND
              LG-DRequ.CodCia = LG-CRequ.CodCia AND
              LG-DRequ.NroSer = LG-CRequ.NroSer AND
              LG-DRequ.NroReq = LG-CRequ.NroReq: 
    /*   FIRST Almmmate OF LG-DRequ NO-LOCK
         BREAK BY Almmmate.CodUbi BY Almmmate.DesMat:*/
         S-Item = S-Item + 1.     
    /*   IF FIRST-OF ( LG-DRequ.AlmDes ) THEN DO:
            FIND Almacen WHERE almacen.CodCia = LG-DRequ.CodCia AND
                 almacen.CodAlm = LG-DRequ.Almdes NO-LOCK NO-ERROR.
            S-Tit = "Almacen de Despacho : " + LG-DRequ.Almdes.
         END.
         IF FIRST-OF ( Almmmate.CodUbi ) THEN DO:
            FIND almtubic WHERE almtubic.CodCia = LG-DRequ.CodCia AND
                 almtubic.CodAlm = LG-DRequ.Almdes AND
                 almtubic.CodUbi = Almmmate.CodUbi NO-LOCK NO-ERROR.
            S-Tit = "          Articulos Ubicados en : " + Almmmate.CodUbi.
         END.*/
         
         FIND Almmmate WHERE Almmmate.CodCia = LG-DRequ.CodCia AND
                             Almmmate.CodAlm = LG-CRequ.Solicita AND
                             Almmmate.CodMat = LG-DRequ.CodMat NO-LOCK NO-ERROR.
          
         FIND Almmmatg WHERE Almmmatg.CodCia = LG-DRequ.CodCia AND
              Almmmatg.CodMat = LG-DRequ.CodMat NO-LOCK NO-ERROR.
         DISPLAY STREAM Reporte 
                   S-Item
                   LG-DRequ.Codmat 
                   Almmmate.CodUbi
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   Almmmatg.CanEmp
                   Almmmate.StkAct
                   LG-DRequ.CanPedi WITH FRAME F-FMT.
         DOWN STREAM Reporte WITH FRAME F-FMT.
     END.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "        ------------------                ------------------              ------------------  " AT 10 SKIP.
  PUT STREAM Reporte "             Operador                         Supervisor                        Vo.Bo.        " AT 10 SKIP.
  PUT STREAM Reporte LG-CRequ.Userid-SOL AT 24 " JEFE ALMACEN " AT 86 SKIP.     
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
     RUN VALIDA.
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
  {src/adm/template/snd-list.i "LG-CRequ"}

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

  IF p-state = 'update-begin':U AND NOT AVAILABLE LG-CRequ THEN RETURN ERROR.
  IF p-state = 'update-begin':U AND LG-CRequ.FlgSit <> "S" THEN RETURN ERROR.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     L-CREA = NO.
     RUN Actualiza-DREQ.
     RUN Procesa-Handle IN lh_Handle ("Pagina2").
     RUN Procesa-Handle IN lh_Handle ('Browse').
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
   I-NRO = 0.
   FOR EACH DREQ WHERE DREQ.CanPedi > 0:
       I-NRO = I-NRO + 1.
   END.
   IF I-NRO = 0 THEN DO:
      MESSAGE "No hay articulos a solicitar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-CRequ.Observ.
      RETURN "ADM-ERROR".   
   END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

