&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS L-table-Win 
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

/* Definicion de variables compartidas */
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE F-STKACT AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRECIO1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRECIO2 AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PESMAT  AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-FECINI AS DATE.
DEFINE VARIABLE X-FECFIN AS DATE.
DEFINE VARIABLE X-CODDOC AS CHAR INIT "L/P".

/* COPIA */
DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR R-ROWID    AS ROWID   NO-UNDO.
DEFINE VAR F-STKGEN   AS DECIMAL NO-UNDO.
DEFINE VAR F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VAR F-CODMAR AS CHAR NO-UNDO.
/* FIN COPIA */

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* Preprocesadores para condiciones */  
/*&SCOPED-DEFINE CONDICION ( PR-ODPC.CodCia = S-CODCIA  AND PR-ODPC.FlgEst = "P" )*/
&SCOPED-DEFINE CONDICION ( PR-ODPC.CodCia = S-CODCIA )
                           
&SCOPED-DEFINE CODIGO PR-ODPC.NumOrd

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( (PR-ODPC.CodPro BEGINS F-PROVEE) )
&SCOPED-DEFINE FILTRO2 ( (INDEX ( PR-ODPC.CodPro , F-PROVEE ) <> 0))

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY .88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 10 BY .88
     BGCOLOR 8 .

DEFINE VARIABLE CMB-condicion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-buscar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-chr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-date AS DATE FORMAT "99/99/9999":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-dec AS DECIMAL FORMAT "->>>>>9,99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-int AS INTEGER FORMAT "->>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55.14 BY 1.35.

