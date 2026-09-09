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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF TEMP-TABLE tmp-detalle
    FIELD Llave     AS CHAR
    FIELD CanxMes   AS DEC
    FIELD VtaxMesMe AS DEC
    FIELD VtaxMesMn AS DEC
    FIELD CtoxMesMe AS DEC
    FIELD CtoxMesMn AS DEC
    FIELD ProxMesMe AS DEC
    FIELD ProxMesMn AS DEC
    FIELD StkAct    AS DEC
    INDEX Llave01 AS PRIMARY Llave.

DEF STREAM REPORTE.

/* VARIABLES PARA EL RESUMEN */
DEF VAR x-CodDiv LIKE gn-divi.coddiv NO-UNDO.
DEF VAR x-CodCli LIKE gn-clie.codcli NO-UNDO.
DEF VAR x-CodPro LIKE gn-prov.codpro NO-UNDO.
DEF VAR x-CodVen LIKE gn-ven.codven NO-UNDO.
DEF VAR x-FmaPgo LIKE gn-ConVt.Codig NO-UNDO.
DEF VAR x-CodFam LIKE almmmatg.codfam NO-UNDO.
DEF VAR x-SubFam LIKE almmmatg.subfam NO-UNDO.
DEF VAR x-NroCard LIKE gn-card.nrocard NO-UNDO.

DEF VAR x-Canal   LIKE gn-clie.canal NO-UNDO.
DEF VAR x-CodDept LIKE gn-clie.coddept NO-UNDO.
DEF VAR x-CodProv LIKE gn-clie.codprov NO-UNDO.
DEF VAR x-CodDist LIKE gn-clie.coddist NO-UNDO.

DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Promn   AS DECI INIT 0.
DEFINE VAR T-Prome   AS DECI INIT 0.
DEFINE VAR T-Sdomn   AS DECI INIT 0.
DEFINE VAR T-Sdome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.
DEFINE VAR T-Pro     AS DECI INIT 0.
DEFINE VAR T-Sdo     AS DECI INIT 0.
DEFINE VAR T-StkAct  AS DECI INIT 0.
DEFINE VAR x-Llave AS CHAR.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR I AS INTEGER.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR F-Salida  AS DECI INIT 0.

DEFINE VAR x-Meses AS CHAR 
    INIT 'ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE' 
    NO-UNDO.
DEFINE VAR x-Mes AS CHAR NO-UNDO.

DEF INPUT PARAMETER pParametro AS CHAR.
/* Sistaxis de pParamtero
+COSTO    Imprimir el valor del costo
-COSTO    Imprimir sin el valor del costo
************************** */

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
&Scoped-Define ENABLED-OBJECTS TOGGLE-CodDiv TOGGLE-CodCli TOGGLE-CodMat ~
TOGGLE-CodPro TOGGLE-CodVen TOGGLE-FmaPgo TOGGLE-NroCard DesdeF HastaF ~
BUTTON-1 BtnDone RADIO-SET-Tipo 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-CodDiv COMBO-BOX-CodDiv ~
TOGGLE-CodCli FILL-IN-CodCli FILL-IN-NomCli TOGGLE-Resumen-Depto ~
TOGGLE-CodMat COMBO-BOX-CodFam TOGGLE-Resumen-Linea COMBO-BOX-SubFam ~
TOGGLE-Resumen-Marca TOGGLE-CodPro FILL-IN-CodPro FILL-IN-NomPro ~
TOGGLE-CodVen FILL-IN-CodVen FILL-IN-NomVen TOGGLE-FmaPgo COMBO-BOX-FmaPgo ~
TOGGLE-NroCard FILL-IN-NroCard FILL-IN-NomCard DesdeF HastaF RADIO-SET-Tipo ~
FILL-IN-Mensaje 

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
     SIZE 6 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-FmaPgo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCard AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCard AS CHARACTER FORMAT "X(6)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Mensual", 2
     SIZE 25 BY 1.08 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodCli AS LOGICAL INITIAL no 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodDiv AS LOGICAL INITIAL no 
     LABEL "Division" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodMat AS LOGICAL INITIAL no 
     LABEL "Artículo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodPro AS LOGICAL INITIAL no 
     LABEL "Proveedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-CodVen AS LOGICAL INITIAL no 
     LABEL "Vendedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-FmaPgo AS LOGICAL INITIAL no 
     LABEL "Forma de Pago" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-NroCard AS LOGICAL INITIAL no 
     LABEL "Tarjeta" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-Depto AS LOGICAL INITIAL no 
     LABEL "Resumido por Departamento-Provincia" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-Linea AS LOGICAL INITIAL yes 
     LABEL "Resumido por Linea y Sub-Linea" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Resumen-Marca AS LOGICAL INITIAL no 
     LABEL "Resumido por marca" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE-CodDiv AT ROW 1.27 COL 4 WIDGET-ID 2
     COMBO-BOX-CodDiv AT ROW 1.27 COL 26 COLON-ALIGNED WIDGET-ID 30
     TOGGLE-CodCli AT ROW 2.35 COL 4 WIDGET-ID 6
     FILL-IN-CodCli AT ROW 2.35 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN-NomCli AT ROW 2.35 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     TOGGLE-Resumen-Depto AT ROW 3.42 COL 28 WIDGET-ID 64
     TOGGLE-CodMat AT ROW 4.23 COL 4 WIDGET-ID 14
     COMBO-BOX-CodFam AT ROW 4.23 COL 26 COLON-ALIGNED WIDGET-ID 36
     TOGGLE-Resumen-Linea AT ROW 4.23 COL 81 WIDGET-ID 60
     COMBO-BOX-SubFam AT ROW 5.31 COL 26 COLON-ALIGNED WIDGET-ID 38
     TOGGLE-Resumen-Marca AT ROW 5.31 COL 81 WIDGET-ID 62
     TOGGLE-CodPro AT ROW 6.38 COL 4 WIDGET-ID 16
     FILL-IN-CodPro AT ROW 6.38 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     FILL-IN-NomPro AT ROW 6.38 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     TOGGLE-CodVen AT ROW 7.46 COL 4 WIDGET-ID 18
     FILL-IN-CodVen AT ROW 7.46 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN-NomVen AT ROW 7.46 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     TOGGLE-FmaPgo AT ROW 8.54 COL 4 WIDGET-ID 20
     COMBO-BOX-FmaPgo AT ROW 8.54 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     TOGGLE-NroCard AT ROW 9.62 COL 4 WIDGET-ID 50
     FILL-IN-NroCard AT ROW 9.62 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     FILL-IN-NomCard AT ROW 9.62 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     DesdeF AT ROW 10.69 COL 26 COLON-ALIGNED WIDGET-ID 10
     HastaF AT ROW 10.69 COL 47 COLON-ALIGNED WIDGET-ID 12
     BUTTON-1 AT ROW 11.5 COL 89 WIDGET-ID 24
     BtnDone AT ROW 11.5 COL 95 WIDGET-ID 28
     RADIO-SET-Tipo AT ROW 11.77 COL 28 NO-LABEL WIDGET-ID 56
     FILL-IN-Mensaje AT ROW 13.12 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.43 BY 13.5 WIDGET-ID 100.


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
         TITLE              = "ESTADISTICAS DE VENTAS"
         HEIGHT             = 13.5
         WIDTH              = 141.43
         MAX-HEIGHT         = 22.92
         MAX-WIDTH          = 153.72
         VIRTUAL-HEIGHT     = 22.92
         VIRTUAL-WIDTH      = 153.72
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
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-SubFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCard IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroCard IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Depto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Linea IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Resumen-Marca IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ESTADISTICAS DE VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ESTADISTICAS DE VENTAS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN
       DesdeF HastaF 
        TOGGLE-CodCli 
        TOGGLE-CodDiv 
        TOGGLE-CodMat 
        TOGGLE-CodPro 
        TOGGLE-CodVen 
        TOGGLE-FmaPgo
        TOGGLE-NroCard
        RADIO-SET-Tipo
        TOGGLE-Resumen-Linea TOGGLE-Resumen-Marca
        TOGGLE-Resumen-Depto.
    ASSIGN
        COMBO-BOX-CodDiv 
        COMBO-BOX-CodFam COMBO-BOX-FmaPgo 
        COMBO-BOX-SubFam FILL-IN-CodCli 
        FILL-IN-CodPro FILL-IN-CodVen FILL-IN-NroCard.
    /* CONSISTENCIA */
    IF (TOGGLE-CodCli OR 
        TOGGLE-CodDiv OR
        TOGGLE-CodMat OR
        TOGGLE-CodPro OR 
        TOGGLE-CodVen OR
        TOGGLE-FmaPgo OR
        TOGGLE-NroCard
        ) = NO
        THEN DO:
        MESSAGE 'Debe seleccionar por lo menos uno' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
   RUN Carga-Temporal.
   FIND FIRST tmp-detalle NO-ERROR.
   IF NOT AVAILABLE tmp-detalle THEN DO:
       MESSAGE 'No hay registros' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME F-Main /* Linea */
