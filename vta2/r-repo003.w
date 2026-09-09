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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE Detalle LIKE Almmmatg
    FIELD ClfCli_A LIKE Almmmatg.PreOfi
    FIELD ClfCli_A1 LIKE Almmmatg.PreOfi
    FIELD ClfCli_B LIKE Almmmatg.PreOfi
    FIELD ClfCli_B1 LIKE Almmmatg.PreOfi
    FIELD ClfCli_B2 LIKE Almmmatg.PreOfi
    FIELD ClfCli_B3 LIKE Almmmatg.PreOfi.

DEF TEMP-TABLE tt-txt
    FIELD Codigo AS CHAR FORMAT 'x(15)'.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodFam BUTTON-2 BtnDone ~
COMBO-BOX-CodDiv COMBO-BOX-FmaPgo optgrp-cuales BUTTON-3 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodFam COMBO-BOX-CodDiv ~
COMBO-BOX-FmaPgo optgrp-cuales FILL-IN-filetxt FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-3 
     LABEL "Limpiar TXT" 
     SIZE 12.43 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "00000","00000"
     DROP-DOWN-LIST
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-FmaPgo AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Condición de Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-filetxt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72 BY 1
     FGCOLOR 4 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE optgrp-cuales AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "ACTIVOS", 1,
"NO ACTIVOS", 2,
"Ambos", 3
     SIZE 43 BY .96 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodFam AT ROW 1.19 COL 20 COLON-ALIGNED WIDGET-ID 2
     BUTTON-2 AT ROW 1.19 COL 90 WIDGET-ID 8
     BtnDone AT ROW 1.19 COL 97 WIDGET-ID 10
     COMBO-BOX-CodDiv AT ROW 2.35 COL 20 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-FmaPgo AT ROW 3.5 COL 20 COLON-ALIGNED WIDGET-ID 6
     optgrp-cuales AT ROW 4.65 COL 17.57 NO-LABEL WIDGET-ID 26
     BUTTON-3 AT ROW 6.46 COL 3.57 WIDGET-ID 32
     BUTTON-1 AT ROW 6.46 COL 88.57 WIDGET-ID 14
     FILL-IN-filetxt AT ROW 6.54 COL 16.29 NO-LABEL WIDGET-ID 16
     FILL-IN-Mensaje AT ROW 7.92 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     "Seleccione el Archivo de TEXTO a trabajar" VIEW-AS TEXT
          SIZE 37.43 BY .62 AT ROW 5.85 COL 48.43 WIDGET-ID 18
          FGCOLOR 14 FONT 6
     "<----- NO SE CONSIDERA CUANDO ELIJE Archivo TXT" VIEW-AS TEXT
          SIZE 47.29 BY .62 AT ROW 4.73 COL 61.72 WIDGET-ID 30
          FGCOLOR 12 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 109 BY 8.35 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 8.35
         WIDTH              = 109
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 109
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 109
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
/* SETTINGS FOR FILL-IN FILL-IN-filetxt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE X-archivo AS CHARACTER.
    DEFINE VARIABLE OKpressed AS LOGICAL.

    DISPLAY "" @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.
    DISPLAY "" @ FILL-IN-mensaje WITH FRAME {&FRAME-NAME}.

SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.  

      DISPLAY X-archivo @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN
        COMBO-BOX-CodDiv COMBO-BOX-CodFam COMBO-BOX-FmaPgo FILL-IN-filetxt optgrp-cuales.

    FOR EACH tt-txt:
            DELETE tt-txt.
    END.

    RUN Carga-Temporal.
    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel.
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Limpiar TXT */
DO:
  FILL-IN-filetxt:SCREEN-VALUE = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-PreVta_A LIKE Detalle.ClfCli_A NO-UNDO.
DEF VAR x-PreVta_A1 LIKE Detalle.ClfCli_A1 NO-UNDO.
DEF VAR x-PreVta_B LIKE Detalle.ClfCli_B NO-UNDO.
DEF VAR x-PreVta_B1 LIKE Detalle.ClfCli_B1 NO-UNDO.
DEF VAR x-PreVta_B2 LIKE Detalle.ClfCli_B2 NO-UNDO.
DEF VAR x-PreVta_B3 LIKE Detalle.ClfCli_B3 NO-UNDO.

DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-PreBas AS DEC DECIMALS 4 NO-UNDO.
DEF VAR f-PreVta AS DEC DECIMALS 4 NO-UNDO.
DEF VAR f-Dsctos AS DEC DECIMALS 4 NO-UNDO.
DEF VAR y-Dsctos AS DEC DECIMALS 4 NO-UNDO.
DEF VAR z-Dsctos AS DEC DECIMALS 4 NO-UNDO.
DEF VAR f-Factor AS DEC DECIMALS 4 NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR x-Clientes AS CHAR EXTENT 6 NO-UNDO.
DEF VAR i-CuentaRegistros AS INT INIT 0 NO-UNDO.

/* Cargo el archivo TXT */
DEFINE VARIABLE lRutaFile AS CHARACTER.
DEFINE VAR lCodArt AS CHAR.

lRutaFile = FILL-IN-filetxt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

/* Cargamos los clientes */
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.clfcli = 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN x-Clientes[1] = gn-clie.codcli.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.clfcli = 'A1'
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN x-Clientes[2] = gn-clie.codcli.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.clfcli = 'B'
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN x-Clientes[3] = gn-clie.codcli.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.clfcli = 'B1'
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN x-Clientes[4] = gn-clie.codcli.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.clfcli = 'B2'
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN x-Clientes[5] = gn-clie.codcli.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.clfcli = 'B3'
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN x-Clientes[6] = gn-clie.codcli.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "INICIANDO PROCESO".

IF lRutaFile <> "" THEN DO:
    INPUT FROM VALUE(lRutaFile).
    REPEAT:
        CREATE tt-txt.
        IMPORT tt-txt.
    END.                    
    INPUT CLOSE.

    FOR EACH tt-txt NO-LOCK:
        lCodArt = trim(tt-txt.codigo).
        i-CuentaRegistros = i-CuentaRegistros + 1.        

        IF lCodArt = "" THEN NEXT.
        IF i-CuentaRegistros MODULO 100 = 0 THEN DISPLAY lCodArt @ FILL-IN-Mensaje WITH FRAME {&FRAME-NAME}.
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = lCodArt NO-LOCK NO-ERROR.
        FIND FIRST Almtfami OF Almmmatg NO-LOCK.

        IF AVAILABLE almmmatg THEN DO:
            /*
            CREATE tt-almmmatg.
            BUFFER-COPY almmmatg TO tt-almmmatg.
            tt-almmmatg.orden = lCorre.
            */
            ASSIGN
                x-PreVta_A = 0
                x-PreVta_A1 = 0
                x-PreVta_B = 0
                x-PreVta_B1 = 0
                x-PreVta_B2 = 0
                x-PreVta_B3 = 0
                s-UndVta    = Almmmatg.UndBas.
            /* Clasificacion A */
            RUN Dame-Precio(
                "A",
                x-Clientes[1],
                OUTPUT x-PreVta_A,
                INPUT-OUTPUT s-UndVta,
                COMBO-BOX-FmaPgo).
            /* Clasificacion A1 */
            RUN Dame-Precio (
                "A1",
                x-Clientes[2],
                OUTPUT x-PreVta_A1,
                INPUT-OUTPUT s-UndVta,
                COMBO-BOX-FmaPgo).
            /* Clasificacion B */
            RUN Dame-Precio (
                "B",
                x-Clientes[3],
                OUTPUT x-PreVta_B,
                INPUT-OUTPUT s-UndVta,
                COMBO-BOX-FmaPgo).
            /* Clasificacion B1 */
            RUN Dame-Precio (
                "B1",
                x-Clientes[4],
                OUTPUT x-PreVta_B1,
                INPUT-OUTPUT s-UndVta,
                COMBO-BOX-FmaPgo).
            /* Clasificacion B2 */
            RUN Dame-Precio (
                "B2",
                x-Clientes[5],
                OUTPUT x-PreVta_B2,
                INPUT-OUTPUT s-UndVta,
                COMBO-BOX-FmaPgo).
            /* Clasificacion B3 */
            RUN Dame-Precio (
                "B3",
                x-Clientes[6],
                OUTPUT x-PreVta_B3,
                INPUT-OUTPUT s-UndVta,
                COMBO-BOX-FmaPgo).
    
            CREATE Detalle.
            BUFFER-COPY Almmmatg
                TO Detalle
                ASSIGN
                /*Detalle.PreOfi = (IF Almmmatg.MonVta = 2 THEN Almmmatg.PreOfi * Almmmatg.TpoCmb ELSE Almmmatg.PreOfi)*/
                Detalle.PreOfi = Almmmatg.PreOfi
                Detalle.ClfCli_A = x-PreVta_A
                Detalle.ClfCli_A1 = x-PreVta_A1
                Detalle.ClfCli_B = x-PreVta_B
                Detalle.ClfCli_B1 = x-PreVta_B1
                Detalle.ClfCli_B2 = x-PreVta_B2
                Detalle.ClfCli_B3 = x-PreVta_B3.
        END.
        ELSE DO:
            CREATE Detalle.
                Detalle.codmat = lCodArt.
                Detalle.DesMat = " ** NO EXISTE **".
                Detalle.orden = i-CuentaRegistros.
        END.        
    END.
