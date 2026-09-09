&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE PEDI-1 LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE PEDI-2 LIKE FacDPedi.



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
DEFINE SHARED VARIABLE S-CODIGV  AS INT.
DEFINE SHARED VARIABLE S-FLGSIT  AS CHAR.
DEFINE SHARED VARIABLE S-NROCOT  AS CHARACTER.
DEFINE SHARED VARIABLE S-NROPED  AS CHARACTER.
DEFINE SHARED VARIABLE pCodAlm AS CHAR.     /* ALMACEN POR DEFECTO */
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.

DEFINE BUFFER B-PEDI-1 FOR PEDI-1.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-Adm-New-Record AS CHAR.

DEFINE VAR s-registro-activo AS LOG INIT NO NO-UNDO.

DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

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
&Scoped-define INTERNAL-TABLES PEDI-1 Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI-1.NroItm PEDI-1.codmat ~
Almmmatg.DesMat Almmmatg.DesMar PEDI-1.UndVta PEDI-1.CanPed PEDI-1.PreUni ~
PEDI-1.Por_Dsctos[1] PEDI-1.Por_Dsctos[2] PEDI-1.Por_Dsctos[3] ~
PEDI-1.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI-1.codmat PEDI-1.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI-1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI-1
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF PEDI-1 NO-LOCK ~
    BY PEDI-1.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF PEDI-1 NO-LOCK ~
    BY PEDI-1.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI-1 Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI-1
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesMat F-TotBrt F-ImpExo F-ValVta ~
F-ImpIsc F-ImpIgv F-ImpTot F-ImpDes 

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
DEFINE VARIABLE F-ImpDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpExo AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIgv AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIsc AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 1.88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI-1, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI-1.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      PEDI-1.codmat COLUMN-LABEL "Articulo" FORMAT "X(13)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 35.14
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(12)":U
      PEDI-1.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 5.29
      PEDI-1.CanPed FORMAT ">>>,>>9.99":U WIDTH 6.43
      PEDI-1.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
            WIDTH 7.14
      PEDI-1.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Manual" FORMAT "->>9.99":U
      PEDI-1.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.99":U
      PEDI-1.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol. Prom." FORMAT "->>9.99":U
      PEDI-1.ImpLin FORMAT ">,>>>,>>9.99":U WIDTH 8.57
  ENABLE
      PEDI-1.codmat
      PEDI-1.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 113 BY 7.81
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-DesMat AT ROW 8.81 COL 14 COLON-ALIGNED WIDGET-ID 2
     F-TotBrt AT ROW 10.46 COL 19 NO-LABEL
     F-ImpExo AT ROW 10.46 COL 31 NO-LABEL
     F-ValVta AT ROW 10.46 COL 53.14 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 10.46 COL 65.86 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 10.46 COL 78.43 COLON-ALIGNED NO-LABEL
     F-ImpTot AT ROW 10.46 COL 91 COLON-ALIGNED NO-LABEL
     F-ImpDes AT ROW 10.5 COL 41 COLON-ALIGNED NO-LABEL
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 9.88 COL 83.14
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 9.88 COL 71.57
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.92 COL 56.86
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 9.88 COL 31.43
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 9.88 COL 93.14
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.88 COL 20.86
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 9.92 COL 43.57
     RECT-11 AT ROW 9.62 COL 1
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI-1 T "SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI-2 T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 10.54
         WIDTH              = 115.
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

/* SETTINGS FOR FILL-IN F-ImpDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpExo IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpIsc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI-1,INTEGRAL.Almmmatg OF Temp-Tables.PEDI-1"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.PEDI-1.NroItm|yes"
     _FldNameList[1]   > Temp-Tables.PEDI-1.NroItm
"PEDI-1.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI-1.codmat
"PEDI-1.codmat" "Articulo" "X(13)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "35.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI-1.UndVta
"PEDI-1.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI-1.CanPed
"PEDI-1.CanPed" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI-1.PreUni
"PEDI-1.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI-1.Por_Dsctos[1]
"PEDI-1.Por_Dsctos[1]" "% Dscto.!Manual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI-1.Por_Dsctos[2]
"PEDI-1.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.PEDI-1.Por_Dsctos[3]
"PEDI-1.Por_Dsctos[3]" "% Dscto!Vol. Prom." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.PEDI-1.ImpLin
"PEDI-1.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  DISPLAY I-NroItm @ PEDI-1.NroItm WITH BROWSE {&BROWSE-NAME}.
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
      IF AVAILABLE Almmmatg THEN
        FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI-1.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI-1.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF s-registro-activo = NO THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.

    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        WITH BROWSE {&BROWSE-NAME}.
    DISPLAY Almmmatg.DesMat @ FILL-IN-DesMat WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF PEDI-1.codmat IN BROWSE br_table /* Articulo */
