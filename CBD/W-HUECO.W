&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

{BIN/S-GLOBAL.I}
{CBD/CBGLOBAL.I}
DEFINE BUFFER CABEZA FOR CB-CMOV.


DEF VAR X-MSG1 AS CHAR FORMAT "X(35)".
DEF VAR X-MSG2 AS CHAR FORMAT "X(35)".

DEFINE FRAME F-CAB 
  X-MSG1 SKIP
  X-MSG2
WITH TITLE "PROCESANDO COMPROBANTE" NO-LABELS CENTERED 
     VIEW-AS DIALOG-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 c-mes TOGGLE-2 F-Asiento BUTTON-2 ~
F-RANGO F-NroDoc 
&Scoped-Define DISPLAYED-OBJECTS c-mes TOGGLE-2 F-Asiento F-RANGO F-NroDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 F-Asiento F-NroDoc 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Procesar" 
     SIZE 12 BY 1.46.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 12 BY 1.46.

DEFINE VARIABLE c-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 6.43 BY 1 NO-UNDO.

DEFINE VARIABLE F-Asiento AS CHARACTER FORMAT "X(6)":U 
     LABEL "Asiento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-NroDoc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE F-RANGO AS INTEGER FORMAT "999":U INITIAL 10 
     LABEL "Rango" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL no 
     LABEL "Anula Detalle sin cabecera" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.14 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 5.77 COL 4.57
     c-mes AT ROW 1.73 COL 6.43 COLON-ALIGNED
     TOGGLE-2 AT ROW 3.08 COL 8.14
     F-Asiento AT ROW 4.38 COL 5 COLON-ALIGNED
     BUTTON-2 AT ROW 5.77 COL 20.29
     F-RANGO AT ROW 1.73 COL 23 COLON-ALIGNED
     F-NroDoc AT ROW 4.38 COL 23.14 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Anular comprobantes Vacios"
         HEIGHT             = 6.5
         WIDTH              = 36.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN F-Asiento IN FRAME F-Main
   1                                                                    */
/* SETTINGS FOR FILL-IN F-NroDoc IN FRAME F-Main
   1                                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Anular comprobantes Vacios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Anular comprobantes Vacios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
    DEF VAR X AS LOGICAL.
    ASSIGN C-MES F-RANGO F-Asiento F-NroDoc.
    X = SESSION:SET-WAIT-STATE("GENERAL").
    IF TOGGLE-2:SCREEN-VALUE = "NO" THEN
       RUN PROCESO.
    ELSE
       RUN DELEDETA.
    X = SESSION:SET-WAIT-STATE("").      
    APPLY "CLOSE":U TO THIS-PROCEDURE.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Salir */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-2 W-Win
ON VALUE-CHANGED OF TOGGLE-2 IN FRAME F-Main /* Anula Detalle sin cabecera */
DO:
   IF TOGGLE-2:SCREEN-VALUE = "NO" THEN DO:
       F-Asiento:SENSITIVE = NO.
       F-NroDoc:SENSITIVE = NO.
   END.    
   ELSE DO :
       F-Asiento:SENSITIVE = YES.
       F-NroDoc:SENSITIVE = YES.
   END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

F-Asiento:SENSITIVE = NO.
F-NroDoc:SENSITIVE = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREA-CAB W-Win 
PROCEDURE CREA-CAB :
DEFINE INPUT PARAMETER I        AS INTEGER .
DEFINE INPUT PARAMETER X-NROAST AS CHAR.
DEFINE INPUT PARAMETER X-CODOPE AS CHAR.
DEFINE INPUT PARAMETER X-FCHAST AS DATE.

DEF VAR J AS INTEGER.
DEF VAR Y AS CHAR.

