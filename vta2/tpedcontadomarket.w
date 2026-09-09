&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE s-TpoPed   AS CHAR.
DEFINE SHARED VARIABLE s-nrodec AS INT.
DEFINE SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE s-NroPed AS CHAR.
DEFINE SHARED VARIABLE s-NroRef AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE pCodAlm  AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMat AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHAR NO-UNDO.
DEFINE VARIABLE x-adm-new-record AS CHAR.
DEFINE VARIABLE X-CODMAT AS CHAR NO-UNDO.

DEFINE BUFFER B-ITEM FOR ITEM.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

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
&Scoped-define FIELDS-IN-QUERY-br_table ITEM.NroItm ITEM.codmat ~
fDesMat() @ x-DesMat fDesMar() @ x-DesMar ITEM.UndVta ITEM.AlmDes ~
ITEM.CanPed ITEM.PreUni ITEM.Por_Dsctos[1] ITEM.Por_Dsctos[2] ~
ITEM.Por_Dsctos[3] ITEM.ImpLin 
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "IMPORTE TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
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
      ITEM.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      ITEM.codmat COLUMN-LABEL "Articulo" FORMAT "X(14)":U WIDTH 6
      fDesMat() @ x-DesMat COLUMN-LABEL "Descripción" FORMAT "x(60)":U
      fDesMar() @ x-DesMar COLUMN-LABEL "Marca" FORMAT "x(20)":U
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 5.29
      ITEM.AlmDes COLUMN-LABEL "Alm!Desp" FORMAT "x(3)":U WIDTH 4.43
      ITEM.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>>,>>9.99":U
            WIDTH 7.29
      ITEM.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
            WIDTH 7.43
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Manual" FORMAT "->>9.9999":U
            WIDTH 7.14
      ITEM.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.9999":U
            WIDTH 6.72
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.9999":U
            WIDTH 7.43
      ITEM.ImpLin FORMAT ">,>>>,>>9.99":U WIDTH 10.72
  ENABLE
      ITEM.codmat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 141 BY 11.04
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-ImpTot AT ROW 12.04 COL 127 COLON-ALIGNED WIDGET-ID 2
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
         HEIGHT             = 12.69
         WIDTH              = 141.72.
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
     _FldNameList[1]   > Temp-Tables.ITEM.NroItm
