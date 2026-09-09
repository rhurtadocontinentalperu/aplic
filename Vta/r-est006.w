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
DEF SHARED VAR s-nomcia AS CHAR.

DEF TEMP-TABLE Detalle LIKE Ccbcdocu
    FIELD codmat LIKE ccbddocu.codmat
    FIELD candes LIKE ccbddocu.candes
    FIELD undvta LIKE ccbddocu.undvta
    FIELD implin LIKE ccbddocu.implin
    INDEX Llave01 codcia codcli coddoc nrodoc codmat.

Def BUFFER B-CDOCU FOR CcbCdocu.

Def var x-TpoCmbCmp as deci init 1.
Def var x-TpoCmbVta as deci init 1.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE NO-HIDE
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS x-Licencia x-CodMat x-FchDoc-1 x-FchDoc-2 ~
x-CodCli x-CodMon BUTTON-2 BtnDone BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS x-Licencia x-CodMat x-DesMat x-FchDoc-1 ~
x-FchDoc-2 x-CodCli x-NomCli x-CodMon f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "./img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "./img/print.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE x-Licencia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Licencia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER FORMAT "x(6)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 21 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Licencia AT ROW 1.54 COL 11 COLON-ALIGNED WIDGET-ID 4
     x-CodMat AT ROW 2.62 COL 11 COLON-ALIGNED WIDGET-ID 28
     x-DesMat AT ROW 2.62 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     x-FchDoc-1 AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 6
     x-FchDoc-2 AT ROW 4.77 COL 11 COLON-ALIGNED WIDGET-ID 8
     x-CodCli AT ROW 5.85 COL 11 COLON-ALIGNED WIDGET-ID 10
     x-NomCli AT ROW 5.85 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     x-CodMon AT ROW 6.92 COL 13 NO-LABEL WIDGET-ID 18
     f-Mensaje AT ROW 8 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     BUTTON-2 AT ROW 9.88 COL 5 WIDGET-ID 16
     BtnDone AT ROW 9.88 COL 13 WIDGET-ID 14
     BUTTON-1 AT ROW 9.88 COL 22 WIDGET-ID 26
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.92 COL 7 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.08
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "VENTAS DETALLADAS POR LICENCIA"
         HEIGHT             = 11.08
         WIDTH              = 80
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
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS DETALLADAS POR LICENCIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS DETALLADAS POR LICENCIA */
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
        x-Licencia
        x-FchDoc-1
        x-FchDoc-2
        x-CodCli
        x-CodMon.
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
      x-Licencia
      x-FchDoc-1
      x-FchDoc-2
      x-CodCli
      x-CodMon
      x-CodMat.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEAVE OF x-CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-clie WHERE codcia = cl-codcia
      AND codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE 'Cliente errado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  x-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMat W-Win
