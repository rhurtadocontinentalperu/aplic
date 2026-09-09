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
DEF SHARED VAR s-coddiv AS CHAR.

DEF STREAM REPORTE.
DEF BUFFER B-CPEDI FOR faccpedi.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchCot-1 FILL-IN-FchCot-2 BUTTON-2 ~
BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje FILL-IN-FchCot-1 ~
FILL-IN-FchCot-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Salir" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE FILL-IN-FchCot-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Cotizaciones emitidas desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchCot-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Mensaje AT ROW 5.31 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-FchCot-1 AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-FchCot-2 AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 18
     BUTTON-2 AT ROW 1.27 COL 61 WIDGET-ID 14
     BtnDone AT ROW 2.88 COL 61 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.42 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE SEGUIMIENTO DE COTIZACIONES"
         HEIGHT             = 6.42
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE SEGUIMIENTO DE COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE SEGUIMIENTO DE COTIZACIONES */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCot-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCot-1 W-Win
ON LEAVE OF FILL-IN-FchCot-1 IN FRAME F-Main /* Cotizaciones emitidas desde */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCot-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCot-2 W-Win
ON LEAVE OF FILL-IN-FchCot-2 IN FRAME F-Main /* hasta */
DO:
    ASSIGN {&self-name}.
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
  DISPLAY FILL-IN-Mensaje FILL-IN-FchCot-1 FILL-IN-FchCot-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchCot-1 FILL-IN-FchCot-2 BUTTON-2 BtnDone 
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

DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Anticipos AS DEC NO-UNDO.
DEF VAR x-Depositos AS DEC NO-UNDO.
DEF VAR x-Facturado AS DEC NO-UNDO.
DEF VAR x-Tramite AS DEC NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
/* FIJAMOS EL INICIO DE LA CAMPAÑA: VAS A TENER QUE MODIFICARLO CADA CAMPAÑA */
DEF VAR x-FechaInicio AS DATE NO-UNDO.
x-FechaInicio = 10/01/2010.

DEF BUFFER B-CDOCU FOR ccbcdocu.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = 'Evento|Cotizacion|Emision|Entrega|Vendedor|Cliente|Departamento|Provincia|Distrito|Postal|'.
x-Titulo = x-Titulo + 'Total Cotizaciones|Anticipos|Depositos|Total depositos|Facturado|Pedidos en proceso|'.
x-Titulo = x-Titulo + 'Total atendido|Por atender|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9) ).
PUT STREAM REPORTE x-Titulo SKIP.
FOR EACH faccpedi NO-LOCK WHERE codcia = s-codcia
    AND coddiv = s-coddiv
    /* AND codcli = '10040212286'      /* SOLO ES PARA PROBAR */ */
    AND coddoc = 'COT'
    AND fchped >= FILL-IN-FchCot-1 
    AND fchped <= FILL-IN-FchCot-2
    AND LOOKUP(flgest, 'P,C') > 0,
    FIRST gn-ven OF faccpedi NO-LOCK,
    FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = faccpedi.codcli:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +
        'PEDIDO ' + faccpedi.nroped + ' ' + STRING(faccpedi.fchped).
    x-Llave = 'EXPOLIBRERIA|'.
    IF fchped < 01/01/2011 OR UsrSac = '*' THEN x-Llave = 'EXPO OCT 2010|'.
    IF fchped >= 01/01/2011 AND fchped <= 04/30/2011 AND UsrSac <> '*' THEN x-Llave = 'EXPO OCT 2011|'.
    x-Llave = x-Llave + STRING(nroped, '999999999') + '|' + STRING(fchped, '99/99/9999') + '|' + 
                STRING(fchent, '99/99/9999') + '|' +
                faccpedi.codven + ' ' + gn-ven.nomven + '|' +
            faccpedi.codcli + ' ' + faccpedi.nomcli + '|'.
    /* departamento provincia distrito y codipo postal */
    FIND Tabdepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdepto 
    THEN x-Llave = x-Llave + gn-clie.coddept + ' ' + TabDepto.NomDepto + '|'.
    ELSE x-Llave = x-LLave + ' ' + '|'.
    FIND Tabprovi WHERE TabProvi.CodDepto = gn-clie.coddept
        AND TabProvi.CodProvi = gn-clie.codprov NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi 
    THEN x-Llave = x-Llave + gn-clie.coddept + ' ' + TabProvi.NomProvi + '|'.
    ELSE x-Llave = x-Llave + ' ' + '|'.
    FIND Tabdistr WHERE TabDistr.CodDepto = gn-clie.coddept
        AND TabDistr.CodProvi = gn-clie.codprov
        AND TabDistr.CodDistr = gn-clie.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr 
    THEN x-Llave = x-LLave + gn-clie.coddist + ' ' + TabDistr.NomDistr + '|'.
    ELSE x-Llave = x-Llave + ' ' + '|'.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = FacCPedi.CodPos NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla
    THEN x-Llave = x-Llave + faccpedi.codpos + ' ' + almtabla.nombre + '|'.
    ELSE x-Llave = x-LLave + ' ' + '|'.
    x-Llave = x-LLave + STRING(Faccpedi.imptot, '>>>,>>>,>>9.99') + '|'.
    /* Anticipos */
    x-Anticipos = 0.
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc, 'A/R,A/C') > 0
        AND ccbcdocu.codcli = faccpedi.codcli
        AND ccbcdocu.flgest <> 'A'
        AND ccbcdocu.fchdoc >= x-FechaInicio:
