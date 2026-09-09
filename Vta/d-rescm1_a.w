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
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VARIABLE X-SINANT AS DECI INIT 0.
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR cl-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

DEFINE VAR ESTADO AS CHARACTER.

DEFINE TEMP-TABLE T-CDOC LIKE Ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Serie f-tipo x-CodDiv f-clien ~
f-vende f-desde f-hasta FILL-IN-CndVta r-sortea R-Condic R-Estado B-imprime ~
B-cancela btn-excel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Serie f-tipo x-CodDiv f-clien ~
f-nomcli f-vende f-nomven f-desde f-hasta FILL-IN-CndVta ~
FILL-IN-Descripcion r-sortea R-Condic R-Estado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-cancela 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 13 BY 1.5.

DEFINE BUTTON btn-excel AUTO-GO 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 6" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo Cmpbte." 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Todos","Boleta","Factura","N/C","N/D","Letras","Ticket" 
     DROP-DOWN-LIST
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "x(5)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CndVta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cond. Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-Descripcion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-Serie AS CHARACTER FORMAT "X(4)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE R-Condic AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C/Totales", 1,
"S/Totales", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Estado AS CHARACTER INITIAL "C" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Anulados", "A",
"Cancelados", "C",
"Todos", ""
     SIZE 14 BY 2.27
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documento", 1,
"Cliente", 2
     SIZE 14 BY 1.35
     FGCOLOR 9 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Serie AT ROW 1.27 COL 12 COLON-ALIGNED WIDGET-ID 18
     f-tipo AT ROW 1.31 COL 47 COLON-ALIGNED WIDGET-ID 38
     x-CodDiv AT ROW 2.15 COL 12 COLON-ALIGNED WIDGET-ID 20
     f-clien AT ROW 3.08 COL 12 COLON-ALIGNED WIDGET-ID 2
     f-nomcli AT ROW 3.08 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     f-vende AT ROW 3.96 COL 12 COLON-ALIGNED WIDGET-ID 12
     f-nomven AT ROW 3.96 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     f-desde AT ROW 4.85 COL 12 COLON-ALIGNED WIDGET-ID 4
     f-hasta AT ROW 4.85 COL 38 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-CndVta AT ROW 5.73 COL 12 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Descripcion AT ROW 5.73 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     r-sortea AT ROW 6.92 COL 20 NO-LABEL WIDGET-ID 32
     R-Condic AT ROW 6.92 COL 36 NO-LABEL WIDGET-ID 22
     R-Estado AT ROW 6.92 COL 54 NO-LABEL WIDGET-ID 26
     B-imprime AT ROW 9.62 COL 33 WIDGET-ID 40
     B-cancela AT ROW 9.62 COL 47 WIDGET-ID 42
     btn-excel AT ROW 9.62 COL 61 WIDGET-ID 44
     "Ordenado Por :" VIEW-AS TEXT
          SIZE 12.57 BY .62 AT ROW 6.92 COL 4 WIDGET-ID 36
          BGCOLOR 8 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.14 BY 10.81 WIDGET-ID 100.


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
         HEIGHT             = 10.81
         WIDTH              = 78.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 126.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 126.57
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
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Descripcion IN FRAME F-Main
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


&Scoped-define SELF-NAME B-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-cancela W-Win
ON CHOOSE OF B-cancela IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime W-Win
ON CHOOSE OF B-imprime IN FRAME F-Main /* Imprimir */
DO:
  
  RUN Asigna-Variables.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 6 */
DO:
    RUN Asigna-Variables.
    IF r-sortea = 1 THEN RUN Excel-Doc.
    ELSE IF r-sortea = 2 THEN RUN Excel.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
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


&Scoped-define SELF-NAME FILL-IN-CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CndVta W-Win
ON LEAVE OF FILL-IN-CndVta IN FRAME F-Main /* Cond. Venta */
DO:
  FILL-IN-Descripcion:SCREEN-VALUE = ''.
  FIND gn-convt WHERE gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN FILL-IN-Descripcion:SCREEN-VALUE = gn-ConVt.Nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Gn-Divi WHERE Gn-Divi.codcia = s-codcia NO-LOCK:
        x-CodDiv:ADD-LAST(Gn-Divi.coddiv).
    END.
    x-CodDiv:SCREEN-VALUE = s-CodDiv.
