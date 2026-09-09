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

&SCOPED-DEFINE precio-venta-general-mayor web/PrecioFinalCreditoMayorista.p

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VARIABLE s-Tabla AS CHARACTER.
DEFINE SHARED VARIABLE s-Codigo AS CHARACTER.

/* Local Variable Definitions ---                                       */

/* TRACE */
DEFINE STREAM txt-trace.
DEFINE VAR x-dir-tmp AS CHAR.
DEFINE VAR x-trace-save AS LOG INIT NO.
DEFINE VAR x-file-trace AS CHAR.

DEFIN VAR pMensaje AS CHAR NO-UNDO.

x-dir-tmp = SESSION:TEMP-DIRECTORY.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD Referencia_Aliado AS CHAR FORMAT 'x(8)'
    FIELD Sku AS CHAR FORMAT 'x(13)' 
    FIELD Nombre AS CHAR FORMAT 'x(100)'
    FIELD Descripcion AS CHAR FORMAT 'x(100)'
    FIELD Marca AS CHAR FORMAT 'x(30)'
    FIELD Stock AS INTE FORMAT '>>>>>>>>9'
    FIELD Tienda AS CHAR FORMAT 'x(8)'
    FIELD Precio_Por_Tienda AS DECI FORMAT '>>>>>>>>9.99'
    FIELD Precio_Con_Descuento AS CHAR
    FIELD Descuento AS CHAR
    FIELD Fecha_Inicio_Descuento AS CHAR FORMAT 'x(10)'
    FIELD Fecha_Fin_Descuento AS CHAR FORMAT 'x(10)'
    FIELD Categoria_Producto_1 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_2 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_3 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_4 AS CHAR FORMAT 'x(8)'
    FIELD Imagen_de_Producto AS CHAR
    FIELD Categoria_Combinacion AS CHAR
    FIELD Nombre_Combinacion AS CHAR
    INDEX Idx00 AS PRIMARY Sku
    .

/*
DEF TEMP-TABLE Detalle
    FIELD Referencia_Aliado AS CHAR FORMAT 'x(8)'
    FIELD Sku AS CHAR FORMAT 'x(13)' 
    FIELD Nombre AS CHAR FORMAT 'x(100)'
    FIELD Descripcion AS CHAR FORMAT 'x(100)'
    FIELD Marca AS CHAR FORMAT 'x(30)'
    FIELD Stock AS INTE FORMAT '>>>>>>>>9'
    FIELD Tienda AS CHAR FORMAT 'x(8)'
    FIELD Precio_Por_Tienda AS DECI FORMAT '>>>>>>>>9.99'
    FIELD Precio_Con_Descuento AS DECI FORMAT '>>>>>>>>9.99'
    FIELD Descuento AS DECI FORMAT '>>>>>9.9999'
    FIELD Fecha_Inicio_Descuento AS CHAR FORMAT 'x(10)'
    FIELD Fecha_Fin_Descuento AS CHAR FORMAT 'x(10)'
    FIELD Categoria_Producto_1 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_2 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_3 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_4 AS CHAR FORMAT 'x(8)'
    FIELD Imagen_de_Producto AS CHAR
    FIELD Categoria_Combinacion AS CHAR
    FIELD Nombre_Combinacion AS CHAR
    .

*/

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
&Scoped-define INTERNAL-TABLES VtaListaMay Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaListaMay.codmat Almmmatg.DesMat ~
Almmmatg.DesMar ~
(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * VtaListaMay.PreOfi @ VtaListaMay.PreOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH VtaListaMay OF GN-DIVI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF VtaListaMay NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaListaMay OF GN-DIVI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF VtaListaMay NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaListaMay Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaListaMay
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DesMat 

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
DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 90 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaListaMay, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaListaMay.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * VtaListaMay.PreOfi @ VtaListaMay.PreOfi COLUMN-LABEL "Precio en S/"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 109 BY 16.15
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN_DesMat AT ROW 17.15 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.GN-DIVI
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
         HEIGHT             = 17.04
         WIDTH              = 110.57.
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

/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaListaMay OF INTEGRAL.GN-DIVI,INTEGRAL.Almmmatg OF INTEGRAL.VtaListaMay"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   = INTEGRAL.VtaListaMay.codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * VtaListaMay.PreOfi @ VtaListaMay.PreOfi" "Precio en S/" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE api_connection_log B-table-Win 
PROCEDURE api_connection_log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pError AS CHAR.

DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.
DEFINE VAR lRemote-user         AS CHAR.
DEFINE VAR lxClientName         AS CHAR.

lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME").
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").
lRemote-user        = OS-GETENV ( "REMOTE_USER").

lxClientName        = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lxClientName        = IF (CAPS(lxClientName) = "CONSOLE") THEN "" ELSE lxClientName.
lxClientName        = IF (lxClientName = ? OR lxClientName = "") THEN lComputerName ELSE lxClientName.

CREATE connection_log.
ASSIGN
    connection_log.connect_ClientType = s-user-id
    connection_log.connect_device = lxClientName
    connection_log.connect_estado = "RAPPI_API_PRICING"
    /*connection_log.connect_name = pUrl*/
    connection_log.connect_thora_procesada = STRING(TIME, 'HH:MM:SS')
    connection_log.connect_time = STRING(TODAY, '99/99/9999')
    connection_log.connect_type = pError
    .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Precios B-table-Win 
PROCEDURE Carga-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPrecio AS INTE.

DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR pSalesChannel AS CHAR NO-UNDO.
DEF VAR pMonVta AS INTE NO-UNDO.
DEF VAR pTpoCmb AS DECI NO-UNDO.

DEF VAR cCodMat AS CHAR NO-UNDO.

/* 21/10/2017 Control de uso de API */
RUN api_connection_log ('INICIO').

pSalesChannel = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))).

