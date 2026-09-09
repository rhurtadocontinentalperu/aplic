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
DEF VAR C-LISTDIV AS CHAR NO-UNDO.

FIND integral.FacCfgGn WHERE integral.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wtipcam = integral.FacCfgGn.Tpocmb[1] .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-1 f-periodo f-mesact ~
SELECT-1 BUTTON-12 BUTTON-13 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-2 FILL-IN-1 COMBO-BOX-1 f-periodo ~
f-mesact SELECT-1 

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

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "A¤o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "A¤o","Mes" 
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 28.43 BY 3.77
     BGCOLOR 11 FONT 6 NO-UNDO.

DEFINE VARIABLE f-mesact AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE VARIABLE f-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.57 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 6.73.

DEFINE VARIABLE SELECT-1 AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 8.57 BY 2.92 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-2 AT ROW 1.46 COL 2.86 NO-LABEL
     FILL-IN-1 AT ROW 6.42 COL 3 NO-LABEL
     COMBO-BOX-1 AT ROW 16.92 COL 1 NO-LABEL
     f-periodo AT ROW 5.42 COL 10.86 COLON-ALIGNED
     f-mesact AT ROW 5.42 COL 25.43 COLON-ALIGNED
     SELECT-1 AT ROW 2.31 COL 31.43 NO-LABEL
     BUTTON-12 AT ROW 1.73 COL 40.72
     BUTTON-13 AT ROW 3.5 COL 40.72
     RECT-1 AT ROW 1.08 COL 1.29
     "   Tiendas" VIEW-AS TEXT
          SIZE 8.29 BY .77 AT ROW 1.46 COL 31.43
          BGCOLOR 7 FGCOLOR 15 
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
         TITLE              = "Actualizacion VENTAS - Puntos Remotos"
         HEIGHT             = 7.08
         WIDTH              = 53.57
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 109.57
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 109.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\caja3":U) THEN
    MESSAGE "Unable to load icon: img\caja3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
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
ON END-ERROR OF W-Win /* Actualizacion VENTAS - Puntos Remotos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Actualizacion VENTAS - Puntos Remotos */
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

  ASSIGN
        f-periodo
        f-mesAct
        SELECT-1.
  MESSAGE " Esta seguro de Actualizar Informaci¢n a GERENCIA " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN DO:
            IF f-periodo = 0 then DO:
               MESSAGE " Ingrese el Periodo a Condolidar " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO f-periodo.
               return NO-APPLY.
            END.   
            IF f-mesAct  = 0 then DO:
               MESSAGE " Ingrese el Mes a Consolidar " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO f-mesAct.
               return NO-APPLY.  
            END.   
            if session:set-wait-state("GENERAL") then.
            RUN actualiza-vta.
            if session:set-wait-state(" ") then.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-vta W-Win 
PROCEDURE actualiza-vta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR T AS INTEGER NO-UNDO INIT 1.

DO T = 1 TO NUM-ENTRIES(SELECT-1):
      S-CODDIV = ENTRY(T,SELECT-1).
      
      /**** Actualiza Informacion VENTAS - PUNO ****/
      FIND FIRST PROPUNO.TmsvDiv0 WHERE PROPUNO.TmsvDiv0.DivCia   = 1         and
                                        PROPUNO.TmsvDiv0.DivCod   = S-CODDIV  and
                                        PROPUNO.TmsvDiv0.DivPerio = F-PERIODO and
                                        PROPUNO.TmsvDiv0.DivMes   = F-MESACT NO-LOCK NO-ERROR.
                                        
           IF AVAILABLE PROPUNO.TmsvDiv0 THEN DO:
              FILL-IN-1 = "Division :" + PROPUNO.TmsvDiv0.DivCod.
              DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
              FIND FIRST integral.TmsvDiv0 WHERE integral.TmsvDiv0.DivCia   = PROPUNO.TmsvDiv0.DivCia   and
                                                integral.TmsvDiv0.DivCod   = PROPUNO.TmsvDiv0.DivCod   and
                                                integral.TmsvDiv0.DivPerio = PROPUNO.TmsvDiv0.DivPerio and
                                                integral.TmsvDiv0.DivMes   = PROPUNO.TmsvDiv0.DivMes NO-ERROR. 
                   IF AVAILABLE integral.TmsvDiv0 THEN DO:
                      ASSIGN
                          integral.TmsvDiv0.DivTodol  = PROPUNO.TmsvDiv0.DivTodol 
                          integral.TmsvDiv0.DivToSol  = PROPUNO.TmsvDiv0.DivToSol 
                          integral.TmsvDiv0.DivUser   = PROPUNO.TmsvDiv0.DivUser 
                          integral.TmsvDiv0.DivVtdol  = PROPUNO.TmsvDiv0.DivVtdol 
                          integral.TmsvDiv0.DivVtsol  = PROPUNO.TmsvDiv0.DivVtsol
                          integral.TmsvDiv0.DivCambi  = PROPUNO.TmsvDiv0.DivCambi.
                   END.
                   ELSE DO:                                         
                      CREATE integral.TmsvDiv0.
                      RAW-TRANSFER PROPUNO.TmsVDiv0 TO integral.TmsVDiv0.            
                   END.             
           END.
               
      /***** Actualizacion de ARTICULOS - PUNO *****/         
      FOR EACH PROPUNO.TmsVart0 WHERE PROPUNO.TmsVart0.CodCia  = 1        and
                                      PROPUNO.TmsVart0.CodDiv  = S-CODDIV and
                                      PROPUNO.TmsVart0.Periodo = F-PERIODO 
                                      BY proPUNO.TmsVart0.CodArt :
          FILL-IN-1 = proPUNO.TmsVart0.CodDiv + " " + proPUNO.TmsVart0.CodArt.
          DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
          FIND FIRST integral.TmsVart0 WHERE integral.TmsVart0.CodCia  = proPUNO.TmsVart0.CodCia  and
                                            integral.TmsVart0.CodDiv  = proPUNO.TmsVart0.CodDiv  and
                                            integral.TmsVart0.Periodo = proPUNO.TmsVart0.Periodo and
                                            integral.TmsVart0.CodArt  = proPUNO.TmsVart0.CodArt NO-ERROR.
                                            
               IF AVAILABLE integral.TmsVart0 THEN DO:                                      
                  ASSIGN 
                       integral.TmsVart0.CanMes[F-MESACT] = propuno.TmsVart0.CanMes[F-MESACT]
                       integral.TmsVart0.CanPeri   = propuno.TmsVart0.CanPeri  
                       integral.TmsVart0.FacMes[F-MESACT] = propuno.TmsVart0.FacMes[F-MESACT]
                       integral.TmsVart0.Factor    = propuno.TmsVart0.Factor   
                       integral.TmsVart0.ImpMes[F-MESACT] = propuno.TmsVart0.ImpMes[F-MESACT]
                       integral.TmsVart0.ImpPeri   = propuno.TmsVart0.ImpPeri.  
               END.
               ELSE DO :
                  CREATE integral.TmsVart0.
                  RAW-TRANSFER PROPUNO.TmsVart0 TO integral.TmsVart0.
               END.
      END.    
      