DEFINE FRAME Dialog-Frame
     FILL-IN-buscar AT ROW 1.23 COL 6.14 COLON-ALIGNED
     CMB-condicion AT ROW 1.19 COL 21 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 2.62 COL 34.29
     FILL-IN-chr AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-date AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-int AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-dec AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     Btn_Cancel AT ROW 2.62 COL 44.86
     RECT-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(1.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         FONT 4 TITLE "Condiciones de Búsqueda"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel CENTERED.

DEFINE TEMP-TABLE T-Prod 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

DEFINE TEMP-TABLE T-Alm 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .


DEFINE TEMP-TABLE T-Merm 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

DEFINE TEMP-TABLE T-Horas 
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD CodPer LIKE Pl-PERS.CodPer
       FIELD DesPer AS CHAR FORMAT "X(45)"
       FIELD TotMin AS DECI FORMAT "->>>,>>9.99"
       FIELD TotHor AS DECI FORMAT "->>>,>>9.99"
       FIELD Factor AS DECI EXTENT 10 FORMAT "->>9.99" .

DEFINE TEMP-TABLE T-Gastos
       FIELD CodGas LIKE PR-ODPDG.CodGas
       FIELD CodPro LIKE PR-ODPDG.CodPro
       FIELD Total  LIKE Almdmov.CanDes.

FIND PR-CORR WHERE PR-CORR.Codcia = S-CODCIA AND
                   PR-CORR.Coddoc = X-CODDOC
                   NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-CORR THEN DO:
   MESSAGE "Correlativo de Liquidaciones no esta configurado"
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
END.

FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA 
                     NO-LOCK NO-ERROR.

IF NOT AVAILABLE PR-CFGPRO THEN DO:
   MESSAGE "Registro de Configuracion de Produccion no existe"
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
END.

DEFINE BUFFER B-DMOV FOR ALMDMOV.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLookup
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PR-ODPC

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PR-ODPC.FchOrd PR-ODPC.FchVto ~
PR-ODPC.NumOrd PR-ODPC.CodPro PR-ODPC.Usuario PR-ODPC.CanPed PR-ODPC.CanAte ~
PR-ODPC.Observ[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH PR-ODPC WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PR-ODPC WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table PR-ODPC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PR-ODPC


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-codigo CMB-filtro ~
FILL-IN-filtro F-PROVEE br_table BUTTON-1 F-fecha 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo CMB-filtro FILL-IN-filtro ~
F-PROVEE F-fecha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" L-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
CodCia||y|integral.PR-ODPC.CodCia
CodPro||y|integral.PR-ODPC.CodPro
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "CodCia,CodPro"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" L-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
Orden|y||integral.PR-ODPC.Codcia|yes,integral.PR-ODPC.NumOrd|yes
Proveedor|||integral.PR-ODPC.Codcia|yes,integral.PR-ODPC.CodPro|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Orden,Proveedor",
     SortBy-Case = Orden':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Generar Liquidacion" 
     SIZE 15 BY .85.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Descripción" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 20.72 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Liquidacion Al" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PROVEE AS CHARACTER FORMAT "X(256)":U 
     LABEL "C.Conversion" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(9)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 1.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PR-ODPC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PR-ODPC.FchOrd COLUMN-LABEL "Fecha           !Emision" FORMAT "99/99/9999":U
      PR-ODPC.FchVto COLUMN-LABEL "Fecha         !Entrega" FORMAT "99/99/9999":U
      PR-ODPC.NumOrd COLUMN-LABEL "Orden No" FORMAT "X(8)":U
      PR-ODPC.CodPro COLUMN-LABEL "Centro !Conversion" FORMAT "x(10)":U
      PR-ODPC.Usuario COLUMN-LABEL "Usuario" FORMAT "X(12)":U
      PR-ODPC.CanPed COLUMN-LABEL "Cantidad !Requerida" FORMAT ">,>>>,>>9.9999":U
      PR-ODPC.CanAte COLUMN-LABEL "Cantidad !Producida" FORMAT ">,>>>,>>9.9999":U
      PR-ODPC.Observ[1] FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 104.57 BY 11.04
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codigo AT ROW 1.31 COL 10 COLON-ALIGNED
     CMB-filtro AT ROW 1.31 COL 23
     FILL-IN-filtro AT ROW 1.31 COL 53.72 NO-LABEL
     F-PROVEE AT ROW 2.27 COL 9.86 COLON-ALIGNED
     br_table AT ROW 3.15 COL 105.57 RIGHT-ALIGNED
     BUTTON-1 AT ROW 14.46 COL 41.43
     F-fecha AT ROW 14.5 COL 26.29 COLON-ALIGNED
     RECT-1 AT ROW 14.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartLookup
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
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
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 15
         WIDTH              = 112.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB L-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table F-PROVEE F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BROWSE br_table IN FRAME F-Main
   ALIGN-R                                                              */
ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PR-ODPC"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > integral.PR-ODPC.FchOrd
"PR-ODPC.FchOrd" "Fecha           !Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.PR-ODPC.FchVto
"PR-ODPC.FchVto" "Fecha         !Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.PR-ODPC.NumOrd
"PR-ODPC.NumOrd" "Orden No" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.PR-ODPC.CodPro
"PR-ODPC.CodPro" "Centro !Conversion" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.PR-ODPC.Usuario
"PR-ODPC.Usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.PR-ODPC.CanPed
"PR-ODPC.CanPed" "Cantidad !Requerida" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.PR-ODPC.CanAte
"PR-ODPC.CanAte" "Cantidad !Producida" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.PR-ODPC.Observ[1]
"PR-ODPC.Observ[1]" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
    RETURN NO-APPLY.
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
   IF AVAILABLE PR-ODPC THEN DO:
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 L-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Generar Liquidacion */
DO:
  ASSIGN F-Fecha.
  FIND LAST PR-LIQC WHERE PR-LIQC.Codcia = PR-ODPC.Codcia AND
                          PR-LIQC.NumOrd = PR-ODPC.NumOrd AND
                          PR-LIQC.FlgEst <> "A"
                          NO-LOCK NO-ERROR.
  IF AVAILABLE PR-LIQC THEN DO:
  
     X-FECINI = PR-LIQC.FecFin + 1.                   
     MESSAGE "Periodo Liquidado : " + STRING(PR-LIQC.FecIni,"99/99/9999") + " Al " + STRING(PR-LIQC.FecFin,"99/99/9999") SKIP
             "Fecha             : " + STRING(PR-LIQC.FchLiq,"99/99/9999")     SKIP
             "Numero            : " + PR-LIQC.NumLiq 
             VIEW-AS ALERT-BOX INFORMATION TITLE "Datos Ultima Liquidacion".
     IF F-Fecha <= PR-LIQC.FecFin THEN DO:
        MESSAGE "Fecha Incorrecta " SKIP
                "Verifque........."
                VIEW-AS ALERT-BOX .
                APPLY "ENTRY" TO F-Fecha.
                RETURN NO-APPLY. 
     END.
  
  END.      
  ELSE DO:
    X-FECINI = PR-ODPC.FchOrd.
  END.
  X-FECFIN = F-Fecha .     
  
  MESSAGE "Seguro de Generar Liquidacion " SKIP
          "Orden de Produccion No : " + PR-ODPC.NumOrd SKIP
          "Periodo a Liquidar     : " + STRING(X-FECINI,"99/99/9999") + " Al " + STRING(X-FECFIN,"99/99/9999")
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE X-OK AS LOGICAL.
  IF X-OK THEN DO:
     RUN Genera-Liquidacion.                    
     MESSAGE "Desea Imprimir Liquidacion " SKIP
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE Y-OK AS LOGICAL.
     IF Y-OK THEN DO:
        RUN PRO/R-ImpLiqop(ROWID(PR-LIQC)).             
     END.                 

     MESSAGE "Liquidacion Generada "
              VIEW-AS ALERT-BOX INFORMATION TITLE "Procesao Concluido".  
     
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro L-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main /* Descripción */
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE AND
        F-Provee = F-Provee:SCREEN-VALUE
        THEN RETURN.        
    ASSIGN
        FILL-IN-filtro
        CMB-filtro
        F-Provee.
    CASE CMB-filtro:
         WHEN 'Todos':U THEN DO:
              IF F-PROVEE <> "" THEN RUN set-attribute-list('Key-Name=Nombres que inicien con').
              ELSE RUN set-attribute-list('Key-Name=?').
         END.
         WHEN 'Nombres que contengan':U THEN DO:
              IF FILL-IN-filtro <> "" THEN 
                 RUN set-attribute-list('Key-Name=' + CMB-filtro).
              ELSE DO:
                 RUN set-attribute-list('Key-Name=?').
              END.
         END.
         OTHERWISE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    END CASE.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-fecha L-table-Win
ON LEAVE OF F-fecha IN FRAME F-Main /* Liquidacion Al */
DO:
  ASSIGN F-FECHA.
  IF F-FECHA > TODAY THEN RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PROVEE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PROVEE L-table-Win
ON LEAVE OF F-PROVEE IN FRAME F-Main /* C.Conversion */
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo L-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Orden */
DO:
    IF INPUT FILL-IN-codigo = "" THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = string (integer(INPUT FILL-IN-codigo:screen-value),"999999" ))
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE
                "Registro no se encuentra en el filtro actual" SKIP
                "       Deshacer la actual selección ?       "
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO TITLE "Pregunta"
                UPDATE answ AS LOGICAL.
            IF answ THEN DO:
                ASSIGN
                    FILL-IN-filtro:SCREEN-VALUE = ""
                    CMB-filtro:SCREEN-VALUE = CMB-filtro:ENTRY(1).
                APPLY "VALUE-CHANGED" TO CMB-filtro.
                RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
            END.
        END.
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro L-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF PR-ODPC DO:
     FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPC.CodCia 
                    AND  Almmmatg.CodMat = PR-ODPC.CodArt 
                   NO-LOCK NO-ERROR.
END.
/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Act-Alm L-table-Win 
PROCEDURE Act-Alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Act-Gastos L-table-Win 
PROCEDURE Act-Gastos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Act-Horas L-table-Win 
PROCEDURE Act-Horas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR EACH PR-MOV-MES WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
                           PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  AND
                           PR-MOV-MES.FchReg >= X-FECINI  AND  
                           PR-MOV-MES.FchReg <= X-FECFIN:
     PR-MOV-MES.Numliq = PR-LIQC.NumLiq.
 END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Act-Merma L-table-Win 
PROCEDURE Act-Merma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases L-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'Orden':U THEN DO:
      &Scope SORTBY-PHRASE BY PR-ODPC.Codcia BY PR-ODPC.NumOrd
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Proveedor':U THEN DO:
      &Scope SORTBY-PHRASE BY PR-ODPC.Codcia BY PR-ODPC.CodPro
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available L-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busqueda-secuencial L-table-Win 
PROCEDURE busqueda-secuencial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

DEFINE VARIABLE pto AS LOGICAL NO-UNDO.
pto = SESSION:SET-WAIT-STATE("GENERAL").

ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

lazo:
DO WHILE AVAILABLE({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) ON STOP UNDO, LEAVE lazo:

    GET NEXT {&BROWSE-NAME}.

    IF QUERY-OFF-END("{&BROWSE-NAME}") THEN GET FIRST {&BROWSE-NAME}.

    REPOSITION br_table TO ROWID ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

    IF RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = curr-record THEN LEAVE lazo.

    CASE wh:DATA-TYPE:
    WHEN "INTEGER" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF INTEGER(wh:SCREEN-VALUE) = FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF INTEGER(wh:SCREEN-VALUE) > FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF INTEGER(wh:SCREEN-VALUE) >= FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF INTEGER(wh:SCREEN-VALUE) <  FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF INTEGER(wh:SCREEN-VALUE) <= FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "DECIMAL" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) = FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF DECIMAL(wh:SCREEN-VALUE) > FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) >= FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF DECIMAL(wh:SCREEN-VALUE) <  FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) <= FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "DATE" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF DATE(wh:SCREEN-VALUE) = FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF DATE(wh:SCREEN-VALUE) > FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF DATE(wh:SCREEN-VALUE) >= FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF DATE(wh:SCREEN-VALUE) <  FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF DATE(wh:SCREEN-VALUE) <= FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "CHARACTER" THEN
        CASE CMB-condicion:
        WHEN "=" THEN
            IF wh:SCREEN-VALUE = FILL-IN-chr THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "Inicie con" THEN
            IF wh:SCREEN-VALUE BEGINS FILL-IN-chr THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "Que contenga" THEN
            IF INDEX(wh:SCREEN-VALUE, FILL-IN-chr) > 0 THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    OTHERWISE LEAVE lazo.
    END CASE.
