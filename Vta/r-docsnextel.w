&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEFINE SHARED VARIABLE s-codcia  AS INTEGER   INIT 1.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER   .
DEFINE SHARED VARIABLE s-coddiv  AS CHARACTER INIT '00014'.

/* Local Variable Definitions ---                                       */

DEFINE STREAM Reporte.
DEFINE VARIABLE OKpressed       AS LOGICAL NO-UNDO. 
DEFINE VARIABLE FILL-IN-file    AS CHAR NO-UNDO.

/* CLientes */
DEFINE TEMP-TABLE tt-clientes
    FIELDS t-codcli LIKE gn-clie.codcli
    FIELDS t-nomcli LIKE gn-clie.nomcli
    FIELDS t-dircli LIKE gn-clie.DirCli.

/* Materiales */
DEFINE TEMP-TABLE tt-materiales
    FIELDS t-codmat LIKE almmmatg.codmat
    FIELDS t-desmat LIKE almmmatg.desmat
    /*FIELDS t-fprevta LIKE almmmatg.Prevta*/
    FIELDS t-fprevta AS DECIMAL
    FIELDS t-dstock LIKE almmmatg.StkMax.

/* Vendedores */
DEFINE TEMP-TABLE tt-vendedores
    FIELDS t-codven LIKE gn-ven.CodVen
    FIELDS t-codven1 LIKE gn-ven.CodVen
    FIELDS t-nomven LIKE gn-ven.nomVen
    FIELDS t-codven2 LIKE gn-ven.CodVen.

/* Rutas */
DEFINE TEMP-TABLE tt-rutas
    FIELDS t-codcli LIKE gn-clie.codcli
    FIELDS t-codven LIKE gn-ven.CodVen.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Desde FILL-IN-Hasta BUTTON-1 ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Desde FILL-IN-Hasta FILL-IN-1 ~
FILL-IN-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/api-ve.ico":U
     LABEL "Button 1" 
     SIZE 12 BY 1.88.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 3" 
     SIZE 12 BY 1.88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63.14 BY 1
     BGCOLOR 15 FGCOLOR 7  NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Desde AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Hasta AT ROW 2.08 COL 36 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 3.42 COL 7 WIDGET-ID 2
     BUTTON-3 AT ROW 3.42 COL 19.43 WIDGET-ID 10
     FILL-IN-1 AT ROW 5.58 COL 7 NO-LABEL WIDGET-ID 4
     FILL-IN-2 AT ROW 6.65 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "Fecha a considerar para Clientes y Vendedores" VIEW-AS TEXT
          SIZE 56 BY .62 AT ROW 1.31 COL 6 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.43 BY 7.38 WIDGET-ID 100.


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
         TITLE              = "Genera Archivos de Carga Nextel"
         HEIGHT             = 7.38
         WIDTH              = 73.43
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Genera Archivos de Carga Nextel */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Genera Archivos de Carga Nextel */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    
    ASSIGN fill-in-desde fill-in-hasta.
    RUN Genera_Archivos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
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
  DISPLAY FILL-IN-Desde FILL-IN-Hasta FILL-IN-1 FILL-IN-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Desde FILL-IN-Hasta BUTTON-1 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera_Archivos W-Win 
PROCEDURE Genera_Archivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR cotfile     AS CHAR INIT  "" NO-UNDO.
    DEF VAR x-file      AS CHAR INIT  "" NO-UNDO.
    DEF VAR x-file02    AS CHAR INIT  "" NO-UNDO.
    DEF VAR Rpta-1      AS LOG NO-UNDO.

    DEFINE VARIABLE s-codmon AS INTEGER     NO-UNDO.
    DEFINE VARIABLE s-codcli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE s-TpoCmb AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE s-cndvta AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE f-factor AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-canped AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE f-prebas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-prevta AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE y-dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-tipdto AS CHARACTER   NO-UNDO.
        
    DEFINE VARIABLE dStock   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE iDesde   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iHasta   AS INTEGER     NO-UNDO.
