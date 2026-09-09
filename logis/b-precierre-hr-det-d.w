&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-RutaD FOR DI-RutaD.
DEFINE TEMP-TABLE t-VtaUbiDiv NO-UNDO LIKE VtaUbiDiv.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-Moneda AS CHAR NO-UNDO.

DEFINE BUFFER x-di-rutaD FOR di-rutaD.
DEFINE BUFFER x-faccpedi FOR faccpedi.

DEFINE TEMP-TABLE tt-ptos-entrega
    FIELD trowid AS ROWID
    FIELD trowclick AS LOGICAL.

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
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DI-RutaD CcbCDocu gn-clie t-VtaUbiDiv

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DI-RutaD.CodRef DI-RutaD.NroRef ~
CcbCDocu.NomCli fMoneda() @ x-Moneda CcbCDocu.ImpTot DI-RutaD.HorLle ~
DI-RutaD.HorPar fEstado() @ x-Estado fEstadoDet() @ x-Motivo ~
fTipo() @ DI-RutaD.Libre_c05 DI-RutaD.Libre_c03 CcbCDocu.Libre_c01 ~
CcbCDocu.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH DI-RutaD OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = DI-RutaD.CodCia ~
  AND CcbCDocu.CodDoc = DI-RutaD.CodRef ~
  AND CcbCDocu.NroDoc = DI-RutaD.NroRef NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK, ~
      FIRST t-VtaUbiDiv WHERE t-VtaUbiDiv.CodDept = gn-clie.CodDept ~
  AND t-VtaUbiDiv.CodProv = gn-clie.CodProv ~
  AND t-VtaUbiDiv.CodDist = gn-clie.CodDist ~
      AND t-VtaUbiDiv.CodCia = s-codcia ~
 AND t-VtaUbiDiv.CodDiv = s-coddiv NO-LOCK ~
    BY t-VtaUbiDiv.Libre_d01 ~
       BY CcbCDocu.NomCli ~
        BY CcbCDocu.NroPed ~
         BY CcbCDocu.Libre_c02
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DI-RutaD OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = DI-RutaD.CodCia ~
  AND CcbCDocu.CodDoc = DI-RutaD.CodRef ~
  AND CcbCDocu.NroDoc = DI-RutaD.NroRef NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK, ~
      FIRST t-VtaUbiDiv WHERE t-VtaUbiDiv.CodDept = gn-clie.CodDept ~
  AND t-VtaUbiDiv.CodProv = gn-clie.CodProv ~
  AND t-VtaUbiDiv.CodDist = gn-clie.CodDist ~
      AND t-VtaUbiDiv.CodCia = s-codcia ~
 AND t-VtaUbiDiv.CodDiv = s-coddiv NO-LOCK ~
    BY t-VtaUbiDiv.Libre_d01 ~
       BY CcbCDocu.NomCli ~
        BY CcbCDocu.NroPed ~
         BY CcbCDocu.Libre_c02.
