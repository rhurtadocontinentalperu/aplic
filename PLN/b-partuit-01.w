&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-Periodo AS INT.
DEFINE SHARED VAR s-NroMes AS INT.

DEFINE VARIABLE total_ingresos AS DECIMAL NO-UNDO.
DEFINE VARIABLE total_dias AS DECIMAL NO-UNDO.
DEFINE VARIABLE s-task-no AS INT INITIAL 0 NO-UNDO.

DEF TEMP-TABLE detalle
    FIELD codper LIKE pl-pers.codper
    FIELD valcal-mes AS DEC EXTENT 4000.
DEFINE STREAM REPORTE.

DEF TEMP-TABLE calculados
    FIELD DNI AS CHAR       FORMAT 'x(11)'  LABEL 'DNI'
    FIELD CodPer AS CHAR    FORMAT 'x(6)'   LABEL 'CODIGO'
    FIELD NomPer AS CHAR    FORMAT 'x(40)'  LABEL 'NOMBRE'
    FIELD DiasLab AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'DIAS LABORADOS'
    FIELD RemPer  AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'REMUN. PERCIBIDAS'
    FIELD DiasLabT AS DEC   FORMAT '->>>,>>>,>>9.99'    LABEL 'DIAS LABOR. POR LOS TRAB.'
    FIELD RemPerT AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'REMUN. PERCIBIDAS POR LOS TRAB.'
    FIELD ParDias AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'PARTICIP. POR DIAS LABORADOS'
    FIELD ParRem AS DEC     FORMAT '->>>,>>>,>>9.99'    LABEL 'PARTICIP. POR REMUNERACIONES'
    FIELD Deduc AS DEC      FORMAT '->>>,>>>,>>9.99'    LABEL 'DEDUCCIONES'
    FIELD TOTAL AS DEC      FORMAT '->>>,>>>,>>9.99'    LABEL 'TOTAL A PAGAR'
    FIELD VContr AS DATE    FORMAT '99/99/9999'         LABEL 'FECHA CESE'
    FIELD FecIng AS DATE    FORMAT '99/99/9999'         LABEL 'FECHA INGRESO'
    INDEX llave01 AS PRIMARY codper.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table w-report.Llave-I w-report.Campo-C[1] w-report.Campo-F[2] /*WIDTH 11.43*/ w-report.Campo-F[1] w-report.Campo-F[4] w-report.Campo-F[5] w-report.Campo-F[6] w-report.Campo-F[7] w-report.Campo-F[3] w-report.Campo-F[8] w-report.Campo-D[1] w-report.Campo-D[2]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table w-report.Campo-F[3]   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table w-report
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table CASE RADIO-SET-Orden:     WHEN 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report         WHERE w-report.Task-No = s-task-no         AND w-report.Llave-C = s-user-id NO-LOCK BY w-report.llave-i INDEXED-REPOSITION.     WHEN 2 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report         WHERE w-report.Task-No = s-task-no         AND w-report.Llave-C = s-user-id NO-LOCK BY w-report.campo-c[1] INDEXED-REPOSITION. END CASE.
&Scoped-define TABLES-IN-QUERY-br_table w-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table w-report


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-Orden BUTTON-1 BUTTON-4 ~
FILL-IN-renta br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Orden COMBO-BOX-Periodo ~
FILL-IN-renta f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CALCULAR UTILIDADES" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "HOJA DE TRABAJO EN EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "GUARDAR CALCULOS" 
     SIZE 24 BY 1.12.

DEFINE BUTTON BUTTON-Excel 
     LABEL "EXPORTAR A EXCEL" 
     SIZE 18 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Ejercicio Gravable" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-renta AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Renta Anual" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Orden AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Codigo", 1,
