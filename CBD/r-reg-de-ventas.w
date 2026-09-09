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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cb-codcia AS INTE.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEFINE TEMP-TABLE T-CDOC LIKE Ccbcdocu
    FIELD Mon AS CHAR
    FIELD Percepcion AS DECI
    FIELD Totales AS DECI
    FIELD Estado AS CHAR
    FIELD cbd_codcbd AS CHAR
    FIELD cbd_fchdoc AS DATE
    FIELD cbd_codref AS CHAR
    FIELD cbd_nroref AS CHAR
    FIELD cbd_nroast AS CHAR
    .

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD coddoc    AS CHAR     FORMAT 'x(5)'               LABEL 'Codigo'
    FIELD nroser    AS CHAR     FORMAT 'x(3)'               LABEL 'Serie'
    FIELD nrodoc    AS CHAR     FORMAT 'x(10)'              LABEL 'Numero'
    FIELD fchdoc    AS DATE     FORMAT '99/99/9999'         LABEL 'Fecha'
    FIELD nomcli    AS CHAR     FORMAT 'x(100)'             LABEL 'Nombre o Razon Social'
    FIELD ruccli    AS CHAR     FORMAT 'x(15)'              LABEL 'R.U.C.'
    FIELD mon       AS CHAR     FORMAT 'x(5)'               LABEL 'Moneda'
    FIELD impbrt    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Bruto'
    FIELD impdto    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Dscto'
    FIELD impexo    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Exonerado'
    FIELD impvta    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Venta'
    FIELD impigv    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp I.G.V.'
    FIELD imptot    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Sin Percepcion'
    FIELD percepcion AS DECI    FORMAT '->>>,>>>,>>9.99'    LABEL 'Percepcion'
    FIELD totales   AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Total'
    FIELD estado    AS CHAR     FORMAT 'x(15)'              LABEL 'Estado'
    FIELD coddiv    AS CHAR     FORMAT 'x(10)'              LABEL 'Division'
    FIELD fmapgo    AS CHAR     FORMAT 'x(10)'              LABEL 'Cond.Vta'
    FIELD fchvto    AS DATE     FORMAT '99/99/9999'         LABEL 'Vencimiento'
    FIELD cbd_codcbd AS CHAR    FORMAT 'x(5)'               LABEL 'T.D.'
    FIELD cbd_fchdoc AS DATE    FORMAT '99/99/9999'         LABEL 'Fecha'
    FIELD cbd_codref AS CHAR    FORMAT 'x(5)'               LABEL 'Doc'
    FIELD cbd_nroser AS CHAR    FORMAT 'x(5)'               LABEL 'Serie'
    FIELD cbd_nrodoc AS CHAR    FORMAT 'x(10)'              LABEL 'Numero'
    FIELD cbd_nroast AS CHAR    FORMAT 'x(10)'              LABEL 'Asiento'
    .

DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Mes BUTTON-1 ~
BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Mes 

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
     LABEL "&Done" 
     SIZE 9 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 1" 
     SIZE 9 BY 2.15 TOOLTIP "EXPORTAR A TEXTO".

DEFINE VARIABLE COMBO-BOX-Mes AS INTEGER FORMAT ">>9":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Mes AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 4.23 COL 4 WIDGET-ID 6
     BtnDone AT ROW 4.23 COL 13 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.62 WIDGET-ID 100.


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
         TITLE              = "REGISTRO DE VENTAS"
         HEIGHT             = 6.62
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REGISTRO DE VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REGISTRO DE VENTAS */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN COMBO-BOX-Mes COMBO-BOX-Periodo.

  /* Pantalla de Impresión */
  DEF VAR pOptions AS CHAR.
  DEF VAR pArchivo AS CHAR.
  DEF VAR cArchivo AS CHAR.

  RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
  IF pOptions = "" THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE('GENERAL').

  /* Cargamos la informacion al temporal */
  RUN Carga-Temporal.
  RUN Depura-Temporal.
  RUN Carga-Reporte.

  SESSION:SET-WAIT-STATE('').

  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  cArchivo = LC(pArchivo).
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
  SESSION:SET-WAIT-STATE('').
  /* ******************************************************* */
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte W-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NomCli AS CHAR NO-UNDO.
DEF VAR iContador AS INTE NO-UNDO.

EMPTY TEMP-TABLE Detalle.

FOR EACH T-CDOC NO-LOCK BY T-CDOC.FchDoc:
    iContador = iContador + 1.
    IF iContador MODULO 1000 = 0 THEN DO:
        DISPLAY STRING(T-CDOC.FchDoc,'99/99/9999') + ' ' + 
            T-CDOC.coddoc + ' ' +
            T-CDOC.nrodoc  @ Fi-Mensaje LABEL "Carga Reporte"
            WITH FRAME F-Proceso.
    END.
    CREATE Detalle.
    BUFFER-COPY T-CDOC TO Detalle
        ASSIGN
        Detalle.nroser = SUBSTRING(T-CDOC.nrodoc,1,3)
        Detalle.nrodoc = SUBSTRING(T-CDOC.nrodoc,4)
        Detalle.cbd_nroser = SUBSTRING(T-CDOC.cbd_nroref,1,3)
        Detalle.cbd_nrodoc = SUBSTRING(T-CDOC.cbd_nroref,4)
        .
    x-NomCli = Detalle.nomcli.
    RUN lib/limpiar-texto-abc (INPUT Detalle.nomcli,
                               INPUT " ",
                               OUTPUT x-NomCli).
    ASSIGN
        Detalle.nomcli = x-NomCli.

