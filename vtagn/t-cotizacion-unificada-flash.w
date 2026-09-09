&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM-2 LIKE FacDPedi.



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

/* Parameters Definitions ---                                           */
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCreditoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalCreditoMayorista.p

/* 20/07/2022 Control de modicación de registro */
DEF VAR s-Update-Control AS LOG INIT NO NO-UNDO.

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
DEFINE SHARED VARIABLE s-NroPed AS CHAR.
DEFINE SHARED VARIABLE s-nrodec AS INT.
DEFINE SHARED VARIABLE S-CMPBNTE  AS CHAR.
DEFINE SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEFINE SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

DEFINE SHARED VARIABLE s-acceso-semaforos AS LOG.

DEFINE SHARED VARIABLE s-ListaTerceros AS INT.
DEF SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.

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

DEFINE NEW SHARED VARIABLE S-CODMAT   AS CHAR.

DEFINE SHARED VAR s-nivel-acceso AS INT NO-UNDO.
/* 1: NO ha pasado por ABASTECIMIENTOS => Puede modificar todo */
/* 0: YA pasó por abastecimientos => Puede disminuir las cantidades mas no incrementarlas */

DEF VAR x-Semaforo AS CHAR NO-UNDO.

DEF VAR pForeground AS INT.
DEF VAR pBackground AS INT.

DEFINE SHARED VARIABLE s-import-b2b AS LOG.
DEFINE SHARED VARIABLE s-import-ibc AS LOG.
/*DEFINE SHARED VARIABLE s-import-cissac AS LOG.*/

/* Controla si es un nuevo pedido o se está modificando */
DEF SHARED VAR s-adm-new-record AS CHAR.

/* Llave única para el usuario activo */
DEF SHARED VAR s-Llave-Control AS CHAR.

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
ITEM.codmat fDesMat() @ x-DesMat fDesMar() @ x-DesMar ITEM.UndVta ~
ITEM.CanPed ITEM.PreUni ITEM.Libre_d02 ITEM.Por_Dsctos[1] ~
ITEM.Por_Dsctos[2] ITEM.Por_Dsctos[3] ITEM.ImpDto ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.codmat ITEM.CanPed 
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
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpTot FILL-IN-Master ~
FILL-IN-Semaforo 

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
DEFINE BUTTON BUTTON-2 
     LABEL "+ CODIGOS" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Master AS DECIMAL FORMAT ">>>,>>,>>9.99":U INITIAL 0 
     LABEL "Empaque Master" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 13 FGCOLOR 15 FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-Semaforo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

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
      fDesMat() @ x-DesMat COLUMN-LABEL "Descripción" FORMAT "x(60)":U
            WIDTH 46.43
      fDesMar() @ x-DesMar COLUMN-LABEL "Marca" FORMAT "x(20)":U
            WIDTH 12.43
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 6.43
      ITEM.CanPed FORMAT ">>>,>>9.99":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ITEM.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.99999":U
      ITEM.Libre_d02 COLUMN-LABEL "Flete!Unitario" FORMAT "->>>,>>9.9999":U
            WIDTH 8.14
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Admins" FORMAT "->>9.9999":U
            WIDTH 6.43
      ITEM.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.9999":U
            WIDTH 7.43
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.9999":U
            WIDTH 7.43
      ITEM.ImpDto FORMAT ">,>>>,>>9.99":U WIDTH 8.43
      ITEM.ImpLin FORMAT ">,>>>,>>9.99":U WIDTH 8.72
  ENABLE
      ITEM.codmat
      ITEM.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 156 BY 11.85
         BGCOLOR 15 FONT 4 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-2 AT ROW 12.85 COL 36 WIDGET-ID 8
     FILL-IN-ImpTot AT ROW 12.85 COL 140 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Master AT ROW 13.38 COL 64 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Semaforo AT ROW 13.38 COL 82 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     "F8: Stocks por Almacén    F5: Actualiza PRECIOS" VIEW-AS TEXT
          SIZE 41 BY .5 AT ROW 12.85 COL 53 WIDGET-ID 10
          BGCOLOR 9 FGCOLOR 15 FONT 6
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
      TABLE: ITEM-2 T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 14.31
         WIDTH              = 158.43.
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
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Master IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Semaforo IN FRAME F-Main
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
     _FldNameList[4]   > "_<CALC>"