/*
    SYSTEM-DIALOG GET-FILE x-File FILTERS '*.txt' '*.txt'
        INITIAL-FILTER 1 ASK-OVERWRITE CREATE-TEST-FILE
        DEFAULT-EXTENSION 'txt'
        RETURN-TO-START-DIR SAVE-AS
        TITLE 'Guardar en' USE-FILENAME
        UPDATE Rpta-1.
  */  
  
    SYSTEM-DIALOG GET-DIR X-file
    RETURN-TO-START-DIR
    TITLE 'Guardar en'
    UPDATE Rpta-1.


    IF Rpta-1 = NO THEN RETURN.

    x-file = x-file + "\".

    x-file02 = x-file + 'producto.txt'.

    DISPLAY x-file @ fill-in-1 WITH FRAME {&FRAME-NAME}.

    iDesde = (YEAR(fill-in-desde) * 10000) + (MONTH(fill-in-desde) * 100) + DAY((fill-in-desde)).
    iHasta = (YEAR(fill-in-Hasta) * 10000) + (MONTH(fill-in-Hasta) * 100) + DAY((fill-in-Hasta)).
    
    /*Tabla Materiales*/

    
    
    FOR EACH almtfam WHERE almtfam.CodCia = s-codcia 
            AND Almtfami.SwComercial
            AND LOOKUP(almtfami.codfam,"000,001,010,011,012") > 0 NO-LOCK,
            EACH almmmatg WHERE almmmatg.codcia = almtfami.codcia
                AND almmmatg.tpoart = 'A'
                AND almmmatg.codfam = almtfami.codfam NO-LOCK:
        
            ASSIGN 
                F-FACTOR = 1
                X-CANPED = 1
                s-coddiv = '00014'
                s-codcli = '11111111111'
                s-codmon = 1
                s-tpocmb = 2.85
                s-cndvta = '000'.
            RUN vtamay/PrecioVenta-3 (s-CodCia,
                                s-CodDiv,
                                s-CodCli,
                                s-CodMon,
                                s-TpoCmb,
                                f-Factor,
                                Almmmatg.CodMat,
                                s-CndVta,
                                x-CanPed,
                                4,
                                35,
                                OUTPUT f-PreBas,
                                OUTPUT f-PreVta,
                                OUTPUT f-Dsctos,
                                OUTPUT y-Dsctos,
                                OUTPUT x-TipDto).
            /*Stock Articulo*/
            dStock = 0.
            FOR EACH almmmate OF almmmatg NO-LOCK:
                dStock = dStock + almmmate.stkact.
            END.
            
            IF dStock > 0 THEN DO:
                FIND tt-materiales WHERE t-codmat = almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-materiales THEN DO:
                    CREATE tt-materiales.
                    ASSIGN t-codmat = almmmatg.codmat   /*Codigo*/
                            t-desmat = almmmatg.desmat  /*Descripcion*/
                            t-fprevta = f-prevta        /*Precio*/
                            t-dstock = dstock.          /*Stock Total*/
                END.
            END.
            DISPLAY "Cargando Tabla Articulos " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
        END.

    /*Tabla Vendedores*/
    x-file02 = x-file + 'Vendedor.txt'.

    FOR EACH dwh_ventas_vend WHERE dwh_ventas_vend.codcia = s-codcia
            AND dwh_ventas_vend.coddiv = s-coddiv
            AND dwh_ventas_vend.fecha  >= iDesde
            AND dwh_ventas_vend.fecha  <= iHasta,
            FIRST gn-ven WHERE gn-ven.CodCia = s-codcia 
                AND gn-ven.codven = dwh_ventas_vend.codven NO-LOCK:
            IF AVAILABLE gn-ven THEN DO:
                FIND tt-vendedores WHERE t-codven = gn-ven.CodVen EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-vendedores THEN DO:
                    CREATE tt-vendedores.
                    ASSIGN tt-vendedores.t-codven = gn-ven.CodVen   /*Codigo*/
                        t-codven1 = gn-ven.CodVen                   /*Login*/
                        t-nomven = gn-ven.nomVen                    /*Nombre*/
                        t-codven2 = gn-ven.CodVen.                  /*Clave*/
                END.
            END.
            DISPLAY "Cargando Tabla Vendedores " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
        END.

    /*Tabla Rutas*/
    x-file02 = x-file + 'Ruta.txt'.

    FOR EACH dwh_ventas_vendcli WHERE dwh_ventas_vendcli.codcia = s-codcia
            AND dwh_ventas_vendcli.coddiv = s-coddiv
            AND dwh_ventas_vendcli.fecha  >= iDesde
            AND dwh_ventas_vendcli.fecha  <= iHasta NO-LOCK:
            
            FIND tt-rutas WHERE t-codcli = dwh_ventas_vendcli.codcli AND tt-rutas.t-codven = dwh_ventas_vendcli.codven EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-rutas THEN DO:
                CREATE tt-rutas.
                ASSIGN t-codcli = dwh_ventas_vendcli.codcli
                    tt-rutas.t-codven = dwh_ventas_vendcli.codven.
            END.
            FIND tt-clientes WHERE tt-clientes.t-codcli = dwh_ventas_vendcli.codcli EXCLUSIVE-LOCK NO-ERROR.             
            IF NOT AVAIL tt-clientes THEN DO:
                CREATE tt-clientes.
                ASSIGN tt-clientes.t-codcli = dwh_ventas_vendcli.codcli.    /*Codigo*/
            END.
        END.

    /*Tabla Clientes*/
    DEFINE VARIABLE cDirCli AS CHARACTER   NO-UNDO.
    x-file02 = x-file + 'Cliente.txt'.

    FOR EACH tt-clientes EXCLUSIVE-LOCK,
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = tt-clientes.t-codcli NO-LOCK :
            IF AVAILABLE gn-clie  THEN DO:
                cDirCli = REPLACE(gn-clie.dircli,"|"," ").
                ASSIGN t-nomcli = gn-clie.nomcli    /*Nombre*/
                        t-dircli = cDirCli.         /*Direccion*/
            END.
            DISPLAY "Cargando Tabla Clientes " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
        END.

    DISPLAY "" @ fill-in-2 WITH FRAME {&FRAME-NAME}.

    /* Crea archivos TXTs */
    RUN genera_txt.

    MESSAGE "Proceso Terminado"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera_txt W-Win 
