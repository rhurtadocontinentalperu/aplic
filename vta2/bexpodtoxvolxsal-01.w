&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-FacTabla FOR FacTabla.
DEFINE SHARED TEMP-TABLE T-FacTabla LIKE FacTabla.
DEFINE TEMP-TABLE T-Tabla NO-UNDO LIKE FacTabla.



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

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE pMensaje        AS CHARACTER    NO-UNDO.

DEF TEMP-TABLE Detalle
    FIELD DtoVolR AS DEC
    FIELD DtoVolD AS DEC
    FIELD PreUni  AS DEC.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE GN-DIVI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR GN-DIVI.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacTabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacTabla.Nombre FacTabla.Campo-D[1] ~
FacTabla.Campo-D[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacTabla.Nombre ~
FacTabla.Campo-D[1] FacTabla.Campo-D[2] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define QUERY-STRING-br_table FOR EACH FacTabla WHERE FacTabla.CodCia = GN-DIVI.CodCia ~
  AND FacTabla.Codigo BEGINS GN-DIVI.CodDiv ~
      AND FacTabla.Tabla = s-tabla NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacTabla WHERE FacTabla.CodCia = GN-DIVI.CodCia ~
  AND FacTabla.Codigo BEGINS GN-DIVI.CodDiv ~
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
      FacTabla.Campo-D[1] COLUMN-LABEL "Vigente Desde" FORMAT "99/99/9999":U
      FacTabla.Campo-D[2] COLUMN-LABEL "Hasta" FORMAT "99/99/9999":U
  ENABLE
      FacTabla.Nombre
      FacTabla.Campo-D[1]
      FacTabla.Campo-D[2]
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
   External Tables: INTEGRAL.GN-DIVI
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-FacTabla B "?" ? INTEGRAL FacTabla
      TABLE: T-FacTabla T "SHARED" ? INTEGRAL FacTabla
      TABLE: T-Tabla T "?" NO-UNDO INTEGRAL FacTabla
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
     _TblList          = "INTEGRAL.FacTabla WHERE INTEGRAL.GN-DIVI <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "FacTabla.CodCia = GN-DIVI.CodCia
  AND FacTabla.Codigo BEGINS GN-DIVI.CodDiv"
     _Where[1]         = "FacTabla.Tabla = s-tabla"
     _FldNameList[1]   > INTEGRAL.FacTabla.Nombre
"FacTabla.Nombre" ? ? "character" ? ? ? ? ? ? yes ? no no "40.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacTabla.Campo-D[1]
"FacTabla.Campo-D[1]" "Vigente Desde" "99/99/9999" "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacTabla.Campo-D[2]
"FacTabla.Campo-D[2]" "Hasta" "99/99/9999" "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "GN-DIVI"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Excel B-table-Win 
PROCEDURE Captura-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR k         AS INT NO-UNDO.
DEF VAR x-DtoVolR AS DEC NO-UNDO.
DEF VAR x-DtoVolD AS DEC NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "CODIGO" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN 'ADM-ERROR'.
END.

/* Cargamos temporal */
EMPTY TEMP-TABLE T-TABLA.
ASSIGN
    t-Column = 0
    t-Row    = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    CREATE T-TABLA.
    ASSIGN
        T-TABLA.codcia = s-codcia
        T-TABLA.Tabla  = s-Tabla-1
        T-TABLA.Codigo = FacTabla.Codigo + '|' + cValue
        T-TABLA.Campo-C[1] = cValue.
END.
/* CONSISTENCIA */
FOR EACH T-TABLA:
    FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND 
        Almmmatg.codmat = T-TABLA.Campo-C[1] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        pMensaje = 'ERROR en el código ' + cValue + CHR(10) + 'Proceso Abortado'.
        RETURN 'ADM-ERROR'.
    END.
END.
/* GRABAMOS INFORMACION */
DEF VAR x-Orden AS INTE NO-UNDO.
DEF VAR x-PorDto AS DECI NO-UNDO.
DEF VAR x-Margen AS DECI NO-UNDO.
DEF VAR x-Limite AS DECI NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE BUFFER LocalBufferMatg FOR Almmmatg.

RUN pri/pri-librerias PERSISTENT SET hProc.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-TABLA:
        FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = T-TABLA.CodCia AND
            B-FacTabla.Tabla = T-TABLA.Tabla AND
            B-FacTabla.Codigo = T-TABLA.Codigo
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacTabla THEN DO:
            CREATE B-FacTabla.
            BUFFER-COPY T-TABLA TO B-FacTabla NO-ERROR.
        END.
        /* ****************************************************************************************************** */
        /* Control Margen de Utilidad */
        /* Se van a barrer todos los productos relacionados */
        /* ****************************************************************************************************** */
        /* 05/12/2022: Control de Margen */
        FIND FIRST LocalBufferMatg WHERE LocalBufferMatg.CodCia = s-CodCia
            AND LocalBufferMatg.codmat = B-FacTabla.Campo-C[1] NO-LOCK NO-ERROR.
        IF AVAILABLE LocalBufferMatg THEN DO:
            DO x-Orden = 11 TO 20:
                x-PorDto =  FacTabla.Valor[x-Orden].
                IF x-PorDto > 0 THEN DO:
                    RUN PRI_Margen-Utilidad-Listas IN hProc (INPUT ENTRY(1,FacTabla.Codigo,'|'),
                                                             INPUT LocalBufferMatg.CodMat,
                                                             INPUT LocalBufferMatg.CHR__01,
                                                             INPUT x-PorDto,
                                                             INPUT 1,
                                                             OUTPUT x-Margen,
                                                             OUTPUT x-Limite,
                                                             OUTPUT pMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' OR pMensaje > '' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
            END.
        END.
    END.
END.
RELEASE B-FacTabla.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    hColumn:READ-ONLY = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.
DEFINE VAR s-UndVta AS CHAR NO-UNDO.
DEFINE VAR f-Factor AS DEC NO-UNDO.
DEFINE VAR F-PREBAS AS DEC NO-UNDO.
DEFINE VAR F-PREVTA AS DEC NO-UNDO.
DEFINE VAR F-DSCTOS AS DEC NO-UNDO.
DEFINE VAR Y-DSCTOS AS DEC NO-UNDO.
DEFINE VAR Z-DSCTOS AS DEC NO-UNDO.
DEFINE VAR X-TIPDTO AS CHAR NO-UNDO.
DEFINE VAR f-FleteUnitario AS DEC NO-UNDO.
DEFINE VAR x-ImpLin AS DEC NO-UNDO.

DEF VAR x-PreUni AS DEC NO-UNDO.

FIND FIRST t-FacTabla NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-FacTabla THEN RETURN.

DEF VAR k AS INT NO-UNDO.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

SESSION:SET-WAIT-STATE('GENERAL').
{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

chWorkSheet = chExcelApplication:Sheets:Item(1).  

iRow = 1.
cColumn = TRIM(STRING(iRow)).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):VALUE = "LISTA DE PRECIOS: " + gn-divi.coddiv + " " + CAPS(gn-divi.desdiv).
iRow = iRow + 1.
cColumn = TRIM(STRING(iRow)).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Los precios incluyen IGV".
iRow = iRow + 1.
cColumn = TRIM(STRING(iRow)).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):VALUE = "ESCALA DE VENTAS".
GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE FacTabla:
    /* Precio Unitario */
    s-CodDoc = FacTabla.Codigo.
    x-PreUni = 0.
    f-FleteUnitario = 0.
    FOR EACH B-FacTabla NO-LOCK WHERE B-FacTabla.codcia = FacTabla.codcia
        AND B-FacTabla.tabla = s-Tabla-1
        AND B-FacTabla.codigo BEGINS FacTabla.codigo:
        FIND VtaListaMay WHERE VtaListaMay.CodCia = s-CodCia AND
            VtaListaMay.CodDiv = gn-divi.CodDiv AND
            VtaListaMay.codmat = B-FacTabla.Campo-C[1]
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMay THEN RETURN.
        IF VtaListaMay.PreOfi = 0 THEN RETURN.
        FIND FIRST Almmmatg OF Vtalistamay NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN RETURN.
        x-PreUni = VtaListaMay.PreOfi.
        /*IF Almmmatg.MonVta = 2 THEN x-PreUni = VtaListaMay.PreOfi * Almmmatg.TpoCmb.*/
        /* Flete */
        /*RUN vtagn/precio-venta-general-v01.p (*/
        RUN pri/PrecioVentaMayorCredito (
            "E",    /* Expolibreria */
            VtaListaMay.CodDiv,
            '11111111111',
            Almmmatg.MonVta,        /*1,*/
            INPUT-OUTPUT S-UNDVTA,
            OUTPUT f-Factor,
            VtaListaMay.codmat,
            "001",
            1,
            4,
            OUTPUT F-PREBAS,
            OUTPUT F-PREVTA,
            OUTPUT F-DSCTOS,
            OUTPUT Y-DSCTOS,
            OUTPUT Z-DSCTOS,
            OUTPUT X-TIPDTO,
            "C",
            OUTPUT f-FleteUnitario,
            "",
            NO).
        x-PreUni = x-PreUni + f-FleteUnitario.
        LEAVE.
    END.

    /* TITULOS */
    iRow = iRow + 2.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = CAPS(FacTabla.Nombre).
    iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = FacTabla.Campo-C[1].
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CAJA".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "P.UNITARIO".
    /* Buscamos los descuentos por volumen y los ordenamos */
    EMPTY TEMP-TABLE Detalle.
    DO k = 1 TO 10:
        IF FacTabla.Valor[k] = 0 THEN LEAVE.
        CREATE Detalle.
        ASSIGN
            Detalle.DtoVolR = FacTabla.Valor[k]
            Detalle.PreUni  = ROUND(x-PreUni * ( 1 - ( FacTabla.Valor[k + 10] / 100 ) ),4).
    END.
    FOR EACH Detalle BY Detalle.DtoVolR DESC:
        iRow = iRow + 1.
        cColumn = TRIM(STRING(iRow)).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Detalle.DtoVolR.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = (Detalle.DtoVolR / Almmmatg.Libre_d03).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Detalle.PreUni.
    END.
    iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "P.MOSTRADOR".
    cColumn = TRIM(STRING(iRow)).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = x-PreUni.
    GET NEXT {&BROWSE-NAME}.
END.
SESSION:SET-WAIT-STATE('').
chExcelApplication:Visible = TRUE.
{lib\excel-close-file.i} 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel B-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE FacTabla THEN RETURN.

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR OKpressed AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls,*xlsx", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN 'ADM-ERROR'.

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(x-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').
pMensaje = "".
RUN Captura-Excel (OUTPUT pMensaje).
SESSION:SET-WAIT-STATE('').
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

IF RETURN-VALUE = 'ADM-ERROR' OR pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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
  DEF VAR pLargo AS INT INIT 10 NO-UNDO.
  DEF VAR pPassword AS CHAR NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Grabamos un valor aleatorio de 10 caracteres */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN RUN lib/_gen_password (pLargo, OUTPUT pPassword).
  ELSE pPassword = ENTRY(2,FacTabla.Codigo,'|').
  ASSIGN
      FacTabla.CodCia = s-codcia
      FacTabla.Tabla  = s-tabla
      FacTabla.Codigo = gn-divi.coddiv + '|' + pPassword.

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
  EMPTY TEMP-TABLE T-FacTabla.
  RUN Procesa-Handle IN lh_handle ('Open-Browse').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
      AND FacTabla.Tabla = s-tabla 
      AND FacTabla.Codigo BEGINS gn-divi.coddiv
      NO-LOCK NO-ERROR.
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
  {src/adm/template/snd-list.i "GN-DIVI"}
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

