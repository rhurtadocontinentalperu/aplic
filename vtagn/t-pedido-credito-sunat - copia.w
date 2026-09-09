&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-NroPed AS CHAR.
DEF SHARED VAR s-NroCot AS CHAR.
DEF SHARED VAR s-TpoPed AS CHAR.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VARIABLE s-Tipo-Abastecimiento AS CHAR.
DEF SHARED VARIABLE lh_Handle  AS HANDLE.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.

DEFINE BUFFER B-PEDI FOR PEDI.

&SCOPED-DEFINE Condicion ( PEDI.Libre_c05 <> 'OF' )

&SCOPED-DEFINE Condicion2 ( B-PEDI.Libre_c05 <> 'OF' )

DEFINE VAR x-Saldo-Cot AS DECI NO-UNDO.
DEFINE VAR x-Total-Cot AS DECI NO-UNDO.

DEF SHARED VAR s-adm-new-record AS CHAR.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.NroItm PEDI.codmat ~
(IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> 'OF' THEN PEDI.Libre_c05 + '-' ELSE '')  + Almmmatg.Desmat @ Almmmatg.DesMat ~
Almmmatg.DesMar PEDI.UndVta PEDI.CanPed PEDI.Libre_d01 PEDI.PreUni ~
PEDI.Por_Dsctos[1] PEDI.Por_Dsctos[2] PEDI.Por_Dsctos[3] PEDI.ImpLin ~
PEDI.AlmDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK ~
    BY PEDI.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK ~
    BY PEDI.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-28 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Peso FILL-IN-ImpTot ~
FILL-IN_Total_Cotizacion FILL-IN_Saldo_Cotizacion 

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
DEFINE BUTTON BUTTON-3 
     LABEL "Eliminar items - masivo" 
     SIZE 18.43 BY 1.12
     BGCOLOR 12 .

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "IMPORTE TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "PESO TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN_Saldo_Cotizacion AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "SALDO PED COMERCIAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 14  NO-UNDO.

