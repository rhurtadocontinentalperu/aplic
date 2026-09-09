&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DINV LIKE InvdPDA.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-adm-new-record AS LOG INIT NO NO-UNDO.
DEF VAR s-NroSecuencia AS INT INIT 0 NO-UNDO.

/* Control */
FIND FIRST InvZonas WHERE InvZonas.CodCia = s-codcia
    AND InvZonas.CodAlm = s-codalm
    /*AND InvZonas.SCont1 = NO*/
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE InvZonas THEN DO:
    MESSAGE 'No se puede hacer el 2do. conteo' SKIP
        'No se ha configurado el inventario'
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR pFactor AS DECI NO-UNDO.
DEF VAR pCanPed AS DECI NO-UNDO.
DEF VAR pCodEan AS CHAR NO-UNDO.

DEF VAR pCodDigitado AS CHAR.
DEF VAR pSeleUbi AS LOG INIT NO.

DEFINE VAR pCodInventariador AS CHAR INIT ''.

RUN MINI\d-ingreso-inventariador.r(OUTPUT pCodInventariador).

IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN ERROR.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Qty ~
BtnOk BtnDone BtnCancelar RECT-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodUbi FILL-IN-CodMat ~
FILL-IN-Qty FILL-IN-Cantidad txtOldUbi txtOldDigitado txtOldArt ~
txtOldFactor txtOldCantidad txtOldTotal FILL-IN-UndBas EDITOR-DesMat ~
FILL-IN-Marca FILL-IN-UbiAlm FILL-IN-Factor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancelar 
     LABEL "Cancelar" 
     SIZE 13.72 BY 1.12
     FONT 11.

DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 11 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BtnOk 
     LABEL "Ok" 
     SIZE 6 BY 1.12
     FONT 11.

DEFINE BUTTON BUTTON-1 
     LABEL "Limpiar" 
     SIZE 18 BY 1.5.

DEFINE BUTTON BUTTON-Grabar 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "GRABAR EN INVENTARIOS" 
     SIZE 11 BY 1.54 TOOLTIP "GRABAR EN INVENTARIOS".

DEFINE VARIABLE EDITOR-DesMat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 46 BY 3.85
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodUbi AS CHARACTER FORMAT "X(10)":U 
     LABEL "UBICACION" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.35
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Cantidad AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.35
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(20)":U 
     LABEL "ARTICULO" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.35
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Factor AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "Factor" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.35
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 32.29 BY 1.35 NO-UNDO.

DEFINE VARIABLE FILL-IN-Qty AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.35
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-UbiAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ubi Sist" 
     VIEW-AS FILL-IN 
     SIZE 32.29 BY 1.35 NO-UNDO.

DEFINE VARIABLE FILL-IN-UndBas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.35
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE txtOldArt AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS FILL-IN 
     SIZE 50.14 BY 1.04
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

DEFINE VARIABLE txtOldCantidad AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY 1.04
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

DEFINE VARIABLE txtOldDigitado AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS FILL-IN 
     SIZE 29.72 BY .92
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

DEFINE VARIABLE txtOldFactor AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY 1.04
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

DEFINE VARIABLE txtOldTotal AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY 1.04
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

