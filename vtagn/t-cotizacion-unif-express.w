&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-2 LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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
&SCOPED-DEFINE precio-venta-general vtagn/PrecioVentaMayorCredito.p

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.       /* División de Ventas */
DEFINE SHARED VARIABLE pCodDiv   AS CHAR.       /* División de Precios */
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-FMAPGO  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE s-TpoPed   AS CHAR.
DEFINE SHARED VARIABLE s-nrodec AS INT.
DEFINE SHARED VARIABLE s-import-ibc AS LOG.
DEFINE SHARED VARIABLE s-import-cissac AS LOG.
DEFINE SHARED VARIABLE S-CMPBNTE  AS CHAR.
DEFINE SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEFINE SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

DEFINE SHARED VARIABLE s-ListaTerceros AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE pCodAlm  AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMat AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHAR NO-UNDO.
/*DEFINE VARIABLE x-adm-new-record AS CHAR.*/
DEFINE VARIABLE s-status-record AS CHAR.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.

DEFINE BUFFER B-ITEM FOR ITEM.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

DEF VAR x-Semaforo AS CHAR NO-UNDO.
DEF VAR pForeground AS INT.
DEF VAR pBackground AS INT.

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
&Scoped-define INTERNAL-TABLES ITEM

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table x-Semaforo @ x-Semaforo ITEM.NroItm ~
ITEM.codmat ITEM.CodMatWeb fDesMat() @ x-DesMat fDesMar() @ x-DesMar ~
ITEM.UndVta ITEM.CanPed ITEM.PreUni ITEM.Por_Dsctos[1] ITEM.Por_Dsctos[2] ~
ITEM.Por_Dsctos[3] ITEM.ImpDto ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.codmat 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY ITEM.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY ITEM.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpTot 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDesMar B-table-Win 
FUNCTION fDesMar RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDesMat B-table-Win 
FUNCTION fDesMat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPrecioUnitario B-table-Win 
FUNCTION fPrecioUnitario RETURNS DECIMAL
  ( INPUT pPreUni AS DEC ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      x-Semaforo @ x-Semaforo COLUMN-LABEL "Sem." FORMAT "x(4)":U
      ITEM.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      ITEM.codmat COLUMN-LABEL "Articulo" FORMAT "X(14)":U WIDTH 8
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ITEM.CodMatWeb COLUMN-LABEL "Cod. Web" FORMAT "x(6)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fDesMat() @ x-DesMat COLUMN-LABEL "Descripción" FORMAT "x(50)":U
            WIDTH 46
      fDesMar() @ x-DesMar COLUMN-LABEL "Marca" FORMAT "x(20)":U
            WIDTH 13.43
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 6.43
      ITEM.CanPed FORMAT ">>>,>>9.99":U WIDTH 8.43
      ITEM.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.99999":U
            WIDTH 8.43
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Admins" FORMAT "->,>>9.999999":U
            WIDTH 6.43
      ITEM.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->,>>9.999999":U
            WIDTH 7.43
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->,>>9.999999":U
            WIDTH 7.43
      ITEM.ImpDto FORMAT ">,>>>,>>9.9999":U WIDTH 8.43
      ITEM.ImpLin FORMAT ">,>>>,>>9.99":U WIDTH 8.72
  ENABLE
      ITEM.codmat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 156 BY 11.73
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-ImpTot AT ROW 12.85 COL 140 COLON-ALIGNED WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-2 T "NEW SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 13.54
         WIDTH              = 158.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

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

/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ITEM"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.ITEM.NroItm|yes"
     _FldNameList[1]   > "_<CALC>"
"x-Semaforo @ x-Semaforo" "Sem." "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM.NroItm
"ITEM.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "Articulo" "X(14)" "character" 11 0 ? ? ? ? yes ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ITEM.CodMatWeb
"ITEM.CodMatWeb" "Cod. Web" "x(6)" "character" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fDesMat() @ x-DesMat" "Descripción" "x(50)" ? ? ? ? ? ? ? no ? no no "46" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fDesMar() @ x-DesMar" "Marca" "x(20)" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Precio!Unitario" ">>,>>9.99999" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto!Admins" ? "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.Por_Dsctos[2]
"ITEM.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM.ImpDto
"ITEM.ImpDto" ? ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    /* ******************************************************************************* */
    /* RHC SEMAFORO 14/11/2019 */
    /* ******************************************************************************* */
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR pLimite AS DEC NO-UNDO.
    DEF VAR pMargen AS DEC NO-UNDO.
    RUN vtagn/p-margen-utilidad-v2 (s-CodDiv,
                                    INPUT ITEM.CodMat,
                                    INPUT (ITEM.ImpLin / ITEM.CanPed),
                                    INPUT ITEM.UndVta,
                                    INPUT s-CodMon,
                                    INPUT s-TpoCmb,
                                    NO,
                                    INPUT ITEM.AlmDes,
                                    OUTPUT pMargen,
                                    OUTPUT pLimite,
                                    OUTPUT pError).
    IF RETURN-VALUE = 'OK' THEN DO:
        RUN vtagn/p-semaforo (INPUT ITEM.CodMat,
                              INPUT s-CodDiv,
                              INPUT pMargen,
                              OUTPUT pForeground,
                              OUTPUT pBackground).
        ASSIGN
            x-Semaforo:BGCOLOR IN BROWSE {&BROWSE-NAME} = pBackground
            x-Semaforo:FGCOLOR IN BROWSE {&BROWSE-NAME} = pForeground.
    END.
    /* ******************************************************************************* */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  DISPLAY I-NroItm @ ITEM.NroItm WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME ITEM.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
    IF s-status-record = 'cancel-record' THEN RETURN.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    /* Solo de modifica el precio si se cambia el código del producto */
    ASSIGN 
        F-FACTOR = 1
        X-CANPED = 1
        f-PreBas = ITEM.PreUniWeb
        f-PreVta = ITEM.PreUniWeb
        f-Dsctos = 0
        y-Dsctos = 0
        z-Dsctos = 0
        x-TipDto = ''
        f-FleteUnitario = 0.
    IF ITEM.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> ITEM.codmatweb THEN DO:
        /* Valida Maestro Productos x Almacen */
        /*RUN vta2/PrecioMayorista-Cred-v2 (*/
        RUN {&precio-venta-general} (
            s-TpoPed,
            pCodDiv,
            s-CodCli,
            s-CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
            s-FmaPgo,
            x-CanPed,
            s-NroDec,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
            OUTPUT f-FleteUnitario,
            "",
            TRUE
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
        IF f-PreBas > ITEM.PreUniWeb 
            THEN ASSIGN 
                f-Dsctos = 0
                y-Dsctos = ROUND( ( 1 - ITEM.PreUniWeb / f-PreBas ) * 100, 4 )
                z-Dsctos = 0.
        ELSE ASSIGN 
                f-PreBas = ITEM.PreUniWeb
                f-PreVta = ITEM.PreUniWeb
                f-Dsctos = 0
                y-Dsctos = 0
                z-Dsctos = 0
                x-TipDto = ''.
    END.

    DISPLAY 
        Almmmatg.DesMat @ x-DesMat 
        Almmmatg.DesMar @ x-DesMar 
        s-UndVta @ ITEM.UndVta 
        F-PREVTA @ ITEM.PreUni 
        z-Dsctos @ ITEM.Por_Dsctos[2]
        y-Dsctos @ ITEM.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM.codmat IN BROWSE br_table /* Articulo */
OR F8 OF ITEM.codmat
DO:
    ASSIGN 
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    CASE s-TpoPed:
        WHEN "M" THEN DO:
            RUN vta2/c-listaprecios-marco ('Lista de Precios Contrato Marco').
            IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
        END.
        WHEN "R" THEN DO:
            RUN vta2/c-listaprecios-remate-cred ('Lista de Precios Remate').
            IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
        END.
        OTHERWISE DO:
            RUN vta2/c-listaprecios-cred ('Lista de Precios').
            IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.CanPed IN BROWSE br_table /* Cantidad */
DO:
    IF ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN RETURN.
    /*IF x-Adm-New-record = "NO" THEN RETURN.*/
    IF s-status-record = 'cancel-record' THEN RETURN.
    RUN vtagn/c-uniofi-01 ("Unidades de Venta",
                        ITEM.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        s-codalm).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM.CanPed, ITEM.codmat, ITEM.UndVta, ITEM.PreUni 
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios-Supermercados B-table-Win 
PROCEDURE Calculo-Precios-Supermercados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR f-PorImp AS DEC NO-UNDO.

   F-PorImp = 1.

   /* RHC 12.06.08 al tipo de cambio de la familia */
   IF S-CODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * Almmmatg.TpoCmb * F-FACTOR.
   END.
   IF S-CODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / Almmmatg.TpoCmb) * F-FACTOR.
   END.
   f-PreVta = f-PreBas.
   FIND FacTabla WHERE FacTabla.CodCia = s-codcia
       AND FacTabla.Tabla = 'AU' 
       AND FacTabla.Codigo = s-codcli
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Factabla THEN RETURN.

   IF Factabla.Valor[1] <> 0 
   THEN f-PreVta = f-PreBas * ( 1 - Factabla.Valor[1] / 100 ).
   ELSE f-PreVta = f-PreBas * ( 1 + Factabla.Valor[2] / 100 ).

    RUN src/BIN/_ROUND1(F-PREVTA, 2, OUTPUT F-PREVTA).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desde_cotiz_excel B-table-Win 
PROCEDURE desde_cotiz_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-ImpTot = 0.
FOR EACH B-ITEM:
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-ITEM.ImpLin.
END.
DISPLAY FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
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
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND Almmmatg.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      ITEM.CodCia = S-CODCIA
      ITEM.Factor = F-FACTOR
      ITEM.NroItm = I-NroItm
      ITEM.PorDto = f-Dsctos
      ITEM.PreBas = F-PreBas 
      ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
      ITEM.AftIgv = Almmmatg.AftIgv
      ITEM.AftIsc = Almmmatg.AftIsc
      ITEM.Libre_c04 = x-TipDto.
  IF TRUE <> (ITEM.AlmDes > '') THEN ITEM.AlmDes = ENTRY(1, s-CodAlm).
  ASSIGN 
      ITEM.UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      ITEM.PreUni = DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[1] = DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[2] = DEC(ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[3] = DEC(ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Libre_d02 = f-FleteUnitario.         /* Flete Unitario */
  /* RHC El código del producto es el mismo de la Web => Retornamos valores originales */
  IF (ITEM.CodMat = ITEM.CodMatWeb) THEN
      ASSIGN
      ITEM.ImpLin = ITEM.ImpLinWeb
      ITEM.PreUni = ITEM.PreUniWeb.
  /* ***************************************************************** */
  {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
  /* ***************************************************************** */
  /* REPETIDOS */
  IF CAN-FIND(FIRST B-ITEM WHERE B-ITEM.codmat = ITEM.codmat AND ROWID(B-ITEM) <> ROWID(ITEM) NO-LOCK) THEN DO:
      MESSAGE 'Product YA registrado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.codmat IN BROWSE {&browse-name}.
      UNDO, RETURN 'ADM-ERROR'.
  END.

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
  /*x-Adm-New-Record = "NO".*/
  s-status-record = 'cancel-record'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head').


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.
  
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
  /*DEF VAR x-adm-new-record AS CHAR.*/
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  IF s-status-record = 'add-record' THEN RUN Procesa-Handle IN lh_handle ('Add-Record').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Percepcion B-table-Win 
PROCEDURE Percepcion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


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
  {src/adm/template/snd-list.i "ITEM"}

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
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/

  IF ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    OR INTEGER(ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Codigo de Producto no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       RETURN "ADM-ERROR".
  END.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Código de producto NO registrado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF Almmmatg.TpoArt = "D" THEN DO:
      MESSAGE 'Código de producto DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* FAMILIA DE VENTAS */

  /* Ic -Ene2016 : No vales Vales Utilex */
  IF s-TpoPed <> 'VU' THEN DO:
      FIND Almtfami OF Almmmatg NO-LOCK.
      IF Almtfami.SwComercial = NO THEN DO:
          MESSAGE 'Línea NO autorizada para ventas' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO ITEM.CodMat.
          RETURN "ADM-ERROR".
      END.
  END.

  FIND Almsfami OF Almmmatg NO-LOCK.
  IF AlmSFami.SwDigesa = YES AND Almmmatg.VtoDigesa <> ? AND Almmmatg.VtoDigesa < TODAY THEN DO:
      MESSAGE 'Producto con autorización de DIGESA VENCIDA' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* ARTICULO */
  DEF VAR pCodMat AS CHAR.
  pCodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* RHC 21/08/2012 CONTROL POR TIPO DE PRODUCTO */
  IF Almmmatg.TpoMrg = "1" AND s-FlgTipoVenta = NO THEN DO:
      MESSAGE "No se puede vender este producto al por menor"
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  IF Almmmatg.TpoMrg = "2" AND s-FlgTipoVenta = YES THEN DO:
      MESSAGE "No se puede vender este producto al por mayor"
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */
  /* Unidad */
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "NO tiene registrado la unidad de venta" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* CANTIDAD */
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&browse-name} = "UNI" 
      AND DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) -
            TRUNCATE(DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 0) <> 0
      THEN DO:
      MESSAGE "NO se permiten ventas fraccionadas" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.

  /* PRECIO UNITARIO */
  IF DECIMAL(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       RETURN "ADM-ERROR".
  END.

  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
IF AVAILABLE ITEM THEN 
    ASSIGN
    i-nroitm = ITEM.NroItm
    f-Factor = ITEM.Factor
    f-PreBas = ITEM.PreBas
    f-PreVta = ITEM.PreUni
    s-UndVta = ITEM.UndVta
    x-TipDto = ITEM.Libre_c04
    /*x-Adm-New-Record = "NO".*/
    s-status-record = 'update-record'.
RUN Procesa-Handle IN lh_handle ('Disable-Head').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDesMar B-table-Win 
FUNCTION fDesMar RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ITEM THEN RETURN "".   /* Function return value. */
FIND Almmmatg OF ITEM NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN RETURN Almmmatg.DesMar.
RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDesMat B-table-Win 
FUNCTION fDesMat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ITEM THEN RETURN "".   /* Function return value. */
FIND Almmmatg OF ITEM NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN RETURN Almmmatg.DesMat.
RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPrecioUnitario B-table-Win 
FUNCTION fPrecioUnitario RETURNS DECIMAL
  ( INPUT pPreUni AS DEC ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR s-TpoCmb AS DEC NO-UNDO.

IF s-CodDiv <> "00018" THEN RETURN pPreUni.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv NO-LOCK.
IF gn-divi.Libre_L01 = NO THEN RETURN pPreUni.

/* NO debe ser un cliente especial */
FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = "PL1" 
    AND VtaTabla.Llave_c1 = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN RETURN pPreUni.
/* Debe estar registrado en la lista #1 */
FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = "LP1" NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMay THEN RETURN pPreUni.
/* PRECIO BASE Y UNIDAD DE VENTA */
ASSIGN
    F-PreBas = VtaListaMay.PreOfi
    s-UndVta = VtaListaMay.Chr__01.
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN RETURN pPreUni.
ASSIGN
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu
    s-tpocmb = VtaListaMay.TpoCmb.     /* ¿? */
/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMay.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMay.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) * F-FACTOR.
END.
RETURN MINIMUM(f-PreBas, pPreUni).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