OR F8 OF PEDI-1.codmat
DO:
    ASSIGN
        input-var-1 = pCodAlm
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-listpr-01 ('Lista de Precios').
    IF output-var-1 <> ? THEN DO:
        /*pCodAlm = output-var-3.           NO PARA ESTE CASO */     
        DISPLAY
            output-var-2 @ PEDI-1.codmat
            WITH BROWSE {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI-1.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.CanPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PEDI-1.CanPed IN BROWSE br_table /* Cantidad */
DO:
    IF s-registro-activo = NO THEN RETURN.
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        PEDI-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                        pCodAlm
                        ).
    IF output-var-2 = ? THEN DO:
        APPLY 'ENTRY':U TO PEDI-1.codmat IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
    END.
    FIND Almtconv WHERE 
         Almtconv.CodUnid = Almmmatg.UndBas AND  
         Almtconv.Codalter = output-var-2 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN  F-FACTOR = Almtconv.Equival.
    ELSE DO:
         MESSAGE "Equivalencia no Registrada"
                 VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO PEDI-1.CodMat IN BROWSE {&BROWSE-NAME}.
         RETURN NO-APPLY.
    END.
    /************************************************/
    DISPLAY output-var-2 @ PEDI-1.UndVta WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI-1.CanPed IN BROWSE br_table /* Cantidad */
