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
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle
    FIELD coddiv LIKE ccbccaja.coddiv   LABEL 'DIVISION'
    FIELD fchcie LIKE ccbccaja.fchcie   LABEL 'FECHA'
    FIELD tipo   LIKE ccbccaja.tipo     LABEL 'TIPO'            FORMAT 'x(20)'
    FIELD concepto AS CHAR              LABEL 'CONCEPTO'        FORMAT 'x(20)'
    FIELD moneda AS CHAR                LABEL 'MONEDA'
    FIELD importe AS DEC                LABEL 'IMPORTE'.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-FchCie-1 x-FchCie-2 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Division x-FchCie-1 x-FchCie-2 ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division(es)" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchCie-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchCie-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.38 COL 2 WIDGET-ID 6
     F-Division AT ROW 1.38 COL 12 COLON-ALIGNED WIDGET-ID 8
     x-FchCie-1 AT ROW 2.35 COL 12 COLON-ALIGNED WIDGET-ID 10
     x-FchCie-2 AT ROW 3.31 COL 12 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Mensaje AT ROW 5.04 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     Btn_OK AT ROW 5.04 COL 54 WIDGET-ID 16
     Btn_Cancel AT ROW 5.04 COL 66 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.23
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
         TITLE              = "REPORTE DE INGRESOS A CAJA POR CONCEPTOS"
         HEIGHT             = 6.23
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE INGRESOS A CAJA POR CONCEPTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE INGRESOS A CAJA POR CONCEPTOS */
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
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN f-division x-fchcie-1 x-fchcie-2.
  IF f-division = '' THEN DO:
    MESSAGE 'Ingrese al menos una division' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  DEF VAR pArchivo AS CHAR NO-UNDO.
  DEF VAR pOptions AS CHAR NO-UNDO.

  RUN lib/tt-file-to-text (OUTPUT pOptions, OUTPUT pArchivo).
  IF pOptions = "" THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').

  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division(es) */
