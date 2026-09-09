&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDM LIKE INTEGRAL.FacDPedm
       INDEX Llave01 CodCia CodDoc NroPed NroItm.


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

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CODMAT AS CHAR NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.
DEFINE BUFFER B-PEDM FOR PEDM.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

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
&Scoped-define INTERNAL-TABLES PEDM Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDM.NroItm PEDM.codmat ~
Almmmatg.DesMat Almmmatg.DesMar PEDM.UndVta PEDM.AlmDes PEDM.CanPed ~
PEDM.PorDto PEDM.PreUni PEDM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDM.codmat 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}codmat ~{&FP2}codmat ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDM
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF PEDM NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table PEDM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDM


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 br_table 
&Scoped-Define DISPLAYED-OBJECTS F-PorDes F-TotBrt F-ImpExo F-ImpDes ~
F-ValVta F-ImpIsc F-ImpIgv F-ImpTot 

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

DEFINE VARIABLE F-PorDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY 9.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDM, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDM.NroItm COLUMN-LABEL "No" FORMAT ">>>9"
      PEDM.codmat COLUMN-LABEL "Articulo" FORMAT "X(17)"
      Almmmatg.DesMat
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(12)"
      PEDM.UndVta COLUMN-LABEL "Undidad" FORMAT "x(10)"
      PEDM.AlmDes COLUMN-LABEL "Alm!Des"
      PEDM.CanPed FORMAT ">>,>>9.99"
      PEDM.PorDto FORMAT "->>9.99"
      PEDM.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999"
      PEDM.ImpLin FORMAT ">,>>>,>>9.99"
  ENABLE
      PEDM.codmat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 106 BY 7.12
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.38 COL 2
     F-PorDes AT ROW 9.65 COL 7 COLON-ALIGNED NO-LABEL
     F-TotBrt AT ROW 9.65 COL 20.86 NO-LABEL
     F-ImpExo AT ROW 9.65 COL 32.86 NO-LABEL
     F-ImpDes AT ROW 9.69 COL 42.86 COLON-ALIGNED NO-LABEL
     F-ValVta AT ROW 9.65 COL 55 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 9.65 COL 67.72 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 9.65 COL 80.29 COLON-ALIGNED NO-LABEL
     F-ImpTot AT ROW 9.65 COL 92.86 COLON-ALIGNED NO-LABEL
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 9.08 COL 33.29
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.08 COL 10.86
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.12 COL 58.72
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 9.08 COL 85
     "F11 => Ingresar Cantidad" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 8.5 COL 2
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 9.08 COL 73.43
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.08 COL 22.72
     RECT-1 AT ROW 1 COL 1
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 9.12 COL 45.43
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 9.08 COL 95
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
      TABLE: PEDM T "SHARED" ? INTEGRAL FacDPedm
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCia CodDoc NroPed NroItm
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
         HEIGHT             = 9.62
         WIDTH              = 108.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table TEXT-8 F-Main */
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
/* SETTINGS FOR FILL-IN F-PorDes IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDM,INTEGRAL.Almmmatg OF Temp-Tables.PEDM"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.PEDM.NroItm
"PEDM.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.PEDM.codmat
"PEDM.codmat" "Articulo" "X(17)" "character" ? ? ? ? ? ? yes ?
     _FldNameList[3]   = integral.Almmmatg.DesMat
     _FldNameList[4]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(12)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.PEDM.UndVta
"PEDM.UndVta" "Undidad" "x(10)" "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > Temp-Tables.PEDM.AlmDes
"PEDM.AlmDes" "Alm!Des" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[7]   > Temp-Tables.PEDM.CanPed
"PEDM.CanPed" ? ">>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[8]   > Temp-Tables.PEDM.PorDto
"PEDM.PorDto" ? "->>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[9]   > Temp-Tables.PEDM.PreUni
"PEDM.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[10]   > Temp-Tables.PEDM.ImpLin
"PEDM.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
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
  DISPLAY I-NroItm @ PEDM.NroItm WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME PEDM.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDM.codmat br_table _BROWSE-COLUMN B-table-Win
ON F11 OF PEDM.codmat IN BROWSE br_table /* Articulo */
DO:
 RUN vta/D-VTAAUT(OUTPUT x-codmat, OUTPUT x-canped).
 IF X-CODMAT <> ? AND X-CANPED > 0 THEN DO:
  DISPLAY x-codmat @ PEDM.Codmat
          WITH BROWSE {&BROWSE-NAME}.
  APPLY "RETURN" TO PEDM.CodMat IN BROWSE {&BROWSE-NAME}.   
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDM.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) <= 6 THEN DO: 
        ASSIGN
            SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
            NO-ERROR.
    END.
   IF LENGTH(SELF:SCREEN-VALUE) > 6 THEN DO: 
      FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                     AND  Almmmatg.CodBrr = SELF:SCREEN-VALUE 
                     NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN DO:
         MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
      SELF:SCREEN-VALUE = Almmmatg.CodMat.
   END.
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.TpoArt <> "A" THEN DO:
       MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    /* Valida Maestro Productos x Almacen */
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = trim(S-CODALM) 
        AND Almmmate.CodMat = trim(SELF:SCREEN-VALUE) 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no esta asignado al" SKIP
               "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.   
    END.

    /****    Selecciona las unidades de medida   ****/
   IF Almmmatg.UndAlt[1] = "" THEN DO:
      MESSAGE "Articulo no tiene Unidad de Venta"
              VIEW-AS ALERT-BOX ERROR.
      PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "".
      RETURN NO-APPLY.
   END.
   Output-Var-2 = Almmmatg.UndAlt[1].   /* OJO */
    FIND Almtconv WHERE 
         Almtconv.CodUnid = Almmmatg.UndBas AND  
         Almtconv.Codalter = output-var-2 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN
       F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    ELSE DO:
         MESSAGE "Equivalencia no Registrado"
                 VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO PEDM.CodMat IN BROWSE {&BROWSE-NAME}.
         RETURN NO-APPLY.
    END.
    /************************************************/
    ASSIGN 
        S-UNDBAS = Almmmatg.UndBas
        F-CanPed = 1.
    IF x-CanPed > 0 AND X-CanPed <> F-CanPed THEN F-CanPed = X-CanPed.
    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        f-CanPed @ PEDM.CanPed
        output-var-2 @ PEDM.UndVta
        s-codalm @ PEDM.AlmDes
        F-DSCTOS @ PEDM.PorDto
        F-PREVTA @ PEDM.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
    RUN vta/PrecioTienda (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        f-Factor,
                        Almmmatg.CodMat,
                        PEDM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        f-CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT SW-LOG1).
    DISPLAY 
        F-DSCTOS @ PEDM.PorDto
        F-PREVTA @ PEDM.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDM.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDM.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PEDM.AlmDes IN BROWSE br_table /* Alm!Des */
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN lkup/c-uniabc ("Unidades de Venta",
                        Almmmate.CodMat
                        ).
    IF output-var-2 = ? THEN DO:
        APPLY 'ENTRY':U TO PEDM.codmat IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
    END.
    F-Factor = 1.
    FIND Almtconv WHERE 
         Almtconv.CodUnid = Almmmatg.UndBas AND  
         Almtconv.Codalter = output-var-2 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN  F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    ELSE DO:
         MESSAGE "Equivalencia no Registrado"
                 VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO PEDM.CodMat IN BROWSE {&BROWSE-NAME}.
         RETURN NO-APPLY.
    END.
    /************************************************/
    ASSIGN 
        S-UNDBAS = Almmmatg.UndBas
        X-CANPED = 1
        F-PreBas = output-var-4
        F-PreVta = output-var-4
        F-Dsctos = ABSOLUTE(output-var-5)
        /*F-Dsctos = output-var-5*/
        Y-Dsctos = 0.
    DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
            Almmmatg.DesMar @ Almmmatg.DesMar 
            output-var-2 @ PEDM.UndVta
            s-codalm @ PEDM.AlmDes
            F-DSCTOS @ PEDM.PorDto
            F-PREVTA @ PEDM.PreUni 
            WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDM.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDM.AlmDes IN BROWSE br_table /* Alm!Des */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Almacen WHERE Almacen.CodCia = S-CodCia 
        AND Almacen.CodAlm = PEDM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO PEDM.AlmDes IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
    END.
    IF NOT Almacen.AutMov THEN DO:
       MESSAGE "Almacen no Autorizado para Movimientos" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO PEDM.AlmDes IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
    END.
    /* Almacenes autorizados */
