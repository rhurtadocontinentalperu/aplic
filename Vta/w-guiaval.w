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

DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
 
/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE VARIABLE F-DIRDIV   AS CHAR.
DEFINE VARIABLE F-PUNTO    AS CHAR.
DEFINE VARIABLE X-PUNTO    AS CHAR.
DEFINE VARIABLE X-DIVI     AS CHAR INIT "00000".
DEFINE VARIABLE X-CODALM   AS CHAR INIT "".
DEFINE VARIABLE X-CODDIV   AS CHAR INIT "".
DEFINE VARIABLE X-CODDOC   AS CHAR INIT "G/R".
DEFINE VARIABLE X-GUIA1    AS CHAR INIT "".
DEFINE VARIABLE X-GUIA2    AS CHAR INIT "".
DEFINE VARIABLE X-DEPTO    AS CHAR INIT "" FORMAT "X(20)".
DEFINE VARIABLE X-PROVI    AS CHAR INIT "" FORMAT "X(20)".
DEFINE VARIABLE X-DISTR    AS CHAR INIT "" FORMAT "X(20)".
DEFINE VARIABLE W-ESTADO   AS CHAR.
DEFINE VAR X-TITU    AS CHAR.
DEFINE VAR X-SOLES   AS DECI INIT 0.
DEFINE VAR X-DOLARES AS DECI INIT 0.

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
&Scoped-Define ENABLED-OBJECTS RECT-67 RECT-68 RECT-69 f-desde f-hora1 ~
BUTTON-1 f-hasta f-hora2 BUTTON-2 f-codcob f-cndvta c-estado 
&Scoped-Define DISPLAYED-OBJECTS f-desde f-hora1 f-hasta f-hora2 f-codcob ~
f-cndvta c-estado txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendiente","Enviado ","Recepcionado" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE f-cndvta AS CHARACTER FORMAT "XXX":U 
     LABEL "Cond. Vta" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .77 NO-UNDO.

DEFINE VARIABLE f-codcob AS CHARACTER FORMAT "X(8)":U 
     LABEL "Cobrador" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .77 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE f-hora1 AS CHARACTER FORMAT "99:99":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .77 NO-UNDO.

DEFINE VARIABLE f-hora2 AS CHARACTER FORMAT "99:99":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .77 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 3.5.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 4.58.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 8.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-desde AT ROW 1.81 COL 15 COLON-ALIGNED WIDGET-ID 6
     f-hora1 AT ROW 1.81 COL 33 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 1.81 COL 53 WIDGET-ID 26
     f-hasta AT ROW 3.08 COL 15 COLON-ALIGNED WIDGET-ID 10
     f-hora2 AT ROW 3.08 COL 33 COLON-ALIGNED WIDGET-ID 12
     BUTTON-2 AT ROW 3.69 COL 53 WIDGET-ID 28
     f-codcob AT ROW 5.58 COL 12 COLON-ALIGNED WIDGET-ID 18
     f-cndvta AT ROW 6.73 COL 12 COLON-ALIGNED WIDGET-ID 20
     c-estado AT ROW 6.73 COL 32 COLON-ALIGNED WIDGET-ID 22
     txt-msj AT ROW 8.38 COL 3 NO-LABEL WIDGET-ID 30
     "Inicio" VIEW-AS TEXT
          SIZE 7 BY .62 AT ROW 2 COL 4 WIDGET-ID 4
          FONT 0
     "Fin" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.27 COL 4 WIDGET-ID 14
          FONT 0
     RECT-67 AT ROW 1.27 COL 2 WIDGET-ID 2
     RECT-68 AT ROW 5.04 COL 2 WIDGET-ID 16
     RECT-69 AT ROW 1.27 COL 51 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69 BY 8.96
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
         TITLE              = "Reporte Guias x Ubicación"
         HEIGHT             = 8.96
         WIDTH              = 69
         MAX-HEIGHT         = 8.96
         MAX-WIDTH          = 69
         VIRTUAL-HEIGHT     = 8.96
         VIRTUAL-WIDTH      = 69
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
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Guias x Ubicación */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Guias x Ubicación */
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

    ASSIGN f-hora1 f-hora2  f-desde f-hasta F-CNDVTA C-ESTADO.

    DO WITH FRAME {&FRAME-NAME}:
        /*ASSIGN F-HORA1 F-HORA2 F-HASTA F-DESDE.*/
        IF F-DESDE = F-HASTA THEN DO:
            IF F-HORA1 > F-HORA2 THEN DO:   
                MESSAGE "Rango de Hora Incorrecto " SKIP
                    "Verifique por favor ....." SKIP
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY":U TO F-HORA1.
                RETURN NO-APPLY.
            END.
        END.
    END.

    RUN Imprimir.
    txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
    
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


