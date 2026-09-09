&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DLORD LIKE PR-ODPCX.



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

DEF VAR p-NumOrd LIKE PR-ODPC.NumOrd.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-CodCia  AS INTEGER.
DEF SHARED VAR s-user-id AS CHARACTER.
DEF SHARED VAR s-CodAlm  AS CHARACTER.
DEF SHARED VAR s-nOMcIA  AS CHARACTER.

DEF VAR L-CREA AS LOGICAL.

DEF BUFFER B-ORDPRO FOR PR-ODPC.
DEF BUFFER B-DLORD  FOR LPRDOPRO.
DEF BUFFER B-LPROD  FOR LPRCLPRO.
DEF BUFFER B-SERVICIOS FOR PR-ODPDG.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE TEMP-TABLE T-LPROD
    FIELD NumOrd LIKE LPRCLPRO.NumOrd
    FIELD FchPro LIKE LPRCLPRO.FchPro
    FIELD CodMaq LIKE LPRCLPRO.CodMaq
    FIELD DesMaq LIKE LPRMAQUI.DesPro
    FIELD NroDoc LIKE LPRCLPRO.NroDoc
    FIELD CodMat LIKE LPRDOPRO.CodArt
    FIELD DesMat LIKE Almmmatg.DesMat
    FIELD CanPro LIKE LPRDOPRO.CanPed.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LPRCLPRO
&Scoped-define FIRST-EXTERNAL-TABLE LPRCLPRO


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LPRCLPRO.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LPRCLPRO.NumOrd LPRCLPRO.CodMaq ~
LPRCLPRO.FchPro 
&Scoped-define ENABLED-TABLES LPRCLPRO
&Scoped-define FIRST-ENABLED-TABLE LPRCLPRO
&Scoped-Define DISPLAYED-FIELDS LPRCLPRO.NumOrd LPRCLPRO.CodMaq ~
LPRCLPRO.NroDoc LPRCLPRO.FchDoc LPRCLPRO.FchPro LPRCLPRO.Usuario 
&Scoped-define DISPLAYED-TABLES LPRCLPRO
&Scoped-define FIRST-DISPLAYED-TABLE LPRCLPRO
&Scoped-Define DISPLAYED-OBJECTS f-estado x-maquina 

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
DEFINE VARIABLE f-estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-maquina AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81
     FONT 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LPRCLPRO.NumOrd AT ROW 1.19 COL 14 COLON-ALIGNED
          LABEL "Nº O/P"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     f-estado AT ROW 1.19 COL 68 COLON-ALIGNED NO-LABEL
     LPRCLPRO.CodMaq AT ROW 2.15 COL 14 COLON-ALIGNED
          LABEL "Nº Lote"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     LPRCLPRO.NroDoc AT ROW 2.15 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     x-maquina AT ROW 2.15 COL 31 COLON-ALIGNED NO-LABEL
     LPRCLPRO.FchDoc AT ROW 2.15 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     LPRCLPRO.FchPro AT ROW 3.12 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LPRCLPRO.Usuario AT ROW 3.12 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     "-" VIEW-AS TEXT
          SIZE 1 BY .5 AT ROW 2.35 COL 23
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LPRCLPRO
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DLORD T "SHARED" ? INTEGRAL PR-ODPCX
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
         HEIGHT             = 3.35
         WIDTH              = 87.86.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN LPRCLPRO.CodMaq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN f-estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LPRCLPRO.NumOrd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-maquina IN FRAME F-Main
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

&Scoped-define SELF-NAME LPRCLPRO.CodMaq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LPRCLPRO.CodMaq V-table-Win
ON LEAVE OF LPRCLPRO.CodMaq IN FRAME F-Main /* Nº Lote */
DO:
    FIND FIRST LPRMAQUI WHERE
       LPRMAQUI.CodCia = s-CodCia AND
       LPRMAQUI.CodMaq = INPUT LPRCLPRO.CodMaq
       NO-LOCK NO-ERROR.
    IF AVAILABLE LPRMAQUI THEN DISPLAY LPRMAQUI.DesPro @ x-maquina WITH FRAME {&FRAME-NAME}.
    ELSE DISPLAY "" @ x-maquina WITH FRAME {&FRAME-NAME}. 
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

