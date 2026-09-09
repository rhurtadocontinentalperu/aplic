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
DEFINE SHARED VARIABLE S-NOMCIA AS CHAR.
DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE BUFFER B-Docum FOR FacDocum.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES FacDocum
&Scoped-define FIRST-EXTERNAL-TABLE FacDocum


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacDocum.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacDocum.FlgCbd FacDocum.Codope ~
FacDocum.TpoDoc FacDocum.CodCta[1] FacDocum.CodCta[2] FacDocum.CodCta[3] ~
FacDocum.CodCta[4] FacDocum.CodCbd FacDocum.CodCta[8] 
&Scoped-define ENABLED-TABLES FacDocum
&Scoped-define FIRST-ENABLED-TABLE FacDocum
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-7 
&Scoped-Define DISPLAYED-FIELDS FacDocum.FlgCbd FacDocum.Codope ~
FacDocum.TpoDoc FacDocum.CodCta[1] FacDocum.CodCta[2] FacDocum.CodCta[3] ~
FacDocum.CodCta[4] FacDocum.CodCbd FacDocum.CodCta[8] 
&Scoped-define DISPLAYED-TABLES FacDocum
&Scoped-define FIRST-DISPLAYED-TABLE FacDocum
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 ~
FILL-IN-5 

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
DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 7.27.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 7.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacDocum.FlgCbd AT ROW 2.08 COL 4 WIDGET-ID 8
          LABEL "Genera Mov. Contable"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .77
     FacDocum.Codope AT ROW 3.69 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN-1 AT ROW 4.5 COL 23 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 5.31 COL 23 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 6.12 COL 23 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 6.92 COL 23 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 7.73 COL 23 COLON-ALIGNED NO-LABEL
     FacDocum.TpoDoc AT ROW 2.88 COL 4 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Cargo", yes,
