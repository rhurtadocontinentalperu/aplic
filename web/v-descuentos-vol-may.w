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
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCredito.p*/
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCreditoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalCreditoMayorista.p

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE VAR    I AS INTEGER NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almmmatg.DtoVolR[1] Almmmatg.DtoVolD[1] ~
Almmmatg.DtoVolR[2] Almmmatg.DtoVolD[2] Almmmatg.DtoVolR[3] ~
Almmmatg.DtoVolD[3] Almmmatg.DtoVolR[4] Almmmatg.DtoVolD[4] ~
Almmmatg.DtoVolR[5] Almmmatg.DtoVolD[5] Almmmatg.DtoVolR[6] ~
Almmmatg.DtoVolD[6] Almmmatg.DtoVolR[7] Almmmatg.DtoVolD[7] ~
Almmmatg.DtoVolR[8] Almmmatg.DtoVolD[8] Almmmatg.DtoVolR[9] ~
Almmmatg.DtoVolD[9] Almmmatg.DtoVolR[10] Almmmatg.DtoVolD[10] 
&Scoped-define ENABLED-TABLES Almmmatg
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 RECT-14 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.UndBas ~
Almmmatg.DesMat Almmmatg.DtoVolR[1] Almmmatg.DtoVolD[1] Almmmatg.DtoVolR[2] ~
Almmmatg.DtoVolD[2] Almmmatg.DtoVolR[3] Almmmatg.DtoVolD[3] ~
Almmmatg.DtoVolR[4] Almmmatg.DtoVolD[4] Almmmatg.DtoVolR[5] ~
Almmmatg.DtoVolD[5] Almmmatg.DtoVolR[6] Almmmatg.DtoVolD[6] ~
Almmmatg.DtoVolR[7] Almmmatg.DtoVolD[7] Almmmatg.DtoVolR[8] ~
Almmmatg.DtoVolD[8] Almmmatg.DtoVolR[9] Almmmatg.DtoVolD[9] ~
Almmmatg.DtoVolR[10] Almmmatg.DtoVolD[10] 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg


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
DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.29 BY .85.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.14 BY 8.69.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 12.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.codmat AT ROW 1.73 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.UndBas AT ROW 1.73 COL 18.14 COLON-ALIGNED NO-LABEL FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DesMat AT ROW 2.58 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40.57 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DtoVolR[1] AT ROW 4.5 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[1] AT ROW 4.5 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[2] AT ROW 5.31 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[2] AT ROW 5.31 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[3] AT ROW 6.12 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[3] AT ROW 6.12 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[4] AT ROW 6.92 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[4] AT ROW 6.92 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[5] AT ROW 7.73 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[5] AT ROW 7.73 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[6] AT ROW 8.54 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[6] AT ROW 8.54 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[7] AT ROW 9.35 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[7] AT ROW 9.35 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[8] AT ROW 10.15 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[8] AT ROW 10.15 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[9] AT ROW 10.96 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[9] AT ROW 10.96 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.DtoVolR[10] AT ROW 11.77 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[10] AT ROW 11.77 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     "DESCUENTO POR VOLUMEN" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 1 COL 11 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.54 COL 21
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.54 COL 5.14
     RECT-10 AT ROW 3.38 COL 2.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-13 AT ROW 4.23 COL 2.86
     RECT-14 AT ROW 1.27 COL 2 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almmmatg
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
         HEIGHT             = 12.81
         WIDTH              = 46.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME Almmmatg.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[10] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[10] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Almmmatg.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Almmmatg.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[1] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[1] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[2] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[2] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[3] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[3] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[4] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[4] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[5] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[5] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[6] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[6] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[7] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[7] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[8] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[8] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[9] V-table-Win