END.

pto = SESSION:SET-WAIT-STATE("").

REPOSITION {&BROWSE-NAME} TO RECID curr-record.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE captura-datos L-table-Win 
PROCEDURE captura-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
    ASSIGN
        output-var-1 = ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} )
        output-var-2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NumOrd
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodArt.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Alm L-table-Win 
PROCEDURE Crea-Tempo-Alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                     

  FOR EACH T-Alm:
      DELETE T-Alm.
  END.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  
            FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                         Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                         Almcmov.TipMov = PR-CFGPRO.TipMov[1] AND
                                         Almcmov.Codmov = PR-CFGPRO.CodMov[1] AND
                                         Almcmov.CodRef = "OP" AND
                                         Almcmov.Nroref = PR-ODPC.NumOrd AND
                                         Almcmov.FchDoc >= X-FECINI AND
                                         Almcmov.FchDoc <= X-FECFIN:
                                     
                                 
             FOR EACH Almdmov OF Almcmov:
                 
                 F-STKGEN = 0.
                 F-VALCTO = 0.
                 F-PRECIO = 0.
                 F-TOTAL  = 0.
                 
                 FIND B-DMOV WHERE ROWID(B-DMOV) = ROWID(almdmov)
                                   NO-LOCK NO-ERROR.
                 REPEAT:           
                    FIND PREV B-DMOV WHERE B-DMOV.Codcia = S-CODCIA AND
                                           B-DMOV.CodMat = Almdmov.CodMat AND
                                           B-DMOV.FchDoc <= Almdmov.FchDoc 
                                           USE-INDEX Almd02
                                           NO-LOCK NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN LEAVE.
                    IF B-DMOV.StkAct > 0 THEN LEAVE.
                 END.      
                 IF AVAILABLE B-DMOV THEN DO:
 
                    F-PRECIO = B-DMOV.Vctomn1 .
                    F-TOTAL  = F-PRECIO * Almdmov.CanDes.
                    
                 END.
                 
                 /*F-TOTAL = Almdmov.VctoMn1 * Almdmov.CanDes.*/
                 
                 FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                     Almmmatg.CodMat = Almdmov.Codmat
                                     NO-LOCK NO-ERROR.
              
                FIND T-Alm WHERE T-Alm.codmat = Almdmov.Codmat
                                    NO-ERROR.
                IF NOT AVAILABLE T-Alm THEN DO:
                   CREATE T-Alm.
                   ASSIGN 
                      T-Alm.Codmat = Almdmov.Codmat
                      T-Alm.Desmat = Almmmatg.desmat
                      T-Alm.UndBas = Almmmatg.undbas.
                END.                         
                T-Alm.CanRea = T-Alm.CanRea + Almdmov.CanDes.    
                T-Alm.Total  = T-Alm.Total  + F-TOTAL.    


             END.        
            END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Gastos L-table-Win 
