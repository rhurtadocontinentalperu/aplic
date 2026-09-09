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

DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
 
def var l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE PTO       AS LOGICAL.

DEFINE VARIABLE F-TIPO   AS CHAR INIT "0".
DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE T-FAMILI AS CHAR INIT "".
DEFINE VARIABLE T-SUBFAM AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE L-SALIR  AS LOGICAL INIT NO.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE VARIABLE F-DIRDIV   AS CHAR.
DEFINE VARIABLE F-PUNTO    AS CHAR.
DEFINE VARIABLE X-PUNTO    AS CHAR.

DEFINE VAR X-TOT1 AS DECI.
DEFINE VAR X-TOT2 AS DECI.
DEFINE VAR X-TOT3 AS DECI.
DEFINE VAR X-TOT4 AS DECI.
DEFINE VAR X-TOTS1 AS DECI.
DEFINE VAR X-TOTS2 AS DECI.


DEFINE VAR X-SIGNO AS DECI.
DEFINE VAR X-NOMBRE AS CHAR.
DEFINE VAR X-TPOCMB AS DECI.
DEFINE VAR X-FLG AS LOGICAL.

DEFINE TEMP-TABLE tempo 
       FIELD CODCIA   LIKE CcbcDocu.Codcia
       FIELD CODDIV   LIKE CcbCdocu.Coddiv
       FIELD CODCLI   LIKE CcbCdocu.Codcli
       FIELD CODDOC   LIKE CcbCdocu.CodDoc
       FIELD NRODOC   LIKE CcbCdocu.NroDoc
       FIELD FCHDOC   LIKE Ccbcdocu.FchDoc
       FIELD NOMCLI   LIKE Ccbcdocu.Nomcli
       FIELD IMPTOT   LIKE Ccbcdocu.ImpTot
       FIELD IMPNAC   LIKE Ccbcdocu.ImpTot
       FIELD IMPUSA   LIKE Ccbcdocu.ImpTot
       FIELD CODMON   LIKE Ccbcdocu.Codmon
       FIELD NROCAR   LIKE Ccbcdocu.NroCar
       INDEX LLAVE01 CODCIA NROCAR FCHDOC CODDIV.

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
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-55 RECT-59 RECT-60 R-reporte ~
F-Division f-desde f-hasta RADIO-SET-Tipo x-NroCard F-unival x-MtoMin ~
f-TpoCmb B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS R-reporte F-Division f-desde f-hasta ~
RADIO-SET-Tipo x-NroCard F-unival x-MtoMin f-TpoCmb x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 10.57 BY 1.5.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 10.57 BY 1.5.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-TpoCmb AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "T.C." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-unival AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Valor Unitario en S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-MtoMin AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Monto Minimo S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE x-NroCard AS CHARACTER FORMAT "X(6)":U 
     LABEL "Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-reporte AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Listado General", 1,
"Solo Cancelados", 2,
"Solo Cancelados sin deuda", 3
     SIZE 22 BY 1.96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detalle", 1,
"Resumen", 2
     SIZE 12 BY 1.38 NO-UNDO.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.86 BY 1.85.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 2.19.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 7.62.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 2.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-reporte AT ROW 1.5 COL 36.72 NO-LABEL WIDGET-ID 12
     F-Division AT ROW 1.58 COL 12.86 WIDGET-ID 4
     f-desde AT ROW 2.35 COL 17 COLON-ALIGNED WIDGET-ID 2
     f-hasta AT ROW 3.12 COL 17 COLON-ALIGNED WIDGET-ID 6
     RADIO-SET-Tipo AT ROW 3.85 COL 36.57 NO-LABEL WIDGET-ID 16
     x-NroCard AT ROW 3.88 COL 17 COLON-ALIGNED WIDGET-ID 26
     F-unival AT ROW 4.65 COL 17 COLON-ALIGNED WIDGET-ID 10
     x-MtoMin AT ROW 5.42 COL 17 COLON-ALIGNED WIDGET-ID 24
     f-TpoCmb AT ROW 6.19 COL 17 COLON-ALIGNED WIDGET-ID 8
     x-mensaje AT ROW 7.65 COL 1.57 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     B-imprime AT ROW 9 COL 48 WIDGET-ID 30
     B-cancela AT ROW 9 COL 59 WIDGET-ID 28
     RECT-58 AT ROW 1.38 COL 36.14 WIDGET-ID 22
     RECT-55 AT ROW 3.58 COL 36 WIDGET-ID 20
     RECT-59 AT ROW 1.19 COL 2 WIDGET-ID 32
     RECT-60 AT ROW 8.81 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.72 BY 10.38
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Reporte de Ventas por Tarjeta"
         HEIGHT             = 10.38
         WIDTH              = 71.72
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