/****
      /***** Actualizacion de CLIENTES - PUNO *****/
      FOR EACH PROPUNO.TMSVVAR0 NO-LOCK WHERE PROPUNO.TMSVVAR0.CODCIA   = S-CODCIA  AND
                                              PROPUNO.TMSVVAR0.CODDIV   = S-CODDIV  AND
                                              PROPUNO.TMSVVAR0.TIPTABLA = "CLI"     AND 
                                              PROPUNO.TMSVVAR0.PERIODO  = F-PERIODO 
                                                BY PROPUNO.TMSVVAR0.CODDIV
                                                BY PROPUNO.TMSVVAR0.CODVAR :
                                    
          FILL-IN-1 = "Cliente : " + PROPUNO.TMSVVAR0.CODVAR + " " + PROPUNO.TMSVVAR0.CODDIV + " " + PROPUNO.TMSVVAR0.NOMBRE.
          DISPLAY FILL-IN-1 WITH FRAME {&FRAME-NAME}.
          FIND FIRST integral.TmsVvar0 WHERE integral.TmsVvar0.CodCia  = proPUNO.TmsVvar0.CodCia  and
                                            integral.TmsVvar0.CodDiv  = proPUNO.TmsVvar0.CodDiv  and
                                            integral.TmsVvar0.Periodo = proPUNO.TmsVvar0.Periodo and
                                            integral.TmsVvar0.CodArt  = proPUNO.TmsVvar0.CodArt NO-ERROR.
                                            
               IF AVAILABLE integral.TmsVvar0 THEN DO:                                      
                  ASSIGN 
                       integral.TmsVvar0.FacMes[F-MESACT] = 
                       integral.TmsVvar0.Factor           = 
                       integral.TmsVvar0.TotMes[F-MESACT] = 
                       integral.TmsVvar0.TotPeri          =                        
                  

               END.
               ELSE DO :
                  CREATE integral.TmsVart0.
                  RAW-TRANSFER PROPUNO.TmsVart0 TO integral.TmsVart0.
               END.
****/
      
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY EDITOR-2 FILL-IN-1 COMBO-BOX-1 f-periodo f-mesact SELECT-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 COMBO-BOX-1 f-periodo f-mesact SELECT-1 BUTTON-12 BUTTON-13 
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
  editor-2 = "Proceso que Actualiza las Ventas de las Tiendas
  Remotas en la CENTRAL, para poder Actualizar el Avance de Ventas 
  de GERENCIA. ".

  C-LISTDIV = 'TH002,TH006,TH007'.

  DO WITH FRAME {&FRAME-NAME}:       
     SELECT-1:LIST-ITEMS = C-LISTDIV.
     ASSIGN f-periodo = year(today)
            f-mesact  = month(today).
     DISPLAY f-periodo
             f-mesact
             EDITOR-2.  
  END.              

  /* Code placed here will execute AFTER standard behavior.    */
  
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


