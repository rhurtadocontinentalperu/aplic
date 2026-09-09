&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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

DEFINE NEW SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE NEW SHARED TEMP-TABLE VMOV LIKE cb-cmov.
DEFINE VARIABLE C-Btn AS CHAR INIT "C" NO-UNDO.
DEFINE VARIABLE X-ROWID AS ROWID.
DEFINE VAR j AS INTEGER NO-UNDO.
DEFINE VARIABLE CtaDif AS CHAR NO-UNDO.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE SHARED VARIABLE s-user-id AS CHARACTER.

DEFINE VARIABLE X-NROAST AS INTEGER NO-UNDO.
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE VARIABLE x-DbeSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-HbeSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-SdoSol AS DECIMAL NO-UNDO.

DEFINE VARIABLE x-DbeDol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-HbeDol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-SdoDol AS DECIMAL NO-UNDO.

DEFINE VARIABLE L-MesCie AS LOGICAL INITIAL YES NO-UNDO.
FIND cb-peri WHERE  cb-peri.CodCia  = s-codcia  AND
                    cb-peri.Periodo = s-periodo NO-LOCK.
IF AVAILABLE cb-peri THEN L-MesCie = cb-peri.MesCie[s-NroMes + 1].

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
      NO-LOCK  NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn-Add Btn-Update Bnt-Save ~
Bnt-Cancel Btn-Delete Btn-Impr Btn-Exit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 Btn-Add Btn-Update Btn-Delete Btn-Impr Btn-Exit 
&Scoped-define List-2 Bnt-Save Bnt-Cancel 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cjdocm AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-cjletr AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-docmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-letras AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-canje AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-canje AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cjletr AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Bnt-Cancel 
     LABEL "&Cancelar" 
     SIZE 8 BY .85.

DEFINE BUTTON Bnt-Save 
     LABEL "&Grabar" 
     SIZE 8 BY .85.

DEFINE BUTTON Btn-Add 
     LABEL "&Adicionar" 
     SIZE 8 BY .85.

DEFINE BUTTON Btn-Delete 
     LABEL "&Eliminar" 
     SIZE 8 BY .85.

DEFINE BUTTON Btn-Exit 
     LABEL "&Salir" 
     SIZE 8 BY .85.

DEFINE BUTTON Btn-Impr 
     LABEL "&Imprimir" 
     SIZE 8 BY .85.

DEFINE BUTTON Btn-Update 
     LABEL "&Modificar" 
     SIZE 8 BY .85.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.72 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-Add AT ROW 14.85 COL 26
     Btn-Update AT ROW 14.85 COL 34
     Bnt-Save AT ROW 14.85 COL 42
     Bnt-Cancel AT ROW 14.85 COL 50
     Btn-Delete AT ROW 14.85 COL 58
     Btn-Impr AT ROW 14.85 COL 66
     Btn-Exit AT ROW 14.85 COL 74
     RECT-1 AT ROW 14.58 COL 25.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.29 BY 15.58
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Canje de Letras"
         HEIGHT             = 15.08
         WIDTH              = 82.72
         MAX-HEIGHT         = 17.62
         MAX-WIDTH          = 85.72
         VIRTUAL-HEIGHT     = 17.62
         VIRTUAL-WIDTH      = 85.72
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
/* SETTINGS FOR BUTTON Bnt-Cancel IN FRAME F-Main
   2                                                                    */
/* SETTINGS FOR BUTTON Bnt-Save IN FRAME F-Main
   2                                                                    */
/* SETTINGS FOR BUTTON Btn-Add IN FRAME F-Main
   1                                                                    */
/* SETTINGS FOR BUTTON Btn-Delete IN FRAME F-Main
   1                                                                    */
/* SETTINGS FOR BUTTON Btn-Exit IN FRAME F-Main
   1                                                                    */
/* SETTINGS FOR BUTTON Btn-Impr IN FRAME F-Main
   1                                                                    */