"Nombre", 2
     SIZE 12 BY 1.62 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      w-report.Llave-I COLUMN-LABEL "Código" FORMAT "999999":U
      w-report.Campo-C[1] COLUMN-LABEL "Trabajador" FORMAT "X(35)":U
            WIDTH 31.86
      w-report.Campo-F[2] COLUMN-LABEL "Dias!Laborados" FORMAT "->>>>,>>9.99":U
            /*WIDTH 11.43*/
      w-report.Campo-F[1] COLUMN-LABEL "Remuneraciones!percibidas" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.43
      w-report.Campo-F[4] COLUMN-LABEL "Dias Laborados!por los trabajadores" FORMAT "->>>>>,>>9.99":U
            WIDTH 14.43
      w-report.Campo-F[5] COLUMN-LABEL "Remuneraciones!percibidas!por los trabajadores" FORMAT "->>,>>>,>>9.99":U
            WIDTH 13.43
      w-report.Campo-F[6] COLUMN-LABEL "Participacion!por dias laborados" FORMAT "->>,>>>,>>9.99":U
      w-report.Campo-F[7] COLUMN-LABEL "Participacion!por remuneraciones" FORMAT "->>,>>>,>>9.99":U
            WIDTH 14
      w-report.Campo-F[3] COLUMN-LABEL "Deducciones 5ta" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.43
      w-report.Campo-F[8] COLUMN-LABEL "Total a pagar" FORMAT "->>,>>>,>>9.99":U
            WIDTH 10.72
      w-report.Campo-D[1] COLUMN-LABEL "Fecha de Cese" FORMAT "99/99/9999"
      w-report.Campo-D[2] COLUMN-LABEL "Fecha de Ingreso" FORMAT "99/99/9999"
    ENABLE w-report.Campo-F[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 146 BY 13.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-Orden AT ROW 1 COL 13 NO-LABEL WIDGET-ID 10
     COMBO-BOX-Periodo AT ROW 1 COL 38 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.27 COL 53 WIDGET-ID 6
     BUTTON-Excel AT ROW 1.27 COL 73 WIDGET-ID 20
     BUTTON-4 AT ROW 1.27 COL 91 WIDGET-ID 16
     BUTTON-5 AT ROW 1.27 COL 116 WIDGET-ID 18
     FILL-IN-renta AT ROW 1.81 COL 38 COLON-ALIGNED WIDGET-ID 4
     br_table AT ROW 2.88 COL 1
     f-Mensaje AT ROW 16.19 COL 82 NO-LABEL WIDGET-ID 8
     "Ordenado por:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.27 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 17.62
         WIDTH              = 146.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-renta F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Excel IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN COMBO-BOX-Periodo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
CASE RADIO-SET-Orden:
    WHEN 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report
        WHERE w-report.Task-No = s-task-no
        AND w-report.Llave-C = s-user-id NO-LOCK BY w-report.llave-i INDEXED-REPOSITION.
    WHEN 2 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report
        WHERE w-report.Task-No = s-task-no
        AND w-report.Llave-C = s-user-id NO-LOCK BY w-report.campo-c[1] INDEXED-REPOSITION.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CALCULAR UTILIDADES */
DO:
    ASSIGN
        COMBO-BOX-Periodo FILL-IN-renta.
    IF FILL-IN-renta <= 0 THEN DO:
        MESSAGE 'Ingrese la Renta Anual' VIEW-AS ALERT-BOX WARNING.
        APPLY 'entry' TO FILL-IN-Renta.
        RETURN NO-APPLY.
    END.
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            BUTTON-1:SENSITIVE = NO
            FILL-IN-renta:SENSITIVE = NO
            BUTTON-5:SENSITIVE = YES
            BUTTON-Excel:SENSITIVE = YES.
    END.
    RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* HOJA DE TRABAJO EN EXCEL */
DO:
    ASSIGN
        COMBO-BOX-Periodo FILL-IN-renta.
    RUN Hoja-Trabajo-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* GUARDAR CALCULOS */
DO:
    MESSAGE 'Se va a proceder a grabar los cálculos en las planillas' SKIP
        'Continuamos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
   RUN Guarda-Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel B-table-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* EXPORTAR A EXCEL */
DO:
    ASSIGN COMBO-BOX-Periodo FILL-IN-renta.

    EMPTY TEMP-TABLE Calculados.
    DEF BUFFER b-report FOR w-report.
    DEF VAR x-NomPer AS CHAR NO-UNDO.

    SESSION:SET-WAIT-STATE('GENERAL').
    FOR EACH b-report NO-LOCK WHERE b-report.Task-No = s-task-no
        AND b-report.Llave-C = s-user-id:
        CREATE Calculados.
        ASSIGN
            Calculados.dni = b-report.Campo-C[2]
            Calculados.codper = STRING(b-report.llave-i, '999999')
            Calculados.nomper = b-report.campo-c[1]
            Calculados.diaslab = b-report.campo-f[2]
            Calculados.remper  = b-report.campo-f[1]
            Calculados.diaslabt = b-report.campo-f[4]
            Calculados.rempert = b-report.campo-f[5]
            Calculados.pardias = b-report.campo-f[6]
            Calculados.parrem = b-report.campo-f[7]
            Calculados.deduc = b-report.campo-f[3]
            Calculados.TOTAL = b-report.campo-f[8]
            Calculados.VContr = b-report.campo-d[1]
            Calculados.FecIng = b-report.campo-d[2]
            .
        RUN lib/limpiar-texto (Calculados.nomper,'',OUTPUT x-NomPer).
        Calculados.nomper = x-NomPer.
    END.

    DEF VAR pOptions AS CHAR INIT ''.
    DEF VAR pArchivo AS CHAR INIT ''.

    ASSIGN
        pOptions = "FileType:XLS" + CHR(1) + ~
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:no" + CHR(1) + ~
              "Labels:yes".
    RUN lib/tt-file (TEMP-TABLE Calculados:HANDLE, pArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Orden B-table-Win
ON VALUE-CHANGED OF RADIO-SET-Orden IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* CALCULO BASE */
total_ingresos = 0.
total_dias = 0.

SESSION:SET-WAIT-STATE('GENERAL').
REPEAT:
    s-task-no = RANDOM(1, 999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
END.

/* Empleados */ 
/*
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados */
    PL-MOV-MES.CodCal = 01 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 101 OR                                 /* Basico */
    PL-MOV-MES.CodMov = 103 OR                                  /* Asig. Familiar */
    PL-MOV-MES.CodMov = 106 OR                                  /* Vacacional */
    PL-MOV-MES.CodMov = 107 OR                                  /* Vacaciones Trabajadas*/
    PL-MOV-MES.CodMov = 108 OR                                  /* Vacaciones Truncas */
    PL-MOV-MES.CodMov = 118 OR                                  /* Descanso medico */
    PL-MOV-MES.CodMov = 125 OR                                  /* HE 25% */
    PL-MOV-MES.CodMov = 126 OR                                  /* HE 100% */
    PL-MOV-MES.CodMov = 127 OR                                  /* HE 35% */
    PL-MOV-MES.CodMov = 131 OR                                  /* Bonificacion Incentivo */
    PL-MOV-MES.CodMov = 134 OR                                  /* Bonificacion Especial */
    PL-MOV-MES.CodMov = 136 OR                                  /* Reintegro */
    PL-MOV-MES.CodMov = 138 OR                                  /* Asignación Extraordinaria */
    PL-MOV-MES.CodMov = 139 OR                                  /* Gratificacion Trunca */
    PL-MOV-MES.CodMov = 801 OR                                  /* Bonificacion por Produccion */
    PL-MOV-MES.CodMov = 802 OR                                  /* Bonificacion Nocturna */
    PL-MOV-MES.CodMov = 803 OR                                  /* Subsidio Pre-Post Natal */
     PL-MOV-MES.CodMov = 130 OR                                  /* Otros Ingresos */
     PL-MOV-MES.CodMov = 146 OR                                  /* Riesgo de Caja */
     PL-MOV-MES.CodMov = 209 OR                                  /* Comisiones */
    PL-MOV-MES.CodMov = 100)                                    /* Dias Calendarios */
*/
/* Boleta de Remuneraciones */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Remuneraciones".
FOR EACH PL-MOV-MES USE-INDEX IDX01 WHERE {pln/partuti-rem-01.i} NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 100 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-MES.ValCal-Mes.
            total_dias = total_dias + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.
/* RHC 30/03/2015 Subsidio por Incapacidada temporal */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Subsidios".
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 00 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 118                                     /* Subsidio */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-MES.ValCal-Mes.
    total_dias = total_dias + PL-MOV-MES.ValCal-Mes.
END.
/* ************************************************* */

/* Boleta de Gratificaciones */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Gratificaciones".
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 04 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 212                                     /* Gratificacion */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Liquidaciones".
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 05 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                  /* Liq Acumulada */
    PL-MOV-MES.CodMov = 139)                                     /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion de Eventuales */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Liquidaciones eventuales".
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 08 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                 /* Acumu. Vacaciones */
    PL-MOV-MES.CodMov = 611)                                    /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.

