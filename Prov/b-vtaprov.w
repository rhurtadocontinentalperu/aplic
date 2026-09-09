&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE INTEGRAL.FacDPedi.
DEFINE SHARED TEMP-TABLE T-MATPRO LIKE INTEGRAL.Almmmatg
       FIELD PreUni AS DEC
       FIELD CanPed AS DEC
       FIELD PorDto AS DEC EXTENT 4
       FIELD ClfCli AS CHAR
       FIELD ImpTot AS DEC
       FIELD StkAct AS DEC.


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
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-tpocmb AS DEC.
DEF SHARED VAR X-NRODEC AS INTEGER INIT 2.

DEF VAR x-Moneda AS CHAR FORMAT 'x(3)'.
DEF VAR pv-codcia AS INT NO-UNDO.
DEF VAR cl-codcia AS INT NO-UNDO.
DEF VAR s-codpro LIKE Gn-prov.codpro NO-UNDO.

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

RUN Inicializa-Temporal.

/* Calculo de Precios */
DEF VAR f-Dsctos AS DEC DECIMALS 6 NO-UNDO.
DEF VAR f-PreVta AS DEC DECIMALS 6 NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

DEF BUFFER B-MATPRO FOR T-MATPRO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-MATPRO

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATPRO.codmat T-MATPRO.DesMat T-MATPRO.DesMar T-MATPRO.UndBas (IF T-MATPRO.MonVta = 2 THEN 'US$' ELSE 'S/.') @ x-Moneda T-MATPRO.PreUni T-MATPRO.PorDto[1] T-MATPRO.PorDto[2] T-MATPRO.PorDto[3] T-MATPRO.PorDto[4] T-MATPRO.CanPed T-MATPRO.ImpTot T-MATPRO.StkAct T-MATPRO.CanEmp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATPRO.CanPed   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CanPed ~{&FP2}CanPed ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATPRO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATPRO
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH T-MATPRO WHERE ~{&KEY-PHRASE} NO-LOCK     BY T-MATPRO.DesMat.
&Scoped-define TABLES-IN-QUERY-br_table T-MATPRO
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATPRO


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-ClfCli x-CodPro BUTTON-9 x-DesMar x-CodFam ~
x-SubFam br_table 
&Scoped-Define DISPLAYED-OBJECTS x-ClfCli x-CodPro x-DesMar x-CodFam ~
x-DesFam x-SubFam x-DesSub x-ImpTot 

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
DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "adeicon\filter-u":U
     IMAGE-DOWN FILE "adeicon\filter-d":U
     IMAGE-INSENSITIVE FILE "adeicon\filter-i":U
     LABEL "Button 9" 
     SIZE 6 BY 1.54 TOOLTIP "Filtrar Catalogo".

