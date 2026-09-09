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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE TEMP-TABLE T-COSTO 
    FIELD Codcia LIKE Almmmatg.codcia
    FIELD Codfam LIKE Almmmatg.codfam
    FIELD Subfam LIKE Almmmatg.subfam
    FIELD Desfam LIKE Almtfami.desfam
    FIELD Vkilos LIKE Almdmov.candes FORMAT '->>>,>>>,>>9.99'
    FIELD VPieza LIKE Almdmov.candes FORMAT '->>>>,>>>,>>9'
    FIELD Vvalor LIKE Almdmov.implin FORMAT '->>>,>>>,>>9.99'
    FIELD Ctovta LIKE Almdmov.implin FORMAT '->>>,>>>,>>9.99'
    FIELD Difere LIKE Almdmov.implin FORMAT '->>>>>>,>>9.99'
    FIELD PorDif AS DECIMAL FORMAT '->>>9.99'.

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
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 f-desde R-Codmon f-hasta ~
BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS f-desde R-Codmon f-hasta txt-msj 

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
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 8.43 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.57 BY 4.88.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.43 BY 1.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-desde AT ROW 2.08 COL 25 COLON-ALIGNED WIDGET-ID 34
     R-Codmon AT ROW 2.08 COL 54 NO-LABEL WIDGET-ID 38
     f-hasta AT ROW 3.19 COL 25 COLON-ALIGNED WIDGET-ID 36
     txt-msj AT ROW 5.04 COL 2 NO-LABEL WIDGET-ID 30
     BUTTON-3 AT ROW 6.42 COL 41.29 WIDGET-ID 24
     BUTTON-4 AT ROW 6.42 COL 56.29 WIDGET-ID 26
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 2.88 COL 5 WIDGET-ID 42
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 7.14 BY .5 AT ROW 2.54 COL 46 WIDGET-ID 44
          FONT 6
     RECT-70 AT ROW 1.23 COL 1.57 WIDGET-ID 20
     RECT-71 AT ROW 6.19 COL 1.72 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.43 BY 7.58
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
         TITLE              = "Ventas vs Costo de Ventas"
         HEIGHT             = 7.58
         WIDTH              = 72.43
         MAX-HEIGHT         = 7.58
         MAX-WIDTH          = 72.43
         VIRTUAL-HEIGHT     = 7.58
         VIRTUAL-WIDTH      = 72.43
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
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas vs Costo de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas vs Costo de Ventas */
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
    ASSIGN f-Desde f-hasta r-codmon.

    IF f-desde = ? then do:
       MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.   
    END.

    IF f-hasta = ? then do:
       MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-hasta.
       RETURN NO-APPLY.   
    END.   

    IF f-desde > f-hasta then do:
       MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.
    END.
    
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
    FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
      FOR EACH Almdmov WHERE Almdmov.codcia = s-codcia AND
          Almdmov.codalm = Almacen.codalm AND Almdmov.tipmov = 'S' AND 
          LOOKUP(STRING(Almdmov.codmov,'99'), '87,97') = 0 AND 
          Almdmov.fchdoc >= f-desde AND Almdmov.fchdoc <= f-hasta NO-LOCK,
          EACH Almmmatg WHERE Almmmatg.codcia = s-codcia AND
               Almmmatg.codmat = Almdmov.codmat NO-LOCK:
          DISPLAY "    Movimiento " + Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + STRING(Almdmov.nrodoc, '999999') @ txt-msj 
              WITH FRAME {&FRAME-NAME}.                  
          FIND T-COSTO WHERE T-Costo.codcia = s-codcia AND
               T-COSTO.codfam = Almmmatg.codfam AND
               T-COSTO.subfam = Almmmatg.subfam NO-ERROR.
          IF NOT AVAILABLE T-COSTO THEN DO:
             CREATE T-COSTO.
             ASSIGN
                T-COSTO.codcia = s-codcia
                T-COSTO.Codfam = Almmmatg.codfam
                T-COSTO.Subfam = Almmmatg.subfam.
             FIND AlmSFami WHERE AlmSFami.CodCia = s-codcia AND
                  AlmSFami.codfam = Almmmatg.codfam AND
                  AlmSFami.subfam = Almmmatg.subfam NO-LOCK NO-ERROR.
             IF AVAILABLE Almsfami THEN
                ASSIGN 
                  T-COSTO.Desfam = AlmSFami.dessub.
          END.
          CASE Almdmov.CodUnd:
               WHEN 'KGS' THEN 
                   ASSIGN 
                      T-COSTO.Vkilos = T-COSTO.Vkilos + (Almdmov.candes * Almdmov.factor).
               OTHERWISE DO:
                   IF SUBSTRING(Almdmov.Codund,3,2) = 'KG' THEN 
                      ASSIGN
                         T-COSTO.Vkilos = T-COSTO.Vkilos + (Almdmov.candes * Almdmov.factor).
                   ELSE
                      ASSIGN 
                         T-COSTO.Vpieza = T-COSTO.Vpieza + (Almdmov.candes * Almdmov.factor)
                         T-COSTO.Vkilos = T-COSTO.Vkilos + Almdmov.Pesmat.
               END.
          END.
            IF Almdmov.codmon = R-Codmon  THEN
               ASSIGN
                  T-COSTO.Vvalor = T-COSTO.Vvalor + Almdmov.ImpCto
                  T-COSTO.Ctovta = T-COSTO.Ctovta + 
                                   (IF Almdmov.aftigv THEN Almdmov.Implin / 1.18 ELSE Almdmov.implin).
            ELSE DO:
               IF R-Codmon = 1 THEN
                  ASSIGN
                     T-COSTO.Vvalor = T-COSTO.Vvalor + (Almdmov.ImpCto * Almdmov.tpocmb)
                     T-COSTO.Ctovta = T-COSTO.Ctovta + 
                                      (IF Almdmov.aftigv THEN (Almdmov.Implin * Almdmov.tpocmb / 1.18) ELSE 
                                      (Almdmov.Implin * Almdmov.tpocmb) ).
               ELSE
                  ASSIGN
                     T-COSTO.Vvalor = T-COSTO.Vvalor + (Almdmov.ImpCto / Almdmov.tpocmb)
                     T-COSTO.Ctovta = T-COSTO.Ctovta + 
                                      (IF Almdmov.aftigv THEN (Almdmov.Implin / Almdmov.tpocmb / 1.18) ELSE
                                      (Almdmov.Implin / Almdmov.tpocmb) ).
            END.
          ASSIGN
              T-COSTO.Difere = T-COSTO.Vvalor - T-COSTO.Ctovta.
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
  DISPLAY f-desde R-Codmon f-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 f-desde R-Codmon f-hasta BUTTON-3 BUTTON-4 
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
 DEFINE VAR x-pordif AS DECIMAL NO-UNDO.
 DEFINE VAR x-ctovta AS DECIMAL NO-UNDO.
 DEFINE VAR x-difere AS DECIMAL NO-UNDO.
 
 DEFINE FRAME f-cab
        T-COSTO.Codfam FORMAT 'XXX-XXX'
        T-COSTO.desfam 
        T-COSTO.Vkilos
        T-COSTO.Vpieza
        T-COSTO.VValor
        T-COSTO.Ctovta
        T-COSTO.Difere
        T-COSTO.PorDif
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
/*        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"*/
        {&PRN6A} + "VENTAS vs COSTO DE VENTAS "  AT 43 FORMAT "X(40)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "--------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                       DIFERENCIA        %      " SKIP
        "  TIPO    DESCRIPCION                      K I L O S     P I E Z A S     VALOR VENTA     COSTO VENTA  V.VTA - C.VTA  DIF./C.VTA " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 /*
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 */
 PUT CONTROL {&PRN0} + {&PRN5A} + CHR(62) + {&PRN3}.       

 FOR EACH T-COSTO BREAK BY T-COSTO.Codcia BY T-COSTO.Codfam 
     BY T-COSTO.Subfam :
      /*{&new-page}.        */
        DISPLAY STREAM REPORT 
            T-COSTO.Codfam + T-COSTO.subfam @ T-COSTO.Codfam
            T-COSTO.desfam 
            T-COSTO.Vkilos
            T-COSTO.Vpieza
            T-COSTO.VValor
            T-COSTO.Ctovta
            T-COSTO.Difere
            T-COSTO.PorDif WITH FRAME F-Cab.

     ACCUMULATE T-COSTO.Vkilos (SUB-TOTAL BY T-COSTO.subfam).
     ACCUMULATE T-COSTO.Vpieza (SUB-TOTAL BY T-COSTO.subfam).
     ACCUMULATE T-COSTO.Vvalor (SUB-TOTAL BY T-COSTO.subfam).
     ACCUMULATE T-COSTO.ctovta (SUB-TOTAL BY T-COSTO.subfam).
     ACCUMULATE T-COSTO.Difere (SUB-TOTAL BY T-COSTO.subfam).
     ACCUMULATE T-COSTO.Vkilos (TOTAL).
     ACCUMULATE T-COSTO.Vpieza (TOTAL).
     ACCUMULATE T-COSTO.Vvalor (TOTAL).
     ACCUMULATE T-COSTO.ctovta (TOTAL).
     ACCUMULATE T-COSTO.Difere (TOTAL).
     IF LAST-OF(T-COSTO.Codfam) OR LAST-OF(T-COSTO.subfam) THEN DO:
        x-difere = ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.Difere.
        x-ctovta = ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.Ctovta.
        x-pordif = ROUND(x-difere * 100 / x-ctovta, 2).
        DISPLAY STREAM REPORT 
            T-COSTO.Codfam + T-COSTO.subfam @ T-COSTO.Codfam
            T-COSTO.desfam 
            ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.Vkilos @ T-COSTO.Vkilos
            ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.Vpieza @ T-COSTO.Vpieza
            ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.VValor @ T-COSTO.VValor
            ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.Ctovta @ T-COSTO.Ctovta
            ACCUM SUB-TOTAL BY T-COSTO.subfam T-COSTO.Difere @ T-COSTO.Difere
            x-pordif @ T-COSTO.PorDif WITH FRAME F-Cab.
     END.
     IF LAST-OF(T-COSTO.codcia) THEN DO:
        UNDERLINE STREAM REPORT
            T-COSTO.Vkilos
            T-COSTO.Vpieza
            T-COSTO.VValor
            T-COSTO.Ctovta
            T-COSTO.Difere
            T-COSTO.PorDif WITH FRAME F-Cab.
        x-difere = ACCUM TOTAL T-COSTO.Difere.
        x-ctovta = ACCUM TOTAL T-COSTO.Ctovta.
        x-pordif = ROUND(x-difere * 100 / x-ctovta, 2).
        DISPLAY STREAM REPORT 
            ' ' @ T-COSTO.Codfam
            '      T O T A L ' @ T-COSTO.desfam 
            ACCUM TOTAL T-COSTO.Vkilos @ T-COSTO.Vkilos
            ACCUM TOTAL T-COSTO.Vpieza @ T-COSTO.Vpieza
            ACCUM TOTAL T-COSTO.VValor @ T-COSTO.VValor
            ACCUM TOTAL T-COSTO.Ctovta @ T-COSTO.Ctovta
            ACCUM TOTAL T-COSTO.Difere @ T-COSTO.Difere
            x-pordif @ T-COSTO.PorDif WITH FRAME F-Cab.
        UNDERLINE STREAM REPORT
            T-COSTO.Vkilos
            T-COSTO.Vpieza
            T-COSTO.VValor
            T-COSTO.Ctovta
            T-COSTO.Difere
            T-COSTO.PorDif WITH FRAME F-Cab.
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
      ASSIGN F-DESDE   = TODAY
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

