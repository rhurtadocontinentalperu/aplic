&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'H/R'.
DEF NEW SHARED VAR lh_Handle  AS HANDLE.

DEF BUFFER B-RUTAC FOR di-rutac.
DEF BUFFER B-RUTAD FOR di-rutad.


    DEFINE SHARED VARIABLE pRCID AS INT.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 BUTTON-PreHR BUTTON-Atencion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-rut001a-v31 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-rut001b-v31 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-rut001c AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv04 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv101 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-dirutac AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-rut001-v31 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Atencion 
     LABEL "Hoja de Atencion al Cliente" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-PreHR 
     LABEL "Importar Pre-Hoja de Ruta" 
     SIZE 20 BY 1.12.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 125 BY 11.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-PreHR AT ROW 16.31 COL 108 WIDGET-ID 6
     BUTTON-Atencion AT ROW 17.38 COL 108 WIDGET-ID 4
     RECT-2 AT ROW 2.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.86 BY 24.62
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "INGRESO DE LA HOJA DE RUTA"
         HEIGHT             = 24.62
         WIDTH              = 128.86
         MAX-HEIGHT         = 25.27
         MAX-WIDTH          = 132.14
         VIRTUAL-HEIGHT     = 25.27
         VIRTUAL-WIDTH      = 132.14
         MAX-BUTTON         = no
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