/* TOTAL A PAGAR */
FOR EACH w-report WHERE w-report.Task-No = s-task-no 
    AND w-report.Llave-C = s-user-id:
    ASSIGN
        w-report.campo-f[4] = total_dias
        w-report.campo-f[5] = total_ingresos
        w-report.campo-f[6] = (w-report.campo-f[2] * (FILL-IN-Renta * 0.5) / total_dias)
        w-report.campo-f[7] = (w-report.campo-f[1] * (FILL-IN-Renta * 0.5) / total_ingresos)
        w-report.campo-f[8] = w-report.campo-f[6] + w-report.campo-f[7].
    IF w-report.campo-f[8] <= 0 THEN DELETE w-report.
END.
/* RHC 04.04.2012 AGREGAMOS QUINTA CATEGORIA SOLO LOS QUE SIGUEN TRABAJANDO */
DEF VAR pPorcentaje AS DEC INIT 0.15.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Quinta Categoria".
FOR EACH pl-flg-mes NO-LOCK WHERE pl-flg-mes.codcia = s-codcia
    AND pl-flg-mes.periodo = s-Periodo 
    AND pl-flg-mes.nromes = s-NroMes,
    FIRST pl-pers WHERE pl-pers.codper = pl-flg-mes.codper NO-LOCK:
    IF PL-FLG-MES.Vcontr <> ? AND PL-FLG-MES.Vcontr < DATE(S-NROMES, 01, S-PERIODO) THEN NEXT.
    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-FLG-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN NEXT.
    /* RHC 19.04.2012 SE TRABAJA CON EL SUELDO PROYECTADO */
    RUN Quinta-Categoria (OUTPUT pPorcentaje).
    /* ************************************************** */
    /* ACUMULAMOS DESCUENTO POR QUINTA CATEGORIA */
    /* RHC 17/05/2013 NO deducimos 5ta categoria (solicitado por Carmen Alvarez) */
    ASSIGN
        w-report.Campo-F[3] = ( w-report.Campo-F[6] + w-report.Campo-F[7] ) * pPorcentaje
        w-report.campo-f[8] = w-report.campo-f[6] + w-report.campo-f[7] /*- w-report.campo-f[3]*/.
    IF w-report.campo-f[8] <= 0 THEN DELETE w-report.
