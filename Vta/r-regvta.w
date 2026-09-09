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
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

 DEFINE VAR W-TotBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR W-ConBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConVen AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR W-CreBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreVen AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR W-NCBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR W-NDBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR F-ImpBrt AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpDto AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR F-ImpVta AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpExo AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIgv AS DECIMAL FORMAT "(>>>,>>9.99)".
 DEFINE VAR F-ImpTot AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIsc AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR JJ       AS INTEGER NO-UNDO.
 DEFINE VAR F-TOTCON AS DECIMAL EXTENT 6 INITIAL 0.
 DEFINE VAR F-TOTCRE AS DECIMAL EXTENT 6 INITIAL 0.
 C = 1.

  MESSAGE "Este reporte es para uso exclusivo de contabilidad" SKIP
          "El area de Informatica no se responsabiliza por el" SKIP
          "uso indebido en otras areas"
          VIEW-AS ALERT-BOX INFORMATION.

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
&Scoped-Define ENABLED-OBJECTS RECT-48 RECT-72 FILL-IN-CodDiv f-vende ~
R-S-TipImp f-desde f-hasta txt-msj BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDiv f-vende f-nomven R-S-TipImp ~
f-desde f-hasta txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .85 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .85
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE R-S-TipImp AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detalle y Resumen", 1,
"Solo Detalle", 2,
"Solo Resumen", 3
     SIZE 17.14 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 7.08.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodDiv AT ROW 1.81 COL 4.86 WIDGET-ID 108
     f-vende AT ROW 2.88 COL 9 COLON-ALIGNED WIDGET-ID 106
     f-nomven AT ROW 2.88 COL 16 NO-LABEL WIDGET-ID 104
     R-S-TipImp AT ROW 4.12 COL 11 NO-LABEL WIDGET-ID 110
     f-desde AT ROW 5.04 COL 45 COLON-ALIGNED WIDGET-ID 100
     f-hasta AT ROW 5.04 COL 65 COLON-ALIGNED WIDGET-ID 102
     txt-msj AT ROW 7.19 COL 3 NO-LABEL WIDGET-ID 90
     BUTTON-3 AT ROW 8.54 COL 49 WIDGET-ID 92
     BUTTON-4 AT ROW 8.54 COL 64 WIDGET-ID 94
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 4.23 COL 53 WIDGET-ID 114
          BGCOLOR 8 FONT 6
     RECT-48 AT ROW 1.19 COL 2 WIDGET-ID 80
     RECT-72 AT ROW 8.35 COL 2 WIDGET-ID 98
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.29 BY 9.88
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
         TITLE              = "Registro de Ventas Gestion"
         HEIGHT             = 9.88
         WIDTH              = 80.29
         MAX-HEIGHT         = 9.88
         MAX-WIDTH          = 80.29
         VIRTUAL-HEIGHT     = 9.88
         VIRTUAL-WIDTH      = 80.29
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
/* SETTINGS FOR FILL-IN f-nomven IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-CodDiv IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       RECT-48:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Ventas Gestion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Ventas Gestion */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    RUN Asigna-Variables.    

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende W-Win
ON LEAVE OF f-vende IN FRAME F-Main /* Vendedor */
DO:
  F-vende = "".
  IF F-vende:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = F-vende:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN f-Desde f-hasta R-S-TipImp f-vende FILL-IN-CodDiv.

        IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
           APPLY "ENTRY":U to f-desde.
           RETURN NO-APPLY.   
        END.
        IF f-hasta = ? then do: MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
           APPLY "ENTRY":U to f-hasta.
           RETURN NO-APPLY.   
        END.   
        IF f-desde > f-hasta then do: MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
           APPLY "ENTRY":U to f-desde.
           RETURN NO-APPLY.
        END.

        T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  
  DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(26)"
        CcbcDocu.RucCli FORMAT "X(8)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        F-ImpBrt 
        F-ImpDto 
        F-ImpVta 
        F-ImpIgv 
        F-ImpTot 
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " REGISTRO DE VENTAS "  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                     T O T A L      TOTAL         VALOR              P R E C I O        " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.      BRUTO        DSCTO.        VENTA     I.G.V.    V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
/*MLR* 11/Mar/2008 ***
                             AND  CcbcDocu.CodDiv = FILL-IN-CodDiv
*MLR* 11/Mar/2008 ***/
                             AND  CcbcDocu.CodDiv BEGINS FILL-IN-CodDiv
                             AND  CcbcDocu.FchDoc >= F-desde 
                             AND  CcbcDocu.FchDoc <= F-hasta 
                             AND  CcbcDocu.CodDoc BEGINS "" /*LOOKUP(CcbcDocu.CodDoc,"BOL,FAC,N/C,N/D") > 0 */
                             AND  CcbcDocu.CodDoc <> "G/R" 
                             AND  CcbcDocu.CodVen BEGINS f-vende
                            USE-INDEX LLAVE10
                            BREAK BY CcbCDocu.codcia 
                                  BY CcbCDocu.Fchdoc 
                                  BY CcbCDocu.Coddoc 
                                  BY CcbCDocu.NroDoc:
                                  
     IF FIRST-OF(CcbCDocu.Fchdoc) THEN DO:
        ASSIGN F-TOTCON = 0 F-TOTCRE = 0.
        FIND gn-tcmb WHERE gn-tcmb.fecha = CcbCDocu.fchdoc NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN x-tpocmb = gn-tcmb.venta. 
     END.

     /*IF R-S-TipImp <> 3 THEN  {&NEW-PAGE}.*/
     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.


        F-ImpBrt = (IF X-MON = 'S/.' THEN Impbrt ELSE Impbrt * x-tpocmb).
        F-ImpDto = (IF X-MON = 'S/.' THEN ImpDto ELSE ImpDto * x-tpocmb).
        F-ImpExo = (IF X-MON = 'S/.' THEN ImpExo ELSE ImpExo * x-tpocmb).
        F-ImpVta = (IF X-MON = 'S/.' THEN ImpVta ELSE ImpVta * x-tpocmb).
        F-ImpIgv = (IF X-MON = 'S/.' THEN ImpIgv ELSE ImpIgv * x-tpocmb).
        F-Imptot = (IF X-MON = 'S/.' THEN ImpTot ELSE ImpTot * x-tpocmb).


     IF CcbCDocu.Coddoc = 'N/C' THEN
        ASSIGN F-ImpBrt = F-ImpBrt * -1 
               F-ImpDto = F-ImpDto * -1
               F-ImpExo = F-ImpExo * -1
               F-ImpVta = F-ImpVta * -1
               F-ImpIgv = F-ImpIgv * -1
               F-ImpTot = F-ImpTot * -1.
               