PROCEDURE Crea-Tempo-Gastos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR X-UNIDADES AS DECI INIT 0.
    DEFINE VAR X-PRECIo AS DECI INIT 0.

    EMPTY TEMP-TABLE T-Gastos.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha NO-LOCK NO-ERROR.  

/*        
    FOR EACH T-Alm:
        IF T-Alm.CodMat = PR-ODPC.CodArt THEN DO:
           X-UNIDADES = X-UNIDADES + T-Alm.CanRea.
        END.
    END.
*/
    FOR EACH T-Prod:    
        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                            Almmmatg.CodMat = T-Prod.CodMat 
                            NO-LOCK NO-ERROR.
                                
        FOR EACH PR-ODPDG OF PR-ODPC:
            FIND T-Gastos WHERE T-Gastos.CodGas = PR-ODPDG.CodGas AND
                                T-Gastos.CodPro = PR-ODPDG.CodPro
                                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-Gastos THEN DO:
                CREATE T-Gastos.
                ASSIGN
                    T-Gastos.CodGas = PR-ODPDG.CodGas
                    T-Gastos.CodPro = PR-ODPDG.CodPro .
            END.
            X-PRECIO = 0.
            FIND PR-PRESER WHERE PR-PRESER.Codcia = PR-ODPDG.Codcia AND
                                 PR-PRESER.CodPro = PR-ODPDG.CodPro AND
                                 PR-PRESER.CodGas = PR-ODPDG.CodGas AND
                                 PR-PRESER.CodMat = T-Prod.CodMat
                                 NO-LOCK NO-ERROR.
            IF AVAILABLE PR-PRESER THEN DO:  
                IF PR-ODPC.CodMon = 1 THEN DO:
                   IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1].
                   IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1] * Gn-Tcmb.Venta .
                END.
                IF PR-ODPC.CodMon = 2 THEN DO:
                   IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1] /  Gn-Tcmb.Venta.
                   IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1]  .
                END.
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                               AND  Almtconv.Codalter = PR-PRESER.UndA 
                               NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                   T-Gastos.Total  = T-Gastos.Total + (X-PRECIO * T-Prod.CanRea) / (PR-PRESER.CanDes[1] * Almtconv.Equival).                    
                END.                    
            END.            
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas L-table-Win 
PROCEDURE Crea-Tempo-Horas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH T-Horas:
      DELETE T-Horas.
  END.
  DEFINE VAR X-DIAS AS INTEGER INIT 208.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
  DEFINE VAR X-HORAI AS DECI .
  DEFINE VAR X-SEGI AS DECI .
  DEFINE VAR X-SEGF AS DECI .
  DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".
  DEFINE VAR X-BASE   AS DECI .
  DEFINE VAR X-HORMEN AS DECI .
  DEFINE VAR X-FACTOR AS DECI .
  
  DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT "->>9.99".
  DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT "->>>>>9.99".
  
  DEFINE VAR X-TOT1 AS DECI.
  DEFINE VAR X-TOT2 AS DECI.
  DEFINE VAR X-TOT3 AS DECI.
  DEFINE VAR X-TOT4 AS DECI.
  DEFINE VAR X-TOT5 AS DECI.
  DEFINE VAR X-TOT6 AS DECI.
  DEFINE VAR X-TOT10 AS DECI.
  



       FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
                                         PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  AND
                                         PR-MOV-MES.FchReg >= X-FECINI  AND  
                                         PR-MOV-MES.FchReg <= X-FECFIN
                                         BREAK BY PR-MOV-MES.NumOrd
                                               BY PR-MOV-MES.FchReg
                                               BY PR-MOV-MES.CodPer :
      
 

          FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer
                             NO-LOCK NO-ERROR.
          X-DESPER = "".
          IF AVAILABLE Pl-PERS THEN 
          X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).
          X-HORAI  = PR-MOV-MES.HoraI.
          X-HORA   = 0.
          X-IMPHOR = 0.
          X-TOTA   = 0.
          X-BASE   = 0.
          X-HORMEN = 0.
          X-FACTOR = 0.
                    
          FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
                                   PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
                                   PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
                                   PL-MOV-MES.CodPln  = 01 AND
                                   PL-MOV-MES.Codcal  = 0 AND
                                   PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
                                   (PL-MOV-MES.CodMov = 101 OR
                                    PL-MOV-MES.CodMov = 103)  :
          
            X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     

              
          END.

        FIND LAST PL-VAR-MES WHERE
                  PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
                  PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes 
                  NO-ERROR.

        IF AVAILABLE PL-VAR-MES THEN 
           ASSIGN
           X-HORMEN = PL-VAR-MES.ValVar-MES[11]
           X-FACTOR = PL-VAR-MES.ValVar-MES[12] + PL-VAR-MES.ValVar-MES[13] + PL-VAR-MES.ValVar-MES[3] + PL-VAR-MES.ValVar-MES[5] + PL-VAR-MES.ValVar-MES[10].

           X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.
         
          
          FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA /*AND
                                          PR-CFGPL.Periodo = PR-MOV-MES.Periodo AND
                                          PR-CFGPL.NroMes  = PR-MOV-MES.NroMes*/:
              IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
                 IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
                    X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
                    X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                    X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                    X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 

                    LEAVE.
                 END.
                 IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
                    X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
                    X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                    X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                    X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-HORAI = PR-CFGPL.HoraF.
                 END.
                 
              END.
                             
                                          
          END.               

          X-IMPHOR = X-IMPHOR * 60 .         

          X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
          X-SEGI = TRUNCATE(PR-MOV-MES.HoraI,0) * 60 + (PR-MOV-MES.HoraI - TRUNCATE(PR-MOV-MES.HoraI,0)) * 100 . 

          FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer 
                             NO-ERROR.
          IF NOT AVAILABLE T-Horas THEN DO:
             CREATE T-Horas.
             ASSIGN 
             T-Horas.CodPer = PR-MOV-MES.CodPer
             T-Horas.DesPer = X-DESPER .
          END.
          ASSIGN
          T-Horas.TotMin = T-Horas.TotMin +  X-SEGF - X-SEGI .
          T-Horas.TotHor = T-Horas.TotHor + X-TOTA[10] .
           
                             
                     

  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas-2 L-table-Win 
