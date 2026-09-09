&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-CcbCDocu NO-UNDO LIKE INTEGRAL.CcbCDocu
       Field nItem as int
       index idxItem nitem.



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
DEF SHARED VAR s-codcia  AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.

DEF VAR lGenerar AS INT INIT 0.
DEF NEW SHARED VAR s-coddoc AS CHAR INITIAL "BD".
DEF NEW SHARED VAR s-NroSer LIKE Faccorre.nroser.

/* Control de correlativos */
FIND FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = s-coddoc
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum
THEN DO:
    MESSAGE "No esta definido el documento Boleta Deposito" s-coddoc VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.flgest = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre
THEN DO:
    MESSAGE "No esta definido el correlativo"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEFINE VARIABLE FILL-IN-Archivo AS CHAR         NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG          NO-UNDO.

s-NroSer = Faccorre.nroser.

/* TeleCredito BCP (Válida a partir de la linea 6) */
DEFINE NEW GLOBAL SHARED TEMP-TABLE TeleCredito
    FIELD Fecha AS CHAR     COLUMN-LABEL 'Fecha'    FORMAT 'x(10)'          /* dd/mm/aaaa */
    FIELD FechaValuta AS CHAR COLUMN-LABEL 'Fecha Valuta'   FORMAT 'x(10)'    /* dd/mm/aaaa */
    FIELD DescOperacion AS CHAR COLUMN-LABEL 'Descripción Operación'    FORMAT 'x(22)'
    FIELD Monto AS CHAR COLUMN-LABEL 'Monto'    FORMAT 'x(18)'          /* -9(14).9(2) */
    FIELD Saldo AS CHAR COLUMN-LABEL 'Saldo'    FORMAT 'x(18)'          /* -9(14).9(2) */
    FIELD Sucursal AS CHAR COLUMN-LABEL 'Sucursal-Agencia' FORMAT 'x(7)'        /* SUC-AGE */
    FIELD NumOperacion AS CHAR COLUMN-LABEL 'Operación Número' FORMAT 'x(8)'   
    FIELD HorOperacion AS CHAR COLUMN-LABEL 'Operación Hora' FORMAT 'x(8)'    /* HH:MM:SS */
    FIELD UsuarioX AS CHAR COLUMN-LABEL 'Usuario'    FORMAT 'x(6)'
    FIELD UTC AS CHAR COLUMN-LABEL 'UTC'    FORMAT 'x(6)'
    FIELD Referencia AS CHAR COLUMN-LABEL 'Referencia' FORMAT 'x(22)'
    FIELD Situacion AS CHAR COLUMN-LABEL "Situa" FORMAT "X(25)"
    FIELD nsec AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Telecredito tt-ccbcdocu

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 Fecha FechaValuta DescOperacion Monto /*Saldo*/ Sucursal NumOperacion HorOperacion UsuarioX UTC Referencia situacion   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH Telecredito NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH Telecredito NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 Telecredito
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 Telecredito


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-ccbcdocu.nItem tt-ccbcdocu.NroDoc tt-ccbcdocu.fchdoc tt-ccbcdocu.flgsit tt-ccbcdocu.fchate tt-ccbcdocu.flgate tt-ccbcdocu.codmov tt-ccbcdocu.nroref tt-ccbcdocu.codcta tt-ccbcdocu.glosa tt-ccbcdocu.imptot tt-ccbcdocu.codcli tt-ccbcdocu.nomcli tt-ccbcdocu.usuario tt-ccbcdocu.flgubi tt-ccbcdocu.fchubi   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5   
&Scoped-define SELF-NAME BROWSE-5
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-ccbcdocu
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY {&SELF-NAME} FOR EACH tt-ccbcdocu.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-ccbcdocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-ccbcdocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 BUTTON-3 btnDeposito btnExcel ~
BROWSE-3 BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division FILL-IN-Cuenta ~
FILL-IN-Moneda FILL-IN-TipodeCuenta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnDeposito 
     LABEL "Generar Boletas Deposito" 
     SIZE 20 BY 1.12.