DEF VAR x-Cuenta AS INTE NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.

FOR EACH Detalle EXCLUSIVE-LOCK BREAK BY Detalle.Sku:
    IF FIRST-OF(Detalle.sku) THEN DO:
        cCodMat = Detalle.sku.
        cCodMat = STRING(INTEGER(cCodMat), '999999') NO-ERROR.
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND 
            Almmmatg.codmat = cCodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        x-Cuenta = x-Cuenta + 1.
        /* Pintamos cada 100 productos */
        IF x-Cuenta MODULO 100 = 0 THEN
        FILL-IN_DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PRECIOS >> " + Almmmatg.codmat + " - " + Almmmatg.desmat.
        f-PreVta = 0.
        RUN web_api-pricing-preuni IN hProc (INPUT cCodMat,
                                             INPUT pSalesChannel,
                                             INPUT "C",
                                             INPUT "603",
                                             OUTPUT pMonVta,
                                             OUTPUT pTpoCmb,
                                             OUTPUT f-PreVta,
                                             OUTPUT pMensaje)
            .
        IF RETURN-VALUE = 'ADM-ERROR' THEN f-PreVta = 0.
        IF pMonVta = 2 THEN f-PreVta = f-PreVta * pTpoCmb.

/*         RUN {&precio-venta-general-mayor} ("N",                                                                          */
/*                                            gn-divi.coddiv,                                                               */
/*                                            "11111111111",                                                                */
/*                                            1,                                                                            */
/*                                            INPUT-OUTPUT s-UndVta,                                                        */
/*                                            OUTPUT f-Factor,                                                              */
/*                                            cCodMat,                                                                      */
/*                                            '603',                                                                        */
/*                                            1,                                                                            */
/*                                            4,                                                                            */
/*                                            OUTPUT f-PreBas,                                                              */
/*                                            OUTPUT f-PreVta,                                                              */
/*                                            OUTPUT f-Dsctos,                                                              */
/*                                            OUTPUT y-Dsctos,                                                              */
/*                                            OUTPUT z-Dsctos,                                                              */
/*                                            OUTPUT x-TipDto,                                                              */
/*                                            "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */ */
/*                                            OUTPUT f-FleteUnitario,                                                       */
/*                                            "",                                                                           */
/*                                            NO,                                                                           */
/*                                            OUTPUT pMensaje).                                                             */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN NEXT.                                                                         */
    END.
    ASSIGN
        Detalle.Precio_Por_Tienda = ROUND(f-PreVta,2).