/*         AND ccbcdocu.fchdoc >= FILL-IN-FchCot-1  */
/*         AND ccbcdocu.fchdoc <= FILL-IN-FchCot-2: */
        x-Anticipos = x-Anticipos + (IF ccbcdocu.codmon = 1 THEN ccbcdocu.imptot ELSE (ccbcdocu.imptot * ccbcdocu.tpocmb) ).
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +
            'ANTICIPOS ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + STRING(ccbcdocu.fchdoc).
    END.
    x-Llave = x-Llave + STRING(x-Anticipos, '>>>,>>>,>>9.99') + '|'.
    /* Depositos */
    x-Depositos = 0.
    DEPOSITOS:
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = 'BD'
        AND ccbcdocu.coddiv = s-coddiv
        AND ccbcdocu.codcli = faccpedi.codcli
        AND ccbcdocu.flgest <> 'A'
        AND ccbcdocu.fchdoc >= x-FechaInicio:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +
            'DEPOSITOS ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + STRING(ccbcdocu.fchdoc).
        /* FILTRAR los depositos NO asignados a ANTICIPOS DE CAMPAÑA */
        FOR EACH ccbdmov NO-LOCK WHERE ccbdmov.codcia = s-codcia
            AND ccbdmov.coddoc = ccbcdocu.coddoc
            AND ccbdmov.nrodoc = ccbcdocu.nrodoc:
            /* I/C donde se usaron los depositos */
            FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = 1
                AND ccbdcaja.coddoc = ccbdmov.codref
                AND ccbdcaja.nrodoc = ccbdmov.nroref:
                FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
                    AND B-CDOCU.coddoc = ccbdcaja.codref
                    AND B-CDOCU.nrodoc = ccbdcaja.nroref
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-CDOCU AND B-CDOCU.TpoFac = "A" THEN NEXT DEPOSITOS.
            END.
        END.
        /* ********************************************************* */
        x-Depositos = x-Depositos + (IF ccbcdocu.codmon = 1 THEN ccbcdocu.imptot ELSE (ccbcdocu.imptot * ccbcdocu.tpocmb) ).
    END.
    x-Llave = x-Llave + STRING(x-Depositos, '>>>,>>>,>>9.99') + '|'.

    x-LLave = x-Llave + STRING(x-Anticipos + x-Depositos, '>>>,>>>,>>9.99') + '|'.
    /* Facturado */
    x-Facturado = 0.
    FOR EACH B-CPEDI NO-LOCK USE-INDEX LLave07 WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddoc = 'PED'
        AND B-CPEDI.codref = faccpedi.coddoc
        AND B-CPEDI.nroref = faccpedi.nroped
        AND B-CPEDI.flgest <> 'A',
        EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.codped = B-CPEDI.coddoc
        AND ccbcdocu.nroped = B-CPEDI.nroped:
        IF LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN NEXT.
        x-Facturado = x-Facturado + ccbcdocu.imptot.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +
            'FACTURADO ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + STRING(ccbcdocu.fchdoc).
    END.