{src/adm-vm/method/vmviewer.i}
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
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Ventas por Tarjeta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Ventas por Tarjeta */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-cancela W-Win
ON CHOOSE OF B-cancela IN FRAME F-Main /* Cancelar */
DO:
  L-SALIR = YES.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime W-Win
ON CHOOSE OF B-imprime IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN R-reporte f-division f-desde f-hasta RADIO-SET-Tipo x-NroCard x-MtoMin
    f-unival f-tpocmb.

  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* División */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                       Gn-Divi.Coddiv = SELF:SCREEN-VALUE
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hasta W-Win
ON LEAVE OF f-hasta IN FRAME F-Main /* Hasta */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE GN-TCMB
  THEN DISPLAY gn-tcmb.venta @ f-tpocmb WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tempo:
        DELETE tempo.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle W-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
    Gn-Divi.Codcia = S-CODCIA AND
    Gn-Divi.CodDiv BEGINS F-Division:
    FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
        CcbCdocu.CodCia = S-CODCIA AND
        CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
        CCbCdocu.FchDoc >= f-desde AND 
        CcbCdocu.FchDoc <= f-hasta AND
        LOOKUP(TRIM(CcbCdocu.CodDoc),"FAC,BOL,N/C,TCK") > 0 AND 
        CcbCdocu.FlgEst <> "A" AND
        CcbCdocu.NroCard <> '' AND
        (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard)
        USE-INDEX LLAVE10:
        CREATE Tempo.
        ASSIGN
        Tempo.Codcia = S-CODCIA  
        Tempo.CodDiv = Ccbcdocu.CodDiv
        Tempo.CodDoc = Ccbcdocu.CodDoc
        Tempo.NroDoc = Ccbcdocu.NroDoc
        Tempo.fchDoc = Ccbcdocu.fchDoc
        Tempo.Codmon = Ccbcdocu.Codmon
        Tempo.Nomcli = Ccbcdocu.Nomcli
        Tempo.Codcli = Ccbcdocu.Codcli
        Tempo.NroCar = ccbcdocu.NroCar .
        IF Ccbcdocu.Codmon = 1 THEN Tempo.ImpNac =  Ccbcdocu.ImpTot.
        IF Ccbcdocu.Codmon = 2 THEN Tempo.ImpUsa =  Ccbcdocu.ImpTot.
        IF ccbcdocu.codmon = 1 
        THEN Tempo.ImpTot = Tempo.ImpNac.
        ELSE Tempo.ImpTot = Tempo.ImpUsa * x-tpocmb.
    END.
END.
 
/* POR EL MONTO MINIMO DE COMPRA */
DEF VAR x-Anular AS CHAR.
DEF VAR f-Signo AS INT.
DEF VAR x-Total AS DECI.
FOR EACH Tempo WHERE BREAK BY Tempo.NroCar:
    f-Signo = IF Tempo.CodDoc = 'N/C' THEN -1 ELSE 1.
    x-Total = Tempo.ImpTot * f-signo.
    ACCUMULATE x-Total (TOTAL BY Tempo.NroCar).
    IF LAST-OF(Tempo.NroCar) THEN DO:
        IF (ACCUM TOTAL BY Tempo.NroCar x-Total) < x-MtoMin THEN DO:
            IF x-Anular = '' 
            THEN x-Anular = Tempo.NroCar.
            ELSE x-Anular = x-Anular + ',' + Tempo.NroCar.
        END.
    END.