DO:
    ASSIGN F-Division.
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

  DEF VAR i AS INT NO-UNDO.
  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-CodDiv LIKE GN-DIVI.CodDiv NO-UNDO.
  
  EMPTY TEMP-TABLE Detalle.
  
  DO i = 1 TO NUM-ENTRIES(f-Division):
      x-CodDiv = ENTRY(i, f-Division).
      /* 1ro. INGRESOS A CAJA */
      FOR EACH Ccbccaja NO-LOCK USE-INDEX Llave08 WHERE Ccbccaja.codcia = s-codcia
          AND Ccbccaja.coddiv = x-coddiv
          AND Ccbccaja.coddoc = "I/C"
          AND Ccbccaja.flgcie = 'C'
          AND Ccbccaja.fchcie >= x-fchcie-1
          AND Ccbccaja.fchcie <= x-fchcie-2
          AND Ccbccaja.flgest <> "A":
          IF NOT (Ccbccaja.tipo = 'CANCELACION' OR Ccbccaja.tipo = 'MOSTRADOR') THEN NEXT.
          FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
               'DIVISION: ' + ccbccaja.coddiv + 
               ' DIA:' + STRING(ccbccaja.fchcie).
          DO k = 1 TO 10:
              IF NOT (k = 1 OR k = 2 OR k = 3 OR k = 4 OR k = 7) THEN NEXT.
              IF Ccbccaja.ImpNac[k] > 0 THEN DO:
                  CREATE Detalle.
                  ASSIGN
                      Detalle.coddiv = Ccbccaja.coddiv
                      Detalle.fchcie = Ccbccaja.fchdoc
                      Detalle.tipo   = Ccbccaja.tipo
                      Detalle.moneda = 'SOLES'
                      Detalle.importe = Ccbccaja.ImpNac[k] - (IF k = 1 THEN Ccbccaja.vuenac ELSE 0).
                  CASE Ccbccaja.tipo:
                      WHEN 'ANTREC'         THEN Detalle.tipo = 'ANTICIPO'.
                      WHEN 'CANCELACION'    THEN Detalle.tipo = 'CREDITO'.
                      WHEN 'MOSTRADOR'      THEN Detalle.tipo = 'CONTADO'.
                      WHEN 'SENCILLO'       THEN Detalle.tipo = 'SENCILLO CAJA'.
                  END CASE.
                  ASSIGN
                      Detalle.Tipo = "CAJA COBRANZAS".
                  CASE k:
                      WHEN 1 THEN Detalle.concepto = "EFECTIVO".
                      WHEN 2 THEN Detalle.concepto = "CHEQUE DEL DIA".
                      WHEN 3 THEN Detalle.concepto = "CHEQUE DIFERIDO".
                      WHEN 4 THEN Detalle.concepto = "TARJETA DE CREDITO".
                      WHEN 5 THEN Detalle.concepto = "BOLETA DE DEPOSITO".
                      WHEN 6 THEN Detalle.concepto = "NOTA DE CREDITO".
                      WHEN 7 THEN Detalle.concepto = "ADELANTO".
                      WHEN 8 THEN Detalle.concepto = "COMISIONES".
                      WHEN 9 THEN Detalle.concepto = "RETENCIONES".
                      WHEN 10 THEN Detalle.concepto = "VALES".
                  END CASE.
              END.
              IF Ccbccaja.ImpUsa[k] > 0 THEN DO:
                  CREATE Detalle.
                  ASSIGN
                      Detalle.coddiv = Ccbccaja.coddiv
                      Detalle.fchcie = Ccbccaja.fchdoc
                      Detalle.tipo   = Ccbccaja.tipo
                      Detalle.moneda = 'DOLARES'
                      Detalle.importe = Ccbccaja.ImpUsa[k] - (IF k = 1 THEN Ccbccaja.vueusa ELSE 0).
                  CASE Ccbccaja.tipo:
                      WHEN 'ANTREC'         THEN Detalle.tipo = 'ANTICIPO'.
                      WHEN 'CANCELACION'    THEN Detalle.tipo = 'CREDITO'.
                      WHEN 'MOSTRADOR'      THEN Detalle.tipo = 'CONTADO'.
                      WHEN 'SENCILLO'       THEN Detalle.tipo = 'SENCILLO CAJA'.
                  END CASE.
                  ASSIGN
                      Detalle.Tipo = "CAJA COBRANZAS".
                  CASE k:
                      WHEN 1 THEN Detalle.concepto = "EFECTIVO".
                      WHEN 2 THEN Detalle.concepto = "CHEQUE DEL DIA".
                      WHEN 3 THEN Detalle.concepto = "CHEQUE DIFERIDO".
                      WHEN 4 THEN Detalle.concepto = "TARJETA DE CREDITO".
                      WHEN 5 THEN Detalle.concepto = "BOLETA DE DEPOSITO".
                      WHEN 6 THEN Detalle.concepto = "NOTA DE CREDITO".
                      WHEN 7 THEN Detalle.concepto = "ADELANTO".
                      WHEN 8 THEN Detalle.concepto = "COMISIONES".
                      WHEN 9 THEN Detalle.concepto = "RETENCIONES".
                      WHEN 10 THEN Detalle.concepto = "VALES".
                  END CASE.
              END.
          END.
      END.
      /* 2do BOLETAS DE DEPOSITO */
      FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
          AND Ccbcdocu.coddiv = x-coddiv
          AND Ccbcdocu.coddoc = "BD"
          AND Ccbcdocu.fchdoc >= x-fchcie-1
          AND Ccbcdocu.fchdoc <= x-fchcie-2:
          IF Ccbcdocu.flgest = "A" OR Ccbcdocu.flgest = "E" THEN NEXT.
          FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
               'DIVISION: ' + ccbcdocu.coddiv + 
               ' DIA:' + STRING(ccbcdocu.fchdoc).
          CREATE Detalle.
          ASSIGN
              Detalle.coddiv = Ccbcdocu.coddiv
              Detalle.fchcie = Ccbcdocu.fchdoc
              Detalle.tipo   = "BANCOS"
              Detalle.concepto = "BOLETA DE DEPOSITO"
              Detalle.moneda = (IF Ccbcdocu.codmon = 1 THEN 'SOLES' ELSE 'DOLARES')
              Detalle.importe = Ccbcdocu.ImpTot.
      END.
  END.
  FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DISPLAY F-Division x-FchCie-1 x-FchCie-2 FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-FchCie-1 x-FchCie-2 Btn_OK Btn_Cancel 
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
  ASSIGN
      x-FchCie-1 = TODAY - DAY(TODAY) + 1
      x-FchCie-2 = TODAY.

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