PROCEDURE Crea-Tempo-Horas-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  FOR EACH T-Horas:
      DELETE T-Horas.
  END.
  DEFINE VAR X-DIAS AS INTEGER INIT 208.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
  DEFINE VAR X-HORAI AS DECI .
  DEFINE VAR X-SEGI AS DECI .
  DEFINE VAR X-SEGF AS DECI .
  DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".
  DEFINE VAR X-BASE   AS DECI .
  DEFINE VAR X-HORMEN AS DECI .
  DEFINE VAR X-FACTOR AS DECI .
  
  DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT "->>9.99".
  DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT "->>>>>9.99".
  
  DEFINE VAR X-TOT1 AS DECI.
  DEFINE VAR X-TOT2 AS DECI.
  DEFINE VAR X-TOT3 AS DECI.
  DEFINE VAR X-TOT4 AS DECI.
  DEFINE VAR X-TOT5 AS DECI.
  DEFINE VAR X-TOT6 AS DECI.
  DEFINE VAR X-TOT10 AS DECI.
  
  FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
      PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  AND
      PR-MOV-MES.FchReg >= X-FECINI  AND  
      PR-MOV-MES.FchReg <= X-FECFIN
      BREAK BY PR-MOV-MES.NumOrd
        BY PR-MOV-MES.FchReg
        BY PR-MOV-MES.CodPer :

      FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer
          NO-LOCK NO-ERROR.
      X-DESPER = "".
      IF AVAILABLE Pl-PERS THEN 
          X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).

      ASSIGN
          X-HORAI  = PR-MOV-MES.HoraI
          X-HORA   = 0
          X-IMPHOR = 0
          X-TOTA   = 0
          X-BASE   = 0
          X-HORMEN = 0
          X-FACTOR = 0.
        
      /*Coneptos Actuales*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          PL-MOV-MES.Codcal  = 0 AND
          PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
          (PL-MOV-MES.CodMov = 101 OR
           PL-MOV-MES.CodMov = 103) NO-LOCK:
          
          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      /*RDP:Conceptos a incluir - Calculo 01*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          PL-MOV-MES.Codcal  = 01 AND
          PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
          LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"126,301,144") > 0 NO-LOCK:          
          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      /*RDP:Conceptos a incluir - Calculo 09,10,11*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          LOOKUP(STRING(PL-MOV-MES.Codcal,"99"),"09,10,11") > 0  AND
          PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND
          PL-MOV-MES.CodMov  = 403 NO-LOCK:          
          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.


      FIND LAST PL-VAR-MES WHERE
          PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes NO-ERROR.

      IF AVAILABLE PL-VAR-MES THEN 
          ASSIGN
            X-HORMEN = PL-VAR-MES.ValVar-MES[11]
            X-FACTOR = PL-VAR-MES.ValVar-MES[12] + PL-VAR-MES.ValVar-MES[13] + PL-VAR-MES.ValVar-MES[3] + PL-VAR-MES.ValVar-MES[5] + PL-VAR-MES.ValVar-MES[10].
      
      X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.

      FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA 
          /*AND PR-CFGPL.Periodo = PR-MOV-MES.Periodo 
          AND PR-CFGPL.NroMes  = PR-MOV-MES.NroMes*/:

          IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
              IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
                  X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
                  X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                  X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                  X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  LEAVE.
              END.

              IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
                  X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
                  X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                  X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                  X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-HORAI = PR-CFGPL.HoraF.
              END.
          END.
      END.               

      X-IMPHOR = X-IMPHOR * 60 .         
      
      X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
      X-SEGI = TRUNCATE(PR-MOV-MES.HoraI,0) * 60 + (PR-MOV-MES.HoraI - TRUNCATE(PR-MOV-MES.HoraI,0)) * 100 . 

      FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer NO-ERROR.
      IF NOT AVAILABLE T-Horas THEN DO:
          CREATE T-Horas.
          ASSIGN 
              T-Horas.CodPer = PR-MOV-MES.CodPer
              T-Horas.DesPer = X-DESPER .
      END.
      ASSIGN
          T-Horas.TotMin = T-Horas.TotMin +  X-SEGF - X-SEGI .
      T-Horas.TotHor = T-Horas.TotHor + X-TOTA[10] . 
  END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas-3 L-table-Win 
PROCEDURE Crea-Tempo-Horas-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pro/calcula-horas-mod (INPUT-OUTPUT TABLE T-Horas,
                           INPUT ROWID(PR-ODPC),
                           INPUT x-FecIni,
                           INPUT x-FecFin).