END.
ELSE DO:
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND (optgrp-cuales = 3 OR (optgrp-cuales = 1 AND Almmmatg.TipArt = "A") OR (optgrp-cuales = 2 AND Almmmatg.TipArt <> "A"))
        AND ( COMBO-BOX-CodFam = 'Todas' OR Almmmatg.codfam = COMBO-BOX-CodFam ),
        FIRST Almtfami OF Almmmatg NO-LOCK:
        i-CuentaRegistros = i-CuentaRegistros + 1.
        IF i-CuentaRegistros MODULO 100 = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            "PROCESANDO: " + Almmmatg.codmat + " LINEA: " + Almmmatg.codfam + "REG. PROCESADOS: " + STRING(i-CuentaRegistros, ">>>,>>>9").
        ASSIGN
            x-PreVta_A = 0
            x-PreVta_A1 = 0
            x-PreVta_B = 0
            x-PreVta_B1 = 0
            x-PreVta_B2 = 0
            x-PreVta_B3 = 0
            s-UndVta    = Almmmatg.UndBas.
        /* Clasificacion A */
        RUN Dame-Precio (
            "A",
            x-Clientes[1],
            OUTPUT x-PreVta_A,
            INPUT-OUTPUT s-UndVta,
            COMBO-BOX-FmaPgo).
        /* Clasificacion A1 */
        RUN Dame-Precio (
            "A1",
            x-Clientes[2],
            OUTPUT x-PreVta_A1,
            INPUT-OUTPUT s-UndVta,
            COMBO-BOX-FmaPgo).
        /* Clasificacion B */
        RUN Dame-Precio (
            "B",
            x-Clientes[3],
            OUTPUT x-PreVta_B,
            INPUT-OUTPUT s-UndVta,
            COMBO-BOX-FmaPgo).
        /* Clasificacion B1 */
        RUN Dame-Precio (
            "B1",
            x-Clientes[4],
            OUTPUT x-PreVta_B1,
            INPUT-OUTPUT s-UndVta,
            COMBO-BOX-FmaPgo).
        /* Clasificacion B2 */
        RUN Dame-Precio (
            "B2",
            x-Clientes[5],
            OUTPUT x-PreVta_B2,
            INPUT-OUTPUT s-UndVta,
            COMBO-BOX-FmaPgo).
        /* Clasificacion B3 */
        RUN Dame-Precio (
            "B3",
            x-Clientes[6],
            OUTPUT x-PreVta_B3,
            INPUT-OUTPUT s-UndVta,
            COMBO-BOX-FmaPgo).

        CREATE Detalle.
        BUFFER-COPY Almmmatg
            TO Detalle
            ASSIGN
            /*Detalle.PreOfi = (IF Almmmatg.MonVta = 2 THEN Almmmatg.PreOfi * Almmmatg.TpoCmb ELSE Almmmatg.PreOfi)*/
            Detalle.PreOfi = Almmmatg.PreOfi
            Detalle.ClfCli_A = x-PreVta_A
            Detalle.ClfCli_A1 = x-PreVta_A1
            Detalle.ClfCli_B = x-PreVta_B
            Detalle.ClfCli_B1 = x-PreVta_B1
            Detalle.ClfCli_B2 = x-PreVta_B2
            Detalle.ClfCli_B3 = x-PreVta_B3.
    END.

