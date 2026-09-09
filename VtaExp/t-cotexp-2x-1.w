&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



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

DEFINE SHARED VARIABLE S-NROCOT  AS CHAR.
DEFINE SHARED VARIABLE S-CODPRO  AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.       /* DESCUENTO EXPOLIBRERIA */
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

DEFINE BUFFER B-PEDI FOR PEDI2.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PEDI2 Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI2.Libre_c01 PEDI2.Libre_c02 ~
PEDI2.codmat Almmmatg.DesMat Almmmatg.DesMar PEDI2.UndVta PEDI2.CanPed ~
PEDI2.PreUni PEDI2.PorDto PEDI2.Por_Dsctos[2] PEDI2.Por_Dsctos[3] ~
PEDI2.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI2 WHERE ~{&KEY-PHRASE} ~
      AND PEDI2.CanPed <> 0 NO-LOCK, ~
      FIRST Almmmatg OF PEDI2 NO-LOCK ~
    BY PEDI2.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI2 WHERE ~{&KEY-PHRASE} ~
      AND PEDI2.CanPed <> 0 NO-LOCK, ~
      FIRST Almmmatg OF PEDI2 NO-LOCK ~
    BY PEDI2.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI2 Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI2
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-7 btn-elimina 
&Scoped-Define DISPLAYED-OBJECTS F-ValVta F-ImpIsc F-PorDes F-TotBrt ~
F-ImpExo F-ImpDes F-ImpIgv F-ImpTot 

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
DEFINE BUTTON btn-elimina 
     LABEL "Elimina" 
     SIZE 9 BY 1.12.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/api-lc.ico":U
     LABEL "Button 7" 
     SIZE 9.43 BY 2.15.

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
     LABEL "% Dscto" 
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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI2, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI2.Libre_c01 COLUMN-LABEL "Pag" FORMAT "x(4)":U WIDTH 3.14
      PEDI2.Libre_c02 COLUMN-LABEL "Secu" FORMAT "x(6)":U
      PEDI2.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 45
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(25)":U WIDTH 8.43
      PEDI2.UndVta FORMAT "x(5)":U
      PEDI2.CanPed FORMAT "->>>,>>9.9999":U WIDTH 7.72
      PEDI2.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>>,>>9.999999":U
            WIDTH 7.43
      PEDI2.PorDto COLUMN-LABEL "% Dscto.!Incluido" FORMAT ">>9.99":U
      PEDI2.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.99":U
      PEDI2.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.99":U
      PEDI2.ImpLin FORMAT "->>>,>>>,>>9.99":U WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 120.72 BY 9.35
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.29
     BUTTON-7 AT ROW 2.08 COL 123 WIDGET-ID 2
     btn-elimina AT ROW 5.27 COL 123.57 WIDGET-ID 6
     F-ValVta AT ROW 11.23 COL 59 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     F-ImpIsc AT ROW 11.23 COL 72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     F-PorDes AT ROW 11.27 COL 12 COLON-ALIGNED WIDGET-ID 20
     F-TotBrt AT ROW 11.27 COL 25 NO-LABEL WIDGET-ID 22
     F-ImpExo AT ROW 11.27 COL 37 NO-LABEL WIDGET-ID 12
     F-ImpDes AT ROW 11.27 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     F-ImpIgv AT ROW 11.27 COL 84 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     F-ImpTot AT ROW 11.27 COL 97 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 10.69 COL 77 WIDGET-ID 28
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 10.69 COL 36 WIDGET-ID 36
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 10.69 COL 49 WIDGET-ID 34
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 10.69 COL 88 WIDGET-ID 32
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.69 COL 62 WIDGET-ID 30
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 10.69 COL 99 WIDGET-ID 38
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.69 COL 25 WIDGET-ID 26
     "Agregar" VIEW-AS TEXT
          SIZE 7 BY .81 AT ROW 4.27 COL 124.14 WIDGET-ID 8
          FONT 6
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
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 11.08
         WIDTH              = 134.86.
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table TEXT-2 F-Main */
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
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI2,INTEGRAL.Almmmatg OF Temp-Tables.PEDI2"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.PEDI2.NroItm|yes"
     _Where[1]         = "Temp-Tables.PEDI2.CanPed <> 0"
     _FldNameList[1]   > Temp-Tables.PEDI2.Libre_c01
"PEDI2.Libre_c01" "Pag" "x(4)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI2.Libre_c02
"PEDI2.Libre_c02" "Secu" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.PEDI2.codmat
"PEDI2.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(25)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.PEDI2.UndVta
     _FldNameList[7]   > Temp-Tables.PEDI2.CanPed