/* DEFINE VAR X-DIAS AS INTEGER INIT 208.                                                                                       */
/* DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".                                                                                 */
/* DEFINE VAR X-HORAI AS DECI .                                                                                                 */
/* DEFINE VAR X-SEGI AS DECI .                                                                                                  */
/* DEFINE VAR X-SEGF AS DECI .                                                                                                  */
/* DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".                                                                                */
/* DEFINE VAR X-BASE   AS DECI .                                                                                                */
/* DEFINE VAR X-HORMEN AS DECI .                                                                                                */
/* DEFINE VAR X-FACTOR AS DECI .                                                                                                */
/*                                                                                                                              */
/* EMPTY TEMP-TABLE t-Horas.                                                                                                    */
/* FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA                                                               */
/*     AND PR-MOV-MES.NumOrd = PR-ODPC.NumOrd                                                                                   */
/*     AND PR-MOV-MES.FchReg >= X-FECINI                                                                                        */
/*     AND PR-MOV-MES.FchReg <= X-FECFIN                                                                                        */
/*     BREAK BY PR-MOV-MES.CodPer BY PR-MOV-MES.Periodo BY PR-MOV-MES.NroMes BY PR-MOV-MES.FchReg:                              */
/*     /* Quiebre por Personal, Periodo y Mes trabajado */                                                                      */
/*     IF FIRST-OF(PR-MOV-MES.CodPer) OR FIRST-OF(PR-MOV-MES.Periodo) OR FIRST-OF(PR-MOV-MES.NroMes) THEN DO:                   */
/*         ASSIGN                                                                                                               */
/*             X-DESPER = ""                                                                                                    */
/*             x-HorMen = 0.                                                                                                    */
/*         FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer NO-LOCK NO-ERROR.                                              */
/*         IF AVAILABLE Pl-PERS THEN X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer). */
/*     END.                                                                                                                     */
/*     /* Acumulamos las horas trabajadas según producción */                                                                   */
/*     ASSIGN                                                                                                                   */
/*         X-HORAI  = PR-MOV-MES.HoraI.                                                                                         */
/*     FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA:                                                              */
/*         IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:                                                   */
/*             IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:                                                                   */
/*                X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 .        */
/*                X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 .                                   */
/*                x-HorMen = x-HorMen + (X-SEGF - X-SEGI) * (IF PR-CFGPL.Factor = 0 THEN 0 ELSE 1 ).                            */
/*                LEAVE.                                                                                                        */
/*             END.                                                                                                             */
/*             IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:                                                                    */
/*                X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 .              */
/*                X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 .                                   */
/*                x-HorMen = x-HorMen + (X-SEGF - X-SEGI) * ( IF PR-CFGPL.Factor = 0 THEN 0 ELSE 1 ).                           */
/*                X-HORAI = PR-CFGPL.HoraF.                                                                                     */
/*             END.                                                                                                             */
/*         END.                                                                                                                 */
/*     END.                                                                                                                     */
/*     IF LAST-OF(PR-MOV-MES.CodPer) OR LAST-OF(PR-MOV-MES.Periodo) OR LAST-OF(PR-MOV-MES.NroMes) THEN DO:                      */
/*         ASSIGN                                                                                                               */
/*             x-Base = 0                                                                                                       */
/*             x-Dias = 0                                                                                                       */
/*             x-ImpHor = 0.                                                                                                    */
/*         /* Calculamos el Valor Hora de acuerdo a la planilla */                                                              */
/*         FIND PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                      */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             PL-MOV-MES.Codcal  = 01 AND                                                                                      */
/*             PL-MOV-MES.CodMov  = 100    /* DIAS TRABAJADOS */                                                                */
/*             NO-LOCK NO-ERROR.                                                                                                */
/*         IF AVAILABLE PL-MOV-MES THEN x-Dias = PL-MOV-MES.ValCal-Mes.                                                         */
/*         /* BOLETA DE SUELDOS 101 Sueldo 103 Asig. fam 117 Alimentacion 125 HHEE 25% 126 HHEE 100% 127 HHEE 35% 301 ESSALUD   */
/*         113 Refrigerio 306 Senati*/                                                                                          */
/*         FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                  */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             PL-MOV-MES.Codcal  = 01 AND                                                                                      */
/*             LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"101,103,117,113,125,126,127,301,306") > 0 NO-LOCK:                       */
/*             X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                                                                        */
/*         END.                                                                                                                 */
/*         /* BOLETA DE GRATIFICACIONES 144 Asig, Extr Grat. 9% */                                                              */
/*         FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                  */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             PL-MOV-MES.Codcal  = 04 AND                                                                                      */
/*             PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND                                                                        */
/*             LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"144") > 0 NO-LOCK:                                                       */
/*             X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                                                                        */
/*         END.                                                                                                                 */
/*         /* BOLETAS DE PROVISIONES - Calculo 09,10,11 */                                                                      */
/*         FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                  */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             LOOKUP(STRING(PL-MOV-MES.Codcal,"99"),"09,10,11") > 0  AND                                                       */
/*             PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND                                                                       */
/*             PL-MOV-MES.CodMov  = 403 NO-LOCK:                                                                                */
/*             X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                                                                        */
/*         END.                                                                                                                 */
/*         IF x-Dias > 0 THEN x-ImpHor = x-Base / x-Dias / 8.  /* IMPORTE HORA */                                               */
/*         /* Acumulamos por cada trabajador */                                                                                 */
/*         FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer NO-ERROR.                                                      */
/*         IF NOT AVAILABLE T-Horas THEN DO:                                                                                    */
/*            CREATE T-Horas.                                                                                                   */
/*            ASSIGN                                                                                                            */
/*                T-Horas.CodPer = PR-MOV-MES.CodPer                                                                            */
/*                T-Horas.DesPer = X-DESPER .                                                                                   */
/*         END.                                                                                                                 */
/*         ASSIGN                                                                                                               */
/*             T-Horas.TotMin = T-Horas.TotMin +  x-HorMen                                                                      */
/*             T-Horas.TotHor = T-Horas.TotHor + ( ( x-HorMen / 60 ) * x-ImpHor ).                                              */
/*     END.                                                                                                                     */
/* END.                                                                                                                         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Merma L-table-Win 
PROCEDURE Crea-Tempo-Merma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-Merm:
    DELETE T-Merm.
END.

DEFINE VAR I AS INTEGER.
DEFINE VAR F-STKGEN AS DECI .
DEFINE VAR F-VALCTO AS DECI .
DEFINE VAR F-PRECIO AS DECI.
DEFINE VAR F-TOTAL AS DECI.
  

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                               Almcmov.CodAlm = PR-ODPC.CodAlm AND
                               Almcmov.TipMov = PR-CFGPRO.TipMov[3] AND
                               Almcmov.Codmov = PR-CFGPRO.CodMov[3]  AND
                               Almcmov.CodRef = "OP" AND
                               Almcmov.Nroref = PR-ODPC.NumOrd AND
                               Almcmov.FchDoc >= X-FECINI AND
                               Almcmov.FchDoc <= X-FECFIN:
                           
                       
   FOR EACH Almdmov OF Almcmov:  
     
       FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                           Almmmatg.CodMat = Almdmov.Codmat
                           NO-LOCK NO-ERROR.
    

      FIND T-Merm WHERE T-Merm.codmat = Almdmov.Codmat
                          NO-ERROR.
      IF NOT AVAILABLE T-Merm THEN DO:
         CREATE T-Merm.
         ASSIGN 
            T-Merm.Codmat = Almdmov.Codmat
            T-Merm.Desmat = Almmmatg.desmat
            T-Merm.UndBas = Almmmatg.undbas.
      END.                         
      T-Merm.CanRea = T-Merm.CanRea + Almdmov.CanDes.    

   END.        
  END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Prod L-table-Win 
PROCEDURE Crea-Tempo-Prod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                     

  FOR EACH T-Prod:
      DELETE T-Prod.
  END.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  

            FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                         Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                         Almcmov.TipMov = PR-CFGPRO.TipMov[2] AND
                                         Almcmov.Codmov = PR-CFGPRO.CodMov[2] AND
                                         Almcmov.CodRef = "OP" AND
                                         Almcmov.Nroref = PR-ODPC.NumOrd AND
                                         Almcmov.FchDoc >= X-FECINI AND
                                         Almcmov.FchDoc <= X-FECFIN:
                                         
                                     
                                 
             FOR EACH Almdmov OF Almcmov:
/*    
                 F-STKGEN = AlmDMOV.StkActCbd .
                 F-VALCTO = AlmDMOV.Vctomn1Cbd .
                 F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
                 F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
                 F-TOTAL  = F-PRECIO * Almdmov.CanDes.
                 F-TOTAL  = 0.
*/
                 F-STKGEN = AlmDMOV.StkAct .
                 F-PRECIO = AlmDMOV.Vctomn1 .
                 F-TOTAL  = F-PRECIO * Almdmov.CanDes.

                 FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                     Almmmatg.CodMat = Almdmov.Codmat
                                     NO-LOCK NO-ERROR.
              

                FIND T-Prod WHERE T-Prod.codmat = Almdmov.Codmat
                                    NO-ERROR.
                IF NOT AVAILABLE T-Prod THEN DO:
                   CREATE T-Prod.
                   ASSIGN 
                      T-Prod.Codmat = Almdmov.Codmat
                      T-Prod.Desmat = Almmmatg.desmat
                      T-Prod.UndBas = Almmmatg.undbas.
                END.                         
                T-Prod.CanRea = T-Prod.CanRea + Almdmov.CanDes.    
                T-Prod.Total  = T-Prod.Total  + F-TOTAL.    

             END.        
            END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI L-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Liquidacion L-table-Win 