/*    IF LOOKUP(TRIM(PEDM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), "03A,04,04A,05A,19") = 0 
 *     THEN DO:
 *        IF S-CODALM <> PEDM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} THEN DO:
 *          MESSAGE "Almacen NO Autorizado para Ventas" VIEW-AS ALERT-BOX ERROR.
 *          APPLY "ENTRY" TO PEDM.AlmDes IN BROWSE {&BROWSE-NAME}.
 *          RETURN NO-APPLY.
 *        END.  
 *     END.*/
    /* RHC 13.03.06 */
    DEF VAR x-AlmValido AS CHAR NO-UNDO.
    x-AlmValido = "03A,04,04A,05A,19".
    IF s-codalm <> SELF:SCREEN-VALUE THEN DO:
        CASE s-coddiv:
            WHEN '00001' THEN x-AlmValido = x-AlmValido + ',19B'.
            WHEN '00003' THEN x-AlmValido = x-AlmValido + ',19D'.
            WHEN '00014' THEN x-AlmValido = x-AlmValido + ',19E'.
            WHEN '00008' THEN x-AlmValido = x-AlmValido + ',19F'.
        END CASE.
        IF LOOKUP(TRIM(SELF:SCREEN-VALUE), x-AlmValido) = 0 THEN DO:
            MESSAGE 'Almacen NO AUTORIZADO para ventas' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO PEDM.AlmDes IN BROWSE {&BROWSE-NAME}.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDM.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDM.CanPed IN BROWSE br_table /* Cantidad */