&Scoped-define TABLES-IN-QUERY-br_table DI-RutaD CcbCDocu gn-clie ~
t-VtaUbiDiv
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DI-RutaD
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table t-VtaUbiDiv


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDet B-table-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTipo B-table-Win 
FUNCTION fTipo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Por_Entregar LABEL "Por Entregar"  
       MENU-ITEM m_Entregado    LABEL "Entregado"     
       MENU-ITEM m_Devolucion_Parcial LABEL "Devolucion Parcial"
       MENU-ITEM m_No_Entregado LABEL "No Entregado"  
       MENU-ITEM m_Dejado_en_Tienda LABEL "Dejado en Tienda".


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DI-RutaD, 
      CcbCDocu, 
      gn-clie
    FIELDS(), 
      t-VtaUbiDiv
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DI-RutaD.CodRef FORMAT "x(3)":U
      DI-RutaD.NroRef FORMAT "X(15)":U WIDTH 15
      CcbCDocu.NomCli FORMAT "x(35)":U
      fMoneda() @ x-Moneda COLUMN-LABEL "Mon." FORMAT "x(3)":U
      CcbCDocu.ImpTot COLUMN-LABEL "Importe!Total" FORMAT "->>>,>>9.99":U
            WIDTH 8.72
      DI-RutaD.HorLle COLUMN-LABEL "Hora!Llegada" FORMAT "XX:XX":U
      DI-RutaD.HorPar COLUMN-LABEL "Hora!Partida" FORMAT "XX:XX":U
      fEstado() @ x-Estado COLUMN-LABEL "Situacion" FORMAT "x(50)":U
            WIDTH 39.29
      fEstadoDet() @ x-Motivo COLUMN-LABEL "Motivo" FORMAT "x(40)":U
            WIDTH 38.43
      fTipo() @ DI-RutaD.Libre_c05 COLUMN-LABEL "Tipo" FORMAT "x(15)":U
            WIDTH 38.86
      DI-RutaD.Libre_c03 COLUMN-LABEL "Glosa" FORMAT "x(60)":U
            WIDTH 30
      CcbCDocu.Libre_c01 COLUMN-LABEL "Ref." FORMAT "x(3)":U
      CcbCDocu.Libre_c02 COLUMN-LABEL "Número" FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 156.86 BY 14.54
         FONT 2 TOOLTIP "Haz clic en el botón derecho".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1.14
     "Seleccione el campo y luego haga clic derecho para cambiar su estado" VIEW-AS TEXT
          SIZE 49 BY .5 AT ROW 15.81 COL 2
          BGCOLOR 11 FGCOLOR 0 
     "Seleccione el campo y luego haga doble clic para cambiar la hora" VIEW-AS TEXT
          SIZE 49 BY .5 AT ROW 16.38 COL 2
          BGCOLOR 11 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.DI-RutaC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: B-RutaD B "?" ? INTEGRAL DI-RutaD
      TABLE: t-VtaUbiDiv T "?" NO-UNDO INTEGRAL VtaUbiDiv
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
         HEIGHT             = 15.88
         WIDTH              = 159.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
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
/* BROWSE-TAB br_table TEXT-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.DI-RutaD OF INTEGRAL.DI-RutaC,INTEGRAL.CcbCDocu WHERE INTEGRAL.DI-RutaD ...,INTEGRAL.gn-clie WHERE INTEGRAL.CcbCDocu ...,Temp-Tables.t-VtaUbiDiv WHERE INTEGRAL.gn-clie ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST USED, FIRST USED"
     _OrdList          = "Temp-Tables.t-VtaUbiDiv.Libre_d01|yes,INTEGRAL.CcbCDocu.NomCli|yes,INTEGRAL.CcbCDocu.NroPed|yes,INTEGRAL.CcbCDocu.Libre_c02|yes"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = INTEGRAL.DI-RutaD.CodCia
  AND INTEGRAL.CcbCDocu.CodDoc = INTEGRAL.DI-RutaD.CodRef
  AND INTEGRAL.CcbCDocu.NroDoc = INTEGRAL.DI-RutaD.NroRef"
     _JoinCode[3]      = "INTEGRAL.gn-clie.CodCli = CcbCDocu.CodCli"
     _Where[3]         = "gn-clie.CodCia = cl-codcia"
     _JoinCode[4]      = "Temp-Tables.t-VtaUbiDiv.CodDept = gn-clie.CodDept
  AND Temp-Tables.t-VtaUbiDiv.CodProv = gn-clie.CodProv
  AND Temp-Tables.t-VtaUbiDiv.CodDist = gn-clie.CodDist"
     _Where[4]         = "Temp-Tables.t-VtaUbiDiv.CodCia = s-codcia
 AND Temp-Tables.t-VtaUbiDiv.CodDiv = s-coddiv"
     _FldNameList[1]   = INTEGRAL.DI-RutaD.CodRef
     _FldNameList[2]   > INTEGRAL.DI-RutaD.NroRef
"INTEGRAL.DI-RutaD.NroRef" ? "X(15)" "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.NomCli
"INTEGRAL.CcbCDocu.NomCli" ? "x(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fMoneda() @ x-Moneda" "Mon." "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.ImpTot
"INTEGRAL.CcbCDocu.ImpTot" "Importe!Total" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.DI-RutaD.HorLle
"INTEGRAL.DI-RutaD.HorLle" "Hora!Llegada" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.DI-RutaD.HorPar
"INTEGRAL.DI-RutaD.HorPar" "Hora!Partida" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fEstado() @ x-Estado" "Situacion" "x(50)" ? ? ? ? ? ? ? no ? no no "39.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fEstadoDet() @ x-Motivo" "Motivo" "x(40)" ? ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fTipo() @ DI-RutaD.Libre_c05" "Tipo" "x(15)" ? ? ? ? ? ? ? no ? no no "38.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.DI-RutaD.Libre_c03
"INTEGRAL.DI-RutaD.Libre_c03" "Glosa" ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbCDocu.Libre_c01
"INTEGRAL.CcbCDocu.Libre_c01" "Ref." "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.CcbCDocu.Libre_c02
"INTEGRAL.CcbCDocu.Libre_c02" "Número" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
  DEF VAR x-HorLle LIKE DI-RutaD.HorLle.
  DEF VAR x-HorPar LIKE DI-RutaD.HorPar.
  DEF VAR x-Ok     AS LOG INIT NO.
  
  x-HorLle = DI-RutaD.HorLle.
  x-HorPar = DI-RutaD.HorPar.

  /* Cuantos puntos de entrega? */
    DEFINE VAR x-codorden AS CHAR.
    DEFINE VAR x-nroorden AS CHAR.
    DEFINE VAR x-codclie AS CHAR.

    DEFINE VAR x-sede AS CHAR INIT "".
    DEFINE VAR x-ptos AS INT.
    DEFINE VAR x-varios-ptos AS INT.
    DEF VAR x-Rowid AS ROWID NO-UNDO.

    x-codorden = Ccbcdocu.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-nroorden = Ccbcdocu.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-Rowid = ROWID(Di-RutaD).

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = x-codorden AND
                                x-faccpedi.nroped = x-nroorden NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        x-codclie = x-faccpedi.codcli.
        x-sede = x-faccpedi.sede.
    END.        

    EMPTY TEMP-TABLE tt-ptos-entrega.

    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE DI-RUTAD:

        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = Ccbcdocu.Libre_c01 AND
                                    x-faccpedi.nroped = Ccbcdocu.Libre_c02 AND 
                                    x-faccpedi.codcli = x-codclie NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:

            IF x-sede = x-faccpedi.sede THEN DO:
                x-ptos = x-ptos + 1.

                CREATE tt-ptos-entrega.
                    ASSIGN tt-ptos-entrega.trowid = ROWID(DI-RUTAD).
            END.
        END.

        GET NEXT {&BROWSE-NAME}.
    END.

    REPOSITION {&BROWSE-NAME} TO ROWID x-Rowid.

    /*
    EMPTY TEMP-TABLE tt-puntos-entrega.
    
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
            AND FacCPedi.CodDoc = Di-RutaD.codref           
            AND FacCPedi.NroPed = Di-RutaD.nroref
        BREAK BY Faccpedi.CodCli:
        IF FIRST-OF(Faccpedi.CodCli) THEN tt-di-rutaC.libre_d03 = tt-di-rutaC.libre_d03 + 1.
        ASSIGN
            tt-Di-Rutac.Libre_d02 = tt-Di-Rutac.Libre_d02 + Faccpedi.AcuBon[8]
            tt-Di-Rutac.Libre_d01 = tt-Di-Rutac.Libre_d01 + Faccpedi.Peso
            tt-Di-Rutac.Libre_d06 = tt-Di-Rutac.Libre_d06 + Faccpedi.Volumen.
        IF Faccpedi.coddoc = 'OTR' THEN DO:
             tt-Di-Rutac.Libre_d02 = tt-Di-Rutac.Libre_d02 - Faccpedi.AcuBon[8].
             FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
                  tt-Di-Rutac.Libre_d02 =  tt-Di-Rutac.Libre_d02 + 
                      (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * 
                                      (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
             END.
        END.
        /* Ic - 04Set2020 Puntos de entrega a pedido de Fernan segun meet avalado po Daniel Llican y Maz Ramos */
        FIND FIRST tt-puntos-entrega WHERE tt-puntos-entrega.tsede = faccpedi.sede EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-puntos-entrega THEN DO:
            CREATE tt-puntos-entrega.
                ASSIGN tt-puntos-entrega.tsede = faccpedi.sede.
                ASSIGN tt-di-rutaC.libre_d07 = tt-di-rutaC.libre_d07 + 1.
        END.
    END.
    */

  x-varios-ptos = x-ptos.       /* Regresa con 0 o 1 */
  RUN alm/h-rut002b (INPUT-OUTPUT x-HorLle, INPUT-OUTPUT x-HorPar, INPUT-OUTPUT x-varios-ptos, OUTPUT x-Ok).
  
  IF x-Ok = NO THEN RETURN.

  /* Marcar todas las relacionadas */  
  DEF VAR x-Rowid2 AS ROWID NO-UNDO.

  FIND CURRENT Di-RutaD NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Di-RutaD THEN DO:
      RETURN.
  END.
  ASSIGN
      x-Rowid = ROWID(Di-RutaD).
  FOR EACH tt-ptos-entrega NO-LOCK :
      x-Rowid2 = ?.
      IF x-ptos > 1 AND x-varios-ptos = 1 THEN DO:
          x-Rowid2 = tt-ptos-entrega.trowid.
      END.
      ELSE DO:
          IF x-Rowid = tt-ptos-entrega.trowid THEN x-rowid2 = tt-ptos-entrega.trowid.
      END.
      IF x-rowid2 <> ? THEN DO:
        FIND FIRST B-RutaD WHERE ROWID(B-RutaD) = x-rowid2 EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-RutaD THEN DO:
            ASSIGN
                B-RutaD.HorLle = x-HorLle
                B-RutaD.HorPar = x-HorPar.
        END.
      END.
  END.

  /*
  FOR EACH B-RutaD OF Di-RutaC,
      FIRST B-CDocu NO-LOCK WHERE B-CDocu.CodCia = B-RutaD.CodCia
      AND B-CDocu.CodDoc = B-RutaD.CodRef           /* G/R */
      AND B-CDocu.NroDoc = B-RutaD.NroRef
      AND B-CDocu.CodCli = Ccbcdocu.CodCli
      AND B-CDocu.Libre_c01 = Ccbcdocu.Libre_c01    /* O/D */
      AND B-CDocu.Libre_c02 = Ccbcdocu.Libre_c02:
      ASSIGN
          B-RutaD.HorLle = x-HorLle
          B-RutaD.HorPar = x-HorPar.
  END.
  */

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&BROWSE-NAME} TO ROWID x-Rowid.
  RUN dispatch IN THIS-PROCEDURE ('row-changed':U). 