"Abono", no,
"Ninguno", ?
          SIZE 28 BY .81
     FacDocum.CodCta[1] AT ROW 5.31 COL 14 COLON-ALIGNED
          LABEL "Cuenta MN"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacDocum.CodCta[2] AT ROW 6.12 COL 14 COLON-ALIGNED
          LABEL "Cuenta ME"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacDocum.CodCta[3] AT ROW 6.92 COL 14 COLON-ALIGNED
          LABEL "Cuenta Orden-1"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacDocum.CodCta[4] AT ROW 7.73 COL 14 COLON-ALIGNED
          LABEL "Cuenta Orden-2"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacDocum.CodCbd AT ROW 4.5 COL 14 COLON-ALIGNED
          LABEL "Doc. SUNAT"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FacDocum.CodCta[8] AT ROW 2.08 COL 74 COLON-ALIGNED WIDGET-ID 12
          LABEL "Prefijo Cod. Barra" FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     "Configuración Contable" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 
     "Otros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 62 WIDGET-ID 16
          BGCOLOR 9 FGCOLOR 15 
     RECT-6 AT ROW 1.54 COL 2 WIDGET-ID 10
     RECT-7 AT ROW 1.54 COL 61 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacDocum
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
         HEIGHT             = 12.04
         WIDTH              = 94.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN FacDocum.CodCbd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacDocum.CodCta[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacDocum.CodCta[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacDocum.CodCta[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacDocum.CodCta[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacDocum.CodCta[8] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX FacDocum.FlgCbd IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME FacDocum.CodCta[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDocum.CodCta[1] V-table-Win
ON LEAVE OF FacDocum.CodCta[1] IN FRAME F-Main /* Cuenta MN */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN DO:
       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE cb-ctas THEN DO:
          MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FacDocum.Codcta[1].
          RETURN NO-APPLY.
       END.
       DISPLAY
         cb-ctas.Nomcta @ FILL-IN-2.
       END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacDocum.CodCta[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDocum.CodCta[2] V-table-Win
ON LEAVE OF FacDocum.CodCta[2] IN FRAME F-Main /* Cuenta ME */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN DO:
       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE cb-ctas THEN DO:
          MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FacDocum.Codcta[2].
          RETURN NO-APPLY.
       END.
       DISPLAY
         cb-ctas.Nomcta @ FILL-IN-3.
     END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacDocum.CodCta[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDocum.CodCta[3] V-table-Win
ON LEAVE OF FacDocum.CodCta[3] IN FRAME F-Main /* Cuenta Orden-1 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN DO:
       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE cb-ctas THEN DO:
          MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FacDocum.Codcta[3].
          RETURN NO-APPLY.
       END.
       DISPLAY
         cb-ctas.Nomcta @ FILL-IN-4.
     END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacDocum.CodCta[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDocum.CodCta[4] V-table-Win
ON LEAVE OF FacDocum.CodCta[4] IN FRAME F-Main /* Cuenta Orden-2 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN DO:
       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE cb-ctas THEN DO:
          MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO FacDocum.Codcta[4].
          RETURN NO-APPLY.
       END.
       DISPLAY
         cb-ctas.Nomcta @ FILL-IN-5.
     END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacDocum.Codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDocum.Codope V-table-Win
ON LEAVE OF FacDocum.Codope IN FRAME F-Main /* Operacion */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN DO:
        FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
             cb-oper.Codope = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-oper THEN DO:
           MESSAGE 'Operacion no existe' VIEW-AS ALERT-BOX.
           APPLY 'ENTRY ':U TO integral.FacDocum.Codope.
           RETURN NO-APPLY.
        END.
     END.
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
  {src/adm/template/row-list.i "FacDocum"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacDocum"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir V-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 82 TODAY SKIP(1)
    {&PRN6A} + "CONFIGURACION CONTABLE - CUENTAS POR COBRAR" + {&PRN6B} + {&PRND} AT 45 FORMAT "X(45)" SKIP(1)
    "----------------------------------------------------------------------------------------------------------------" SKIP
    "                                                     GENERA  COD. DOC.      C U E N T A         O R D E N - 2   " SKIP
    "  COD. DESCRIPCION                             TIPO  ASIENTO OPE. CONT.   SOLES    DOLARES    SOLES    DOLARES  " SKIP
    "----------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 115. 
   
 DEFINE FRAME F-Detalle
   B-Docum.CodDoc AT 3
   B-Docum.NomDoc AT 8 FORMAT 'X(40)'
   B-Docum.TpoDoc AT 48
   B-Docum.FlgCbd AT 55
   B-Docum.Codope AT 62
   B-Docum.CodCbd AT 68
   B-Docum.CodCta[1] AT 73
   B-Docum.CodCta[2] AT 83
   B-Docum.CodCta[3] AT 93
   B-Docum.CodCta[4] AT 103
   WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 115 STREAM-IO DOWN. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
/*       WHEN 2 THEN OUTPUT TO PRINTER VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */*/
       WHEN 2 THEN OUTPUT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.

 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
 FOR EACH B-Docum WHERE B-Docum.codcia = s-codcia NO-LOCK :
     VIEW FRAME F-Header.
     DISPLAY  
       B-Docum.CodDoc 
       B-Docum.NomDoc 
       B-Docum.TpoDoc 
       B-Docum.FlgCbd 
       B-Docum.Codope 
       B-Docum.CodCbd 
       B-Docum.CodCta[1] 
       B-Docum.CodCta[2] 
       B-Docum.CodCta[3] 
       B-Docum.CodCta[4] 
     WITH FRAME F-Detalle.
 END.
 OUTPUT CLOSE.
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
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.Codcta = FacDocum.CodCta[1] NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        DISPLAY
          cb-ctas.Nomcta @ FILL-IN-2.
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.Codcta = FacDocum.CodCta[2] NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        DISPLAY
          cb-ctas.Nomcta @ FILL-IN-3.
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.Codcta = FacDocum.CodCta[3] NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        DISPLAY
          cb-ctas.Nomcta @ FILL-IN-4.
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.Codcta = FacDocum.CodCta[4] NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        DISPLAY
          cb-ctas.Nomcta @ FILL-IN-5.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*RUN bin/_prnctr.p.*/
  RUN lib/Imprimir.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
/*  RUN aderb/_prlist.p(
 *       OUTPUT s-printer-list,
 *       OUTPUT s-port-list,
 *       OUTPUT s-printer-count).
 *   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *   s-port-name = REPLACE(S-PORT-NAME, ":", "").*/
   
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   
  RUN Imprimir.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
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
  {src/adm/template/snd-list.i "FacDocum"}

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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE FacDocum THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