"PEDI2.CanPed" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI2.PreUni
"PEDI2.PreUni" "Precio!Unitario" ">>>,>>9.999999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI2.PorDto
"PEDI2.PorDto" "% Dscto.!Incluido" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.PEDI2.Por_Dsctos[2]
"PEDI2.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.PEDI2.Por_Dsctos[3]
"PEDI2.Por_Dsctos[3]" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.PEDI2.ImpLin
"PEDI2.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME PEDI2.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI2.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI2.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
        NO-ERROR.
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
    ASSIGN 
        S-UNDBAS = Almmmatg.UndBas
        F-FACTOR = 1
        X-CANPED = 1.
    RUN vtaexp/PrecioVenta (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        f-Factor,
                        Almmmatg.CodMat,
                        s-CndVta,
                        x-CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT x-TipDto
                            ).

    /* RHC 8.11.05  DESCUENTO ADICIONAL POR EXPOLIBRERIA */
    /* RHC 10.01.08 SOLO SI NO TIENE DESCUENTO PROMOCIONAL */
    z-Dsctos = 0.
    FIND FacTabla WHERE factabla.codcia = s-codcia
        AND factabla.tabla = 'EL'
        AND factabla.codigo = STRING(YEAR(TODAY), '9999')
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla 
        AND y-Dsctos = 0 
        AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 
        THEN DO:    /* NO Promociones */
        CASE Almmmatg.Chr__02:
            WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1].
            WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2].
        END CASE.
    END.
    IF AVAILABLE FacTabla 
            AND y-Dsctos = 0 
            AND LOOKUP(TRIM(s-CndVta), '400,401') > 0 
            THEN DO:    /* NO Promociones */
        CASE Almmmatg.Chr__02:
            WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1] /* - 1*/.
            WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2] /* - 2*/.
        END CASE.
    END.
    /* ************************************************* */
    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-elimina B-table-Win