/*   ASSIGN                                            */
/*     Di-RutaD.HorLle = x-HorLle                      */
/*     Di-RutaD.HorPar = x-HorPar.                     */
/*   FIND CURRENT Di-RutaD NO-LOCK NO-ERROR.           */
/*   RUN dispatch IN THIS-PROCEDURE ('row-changed':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME m_Dejado_en_Tienda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Dejado_en_Tienda B-table-Win
ON CHOOSE OF MENU-ITEM m_Dejado_en_Tienda /* Dejado en Tienda */
DO:
    DEF VAR pCodDiv AS CHAR NO-UNDO.
    DEF VAR pRowid  AS ROWID NO-UNDO.
    DEF VAR pFlgEstDet AS CHAR NO-UNDO.     /* Código del Motivo */
    DEF VAR pEstado AS CHAR NO-UNDO.        /* Siempre va a ser "R" */

    IF AVAILABLE Di-RutaD AND 
        Di-RutaD.flgest = "T" AND 
        Di-RutaD.FlgEstDet = "@DT"      /* Código de Motivo: Bloqueamos cualquier modificación */
        THEN RETURN NO-APPLY.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    /* Preguntamos en cual almacén se dejó */
    RUN gn/d-almac-y-tiendas.w (OUTPUT pCodDiv).
    IF TRUE <> (pCodDiv > '') THEN RETURN NO-APPLY.
    /* Preguntamos el motivo */
    RUN alm/d-rut002a-01 (OUTPUT pFlgEstDet, OUTPUT pEstado, INPUT ccbcdocu.divori).

    IF pFlgEstDet = 'ADM-ERROR' THEN RETURN NO-APPLY.

    RUN dist/dist-librerias PERSISTENT SET hProc.
    pRowid = ROWID(Di-RutaD).
    DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY ON STOP UNDO, RETURN NO-APPLY:
        FIND CURRENT Di-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE Di-RutaD THEN UNDO, RETURN NO-APPLY.
        ASSIGN
            Di-RutaD.flgest = "T"     /* Dejado en Tienda */
            Di-RutaD.FlgEstDet = pFlgEstDet
            Di-RutaD.Libre_c02 = pCodDiv.
        /* Replicamos las G/R relacionadas por la O/D */
        RUN HR_Cierre-Dejado-en-Tienda IN hProc ("T", pCodDiv, pFlgEstDet, pRowid).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE 'NO se pudo grabar todos los registros relacionados con la O/D'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, LEAVE.
        END.
    END.
    FIND CURRENT Di-RutaD NO-LOCK NO-ERROR.
    DELETE PROCEDURE hProc.
    /* borramos detalle */
    RUN Borra-Devolucion (INPUT Di-RutaD.CodRef, INPUT Di-RutaD.NroRef).

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    REPOSITION {&BROWSE-NAME} TO ROWID pRowid NO-ERROR.
END.