DEFINE VARIABLE x-ClfCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clasificacion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "A","B","C","D","E" 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccion Proveedor" 
     LABEL "Proveedor" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Seleccion Proveedor" 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-DesMar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 1 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-MATPRO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-MATPRO.codmat COLUMN-LABEL "Articulo"
      T-MATPRO.DesMat FORMAT "X(60)"
      T-MATPRO.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)"
      T-MATPRO.UndBas COLUMN-LABEL "Unidad"
      (IF T-MATPRO.MonVta = 2 THEN 'US$' ELSE 'S/.') @ x-Moneda COLUMN-LABEL 'Moneda'
      T-MATPRO.PreUni COLUMN-LABEL "Pre.Uni." FORMAT ">>>>9.99" COLUMN-BGCOLOR 11
      T-MATPRO.PorDto[1] COLUMN-LABEL "%1" FORMAT ">9.9999" COLUMN-BGCOLOR 14
      T-MATPRO.PorDto[2] COLUMN-LABEL "%2" FORMAT ">9.9999" COLUMN-BGCOLOR 14
      T-MATPRO.PorDto[3] COLUMN-LABEL "%3" FORMAT ">9.9999" COLUMN-BGCOLOR 14
      T-MATPRO.PorDto[4] COLUMN-LABEL "%4" FORMAT ">9.9999" COLUMN-BGCOLOR 14
      T-MATPRO.CanPed COLUMN-LABEL "Cantidad" FORMAT ">>>>>9.99"
      T-MATPRO.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>>>9.99"
      T-MATPRO.StkAct COLUMN-LABEL "Stock"   FORMAT "->>>>>9.99" COLUMN-BGCOLOR 10
      T-MATPRO.CanEmp COLUMN-LABEL "Empaque" FORMAT ">>,>>9.99"
  ENABLE
      T-MATPRO.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 136 BY 14.42
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-ClfCli AT ROW 1.19 COL 11 COLON-ALIGNED
     x-CodPro AT ROW 2.15 COL 11 COLON-ALIGNED
     BUTTON-9 AT ROW 2.92 COL 76
     x-DesMar AT ROW 3.12 COL 11 COLON-ALIGNED
     x-CodFam AT ROW 4.08 COL 11 COLON-ALIGNED
     x-DesFam AT ROW 4.08 COL 23 COLON-ALIGNED NO-LABEL
     x-SubFam AT ROW 5.04 COL 11 COLON-ALIGNED
     x-DesSub AT ROW 5.04 COL 23 COLON-ALIGNED NO-LABEL
     br_table AT ROW 6.19 COL 1
     x-ImpTot AT ROW 20.62 COL 105 COLON-ALIGNED
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
      TABLE: T-MATPRO T "SHARED" ? INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          FIELD PreUni AS DEC
          FIELD CanPed AS DEC
          FIELD PorDto AS DEC EXTENT 4
          FIELD ClfCli AS CHAR
          FIELD ImpTot AS DEC
          FIELD StkAct AS DEC
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 21.04
         WIDTH              = 140.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br_table x-DesSub F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH T-MATPRO WHERE ~{&KEY-PHRASE} NO-LOCK
    BY T-MATPRO.DesMat.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "Temp-Tables.T-MATPRO.DesMat|yes"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 B-table-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
  ASSIGN
    x-ClfCli x-CodFam x-CodPro x-DesMar x-DesFam x-DesSub x-SubFam /*x-NomPro*/.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-ClfCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-ClfCli B-table-Win
ON VALUE-CHANGED OF x-ClfCli IN FRAME F-Main /* Clasificacion */
DO:
  IF x-ClfCli <> SELF:SCREEN-VALUE 
  THEN DO:
    ASSIGN x-ClfCli.
    RUN Carga-Temporal-Clf.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam B-table-Win
ON LEAVE OF x-CodFam IN FRAME F-Main /* Familia */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Almtfami WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtfami THEN DO:
    MESSAGE 'Códio de familia no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  x-DesFam:SCREEN-VALUE = Almtfami.desfam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro B-table-Win
ON VALUE-CHANGED OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  s-codpro = SUBSTRING(SELF:SCREEN-VALUE,1, 11).
/*  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
 *     AND Gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
 *   IF AVAILABLE gn-prov THEN x-NomPro:SCREEN-VALUE = Gn-prov.nompro.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-SubFam B-table-Win
ON LEAVE OF x-SubFam IN FRAME F-Main /* Sub-Familia */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Almsfami WHERE Almsfami.codcia = s-codcia
    AND Almsfami.codfam = x-codfam:SCREEN-VALUE  
    AND Almsfami.subfam = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almsfami THEN DO:
    MESSAGE 'Código de sub-familia no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  x-DesSub:SCREEN-VALUE = AlmSFami.dessub.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON LEAVE, RETURN OF T-MATPRO.CanPed DO:
    F-DSCTOS = (1 - (1 - T-MATPRO.PorDto[1] / 100) * 
                 (1 - T-MATPRO.PorDto[2] / 100) * 
                 (1 - T-MATPRO.PorDto[3] / 100) * 
                 (1 - T-MATPRO.PorDto[4] / 100) ) * 100.
    F-PREVTA = T-MATPRO.PreUni * (1 - F-DSCTOS / 100).
    /*RUN BIN/_ROUND1(F-PREVTA,2,OUTPUT F-PREVTA).*/
    T-MATPRO.ImpTot = ROUND( f-PreVta * T-MATPRO.CanPed , 2).
    DISPLAY T-MATPRO.ImpTot WITH BROWSE {&BROWSE-NAME}.
    RUN Totales.