&Scoped-define SELF-NAME f-cndvta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cndvta W-Win
ON MOUSE-SELECT-DBLCLICK OF f-cndvta IN FRAME F-Main /* Cond. Vta */
DO:
    RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
    IF output-var-2 = ? THEN output-var-2 = "".
    f-cndvta:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-codcob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-codcob W-Win
ON LEAVE OF f-codcob IN FRAME F-Main /* Cobrador */
DO:
    assign F-CODCOB.
    IF F-CODCOB = "" THEN RETURN.
    FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
                      gn-cob.codcob = F-CODCOB NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-cob
    THEN DO:
      MESSAGE "Cobrador no registrado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
  
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
  DISPLAY f-desde f-hora1 f-hasta f-hora2 f-codcob f-cndvta c-estado txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-67 RECT-68 RECT-69 f-desde f-hora1 BUTTON-1 f-hasta f-hora2 
         BUTTON-2 f-codcob f-cndvta c-estado 
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
        txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        RUN Reporte.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
         f-punto = S-CODDIV.

        DO WITH FRAME {&FRAME-NAME}:
           f-desde = TODAY - DAY(TODAY) + 1.
           f-hasta = TODAY.
           F-HORA1 = SUBSTRING(STRING(TIME,"HH:MM"),1,2) + SUBSTRING(STRING(TIME,"HH:MM"),4,2).
           F-HORA2 = SUBSTRING(STRING(TIME,"HH:MM"),1,2) + SUBSTRING(STRING(TIME,"HH:MM"),4,2).
           DISPLAY f-desde f-hasta f-hora1 f-hora2.
        END.
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
 X-TITU = "REPORTE DE GUIAS - CONDICION VENTA " .
 DEFINE FRAME f-cab
        CcbCdocu.Nrodoc 
        CcbCdocu.Fchdoc
        CcbCdocu.Nomcli FORMAT "X(40)"
        CcbCdocu.Fmapgo FORMAT "X(5)"
        ccbCDocu.Flgsit FORMAT "X"
        X-SOLES         FORMAT "->>>,>>>,>>9.99"
        X-DOLARES       FORMAT "->>>,>>>,>>9.99"
        CcbCDocu.Glosa  FORMAT "X(40)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN4} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  
        {&PRN4} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN4} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6A} + "GUIAS    : " + X-GUIA1  + " HASTA :" + X-GUIA2  FORMAT "X(60)"
        {&PRN4} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND}  SKIP
        
        "-----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " Documento   Fecha      Nombre o Razon Social                Cond.Vta Estado     Importe S/.  Importe US$.             Observaciones                 " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = S-CODDIV AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          CcbCdocu.CodDoc = X-CODDOC AND
          CcbCDocu.FlgEst <> "A"     AND
          CcbCDocu.FlgSit BEGINS w-estado AND
          CcbCdocu.FmaPgo BEGINS F-cndvta AND
          CcbCdocu.CodCob BEGINS F-CODCOB USE-INDEX LLAVE10
          BREAK BY CodCia
                BY CodDiv
                BY Codcob
                BY FmaPgo  
                BY Codcli:
                                 
     DISPLAY STREAM REPORT WITH FRAME F-Cab.
 
     IF FIRST-OF( CcbCdocu.CodCob) THEN DO:
       FIND Gn-Cob WHERE Gn-Cob.Codcia = S-CODCIA AND
                   TRIM(Gn-Cob.Codcob) = TRIM(CcbCdocu.Codcob) NO-LOCK NO-ERROR.
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT "COBRADOR : "    FORMAT "X(10)"  AT 1.
          PUT STREAM REPORT CcbCDocu.Codcob  FORMAT "X(10)"  AT 14.
       IF AVAILABLE Gn-Cob THEN DO:
          PUT STREAM REPORT Gn-Cob.Nomcob  FORMAT "X(40)"  AT 25 SKIP.
       END.
       PUT STREAM REPORT '------------------------------------------' FORMAT "X(50)" SKIP(2).
     END.
      
     IF FIRST-OF( CcbCdocu.FmaPgo) THEN DO:
       FIND Gn-Convt WHERE TRIM(Gn-Convt.Codig) = TRIM(CcbCdocu.FmaPgo) NO-LOCK NO-ERROR.
       IF AVAILABLE Gn-convt THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT CcbCDocu.FmaPgo FORMAT "X(4)"  AT 11.
          PUT STREAM REPORT Gn-Convt.Nombr  FORMAT "X(40)" AT 17 SKIP.
       END.
     END.

     X-SOLES = 0.
     X-DOLARES = 0.
     
     IF CcbCDocu.Codmon = 1 THEN DO:
      X-SOLES = CcbCDocu.Imptot.
      ACCUM  X-SOLES (SUB-TOTAL BY CcbCdocu.Codcob) .
      ACCUM  X-SOLES (SUB-TOTAL BY CcbCdocu.FmaPgo) .
      ACCUM  X-SOLES (SUB-TOTAL BY CcbCdocu.Codcli) .
      ACCUM  X-SOLES (TOTAL BY CcbCdocu.Codcia) .
     END.
     IF CcbCDocu.Codmon = 2 THEN DO:
      X-DOLARES = CcbCDocu.Imptot.
      ACCUM  X-DOLARES (SUB-TOTAL BY CcbCdocu.Codcob) .
      ACCUM  X-DOLARES (SUB-TOTAL BY CcbCdocu.FmaPgo) .
      ACCUM  X-DOLARES (SUB-TOTAL BY CcbCdocu.Codcli) .
      ACCUM  X-DOLARES ( TOTAL BY CcbCdocu.Codcia) .
     END.
     
     DISPLAY STREAM REPORT 
        CcbCDocu.Nrodoc
        CcbCDocu.Fchdoc
        CcbCDocu.Nomcli
        CcbCDocu.FmaPgo
        CcbCDocu.Flgsit
        X-SOLES
        X-DOLARES
        CcbCDocu.Glosa
        WITH FRAME F-Cab.
       
      IF LAST-OF(CcbCDocu.Codcli) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcli X-SOLES   ) @ X-SOLES 
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcli X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        

      END.

      IF LAST-OF(CcbCDocu.Fmapgo) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("SUB-TOTAL  : " + CcbCDocu.FmaPgo) @ CcbCDocu.Nomcli
            (ACCUM SUB-TOTAL BY  CcbCdocu.FmaPgo X-SOLES   ) @ X-SOLES 
            (ACCUM SUB-TOTAL BY  CcbCdocu.FmaPgo X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        
      END.
      
      IF LAST-OF(CcbCDocu.Codcob) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("SUB-TOTAL COBRADOR : " + CcbCDocu.Codcob) @ CcbCDocu.Nomcli
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcob X-SOLES   ) @ X-SOLES 
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcob X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        
      END.
      
      
      
      IF LAST-OF(CcbCDocu.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("TOTAL  : " + STRING(CcbCDocu.Codcia,"999")) @ CcbCDocu.Nomcli
            (ACCUM TOTAL BY  CcbCdocu.Codcia X-SOLES   ) @ X-SOLES 
            (ACCUM TOTAL BY  CcbCdocu.Codcia X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
      END.

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