/* SETTINGS FOR BUTTON Btn-Update IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Canje de Letras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Canje de Letras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bnt-Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bnt-Cancel W-Win
ON CHOOSE OF Bnt-Cancel IN FRAME F-Main /* Cancelar */
DO:
  RUN select-page(1).
  C-Btn = "C".
  RUN Control-Bnt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bnt-Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bnt-Save W-Win
ON CHOOSE OF Bnt-Save IN FRAME F-Main /* Grabar */
DO:
  RUN VALIDA.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
  RUN select-page(1).
  RUN dispatch IN h_v-cjletr ('assign-statement':U).
  RUN Graba-Movto.
  C-Btn = "S".
  RUN Control-Bnt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Add W-Win
ON CHOOSE OF Btn-Add IN FRAME F-Main /* Adicionar */
DO:
  IF L-MESCIE THEN DO:
       MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
  END.
  RUN select-page(2).
  C-Btn = "A".
  RUN Control-Bnt.
  RUN Inicia-Temp.
  RUN dispatch IN h_b-cjletr ('open-query':U).
  RUN dispatch IN h_b-cjdocm ('open-query':U).
  RUN dispatch IN h_v-cjletr ('add-record':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Delete W-Win
ON CHOOSE OF Btn-Delete IN FRAME F-Main /* Eliminar */
DO:
  IF L-MESCIE THEN DO:
       MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
  END.
  C-Btn = "D".
  MESSAGE "Esta Seguro" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Pregunta" 
           UPDATE Rpta AS LOGICAL.
  IF Rpta THEN DO:
     RUN dispatch IN h_v-canje ('delete-record':U).
     RUN dispatch IN h_b-docmto ('open-query':U).
     RUN dispatch IN h_b-letras ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Exit W-Win
ON CHOOSE OF Btn-Exit IN FRAME F-Main /* Salir */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Impr W-Win
ON CHOOSE OF Btn-Impr IN FRAME F-Main /* Imprimir */
DO:
  RUN dispatch IN h_v-canje ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Update W-Win
ON CHOOSE OF Btn-Update IN FRAME F-Main /* Modificar */
DO:
  IF L-MESCIE THEN DO:
       MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
  END.
  RUN Inicia-Temp.
  RUN Modifica IN h_v-canje.
  RUN select-page(2).
  C-Btn = "U".
  RUN Control-Bnt.
  RUN dispatch IN h_b-cjletr ('open-query':U).
  RUN dispatch IN h_b-cjdocm ('open-query':U).
  RUN dispatch IN h_v-cjletr ('display-fields':U).
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/v-canje.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-canje ).
       RUN set-position IN h_v-canje ( 1.04 , 5.72 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 71.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/b-letras.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-letras ).
       RUN set-position IN h_b-letras ( 4.81 , 3.72 ) NO-ERROR.
       /* Size in UIB:  ( 4.65 , 76.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/b-docmto.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-docmto ).
       RUN set-position IN h_b-docmto ( 9.58 , 3.86 ) NO-ERROR.
       /* Size in UIB:  ( 4.62 , 76.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 14.23 , 10.43 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.38 , 14.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/q-canje.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-canje ).
       RUN set-position IN h_q-canje ( 14.27 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.04 , 9.14 ) */

       /* Links to SmartViewer h_v-canje. */
       RUN add-link IN adm-broker-hdl ( h_q-canje , 'Record':U , h_v-canje ).

       /* Links to SmartBrowser h_b-letras. */
       RUN add-link IN adm-broker-hdl ( h_q-canje , 'Record':U , h_b-letras ).

       /* Links to SmartBrowser h_b-docmto. */
       RUN add-link IN adm-broker-hdl ( h_q-canje , 'Record':U , h_b-docmto ).

       /* Links to SmartQuery h_q-canje. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-canje ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/b-cjletr.w':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjletr ).
       RUN set-position IN h_b-cjletr ( 4.23 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.50 , 72.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/v-cjletr.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cjletr ).
       RUN set-position IN h_v-cjletr ( 1.00 , 5.72 ) NO-ERROR.
       /* Size in UIB:  ( 3.15 , 71.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/cbd/b-cjdocm.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjdocm ).
       RUN set-position IN h_b-cjdocm ( 8.92 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.65 , 72.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 4.23 , 73.57 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.46 , 9.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 8.85 , 73.57 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 4.54 , 8.86 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cjletr. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-cjletr ).

       /* Links to SmartBrowser h_b-cjdocm. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_b-cjdocm ).
       RUN add-link IN adm-broker-hdl ( h_v-cjletr , 'State':U , h_b-cjdocm ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Bnt W-Win 
PROCEDURE Control-Bnt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   IF C-Btn = "S" OR C-Btn = "C" THEN DO:
      ENABLE  {&List-1}.
      DISABLE {&List-2}.
      END.
   ELSE DO:
      ENABLE  {&List-2}.
      DISABLE {&List-1}.
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
  ENABLE RECT-1 Btn-Add Btn-Update Bnt-Save Bnt-Cancel Btn-Delete Btn-Impr 
         Btn-Exit 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Automatica W-Win 
PROCEDURE Genera-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR x-GenAut AS INTEGER.
    DEFINE VAR i        AS INTEGER INIT 1.
    DEFINE BUFFER DETALLE FOR cb-dmov.
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut  = 0.
       
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):

        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> ""
            THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN cb-dmov.CtaAut = ""
           cb-dmov.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN 
                cb-dmov.CtaAut = cb-dmov.CodAux.
             ELSE
                cb-dmov.CtaAut = cb-ctas.An1Cta.
             IF cb-dmov.CtrCta = ""  THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
                        IF cb-dmov.CtrCta = ""
                        THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
                    END.
        WHEN 3 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
                    END.
    END CASE.

/* Generando las cuentas autom ticas */
IF cb-dmov.CtrCta <> "" THEN DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
                        AND integral.cb-ctas.CodCta = cb-dmov.CodCta
                        NO-LOCK NO-ERROR.
        IF cb-dmov.CtaAut <> ""
        THEN DO:
            CREATE DETALLE.
            j = j + 1.
            ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
                   DETALLE.Periodo  = cb-dmov.Periodo
                   DETALLE.NroMes   = cb-dmov.NroMes
                   DETALLE.CodOpe   = cb-dmov.CodOpe
                   DETALLE.NroAst   = cb-dmov.NroAst
                   DETALLE.TpoItm   = "A"
                   DETALLE.Relacion = RECID(cb-dmov)
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.NroItm   = j
                   DETALLE.Codcta   = cb-dmov.CtaAut
                   DETALLE.CodDiv   = cb-dmov.CodDiv
                   DETALLE.ClfAux   = cb-dmov.ClfAux
                   DETALLE.CodAux   = cb-dmov.CodCta
                   DETALLE.NroRuc   = cb-dmov.NroRuc
                   DETALLE.CodDoc   = cb-dmov.CodDoc
                   DETALLE.NroDoc   = cb-dmov.NroDoc
                   DETALLE.GloDoc   = cb-dmov.GloDoc
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.TpoMov   = cb-dmov.TpoMov
                   DETALLE.NroRef   = cb-dmov.NroRef
                   DETALLE.FchDoc   = cb-dmov.FchDoc
                   DETALLE.FchVto   = cb-dmov.FchVto
                   DETALLE.ImpMn1   = cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = cb-dmov.ImpMn3
                   DETALLE.Tm       = cb-dmov.Tm
                   DETALLE.CCO      = cb-dmov.CCO.
            IF DETALLE.TpoMov THEN 
               ASSIGN x-HbeSol = x-HbeSol + DETALLE.ImpMn1
                      x-HbeDol = x-HbeDol + DETALLE.ImpMn2.
            ELSE 
               ASSIGN x-DbeSol = x-DbeSol + DETALLE.ImpMn1        
                      x-DbeDol = x-DbeDol + DETALLE.ImpMn2.
        END.
         
    CREATE DETALLE.
    j = j + 1.
    ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
           DETALLE.Periodo  = cb-dmov.Periodo
           DETALLE.NroMes   = cb-dmov.NroMes
           DETALLE.CodOpe   = cb-dmov.CodOpe
           DETALLE.NroAst   = cb-dmov.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.Relacion = RECID(cb-dmov)
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.NroItm   = j
           DETALLE.Codcta   = cb-dmov.Ctrcta
           DETALLE.CodDiv   = cb-dmov.CodDiv
           DETALLE.ClfAux   = cb-dmov.ClfAux
           DETALLE.CodAux   = cb-dmov.CodCta
           DETALLE.NroRuc   = cb-dmov.NroRuc
           DETALLE.CodDoc   = cb-dmov.CodDoc
           DETALLE.NroDoc   = cb-dmov.NroDoc
           DETALLE.GloDoc   = cb-dmov.GloDoc
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.TpoMov   = NOT cb-dmov.TpoMov
           DETALLE.ImpMn1   = cb-dmov.ImpMn1
           DETALLE.ImpMn2   = cb-dmov.ImpMn2
           DETALLE.ImpMn3   = cb-dmov.ImpMn3
           DETALLE.NroRef   = cb-dmov.NroRef
           DETALLE.FchDoc   = cb-dmov.FchDoc
           DETALLE.FchVto   = cb-dmov.FchVto
           DETALLE.Tm       = cb-dmov.Tm
           DETALLE.CCO      = cb-dmov.CCO.
    IF DETALLE.TpoMov THEN 
       ASSIGN x-HbeSol = x-HbeSol + DETALLE.ImpMn1
              x-HbeDol = x-HbeDol + DETALLE.ImpMn2.
    ELSE 
       ASSIGN x-DbeSol = x-DbeSol + DETALLE.ImpMn1        
              x-DbeDol = x-DbeDol + DETALLE.ImpMn2.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cabecera W-Win 