DEFINE VARIABLE FILL-IN_Total_Cotizacion AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL PED COMERCIAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 14  NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 181 BY 2.42
     BGCOLOR 1 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      PEDI.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 7
      (IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> 'OF' THEN PEDI.Libre_c05 + '-' ELSE '')  + Almmmatg.Desmat @ Almmmatg.DesMat COLUMN-LABEL "Descripción" FORMAT "x(100)":U
            WIDTH 80.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 12.43
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 5.29
      PEDI.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      PEDI.Libre_d01 COLUMN-LABEL "Cantidad!Pedida" FORMAT ">>>,>>9.99":U
      PEDI.PreUni COLUMN-LABEL "P. Unitario!con IGV" FORMAT ">>,>>9.99999":U
            WIDTH 8
      PEDI.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Adminst" FORMAT "->,>>9.999999":U
            WIDTH 6.86
      PEDI.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->,>>9.999999":U
            WIDTH 6.43
      PEDI.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->,>>9.999999":U
            WIDTH 6.43
      PEDI.ImpLin COLUMN-LABEL "Importe!con IGV" FORMAT ">,>>>,>>9.99":U
            WIDTH 10
      PEDI.AlmDes FORMAT "x(3)":U WIDTH 7.72
  ENABLE
      PEDI.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 181 BY 10.5
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1
     BUTTON-3 AT ROW 11.77 COL 58 WIDGET-ID 6
     FILL-IN-Peso AT ROW 11.77 COL 140 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-ImpTot AT ROW 11.77 COL 166 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Total_Cotizacion AT ROW 12.85 COL 132 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_Saldo_Cotizacion AT ROW 12.85 COL 166 COLON-ALIGNED WIDGET-ID 20
     RECT-28 AT ROW 11.5 COL 1 WIDGET-ID 16
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
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 12.92
         WIDTH              = 181.29.
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
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Saldo_Cotizacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Total_Cotizacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.PEDI.NroItm|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > Temp-Tables.PEDI.NroItm
"PEDI.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"(IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> 'OF' THEN PEDI.Libre_c05 + '-' ELSE '')  + Almmmatg.Desmat @ Almmmatg.DesMat" "Descripción" "x(100)" ? ? ? ? ? ? ? no ? no no "80.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" "Cantidad!Aprobada" ">>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.Libre_d01
"PEDI.Libre_d01" "Cantidad!Pedida" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" "P. Unitario!con IGV" ">>,>>9.99999" "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI.Por_Dsctos[1]
"PEDI.Por_Dsctos[1]" "% Dscto.!Adminst" ? "decimal" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.PEDI.Por_Dsctos[2]
"PEDI.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.PEDI.Por_Dsctos[3]
"PEDI.Por_Dsctos[3]" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.PEDI.ImpLin
"PEDI.ImpLin" "Importe!con IGV" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.PEDI.AlmDes
"PEDI.AlmDes" ? ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    IF NOT AVAILABLE PEDI THEN RETURN.
    IF PEDI.Libre_c01 = '*' AND PEDI.CanPed <> PEDI.Libre_d01 THEN DO:
        ASSIGN
            Almmmatg.DesMar:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11 
            Almmmatg.DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.CanPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.ImpLin:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.NroItm:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.PreUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.UndVta:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.Por_Dsctos[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.Por_Dsctos[2]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            PEDI.Por_Dsctos[3]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11.
        ASSIGN
            Almmmatg.DesMar:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            Almmmatg.DesMat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.CanPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.codmat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.ImpLin:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.Libre_d01:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.NroItm:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.PreUni:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.UndVta:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.Por_Dsctos[1]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.Por_Dsctos[2]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            PEDI.Por_Dsctos[3]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  DISPLAY I-NroItm @ PEDI.NroItm WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Eliminar items - masivo */
DO:
  RUN vta2/d-items-eliminacion-masiva.r(INPUT-OUTPUT TABLE PEDI).

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

ON 'RETURN':U OF PEDI.CanPed, PEDI.codmat, PEDI.UndVta, PEDI.PreUni
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Saldo-Cot B-table-Win 
PROCEDURE Captura-Saldo-Cot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTotalCot AS DECI.
DEF INPUT PARAMETER pSaldoCot AS DECI.

ASSIGN
    x-Total-Cot = pTotalCot
    x-Saldo-Cot = pSaldoCot.

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
    FILL-IN-ImpTot = 0
    FILL-IN-Peso   = 0.
DEF BUFFER B-MATG FOR Almmmatg.
FOR EACH B-PEDI WHERE {&Condicion2},
    FIRST B-MATG OF B-PEDI NO-LOCK:
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-PEDI.ImpLin.
    FILL-IN-Peso   = FILL-IN-Peso   + (B-MATG.PesMat * B-PEDI.CanPed * B-PEDI.factor).
END.
DISPLAY FILL-IN-ImpTot FILL-IN-Peso WITH FRAME {&FRAME-NAME}.

DISPLAY 
    x-Saldo-Cot @ FILL-IN_Saldo_Cotizacion 
    x-Total-Cot @ FILL-IN_Total_Cotizacion
    WITH FRAME {&FRAME-NAME}.

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
  MESSAGE 'No se puede agragar registros' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.

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
      AND Almmmatg.codmat = PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {vta2/calcula-linea-detalle.i &Tabla="PEDI"}

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
  {src/adm/template/snd-list.i "PEDI"}
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
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
  
  /* CANTIDAD */
  IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CanPed.
       RETURN "ADM-ERROR".
  END.
  /* REDONDEAMOS AL EMPAQUE */
  DEF VAR f-Canped AS DEC NO-UNDO.
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  f-CanPed = DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.

  /* ******************************************************************** */
  /* Stock Disponible */
  /* 07/11/2023 C.Tenazoa */
  /* ******************************************************************** */
  DEF VAR x-StkAct AS DECI NO-UNDO.
  DEF VAR s-StkComprometido AS DECI NO-UNDO.
  DEF VAR s-StkDis AS DECI NO-UNDO.

  x-StkAct = 0.
  s-StkComprometido = 0.

  FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia
      AND Almmmate.codalm = s-CodAlm  /* *** OJO *** */
      AND Almmmate.codmat = PEDI.CodMat
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
  IF x-StkAct > 0 THEN RUN gn/Stock-Comprometido-v2 (PEDI.CodMat, s-CodAlm, YES, OUTPUT s-StkComprometido).
  s-StkDis = x-StkAct - s-StkComprometido.
  IF s-adm-new-record = "NO" THEN DO:
      FIND B-DPEDI WHERE B-DPEDI.codcia = s-codcia AND
          B-DPEDI.coddoc = "PED" AND
          B-DPEDI.nroped = s-nroped AND
          B-DPEDI.codmat = PEDI.codmat NO-LOCK NO-ERROR.
      IF AVAILABLE B-DPEDI THEN s-StkDis = s-StkDis + (B-DPEDI.CanPed * B-DPEDI.Factor).
  END.
  IF s-StkDis <= 0 THEN DO:
      APPLY 'ENTRY':U TO PEDI.canped.
      RETURN 'ADM-ERROR'.
  END.
  
  IF s-StkDis < f-CanPed THEN DO:
      /* Se ajusta la Cantidad Pedida al Saldo Disponible del Almacén */
      f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
  END.
  f-CanPed = f-CanPed * f-Factor.   /* En unidades de Stock */
  
  /* ******************************************************************** */
  /* ******************************************************************** */
  IF s-FlgEmpaque = YES THEN DO:
      CASE TRUE:
          WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
              RUN vtagn/p-cantidad-sugerida-pco.p (PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name}, 
                                                   f-CanPed, 
                                                   OUTPUT pSugerido, 
                                                   OUTPUT pEmpaque).
              f-CanPed = pSugerido.
              f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
              PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(f-CanPed).
              IF f-CanPed <= 0 THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' pEmpaque Almmmatg.UndBas VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO PEDI.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
          OTHERWISE DO:
              /* 07/11/2023 C.Tenazoa */
              DEF VAR pMensaje AS CHAR NO-UNDO.
              FIND COTIZACION WHERE COTIZACION.codcia = s-codcia AND
                  COTIZACION.coddoc = "COT" AND
                  COTIZACION.nroped = s-NroCot NO-LOCK NO-ERROR.
              RUN vtagn/p-cantidad-sugerida-v2.p (s-CodDiv,
                                                  (IF AVAILABLE COTIZACION THEN COTIZACION.Lista_de_Precios ELSE s-CodDiv),
                                                  PEDI.CodMat,
                                                  f-CanPed,
                                                  PEDI.UndVta,
                                                  s-CodCli,
                                                  OUTPUT pSugerido,
                                                  OUTPUT pEmpaque,
                                                  OUTPUT pMensaje).
              IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.

