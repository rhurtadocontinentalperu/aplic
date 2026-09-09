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


DEF STREAM REPORTE.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-tienda FILL-IN-chico FILL-IN-grande ~
FILL-IN-fentrega BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-tienda FILL-IN-chico ~
FILL-IN-grande FILL-IN-fentrega 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-chico AS CHARACTER FORMAT "X(15)":U INITIAL "F003NC00AE1" 
     LABEL "Codigo de BARRAS pequeña" 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-fentrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de entreg" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-grande AS CHARACTER FORMAT "X(256)":U INITIAL "500000025249890003" 
     LABEL "Codigo de BARRAS grande" 
     VIEW-AS FILL-IN 
     SIZE 30.14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-tienda AS CHARACTER FORMAT "X(25)":U INITIAL "P114 PRO" 
     LABEL "Tienda (25 caracteres)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-tienda AT ROW 2.31 COL 23 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-chico AT ROW 3.88 COL 27.14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-grande AT ROW 5.27 COL 26.86 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-fentrega AT ROW 6.58 COL 27 COLON-ALIGNED WIDGET-ID 10
     BUTTON-1 AT ROW 8.31 COL 49 WIDGET-ID 12
     "Ejm F003NCC00AE1" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 4.04 COL 58 WIDGET-ID 6
          FGCOLOR 4 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.57 BY 9.12 WIDGET-ID 100.


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
         TITLE              = "Rotulo PLAZA VEA"
         HEIGHT             = 9.12
         WIDTH              = 81.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 81.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 81.57
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Rotulo PLAZA VEA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Rotulo PLAZA VEA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN fill-in-chico fill-in-grande fill-in-tienda fill-in-fentrega.

        MESSAGE 'Seguro de Imprimir Rotulo ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        DEFINE VAR cCurrentUser AS CHAR.
        DEFINE VAR x-archivo AS CHAR.

        cCurrentUser = USERID("DICTDB").

        IF cCurrentUser = 'admin' OR cCurrentUser = 'master'  THEN DO:
            x-archivo = session:temp-directory.
            x-archivo = x-archivo + "imp-zebra-tempo.txt".
            OUTPUT STREAM REPORTE TO VALUE(x-Archivo).
        END.
        ELSE DO:
            DEFINE VAR rpta2 AS LOG.

            SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta2.
            IF rpta2 = NO THEN RETURN.

            OUTPUT STREAM REPORTE TO PRINTER.
        END.


  DEFINE VAR x-fechaent AS CHAR.

  x-fechaent = STRING(fill-in-fentrega,"99/99/9999").
  x-fechaent = REPLACE(x-fechaent,"/","-").


              RUN imprimir-rotulo-lpn(INPUT fill-in-tienda, 
                            INPUT fill-in-grande, 
                            INPUT x-fechaent,
                            INPUT fill-in-chico).
OUTPUT STREAM REPORTE CLOSE.

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
  DISPLAY FILL-IN-tienda FILL-IN-chico FILL-IN-grande FILL-IN-fentrega 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-tienda FILL-IN-chico FILL-IN-grande FILL-IN-fentrega BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulo-lpn W-Win 
PROCEDURE imprimir-rotulo-lpn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pTexto AS CHAR.
    DEFINE INPUT PARAMETER pCodBarra AS CHAR.
    DEFINE INPUT PARAMETER pFecha AS CHAR.
    DEFINE INPUT PARAMETER pBarraLocal AS CHAR.

    /*
            RUN ue-imprime-nuevo-formato(INPUT tt-regLPN.ttTienda, 
                            INPUT tt-regLPN.ttCodLPN, 
                            INPUT x-fechaent,
                            INPUT x-codbarratda).
            /*
            RUN pImprimeEtq(INPUT "P235 SPSA PVEA CUSCO SAN JERONIMO",
                            INPUT "500071012160650100","15-04-2017","F003ND00AAC").    
    */
    */


    DEFINE VAR xTexto AS CHAR.

    xTexto = REPLACE(pTexto,"SPSA PVEA","").
    xTexto = REPLACE(xTexto,"SPSA PLAZA VEA","").
    xTexto = REPLACE(xTexto,"  "," ").

    /* Inicio de Formato */
    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    /**/
    PUT STREAM REPORTE '^FO10,020' SKIP.
    PUT STREAM REPORTE '^AVN,80,50' SKIP. /*120,60*/
    
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  xTexto FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Barras LOCAL */
    PUT STREAM REPORTE '^FO220,110' SKIP.    /*40,180*/
    /*PUT STREAM REPORTE '^BY2^BCN,100,Y,N,N' SKIP.*/
    PUT STREAM REPORTE '^BC2^BCN,100,Y,N,N' SKIP.
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  pBarraLocal FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Barras LPN */
    PUT STREAM REPORTE '^FO50,260' SKIP.    /*40,180*/
    PUT STREAM REPORTE '^BY3^BCN,180,Y,N,N' SKIP.
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  pCodBarra FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Fecha */
    PUT STREAM REPORTE '^FO220,500' SKIP.   /*160,420*/
    PUT STREAM REPORTE '^AVN,40,30' SKIP.    
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  pFecha FORMAT 'x(10)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Fin */
    PUT STREAM REPORTE "^XZ" SKIP.



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
  fill-in-fentrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/99999").

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