PROCEDURE Genera-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF C-Btn = "A" THEN CREATE cb-cmov.
ELSE DO:
    FIND cb-cmov WHERE cb-cmov.Codcia  = VMOV.Codcia AND
         cb-cmov.periodo = VMOV.periodo AND
         cb-cmov.Nromes  = VMOV.Nromes AND
         cb-cmov.Codope  = VMOV.Codope AND
         cb-cmov.Nroast  = VMOV.Nroast NO-ERROR.
END.
IF AVAILABLE cb-cmov THEN DO:
    ASSIGN cb-cmov.Codcia  = S-CODCIA
           cb-cmov.Codmon  = VMOV.Codmon
           cb-cmov.Codope  = "004"
           cb-cmov.Fchast  = VMOV.Fchast
           cb-cmov.FchMod  = VMOV.FchMod
           cb-cmov.Flgest  = ""
           cb-cmov.Nroast  = STRING(X-NROAST,"999999")
           cb-cmov.GloAst  = VMOV.GloAst
           cb-cmov.Nromes  = S-Nromes
           cb-cmov.Periodo = S-PERIODO
           cb-cmov.Tpocmb  = VMOV.Tpocmb
           cb-cmov.Codaux  = VMOV.Codaux
           cb-cmov.Usuario = S-USER-ID
           cb-cmov.CodDiv  = VMOV.CodDiv
           cb-cmov.DBEMN1  = x-DbeSol
           cb-cmov.DBEMN2  = x-DbeDol
           cb-cmov.HBEMN1  = x-HbeSol
           cb-cmov.HBEMN2  = x-HbeDol
           cb-cmov.Notast  = VMOV.NotAst
                  X-ROWID  = ROWID(cb-cmov).