END.

DEF VAR i AS INT NO-UNDO.
DO i = 1 TO NUM-ENTRIES(x-Anular):
    FOR EACH Tempo WHERE Tempo.NroCar = ENTRY(i, x-Anular):
        DELETE Tempo.
    END.            
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen W-Win 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND                                               */
/*     Gn-Divi.Codcia = S-CODCIA AND                                                            */
/*     Gn-Divi.CodDiv BEGINS F-Division:                                                        */
/*                                                                                              */
/*     FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND                                          */
/*         CcbCdocu.CodCia = S-CODCIA AND                                                       */
/*         CcbCdocu.CodDiv = Gn-Divi.CodDiv AND                                                 */
/*         CCbCdocu.FchDoc >= f-desde AND                                                       */
/*         CcbCdocu.FchDoc <= f-hasta AND                                                       */
/*         LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND                                */
/*         CcbCdocu.FlgEst <> "A" AND                                                           */
/*         CcbCdocu.NroCard <> "" AND                                                           */
/*         (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard)                                     */
/*         USE-INDEX LLAVE10:                                                                   */
/*                                                                                              */
/*         x-signo = IF Ccbcdocu.Coddoc = "N/C" THEN -1 ELSE 1.                                 */
/*                                                                                              */
/*         FIND Tempo WHERE Tempo.Codcia = S-CODCIA  AND                                        */
/*                          Tempo.NroCar = Ccbcdocu.NroCar                                      */
/*                          NO-ERROR.                                                           */
/*         IF NOT AVAILABLE Tempo THEN DO:                                                      */
/*             FIND Gn-Card WHERE Gn-Card.NroCard = Ccbcdocu.NroCar NO-LOCK NO-ERROR.           */
/*             x-nombre = "".                                                                   */
/*             IF AVAILABLE Gn-Card THEN x-nombre = Gn-card.NomClie[1] .                        */
/*             CREATE Tempo.                                                                    */
/*             ASSIGN                                                                           */
/*                 Tempo.Codcia = S-CODCIA                                                      */
/*                 Tempo.NroCar = ccbcdocu.NroCar                                               */
/*                 Tempo.Nomcli = x-nombre.                                                     */
/*         END.                                                                                 */
/*         IF Ccbcdocu.Codmon = 1 THEN Tempo.ImpNac = Tempo.ImpNac + x-signo * Ccbcdocu.ImpTot. */
/*         IF Ccbcdocu.Codmon = 2 THEN Tempo.ImpUsa = Tempo.ImpUsa + x-signo * Ccbcdocu.ImpTot. */
/*     END.                                                                                     */
/* END.                                                                                         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalle W-Win 
PROCEDURE Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-TITU AS CHAR.
DEFINE VAR x-Total AS DEC.
DEFINE VAR x-Bonos AS DEC.

X-TITU = "VENTAS POR TARJETAS - DETALLE - " .
X-TOT1 = 0.
X-TOT2 = 0.
X-TOT3 = 0.
X-TOT4 = 0.
x-Total = 0.

DEFINE FRAME f-cab
    Tempo.CodDiv FORMAT 'x(9)'
    Tempo.Coddoc FORMAT 'x(3)'
    Tempo.Nrodoc FORMAT 'x(9)'
    Tempo.fchdoc FORMAT '99/99/99'
    Tempo.codcli format 'x(11)'
    Tempo.nomcli format "x(40)"
    Tempo.impnac FORMAT '->,>>>,>>9.99'
    Tempo.impusa FORMAT '->,>>>,>>9.99'
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
    {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
    {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
    {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    {&PRN2} + {&PRN6A} + "DIVISION : " + F-Division FORMAT "X(30)"
    {&PRN2} + {&PRN6A} + "OBS: INCLUYE IGV" At 40 FORMAT "X(20)"  SKIP      
    "T.C.:" f-TpoCmb
    {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
    "-------------------------------------------------------------------------------------------------------------------" SKIP
    " Division Coddoc NroDoc Fecha    Cliente     Nombre o Razon Social                           S/.            US$    " SKIP
    "-------------------------------------------------------------------------------------------------------------------" SKIP
/*
         123456789 123 123456789 99/99/99 12345678901 1234567890123456789012345678901234567890 ->,>>>,>>9.99 ->,>>>,>>9.99
*/
    WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

          