DO:
    COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
    COMBO-BOX-SubFam:ADD-LAST('Todos').
    COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'.
    IF SELF:SCREEN-VALUE <> 'Todos' THEN DO:
        FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
            AND Almsfami.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(Almsfami.subfam + ' - '+ AlmSFami.dessub).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVen W-Win
ON LEAVE OF FILL-IN-CodVen IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE 'Vendedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomVen:SCREEN-VALUE = gn-ven.nomven.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroCard W-Win
ON LEAVE OF FILL-IN-NroCard IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND gn-card WHERE gn-card.nrocard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-card THEN DO:
        MESSAGE 'Tarjeta del cliente no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomCard:SCREEN-VALUE = gn-card.nomcli[1].
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodCli W-Win
ON VALUE-CHANGED OF TOGGLE-CodCli IN FRAME F-Main /* Cliente */
DO:
    FILL-IN-CodCli:SENSITIVE = NOT FILL-IN-CodCli:SENSITIVE.
    TOGGLE-Resumen-Depto:SENSITIVE = NOT TOGGLE-Resumen-Depto:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodDiv W-Win
ON VALUE-CHANGED OF TOGGLE-CodDiv IN FRAME F-Main /* Division */
DO:
  COMBO-BOX-CodDiv:SENSITIVE = NOT COMBO-BOX-CodDiv:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodMat W-Win
ON VALUE-CHANGED OF TOGGLE-CodMat IN FRAME F-Main /* Artículo */
DO:
    COMBO-BOX-CodFam:SENSITIVE = NOT COMBO-BOX-CodFam:SENSITIVE.
    COMBO-BOX-SubFam:SENSITIVE = NOT COMBO-BOX-SubFam:SENSITIVE.
    TOGGLE-Resumen-Linea:SENSITIVE = NOT TOGGLE-Resumen-Linea:SENSITIVE.
    TOGGLE-Resumen-Marca:SENSITIVE = NOT TOGGLE-Resumen-Marca:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodPro W-Win
ON VALUE-CHANGED OF TOGGLE-CodPro IN FRAME F-Main /* Proveedor */
DO:
    FILL-IN-CodPro:SENSITIVE = NOT FILL-IN-CodPro:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-CodVen W-Win
ON VALUE-CHANGED OF TOGGLE-CodVen IN FRAME F-Main /* Vendedor */
DO:
    FILL-IN-CodVen:SENSITIVE = NOT FILL-IN-CodVen:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-FmaPgo W-Win
ON VALUE-CHANGED OF TOGGLE-FmaPgo IN FRAME F-Main /* Forma de Pago */
DO:
    COMBO-BOX-FmaPgo:SENSITIVE = NOT COMBO-BOX-FmaPgo:SENSITIVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-NroCard W-Win
ON VALUE-CHANGED OF TOGGLE-NroCard IN FRAME F-Main /* Tarjeta */
DO:
    FILL-IN-NroCard:SENSITIVE = NOT FILL-IN-NroCard:SENSITIVE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Articulos W-Win 