PROCEDURE genera_txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR cotfile     AS CHAR INIT  "" NO-UNDO.
    DEF VAR x-file      AS CHAR INIT  "" NO-UNDO.
    DEF VAR x-file02    AS CHAR INIT  "" NO-UNDO.
    DEF VAR Rpta-1      AS LOG NO-UNDO.

    DEFINE VARIABLE s-codmon AS INTEGER     NO-UNDO.
    DEFINE VARIABLE s-codcli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE s-TpoCmb AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE s-cndvta AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE f-factor AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-canped AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE f-prebas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-prevta AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE y-dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-tipdto AS CHARACTER   NO-UNDO.
        
    DEFINE VARIABLE dStock   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE iDesde   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iHasta   AS INTEGER     NO-UNDO.
    /*
    SYSTEM-DIALOG GET-DIR X-file
    RETURN-TO-START-DIR
    TITLE 'Guardar en'
    UPDATE Rpta-1.
    

    IF Rpta-1 = NO THEN RETURN.
    */

    /*x-file = x-file + "\".*/
    ASSIGN x-file = fill-in-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    /*DISPLAY x-file @ fill-in-1 WITH FRAME {&FRAME-NAME}.*/

    
    /*Tabla Materiales*/
    x-file02 = x-file + 'producto.txt'.
    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
    FOR EACH tt-materiales NO-LOCK:
        PUT STREAM Report UNFORMATTED
            t-codmat "|"  /*Codigo*/
            t-desmat "|"  /*Descripcion*/
            t-fprevta        "|"  /*Precio*/
            t-dStock          "|"  SKIP.        /*Stock Total*/
        DISPLAY "Generando TXT Articulos " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
    END.
    OUTPUT STREAM Report CLOSE.

    /*Tabla Vendedores*/
    x-file02 = x-file + 'Vendedor.txt'.
    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
    FOR EACH tt-vendedores NO-LOCK:
        PUT STREAM Report UNFORMATTED 
            t-CodVen "|"       /*Codigo*/
            t-CodVen1 "|"       /*Login*/
            t-NomVen "|"       /*Nombre*/
            t-CodVen2 "|" SKIP.     /*Clave*/
        DISPLAY "Generando TXT Vendedores " @ fill-in-2 WITH FRAME {&FRAME-NAME}.

    END.
    OUTPUT STREAM Report CLOSE.

    /*Tabla Rutas*/
    x-file02 = x-file + 'Ruta.txt'.
    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
    FOR EACH tt-rutas NO-LOCK :
        PUT STREAM report UNFORMATTED
            t-codcli "|"
            tt-rutas.t-codven "|"
            "1111111" "|" SKIP.
        DISPLAY "Generando TXT Rutas " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
    END.
    OUTPUT STREAM Report CLOSE.

    /*Tabla Clientes*/
    x-file02 = x-file + 'Cliente.txt'.

    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
    FOR EACH tt-clientes NO-LOCK :  
        PUT STREAM Report UNFORMATTED
                tt-clientes.t-codcli "|"    /*Codigo*/
                t-nomcli "|"    /*Nombre*/
                t-DirCli "|" SKIP.  /*Direccion*/
        DISPLAY "Generando TXT Clientes " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
    END.
    OUTPUT STREAM Report CLOSE.


    /* --------------------------------------------- */