END.
RELEASE  cb-cmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle W-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>  
  Notes:               
------------------------------------------------------------------------------*/
j = 0.
x-DbeSol = 0.
x-HbeSol = 0.
x-DbeDol = 0.
x-HbeDol = 0.
/* ELIMINAMOS MOVIENTO ANTERIOR EN CASO DE MODIFICACION*/
IF C-Btn = "U" THEN DO:
   FOR EACH cb-dmov WHERE cb-dmov.Codcia  = VMOV.Codcia AND
            cb-dmov.periodo = VMOV.periodo AND
            cb-dmov.Nromes  = VMOV.Nromes  AND
            cb-dmov.Codope  = VMOV.Codope  AND
            cb-dmov.Nroast  = VMOV.Nroast:
         /* Des-actulizando saldos acumulados */ 
         RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).
         /* Borrando el detalle del Documento */ 
         DELETE cb-dmov.
   END.
END.

FOR EACH RMOV : 
   j = j + 1.
   CREATE cb-dmov.
   Cb-dmov.CodCia  = S-CodCia. 
   Cb-dmov.NroMes  = S-NroMes. 
   Cb-dmov.Periodo = S-PERIODO.
   Cb-dmov.Codope  = "004".
   Cb-dmov.C-Fcaja = RMOV.c-FCaja.
   Cb-dmov.cco     = RMOV.cco.
   Cb-dmov.Clfaux  = "@PV".
   Cb-dmov.Codaux  = VMOV.Codaux. 
   Cb-dmov.Codcta  = RMOV.CodCta. 
   Cb-dmov.CodDiv  = VMOV.CodDiv. 
   Cb-dmov.Coddoc  = RMOV.CodDoc. 
   Cb-dmov.Codmon  = VMOV.CodMon. 
   Cb-dmov.CtaAut  = RMOV.CtaAut. 
   Cb-dmov.CtrCta  = RMOV.CtrCta. 
   cb-dmov.TpoItm  = "".
   Cb-dmov.Fchdoc  = RMOV.FchDoc. 
   Cb-dmov.Fchvto  = RMOV.FchVto. 
   Cb-dmov.flgact  = YES.
   Cb-dmov.Glodoc  = VMOV.NotAst. 
   Cb-dmov.Tpocmb  = RMOV.Tpocmb.
   IF RMOV.TpoItm NE "N" THEN Cb-dmov.Tpocmb = VMOV.TpoCmb.
   IF VMOV.CodMon = 1 THEN
      IF RMOV.TpoCmb > 0 THEN RMOV.ImpMn2 = ROUND(RMOV.ImpMn1 / RMOV.TpoCmb,2).
      ELSE RMOV.ImpMn2 = 0.
   ELSE RMOV.ImpMn1 = ROUND(RMOV.ImpMn2 * RMOV.TpoCmb,2).
   Cb-dmov.ImpMn1 = RMOV.ImpMn1. 
   Cb-dmov.ImpMn2 = RMOV.ImpMn2. 
   Cb-dmov.ImpMn3 = RMOV.IMpMn3.
   Cb-dmov.Nroast = STRING(X-NROAST,"999999"). 
   Cb-dmov.Nrodoc = RMOV.NroDoc. 
   Cb-dmov.Nroref = RMOV.NroRef. 
   Cb-dmov.Nroruc = RMOV.NroRuc. 
   Cb-dmov.Rel-Ac-Cb = RMOV.Rel-Ac-cb.
   Cb-dmov.Relacion = RMOV.Relacion. 
   Cb-dmov.tm = RMOV.Tm.
   Cb-dmov.TpoMov = RMOV.TpoMov.
   cb-dmov.DisCCo = RMOV.DisCCo.
   cb-dmov.NroItm = j.
   
   IF cb-dmov.TpoMov THEN x-HbeSol = x-HbeSol + cb-dmov.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + cb-dmov.ImpMn1.        

   IF cb-dmov.TpoMov THEN x-HbeDol = x-HbeDol + cb-dmov.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + cb-dmov.ImpMn2.        
   
   RUN cbd/cb-acmd.p(RECID(cb-dmov), YES, YES).   