DEFINE VARIABLE txtOldUbi AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .92
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.86 BY 3.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodUbi AT ROW 5.92 COL 3.86 WIDGET-ID 28
     FILL-IN-CodMat AT ROW 7.23 COL 25 COLON-ALIGNED WIDGET-ID 12 AUTO-RETURN 
     FILL-IN-Qty AT ROW 17.08 COL 25 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-Cantidad AT ROW 18.42 COL 25 COLON-ALIGNED WIDGET-ID 20
     BtnOk AT ROW 20.38 COL 2.57 WIDGET-ID 78
     txtOldUbi AT ROW 2.5 COL 6.72 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     txtOldDigitado AT ROW 2.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     txtOldArt AT ROW 3.5 COL 4.86 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     txtOldFactor AT ROW 4.65 COL 6.72 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     txtOldCantidad AT ROW 4.65 COL 23.57 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     txtOldTotal AT ROW 4.65 COL 40.29 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     FILL-IN-UndBas AT ROW 7.27 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     EDITOR-DesMat AT ROW 8.81 COL 6 NO-LABEL WIDGET-ID 10
     BUTTON-1 AT ROW 9.46 COL 38 WIDGET-ID 36
     FILL-IN-Marca AT ROW 12.85 COL 18 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-UbiAlm AT ROW 14.19 COL 4.43 WIDGET-ID 34
     FILL-IN-Factor AT ROW 15.73 COL 25 COLON-ALIGNED WIDGET-ID 22
     BUTTON-Grabar AT ROW 20.04 COL 35.43 WIDGET-ID 16
     BtnDone AT ROW 20.04 COL 46.43 WIDGET-ID 18
     BtnCancelar AT ROW 20.38 COL 10.29 WIDGET-ID 80
     "          2do CONTEO (Al barrer)" VIEW-AS TEXT
          SIZE 57 BY 1.12 AT ROW 1.04 COL 1.14 WIDGET-ID 76
          BGCOLOR 15 FGCOLOR 12 
     "Dig." VIEW-AS TEXT
          SIZE 5.57 BY .88 AT ROW 2.5 COL 20.72 WIDGET-ID 72
          FONT 11
     "Tot.:" VIEW-AS TEXT
          SIZE 5.43 BY .77 AT ROW 4.73 COL 36.57 WIDGET-ID 68
          FONT 11
     "Cant.:" VIEW-AS TEXT
          SIZE 7 BY .77 AT ROW 4.73 COL 19 WIDGET-ID 64
          FONT 11
     "Fact." VIEW-AS TEXT
          SIZE 7.14 BY .77 AT ROW 4.77 COL 1.72 WIDGET-ID 60
          FONT 11
     "Art.:" VIEW-AS TEXT
          SIZE 4 BY .77 AT ROW 3.58 COL 1.72 WIDGET-ID 58
          FONT 11
     "Ubic" VIEW-AS TEXT
          SIZE 7.14 BY .77 AT ROW 2.54 COL 2.14 WIDGET-ID 54
          FONT 11
     RECT-1 AT ROW 2.27 COL 1.14 WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57.57 BY 20.81
         FONT 8 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DINV T "?" ? INTEGRAL InvdPDA
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "1er. CONTEO"
         HEIGHT             = 20.81
         WIDTH              = 57.57
         MAX-HEIGHT         = 20.81
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 20.81
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-Grabar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN COMBO-BOX-CodUbi IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cantidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Factor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UbiAlm IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOldArt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOldCantidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOldDigitado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOldFactor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOldTotal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOldUbi IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* 1er. CONTEO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* 1er. CONTEO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnCancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnCancelar W-Win
ON CHOOSE OF BtnCancelar IN FRAME F-Main /* Cancelar */
DO:

    APPLY 'ENTRY':U TO FILL-IN-CodMat.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
    /* Control de lo ya ingresado */
    IF CAN-FIND(FIRST T-DINV NO-LOCK) THEN DO:
        /*
        MESSAGE 'Aún no ha grabado la información registrada' SKIP
            'Continuamos?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta AS LOG.
        */
        MESSAGE 'Aún no ha grabado la información registrada' SKIP
            'DESEA PERDERLA?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.

    IF pSeleUbi = YES  THEN DO:
        FIND InvZonas WHERE InvZonas.CodCia = s-codcia
            AND InvZonas.CodAlm = s-codalm
            AND InvZonas.CZona = COMBO-BOX-CodUbi:SCREEN-VALUE
            AND InvZonas.SCont1 = NO
            EXCLUSIVE NO-ERROR.
        IF AVAILABLE InvZonas THEN DO:
            ASSIGN InvZonas.usrConteo = ''
                    invZonas.FHIniConteo = ?.
        END.

        RELEASE invZonas.
    END.
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


