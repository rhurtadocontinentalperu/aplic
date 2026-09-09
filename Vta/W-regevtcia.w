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
DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR wtotsol AS DEC NO-UNDO.
DEF VAR wtotdol AS DEC NO-UNDO.
DEF VAR wtotcts AS DEC NO-UNDO.
DEF VAR wtotctd AS DEC NO-UNDO.
DEF VAR wtotcrs AS DEC NO-UNDO.
DEF VAR wtotcrd AS DEC NO-UNDO.
DEF VAR wtipcam AS DEC NO-UNDO.

DEF VAR wfactor AS DECIMAL NO-UNDO.
DEF VAR I       AS INT NO-UNDO.

DEF VAR w-perio AS INT NO-UNDO.
DEF VAR w-mes   AS INT NO-UNDO.
DEF VAR w-dia   AS INT NO-UNDO.

DEF VAR w-perio-2 AS INT NO-UNDO.
DEF VAR w-mes-2   AS INT NO-UNDO.
DEF VAR w-dia-2   AS INT NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wtipcam = FacCfgGn.Tpocmb[1] .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-1 BUTTON-12 BUTTON-13 ~
BUTTON-14 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-2 FILL-IN-1 COMBO-BOX-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Cerrar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-13 AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "help" 
     SIZE 12.43 BY 1.54.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "A¤o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "A¤o","Mes" 
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 33.14 BY 5.77
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.43 BY 7.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-2 AT ROW 1.19 COL 2 NO-LABEL
     FILL-IN-1 AT ROW 7.12 COL 2.14 NO-LABEL
     COMBO-BOX-1 AT ROW 16.92 COL 1 NO-LABEL
     BUTTON-12 AT ROW 1.46 COL 36
     BUTTON-13 AT ROW 3.38 COL 36
     BUTTON-14 AT ROW 5.31 COL 36
     RECT-1 AT ROW 1 COL 1
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
         TITLE              = "Regeneracion de Estadisticas"
         HEIGHT             = 7.5
         WIDTH              = 48.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\db":U) THEN
    MESSAGE "Unable to load icon: img\db"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-2:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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
ON END-ERROR OF W-Win /* Regeneracion de Estadisticas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Regeneracion de Estadisticas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
  MESSAGE " Esta seguro de Efectuar operacion " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN      
         DO:
            IF session:set-wait-state("GENERAL") THEN 
               RUN Procesa-Estadistica.  
            IF session:set-wait-state(" ") THEN 
               MESSAGE " Proceso Terminado " VIEW-AS ALERT-BOX INFORMATION. 
         END.  
       WHEN no  THEN 
            RETURN.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON ENTRY OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
   IF BUTTON-12:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON ENTRY OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  IF BUTTON-13:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON ENTRY OF BUTTON-14 IN FRAME F-Main /* help */
DO:
  IF BUTTON-14:LOAD-MOUSE-POINTER("GLOVE") THEN. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY EDITOR-2 FILL-IN-1 COMBO-BOX-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 COMBO-BOX-1 BUTTON-12 BUTTON-13 BUTTON-14 
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
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  editor-2 = "Este proceso regenera las estadisticas de 
  Venta en forma total.  Para proceder 
  no debe de existir usuarios en el sistema 
  Asegurese que todas las operaciones esten  
  correctamente generados. 
  La duracion de este proceso dependera del 
  volumen de informacion registrado en el  
  en el sistema".
  DISPLAY EDITOR-2 WITH FRAME {&FRAME-NAME}.
  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Estadistica W-Win 