/*
    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
        FOR EACH almtfam WHERE almtfam.CodCia = s-codcia 
            AND Almtfami.SwComercial
            AND LOOKUP(almtfami.codfam,"000,001,010,011,012") > 0 NO-LOCK,
            EACH almmmatg WHERE almmmatg.codcia = almtfami.codcia
                AND almmmatg.tpoart = 'A'
                AND almmmatg.codfam = almtfami.codfam NO-LOCK:
        
            ASSIGN 
                F-FACTOR = 1
                X-CANPED = 1
                s-coddiv = '00014'
                s-codcli = '11111111111'
                s-codmon = 1
                s-tpocmb = 2.85
                s-cndvta = '000'.
            RUN vtamay/PrecioVenta-3 (s-CodCia,
                                s-CodDiv,
                                s-CodCli,
                                s-CodMon,
                                s-TpoCmb,
                                f-Factor,
                                Almmmatg.CodMat,
                                s-CndVta,
                                x-CanPed,
                                4,
                                35,
                                OUTPUT f-PreBas,
                                OUTPUT f-PreVta,
                                OUTPUT f-Dsctos,
                                OUTPUT y-Dsctos,
                                OUTPUT x-TipDto).
            /*Stock Articulo*/
            dStock = 0.
            FOR EACH almmmate OF almmmatg NO-LOCK:
                dStock = dStock + almmmate.stkact.
            END.
            
            IF dStock > 0 THEN DO:
                PUT STREAM Report UNFORMATTED
                    almmmatg.codmat "|"  /*Codigo*/
                    almmmatg.desmat "|"  /*Descripcion*/
                    f-prevta        "|"  /*Precio*/
                    dStock          "|"  SKIP.        /*Stock Total*/
            END.
            DISPLAY "Cargando Tabla Articulos " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
        END.

    OUTPUT STREAM Report CLOSE.

    /*Tabla Vendedores*/
    x-file02 = x-file + 'Vendedor.txt'.
    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
        FOR EACH dwh_ventas_vend WHERE dwh_ventas_vend.codcia = s-codcia
            AND dwh_ventas_vend.coddiv = s-coddiv
            AND dwh_ventas_vend.fecha  >= iDesde
            AND dwh_ventas_vend.fecha  <= iHasta,
            FIRST gn-ven WHERE gn-ven.CodCia = s-codcia 
                AND gn-ven.codven = dwh_ventas_vend.codven NO-LOCK:

            PUT STREAM Report UNFORMATTED 
                gn-ven.CodVen "|"       /*Codigo*/
                gn-ven.CodVen "|"       /*Login*/
                gn-ven.NomVen "|"       /*Nombre*/
                gn-ven.CodVen "|" SKIP.     /*Clave*/
            DISPLAY "Cargando Tabla Vendedores " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
        END.
    OUTPUT STREAM Report CLOSE.


