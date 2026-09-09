&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-FacTabla FOR FacTabla.
DEFINE SHARED TEMP-TABLE T-FacTabla LIKE FacTabla.



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

DEF SHARED VAR s-Tabla   AS CHAR.
DEF SHARED VAR s-Tabla-1 AS CHAR.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR S-CODDOC   AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE SHARED VARIABLE s-Divisiones AS CHAR.

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
&Scoped-define INTERNAL-TABLES FacTabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacTabla.Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacTabla.Nombre 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define QUERY-STRING-br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = s-tabla NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = s-tabla NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacTabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacTabla.Nombre FORMAT "x(40)":U WIDTH 40.43
  ENABLE
      FacTabla.Nombre
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-FacTabla B "?" ? INTEGRAL FacTabla
      TABLE: T-FacTabla T "SHARED" ? INTEGRAL FacTabla
   END-TABLES.
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
         HEIGHT             = 6.85
         WIDTH              = 66.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacTabla"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "FacTabla.CodCia = s-codcia
 AND FacTabla.Tabla = s-tabla"
     _FldNameList[1]   > INTEGRAL.FacTabla.Nombre
"FacTabla.Nombre" ? ? "character" ? ? ? ? ? ? yes ? no no "40.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
      RUN Carga-Temporal.
      RUN Procesa-Handle IN lh_handle ('Open-Browse').
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN RUN Procesa-Handle IN lh_handle ("Disable-Others").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* Filtramos solo sus líneas autorizadas */
DEF VAR x-Ok AS LOG NO-UNDO.
ON FIND OF FacTabla DO:
    x-Ok = NO.
    FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = FacTabla.codcia
        AND B-FacTabla.tabla = s-Tabla-1
        AND B-FacTabla.codigo BEGINS FacTabla.codigo
        AND CAN-FIND(FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia 
                     AND Almmmatg.codmat = B-FacTabla.campo-c[1]
                     AND CAN-FIND(FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
                                  AND Vtatabla.tabla = "LP"
                                  AND Vtatabla.llave_c1 = s-user-id
                                  AND Vtatabla.llave_c2 = Almmmatg.codfam NO-LOCK)
                     NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-FacTabla THEN RETURN ERROR.
/*     FOR EACH B-FacTabla NO-LOCK WHERE B-FacTabla.codcia = FacTabla.codcia */
/*         AND B-FacTabla.tabla = s-Tabla-1                                  */
/*         AND B-FacTabla.codigo BEGINS FacTabla.codigo,                     */
/*         FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia           */
/*         AND Almmmatg.codmat = FacTabla.campo-c[1]                         */
/*         AND CAN-FIND(FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia      */
/*                      AND Vtatabla.tabla = "LP"                            */
/*                      AND Vtatabla.llave_c1 = s-user-id                    */
/*                      AND Vtatabla.llave_c2 = Almmmatg.codfam NO-LOCK):    */
/*         x-Ok = YES.                                                       */
/*         LEAVE.                                                            */
/*     END.                                                                  */
/*     IF x-Ok = NO THEN RETURN ERROR.                                       */
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Excel B-table-Win 
PROCEDURE Carga-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cNombreLista AS CHAR NO-UNDO.
DEF VAR k         AS INT NO-UNDO.
DEF VAR iCountLine AS INT NO-UNDO.
DEF VAR x-DtoVolR AS DEC NO-UNDO.
DEF VAR x-DtoVolD AS DEC NO-UNDO.

DEF VAR RADIO-SET-2 AS INT NO-UNDO.

DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
IF NOT (cValue BEGINS "DESCUENTOS POR VOLUMEN POR SALDO") THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
cNombreLista = cValue.

ASSIGN
    t-Row    = t-Row + 1
    t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "DIVISION" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
CASE TRUE:
    WHEN INDEX(cNombreLista, "- PORCENTAJES") > 0 THEN RADIO-SET-2 = 1.
    WHEN INDEX(cNombreLista, "- IMPORTES") > 0 THEN RADIO-SET-2 = 2.
    OTHERWISE RETURN.
END CASE.

/* Cargamos temporal */
DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.

DEF VAR x-TpoCmb AS DEC NO-UNDO.
DEF VAR x-MonVta AS INT NO-UNDO.
DEF VAR x-UndVta AS CHAR NO-UNDO.
DEF VAR x-PreVta AS DEC NO-UNDO.

DEF VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    ASSIGN
        t-Column = 0
        t-Row = 2.     /* Saltamos el encabezado de los campos */
    RLOOP:
    REPEAT:
        ASSIGN
            t-column = 0
            t-Row    = t-Row + 1.
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE RLOOP.    /* FIN DE DATOS */ 
        /* División */
        FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
            gn-divi.coddiv = cValue NO-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "DIVISION".
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        IF LOOKUP(gn-divi.coddiv, s-Divisiones) = 0 THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "DIVISION NO VALIDA".
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            x-CodDiv = cValue.
        /* Vigencia */
        t-Column = t-Column + 3.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            x-FchIni = DATE(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR OR x-FchIni = ? THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "DESDE".
            UNDO, RETURN 'ADM-ERROR'.
        END.
        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            x-FchFin = DATE(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR OR x-FchFin = ? THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "HASTA".
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* Creamos/Bloqueamos Registro */
        FIND FIRST VtaDctoVolSaldo WHERE VtaDctoVolSaldo.CodCia = s-codcia AND
            VtaDctoVolSaldo.CodDiv = x-CodDiv AND
            VtaDctoVolSaldo.Codigo = FacTabla.Codigo AND
            VtaDctoVolSaldo.Tabla = FacTabla.Tabla AND
            VtaDctoVolSaldo.FchIni = x-FchIni AND
            VtaDctoVolSaldo.FchFin = x-FchFin
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaDctoVolSaldo THEN DO:
            CREATE VtaDctoVolSaldo.
            ASSIGN
                VtaDctoVolSaldo.CodCia = s-codcia 
                VtaDctoVolSaldo.CodDiv = x-CodDiv 
                VtaDctoVolSaldo.Codigo = FacTabla.Codigo 
                VtaDctoVolSaldo.Tabla = FacTabla.Tabla.
        END.
        ELSE DO:
            FIND CURRENT VtaDctoVolSaldo EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE VtaDctoVolSaldo THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
        END.
        ASSIGN
            VtaDctoVolSaldo.FchIni = x-FchIni
            VtaDctoVolSaldo.FchFin = x-FchFin.
        /* PRECIO UNITARIO */
        RUN PRI_PrecioBase-DctoVolSaldo IN hProc (INPUT s-Tabla-1,
                                                  INPUT VtaDctoVolSaldo.Codigo,
                                                  INPUT VtaDctoVolSaldo.coddiv,
                                                  OUTPUT x-PreVta,
                                                  OUTPUT x-TpoCmb,
                                                  OUTPUT x-MonVta,
                                                  OUTPUT x-UndVta).
        IF x-MonVta = 2 THEN x-PreVta = x-PreVta * x-TpoCmb.
        /* Cargamos Descuentos por Volumen */
        k = 1.
        DO iCountLine = 1 TO 5:
            t-Column = t-Column + 1.
            cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
            ASSIGN
                x-DtoVolR = DECIMAL(cValue)
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                    + "Rango".
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
            t-Column = t-Column + 1.
            cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
            ASSIGN
                x-DtoVolD = DECIMAL(cValue)
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                    + "Descuento".
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.

            IF x-DtoVolR = ? OR x-DtoVolR = 0 OR x-DtoVolR < 0
                OR x-DtoVolD = ? OR x-DtoVolD = 0 OR x-DtoVolD < 0 THEN NEXT.
            ASSIGN
                VtaDctoVolSaldo.DtoVolR[k]  = x-DtoVolR
                VtaDctoVolSaldo.DtoVolD[k]  = x-DtoVolD.
            /* Corregimos */
            IF RADIO-SET-2 = 2 THEN DO:
                IF VtaDctoVolSaldo.DtoVolD[k] > 0 THEN
                    VtaDctoVolSaldo.DtoVolD[k] = ROUND ( ( 1 -  VtaDctoVolSaldo.DtoVolD[k] / x-PreVta  ) * 100, 6 ).
                VtaDctoVolSaldo.DtoVolP[k] = ROUND(x-PreVta * (1 - (VtaDctoVolSaldo.DtoVolD[k] / 100)), 4).
            END.
            k = k + 1.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Plantilla B-table-Win 
PROCEDURE Carga-Plantilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE FacTabla THEN RETURN.

    DEF VAR FILL-IN-Archivo AS CHAR NO-UNDO.
    DEF VAR OKpressed AS LOG NO-UNDO.


    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls)" "*.xls,*xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    pMensaje = ''.
    RUN Carga-Excel.
    SESSION:SET-WAIT-STATE('').

    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* Mensaje de error de carga */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'Proceso Abortado'.
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Procesa-Handle IN lh_handle ("Pinta-Divisiones").
    MESSAGE 'Proceso Terminado'.


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

IF NOT AVAILABLE FacTabla THEN RETURN.

EMPTY TEMP-TABLE T-FacTabla.

s-CodDoc = FacTabla.Codigo.
FOR EACH B-FacTabla NO-LOCK WHERE B-FacTabla.codcia = FacTabla.codcia
    AND B-FacTabla.tabla = s-Tabla-1
    AND B-FacTabla.codigo BEGINS FacTabla.codigo:
    CREATE T-FacTabla.
    BUFFER-COPY B-FacTabla TO T-FacTabla.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Plantilla B-table-Win 
PROCEDURE Generar-Plantilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER RADIO-SET-2 AS INT.

IF NOT AVAILABLE FacTabla THEN RETURN.

DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.
DEFINE VARIABLE k                       AS INTEGER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-PreVta LIKE Almmmatg.preofi NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "DESCUENTOS POR VOLUMEN POR SALDO"
    chWorkSheet:Range("A2"):Value = "DIVISION"
    chWorkSheet:Columns("A"):NumberFormat = "@"

    chWorkSheet:Range("B2"):Value = "PRECIO LISTA S/."
    chWorkSheet:Range("C2"):Value = "UNIDAD BASE"

    chWorkSheet:Range("D2"):Value = "DESDE"
    chWorkSheet:Columns("D"):NumberFormat = "dd/MM/yyyy"
    chWorkSheet:Range("E2"):Value = "HASTA"
    chWorkSheet:Columns("E"):NumberFormat = "dd/MM/yyyy"
    chWorkSheet:Range("F2"):Value = "MINIMO 1"
    chWorkSheet:Range("G2"):Value = "DESCUENTO 1"
    chWorkSheet:Range("H2"):Value = "MINIMO 2"
    chWorkSheet:Range("I2"):Value = "DESCUENTO 2"
    chWorkSheet:Range("J2"):Value = "MINIMO 3"
    chWorkSheet:Range("K2"):Value = "DESCUENTO 3"
    chWorkSheet:Range("L2"):Value = "MINIMO 4"
    chWorkSheet:Range("M2"):Value = "DESCUENTO 4"
    chWorkSheet:Range("N2"):Value = "MINIMO 5"
    chWorkSheet:Range("O2"):Value = "DESCUENTO 5".

CASE RADIO-SET-2:
    WHEN 1 THEN chWorkSheet:Range("A1"):VALUE = chWorkSheet:Range("A1"):VALUE + " - PORCENTAJES".
    WHEN 2 THEN chWorkSheet:Range("A1"):VALUE = chWorkSheet:Range("A1"):VALUE + " - IMPORTES".
END CASE.

ASSIGN
    t-Row = 2.
/* Barremos todas las divisiones activas */
DEF VAR x-TpoCmb AS DEC NO-UNDO.
DEF VAR x-MonVta AS INT NO-UNDO.
DEF VAR x-UndVta AS CHAR NO-UNDO.

DEF VAR hProc AS HANDLE NO-UNDO.

RUN pri/pri-librerias PERSISTENT SET hProc.

DEF VAR j AS INT NO-UNDO.
DO j = 1 TO NUM-ENTRIES(s-Divisiones):
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    /* DIVISION */
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ENTRY(j, s-Divisiones).
    /* PRECIO LISTA Y UNIDAD BASE */
    FIND FIRST VtaDctoVolSaldo WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND
        VtaDctoVolSaldo.Tabla = FacTabla.Tabla AND 
        VtaDctoVolSaldo.Codigo = FacTabla.Codigo AND
        VtaDctoVolSaldo.CodDiv = ENTRY(j, s-Divisiones) AND
        (VtaDctoVolSaldo.FchIni >= TODAY OR TODAY <= VtaDctoVolSaldo.FchFin)
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDctoVolSaldo THEN DO:
        RUN PRI_PrecioBase-DctoVolSaldo IN hProc (INPUT s-Tabla-1,
                                                  INPUT VtaDctoVolSaldo.Codigo,
                                                  INPUT VtaDctoVolSaldo.coddiv,
                                                  OUTPUT x-PreVta,
                                                  OUTPUT x-TpoCmb,
                                                  OUTPUT x-MonVta,
                                                  OUTPUT x-UndVta).
        IF x-monvta = 2 THEN x-PreVta = x-PreVta * x-TpoCmb.
    END.
    ELSE ASSIGN x-PreVta = 0 x-UndVta = ''.
    /* PRECIO LISTA */
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreVta.
    /* UNIDAD */
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-UndVta.

    REPEAT WHILE AVAILABLE VtaDctoVolSaldo:
        /* DESDE */
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.FchIni.
        /* HASTA */
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.FchFin.
        /* DESCUENTOS */
        DO k = 1 TO 5:
            IF VtaDctoVolSaldo.DtoVolD[k] <= 0 THEN NEXT.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.DtoVolR[k].
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.DtoVolD[k].
            IF RADIO-SET-2 = 2 
                THEN chWorkSheet:Cells(t-Row, t-Column):VALUE = ROUND(x-PreVta * ( 1 - ( VtaDctoVolSaldo.DtoVolD[k] / 100 ) ),4).
        END.
        FIND NEXT VtaDctoVolSaldo WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND
                VtaDctoVolSaldo.Tabla = FacTabla.Tabla AND 
                VtaDctoVolSaldo.Codigo = FacTabla.Codigo AND
                VtaDctoVolSaldo.CodDiv = ENTRY(j, s-Divisiones) AND
                (VtaDctoVolSaldo.FchIni >= TODAY OR TODAY <= VtaDctoVolSaldo.FchFin)
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaDctoVolSaldo THEN DO:
                ASSIGN
                    t-Column = 0
                    t-Row    = t-Row + 1.
                /* DIVISION */
                ASSIGN
                    t-Column = t-Column + 1
                    chWorkSheet:Cells(t-Row, t-Column):VALUE = ENTRY(j, s-Divisiones).
                /* PRECIO LISTA */
                ASSIGN
                    t-Column = t-Column + 1
                    chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreVta.
                /* UNIDAD */
                ASSIGN
                    t-Column = t-Column + 1
                    chWorkSheet:Cells(t-Row, t-Column):VALUE = x-UndVta.
            END.
    END.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

DELETE PROCEDURE hProc.

END PROCEDURE.

/*
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.
DEFINE VARIABLE k                       AS INTEGER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-PreVta LIKE Almmmatg.preofi NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "DESCUENTOS POR VOLUMEN POR SALDO"
    chWorkSheet:Range("A2"):Value = "DIVISION"
    chWorkSheet:Columns("A"):NumberFormat = "@"

    chWorkSheet:Range("B2"):Value = "DESDE"
    chWorkSheet:Columns("B"):NumberFormat = "dd/MM/yyyy"
    chWorkSheet:Range("C2"):Value = "HASTA"
    chWorkSheet:Columns("C"):NumberFormat = "dd/MM/yyyy"
    chWorkSheet:Range("D2"):Value = "MINIMO 1"
    chWorkSheet:Range("E2"):Value = "DESCUENTO 1"
    chWorkSheet:Range("F2"):Value = "MINIMO 2"
    chWorkSheet:Range("G2"):Value = "DESCUENTO 2"
    chWorkSheet:Range("H2"):Value = "MINIMO 3"
    chWorkSheet:Range("I2"):Value = "DESCUENTO 3"
    chWorkSheet:Range("J2"):Value = "MINIMO 4"
    chWorkSheet:Range("K2"):Value = "DESCUENTO 4"
    chWorkSheet:Range("L2"):Value = "MINIMO 5"
    chWorkSheet:Range("M2"):Value = "DESCUENTO 5".
CASE RADIO-SET-2:
    WHEN 1 THEN chWorkSheet:Range("A1"):VALUE = chWorkSheet:Range("A1"):VALUE + " - PORCENTAJES".
    WHEN 2 THEN chWorkSheet:Range("A1"):VALUE = chWorkSheet:Range("A1"):VALUE + " - IMPORTES".
END CASE.

ASSIGN
    t-Row = 2.
/* Barremos todas las divisiones activas */
DEF VAR j AS INT NO-UNDO.
DO j = 1 TO NUM-ENTRIES(s-Divisiones):
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    /* DIVISION */
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = ENTRY(j, s-Divisiones).
    FIND FIRST VtaDctoVolSaldo WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND
        VtaDctoVolSaldo.Tabla = FacTabla.Tabla AND 
        VtaDctoVolSaldo.Codigo = FacTabla.Codigo AND
        VtaDctoVolSaldo.CodDiv = ENTRY(j, s-Divisiones) AND
        (VtaDctoVolSaldo.FchIni >= TODAY OR TODAY <= VtaDctoVolSaldo.FchFin)
        NO-LOCK NO-ERROR.
    REPEAT WHILE AVAILABLE VtaDctoVolSaldo:
        /* DESDE */
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.FchIni.
        /* HASTA */
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.FchFin.
        /* DESCUENTOS */
        DO k = 1 TO 5:
            IF VtaDctoVolSaldo.DtoVolD[k] <= 0 THEN NEXT.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.DtoVolR[k].
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDctoVolSaldo.DtoVolD[k].
        END.
        FIND NEXT VtaDctoVolSaldo WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND
            VtaDctoVolSaldo.Tabla = FacTabla.Tabla AND 
            VtaDctoVolSaldo.Codigo = FacTabla.Codigo AND
            VtaDctoVolSaldo.CodDiv = ENTRY(j, s-Divisiones) AND
            (VtaDctoVolSaldo.FchIni >= TODAY OR TODAY <= VtaDctoVolSaldo.FchFin)
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDctoVolSaldo THEN DO:
            ASSIGN
                t-Column = 0
                t-Row    = t-Row + 1.
            /* DIVISION */
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = ENTRY(j, s-Divisiones).
        END.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solo vamos a crear y anular, no se va a poder modificar
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pLargo AS INT INIT 10 NO-UNDO.
  DEF VAR pPassword AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Grabamos un valor aleatorio de 10 caracteres */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN RUN lib/_gen_password (pLargo, OUTPUT pPassword).
  ELSE pPassword = FacTabla.Codigo.

  ASSIGN
      FacTabla.CodCia = s-codcia
      FacTabla.Tabla  = s-tabla
      FacTabla.Codigo = pPassword.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Procesa-Handle IN lh_handle ("Enable-Others").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE FacTabla THEN RETURN.

  s-CodDoc = FacTabla.Codigo.
  FOR EACH B-FacTabla WHERE B-FacTabla.codcia = FacTabla.codcia
      AND B-FacTabla.tabla = s-Tabla-1
      AND B-FacTabla.codigo BEGINS FacTabla.codigo:
      DELETE B-FacTabla.
  END.
  /* Borramos divisiones relacionadas */
  FOR EACH VtaDctoVolSaldo EXCLUSIVE-LOCK WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND
      VtaDctoVolSaldo.Tabla = FacTabla.Tabla AND
      VtaDctoVolSaldo.Codigo = FacTabla.Codigo:
      DELETE VtaDctoVolSaldo.
  END.

  EMPTY TEMP-TABLE T-FacTabla.
  RUN Procesa-Handle IN lh_handle ('Open-Browse').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN Procesa-Handle IN lh_handle ("Enable-Header-3").

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
  RUN Procesa-Handle IN lh_handle ("Disable-Header-3").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
      AND FacTabla.Tabla = s-tabla NO-LOCK NO-ERROR.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Open-Browse').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Open-Browse').
  RUN Procesa-Handle IN lh_handle ("Enable-Others").

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
  {src/adm/template/snd-list.i "FacTabla"}

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

IF FacTabla.Nombre:SCREEN-VALUE IN BROWSE {&browse-name} = "" THEN DO:
    MESSAGE 'Ingrese la descripción' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
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

/*MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

