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

DEF SHARED VAR s-codcia AS INT.

DEF VAR cl-codcia AS INT NO-UNDO.
FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

DEF TEMP-TABLE T-Facctmat LIKE Facctmat.
DEF TEMP-TABLE T-Facctpro LIKE Facctpro.
DEF TEMP-TABLE T-Almmmatg LIKE Almmmatg.
DEF TEMP-TABLE T-Almmmate LIKE Almmmate.
DEF TEMP-TABLE T-Gn-Clie LIKE Gn-Clie.
DEF TEMP-TABLE T-Faccfggn LIKE Faccfggn.
DEF TEMP-TABLE T-Tabdistr LIKE Tabdistr.
DEF TEMP-TABLE T-Tabdepto LIKE Tabdepto.
DEF TEMP-TABLE T-Tabprovi LIKE Tabprovi.
DEF TEMP-TABLE T-Gn-Convt LIKE Gn-Convt.
DEF TEMP-TABLE T-Gn-Card LIKE Gn-Card.
DEF TEMP-TABLE T-Almacen LIKE Almacen.
DEF TEMP-TABLE T-Almtconv LIKE Almtconv.
DEF TEMP-TABLE T-Clfclie LIKE Clfclie.
DEF TEMP-TABLE T-Dsctos LIKE Dsctos.
DEF TEMP-TABLE T-Tabgener LIKE Tabgener.
DEF TEMP-TABLE T-Facdocum LIKE Facdocum.
DEF TEMP-TABLE T-Lg-cmatpr LIKE Lg-cmatpr.
DEF TEMP-TABLE T-Lg-dmatpr LIKE Lg-dmatpr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-Facctmat x-Almmmatg x-Almmmate ~
x-Lgcmatpr x-GnClie x-Varios Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-Mensaje x-Facctmat x-Almmmatg x-Almmmate ~
x-Lgcmatpr x-GnClie x-Varios 

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
     LABEL "&Importar" 
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
     x-Mensaje AT ROW 9.08 COL 8 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 10.42 COL 6
     x-Facctmat AT ROW 2.15 COL 18
     x-Almmmatg AT ROW 3.31 COL 18
     x-Almmmate AT ROW 4.46 COL 18
     x-Lgcmatpr AT ROW 5.62 COL 18
     x-GnClie AT ROW 6.77 COL 18
     x-Varios AT ROW 7.92 COL 18
     Btn_Done AT ROW 10.42 COL 24
     "Seleccione las tablas a importar" VIEW-AS TEXT
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
         TITLE              = "IMPORTAR TABLAS Y MAESTROS"
         HEIGHT             = 11.54
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
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
ON END-ERROR OF W-Win /* IMPORTAR TABLAS Y MAESTROS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR TABLAS Y MAESTROS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Importar */
DO:
  ASSIGN
    x-Almmmate x-Almmmatg x-GnClie x-Varios x-Lgcmatpr x-Facctmat.
  RUN Importar.
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
  DISPLAY x-Mensaje x-Facctmat x-Almmmatg x-Almmmate x-Lgcmatpr x-GnClie 
          x-Varios 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-Facctmat x-Almmmatg x-Almmmate x-Lgcmatpr x-GnClie x-Varios 
         Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar W-Win 