DEFINE BUTTON btnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "txt Telecredito" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Cuenta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Moneda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moneda" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TipodeCuenta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo de Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 149 BY 1.54
     BGCOLOR 11 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      Telecredito SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      tt-ccbcdocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _FREEFORM
  QUERY BROWSE-3 NO-LOCK DISPLAY
      Fecha           FORMAT 'x(12)'
FechaValuta
DescOperacion   FORMAT 'x(30)'
Monto
/*Saldo*/
Sucursal
NumOperacion
HorOperacion
UsuarioX
UTC
Referencia      FORMAT 'x(30)'
situacion       FORMAT "x(30)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 148 BY 10.27
         FONT 4 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _FREEFORM
  QUERY BROWSE-5 DISPLAY
      tt-ccbcdocu.nItem       COLUMN-LABEL "Sec"    FORMAT "9999"
tt-ccbcdocu.NroDoc      COLUMN-LABEL "Nro Boleta"    FORMAT "x(15)"
tt-ccbcdocu.fchdoc      COLUMN-LABEL "F.Proceso"    FORMAT "99/99/9999"
tt-ccbcdocu.flgsit      COLUMN-LABEL "Situacion"    FORMAT "x(15)"
tt-ccbcdocu.fchate      COLUMN-LABEL "F.Deposito"   FORMAT "99/99/9999"
tt-ccbcdocu.flgate      COLUMN-LABEL "Banco" FORMAT "x(3)"
tt-ccbcdocu.codmov      COLUMN-LABEL "Moneda" FORMAT "9"
tt-ccbcdocu.nroref      COLUMN-LABEL "Deposito" FORMAT "x(12)"
tt-ccbcdocu.codcta      COLUMN-LABEL "Cuenta" FORMAT "x(10)"
tt-ccbcdocu.glosa       COLUMN-LABEL "Observaciones" FORMAT "x(60)"
tt-ccbcdocu.imptot      COLUMN-LABEL "Importe"
tt-ccbcdocu.codcli      COLUMN-LABEL "Cod.Clie" FORMAT "x(15)"
tt-ccbcdocu.nomcli      COLUMN-LABEL "Nombre Cliente" FORMAT "x(60)"
tt-ccbcdocu.usuario     COLUMN-LABEL "Usua.Registro"
tt-ccbcdocu.flgubi      COLUMN-LABEL "Usua.Autorizo"
tt-ccbcdocu.fchubi      COLUMN-LABEL "Fech.Autoriza"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 147 BY 11.77
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Division AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-3 AT ROW 2.73 COL 84.72 WIDGET-ID 12
     btnDeposito AT ROW 2.73 COL 101.57 WIDGET-ID 20
     btnExcel AT ROW 2.77 COL 126.29 WIDGET-ID 22
     FILL-IN-Cuenta AT ROW 2.92 COL 5.72 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Moneda AT ROW 2.92 COL 46 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-TipodeCuenta AT ROW 2.92 COL 69.86 COLON-ALIGNED WIDGET-ID 18
     BROWSE-3 AT ROW 4.19 COL 2 WIDGET-ID 200
     BROWSE-5 AT ROW 14.62 COL 2 WIDGET-ID 300
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 149.29 BY 25.62
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-CcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          Field nItem as int
          index idxItem nitem
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Telecredito"
         HEIGHT             = 25.62
         WIDTH              = 149.29
         MAX-HEIGHT         = 25.62
         MAX-WIDTH          = 149.29
         VIRTUAL-HEIGHT     = 25.62
         VIRTUAL-WIDTH      = 149.29
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
/* BROWSE-TAB BROWSE-3 FILL-IN-TipodeCuenta F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-3 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Cuenta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TipodeCuenta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH Telecredito NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH tt-ccbcdocu.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Telecredito */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Telecredito */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDeposito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDeposito W-Win
ON CHOOSE OF btnDeposito IN FRAME F-Main /* Generar Boletas Deposito */
DO:

    IF lGenerar = 0 THEN DO:
        MESSAGE "Aun falta procesar el TXT del Banco" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.
    IF lGenerar = 2 THEN DO:
        MESSAGE "Ya se efectuo el proceso de Generacion de Boleta" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

        MESSAGE 'Seguro de Generar Boleta de Deposito?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN ue-crea-bd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel W-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Excel */