&Scoped-define SELF-NAME BtnOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOk W-Win
ON CHOOSE OF BtnOk IN FRAME F-Main /* Ok */
DO:
    IF FILL-IN-CodMat:SCREEN-VALUE = '' THEN DO:
        APPLY 'ENTRY':U TO FILL-IN-CodMat.
        RETURN NO-APPLY.
    END.
    IF DECIMAL(FILL-IN-Qty:SCREEN-VALUE) >= 1000000 THEN DO:
        MESSAGE "Cantidad es demasiado elevado...".
        APPLY 'ENTRY':U TO FILL-IN-Qty.
        RETURN NO-APPLY.
    END.

    ASSIGN COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Cantidad FILL-IN-Factor FILL-IN-Qty.
    IF FILL-IN-Cantidad = 0 THEN DO:
        MESSAGE 'La cantidad ingresada es 0' SKIP
            'Continuamos con la grabación?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN DO:
            APPLY 'ENTRY':U TO FILL-IN-Qty.
            RETURN NO-APPLY.
        END.
    END.

    /* Validar que tenga CONTEO */
    FIND FIRST invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND 
                                    invCargaInicial.codalm = s-codalm AND 
                                    invCargaInicial.codmat = pCodMat NO-LOCK NO-ERROR.
                                    
    IF NOT AVAILABLE invCargaInicial THEN DO:
        MESSAGE "Articulo no existe en la TOMA DE INVENTARIOS".
        APPLY 'ENTRY':U TO FILL-IN-CodMat.
        RETURN NO-APPLY.
    END.
    IF invCargaInicial.QCont1 = ? THEN DO:
        MESSAGE "Articulo aun no tiene CONTEO".
        APPLY 'ENTRY':U TO FILL-IN-CodMat.
        RETURN NO-APPLY.
    END.
    IF invCargaInicial.QCont2 <> ? THEN DO:
        MESSAGE "Articulo aun no tiene RECONTEO".
        APPLY 'ENTRY':U TO FILL-IN-CodMat.
        RETURN NO-APPLY.
    END.
    IF invCargaInicial.QCont3 <> ? THEN DO:
        MESSAGE "Articulo ya tiene 3er CONTEO".
        APPLY 'ENTRY':U TO FILL-IN-CodMat.
        RETURN NO-APPLY.
    END.

    CREATE T-DINV.
    ASSIGN
        s-NroSecuencia = s-NroSecuencia + 1
        T-DINV.Codcia = s-codcia
        T-DINV.CodAlm = s-codalm
        T-DINV.codmat = FILL-IN-CodMat
        T-DINV.CZona = COMBO-BOX-CodUbi
        T-DINV.CItem = s-NroSecuencia
        T-DINV.QFactor = FILL-IN-Factor
        T-DINV.QDigitado = FILL-IN-Qty
        T-DINV.QNeto = FILL-IN-Cantidad
        T-DINV.CodEan = pCodEan.
    s-adm-new-record = YES.

    /* Valores anteriores */
    DISPLAY TRIM(FILL-IN-codmat:SCREEN-VALUE) + " " + TRIM(EDITOR-desmat:SCREEN-VALUE) @ txtOldArt
        WITH FRAME {&FRAME-NAME}.
    DISPLAY TRIM(COMBO-BOX-Codubi:SCREEN-VALUE) @ txtOldUbi
        WITH FRAME {&FRAME-NAME}.
    DISPLAY TRIM(FILL-IN-factor:SCREEN-VALUE) @ txtOldFactor
        WITH FRAME {&FRAME-NAME}.
    DISPLAY TRIM(FILL-IN-qty:SCREEN-VALUE) @ txtOldCantidad
        WITH FRAME {&FRAME-NAME}.
    DISPLAY TRIM(FILL-IN-cantidad:SCREEN-VALUE) @ txtOldTotal
        WITH FRAME {&FRAME-NAME}.
    DISPLAY TRIM(pCodDigitado) @ txtOldDigitado
          WITH FRAME {&FRAME-NAME}.

    /*PAUSE 1 NO-MESSAGE.*/

    ASSIGN
        FILL-IN-CodMat = ''
        EDITOR-DesMat = ''
        FILL-IN-Cantidad = 0
        FILL-IN-Factor = 1
        FILL-IN-Qty = 1
        BUTTON-Grabar:SENSITIVE = YES.
    DISPLAY FILL-IN-CodMat EDITOR-DesMat FILL-IN-CodMat FILL-IN-Cantidad  
        FILL-IN-Factor FILL-IN-Qty
        WITH FRAME {&FRAME-NAME}.

    APPLY 'ENTRY':U TO FILL-IN-CodMat.

    /*RETURN NO-APPLY.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Limpiar */