FOR EACH Tempo BREAK BY Tempo.Codcia 
    BY Tempo.NroCar:

    x-signo = IF Tempo.Coddoc = "N/C" THEN -1 ELSE 1.

    IF Tempo.CodMon = 1 THEN DO:
        x-tot1   = x-tot1 + x-signo * Tempo.ImpNac.
        x-tot3   = x-tot3 + x-signo * Tempo.ImpNac.
    END.

    IF Tempo.CodMon = 2 THEN DO:
        x-tot2   = x-tot2 + x-signo * Tempo.ImpUsa.
        x-tot4   = x-tot4 + x-signo * Tempo.ImpUsa.
    END.
    
    x-Total = x-Total + x-signo * Tempo.ImpTot.

     
    IF FIRST-OF (Tempo.NroCar) THEN DO:
       FIND Gn-Card WHERE Gn-Card.NroCarD = Tempo.NroCar
                          NO-LOCK NO-ERROR. 
       x-nombre = "".                   
       IF AVAILABLE Gn-Card THEN x-nombre = Gn-card.NomClie[1] .

       /*{&NEW-PAGE}.*/
       PAGE.
       DISPLAY STREAM REPORT 
           Tempo.NroCar @ Tempo.codcli
           x-nombre  @ Tempo.nomcli
           WITH FRAME F-Cab.
       DOWN STREAM REPORT WITH FRAME F-CAB.                      
    END.

    DISPLAY STREAM REPORT 
        Tempo.CodDiv
        Tempo.Coddoc 
        Tempo.NroDoc
        Tempo.Fchdoc
        Tempo.CodCli
        Tempo.Nomcli
        Tempo.ImpNac
        Tempo.ImpUsa
        WITH FRAME F-Cab.
    DOWN STREAM REPORT WITH FRAME F-CAB.        

    IF LAST-OF (Tempo.NroCar) THEN DO:
       FIND Gn-Card WHERE Gn-Card.NroCard = Tempo.NroCar NO-LOCK NO-ERROR. 
       x-nombre = "".                   
       IF AVAILABLE Gn-Card THEN x-nombre = Gn-card.NomClie[1] .

       /*{&NEW-PAGE}.*/
       PAGE.
       DISPLAY STREAM REPORT 
           "Sub-Total :" @ Tempo.nomcli 
           x-tot1 @ Tempo.impnac
           x-tot2 @ Tempo.impUsa
           WITH FRAME F-Cab.
       DOWN STREAM REPORT WITH FRAME F-Cab.
       DISPLAY STREAM REPORT
           "Total en S/." @ Tempo.nomcli
           x-Total @ Tempo.ImpUsa
           WITH FRAME f-Cab.
       DOWN STREAM REPORT WITH FRAME F-Cab.
       DISPLAY STREAM REPORT
           "Valor Unitario del Vale de Compra" @ Tempo.nomcli
           F-unival @ Tempo.ImpUsa
           WITH FRAME f-Cab.
       DOWN STREAM REPORT WITH FRAME F-Cab.
       x-Bonos = TRUNCATE(x-Total / f-unival / 100 , 0).
       DISPLAY STREAM REPORT
           x-Bonos @ Tempo.ImpUsa
           WITH FRAME f-Cab.
       X-TOT1 = 0.
       X-TOT2 = 0.
       x-Total = 0.
    END.

    IF LAST-OF (Tempo.Codcia) THEN DO:
        DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        UNDERLINE STREAM REPORT 
            tempo.ImpNac
            Tempo.ImpUsa
            WITH FRAME F-CAB. 
        DISPLAY STREAM REPORT
            "T  O  T  A  L  :  " @ Tempo.nomcli
            x-tot3 @ Tempo.ImpNac
            x-tot4 @ Tempo.ImpUsa
            WITH FRAME F-CAB.
    END.
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
  DISPLAY R-reporte F-Division f-desde f-hasta RADIO-SET-Tipo x-NroCard F-unival 
          x-MtoMin f-TpoCmb x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-58 RECT-55 RECT-59 RECT-60 R-reporte F-Division f-desde f-hasta 
         RADIO-SET-Tipo x-NroCard F-unival x-MtoMin f-TpoCmb B-imprime 
         B-cancela 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DISPLAY "Cargando Informacion..." @ x-mensaje WITH FRAME {&FRAME-NAME}.
    RUN Borra-Temporal.
    RUN Carga-Detalle.
    
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        
        CASE R-reporte:
            WHEN 2 THEN RUN Reviza-2.
            WHEN 3 THEN RUN reviza-3.
        END.
    
        CASE RADIO-SET-Tipo:
            WHEN 1 THEN DO:
                RUN Detalle.
            END.   
            WHEN 2 THEN DO:
                RUN Resumen.
            END.    
        END.
         
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
        f-desde = TODAY - DAY(TODAY) + 1.
        f-hasta = TODAY.
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= f-hasta NO-LOCK NO-ERROR.
        IF AVAILABLE GN-TCMB THEN f-tpocmb = gn-tcmb.venta.
        DISPLAY f-desde f-hasta f-tpocmb.
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
/*        WHEN "F-SUBFAM" THEN ASSIGN input-var-1 = f-familia.
        WHEN "F-MARCA"  THEN ASSIGN input-var-1 = "MK".*/
        /*    ASSIGN
              input-para-1 = ""
              input-para-2 = ""
              input-para-3 = "".
         */      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen W-Win 