PROCEDURE Genera-Liquidacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Crea-Tempo-Prod.
RUN Crea-Tempo-Alm.
RUN Crea-Tempo-Merma.
RUN Crea-Tempo-Horas-3.
RUN Crea-Tempo-Gastos.
RUN Genera-Totales.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Totales L-table-Win 
PROCEDURE Genera-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha
                            NO-LOCK NO-ERROR.  

DO:
    
    FIND PR-CORR WHERE PR-CORR.Codcia = S-CODCIA AND
                       PR-CORR.Coddoc = X-CODDOC
                       EXCLUSIVE-LOCK NO-ERROR.
    PR-CORR.NroDoc = PR-CORR.NroDoc + 1 . 
    CREATE PR-LIQC.
    ASSIGN
    PR-LIQC.Codcia = S-CODCIA 
    PR-LIQC.CanFin = 0
    PR-LIQC.codart = ""/*PR-ODPC.CodArt*/
    PR-LIQC.CodFor = ""/*PR-ODPC.CodFor*/
    PR-LIQC.CodMon = PR-ODPC.CodMon
    PR-LIQC.CtoGas = 0
    PR-LIQC.CtoHor = 0
    PR-LIQC.CtoMat = 0
    PR-LIQC.CtoFab = 0
    PR-LIQC.Ctotot = 0
    PR-LIQC.Factor = PR-CFGPRO.Factor  
    PR-LIQC.FchLiq = TODAY
    PR-LIQC.FecFin = X-FECFIN
    PR-LIQC.FecIni = X-FECINI
    PR-LIQC.FlgEst = ""
    PR-LIQC.NumOrd = PR-ODPC.NumOrd
    PR-LIQC.PreUni = 0
    PR-LIQC.TpoCmb = Gn-Tcmb.Venta
    PR-LIQC.Usuario = S-USER-ID
    PR-LIQC.Numliq = STRING(PR-CORR.NroDoc,"999999") .
    RELEASE PR-CORR.

    FOR EACH T-Prod:
        ASSIGN
        PR-LIQC.CanFin = PR-LIQC.CanFin + T-Prod.CanRea .
