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
{lib/def-prn.i}    
DEFINE STREAM REPORT.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
  
DEF VAR l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.
DEFINE        VARIABLE L-FIN      AS LOGICAL.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/*** DEFINE VARIABLES SUB-TOTALES ***/

DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.

/*DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.*/
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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR F-DESDE AS DATE NO-UNDO.
DEFINE VAR F-HASTA AS DATE NO-UNDO.

DEFINE TEMP-TABLE T-MOVI 
   FIELD codcia LIKE Almtmovm.CodCia 
   FIELD codmat LIKE Almdmov.codmat
   FIELD codpro LIKE Almcmov.codpro
   FIELD Ipieza LIKE Almdmov.Candes
   FIELD Ikilos LIKE Almdmov.Candes
   FIELD Cpieza LIKE Almdmov.Candes
   FIELD Ckilos LIKE Almdmov.Candes
   FIELD Tpieza LIKE Almdmov.Candes
   FIELD Vpieza LIKE Almdmov.Candes
   FIELD Vkilos LIKE Almdmov.Candes
   FIELD Spieza LIKE Almdmov.Candes
   FIELD Skilos LIKE Almdmov.Candes
   FIELD Precio LIKE Almdmov.preuni.

DEFINE TEMP-TABLE T-VENTA
   FIELD codmat LIKE Almdmov.codmat
   FIELD Saldo  LIKE Almdmov.Candes
   FIELD Stock  LIKE Almdmov.Candes
   FIELD Venta  LIKE Almdmov.Candes.

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
&Scoped-Define ENABLED-OBJECTS RECT-49 RECT-50 RECT-51 desdeF hastaF ~
R-Codmon BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 x-desalm desdeF hastaF R-Codmon ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62.14 BY .81 NO-UNDO.

DEFINE VARIABLE R-Codmon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18.29 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.57 BY 7.42.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 1.19.

DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.43 BY 2.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 1.54 COL 8.28 WIDGET-ID 22
     x-desalm AT ROW 1.54 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     desdeF AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 20
     hastaF AT ROW 3.69 COL 31.57 COLON-ALIGNED WIDGET-ID 24
     R-Codmon AT ROW 5.81 COL 16 NO-LABEL WIDGET-ID 26
     x-mensaje AT ROW 7.19 COL 2.86 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     BUTTON-1 AT ROW 8.65 COL 38 WIDGET-ID 46
     BUTTON-2 AT ROW 8.65 COL 53 WIDGET-ID 48
     "Moneda :" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.04 COL 8 WIDGET-ID 34
          FONT 6
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 2.88 COL 6 WIDGET-ID 36
          FONT 6
     RECT-49 AT ROW 1.12 COL 1.43 WIDGET-ID 30
     RECT-50 AT ROW 5.58 COL 15 WIDGET-ID 32
     RECT-51 AT ROW 8.5 COL 1.57 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.14 BY 9.85
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
         TITLE              = "Resumen Documentos"
         HEIGHT             = 9.85
         WIDTH              = 69.14
         MAX-HEIGHT         = 9.85
         MAX-WIDTH          = 69.14
         VIRTUAL-HEIGHT     = 9.85
         VIRTUAL-WIDTH      = 69.14
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN x-desalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen Documentos */
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
  ASSIGN desdeF hastaF R-Codmon.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-tipmov AS CHAR.
    DEFINE INPUT PARAMETER x-codmov AS INTEGER.
    DEFINE INPUT PARAMETER x-factor AS INTEGER.
    
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia 
        AND  Almcmov.codalm = s-codalm 
        AND  Almcmov.Tipmov = x-tipmov 
        AND  Almcmov.codmov = x-codmov 
        AND  Almcmov.Fchdoc <= F-Hasta,
        EACH Almdmov OF Almcmov NO-LOCK:

        DISPLAY Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + STRING(Almdmov.nrodoc, '999999') @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        FIND T-MOVI WHERE T-MOVI.codcia = s-codcia 
            AND  T-MOVI.Codmat = Almdmov.codmat 
            AND  T-MOVI.Codpro = Almcmov.codpro NO-LOCK NO-ERROR.

        IF NOT AVAILABLE T-MOVI THEN DO:
            CREATE T-MOVI.
            ASSIGN
                T-MOVI.Codcia = s-codcia
                T-MOVI.Codmat = Almdmov.codmat
                T-MOVI.Codpro = Almcmov.codpro.
        END.
        IF Almdmov.Fchdoc < F-Desde THEN
            ASSIGN
                T-MOVI.Ipieza = T-MOVI.Ipieza + (Almdmov.candes * Almdmov.factor * x-factor).
        ELSE
            ASSIGN
                T-MOVI.Cpieza = T-MOVI.Cpieza + (Almdmov.candes * Almdmov.factor * x-factor).
        FIND T-VENTA WHERE T-VENTA.codmat = Almdmov.codmat NO-ERROR.
        IF NOT AVAILABLE T-VENTA THEN DO:
            CREATE T-VENTA.
            ASSIGN
                T-VENTA.Codmat = Almdmov.codmat.
        END.
        ASSIGN
            T-VENTA.Saldo = T-VENTA.Saldo + (Almdmov.candes * Almdmov.factor * x-factor).
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

    /***     S A L D O    A N T E R I O R      ***/
    RUN Carga-Datos('I',25,1).
    RUN Carga-Datos('S',75,-1).

    /***  DISTRUBUYO LAS VENTAS DEL MES ENTRE LAS CONSIGNACIONES  ***/
    FOR EACH T-VENTA :
        IF T-VENTA.Venta = 0 THEN NEXT.
        FIND LAST Almdmov WHERE Almdmov.codcia = s-codcia 
            AND  Almdmov.codmat = T-VENTA.Codmat 
            AND  Almdmov.Fchdoc <= F-Hasta NO-LOCK NO-ERROR.

        IF AVAILABLE Almdmov THEN
            ASSIGN T-VENTA.Stock = Almdmov.Stksub.
        IF T-VENTA.Stock >= T-VENTA.Saldo THEN ASSIGN T-VENTA.Venta = 0.
        ASSIGN
            T-VENTA.Venta = T-VENTA.Saldo - T-VENTA.Stock.
    END.

    FOR EACH T-MOVI BREAK BY T-MOVI.codcia BY T-MOVI.Codmat:
        FIND T-VENTA WHERE T-VENTA.Codmat = T-MOVI.Codmat NO-ERROR.
        IF T-VENTA.Venta > T-MOVI.Tpieza THEN
            ASSIGN T-MOVI.Vpieza = T-MOVI.Tpieza.
        ELSE
            ASSIGN T-MOVI.Vpieza = T-VENTA.Venta.
        ASSIGN
            T-VENTA.Venta = T-VENTA.Venta  - T-MOVI.Vpieza.    
    END.

HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas W-Win 
PROCEDURE Carga-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-tipmov AS CHAR.
    DEFINE INPUT PARAMETER x-codmov AS INTEGER.
    DEFINE INPUT PARAMETER x-factor AS INTEGER.
    
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia 
        AND  Almcmov.codalm = s-codalm 
        AND  Almcmov.Tipmov = x-tipmov 
        AND  Almcmov.codmov = x-codmov 
        AND  Almcmov.Fchdoc >= F-Desde 
        AND  Almcmov.Fchdoc <= F-Hasta,
        EACH Almdmov OF Almcmov NO-LOCK:

        DISPLAY "Movimiento: " + Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + STRING(Almdmov.nrodoc, '999999') @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    
        FIND FIRST T-VENTA WHERE T-VENTA.Codmat = Almdmov.codmat NO-ERROR.
        IF NOT AVAILABLE T-VENTA THEN DO:
           CREATE T-VENTA.
           ASSIGN T-VENTA.Codmat = Almdmov.codmat.
        END.
        ASSIGN
           T-VENTA.Venta = T-VENTA.Venta + (Almdmov.candes * Almdmov.factor).
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
  DISPLAY FILL-IN-3 x-desalm desdeF hastaF R-Codmon x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-49 RECT-50 RECT-51 desdeF hastaF R-Codmon BUTTON-1 BUTTON-2 
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

  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo3 AS CHAR NO-UNDO.
  x-titulo1 = 'LIQUIDACION DE CONSIGNACION'.