END.
HIDE FRAME F-Proceso.

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

DEF VAR k AS INT NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.
DEFINE VAR x-Comprobantes AS CHAR NO-UNDO.

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.

DEF VAR iContador AS INTE NO-UNDO.

EMPTY TEMP-TABLE T-CDOC.

x-Comprobantes = 'FAC,BOL,N/D,N/C'.

x-FchIni = DATE(COMBO-BOX-Mes,01,COMBO-BOX-Periodo).
x-FchFin = ADD-INTERVAL(x-FchIni,1,'month') - 1.

FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
    Ccbcdocu.fchdoc >= x-FchIni AND
    Ccbcdocu.fchdoc <= x-FchFin:
    IF LOOKUP(Ccbcdocu.coddoc, x-Comprobantes) = 0 THEN NEXT.

    iContador = iContador + 1.
    IF iContador MODULO 1000 = 0 THEN DO:
        DISPLAY STRING(Ccbcdocu.FchDoc,'99/99/9999') + ' ' + 
            Ccbcdocu.coddoc + ' ' +
            Ccbcdocu.nrodoc  @ Fi-Mensaje LABEL "Carga Temporal"
            WITH FRAME F-Proceso.
    END.

    CREATE T-CDOC.
    BUFFER-COPY Ccbcdocu 
        TO T-CDOC
        ASSIGN 
        T-CDOC.ImpDto = T-CDOC.ImpDto + (IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN 0 ELSE Ccbcdocu.Libre_d01)
        T-CDOC.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5] - Ccbcdocu.AcuBon[10].    /* SIN PERCEP */
    /* CASO DE FACTURAS CON APLICACION DE ADELANTOS */
    IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
        AND Ccbcdocu.FlgEst <> 'A' 
        AND Ccbcdocu.ImpTot2 > 0
        THEN DO:
        /* Recalculamos Importes */
        ASSIGN
            T-CDOC.ImpTot2 = Ccbcdocu.ImpTot2
            T-CDOC.ImpTot = T-CDOC.ImpTot - T-CDOC.ImpTot2
            T-CDOC.Libre_d01 = Ccbcdocu.ImpTot.
        IF T-CDOC.ImpTot <= 0 THEN DO:
            ASSIGN
                T-CDOC.ImpTot = 0
                T-CDOC.ImpBrt = 0
                T-CDOC.ImpExo = 0
                T-CDOC.ImpDto = 0
                T-CDOC.ImpVta = 0
                T-CDOC.ImpIgv = 0.
        END.
        ELSE DO:
            x-Factor = T-CDOC.ImpTot / (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]).
            ASSIGN
                T-CDOC.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                T-CDOC.ImpIgv = T-CDOC.ImpTot - T-CDOC.ImpVta.
            ASSIGN
                T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto /*+ T-CDOC.ImpExo*/.
        END.
    END.
    /* Ic - 11Ene2017, no valido para Transferencias Gratuitas */
    IF t-cdoc.fmapgo <> '899' THEN
    ASSIGN
        T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto /*+ T-CDOC.ImpExo*/.
    /* ******************************************** */
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Depura-Temporal W-Win 
PROCEDURE Depura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tpocmb AS DEC NO-UNDO.
DEFINE VAR x-impbrt AS DEC NO-UNDO.
DEFINE VAR x-impdto AS DEC NO-UNDO.
DEFINE VAR x-impexo AS DEC NO-UNDO.
DEFINE VAR x-impvta AS DEC NO-UNDO.
DEFINE VAR x-impigv AS DEC NO-UNDO.
DEFINE VAR x-imptot AS DEC NO-UNDO.
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VAR JJ       AS INTEGER NO-UNDO.
DEFINE VAR lDocSunat AS CHAR.

DEF VAR x-Factor AS DEC NO-UNDO.
DEF VAR iContador AS INTE NO-UNDO.