DO J = I TO INTEGER(X-NROAST) - 1 :
   Y = STRING(J,"999999").
   FIND CABEZA WHERE CABEZA.CODCIA   = S-CODCIA  AND
                     CABEZA.PERIODO  = S-PERIODO AND   
                     CABEZA.NROMES   = C-MES     AND
                     CABEZA.CODOPE   = X-CODOPE  AND
                     CABEZA.NROAST   = Y
                     NO-LOCK NO-ERROR.
  IF NOT AVAIL CABEZA THEN DO:
     CREATE CABEZA.
     ASSIGN CABEZA.CODCIA  = S-CODCIA 
            CABEZA.PERIODO = S-PERIODO
            CABEZA.NROMES  = C-MES
            CABEZA.CODOPE  = X-CODOPE
            CABEZA.NROAST  = Y
            CABEZA.FCHAST  = X-FCHAST
            CABEZA.GLOAST  = "*** A N U L A D O  ***"
            CABEZA.NOTAST  = "*** A N U L A D O  ***"
            CABEZA.FLGEST  = "A".
     X-MSG2 = "ANULANDO: " + Y .
     DISPLAY X-MSG2 WITH FRAME F-CAB.
     PAUSE 0.         
       
            
  END.                   

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleDeta W-Win 
PROCEDURE DeleDeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CB-DMOV
         WHERE CB-DMOV.CODCIA  = S-CODCIA AND
                       CB-DMOV.PERIODO = S-PERIODO AND
                       CB-DMOV.NROMES  = C-MES AND
                       CB-DMOV.CODOPE  = STRING(F-RANGO,"999") AND
                       CB-DMOV.NROAST  = F-Asiento
                       BREAK BY CB-DMOV.NROAST :                             
    X-MSG1 = STRING(CB-DMOV.NROMES,"99") + "-" +
             CB-DMOV.CODOPE              + "-" +
             CB-DMOV.NROAST              + "-" +
             Cb-dmov.Glodoc.
                          
    DISPLAY X-MSG1 WITH FRAME F-CAB.
    PAUSE 0. 
    
    FIND CB-CMOV WHERE CB-CMOV.CODCIA  = CB-DMOV.CODCIA AND
                       CB-CMOV.PERIODO = CB-DMOV.PERIODO AND
                       CB-CMOV.NROMES  = CB-DMOV.NROMES AND
                       CB-CMOV.CODOPE  = CB-DMOV.CODOPE AND
                       CB-CMOV.NROAST  = CB-DMOV.NROAST NO-LOCK NO-ERROR.
                       
    IF NOT AVAILABLE CB-CMOV THEN DO :
       
       X-MSG1 = " Se encontro un Registro sin Cabecera ".
       DISPLAY X-MSG1 WITH FRAME F-CAB.
       PAUSE 0. 
       
       DELETE CB-DMOV.
                            
    END.   
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY c-mes TOGGLE-2 F-Asiento F-RANGO F-NroDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 c-mes TOGGLE-2 F-Asiento BUTTON-2 F-RANGO F-NroDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
C-MES = S-NROMES.  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO W-Win 
PROCEDURE PROCESO :
DEF VAR I AS INTEGER.
DEF VAR F AS LOGICAL.

FOR EACH CB-CMOV
         NO-LOCK WHERE CB-CMOV.CODCIA  = S-CODCIA AND
                       CB-CMOV.PERIODO = S-PERIODO AND
                       CB-CMOV.NROMES  = C-MES     AND
                       CB-CMOV.NROAST  <> ""
                       BREAK BY CB-CMOV.CODOPE 
                             BY CB-CMOV.NROAST :

    X-MSG1 = STRING(CB-CMOV.NROMES,"99") + "-" +
             CB-CMOV.CODOPE              + "-" +
             CB-CMOV.NROAST.
    DISPLAY X-MSG1 WITH FRAME F-CAB.
    PAUSE 0.         
    
    IF FIRST-OF(CB-CMOV.CODOPE) THEN DO:
         I = INTEGER(CB-CMOV.NROAST).
    END.     
    ELSE I = I + 1.
    IF  INTEGER(CB-CMOV.NROAST) - I >= F-RANGO 
        THEN I = INTEGER(CB-CMOV.NROAST).
    IF  CB-CMOV.NROAST <> STRING(I,"999999") AND
        INTEGER(CB-CMOV.NROAST) > I  THEN DO:
        RUN CREA-CAB(I , CB-CMOV.NROAST ,  CB-CMOV.CODOPE, CB-CMOV.FCHAST ).
        I = INTEGER(CB-CMOV.NROAST).
    END.                       
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