DO:
  FIND LAST T-DINV USE-INDEX Llave01 NO-ERROR.
  IF AVAILABLE T-DINV THEN DO:
      FIND Almmmatg OF T-DINV NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
          MESSAGE 'BORRAMOS EL REGISTRO?' SKIP(1)
              '     CODIGO:' T-DINV.CodMat SKIP
              'DESCRIPCION:' Almmmatg.DesMat SKIP
              '   CANTIDAD:' T-DINV.QNeto 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE rpta AS LOG.
          IF rpta = YES THEN DELETE T-DINV.
          APPLY 'ENTRY':U TO FILL-IN-CodMat.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grabar W-Win
ON CHOOSE OF BUTTON-Grabar IN FRAME F-Main /* GRABAR EN INVENTARIOS */
DO:
   FIND FIRST T-DINV NO-LOCK NO-ERROR.
   IF NOT AVAILABLE T-DINV THEN RETURN NO-APPLY.
   MESSAGE 'Se va a grabar todo lo registrado' SKIP
       'Procedemos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
       UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.
   RUN Grabar NO-ERROR.
   IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
   DO WITH FRAME {&FRAME-NAME}:
       /* Control de lo ya ingresado */
       /*COMBO-BOX-CodUbi:DELETE(COMBO-BOX-CodUbi:SCREEN-VALUE).*/
       COMBO-BOX-CodUbi:SENSITIVE = YES.
       BUTTON-Grabar:SENSITIVE = NO.
       /*COMBO-BOX-CodUbi = 'Seleccione'.*/
       /*COMBO-BOX-CodUbi:SCREEN-VALUE = 'Seleccione'.*/
       COMBO-BOX-CodUbi = ''.
       COMBO-BOX-CodUbi:SCREEN-VALUE = ''.
       APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
   END.
   s-NroSecuencia = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodUbi W-Win
ON LEAVE OF COMBO-BOX-CodUbi IN FRAME F-Main /* UBICACION */
DO:
  pSeleUbi = NO.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.

  FIND InvZonas WHERE InvZonas.CodCia = s-codcia
    AND InvZonas.CodAlm = s-codalm
    AND InvZonas.CZona = COMBO-BOX-CodUbi:SCREEN-VALUE    
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE InvZonas THEN DO:
    MESSAGE 'Zona NO registrada' VIEW-AS ALERT-BOX ERROR.
    SELF:SCREEN-VALUE = ''.
    RETURN NO-APPLY.
  END.


  FIND InvZonas WHERE InvZonas.CodCia = s-codcia
      AND InvZonas.CodAlm = s-codalm
      AND InvZonas.CZona = COMBO-BOX-CodUbi:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE InvZonas THEN DO:
      MESSAGE 'Zona NO esta REGISTRADO' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.

  IF InvZonas.SCont1 = NO  THEN DO:
      MESSAGE 'Zona NO tiene CONTEO' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.

  IF InvZonas.SCont1 = YES AND InvZonas.SCont2 = YES  THEN DO:
      MESSAGE 'Zona YA tiene RECONTEO' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.

  /* Fecha de Inciios de la Zona */
  DEFINE BUFFER b-invZonas FOR invZonas.

  FIND FIRST b-invzonas WHERE ROWID(invzonas) = ROWID(b-invzonas) EXCLUSIVE NO-ERROR.
  IF AVAILABLE b-invzonas THEN DO:
      ASSIGN b-invzonas.FHIniReConteo = NOW
            b-invzonas.UsrReConteo = s-user-id.
      pSeleUbi = YES.
  END.

  RELEASE b-invZonas.

  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Cantidad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Cantidad W-Win