/*  x-titulo2 = ENTRY(F-Mes,'ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE').*/
/*  x-titulo2 = TRIM(x-titulo2) + '-' + STRING(F-Periodo, '9999').*/
  x-titulo3 = 'Expresado en ' + (IF R-Codmon = 1 THEN 'Nuevos Soles' ELSE 'Dolares Americanos').
  
  DEFINE FRAME F-REP
         T-MOVI.Codmat
         Almmmatg.desmat FORMAT 'X(30)'
         Almmmatg.pesmat
         T-MOVI.Ipieza FORMAT '>>>>,>>9.99'
         T-MOVI.Ikilos
         T-MOVI.Cpieza FORMAT '>>>>,>>9.99'
         T-MOVI.Ckilos
         T-MOVI.Vpieza FORMAT '>>>>,>>9.99'
         T-MOVI.Vkilos
         T-MOVI.Spieza FORMAT '>>>>,>>9.99'
         T-MOVI.Skilos
         WITH WIDTH 160 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
         
  DEFINE FRAME H-REP
     HEADER
         {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
         {&PRN2} + {&PRN6A} + "( " + S-CODALM + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
         {&PRN6A} + x-titulo1 AT 37 FORMAT "X(40)"
         {&PRN3} + {&PRN6B} + "Pag.  : " AT 87 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN2} + {&PRN6A} + x-titulo2 AT 37 FORMAT "X(40)" 
         {&PRN3} + "Fecha : " AT 90 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
         x-titulo3 + {&PRN6B} + {&PRN3}  FORMAT "X(40)" 
         "-------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                 Peso x   ----- SALDO INICIAL ----- ----- INGRESOS MES ----- -------  VENTAS  ------- ----- S A L D O  ----- "
         "  Codigo       Descripcion                        UND        Piezas       kilos        Piezas       kilos       Piezas       kilos       Piezas       kilos  " 
         "-------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.

  FOR EACH T-MOVI ,
      EACH Almmmatg WHERE Almmmatg.codcia = s-codcia 
                     AND  Almmmatg.codmat = T-MOVI.codmat 
                    BREAK BY T-MOVI.Codcia 
                          BY T-MOVI.Codpro 
                          BY T-MOVI.Codmat:
      VIEW STREAM REPORT FRAME H-REP.
      IF FIRST-OF(T-MOVI.Codpro) THEN DO:
         FIND gn-prov WHERE gn-prov.CodCia = s-codcia 
                       AND  gn-prov.CodPro = T-MOVI.Codpro 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE gn-prov THEN 
            PUT STREAM REPORT 'PROVEEDOR : ' gn-prov.NomPro SKIP.
            UNDERLINE STREAM REPORT Almmmatg.desmat WITH FRAME F-REP.
      END.
      T-MOVI.IKilos = T-MOVI.Ipieza * Almmmatg.pesmat.
      T-MOVI.CKilos = T-MOVI.Cpieza * Almmmatg.pesmat.
      T-MOVI.VKilos = T-MOVI.Vpieza * Almmmatg.pesmat.
      T-MOVI.Spieza = T-MOVI.Ipieza + T-MOVI.Cpieza - T-MOVI.Vpieza.
      T-MOVI.SKilos = T-MOVI.Spieza * Almmmatg.pesmat.
      DISPLAY STREAM REPORT 
         T-MOVI.Codmat
         Almmmatg.desmat
         Almmmatg.pesmat
         T-MOVI.Ipieza 
         T-MOVI.Ikilos
         T-MOVI.Cpieza 
         T-MOVI.Ckilos
         T-MOVI.Vpieza 
         T-MOVI.Vkilos
         T-MOVI.Spieza 
         T-MOVI.Skilos 
         WITH FRAME F-REP.
      ACCUMULATE T-MOVI.Ipieza (TOTAL).
      ACCUMULATE T-MOVI.Ikilos (TOTAL).
      ACCUMULATE T-MOVI.Cpieza (TOTAL).
      ACCUMULATE T-MOVI.Ckilos (TOTAL).
      ACCUMULATE T-MOVI.Vpieza (TOTAL).
      ACCUMULATE T-MOVI.Vkilos (TOTAL).
      ACCUMULATE T-MOVI.Spieza (TOTAL).
      ACCUMULATE T-MOVI.Skilos (TOTAL).

      ACCUMULATE T-MOVI.Ipieza (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Ikilos (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Cpieza (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Ckilos (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Vpieza (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Vkilos (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Spieza (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Skilos (SUB-TOTAL BY T-MOVI.Codpro).

      IF LAST-OF(T-MOVI.Codpro) THEN DO:
         UNDERLINE STREAM REPORT
            T-MOVI.Ipieza 
            T-MOVI.Ikilos
            T-MOVI.Cpieza 
            T-MOVI.Ckilos
            T-MOVI.Vpieza 
            T-MOVI.Vkilos
            T-MOVI.Spieza 
            T-MOVI.Skilos 
            WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            '      TOTAL GENERAL : '  @ Almmmatg.desmat
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Ipieza @ T-MOVI.Ipieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Ikilos @ T-MOVI.Ikilos
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Cpieza @ T-MOVI.Cpieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Cpieza @ T-MOVI.Cpieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Vpieza @ T-MOVI.Vpieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Vpieza @ T-MOVI.Vpieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Spieza @ T-MOVI.Spieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Spieza @ T-MOVI.Spieza 
            WITH FRAME F-REP.
      END.
      IF LAST-OF(T-MOVI.Codcia) THEN DO:
         DOWN(2) WITH FRAME F-REP.
         UNDERLINE STREAM REPORT
            T-MOVI.Ipieza 
            T-MOVI.Ikilos
            T-MOVI.Cpieza 
            T-MOVI.Ckilos
            T-MOVI.Vpieza 
            T-MOVI.Vkilos
            T-MOVI.Spieza 
            T-MOVI.Skilos 
            WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            '      TOTAL GENERAL : '  @ Almmmatg.desmat
            ACCUM TOTAL T-MOVI.Ipieza @ T-MOVI.Ipieza
            ACCUM TOTAL T-MOVI.Ikilos @ T-MOVI.Ikilos
            ACCUM TOTAL T-MOVI.Cpieza @ T-MOVI.Cpieza
            ACCUM TOTAL T-MOVI.Cpieza @ T-MOVI.Cpieza
            ACCUM TOTAL T-MOVI.Vpieza @ T-MOVI.Vpieza
            ACCUM TOTAL T-MOVI.Vpieza @ T-MOVI.Vpieza
            ACCUM TOTAL T-MOVI.Spieza @ T-MOVI.Spieza
            ACCUM TOTAL T-MOVI.Spieza @ T-MOVI.Spieza 
            WITH FRAME F-REP.
      END.
  END.
  PAGE STREAM REPORT.

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

    RUN Carga-Temporal.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN formato.
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