/*
  ASSIGN
    Di-RutaD.flgest = "N"
    Di-RutaD.FlgEstDet = pFlgEstDet
    Di-RutaD.Libre_c02 = pEstado.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Devolucion_Parcial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Devolucion_Parcial B-table-Win
ON CHOOSE OF MENU-ITEM m_Devolucion_Parcial /* Devolucion Parcial */
DO:
  IF AVAILABLE Di-RutaD AND 
      Di-RutaD.flgest = "T" AND 
      Di-RutaD.FlgEstDet = "@DT"      /* Código de Motivo: Bloqueamos cualquier modificación */
      THEN RETURN NO-APPLY.

  /* Consistencia */
  DEF VAR pFlgEstDet AS CHAR NO-UNDO.
  DEF VAR pGlosa AS CHAR NO-UNDO.

  RUN logis/d-motivo-demora (OUTPUT pFlgEstDet, OUTPUT pGlosa).
  IF pFlgEstDet = 'ADM-ERROR' THEN RETURN NO-APPLY.

  RUN logis/d-precierre-hr-dev-parcial (ROWID(di-rutad)).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.

  DEF BUFFER B-RUTAD FOR Di-rutad.
  FIND B-RUTAD WHERE ROWID(B-RUTAD) = ROWID(Di-RutaD) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE B-RUTAD THEN DO:
      ASSIGN
          B-RUTAD.FlgEstDet = pFlgEstDet
          B-RUTAD.Libre_c03 = pGlosa.
  END.

  RUN dispatch IN THIS-PROCEDURE ('row-changed':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Entregado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Entregado B-table-Win
ON CHOOSE OF MENU-ITEM m_Entregado /* Entregado */
DO:
  IF AVAILABLE Di-RutaD AND 
      Di-RutaD.flgest = "T" AND 
      Di-RutaD.FlgEstDet = "@DT"      /* Código de Motivo: Bloqueamos cualquier modificación */
      THEN RETURN NO-APPLY.

  /* Consistencia */
  DEF VAR pFlgEstDet AS CHAR NO-UNDO.
  DEF VAR pGlosa AS CHAR NO-UNDO.

  RUN logis/d-motivo-demora (OUTPUT pFlgEstDet, OUTPUT pGlosa).
  IF pFlgEstDet = 'ADM-ERROR' THEN RETURN NO-APPLY.

  FIND CURRENT Di-RutaD EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Di-RutaD THEN RETURN.

  ASSIGN
      Di-RutaD.flgest = 'C'
      Di-RutaD.FlgEstDet = ''
      Di-RutaD.Libre_c02 = ''.
  ASSIGN
      Di-RutaD.FlgEstDet = pFlgEstDet
      Di-RutaD.Libre_c03 = pGlosa.

  RUN Actualiza-Similares (INPUT Di-RutaD.CodRef,
                           INPUT Di-RutaD.NroRef,
                           INPUT pFlgEstDet,
                           INPUT pGlosa).
  
  FIND CURRENT Di-RutaD NO-LOCK NO-ERROR.
  DEF VAR x-Rowid AS ROWID NO-UNDO.
  x-Rowid = ROWID(Di-RutaD).
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&BROWSE-NAME} TO ROWID x-Rowid NO-ERROR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_No_Entregado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_No_Entregado B-table-Win
ON CHOOSE OF MENU-ITEM m_No_Entregado /* No Entregado */
DO:
  IF NOT AVAILABLE Di-RutaD THEN RETURN.

  IF AVAILABLE Di-RutaD AND 
      Di-RutaD.flgest = "T" AND 
      Di-RutaD.FlgEstDet = "@DT"      /* Código de Motivo: Bloqueamos cualquier modificación */
      THEN RETURN NO-APPLY.
  
  /* Consistencia */
  DEF VAR pFlgEstDet AS CHAR NO-UNDO.
  DEF VAR pEstado AS CHAR NO-UNDO.
  DEF VAR pGlosa AS CHAR NO-UNDO.

  RUN logis/d-motivo-no-entregado (OUTPUT pFlgEstDet, 
                                   OUTPUT pEstado, 
                                   OUTPUT pGlosa,
                                   INPUT ccbcdocu.divori).

  IF pFlgEstDet = 'ADM-ERROR' THEN RETURN NO-APPLY.

  IF pEstado = "A" THEN DO:     /* NO ENTREGADO y NO REPROGRAMADO */
      /* Cargamos la información del parte ingreso al almacén */
      DEF BUFFER FACTURA FOR Ccbcdocu.
      FIND FIRST FACTURA WHERE FACTURA.codcia = Ccbcdocu.codcia AND
          /*FACTURA.coddiv = Ccbcdocu.coddiv AND*/
          FACTURA.coddoc = Ccbcdocu.codref AND  /* BOL o FAC */
          FACTURA.nrodoc = Ccbcdocu.nroref NO-LOCK NO-ERROR.
      IF AVAILABLE FACTURA THEN DO:
          DEF VAR x-Total-1 AS DEC NO-UNDO.
          DEF VAR x-Total-2 AS DEC NO-UNDO.

          FOR EACH Ccbddocu OF FACTURA NO-LOCK:
              x-Total-1 = x-Total-1 + (Ccbddocu.candes * Ccbddocu.factor).
          END.
          FOR FIRST Almcmov NO-LOCK WHERE Almcmov.codcia = FACTURA.codcia AND
              /*CAN-FIND(FIRST Almacen OF Almcmov WHERE Almacen.coddiv = DI-RutaD.CodDiv NO-LOCK) AND*/
              Almcmov.tipmov = "I" AND 
              Almcmov.codmov = 09 AND
              Almcmov.codref = FACTURA.coddoc AND
              Almcmov.nroref = FACTURA.nrodoc AND
              Almcmov.flgest <> 'A',
              EACH Almdmov OF Almcmov NO-LOCK:
              x-Total-2 = x-Total-2 + (Almdmov.candes * Almdmov.factor).
          END.
          IF x-Total-1 <> x-Total-2 THEN DO:
              MESSAGE 'NO se ha devuelto TOTALMENTE la' FACTURA.coddoc FACTURA.nrodoc VIEW-AS ALERT-BOX WARNING.
              RETURN NO-APPLY.
          END.
      END.
  END.

  FIND CURRENT Di-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE Di-RutaD THEN RETURN NO-APPLY.
  ASSIGN
      Di-RutaD.flgest = "N"
      Di-RutaD.FlgEstDet = pFlgEstDet
      Di-RutaD.Libre_c02 = pEstado
      Di-RutaD.Libre_c03 = pGlosa.
  FIND CURRENT Di-RutaD NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
  /* borramos detalle */
  RUN Borra-Devolucion (INPUT Di-RutaD.CodRef, INPUT Di-RutaD.NroRef).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Por_Entregar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Por_Entregar B-table-Win
