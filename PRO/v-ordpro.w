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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-DESALM  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.

DEFINE VAR I-CODMON AS INTEGER INIT 1.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.

DEFINE BUFFER B-PR-ODPC FOR PR-ODPC.

DEFINE SHARED VAR lh_Handle AS HANDLE.

DEFINE VARIABLE X-CODDOC AS CHAR INIT "O/T".

FIND PR-CORR WHERE PR-CORR.Codcia = S-CODCIA AND
                   PR-CORR.Coddoc = X-CODDOC
                   NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-CORR THEN DO:
   MESSAGE "Correlativo de Ordenes no esta configurado"
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
END.

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
&Scoped-define EXTERNAL-TABLES PR-ODPC
&Scoped-define FIRST-EXTERNAL-TABLE PR-ODPC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PR-ODPC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PR-ODPC.CodMaq PR-ODPC.CodAlm PR-ODPC.FchVto ~
PR-ODPC.Observ[1] 
&Scoped-define ENABLED-TABLES PR-ODPC
&Scoped-define FIRST-ENABLED-TABLE PR-ODPC
&Scoped-Define ENABLED-OBJECTS RECT-27 
&Scoped-Define DISPLAYED-FIELDS PR-ODPC.NumOrd PR-ODPC.CodMaq ~
PR-ODPC.FchOrd PR-ODPC.CodAlm PR-ODPC.FchVto PR-ODPC.Observ[1] ~
PR-ODPC.FchCie PR-ODPC.CodMon PR-ODPC.TpoCmb PR-ODPC.CtoMat PR-ODPC.CtoGas ~
PR-ODPC.Ctotot PR-ODPC.CtoPro PR-ODPC.Usuario PR-ODPC.CtoMatF ~
PR-ODPC.CtoGasF PR-ODPC.CtoTotF PR-ODPC.CtoProF 
&Scoped-define DISPLAYED-TABLES PR-ODPC
&Scoped-define FIRST-DISPLAYED-TABLE PR-ODPC
&Scoped-Define DISPLAYED-OBJECTS F-ESTADO FILL-IN-NomMaq FILL-IN-Nompro 

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
DEFINE VARIABLE F-ESTADO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomMaq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nompro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.43 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-ESTADO AT ROW 1.19 COL 67.14 COLON-ALIGNED NO-LABEL
     PR-ODPC.NumOrd AT ROW 1.27 COL 11.29 COLON-ALIGNED
          LABEL "Orden #" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 16.72 BY .69
          FONT 1
     PR-ODPC.CodMaq AT ROW 2.08 COL 11.43 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     FILL-IN-NomMaq AT ROW 2.08 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     PR-ODPC.FchOrd AT ROW 2.88 COL 70.72 COLON-ALIGNED
          LABEL "Fecha Emision"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     PR-ODPC.CodAlm AT ROW 2.92 COL 11.43 COLON-ALIGNED
          LABEL "Alm.Conversion"
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .69
     FILL-IN-Nompro AT ROW 2.92 COL 18.72 COLON-ALIGNED NO-LABEL
     PR-ODPC.FchVto AT ROW 3.62 COL 70.72 COLON-ALIGNED
          LABEL "Fecha Fin"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     PR-ODPC.Observ[1] AT ROW 3.65 COL 13.43 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 47.29 BY 1.69
     PR-ODPC.FchCie AT ROW 4.46 COL 70.72 COLON-ALIGNED
          LABEL "Cierre"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     PR-ODPC.CodMon AT ROW 5.38 COL 71.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .58
     PR-ODPC.TpoCmb AT ROW 6.04 COL 70.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     PR-ODPC.CtoMat AT ROW 6.12 COL 12.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-ODPC.CtoGas AT ROW 6.12 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-ODPC.Ctotot AT ROW 6.12 COL 35.86 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-ODPC.CtoPro AT ROW 6.12 COL 47.57 COLON-ALIGNED NO-LABEL FORMAT "->>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-ODPC.Usuario AT ROW 6.85 COL 70.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     PR-ODPC.CtoMatF AT ROW 7.04 COL 12.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 4 
     PR-ODPC.CtoGasF AT ROW 7.04 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 4 
     PR-ODPC.CtoTotF AT ROW 7.04 COL 35.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 4 
     PR-ODPC.CtoProF AT ROW 7.04 COL 47.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 4 
     "Observaciones" VIEW-AS TEXT
          SIZE 10.57 BY .5 AT ROW 4.08 COL 3
     "Proyectado" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.23 COL 6
     "Resultado Final" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 6.85 COL 3
     "Cto.Material" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.5 COL 15.57
     "Gastos" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.5 COL 27.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Cto.Total" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.46 COL 38.86
     "Cto.Producto" VIEW-AS TEXT
          SIZE 10.57 BY .5 AT ROW 5.46 COL 49.57
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 5.38 COL 64.57
     RECT-27 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PR-ODPC
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
         HEIGHT             = 8.04
         WIDTH              = 90.57.
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