END.
/* RHC 27/03/2018 Fecha de Cese Walter Alegre */
FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.Task-No = s-task-no AND w-report.Llave-C = s-user-id:
    FOR EACH PL-FLG-MES USE-INDEX IDX02 NO-LOCK WHERE PL-FLG-MES.CodCia = s-codcia 
        AND PL-FLG-MES.codper = STRING(w-report.llave-i, '999999'):
        w-report.campo-d[1] = PL-FLG-MES.VContr.
        w-report.campo-d[2] = PL-FLG-MES.FecIng.
    END.
END.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro B-table-Win 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER cCodPer AS CHAR.
DEF INPUT PARAMETER dMontoPagar AS DEC.
DEF INPUT PARAMETER iCodCal AS INT.
DEF INPUT PARAMETER iCodMov AS INT.

    CREATE pl-mov-mes.
    ASSIGN
        pl-mov-mes.CodCia = s-CodCia
        pl-mov-mes.Periodo = s-periodo
        pl-mov-mes.NroMes = s-nromes
        pl-mov-mes.codpln = 01
        pl-mov-mes.codcal = iCodCal
        pl-mov-mes.codper = cCodper
        pl-mov-mes.CodMov = iCodMov
        pl-mov-mes.valcal-mes = dMontoPagar
        pl-mov-mes.flgreg-mes = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Guarda-Calculo B-table-Win 
PROCEDURE Guarda-Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dMontoPagar AS DECIMAL NO-UNDO.
DEFINE VARIABLE cCodPer AS CHARACTER NO-UNDO.

/* Limpiamos informacion */
SESSION:SET-WAIT-STATE('general').
FOR EACH pl-mov-mes WHERE codcia = s-codcia
    AND periodo = s-periodo
    AND nromes = s-nromes
    AND codpln = 01
    AND codcal = 00     /* Ingreso Manual */
    AND codmov = 137:
    DELETE pl-mov-mes.