ON CHOOSE OF MENU-ITEM m_Por_Entregar /* Por Entregar */
DO:
    IF AVAILABLE Di-RutaD AND 
        Di-RutaD.flgest = "T" AND 
        Di-RutaD.FlgEstDet = "@DT"      /* Código de Motivo: Bloqueamos cualquier modificación */
        THEN RETURN NO-APPLY.
  
    FIND CURRENT Di-RutaD EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Di-RutaD THEN RETURN.
  ASSIGN
    Di-RutaD.flgest = 'P'
    Di-RutaD.FlgEstDet = ''
    Di-RutaD.Libre_c02 = ''.
  FIND CURRENT Di-RutaD NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
  /* borramos detalle */
  RUN Borra-Devolucion (INPUT Di-RutaD.CodRef, INPUT Di-RutaD.NroRef).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME POPUP-MENU-br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL POPUP-MENU-br_table B-table-Win
ON MENU-DROP OF MENU POPUP-MENU-br_table
DO:
  IF di-rutac.flgest = 'A'
  THEN DO:
    MESSAGE 'La hoja de ruta está ANULADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF di-rutac.flgest = 'C'
  THEN DO:
    MESSAGE 'La hoja de ruta está CERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Similares B-table-Win 
PROCEDURE Actualiza-Similares :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Actualizar todos los registros con la misma O/D
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodRef AS CHAR.
DEF INPUT PARAMETER pNroRef AS CHAR.
DEF INPUT PARAMETER pFlgEstDet AS CHAR.
DEF INPUT PARAMETER pGlosa AS CHAR.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-RUTAD FOR Di-RutaD.
/* Buscamos la O/D */
FIND B-CDOCU WHERE B-CDOCU.CodCia = s-CodCia
    AND B-CDOCU.CodDoc = pCodRef
    AND B-CDOCU.NroDoc = pNroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN RETURN 'OK'.
DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.
ASSIGN
    x-CodDoc = B-CDOCU.Libre_c01        /* O/D */
    x-NroDoc = B-CDOCU.Libre_c02.
/* Buscamos todas las G/R de la misma O/D */
FOR EACH B-RUTAD OF Di-RutaC EXCLUSIVE-LOCK,
    FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
    AND B-CDOCU.coddoc = B-RUTAD.CodRef
    AND B-CDOCU.nrodoc = B-RUTAD.NroRef
    AND B-CDOCU.libre_c01 = x-CodDoc
    AND B-CDOCU.libre_c02 = x-NroDoc NO-LOCK:
    ASSIGN
        B-RUTAD.flgest = 'C'
        B-RUTAD.Libre_c02 = ''
        B-RUTAD.FlgEstDet = pFlgEstDet
        B-RUTAD.Libre_c03 = pGlosa.
    RUN Borra-Devolucion (INPUT B-RUTAD.CodRef, INPUT B-RUTAD.NroRef).
END.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Devolucion B-table-Win 
PROCEDURE Borra-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodRef AS CHAR.
  DEF INPUT PARAMETER pNroRef AS CHAR.

  FOR EACH di-rutadv WHERE Di-RutaDv.CodCia = di-rutac.codcia
      AND Di-RutaDv.CodDoc = di-rutac.coddoc
      AND Di-RutaDv.NroDoc = di-rutac.nrodoc
      AND Di-RutaDv.CodDiv = di-rutac.coddiv
      AND Di-RutaDv.CodRef = pCodRef
      AND Di-RutaDv.NroRef = pNroRef
      EXCLUSIVE-LOCK:
      DELETE di-rutadv.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ubicaciones B-table-Win 