ON LEAVE OF FILL-IN-Cantidad IN FRAME F-Main /* Total */
OR ENTER OF FILL-IN-Cantidad
DO:
    /*
  IF FILL-IN-CodMat:SCREEN-VALUE = '' THEN DO:
      APPLY 'ENTRY':U TO FILL-IN-CodMat.
      RETURN NO-APPLY.
  END.
  ASSIGN COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Cantidad FILL-IN-Factor FILL-IN-Qty.
  IF FILL-IN-Cantidad = 0 THEN DO:
      MESSAGE 'La cantidad ingresada es 0' SKIP
          'Continuamos con la grabación?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO FILL-IN-Qty.
          RETURN NO-APPLY.
      END.
  END.
  CREATE T-DINV.
  ASSIGN
      s-NroSecuencia = s-NroSecuencia + 1
      T-DINV.Codcia = s-codcia
      T-DINV.CodAlm = s-codalm
      T-DINV.codmat = FILL-IN-CodMat
      T-DINV.CZona = COMBO-BOX-CodUbi
      T-DINV.CItem = s-NroSecuencia
      T-DINV.QFactor = FILL-IN-Factor
      T-DINV.QDigitado = FILL-IN-Qty
      T-DINV.QNeto = FILL-IN-Cantidad
      T-DINV.CodEan = pCodEan.
  s-adm-new-record = YES.
  PAUSE 1 NO-MESSAGE.
  ASSIGN
      FILL-IN-CodMat = ''
      EDITOR-DesMat = ''
      FILL-IN-Cantidad = 0
      FILL-IN-Factor = 1
      FILL-IN-Qty = 1
      BUTTON-Grabar:SENSITIVE = YES.
  DISPLAY FILL-IN-CodMat EDITOR-DesMat FILL-IN-CodMat FILL-IN-Cantidad  
      FILL-IN-Factor FILL-IN-Qty
      WITH FRAME {&FRAME-NAME}.
/*   MESSAGE                   */
/*       T-DINV.Codcia SKIP    */
/*       T-DINV.CodAlm SKIP    */
/*       T-DINV.codmat SKIP    */
/*       T-DINV.CZona SKIP     */
/*       T-DINV.CItem SKIP     */
/*       T-DINV.QFactor SKIP   */
/*       T-DINV.QDigitado SKIP */
/*       T-DINV.QNeto SKIP     */
/*       T-DINV.CodEan .       */
  APPLY 'ENTRY':U TO FILL-IN-CodMat.
  RETURN NO-APPLY.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON ENTRY OF FILL-IN-CodMat IN FRAME F-Main /* ARTICULO */
DO:
  pFactor = 1.
  pCanPed = 1.
  pCodEan = "".
  pCodDigitado = "".
  DISPLAY 
      pFactor @  FILL-IN-Factor 
      pCanPed @ FILL-IN-Qty
      WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* ARTICULO */