DO:
  RUN ue-excel.

    MESSAGE 'Excel Concluido...' VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* txt Telecredito */
DO:
    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.txt)" "*.txt", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    /* Mensaje de error de carga */
/*     IF pMensaje <> "" THEN DO:                               */
/*         MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.            */
/*         RETURN NO-APPLY.                                     */
/*     END.                                                     */
/*                                                              */
/*     ASSIGN                                                   */
/*         BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.     */
/*     MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

DEF VAR lItem AS INT INIT 1 NO-UNDO.
DEF VAR lNumOp AS CHAR.

EMPTY TEMP-TABLE TeleCredito.

{&OPEN-QUERY-BROWSE-3}

INPUT FROM VALUE(FILL-IN-Archivo).
REPEAT:
    CREATE TeleCredito.
    IMPORT DELIMITER "|" TeleCredito.
END.
INPUT CLOSE.
FOR EACH TeleCredito:
    IF lItem = 1 THEN FILL-IN-Cuenta = TeleCredito.FechaValuta.
    IF lItem = 2 THEN FILL-IN-Moneda = TeleCredito.FechaValuta.
    IF lItem = 3 THEN FILL-IN-TipodeCuenta = TeleCredito.FechaValuta.
    IF lItem < 6 THEN DELETE TeleCredito.
    lItem = lItem + 1.
END.
DISPLAY
    FILL-IN-Cuenta FILL-IN-Moneda FILL-IN-TipodeCuenta WITH FRAME {&FRAME-NAME}.

{&OPEN-QUERY-BROWSE-3}

/**/
DEFINE VAR lNroCta AS CHAR.
DEFINE VAR lCodClie AS CHAR.
lItem = 0.
FOR EACH TeleCredito:  

    lNroCta = SUBSTRING(FILL-IN-Cuenta:SCREEN-VALUE IN FRAME {&FRAME-NAME},1,16).
    FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND cb-ctas.nrocta = lNroCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN DO:
        lCodClie = TRIM(Telecredito.descoperacion).
        IF LENGTH(lCodClie) > 10 THEN DO:
            lCodCLie = SUBSTRING(lCodClie, LENGTH(lCodClie) - 10, 11).
            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = lCodClie NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
                /* Buscar si la operacion de la Boleta de Deposito no esta Repetida */
                lNumOp = TRIM(telecredito.numoperacion).
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.codref = "" AND
                    ccbcdocu.nroref = lNumOp AND ccbcdocu.coddoc = 'BD' NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ccbcdocu THEN DO:
                    lItem = lItem + 1.
                    CREATE tt-ccbcdocu.
                        ASSIGN tt-ccbcdocu.nitem = lItem
                            tt-ccbcdocu.nrodoc = ""
                            tt-ccbcdocu.fchdoc = TODAY
                            tt-ccbcdocu.flgsit = "AUTORIZADA"
                            tt-ccbcdocu.fchate = DATE(telecredito.fecha)
                            tt-ccbcdocu.flgate = cb-ctas.codbco
                            tt-ccbcdocu.codmov = IF(CAPS(FILL-IN-moneda:SCREEN-VALUE IN FRAM {&FRAME-NAME}) = "SOLES") THEN 1 ELSE 2
                            tt-ccbcdocu.codref = ""
                            tt-ccbcdocu.nroref = trim(telecredito.numoperacion)
                            tt-ccbcdocu.tpofac = "EFE"
                            tt-ccbcdocu.tpocmb = IF (AVAILABLE gn-tcmb) THEN gn-tcmb.compra ELSE 0
                            tt-ccbcdocu.codcta = cb-ctas.codcta
                            tt-ccbcdocu.glosa = cb-ctas.nomcta
                            tt-ccbcdocu.codage = "OTROS"
                            tt-ccbcdocu.imptot = DECIMAL(telecredito.monto)
                            tt-ccbcdocu.codcli = lCodClie
                            tt-ccbcdocu.nomcli = gn-clie.nomcli
                            tt-ccbcdocu.usuario = S-USER-ID
                            tt-ccbcdocu.flgubi = s-user-id
                            tt-ccbcdocu.fchubi = TODAY
                            tt-ccbcdocu.flgest = 'C'
                            tt-ccbcdocu.horcie = STRING(TIME,"hh:mm:ss").

                            lGenerar = 1.

                    ASSIGN telecredito.situacion = "OK : Listo para Procesar"
                        telecredito.nsec = lItem.
                END.
                ELSE DO:
                    ASSIGN telecredito.situacion = "ERROR : Numero de operacion YA Existe".
                END.
            END.
            ELSE DO:
                ASSIGN telecredito.situacion = "ERROR : Cliene no Existe".
            END.
        END.
        ELSE DO:
            ASSIGN telecredito.situacion = "ERROR : Cod.Cliente Errado".
        END.
    END.
    ELSE DO:
        ASSIGN telecredito.situacion = "ERROR : Nro de Cta no existe en Plan de Ctas".
    END.