/*        PR-LIQC.CtoMat = PR-LIQC.CtoMat + T-Prod.Total.*/
        CREATE PR-LIQCX.
        ASSIGN
        PR-LIQCX.Codcia = PR-LIQC.Codcia 
        PR-LIQCX.CanFin = T-Prod.CanRea
        PR-LIQCX.codart = T-Prod.Codmat
        PR-LIQCX.CodUnd = T-Prod.UndBas
        PR-LIQCX.CtoTot = T-Prod.Total
        PR-LIQCX.Numliq = PR-LIQC.NumLiq 
        PR-LIQCX.NumOrd = PR-LIQC.NumOrd
        PR-LIQCX.PreUni = T-Prod.Total / T-Prod.CanRea.
    END.
    
    FOR EACH T-Alm:
        PR-LIQC.CtoMat = PR-LIQC.CtoMat + T-Alm.Total.
        CREATE PR-LIQD1.
        ASSIGN
        PR-LIQD1.Codcia = PR-LIQC.Codcia 
        PR-LIQD1.CanDes = T-Alm.CanRea
        PR-LIQD1.codmat = T-Alm.Codmat
        PR-LIQD1.CodUnd = T-Alm.UndBas
        PR-LIQD1.ImpTot = T-Alm.Total
        PR-LIQD1.Numliq = PR-LIQC.NumLiq 
        PR-LIQD1.NumOrd = PR-LIQC.NumOrd
        PR-LIQD1.PreUni = T-Alm.Total / T-Alm.CanRea.
    END.

    FOR EACH T-Horas:
        CREATE PR-LIQD2.
        ASSIGN
        PR-LIQD2.CodCia = PR-LIQC.Codcia 
        PR-LIQD2.codper = T-Horas.CodPer
        PR-LIQD2.Horas  = TRUNCATE(T-Horas.Totmin / 60 ,0 ) + (( T-Horas.TotMin MOD 60 ) / 100 )
        PR-LIQD2.HorVal = T-Horas.TotHor
        PR-LIQD2.Numliq = PR-LIQC.NumLiq
        PR-LIQD2.NumOrd = PR-LIQC.NumOrd
        PR-LIQC.CtoHor = PR-LIQC.CtoHor + T-Horas.TotHor.
    END.
    FOR EACH T-Gastos:
        CREATE PR-LIQD3.
        ASSIGN
        PR-LIQD3.CodCia = PR-LIQC.Codcia 
        PR-LIQD3.codGas = T-Gastos.CodGas
        PR-LIQD3.CodPro = T-Gastos.CodPro
        PR-LIQD3.ImpTot = T-Gastos.Total
        PR-LIQD3.Numliq = PR-LIQC.NumLiq
        PR-LIQD3.NumOrd = PR-LIQC.NumOrd
        PR-LIQC.CtoGas  = PR-LIQC.CtoGas + T-Gastos.Total.
    END.
    FOR EACH T-Merm:
        CREATE PR-LIQD4.
        ASSIGN
        PR-LIQD4.Codcia = PR-LIQC.Codcia 
        PR-LIQD4.CanDes = T-Merm.CanRea
        PR-LIQD4.codmat = T-Merm.Codmat
        PR-LIQD4.CodUnd = T-Merm.UndBas
        PR-LIQD4.ImpTot = T-Merm.Total
        PR-LIQD4.Numliq = PR-LIQC.NumLiq 
        PR-LIQD4.NumOrd = PR-LIQC.NumOrd.
    END.

    PR-LIQC.CtoFab = PR-CFGPRO.Factor * PR-LIQC.CtoHor . 
    PR-LIQC.CtoTot = PR-LIQC.CtoMat + PR-LIQC.CtoHor + PR-LIQC.CtoGas + PR-LIQC.CtoFab .
    PR-LIQC.PreUni = PR-LIQC.CtoTot / PR-LIQC.CanFin.
    PR-LIQC.Factor = IF PR-LIQC.CtoFab > 0 THEN PR-LIQC.Factor ELSE 0.
        
    RUN ACT-Horas.
    RUN ACT-Alm.
    RUN ACT-Merma.
    RUN ACT-Gastos.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize L-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
   
    RUN get-attribute ('Keys-Accepted').

    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
        ASSIGN
            CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
            CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    F-FECHA = TODAY.
    DISPLAY F-FECHA WITH FRAME {&FRAME-NAME}.
    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        output-var-1 = ?
        output-var-2 = ?
        output-var-3 = ?.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-PARAMETROS L-table-Win 
PROCEDURE PROCESA-PARAMETROS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RECOGE-PARAMETROS L-table-Win 
PROCEDURE RECOGE-PARAMETROS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key L-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "CodCia" "PR-ODPC" "CodCia"}
  {src/adm/template/sndkycas.i "CodPro" "PR-ODPC" "CodPro"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records L-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PR-ODPC"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed L-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toma-handle L-table-Win 
PROCEDURE toma-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-handle AS WIDGET-HANDLE.
    
    ASSIGN whpadre = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

