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

/* Local Variable Definitions ---                                       */
/*{lib/def-prn.i}    */
DEFINE STREAM report.

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR INIT "00000".
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RECT-49 RECT-50 Btn_OK f-vende Btn_Cancel ~
f-desde f-hasta 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 f-vende f-nomven f-desde f-hasta ~
txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .77 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .77 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .77 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77
     FONT 6 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 54.43 BY 6.88.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 6.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 1.54 COL 5.29 WIDGET-ID 20
     Btn_OK AT ROW 1.54 COL 58 WIDGET-ID 34
     f-vende AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 18
     f-nomven AT ROW 2.62 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     Btn_Cancel AT ROW 3.15 COL 58 WIDGET-ID 32
     f-desde AT ROW 4.77 COL 13.72 COLON-ALIGNED WIDGET-ID 14
     f-hasta AT ROW 4.77 COL 34 COLON-ALIGNED WIDGET-ID 16
     txt-msj AT ROW 6.65 COL 3 NO-LABEL WIDGET-ID 28
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 3.96 COL 4.14 WIDGET-ID 24
          FONT 6
     RECT-49 AT ROW 1.12 COL 1.57 WIDGET-ID 22
     RECT-50 AT ROW 1.19 COL 57 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.57 BY 7.69
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
         TITLE              = "Resumen Pedidos de Mostrador"
         HEIGHT             = 7.69
         WIDTH              = 74.57
         MAX-HEIGHT         = 7.69
         MAX-WIDTH          = 74.57
         VIRTUAL-HEIGHT     = 7.69
         VIRTUAL-WIDTH      = 74.57
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
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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
ON END-ERROR OF W-Win /* Resumen Pedidos de Mostrador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen Pedidos de Mostrador */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancel */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* OK */
DO:
     
  ASSIGN f-Desde f-hasta f-vende.

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
 
  IF f-vende <> "" then T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
   
  RUN Imprimir.

  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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
  DISPLAY FILL-IN-3 f-vende f-nomven f-desde f-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-49 RECT-50 Btn_OK f-vende Btn_Cancel f-desde f-hasta 
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

    /*SESSION:SET-WAIT-STATE ( 'General' ).    */

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        RUN prn-mos.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    /*SESSION:SET-WAIT-STATE ( '' ).*/

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
      ASSIGN FILL-IN-3 = S-CODDIV
             F-DESDE   = TODAY
             F-HASTA   = TODAY.
      DISPLAY 
          s-coddiv @ FILL-IN-3
          TODAY @ F-DESDE
          TODAY @ F-HASTA.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-mos W-Win 
PROCEDURE prn-mos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
    
 DEFINE FRAME f-cab
        FacCpedm.NroPed FORMAT "XXX-XXXXXX"
        FacCpedm.FchPed 
        Faccpedm.NomCli FORMAT "X(30)"
        Faccpedm.RucCli FORMAT "X(8)"
        Faccpedm.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        Faccpedm.ImpBrt FORMAT "->,>>>,>>9.99"
        Faccpedm.ImpDto FORMAT "->>,>>9.99"
        Faccpedm.ImpVta FORMAT "->,>>>,>>9.99"
        Faccpedm.ImpIgv FORMAT "->>,>>9.99"
        Faccpedm.ImpTot FORMAT "->,>>>,>>9.99"
        X-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCPedm.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN DE PEDIDOS DE MOSTRADOR"  AT 42 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(60)" "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
        "  PEDIDO    EMISION   C L I E N T E                   R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
        /* WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.*/
        WITH PAGE-TOP WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 

 FOR EACH FacCpedm NO-LOCK WHERE
          FacCpedm.CodCia = S-CODCIA AND
          FacCpedm.CodDiv = S-CODDIV AND
          FacCpedm.CodDoc = "P/M"    AND
          FacCpedm.FchPed >= F-desde AND
          FacCpedm.FchPed <= F-hasta AND 
          FacCpedm.CodVen BEGINS f-vende
     BY FacCpedm.NroPed:
     /*{&new-page}.*/
     IF FacCpedm.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

     CASE FacCpedm.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCpedm.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + Faccpedm.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + Faccpedm.ImpDto.
                w-totval [1] = w-totval [1] + Faccpedm.ImpVta.
                w-totigv [1] = w-totigv [1] + Faccpedm.ImpIgv.
                w-totven [1] = w-totven [1] + Faccpedm.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + Faccpedm.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + Faccpedm.ImpDto.
                w-totval [2] = w-totval [2] + Faccpedm.ImpVta.
                w-totigv [2] = w-totigv [2] + Faccpedm.ImpIgv.
                w-totven [2] = w-totven [2] + Faccpedm.ImpTot.                
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCpedm.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + Faccpedm.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + Faccpedm.ImpDto.
                w-totval [3] = w-totval [3] + Faccpedm.ImpVta.
                w-totigv [3] = w-totigv [3] + Faccpedm.ImpIgv.
                w-totven [3] = w-totven [3] + Faccpedm.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + Faccpedm.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + Faccpedm.ImpDto.
                w-totval [4] = w-totval [4] + Faccpedm.ImpVta.
                w-totigv [4] = w-totigv [4] + Faccpedm.ImpIgv.
                w-totven [4] = w-totven [4] + Faccpedm.ImpTot.                
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCpedm.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + Faccpedm.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + Faccpedm.ImpDto.
                w-totval [5] = w-totval [5] + Faccpedm.ImpVta.
                w-totigv [5] = w-totigv [5] + Faccpedm.ImpIgv.
                w-totven [5] = w-totven [5] + Faccpedm.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + Faccpedm.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + Faccpedm.ImpDto.
                w-totval [6] = w-totval [6] + Faccpedm.ImpVta.
                w-totigv [6] = w-totigv [6] + Faccpedm.ImpIgv.
                w-totven [6] = w-totven [6] + Faccpedm.ImpTot.                
             END.                
          END.   
     END.        
               
     DISPLAY STREAM REPORT 
        FacCpedm.NroPed 
        FacCpedm.FchPed 
        Faccpedm.NomCli 
        Faccpedm.RucCli 
        Faccpedm.Codven
        X-MON           
        Faccpedm.ImpVta 
        Faccpedm.ImpDto 
        Faccpedm.ImpBrt 
        Faccpedm.ImpIgv 
        Faccpedm.ImpTot 
        X-EST WITH FRAME F-Cab.

 END.
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.


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