END.
DELETE PROCEDURE hProc.

/* 21/10/2017 Control de uso de API */
RUN api_connection_log ('FIN').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte B-table-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pPorStock AS DECI.
DEF INPUT PARAMETER pStock AS INTE.
DEF INPUT PARAMETER pMinimo AS DECI.

EMPTY TEMP-TABLE Detalle.
/* Barremos por cada precio registrado en la lista de precios y
    por cada ID Rappi registrado
*/
DEF VAR x-Cuenta AS INTE NO-UNDO.
/* 1ro. Stocks */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.TpoArt <> "D",
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.SwComercial = YES,
    FIRST Almsfami OF Almmmatg NO-LOCK:
    /* Filtro */
    IF Almmmatg.TpoMrg = "1" THEN NEXT.     /* Mayorista: No pasa */
    x-Cuenta = x-Cuenta + 1.
    /* Pintamos cada 100 productos */
    IF x-Cuenta MODULO 100 = 0 THEN
        FILL-IN_DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "STOCK >> " + Almmmatg.codmat + " - " + Almmmatg.desmat.
    RUN Carga-Temporal (INPUT pPorStock, INPUT pStock, INPUT pMinimo).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Cargamos Stocks Válidos
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pPorStock AS DECI.
    DEF INPUT PARAMETER pStock AS INTE.
    DEF INPUT PARAMETER pMinimo AS DECI.

    DEF VAR x-StkAct AS DECI NO-UNDO.
    DEF VAR cCodMat AS CHAR NO-UNDO.
    DEF VAR cDesMat AS CHAR NO-UNDO.
    DEF VAR cFchIni AS CHAR NO-UNDO.
    DEF VAR cFchFin AS CHAR NO-UNDO.

    /* Barremos divisiones relacionadas con Rappi */
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia AND FacTabla.Tabla = 'IDRAPPI',
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia 
            AND Almacen.CodDiv = FacTabla.Codigo
            AND Almacen.Campo-c[9] <> "I"
            AND Almacen.AlmDespacho = YES 
            AND Almacen.AlmPrincipal = YES:
        x-StkAct = 0.
        FIND FIRST Almmmate WHERE Almmmate.codcia = s-CodCia
            AND Almmmate.codalm = Almacen.CodAlm
            AND Almmmate.codmat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
        x-StkAct = x-StkAct * pPorStock / 100.
        IF x-StkAct < 0 THEN x-StkAct = 0.
        IF pStock > 1 THEN DO:
            IF pStock = 2 AND x-StkAct = 0 THEN NEXT.
            IF pStock = 3 AND x-StkAct > 0 THEN NEXT.
        END.
        IF (pStock = 1 OR pStock = 2) AND pMinimo > 0 AND x-StkAct < pMinimo THEN NEXT.
        cCodMat = Almmmatg.CodMat.
        cCodMat = STRING(INTEGER(TRIM(Almmmatg.CodMat))) NO-ERROR.
        cDesMat = REPLACE(Almmmatg.DesMat, '"', "'").

        CREATE Detalle.
        ASSIGN
            Detalle.Referencia_Aliado = cCodMat
            Detalle.Sku = cCodMat
            Detalle.Nombre = cDesMat
            Detalle.Marca = Almmmatg.DesMar
            Detalle.Stock = x-StkAct
            Detalle.Tienda = FacTabla.Campo-C[1] 
            /*Detalle.Precio_Por_Tienda = ROUND(f-PreVta,2)*/
            Detalle.Categoria_Producto_1 = Almtfami.desfam
            Detalle.Categoria_Producto_2 = AlmSFami.dessub
            Detalle.Categoria_Producto_3 = ''
            Detalle.Categoria_Producto_4 = ''
            Detalle.Imagen_de_Producto = ''
            Detalle.Categoria_Combinacion = ''
            Detalle.Nombre_Combinacion = ''
            .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Old B-table-Win 