END.
/*
        F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).
        RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Clasificacion B-table-Win 
PROCEDURE Actualiza-Clasificacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-MATPRO:
    T-MATPRO.ClfCli = x-ClfCli.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DISPLAY 'Cargando Información' SKIP 'Un momento por favor...'
    WITH FRAME F-Mensaje OVERLAY CENTERED VIEW-AS DIALOG-BOX
    NO-LABELS.  

  FOR EACH T-MATPRO:
    DELETE T-MATPRO.
  END.

  /* PRODUCTOS Y DESCUENTOS */
  FOR EACH Facctmat NO-LOCK WHERE Facctmat.codcia = s-codcia,
        FIRST Almmmatg OF Facctmat NO-LOCK WHERE Almmmatg.codpr1 = s-codpro
            AND Almmmatg.codfam BEGINS x-codfam
            AND Almmmatg.subfam BEGINS x-subfam,
        FIRST Facctpro NO-LOCK WHERE Facctpro.codcia = Facctmat.codcia
            AND Facctpro.codpro = s-codpro
            AND Facctpro.categoria = Facctmat.categoria:
    CREATE T-MATPRO.
    BUFFER-COPY Almmmatg TO T-MATPRO
        ASSIGN
            T-MATPRO.MonVta = s-CodMon.
    FIND PEDI WHERE PEDI.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE PEDI THEN T-MATPRO.CanPed = PEDI.CanPed.   /* OJO */
    CASE x-ClfCli:
        WHEN 'A' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[1]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[2]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[3]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[4].
        WHEN 'B' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[5]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[6]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[7]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[8].
        WHEN 'C' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[9]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[10]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[11]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[12].
        WHEN 'D' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[13]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[14]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[15]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[16].
        WHEN 'E' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[17]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[18]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[19]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[20].
    END CASE.
  END.
  /* PRECIOS Y STOCKS */
  f-Factor = 1.
  FIND LAST PEDI NO-LOCK NO-ERROR.
  IF AVAILABLE PEDI THEN FIND NEXT PEDI NO-LOCK NO-ERROR.
  FOR EACH T-MATPRO, 
        FIRST Almmmatg OF T-MATPRO NO-LOCK, 
        FIRST Facctmat OF T-MATPRO NO-LOCK:
    /* definimos el precio base */
    FIND FIRST Lg-dmatpr WHERE Lg-dmatpr.codcia = s-codcia
        AND Lg-dmatpr.codmat = Almmmatg.codmat
        AND Lg-dmatpr.codpro = Almmmatg.CodPr1
        AND Lg-dmatpr.flgest = 'A'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Lg-dmatpr THEN DO:
        IF S-CODMON = 1 THEN DO:
            IF Almmmatg.MonVta = 1 THEN
                ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * F-FACTOR.
            ELSE
                ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * S-TpoCmb * F-FACTOR.
        END.
        IF S-CODMON = 2 THEN DO:
           IF Almmmatg.MonVta = 2 THEN
              ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * F-FACTOR.
           ELSE
              ASSIGN F-PREBAS = (Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) / S-TpoCmb) * F-FACTOR.
        END.
        T-MATPRO.PreUni = f-PreBas.
    END.
    F-DSCTOS = (1 - (1 - T-MATPRO.PorDto[1] / 100) * 
                 (1 - T-MATPRO.PorDto[2] / 100) * 
                 (1 - T-MATPRO.PorDto[3] / 100) * 
                 (1 - T-MATPRO.PorDto[4] / 100) ) * 100.
    F-PREVTA = T-MATPRO.PreUni * (1 - F-DSCTOS / 100).
    RUN BIN/_ROUND1(F-PREVTA,2,OUTPUT F-PREVTA).
    T-MATPRO.ImpTot = ROUND( f-PreVta * T-MATPRO.CanPed , 2).
    
    /* STOCKS */
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = '11'
        AND Almmmate.codmat = T-MATPRO.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN T-MATPRO.StkAct = T-MATPRO.StkAct + Almmmate.stkact.
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = '04'
        AND Almmmate.codmat = T-MATPRO.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN T-MATPRO.StkAct = T-MATPRO.StkAct + Almmmate.stkact.
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = '15'
        AND Almmmate.codmat = T-MATPRO.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN T-MATPRO.StkAct = T-MATPRO.StkAct + Almmmate.stkact.
  END.
  HIDE FRAME F-Mensaje.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END PROCEDURE.