/*               RUN vtagn/p-cantidad-sugerida-pco.p (PEDI.CodMat,      */
/*                                                    f-CanPed,         */
/*                                                    OUTPUT pSugerido, */
/*                                                    OUTPUT pEmpaque). */
/*               RUN vtagn/p-cantidad-sugerida.p (s-TpoPed,                                          */
/*                                                PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name}, */
/*                                                f-CanPed,                                          */
/*                                                OUTPUT pSugerido,                                  */
/*                                                OUTPUT pEmpaque).                                  */
              f-CanPed = pSugerido.
              f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
              PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(f-CanPed).
              IF f-CanPed <= 0 THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' pEmpaque Almmmatg.UndBas VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO PEDI.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END CASE.
  END.
  /* CONSISTENCIA DE CANTIDAD CONTRA EL SALDO DE LA COTIZACION */
  IF INPUT PEDI.CanPed > PEDI.Libre_d01 THEN DO:
      MESSAGE 'No se puede despachar mas de ' PEDI.Libre_d01 PEDI.UndVta VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CanPed.
      UNDO, RETURN 'ADM-ERROR'.
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

/* ************************************************************* */
/* RHC 09/02/2020 SOLO para COTIZACIONES seleccionadas */
/* Solo línea 011 que tenga algún descuento por VOL DVXDSF u otros */
/* ************************************************************* */
IF Almmmatg.CodFam = '011' AND 
    (PEDI.Libre_c04 = 'VOL' OR PEDI.Libre_c04 BEGINS 'DV' OR PEDI.Libre_c04 BEGINS 'EDV')
    THEN DO:
    FIND Vtactabla WHERE VtaCTabla.CodCia = s-codcia AND
        VtaCTabla.Tabla = 'ATENCION_PARCIAL' AND
        VtaCTabla.Llave = s-coddiv + ',' + 'COT' + ',' + s-nrocot AND
        VtaCTabla.Estado = 'P'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCTabla THEN DO:
        MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
/* IF s-user-id <> 'SAC-00' THEN DO:                             */
/*     IF AVAILABLE PEDI AND Almmmatg.CodFam = '011'             */
/*         AND LOOKUP(PEDI.Libre_c04, 'VOL,DVXDSF') > 0 THEN DO: */
/*         MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.    */
/*         RETURN 'ADM-ERROR'.                                   */
/*     END.                                                      */
/*     IF AVAILABLE PEDI AND PEDI.Libre_c04 = "lp3ros" THEN DO:  */
/*         MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.    */
/*         RETURN 'ADM-ERROR'.                                   */
/*     END.                                                      */
/* END.                                                          */
IF AVAILABLE PEDI THEN 
    ASSIGN
    i-nroitm = PEDI.NroItm
    f-Factor = PEDI.Factor
    f-PreBas = PEDI.PreBas
    f-PreVta = PEDI.PreUni.
RUN Procesa-Handle IN lh_handle ('Disable-Head').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