END.
FOR EACH pl-mov-mes WHERE codcia = s-codcia
    AND periodo = s-periodo
    AND nromes = s-nromes
    AND codpln = 01
    AND codcal = 20     /* Participación de utilidades */
    AND (codmov = 900 OR codmov = 901 OR codmov = 902
         OR codmov = 903 OR codmov = 904 OR codmov = 905
         OR codmov = 906 OR codmov = 907):
    DELETE pl-mov-mes.
END.
/* Cargamos calculado */
FOR EACH w-report WHERE w-report.task-no = s-task-no AND
    w-report.Llave-C = s-user-id:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = w-report.campo-c[1].
    cCodPer = STRING(w-report.Llave-I,"999999").
    dMontoPagar = w-report.campo-f[8].
    RUN Graba-Registro (cCodPer, dMontoPagar, 00, 137).
    dMontoPagar = FILL-IN-renta.
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 900).
    dMontoPagar =  w-report.campo-f[4].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 901).
    dMontoPagar =  w-report.campo-f[2].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 902).
    dMontoPagar =  w-report.campo-f[5].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 903).
    dMontoPagar =  w-report.campo-f[1].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 904).
    dMontoPagar =  w-report.campo-f[6].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 905).
    dMontoPagar =  w-report.campo-f[7].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 906).
    dMontoPagar =  w-report.campo-f[3].
    RUN Graba-Registro (cCodPer, dMontoPagar, 20, 907).
END.
IF AVAILABLE(pl-mov-mes) THEN RELEASE pl-mov-mes.
/* limpiamos temporal */
FOR EACH w-report WHERE w-report.task-no = s-task-no AND
    w-report.Llave-C = s-user-id:
    DELETE w-report.
END.
IF AVAILABLE(w-report) THEN RELEASE w-report.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        BUTTON-1:SENSITIVE = YES
        FILL-IN-renta:SENSITIVE = YES
        BUTTON-5:SENSITIVE = NO.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hoja-Trabajo-Excel B-table-Win 
PROCEDURE Hoja-Trabajo-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE detalle.

/* Boleta de Remuneraciones */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Remuneraciones".
FOR EACH PL-MOV-MES NO-LOCK WHERE
    {pln/partuti-rem-01.i}
    :
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[pl-mov-mes.codmov] = detalle.valcal-mes[pl-mov-mes.codmov] + pl-mov-mes.valcal-mes.
END.
/* Boleta de Gratificaciones */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Gratificaciones".
DEF VAR x-codmov AS INT.
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 04 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 212                                     /* Gratificacion */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    x-CodMov = pl-mov-mes.codmov + 1000.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[x-codmov] = detalle.valcal-mes[x-codmov] + pl-mov-mes.valcal-mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Liquidacion".
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 05 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                  /* Liq Acumulada */
    PL-MOV-MES.CodMov = 139)                                     /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    x-CodMov = pl-mov-mes.codmov + 2000.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[x-codmov] = detalle.valcal-mes[x-codmov] + pl-mov-mes.valcal-mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion de Eventuales */
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Liquidacion Eventuales".
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 08 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                 /* Acumu. Vacaciones */
    PL-MOV-MES.CodMov = 611)                                    /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    x-CodMov = pl-mov-mes.codmov + 3000.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[x-codmov] = detalle.valcal-mes[x-codmov] + pl-mov-mes.valcal-mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-linea AS CHAR FORMAT 'x(1000)'.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-linea = 'PERSONAL|101|103|106|107|108|118|125|126|127|131|134|136|138|139|801|802|803|130|146|209|'.
x-linea = x-linea + '212|'.
x-linea = x-linea + '431|139|'.
x-linea = x-linea + '431|611|'.
x-linea = x-linea + 'DIAS EFECTIVOS|'.
x-linea = REPLACE(x-linea, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTED x-linea SKIP.
FOR EACH detalle, FIRST pl-pers WHERE pl-pers.codper = detalle.codper NO-LOCK:
    x-linea = detalle.codper + ' - ' +
                TRIM (pl-pers.patper) + TRIM (pl-pers.matper) + ', ' + 
                TRIM(pl-pers.nomper) + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[101], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[103], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[106], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[107], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[108], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[118], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[125], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[126], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[127], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[131], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[134], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[136], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[138], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[139], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[801], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[802], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[803], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[130], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[146], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[209], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[1212], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[2431], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[2139], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[3431], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[3611], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[100], '>>>,>>9.99') + '|'.
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-linea SKIP.
END.
OUTPUT CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Utilidades', YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      w-report.campo-f[8] = w-report.campo-f[6] + w-report.campo-f[7] - w-report.campo-f[3].
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-4:SENSITIVE = YES
          BUTTON-5:SENSITIVE = YES
          RADIO-SET-Orden:SENSITIVE = YES
          BUTTON-Excel:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-4:SENSITIVE = NO 
          BUTTON-5:SENSITIVE = NO 
          RADIO-SET-Orden:SENSITIVE = NO
          BUTTON-Excel:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  COMBO-BOX-Periodo = s-Periodo - 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Quinta-Categoria B-table-Win 