{src/adm-vm/method/vmviewer.i}
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
ON END-ERROR OF W-Win /* INGRESO DE LA HOJA DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INGRESO DE LA HOJA DE RUTA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Atencion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Atencion W-Win
ON CHOOSE OF BUTTON-Atencion IN FRAME F-Main /* Hoja de Atencion al Cliente */
DO:
  RUN dispatch IN h_v-rut001-v31 ('um-imprimir-hoja-de-atencion':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PreHR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PreHR W-Win
ON CHOOSE OF BUTTON-PreHR IN FRAME F-Main /* Importar Pre-Hoja de Ruta */
DO:
   RUN Importar-Prehoja.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/*
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}
*/

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
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.54 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv04.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv04 ).
       RUN set-position IN h_p-updv04 ( 1.00 , 20.00 ) NO-ERROR.
       RUN set-size IN h_p-updv04 ( 1.42 , 73.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/v-rut001-v31.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-rut001-v31 ).
       RUN set-position IN h_v-rut001-v31 ( 2.73 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.58 , 119.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Fac Bol|Transferencia|Itinerante' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 14.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 10.77 , 105.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-dirutac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-dirutac ).
       RUN set-position IN h_q-dirutac ( 1.00 , 119.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.65 , 8.29 ) */

       /* Links to SmartViewer h_v-rut001-v31. */
       RUN add-link IN adm-broker-hdl ( h_p-updv04 , 'TableIO':U , h_v-rut001-v31 ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_v-rut001-v31 ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-dirutac. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-dirutac ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv04 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-rut001-v31 ,
             h_p-updv04 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_v-rut001-v31 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-rut001a-v31.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut001a-v31 ).
       RUN set-position IN h_b-rut001a-v31 ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-rut001a-v31 ( 7.50 , 90.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv101.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv101 ).
       RUN set-position IN h_p-updv101 ( 17.42 , 94.00 ) NO-ERROR.
       RUN set-size IN h_p-updv101 ( 3.50 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut001a-v31. */
       RUN add-link IN adm-broker-hdl ( h_p-updv101 , 'TableIO':U , h_b-rut001a-v31 ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-rut001a-v31 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut001a-v31 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv101 ,
             BUTTON-Atencion:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-rut001b-v31.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut001b-v31 ).
       RUN set-position IN h_b-rut001b-v31 ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-rut001b-v31 ( 6.92 , 58.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 23.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut001b-v31. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-rut001b-v31 ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-rut001b-v31 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut001b-v31 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             BUTTON-Atencion:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-rut001c.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut001c ).
       RUN set-position IN h_b-rut001c ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-rut001c ( 6.92 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-3 ).
       RUN set-position IN h_p-updv12-3 ( 17.04 , 89.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-3 ( 5.19 , 11.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut001c. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-3 , 'TableIO':U , h_b-rut001c ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-rut001c ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut001c ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-3 ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 3 */

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
  ENABLE RECT-2 BUTTON-PreHR BUTTON-Atencion 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-GRT W-Win 
PROCEDURE Importar-GRT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pStatus AS CHAR.
ASSIGN
    pStatus = "*".  /* Valor por Defecto */

DEF BUFFER ORDENES FOR Faccpedi.

DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.

DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.
DEFINE VAR lRowId AS ROWID.

DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.

DEFINE BUFFER z-vtadtabla FOR vtadtabla.
DEFINE VAR lRowIdx AS ROWID.

DEF BUFFER B-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtactabla FOR vtactabla.

/* Buscamos la ORDEN (OTR) */
FIND ORDENES WHERE ORDENES.codcia = s-codcia
    AND ORDENES.coddoc = B-RutaD.CodRef
    AND ORDENES.nroped = B-RutaD.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDENES THEN RETURN 'ADM-ERROR'.
/* ******************************************************* */
FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia
    AND Almcmov.CodRef = ORDENES.CodDoc
    AND Almcmov.NroRef = ORDENES.NroPed
    AND Almcmov.TipMov = "S"
    AND Almcmov.FlgEst <> "A",
    FIRST Almtmovm NO-LOCK WHERE Almtmovm.CodCia = Almcmov.CodCia
    AND Almtmovm.Codmov = Almcmov.CodMov
    AND Almtmovm.Tipmov = Almcmov.TipMov
    AND Almtmovm.MovTrf = YES,
    FIRST Almacen OF Almcmov NO-LOCK WHERE Almacen.coddiv = s-CodDiv:
    ASSIGN
        pStatus = "P".  /* Correcto */
    CREATE Di-RutaG.
    ASSIGN 
        Di-RutaG.CodCia = Di-RutaC.CodCia
        Di-RutaG.CodDiv = Di-RutaC.CodDiv
        Di-RutaG.CodDoc = Di-RutaC.CodDoc
        Di-RutaG.NroDoc = Di-RutaC.NroDoc
        Di-RutaG.Tipmov = Almcmov.TipMov
        Di-RutaG.CodMov = Almcmov.CodMov
        Di-RutaG.CodAlm = Almcmov.CodAlm
        Di-RutaG.serref = Almcmov.NroSer
        Di-RutaG.nroref = Almcmov.NroDoc
        .
    /* Guardos los pesos y el costo de Mov. Almacen - Ic 10Jul2013 */
    lPesos = 0.
    lCosto = 0.
    lVolumen = 0.
    FOR EACH Almdmov OF Almcmov NO-LOCK:
        /* Costo */
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
            AND AlmStkGe.codmat = almdmov.codmat 
            AND AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
        lValorizado = NO.
        IF AVAILABLE AlmStkGe THEN DO:
            /* Ic - 29Mar2017
            Correo de Luis Figueroa 28Mar2017
            De: Luis Figueroa [mailto:lfigueroa@continentalperu.com] 
            Enviado el: martes, 28 de marzo de 2017 08:59 p.m.
            
            Enrique:
            Para el cálculo del  valorizado de las transferencias internas por favor utilizar el costo y no el precio de venta
            Esto ya lo aprobó PW            
            */
            /* Costo KARDEX */
            IF AlmStkGe.CtoUni <> ? THEN DO:
                lCosto = lCosto + (AlmStkGe.CtoUni * AlmDmov.candes * AlmDmov.factor).
                lValorizado = YES.
            END.
        END.
        /* 
        Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta
        Ic - 29Mar2017, se dejo sin efecto lo anterior (Felix Perez)
        */
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
            almmmatg.codmat = almdmov.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            lVolumen = lVolumen + ( Almdmov.candes * ( almmmatg.libre_d02 / 1000000)).
            lPesos = lPesos + (almmmatg.pesmat * almdmov.candes).
        END.
        /* Volumen */
        IF lValorizado = NO THEN DO:
            IF AVAILABLE almmmatg THEN DO :
                /* Si tiene valorzacion CERO, cargo el precio de venta */
                IF lValorizado = NO THEN DO:
                    IF almmmatg.monvta = 2 THEN DO:
                        /* Dolares */
                        lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes * Almdmov.factor).
                    END.
                    ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes * Almdmov.factor).
                END.
            END.
        END.
    END.
    ASSIGN 
        Di-RutaG.libre_d01 = lPesos
        Di-RutaG.libre_d02 = lCosto
        Di-RutaG.libre_d03 = lVolumen.

    /*      R A C K S      */
    IF almcmov.codref = 'OTR' THEN DO:
        /* Orden de Transferencia */
        lCodDoc = almcmov.codref.
        lNroDoc = almcmov.nroref.
    END.
    ELSE DO:
        /* Transferencia entre almacenes */
        lCodDoc = 'TRA'.
        lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    END.
    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST vtadtabla WHERE vtadtabla.codcia = DI-RutaC.codcia AND
          vtadtabla.tabla = 'MOV-RACK-DTL' AND 
          vtadtabla.libre_c03 = lCodDoc AND 
          vtadtabla.llavedetalle = lNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE vtadtabla THEN DO:
        lComa = "".
        IF (vtadtabla.libre_c05 = ? OR TRIM(vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.                
        ELSE DO :
            lComa = TRIM(vtadtabla.libre_c05).
        END.
        /* Grabo la Hoja de Ruta */
        IF lComa = "" THEN DO:
            lComa = trim(Di-RutaC.nrodoc).
        END.
        ELSE DO:
            lComa = lComa + ", " + trim(Di-RutaC.nrodoc).
        END.
        lRowIdx = ROWID(vtadtabla).
        FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
        IF AVAILABLE z-vtadtabla THEN DO:
            ASSIGN z-vtadtabla.libre_c05 = lComa.
        END.       
        RELEASE z-vtadtabla.
        /* * */
        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                    vtactabla.tabla = "MOV-RACK-HDR" AND 
                    vtactabla.llave BEGINS vtadtabla.llave AND 
                    vtactabla.libre_c02 = vtadtabla.tipo NO-LOCK NO-ERROR.
        IF AVAILABLE vtactabla THEN DO:
            /* Grabo el RACK en DI-RUTAG */
            ASSIGN Di-RutaG.libre_c05 = vtactabla.libre_c01.
            lPaletadespachada = YES.
            FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                    b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                    b-vtadtabla.llave = vtadtabla.llave AND 
                    b-vtadtabla.tipo = vtadtabla.tipo NO-LOCK :
                IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
            END.
            RELEASE B-vtadtabla.
            IF lPaletadespachada = YES THEN DO:
                /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'RACKS' AND 
                            vtatabla.llave_c1 = vtadtabla.llave AND
                            vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                    ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
                END.
                RELEASE vtatabla.
                /* la Paleta */
                lRowId = ROWID(vtactabla).  
                FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                IF AVAILABLE B-vtactabla THEN DO:
                    ASSIGN B-vtactabla.libre_d03 =  pRCID
                            B-vtactabla.libre_f02 = TODAY
                            B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").
                END.                    
            END.
            RELEASE B-vtactabla.
        END.
    END.
    RELEASE vtadtabla.
END.    /* EACH Almcmov */
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-GRV W-Win 
PROCEDURE Importar-GRV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pStatus AS CHAR.
ASSIGN
    pStatus = "*".  /* Valor por Defecto */

DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER bb-vtadtabla FOR vtadtabla.
DEF BUFFER z-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtactabla FOR vtactabla. 
    
DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.
DEFINE VAR lRowId  AS ROWID.
DEFINE VAR lRowIdx AS ROWID.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.
/************************** Los RACKS  *****************************************/
DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.   

/* Buscamos la ORDEN (O/D u O/M) */
FIND ORDENES WHERE ORDENES.codcia = s-codcia
    AND ORDENES.coddoc = B-RutaD.CodRef
    AND ORDENES.nroped = B-RutaD.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDENES THEN RETURN 'ADM-ERROR'.
/* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
    AND PEDIDO.coddoc = ORDENES.CodRef
    AND PEDIDO.nroped = ORDENES.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN 'ADM-ERROR'.
/* ******************************************************* */
/* Guias de remisión están relacionadas */
/* RHC 24/05/18 Buscamos al menos una G/R facturada pero que no esté en ninguna H/R */
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = 'G/R'
    AND Ccbcdocu.codped = PEDIDO.coddoc
    AND Ccbcdocu.nroped = PEDIDO.nroped
    AND CcbCDocu.Libre_c01 = ORDENES.CodDoc     /* O/D */
    AND CcbCDocu.Libre_c02 = ORDENES.NroPed
    AND Ccbcdocu.flgest = "F":
    FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-CodCia                               
        AND DI-RutaD.CodDiv = s-CodDiv                                                
        AND DI-RutaD.CodDoc = "H/R"                                                   
        AND DI-RutaD.CodRef = Ccbcdocu.CodDoc   /* G/R */                             
        AND DI-RutaD.NroRef = Ccbcdocu.NroDoc                                         
        AND CAN-FIND(FIRST DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK) 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-RutaD THEN NEXT.
    ASSIGN
        pStatus = "P".  /* Correcto */
    CREATE DI-RutaD.
    ASSIGN
        DI-RutaD.CodCia = DI-RutaC.CodCia
        DI-RutaD.CodDiv = DI-RutaC.CodDiv
        DI-RutaD.CodDoc = DI-RutaC.CodDoc
        DI-RutaD.NroDoc = DI-RutaC.NroDoc.
    ASSIGN
        DI-RutaD.CodRef = Ccbcdocu.CodDoc
        DI-RutaD.NroRef = Ccbcdocu.NroDoc.
    /* Pesos y Volumenes */
    cValor = "".
    pResumen = "".
    RUN Vta/resumen-pedido (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
    pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
    DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
        cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
    END.
    ASSIGN
        DI-RutaD.Libre_c01 = cValor.
    /* Grabamos el orden de impresion */
    ASSIGN
        DI-RutaD.Libre_d01 = 9999.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
            AND VtaUbiDiv.CodDiv = s-coddiv
            AND VtaUbiDiv.CodDept = gn-clie.CodDept 
            AND VtaUbiDiv.CodProv = gn-clie.CodProv 
            AND VtaUbiDiv.CodDist = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
    END.
    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST bb-vtadtabla WHERE bb-vtadtabla.codcia = DI-RutaC.codcia AND
        bb-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
        bb-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND   /* O/D, OTR, TRA */
        bb-vtadtabla.llavedetalle = ccbcdocu.libre_c02 NO-LOCK NO-ERROR. /* Nro */
    IF AVAILABLE bb-vtadtabla THEN DO:
        lComa = "".
        IF (bb-vtadtabla.libre_c05 = ? OR TRIM(bb-vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.
        ELSE DO :
            lComa = TRIM(bb-vtadtabla.libre_c05).
        END.
        /* Grabo la Hoja de Ruta */
        IF lComa = "" THEN DO:
            lComa = trim(Di-RutaC.nrodoc).
        END.
        ELSE DO:
            lComa = lComa + ", " + trim(Di-RutaC.nrodoc).
        END.
        lRowIdx = ROWID(bb-vtadtabla).
        FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
        IF AVAILABLE z-vtadtabla  THEN DO:
            ASSIGN z-vtadtabla.libre_c05 = lComa.            
        END.
        RELEASE z-vtadtabla.
        /* Libero RACKS Paletas */
        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
            vtactabla.tabla = "MOV-RACK-HDR" AND 
            vtactabla.llave BEGINS bb-vtadtabla.llave AND 
            vtactabla.libre_c02 = bb-vtadtabla.tipo NO-LOCK NO-ERROR.
        IF AVAILABLE vtactabla THEN DO:
            /* Grabo el RACK en la RI-RUTAD */
            ASSIGN DI-RutaD.libre_c05 = vtactabla.libre_c01.
            /* Chequeo si todo el detalle de la paleta tiene HR (hoja de ruta) */
            lPaletadespachada = YES.
            FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                b-vtadtabla.llave = bb-vtadtabla.llave AND /* Division */
                b-vtadtabla.tipo = bb-vtadtabla.tipo NO-LOCK :  /* Nro paleta */
                IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
            END.
            RELEASE B-vtadtabla.
            IF lPaletadespachada = YES THEN DO:
                /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                    vtatabla.tabla = 'RACKS' AND 
                    vtatabla.llave_c1 = bb-vtadtabla.llave AND  /* Division */
                    vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.  /* Rack */
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                    ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
                    RELEASE vtatabla.
                END.
                ELSE DO:
                    RELEASE vtatabla.
                    /*MESSAGE "NO EXISTE en RACK ..Division(" + bb-vtadtabla.llave + ") Rack(" + vtactabla.libre_c01 + ")" .*/
                END.
                /**/
                lRowId = ROWID(vtactabla).  
                FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                IF AVAILABLE B-vtactabla THEN DO:
                    /* Cabecera */
                    ASSIGN 
                        B-vtactabla.libre_d03 =  pRCID
                        B-vtactabla.libre_f02 = TODAY
                        B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").
                    RELEASE B-vtactabla.
                END.
                ELSE DO:
                    RELEASE B-vtactabla.
                    /*MESSAGE "NO existe CABECERA .." .*/
                END.
            END.
            ELSE DO:
                RELEASE B-vtactabla.
                /* Aun hay O/D, TRA, OTR pendientes de despachar */
            END.
        END.
        ELSE DO:
            /*MESSAGE "NO esta en la CABECERA ..(" bb-vtadtabla.llave + ") (" +  bb-vtadtabla.tipo + ")".*/
        END.
    END.
    ELSE DO:
        /*MESSAGE "No esta en el DETALLE ..Tipo(" + ccbcdocu.libre_c01 + ") Nro (" + ccbcdocu.libre_c02 + ")".*/
    END.
END.    /* EACH Ccbcdocu */
RELEASE vtadtabla.
RELEASE vtactabla.
RELEASE B-vtactabla.
RELEASE bb-vtadtabla.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Prehoja W-Win 
PROCEDURE Importar-Prehoja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    input-var-1 = s-coddiv
    input-var-2 = 'PHR'
    input-var-3 = 'P'
    output-var-1 = ?.
RUN lkup/c-pre-hojaruta ('PRE-HOJAS DE RUTA PENDIENTES').
IF output-var-1 = ? THEN RETURN.

FIND B-RUTAC WHERE ROWID(B-RUTAC) = output-var-1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
    MESSAGE 'YA no está disponible la Pre-Hoja de Ruta' SKIP 'Proceso Abortado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
/* **************************************************************************** */
/* 1ro. CONSISTENCIA DE COMPROBANTES */
/* **************************************************************************** */
RUN Importar-Valida.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
/* **************************************************************************** */
/* **************************************************************************** */
/* 2do. Generamos la Hoja de Ruta */
/* **************************************************************************** */
DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pStatus AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR INIT '' NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT B-RUTAC EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
        pMensaje = 'YA no está disponible la Pre-Hoja de Ruta'.
        UNDO, LEAVE.
    END.
    /* Limpiamos la información que NO va a ser migrada */
    FOR EACH T-RutaD NO-LOCK:
        FIND B-RutaD WHERE B-RutaD.CodCia = T-RutaD.CodCia
            AND B-RutaD.CodDiv = T-RutaD.CodDiv
            AND B-RutaD.CodDoc = T-RutaD.CodDoc
            AND B-RutaD.NroDoc = T-RutaD.NroDoc
            AND B-RutaD.CodRef = T-RutaD.CodRef
            AND B-RutaD.NroRef = T-RutaD.NroRef
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = ERROR-STATUS:GET-MESSAGE(1).
            UNDO RLOOP, LEAVE RLOOP.
        END.
        DELETE B-RutaD.
    END.
    /* ************************************************ */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = S-CODCIA  ~
        AND FacCorre.CodDiv = S-CODDIV ~
        AND FacCorre.CodDoc = S-CODDOC" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" ~
        }
    CREATE DI-RutaC.
    ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P"      /* Pendiente */
        DI-RutaC.Libre_c03 = B-RUTAC.CodDoc + ',' + B-RUTAC.NroDoc  /* PARA EXTORNAR */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, LEAVE.
    END.
    /* Información Adicional */
    ASSIGN
/*         DI-RutaC.HorSal = B-RutaC.HorSal */
/*         DI-RutaC.FchSal = B-RutaC.FchSal */
/*         DI-RutaC.KmtIni = B-RutaC.KmtIni */
        DI-RutaC.CodVeh = B-RutaC.CodVeh
        DI-RutaC.Libre_c01 = B-RutaC.Libre_c01 
        DI-RutaC.TpoTra = B-RutaC.TpoTra
        DI-RutaC.Nomtra = B-RutaC.Nomtra
        DI-RutaC.CodPro = B-RutaC.CodPro
        DI-RutaC.Tpotra = B-RutaC.Tpotra
        DI-RutaC.ayudante-1 = B-RutaC.ayudante-1 
        DI-RutaC.ayudante-2 = B-RutaC.ayudante-2 
        DI-RutaC.responsable = B-RutaC.responsable
        DI-RutaC.DesRut = B-RutaC.DesRut
        .
    /* ********************* */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.

    pRowid = ROWID(DI-RutaC).
    /* Detalle */
    FOR EACH B-RutaD WHERE B-RutaD.CodCia = B-RutaC.CodCia
        AND B-RutaD.CodDiv = B-RutaC.CodDiv
        AND B-RutaD.CodDoc = B-RutaC.CodDoc
        AND B-RutaD.NroDoc = B-RutaC.NroDoc:
        pStatus = "*".  /* <<< OJO <<< */
        CASE B-RutaD.CodRef:
            WHEN "O/D" OR WHEN "O/M" THEN DO:
                RUN Importar-GRV (OUTPUT pStatus).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    pMensaje = 'ERROR al grabar la ' + B-RutaD.CodRef + ' ' + B-RutaD.NroRef.
                    UNDO, LEAVE.
                END.
            END.
            WHEN "OTR" THEN DO:
                RUN Importar-GRT (OUTPUT pStatus).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    pMensaje = 'ERROR al grabar la ' + B-RutaD.CodRef + ' ' + B-RutaD.NroRef.
                    UNDO, LEAVE.
                END.
            END.
        END CASE.
        ASSIGN
            B-RutaD.FlgEst = pStatus.   /* OJO */
    END.
    /* Verificamos que haya pasado al menos un registro */
    FIND FIRST Di-RutaD OF Di-RutaC NO-LOCK NO-ERROR.
    FIND FIRST Di-RutaG OF Di-RutaC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaD AND NOT AVAILABLE Di-RutaG THEN DO:
        pMensaje = "NO se ha generado ningun registro para la Hoja de Ruta" + CHR(10) +
            "Proceso Abortado".
        UNDO, LEAVE.
    END.
    /* Final */
    ASSIGN 
        B-RUTAC.FlgEst = "C"
        B-RUTAC.CodCob = DI-RutaC.NroDoc.   /* OJO */
    /* RHC 17.09.11 Control de G/R por pedidos */
    RUN dist/p-rut001 ( ROWID(Di-RutaC), YES ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.

    FIND CURRENT Di-RutaC EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, LEAVE.
    END.
    IF Di-RutaC.FlgEst <> "P" THEN DO:
        pMensaje = "No están completos los comprobantes" + CHR(10) + "Proceso abortado".
        UNDO, LEAVE.
    END.
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(B-RUTAC)  THEN RELEASE B-RUTAC.
IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.
IF AVAILABLE(DI-RutaG) THEN RELEASE DI-RutaG.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
RUN dispatch IN h_q-dirutac ('open-query':U).
RUN Posiciona-Registro IN h_q-dirutac ( INPUT pRowid ).
RUN INFORMA-ESTADO IN h_p-updv04.
RUN Choose-Update IN h_p-updv04.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Valida W-Win 
PROCEDURE Importar-Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO  FOR Faccpedi.

DEF VAR pBloqueados AS INT NO-UNDO.
DEF VAR pTotales AS INT NO-UNDO.

ASSIGN
    pBloqueados = 0
    pTotales = 0.

EMPTY TEMP-TABLE T-RutaD.
RLOOP:
FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = B-RutaC.CodCia
    AND B-RutaD.CodDiv = B-RutaC.CodDiv
    AND B-RutaD.CodDoc = B-RutaC.CodDoc
    AND B-RutaD.NroDoc = B-RutaC.NroDoc:
    
    pTotales = pTotales + 1.
    CASE B-RutaD.CodRef:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            /* Buscamos la ORDEN (O/D u O/M) */
            FIND ORDENES WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.CodRef
                AND ORDENES.nroped = B-RutaD.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ORDENES THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = ORDENES.CodRef
                AND PEDIDO.nroped = ORDENES.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            /* Ya debe haber pasado por FACTURACION */
            FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                /*AND Ccbcdocu.coddiv = s-coddiv*/  /* RHC 18/12/17 Hasta Cross Docking */
                AND Ccbcdocu.coddoc = 'G/R'
                AND Ccbcdocu.codped = PEDIDO.coddoc
                AND Ccbcdocu.nroped = PEDIDO.nroped
                AND Ccbcdocu.flgest = "F"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcdocu THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
        END.
        WHEN "OTR" THEN DO:
            /* Buscamos la ORDEN (OTR) */
            FIND ORDENES WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.CodRef
                AND ORDENES.nroped = B-RutaD.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ORDENES THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            FIND FIRST Almcmov WHERE Almcmov.CodCia = s-CodCia
                AND Almcmov.CodRef = ORDENES.CodDoc     /* OTR */
                AND Almcmov.NroRef = ORDENES.NroPed
                AND Almcmov.TipMov = "S"
                AND Almcmov.FlgEst <> "A"
                AND CAN-FIND(FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia
                             AND Almtmovm.Codmov = Almcmov.CodMov
                             AND Almtmovm.Tipmov = Almcmov.TipMov
                             AND Almtmovm.MovTrf = YES NO-LOCK)
                /*AND CAN-FIND(FIRST Almacen OF Almcmov WHERE Almacen.coddiv = s-CodDiv NO-LOCK)*/
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almcmov THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
        END.
    END CASE.
END.
/* Mensaje con la información que NO va a ser migrada */
DEF VAR pOk AS LOG NO-UNDO.
RUN dist/d-mantto-phr-del.w(pTotales, pBloqueados, INPUT TABLE T-RutaD,OUTPUT pOk).
IF pOk = NO THEN RETURN 'ADM-ERROR'.
IF pTotales = pBloqueados THEN DO:
    MESSAGE 'TODOS los documentos tiene observaciones' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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
  lh_handle = THIS-PROCEDURE.
  RUN Procesa-Handle ("Inicializa").
  
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
DEFINE INPUT PARAMETER p-State AS CHAR.

CASE p-State:
    WHEN "Pagina0"  THEN DO:
          RUN select-page(0).
          RUN dispatch IN h_folder ('hide':U).
          BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
          BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      END.
    WHEN "Pagina1"  THEN DO:
        RUN dispatch IN h_folder ('view':U).
        RUN select-page(1).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      END.
    WHEN "Pagina2"  THEN DO:
        RUN select-page(2).
      END.
    WHEN 'pinta-viewer' THEN DO:
        RUN dispatch IN h_v-rut001-v31 ('display-fields':U).
    END.
    WHEN 'disable-header' THEN DO:
        RUN dispatch IN h_p-updv04 ('disable':U).
        RUN dispatch IN h_q-dirutac ('disable':U).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    WHEN 'disable-detail' THEN DO:
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        IF h_b-rut001c <> ? THEN RUN dispatch IN h_p-updv12-3 ('disable':U).
    END.
    WHEN 'enable-header' THEN DO:
        RUN dispatch IN h_p-updv04 ('enable':U).
        RUN dispatch IN h_q-dirutac ('enable':U).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    WHEN 'enable-detail' THEN DO:
        RUN dispatch IN h_p-updv04 ('enable':U).
        RUN dispatch IN h_q-dirutac ('enable':U).
        IF h_b-rut001c <> ? THEN RUN dispatch IN h_p-updv12-3 ('enable':U).
    END.
END CASE.              

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

