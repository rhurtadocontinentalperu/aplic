&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-w-report NO-UNDO LIKE w-report.



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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR s-task-no AS INTE NO-UNDO.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodDiv AS CHAR FORMAT 'x(8)' LABEL 'División'
    FIELD NomDiv AS CHAR FORMAT 'x(40)' LABEL 'Descripción'
    FIELD FChCie AS DATE FORMAT '99/99/9999' LABEL 'Fecha de Cierre'
    FIELD HorCie AS CHAR FORMAT 'x(8)' LABEL 'Hora Cierre'
    FIELD Usuario AS CHAR FORMAT 'x(15)' LABEL 'Cajero'
    FIELD NomUser AS CHAR FORMAT 'x(40)' LABEL 'Nombre'
    FIELD EfeDec AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Efectivo Declarado'
    FIELD EfeSis AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Efectivo Sistemas'
    FIELD Diferencia AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Diferencia'
    FIELD TotTar AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Total Tarjetas'
    FIELD RemBov AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Remesa a Bóveda'
    .

DEFINE STREAM REPORTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-w-report.Campo-C[1] ~
t-w-report.Campo-C[2] t-w-report.Campo-D[1] t-w-report.Campo-C[30] ~
t-w-report.Campo-C[3] t-w-report.Campo-C[4] t-w-report.Campo-F[1] ~
t-w-report.Campo-F[2] t-w-report.Campo-F[5] t-w-report.Campo-F[3] ~
t-w-report.Campo-F[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Exportar BUTTON-1 x-FchCie-1 ~
x-FchCie-2 BUTTON-Cargar BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS f-Division x-FchCie-1 x-FchCie-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-Cargar 
     IMAGE-UP FILE "IMG/proces.bmp":U
     LABEL "Cargar BD" 
     SIZE 15 BY 1.62 TOOLTIP "Cargar la BD a exportar a texto".

DEFINE BUTTON BUTTON-Exportar 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Exportar" 
     SIZE 15 BY 1.62 TOOLTIP "Exportar".

DEFINE VARIABLE f-Division AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 85 BY 2.15 NO-UNDO.

DEFINE VARIABLE x-FchCie-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Cerrados desde el" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchCie-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-w-report.Campo-C[1] COLUMN-LABEL "División" FORMAT "X(8)":U
      t-w-report.Campo-C[2] COLUMN-LABEL "Descripción" FORMAT "X(40)":U
      t-w-report.Campo-D[1] COLUMN-LABEL "Fecha de Cierre" FORMAT "99/99/9999":U
            WIDTH 11.14
      t-w-report.Campo-C[30] COLUMN-LABEL "Hora Cierre" FORMAT "X(8)":U
      t-w-report.Campo-C[3] COLUMN-LABEL "Cajero" FORMAT "X(8)":U
            WIDTH 8.43
      t-w-report.Campo-C[4] COLUMN-LABEL "Nombre" FORMAT "X(40)":U
            WIDTH 33.72
      t-w-report.Campo-F[1] COLUMN-LABEL "Efectivo Declarado" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 13.14
      t-w-report.Campo-F[2] COLUMN-LABEL "Efectivo Sistemas" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 13.14
      t-w-report.Campo-F[5] COLUMN-LABEL "Diferencia" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 13.14
      t-w-report.Campo-F[3] COLUMN-LABEL "Total Tarjetas" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 13.14
      t-w-report.Campo-F[4] COLUMN-LABEL "Remesa a Bóveda" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 13.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 171 BY 19.65
         FONT 4
         TITLE "VISTA PREVIA".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-Division AT ROW 1.27 COL 22 NO-LABEL WIDGET-ID 14
     BUTTON-Exportar AT ROW 1.27 COL 135 WIDGET-ID 12
     BUTTON-1 AT ROW 1.27 COL 108 WIDGET-ID 2
     x-FchCie-1 AT ROW 3.42 COL 20 COLON-ALIGNED WIDGET-ID 6
     x-FchCie-2 AT ROW 4.38 COL 20 COLON-ALIGNED WIDGET-ID 8
     BUTTON-Cargar AT ROW 1.27 COL 120 WIDGET-ID 10
     BROWSE-2 AT ROW 5.31 COL 2 WIDGET-ID 200
     "División:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.54 COL 16 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 173.57 BY 24.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RESUMEN CIERRES DE CAJA"
         HEIGHT             = 24.77
         WIDTH              = 173.57
         MAX-HEIGHT         = 24.77
         MAX-WIDTH          = 191.43
         VIRTUAL-HEIGHT     = 24.77
         VIRTUAL-WIDTH      = 191.43
         MAX-BUTTON         = no
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 BUTTON-Cargar F-Main */
/* SETTINGS FOR EDITOR f-Division IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-w-report.Campo-C[1]
"t-w-report.Campo-C[1]" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-w-report.Campo-C[2]
"t-w-report.Campo-C[2]" "Descripción" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-w-report.Campo-D[1]
"t-w-report.Campo-D[1]" "Fecha de Cierre" ? "date" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-w-report.Campo-C[30]
"t-w-report.Campo-C[30]" "Hora Cierre" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-w-report.Campo-C[3]
"t-w-report.Campo-C[3]" "Cajero" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-w-report.Campo-C[4]
"t-w-report.Campo-C[4]" "Nombre" "X(40)" "character" ? ? ? ? ? ? no ? no no "33.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-w-report.Campo-F[1]
"t-w-report.Campo-F[1]" "Efectivo Declarado" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-w-report.Campo-F[2]
"t-w-report.Campo-F[2]" "Efectivo Sistemas" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-w-report.Campo-F[5]
"t-w-report.Campo-F[5]" "Diferencia" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-w-report.Campo-F[3]
"t-w-report.Campo-F[3]" "Total Tarjetas" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-w-report.Campo-F[4]
"t-w-report.Campo-F[4]" "Remesa a Bóveda" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RESUMEN CIERRES DE CAJA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RESUMEN CIERRES DE CAJA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  /*RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).*/
  RUN gn/d-selecciona-divisiones.w (OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cargar W-Win
ON CHOOSE OF BUTTON-Cargar IN FRAME F-Main /* Cargar BD */
DO:
  ASSIGN F-Division x-FchCie-1 x-FchCie-2.

  IF ABSOLUTE( INTERVAL(x-FchCie-1, x-FchCie-2, 'MONTHS') ) > 6 THEN DO:
      MESSAGE 'Se ha solicitado información con una antiguedad mayor de 6 meses' SKIP
          'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO x-FchCie-1.
          RETURN NO-APPLY.
      END.
  END.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Exportar W-Win
ON CHOOSE OF BUTTON-Exportar IN FRAME F-Main /* Exportar */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DEF VAR x-Cierre AS DATE NO-UNDO.
  DEF VAR x-CodDiv LIKE GN-DIVI.CodDiv NO-UNDO.

  EMPTY TEMP-TABLE t-w-report.

  s-task-no = 0.

  DO i = 1 TO NUM-ENTRIES(f-Division):
      x-CodDiv = ENTRY(i, f-Division).
      /* Se barre los cierres de caja en el rango de fechas */
      DO x-Cierre = x-fchcie-1 TO x-fchcie-2:
          FOR EACH Ccbcierr NO-LOCK WHERE Ccbcierr.codcia = s-codcia AND Ccbcierr.fchcie = x-Cierre:
              IF NOT CAN-FIND(FIRST Ccbccaja WHERE Ccbccaja.codcia = s-codcia AND
                              Ccbccaja.usuario = Ccbcierr.usuario AND
                              Ccbccaja.flgcie = "C" AND
                              Ccbccaja.fchcie = Ccbcierr.fchcie AND
                              Ccbccaja.horcie = Ccbcierr.horcie AND
                              Ccbccaja.coddiv = x-CodDiv AND
                              LOOKUP(ccbccaja.coddoc, "I/C,E/C") > 0 AND
                              Ccbccaja.flgest <> "A"
                              NO-LOCK)
                  THEN NEXT.
              RUN Carga-Detalle (x-Cierre, x-CodDiv).
          END.
      END.
  END.

END PROCEDURE.


PROCEDURE Carga-Detalle:

    DEF INPUT PARAMETER pFchCie AS DATE.
    DEF INPUT PARAMETER pCodDiv AS CHAR.
    
    DEFINE VARIABLE user_name AS CHARACTER NO-UNDO.
    DEFINE VARIABLE monto_decNac AS DECI NO-UNDO.
    DEFINE VARIABLE monto_nac AS DECI NO-UNDO.
    
    /* Cajero */
    FIND DICTDB._user WHERE DICTDB._user._userid = CcbCierr.usuario NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._user THEN user_name = DICTDB._user._user-name.
    IF TRUE <> (USER_name > '') THEN DO:
        FIND FIRST gn-users WHERE gn-users.codcia = s-codcia AND 
            gn-user.USER-ID = CcbCierr.usuario
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-users THEN USER_name = gn-users.User-Name.
    END.

    /* Efectivo Declarado */
    ASSIGN
        monto_decNac = 0.
    FIND CCBDECL WHERE CCBDECL.CODCIA  = S-CODCIA AND
        CCBDECL.USUARIO = CCBCIERR.USUARIO AND
        CCBDECL.FCHCIE  = CCBCIERR.FCHCIE AND
        CCBDECL.HORCIE  = CCBCIERR.HORCIE NO-LOCK.
    IF NOT AVAILABLE CCBDECL THEN NEXT.
    ASSIGN
        monto_decNac = CCBDECL.ImpNac[1].
    /* Creamos registro */
    CREATE t-w-report.
    ASSIGN
        t-w-report.Task-No = s-task-no
        t-w-report.Llave-C = s-user-id.
    /* División */
    ASSIGN
        t-w-report.Campo-C[1] = pCodDiv.
    FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
        GN-DIVI.CodDiv = pCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN t-w-report.Campo-C[2] = GN-DIVI.DesDiv.
    /* Fecha de Cierre */
    ASSIGN
        t-w-report.Campo-D[1] = CcbCierr.FchCie
        t-w-report.Campo-C[30] = CcbCierr.HorCie.
    /* Cajero */
    ASSIGN
        t-w-report.Campo-C[3] = CcbCierr.usuario
        t-w-report.Campo-C[4] = USER_name.
    /* Efectivo Declarado */
    ASSIGN
        t-w-report.Campo-F[1] = monto_decNac.
    /* Barremos I/C y E/C */
    DEF VAR j AS INTE NO-UNDO.

    FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia AND
        Ccbccaja.usuario = Ccbcierr.usuario AND
        Ccbccaja.flgcie = "C" AND
        Ccbccaja.fchcie = Ccbcierr.fchcie AND
        Ccbccaja.horcie = Ccbcierr.horcie AND
        Ccbccaja.coddiv = pCodDiv:
        IF LOOKUP(ccbccaja.coddoc, "I/C,E/C") = 0 THEN NEXT.
        IF Ccbccaja.flgest = "A" THEN NEXT.
        
        /* Efectivo Sistemas */
        DO j = 1 TO 10:
            IF CcbCCaja.ImpNac[j] <> 0 OR CcbCCaja.Impusa[j] <> 0 THEN DO:
                /* Descuenta Vuelto */
                /*RDP01 - Parche No descuenta vuelto */
                IF j = 1 THEN DO:
                    ASSIGN
                        monto_nac = CcbCCaja.ImpNac[j] - CcbCCaja.VueNac.
                END.
                ELSE DO:
                    ASSIGN
                        monto_nac = CcbCCaja.ImpNac[j].
                END.
                IF ccbccaja.coddoc = "I/C" AND j = 1 THEN DO:
                    /* Guarda Efectivo Recibido */
                    t-w-report.Campo-F[2] = t-w-report.Campo-F[2] + monto_Nac.
                END.
                /* Total Tarjetas Sistemas */
                IF j >= 2 AND j <= 4 AND Ccbccaja.coddoc = "I/C" THEN DO:
                    t-w-report.Campo-F[3] = t-w-report.Campo-F[3] + monto_nac.
                END.
            END.
        END.
        /* Tarjeta Puntos */
        IF ccbccaja.coddoc = "I/C" AND (CcbCCaja.TarPtoNac <> 0 OR CcbCCaja.TarPtoUsa <> 0) THEN DO:
            /* Guarda Efectivo Recibido */
            t-w-report.Campo-F[2] = t-w-report.Campo-F[2] + CcbCCaja.TarPtoNac.
        END.
        /* Remesa a Bóveda */
        IF Ccbccaja.tipo = "REMEBOV" AND Ccbccaja.coddoc = "E/C" THEN DO:
            t-w-report.Campo-F[4] = t-w-report.Campo-F[4] + CcbCCaja.ImpNac[1].
        END.
    END.
    /* Diferencia */
    FOR EACH t-w-report EXCLUSIVE-LOCK WHERE t-w-report.Task-No = s-task-no AND t-w-report.Llave-C = s-user-id:
        t-w-report.Campo-F[5] = t-w-report.Campo-F[1] - t-w-report.Campo-F[2].
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Old W-Win 
PROCEDURE Carga-Temporal-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  21/03/2024: Se va a usar una tabla temporal t-w-report
------------------------------------------------------------------------------*/

/*   DEF VAR i AS INT NO-UNDO.                                                                             */
/*   DEF VAR x-Cierre AS DATE NO-UNDO.                                                                     */
/*   DEF VAR x-CodDiv LIKE GN-DIVI.CodDiv NO-UNDO.                                                         */
/*                                                                                                         */
/*   FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.Llave-C = s-user-id AND w-report.Task-No = s-task-no: */
/*       DELETE w-report.                                                                                  */
/*   END.                                                                                                  */
/*   RELEASE w-report.                                                                                     */
/*                                                                                                         */
/*   s-task-no = 0.                                                                                        */
/*   REPEAT:                                                                                               */
/*       s-task-no = RANDOM(1,999999).                                                                     */
/*       IF NOT CAN-FIND(FIRST w-report WHERE w-report.Task-No = s-task-no AND                             */
/*                       w-report.Llave-C = s-user-id NO-LOCK)                                             */
/*           THEN DO:                                                                                      */
/*           CREATE w-report.                                                                              */
/*           ASSIGN                                                                                        */
/*               w-report.Task-No = s-task-no                                                              */
/*               w-report.Llave-C = s-user-id                                                              */
/*               w-report.Llave-I = 1.     /* Para borrar */                                               */
/*           LEAVE.                                                                                        */
/*       END.                                                                                              */
/*   END.                                                                                                  */
/*                                                                                                         */
/*   DO i = 1 TO NUM-ENTRIES(f-Division):                                                                  */
/*       x-CodDiv = ENTRY(i, f-Division).                                                                  */
/*       /* Se barre los cierres de caja en el rango de fechas */                                          */
/*       DO x-Cierre = x-fchcie-1 TO x-fchcie-2:                                                           */
/*           FOR EACH Ccbcierr NO-LOCK WHERE Ccbcierr.codcia = s-codcia AND Ccbcierr.fchcie = x-Cierre:    */
/*               IF NOT CAN-FIND(FIRST Ccbccaja WHERE Ccbccaja.codcia = s-codcia AND                       */
/*                               Ccbccaja.usuario = Ccbcierr.usuario AND                                   */
/*                               Ccbccaja.flgcie = "C" AND                                                 */
/*                               Ccbccaja.fchcie = Ccbcierr.fchcie AND                                     */
/*                               Ccbccaja.horcie = Ccbcierr.horcie AND                                     */
/*                               Ccbccaja.coddiv = x-CodDiv AND                                            */
/*                               LOOKUP(ccbccaja.coddoc, "I/C,E/C") > 0 AND                                */
/*                               Ccbccaja.flgest <> "A"                                                    */
/*                               NO-LOCK)                                                                  */
/*                   THEN NEXT.                                                                            */
/*               RUN Carga-Detalle (x-Cierre, x-CodDiv).                                                   */
/*           END.                                                                                          */
/*       END.                                                                                              */
/*   END.                                                                                                  */
/*   FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.Llave-C = s-user-id AND                               */
/*       w-report.Task-No = s-task-no AND                                                                  */
/*       w-report.Llave-I = 1:                                                                             */
/*       DELETE w-report.                                                                                  */
/*   END.                                                                                                  */
/*   RELEASE w-report.                                                                                     */

END PROCEDURE.


/* PROCEDURE Carga-Detalle:                                                                                  */
/*                                                                                                           */
/*     DEF INPUT PARAMETER pFchCie AS DATE.                                                                  */
/*     DEF INPUT PARAMETER pCodDiv AS CHAR.                                                                  */
/*                                                                                                           */
/*     DEFINE VARIABLE user_name AS CHARACTER NO-UNDO.                                                       */
/*     DEFINE VARIABLE monto_decNac AS DECI NO-UNDO.                                                         */
/*     DEFINE VARIABLE monto_nac AS DECI NO-UNDO.                                                            */
/*                                                                                                           */
/*     /* Cajero */                                                                                          */
/*     FIND DICTDB._user WHERE DICTDB._user._userid = CcbCierr.usuario NO-LOCK NO-ERROR.                     */
/*     IF AVAILABLE DICTDB._user THEN user_name = DICTDB._user._user-name.                                   */
/*     IF TRUE <> (USER_name > '') THEN DO:                                                                  */
/*         FIND FIRST gn-users WHERE gn-users.codcia = s-codcia AND                                          */
/*             gn-user.USER-ID = CcbCierr.usuario                                                            */
/*             NO-LOCK NO-ERROR.                                                                             */
/*         IF AVAILABLE gn-users THEN USER_name = gn-users.User-Name.                                        */
/*     END.                                                                                                  */
/*                                                                                                           */
/*     /* Efectivo Declarado */                                                                              */
/*     ASSIGN                                                                                                */
/*         monto_decNac = 0.                                                                                 */
/*     FIND CCBDECL WHERE CCBDECL.CODCIA  = S-CODCIA AND                                                     */
/*         CCBDECL.USUARIO = CCBCIERR.USUARIO AND                                                            */
/*         CCBDECL.FCHCIE  = CCBCIERR.FCHCIE AND                                                             */
/*         CCBDECL.HORCIE  = CCBCIERR.HORCIE NO-LOCK.                                                        */
/*     IF NOT AVAILABLE CCBDECL THEN NEXT.                                                                   */
/*     ASSIGN                                                                                                */
/*         monto_decNac = CCBDECL.ImpNac[1].                                                                 */
/*     /* Creamos registro */                                                                                */
/*     CREATE w-report.                                                                                      */
/*     ASSIGN                                                                                                */
/*         w-report.Task-No = s-task-no                                                                      */
/*         w-report.Llave-C = s-user-id.                                                                     */
/*     /* División */                                                                                        */
/*     ASSIGN                                                                                                */
/*         w-report.Campo-C[1] = pCodDiv.                                                                    */
/*     FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND                                                      */
/*         GN-DIVI.CodDiv = pCodDiv NO-LOCK NO-ERROR.                                                        */
/*     IF AVAILABLE gn-divi THEN w-report.Campo-C[2] = GN-DIVI.DesDiv.                                       */
/*     /* Fecha de Cierre */                                                                                 */
/*     ASSIGN                                                                                                */
/*         w-report.Campo-D[1] = CcbCierr.FchCie                                                             */
/*         w-report.Campo-C[30] = CcbCierr.HorCie.                                                           */
/*     /* Cajero */                                                                                          */
/*     ASSIGN                                                                                                */
/*         w-report.Campo-C[3] = CcbCierr.usuario                                                            */
/*         w-report.Campo-C[4] = USER_name.                                                                  */
/*     /* Efectivo Declarado */                                                                              */
/*     ASSIGN                                                                                                */
/*         w-report.Campo-F[1] = monto_decNac.                                                               */
/*     /* Barremos I/C y E/C */                                                                              */
/*     DEF VAR j AS INTE NO-UNDO.                                                                            */
/*                                                                                                           */
/*     FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia AND                                        */
/*         Ccbccaja.usuario = Ccbcierr.usuario AND                                                           */
/*         Ccbccaja.flgcie = "C" AND                                                                         */
/*         Ccbccaja.fchcie = Ccbcierr.fchcie AND                                                             */
/*         Ccbccaja.horcie = Ccbcierr.horcie AND                                                             */
/*         Ccbccaja.coddiv = pCodDiv:                                                                        */
/*         IF LOOKUP(ccbccaja.coddoc, "I/C,E/C") = 0 THEN NEXT.                                              */
/*         IF Ccbccaja.flgest = "A" THEN NEXT.                                                               */
/*                                                                                                           */
/*         /* Efectivo Sistemas */                                                                           */
/*         DO j = 1 TO 10:                                                                                   */
/*             IF CcbCCaja.ImpNac[j] <> 0 OR CcbCCaja.Impusa[j] <> 0 THEN DO:                                */
/*                 /* Descuenta Vuelto */                                                                    */
/*                 /*RDP01 - Parche No descuenta vuelto */                                                   */
/*                 IF j = 1 THEN DO:                                                                         */
/*                     ASSIGN                                                                                */
/*                         monto_nac = CcbCCaja.ImpNac[j] - CcbCCaja.VueNac.                                 */
/*                 END.                                                                                      */
/*                 ELSE DO:                                                                                  */
/*                     ASSIGN                                                                                */
/*                         monto_nac = CcbCCaja.ImpNac[j].                                                   */
/*                 END.                                                                                      */
/*                 IF ccbccaja.coddoc = "I/C" AND j = 1 THEN DO:                                             */
/*                     /* Guarda Efectivo Recibido */                                                        */
/*                     w-report.Campo-F[2] = w-report.Campo-F[2] + monto_Nac.                                */
/*                 END.                                                                                      */
/*                 /* Total Tarjetas Sistemas */                                                             */
/*                 IF j >= 2 AND j <= 4 AND Ccbccaja.coddoc = "I/C" THEN DO:                                 */
/*                     w-report.Campo-F[3] = w-report.Campo-F[3] + monto_nac.                                */
/*                 END.                                                                                      */
/*             END.                                                                                          */
/*         END.                                                                                              */
/*         /* Tarjeta Puntos */                                                                              */
/*         IF ccbccaja.coddoc = "I/C" AND (CcbCCaja.TarPtoNac <> 0 OR CcbCCaja.TarPtoUsa <> 0) THEN DO:      */
/*             /* Guarda Efectivo Recibido */                                                                */
/*             w-report.Campo-F[2] = w-report.Campo-F[2] + CcbCCaja.TarPtoNac.                               */
/*         END.                                                                                              */
/*         /* Remesa a Bóveda */                                                                             */
/*         IF Ccbccaja.tipo = "REMEBOV" AND Ccbccaja.coddoc = "E/C" THEN DO:                                 */
/*             w-report.Campo-F[4] = w-report.Campo-F[4] + CcbCCaja.ImpNac[1].                               */
/*         END.                                                                                              */
/*     END.                                                                                                  */
/*     /* Diferencia */                                                                                      */
/*     FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.Task-No = s-task-no AND w-report.Llave-C = s-user-id: */
/*         w-report.Campo-F[5] = w-report.Campo-F[1] - w-report.Campo-F[2].                                  */
/*     END.                                                                                                  */
/*                                                                                                           */
/* END PROCEDURE.                                                                                            */
/*                                                                                                           */

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
  DISPLAY f-Division x-FchCie-1 x-FchCie-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-Exportar BUTTON-1 x-FchCie-1 x-FchCie-2 BUTTON-Cargar BROWSE-2 
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

/* Definimos variables para generar el texto */
DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

/* Usamos la secuencia "sec-arc" */
x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".


x-Titulo = 'División|Descripción|Fecha de cierre|Hora Cierre|Cajero|Nombre|Efectivo Declarado|' +
    'Efectivo Sistemas|Diferencia|Total Tarjetas|Remesa Bóveda'.


SESSION:SET-WAIT-STATE("GENERAL").
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).      /* OJO */
PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
FOR EACH t-w-report NO-LOCK:
    x-Llave = t-w-report.campo-c[1] + '|'.
    x-Llave = x-Llave + t-w-report.campo-c[2] + '|'.
    x-Llave = x-Llave  + STRING(t-w-report.campo-d[1], '99/99/9999') + '|'.
    x-Llave = x-Llave  + t-w-report.campo-c[30] + '|'.
    x-Llave = x-Llave  + t-w-report.campo-c[3] + '|'.
    x-Llave = x-Llave  + t-w-report.campo-c[4] + '|'.
    x-Llave = x-Llave  + STRING(t-w-report.campo-f[1], '->>>,>>>,>>9.99') + '|'.
    x-Llave = x-Llave  + STRING(t-w-report.campo-f[2], '->>>,>>>,>>9.99') + '|'.
    x-Llave = x-Llave  + STRING(t-w-report.campo-f[5], '->>>,>>>,>>9.99') + '|'.
    x-Llave = x-Llave  + STRING(t-w-report.campo-f[3], '->>>,>>>,>>9.99') + '|'.
    x-Llave = x-Llave  + STRING(t-w-report.campo-f[4], '->>>,>>>,>>9.99').
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-LLave SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
SESSION:SET-WAIT-STATE("").
/* ******************************************************* */
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Resumen de Cierres de Caja', YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Old W-Win 
PROCEDURE Excel-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlyexcel (OUTPUT pOptions, INPUT-OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    FOR EACH t-w-report NO-LOCK:
        CREATE Detalle.
        ASSIGN
            Detalle.coddiv = t-w-report.campo-c[1]
            Detalle.nomdiv = t-w-report.campo-c[2]
            Detalle.fchcie = t-w-report.campo-d[1]
            Detalle.horcie = t-w-report.campo-c[30]
            Detalle.usuario = t-w-report.campo-c[3]
            Detalle.nomuser = t-w-report.campo-c[4]
            Detalle.efedec = t-w-report.campo-f[1]
            Detalle.efesis = t-w-report.campo-f[2]
            Detalle.diferencia = t-w-report.campo-f[5]
            Detalle.tottar = t-w-report.campo-f[3]
            Detalle.rembov = t-w-report.campo-f[4]
            .
    END.

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
  F-Division = s-coddiv.
  x-FchCie-1 = TODAY.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-w-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    FOR EACH w-report NO-LOCK WHERE w-report.Llave-C = s-user-id AND w-report.Task-No = s-task-no:
        CREATE Detalle.
        ASSIGN
            Detalle.coddiv = w-report.campo-c[1]
            Detalle.nomdiv = w-report.campo-c[2]
            Detalle.fchcie = w-report.campo-d[1]
            Detalle.horcie = w-report.campo-c[30]
            Detalle.usuario = w-report.campo-c[3]
            Detalle.nomuser = w-report.campo-c[4]
            Detalle.efedec = w-report.campo-f[1]
            Detalle.efesis = w-report.campo-f[2]
            Detalle.diferencia = w-report.campo-f[5]
            Detalle.tottar = w-report.campo-f[3]
            Detalle.rembov = w-report.campo-f[4]
            .
    END.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

