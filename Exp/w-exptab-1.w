&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

DEF SHARED VAR s-codcia AS INT.

DEF VAR cl-codcia AS INT NO-UNDO.
FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

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
&Scoped-Define ENABLED-OBJECTS x-Facctmat x-Almmmatg x-Almmmate x-Lgcmatpr ~
x-GnClie x-Varios BUTTON-1 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-Facctmat x-Almmmatg x-Almmmate ~
x-Lgcmatpr x-GnClie x-Varios x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     LABEL "&Salir" 
     SIZE 15 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "&Exportar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE x-Almmmate AS LOGICAL INITIAL yes 
     LABEL "Stocks por almacen" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

DEFINE VARIABLE x-Almmmatg AS LOGICAL INITIAL yes 
     LABEL "Catálogo de Productos" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

DEFINE VARIABLE x-Facctmat AS LOGICAL INITIAL yes 
     LABEL "Productos, Poveedores y Descuentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE x-GnClie AS LOGICAL INITIAL yes 
     LABEL "Maestro de Clientes" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

DEFINE VARIABLE x-Lgcmatpr AS LOGICAL INITIAL yes 
     LABEL "Lista de precios proveedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.

DEFINE VARIABLE x-Varios AS LOGICAL INITIAL yes 
     LABEL "Tablas varias" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Facctmat AT ROW 2.15 COL 18
     x-Almmmatg AT ROW 3.31 COL 18
     x-Almmmate AT ROW 4.46 COL 18
     x-Lgcmatpr AT ROW 5.62 COL 18
     x-GnClie AT ROW 6.77 COL 18
     x-Varios AT ROW 7.92 COL 18
     x-Mensaje AT ROW 9.08 COL 8 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 10.42 COL 6
     Btn_Done AT ROW 10.42 COL 24
     "Seleccione las tablas a exportar" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 1.19 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4
         DEFAULT-BUTTON Btn_Done.


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
         TITLE              = "EXPORTAR TABLAS Y MAESTROS"
         HEIGHT             = 11.46
         WIDTH              = 71.86
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
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* EXPORTAR TABLAS Y MAESTROS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* EXPORTAR TABLAS Y MAESTROS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Exportar */
DO:
  ASSIGN
    x-Almmmate x-Almmmatg x-GnClie x-Varios x-Lgcmatpr x-Facctmat.
  RUN Exportar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
  DISPLAY x-Facctmat x-Almmmatg x-Almmmate x-Lgcmatpr x-GnClie x-Varios 
          x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Facctmat x-Almmmatg x-Almmmate x-Lgcmatpr x-GnClie x-Varios BUTTON-1 
         Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exportar W-Win 
PROCEDURE Exportar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  IF x-Facctmat = YES THEN DO:
    OUTPUT TO c:\exportar\facctmat.d.
    FOR EACH Facctmat NO-LOCK WHERE Facctmat.codcia = s-codcia AND Facctmat.codmat <> '':
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PRODUCTOS vs CATEGORIAS: ' + Facctmat.codmat.
        EXPORT Facctmat.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\facctpro.d.
    FOR EACH Facctpro NO-LOCK WHERE Facctpro.codcia = s-codcia AND Facctpro.codpro <> '':
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROVEEDORES vs CLASIFICACION: ' + Facctpro.codpro.
        EXPORT Facctpro.
    END.
    OUTPUT CLOSE.
  END.
  IF x-Almmmatg = YES THEN DO:
    OUTPUT TO c:\exportar\almmmatg.d.
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat <> '':
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CATALOGO DE PRODUCTOS: ' + Almmmatg.codmat.
        EXPORT Almmmatg.
    END.
    OUTPUT CLOSE.
  END.
  IF x-Almmmate = YES THEN DO:
    OUTPUT TO c:\exportar\almmmate.d.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia 
            AND Almmmate.codmat <> ''
            AND LOOKUP(TRIM(Almmmate.codalm), '11,22,03,04,05,15,19') > 0:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'STOCK DE PRODUCTOS: ' + Almmmate.codalm + ' ' + Almmmate.codmat.
        EXPORT Almmmate.
    END.
    OUTPUT CLOSE.
  END.
  IF x-Lgcmatpr = YES THEN DO:
    OUTPUT TO c:\exportar\lg-cmatp.d.
    FOR EACH Lg-cmatpr NO-LOCK WHERE Lg-cmatpr.codcia = s-codcia AND Lg-cmatpr.flgest = 'A':
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'LISTA PRECIO PROVEEDOR: ' + STRING(Lg-cmatpr.nrolis).
        EXPORT Lg-cmatpr.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\lg-dmatp.d.
    FOR EACH Lg-cmatpr NO-LOCK WHERE Lg-cmatpr.codcia = s-codcia AND Lg-cmatpr.flgest = 'A',
           EACH Lg-dmatpr OF Lg-cmatpr NO-LOCK:
        EXPORT Lg-dmatpr.
    END.
    OUTPUT CLOSE.
  END.
  IF x-Gnclie = YES THEN DO:
    OUTPUT TO c:\exportar\gn-clie.d.
    FOR EACH gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli <> '':
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'MAESTRO DE CLIENTES: ' + gn-clie.codcli.
        EXPORT gn-clie.
    END.
    OUTPUT CLOSE.
  END.
  IF x-Varios = YES THEN DO:
    OUTPUT TO c:\exportar\faccfggn.d.
    FOR EACH faccfggn NO-LOCK WHERE faccfggn.codcia = s-codcia:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CONIGURACION DE VENTAS'.
        EXPORT faccfggn.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\tabdistr.d.
    FOR EACH tabdistr WHERE tabdistr.coddistr <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'DISTRITOS'.
        EXPORT tabdistr.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\tabdepto.d.
    FOR EACH tabdepto WHERE tabdepto.coddep <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'DEPARTAMENTOS'.
        EXPORT tabdepto.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\tabprovi.d.
    FOR EACH tabprovi WHERE tabprovi.codprov <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROVINCIAS'.
        EXPORT tabprovi.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\gn-convt.d.
    FOR EACH gn-convt WHERE gn-ConVt.Codig <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CONDICIONES DE VENTA'.
        EXPORT gn-convt.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\gn-card.d.
    FOR EACH gn-card WHERE gn-card.nrocard <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'TARJETA DE CLIENTE: '+ gn-card.nrocard.
        EXPORT gn-card.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\almacen.d.
    FOR EACH almacen WHERE almacen.codcia = s-codcia AND almacen.codalm <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'ALMACENES'.
        EXPORT almacen.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\almtconv.d.
    FOR EACH almtconv WHERE almtconv.codunid <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'TABLA DE CONVERSIONES'.
        EXPORT almtconv.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\clfclie.d.
    FOR EACH clfclie WHERE ClfClie.Categoria <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CLASIFICACION DE CLIENTES'.
        EXPORT clfclie.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\dsctos.d.
    FOR EACH dsctos WHERE dsctos.clfcli <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'DESCUENTOS'.
        EXPORT dsctos.
    END.
    OUTPUT CLOSE.
    OUTPUT TO c:\exportar\tabgener.d.
    FOR EACH tabgener WHERE tabgener.clave <> '' NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'TABLAS GENERALES'.
        EXPORT tabgener.
    END.
    OUTPUT CLOSE.
  END.
  MESSAGE 'Exportacion termidada' VIEW-AS ALERT-BOX WARNING.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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