END.


END PROCEDURE.

PROCEDURE Dame-Precio:
/* ****************** */

DEF INPUT PARAMETER pClfCli AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pPreVta AS DEC DECIMALS 4.
DEF INPUT-OUTPUT  PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER s-CndVta AS CHAR.

IF pCodCli = "" OR pCodCli = ? THEN RETURN.

DEF VAR f-PreBas AS DEC DECIMALS 4 NO-UNDO.
DEF VAR f-Dsctos AS DEC DECIMALS 4 NO-UNDO.
DEF VAR y-Dsctos AS DEC DECIMALS 4 NO-UNDO.
DEF VAR z-Dsctos AS DEC DECIMALS 4 NO-UNDO.
DEF VAR f-Factor AS DEC DECIMALS 4 NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR x-Flete  AS DECI NO-UNDO.

    RUN pri/PrecioVentaMayorCredito (
        INPUT "",
        COMBO-BOX-CodDiv,
        pCodCli,
        INPUT Almmmatg.MonVta,      /*1,*/
        INPUT-OUTPUT pUndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-CndVta,
        INPUT 1,
        INPUT 4,
        OUTPUT f-PreBas,
        OUTPUT pPreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        INPUT "",
        OUTPUT x-Flete,
        "",
        INPUT NO
        ).



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
  DISPLAY COMBO-BOX-CodFam COMBO-BOX-CodDiv COMBO-BOX-FmaPgo optgrp-cuales 
          FILL-IN-filetxt FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodFam BUTTON-2 BtnDone COMBO-BOX-CodDiv COMBO-BOX-FmaPgo 
         optgrp-cuales BUTTON-3 BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "CONTINENTAL"
    chWorkSheet:Range("A2"):Value = "DIVISION: " + COMBO-BOX-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    chWorkSheet:Range("A3"):Value = "CONDICION DE VENTA: " + COMBO-BOX-FmaPgo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    chWorkSheet:Range("A4"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B4"):Value = "DESCRIPCION"
    chWorkSheet:Range("C4"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D4"):Value = "SUBLINEA"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Range("E4"):Value = "PRECIO OFICINA"
    chWorkSheet:Range("F4"):Value = "UNIDAD OFICINA"
    chWorkSheet:Range("G4"):Value = "A"
    chWorkSheet:Range("H4"):Value = "A1"
    chWorkSheet:Range("I4"):Value = "B"
    chWorkSheet:Range("J4"):Value = "B1"
    chWorkSheet:Range("K4"):Value = "B2"
    chWorkSheet:Range("L4"):Value = "B3".
    chWorkSheet:Range("M4"):Value = "CodMarca".
    chWorkSheet:Range("N4"):Value = "Marca".

DEF VAR i-CuentaRegistros AS INT NO-UNDO.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    "GENERANDO EL EXCEL".
ASSIGN
    t-Row = 4.
FOR EACH Detalle:
    i-CuentaRegistros = i-CuentaRegistros + 1.
    IF i-CuentaRegistros MODULO 100 = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME  {&FRAME-NAME} =
        "GENERANDO EL EXCEL REG. PROCESADOS: " + STRING(i-CuentaRegistros, ">>>,>>>9").
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.codfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.subfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.PreOfi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.CHR__01.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ClfCli_A.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ClfCli_A1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ClfCli_B.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ClfCli_B1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ClfCli_B2.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ClfCli_B3.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = "'" + CodMar.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = "'" + DesMar.

END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.SwComercial = YES:
           COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' ' +  Almtfami.desfam, Almtfami.codfam).
      END.

      COMBO-BOX-CodDiv:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
      END.
      COMBO-BOX-CodDiv = s-coddiv.

      COMBO-BOX-FmaPgo:DELETE(1).
      COMBO-BOX-FmaPgo:DELIMITER = "|".
      FOR EACH gn-ConVt NO-LOCK:
          COMBO-BOX-FmaPgo:ADD-LAST(gn-ConVt.Codig + ' ' + gn-ConVt.Nombr, gn-ConVt.Codig).
      END.
      FIND FIRST gn-convt NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN COMBO-BOX-FmaPgo = gn-ConVt.Codig.
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

