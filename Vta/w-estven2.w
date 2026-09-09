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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
 
def var l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
/* DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0. */
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE VARIABLE F-DIRDIV    AS CHAR.
DEFINE VARIABLE F-PUNTO     AS CHAR.
DEFINE VARIABLE X-PUNTO     AS CHAR.

DEFINE TEMP-TABLE t-vendedor 
       FIELD CODCIA   LIKE CcbcDocu.Codcia
       FIELD CODCLI   LIKE Ccbcdocu.Codcli
       FIELD DESCLI   LIKE Ccbcdocu.Nomcli
/*ML01*/ FIELDS DIRCLI LIKE gn-clie.DirCli
       FIELD TOTVTA    LIKE CcbDdocu.ImpLin
       FIELD TOTIGV    LIKE CcbDdocu.ImpLin
       FIELD TOTAL     LIKE CcbDdocu.ImpLin
       INDEX LLAVE01 CODCLI.

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
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 f-desde f-hasta ~
RADIO-SET-Tipo BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS f-desde f-hasta RADIO-SET-Tipo txt-msj 

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
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumen", 1
     SIZE 12 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.57 BY 4.35.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.43 BY 1.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-desde AT ROW 2.58 COL 30 COLON-ALIGNED WIDGET-ID 68
     f-hasta AT ROW 2.62 COL 47 COLON-ALIGNED WIDGET-ID 70
     RADIO-SET-Tipo AT ROW 2.65 COL 8 NO-LABEL WIDGET-ID 72
     txt-msj AT ROW 4.5 COL 2 NO-LABEL WIDGET-ID 30
     BUTTON-3 AT ROW 5.77 COL 41 WIDGET-ID 24
     BUTTON-4 AT ROW 5.81 COL 56.29 WIDGET-ID 26
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.54 COL 36.72 WIDGET-ID 74
          FONT 6
     RECT-70 AT ROW 1.23 COL 1.57 WIDGET-ID 20
     RECT-71 AT ROW 5.65 COL 1.72 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.72 BY 7
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
         TITLE              = "Reporte de Ventas"
         HEIGHT             = 7
         WIDTH              = 72.72
         MAX-HEIGHT         = 7
         MAX-WIDTH          = 72.72
         VIRTUAL-HEIGHT     = 7
         VIRTUAL-WIDTH      = 72.72
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
ON END-ERROR OF W-Win /* Reporte de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Ventas */
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

  ASSIGN  f-desde f-hasta RADIO-SET-Tipo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-data W-Win 
PROCEDURE carga-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR F-Codigos AS CHAR EXTENT 49.
    DEFINE VAR x AS INTEGER INIT 0.

    FIND FIRST gn-divi where GN-DIVI.CodCia = S-CODCIA 
        AND GN-DIVI.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi then F-DIRDIV = GN-DIVI.DesDiv.    
    
    FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA 
        AND GN-DIVI.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
    X-PUNTO = GN-DIVI.Desdiv.
    RUN CARGA-TABLA-DIVI.
                        
    CASE RADIO-SET-Tipo:
         WHEN 1 THEN RUN Resumen-Vendedor.
    END CASE. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-tabla-divi W-Win 
PROCEDURE carga-tabla-divi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR F-CODI AS CHAR.
DEFINE VAR F-FACTOR AS INTEGER .
DEFINE VAR F-PORIGV AS INTEGER .
DEFINE VAR F-FMAPGO AS CHAR.
DEFINE VAR X-NOMBRE AS CHAR.
DEFINE VAR X-SIGNO AS INTEGER INIT 1.
DEFINE VAR x-TpoCmbCmp AS DEC.
DEFINE VAR x-TpoCmbVta AS DEC.
/*ML01*/ DEFINE VARIABLE cDirCli AS CHARACTER NO-UNDO.

/*
F-CODI = "001228,001229,001230,001231,001232,001233,001237,001238,001239,001240,001241,001242,
014260,014261,014262,011096,011095,011116,011120,011097,011098,011099,011105,011106,011108,
011109,011093,011094,003430,003431,003432,003433,003434,003441,003442,003438,003439,003440,
003435,003436,003437,007866,001722,001723,001726,001727,010374,010387,010383".
*/

FIND FaccfgGn WHERE FaccfgGn.Codcia = S-CODCIA NO-LOCK NO-ERROR.

 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = f-punto AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          ( CcbCdocu.CodDoc = "FAC" OR CcbCdocu.CodDoc = "BOL" OR CcbCdocu.CodDoc = "N/C" ) AND
          CcbCDocu.FlgEst <> "A"   
          USE-INDEX LLAVE10 :
           
        FIND T-VENDEDOR WHERE 
             t-vendedor.codcli = CcbCDocu.CodCli NO-ERROR .
        IF NOT AVAILABLE T-VENDEDOR then do:
           x-nombre = Ccbcdocu.Nomcli.
           FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
               AND  gn-clie.CodCli = Ccbcdocu.Codcli
               NO-LOCK NO-ERROR.