PROCEDURE Carga-Temporal-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pPorStock AS DECI.
    DEF INPUT PARAMETER pStock AS INTE.
    DEF INPUT PARAMETER pMinimo AS DECI.

    DEF VAR x-StkAct AS DECI NO-UNDO.
    DEF VAR cCodMat AS CHAR NO-UNDO.
    DEF VAR cDesMat AS CHAR NO-UNDO.
    DEF VAR cFchIni AS CHAR NO-UNDO.
    DEF VAR cFchFin AS CHAR NO-UNDO.

    DEF VAR s-UndVta AS CHAR NO-UNDO.
    DEF VAR f-Factor AS DECI NO-UNDO.
    DEF VAR f-PreBas AS DECI NO-UNDO.
    DEF VAR f-PreVta AS DECI NO-UNDO.
    DEF VAR f-Dsctos AS DECI NO-UNDO.
    DEF VAR y-Dsctos AS DECI NO-UNDO.
    DEF VAR z-Dsctos AS DECI NO-UNDO.
    DEF VAR x-TipDto AS CHAR NO-UNDO.
    DEF VAR f-FleteUnitario AS DECI NO-UNDO.

    /* Barremos divisiones relacionadas con Rappi */
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia AND FacTabla.Tabla = 'IDRAPPI',
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia 
            AND Almacen.CodDiv = FacTabla.Codigo
            AND Almacen.AlmDespacho = YES 
            AND Almacen.AlmPrincipal = YES:
        x-StkAct = 0.
        FIND Almmmate WHERE Almmmate.codcia = s-CodCia
            AND Almmmate.codalm = Almacen.CodAlm
            AND Almmmate.codmat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
        x-StkAct = x-StkAct * pPorStock / 100.
        IF x-StkAct < 0 THEN x-StkAct = 0.
        IF pStock > 1 THEN DO:
            IF pStock = 2 AND x-StkAct = 0 THEN NEXT.
            IF pStock = 3 AND x-StkAct > 0 THEN NEXT.
        END.
        IF (pStock = 1 OR pStock = 2) AND pMinimo > 0 AND x-StkAct < pMinimo THEN NEXT.
        cCodMat = STRING(INTEGER(TRIM(Almmmatg.CodMat))).
        cDesMat = REPLACE(Almmmatg.DesMat, '"', "'").

        CREATE Detalle.
        ASSIGN
            Detalle.Referencia_Aliado = cCodMat
            Detalle.Sku = cCodMat
            Detalle.Nombre = cDesMat
            Detalle.Marca = Almmmatg.DesMar
            Detalle.Stock = x-StkAct
            Detalle.Tienda = FacTabla.Campo-C[1] 
            Detalle.Precio_Por_Tienda = ROUND(f-PreVta,2)
            Detalle.Categoria_Producto_1 = Almtfami.desfam
            Detalle.Categoria_Producto_2 = AlmSFami.dessub
            Detalle.Categoria_Producto_3 = ''
            Detalle.Categoria_Producto_4 = ''
            Detalle.Imagen_de_Producto = ''
            Detalle.Categoria_Combinacion = ''
            Detalle.Nombre_Combinacion = ''
            .
        /* Descuentos */
        DEF VAR x-Old-Descuento AS DEC NO-UNDO.
        DEF VAR x-DctoPromocional AS DEC NO-UNDO.
        x-Old-Descuento = 0. 
        FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia
            AND VtaDctoProm.CodDiv = gn-divi.CodDiv
            AND VtaDctoProm.CodMat = VtaListaMay.CodMat
            AND VtaDctoProm.FlgEst = "A"
            AND (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin):
            cFchIni = STRING(DAY(VtaDctoProm.FchIni),'99') + '-' +
                        STRING(MONTH(VtaDctoProm.FchIni),'99') + '-' +
                        STRING(YEAR(VtaDctoProm.FchIni),'9999').
            cFchFin = STRING(DAY(VtaDctoProm.FchFin),'99') + '-' +
                        STRING(MONTH(VtaDctoProm.FchFin),'99') + '-' +
                        STRING(YEAR(VtaDctoProm.FchFin),'9999').
            x-DctoPromocional = VtaDctoProm.Descuento.
            x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento).
            IF VtaDctoProm.Descuento >= x-DctoPromocional THEN
                ASSIGN
                Detalle.Precio_Con_Descuento = STRING( ROUND( Detalle.Precio_Por_Tienda * (1 - ( x-DctoPromocional / 100 )), 4) )
                Detalle.Fecha_Inicio_Descuento = cFchIni
                Detalle.Fecha_Fin_Descuento = cFchFin
                .
            x-Old-Descuento = x-DctoPromocional.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Contador-de-Envios B-table-Win 