/*     OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.                    */
/*         FOR EACH gn-ven WHERE gn-ven.CodCia = s-codcia                                 */
/*             AND gn-ven.flgest = 'A' NO-LOCK:                                           */
/*             PUT STREAM Report UNFORMATTED                                              */
/*                 gn-ven.CodVen "|"       /*Codigo*/                                     */
/*                 gn-ven.CodVen "|"       /*Login*/                                      */
/*                 gn-ven.NomVen "|"       /*Nombre*/                                     */
/*                 gn-ven.CodVen SKIP.     /*Clave*/                                      */
/*             DISPLAY "Cargando Tabla Vendedores " @ fill-in-2 WITH FRAME {&FRAME-NAME}. */
/*         END.                                                                           */
/*     OUTPUT STREAM Report CLOSE.                                                        */

    /*Tabla Rutas*/
    /*x-file02 = REPLACE(x-file,'.txt','_Tab_Rutas.txt').*/
    x-file02 = x-file + 'Ruta.txt'.

    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
        FOR EACH dwh_ventas_vendcli WHERE dwh_ventas_vendcli.codcia = s-codcia
            AND dwh_ventas_vendcli.coddiv = s-coddiv
            AND dwh_ventas_vendcli.fecha  >= iDesde
            AND dwh_ventas_vendcli.fecha  <= iHasta NO-LOCK:
            PUT STREAM report UNFORMATTED
                dwh_ventas_vendcli.codcli "|"
                dwh_ventas_vendcli.codven "|"
                "1111111" "|" SKIP.
            FIND FIRST tt-clientes WHERE t-codcli = dwh_ventas_vendcli.codcli
                NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-clientes THEN DO:
                CREATE tt-clientes.
                ASSIGN t-codcli = dwh_ventas_vendcli.codcli.
            END.
        END.
    OUTPUT STREAM Report CLOSE.

    /*Tabla Clientes*/
    DEFINE VARIABLE cDirCli AS CHARACTER   NO-UNDO.
    /*x-file02 = REPLACE(x-file,'.txt','_Tab_Clientes.txt').*/
    x-file02 = x-file + 'Cliente.txt'.

    OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.
        FOR EACH tt-clientes NO-LOCK,
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = t-codcli NO-LOCK:
            cDirCli = REPLACE(gn-clie.dircli,"|"," ").
            PUT STREAM Report UNFORMATTED
                    gn-clie.codcli "|"    /*Codigo*/
                    gn-clie.nomcli "|"    /*Nombre*/
                    cDirCli "|" SKIP.  /*Direccion*/
            DISPLAY "Cargando Tabla Clientes " @ fill-in-2 WITH FRAME {&FRAME-NAME}.
        END.
    OUTPUT STREAM Report CLOSE.


/*     /*Tabla Clientes*/                                                               */
/*     x-file02 = REPLACE(x-file,'.txt','_Tab_Clientes.txt').                           */
/*     OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.                  */
/*         FOR EACH gn-clie WHERE gn-clie.codcia = cl-codcia                            */
/*             AND gn-clie.coddiv = s-coddiv                                            */
/*             AND gn-clie.Flgsit = 'A' NO-LOCK:                                        */
/*             PUT STREAM Report UNFORMATTED                                            */
/*                     gn-clie.codcli "|"    /*Codigo*/                                 */
/*                     gn-clie.nomcli "|"    /*Nombre*/                                 */
/*                     gn-clie.dircli SKIP.  /*Direccion*/                              */
/*             DISPLAY "Cargando Tabla Clientes " @ fill-in-2 WITH FRAME {&FRAME-NAME}. */
/*         END.                                                                         */
/*     OUTPUT STREAM Report CLOSE.                                                      */

/*     OUTPUT STREAM Report TO VALUE(x-file02) /*PAGED PAGE-SIZE 31*/.                                 */
/*         FOR EACH gn-ven WHERE gn-ven.CodCia = s-codcia                                              */
/*             AND LOOKUP(gn-ven.codven,"002,022,054,715,716,718,726,731,735,751,752,812,961,962") > 0 */
/*             AND gn-ven.flgest = 'A' NO-LOCK:                                                        */
/*                                                                                                     */
/*             FOR EACH gn-clie WHERE gn-clie.codcia = cl-codcia                                       */
/*                 AND gn-clie.coddiv = s-coddiv                                                       */
/*                 AND gn-clie.Flgsit = 'A' NO-LOCK:                                                   */
/*                 PUT STREAM Report UNFORMATTED                                                       */
/*                     gn-clie.codcli "|"                                                              */
/*                     gn-ven.codven "|"                                                               */
/*                     "1111111" SKIP.                                                                 */
/*                 DISPLAY "Cargando Tabla Rutas " @ fill-in-2 WITH FRAME {&FRAME-NAME}.               */
/*             END.                                                                                    */
/*                                                                                                     */
/*         END.                                                                                        */
/*     OUTPUT STREAM Report CLOSE.                                                                     */

    DISPLAY "" @ fill-in-2 WITH FRAME {&FRAME-NAME}.

    MESSAGE "Proceso Terminado"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
 */

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
  DO WITH FRAME {&FRAME-NAME} :
      ASSIGN 
          fill-in-desde = TODAY - 365
          fill-in-hasta = TODAY.
      DISPLAY fill-in-desde fill-in-hasta.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