/*ML01* ***
           IF AVAILABLE gn-clie THEN x-nombre = gn-clie.Nomcli.
*ML01* ***/
/*ML01*/    IF AVAILABLE gn-clie THEN ASSIGN cDirCli = gn-clie.DirCli x-nombre = gn-clie.Nomcli.
/*ML01*/    ELSE ASSIGN cDirCli = "" x-nombre = "".

           CREATE T-VENDEDOR.
               ASSIGN 
               T-VENDEDOR.CODCLI   = CcbCdocu.Codcli
/*ML01*/       T-VENDEDOR.DIRCLI   = cDirCli
               T-VENDEDOR.DESCLI   = X-NOMBRE. 
        END.        
        X-SIGNO = IF Ccbcdocu.Coddoc = "N/C" THEN -1 ELSE 1.
        ASSIGN
            x-TpoCmbCmp = CcbCDocu.TpoCmb
            x-TpoCmbVta = CcbCDocu.TpoCmb.
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb 
        THEN FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                    USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb 
        THEN ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.
/*        T-VENDEDOR.TOTVTA = T-VENDEDOR.TOTVTA + X-SIGNO * Ccbcdocu.Impvta / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
 *         T-VENDEDOR.TOTIGV = T-VENDEDOR.TOTIGV + X-SIGNO * Ccbcdocu.ImpIgv / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
 *         T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * Ccbcdocu.ImpTot / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).*/
        IF CcbCDocu.CodMon = 2
        THEN ASSIGN
                T-VENDEDOR.TOTVTA = T-VENDEDOR.TOTVTA + X-SIGNO * Ccbcdocu.Impvta 
                T-VENDEDOR.TOTIGV = T-VENDEDOR.TOTIGV + X-SIGNO * Ccbcdocu.ImpIgv
                T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * Ccbcdocu.ImpTot.
        IF CcbCDocu.CodMon = 1
        THEN ASSIGN
                T-VENDEDOR.TOTVTA = T-VENDEDOR.TOTVTA + X-SIGNO * Ccbcdocu.Impvta / x-TpoCmbCmp
                T-VENDEDOR.TOTIGV = T-VENDEDOR.TOTIGV + X-SIGNO * Ccbcdocu.ImpIgv / x-TpoCmbCmp
                T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * Ccbcdocu.ImpTot / x-TpoCmbCmp.
        PROCESS EVENTS.
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
  DISPLAY f-desde f-hasta RADIO-SET-Tipo txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 f-desde f-hasta RADIO-SET-Tipo BUTTON-3 BUTTON-4 
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
      ASSIGN 
          f-punto = S-CODDIV
          f-desde = TODAY - DAY(TODAY) + 1
          f-hasta = TODAY.
      DISPLAY f-desde f-hasta.      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resumen-vendedor W-Win 
PROCEDURE resumen-vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-TITU AS CHAR.
X-TITU = "RESUMEN DE VENTAS - " + X-PUNTO.
 DEFINE FRAME f-cab
        T-VENDEDOR.CodCli FORMAT "x(11)"    
        T-VENDEDOR.Descli FORMAT "x(35)"
        T-VENDEDOR.TOTVTA FORMAT "->>>,>>>,>>>.99"
        T-VENDEDOR.TOTIGV FORMAT "->>>,>>>,>>>.99"
        T-VENDEDOR.TOTAL  FORMAT "->>>,>>>,>>>.99"
/*ML01*/ T-VENDEDOR.DIRCLI
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
/*ML01* ***
        "------------------------------------------------------------------------------------------------" SKIP
        " Codigo.        RAZON    SOCIAL                    VALOR VENTA       VALOR IGV     VALOR TOTAL                                             " SKIP
        "------------------------------------------------------------------------------------------------" SKIP
*ML01* ***/
/*ML01* Inicio de Bloque */
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " Codigo.        RAZON    SOCIAL                    VALOR VENTA       VALOR IGV     VALOR TOTAL   DIRECCION                                          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*ML01* Fin de Bloque */
/***     99999999999 12345678901234567890123456789012345 -999,999,999.99 -999,999,999.99 -999,999,999.99***/
  
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK
          BREAK BY T-VENDEDOR.CODCIA BY T-VENDEDOR.TOTAl DESCENDING :
                                 
        ACCUMULATE T-VENDEDOR.TOTVTA ( TOTAL BY T-VENDEDOR.CODCIA ).
        ACCUMULATE T-VENDEDOR.TOTIGV ( TOTAL BY T-VENDEDOR.CODCIA ).
        ACCUMULATE T-VENDEDOR.TOTAL  ( TOTAL BY T-VENDEDOR.CODCIA ).

        {&NEW-PAGE}.
         DISPLAY STREAM REPORT 
                   T-VENDEDOR.codcli 
                   T-VENDEDOR.descli
/*ML01*/           T-VENDEDOR.DIRCLI
                   T-VENDEDOR.Totvta
                   T-VENDEDOR.Totigv
                   T-VENDEDOR.Total 
                   WITH FRAME F-Cab.
        DOWN STREAM REPORT WITH FRAME F-CAB.        
        IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTVTA
                                   T-VENDEDOR.TOTIGV
                                   T-VENDEDOR.TOTAL   WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
              "T  O  T  A  L  :  " @ T-VENDEDOR.Descli
              ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTVTA @ T-VENDEDOR.TOTVTA 
              ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTIGV @ T-VENDEDOR.TOTIGV 
              ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTAL  @ T-VENDEDOR.TOTAL  
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