PROCEDURE Quinta-Categoria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pPorcentaje AS DEC.

FIND LAST PL-VAR-MES WHERE PL-VAR-MES.Periodo = s-Periodo 
    AND PL-VAR-MES.NroMes <= s-NroMes NO-LOCK.

/* CALCULO DE IMPUESTO A LA RENTA DE QUINTA CATEGORIA */
DEF VAR AFECTO-QUINTA-CATEGORIA AS DEC INIT 0 NO-UNDO.
DEF VAR PROMEDIO-HORAS-EXTRAS AS DEC INIT 0 NO-UNDO.
DEF VAR PROMEDIO-COMISIONES AS DEC INIT 0 NO-UNDO.
DEF VAR REMUNERACION-MESES-ANTERIORES AS DEC INIT 0 NO-UNDO.
DEF VAR GRATIFICACION-MESES-ANTERIORES AS DEC INIT 0 NO-UNDO.
DEF VAR REMUNERACION-PROYECTADA AS DEC INIT 0 NO-UNDO.
DEF VAR GRATIFICACION-PROYECTADA AS DEC INIT 0 NO-UNDO.
DEF VAR IMPUESTO-RETENIDO-QUINTA AS DEC INIT 0 NO-UNDO.
DEF VAR BASE-IMPONIBLE-QUINTA AS DEC INIT 0 NO-UNDO.
DEF VAR REMUNERACION-FIJA-QUINTA AS DEC INIT 0 NO-UNDO.
DEF VAR REMUNERACION-FIJA-GRATIFICACION AS DEC INIT 0 NO-UNDO.
DEF VAR MESES-ATRAS AS DEC INIT 0 NO-UNDO.
DEF VAR UIT-PROMEDIO AS DECIMAL NO-UNDO.
DEF VAR VAR AS DECIMAL NO-UNDO.

ASSIGN UIT-PROMEDIO = PL-VAR-MES.ValVar-Mes[2].

DEF VAR x-Contador   AS INT NO-UNDO.
DEF VAR x-Contador-2 AS INT NO-UNDO.
DEF VAR x-MES AS INT NO-UNDO.
DEF VAR x-ANO AS INT NO-UNDO.

ASSIGN
    pPorcentaje = 0
    VAR = 0.     

/* PROMEDIO HORAS EXTRAS ULTIMOS 6 MESES */
ASSIGN
    x-MES = s-NroMes - 1 
    x-ANO = s-Periodo
    x-Contador-2 = 0
    MESES-ATRAS = 0.
DO x-Contador = 1 TO 6:
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
            AND PL-MOV-MES.periodo = x-ANO
            AND PL-MOV-MES.nromes  = x-MES
            AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
            AND PL-MOV-MES.codper  = PL-FLG-MES.codper
            AND PL-MOV-MES.codcal  = 001    /* Sueldos */
            AND (PL-MOV-MES.codmov  = 125
                OR PL-MOV-MES.codmov = 126
                OR PL-MOV-MES.codmov = 127)
            BREAK BY PL-MOV-MES.codcia:
        PROMEDIO-HORAS-EXTRAS = PROMEDIO-HORAS-EXTRAS + PL-MOV-MES.valcal-mes.
        IF FIRST-OF(PL-MOV-MES.codcia)
        THEN x-Contador-2 = x-Contador-2 + 1.
    END.
    MESES-ATRAS = MESES-ATRAS + 1.
    x-MES = x-MES - 1.
    IF x-MES <= 0
    THEN ASSIGN
            x-MES = 12
            x-ANO = x-ANO - 1.
    IF x-ANO = YEAR(PL-FLG-MES.fecing) AND x-MES < MONTH(PL-FLG-MES.fecing) THEN LEAVE.
    IF x-ANO < YEAR(PL-FLG-MES.fecing) THEN LEAVE.