ON LEAVE OF x-CodMat IN FRAME F-Main /* Producto */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING( INTEGER(SELF:SCREEN-VALUE), '999999')
      NO-ERROR.
  FIND almmmatg WHERE almmmatg.codcia = s-codcia
      AND almmmatg.codmat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almmmatg THEN DO:
      MESSAGE 'Producto NO existe' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Almmmatg.Licencia[1] <> SUBSTRING (x-Licencia:SCREEN-VALUE,1,3) THEN DO:
      MESSAGE 'La licencia del producto NO coincide' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  x-desmat:SCREEN-VALUE = almmmatg.desmat.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    Def var i           as inte init 0.
    
    DEF VAR x-ImpAde    AS DEC NO-UNDO.     /* Importe aplicado de la factura adelantada */

    FOR EACH Detalle:
        DELETE Detalle.
    END.

    SESSION:SET-WAIT-STATE('GENERAL').
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia NO-LOCK :
        /* Barremos las ventas */
        FOR EACH CcbCdocu USE-INDEX LLave10 NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA 
                AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
                AND CcbCdocu.FchDoc >= x-FchDoc-1
                AND CcbCdocu.FchDoc <= x-FchDoc-2:
            /* ***************** FILTROS ********************************** */
            IF CcbCdocu.TpoFac = 'A' THEN NEXT.     /* NO facturas adelantadas */
            IF Lookup(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C") = 0 THEN NEXT.
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF x-codcli <> '' AND CcbCdocu.CodCli <> x-CodCli THEN NEXT.
            IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
            /* *********************************************************** */
            f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc.
            FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
                              USE-INDEX Cmb01
                              NO-LOCK NO-ERROR.
            IF NOT AVAIL Gn-Tcmb THEN 
                FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                                   USE-INDEX Cmb01
                                   NO-LOCK NO-ERROR.
            IF AVAIL Gn-Tcmb THEN 
                ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.
            /* ************************************************* */

            /* NOTAS DE CREDITO por OTROS conceptos */
            IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN DO:
                RUN PROCESA-NOTA.
                NEXT.
            END.

            FOR EACH CcbDdocu OF CcbCdocu NO-LOCK WHERE x-codmat = ''
                OR Ccbddocu.codmat = x-codmat:
                /* Filtros */
                IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
                FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
                    AND Almmmatg.CodMat = CcbDdocu.CodMat 
                    AND Almmmatg.Licencia[1] = SUBSTRING (x-Licencia,1,3)
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almmmatg THEN NEXT.
                /* ******** */
                CREATE Detalle.
                BUFFER-COPY Ccbcdocu TO Detalle
                    ASSIGN
                    detalle.codmat = ccbddocu.codmat
                    detalle.undvta = ccbddocu.undvta
                    detalle.candes = ccbddocu.candes.
                IF x-CodMon = Ccbcdocu.codmon 
                    THEN ASSIGN
                    Detalle.impigv = Ccbddocu.impigv
                    Detalle.implin = Ccbddocu.implin.
                IF x-CodMon <> Ccbcdocu.codmon 
                    THEN IF x-CodMon = 1
                    THEN ASSIGN
                    Detalle.impigv = Ccbddocu.impigv * x-TpoCmbVta
                    Detalle.implin = Ccbddocu.implin * x-TpoCmbVta.
                    ELSE ASSIGN
                    Detalle.impigv = Ccbddocu.impigv / x-TpoCmbCmp
                    Detalle.implin = Ccbddocu.implin / x-TpoCmbCmp.
            END.  
        END.
    END.
    FOR EACH detalle WHERE detalle.coddoc = 'N/C':
        detalle.implin = detalle.implin * -1.
        detalle.candes = detalle.candes * -1.
    END.
    SESSION:SET-WAIT-STATE('').
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DISPLAY x-Licencia x-CodMat x-DesMat x-FchDoc-1 x-FchDoc-2 x-CodCli x-NomCli 
          x-CodMon f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Licencia x-CodMat x-FchDoc-1 x-FchDoc-2 x-CodCli x-CodMon BUTTON-2 
         BtnDone BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR s-SubTit  AS CHAR FORMAT 'x(50)' NO-UNDO.
  DEF VAR s-SubTit1 AS CHAR FORMAT 'x(50)' NO-UNDO.

  s-Subtit = "LICENCIA: " + x-Licencia.
  s-Subtit1 = "IMPORTES EXPRESADO EN " + (IF x-CodMon = 1 THEN 'SOLES' ELSE 'DOLARES').

  DEFINE FRAME F-REPORTE
      detalle.codcli
      detalle.nomcli
      detalle.coddoc
      detalle.nrodoc
      detalle.fchdoc
      detalle.codmat
      almmmatg.desmat   
      detalle.candes    FORMAT '(>>>,>>>,>>9.99)'
      detalle.undvta
      detalle.implin    FORMAT '(>>>,>>>,>>9.99)'
      WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
      HEADER
      S-NOMCIA FORMAT "X(50)" AT 1 SKIP
      "VENTAS DETALLADAS POR LICENCIA" AT 20 
      "Pagina : " TO 70 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
      "Fecha  : " TO 70 TODAY FORMAT "99/99/9999" SKIP
      "Hora   : " TO 70 STRING(TIME,"HH:MM") SKIP
      S-SUBTIT SKIP
      s-Subtit1 SKIP(1)
      WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH Detalle NO-LOCK, FIRST Almmmatg OF Detalle NO-LOCK BREAK BY Detalle.codcia:
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUMULATE implin (TOTAL BY detalle.codcia).
      DISPLAY STREAM Report
          detalle.codcli
          detalle.nomcli
          detalle.coddoc
          detalle.nrodoc
          detalle.fchdoc
          detalle.codmat
          almmmatg.desmat
          detalle.candes
          detalle.undvta
          detalle.implin
          WITH FRAME F-REPORTE.
      IF LAST-OF(detalle.codcia) THEN DO:
          UNDERLINE STREAM REPORT detalle.implin WITH FRAME F-Reporte.
          DISPLAY STREAM REPORT
              ACCUM TOTAL BY detalle.codcia implin @ detalle.implin
              WITH FRAME F-Reporte.
      END.
  END.

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

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.
    SESSION:SET-WAIT-STATE('').

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
  ASSIGN
      x-FchDoc-1 = TODAY - DAY(TODAY) + 1
      x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH almtabla WHERE tabla = 'LC' NO-LOCK:
          x-Licencia:ADD-LAST(almtabla.Codigo + ' ' + almtabla.Nombre).
      END.
      x-Licencia:SCREEN-VALUE = x-Licencia:ENTRY(1).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Nota W-Win 
PROCEDURE Procesa-Nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-ImpTot    AS DEC NO-UNDO.     /* IMporte NETO de venta */
    DEF VAR x-coe       as deci init 0.
    
    FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
        AND B-CDOCU.CodDoc = CcbCdocu.Codref 
        AND B-CDOCU.NroDoc = CcbCdocu.Nroref 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN.

    x-ImpTot = B-CDOCU.ImpTot.     /* <<< OJO <<< */
    /* buscamos si hay una aplicación de fact adelantada */
    FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
    /* ************************************************* */

    x-coe = Ccbcdocu.ImpTot / x-ImpTot.

    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK WHERE x-codmat = ''
                OR Ccbddocu.codmat = x-codmat:
        IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
        FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
            AND Almmmatg.CodMat = CcbDdocu.CodMat 
            AND Almmmatg.Licencia[1] = SUBSTRING(x-Licencia,1,3)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.

        CREATE Detalle.
        BUFFER-COPY Ccbcdocu TO Detalle
            ASSIGN
            detalle.codmat = ccbddocu.codmat
            detalle.undvta = ccbddocu.undvta
            detalle.candes = ccbddocu.candes.
        IF x-CodMon = B-CDOCU.codmon 
            THEN ASSIGN
            Detalle.impigv = Ccbddocu.impigv * x-coe
            Detalle.implin = Ccbddocu.implin * x-coe.
        IF x-CodMon <> B-CDOCU.codmon 
            THEN IF x-CodMon = 1
            THEN ASSIGN
            Detalle.impigv = Ccbddocu.impigv * x-coe * x-TpoCmbVta
            Detalle.implin = Ccbddocu.implin * x-coe * x-TpoCmbVta.
            ELSE ASSIGN
            Detalle.impigv = Ccbddocu.impigv * x-coe / x-TpoCmbCmp
            Detalle.implin = Ccbddocu.implin * x-coe / x-TpoCmbCmp.
    END.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.

  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN Carga-Temporal.

  DEFINE FRAME F-REPORTE
      detalle.codcli
      detalle.nomcli
      detalle.coddoc
      detalle.nrodoc
      detalle.fchdoc
      detalle.codmat
      almmmatg.desmat   
      detalle.candes    FORMAT '(>>>,>>>,>>9.99)'
      detalle.undvta
      detalle.implin    FORMAT '(>>>,>>>,>>9.99)'
      WITH WIDTH 200 NO-BOX STREAM-IO NO-UNDERLINE DOWN. 

  OUTPUT STREAM Report TO VALUE (x-Archivo).
  FOR EACH Detalle NO-LOCK, FIRST Almmmatg OF Detalle NO-LOCK:
      DISPLAY STREAM Report
          detalle.codcli
          detalle.nomcli
          detalle.coddoc
          detalle.nrodoc
          detalle.fchdoc
          detalle.codmat
          almmmatg.desmat
          detalle.candes
          detalle.undvta
          detalle.implin
          WITH FRAME F-REPORTE.
  END.
  OUTPUT STREAM Report CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