"fDesMat() @ x-DesMat" "Descripción" "x(60)" ? ? ? ? ? ? ? no ? no no "46.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fDesMar() @ x-DesMar" "Marca" "x(20)" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" ? ">>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Precio!Unitario" ">>,>>9.99999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM.Libre_d02
"ITEM.Libre_d02" "Flete!Unitario" "->>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto.!Admins" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.Por_Dsctos[2]
"ITEM.Por_Dsctos[2]" "% Dscto!Evento" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Vol/Prom" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM.ImpDto
"ITEM.ImpDto" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON F5 OF br_table IN FRAME F-Main
DO:
  IF s-status-record = 'add-record' OR s-status-record = 'update-record' THEN RETURN.

  DEF VAR x-Rowid AS ROWID NO-UNDO.

  x-Rowid = ?.
  IF AVAILABLE ITEM THEN x-Rowid = ROWID(ITEM).

  RUN Procesa-Handle IN lh_Handle ('Recalculo').
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

  REPOSITION {&BROWSE-NAME} TO ROWID(x-Rowid) NO-ERROR.
  s-Update-Control = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F8 OF br_table IN FRAME F-Main
DO:
  S-CODMAT =ITEM.CodMat.
  run alm/d-stkalm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    /* ****************************************************************************************************** */
    /* Control Margen de Utilidad */
    /* ****************************************************************************************************** */
    /* 1ro. Calculamos el margen de utilidad */
    /* ******************************************************************************* */
    /* RHC SEMAFORO 14/11/2019 */
    /* ******************************************************************************* */
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR pLimite AS DEC NO-UNDO.
    DEF VAR pMargen AS DEC NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN pri/pri-librerias PERSISTENT SET hProc.
    RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT pCodDiv,
                                             INPUT ITEM.CodMat,
                                             INPUT ITEM.UndVta,
                                             INPUT (ITEM.ImpLin / ITEM.CanPed),
                                             INPUT s-CodMon,
                                             OUTPUT pMargen,
                                             OUTPUT pLimite,
                                             OUTPUT pError).
    DELETE PROCEDURE hProc.

/*
    RUN vtagn/p-margen-utilidad (ITEM.CodMat,      /* Producto */
                                 INPUT (ITEM.ImpLin / ITEM.CanPed),  /* Precio de venta unitario */
                                 INPUT ITEM.UndVta,
                                 INPUT s-CodMon,       /* Moneda de venta */
                                 INPUT s-TpoCmb,       /* Tipo de cambio */
                                 NO,            /* Muestra el error */
                                 INPUT ITEM.AlmDes,
                                 OUTPUT pMargen,        /* Margen de utilidad */
                                 OUTPUT pLimite,        /* Margen mínimo de utilidad */
                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                 ).
*/