END.
/* Calculamos Diferencia de Cambio */
IF VMOV.CodMon = 2 AND ABSOLUTE(x-DbeSol - x-HbeSol) > 0 THEN DO:
   RUN Genera-Dif-Cambio.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Dif-Cambio W-Win 
PROCEDURE Genera-Dif-Cambio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FIND cb-cfgg WHERE cb-cfgg.CodCia = 0 AND
        cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN RETURN.

   IF (x-DbeSol - x-HbeSol) < 0 THEN CtaDif = cb-cfgg.codcta[1].  /* PERDIDA */
   ELSE CtaDif = cb-cfgg.codcta[2].                               /* GANANCIA */

   j = j + 1.
   CREATE cb-dmov.
   Cb-dmov.CodCia  = S-CodCia. 
   Cb-dmov.NroMes  = S-NroMes. 
   Cb-dmov.Periodo = S-PERIODO.
   Cb-dmov.Codope  = "004".
   Cb-dmov.Clfaux  = "@PV".
   Cb-dmov.Codaux  = VMOV.Codaux.
   Cb-dmov.Codcta  = CtaDif.
   Cb-dmov.CodDiv  = VMOV.CodDiv.
   Cb-dmov.Codmon  = 1.
   cb-dmov.TpoItm  = "D".
   Cb-dmov.flgact  = YES.
   IF CtaDif = cb-cfgg.codcta[2] THEN Cb-dmov.Glodoc  = "Ganancia por Diferencia de Cambio". 
   ELSE Cb-dmov.Glodoc  = "Perdida por Diferencia de Cambio". 
   Cb-dmov.Tpocmb  = 0.
   Cb-dmov.ImpMn1  = ABSOLUTE(x-DbeSol - x-HbeSol). 
   Cb-dmov.ImpMn2  = 0. 
   Cb-dmov.ImpMn3  = 0.
   Cb-dmov.Nroast  = STRING(X-NROAST,"999999"). 
   Cb-dmov.TpoMov  = (x-DbeSol > x-HbeSol).
   cb-dmov.NroItm  = j.

   IF cb-dmov.TpoMov THEN x-HbeSol = x-HbeSol + cb-dmov.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + cb-dmov.ImpMn1.        
   IF cb-dmov.TpoMov THEN x-HbeDol = x-HbeDol + cb-dmov.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + cb-dmov.ImpMn2.     
      
   RUN cbd/cb-acmd.p(RECID(cb-dmov), YES, YES).   
   
   FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
   NO-LOCK NO-ERROR.
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = Cb-dmov.CodCta NO-LOCK NO-ERROR.
   
   RUN Genera-Automatica.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Movto W-Win 
