&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



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
DEFINE NEW SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-Codigo BUTTON-1 BUTTON-2 BUTTON-IMP ~
CB-TpoBie 
&Scoped-Define DISPLAYED-OBJECTS F-Codigo CB-TpoBie 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-matpro-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-option AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-matpro AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-matpro-1 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\activar":U
     LABEL "Activar Lista" 
     SIZE 10.86 BY 1.54.

DEFINE BUTTON BUTTON-2 
     LABEL "Exportar Excel" 
     SIZE 11 BY .92 TOOLTIP "Genera archivo texto".

DEFINE BUTTON BUTTON-IMP 
     LABEL "Importar Excel" 
     SIZE 12 BY .92.

DEFINE VARIABLE CB-TpoBie AS CHARACTER FORMAT "X(256)":U INITIAL "Articulos" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Articulos","Activos","Servicios" 
     DROP-DOWN-LIST
     SIZE 14.57 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE F-Codigo AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Codigo AT ROW 16.35 COL 98 COLON-ALIGNED
     BUTTON-1 AT ROW 16.46 COL 1
     BUTTON-2 AT ROW 16.54 COL 58.72
     BUTTON-IMP AT ROW 16.54 COL 70 WIDGET-ID 4
     CB-TpoBie AT ROW 17.42 COL 93 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.57 BY 17.54
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "NEW SHARED" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Lista Precios x Proveedor"
         COLUMN             = 8.43
         ROW                = 9.42
         HEIGHT             = 17.54
         WIDTH              = 112.57
         MAX-HEIGHT         = 18.04
         MAX-WIDTH          = 117.86
         VIRTUAL-HEIGHT     = 18.04
         VIRTUAL-WIDTH      = 117.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Lista Precios x Proveedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Lista Precios x Proveedor */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Activar Lista */
DO:
    MESSAGE 'Debe trabajar en OpenOrange' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.

  DEFINE VAR RPTA AS CHAR NO-UNDO.
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Compra,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

  MESSAGE "ESTA SEGURO DE ACTIVAR LA LISTA" 
           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
           UPDATE choice AS LOGICAL.
    CASE choice:
      WHEN TRUE THEN /* Yes */
         DO:
            /*RUN Activar-lista IN h_v-matpro.*/
            RUN Activar-lista IN h_b-matpro-1.
            RUN dispatch IN h_v-matpro-1 ('display-fields':U).
         END.
      WHEN FALSE THEN /* No */
       DO:
          RETURN.
       END.
     
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Exportar Excel */
DO:
  /*RUN Genera-Texto IN h_b-matpro.*/
  RUN Excel IN h_b-matpro-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-IMP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-IMP W-Win
ON CHOOSE OF BUTTON-IMP IN FRAME F-Main /* Importar Excel */
DO:
  RUN Importar-Excel IN h_v-matpro-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-TpoBie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-TpoBie W-Win
ON VALUE-CHANGED OF CB-TpoBie IN FRAME F-Main /* Tipo */
DO:
  ASSIGN CB-TpoBie.
  RUN Tipo-Bien IN h_b-matpro-1 (LOOKUP(CB-TpoBie,CB-TpoBie:LIST-ITEMS)).
  RUN dispatch IN h_b-matpro-1 ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Codigo W-Win
ON LEAVE OF F-Codigo IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE <>"" THEN DO:
  /*SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").*/
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  END.
  RUN Busca_Codigo IN h_b-matpro-1 (SELF:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
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

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/v-matpro-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-matpro-1 ).
       RUN set-position IN h_v-matpro-1 ( 1.27 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.77 , 111.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.38 , 14.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv02.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv02 ).
       RUN set-position IN h_p-updv02 ( 5.04 , 17.14 ) NO-ERROR.
       RUN set-size IN h_p-updv02 ( 1.42 , 63.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-matpro-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-matpro-1 ).
       RUN set-position IN h_b-matpro-1 ( 6.58 , 1.72 ) NO-ERROR.
       RUN set-size IN h_b-matpro-1 ( 9.77 , 110.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-option.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Style = Combo-Box,
                     Drawn-in-UIB = yes,
                     Case-Attribute = SortBy-Case,
                     Case-Changed-Event = Open-Query,
                     Dispatch-Open-Query = yes,
                     Edge-Pixels = 2,
                     Label = ':U + 'Ordenado por' + ',
                     Link-Name = SortBy-Target,
                     Margin-Pixels = 8,
                     Options-Attribute = SortBy-Options,
                     Font = 4':U ,
             OUTPUT h_p-option ).
       RUN set-position IN h_p-option ( 16.42 , 43.29 ) NO-ERROR.
       RUN set-size IN h_p-option ( 1.85 , 14.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 16.50 , 12.29 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.50 , 30.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/q-matpro.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-matpro ).
       RUN set-position IN h_q-matpro ( 5.19 , 82.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 15.14 ) */

       /* Links to SmartViewer h_v-matpro-1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv02 , 'TableIO':U , h_v-matpro-1 ).
       RUN add-link IN adm-broker-hdl ( h_q-matpro , 'Record':U , h_v-matpro-1 ).

       /* Links to SmartBrowser h_b-matpro-1. */
       RUN add-link IN adm-broker-hdl ( h_p-option , 'SortBy':U , h_b-matpro-1 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-matpro-1 ).
       RUN add-link IN adm-broker-hdl ( h_q-matpro , 'Record':U , h_b-matpro-1 ).
       RUN add-link IN adm-broker-hdl ( h_v-matpro-1 , 'State':U , h_b-matpro-1 ).

       /* Links to SmartQuery h_q-matpro. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-matpro ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-matpro-1 ,
             F-Codigo:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-matpro-1 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv02 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-matpro-1 ,
             h_p-updv02 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-option ,
             F-Codigo:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-matpro ,
             CB-TpoBie:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY F-Codigo CB-TpoBie 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-Codigo BUTTON-1 BUTTON-2 BUTTON-IMP CB-TpoBie 
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
  
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN lh_Handle = THIS-PROCEDURE.
  ASSIGN lh_Handle = THIS-PROCEDURE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER L-Handle AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    CASE L-Handle:
        WHEN "Hide"   THEN DO:
               RUN dispatch IN h_b-matpro-1 ('hide':U).
               BUTTON-IMP:SENSITIVE = NO.
               BUTTON-2:SENSITIVE = NO.
           END.
        WHEN "Show"   THEN DO:
             /* RUN dispatch IN h_b-matpro ('open-query':U). */
             RUN dispatch IN h_b-matpro-1 ('view':U).                   
             BUTTON-IMP:SENSITIVE = YES.
             BUTTON-2:SENSITIVE = YES.
        END.
        WHEN "view"  THEN DO:         
             RUN dispatch IN h_b-matpro-1 ('view':U).
        END.
        WHEN "open"  THEN DO:         
             RUN dispatch IN h_b-matpro-1 ('open-query':U).
        END.

    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
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