/*     FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia                                        */
/*         AND B-CPEDI.coddoc = 'PED'                                                                  */
/*         AND B-CPEDI.coddiv = faccpedi.coddiv                                                        */
/*         AND B-CPEDI.codcli = faccpedi.codcli                                                        */
/*         AND B-CPEDI.nroref = faccpedi.nroped                                                        */
/*         AND B-CPEDI.fchped >= FILL-IN-FchCot-1                                                      */
/*         AND B-CPEDI.flgest <> 'A',                                                                  */
/*         EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia                                      */
/*         AND ccbcdocu.codped = B-CPEDI.coddoc                                                        */
/*         AND ccbcdocu.nroped = B-CPEDI.nroped:                                                       */
/*         IF LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN NEXT.                                        */
/*         x-Facturado = x-Facturado + ccbcdocu.imptot.                                                */
/*         FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +         */
/*             'FACTURADO ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + STRING(ccbcdocu.fchdoc). */
/*     END.                                                                                            */
    x-Llave = x-Llave + STRING(x-Facturado, '>>>,>>>,>>9.99') + '|'.
    /* Pedidos en proceso */
    x-Tramite = 0.
    FOR EACH B-CPEDI NO-LOCK USE-INDEX Llave07  WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddoc = 'PED'
        AND B-CPEDI.codref = faccpedi.coddoc
        AND B-CPEDI.nroref = faccpedi.nroped
        AND B-CPEDI.flgest = 'P':
        x-Tramite = x-Tramite + B-CPEDI.imptot.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +
            'PEDIDOS EN TRAMITE ' + B-CPEDI.coddoc + ' ' + B-CPEDI.nroped + ' ' + STRING(B-CPEDI.fchped).
    END.
/*     FOR EACH B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia                                              */
/*         AND B-CPEDI.coddoc = 'PED'                                                                        */
/*         AND B-CPEDI.coddiv = faccpedi.coddiv                                                              */
/*         AND B-CPEDI.codcli = faccpedi.codcli                                                              */
/*         AND B-CPEDI.nroref = faccpedi.nroped                                                              */
/*         AND B-CPEDI.flgest = 'P':                                                                         */
/*         x-Tramite = x-Tramite + B-CPEDI.imptot.                                                           */
/*         FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " +               */
/*             'PEDIDOS EN TRAMITE ' + B-CPEDI.coddoc + ' ' + B-CPEDI.nroped + ' ' + STRING(B-CPEDI.fchped). */
/*     END.                                                                                                  */
    x-Llave = x-Llave + STRING(x-Tramite, '>>>,>>>,>>9.99') + '|'.

    x-LLave = x-LLave + STRING(x-Facturado + x-Tramite, '>>>,>>>,>>9.99') + '|'.
    x-Llave = x-LLave + STRING(Faccpedi.imptot - x-Facturado - x-Tramite, '->>>,>>>,>>9.99') + '|'.

    x-Llave = REPLACE ( x-Llave, '|', CHR(9) ).
    PUT STREAM REPORTE x-LLave SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Seguimiento', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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
      FILL-IN-FchCot-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchCot-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

