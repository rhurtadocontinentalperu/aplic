&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE VAR C-DESMOV AS CHAR.
DEFINE VAR C-OP AS CHAR.
DEFINE STREAM REPORT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 DesdeF HastaF RECT-21 R-Puerto ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DesdeF HastaF R-Puerto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-Puerto AS CHARACTER INITIAL "S" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", "S",
"Impresora", "P"
     SIZE 10.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 36.29 BY 7.69.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12.57 BY 2.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DesdeF AT ROW 1.62 COL 15.14 COLON-ALIGNED
     HastaF AT ROW 2.38 COL 15.14 COLON-ALIGNED
     R-Puerto AT ROW 1.58 COL 39.86 NO-LABEL
     Btn_OK AT ROW 4.08 COL 39
     Btn_Cancel AT ROW 6.38 COL 39
     RECT-20 AT ROW 1 COL 1
     RECT-21 AT ROW 1.31 COL 39
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
         TITLE              = "Resumen Movimiento"
         HEIGHT             = 7.88
         WIDTH              = 51.86
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
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen Movimiento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen Movimiento */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN DesdeF HastaF R-Puerto.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY DesdeF HastaF R-Puerto 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-20 DesdeF HastaF RECT-21 R-Puerto Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME W-Win 
PROCEDURE IMPRIME :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR S-NOMTMP AS CHAR NO-UNDO.
  DEFINE VAR S-MOVIM  AS CHAR  FORMAT "X(50)" NO-UNDO.
  DEFINE VAR F-IMPORT AS DECIMAL FORMAT "(>>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR F-TOTMOV AS DECIMAL FORMAT "(>>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR F-TOTGEN AS DECIMAL FORMAT "(>>>,>>>,>>9.99)" NO-UNDO.
  DEFINE FRAME F-REP
         Almcmov.CodMov COLUMN-LABEL "Cod.!Mov."
         S-MOVIM         COLUMN-LABEL "D E S C R I P C I O N" FORMAT "X(50)"
         F-IMPORT FORMAT "(>>>,>>>,>>9.99)"
     HEADER
         S-NOMCIA     "RESUMEN DE MOVIMIENTOS" AT 30  "Pagina :" TO 70 
         PAGE-NUMBER(REPORT) TO 80 FORMAT "ZZZZZ9" SKIP
         "Fecha :" TO 70 Almcmov.FchDoc TO 80 FORMAT "99/99/9999" SKIP
         "Hora :" TO 70 STRING(TIME,"HH:MM:SS") TO 80 SKIP(1)
         "Periodo del " DesdeF " al " HastaF SKIP(1)
         "------------------------------------------------------------------------" SKIP
         "Mov. D E S C R I P C I O N                                       Importe" SKIP
         "------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
  IF R-Puerto = "S" THEN DO:
     OUTPUT STREAM REPORT TO C:\TMP\12345678.PRN PAGED PAGE-SIZE 62.
     S-NOMTMP = "C:\TMP\12345678.PRN".
   END.
  ELSE DO:
       OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62.   
       PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
       PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15). 
  END.
  FOR EACH Almcmov WHERE 
           Almcmov.CodCia  = S-CODCIA AND
           Almcmov.CodAlm  = S-CODALM AND
           Almcmov.FchDoc >= DesdeF   AND
           Almcmov.FchDoc <= HastaF
           BREAK BY Almcmov.CodAlm
                 BY Almcmov.TipMov
                 BY Almcmov.CodMov:
      IF FIRST-OF(Almcmov.TipMov) THEN DO:
         IF Almcmov.TipMov = "I" THEN S-MOVIM = "I N G R E S O S".
         IF Almcmov.TipMov = "S" THEN S-MOVIM = "S A L I D A S".
         IF Almcmov.TipMov = "T" THEN S-MOVIM = "T R A N S F E R E N C I A S".
         DISPLAY STREAM REPORT
                 S-MOVIM WITH FRAME F-REP.
      END.
      FOR EACH Almdmov WHERE  
               Almdmov.CodCia = Almcmov.CodCia AND
               Almdmov.CodAlm = Almcmov.CodAlm AND
               Almdmov.TipMov = Almcmov.TipMov AND
               Almdmov.CodMov = Almcmov.CodMov AND
               Almdmov.NroDoc = Almdmov.NroDoc:
          F-IMPORT = F-IMPORT + Almdmov.ImpCto.
      END.
      IF LAST-OF(Almcmov.CodMov) THEN DO:
         FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia AND
              Almtmovm.Tipmov = Almcmov.TipMov  AND
              Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
         IF AVAILABLE Almtmovm THEN S-MOVIM = Almtmovm.Desmov.
         ELSE S-MOVIM = "".
         DOWN STREAM report 1 WITH FRAME F-REP.
         DISPLAY STREAM REPORT
                 Almcmov.CodMov
                 S-MOVIM
                 F-IMPORT WITH FRAME F-REP.
         DOWN STREAM report 1 WITH FRAME F-REP.
         F-TOTMOV = F-TOTMOV + F-IMPORT.
         F-IMPORT = 0.
      END.
      IF LAST-OF(Almcmov.TipMov) THEN DO:
         UNDERLINE STREAM report 
                   S-MOVIM
                   Almdmov.ImpCto  WITH FRAME F-REP.
         IF Almcmov.TipMov = "I" THEN S-MOVIM = "T O T A L    I N G R E S O S".
         IF Almcmov.TipMov = "S" THEN S-MOVIM = "T O T A L    S A L I D A S".
         IF Almcmov.TipMov = "T" THEN S-MOVIM = "T O T A L    T R A N S F E R E N C I A S".
         DISPLAY STREAM REPORT 
                 S-MOVIM
                 F-TOTMOV @ F-IMPORT WITH FRAME F-REP.
         DOWN STREAM report 1 WITH FRAME F-REP.
         F-TOTGEN = F-TOTGEN + F-TOTMOV.
         F-TOTMOV = 0.
      END.
      IF LAST-OF(Almcmov.CodAlm) THEN DO:
         UNDERLINE STREAM report 
                   S-MOVIM
                   Almdmov.ImpCto  WITH FRAME F-REP.
         DISPLAY STREAM REPORT 
                 "T O T A L    G E N E R A L" @ S-MOVIM
                 F-TOTGEN @ F-IMPORT WITH FRAME F-REP.
         DOWN STREAM report 1 WITH FRAME F-REP.
      END.
  END.
  OUTPUT STREAM REPORT CLOSE.
  IF R-Puerto = "S" THEN DO:
     RUN LIB\W-README.R(S-NOMTMP).
  END.

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
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY
            HastaF = TODAY.
     DISPLAY DesdeF HastaF.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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