DO:
    IF s-registro-activo = NO THEN RETURN.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = PEDI-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK.
    FIND Almtconv WHERE 
         Almtconv.CodUnid  = Almmmatg.UndBas AND  
         Almtconv.Codalter = PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO PEDI-1.CodMat IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
    END.
    IF Almtconv.Multiplos <> 0 THEN DO:
         IF DEC(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
            INT(DEC(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
            MESSAGE " La Cantidad debe de ser un, " SKIP
                    " multiplo de : " Almtconv.Multiplos
                    VIEW-AS ALERT-BOX WARNING.
              APPLY 'ENTRY':U TO PEDI-1.CodMat.
            RETURN NO-APPLY.
         END.
    END.
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    x-CanPed = DEC(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    RUN vta2/PrecioContaMayorista (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        OUTPUT f-Factor,
                        Almmmatg.CodMat,
                        s-FlgSit,
                        PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        x-CanPed,
                        4,
                        ENTRY(1, s-CodAlm),
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos).
    DISPLAY 
        Y-DSCTOS @ PEDI-1.Por_Dsctos[3]
        F-PREVTA @ PEDI-1.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF PEDI-1.CanPed, PEDI-1.codmat, PEDI-1.PreUni
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Distribuye-por-almacenes B-table-Win 
PROCEDURE Distribuye-por-almacenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/i-pedmos-may-alm.i}

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
  DEFINE VARIABLE F-IGV AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL INIT 0 NO-UNDO.

  ASSIGN 
    F-ImpDes = 0
    F-ImpExo = 0
    F-ImpIgv = 0
    F-ImpIsc = 0
    F-ImpTot = 0
    F-TotBrt = 0
    F-ValVta = 0.
    /*F-PorDes = 0.*/
  FOR EACH B-PEDI-1:
    F-ImpTot = F-ImpTot + B-PEDI-1.ImpLin.
    F-Igv = F-Igv + B-PEDI-1.ImpIgv.
    F-Isc = F-Isc + B-PEDI-1.ImpIsc.
    /*F-ImpDes = F-ImpDes + B-PEDI-1.ImpDto.*/
    IF NOT B-PEDI-1.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDI-1.ImpLin.
    IF B-PEDI-1.AftIgv = YES
    THEN f-ImpDes = f-ImpDes + ROUND(B-PEDI-1.ImpDto / (1 + FacCfgGn.PorIgv / 100), 2).
    ELSE f-ImpDes = f-ImpDes + B-PEDI-1.ImpDto.
  END.
  F-ImpIgv = ROUND(F-Igv,2).
  F-ImpIsc = ROUND(F-Isc,2).
/*  F-TotBrt = F-ImpTot - F-ImpIgv - F-ImpIsc + F-ImpDes - F-ImpExo.
 *   F-ValVta = F-TotBrt -  F-ImpDes.*/
  F-ValVta = F-ImpTot - F-ImpExo - F-ImpIgv.
  F-TotBrt = F-ValVta + F-ImpIsc + F-ImpDes + F-ImpExo.
  DISPLAY F-ImpDes
        F-ImpExo
        F-ImpIgv
        F-ImpIsc
        F-ImpTot
        F-TotBrt
        F-ValVta WITH FRAME {&FRAME-NAME}.

END PROCEDURE.
/*
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
  IF FacCPedi.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2)
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
  END.
  FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  I-NroItm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-PEDI-1 BY B-PEDI-1.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-PEDI-1.NroItm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  I-NroItm = I-NroItm + 1.
  RUN Procesa-Handle IN lh_handle ('Disable-Head').
  s-registro-activo = YES.
  APPLY 'ENTRY':U TO PEDI-1.codmat IN BROWSE {&browse-name}.
  
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
      AND Almmmatg.codmat = PEDI-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
    PEDI-1.CodCia = S-CODCIA
    PEDI-1.Factor = F-FACTOR
    PEDI-1.NroItm = I-NroItm.
         
  ASSIGN 
    PEDI-1.UndVta = PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    PEDI-1.PreUni = DEC(PEDI-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.PorDto = F-Dsctos
    PEDI-1.PreBas = F-PreBas 
    PEDI-1.Por_Dsctos[1] = DEC(PEDI-1.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.Por_Dsctos[2] = DEC(PEDI-1.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.Por_Dsctos[3] = DEC(PEDI-1.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.AftIgv = ( IF s-CodIgv = 1 THEN Almmmatg.AftIgv ELSE NO )
    PEDI-1.AftIsc = Almmmatg.AftIsc.
  ASSIGN
      PEDI-1.ImpLin = PEDI-1.CanPed * PEDI-1.PreUni * 
                    ( 1 - PEDI-1.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[3] / 100 ).
  IF PEDI-1.Por_Dsctos[1] = 0 AND PEDI-1.Por_Dsctos[2] = 0 AND PEDI-1.Por_Dsctos[3] = 0 
      THEN PEDI-1.ImpDto = 0.
      ELSE PEDI-1.ImpDto = PEDI-1.CanPed * PEDI-1.PreUni - PEDI-1.ImpLin.
  ASSIGN
      PEDI-1.ImpLin = ROUND(PEDI-1.ImpLin, 2)
      PEDI-1.ImpDto = ROUND(PEDI-1.ImpDto, 2).
  IF PEDI-1.AftIsc 
  THEN PEDI-1.ImpIsc = ROUND(PEDI-1.PreBas * PEDI-1.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE PEDI-1.ImpIsc = 0.
  IF PEDI-1.AftIgv 
  THEN PEDI-1.ImpIgv = PEDI-1.ImpLin - ROUND(PEDI-1.ImpLin  / (1 + (s-PorIgv / 100)),4).
  ELSE PEDI-1.ImpIgv = 0.
  
  /* DISTRIBUYE LA CANTIDAD ENTRE LOS ALMACENES VALIDOS */
  RUN Distribuye-por-almacenes.

  /* RHC 13.05.2011 Margen de Utilidad */
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  FOR EACH PEDI:
      x-PreUni =  PEDI.ImpLin / PEDI.CanPed.
      RUN vtagn/p-margen-utilidad (
          PEDI.CodMat,          /* Producto */
          x-PreUni,             /* Precio de venta unitario */
          PEDI.UndVta,
          s-CodMon,             /* Moneda de venta */
          s-TpoCmb,             /* Tipo de cambio */
          YES,                  /* Muestra el error */
          PEDI.AlmDes,          /* Almacén de despacho */
          OUTPUT x-Margen,      /* Margen de utilidad */
          OUTPUT x-Limite,      /* Margen mínimo de utilidad */
          OUTPUT pError         /* Control de errores: "OK" "ADM-ERROR" */
          ).
      IF pError = "ADM-ERROR" THEN DO:
          UNDO, RETURN "ADM-ERROR".
      END.
  END.


  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  RUN Procesa-handle IN lh_handle ('Pinta-Resumen-Division').
  s-registro-activo = NO.

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
  s-registro-activo = NO.

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
  /* DETALLE POR PRODUCTO */
  FOR EACH PEDI WHERE PEDI.codmat = PEDI-1.codmat:
      DELETE PEDI.
  END.
  /* RESUMEN POR SEDE DE DESPACHO */
  EMPTY TEMP-TABLE PEDI-2.
  FOR EACH PEDI, FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = PEDI.AlmDes:
      FIND FIRST PEDI-2 WHERE PEDI-2.coddiv = Almacen.coddiv NO-ERROR.
      IF NOT AVAILABLE PEDI-2 THEN DO:
          CREATE PEDI-2.
          BUFFER-COPY PEDI
              EXCEPT PEDI.CodDiv PEDI.ImpLin
              TO PEDI-2
              ASSIGN PEDI-2.CodDiv = Almacen.coddiv.
      END.
      ASSIGN
          PEDI-2.ImpLin = PEDI-2.ImpLin + PEDI.ImpLin.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.
  RUN Procesa-handle IN lh_handle ('Pinta-Resumen-Division').

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
  IF AVAILABLE Almmmatg THEN
  FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.

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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH PEDI-1, FIRST Almmmatg OF PEDI-1 NO-LOCK:
    F-FACTOR = PEDI-1.Factor.
    x-CanPed = PEDI-1.CanPed.
    RUN vta2/PrecioContaMayorista (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        OUTPUT f-Factor,
                        PEDI-1.CodMat,
                        s-FlgSit,
                        PEDI-1.UndVta,
                        x-CanPed,
                        4,
                        ENTRY(1, s-codalm),
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos).
    /* RHC 13.05.2011 Caso especial si se despacha del almacén de remates */
    FIND FIRST PEDI WHERE PEDI.codmat = PEDI-1.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE PEDI THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = PEDI.AlmDes NO-LOCK.
        IF Almacen.Campo-C[3] = 'Si' 
            THEN RUN vta2/PrecioContaMayorista (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        OUTPUT f-Factor,
                        PEDI-1.CodMat,
                        s-FlgSit,
                        PEDI-1.UndVta,
                        x-CanPed,
                        4,
                        PEDI.AlmDes,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos).
    END.
    /* FIN REMATES *********************************************************** */
    ASSIGN 
        PEDI-1.PreUni = F-PREVTA
        PEDI-1.PreBas = F-PreBas 
        PEDI-1.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        PEDI-1.PorDto2 = 0        /* el precio unitario */
        PEDI-1.Por_Dsctos[2] = 0
        PEDI-1.Por_Dsctos[3] = Y-DSCTOS 
        PEDI-1.AftIgv = ( IF s-CodIgv = 1 THEN Almmmatg.AftIgv ELSE NO )
        PEDI-1.AftIsc = Almmmatg.AftIsc
        PEDI-1.ImpIsc = 0
        PEDI-1.ImpIgv = 0.
    ASSIGN
        PEDI-1.ImpLin = PEDI-1.CanPed * PEDI-1.PreUni * 
                    ( 1 - PEDI-1.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[3] / 100 ).
    IF PEDI-1.Por_Dsctos[1] = 0 AND PEDI-1.Por_Dsctos[2] = 0 AND PEDI-1.Por_Dsctos[3] = 0 
        THEN PEDI-1.ImpDto = 0.
    ELSE PEDI-1.ImpDto = PEDI-1.CanPed * PEDI-1.PreUni - PEDI-1.ImpLin.
    ASSIGN
        PEDI-1.ImpLin = ROUND(PEDI-1.ImpLin, 2)
        PEDI-1.ImpDto = ROUND(PEDI-1.ImpDto, 2).

   IF PEDI-1.AftIsc THEN 
      PEDI-1.ImpIsc = ROUND(PEDI-1.PreBas * PEDI-1.CanPed * (Almmmatg.PorIsc / 100),4).
   ELSE PEDI-1.ImpIsc = 0.
   IF PEDI-1.AftIgv THEN  
      PEDI-1.ImpIgv = PEDI-1.ImpLin - ROUND(PEDI-1.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
   ELSE PEDI-1.ImpIgv = 0.
END.
RUN Recalcular-Temporales.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-handle IN lh_handle ('Pinta-Resumen-Division').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Temporales B-table-Win 
PROCEDURE Recalcular-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH PEDI-1:
    FOR EACH PEDI WHERE PEDI.CodMat = PEDI-1.CodMat:
        ASSIGN
            PEDI.PreUni = PEDI-1.PreUni
            PEDI.PorDto = PEDI-1.PorDto
            PEDI.PreBas = PEDI-1.PreBas
            PEDI.Por_Dsctos[1] = PEDI-1.Por_Dsctos[1]
            PEDI.Por_Dsctos[2] = PEDI-1.Por_Dsctos[2]
            PEDI.Por_Dsctos[3] = PEDI-1.Por_Dsctos[3].
        ASSIGN
            PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                              ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                              ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                              ( 1 - PEDI.Por_Dsctos[3] / 100 ).
        IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
            THEN PEDI.ImpDto = 0.
        ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
        ASSIGN
            PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
            PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
        IF PEDI.AftIsc 
            THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
        IF PEDI.AftIgv 
            THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    END.
END.
/* RESUMEN POR SEDE DE DESPACHO */
EMPTY TEMP-TABLE PEDI-2.
FOR EACH PEDI, FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = PEDI.AlmDes:
    FIND PEDI-2 WHERE PEDI-2.coddiv = Almacen.coddiv NO-ERROR.
    IF NOT AVAILABLE PEDI-2 THEN DO:
        CREATE PEDI-2.
        BUFFER-COPY PEDI
            EXCEPT PEDI.CodDiv PEDI.ImpLin
            TO PEDI-2
            ASSIGN PEDI-2.coddiv = Almacen.coddiv.
    END.
    ASSIGN
        PEDI-2.ImpLin = PEDI-2.ImpLin + PEDI.ImpLin.
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
  {src/adm/template/snd-list.i "PEDI-1"}
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
  
  IF PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    OR INTEGER(PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.CodMat.
       RETURN "ADM-ERROR".
  END.
  FIND B-PEDI-1 WHERE B-PEDI-1.CODCIA = S-CODCIA 
    AND  B-PEDI-1.CodMat = PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    NO-LOCK NO-ERROR.
  IF AVAILABLE  B-PEDI-1 AND ROWID(B-PEDI-1) <> ROWID(PEDI-1) THEN DO:
       MESSAGE "Código de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* ARTICULO */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
  END.
  IF NOT (Almmmatg.TpoArt <= s-FlgRotacion) THEN DO:
      MESSAGE "Articulo no autorizado para venderse" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN DO:
      MESSAGE 'El producto pertenece a una familia NO autorizada para ventas'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami AND AlmSFami.SwDigesa = YES 
      AND (Almmmatg.VtoDigesa = ? OR Almmmatg.VtoDigesa < TODAY) THEN DO:
      MESSAGE 'La fecha de DIGESA ya venció o no se ha registrado su vencimiento' SKIP
          'Fecha:' Almmmatg.VtoDigesa
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* CANTIDAD */
  IF DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  /* EMPAQUE */
  DEF VAR f-Canped AS DEC NO-UNDO.
  IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
      f-CanPed = DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}).
      f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.CanEmp),0) * Almmmatg.CanEmp).
      IF f-CanPed <> DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) THEN DO:
          MESSAGE 'Solo puede vender en empaques de' Almmmatg.CanEmp
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO PEDI-1.CanPed.
          RETURN "ADM-ERROR".
      END.
  END.
  /* MINIMO DE VENTA */
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
      NO-LOCK NO-ERROR.
  f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
  IF s-FlgMinVenta = YES AND Almmmatg.DEC__03 > 0 THEN DO:
      f-CanPed = DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}).
      IF ( f-CanPed * f-Factor ) < Almmmatg.DEC__03 THEN DO:
          MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO PEDI-1.CanPed.
          RETURN "ADM-ERROR".
      END.
  END.

  /* PRECIO UNITARIO */
  IF DECIMAL(PEDI-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.PreUni.
       RETURN "ADM-ERROR".
  END.
  IF PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.

  /* STOCK COMPROMETIDO */
  DEF VAR s-StkComprometido AS DEC NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  RUN vtagn/Stock-Comprometido (PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}, 
                                s-codalm, 
                                OUTPUT s-StkComprometido).
  IF s-adm-new-record = 'NO' THEN DO:
      FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
          AND Facdpedi.coddoc = s-coddoc
          AND Facdpedi.nroped = s-nroped
          AND Facdpedi.codmat = PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
          NO-LOCK NO-ERROR.
      IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ).
  END.
  ASSIGN
      x-CanPed = DEC(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor
      x-StkAct = 0.
  FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
      AND LOOKUP(Almacen.codalm, s-CodAlm) > 0:
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = Almacen.codalm
          AND Almmmate.codmat = PEDI-1.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmate THEN x-StkAct = x-StkAct + Almmmate.StkAct.
  END.
  IF (x-StkAct - s-StkComprometido) < x-CanPed
      THEN DO:
        MESSAGE "No hay STOCK suficiente" SKIP(1)
                "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP
                "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP
                "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP
                VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO PEDI-1.CodMat.
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

MESSAGE 'Haga los cambios necesarios en el DETALLE POR PRODUCTO Y ALMACEN'
    VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