"ITEM.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "Articulo" "X(14)" "character" ? ? ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fDesMat() @ x-DesMat" "Descripción" "x(60)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fDesMar() @ x-DesMar" "Marca" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.AlmDes
"ITEM.AlmDes" "Alm!Desp" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" "Cantidad!Aprobada" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto.!Manual" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.Por_Dsctos[2]
"ITEM.Por_Dsctos[2]" "% Dscto!Evento" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Vol/Prom" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    IF NOT AVAILABLE ITEM THEN RETURN.
      IF ITEM.Libre_c01 = '*' /*AND ITEM.CanPed <> ITEM.Libre_d01*/ THEN DO:
        ASSIGN
            x-DesMar:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11 
            x-DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.AlmDes:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.CanPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.ImpLin:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.Por_Dsctos[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.Por_Dsctos[2]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.Por_Dsctos[3]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.NroItm:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.PreUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.UndVta:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11.
        ASSIGN
            x-DesMar:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            x-DesMat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.AlmDes:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.CanPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.codmat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.ImpLin:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.Por_Dsctos[1]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.Por_Dsctos[2]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.Por_Dsctos[3]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.NroItm:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.PreUni:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.UndVta:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9.
    END.

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
ON ENTRY OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
  /* SOLO PASA POR AQUI CUANDO SE CREA UN NUEVO REGISTRO
  APROVECHAMOS PARA INICIALIZAR ALGUNOS VALORES */
/*     DISPLAY                                                                                          */
/*         ENTRY(1, s-CodAlm) WHEN ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = "" @ ITEM.AlmDes */
/*         1 WHEN DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) = 0 @ ITEM.CanPed              */
/*         WITH BROWSE {&browse-name}.                                                                  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON F11 OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
    RUN vtamin/D-VTAAUT5(OUTPUT x-codmat, OUTPUT x-canped).
    IF X-CODMAT <> ? AND X-CANPED > 0 THEN DO:
        DISPLAY x-codmat @ ITEM.Codmat WITH BROWSE {&BROWSE-NAME}.
        APPLY "RETURN" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON F12 OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
  RUN vta2/dcapturappvmarket.
  /*s-registro-activo = NO.*/
  RUN dispatch IN THIS-PROCEDURE ('disable-fields').
  RUN dispatch IN THIS-PROCEDURE ('cancel-record').
  RUN dispatch IN THIS-PROCEDURE ('open-query').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF x-Adm-New-Record = "NO" AND SELF:SCREEN-VALUE = ITEM.CodMat THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    DEF VAR pCanPed LIKE ITEM.canped.

    ASSIGN 
        F-CanPed = 1
        pCodMat = SELF:SCREEN-VALUE.

    RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pCanPed, s-codcia).

    IF pCodMat = '' THEN RETURN NO-APPLY.
    ASSIGN
        SELF:SCREEN-VALUE = pCodMat
        f-CanPed = pCanPed.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    DISPLAY 
        Almmmatg.DesMat @ x-DesMat 
        Almmmatg.DesMar @ x-DesMar 
        Almmmatg.UndA   @ ITEM.UndVta
        ENTRY(1, s-CodAlm) @ ITEM.AlmDes
        WITH BROWSE {&BROWSE-NAME}.
    /* Valida Maestro Productos x Almacen */
    ASSIGN 
        F-FACTOR = 1.
    IF x-CanPed > 0 AND X-CanPed <> F-CanPed THEN F-CanPed = X-CanPed.
    RUN vta2/PrecioMayorista-Cont (s-CodCia,
                                   s-CodDiv,
                                   s-CodCli,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT f-Factor,
                                   ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                                   s-FlgSit,
                                   ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                   DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                   s-NroDec,
                                   ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},   /* Necesario para REMATES */
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT x-TipDto
                                   ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

    DISPLAY 
        f-CanPed @ ITEM.CanPed
        F-PREVTA @ ITEM.PreUni 
        z-Dsctos @ ITEM.Por_Dsctos[2]
        y-Dsctos @ ITEM.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
    IF ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = ''
        THEN ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = ENTRY(1, s-codalm).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM.CanPed, ITEM.codmat, ITEM.UndVta, ITEM.PreUni, ITEM.AlmDes
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
  IF s-CodCli = '' THEN DO:
      MESSAGE 'Debe ingresar el CLIENTE' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF s-CndVta = '' THEN DO:
      MESSAGE 'Debe ingresar la CONDICION DE VENTA' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  I-NroItm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-ITEM BY B-ITEM.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-ITEM.NroItm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      I-NroItm = I-NroItm + 1
      s-UndVta = ""
      x-Adm-New-Record = "YES".
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
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
    ITEM.AlmDes = ENTRY(1, s-codalm)
    ITEM.UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    ITEM.CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

  /* REASEGURAMOS EL FACTOR DE EQUIVALENCIA */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.codmat = ITEM.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Código' ITEM.codmat 'NO registrado en el Catálogo' SKIP
          'Grabación abortada'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat IN BROWSE {&browse-name}.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = ITEM.UndVta
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat
          'Unidad de venta:' ITEM.UndVta SKIP
          'Grabación abortada'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.UndVta IN BROWSE {&browse-name}.
      UNDO, RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.
  ASSIGN 
      ITEM.CodCia = S-CODCIA
      ITEM.Factor = F-FACTOR
      ITEM.NroItm = I-NroItm
      ITEM.PorDto = f-Dsctos
      ITEM.PreBas = F-PreBas 
      ITEM.AftIgv = Almmmatg.AftIgv
      ITEM.AftIsc = Almmmatg.AftIsc
      ITEM.Libre_c04 = x-TipDto.
  ASSIGN 
      ITEM.PreUni = DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[1] = DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[2] = DEC(ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[3] = DEC(ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  ASSIGN
      ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
  ASSIGN
      ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
      ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
  IF ITEM.AftIsc 
  THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE ITEM.ImpIsc = 0.
  IF ITEM.AftIgv 
  THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE ITEM.ImpIgv = 0.

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "NO" THEN APPLY 'ENTRY':U TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
/*   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                         */
/*   IF RETURN-VALUE = 'YES' THEN DO:                             */
/*       ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.     */
/*   END.                                                         */
/*   ELSE DO:                                                     */
/*       ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.    */
/*       APPLY 'ENTRY':U TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}. */
/*   END.                                                         */

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
  DEF VAR x-adm-new-record AS CHAR.
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  x-adm-new-record = RETURN-VALUE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  IF x-adm-new-record = "YES" THEN RUN Procesa-Handle IN lh_handle ('Add-Record').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       NO se recalcula si se ha migrado el EDI para el IBC (Supermercados)
------------------------------------------------------------------------------*/

FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF",     /* NO promociones */
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    
    RUN vta2/PrecioMayorista-Cont (s-CodCia,
                                   s-CodDiv,
                                   s-CodCli,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT f-Factor,
                                   ITEM.codmat,
                                   s-FlgSit,
                                   ITEM.undvta,
                                   ITEM.CanPed,
                                   s-NroDec,
                                   ITEM.almdes,   /* Necesario para REMATES */
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT x-TipDto
                                   ).
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0        /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN 
        ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN  
        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
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

  /* PRODUCTO */  
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
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND  Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no asignado al almacén " ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
           VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.AlmDes.
      RETURN "ADM-ERROR".
  END.
  /* FAMILIA DE VENTAS */
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami AND 
      Almtfami.SwComercial = NO THEN DO:
      MESSAGE 'Línea NO autorizada para ventas' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami AND 
      AlmSFami.SwDigesa = YES AND 
      Almmmatg.VtoDigesa <> ? AND 
      Almmmatg.VtoDigesa < TODAY THEN DO:
      MESSAGE 'Producto con autorización de DIGESA VENCIDA' VIEW-AS ALERT-BOX ERROR.
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
  /* UNIDAD */
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "NO tiene registrado la unidad de venta" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* CANTIDAD */
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&browse-name} = "UNI" 
      AND DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) -
            TRUNCATE(DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 0) <> 0
      THEN DO:
      MESSAGE "NO se permiten ventas fraccionadas" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.
  /* FACTOR DE EQUIVALENCIA */
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
          'Unidad de venta:' ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.UndVta.
      RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.

  /* PRECIO */
  IF DECIMAL(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.PreUni.
       RETURN "ADM-ERROR".
  END.

  /* RHC 09/11/2012 NO CONTINUAMOS SI ES UN ALMACEN DE REMATE */
  FIND Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK.
  IF Almacen.Campo-C[3] = "Si" THEN RETURN "OK".
  /* ******************************************************** */

  /* EMPAQUE */
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0.125 THEN DO:
       MESSAGE "Cantidad debe ser mayor o igual a 0.125" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CanPed.
       RETURN "ADM-ERROR".
  END.
  
  DEF VAR f-Canped AS DEC NO-UNDO.
  IF s-FlgEmpaque = YES THEN DO:
      f-CanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
          FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
              f-CanPed = (TRUNCATE((f-CanPed / Vtalistamay.CanEmp),0) * Vtalistamay.CanEmp).
              IF f-CanPed <> DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' Vtalistamay.CanEmp Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
      ELSE DO:      /* LISTA GENERAL */
          IF Almmmatg.DEC__03 > 0 THEN DO:
              f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
              IF f-CanPed <> DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
  END.
  /* MINIMO DE VENTA */
  IF s-FlgMinVenta = YES THEN DO:
      f-CanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
          FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
              IF f-CanPed < Vtalistamay.CanEmp THEN DO:
                  MESSAGE 'Solo puede vender como mínimo' Vtalistamay.CanEmp Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
      ELSE DO:      /* LISTA GENERAL */
          IF Almmmatg.DEC__03 > 0 THEN DO:
              IF f-CanPed < Almmmatg.DEC__03 THEN DO:
                  MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
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
RETURN "ADM-ERROR".

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