/* ***********************

    {vta/preciovt.i}
    
/*    /* definimos el precio base */
 *     FIND FIRST Lg-dmatpr WHERE Lg-dmatpr.codcia = s-codcia
 *         AND Lg-dmatpr.codmat = Almmmatg.codmat
 *         AND Lg-dmatpr.codpro = Almmmatg.CodPr1
 *         AND Lg-dmatpr.flgest = 'A'
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE Lg-dmatpr THEN DO:
 *         IF S-CODMON = 1 THEN DO:
 *             IF Almmmatg.MonVta = 1 THEN
 *                 ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * F-FACTOR.
 *             ELSE
 *                 ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * S-TpoCmb * F-FACTOR.
 *         END.
 *         IF S-CODMON = 2 THEN DO:
 *            IF Almmmatg.MonVta = 2 THEN
 *               ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * F-FACTOR.
 *            ELSE
 *               ASSIGN F-PREBAS = (Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) / S-TpoCmb) * F-FACTOR.
 *         END.
 *     END.
 *     /* Definimos los descuentos */
 *     FIND Facctpro WHERE Facctpro.codcia = s-codcia
 *         AND Facctpro.codpro = Almmmatg.codpr1
 *         AND FAcctpro.categoria = Facctmat.categoria
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE Facctpro 
 *     THEN DO:
 *         IF AVAILABLE PEDI AND PEDI.FlgEst <> '' THEN x-ClfCli = PEDI.FlgEst.
 *         CASE x-ClfCli:
 *         WHEN 'A' THEN F-DSCTOS = (1 - (1 - Facctpro.dsctos[1] / 100) * (1 - Facctpro.Dsctos[2] / 100) * (1 - Facctpro.Dsctos[3] / 100) * (1 - Facctpro.Dsctos[4] / 100) ) * 100.
 *         WHEN 'B' THEN F-DSCTOS = (1 - (1 - Facctpro.dsctos[5] / 100) * (1 - Facctpro.Dsctos[6] / 100) * (1 - Facctpro.Dsctos[7] / 100) * (1 - Facctpro.Dsctos[8] / 100) ) * 100.
 *         WHEN 'C' THEN F-DSCTOS = (1 - (1 - Facctpro.dsctos[9] / 100) * (1 - Facctpro.Dsctos[10] / 100) * (1 - Facctpro.Dsctos[11] / 100) * (1 - Facctpro.Dsctos[12] / 100) ) * 100.
 *         OTHERWISE F-DSCTOS = (1 - (1 - Facctpro.dsctos[9] / 100) * (1 - Facctpro.Dsctos[10] / 100) * (1 - Facctpro.Dsctos[11] / 100) * (1 - Facctpro.Dsctos[12] / 100) ) * 100.
 *         END CASE.
 *     END.
 *     F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).
 *     RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).*/
    
    T-MATPRO.PreUni = f-PreBas.
    T-MATPRO.ImpTot = ROUND( f-PreVta * T-MATPRO.CanPed , 2).

