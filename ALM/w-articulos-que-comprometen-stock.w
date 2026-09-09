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

DEFINE VAR lProcesaRepo AS LOG.
DEFINE VAR lProcesaOTR AS LOG.
DEFINE VAR cMensaje AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-desde FILL-IN-hasta RADIO-SET-cuales ~
BUTTON-dir BUTTON-procesar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta ~
RADIO-SET-cuales FILL-IN-txt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-dir 
     LABEL "..." 
     SIZE 4 BY .85.

DEFINE BUTTON BUTTON-procesar 
     LABEL "Procesar" 
     SIZE 10 BY 1.12.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidas desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-txt AS CHARACTER FORMAT "X(256)":U INITIAL "Ruta donde alojar el archivo..." 
      VIEW-AS TEXT 
     SIZE 61 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo reposiciones", 1,
"Solo OTRs", 2,
"Ambos", 3
     SIZE 23 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-desde AT ROW 2.35 COL 18.29 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-hasta AT ROW 2.35 COL 36.29 COLON-ALIGNED WIDGET-ID 16
     RADIO-SET-cuales AT ROW 3.54 COL 21 NO-LABEL WIDGET-ID 2
     BUTTON-dir AT ROW 7.46 COL 66 WIDGET-ID 8
     BUTTON-procesar AT ROW 8.65 COL 42.72 WIDGET-ID 10
     FILL-IN-txt AT ROW 7.46 COL 4 NO-LABEL WIDGET-ID 6
     "        Consulta de R/A - OTR PENDIENTE DE PROCESAR" VIEW-AS TEXT
          SIZE 70.43 BY .81 AT ROW 1.04 COL 1.57 WIDGET-ID 12
          BGCOLOR 9 FGCOLOR 15 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.57 BY 9.12
         FONT 7 WIDGET-ID 100.


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
         TITLE              = "Articulos que comprometen stock"
         HEIGHT             = 9.12
         WIDTH              = 71.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 83
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 83
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
/* SETTINGS FOR FILL-IN FILL-IN-txt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Articulos que comprometen stock */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos que comprometen stock */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-dir W-Win
ON CHOOSE OF BUTTON-dir IN FRAME F-Main /* ... */
DO:
    DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.
        IF lDirectorio <> "" THEN DO:
             fill-in-txt:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lDirectorio .
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-procesar W-Win
ON CHOOSE OF BUTTON-procesar IN FRAME F-Main /* Procesar */
DO:
    ASSIGN fill-in-txt radio-set-cuales fill-in-desde fill-in-hasta.

    IF FILL-in-desde = ? OR fill-in-hasta = ? THEN DO:
        MESSAGE "Ingrese las fechas correctamente" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    IF FILL-in-desde > fill-in-hasta THEN DO:
        MESSAGE "El rango de las fechas es incorrecto!!!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.


    RUN procesar.

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
  DISPLAY FILL-IN-desde FILL-IN-hasta RADIO-SET-cuales FILL-IN-txt 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-desde FILL-IN-hasta RADIO-SET-cuales BUTTON-dir 
         BUTTON-procesar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  fill-in-txt:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF TRUE <> (fill-in-txt > "") THEN DO:
    MESSAGE "Elija el directorio donde se va a guardar los archivos TXT"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
END.

RUN procesar-otr.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-otr W-Win 
PROCEDURE procesar-otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR cFileTxtOTR AS CHAR.

lProcesaRepo = YES.
lProcesaOTR = YES.

IF radio-set-cuales = 1 THEN lProcesaOTR = NO.
IF radio-set-cuales = 2 THEN lProcesaRepo = NO.

SESSION:SET-WAIT-STATE("GENERAL").

cFileTxtOTR = fill-in-txt + "\RA_OTR_PENDIENTES_TXT.txt".

/* Ordenes de Transferencia */
OUTPUT TO VALUE(cFileTxtOTR).

PUT UNFORMATTED "ALMACEN|NOMBRE|TIPO|SERIE|NUMERO|FECHA|GLOSA|ARTICULO|DESCRIPCION|MARCA|CANTIDAD|UNIDAD|USUARIO|" SKIP.