OR ENTER OF FILL-IN-CodMat
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    /*IF COMBO-BOX-CodUbi:SCREEN-VALUE = 'Seleccione' THEN DO:*/
    IF COMBO-BOX-CodUbi:SCREEN-VALUE = '' THEN DO:
        BELL.
        MESSAGE 'Seleccione una UBICACION' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
        RETURN NO-APPLY.
    END.

    ASSIGN
        pCodMat = SELF:SCREEN-VALUE
        pCanPed = 1.
        IF pCodDigitado = "" THEN DO:
           ASSIGN  pCodDigitado = FILL-IN-codmat:SCREEN-VALUE.
        END.
        
    RUN alm/p-codbrr-inv (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).

    IF pCodMat = '' THEN DO:
        BELL.
        MESSAGE 'Código errado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF LENGTH(SELF:SCREEN-VALUE) > 6 THEN pCodEan = SELF:SCREEN-VALUE.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = pCodMat
        NO-LOCK.
    /* En caso de haber leido EAN14 */
    IF pFactor <> 1 THEN DISPLAY pFactor @ FILL-IN-Factor WITH FRAME {&FRAME-NAME}.
    ASSIGN 
        FILL-IN-CodMat:SCREEN-VALUE = pCodMat
        EDITOR-DesMat:SCREEN-VALUE  = Almmmatg.desmat
        FILL-IN-UndBas:SCREEN-VALUE = Almmmatg.undstk
        FILL-IN-Marca:SCREEN-VALUE = Almmmatg.desmar
        FILL-IN-UbiAlm:SCREEN-VALUE = ''
        COMBO-BOX-CodUbi:SENSITIVE = NO.
    FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = s-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN FILL-IN-UbiAlm:SCREEN-VALUE = Almmmate.CodUbi.
    DISPLAY 
        DECIMAL(FILL-IN-Qty:SCREEN-VALUE) * DECIMAL(FILL-IN-factor:SCREEN-VALUE) @ FILL-IN-Cantidad
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Qty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Qty W-Win
ON LEAVE OF FILL-IN-Qty IN FRAME F-Main /* Cantidad */
OR ENTER OF FILL-IN-Qty
DO:
  IF FILL-IN-CodMat:SCREEN-VALUE = '' THEN DO:
      APPLY 'ENTRY':U TO FILL-IN-CodMat.
      RETURN NO-APPLY.
  END.
  IF DECIMAL(FILL-IN-qty:SCREEN-VALUE) >= 1000000 THEN DO:
      MESSAGE "Cantidad es demasiado elevado...".
      APPLY 'ENTRY':U TO FILL-IN-CodMat.
      RETURN NO-APPLY.
  END.

  DISPLAY
      DECIMAL(FILL-IN-Factor:SCREEN-VALUE) * DECIMAL(FILL-IN-Qty:SCREEN-VALUE) @
      FILL-IN-Cantidad
      WITH FRAME {&FRAME-NAME}.

    /*APPLY 'LEAVE':U TO FILL-IN-Cantidad.*/
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
  DISPLAY COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Qty FILL-IN-Cantidad txtOldUbi 
          txtOldDigitado txtOldArt txtOldFactor txtOldCantidad txtOldTotal 
          FILL-IN-UndBas EDITOR-DesMat FILL-IN-Marca FILL-IN-UbiAlm 
          FILL-IN-Factor 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Qty BtnOk BtnDone BtnCancelar 
         RECT-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar W-Win 