PROCEDURE Importar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    IF x-Facctmat= YES THEN DO:
        FOR EACH Facctmat:
            DELETE Facctmat.
        END.
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\facctmat.d"
                          &tabla-temporal = "t-facctmat"
                          &tabla-destino = "facctmat"
                          &control = "t-facctmat.codmat <> ''"
                          &condicion = "facctmat.codcia = t-facctmat.codcia AND facctmat.codmat = t-facctmat.codmat"
                          &mensaje = "'PRODUCTOS vs CATEGORIAS: ' + t-facctmat.codmat"}
        FOR EACH Facctpro:
            DELETE Facctpro.
        END.
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\facctpro.d"
                          &tabla-temporal = "t-facctpro"
                          &tabla-destino = "facctpro"
                          &control = "t-facctpro.codpro <> ''"
                          &condicion = "facctpro.codcia = t-facctpro.codcia AND facctpro.codpro = t-facctpro.codpro AND facctpro.categoria = t-facctpro.categoria"
                          &mensaje = "'PROVEEDORES vs CLASIFICACION: ' + t-facctpro.codpro"}
    END.
    IF x-Almmmatg = YES THEN DO:
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\almmmatg.d"
                          &tabla-temporal = "t-almmmatg"
                          &tabla-destino = "almmmatg"
                          &control = "t-almmmatg.codmat <> ''"
                          &condicion = "almmmatg.codcia = t-almmmatg.codcia AND almmmatg.codmat = t-almmmatg.codmat"
                          &mensaje = "'CATALOGO DE PRODUCTOS: ' + t-almmmatg.codmat"}
    END.
    IF x-Almmmate = YES THEN DO:
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\almmmate.d"
                          &tabla-temporal = "t-almmmate"
                          &tabla-destino = "almmmate"
                          &control = "t-almmmate.codmat <> ''"
                          &condicion = "almmmate.codcia = t-almmmate.codcia AND almmmate.codmat = t-almmmate.codmat AND almmmate.codalm = t-almmmate.codalm"
                          &mensaje = "'STOCK DE PRODUCTOS: ' + t-almmmate.codalm + ' ' + t-almmmate.codmat"}
    END.
    IF x-Lgcmatpr = YES THEN DO:
        FOR EACH Lg-cmatpr:
            DELETE Lg-cmatpr.
        END.
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\lg-cmatp.d"
                          &tabla-temporal = "t-lg-cmatpr"
                          &tabla-destino = "lg-cmatpr"
                          &control = "t-lg-cmatpr.flgest = 'A'"
                          &condicion = "lg-cmatpr.codcia = t-lg-cmatpr.codcia AND lg-cmatpr.nrolis = t-lg-cmatpr.nrolis"
                          &mensaje = "'PRECIOS POR PROVEEDOR: ' + STRING(t-lg-cmatpr.nrolis)"}
        FOR EACH Lg-dmatpr:
            DELETE Lg-dmatpr.
        END.
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\lg-dmatp.d"
                          &tabla-temporal = "t-lg-dmatpr"
                          &tabla-destino = "lg-dmatpr"
                          &control = "t-lg-dmatpr.codmat <> ''"
                          &condicion = "lg-dmatpr.codcia = t-lg-dmatpr.codcia AND lg-dmatpr.nrolis = t-lg-dmatpr.nrolis AND lg-dmatpr.codmat = t-lg-dmatpr.codmat"
                          &mensaje = "'PRECIOS POR PROVEEDOR: ' + t-lg-dmatpr.codmat"}
    END.
    IF x-GnClie = YES THEN DO:
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\gn-clie.d"
                          &tabla-temporal = "t-gn-clie"
                          &tabla-destino = "gn-clie"
                          &control = "t-gn-clie.codcli <> ''"
                          &condicion = "gn-clie.codcia = t-gn-clie.codcia AND gn-clie.codcli = t-gn-clie.codcli"
                          &mensaje = "'MAESTRO DE CLIENTES: ' + t-gn-clie.codcli"}
    END.
    IF x-Varios = YES THEN DO:
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\faccfggn.d"
                          &tabla-temporal = "t-faccfggn"
                          &tabla-destino = "faccfggn"
                          &control = "TRUE"
                          &condicion = "faccfggn.codcia = t-faccfggn.codcia"
                          &mensaje = "'CONFIGURACION DE VENTAS'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\tabdistr.d"
                          &tabla-temporal = "t-tabdistr"
                          &tabla-destino = "tabdistr"
                          &control = "t-tabdistr.coddistr <> ''"
                          &condicion = "TabDistr.CodDepto = T-TabDistr.CodDepto AND TabDistr.CodProvi = T-TabDistr.CodProvi AND TabDistr.CodDistr = T-TabDistr.CodDistr"
                          &mensaje = "'DISTRITOS'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\tabprovi.d"
                          &tabla-temporal = "t-tabprovi"
                          &tabla-destino = "tabprovi"
                          &control = "t-tabprovi.codprovi <> ''"
                          &condicion = "TabProvi.CodDepto = T-TabProvi.CodDepto AND TabProvi.CodProvi = T-TabProvi.CodProvi"
                          &mensaje = "'PROVINCIAS'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\tabdepto.d"
                          &tabla-temporal = "t-tabdepto"
                          &tabla-destino = "tabdepto"
                          &control = "t-tabdepto.coddepto <> ''"
                          &condicion = "TabDepto.CodDepto = T-TabDepto.CodDepto"
                          &mensaje = "'DEPARTAMENTOS'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\gn-convt.d"
                          &tabla-temporal = "t-gn-convt"
                          &tabla-destino = "gn-convt"
                          &control = "t-gn-convt.codig <> ''"
                          &condicion = "gn-convt.codig = t-gn-convt.codig"
                          &mensaje = "'CONDICIONES DE VENTA'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\gn-card.d"
                          &tabla-temporal = "t-gn-card"
                          &tabla-destino = "gn-card"
                          &control = "t-gn-card.nrocard <> ''"
                          &condicion = "gn-card.nrocard = t-gn-card.nrocard"
                          &mensaje = "'TARJETA DE CLIENTE: ' + t-gn-card.nrocard"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\almacen.d"
                          &tabla-temporal = "t-almacen"
                          &tabla-destino = "almacen"
                          &control = "t-almacen.codalm <> ''"
                          &condicion = "almacen.codcia = t-almacen.codcia AND almacen.codalm = t-almacen.codalm"
                          &mensaje = "'ALMACENES'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\almtconv.d"
                          &tabla-temporal = "t-almtconv"
                          &tabla-destino = "almtconv"
                          &control = "t-almtconv.codunid <> ''"
                          &condicion = "almtconv.codunid = t-almtconv.codunid AND almtconv.codalter = t-almtconv.codalter"
                          &mensaje = "'TABLA DE CONVERSIONES'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\clfclie.d"
                          &tabla-temporal = "t-clfclie"
                          &tabla-destino = "clfclie"
                          &control = "t-clfclie.categoria <> ''"
                          &condicion = "clfclie.categoria = t-clfclie.categoria"
                          &mensaje = "'CLASIFICACION DE CLIENTES'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\dsctos.d"
                          &tabla-temporal = "t-dsctos"
                          &tabla-destino = "dsctos"
                          &control = "t-dsctos.clfcli <> ''"
                          &condicion = "dsctos.clfcli = t-dsctos.clfcli AND dsctos.cndvta = t-dsctos.cndvta AND dsctos.cierre1 = t-dsctos.cierre1"
                          &mensaje = "'DESCUENTOS'"}
        {exp/w-imptab-1.i &tabla-texto = "c:\importar\tabgener.d"
                          &tabla-temporal = "t-tabgener"
                          &tabla-destino = "tabgener"
                          &control = "t-tabgener.clave <> ''"
                          &condicion = "tabgener.codcia = t-tabgener.codcia AND tabgener.clave = t-tabgener.clave AND tabgener.codigo = t-tabgener.codigo"
                          &mensaje = "'TABLAS GENERALES'"}
    END.
  END.

  MESSAGE 'Importacion termidada' VIEW-AS ALERT-BOX WARNING.
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


