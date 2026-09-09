&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME nW-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR INTEGRAL.CcbCDocu.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE INTEGRAL.CcbCDocu
       field Periodo   as char
       field Canal     as character
       field ImpMN     as dec
       field Ubicacion as char
       field Situacion as char
       field Indicador as char.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS nW-Win 
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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.

/* CARGAMOS LAS SEMANAS POSIBLES */
FIND LAST Evtsemana WHERE TODAY >= FecIni AND TODAY <= FecFin NO-LOCK NO-ERROR.
IF NOT AVAILABLE Evtsemana THEN DO:
    MESSAGE 'Debe configurar primero la tabla de semanas para estadísticas'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
DEF VAR x-Sem1-1 AS DATE NO-UNDO.
DEF VAR x-Sem1-2 AS DATE NO-UNDO.
DEF VAR x-Sem2-1 AS DATE NO-UNDO.
DEF VAR x-Sem2-2 AS DATE NO-UNDO.
DEF VAR x-Sem3-1 AS DATE NO-UNDO.
DEF VAR x-Sem3-2 AS DATE NO-UNDO.
DEF VAR x-Sem4-1 AS DATE NO-UNDO.
DEF VAR x-Sem4-2 AS DATE NO-UNDO.
DEF VAR x-Sem5-1 AS DATE NO-UNDO.
DEF VAR x-Sem5-2 AS DATE NO-UNDO.
DEF VAR x-Sem6-1 AS DATE NO-UNDO.
DEF VAR x-Sem6-2 AS DATE NO-UNDO.
DEF VAR x-Label-1 AS CHAR NO-UNDO.
DEF VAR x-Label-2 AS CHAR NO-UNDO.
DEF VAR x-Label-3 AS CHAR NO-UNDO.
DEF VAR x-Label-4 AS CHAR NO-UNDO.
DEF VAR x-Label-5 AS CHAR NO-UNDO.
DEF VAR x-Label-6 AS CHAR NO-UNDO.

DEF VAR x-TpoCmbCmp AS DEC NO-UNDO.
DEF VAR x-TpoCmbVta AS DEC NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.

ASSIGN
    x-Sem1-1 = EvtSemana.FecIni - 7
    x-Sem1-2 = EvtSemana.FecFin - 7
    x-Sem2-1 = EvtSemana.FecIni
    x-Sem2-2 = EvtSemana.FecFin
    x-Sem3-1 = EvtSemana.FecIni + 7
    x-Sem3-2 = EvtSemana.FecFin + 7
    x-Sem4-1 = EvtSemana.FecIni + 7 * 2
    x-Sem4-2 = EvtSemana.FecFin + 7 * 2
    x-Sem5-1 = EvtSemana.FecIni + 7 * 3
    x-Sem5-2 = EvtSemana.FecFin + 7 * 3
    x-Sem6-1 = EvtSemana.FecIni + 7 * 4
    x-Sem6-2 = EvtSemana.FecFin + 7 * 4.
x-Label-2 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND PREV EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-1 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-3 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-4 = "Sem " + STRING(EvtSemana.NroSem, '99').
FIND NEXT EvtSemana NO-LOCK NO-ERROR.
IF AVAILABLE EvtSemana THEN x-Label-5 = "Sem " + STRING(EvtSemana.NroSem, '99').
x-Label-6 = "Por Vencer".

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
&Scoped-Define ENABLED-OBJECTS BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR nW-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-3 AT ROW 1.27 COL 6 WIDGET-ID 10
     Btn_Done AT ROW 1.27 COL 14 WIDGET-ID 12
     f-Mensaje AT ROW 3.42 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 4.23
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: Detalle T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          field Periodo   as char
          field Canal     as character
          field ImpMN     as dec
          field Ubicacion as char
          field Situacion as char
          field Indicador as char
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW nW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "*** PROYECCION DE COBRANZAS ***"
         HEIGHT             = 4.23
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB nW-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW nW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(nW-Win)
THEN nW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME nW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nW-Win nW-Win
ON END-ERROR OF nW-Win /* *** PROYECCION DE COBRANZAS *** */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nW-Win nW-Win
ON WINDOW-CLOSE OF nW-Win /* *** PROYECCION DE COBRANZAS *** */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done nW-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 nW-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK nW-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects nW-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available nW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal nW-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR x-SdoAct AS DEC NO-UNDO.
DEF VAR x-FlgEst AS CHAR INIT "P,J,S".
DEF VAR i AS INT NO-UNDO.
DEF VAR k AS INT INIT 1 NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE Detalle.