IF lProcesaOTR THEN DO:
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = 1,
        EACH Faccpedi NO-LOCK WHERE faccpedi.codcia = gn-divi.codcia  AND
        faccpedi.coddiv = gn-divi.coddiv AND
        faccpedi.flgest = "P" AND
        faccpedi.coddoc = "OTR",
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = Faccpedi.codcia AND
        Almacen.codalm = Faccpedi.codalm,
        EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.flgest = "P",
        FIRST Almmmatg OF Facdpedi NO-LOCK:

        IF faccpedi.fchped < fill-in-desde OR faccpedi.fchped > fill-in-hasta THEN NEXT.

        PUT UNFORMATTED
            faccpedi.codalm "|"
            almacen.descripcion "|"
            faccpedi.coddoc "|"
            substr(faccpedi.nroped,1,3) "|"
            substr(faccpedi.nroped,4) "|"
            faccpedi.fchped "|"
            faccpedi.glosa "|"
            facdpedi.codmat "|"
            almmmatg.desmat "|"
            trim(almmmatg.desmar) "|"
            ( facdpedi.factor * (facdpedi.canped - facdpedi.canate) ) "|"
            almmmatg.undstk "|"
            faccpedi.usuario "|"
            SKIP.
    END.
END.

IF lProcesaRepo = YES THEN RUN procesar-reposiciones.

OUTPUT CLOSE.

SESSION:SET-WAIT-STATE("").

MESSAGE "Proceso terminado " SKIP
        VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-reposiciones W-Win 
PROCEDURE procesar-reposiciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cNumero AS CHAR.

FOR EACH almacen NO-LOCK WHERE almacen.codcia = 1,
    EACH almcrepo WHERE almcrepo.codcia = 1 AND almcrepo.almped = almacen.codalm AND
                            lookup(almcrepo.flgest,"P,X") > 0 AND lookup(almcrepo.tipmov,"A,M,RAN,INC") > 0 NO-LOCK,
    EACH almdrepo OF almcrepo NO-LOCK WHERE almdrepo.flgest = 'P',
    FIRST almmmatg OF almdrepo NO-LOCK:

    IF almcrepo.fchdoc < fill-in-desde OR almcrepo.fchdoc > fill-in-hasta THEN NEXT.

    cNumero = string(almcrepo.NroSer,"999") + STRING(almcrepo.NroDoc,"999999").
                        
    PUT UNFORMATTED almcrepo.almped FORMAT 'x(5)' "|"
                    Almacen.Descripcion "|"
                    almcrepo.tipmov FORMAT 'x(5)' "|"
                    almcrepo.NroSer "|"
                    almcrepo.NroDoc "|"
                    almcrepo.fchdoc "|"
                    almcrepo.glosa "|"
                    almdrepo.codmat "|"
                    almmmatg.desmat "|"
                    trim(almmmatg.desmar) "|"
                    (almdrepo.canapro - almdrepo.canaten) "|"
                    almmmatg.undstk "|"
                    almcrepo.usuario "|" SKIP.

END.

END PROCEDURE.


/*

    

    DEFINE VAR cFileTxtReposiciones AS CHAR.

    cFileTxtReposiciones = fill-in-txt + "\Reposiciones_TXT.txt".

        /* Reposiciones e Incidencias */
        /*OUTPUT TO d:\reposicionesv3.txt.*/
        OUTPUT TO VALUE(cFileTxtReposiciones).
        PUT UNFORMATTED
            "ALMACEN|NOMBRE|TIPO|SERIE|NUMERO|FECHA|GLOSA|ARTICULO|DESCRIPCION|MARCA|CANTIDAD|UNIDAD|USUARIO" SKIP.
        SELECT
            almcrepo.almped FORMAT 'x(5)',
            "|",
            Almacen.Descripcion,
            "|",
            almcrepo.tipmov FORMAT 'x(5)',
            "|",
            almcrepo.NroSer,
            "|",
            almcrepo.NroDoc,
            "|",
            almcrepo.fchdoc,
            "|",
            almcrepo.glosa,
            "|",
            almdrepo.codmat,
            "|",
            almmmatg.desmat,
            "|",
            almmmatg.desmar,
            "|",
            (almdrepo.canapro - almdrepo.canaten),
            "|",
            almmmatg.undstk,
            "|",
            almcrepo.usuario,
            "|"
            FROM almcrepo, almdrepo, almacen, almmmatg
            WHERE almcrepo.codcia = 1 AND
            almcrepo.flgest IN ("P","X") AND
            almcrepo.tipmov IN ("A","M","RAN","INC") AND
            
            almacen.codcia = 1 AND
            almacen.codalm = almcrepo.almped AND
            
            almdrepo.codcia = almcrepo.codcia AND
            almdrepo.codalm = almcrepo.codalm AND
            almdrepo.tipmov = almcrepo.tipmov AND
            almdrepo.nroser = almcrepo.nroser AND
            almdrepo.nrodoc = almcrepo.nrodoc AND
            almdrepo.flgest = "P" AND
            
            almmmatg.codcia = 1 AND
            almmmatg.codmat = almdrepo.codmat
            WITH STREAM-IO NO-BOX NO-LABELS WIDTH 320
            .
        OUTPUT CLOSE.
*/

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