PROCEDURE Contador-de-Envios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER cCarpeta AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Bloqueamos Archivo de Control de envíos */
DEF BUFFER B-Tabla FOR FacTabla.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="B-Tabla" ~
        &Condicion="B-Tabla.CodCia = s-CodCia ~
            AND B-Tabla.Tabla = s-Tabla ~
            AND B-Tabla.Codigo = s-Codigo" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* Veamos el contador de envíos */
    IF B-Tabla.Campo-D[1] = ? OR B-Tabla.Campo-D[1] <> TODAY THEN DO:
        B-Tabla.Campo-D[1] = TODAY.
        B-Tabla.Valor[20] = 1.     /* Inicio del contador */
    END.
    cCarpeta = cCarpeta + '\RAPPI ' + STRING(DAY(TODAY), '99') + ' ' +
        STRING(MONTH(TODAY), '99') + ' ' + SUBSTRING(STRING(YEAR(TODAY)),3,2) + ' - ' +
        TRIM(STRING(INTEGER(B-Tabla.Valor[20]))) + '.csv'.

    ASSIGN
        B-Tabla.Valor[20] = B-Tabla.Valor[20] + 1.
    RELEASE B-Tabla.
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto-v2 B-table-Win 
PROCEDURE Genera-Texto-v2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPorStock AS DEC.
DEF INPUT PARAMETER pMinimo AS DEC.
DEF INPUT PARAMETER pPrecio AS INT.
DEF INPUT PARAMETER pStock AS INT.

IF NOT AVAILABLE Gn-Divi THEN RETURN.