ON LEAVE OF Almmmatg.DtoVolD[9] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
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
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Orden AS INT NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* CONSISTENCIAS PREVIAS */
  DEF VAR x-Margen AS DEC NO-UNDO.
  DEF VAR x-Limite AS DEC NO-UNDO.
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR iCuentaRangos AS INT NO-UNDO.

  /* CONSISTENCIA MARGEN DE UTILIDAD */
  /* CONSISTENCIA CANTIDAD DE RANGOS */
  iCuentaRangos = 0.
  DO x-Orden = 1 TO 10:
      IF Almmmatg.DtoVolR[x-Orden] <> 0 THEN iCuentaRangos = iCuentaRangos + 1.
  END.
  IF iCuentaRangos = 1 THEN DO:
      MESSAGE "Debe definir más de un rango" VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* CONSISTENCIA DE MAYOR A MENOR */
  iCuentaRangos = 0.
  DO x-Orden = 1 TO 10:
      IF Almmmatg.DtoVolR[x-Orden] = 0 THEN NEXT.
      IF iCuentaRangos > 0 AND Almmmatg.DtoVolR[x-Orden] > 0
          AND Almmmatg.DtoVolR[x-Orden] < iCuentaRangos 
          THEN DO:
          MESSAGE "Debe definir los rangos de menor a mayor" VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      iCuentaRangos = Almmmatg.DtoVolR[x-Orden].
  END.

  almmmatg.fchact = TODAY.
  DO x-Orden = 1 TO 10:
      IF Almmmatg.DtoVolR[x-Orden] = 0 OR Almmmatg.DtoVolD[x-Orden] = 0
      THEN ASSIGN
                Almmmatg.DtoVolR[x-Orden] = 0
                Almmmatg.DtoVolD[x-Orden] = 0
                Almmmatg.DtoVolP[x-Orden] = 0.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
  RUN lib/logtabla ('Almmmatg', Almmmatg.codmat, 'WRITE').   /* Log de cambios */

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
  {src/adm/template/snd-list.i "Almmmatg"}

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

DEF VAR x-ValorAnterior AS DEC NO-UNDO.
DEF VAR x-Orden AS INT NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

DO WITH FRAME {&FRAME-NAME} :
    DO x-Orden = 1 TO 10:
        IF INPUT Almmmatg.DtoVolR[x-Orden] <= 0 THEN NEXT.
        IF x-ValorAnterior = 0 THEN x-ValorAnterior = INPUT Almmmatg.DtoVolR[x-Orden].
        IF INPUT Almmmatg.DtoVolR[x-Orden] < x-ValorAnterior THEN DO:
            MESSAGE 'Cantidad mínima mal registrada' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        x-ValorAnterior = INPUT Almmmatg.DtoVolR[x-Orden].
    END.
    /* ****************************************************************************************************** */
    /* Control Margen de Utilidad */
    /* Se van a barrer todos los productos relacionados */
    /* ****************************************************************************************************** */
    /* 05/12/2022: Control de Margen */
    RUN Valida-Margen.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
END.
DELETE PROCEDURE hProc.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Margen V-table-Win 
PROCEDURE Valida-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-PorDto AS DECI NO-UNDO.                                 
DEF VAR x-Orden AS INT NO-UNDO.
DEF VAR x-Margen AS DECI NO-UNDO.
DEF VAR x-Limite AS DECI NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN pri/pri-librerias PERSISTENT SET hProc.

DO x-Orden = 1 TO 10 WITH FRAME {&FRAME-NAME}:
    x-PorDto =  INPUT Almmmatg.DtoVolD[x-Orden].
    IF x-PorDto > 0 THEN DO:
        RUN PRI_Margen-Utilidad-Listas IN hProc (INPUT "",
                                                 INPUT Almmmatg.CodMat,
                                                 INPUT Almmmatg.UndBas,
                                                 INPUT x-PorDto,
                                                 INPUT 1,
                                                 OUTPUT x-Margen,
                                                 OUTPUT x-Limite,
                                                 OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' OR pError > '' THEN DO:
            MESSAGE pError VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').
DELETE PROCEDURE hProc.

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

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