END.    
IF x-Contador-2 >= 3
THEN PROMEDIO-HORAS-EXTRAS = PROMEDIO-HORAS-EXTRAS / MINIMUM(6, MESES-ATRAS).
ELSE PROMEDIO-HORAS-EXTRAS = 0.

/* PROMEDIO COMISIONES */
ASSIGN
    x-MES = s-NroMes - 1 
    x-ANO = s-Periodo
    x-Contador-2 = 0
    MESES-ATRAS = 0.
DO x-Contador = 1 TO 6:
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
            AND PL-MOV-MES.periodo = x-ANO
            AND PL-MOV-MES.nromes  = x-MES
            AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
            AND PL-MOV-MES.codper  = PL-FLG-MES.codper
            AND PL-MOV-MES.codcal  = 001    /* Sueldos */
            AND PL-MOV-MES.codmov  = 209
            BREAK BY PL-MOV-MES.codcia:
        PROMEDIO-COMISIONES = PROMEDIO-COMISIONES + PL-MOV-MES.valcal-mes.
        IF FIRST-OF(PL-MOV-MES.codcia)
        THEN x-Contador-2 = x-Contador-2 + 1.
    END.
    MESES-ATRAS = MESES-ATRAS + 1.
    x-MES = x-MES - 1.
    IF x-MES <= 0
    THEN ASSIGN
            x-MES = 12
            x-ANO = x-ANO - 1.
    IF x-ANO = YEAR(PL-FLG-MES.fecing) AND x-MES < MONTH(PL-FLG-MES.fecing) THEN LEAVE.
    IF x-ANO < YEAR(PL-FLG-MES.fecing) THEN LEAVE.
END.    
IF x-Contador-2 >= 3
THEN PROMEDIO-COMISIONES = PROMEDIO-COMISIONES / MINIMUM(6, MESES-ATRAS).
ELSE PROMEDIO-COMISIONES = 0.
/* REMUNERACION FIJA */
ASSIGN
    x-MES = s-NroMes - 1
    x-ANO = s-Periodo.
FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
    AND PL-MOV-MES.periodo = x-ANO
    AND PL-MOV-MES.nromes  = x-MES
    AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
    AND PL-MOV-MES.codper  = PL-FLG-MES.codper
    AND PL-MOV-MES.codcal  = 000
    AND (PL-MOV-MES.codmov  = 101
         OR PL-MOV-MES.codmov  = 103
         OR PL-MOV-MES.codmov  = 111
         OR PL-MOV-MES.codmov  = 104):
    REMUNERACION-FIJA-QUINTA = REMUNERACION-FIJA-QUINTA + PL-MOV-MES.ValCal-Mes.
END.
FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
    AND PL-MOV-MES.periodo = x-ANO
    AND PL-MOV-MES.nromes  = x-MES
    AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
    AND PL-MOV-MES.codper  = PL-FLG-MES.codper
    AND PL-MOV-MES.codcal  = 000
    AND (PL-MOV-MES.codmov  = 101
         OR PL-MOV-MES.codmov  = 103):
    REMUNERACION-FIJA-GRATIFICACION = REMUNERACION-FIJA-GRATIFICACION + PL-MOV-MES.ValCal-Mes.
END.
/* RENTA BRUTA MES ACTUAL */
FIND PL-MOV-MES WHERE PL-MOV-MES.codcia = s-codcia
    AND PL-MOV-MES.periodo = x-ANO
    AND PL-MOV-MES.nromes  = x-MES
    AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
    AND PL-MOV-MES.codper  = PL-FLG-MES.codper
    AND PL-MOV-MES.codcal  = 001
    AND PL-MOV-MES.codmov  = 405
    NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN AFECTO-QUINTA-CATEGORIA = PL-MOV-MES.ValCal-Mes.
/* REMUNERACION MESES ANTERIORES */
FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
    AND PL-MOV-MES.periodo = x-ANO
    AND PL-MOV-MES.nromes >= 01
    AND PL-MOV-MES.nromes <= x-MES - 1
    AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
    AND PL-MOV-MES.codper  = PL-FLG-MES.codper
    AND PL-MOV-MES.codcal  = 001
    AND (PL-MOV-MES.codmov  = 405
         OR PL-MOV-MES.codmov = 409):
    REMUNERACION-MESES-ANTERIORES = REMUNERACION-MESES-ANTERIORES + PL-MOV-MES.ValCal-Mes.