PROCEDURE Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lDif AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE j AS INTE INIT 1 NO-UNDO.
DEFINE VARIABLE iSConteo AS INTE INIT 2 NO-UNDO.    /* 2do Conteo */
DEFINE VARIABLE dFechReg AS DATETIME NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Borramos las tablas */
    FOR EACH InvcPDA WHERE InvcPDA.CodCia = s-codcia
        AND InvcPDA.CodAlm = s-codalm
        AND InvcPDA.CZona = COMBO-BOX-CodUbi
        AND InvcPDA.SConteo = iSConteo:
        DELETE InvcPDA.
    END.
    FOR EACH InvdPDA WHERE InvdPDA.CodCia = s-codcia
        AND InvdPDA.CodAlm = s-codalm
        AND InvdPDA.CZona = COMBO-BOX-CodUbi
        AND InvdPDA.SConteo = iSConteo:
        DELETE InvdPDA.
    END.
    /* 1ro Cargamos InvdPDA */
    dFechReg = DATETIME(TODAY,MTIME).
    FOR EACH T-DINV BY T-DINV.CItem:
        CREATE InvdPDA.
        BUFFER-COPY T-DINV
            TO InvdPDA
            ASSIGN
            InvdPDA.CodCia  = s-codcia
            InvdPDA.CodAlm  = s-codalm
            InvdPDA.CItem   = j
            InvdPDA.SConteo = iSConteo
            InvdPDA.CUser   = s-user-id
            InvdPDA.FechReg = dFechReg.
        j = j + 1.
        DELETE T-DINV.
    END.
    /* 2do Cargamos InvcPDA */
    FOR EACH InvdPDA NO-LOCK WHERE InvdPDA.CodCia = s-codcia
        AND InvdPDA.CodAlm = s-codalm
        AND InvdPDA.CZona  = COMBO-BOX-CodUbi
        AND InvdPDA.SConteo = iSConteo:
        FIND FIRST InvcPDA WHERE InvcPDA.CodAlm = s-codalm
            AND InvcPDA.CodCia = s-codcia
            AND InvcPDA.CodMat = InvdPDA.CodMat
            AND InvcPDA.CZona = InvdPDA.CZona
            AND InvcPDA.SConteo = InvdPDA.SConteo
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE InvcPDA THEN CREATE InvcPDA.
        ASSIGN
            InvcPDA.CodAlm = s-codalm
            InvcPDA.CodCia = s-codcia
            InvcPDA.CodMat = InvdPDA.CodMat
            InvcPDA.CZona  = InvdPDA.CZona
            InvcPDA.QNeto  = InvcPDA.QNeto + InvdPDA.QNeto
            InvcPDA.SConteo = InvdPDA.SConteo.

        /* Guardamos el Inventariados */
        FIND FIRST invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND 
                                            invCargaInicial.codalm = s-codalm AND 
                                            invCargaInicial.codmat = InvdPDA.CodMat NO-ERROR.

        IF NOT AVAILABLE invCargaInicial THEN DO:
            /* Si NO existe en caraga inicial ADICIONAR */
            CREATE invCargaInicial.
                ASSIGN invCargaInicial.codcia = s-codcia
                        invCargaInicial.CodAlm = s-codalm
                        invCargaInicial.CodMat = invCPDA.CodMat
                        invCargaInicial.QStkSis = 0
                        invCargaInicial.CZona = ''
                        invCargaInicial.FechReg = NOW
                        invCargaInicial.CUser = s-user-id
                        invCargaInicial.Qcont1 = 0.
                        invCargaInicial.Qcont2 = 0.
        END.

        IF invCargaInicial.usrInventario[2] = ? OR 
                invCargaInicial.usrInventario[2] = ''  
                THEN ASSIGN invCargaInicial.usrInventario[2] = pCodInventariador.

        RELEASE invCargaInicial.

    END.
    /* 3ro Marcamos la zona como ya procesada */
    FIND InvZonas WHERE InvZonas.CodCia = s-codcia
        AND InvZonas.CodAlm = s-codalm
        AND InvZonas.CZona = COMBO-BOX-CodUbi
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE InvZonas THEN DO:
        ASSIGN InvZonas.SCont2 = YES
                invZonas.FHFINReConteo = NOW.
    END.
        
END.
IF AVAILABLE InvcPDA THEN RELEASE InvcPDA.
IF AVAILABLE InvdPDA THEN RELEASE InvdPDA.
IF AVAILABLE InvZonas THEN RELEASE InvZonas.

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
  EMPTY TEMP-TABLE T-DINV.
  s-adm-new-record = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   DO WITH FRAME {&FRAME-NAME}:                                   */
/*       FOR EACH InvZonas NO-LOCK WHERE InvZonas.CodCia = s-codcia */
/*           AND InvZonas.CodAlm = s-codalm                         */
/*           AND InvZonas.SCont1 = NO:                              */
/*           COMBO-BOX-CodUbi:ADD-LAST(InvZonas.CZona).             */
/*       END.                                                       */
/*   END.                                                           */

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