FOR EACH T-CDOC EXCLUSIVE-LOCK BY T-CDOC.fchdoc:
    iContador = iContador + 1.
    IF iContador MODULO 1000 = 0 THEN DO:
        DISPLAY STRING(T-CDOC.FchDoc,'99/99/9999') + ' ' + 
            T-CDOC.coddoc + ' ' +
            T-CDOC.nrodoc  @ Fi-Mensaje LABEL "Depura Temporal"
            WITH FRAME F-Proceso.
    END.

    x-Factor = IF T-CDOC.coddoc = 'N/C' THEN -1 ELSE 1.
    /* OJO : TODO EN SOLES */
    X-MON = 'S/.'.
    ASSIGN
        x-impbrt = T-CDOC.impbrt
        x-impdto = T-CDOC.impdto
        x-impexo = T-CDOC.impexo
        x-impvta = T-CDOC.impvta
        x-impigv = T-CDOC.impigv
        x-imptot = T-CDOC.imptot.

    CASE T-CDOC.FlgEst :
        WHEN "P" THEN ASSIGN X-EST = "PEN" JJ = T-CDOC.Codmon.
        WHEN "C" THEN ASSIGN X-EST = "CAN" JJ = T-CDOC.Codmon + 2.
        WHEN "A" THEN ASSIGN X-EST = "ANU" JJ = T-CDOC.Codmon + 4.
    END CASE.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= T-CDOC.fchdoc NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN x-tpocmb = gn-tcmb.venta.
    ELSE x-tpocmb = T-CDOC.tpocmb.
    IF T-CDOC.codmon = 2
        THEN ASSIGN
                x-impbrt = ROUND(T-CDOC.impbrt * x-tpocmb, 2)
                x-impdto = ROUND(T-CDOC.impdto * x-tpocmb, 2)
                x-impexo = ROUND(T-CDOC.impexo * x-tpocmb, 2)
                x-impvta = ROUND(T-CDOC.impvta * x-tpocmb, 2)
                x-impigv = ROUND(T-CDOC.impigv * x-tpocmb, 2)
                x-imptot = ROUND(T-CDOC.imptot * x-tpocmb, 2)
                T-CDOC.AcuBon[5] = ROUND(T-CDOC.AcuBon[5] * x-tpocmb, 2).
    IF T-CDOC.FlgEst <> "A" THEN DO:
        ASSIGN
            T-CDOC.Mon = x-Mon
            T-CDOC.impbrt = x-impbrt * x-Factor
            T-CDOC.impdto = x-impdto * x-Factor
            T-CDOC.impexo = x-impexo * x-Factor
            T-CDOC.impvta = x-impvta * x-Factor
            T-CDOC.impigv = x-impigv * x-Factor
            T-CDOC.imptot = x-imptot * x-Factor
            T-CDOC.percepcion = (T-CDOC.AcuBon[5] * x-Factor ) + T-CDOC.AcuBon[10]
            /* Aqui no suma x que el AcuBon[10] ya esta incluido en el total */         
            T-CDOC.totales = (x-imptot + T-CDOC.AcuBon[5] + T-CDOC.AcuBon[10]) * x-Factor   
            T-CDOC.estado = X-EST
            .
    END.
    ELSE DO:
        ASSIGN 
            T-CDOC.Mon = ""
            T-CDOC.impbrt = 0
            T-CDOC.impdto = 0
            T-CDOC.impexo = 0
            T-CDOC.impvta = 0
            T-CDOC.impigv = 0
            T-CDOC.imptot = 0
            T-CDOC.percepcion = 0
            T-CDOC.totales = 0
            T-CDOC.estado = ""
            T-CDOC.nomcli = "*** ANULADO ***".
    END.

    /* Ic - 29Abr2016 */
    lDocSunat = "".
    IF T-CDOC.coddoc = 'N/C' OR T-CDOC.coddoc = 'N/D' THEN DO:
         FIND FIRST FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = T-CDOC.codref NO-LOCK NO-ERROR.
         ASSIGN
             T-CDOC.cbd_codcbd = (IF AVAILABLE facdocum THEN facdocum.codcbd ELSE "")
             T-CDOC.cbd_fchdoc = T-CDOC.fchdoc
             T-CDOC.cbd_codref = T-CDOC.codref
             T-CDOC.cbd_nroref = T-CDOC.nroref
             .
    END.
    FIND FIRST FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = t-cdoc.coddoc NO-LOCK NO-ERROR.
    lDocSunat = IF AVAILABLE facdocum THEN facdocum.codcbd ELSE "**".
    /* nro asto */
    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta BEGINS '12' AND
        cb-ctas.piddoc = YES AND
        cb-ctas.activo = YES,
        EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = YEAR(T-CDOC.fchdoc) AND
        cb-dmov.codcta = cb-ctas.codcta AND
        cb-dmov.coddoc = lDocSunat AND
        cb-dmov.nrodoc = T-CDOC.nrodoc:
        IF cb-dmov.nromes = MONTH(T-CDOC.fchdoc) THEN DO:
            ASSIGN T-CDOC.cbd_nroast = cb-dmov.nroast.
            LEAVE.
        END.
    END.

END.
HIDE FRAME F-Proceso.

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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-Mes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo COMBO-BOX-Mes BUTTON-1 BtnDone 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Periodo:DELETE(1).
      COMBO-BOX-Periodo:ADD-LAST(P-LIST).
      COMBO-BOX-Periodo = INTEGER(ENTRY(NUM-ENTRIES(P-LIST),P-LIST)).
      COMBO-BOX-Mes = MONTH(TODAY).
  END.

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