PROCEDURE Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-TITU AS CHAR.
X-TITU = "VENTAS POR TARJETAS - RESUMEN - " .
X-TOT1 = 0.
X-TOT2 = 0.

X-TOTS1 = 0.
X-TOTS2 = 0.

DEFINE FRAME f-cab
    Tempo.NroCar FORMAT 'x(09)'
    Tempo.CodCli FORMAT 'x(11)'
    Tempo.Nomcli FORMAT 'x(50)'
    x-tots1 FORMAT '->,>>>,>>9.99'
    x-tots2 FORMAT '->,>>>,>>9.99'
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
    {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
    {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
    {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    {&PRN2} + {&PRN6A} + "DIVISION : " + F-Division FORMAT "X(30)"
    {&PRN2} + {&PRN6A} + "OBS: INCLUYE IGV" At 40 FORMAT "X(20)"        
    "T.C.:" f-TpoCmb
    {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
    "----------------------------------------------------------------------------------------------------" SKIP
    " Tarjeta     Cliente      Nombre o Razon Social                                S/.           US$/.  " SKIP
    "----------------------------------------------------------------------------------------------------" SKIP
/*
    123456789 12345678901 12345678901234567890123456789012345678901234567890 >>,>>>,>>9.99 >>,>>>,>>9.99
*/
    WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

FOR EACH Tempo NO-LOCK BREAK BY Tempo.Codcia 
    BY Tempo.NroCar:

    IF FIRST-OF(Tempo.NroCar) THEN DO:   
        X-TOTS1 = 0.
        X-TOTS2 = 0.                 
    END.

    x-signo = IF Tempo.Coddoc = "N/C" THEN -1 ELSE 1.

    x-tot1   = x-tot1 + x-signo * Tempo.ImpNac .
    x-tot2   = x-tot2 + x-signo * Tempo.ImpUsa .

    x-tots1   = x-tots1 + x-signo * Tempo.ImpNac .
    x-tots2   = x-tots2 + x-signo * Tempo.ImpUsa .
 
    /*{&NEW-PAGE}.  */
    IF LAST-OF(Tempo.NroCar) THEN DO:   
        DISPLAY STREAM REPORT 
            Tempo.NroCar
            Tempo.CodCli
            Tempo.Nomcli
            x-tots1
            x-tots2
            WITH FRAME F-Cab.
        DOWN STREAM REPORT WITH FRAME F-CAB.               
    END.
        
    IF LAST-OF (Tempo.Codcia) THEN DO:
        DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        UNDERLINE STREAM REPORT 
            x-tots1
            x-tots2
            WITH FRAME F-CAB. 
        DISPLAY STREAM REPORT
            "T  O  T  A  L  :  " @ Tempo.Nomcli
            x-tot1 @ x-tots1
            x-tot2 @ x-tots2
            WITH FRAME F-CAB.
    END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reviza-2 W-Win 
PROCEDURE Reviza-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
    Gn-Divi.Codcia = S-CODCIA AND
    Gn-Divi.CodDiv BEGINS F-Division:

    FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
        CcbCdocu.CodCia = S-CODCIA AND
        CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
        CCbCdocu.FchDoc >= f-desde AND 
        CcbCdocu.FchDoc <= f-hasta AND
        LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND 
        CcbCdocu.FlgEst <> "A" AND
        CcbCdocu.NroCard <> "" AND
        (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard) USE-INDEX LLAVE10:

        IF Ccbcdocu.FlgEst <> "C" THEN DO:
            FOR EACH Tempo WHERE Tempo.Codcia = S-CODCIA AND
                Tempo.NroCar = CcbCdocu.NroCar:
                DELETE Tempo.
            END.
        END.          
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reviza-3 W-Win 
PROCEDURE Reviza-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
    Gn-Divi.Codcia = S-CODCIA AND
    Gn-Divi.CodDiv BEGINS F-Division:

    FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
        CcbCdocu.CodCia = S-CODCIA AND
        CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
        CCbCdocu.FchDoc >= f-desde AND 
        CcbCdocu.FchDoc <= f-hasta AND
        LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND 
        CcbCdocu.FlgEst <> "A" AND
        CcbCdocu.NroCard <> "" AND
        (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard) USE-INDEX LLAVE10:
        
        IF Ccbcdocu.FlgEst <> "C" THEN DO:
            FOR EACH Tempo WHERE Tempo.Codcia = S-CODCIA AND
                Tempo.NroCar = CcbCdocu.NroCar:
                DELETE Tempo.
            END.
        END.
    END.
END.

X-FLG = FALSE.

FOR EACH Tempo BREAK BY Tempo.Codcli:
    IF FIRST-OF(Tempo.Codcli) THEN DO:
       X-FLG = FALSE.
       FIND CcbCdocu WHERE CcbCdocu.Codcia = Tempo.Codcia AND
           CcbCdocu.Codcli = Tempo.Codcli AND
           Ccbcdocu.FlgEst = "P" AND
           LOOKUP(CcbCdocu.CodDoc,"FAC,N/D,TCK,LET,CHQ,CHC,CHD") > 0 
           USE-INDEX LLAVE06 NO-LOCK NO-ERROR.

       IF AVAILABLE CcbCdocu THEN  X-FLG = TRUE.         
    END.    
    IF X-FLG THEN DELETE Tempo.
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