PROCEDURE Carga-Ubicaciones PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Similar a la rutina de impresión de H/R */
  EMPTY TEMP-TABLE t-VtaUbiDiv.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
      AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
      AND CcbCDocu.NroDoc = DI-RutaD.NroRef:
      /* ************************************************************************************** */
      /* CABECERA: DI-RUTAC */
      /* ************************************************************************************** */
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = ccbcdocu.codcli
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DO:
          FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
              AND VtaUbiDiv.CodDiv = s-coddiv
              AND VtaUbiDiv.CodDept = gn-clie.CodDept 
              AND VtaUbiDiv.CodProv = gn-clie.CodProv 
              AND VtaUbiDiv.CodDist = gn-clie.CodDist
              NO-LOCK NO-ERROR.
          FIND t-Vtaubidiv WHERE t-VtaUbiDiv.CodCia = s-codcia
              AND t-VtaUbiDiv.CodDiv = s-coddiv
              AND t-VtaUbiDiv.CodDept = gn-clie.CodDept 
              AND t-VtaUbiDiv.CodProv = gn-clie.CodProv 
              AND t-VtaUbiDiv.CodDist = gn-clie.CodDist
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE t-VtaUbiDiv THEN DO:
              CREATE t-VtaUbiDiv.
              IF AVAILABLE VtaUbiDiv THEN BUFFER-COPY VtaUbiDiv TO t-VtaUbiDiv.
              ELSE DO:
                  ASSIGN
                      t-VtaUbiDiv.CodCia = s-codcia
                      t-VtaUbiDiv.CodDiv = s-coddiv
                      t-VtaUbiDiv.CodDept = gn-clie.CodDept 
                      t-VtaUbiDiv.CodProv = gn-clie.CodProv 
                      t-VtaUbiDiv.CodDist = gn-clie.CodDist
                      t-VtaUbiDiv.Libre_d01 = 9999.
              END.
          END.
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Ubicaciones.


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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "DI-RutaD"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "t-VtaUbiDiv"}

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).

  IF Di-RutaD.flgest = 'T' THEN DO:
    FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND
                                gn-divi.coddiv = Di-RutaD.libre_c02 NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN x-Estado = x-Estado + "(" + TRIM(gn-divi.desdiv) + ")".
  END.

  RETURN x-Estado.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDet B-table-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

CASE DI-RutaD.FlgEst:
    WHEN "N" OR WHEN "T"  THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
            AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
            AND almtabla.NomAnt = 'N'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
    END.
    WHEN "C" OR WHEN "D" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HRD'
            AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
            AND almtabla.NomAnt = 'D'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
    END.
END CASE.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF CcbCDocu.codmon = 1 
  THEN RETURN 'S/.'.
  ELSE RETURN 'US$'.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTipo B-table-Win 
FUNCTION fTipo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE DI-RutaD.Libre_c02:
      WHEN "R" THEN RETURN 'REPROGRAMADO'.
      WHEN "A" THEN RETURN 'NO REPROGRAMADO'.
      OTHERWISE RETURN DI-RutaD.Libre_c02.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