PROCEDURE Graba-Movto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND LAST VMOV NO-LOCK NO-ERROR.
  IF C-Btn = "A" THEN
     RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-NroMes, "004", OUTPUT x-nroast). 
  ELSE X-NroAst = INTEGER(VMOV.NroAst).
  
  RUN Genera-Detalle.
  RUN Genera-Cabecera.
  RUN Ubica-Temporal IN h_q-canje(X-ROWID).
  RUN dispatch IN h_b-docmto ('open-query':U).
  RUN dispatch IN h_b-letras ('open-query':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicia-Temp W-Win 
PROCEDURE Inicia-Temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH RMOV:
    DELETE RMOV.
END.
FOR EACH VMOV:
    DELETE VMOV.
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
  
  RUN Control-Bnt.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE TOT-DEB AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE TOT-HAB AS DECIMAL EXTENT 2 NO-UNDO.
FIND LAST VMOV NO-LOCK NO-ERROR.
FOR EACH RMOV:
    IF RMOV.TpoMov THEN
       ASSIGN TOT-HAB[1] = TOT-HAB[1] + RMOV.ImpMn1
              TOT-HAB[2] = TOT-HAB[2] + RMOV.ImpMn2.
    ELSE 
       ASSIGN TOT-DEB[1] = TOT-DEB[1] + RMOV.ImpMn1
              TOT-DEB[2] = TOT-DEB[2] + RMOV.ImpMn2.
END.
IF (VMOV.CODMON = 2 AND TOT-DEB[2] NE TOT-HAB[2]) OR
   (VMOV.CODMON = 1 AND TOT-DEB[1] NE TOT-HAB[1])  THEN DO:
   MESSAGE "Movimiento des-balanceado" SKIP
           "S/. " (TOT-DEB[1] - TOT-HAB[1]) SKIP
           "US$ " (TOT-DEB[2] - TOT-HAB[2]) VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