END.

{&OPEN-QUERY-BROWSE-3}

{&OPEN-QUERY-BROWSE-5}

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
  DISPLAY FILL-IN-Division FILL-IN-Cuenta FILL-IN-Moneda FILL-IN-TipodeCuenta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 BUTTON-3 btnDeposito btnExcel BROWSE-3 BROWSE-5 
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
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv
      NO-LOCK.
  FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ccbcdocu"}
  {src/adm/template/snd-list.i "Telecredito"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-crea-bd W-Win 
PROCEDURE ue-crea-bd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lNroBoleta AS CHAR.
DEFINE VAR lMsgError AS CHAR.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lMsgEmail AS CHAR FORMAT "x(250)".

lMsgEmail = "".
lComa = "".

FOR EACH tt-ccbcdocu:    
    /* Valido que el Nro de Operacion NO EXISTA */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.codref = tt-ccbcdocu.codref AND
        ccbcdocu.nroref = tt-ccbcdocu.nroref AND ccbcdocu.coddoc = 'BD' NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ccbcdocu THEN DO:
        FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
            AND  FacCorre.CodDiv = s-coddiv 
            AND  FacCorre.CodDoc = s-coddoc 
            AND  FacCorre.NroSer = s-NroSer
            EXCLUSIVE-LOCK NO-ERROR.

        lMsgError = "".

        IF AVAILABLE FacCorre THEN DO:
            lNroBoleta = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999").
            ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.

            ASSIGN tt-ccbcdocu.nrodoc = lNroBoleta.

            lMsgEmail = lMsgEmail + lComa + lNroBoleta.
            lComa = ", ".

            CREATE ccbcdocu.
            ASSIGN ccbcdocu.coddoc = s-coddoc
                    ccbcdocu.codcia = s-codcia
                    ccbcdocu.nrodoc = tt-ccbcdocu.nrodoc
                    ccbcdocu.fchdoc = tt-ccbcdocu.fchdoc
                    ccbcdocu.flgsit = tt-ccbcdocu.flgsit
                    ccbcdocu.fchate = tt-ccbcdocu.fchate
                    ccbcdocu.flgate = tt-ccbcdocu.flgate
                    ccbcdocu.codmov = tt-ccbcdocu.codmov
                    ccbcdocu.codref = tt-ccbcdocu.codref
                    ccbcdocu.nroref = tt-ccbcdocu.nroref
                    ccbcdocu.tpofac = tt-ccbcdocu.tpofac
                    ccbcdocu.tpocmb = tt-ccbcdocu.tpocmb
                    ccbcdocu.codcta = tt-ccbcdocu.codcta
                    ccbcdocu.glosa = tt-ccbcdocu.glosa
                    ccbcdocu.codage = tt-ccbcdocu.codage
                    ccbcdocu.imptot = ccbcdocu.imptot
                    ccbcdocu.codcli = tt-ccbcdocu.codcli
                    ccbcdocu.nomcli = tt-ccbcdocu.nomcli
                    ccbcdocu.usuario = S-USER-ID
                    ccbcdocu.flgubi = s-user-id
                    ccbcdocu.fchubi = TODAY
                    ccbcdocu.flgest = 'C'
                    ccbcdocu.horcie = STRING(TIME,"hh:mm:ss").

            lGenerar = 2.

            lMsgError = "GENERADO OK".
        END.
        ELSE DO:
            lMsgError = "NO Generado".
        END.

    END.
    ELSE DO:
        lMsgError = "NO Generado - Nro Operacion ya existe".
    END.

    FIND FIRST telecredito WHERE telecredito.nsec = tt-ccbcdocu.nitem EXCLUSIVE NO-ERROR.
    IF AVAILABLE telecredito THEN DO:
        ASSIGN situacion = lMsgError.
    END.
END.

{&OPEN-QUERY-BROWSE-3}

{&OPEN-QUERY-BROWSE-5}

/*MESSAGE lMsgEmail VIEW-AS ALERT-BOX.*/

/* Envio de Email */
IF lMsgEmail <> "" THEN DO:
    def var objMessage as com-handle.
    create "CDO.Message" objMessage.

    lMsgEmail = "Boletas de Deposito autorizadas (" + lMsgEmail + ")" .

    objMessage:Subject = "BOLETAS DE DEPOSITO AUTORIZADAS - CONTINENTAL SAC".
    objMessage:From = "prueba@continentalsa.com.pe".
    objMessage:To = "sleon@continentalsa.com.pe;ciman@continentalsa.com.pe".
    /*objMessage:To = "ciman@continentalsa.com.pe".*/
    objMessage:TextBody = lMsgEmail + CHR(10) + 
        "       VER DETALLE EN MODULO CAJA BANCOS > CONSULTA".
    objMessage:Send().

    RELEASE OBJECT objMessage NO-ERROR.

    /*MESSAGE lMsgEmail VIEW-AS ALERT-BOX.*/

END.


RUN ue-excel.

MESSAGE 'Proceso de Generacion de Boletas de DESPOSITO Terminado' VIEW-AS ALERT-BOX .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("C1"):Font:Bold = TRUE.
chWorkSheet:Range("C1"):Value = "Telecredito - Boletas de Deposito " + STRING(TODAY,"99/99/9999").

/*chWorkSheet:Range("A4:R4"):Font:Bold = TRUE.*/
chWorkSheet:Range("A2"):Value = "F.Proceso".
chWorkSheet:Range("B2"):Value = "Fecha Valuta".
chWorkSheet:Range("C2"):Value = "Descripcion Operacion".
chWorkSheet:Range("D2"):Value = "Monto".
chWorkSheet:Range("E2"):Value = "Sucursal-Agencia".
chWorkSheet:Range("F2"):Value = "Nro Operacion".
chWorkSheet:Range("G2"):Value = "Hora Operacion".
chWorkSheet:Range("H2"):Value = "UTC".
chWorkSheet:Range("I2"):Value = "Referencia".
chWorkSheet:Range("J2"):Value = "Situacion".

DEF VAR x-Column AS INT INIT 74 NO-UNDO.
DEF VAR x-Range  AS CHAR NO-UNDO.

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */
iColumn = 2.
FOR EACH telecredito:
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.fecha.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.fechavaluta.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.descoperacion.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.monto.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.sucursal.
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + telecredito.numoperacion.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.usuarioX.
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.referencia.
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value = telecredito.situacion.
END.

chExcelApplication:Visible = TRUE.

        /* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

/*MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