PROCEDURE Carga-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtarti NO-LOCK WHERE estavtas.evtarti.codcia = s-codcia
    AND estavtas.evtarti.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtarti.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")),
    FIRST Almmmatg OF estavtas.evtarti NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' ARTICULO ' + Almmmatg.codmat + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    T-StkAct  = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtarti.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtarti.Codmes + 1
      X-CODANO = estavtas.evtarti.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtarti.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtarti.Codmes,"99") + "/" + STRING(estavtas.evtarti.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtarti.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtarti.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtarti.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtarti.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtarti.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtarti.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtarti.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtarti.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtarti.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtarti.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodMat = YES THEN DO:
         IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtarti.codmat + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtarti.codmat + '|'.
             x-Llave = x-Llave + almmmatg.codfam + '|'.
             x-Llave = x-Llave + almmmatg.subfam + '|'.
             x-Llave = x-Llave + almmmatg.desmar + '|'.
             x-Llave = x-Llave + almmmatg.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.codfam + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.codfam + '|'.
                 x-Llave = x-Llave + almmmatg.subfam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.desmar + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + almmmatg.licencia[1] + '|'.
     END.
     /* 29.09.10 agregamos stock contable a la fecha */
     IF TOGGLE-CodMat = YES AND (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
         FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
             AND AlmStkGe.codmat = estavtas.evtarti.codmat
             AND AlmStkGe.fecha <= TODAY
             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmStkGe THEN t-StkAct = AlmStkge.StkAct.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn
         tmp-detalle.StkAct    = t-StkAct.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Articulos-Divisiones W-Win 
PROCEDURE Carga-Articulos-Divisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtartdv NO-LOCK WHERE estavtas.evtartdv.codcia = s-codcia
    AND estavtas.evtartdv.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtartdv.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtartdv.coddiv BEGINS x-CodDiv,
    FIRST Almmmatg OF estavtas.evtartdv NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' ARTICULO ' + estavtas.evtartdv.codmat + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    T-StkAct  = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtartdv.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtartdv.Codmes + 1
      X-CODANO = estavtas.evtartdv.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtartdv.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtartdv.Codmes,"99") + "/" + STRING(estavtas.evtartdv.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtartdv.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtartdv.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtartdv.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtartdv.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtartdv.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtartdv.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtartdv.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtartdv.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtartdv.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtartdv.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtartdv.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtartdv.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtartdv.canalventa + '|'.
     END.
     IF TOGGLE-CodMat = YES THEN DO:
         IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtartdv.codmat + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtartdv.codmat + '|'.
             x-Llave = x-Llave + almmmatg.codfam + '|'.
             x-Llave = x-Llave + almmmatg.subfam + '|'.
             x-Llave = x-Llave + almmmatg.desmar + '|'.
             x-Llave = x-Llave + almmmatg.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.codfam + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.codfam + '|'.
                 x-Llave = x-Llave + almmmatg.subfam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.desmar + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + almmmatg.licencia[1] + '|'.
     END.
     /* 29.09.10 agregamos stock contable a la fecha */
     IF TOGGLE-CodMat = YES AND (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
/*          FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia    */
/*              AND AlmStkGe.codmat = estavtas.evtartdv.codmat     */
/*              AND AlmStkGe.fecha <= TODAY                        */
/*              NO-LOCK NO-ERROR.                                  */
/*          IF AVAILABLE AlmStkGe THEN t-StkAct = AlmStkge.StkAct. */
         FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
             AND Almacen.coddiv = estavtas.evtartd.coddiv:
             /* Almacenes que NO son propios */
             IF Almacen.FlgRep = NO THEN NEXT.
             /* RHC 09.09.04 EL ALMACEN DE CONSIGN. NO TIENE MOVIMIENTO CONTABLE  */
             IF Almacen.AlmCsg = YES THEN NEXT.
             FIND Almmmate WHERE Almmmate.codcia = Almacen.codcia
                 AND Almmmate.codalm = Almacen.codalm
                 AND Almmmate.codmat = estavtas.evtartdv.codmat
                 NO-LOCK NO-ERROR.
             IF AVAILABLE Almmmate THEN t-StkAct = t-StkAct + Almmmate.StkAct.
         END.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn
         tmp-detalle.StkAct    = t-StkAct.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Articulos-Vendedores W-Win 
PROCEDURE Carga-Articulos-Vendedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtvenarti NO-LOCK WHERE estavtas.evtvenarti.codcia = s-codcia
    AND estavtas.evtvenarti.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtvenarti.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtvenarti.coddiv BEGINS x-CodDiv
    AND estavtas.evtvenarti.codven BEGINS x-CodVen,
    FIRST Almmmatg OF estavtas.evtvenarti NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' VENDEDOR ' + codven + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    T-StkAct  = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtvenarti.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtvenarti.Codmes + 1
      X-CODANO = estavtas.evtvenarti.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtvenarti.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtvenarti.Codmes,"99") + "/" + STRING(estavtas.evtvenarti.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtvenarti.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtvenarti.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtvenarti.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtvenarti.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtvenarti.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtvenarti.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtvenarti.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtvenarti.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtvenarti.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtvenarti.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtvenarti.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtvenarti.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtvenarti.canalventa + '|'.
     END.
     IF TOGGLE-CodMat = YES THEN DO:
         IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtvenarti.codmat + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtvenarti.codmat + '|'.
             x-Llave = x-Llave + almmmatg.codfam + '|'.
             x-Llave = x-Llave + almmmatg.subfam + '|'.
             x-Llave = x-Llave + almmmatg.desmar + '|'.
             x-Llave = x-Llave + almmmatg.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.codfam + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.codfam + '|'.
                 x-Llave = x-Llave + almmmatg.subfam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.desmar + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + almmmatg.licencia[1] + '|'.
     END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtvenarti.codven + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtvenarti.codven + '|'.
     END.
     /* 29.09.10 agregamos stock contable a la fecha */
     IF TOGGLE-CodMat = YES AND (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
         FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
             AND AlmStkGe.codmat = estavtas.evtvenarti.codmat
             AND AlmStkGe.fecha <= TODAY
             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmStkGe THEN t-StkAct = AlmStkge.StkAct.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn
         tmp-detalle.StkAct    = t-StkAct.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Clientes W-Win 
PROCEDURE Carga-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RUTINA GENERAL */
FOR EACH estavtas.evtclie NO-LOCK WHERE estavtas.evtclie.codcia = s-codcia
    AND estavtas.evtclie.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtclie.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtclie.coddiv BEGINS x-CodDiv
    AND estavtas.evtclie.codcli BEGINS x-CodCli:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' CLIENTE ' + codcli + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtclie.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtclie.Codmes + 1
      X-CODANO = estavtas.evtclie.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtclie.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtclie.Codmes,"99") + "/" + STRING(estavtas.evtclie.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtclie.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtclie.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtclie.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtclie.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtclie.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtclie.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtclie.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtclie.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtclie.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtclie.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtclie.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtclie.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtclie.canalventa + '|'.
     END.
     IF TOGGLE-CodCli = YES THEN DO:
         ASSIGN
             x-Canal = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''.
         IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtclie.codcli + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtclie.codcli + '|'.
             x-Llave = x-Llave + estavtas.evtclie.codunico + '|'.
             x-Llave = x-Llave + estavtas.evtclie.sede + '|'.
         END.
         FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = estavtas.evtclie.codcli
              NO-LOCK NO-ERROR.
         IF AVAILABLE gn-clie THEN DO:
             ASSIGN
                 x-Canal = gn-clie.canal
                 x-CodDept = gn-clie.coddept
                 x-CodProv = gn-clie.codprov
                 x-CodDist = gn-clie.coddist.
             /* CANAL CLIENTE */
             FIND almtabla WHERE almtabla.Tabla = 'CN' 
                AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
             IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
             ELSE x-Canal = x-Canal + ' - '.
             /* DEPARTAMENTO */
             FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
             /* PROVINCIA */
             FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept
                 AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
             /* DISTRITO */
             FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept
                 AND Tabdistr.Codprovi = x-codprov
                 AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
             /* ******* */
             IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
             ELSE x-CodDept = x-CodDept + ' - '.
             IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
             ELSE x-CodProv = x-CodProv + ' - '.
             IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
             ELSE x-CodDist = x-CodDist + ' - '.
         END.
         IF x-Llave = '' THEN x-Llave = x-canal + '|'.
         ELSE x-Llave = x-Llave + x-canal + '|'.
         x-Llave = x-Llave + x-coddept + '|'.
         x-Llave = x-Llave + x-codprov + '|'.
         x-Llave = x-Llave + x-coddist + '|'.
         x-Llave = x-Llave + estavtas.evtclie.zona + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Clientes-Articulos W-Win 
PROCEDURE Carga-Clientes-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtclarti NO-LOCK WHERE estavtas.evtclarti.codcia = s-codcia
    AND estavtas.evtclarti.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtclarti.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    /*AND codmat = '019934'*/
    AND estavtas.evtclarti.coddiv BEGINS x-CodDiv
    AND estavtas.evtclarti.codcli BEGINS x-CodCli,
    FIRST Almmmatg OF estavtas.evtclarti NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' CLIENTE ' + codcli + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    T-StkAct  = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtclarti.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtclarti.Codmes + 1
      X-CODANO = estavtas.evtclarti.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtclarti.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtclarti.Codmes,"99") + "/" + STRING(estavtas.evtclarti.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtclarti.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtclarti.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtclarti.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtclarti.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtclarti.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtclarti.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtclarti.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtclarti.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtclarti.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtclarti.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtclarti.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtclarti.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtclarti.canalventa + '|'.
     END.
     IF TOGGLE-CodCli = YES THEN DO:
         ASSIGN
             x-Canal = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''.
         IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtclarti.codcli + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtclarti.codcli + '|'.
             x-Llave = x-Llave + estavtas.evtclarti.codunico + '|'.
             x-Llave = x-Llave + estavtas.evtclarti.sede + '|'.
         END.
         FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = estavtas.evtclarti.codcli
              NO-LOCK NO-ERROR.
         IF AVAILABLE gn-clie THEN DO:
             ASSIGN
                 x-Canal = gn-clie.canal
                 x-CodDept = gn-clie.coddept
                 x-CodProv = gn-clie.codprov
                 x-CodDist = gn-clie.coddist.
         END.
         /* CANAL CLIENTE */
         FIND almtabla WHERE almtabla.Tabla = 'CN' 
            AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
         IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
         ELSE x-Canal = x-Canal + ' - '.
         /* DEPARTAMENTO */
         FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
         /* PROVINCIA */
         FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept
             AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
         /* DISTRITO */
         FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept
             AND Tabdistr.Codprovi = x-codprov
             AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
         /* ******* */
         IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
         ELSE x-CodDept = x-CodDept + ' - '.
         IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
         ELSE x-CodProv = x-CodProv + ' - '.
         IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
         ELSE x-CodDist = x-CodDist + ' - '.
         /* CANAL */
         IF x-Llave = '' THEN x-Llave = x-canal + '|'.
         ELSE x-Llave = x-Llave + x-canal + '|'.
         x-Llave = x-Llave + x-coddept + '|'.
         x-Llave = x-Llave + x-codprov + '|'.
         x-Llave = x-Llave + x-coddist + '|'.
         x-Llave = x-Llave + estavtas.evtclarti.zona + '|'.
     END.
     IF TOGGLE-CodMat = YES THEN DO:
         IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtclarti.codmat + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtclarti.codmat + '|'.
             x-Llave = x-Llave + almmmatg.codfam + '|'.
             x-Llave = x-Llave + almmmatg.subfam + '|'.
             x-Llave = x-Llave + almmmatg.desmar + '|'.
             x-Llave = x-Llave + almmmatg.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.codfam + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.codfam + '|'.
                 x-Llave = x-Llave + almmmatg.subfam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.desmar + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + almmmatg.licencia[1] + '|'.
     END.
     /* 29.09.10 agregamos stock contable a la fecha */
     IF TOGGLE-CodMat = YES AND (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
         FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
             AND AlmStkGe.codmat = estavtas.evtclarti.codmat
             AND AlmStkGe.fecha <= TODAY
             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmStkGe THEN t-StkAct = AlmStkge.StkAct.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn
         tmp-detalle.StkAct    = t-StkAct.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divisiones W-Win 
PROCEDURE Carga-Divisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtdivi NO-LOCK WHERE estavtas.evtdivi.codcia = s-codcia
    AND estavtas.evtdivi.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtdivi.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtdivi.coddiv BEGINS x-CodDiv:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtdivi.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtdivi.Codmes + 1
      X-CODANO = estavtas.evtdivi.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtdivi.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtdivi.Codmes,"99") + "/" + STRING(estavtas.evtdivi.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtdivi.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtdivi.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtdivi.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtdivi.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtdivi.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtdivi.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtdivi.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtdivi.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtdivi.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtdivi.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtdivi.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtdivi.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtdivi.canalventa + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Pagos W-Win 
PROCEDURE Carga-Pagos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtfpgo NO-LOCK WHERE estavtas.evtfpgo.codcia = s-codcia
    AND estavtas.evtfpgo.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtfpgo.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtfpgo.coddiv BEGINS x-CodDiv
    AND estavtas.evtfpgo.fmapgo BEGINS x-FmaPgo:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' CONDICION ' + fmapgo + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtfpgo.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtfpgo.Codmes + 1
      X-CODANO = estavtas.evtfpgo.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtfpgo.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtfpgo.Codmes,"99") + "/" + STRING(estavtas.evtfpgo.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtfpgo.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtfpgo.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtfpgo.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtfpgo.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtfpgo.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtfpgo.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtfpgo.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtfpgo.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtfpgo.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtfpgo.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtfpgo.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtfpgo.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtfpgo.canalventa + '|'.
     END.
     IF TOGGLE-FmaPgo = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtfpgo.fmapgo + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtfpgo.fmapgo + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Proveedores W-Win 
PROCEDURE Carga-Proveedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtprov NO-LOCK WHERE estavtas.evtprov.codcia = s-codcia
    AND estavtas.evtprov.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtprov.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtprov.coddiv BEGINS x-CodDiv
    AND estavtas.evtprov.codpro BEGINS x-CodPro:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' PROVEEDOR ' + codpro + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtprov.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtprov.Codmes + 1
      X-CODANO = estavtas.evtprov.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtprov.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtprov.Codmes,"99") + "/" + STRING(estavtas.evtprov.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtprov.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtprov.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtprov.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtprov.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtprov.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtprov.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtprov.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtprov.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtprov.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtprov.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtprov.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtprov.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtprov.canalventa + '|'.
     END.
     IF TOGGLE-CodPro = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtprov.codpro + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtprov.codpro + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tarjetas W-Win 
PROCEDURE Carga-Tarjetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtcard NO-LOCK WHERE estavtas.evtcard.codcia = s-codcia
    AND estavtas.evtcard.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtcard.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtcard.coddiv BEGINS x-CodDiv
    AND estavtas.evtcard.codcli BEGINS x-CodCli
    AND estavtas.evtcard.nrocard BEGINS x-NroCard:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' CLIENTE ' + codcli + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtcard.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtcard.Codmes + 1
      X-CODANO = estavtas.evtcard.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtcard.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtcard.Codmes,"99") + "/" + STRING(estavtas.evtcard.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtcard.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtcard.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtcard.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtcard.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtcard.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtcard.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtcard.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtcard.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtcard.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtcard.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtcard.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtcard.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtcard.canalventa + '|'.
     END.
     IF TOGGLE-CodCli = YES THEN DO:
         ASSIGN
             x-Canal = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''.
         IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtcard.codcli + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtcard.codcli + '|'.
             x-Llave = x-Llave + estavtas.evtcard.codunico + '|'.
             x-Llave = x-Llave + estavtas.evtcard.sede + '|'.
         END.
         FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = estavtas.evtcard.codcli
              NO-LOCK NO-ERROR.
         IF AVAILABLE gn-clie THEN DO:
             ASSIGN
                 x-Canal = gn-clie.canal
                 x-CodDept = gn-clie.coddept
                 x-CodProv = gn-clie.codprov
                 x-CodDist = gn-clie.coddist.
             /* CANAL CLIENTE */
             FIND almtabla WHERE almtabla.Tabla = 'CN' 
                AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
             IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
             ELSE x-Canal = x-Canal + ' - '.
             /* DEPARTAMENTO */
             FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
             /* PROVINCIA */
             FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept
                 AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
             /* DISTRITO */
             FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept
                 AND Tabdistr.Codprovi = x-codprov
                 AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
             /* ******* */
             IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
             ELSE x-CodDept = x-CodDept + ' - '.
             IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
             ELSE x-CodProv = x-CodProv + ' - '.
             IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
             ELSE x-CodDist = x-CodDist + ' - '.
         END.
         IF x-Llave = '' THEN x-Llave = x-canal + '|'.
         ELSE x-Llave = x-Llave + x-canal + '|'.
         x-Llave = x-Llave + x-coddept + '|'.
         x-Llave = x-Llave + x-codprov + '|'.
         x-Llave = x-Llave + x-coddist + '|'.
         x-Llave = x-Llave + estavtas.evtcard.zona + '|'.
     END.
     IF TOGGLE-NroCard = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtcard.nrocard + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtcard.nrocard + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH tmp-detalle:
    DELETE tmp-detalle.
END.
/* CARGA LOG DE CONTROL */
CREATE LogTabla.
ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'ESTADISTICA'
    logtabla.Usuario = s-user-id.
    logtabla.ValorLlave = STRING (TOGGLE-CodDiv) + '|' + COMBO-BOX-CodDiv + '|' + STRING (TOGGLE-CodCli) + '|' +
        FILL-IN-CodCli + '|' + STRING (TOGGLE-Resumen-Depto) + '|' + STRING (TOGGLE-CodMat) + '|' +
        COMBO-BOX-CodFam + '|' + STRING (TOGGLE-Resumen-Linea) + '|' + COMBO-BOX-SubFam + '|' +
        STRING (TOGGLE-Resumen-Marca) + '|' + STRING (TOGGLE-CodPro) + '|' + FILL-IN-CodPro + '|' +
        STRING (TOGGLE-CodVen) + '|' + FILL-IN-Codven + '|' + STRING (TOGGLE-FmaPgo) + '|' +
        COMBO-BOX-FmaPgo + '|' + STRING (TOGGLE-NroCard) + '|' + FILL-IN-NroCard + '|' +
        STRING (DesdeF) + '|' + STRING (HastaF) + '|' + STRING (RADIO-SET-Tipo).
RELEASE LogTabla.

/* INFORMACION RESUMIDA */

ASSIGN
    x-CodDiv = ''
    x-CodCli = ''
    x-CodPro = ''
    x-CodVen = ''
    x-FmaPgo = ''
    x-CodFam = ''
    x-SubFam = ''
    x-NroCard = ''.
IF TOGGLE-CodDiv AND NOT COMBO-BOX-CodDiv BEGINS 'Todos' THEN x-CodDiv = ENTRY(1, COMBO-BOX-CodDiv, ' - ').
IF TOGGLE-CodCli THEN x-CodCli = FILL-IN-CodCli.
IF TOGGLE-CodMat AND NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF TOGGLE-CodMat AND NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').
IF TOGGLE-CodPro THEN x-CodPro = FILL-IN-CodPro.
IF TOGGLE-CodVen THEN x-CodVen = FILL-IN-CodVen.
IF TOGGLE-FmaPgo AND NOT COMBO-BOX-FmaPgo BEGINS 'Todos' THEN x-FmaPgo = ENTRY(1, COMBO-BOX-FmaPgo, ' - ').
IF TOGGLE-NroCard THEN x-NroCard = FILL-IN-NroCard.

/* RUTINAS ESPECIFICAS */
/* SELECCION SIMPLE */
IF TOGGLE-CodDiv = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Divisiones.
    RETURN.
END.
IF TOGGLE-CodCli = YES 
    AND (TOGGLE-CodDiv OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Clientes.
    RETURN.
END.
IF (TOGGLE-CodCli AND TOGGLE-CodDiv) = YES 
    AND (TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Clientes.
    RETURN.
END.
IF TOGGLE-CodMat = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodDiv OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Articulos.
    RETURN.
END.
IF (TOGGLE-CodMat AND TOGGLE-CodDiv) = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Articulos-Divisiones.
    RETURN.
END.
IF TOGGLE-CodPro = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodDiv OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Proveedores.
    RETURN.
END.
IF (TOGGLE-CodPro AND TOGGLE-CodDiv) = YES
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Proveedores.
    RETURN.
END.
IF TOGGLE-CodVen = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodDiv OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Vendedores.
    RETURN.
END.
IF (TOGGLE-CodVen AND TOGGLE-CodDiv) = YES
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Vendedores.
    RETURN.
END.
IF TOGGLE-FmaPgo = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodDiv OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Pagos.
    RETURN.
END.
IF (TOGGLE-FmaPgo AND TOGGLE-CodDiv) = YES
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Pagos.
    RETURN.
END.
IF TOGGLE-NroCard = YES 
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodDiv OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo) = NO THEN DO:
    RUN Carga-Tarjetas.
    RETURN.
END.
IF (TOGGLE-NroCard AND TOGGLE-CodDiv) = YES
    AND (TOGGLE-CodCli OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo) = NO THEN DO:
    RUN Carga-Tarjetas.
    RETURN.
END.
IF (TOGGLE-NroCard AND TOGGLE-CodCli) = YES
    AND (TOGGLE-CodDiv OR 
         TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo) = NO THEN DO:
    RUN Carga-Tarjetas.
    RETURN.
END.
IF (TOGGLE-NroCard AND TOGGLE-CodDiv AND TOGGLE-CodCli) = YES
    AND (TOGGLE-CodMat OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo) = NO THEN DO:
    RUN Carga-Tarjetas.
    RETURN.
END.
/* SELECCION MULTIPLE */
IF (TOGGLE-CodCli AND TOGGLE-CodMat) = YES 
    AND (TOGGLE-CodDiv OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Clientes-Articulos.
    RETURN.
END.
IF (TOGGLE-CodCli AND TOGGLE-CodMat AND TOGGLE-CodDiv) = YES 
    AND (TOGGLE-CodPro OR 
         TOGGLE-CodVen OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Clientes-Articulos.
    RETURN.
END.
IF (TOGGLE-CodMat AND TOGGLE-CodVen) = YES 
    AND (TOGGLE-CodDiv OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodCli OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Articulos-Vendedores.
    RETURN.
END.
IF (TOGGLE-CodMat AND TOGGLE-CodVen AND TOGGLE-CodDiv) = YES 
    AND (TOGGLE-CodPro OR 
         TOGGLE-CodCli OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Articulos-Vendedores.
    RETURN.
END.
IF (TOGGLE-CodCli AND TOGGLE-CodVen) = YES 
    AND (TOGGLE-CodDiv OR 
         TOGGLE-CodPro OR 
         TOGGLE-CodMat OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Vendedores-Clientes.
    RETURN.
END.
IF (TOGGLE-CodCli AND TOGGLE-CodVen AND TOGGLE-CodDiv) = YES 
    AND (TOGGLE-CodPro OR 
         TOGGLE-CodMat OR 
         TOGGLE-FmaPgo OR 
         TOGGLE-NroCard) = NO THEN DO:
    RUN Carga-Vendedores-Clientes.
    RETURN.
END.

/* RUTINA GENERAL */
SESSION:SET-WAIT-STATE('').
MESSAGE 'El reporte puede demorar en procesar' SKIP
    'Continuamos?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH estavtas.evtall01 NO-LOCK WHERE estavtas.evtall01.codcia = s-codcia
    AND estavtas.evtall01.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtall01.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtall01.coddiv BEGINS x-CodDiv
    AND estavtas.evtall01.codcli BEGINS x-CodCli
    AND estavtas.evtall01.codpro BEGINS x-CodPro
    AND estavtas.evtall01.codven BEGINS x-CodVen
    AND estavtas.evtall01.fmapgo BEGINS x-FmaPgo
    AND estavtas.evtall01.nrocard BEGINS x-NroCard,
    FIRST Almmmatg OF estavtas.evtall01 NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.subfam BEGINS x-SubFam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' CLIENTE ' + codcli + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    T-StkAct  = 0.

    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtall01.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtall01.Codmes + 1
      X-CODANO = estavtas.evtall01.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtall01.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtall01.Codmes,"99") + "/" + STRING(estavtas.evtall01.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtall01.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtall01.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtall01.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtall01.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtall01.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtall01.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtall01.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtall01.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtall01.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtall01.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtall01.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtall01.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtall01.canalventa + '|'.
     END.
     IF TOGGLE-CodCli = YES THEN DO:
         ASSIGN
             x-Canal = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''.
         IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtall01.codcli + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtall01.codcli + '|'.
             x-Llave = x-Llave + estavtas.evtall01.codunico + '|'.
             x-Llave = x-Llave + estavtas.evtall01.sede + '|'.
         END.
         FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = estavtas.evtall01.codcli
              NO-LOCK NO-ERROR.
         IF AVAILABLE gn-clie THEN DO:
             ASSIGN
                 x-Canal = gn-clie.canal
                 x-CodDept = gn-clie.coddept
                 x-CodProv = gn-clie.codprov
                 x-CodDist = gn-clie.coddist.
         END.
         /* CANAL CLIENTE */
         FIND almtabla WHERE almtabla.Tabla = 'CN' 
            AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
         IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
         ELSE x-Canal = x-Canal + ' - '.
         /* DEPARTAMENTO */
         FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
         /* PROVINCIA */
         FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept
             AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
         /* DISTRITO */
         FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept
             AND Tabdistr.Codprovi = x-codprov
             AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
         /* ******* */
         IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
         ELSE x-CodDept = x-CodDept + ' - '.
         IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
         ELSE x-CodProv = x-CodProv + ' - '.
         IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
         ELSE x-CodDist = x-CodDist + ' - '.
         /* CANAL */
         IF x-Llave = '' THEN x-Llave = x-canal + '|'.
         ELSE x-Llave = x-Llave + x-canal + '|'.
         x-Llave = x-Llave + x-coddept + '|'.
         x-Llave = x-Llave + x-codprov + '|'.
         x-Llave = x-Llave + x-coddist + '|'.
         x-Llave = x-Llave + estavtas.evtall01.zona + '|'.
     END.
     IF TOGGLE-CodMat = YES THEN DO:
         IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtall01.codmat + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtall01.codmat + '|'.
             x-Llave = x-Llave + almmmatg.codfam + '|'.
             x-Llave = x-Llave + almmmatg.subfam + '|'.
             x-Llave = x-Llave + almmmatg.desmar + '|'.
             x-Llave = x-Llave + almmmatg.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.codfam + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.codfam + '|'.
                 x-Llave = x-Llave + almmmatg.subfam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.desmar + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + almmmatg.licencia[1] + '|'.
     END.
     IF TOGGLE-CodPro = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtall01.codpro + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtall01.codpro + '|'.
     END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtall01.codven + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtall01.codven + '|'.
     END.
     IF TOGGLE-FmaPgo = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtall01.fmapgo + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtall01.fmapgo + '|'.
     END.
     IF TOGGLE-NroCard = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtall01.nrocard + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtall01.nrocard + '|'.
     END.
     /* 29.09.10 agregamos stock contable a la fecha */
     IF TOGGLE-CodMat = YES AND (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
         FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
             AND AlmStkGe.codmat = estavtas.evtall01.codmat
             AND AlmStkGe.fecha <= TODAY
             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmStkGe THEN t-StkAct = AlmStkge.StkAct.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn
         tmp-detalle.StkAct    = t-StkAct.
END.
SESSION:SET-WAIT-STATE('GENERAL').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Vendedores W-Win 
PROCEDURE Carga-Vendedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtven NO-LOCK WHERE estavtas.evtven.codcia = s-codcia
    AND estavtas.evtven.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtven.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtven.coddiv BEGINS x-CodDiv
    AND estavtas.evtven.codven BEGINS x-CodVen:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' VENDEDOR ' + codven + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtven.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtven.Codmes + 1
      X-CODANO = estavtas.evtven.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtven.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtven.Codmes,"99") + "/" + STRING(estavtas.evtven.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtven.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtven.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtven.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtven.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtven.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtven.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtven.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtven.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtven.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtven.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtven.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtven.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtven.canalventa + '|'.
     END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtven.codven + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtven.codven + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Vendedores-Clientes W-Win 
PROCEDURE Carga-Vendedores-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH estavtas.evtvencli NO-LOCK WHERE estavtas.evtvencli.codcia = s-codcia
    AND estavtas.evtvencli.nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
    AND estavtas.evtvencli.nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))
    AND estavtas.evtvencli.coddiv BEGINS x-CodDiv
    AND estavtas.evtvencli.codcli BEGINS x-CodCli
    AND estavtas.evtvencli.codven BEGINS x-CodVen:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + 
        'MES ' + STRING(codmes, '99') + ' AÑO ' + STRING(codano, '9999') +
        ' DIVISION ' + coddiv + ' VENDEDOR ' + codven + ' **'.
    T-Vtamn   = 0.
    T-Vtame   = 0.
    T-Ctomn   = 0.
    T-Ctome   = 0.
    T-Promn   = 0.
    T-Prome   = 0.
    T-Sdome   = 0.
    T-Sdomn   = 0.
    F-Salida  = 0.
    x-Llave = ''.
    /*****************Capturando el Mes siguiente *******************/
    IF estavtas.evtvencli.Codmes < 12 THEN DO:
      ASSIGN
      X-CODMES = estavtas.evtvencli.Codmes + 1
      X-CODANO = estavtas.evtvencli.Codano .
    END.
    ELSE DO: 
      ASSIGN
      X-CODMES = 01
      X-CODANO = estavtas.evtvencli.Codano + 1 .
    END.
    /**********************************************************************/

    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.evtvencli.Codmes,"99") + "/" + STRING(estavtas.evtvencli.Codano,"9999")).
          IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
              F-Salida  = F-Salida  + estavtas.evtvencli.CanxDia[I].
              T-Vtamn   = T-Vtamn   + estavtas.evtvencli.Vtaxdiamn[I].
              T-Vtame   = T-Vtame   + estavtas.evtvencli.Vtaxdiame[I].
              T-Ctomn   = T-Ctomn   + estavtas.evtvencli.Ctoxdiamn[I].
              T-Ctome   = T-Ctome   + estavtas.evtvencli.Ctoxdiame[I].
              T-Promn   = T-Promn   + estavtas.evtvencli.Proxdiamn[I].
              T-Prome   = T-Prome   + estavtas.evtvencli.Proxdiame[I].
          END.
     END.     
     /* ARMAMOS LA LLAVE */
     /* LLAVE INICIAL */
     IF RADIO-SET-Tipo = 2 THEN DO:
         IF x-Llave = '' THEN x-Llave = STRING(estavtas.evtvencli.codano, '9999') + '|'.
         ELSE x-Llave = x-LLave + STRING(estavtas.evtvencli.codano, '9999') + '|'.
         x-Mes = ENTRY(estavtas.evtvencli.codmes, x-Meses).
         x-Mes = STRING(codmes, '99').
         IF x-Llave = '' THEN x-Llave = x-Mes + '|'.
         ELSE x-Llave = x-LLave + x-Mes + '|'.
     END.
     IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtvencli.coddiv + '|'.
         ELSE x-Llave = x-LLave + estavtas.evtvencli.coddiv + '|'.
         x-LLave = x-Llave + estavtas.evtvencli.canalventa + '|'.
     END.
     IF TOGGLE-CodCli = YES THEN DO:
         ASSIGN
             x-Canal = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''.
         IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = estavtas.evtvencli.codcli + '|'.
             ELSE x-Llave = x-Llave + estavtas.evtvencli.codcli + '|'.
             x-Llave = x-Llave + estavtas.evtvencli.codunico + '|'.
             x-Llave = x-Llave + estavtas.evtvencli.sede + '|'.
         END.
         FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = estavtas.evtvencli.codcli
              NO-LOCK NO-ERROR.
         IF AVAILABLE gn-clie THEN DO:
             ASSIGN
                 x-Canal = gn-clie.canal
                 x-CodDept = gn-clie.coddept
                 x-CodProv = gn-clie.codprov
                 x-CodDist = gn-clie.coddist.
             /* CANAL CLIENTE */
             FIND almtabla WHERE almtabla.Tabla = 'CN' 
                AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
             IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
             ELSE x-Canal = x-Canal + ' - '.
             /* DEPARTAMENTO */
             FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
             /* PROVINCIA */
             FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept
                 AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
             /* DISTRITO */
             FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept
                 AND Tabdistr.Codprovi = x-codprov
                 AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
             /* ******* */
             IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
             ELSE x-CodDept = x-CodDept + ' - '.
             IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
             ELSE x-CodProv = x-CodProv + ' - '.
             IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
             ELSE x-CodDist = x-CodDist + ' - '.
         END.
         IF x-Llave = '' THEN x-Llave = x-canal + '|'.
         ELSE x-Llave = x-Llave + x-canal + '|'.
         x-Llave = x-Llave + x-coddept + '|'.
         x-Llave = x-Llave + x-codprov + '|'.
         x-Llave = x-Llave + x-coddist + '|'.
         x-Llave = x-Llave + estavtas.evtvencli.zona + '|'.
     END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = estavtas.evtvencli.codven + '|'.
         ELSE x-Llave = x-Llave + estavtas.evtvencli.codven + '|'.
     END.
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + f-Salida
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + T-Vtame
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + T-Vtamn
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + T-Ctome
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + T-Ctomn
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + T-Prome
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + T-Promn.
END.

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
  DISPLAY TOGGLE-CodDiv COMBO-BOX-CodDiv TOGGLE-CodCli FILL-IN-CodCli 
          FILL-IN-NomCli TOGGLE-Resumen-Depto TOGGLE-CodMat COMBO-BOX-CodFam 
          TOGGLE-Resumen-Linea COMBO-BOX-SubFam TOGGLE-Resumen-Marca 
          TOGGLE-CodPro FILL-IN-CodPro FILL-IN-NomPro TOGGLE-CodVen 
          FILL-IN-CodVen FILL-IN-NomVen TOGGLE-FmaPgo COMBO-BOX-FmaPgo 
          TOGGLE-NroCard FILL-IN-NroCard FILL-IN-NomCard DesdeF HastaF 
          RADIO-SET-Tipo FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE TOGGLE-CodDiv TOGGLE-CodCli TOGGLE-CodMat TOGGLE-CodPro TOGGLE-CodVen 
         TOGGLE-FmaPgo TOGGLE-NroCard DesdeF HastaF BUTTON-1 BtnDone 
         RADIO-SET-Tipo 
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
DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR i-Campo AS INT INIT 1 NO-UNDO.
DEF VAR x-Campo AS CHAR NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(500)' NO-UNDO.
DEF VAR l-Titulo AS LOG INIT NO NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
FOR EACH tmp-detalle:
    i-Campo = 1.
    x-LLave = ''.
    x-Campo = ''.
    x-Titulo = ''.
    IF RADIO-SET-Tipo = 2 THEN DO:
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'PERIODO' + '|'.
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'MES' + '|'.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        /* DIVISION */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = x-Campo
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN x-Llave = TRIM(x-Llave) + ' - ' + TRIM(GN-DIVI.DesDiv).
        ELSE x-Llave = TRIM(x-Llave) + ' - '.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'DIVISION' + '|'.
        /* CANAL VENTA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-LLave = x-LLave + x-Campo.
        FIND vtamcanal WHERE Vtamcanal.Codcia = s-codcia
            AND Vtamcanal.CanalVenta = x-Campo
            NO-LOCK NO-ERROR.
        IF AVAILABLE vtamcanal 
        THEN x-Llave = x-Llave + ' - ' + TRIM(Vtamcanal.Descrip).
        ELSE x-Llave = x-Llave + 'SIN CANAL'.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        x-Titulo = x-Titulo + 'CANAL-VENTA' + '|'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        /* CLIENTE */
        IF TOGGLE-Resumen-Depto = NO THEN DO:
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = x-Campo
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN x-Llave = x-Llave + ' - ' + TRIM( SUBSTRING (gn-clie.nomcli, 1, 60 ) ).
            ELSE x-Llave = x-Llave + ' - ' .
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'CLIENTE' + '|'. ELSE x-Titulo = x-Titulo + 'CLIENTE' + '|'.
            /* CODIGO UNICO */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = x-Campo
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN x-Llave = x-LLave + ' - ' + TRIM( SUBSTRING (gn-clie.nomcli, 1, 60 ) ).
            ELSE x-Llave = x-LLave + ' - '.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'CLIENTE-UNIFICADO' + '|'. ELSE x-Titulo = x-Titulo + 'CLIENTE-UNIFICADO' + '|'.
            /* SEDE */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                AND gn-clied.sede = x-Campo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN x-LLave = x-Llave + ' - ' + TRIM(gn-clied.dircli).
            ELSE x-LLave = x-Llave + ' - '.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'SEDE' + '|'. ELSE x-Titulo = x-Titulo + 'SEDE' + '|'.
        END.
        /* CANAL DEL CLIENTE */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-LLave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'CANAL-CLIENTE' + '|'. ELSE x-Titulo = x-Titulo + 'CANAL-CLIENTE' + '|'.
        /* DEPARTAMENTO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'DEPARTAMENTO' + '|'. ELSE x-Titulo = x-Titulo + 'DEPARTAMENTO' + '|'.
        /* PROVINCIA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'PROVINCIA' + '|'. ELSE x-Titulo = x-Titulo + 'PROVINCIA' + '|'.
        /* DISTRITO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        IF x-Titulo = '' THEN x-Titulo = 'DISTRITO' + '|'. ELSE x-Titulo = x-Titulo + 'DISTRITO' + '|'.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        /* ZONA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        FIND FacTabla WHERE FacTabla.CodCia = s-codcia
            AND FacTabla.Tabla = 'ZN'
            AND FacTabla.Codigo = x-Campo NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN x-LLave = x-Llave + ' - ' + TRIM(FacTabla.Nombre).
        ELSE x-LLave = x-Llave + ' - '.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'ZONA' + '|'. ELSE x-Titulo = x-Titulo + 'ZONA' + '|'.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        /* ARTICULO */
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = x-Campo
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN x-Llave = x-LLave + ' - ' + TRIM(Almmmatg.desmat).
            ELSE x-Llave = x-LLave + ' - '.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'ARTICULO' + '|'. ELSE x-Titulo = x-Titulo + 'ARTICULO' + '|'.
            /* LINEA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND Almtfami WHERE Almtfami.codcia = s-codcia
                AND Almtfami.codfam = x-Campo
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtfami THEN x-Llave = x-Llave + ' - ' + TRIM(Almtfami.desfam).
            ELSE x-Llave = x-Llave + ' - '.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'LINEA' + '|'.
            /* SUB-LINEA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            IF AVAILABLE Almtfami THEN DO:
                FIND Almsfami WHERE Almsfami.codcia = s-codcia
                    AND Almsfami.codfam = ALmtfami.codfam
                    AND ALmsfami.subfam = x-Campo
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almsfami THEN x-Llave = x-Llave + ' - ' + TRIM(AlmSFami.dessub).
                ELSE x-Llave = x-Llave + ' - '.
            END.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'SUB-LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'SUB-LINEA' + '|'.
            /* MARCA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'MARCA' + '|'. ELSE x-Titulo = x-Titulo + 'MARCA' + '|'.
            /* UNIDAD */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'UNIDAD' + '|'. ELSE x-Titulo = x-Titulo + 'UNIDAD' + '|'.
            /* LICENCIA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND almtabla WHERE almtabla.Tabla = "LC" 
                AND almtabla.Codigo = x-Campo NO-LOCK NO-ERROR.
            IF AVAILABLE Almtabla THEN x-Llave = x-Llave + ' - ' + TRIM(almtabla.Nombre).
            ELSE x-Llave = x-Llave + ' - '.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'LICENCIA' + '|'. ELSE x-Titulo = x-Titulo + 'LICENCIA' + '|'.
        END.
        ELSE DO:
            IF TOGGLE-Resumen-Linea = YES THEN DO:
                /* LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                FIND Almtfami WHERE Almtfami.codcia = s-codcia
                    AND Almtfami.codfam = x-Campo
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtfami THEN x-Llave = x-Llave + ' - ' + TRIM(Almtfami.desfam).
                ELSE x-Llave = x-Llave + ' - '.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'LINEA' + '|'.
                /* SUB-LINEA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                IF AVAILABLE Almtfami THEN DO:
                    FIND Almsfami WHERE Almsfami.codcia = s-codcia
                        AND Almsfami.codfam = ALmtfami.codfam
                        AND ALmsfami.subfam = x-Campo
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almsfami THEN x-Llave = x-Llave + ' - ' + TRIM(AlmSFami.dessub).
                    ELSE x-Llave = x-Llave + ' - '.
                END.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'SUB-LINEA' + '|'. ELSE x-Titulo = x-Titulo + 'SUB-LINEA' + '|'.
            END.
            IF TOGGLE-Resumen-Marca = YES THEN DO:
                /* MARCA */
                x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
                x-Llave = x-Llave + x-Campo.
                x-Llave = x-LLave + '|'.
                i-Campo = i-Campo + 1.
                IF x-Titulo = '' THEN x-Titulo = 'MARCA' + '|'. ELSE x-Titulo = x-Titulo + 'MARCA' + '|'.
            END.
            /* LICENCIA */
            x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
            x-Llave = x-Llave + x-Campo.
            FIND almtabla WHERE almtabla.Tabla = "LC" 
                AND almtabla.Codigo = x-Campo NO-LOCK NO-ERROR.
            IF AVAILABLE Almtabla THEN x-Llave = x-Llave + ' - ' + TRIM(almtabla.Nombre).
            ELSE x-Llave = x-Llave + ' - '.
            x-Llave = x-LLave + '|'.
            i-Campo = i-Campo + 1.
            IF x-Titulo = '' THEN x-Titulo = 'LICENCIA' + '|'. ELSE x-Titulo = x-Titulo + 'LICENCIA' + '|'.
        END.
    END.
    IF TOGGLE-CodPro = YES THEN DO:
        /* PROVEEDOR */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = x-Campo
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN x-Llave = x-LLave + ' - ' + TRIM(gn-prov.NomPro).
        ELSE x-Llave = x-LLave + ' - '.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'PROVEEDOR' + '|'. ELSE x-Titulo = x-Titulo + 'PROVEEDOR' + '|'.
    END.
    IF TOGGLE-CodVen = YES THEN DO:
        /* VENDEDOR */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = x-Campo
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-Llave = x-LLave + ' - ' + TRIM(gn-ven.NomVen).
        ELSE x-Llave = x-LLave + ' - '.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'VENDEDOR' + '|'. ELSE x-Titulo = x-Titulo + 'VENDEDOR' + '|'.
    END.
    IF TOGGLE-FmaPgo = YES THEN DO:
        /* FORMA DE PAGO */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        FIND gn-convt WHERE gn-convt.codig = x-Campo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN x-Llave = x-LLave + ' - ' + TRIM(gn-ConVt.Nombr).
        ELSE x-Llave = x-LLave + ' - '.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'FORMA-PAGO' + '|'. ELSE x-Titulo = x-Titulo + 'FORMA-PAGO' + '|'.
    END.
    IF TOGGLE-NroCard = YES THEN DO:
        /* TARJETA */
        x-Campo = ENTRY(i-Campo, tmp-detalle.Llave, '|').
        x-Llave = x-Llave + x-Campo.
        FIND gn-card WHERE gn-card.nrocard = x-Campo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-card THEN x-Llave = x-LLave + ' - ' + TRIM(gn-card.NomClie[1]).
        ELSE x-Llave = x-LLave + ' - '.
        x-Llave = x-LLave + '|'.
        i-Campo = i-Campo + 1.
        IF x-Titulo = '' THEN x-Titulo = 'TARJETA' + '|'. ELSE x-Titulo = x-Titulo + 'TARJETA' + '|'.
    END.
    x-Titulo = x-Titulo + 'CANTIDAD' + '|' + 'VENTA-DOLARES' + '|' + 'VENTA-SOLES' + '|'+ ' '.
    x-Llave = x-Llave + STRING(tmp-detalle.CanxMes, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(tmp-detalle.VtaxMesMe, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(tmp-detalle.VtaxMesMn, '->>>>>>>>9.99') + '|'.
    IF pParametro = '+COSTO' THEN DO:
        x-Titulo = x-Titulo + 'COSTO-DOLARES' + '|' + 'COSTO-SOLES' + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.CtoxMesMe, '->>>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.CtoxMesMn, '->>>>>>>>9.99') + '|'.
        x-Titulo = x-Titulo + 'PROMEDIO-DOLARES' + '|' + 'PROMEDIO-SOLES' + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.ProxMesMe, '->>>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.ProxMesMn, '->>>>>>>>9.99') + '|'.
    END.
    IF TOGGLE-CodMat = YES AND TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO THEN DO:
        x-Titulo = x-Titulo + 'STOCK-CONTABLE' + '|'.
        x-Llave = x-Llave + STRING(tmp-detalle.StkAct, '->>>>>>>>9.99') + '|'.
    END.
    x-Llave = x-Llave + ' ' .
    x-Titulo = x-Titulo + ' '.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
    IF l-Titulo = NO THEN DO:
        PUT STREAM REPORTE x-Titulo SKIP.
        l-Titulo = YES.
    END.
    PUT STREAM REPORTE x-LLave SKIP.

END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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
  ASSIGN
      DesdeF = TODAY - DAY(TODAY) + 1
      HastaF = TODAY.
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
      COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv) IN FRAME {&FRAME-NAME}.
  END.
  FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia:
      COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.
  FOR EACH gn-convt NO-LOCK:
      COMBO-BOX-FmaPgo:ADD-LAST(gn-convt.codig + ' - ' + gn-convt.nombr) IN FRAME {&FRAME-NAME}.
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
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