/* SETTINGS FOR FILL-IN PR-ODPC.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET PR-ODPC.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoGas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoGasF IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoMatF IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoPro IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoProF IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.Ctotot IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PR-ODPC.CtoTotF IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ESTADO IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.FchCie IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PR-ODPC.FchOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PR-ODPC.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomMaq IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Nompro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.NumOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN PR-ODPC.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-ODPC.Usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME PR-ODPC.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-ODPC.CodAlm V-table-Win
ON LEAVE OF PR-ODPC.CodAlm IN FRAME F-Main /* Alm.Conversion */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                     Almacen.CodAlm = PR-ODPC.CodAlm:SCREEN-VALUE  
                     NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FILL-IN-NomPro:SCREEN-VALUE = Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-ODPC.CodMaq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-ODPC.CodMaq V-table-Win
ON LEAVE OF PR-ODPC.CodMaq IN FRAME F-Main /* Maquina */
DO:
  FILL-IN-NomMaq:SCREEN-VALUE = ''.
  FIND LprMaqui WHERE LprMaqui.codcia = s-codcia
      AND LprMaqui.CodMaq = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE LprMaqui THEN FILL-IN-NomMaq:SCREEN-VALUE =  INTEGRAL.LPRMAQUI.DesPro.
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
  {src/adm/template/row-list.i "PR-ODPC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PR-ODPC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bloquear-Orden V-table-Win 
PROCEDURE Bloquear-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE PR-ODPC THEN RETURN "ADM-ERROR".

  IF PR-ODPC.FlgEst = "A" THEN RETURN "ADM-ERROR".
  
  IF PR-ODPC.FlgEst = "C" THEN DO:
     MESSAGE "Orden de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.


  FIND B-PR-ODPC WHERE B-PR-ODPC.Codcia = PR-ODPC.Codcia AND
                       B-PR-ODPC.NumOrd = PR-ODPC.NumOrd 
                       EXCLUSIVE-LOCK NO-ERROR.
   
  B-PR-ODPC.Flgest = IF PR-ODPC.FlgEst = "B" THEN "P" ELSE "B".
  RELEASE B-PR-ODPC.
  
  /* refrescamos los datos del viewer */

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  L-CREA = TRUE.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ PR-ODPC.FchOrd
             TODAY @ PR-ODPC.FchVto
             S-USER-ID @ PR-ODPC.Usuario.
     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.venta @ PR-ODPC.TpoCmb.
  

  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VAR X-NumOrd AS INTEGER.
  DEFINE VAR X-TPOCMB AS DECI.
  DEFINE VAR X-Codpro AS CHAR.

  IF L-CREA THEN DO:  
     FIND PR-CORR WHERE PR-CORR.Codcia = S-CODCIA AND
                        PR-CORR.Coddoc = X-CODDOC
                        EXCLUSIVE-LOCK NO-ERROR.
     PR-CORR.NroDoc = PR-CORR.NroDoc + 1 . 

     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN X-TPOCMB = gn-tcmb.venta .

     FIND Almacen WHERE Almacen.Codcia = S-CODCIA AND
                        Almacen.CodALm = PR-ODPC.CodAlm                        
                        NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN x-codpro = Almacen.Codcli.
    
     DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
        PR-ODPC.Codcia = S-CODCIA
        PR-ODPC.NumOrd = STRING(PR-CORR.NroDoc,"999999")
        PR-ODPC.FlgEst = "P"
        PR-ODPC.FchOrd = TODAY
        PR-ODPC.FchVto = DATE(PR-ODPC.FchVto:SCREEN-VALUE)
        PR-ODPC.TpoCmb = X-TPOCMB
        PR-ODPC.CodPro = X-CODPRO
        PR-ODPC.Usuario = S-USER-ID.
        RELEASE PR-CORR.
     END.
  END.
  ELSE DO:
     PR-ODPC.Usuario = S-USER-ID.
  END.

  
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE PR-ODPC THEN RETURN "ADM-ERROR".

  IF PR-ODPC.FlgEst = "A" THEN RETURN "ADM-ERROR".
  
  IF PR-ODPC.FlgEst = "C" THEN DO:
     MESSAGE "Orden de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.

  IF PR-ODPC.FlgEst = "C" THEN DO:
     MESSAGE "Orden de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.

  IF PR-ODPC.CanAte <> 0 THEN DO:
     MESSAGE "Orden presenta avance en Produccion, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.

  /*
  IF PR-ODPC.FlgEst = "P" THEN DO:
     MESSAGE "Orden de Produccion presenta atenciones no puede ser eliminado" VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  */

  FOR EACH PR-ODPD OF PR-ODPC NO-LOCK :
      IF PR-ODPD.CanDes <> 0 THEN DO:
         MESSAGE "Orden presenta despachos , no puede ser eliminado" 
         VIEW-AS ALERT-BOX.
         RETURN "ADM-ERROR".
      END.
      IF PR-ODPD.CanAte <> 0 THEN DO:
         MESSAGE "Orden presenta materiales consumidos, no puede ser eliminado" 
         VIEW-AS ALERT-BOX.
         RETURN "ADM-ERROR".
      END.

  END  .

  FOR EACH PR-ODPCX OF PR-ODPC EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE PR-ODPCX.
  END.

  FOR EACH PR-ODPD OF PR-ODPC EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE PR-ODPD.
  END.
  FOR EACH PR-ODPDG OF PR-ODPC EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE PR-ODPDG.
  END.
  
  FIND B-PR-ODPC WHERE B-PR-ODPC.Codcia = PR-ODPC.Codcia AND
                       B-PR-ODPC.NumOrd = PR-ODPC.NumOrd 
                       EXCLUSIVE-LOCK NO-ERROR.
   
  B-PR-ODPC.Flgest = "A".
  RELEASE B-PR-ODPC.
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
  DO WITH FRAME {&FRAME-NAME}:

    IF AVAILABLE PR-ODPC THEN DO:
    
       CASE PR-ODPC.FlgEst:
            WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "B" THEN DISPLAY "BLOQUEADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "C" THEN DISPLAY "LIQUIDADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE. 

       FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                          Almacen.CodAlm = PR-ODPC.CodAlm  
                          NO-LOCK NO-ERROR.
       IF AVAILABLE Almacen THEN DISPLAY Almacen.Descripcion @ FILL-IN-NomPro .
  
       FILL-IN-NomMaq:SCREEN-VALUE = ''.
       FIND LprMaqui WHERE LprMaqui.codcia = s-codcia
           AND LprMaqui.CodMaq = Pr-Odpc.codmaq 
           NO-LOCK NO-ERROR.
       IF AVAILABLE LprMaqui THEN FILL-IN-NomMaq:SCREEN-VALUE =  INTEGRAL.LPRMAQUI.DesPro.
          
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
  IF NOT AVAILABLE PR-ODPC THEN RETURN.
  
  IF PR-ODPC.FlgEst = "A" THEN DO:
    MESSAGE "Orden de Produccion Anulada" VIEW-AS ALERT-BOX WARNING.
    RETURN .
  END.
  
  /* Pantalla general de parametros de impresion */
 
  RUN PRO\R-IMPODP.R(ROWID(PR-ODPC)). 
    
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
  {src/adm/template/snd-list.i "PR-ODPC"}

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
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     L-CREA = NO.
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
 IF PR-ODPC.CodAlm:SCREEN-VALUE = "" THEN DO:
    MESSAGE "Almacen de Conversion No debe ser blanco" 
    VIEW-AS ALERT-BOX .
    APPLY "ENTRY" TO PR-ODPC.CodAlm.
    RETURN "ADM-ERROR".           
 END.
 IF PR-ODPC.CodMaq:SCREEN-VALUE <> '' THEN DO:
     FIND LprMaqui WHERE LprMaqui.codcia = s-codcia
         AND LprMaqui.CodMaq = PR-ODPC.CodMaq:SCREEN-VALUE 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE LprMaqui THEN DO:
         MESSAGE "Código de Máquina errado" 
         VIEW-AS ALERT-BOX .
         APPLY "ENTRY" TO PR-ODPC.CodMaq.
         RETURN "ADM-ERROR".           
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE PR-ODPC THEN RETURN "ADM-ERROR".
IF AVAILABLE PR-ODPC THEN DO:
   IF PR-ODPC.FlgEst <> "P" THEN RETURN "ADM-ERROR".
END.
/*
FOR EACH PR-ODPD OF PR-ODPC:
    IF PR-ODPD.CanAte + PR-ODPD.CanDes > 0 THEN RETURN "ADM-ERROR".
END.
*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