/* *************************************************************************************** */
/* Verificamos que gn-divi.coddiv esté en una peldaño válido en Pricing */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR LogParteEscalera AS LOG NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.
RUN web_api-captura-peldano-valido IN hProc (INPUT gn-divi.CodDiv,
                                             OUTPUT LogParteEscalera,
                                             OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* *************************************************************************************** */
/* *************************************************************************************** */
DEF VAR cCarpeta AS CHAR NO-UNDO.
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR cDesMat AS CHAR NO-UNDO.
DEF VAR cFchIni AS CHAR NO-UNDO.
DEF VAR cFchFin AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-DIR cCarpeta TITLE "Seleccione la carpeta de destino".
IF TRUE <> (cCarpeta > '') THEN RETURN.

/* *********************** */
/* Archivo separa por TABs */
/* *********************** */
RUN Contador-de-Envios (INPUT-OUTPUT cCarpeta, OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* *************************************************************************************** */
/* *************************************************************************************** */
DEF BUFFER TIENDAS FOR Gn-Divi.
DEF BUFFER B-DIVI FOR Gn-Divi.

DEF VAR x-StkAct AS INTE NO-UNDO.

x-dir-tmp = SESSION:TEMP-DIRECTORY.

/* ---- */
x-file-trace = x-dir-tmp + "tracezz.txt".
x-trace-save = NO.              /* ?????????? */

IF x-trace-save = YES THEN DO:
    OUTPUT STREAM txt-trace TO VALUE (x-file-trace).
END.

SESSION:SET-WAIT-STATE('GENERAL').

RUN Carga-Reporte (INPUT pPorStock, INPUT pStock, INPUT pMinimo).
RUN Carga-Precios (INPUT pPrecio).
RUN Limpieza-Textos (INPUT pPrecio).

/* *************************************************************************************** */
/* *************************************************************************************** */
DEF VAR x-Titulo AS CHAR NO-UNDO.

x-Titulo = 'Referencia_Aliado;Sku;Nombre;Descripcion;Marca;Stock;Tienda;Precio_Por_Tienda;Precio_Con_Descuento;~
Descuento;Fecha_Inicio_Descuento;Fecha_Fin_Descuento;~
Categoria_Producto_1;Categoria_Producto_2;Categoria_Producto_3;Categoria_Producto_4;~
Imagen_de_Producto;Categoria_Combinacion;Nombre_Combinacion'.
x-Titulo = REPLACE(x-Titulo,';',",").

OUTPUT TO VALUE(cCarpeta).
PUT UNFORMATTED x-Titulo SKIP.
FOR EACH Detalle NO-LOCK:
    PUT UNFORMATTED
        Detalle.Referencia_Aliado       ","
        Detalle.Sku                     ","
        Detalle.Nombre                  ","
        Detalle.Descripcion             ","
        Detalle.Marca                   ","
        Detalle.Stock                   ","
        Detalle.Tienda                  ","
        Detalle.Precio_Por_Tienda       ","
        Detalle.Precio_Con_Descuento    ","
        Detalle.Descuento               ","
        Detalle.Fecha_Inicio_Descuento  ","
        Detalle.Fecha_Fin_Descuento     ","
        Detalle.Categoria_Producto_1    ","
        Detalle.Categoria_Producto_2    ","
        Detalle.Categoria_Producto_3    ","
        Detalle.Categoria_Producto_4    ","
        Detalle.Imagen_de_Producto      ","
        Detalle.Categoria_Combinacion   ","
        Detalle.Nombre_Combinacion      
        SKIP.
END.
/* x-Titulo = 'Referencia_Aliado;Sku;Nombre;Descripcion;Marca;Stock;Tienda;Precio_Por_Tienda;Precio_Con_Descuento;~ */
/* Descuento;Fecha_Inicio_Descuento;Fecha_Fin_Descuento;~                                                           */
/* Categoria_Producto_1;Categoria_Producto_2;Categoria_Producto_3;Categoria_Producto_4;~                            */
/* Imagen_de_Producto;Categoria_Combinacion;Nombre_Combinacion'.                                                    */
/* x-Titulo = REPLACE(x-Titulo,';',"~011").                                                                         */
/* FOR EACH Detalle NO-LOCK:                      */
/*     PUT UNFORMATTED                            */
/*         Detalle.Referencia_Aliado       "~011" */
/*         Detalle.Sku                     "~011" */
/*         Detalle.Nombre                  "~011" */
/*         Detalle.Descripcion             "~011" */
/*         Detalle.Marca                   "~011" */
/*         Detalle.Stock                   "~011" */
/*         Detalle.Tienda                  "~011" */
/*         Detalle.Precio_Por_Tienda       "~011" */
/*         Detalle.Precio_Con_Descuento    "~011" */
/*         Detalle.Descuento               "~011" */
/*         Detalle.Fecha_Inicio_Descuento  "~011" */
/*         Detalle.Fecha_Fin_Descuento     "~011" */
/*         Detalle.Categoria_Producto_1    "~011" */
/*         Detalle.Categoria_Producto_2    "~011" */
/*         Detalle.Categoria_Producto_3    "~011" */
/*         Detalle.Categoria_Producto_4    "~011" */
/*         Detalle.Imagen_de_Producto      "~011" */
/*         Detalle.Categoria_Combinacion   "~011" */
/*         Detalle.Nombre_Combinacion             */
/*         SKIP.                                  */
/* END.                                           */
OUTPUT CLOSE.

FILL-IN_DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto-v2-Old B-table-Win 
PROCEDURE Genera-Texto-v2-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPorStock AS DEC.
DEF INPUT PARAMETER pMinimo AS DEC.
DEF INPUT PARAMETER pPrecio AS INT.
DEF INPUT PARAMETER pStock AS INT.

IF NOT AVAILABLE Gn-Divi THEN RETURN.

DEF VAR cCarpeta AS CHAR NO-UNDO.
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR cDesMat AS CHAR NO-UNDO.
DEF VAR cFchIni AS CHAR NO-UNDO.
DEF VAR cFchFin AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-DIR cCarpeta TITLE "Seleccione la carpeta de destino".
IF TRUE <> (cCarpeta > '') THEN RETURN.

/* Bloqueamos Archivo de Control de envíos */
DEF BUFFER B-Tabla FOR FacTabla.

{lib/lock-genericov3.i ~
    &Tabla="B-Tabla" ~
    &Condicion="B-Tabla.CodCia = s-CodCia ~
        AND B-Tabla.Tabla = s-Tabla ~
        AND B-Tabla.Codigo = s-Codigo" ~
    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
    }

/* *********************** */
/* Archivo separa por TABs */
/* *********************** */
DEF VAR cArchivo AS CHAR NO-UNDO.

/* Veamos el contador de envíos */
IF B-Tabla.Campo-D[1] = ? OR B-Tabla.Campo-D[1] <> TODAY THEN DO:
    B-Tabla.Campo-D[1] = TODAY.
    B-Tabla.Valor[20] = 1.     /* Inicio del contador */
END.
cCarpeta = cCarpeta + '\RAPPI ' + STRING(DAY(TODAY), '99') + ' ' +
    STRING(MONTH(TODAY), '99') + ' ' + SUBSTRING(STRING(YEAR(TODAY)),3,2) + ' - ' +
    TRIM(STRING(INTEGER(B-Tabla.Valor[20]))) + '.csv'.

ASSIGN
    B-Tabla.Valor[20] = B-Tabla.Valor[20] + 1.
RELEASE B-Tabla.


DEF BUFFER TIENDAS FOR Gn-Divi.
DEF BUFFER B-DIVI FOR Gn-Divi.

DEF VAR x-StkAct AS INTE NO-UNDO.

x-dir-tmp = SESSION:TEMP-DIRECTORY.

/* ---- */
x-file-trace = x-dir-tmp + "tracezz.txt".
x-trace-save = NO.              /* ?????????? */

IF x-trace-save = YES THEN DO:
    OUTPUT STREAM txt-trace TO VALUE (x-file-trace).
END.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE Detalle.
/* Barremos por cada precio registrado en la lista de precios y
    por cada ID Rappi registrado
*/
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.

FOR EACH VtaListaMay NO-LOCK WHERE VtaListaMay.CodCia = gn-divi.codcia AND VtaListaMay.CodDiv = gn-divi.coddiv,
    FIRST Almmmatg OF VtaListaMay NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK:
    FILL-IN_DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + " - " + Almmmatg.desmat.
    /* 2do. ver si el producto es válido para Rappi */  
    IF Almmmatg.TpoMrg = "1" THEN NEXT.     /* Mayorista:No pasa */
    IF Almmmatg.TpoMrg = "2" AND Almmmatg.MonVta <> 1 THEN NEXT.    /* Minorista: No pasan Dólares */
    /* 1ro. filtramos por precio */
    RUN {&precio-venta-general-mayor} ("N",
                                       gn-divi.coddiv,
                                       "11111111111",
                                       1,
                                       INPUT-OUTPUT s-UndVta,
                                       OUTPUT f-Factor,
                                       Almmmatg.CodMat,
                                       '603',
                                       1,
                                       4,
                                       OUTPUT f-PreBas,
                                       OUTPUT f-PreVta,
                                       OUTPUT f-Dsctos,
                                       OUTPUT y-Dsctos,
                                       OUTPUT z-Dsctos,
                                       OUTPUT x-TipDto,
                                       "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
                                       OUTPUT f-FleteUnitario,
                                       "",
                                       NO
                                       ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN NEXT.

    IF pPrecio > 1 THEN DO:
        IF pPrecio = 2 AND f-PreVta = 0 THEN NEXT.
        IF pPrecio = 3 AND f-PreVta > 0 THEN NEXT.
    END.

    RUN Carga-Temporal (INPUT pPorStock, INPUT pStock, INPUT pMinimo).
END.

DEF VAR x-Titulo AS CHAR NO-UNDO.

x-Titulo = 'Referencia_Aliado;Sku;Nombre;Descripcion;Marca;Stock;Tienda;Precio_Por_Tienda;Precio_Con_Descuento;~
Descuento;Fecha_Inicio_Descuento;Fecha_Fin_Descuento;~
Categoria_Producto_1;Categoria_Producto_2;Categoria_Producto_3;Categoria_Producto_4;~
Imagen_de_Producto;Categoria_Combinacion;Nombre_Combinacion'.
x-Titulo = REPLACE(x-Titulo,';',"~011").

OUTPUT TO VALUE(cCarpeta).
PUT UNFORMATTED x-Titulo SKIP.
FOR EACH Detalle NO-LOCK:
    PUT UNFORMATTED
        Detalle.Referencia_Aliado       "~011"
        Detalle.Sku                     "~011"
        Detalle.Nombre                  "~011"
        Detalle.Descripcion             "~011"
        Detalle.Marca                   "~011"
        Detalle.Stock                   "~011"
        Detalle.Tienda                  "~011"
        Detalle.Precio_Por_Tienda       "~011"
        Detalle.Precio_Con_Descuento    "~011"
        Detalle.Descuento               "~011"
        Detalle.Fecha_Inicio_Descuento  "~011"
        Detalle.Fecha_Fin_Descuento     "~011"
        Detalle.Categoria_Producto_1    "~011"
        Detalle.Categoria_Producto_2    "~011"
        Detalle.Categoria_Producto_3    "~011"
        Detalle.Categoria_Producto_4    "~011"
        Detalle.Imagen_de_Producto      "~011"
        Detalle.Categoria_Combinacion   "~011"
        Detalle.Nombre_Combinacion      
        SKIP.
END.
OUTPUT CLOSE.

FILL-IN_DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpieza-Textos B-table-Win 
PROCEDURE Limpieza-Textos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPrecio AS INTE.

/* Limpieza y depuración de textos */
DEF VAR cCadena AS CHAR NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.

FOR EACH Detalle EXCLUSIVE-LOCK:
    f-PreVta = Detalle.Precio_Por_Tienda.
    IF pPrecio > 1 THEN DO:
        IF pPrecio = 2 AND f-PreVta = 0 THEN DO:
            DELETE Detalle.
            NEXT.
        END.
        IF pPrecio = 3 AND f-PreVta > 0 THEN DO:
            DELETE Detalle.
            NEXT.
        END.
    END.
    RUN lib/limpiar-texto-abc.p (Detalle.Nombre, " ",OUTPUT cCadena).
    cCadena = REPLACE(cCadena,","," ").
    Detalle.Nombre = cCadena.
    RUN lib/limpiar-texto-abc.p (Detalle.Marca, " ",OUTPUT cCadena).
    cCadena = REPLACE(cCadena,","," ").
    Detalle.Marca = cCadena.
    RUN lib/limpiar-texto-abc.p (Detalle.Categoria_Producto_1, " ",OUTPUT cCadena).
    cCadena = REPLACE(cCadena,","," ").
    Detalle.Categoria_Producto_1 = cCadena.
    RUN lib/limpiar-texto-abc.p (Detalle.Categoria_Producto_2, " ",OUTPUT cCadena).
    cCadena = REPLACE(cCadena,","," ").
    Detalle.Categoria_Producto_2 = cCadena.
END.

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
  {src/adm/template/snd-list.i "VtaListaMay"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