PROCEDURE Procesa-Estadistica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   Define var x-signo1 as integer init 1.
   Define var x-fin    as integer init 0.
   Define var f-factor as deci    init 0.


   FOR EACH EvtDivi WHERE EvtDivi.Codcia = S-CODCIA :
       DELETE EvtDivi.
   END.
   FOR EACH EvtArti WHERE EvtArti.Codcia = S-CODCIA :
       DELETE EvtArti.
   END.

   FOR EACH EvtClie WHERE EvtClie.Codcia = S-CODCIA :
       DELETE EvtClie.
   END.

   FOR EACH EvtFpgo WHERE EvtFpgo.Codcia = S-CODCIA :
       DELETE EvtFpgo.
   END.

   FOR EACH EvtVend WHERE EvtVend.Codcia = S-CODCIA :
       DELETE EvtVend.
   END.

   FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA NO-LOCK:
     
       IF Lookup(CcbCDocu.CodDoc,"FAC,BOL,N/C,N/D") = 0 THEN NEXT.
       IF CcbCDocu.FlgEst = "A"  THEN NEXT.
       x-signo1 = IF Ccbcdocu.Coddoc = "N/C" THEN -1 ELSE 1.
       ASSIGN
          fill-in-1 = CcbCDocu.CodCli + "-" + CcbCDocu.NomCli.
       DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 


      /**************** INICIA DIVISION *******************/
       FIND EvtDivi WHERE EvtDivi.Codcia = Ccbcdocu.Codcia AND
                          EvtDivi.CodDiv = Ccbcdocu.Coddiv AND
                          EvtDivi.NroFch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99")) NO-ERROR.
       IF NOT AVAILABLE EvtDivi THEN DO:
         CREATE EvtDivi.
         ASSIGN
         EvtDivi.Codcia = Ccbcdocu.Codcia 
         EvtDivi.CodDiv = Ccbcdocu.Coddiv 
         EvtDivi.CodAno = YEAR(Ccbcdocu.FchDoc) 
         EvtDivi.CodMes = MONTH(Ccbcdocu.FchDoc)
         EvtDivi.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))  .
       END.                    
       IF Ccbcdocu.CodMon = 1 THEN EvtDivi.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtDivi.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 2 THEN EvtDivi.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtDivi.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 1 THEN EvtDivi.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtDivi.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       IF Ccbcdocu.CodMon = 2 THEN EvtDivi.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtDivi.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       /**************** FIN DIVISION *******************/

       /**************** INICIA CLIENTE  *******************/
       FIND EvtClie WHERE EvtClie.Codcia = Ccbcdocu.Codcia AND
                          EvtClie.CodDiv = Ccbcdocu.Coddiv AND
                          EvtClie.Codcli = Ccbcdocu.Codcli AND
                          EvtClie.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99")) 
                          NO-ERROR.
   
       IF NOT AVAILABLE EvtClie THEN DO:
        CREATE EvtClie.
        ASSIGN
        EvtClie.Codcia = Ccbcdocu.Codcia 
        EvtClie.CodDiv = Ccbcdocu.Coddiv 
        EvtClie.CodAno = YEAR(Ccbcdocu.FchDoc) 
        EvtClie.CodMes = MONTH(Ccbcdocu.FchDoc)
        EvtClie.Codcli = Ccbcdocu.Codcli
        EvtClie.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))  .
       END.                   
       IF Ccbcdocu.CodMon = 1 THEN EvtClie.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtClie.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 2 THEN EvtClie.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtClie.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 1 THEN EvtClie.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtClie.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       IF Ccbcdocu.CodMon = 2 THEN EvtClie.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtClie.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       /**************** FIN CLIENTE  *******************/
 
       /*********INICIA FORMA DE PAGO************/
        FIND EvtFpgo WHERE EvtFpgo.Codcia = Ccbcdocu.Codcia AND
                           EvtFpgo.CodDiv = Ccbcdocu.Coddiv AND
                           EvtFpgo.FmaPgo = Ccbcdocu.FmaPgo AND
                           EvtFpgo.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))                           
                           NO-ERROR.
   
       IF NOT AVAILABLE EvtFpgo THEN DO:
        CREATE EvtFpgo.
        ASSIGN
        EvtFpgo.Codcia = Ccbcdocu.Codcia 
        EvtFpgo.CodDiv = Ccbcdocu.Coddiv 
        EvtFpgo.CodAno = YEAR(Ccbcdocu.FchDoc) 
        EvtFpgo.CodMes = MONTH(Ccbcdocu.FchDoc)
        EvtFpgo.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))
        EvtFpgo.FmaPgo = Ccbcdocu.FmaPgo.
       END.                    
       IF Ccbcdocu.CodMon = 1 THEN EvtFpgo.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 2 THEN EvtFpgo.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 1 THEN EvtFpgo.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       IF Ccbcdocu.CodMon = 2 THEN EvtFpgo.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       /*********FIN FORMA DE PAGO************/
 
 
 
 



      FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
          
          FIND Almmmatg WHERE Almmmatg.Codcia = CcbdDocu.Codcia AND
                              Almmmatg.CodMat = CcbdDocu.CodMat NO-LOCK NO-ERROR.

          IF NOT AVAILABLE Almmmatg THEN NEXT.

          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = Ccbddocu.UndVta
                              NO-LOCK NO-ERROR.
  
          F-FACTOR  = 1. 
      
          IF AVAILABLE Almtconv THEN DO:
             F-FACTOR = Almtconv.Equival.
             IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
          END.
          
          

         /*********INICIA ARTICULOS************/          
          FIND EvtArti WHERE EvtArti.Codcia = CcbdDocu.Codcia AND
                             EvtArti.CodDiv = CcbdDocu.Coddiv AND
                             EvtArti.CodMat = CcbdDocu.CodMat AND
                             EvtArti.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))
                             NO-ERROR.     

          IF NOT AVAILABLE EvtArti THEN DO:
           CREATE EvtArti.
           ASSIGN
           EvtArti.Codcia = Ccbddocu.Codcia 
           EvtArti.CodDiv = Ccbddocu.Coddiv 
           EvtArti.CodAno = YEAR(Ccbddocu.FchDoc) 
           EvtArti.CodMes = MONTH(Ccbddocu.FchDoc)
           EvtArti.Nrofch = INTEGER(STRING(YEAR(Ccbddocu.FchDoc),"9999") + STRING(MONTH(Ccbddocu.FchDoc),"99")) 
           EvtArti.CodMat = Ccbddocu.CodMat.            
          END.                    
          IF Ccbcdocu.CodMon = 1 THEN EvtArti.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtArti.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
          IF Ccbcdocu.CodMon = 2 THEN EvtArti.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtArti.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
          IF Ccbcdocu.CodMon = 1 THEN EvtArti.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtArti.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
          IF Ccbcdocu.CodMon = 2 THEN EvtArti.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtArti.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
          EvtArti.CanxDia[DAY(CcbdDocu.FchDoc)] = EvtArti.CanxDia[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR ).
         /*********FIN ARTICULOS************/
          
         /*********ARTICULOS POR VENDEDOR*************/
         FIND EvtVend WHERE EvtVend.Codcia = CcbdDocu.Codcia AND
                            EvtVend.CodDiv = CcbdDocu.Coddiv AND
                            EvtVend.CodVen = CcbcDocu.CodVen AND
                            EvtVend.CodMat = CcbdDocu.CodMat AND 
                            EvtVend.Nrofch = INTEGER(STRING(YEAR(Ccbddocu.FchDoc),"9999") + STRING(MONTH(Ccbddocu.FchDoc),"99")) 
                            NO-ERROR.
         IF NOT AVAILABLE EvtVend THEN DO:
            CREATE EvtVend.
            ASSIGN
            EvtVend.Codcia = Ccbddocu.Codcia 
            EvtVend.CodDiv = Ccbddocu.Coddiv 
            EvtVend.CodAno = YEAR(Ccbddocu.FchDoc) 
            EvtVend.CodMes = MONTH(Ccbddocu.FchDoc)
            EvtVend.Nrofch = INTEGER(STRING(YEAR(Ccbddocu.FchDoc),"9999") + STRING(MONTH(Ccbddocu.FchDoc),"99")) 
            EvtVend.CodVen = Ccbcdocu.CodVen             
            EvtVend.CodMat = Ccbddocu.CodMat.            
         END.                    
         IF Ccbcdocu.CodMon = 1 THEN EvtVend.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtVend.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
         IF Ccbcdocu.CodMon = 2 THEN EvtVend.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtVend.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
         IF Ccbcdocu.CodMon = 1 THEN EvtVend.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtVend.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
         IF Ccbcdocu.CodMon = 2 THEN EvtVend.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtVend.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
         EvtVend.CanxDia[DAY(CcbdDocu.FchDoc)] = EvtVend.CanxDia[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR ).
         /*************************************************/
        

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