END.

ASSIGN
    F-DESDE   = TODAY
    F-HASTA   = TODAY.

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
    THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

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
        ASSIGN 
            f-Desde f-hasta f-vende f-clien 
            f-tipo r-sortea R-Estado R-Condic
            FILL-IN-CndVta FILL-IN-Descripcion 
            FILL-IN-Serie x-CodDiv.

        IF f-desde = ? THEN DO: 
            MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
            APPLY "ENTRY":U to f-desde.
                RETURN NO-APPLY.   
        END.
        IF f-hasta = ? THEN DO: 
            MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
            APPLY "ENTRY":U to f-hasta.
            RETURN NO-APPLY.   
        END.   
        IF f-desde > f-hasta THEN DO: 
            MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
            APPLY "ENTRY":U to f-desde.
            RETURN NO-APPLY.
        END.
        
        CASE f-tipo:SCREEN-VALUE :
            WHEN "Todos" THEN DO:
                f-tipos  = "".
                T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
            END.     
            WHEN "Boleta"  THEN DO: 
                f-tipos = "BOL". 
                T-cmpbte = "     RESUMEN DE BOLETAS     ". 
            END.            
            WHEN "Factura" THEN DO: 
                f-tipos = "FAC".
                T-cmpbte = "     RESUMEN DE FACTURAS    ". 
            END.     
            WHEN "N/C"      THEN DO: 
                f-tipos = "N/C".
                T-cmpbte = "RESUMEN DE NOTAS DE CREDITO ". 
            END.     
            WHEN "N/D"      THEN DO: 
                f-tipos = "N/D".
                T-cmpbte = " RESUMEN DE NOTAS DE DEBITO ". 
            END.
            WHEN "Letras"      THEN DO: 
                f-tipos = "LET".
                T-cmpbte = "      RESUMEN DE LETRAS     ". 
            END.                               
            WHEN "Ticket"      THEN DO: 
                f-tipos = "TCK".
                T-cmpbte = "      RESUMEN DE TICKETS    ". 
            END.                               
        END.          
        IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
        IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
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

    FOR EACH T-CDOC:
        DELETE T-CDOC.
    END.
    
    FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
        AND CcbcDocu.CodDiv = x-CODDIV 
        AND CcbcDocu.FchDoc >= F-desde 
        AND CcbcDocu.FchDoc <= F-hasta 
        AND CcbcDocu.CodDoc BEGINS f-tipos 
        AND CcbcDocu.CodDoc <> "G/R" 
        AND CcbcDocu.CodVen BEGINS f-vende 
        AND CcbcDocu.Codcli BEGINS f-clien 
        AND CcbcDocu.FlgEst BEGINS R-Estado 
        AND CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta 
        AND CcbCDocu.NroDoc BEGINS FILL-IN-serie:
        CREATE T-CDOC.
        BUFFER-COPY Ccbcdocu TO T-CDOC.
        /* CASO DE FACTURAS CON APLICACION DE ADELANTOS */
        DEF VAR x-Factor AS DEC NO-UNDO.
        IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
            AND Ccbcdocu.TpoFac = 'R'
            AND Ccbcdocu.FlgEst <> 'A' 
            AND Ccbcdocu.ImpTot2 > 0 THEN DO:

            /* Recalculamos Importes */
            ASSIGN
                T-CDOC.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.ImpTot2
                T-CDOC.Libre_d01 = Ccbcdocu.ImpTot.
            IF T-CDOC.ImpTot <= 0 THEN DO:
                ASSIGN
                    T-CDOC.ImpTot = 0
                    T-CDOC.ImpBrt = 0
                    T-CDOC.ImpExo = 0
                    T-CDOC.ImpDto = 0
                    T-CDOC.ImpVta = 0
                    T-CDOC.ImpIgv = 0.
            END.
            ELSE DO:
                x-Factor = T-CDOC.ImpTot / Ccbcdocu.ImpTot.
                ASSIGN
                    T-CDOC.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                    T-CDOC.ImpIgv = T-CDOC.ImpTot - T-CDOC.ImpVta.
                ASSIGN
                    T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto + T-CDOC.ImpExo.
            END.
        END.
        /* ******************************************** */
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
  DISPLAY FILL-IN-Serie f-tipo x-CodDiv f-clien f-nomcli f-vende f-nomven 
          f-desde f-hasta FILL-IN-CndVta FILL-IN-Descripcion r-sortea R-Condic 
          R-Estado 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Serie f-tipo x-CodDiv f-clien f-vende f-desde f-hasta 
         FILL-IN-CndVta r-sortea R-Condic R-Estado B-imprime B-cancela 
         btn-excel 
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
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.   

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
       WHEN "A" THEN ESTADO = "ANULADOS".
       WHEN "P" THEN ESTADO = "PENDIENTES".
       WHEN "C" THEN ESTADO = "CANCELADOS".
       WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    {vta/header-excel.i}

    RUN Carga-Temporal.
    FOR EACH T-CDOC NO-LOCK WHERE
        T-CDOC.CodCia = S-CODCIA AND
        T-CDOC.CodDiv = x-CODDIV AND
        T-CDOC.FchDoc >= F-desde AND
        T-CDOC.FchDoc <= F-hasta AND 
        T-CDOC.CodDoc BEGINS f-tipos AND
        T-CDOC.CodDoc <> "G/R"   AND
        T-CDOC.Codcli BEGINS f-clien AND
        T-CDOC.CodVen BEGINS f-vende AND
        T-CDOC.FlgEst BEGINS R-Estado AND
        T-CDOC.FmaPgo BEGINS FILL-IN-CndVta AND 
        T-CDOC.NroDoc BEGINS FILL-IN-serie
        BREAK BY T-CDOC.NomCli:

        IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

        IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

        CASE T-CDOC.FlgEst :
            WHEN "P" THEN DO:
                X-EST = "PEN".
                IF T-CDOC.Codmon = 1 THEN DO:
                    w-totbru [1] = w-totbru [1] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [1] = w-totdsc [1] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [1] = w-totexo [1] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [1] = w-totval [1] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [1] = w-totisc [1] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [1] = w-totigv [1] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [1] = w-totven [1] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
                ELSE DO:  
                    w-totbru [2] = w-totbru [2] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [2] = w-totdsc [2] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [2] = w-totexo [2] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [2] = w-totval [2] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [2] = w-totisc [2] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [2] = w-totigv [2] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [2] = w-totven [2] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
            END.   
            WHEN "C" THEN DO:
                X-EST = "CAN".
                IF T-CDOC.Codmon = 1 THEN DO:
                    w-totbru [3] = w-totbru [3] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [3] = w-totdsc [3] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [3] = w-totexo [3] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [3] = w-totval [3] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [3] = w-totisc [3] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [3] = w-totigv [3] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [3] = w-totven [3] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
                ELSE DO:  
                    w-totbru [4] = w-totbru [4] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [4] = w-totdsc [4] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [4] = w-totexo [4] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [4] = w-totval [4] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [4] = w-totisc [4] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [4] = w-totigv [4] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [4] = w-totven [4] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
            END.   
            WHEN "A" THEN DO:
                X-EST = "ANU".       
                IF T-CDOC.Codmon = 1 THEN DO:
                    w-totbru [5] = w-totbru [5] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [5] = w-totdsc [5] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [5] = w-totexo [5] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [5] = w-totval [5] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [5] = w-totisc [5] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [5] = w-totigv [5] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [5] = w-totven [5] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
                ELSE DO:  
                    w-totbru [6] = w-totbru [6] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [6] = w-totdsc [6] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [6] = w-totexo [6] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [6] = w-totval [6] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [6] = w-totisc [6] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [6] = w-totigv [6] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [6] = w-totven [6] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
            END.   
        END.            
    
        /* set the column names for the Worksheet */
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(T-CDOC.NroDoc,1,3) + "-" + SUBSTRING(T-CDOC.NroDoc,4).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.Codven.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-MON.
        cRange = "H" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpBrt * -1 ).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpBrt.
        cRange = "I" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpDto * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpDto.
        cRange = "J" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpVta * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpVta.
        cRange = "K" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpIgv * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpIgv.
        cRange = "L" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpTot * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = X-EST.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.UsuAnu.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.
    END.

    /***************************/
    iCount = iCount + 4.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".

    /*Totales Canceladas*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".


    /*Detalle Totales Bruto*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Bruto".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    /*Detalle Totales Descuento*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descuento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    /*Detalle Totales Exonerado*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Exonerado".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[6].

    /*Detalle Totales Valor Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6]. 

    /*Detalle Totales ISC*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.S.C".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[6].  

    /*Detalle Totales IGV*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6]. 

    /*Detalle Totales Precio de Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6]. 

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Doc W-Win 
PROCEDURE Excel-Doc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO. 

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
     
    DEFINE VAR fImpLin  AS DEC INIT 0 NO-UNDO.    
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
       WHEN "A" THEN ESTADO = "ANULADOS".
       WHEN "P" THEN ESTADO = "PENDIENTES".
       WHEN "C" THEN ESTADO = "CANCELADOS".
       WHEN "" THEN ESTADO = "TODOS".
    END CASE.       

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    RUN Carga-Temporal.
    FOR EACH T-CDOC NO-LOCK WHERE
        T-CDOC.CodCia = S-CODCIA AND
        T-CDOC.CodDiv = x-CODDIV AND
        T-CDOC.FchDoc >= F-desde AND
        T-CDOC.FchDoc <= F-hasta AND 
        T-CDOC.CodDoc BEGINS f-tipos AND
        T-CDOC.CodDoc <> "G/R" AND
        T-CDOC.CodVen BEGINS f-vende AND
        T-CDOC.Codcli BEGINS f-clien AND
        T-CDOC.FlgEst BEGINS R-Estado AND
        T-CDOC.FmaPgo BEGINS FILL-IN-CndVta AND 
        T-CDOC.NroDoc BEGINS FILL-IN-serie
        USE-INDEX LLAVE10
        BREAK BY T-CDOC.CodCia
        BY T-CDOC.CodDiv BY T-CDOC.CodDoc BY T-CDOC.NroDoc:
    
        IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
           ELSE X-MON = "US$.".
        IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
           ELSE X-TIP = "CR".   
    
        {vta/resdoc-1.i}.
    
        C = C + 1.
        fImpLin = 0.
        FOR EACH ccbddocu OF T-CDOC NO-LOCK WHERE implin < 0:
           fImpLin = fImpLin + ccbddocu.implin.
        END.
        X-SINANT = ABSOLUTE (fImpLin).

        IF FIRST-OF( T-CDOC.CodDoc) THEN DO:
            {vta/header-excel.i}.
        END.

        /* set the column names for the Worksheet */
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(T-CDOC.NroDoc,1,3) + "-" + SUBSTRING(T-CDOC.NroDoc,4).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.Codven.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-MON.
        cRange = "H" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpBrt * -1 ).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpBrt.
        cRange = "I" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpDto * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpDto.
        cRange = "J" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpVta * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpVta.
        cRange = "K" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpIgv * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpIgv.
        cRange = "L" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpTot * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-SINANT.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP + " " + X-EST.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.UsuAnu.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.NroCard. 

        IF R-Condic = 1 THEN DO:
            IF LAST-OF(T-CDOC.CodDoc) THEN DO:
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".

                /***************************/
                iCount = iCount + 4.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL : ".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = T-CDOC.CodDoc.

                /*Totales Canceladas*/
                iCount = iCount + 4.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".

                /*Detalle Totales Bruto*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Total Bruto".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[6].
                
                /*Detalle Totales Descuento*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Descuento".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[6].

                /*Detalle Totales Exonerado*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Exonerado".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[6].

                /*Detalle Totales Valor Venta*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Valor Venta".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[6].         

                /*Detalle Totales ISC*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "I.S.C".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[6].  
                
                /*Detalle Totales IGV*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "I.G.V".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[6]. 

                /*Detalle Totales Precio de Venta*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Precio de Venta".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[6]. 

                M-TOTBRU = 0.
                M-TOTDSC = 0.
                M-TOTEXO = 0.
                M-TOTVAL = 0.  
                M-TOTISC = 0.
                M-TOTIGV = 0.
                M-TOTVEN = 0.

                iCount = iCount + 1.
            END.
        END.
    END.

    /***************************/
    iCount = iCount + 4.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".

    /*Totales Canceladas*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".


    /*Detalle Totales Bruto*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Bruto".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    /*Detalle Totales Descuento*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descuento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    /*Detalle Totales Exonerado*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Exonerado".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[6].

    /*Detalle Totales Valor Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6]. 

    /*Detalle Totales ISC*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.S.C".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[6].  

    /*Detalle Totales IGV*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6]. 

    /*Detalle Totales Precio de Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6]. 

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3}.
            IF r-sortea = 1 THEN RUN prndoc.
            IF r-sortea = 2 THEN RUN prncli.    
            IF r-sortea = 3 THEN RUN prnart.    
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prnart W-Win 
PROCEDURE prnart :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prncli W-Win 
PROCEDURE prncli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
        WHEN "A" THEN ESTADO = "ANULADOS".
        WHEN "P" THEN ESTADO = "PENDIENTES".
        WHEN "C" THEN ESTADO = "CANCELADOS".
        WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    DEFINE FRAME f-cab
        T-CDOC.CodDoc FORMAT "XXX"
        T-CDOC.NroDoc FORMAT "XXX-XXXXXX"
        T-CDOC.FchDoc 
        T-CDOC.NomCli FORMAT "X(23)"
        T-CDOC.RucCli FORMAT "X(11)"
        T-CDOC.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        T-CDOC.ImpBrt FORMAT "->>>>,>>9.99"
        T-CDOC.ImpDto FORMAT "->,>>9.99"
        T-CDOC.ImpVta FORMAT "->>>>,>>9.99"
        T-CDOC.ImpIgv FORMAT "->,>>9.99"
        T-CDOC.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        T-CDOC.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + T-CDOC.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        Titulo SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         
         
    RUN Carga-Temporal.

    FOR EACH T-CDOC NO-LOCK
        BY T-CDOC.NomCli:
        /*{&NEW-PAGE}.*/

        IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

        IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

        CASE T-CDOC.FlgEst :
            WHEN "P" THEN DO:
                X-EST = "PEN".
                IF T-CDOC.Codmon = 1 THEN DO:
                    w-totbru [1] = w-totbru [1] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [1] = w-totdsc [1] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [1] = w-totexo [1] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [1] = w-totval [1] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [1] = w-totisc [1] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [1] = w-totigv [1] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [1] = w-totven [1] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
                ELSE DO:  
                    w-totbru [2] = w-totbru [2] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [2] = w-totdsc [2] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [2] = w-totexo [2] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [2] = w-totval [2] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [2] = w-totisc [2] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [2] = w-totigv [2] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [2] = w-totven [2] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
            END.   
            WHEN "C" THEN DO:
                X-EST = "CAN".
                IF T-CDOC.Codmon = 1 THEN DO:
                    w-totbru [3] = w-totbru [3] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [3] = w-totdsc [3] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [3] = w-totexo [3] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [3] = w-totval [3] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [3] = w-totisc [3] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [3] = w-totigv [3] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [3] = w-totven [3] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
                ELSE DO:  
                    w-totbru [4] = w-totbru [4] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [4] = w-totdsc [4] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [4] = w-totexo [4] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [4] = w-totval [4] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [4] = w-totisc [4] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [4] = w-totigv [4] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [4] = w-totven [4] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
            END.   
            WHEN "A" THEN DO:
                X-EST = "ANU".       
                IF T-CDOC.Codmon = 1 THEN DO:
                    w-totbru [5] = w-totbru [5] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [5] = w-totdsc [5] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [5] = w-totexo [5] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [5] = w-totval [5] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [5] = w-totisc [5] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [5] = w-totigv [5] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [5] = w-totven [5] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
                ELSE DO:  
                    w-totbru [6] = w-totbru [6] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [6] = w-totdsc [6] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [6] = w-totexo [6] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [6] = w-totval [6] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [6] = w-totisc [6] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [6] = w-totigv [6] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [6] = w-totven [6] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
            END.   
        END.        

        DISPLAY STREAM REPORT 
            T-CDOC.CodDoc 
            T-CDOC.NroDoc 
            T-CDOC.FchDoc 
            T-CDOC.NomCli 
            T-CDOC.RucCli 
            T-CDOC.Codven
            X-MON           
            (T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpVta
            (T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpDto
            (T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpBrt
            (T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpIgv
            (T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpTot
            X-EST 
            T-CDOC.UsuAnu
            X-TIP WITH FRAME F-Cab.
        
    END.
 
/*     DO WHILE LINE-COUNTER(REPORT) < 62 - 8 : */
/*         PUT STREAM REPORT "" skip.           */
/*     END.                                     */
     
    PUT STREAM REPORT "" SKIP. 
    PUT STREAM REPORT "" SKIP. 
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Total Bruto     :"
                                               w-totbru[1] AT 69  FORMAT "->>,>>9.99"    w-totbru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) "Total Bruto     :"
                                               w-totbru[5] AT 116 FORMAT "->>,>>9.99"    w-totbru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Descuento       :"
                                               w-totdsc[1] AT 69  FORMAT "->>,>>9.99"   w-totdsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Descuento       :"
                                               w-totdsc[5] AT 116 FORMAT "->>,>>9.99"   w-totdsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 19  FORMAT "->,>>>,>>9.99" w-totexo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Exonerado       :"
                                               w-totexo[1] AT 69  FORMAT "->>,>>9.99"   w-totexo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Exonerado       :"
                                               w-totexo[5] AT 116 FORMAT "->>,>>9.99"   w-totexo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                               w-totval[1] AT 69  FORMAT "->>,>>9.99"   w-totval[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Valor de Venta  :"
                                               w-totval[5] AT 116 FORMAT "->>,>>9.99"   w-totval[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totisc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.S.C.          :"
                                               w-totisc[1] AT 69  FORMAT "->>,>>9.99"   w-totisc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.S.C.          :"
                                               w-totisc[5] AT 116 FORMAT "->>,>>9.99"   w-totisc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.G.V.          :"
                                               w-totigv[1] AT 69  FORMAT "->>,>>9.99"   w-totigv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.G.V.          :"
                                               w-totigv[5] AT 116 FORMAT "->>,>>9.99"   w-totigv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Precio de Venta :"
                                                w-totven[1] AT 69  FORMAT "->>,>>9.99"   w-totven[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Precio de Venta :"
                                                w-totven[5] AT 116 FORMAT "->>,>>9.99"   w-totven[6] AT 128 FORMAT "->>,>>9.99" SKIP.     
    /*OUTPUT STREAM REPORT CLOSE.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prndoc W-Win 
PROCEDURE prndoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEFINE VAR fImpLin  AS DEC INIT 0 NO-UNDO.

    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    C = 1.    
 
    CASE R-Estado:
        WHEN "A" THEN ESTADO = "ANULADOS".
        WHEN "P" THEN ESTADO = "PENDIENTES".
        WHEN "C" THEN ESTADO = "CANCELADOS".
        WHEN "" THEN ESTADO = "TODOS".
    END CASE.
 
    DEFINE FRAME f-cab
        T-CDOC.CodDoc FORMAT "XXX"
        T-CDOC.NroDoc FORMAT "XXX-XXXXXX"
        T-CDOC.FchDoc FORMAT '99/99/99'
        T-CDOC.NomCli FORMAT "X(20)"
        T-CDOC.RucCli FORMAT "X(11)"
        T-CDOC.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(3)"
        T-CDOC.ImpBrt FORMAT "->>>>,>>9.99"
        T-CDOC.ImpDto FORMAT "->>>>9.99"
        T-CDOC.ImpVta FORMAT "->>>>,>>9.99"
        T-CDOC.ImpIgv FORMAT "->>>>9.99"
        T-CDOC.ImpTot FORMAT "->>>>,>>9.99"
        X-SINANT        FORMAT "->>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        T-CDOC.UsuAnu FORMAT "X(8)"
        T-CDOC.NroCard FORMAT "X(6)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + T-CDOC.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP 
        Titulo SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                             T O T A L      TOTAL       VALOR             P R E C I O PRECIO VENTA        USUARIO        " SKIP
        "DOC  DOCUMENTO  EMISION C L I E N T E            R.U.C.  VEND MON    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A  SIN ANTICIPO ESTADO ANULAC. TARJETA" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     /*  XXX XXX-XXXXXX 99/99/99 12345678901234567890 12345678901 1234 123 ->>>>,>>9.99 ->>>>9.99 ->>>>,>>9.99 ->>>>9.99 ->>>>,>>9.99 ->>>,>>9.99 XX XXX XXXXXXXX 123456
     */
         
    WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    RUN Carga-Temporal.
  
    FOR EACH T-CDOC NO-LOCK
        USE-INDEX LLAVE10
        BREAK BY T-CDOC.CodCia
            BY T-CDOC.CodDiv
            BY T-CDOC.CodDoc
            BY T-CDOC.NroDoc:

        /*{&NEW-PAGE}.*/
        
        IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
        IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

        {vta/resdoc-1.i}.

        C = C + 1.
        fImpLin = 0.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE implin < 0:
            fImpLin = fImpLin + ccbddocu.implin.
        END.
        X-SINANT = ABSOLUTE (fImpLin).
        x-SinAnt = T-CDOC.Libre_d01.
        DISPLAY STREAM REPORT 
            T-CDOC.CodDoc 
            T-CDOC.NroDoc 
            T-CDOC.FchDoc 
            T-CDOC.NomCli 
            T-CDOC.RucCli 
            T-CDOC.Codven
            X-MON           
            (T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpVta
            (T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpDto
            (T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpBrt
            (T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpIgv
            (T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpTot
            X-SINANT 
            X-EST 
            X-TIP
            T-CDOC.UsuAnu
            T-CDOC.NroCard
        WITH FRAME F-Cab.

        IF R-Condic = 1 THEN DO:
            IF LAST-OF(T-CDOC.CodDoc) THEN DO:
                UNDERLINE STREAM REPORT 
                    T-CDOC.ImpVta
                    T-CDOC.ImpDto
                    T-CDOC.ImpBrt
                    T-CDOC.ImpIgv
                    T-CDOC.ImpTot
                WITH FRAME F-Cab.

                /***************************/
                MESSAGE 'lineas 'LINE-COUNTER(REPORT).
                DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
                    PUT STREAM REPORT "" skip. 
                END.   

                PUT STREAM REPORT "TOTAL : " T-CDOC.CodDoc SKIP.
                PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
                PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
                PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
                PUT STREAM REPORT "Total Bruto     :" AT 1 m-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Total Bruto     :"      m-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Total Bruto     :"      m-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                PUT STREAM REPORT "Descuento       :" AT 1 m-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Descuento       :"      m-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Descuento       :"      m-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                PUT STREAM REPORT "Exonerado       :" AT 1 m-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Exonerado       :"      m-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Exonerado       :"      m-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                PUT STREAM REPORT "Valor de Venta  :" AT 1 m-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Valor de Venta  :"      m-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Valor de Venta  :"      m-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                PUT STREAM REPORT "I.S.C.          :" AT 1 m-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "I.S.C.          :"      m-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "I.S.C.          :"      m-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                PUT STREAM REPORT "I.G.V.          :" AT 1 m-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "I.G.V.          :"      m-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "I.G.V.          :"      m-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                PUT STREAM REPORT "Precio de Venta :" AT 1 m-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Precio de Venta :"      m-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                  "Precio de Venta :"      m-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
                /*****************************/
                
                M-TOTBRU = 0.
                M-TOTDSC = 0.
                M-TOTEXO = 0.
                M-TOTVAL = 0.  
                M-TOTISC = 0.
                M-TOTIGV = 0.
                M-TOTVEN = 0.
            END.
        END.
    END.
    /*
    DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
        PUT STREAM REPORT "" skip. 
    END.   
    */

    PUT STREAM REPORT "" SKIP. 
    PUT STREAM REPORT "" SKIP. 
    PUT STREAM REPORT "TOTAL GENERAL " SKIP.
    PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP. 
    /*OUTPUT STREAM REPORT CLOSE.*/
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