ON RETURN OF LPRCLPRO.CodMaq, LPRCLPRO.FchPro 
DO:
    APPLY "TAB":U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Orden V-table-Win 
PROCEDURE Actualiza-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* FOR EACH B-LPROD WHERE B-LPROD.CodCia = s-CodCia             */
/*     AND B-LPROD.NumORd = LPRCLPRO.NumOrd,                    */
/*     EACH B-DLORD OF B-LPROD BREAK BY B-DLORD.CodArt:         */
/*     ACCUMULATE B-DLORD.CanPed (SUB-TOTAL BY B-DLORD.CodArt). */
/*     IF LAST-OF(B-DLORD.CodArt) THEN                          */
/*                                                              */
/* END.                                                         */
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
  {src/adm/template/row-list.i "LPRCLPRO"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LPRCLPRO"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalles V-table-Win 
PROCEDURE Borra-Detalles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Borrando Detalle O/P*/
FOR EACH LPRDOPRO WHERE
    LPRDOPRO.CodCia =  LPRCLPRO.CodCia AND
    LPRDOPRO.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDOPRO.NroDoc =  LPRCLPRO.NroDoc:
    DELETE LPRDOPRO.
END.    

/*Borrando Muestras*/
FOR EACH LPRDMUES WHERE
    LPRDMUES.CodCia = LPRCLPRO.CodCia AND
    LPRDMUES.CodMaq = LPRCLPRO.CodMaq AND
    LPRDMUES.NroDoc = LPRCLPRO.NroDoc:
    DELETE LPRDMUES.
END.

/*Borrando Muestras*/
FOR EACH LPRDMUES WHERE
    LPRDMERM.CodCia = LPRCLPRO.CodCia AND
    LPRDMERM.CodMaq = LPRCLPRO.CodMaq AND
    LPRDMERM.NroDoc = LPRCLPRO.NroDoc:
    DELETE LPRDMUES.
END.

/*Borrando Materiales*/
FOR EACH LPRDLPRO WHERE
    LPRDLPRO.CodCia =  LPRCLPRO.CodCia AND
    LPRDLPRO.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDLPRO.NroDoc =  LPRCLPRO.NroDoc.
    DELETE LPRDLPRO.
END.        

/*/*Borrando registro de bobinas*/
 * FOR EACH LPRDBOB WHERE
 *     LPRDBOB.CodCia =  LPRCLPRO.CodCia AND
 *     LPRDBOB.CodMaq =  LPRCLPRO.CodMaq AND
 *     LPRDBOB.NroDoc =  LPRCLPRO.NroDoc:
 *     DELETE LPRDBOB.
 * END.*/

/*/*Borrando Servicios*/
 * 
 * FOR EACH LPRDSERV WHERE
 *     LPRDSERV.CodCia =  LPRCLPRO.CodCia AND
 *     LPRDSERV.CodMaq =  LPRCLPRO.CodMaq AND
 *     LPRDSERV.NroDoc =  LPRCLPRO.NroDoc:
 *     DELETE LPRDSERV.
 * END.*/

/*Borrando Horas - Hombre*/

FOR EACH LPRDHRHM WHERE
    LPRDHRHM.CodCia =  LPRCLPRO.CodCia AND
    LPRDHRHM.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDHRHM.NroDoc =  LPRCLPRO.NroDoc:
    DELETE LPRDHRHM.
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
 DEFINE VAR Tot AS DECIMAL.
 DEFINE VAR VAL AS INTEGER INIT 0.
 DEFINE VAR CNT AS INTEGER INIT 0.
     
 FOR EACH T-DLORD:
   DELETE T-DLORD.
 END. 
 
 FOR EACH PR-ODPCX NO-LOCK WHERE PR-ODPCX.NumOrd = LPRCLPRO.NumOrd:SCREEN-VALUE IN FRAME {&FRAME-NAME}
     BREAK BY PR-ODPCX.CodArt:
     FOR EACH B-LPROD WHERE B-LPROD.NumOrd = PR-ODPCX.NumOrd NO-LOCK,
         EACH B-DLORD OF B-LPROD NO-LOCK BREAK BY B-DLORD.CodArt:
         ACCUMULATE B-DLORD.CanPed (SUB-TOTAL BY B-DLORD.CodArt).
         VAL = 1.
         IF PR-ODPCX.CodArt = B-DLORD.CodArt THEN DO:
            IF LAST-OF(B-DLORD.CodArt) THEN DO:
                 tot = ACCUM SUB-TOTAL BY B-DLORD.CodArt B-DLORD.CanPed.
                 IF PR-ODPCX.CanPed > tot THEN DO:
                    cnt = cnt + 1.
                    CREATE T-DLORD.
                    ASSIGN 
                        T-DLORD.CodArt = PR-ODPCX.codart
                        T-DLORD.CodFor = PR-ODPCX.CodFor
                        T-DLORD.CanPed = PR-ODPCX.CanPed - tot.
                 END. 
             END.
         END.             
     END.
     IF VAL = 0 THEN DO:
         CREATE T-DLORD.
         BUFFER-COPY PR-ODPCX TO T-DLORD.         
     END.
     IF cnt = 0 THEN DO:
         MESSAGE "La Orden " PR-ODPCX.NumOrd 
                 "ya se asigno completamente" 
             VIEW-AS ALERT-BOX.
         RETURN 'ADM-ERROR'.
     END.
          
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato V-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Titulo1 AS CHAR.
DEFINE VAR x-Titulo2 AS CHAR.
DEFINE VAR x-Titulo3 AS CHAR.
   
DEFINE FRAME F-REPORTE
    T-LPROD.CodMat COLUMN-LABEL 'Código'
    T-LPROD.DesMat COLUMN-LABEL 'Descripción Material' FORMAT 'X(50)'
    T-LPROD.CanPro COLUMN-LABEL 'Cantidad a producir'
    WITH WIDTH 100 NO-BOX STREAM-IO DOWN. 

  ASSIGN 
    x-Titulo1 = "LOTES DE PRODUCCION"
    x-Titulo2 = ""
    x-Titulo3 = T-LPROD.CodMaq + '-' + T-LPROD.NroDoc.
    
  DEFINE FRAME F-HEADER
    HEADER
    /*S-NOMCIA FORMAT "X(50)" AT 1*/ SKIP
    X-Titulo1  AT 20 FORMAT "X(50)" SKIP 
    x-titulo2  FORMAT "X(60)"  SKIP
    "Orden de Producción: " T-LPROD.NumOrd  FORMAT "X(60)"  SKIP
    "Lote de Producción : " x-titulo3  FORMAT "X(60)"  SKIP
    "Fecha producción :   " T-LPROD.FchPro SKIP
    "Pagina : " TO 80 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha  : " TO 80 TODAY FORMAT "99/99/9999" SKIP
    WITH PAGE-TOP WIDTH 100 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

   
  FOR EACH T-LPROD:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT
        T-LPROD.CodMat
        T-LPROD.DesMat
        T-LPROD.CanPro
        WITH FRAME F-REPORTE.
        /*DISPLAY NumOrd @ Fi-Mensaje LABEL "O/Produccion"
 *               FORMAT "X(11)" WITH FRAME F-PROCESO.*/
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
        
  END.
HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-HorasHombre V-table-Win 
PROCEDURE Graba-HorasHombre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR EACH LPRMHRHM NO-LOCK WHERE 
   LPRMHRHM.CodCia = s-CodCia AND
   LPRMHRHM.CodMaq = LPRCLPRO.CodMaq:
   IF AVAILABLE LPRMHRHM THEN DO:
     CREATE LPRDHRHM.
     ASSIGN 
       LPRDHRHM.CodCia   = s-CodCia
       LPRDHRHM.CodMaq   = LPRCLPRO.CodMaq
       LPRDHRHM.NroDoc   = LPRCLPRO.NroDoc
       LPRDHRHM.CodPer   = LPRMHRHM.CodPer.
   END.
   ELSE
    MESSAGE "No Hay personal asignado para esta máquina" VIEW-AS ALERT-BOX INFORMATION.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Materiales V-table-Win 
PROCEDURE Graba-Materiales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR EACH PR-ODPD NO-LOCK WHERE
   PR-ODPD.CodCia = LPRCLPR.CodCia AND
   PR-ODPD.NumOrd = LPRCLPR.NumOrd:
   FIND FIRST LPRDLPRO WHERE
      LPRDLPRO.CodCia = LPRCLPRO.CodCia AND
      LPRDLPRO.CodMaq = LPRCLPRO.CodMaq AND
      LPRDLPRO.NroDoc = LPRCLPRO.NroDoc AND
      LPRDLPRO.TpoMat = "MP" AND
      LPRDLPRO.CodMat = PR-ODPD.CodMat
      NO-LOCK NO-ERROR.
      IF NOT AVAILABLE LPRDLPRO THEN DO:
        CREATE LPRDLPRO.
        ASSIGN 
          LPRDLPRO.CodCia = LPRCLPRO.CodCia 
          LPRDLPRO.CodMaq = LPRCLPRO.CodMaq
          LPRDLPRO.NroDoc = LPRCLPRO.NroDoc
          LPRDLPRO.TpoMat = "MP"  
          LPRDLPRO.CodMat = PR-ODPD.CodMat.
      END.
      ASSIGN
          LPRDLPRO.CanDes = 0.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Orden V-table-Win 
PROCEDURE Graba-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH T-DLORD.
       CREATE LPRDOPRO.
       ASSIGN 
          LPRDOPRO.CodCia   = LPRCLPRO.CodCia
          LPRDOPRO.CodMaq   = LPRCLPRO.CodMaq
          LPRDOPRO.NroDoc   = LPRCLPRO.NroDoc
          LPRDOPRO.NumOrd   = LPRCLPRO.NumOrd
          LPRDOPRO.FchPro   = LPRCLPRO.FchPro
          LPRDOPRO.CodArt   = T-DLORD.CodArt
          LPRDOPRO.CanPed   = T-DLORD.CanPed.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime V-table-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
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
  
   RUN PRO\D-LOrdPro (OUTPUT p-NumOrd).  
   IF p-NumOrd = "" THEN RETURN 'ADM-ERROR'.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
    FIND B-ORDPRO WHERE B-ORDPRO.codcia = s-codcia
      AND B-ORDPRO.NumOrd = p-numOrd
      NO-LOCK.
      
    DISPLAY
        p-NumOrd @ LPRCLPRO.NumOrd
        TODAY    @ LPRCLPRO.FchDoc
        WITH FRAME {&FRAME-NAME}.     
    RUN Carga-Temporal.
  END.
  LPRCLPRO.NumOrd:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  L-CREA = YES.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('Browse').
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
 IF L-CREA THEN DO:
    DEFINE VAR X-NumDoc AS INTEGER.   
      FIND LAST B-LPROD WHERE B-LPROD.Codcia = S-CODCIA 
        AND B-LPROD.CodMaq = LPRCLPRO.CodMaq
        NO-LOCK NO-ERROR.
      IF AVAILABLE B-LPROD THEN x-NumDoc = INTEGER(B-LPROD.NroDoc) + 1.
         ELSE x-NumDoc = 1.
      DO WITH FRAME {&FRAME-NAME}:
       ASSIGN
         LPRCLPRO.Codcia  = S-CODCIA
         LPRCLPRO.NroDoc  = STRING(X-NumDoc,"999999")
         LPRCLPRO.FchDoc  = TODAY 
         LPRCLPRO.HraDoc  = STRING(TIME,"HH:MM")
         LPRCLPRO.Estado  = "E".
      END.
 END.
  ASSIGN
    LPRCLPRO.Usuario = s-user-id.
  RUN Graba-Materiales.
  RUN Graba-Orden.
  RUN Graba-HorasHombre. 
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  RUN Procesa-Handle IN lh_handle ('Browse').

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
  RUN Procesa-Handle IN lh_handle ('Pagina1').
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
  IF LPRCLPRO.Estado <> "E" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE LPRCLPRO THEN RETURN 'ADM-ERROR'.
  IF LPRCLPRO.Estado = "A" THEN RETURN "ADM-ERROR".
  
  IF LPRCLPRO.Estado = "L" THEN DO:
     MESSAGE "Lote de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
 DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR"
        ON STOP UNDO, RETURN 'ADM-ERROR': 
      FIND B-LPROD WHERE ROWID(B-LPROD) = ROWID(LPRCLPRO) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-LPROD THEN DO:
        RUN Borra-Detalles.
        ASSIGN
            B-LPROD.Estado = "A"
            B-LPROD.Usuario = s-user-id.
  
        RELEASE B-LPROD.
      END.
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
  
  DO WITH FRAME {&FRAME-NAME}:
    IF AVAILABLE LPRCLPRO THEN DO:
       CASE LPRCLPRO.Estado:
            WHEN "E" THEN DISPLAY "     E N T R A D A     " @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "A" THEN DISPLAY "     A N U L A D O     " @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "L" THEN DISPLAY "   L I Q U I D A D O   " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE. 
       FIND LPRMAQUI WHERE LPRMAQUI.CodCia = LPRCLPRO.CodCia AND
          LPRMAQUI.CodMaq = LPRCLPRO.CodMaq NO-LOCK NO-ERROR.
         x-maquina:SCREEN-VALUE = IF AVAILABLE LPRMAQUI THEN LPRMAQUI.DesPro ELSE "".
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
  IF NOT AVAILABLE LPRCLPRO THEN RETURN.
  
  IF LPRCLPRO.Estado = "A" THEN DO:
    MESSAGE "Orden de Produccion Anulada" VIEW-AS ALERT-BOX WARNING.
    RETURN .
  END.
  
  /* Pantalla general de parametros de impresion */
    
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

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
  {src/adm/template/snd-list.i "LPRCLPRO"}

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
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
    /*Maquinaria*/
     FIND FIRST LPRMAQUI WHERE
          LPRMAQUI.CodCia = s-CodCia AND
          LPRMAQUI.CodMaq = INPUT LPRCLPRO.CodMaq
          NO-LOCK NO-ERROR.
          IF NOT AVAILABLE LPRMAQUI THEN DO:
             MESSAGE "No existe maquina" VIEW-AS ALERT-BOX ERROR.
             RETURN 'ADM-ERROR'.
          END.
            DISPLAY
                LPRMAQUI.DesPro @ x-maquina 
            WITH FRAME {&FRAME-NAME}. 

     /*Validando Fechas*/
     IF DECIMAL(INPUT LPRCLPRO.FchPro) < DECIMAL(TODAY) THEN DO:
        MESSAGE "Fecha invalida" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO LPRCLPRO.FchPro.
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
 IF LPRCLPRO.Estado = 'A' THEN DO:
    MESSAGE 'Lote Anulado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
 END.
 
 IF LPRCLPRO.Estado <> 'E' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
 END.
 
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