if CcbcDocu.Flgest ne "a" then do:
     IF LOOKUP(TRIM(CcbcDocu.Fmapgo), "000,002") > 0 THEN DO:
        F-TOTCON[1] = F-TOTCON[1] + F-Impbrt.
        F-TOTCON[2] = F-TOTCON[2] + F-ImpDto.
        F-TOTCON[4] = F-TOTCON[4] + F-ImpVta.
        F-TOTCON[5] = F-TOTCON[5] + F-ImpIgv.
        F-TOTCON[6] = F-TOTCON[6] + F-ImpTot.
        X-TIP = "CT".
        END.
     ELSE DO:
        F-TOTCRE[1] = F-TOTCRE[1] + F-Impbrt.
        F-TOTCRE[2] = F-TOTCRE[2] + F-ImpDto.
        F-TOTCRE[4] = F-TOTCRE[4] + F-ImpVta.
        F-TOTCRE[5] = F-TOTCRE[5] + F-ImpIgv.
        F-TOTCRE[6] = F-TOTCRE[6] + F-ImpTot.
        X-TIP = "CR".
     END.
     
        ACCUMULATE F-ImpBrt (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpDto (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpVta (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpIgv (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpTot (SUB-TOTAL BY CcbCDocu.fchdoc).
    
     end.
     
     CASE CcbcDocu.FlgEst :
          WHEN "P" THEN ASSIGN X-EST = "PEN"
                               JJ = CcbcDocu.Codmon.
          WHEN "C" THEN ASSIGN X-EST = "CAN"
                               JJ = CcbcDocu.Codmon + 2.
          WHEN "A" THEN ASSIGN X-EST = "ANU"
                               JJ = CcbcDocu.Codmon + 4.
     END CASE.
     W-TotBru [JJ] = W-TotBru [JJ] + F-ImpBrt.
     W-TotDsc [JJ] = W-TotDsc [JJ] + F-ImpDto.
     W-TotExo [JJ] = W-TotExo [JJ] + F-ImpExo.
     W-TotVal [JJ] = W-TotVal [JJ] + F-ImpVta.
     W-TotIsc [JJ] = W-TotIsc [JJ] + F-ImpIsc.
     W-TotIgv [JJ] = W-TotIgv [JJ] + F-ImpIgv.
     W-TotVen [JJ] = W-TotVen [JJ] + F-ImpTot.
     CASE CcbcDocu.CodDoc:
          WHEN "N/C" THEN DO:
               W-NCBru [JJ] = W-NCBru [JJ] + F-ImpBrt. 
               W-NCDsc [JJ] = W-NCDsc [JJ] + F-ImpDto.
               W-NCExo [JJ] = W-NCExo [JJ] + F-ImpExo.
               W-NCVal [JJ] = W-NCVal [JJ] + F-ImpVta.
               W-NCIsc [JJ] = W-NCIsc [JJ] + F-ImpIsc.
               W-NCIgv [JJ] = W-NCIgv [JJ] + F-ImpIgv.
               W-NCVen [JJ] = W-NCVen [JJ] + F-ImpTot.
          END.
          WHEN "N/D" THEN DO:
               W-NDBru [JJ] = W-NDBru [JJ] + F-ImpBrt.   
               W-NDDsc [JJ] = W-NDDsc [JJ] + F-ImpDto.
               W-NDExo [JJ] = W-NDExo [JJ] + F-ImpExo.
               W-NDVal [JJ] = W-NDVal [JJ] + F-ImpVta.
               W-NDIsc [JJ] = W-NDIsc [JJ] + F-ImpIsc.
               W-NDIgv [JJ] = W-NDIgv [JJ] + F-ImpIgv.
               W-NDVen [JJ] = W-NDVen [JJ] + F-ImpTot.
          END.
          OTHERWISE DO:
               IF LOOKUP(TRIM(CcbcDocu.Fmapgo), "000,002") > 0 THEN DO:
                  W-ConBru [JJ] = W-ConBru [JJ] + F-ImpBrt.   
                  W-ConDsc [JJ] = W-ConDsc [JJ] + F-ImpDto.
                  W-ConExo [JJ] = W-ConExo [JJ] + F-ImpExo.
                  W-ConVal [JJ] = W-ConVal [JJ] + F-ImpVta.
                  W-ConIsc [JJ] = W-ConIsc [JJ] + F-ImpIsc.
                  W-ConIgv [JJ] = W-ConIgv [JJ] + F-ImpIgv.
                  W-ConVen [JJ] = W-ConVen [JJ] + F-ImpTot.
                  END.
               ELSE DO:
                  W-CreBru [JJ] = W-CreBru [JJ] + F-ImpBrt.   
                  W-CreDsc [JJ] = W-CreDsc [JJ] + F-ImpDto.
                  W-CreExo [JJ] = W-CreExo [JJ] + F-ImpExo.
                  W-CreVal [JJ] = W-CreVal [JJ] + F-ImpVta.
                  W-CreIsc [JJ] = W-CreIsc [JJ] + F-ImpIsc.
                  W-CreIgv [JJ] = W-CreIgv [JJ] + F-ImpIgv.
                  W-CreVen [JJ] = W-CreVen [JJ] + F-ImpTot.
               END.
          END.
     END CASE.
     IF R-S-TipImp <> 3 THEN DO:
        C = C + 1.
        DISPLAY STREAM REPORT 
              CcbcDocu.CodDoc 
              CcbcDocu.NroDoc 
              CcbcDocu.FchDoc 
              CcbcDocu.NomCli 
              CcbcDocu.RucCli 
              CcbcDocu.Codven
              X-MON           
              F-ImpVta WHEN F-ImpVta <> 0
              F-ImpDto WHEN F-ImpDto <> 0
              F-ImpBrt WHEN F-ImpBrt <> 0
              F-ImpIgv WHEN F-ImpIgv <> 0
              F-ImpTot WHEN F-ImpTot <> 0
              X-EST 
              X-TIP WITH FRAME F-Cab.
        IF LAST-OF(CcbCDocu.Fchdoc) THEN DO:
           UNDERLINE STREAM REPORT F-ImpVta F-Impdto F-Impbrt F-Impigv F-Imptot WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
              'CONTADO'   @ CcbCDocu.Ruccli
              F-TOTCON[1] @ F-Impbrt
              F-TOTCON[2] @ F-Impdto
              F-TOTCON[4] @ F-Impvta
              F-TOTCON[5] @ F-Impigv
              F-TOTCON[6] @ F-Imptot WITH FRAME F-Cab.
           DOWN(1) STREAM REPORT WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
              'CREDITO'   @ CcbCDocu.Ruccli
              F-TOTCRE[1] @ F-Impbrt
              F-TOTCRE[2] @ F-Impdto
              F-TOTCRE[4] @ F-Impvta
              F-TOTCRE[5] @ F-Impigv
              F-TOTCRE[6] @ F-Imptot WITH FRAME F-Cab.
           DOWN(1) STREAM REPORT WITH FRAME F-Cab.
         
         
           DISPLAY STREAM REPORT
              'TOTAL DE DIA   ==>' @ CcbCDocu.Nomcli
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpBrt @ F-Impbrt
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpDto @ F-ImpDto
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpVta @ F-ImpVta
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpIgv @ F-ImpIgv
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpTot @ F-ImpTot WITH FRAME F-Cab.
          DOWN(2) STREAM REPORT WITH FRAME F-Cab.
        END.
     END.
 END.
 RUN Reporte.

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
  DISPLAY FILL-IN-CodDiv f-vende f-nomven R-S-TipImp f-desde f-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-48 RECT-72 FILL-IN-CodDiv f-vende R-S-TipImp f-desde f-hasta 
         txt-msj BUTTON-3 BUTTON-4 
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

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.    
        RUN Carga-Data.
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
    ASSIGN FILL-IN-Coddiv = S-CODDIV
           F-DESDE   = TODAY
           F-HASTA   = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte W-Win 
PROCEDURE Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-RESU
         HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RESUMEN DE VENTAS "  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Vendedor : " f-vende f-nomven
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        WITH PAGE-TOP NO-LABEL NO-UNDERLINE NO-BOX WIDTH 165 STREAM-IO DOWN.         
/*           1         2         3         4         5         6         7         8         9        10        11        12        13
    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    Total Bruto     : ->,>>>,>>9.99  ->>>,>>9.99     Total Bruto     :  ->>>,>>9.99  ->>>,>>9.99    Total Bruto     :  ->>,>>9.99  ->>,>>9.99
*/

 IF R-S-TipImp <> 2 THEN DO:
    /*IF C = 0 THEN {&NEW-PAGE}.*/
    IF C = 1 THEN PAGE STREAM REPORT.
    VIEW STREAM REPORT FRAME F-RESU.
    PUT STREAM REPORT {&PRN6A} + " T O T A L    C O N T A D O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-ConBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-ConBru[1] AT 69  FORMAT "->>>,>>9.99"   W-ConBru[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-ConBru[5] AT 116 FORMAT "->>,>>9.99"    W-ConBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
                      
    PUT STREAM REPORT "Descuento       :" AT 1 W-ConDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-ConDsc[1] AT 69  FORMAT "->>>,>>9.99"   W-ConDsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-ConDsc[5] AT 116 FORMAT "->>,>>9.99"    W-ConDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-ConExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-ConExo[1] AT 69  FORMAT "->>>,>>9.99"   W-ConExo[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-ConExo[5] AT 116 FORMAT "->>,>>9.99"    W-ConExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-ConVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-ConVal[1] AT 69  FORMAT "->>>,>>9.99"   W-ConVal[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-ConVal[5] AT 116 FORMAT "->>,>>9.99"    W-ConVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-ConIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-ConIsc[1] AT 69  FORMAT "->>>,>>9.99"   W-ConIsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-ConIsc[5] AT 116 FORMAT "->>,>>9.99"    W-ConIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-ConIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-ConIgv[1] AT 69  FORMAT "->>>,>>9.99"   W-ConIgv[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-ConIgv[5] AT 116 FORMAT "->>,>>9.99"    W-ConIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-ConVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-ConVen[1] AT 69  FORMAT "->>>,>>9.99"   W-ConVen[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-ConVen[5] AT 116 FORMAT "->>,>>9.99"    W-ConVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
        
    PUT STREAM REPORT {&PRN6A} + " T O T A L    C R E D I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-CreBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-CreBru[1] AT 69  FORMAT "->>>,>>9.99"   W-CreBru[2] AT 82  FORMAT "->>>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-CreBru[5] AT 116 FORMAT "->>,>>9.99"    W-CreBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-CreDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-CreDsc[1] AT 69  FORMAT "->>>,>>9.99"   W-CreDsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-CreDsc[5] AT 116 FORMAT "->>,>>9.99"    W-CreDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-CreExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-CreExo[1] AT 69  FORMAT "->>>,>>9.99"   W-CreExo[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-CreExo[5] AT 116 FORMAT "->>,>>9.99"    W-CreExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-CreVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-CreVal[1] AT 69  FORMAT "->>>,>>9.99"   W-CreVal[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-CreVal[5] AT 116 FORMAT "->>,>>9.99"    W-CreVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-CreIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-CreIsc[1] AT 69  FORMAT "->>>,>>9.99"   W-CreIsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-CreIsc[5] AT 116 FORMAT "->>,>>9.99"    W-CreIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-CreIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-CreIgv[1] AT 69  FORMAT "->>>,>>9.99"   W-CreIgv[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-CreIgv[5] AT 116 FORMAT "->>,>>9.99"    W-CreIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-CreVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-CreVen[1] AT 69  FORMAT "->>>,>>9.99"   W-CreVen[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-CreVen[5] AT 116 FORMAT "->>,>>9.99"    W-CreVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
    PUT STREAM REPORT {&PRN6A} + " T O T A L    N O T A S    D E    D E B I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-NDBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-NDBru[1] AT 69  FORMAT "->>>,>>9.99"   W-NDBru[2] AT 82  FORMAT "->>>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-NDBru[5] AT 116 FORMAT "->>,>>9.99"    W-NDBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-NDDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NDDsc[1] AT 69  FORMAT "->>>,>>9.99"   W-NDDsc[2] AT 82 FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NDDsc[5] AT 116 FORMAT "->>,>>9.99"    W-NDDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-NDExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NDExo[1] AT 69  FORMAT "->>>,>>9.99"   W-NDExo[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NDExo[5] AT 116 FORMAT "->>,>>9.99"    W-NDExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-NDVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NDVal[1] AT 69  FORMAT "->>>,>>9.99"   W-NDVal[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NDVal[5] AT 116 FORMAT "->>,>>9.99"    W-NDVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-NDIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NDIsc[1] AT 69  FORMAT "->>,>>9.99"    W-NDIsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NDIsc[5] AT 116 FORMAT "->>>,>>9.99"   W-NDIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-NDIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NDIgv[1] AT 69  FORMAT "->>>,>>9.99"   W-NDIgv[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NDIgv[5] AT 116 FORMAT "->>,>>9.99"    W-NDIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-NDVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NDVen[1] AT 69  FORMAT "->>>,>>9.99"   W-NDVen[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NDVen[5] AT 116 FORMAT "->>,>>9.99"    W-NDVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
    PUT STREAM REPORT {&PRN6A} + " T O T A L    N O T A S    D E    C R E D I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-NCBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-NCBru[1] AT 69  FORMAT "->>>,>>9.99"   W-NCBru[2] AT 82  FORMAT "->>>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-NCBru[5] AT 116 FORMAT "->>,>>9.99"    W-NCBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-NCDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NCDsc[1] AT 69  FORMAT "->>>,>>9.99"   W-NCDsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NCDsc[5] AT 116 FORMAT "->>,>>9.99"    W-NCDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-NCExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NCExo[1] AT 69  FORMAT "->>>,>>9.99"   W-NCExo[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NCExo[5] AT 116 FORMAT "->>,>>9.99"    W-NCExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-NCVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NCVal[1] AT 69  FORMAT "->>>,>>9.99"   W-NCVal[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NCVal[5] AT 116 FORMAT "->>,>>9.99"    W-NCVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-NCIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NCIsc[1] AT 69  FORMAT "->>>,>>9.99"   W-NCIsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NCIsc[5] AT 116 FORMAT "->>,>>9.99"    W-NCIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-NCIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NCIgv[1] AT 69  FORMAT "->>>,>>9.99"   W-NCIgv[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NCIgv[5] AT 116 FORMAT "->>,>>9.99"    W-NCIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-NCVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NCVen[1] AT 69  FORMAT "->>>,>>9.99"   W-NCVen[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NCVen[5] AT 116 FORMAT "->>,>>9.99"    W-NCVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).

    PUT STREAM REPORT {&PRN6A} + " T O T A L    G E N E R A L" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-TotBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-TotBru[1] AT 69  FORMAT "->>>,>>9.99"   W-TotBru[2] AT 82  FORMAT "->>>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-TotBru[5] AT 116 FORMAT "->>,>>9.99"    W-TotBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-TotDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-TotDsc[1] AT 69  FORMAT "->>>,>>9.99"   W-TotDsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-TotDsc[5] AT 116 FORMAT "->>,>>9.99"    W-TotDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-TotExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-TotExo[1] AT 69  FORMAT "->>>,>>9.99"   W-TotExo[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-TotExo[5] AT 116 FORMAT "->>,>>9.99"    W-TotExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-TotVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-TotVal[1] AT 69  FORMAT "->>>,>>9.99"   W-TotVal[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-TotVal[5] AT 116 FORMAT "->>,>>9.99"    W-TotVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-TotIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-TotIsc[1] AT 69  FORMAT "->>>,>>9.99"   W-TotIsc[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-TotIsc[5] AT 116 FORMAT "->>,>>9.99"    W-TotIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-TotIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-TotIgv[1] AT 69  FORMAT "->>>,>>9.99"   W-TotIgv[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-TotIgv[5] AT 116 FORMAT "->>,>>9.99"    W-TotIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-TotVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-TotVen[1] AT 69  FORMAT "->>>,>>9.99"   W-TotVen[2] AT 82  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-TotVen[5] AT 116 FORMAT "->>,>>9.99"    W-TotVen[6] AT 128 FORMAT "->>,>>9.99" SKIP.
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