DO i = 1 TO NUM-ENTRIES(x-FlgEst):
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
        EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = gn-divi.coddiv
            AND Ccbcdocu.flgest = ENTRY(i, x-FlgEst):
        IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL,LET,CHQ,N/D,N/C') = 0 THEN NEXT.
        IF k = 1 OR ( k >= 1000 AND k MODULO 1000 = 0 ) THEN
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " *** PROCESANDO " +
            ccbcdocu.flgest + " " + 
            ccbcdocu.coddiv + " " +
            ccbcdocu.coddoc + " " +
            ccbcdocu.nrodoc + " " +
            STRING(ccbcdocu.fchdoc) + " ***".
        k = k + 1.
        CREATE Detalle.
        BUFFER-COPY Ccbcdocu TO Detalle.
        IF Detalle.FchVto = ? THEN Detalle.FchVto = Detalle.FchDoc.
        IF Detalle.FchCobranza = ? THEN Detalle.FchCobranza = Detalle.FchDoc.
        /* CARGAMOS EL PERIODO */
        IF Detalle.FchCobranza <= x-Sem1-2 THEN Detalle.Periodo = x-Label-1.
        IF Detalle.FchCobranza >= x-Sem2-1 AND Ccbcdocu.FchCobranza <= x-Sem2-2
            THEN Detalle.Periodo = x-Label-2.
        IF Detalle.FchCobranza >= x-Sem3-1 AND Detalle.FchCobranza <= x-Sem3-2
            THEN Detalle.Periodo = x-Label-3.
        IF Detalle.FchCobranza >= x-Sem4-1 AND Detalle.FchCobranza <= x-Sem4-2
            THEN Detalle.Periodo = x-Label-4.
        IF Detalle.FchCobranza >= x-Sem5-1 AND Detalle.FchCobranza <= x-Sem5-2
            THEN Detalle.Periodo = x-Label-5.
        IF Detalle.FchCobranza >= x-Sem6-1 THEN Detalle.Periodo = x-Label-6.
        /* IMPORTES EN MONEDA NACIONAL */
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= Detalle.FchDoc NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= Detalle.FchDoc NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.
        IF Detalle.codmon = 1 THEN Detalle.ImpMN = Detalle.sdoact.
        ELSE ASSIGN
            Detalle.ImpMN = Detalle.sdoact * x-TpoCmbVta
            Detalle.TpoCmb = x-TpoCmbVta.
        /* UBICACION SOLO LETRAS */
        IF Detalle.CodDoc = 'LET' THEN DO:
            ASSIGN
                Detalle.Ubicacion = 'CARTERA'.      /* por defecto */
            IF Detalle.FlgUbi = 'B' THEN DO:
                RUN gn/fFlgSitCCB (Detalle.FlgSit, OUTPUT pEstado).
                Detalle.Ubicacion = pEstado.
            END.
        END.
        /* SITUACION */
        IF Detalle.FlgEst = "P" THEN DO:
            IF Detalle.FchCobranza <= TODAY THEN Detalle.Situacion = "2. VENCIDA".
            ELSE Detalle.Situacion = "1. POR VENCER".
        END.
        IF Detalle.FlgEst = 'J' THEN Detalle.Situacion = '3. LEGAL'.
        IF Detalle.FlgEst = 'S' THEN Detalle.Situacion = '4. CASTIGADO'.
        /* INDICADOR */
        IF Detalle.coddoc <> 'N/C' THEN DO:
            Detalle.Indicador = Detalle.Ubicacion.
            IF Detalle.coddoc <> 'LET' THEN DO:
                DEF VAR x-Dias AS INT NO-UNDO.
                x-Dias = ABSOLUTE(TODAY - Detalle.FchCobranza).
                IF x-Dias <= 15 THEN Detalle.Indicador = "00-15".
                IF x-Dias > 15 AND x-Dias <= 30 THEN Detalle.Indicador = "16-30".
                IF x-Dias > 30 AND x-Dias <= 60 THEN Detalle.Indicador = "31-60".
                IF x-Dias > 60 AND x-Dias <= 90 THEN Detalle.Indicador = "61-90".
                IF x-Dias > 90 THEN Detalle.Indicador = "91-**".
            END.
        END.
        IF Detalle.coddoc = 'N/C' THEN DO:
/*             /* SALDO DEL CLIENTE */                                                                                                */
/*             x-SdoAct = 0.                                                                                                          */
/*             FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = Detalle.codcia                                                         */
/*                 AND B-CDOCU.codcli = Detalle.codcli                                                                                */
/*                 AND B-CDOCU.flgest = 'P':                                                                                          */
/*                 IF LOOKUP(B-CDOCU.coddoc, 'FAC,BOL,TCK,LET,CHQ,N/D,N/C') = 0 THEN NEXT.                                            */
/*                 /* IMPORTES EN MONEDA NACIONAL */                                                                                  */
/*                 FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= B-CDOCU.FchDoc NO-LOCK NO-ERROR.                                          */
/*                 IF NOT AVAIL Gn-Tcmb THEN                                                                                          */
/*                     FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= B-CDOCU.FchDoc NO-LOCK NO-ERROR.                                     */
/*                 IF AVAIL Gn-Tcmb THEN                                                                                              */
/*                     ASSIGN                                                                                                         */
/*                         x-TpoCmbCmp = Gn-Tcmb.Compra                                                                               */
/*                         x-TpoCmbVta = Gn-Tcmb.Venta.                                                                               */
/*                 IF B-CDOCU.codmon = 1                                                                                              */
/*                 THEN x-SdoAct = x-SdoAct + (IF B-CDOCU.CodDoc = 'N/C' THEN -1 * B-CDOCU.SdoAct ELSE B-CDOCU.SdoAct).               */
/*                 ELSE x-SdoAct = x-SdoAct + (IF B-CDOCU.CodDoc = 'N/C' THEN -1 * B-CDOCU.SdoAct ELSE B-CDOCU.SdoAct) * x-TpoCmbVta. */
/*             END.                                                                                                                   */
/*             IF x-SdoAct > 0 THEN Detalle.Indicador = "SALDO DEUDOR".                                                               */
/*             ELSE Detalle.Indicador = "SALDO ACREEDOR".                                                                             */
            /* CAMBIAMOS SIGNO DEL IMPORTE DE LA NOTA DE CREDITO */
            ASSIGN
                Detalle.ImpTot = -1 * Detalle.ImpTot
                Detalle.SdoAct = -1 * Detalle.SdoAct
                Detalle.ImpMN  = -1 * Detalle.ImpMN.
        END.
        /* CANAL */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = Detalle.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN DO:
            FIND almtabla WHERE almtabla.Tabla = 'CN' 
                AND almtabla.Codigo = gn-clie.Canal NO-LOCK NO-ERROR.
            IF AVAILABLE almtabla THEN Detalle.Canal = almtabla.nombre.
            IF Detalle.nomcli = '' THEN Detalle.nomcli = gn-clie.nomcli.
        END.
    END.
END.
/* DATOS ADICIONALES */
FOR EACH Detalle WHERE Detalle.CodDoc = "N/C" BREAK BY Detalle.codcli:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " *** DATOS ADICIONALES " +
        detalle.coddiv + " " +
        detalle.coddoc + " " +
        detalle.nrodoc + " " +
        STRING(detalle.fchdoc) + " ***".
    IF FIRST-OF(Detalle.codcli) THEN DO:
        /* SALDO DEL CLIENTE */
        x-SdoAct = 0.
        FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = Detalle.codcia
            AND B-CDOCU.codcli = Detalle.codcli
            AND B-CDOCU.flgest = 'P':
            IF LOOKUP(B-CDOCU.coddoc, 'FAC,BOL,TCK,LET,CHQ,N/D,N/C') = 0 THEN NEXT.
            /* IMPORTES EN MONEDA NACIONAL */
            FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= B-CDOCU.FchDoc NO-LOCK NO-ERROR.
            IF NOT AVAIL Gn-Tcmb THEN 
                FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= B-CDOCU.FchDoc NO-LOCK NO-ERROR.
            IF AVAIL Gn-Tcmb THEN 
                ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.
            IF B-CDOCU.codmon = 1 
            THEN x-SdoAct = x-SdoAct + (IF B-CDOCU.CodDoc = 'N/C' THEN -1 * B-CDOCU.SdoAct ELSE B-CDOCU.SdoAct).
            ELSE x-SdoAct = x-SdoAct + (IF B-CDOCU.CodDoc = 'N/C' THEN -1 * B-CDOCU.SdoAct ELSE B-CDOCU.SdoAct) * x-TpoCmbVta.
        END.
    END.
    IF x-SdoAct > 0 THEN Detalle.Indicador = "SALDO DEUDOR".
    ELSE Detalle.Indicador = "SALDO ACREEDOR".
END.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI nW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(nW-Win)
  THEN DELETE WIDGET nW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI nW-Win  _DEFAULT-ENABLE
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
  DISPLAY f-Mensaje 
      WITH FRAME F-Main IN WINDOW nW-Win.
  ENABLE BUTTON-3 Btn_Done 
      WITH FRAME F-Main IN WINDOW nW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW nW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel nW-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /* Cargamos temporal */
    RUN Carga-Temporal.

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE
            'No hay registro a imprimir'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** GENERANDO EXCEL ***".

    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DOC".
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "EMISION".
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "VENCIMIENTO".
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "COBRANZA".
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MON".
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTEMO".
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "TC".
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTEMN".
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MORA".
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CANAL CLIENTE".
    cRange = "N" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "PERIODO".
    cRange = "O" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "SITUACION".
    cRange = "P" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "UBICACION".
    cRange = "Q" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "INDICADOR".

    FOR EACH Detalle NO-LOCK:
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.coddoc.
        cRange = "B" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.nrodoc.
        cRange = "C" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.fchdoc.
        cRange = "D" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.fchvto.
        cRange = "E" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.fchcobranza.
        cRange = "F" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.codcli.
        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.nomcli.
        cRange = "H" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.codmon.
        cRange = "I" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.sdoact.
        cRange = "J" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.tpocmb.
        cRange = "K" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.impMN.
        cRange = "L" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = TODAY - detalle.fchcobranza.
        cRange = "M" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.canal.
        cRange = "N" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.periodo.
        cRange = "O" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.situacion.
        cRange = "P" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.ubicacion.
        cRange = "Q" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.indicador.
    END.

    /* launch Excel so it is visible to the user */
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit nW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records nW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed nW-Win 
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