DO:
    FIND Almtconv WHERE 
         Almtconv.CodUnid  = Almmmatg.UndBas AND  
         Almtconv.Codalter = PEDM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO PEDM.CodMat IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
    END.
    IF Almtconv.Multiplos <> 0 THEN DO:
         IF DEC(PEDM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
            INT(DEC(PEDM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
            MESSAGE " La Cantidad debe de ser un, " SKIP
                    " multiplo de : " Almtconv.Multiplos
                    VIEW-AS ALERT-BOX WARNING.
              APPLY 'ENTRY':U TO PEDM.CodMat.
            RETURN NO-APPLY.
         END.
    END.
    x-CanPed = DEC(PEDM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    RUN vta/PrecioConta (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        f-Factor,
                        Almmmatg.CodMat,
                        PEDM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        x-CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT SW-LOG1).

    DISPLAY 
        F-DSCTOS @ PEDM.PorDto
        F-PREVTA @ PEDM.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDM.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDM.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDM.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
    IF F-PREVTA > DEC(PEDM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
       MESSAGE "No Autorizado para modificar Precio " 
       VIEW-AS ALERT-BOX ERROR.
       DISPLAY F-PREVTA @ PEDM.PreUni WITH BROWSE {&BROWSE-NAME}.
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

ON RETURN OF PEDM.AlmDes, PEDM.CanPed, PEDM.codmat, PEDM.PreUni DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    F-ValVta = 0
    F-PorDes = 0.
  FOR EACH B-PEDM:
    F-ImpTot = F-ImpTot + B-PEDM.ImpLin.
    F-Igv = F-Igv + B-PEDM.ImpIgv.
    F-Isc = F-Isc + B-PEDM.ImpIsc.
    F-ImpDes = F-ImpDes + B-PEDM.ImpDto.
    IF NOT B-PEDM.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDM.ImpLin.
  END.
  F-ImpIgv = ROUND(F-Igv,2).
  F-ImpIsc = ROUND(F-Isc,2).
  F-TotBrt = F-ImpTot - F-ImpIgv - F-ImpIsc + F-ImpDes - F-ImpExo.
  F-ValVta = F-TotBrt -  F-ImpDes.
  DISPLAY F-ImpDes
        F-ImpExo
        F-ImpIgv
        F-ImpIsc
        F-ImpTot
        F-TotBrt
        F-ValVta WITH FRAME {&FRAME-NAME}.

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
  I-NroItm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-PEDM BY B-PEDM.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-PEDM.NroItm.
  END.
  IF (N-ITMS + 1) > FacCfgGn.Items_PedMos THEN DO:
     MESSAGE "El Numero de PEDMs No Puede Ser Mayor a " FacCfgGn.Items_PedMos 
             VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  I-NroItm = I-NroItm + 1.
  x-CanPed = 1.             /* OJO */
  RUN Procesa-Handle IN lh_handle ('Disable-Head').
  
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
    PEDM.CodCia = S-CODCIA
    PEDM.Factor = F-FACTOR
    PEDM.NroItm = I-NroItm
    PEDM.AlmDes = s-CodAlm.
         
  ASSIGN 
    PEDM.PreBas = F-PreBas 
    PEDM.AftIgv = Almmmatg.AftIgv 
    PEDM.AftIsc = Almmmatg.AftIsc 
    PEDM.Flg_factor = IF SW-LOG1 THEN "1" ELSE "0"   /* Add by C.Q. 23/03/2000 */
    PEDM.CanPed = DEC(PEDM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDM.PreUni = DEC(PEDM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDM.PorDto = DEC(PEDM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    /*PEDM.Por_Dsctos[1] = DEC(PEDM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})    /* Add by C.Q. 23/03/2000 */ */
    PEDM.Por_DSCTOS[2] = Almmmatg.PorMax    /* Add by C.Q. 23/03/2000 */
    PEDM.Por_Dsctos[3] = Y-DSCTOS
    PEDM.ImpDto = ROUND( PEDM.PreUni * (PEDM.Por_Dsctos[1] / 100) * (IF SW-LOG1 THEN PEDM.CanPed ELSE (PEDM.CanPed * F-FACTOR)), 2 )
    PEDM.ImpLin = ROUND( PEDM.PreUni * (IF SW-LOG1 THEN PEDM.CanPed ELSE (PEDM.CanPed * F-FACTOR)) , 2 ) - PEDM.ImpDto.
    PEDM.UndVta = PEDM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  IF PEDM.AftIsc 
  THEN PEDM.ImpIsc = ROUND(PEDM.PreBas * (IF SW-LOG1 THEN PEDM.CanPed ELSE (PEDM.CanPed * F-FACTOR)) * (Almmmatg.PorIsc / 100),4).
  IF PEDM.AftIgv 
  THEN PEDM.ImpIgv = PEDM.ImpLin - ROUND(PEDM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

/*  IF PEDM.AftIsc 
 *   THEN PEDM.ImpIsc = ROUND(PEDM.PreBas * PEDM.CanPed * (Almmmatg.PorIsc / 100),4).
 *   IF PEDM.AftIgv 
 *   THEN  PEDM.ImpIgv = PEDM.ImpLin - ROUND(PEDM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
 * */

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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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
  FOR EACH B-PEDM:
    F-FACTOR = B-PEDM.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = B-PEDM.CODCIA AND  
         Almmmatg.codmat = B-PEDM.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        x-CanPed = B-PEDM.CanPed.
        RUN vta/PrecioTienda (s-CodCia,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            s-TpoCmb,
                            f-Factor,
                            Almmmatg.CodMat,
                            B-PEDM.UndVta,
                            x-CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT SW-LOG1).

        ASSIGN 
            B-PEDM.PreBas = F-PreBas 
            B-PEDM.AftIgv = Almmmatg.AftIgv 
            B-PEDM.AftIsc = Almmmatg.AftIsc
            B-PEDM.PreUni = F-PREVTA
            B-PEDM.PorDto = F-DSCTOS
            B-PEDM.Por_Dsctos[2] = Almmmatg.PorMax
            B-PEDM.Por_Dsctos[3] = Y-DSCTOS 
            B-PEDM.ImpDto = ROUND( B-PEDM.PreBas * (F-DSCTOS / 100) * B-PEDM.CanPed , 2).
            B-PEDM.ImpLin = ROUND( B-PEDM.PreUni * B-PEDM.CanPed , 2 ).
       IF B-PEDM.AftIsc THEN 
          B-PEDM.ImpIsc = ROUND(B-PEDM.PreBas * B-PEDM.CanPed * (Almmmatg.PorIsc / 100),4).
       IF B-PEDM.AftIgv THEN  
          B-PEDM.ImpIgv = B-PEDM.ImpLin - ROUND(B-PEDM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
    END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "PEDM"}
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
  DEFINE VARIABLE F-STKRET AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-OK AS LOG NO-UNDO.
  DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
  DEFINE BUFFER BUF-ALMMMATE FOR ALMMMATE.
  
  IF PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    OR INTEGER(PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDM.CodMat.
       RETURN "ADM-ERROR".
  END.
  IF DECIMAL(PEDM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDM.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF DECIMAL(PEDM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDM.PreUni.
       RETURN "ADM-ERROR".
  END.
  IF PEDM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
  END.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
    AND  Almmmate.CodAlm = S-CODALM 
    AND  Almmmate.codmat = PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no asignado al almacen " S-CODALM VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.
/*  FIND B-PEDM WHERE B-PEDM.CODCIA = S-CODCIA 
 *     AND  B-PEDM.CodMat = PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
 *     NO-LOCK NO-ERROR.
 *   IF AVAILABLE  B-PEDM AND ROWID(B-PEDM) <> ROWID(PEDM) THEN DO:
 *        MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
 *        RETURN "ADM-ERROR".
 *   END.*/
  IF PEDM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
    MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  RUN vta/stkdispo (s-codcia, 
                      PEDM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, 
                      PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                      F-FACTOR * DECIMAL(PEDM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 
                      OUTPUT S-OK, 
                      OUTPUT S-STKDIS 
                      ).
  IF S-OK = NO THEN DO:
    FIND buf-almmmate WHERE buf-Almmmate.CodCia = s-codcia 
                       AND  buf-Almmmate.CodAlm = PEDM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
                       AND  buf-Almmmate.codmat = PEDM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
                      NO-LOCK NO-ERROR.
    IF NOT AVAILABLE buf-almmmate THEN DO:
        MESSAGE "Producto no esta registrado" SKIP
                "en Almmmate" SKIP
                VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    
    MESSAGE "No hay STOCK disponible" SKIP(1)
            "       STOCK ACTUAL : " buf-almmmate.StkAct SKIP
            /*" STOCK COMPROMETIDO : " S-STKCOM SKIP*/
            "   STOCK DISPONIBLE : " S-STKDIS SKIP
            VIEW-AS ALERT-BOX ERROR.
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
IF AVAILABLE PEDM
THEN ASSIGN
        i-nroitm = PEDM.NroItm
        f-Factor = PEDM.Factor
        f-PreBas = PEDM.PreBas
        y-Dsctos = PEDM.Por_Dsctos[3].
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