ON CHOOSE OF btn-elimina IN FRAME F-Main /* Elimina */
DO:
    MESSAGE "Esta seguro"
        view-as alert-box question
        buttons yes-no update rpta as logical.
    if not rpta then return no-apply.

    FIND FIRST b-pedi WHERE ROWID(b-pedi) = ROWID(pedi2) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-pedi THEN 
        ASSIGN 
            b-pedi.canped = 0
            b-pedi.implin = 0.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
    /*RUN Vtaexp\w-ingmate00.*/
    IF s-codcli = '' THEN DO:
        MESSAGE 'Debe ingresar Código Cliente'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    RUN Vtaexp\w-ingmate_02-1.
    RUN Imp-Total.
    RUN adm-open-query.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF PEDI2.CanPed, PEDI2.codmat DO:
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
  FOR EACH B-PEDI:
    F-ImpTot = F-ImpTot + B-PEDI.ImpLin.
    F-Igv = F-Igv + B-PEDI.ImpIgv.
    F-Isc = F-Isc + B-PEDI.ImpIsc.
    /*F-ImpDes = F-ImpDes + B-PEDI.ImpDto.*/
    IF NOT B-PEDI.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDI.ImpLin.
    IF B-PEDI.AftIgv = YES
    THEN f-ImpDes = f-ImpDes + ROUND(B-PEDI.ImpDto / (1 + FacCfgGn.PorIgv / 100), 2).
    ELSE f-ImpDes = f-ImpDes + B-PEDI.ImpDto.
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
  FOR EACH B-PEDI BY B-PEDI.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-PEDI.NroItm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  I-NroItm = I-NroItm + 1.
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
    PEDI2.CodCia = S-CODCIA
    PEDI2.Factor = F-FACTOR
    PEDI2.NroItm = I-NroItm.
    /*PEDI2.ALMDES = S-CODALM.*/
         
  ASSIGN 
    PEDI2.PreBas = F-PreBas 
    PEDI2.AftIgv = Almmmatg.AftIgv 
    PEDI2.AftIsc = Almmmatg.AftIsc 
    PEDI2.Libre_c04 = X-TIPDTO.
    
  IF PEDI2.AftIsc 
  THEN PEDI2.ImpIsc = ROUND(PEDI2.PreBas * PEDI2.CanPed * (Almmmatg.PorIsc / 100),4).
  IF PEDI2.AftIgv 
  THEN  PEDI2.ImpIgv = PEDI2.ImpLin - ROUND(PEDI2.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

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
  FOR EACH B-PEDI:
    F-FACTOR = B-PEDI.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = B-PEDI.CODCIA AND  
         Almmmatg.codmat = B-PEDI.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        x-CanPed = B-PEDI.CanPed.
        RUN vtaexp/PrecioVenta (s-CodCia,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            s-TpoCmb,
                            f-Factor,
                            Almmmatg.CodMat,
                            s-CndVta,
                            x-CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT x-TipDto
                                ).

        /* RHC 8.11.05  DESCUENTO ADICIONAL POR EXPOLIBRERIA */
        z-Dsctos = 0.
        FIND FacTabla WHERE factabla.codcia = s-codcia
            AND factabla.tabla = 'EL'
            AND factabla.codigo = STRING(YEAR(TODAY), '9999')
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla 
            AND y-Dsctos = 0 
            AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 
            THEN DO:    /* NO Promociones */
            CASE Almmmatg.Chr__02:
                WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1].
                WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2].
            END CASE.
        END.
        IF AVAILABLE FacTabla 
            AND y-Dsctos = 0 
            AND LOOKUP(TRIM(s-CndVta), '400,401') > 0 
            THEN DO:    /* NO Promociones */
            CASE Almmmatg.Chr__02:
                WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1] /*- 1*/.
                WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2] /*- 2*/.
            END CASE.
        END.
        /* ************************************************* */

        ASSIGN 
            B-PEDI.PreBas = F-PreBas 
            B-PEDI.AftIgv = Almmmatg.AftIgv 
            B-PEDI.AftIsc = Almmmatg.AftIsc
            B-PEDI.PreUni = F-PREVTA
            B-PEDI.PorDto = F-DSCTOS
            B-PEDI.Libre_c04 = X-TIPDTO.
       IF B-PEDI.AftIsc THEN 
          B-PEDI.ImpIsc = ROUND(B-PEDI.PreBas * B-PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
       IF B-PEDI.AftIgv THEN  
          B-PEDI.ImpIgv = B-PEDI.ImpLin - ROUND(B-PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
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
  {src/adm/template/snd-list.i "PEDI2"}
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
  DEFINE VARIABLE S-OK AS LOGICAL NO-UNDO.
  DEFINE VARIABLE F-STKRET AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-STKDIS AS DECIMAL NO-UNDO.
  
  IF PEDI2.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    OR INTEGER(PEDI2.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI2.CodMat.
       RETURN "ADM-ERROR".
  END.
  IF DECIMAL(PEDI2.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI2.CanPed.
       RETURN "ADM-ERROR".
  END.
  /*
  IF DECIMAL(PEDI2.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI2.PreUni.
       RETURN "ADM-ERROR".
  END.
  IF PEDI2.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.
  */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDI2.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
  END.
  /*
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
    AND  Almmmate.CodAlm = PEDI2.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    AND  Almmmate.codmat = PEDI2.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no asignado al almacen " (PEDI2.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.
  */
  FIND B-PEDI WHERE B-PEDI.CODCIA = S-CODCIA 
    AND  B-PEDI.CodMat = PEDI2.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    NO-LOCK NO-ERROR.
  IF AVAILABLE  B-PEDI AND ROWID(B-PEDI) <> ROWID(PEDI2) THEN DO:
       MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.
/*  /* CONSISTENCIA DE STOCK */
 *   RUN vta/stkdispo (s-codcia, 
 *                   PEDI2.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, 
 *                   PEDI2.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
 *                   F-FACTOR * DECIMAL(PEDI2.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 
 *                   OUTPUT S-OK, 
 *                   OUTPUT S-STKDIS
 *                   ).
 *   IF S-OK = NO THEN DO:
 *     MESSAGE "No hay STOCK disponible en el almacen" PEDI2.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} SKIP(1)
 *             "     STOCK ACTUAL : " almmmate.StkAct SKIP
 *             "       DISPONIBLE : " S-STKDIS  SKIP(1)
 *             " Continuamos con la grabacion?"
 *             VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
 *             UPDATE rpta AS LOG.
 *     IF rpta = NO THEN RETURN "ADM-ERROR".
 *   END.*/
  /* ********************* */

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
IF AVAILABLE PEDI2
THEN ASSIGN
        i-nroitm = PEDI2.NroItm
        f-Factor = PEDI2.Factor
        f-PreBas = PEDI2.PreBas
        x-TipDto = PEDI2.Libre_c04.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