END.
/* REMUNERACION PROYECTADA INCLUYENDO EL MES ACTUAL */
REMUNERACION-PROYECTADA = AFECTO-QUINTA-CATEGORIA +
                            ( REMUNERACION-FIJA-QUINTA + 
                              PROMEDIO-HORAS-EXTRAS +
                              PROMEDIO-COMISIONES ) * (12 - x-MES).
/* GRATIFICACIONES PROYECTADAS */
GRATIFICACION-PROYECTADA = (REMUNERACION-FIJA-GRATIFICACION + PROMEDIO-COMISIONES) * 2.
/* BASE IMPONIBLE */
BASE-IMPONIBLE-QUINTA = (REMUNERACION-MESES-ANTERIORES +
                         GRATIFICACION-MESES-ANTERIORES +
                         REMUNERACION-PROYECTADA +
                         GRATIFICACION-PROYECTADA) -
                        (7 * UIT-PROMEDIO).
IF BASE-IMPONIBLE-QUINTA > 0 THEN VAR = BASE-IMPONIBLE-QUINTA.
/* % IMPUESTO QUINTA */
IF VAR > 0 THEN DO:
/*     IF VAR <= (27 * UIT-PROMEDIO) THEN pPorcentaje = 0.15.      */
/*     ELSE IF VAR <= (54 * UIT-PROMEDIO) THEN pPorcentaje = 0.21. */
/*         ELSE pPorcentaje = 0.30.                                */
    DEF VAR TOPE-5 AS DEC.
    DEF VAR TOPE-20 AS DEC.
    DEF VAR TOPE-35 AS DEC.
    DEF VAR TOPE-45 AS DEC.
    DEF VAR ACUMULA-QUINTA AS DEC.
    ACUMULA-QUINTA = 0.
    ASSIGN
        TOPE-5  = (5 * UIT-PROMEDIO)
        TOPE-20 = (20 * UIT-PROMEDIO)
        TOPE-35 = (35 * UIT-PROMEDIO)
        TOPE-45 = (45 * UIT-PROMEDIO).
    /* PRIMEROS 5 UIT */
    IF VAR <= TOPE-5 THEN DO:
        ACUMULA-QUINTA = 0.08 * MINIMUM(BASE-IMPONIBLE-QUINTA, TOPE-5). 
        pPorcentaje = 0.08.
    END.
    IF VAR > TOPE-5 AND VAR <= TOPE-20 THEN DO:
        ACUMULA-QUINTA = 0.14 * (BASE-IMPONIBLE-QUINTA - TOPE-5).
        ACUMULA-QUINTA = ACUMULA-QUINTA + (0.08 * TOPE-5).
        pPorcentaje = 0.14.
    END.
    IF VAR > TOPE-20 AND VAR <= TOPE-35 THEN DO:
        ACUMULA-QUINTA = 0.17 * (BASE-IMPONIBLE-QUINTA - TOPE-20).
        ACUMULA-QUINTA = ACUMULA-QUINTA + 
                        (0.14 * (TOPE-20 - TOPE-5)) + 
                        (0.08 * TOPE-5).
        pPorcentaje = 0.17.
    END.
    IF VAR > TOPE-35 AND VAR <= TOPE-45 THEN DO:
        ACUMULA-QUINTA = 0.20 * (BASE-IMPONIBLE-QUINTA - TOPE-35).
        ACUMULA-QUINTA = ACUMULA-QUINTA + 
                        (0.17 * (TOPE-35 - TOPE-20)) +
                        (0.14 * (TOPE-20 - TOPE-5)) + 
                        (0.08 * TOPE-5).
        pPorcentaje = 0.20.
    END.
    IF VAR > TOPE-45 THEN DO:
        ACUMULA-QUINTA = 0.30 * (BASE-IMPONIBLE-QUINTA - TOPE-45).
        ACUMULA-QUINTA = ACUMULA-QUINTA + 
                        (0.20 * (TOPE-45 - TOPE-35)) +
                        (0.17 * (TOPE-35 - TOPE-20)) +
                        (0.14 * (TOPE-20 - TOPE-5)) + 
                        (0.08 * TOPE-5).
        pPorcentaje = 0.30.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