/*     RUN vtagn/p-margen-utilidad-v2 (s-CodDiv,                          */
/*                                     INPUT ITEM.CodMat,                 */
/*                                     INPUT (ITEM.ImpLin / ITEM.CanPed), */
/*                                     INPUT ITEM.UndVta,                 */
/*                                     INPUT s-CodMon,                    */
/*                                     INPUT s-TpoCmb,                    */
/*                                     NO,                                */
/*                                     INPUT ITEM.AlmDes,                 */
/*                                     OUTPUT pMargen,                    */
/*                                     OUTPUT pLimite,                    */
/*                                     OUTPUT pError).                    */
    IF RETURN-VALUE <> 'ADM-ERROR' THEN DO:
        RUN vtagn/p-semaforo (INPUT ITEM.CodMat,
                              INPUT pCodDiv,
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
      
      FIND Almmmatg OF ITEM NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DISPLAY Almmmatg.CanEmp @ FILL-IN-Master WITH FRAME {&FRAME-NAME}.

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
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
        
    SELF:SCREEN-VALUE = pCodMat.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo " + pCodMat + " no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       ASSIGN SELF:SCREEN-VALUE = "".
       RETURN NO-APPLY.
    END.
    DISPLAY Almmmatg.CanEmp @ FILL-IN-Master WITH FRAME {&FRAME-NAME}.
    /* Valida Maestro Productos x Almacen */
    ASSIGN 
        F-FACTOR = 1
        X-CANPED = 1
        z-Dsctos = 0.
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    RUN {&precio-venta-general} (
        (IF S-TPOMARCO = "SI" THEN "M" ELSE s-TpoPed),
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
        YES
        ).

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
        
    DISPLAY 
        Almmmatg.DesMat @ x-DesMat 
        Almmmatg.DesMar @ x-DesMar 
        s-UndVta @ ITEM.UndVta 
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
            RUN vta2/c-listaprecios-cred-v3 ('Lista de Precios').
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.CanPed IN BROWSE br_table /* Cantidad */
DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    IF s-Import-IBC = YES /*OR s-Import-Cissac = YES*/ THEN RETURN.     /* NO Cambia el precio */
    ASSIGN
        x-CanPed = DEC(SELF:SCREEN-VALUE)
        s-UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM.CanPed IN BROWSE br_table /* Cantidad */
OR f8 OF ITEM.CanPed
DO:
    RUN vtagn/c-uniofi-01 ("Unidades de Venta",
                        ITEM.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        s-codalm).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* + CODIGOS */
DO:
  RUN vta2/d-captura-productosv3.
  /* Definimos si hay datos */
  FIND FIRST ITEM-2 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ITEM-2 THEN RETURN NO-APPLY.

  /* Todo nuevo registro siempre graba la información */
  FOR EACH ITEM-2 NO-LOCK:
      FIND FIRST w-report WHERE w-report.Task-No = 0
          AND w-report.Llave-C = s-Llave-Control
          AND w-report.Campo-C[4] = ITEM-2.codmat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE w-report THEN DO:
          CREATE w-report.
          w-report.Task-No = 0.
          w-report.Llave-C = s-Llave-Control.
          w-report.Campo-C[4] = ITEM-2.codmat.
      END.
      ELSE DO:
          FIND CURRENT w-report EXCLUSIVE-LOCK.
      END.
      ASSIGN
          w-report.Campo-C[3] = s-codcli
          w-report.Campo-C[5] = ITEM-2.undvta
          w-report.Campo-F[1] = ITEM-2.canped
          w-report.Campo-F[2] = ITEM-2.factor
          w-report.Campo-L[1] = ITEM-2.aftigv
          w-report.Campo-L[2] = ITEM-2.aftisc
          .
  END.
  IF AVAILABLE(w-report) THEN RELEASE w-report.
  
  /* Capturamos el 1er item */
  DEF VAR k AS INT NO-UNDO.
  FOR EACH ITEM-2 BY ITEM-2.NroItm:
      k = ITEM-2.NroItm.
      LEAVE.
  END.
  /*RUN Procesa-Handle IN lh_Handle ('Recalculo').*/
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  /* Reposicionamos el puntero */
  FIND ITEM WHERE ITEM.nroitm = k.
  REPOSITION  {&BROWSE-NAME} TO ROWID ROWID(ITEM).
  s-Update-Control = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM.CanPed, ITEM.codmat, ITEM.UndVta , ITEM.PreUni 
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Precios-Items B-table-Win 
PROCEDURE Actualiza-Precios-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE s-update-control.

IF s-Update-Control = NO THEN RETURN.

RUN Procesa-Handle IN lh_handle ('Recalculo').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IBC-Diferencias B-table-Win 
PROCEDURE IBC-Diferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.

EMPTY TEMP-TABLE T-DPEDI.
FOR EACH ITEM:
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = S-CODCIA AND  
         Almmmatg.codmat = ITEM.codmat
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF Almmmatg.TpoArt = "D" THEN NEXT.
    IF Almmmatg.Chr__01 = "" THEN NEXT.
    FIND Almmmate WHERE 
         Almmmate.CodCia = S-CODCIA AND  
         Almmmate.CodAlm = S-CODALM AND  
         Almmmate.CodMat = ITEM.codmat
         USE-INDEX mate01
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    F-FACTOR = 1.
/*     RUN Calculo-Precios-Supermercados. */
    /* RHC 10/08/2012 PRECIO SUPERMERCADO */
    RUN vta2/PrecioSupermercado (s-TpoPed,
                                 pCodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 ITEM.UndVta,
                                 f-Factor,
                                 ITEM.CodMat,
                                 s-FmaPgo,
                                 ITEM.CanPed,
                                 s-NroDec,
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT z-Dsctos,
                                 NO).
    f-PreVta = f-PreVta * ( 1 - z-Dsctos / 100 ) * ( 1 - y-Dsctos / 100 ).
    /* Solo si hay una diferencia mayor al 1% */
    IF ABSOLUTE(ITEM.PreUni - f-PreVta) / f-PreVta * 100 > 0.25 THEN DO:
        CREATE T-DPEDI.
        BUFFER-COPY ITEM TO T-DPEDI
            ASSIGN
                T-DPEDI.Libre_d01 = f-PreVta.
    END.

END.

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
DEF VAR pForeground AS INT.
DEF VAR pBackground AS INT.
/* ******************************************************************************* */
/* RHC SEMAFORO 14/11/2019 */
/* ******************************************************************************* */
DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pLimite AS DEC NO-UNDO.
DEF VAR pMargen AS DEC NO-UNDO.
RUN vtagn/p-semaforo-total.r (INPUT s-CodDiv,
                            INPUT s-CodMon,
                            INPUT TABLE ITEM,
                            OUTPUT pForeground,
                            OUTPUT pBackground).
ASSIGN
    FILL-IN-Semaforo:BGCOLOR IN FRAME {&FRAME-NAME} = pBackground
    FILL-IN-Semaforo:FGCOLOR IN FRAME {&FRAME-NAME} = pForeground.

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
  /* Ya fue procesado por Abastecimientos */
  IF s-nivel-acceso = 0 THEN DO:
      MESSAGE 'Cotización ya ha sido programada por ABASTECIMIENTOS' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  IF s-CodCli = '' THEN DO:
      MESSAGE 'Debe ingresar el CLIENTE' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF s-FmaPgo = '' THEN DO:
      MESSAGE 'Debe ingresar la CONDICION DE VENTA' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* NO PARA: Lista Express */
  IF s-TpoPed = "LF" THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* SUPERMERCADOS */
  IF s-import-ibc = YES /*OR s-Import-Cissac = YES*/ OR s-Import-B2B = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.


  I-NroItm = 0.  
  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  
  FOR EACH B-ITEM BY B-ITEM.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-ITEM.NroItm.
  END.
  s-status-record = 'add-record'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      I-NroItm = I-NroItm + 1
      s-UndVta = "".
      /*x-Adm-New-Record = "YES".*/
  
  RUN Procesa-Handle IN lh_handle ('Disable-Head').
  APPLY 'ENTRY':U TO ITEM.codmat IN BROWSE {&browse-name}.
  
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
      ITEM.PreBas = F-PreBas        /* CONTROL DE PRECIO DE LISTA */
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
  /* ***************************************************************** */
  {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
  /* ***************************************************************** */
  
  /* REPETIDOS */
  IF CAN-FIND(FIRST B-ITEM WHERE B-ITEM.codmat = ITEM.codmat AND ROWID(B-ITEM) <> ROWID(ITEM) NO-LOCK) THEN DO:
      MESSAGE 'Producto YA registrado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.codmat IN BROWSE {&browse-name}.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  /* Grabamos información de control en caso de caida del sistema */
  FIND FIRST w-report WHERE w-report.Task-No = 0
      AND w-report.Llave-C = s-Llave-Control
      AND w-report.Campo-C[4] = ITEM.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report THEN DO:
      CREATE w-report.
      w-report.Task-No = 0.
      w-report.Llave-C = s-Llave-Control.
      w-report.Llave-I = ITEM.NroItm.
      w-report.Campo-C[4] = ITEM.codmat.
  END.
  ELSE DO:
      FIND CURRENT w-report EXCLUSIVE-LOCK.
  END.
  ASSIGN
      w-report.Campo-C[3] = s-codcli
      w-report.Campo-C[5] = ITEM.undvta
      w-report.Campo-F[1] = ITEM.canped
      w-report.Campo-F[2] = ITEM.factor
      w-report.Campo-L[1] = ITEM.aftigv
      w-report.Campo-L[2] = ITEM.aftisc
      .
  IF AVAILABLE(w-report) THEN RELEASE w-report.

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

  FIND FIRST w-report WHERE w-report.Task-No = 0
      AND w-report.Llave-C = s-Llave-Control
      AND w-report.Campo-C[4] = ITEM.codmat
      NO-LOCK NO-ERROR.
  IF AVAILABLE w-report THEN DO:
      FIND CURRENT w-report EXCLUSIVE-LOCK.
      DELETE w-report.
  END.
  IF AVAILABLE(w-report) THEN RELEASE w-report.


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
      IF LOOKUP(s-TpoPed, "I,P,N,LU") > 0 THEN ASSIGN BUTTON-2:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND Almmmatg OF ITEM NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DISPLAY Almmmatg.CanEmp @ FILL-IN-Master WITH FRAME {&FRAME-NAME}.

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
  IF NOT AVAILABLE ITEM THEN RETURN.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  CASE TRUE:
      WHEN s-Import-IBC = YES /*OR s-Import-Cissac = YES*/ THEN DO:
          ASSIGN
              ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
              ITEM.PreUni:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
      END.
      WHEN RETURN-VALUE = "NO" THEN DO:
          ASSIGN
              ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
          APPLY 'ENTRY':U TO ITEM.canped.
      END.
      OTHERWISE DO:
          ASSIGN
              ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
          /*APPLY 'ENTRY':U TO ITEM.codmat.*/
      END.
  END.

  ASSIGN BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO .

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF LOOKUP(s-TpoPed, "I,P,N,LU") > 0 THEN ASSIGN BUTTON-2:VISIBLE = YES BUTTON-2:SENSITIVE = YES.
  END.

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

  /*s-Update-Control = NO.*/
  s-Update-Control = YES.
  
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
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  IF s-status-record = 'add-record' THEN RUN Procesa-Handle IN lh_handle ('Add-Record').
  s-Update-Control = YES.

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

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      /* Ya fue procesado por Abastecimientos */
      IF s-nivel-acceso = 0 AND ITEM.CanPed < DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
          THEN DO:
          MESSAGE 'Cotización ya ha sido programada por ABASTECIMIENTOS' SKIP
              'Solo puede disminuir cantidades, NO inmcrementarlas' VIEW-AS ALERT-BOX WARNING.
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* *********************************************************************************** */
  /* PRODUCTO */  
  /* *********************************************************************************** */

  DEFINE VAR x-codmat2 AS CHAR.

  x-codmat2 = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

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
      MESSAGE 'Código ' + x-codmat2 + ' de producto NO registrado' VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF Almmmatg.TpoArt = "D" THEN DO:
      MESSAGE 'Código de producto ' + x-codmat2 + ' DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* *********************************************************************************** */
  /* FAMILIA DE VENTAS */
  /* *********************************************************************************** */
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
  /* *********************************************************************************** */
  /* PRODUCTO */  
  /* *********************************************************************************** */
  DEF VAR pCodMat AS CHAR.
  pCodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* RHC 21/08/2012 CONTROL POR TIPO DE PRODUCTO */
  IF Almmmatg.TpoMrg = "1" AND s-FlgTipoVenta = NO THEN DO:
      MESSAGE "No se puede vender este producto " + x-codmat2 + " al por menor"
          VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  IF Almmmatg.TpoMrg = "2" AND s-FlgTipoVenta = YES THEN DO:
      MESSAGE "No se puede vender este producto " + x-codmat2 + " al por mayor"
          VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  /* *********************************************************************************** */
  /* UNIDAD */
  /* *********************************************************************************** */
  DEFINE VAR pCanPed AS DEC NO-UNDO.
  DEFINE VAR pMensaje AS CHAR NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN vtagn/ventas-library PERSISTENT SET hProc.

  RUN SET_cliente IN hProc(INPUT s-CodCli).

  pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  RUN VTA_Valida-Cantidad IN hProc (INPUT Almmmatg.CodMat,
                                    INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                    INPUT-OUTPUT pCanPed,
                                    OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  
  /* *********************************************************************************** */
  /* EMPAQUE */
  /* *********************************************************************************** */
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.
  RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                    INPUT pCodDiv,
                                    INPUT Almmmatg.codmat,
                                    INPUT pCanPed,
                                    INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                    INPUT s-CodCli,
                                    OUTPUT pSugerido,
                                    OUTPUT pEmpaque,
                                    OUTPUT pMensaje).
  /* RHC NO dar mensaje en caso de expolibreria Cesar Camus */
  IF s-TpoPed = "E" THEN DO:    /* EXPOLIBRERIA */
      IF pMensaje > '' THEN DO:
          ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pSugerido).
      END.
  END.
  ELSE DO:      /* Todas las demás formas de venta */
      IF pMensaje > '' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pSugerido).
          APPLY 'ENTRY':U TO ITEM.CanPed.
          RETURN 'ADM-ERROR'.
      END.
  END.
  DELETE PROCEDURE hProc.
  /* *********************************************************************************** */
  /* CANTIDAD */
  /* *********************************************************************************** */
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CanPed.
       RETURN "ADM-ERROR".
  END.
  /* ************************************************************************************* */
  /* NO STOCK NI MARGEN DE UTILIDAD PARA EVENTOS */
  /* ************************************************************************************* */
  /* CONSISTENCIA DE STOCK */
  /* ************************************************************************************* */
  DEFINE VARIABLE s-StkComprometido AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkActual AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-STkDisponible AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-CanPedida AS DECIMAL NO-UNDO.

  /* VER SI LA DIVISION VERIFICA STOCK */
  /* Verificamos el stock del primer almacén válido */
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = ENTRY(1, s-CodAlm)
      AND  Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmate THEN x-StkActual = Almmmate.StkAct.
  ELSE x-StkActual = 0.
  RUN gn/Stock-Comprometido-v2 (ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                ENTRY(1, s-CodAlm),
                                YES,
                                OUTPUT s-StkComprometido).
  /* RHC 30/04/2020 En caso de que COT separe stock */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
          AND Facdpedi.coddoc = s-coddoc
          AND Facdpedi.nroped = s-nroped
          AND Facdpedi.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
          NO-LOCK NO-ERROR.
      /* RHC 29/04/2020 Tener cuidado, las COT también comprometen mercadería */
      FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
          FacTabla.Tabla = "GN-DIVI" AND
          FacTabla.Codigo = s-CodDiv AND
          FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
          FacTabla.Valor[1] > 0           /* Horas de reserva */
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla AND AVAILABLE Facdpedi THEN DO:
          /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
          /* Afectamos lo comprometido: extornamos el comprometido */
          s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
      END.
  END.
  x-StkDisponible = x-StkActual - s-StkComprometido.
  x-CanPedida = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-Factor.
  /* RHC 30/04/2020 La División VERIFICA STOCK */
  FIND FacTabla WHERE FacTabla.codcia = s-CodCia AND
      FacTabla.tabla = "GN-DIVI" AND
      FacTabla.codigo = s-CodDiv AND
      FacTabla.campo-L[1] = YES
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN AVAILABLE FacTabla THEN DO:
          /* Sí Verificamos stock */
          IF x-CanPedida > x-StkDisponible THEN DO:
              MESSAGE "No hay STOCK disponible en el almacén" ENTRY(1, s-CodAlm) SKIP(1)
                  "     STOCK ACTUAL : " x-StkActual SKIP
                  "     COMPROMETIDO : " s-StkComprometido  SKIP(1)
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO ITEM.CanPed.
              RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN s-TpoPed <> "E" THEN DO:
          IF x-CanPedida > x-StkDisponible THEN DO:
              MESSAGE "No hay STOCK disponible en el almacén" ENTRY(1, s-CodAlm) SKIP(1)
                  "     STOCK ACTUAL : " x-StkActual SKIP
                  "     COMPROMETIDO : " s-StkComprometido  SKIP(1)
                  " Continuamos con la grabación?"
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                  UPDATE rpta AS LOG.
              IF rpta = NO THEN DO:
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
  END CASE.
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

IF s-Import-B2B = YES THEN DO:
    MESSAGE 'Acceso denegado' SKIP 'Cotización TIENDAS B2B' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

IF AVAILABLE ITEM THEN 
    ASSIGN
    i-nroitm = ITEM.NroItm
    f-Factor = ITEM.Factor
    f-PreBas = ITEM.PreBas
    f-PreVta = ITEM.PreUni
    s-UndVta = ITEM.UndVta
    x-TipDto = ITEM.Libre_c04
    s-status-record = 'update-record'
    f-FleteUnitario = ITEM.Libre_d02.
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