/*    FIND FIRST Lg-dmatpr WHERE Lg-dmatpr.codcia = s-codcia
 *         AND Lg-dmatpr.codmat = T-MATPRO.codmat
 *         AND Lg-dmatpr.codpro = s-CodPro
 *         AND Lg-dmatpr.flgest = 'A'
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE Lg-dmatpr AND Lg-dmatpr.PreAct > 0
 *     THEN ASSIGN
 *             T-MATPRO.PreUni = ROUND(Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100), 2)
 *             F-DSCTOS = (1 - ROUND( (1 - T-MATPRO.PorDto[1] / 100) * 
 *                         (1 - T-MATPRO.PorDto[2] / 100) * 
 *                         (1 - T-MATPRO.PorDto[3] / 100) * 
 *                         (1 - T-MATPRO.PorDto[4] / 100) , 2) ) * 100
 *             F-PREVTA = ROUND(T-MATPRO.PreUni * (1 - F-DSCTOS / 100), 2)
 *             T-MATPRO.ImpTot = ROUND( f-PreVta * T-MATPRO.CanPed , 2).
 *     ELSE DELETE T-MATPRO.*/


************************* */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Clf B-table-Win 
PROCEDURE Carga-Temporal-Clf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-MATPRO,
        FIRST Facctmat OF T-MATPRO NO-LOCK,
        FIRST Facctpro NO-LOCK WHERE Facctpro.codcia = Facctmat.codcia
            AND Facctpro.codpro = s-codpro
            AND Facctpro.categoria = Facctmat.categoria:
    CASE x-ClfCli:
        WHEN 'A' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[1]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[2]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[3]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[4].
        WHEN 'B' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[5]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[6]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[7]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[8].
        WHEN 'C' 
            THEN ASSIGN
                    T-MATPRO.PorDto[1] = Facctpro.Dsctos[9]
                    T-MATPRO.PorDto[2] = Facctpro.Dsctos[10]
                    T-MATPRO.PorDto[3] = Facctpro.Dsctos[11]
                    T-MATPRO.PorDto[4] = Facctpro.Dsctos[12].
    END CASE.
    F-DSCTOS = (1 - (1 - T-MATPRO.PorDto[1] / 100) * 
                 (1 - T-MATPRO.PorDto[2] / 100) * 
                 (1 - T-MATPRO.PorDto[3] / 100) * 
                 (1 - T-MATPRO.PorDto[4] / 100) ) * 100.
    F-PREVTA = T-MATPRO.PreUni * (1 - F-DSCTOS / 100).
    /*RUN BIN/_ROUND1(F-PREVTA,2,OUTPUT F-PREVTA).*/
    T-MATPRO.ImpTot = ROUND( f-PreVta * T-MATPRO.CanPed , 2).
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Temporal B-table-Win 
PROCEDURE Inicializa-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-MATPRO:
    DELETE T-MATPRO.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND Gn-Clie WHERE Gn-clie.codcia = cl-codcia 
    AND Gn-clie.codcli = s-codcli NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Clie THEN x-ClfCli = 'C'.
  IF AVAILABLE Gn-clie THEN DO:
    IF LOOKUP(Gn-clie.clfcli, 'A,B,C,D,E') > 0 THEN x-ClfCli = gn-clie.clfCli.
    ELSE x-ClfCli = 'C'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Facctpro NO-LOCK WHERE FacCtPro.CodCia = s-codcia,
        FIRST Gn-prov WHERE Gn-prov.codcia = pv-codcia 
            AND Gn-prov.codpro = Facctpro.codpro
        BREAK BY FacCtPro.CodPro:
        IF FIRST-OF(FacCtPro.CodPro)
        THEN x-CodPro:ADD-LAST(STRING(FacCtPro.CodPro, 'x(11)') + Gn-prov.nompro).
    END.
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
  RUN Totales.

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
        WHEN "x-subfam" THEN 
            ASSIGN
                input-var-1 = x-codfam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-MATPRO"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  x-ImpTot = 0.
  FOR EACH B-MATPRO:
    x-ImpTot = x-ImpTot + B-MATPRO.ImpTot.
  END.
  DISPLAY x-ImpTot WITH FRAME {&FRAME-NAME}.
  
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


