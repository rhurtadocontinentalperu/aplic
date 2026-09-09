&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEFINE VAR F-PRETOT AS DECIMAL NO-UNDO.
DEFINE VAR F-PRECOS AS DECIMAL NO-UNDO.
DEFINE VAR F-CTOLIS AS DECIMAL NO-UNDO.
DEFINE VAR F-CTOTOT AS DECIMAL NO-UNDO.
DEFINE VAR F-TpoBie AS INTEGER  INITIAL 1 NO-UNDO.
DEFINE VAR F-UNIDAD AS CHAR NO-UNDO.
DEFINE VAR X-MONEDA AS CHAR NO-UNDO.
DEFINE VAR F-MARCAS AS CHAR NO-UNDO.
DEFINE VAR NomPro   AS CHAR NO-UNDO.
DEFINE BUFFER DMATPR FOR LG-dmatpr.
DEFINE BUFFER MATPR FOR LG-cmatpr.

DEFINE SHARED VAR S-CODCIA AS INTEGER.   


DEFINE VAR X-CODMAT AS CHAR INIT "".
DEFINE VAR F-FACTOR AS DECI .
DEFINE VAR X-IGV AS DECI.

FIND FIRST Lg-cfgigv WHERE Lg-cfgigv.desde <= TODAY AND
                     Lg-cfgigv.hasta >= TODAY 
                     NO-LOCK NO-ERROR.

FIND FIRST FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LG-cmatpr
&Scoped-define FIRST-EXTERNAL-TABLE LG-cmatpr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-cmatpr.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LG-dmatpr Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table LG-dmatpr.codmat LG-dmatpr.desmat ~
Almmmatg.DesMar Almmmatg.UndCmp LG-dmatpr.CodMon X-MONEDA @ X-MONEDA ~
LG-dmatpr.PreAct LG-dmatpr.IgvMat LG-dmatpr.Dsctos[1] LG-dmatpr.Dsctos[2] ~
LG-dmatpr.Dsctos[3] LG-dmatpr.PreCos LG-dmatpr.ArtPro LG-dmatpr.PreAnt ~
F-PRETOT @ F-PRETOT 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table LG-dmatpr.codmat ~
LG-dmatpr.CodMon LG-dmatpr.PreAct LG-dmatpr.IgvMat LG-dmatpr.Dsctos[1] ~
LG-dmatpr.Dsctos[2] LG-dmatpr.Dsctos[3] LG-dmatpr.ArtPro 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table LG-dmatpr
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table LG-dmatpr
&Scoped-define QUERY-STRING-br_table FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia ~
  AND LG-dmatpr.nrolis = LG-cmatpr.nrolis ~
  AND LG-dmatpr.codpro = LG-cmatpr.CodPro ~
 ~
      AND LG-dmatpr.tpobien = F-TpoBie AND ~
LG-dmatpr.Codmat BEGINS X-Codmat NO-LOCK, ~
      EACH Almmmatg OF LG-dmatpr NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia ~
  AND LG-dmatpr.nrolis = LG-cmatpr.nrolis ~
  AND LG-dmatpr.codpro = LG-cmatpr.CodPro ~
 ~
      AND LG-dmatpr.tpobien = F-TpoBie AND ~
LG-dmatpr.Codmat BEGINS X-Codmat NO-LOCK, ~
      EACH Almmmatg OF LG-dmatpr NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table LG-dmatpr Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table LG-dmatpr
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


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
Codigo|y|y|BY LG-dmatpr.CODMAT
Marca|||integral.Almmmatg.DesMar|yes,integral.LG-dmatpr.desmat|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Marca",
     Sort-Case = Codigo':U).

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
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      LG-dmatpr, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      LG-dmatpr.codmat FORMAT "X(8)":U
      LG-dmatpr.desmat FORMAT "X(50)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U
      Almmmatg.UndCmp FORMAT "X(4)":U
      LG-dmatpr.CodMon COLUMN-LABEL "M" FORMAT "9":U
      X-MONEDA @ X-MONEDA COLUMN-LABEL "Mon" FORMAT "X(4)":U
      LG-dmatpr.PreAct COLUMN-LABEL "Precio Lista !    Actual" FORMAT ">>,>>9.9999":U
      LG-dmatpr.IgvMat FORMAT ">9.99":U
      LG-dmatpr.Dsctos[1] COLUMN-LABEL "%Dscto!1" FORMAT "->>9.99":U
      LG-dmatpr.Dsctos[2] COLUMN-LABEL "%Dscto!2" FORMAT "->>9.99":U
      LG-dmatpr.Dsctos[3] COLUMN-LABEL "%Dscto!3" FORMAT "->>9.99":U
      LG-dmatpr.PreCos COLUMN-LABEL "Valor Compra! Neto      .!   Sin IGV    ." FORMAT ">>,>>9.9999":U
      LG-dmatpr.ArtPro FORMAT "X(13)":U
      LG-dmatpr.PreAnt COLUMN-LABEL "Precio Lista!Anterior" FORMAT ">>,>>9.9999":U
      F-PRETOT @ F-PRETOT COLUMN-LABEL "Precio    !Compra Neto!   Incl. IGV   ." FORMAT ">>,>>9.9999":U
  ENABLE
      LG-dmatpr.codmat
      LG-dmatpr.CodMon
      LG-dmatpr.PreAct
      LG-dmatpr.IgvMat
      LG-dmatpr.Dsctos[1]
      LG-dmatpr.Dsctos[2]
      LG-dmatpr.Dsctos[3]
      LG-dmatpr.ArtPro
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 87.14 BY 9.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.LG-cmatpr
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.12
         WIDTH              = 87.14.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.LG-dmatpr WHERE integral.LG-cmatpr <external> ...,integral.Almmmatg OF integral.LG-dmatpr"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "LG-dmatpr.CodCia = LG-cmatpr.CodCia
  AND LG-dmatpr.nrolis = LG-cmatpr.nrolis
  AND LG-dmatpr.codpro = LG-cmatpr.CodPro
"
     _Where[1]         = "LG-dmatpr.tpobien = F-TpoBie AND
LG-dmatpr.Codmat BEGINS X-Codmat"
     _FldNameList[1]   > integral.LG-dmatpr.codmat
"LG-dmatpr.codmat" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = integral.LG-dmatpr.desmat
     _FldNameList[3]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = integral.Almmmatg.UndCmp
     _FldNameList[5]   > integral.LG-dmatpr.CodMon
"LG-dmatpr.CodMon" "M" ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"X-MONEDA @ X-MONEDA" "Mon" "X(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.LG-dmatpr.PreAct
"LG-dmatpr.PreAct" "Precio Lista !    Actual" ">>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.LG-dmatpr.IgvMat
"LG-dmatpr.IgvMat" ? ">9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.LG-dmatpr.Dsctos[1]
"LG-dmatpr.Dsctos[1]" "%Dscto!1" "->>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.LG-dmatpr.Dsctos[2]
"LG-dmatpr.Dsctos[2]" "%Dscto!2" "->>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > integral.LG-dmatpr.Dsctos[3]
"LG-dmatpr.Dsctos[3]" "%Dscto!3" "->>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > integral.LG-dmatpr.PreCos
"LG-dmatpr.PreCos" "Valor Compra! Neto      .!   Sin IGV    ." ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > integral.LG-dmatpr.ArtPro
"LG-dmatpr.ArtPro" ? "X(13)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > integral.LG-dmatpr.PreAnt
"LG-dmatpr.PreAnt" "Precio Lista!Anterior" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"F-PRETOT @ F-PRETOT" "Precio    !Compra Neto!   Incl. IGV   ." ">>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN lgc/d-detart.r({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" AND AVAILABLE LG-cmatpr THEN DO:
     LG-dmatpr.Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(LG-cmatpr.Dsctos[1]).
     LG-dmatpr.Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(LG-cmatpr.Dsctos[2]).
     LG-dmatpr.Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(LG-cmatpr.Dsctos[3]).
     X-MONEDA = IF LG-cmatpr.CodMon = 1 THEN "S/." ELSE "US$".
     FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
     IF AVAILABLE LG-CFGIGV AND LG-cmatpr.aftigv THEN 
        LG-dmatpr.IgvMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(LG-CFGIGV.PorIgv).
  END.
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


&Scoped-define SELF-NAME LG-dmatpr.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-dmatpr.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF LG-dmatpr.codmat IN BROWSE br_table /* Código */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  CASE F-TpoBie:
       WHEN 1 THEN DO:
            SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
            /* Valida Si Existe el Articulo */
            FIND Almmmatg WHERE Almmmatg.CodCia = LG-cmatpr.CodCia AND
                 Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN DO:
               MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX.
               RETURN NO-APPLY.
            END.
            /* Valida Si Esta Asignado a un Proveedor */
            /*
            IF Almmmatg.CodPr1 <> "" THEN DO:
               IF Almmmatg.CodPr1 <> LG-cmatpr.CodPro THEN DO:
                  FIND gn-Prov WHERE gn-Prov.CodPro = Almmmatg.CodPr1 NO-LOCK NO-ERROR.                  
                  IF AVAILABLE gn-Prov THEN NomPro = gn-Prov.NomPro.      
                  MESSAGE "Articulo Esta Asignado al Proveedor " Almmmatg.CodPr1 SKIP
                          NomPro VIEW-AS ALERT-BOX ERROR.
                  RETURN NO-APPLY.
               END.   
            END. */
            LG-dmatpr.desmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = Almmmatg.DesMat.
            F-UNIDAD = Almmmatg.UndStk.
            LG-dmatpr.PreAct:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(Almmmatg.preact).
            LG-dmatpr.dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(Almmmatg.dsctos[1]). 
            LG-dmatpr.dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(Almmmatg.dsctos[2]).
            LG-dmatpr.dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(Almmmatg.dsctos[3]).
            LG-dmatpr.CodMon:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(Almmmatg.MonVta).
       END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF LG-dmatpr.codmat,LG-dmatpr.CodMon,LG-dmatpr.PreAct,LG-dmatpr.IgvMat,LG-dmatpr.Dsctos[1],LG-dmatpr.Dsctos[2],LG-dmatpr.Dsctos[3],LG-dmatpr.ArtPro
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON FIND OF LG-dmatpr
DO:
  F-PRETOT = ROUND(LG-dmatpr.PreAct * 
             (1 - (LG-dmatpr.Dsctos[1] / 100)) *
             (1 - (LG-dmatpr.Dsctos[2] / 100)) *
             (1 - (LG-dmatpr.Dsctos[3] / 100)) *
             (1 + (LG-dmatpr.IgvMat / 100)) , 4).
  
     X-MONEDA = IF LG-dmatpr.CodMon = 1 THEN "S/." ELSE "US$".

END.
/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Activar-Lista B-table-Win 
PROCEDURE Activar-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR W-NROLIS AS INTEGER NO-UNDO.

IF LG-cmatpr.FlgEst = "A" OR LG-cmatpr.FlgEst = "D" THEN DO:
   MESSAGE "No puede Activar una lista Activa/Desactivada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
      
/* Desactiva La Antigua Lista */
FIND LAST MATPR WHERE MATPR.CodCia = LG-cmatpr.CodCia 
                  AND MATPR.CodPro = LG-cmatpr.CodPro 
                  AND MATPR.FlgEst = "A" 
                  NO-ERROR.
                  
IF AVAILABLE MATPR THEN DO:
    w-nrolis = matpr.nrolis.
    ASSIGN MATPR.FlgEst = "D"
    MATPR.FchVto = TODAY.
END.    
  
FOR EACH dmatpr WHERE dmatpr.CodCia = LG-cmatpr.CodCia
                AND  dmatpr.nrolis = w-nrolis 
                AND  dmatpr.FlgEst = "A":
    ASSIGN
    dmatpr.flgest = "D".
    FIND almmmatg WHERE almmmatg.codcia = S-CODCIA 
                    AND almmmatg.codmat = dmatpr.codmat 
                    NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        ASSIGN
            ALmmmatg.CodPr1     = "".
            ALmmmatg.ArtPro     = "".
            ALmmmatg.CodPr2     = dmatpr.CodPro.
        RELEASE Almmmatg.
    END.
END.    
  
/* Actualiza Cabecera Lista */
FIND MATPR WHERE MATPR.CodCia = LG-cmatpr.CodCia 
            AND  MATPR.nrolis = LG-cmatpr.nrolis 
            NO-ERROR.
            
IF AVAILABLE MATPR THEN DO:
    ASSIGN 
        MATPR.FlgEst = "A".
        MATPR.FchVIG = TODAY. 
END.
   
/* Actualiza Detalle Lista */
FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia 
                    AND  LG-dmatpr.nrolis = LG-cmatpr.nrolis:
    ASSIGN 
    LG-dmatpr.flgest = "A".
                
    /*RUN update-almmmatg-after-local-add-record.*/
    /* RHC: 18.09.08 NUEVA RUTINA */
    RUN actualiza-lista-de-precios-mayorista.
    
END.                                                                        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-lista-de-precios-mayorista B-table-Win 
PROCEDURE actualiza-lista-de-precios-mayorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND almmmatg WHERE almmmatg.codcia = S-CODCIA                                               
    AND  almmmatg.codmat = LG-dmatpr.codmat                                       
    EXCLUSIVE-LOCK NO-ERROR.                                                                          
  IF NOT AVAILABLE Almmmatg THEN RETURN.

  /* ACTUALIZAMOS PRECIOS A, B y C */
  {vta/lispre-a.i}

  /* ACTUALIZAMOS PRECIO DE OFICINA */
  DEFINE VARIABLE fmot LIKE Almmmatg.PreOfi.
  DEFINE VARIABLE pre-ofi LIKE Almmmatg.PreOfi.
  DEFINE VARIABLE MrgMin LIKE Almmmatg.MrgUti-A.
  DEFINE VARIABLE MrgOfi LIKE Almmmatg.MrgUti-A.
  DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
  DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.

  fmot   = 0.
  MrgMin = 100.
  MrgOfi = 0.
  F-FACTOR = 1.
  MaxCat = 4.
  MaxVta = 3.

  /****   Busca el Factor de conversion   ****/
  IF Almmmatg.Chr__01 <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                   AND  Almtconv.Codalter = Almmmatg.Chr__01
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
       RETURN.
    END.
    F-FACTOR = Almtconv.Equival.
  END.
  /*******************************************/

/* **********************************************************************
    NOTA IMPORTANTE: Cualquier cambio debe hacerse también
                    en FACTURACION -> Lista de precios 
************************************************************************* */                    

  CASE Almmmatg.Chr__02 :
    WHEN "T" THEN DO:        
        IF Almmmatg.MrgUti-A < MrgMin AND Almmmatg.MrgUti-A <> 0 THEN MrgMin = Almmmatg.MrgUti-A.
        IF Almmmatg.MrgUti-B < MrgMin AND Almmmatg.MrgUti-B <> 0 THEN MrgMin = Almmmatg.MrgUti-B.
        IF Almmmatg.MrgUti-C < MrgMin AND Almmmatg.MrgUti-C <> 0 THEN MrgMin = Almmmatg.MrgUti-C.
        fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).
        pre-ofi = Almmmatg.CtoTot * fmot * F-FACTOR .        
        MrgOfi = ROUND((fmot - 1) * 100, 6).
    END.
    WHEN "P" THEN DO:
       pre-ofi = Almmmatg.Prevta[1] * F-FACTOR.
       MrgOfi = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 
    END. 
  END.    
  ASSIGN
    Almmmatg.Dec__01 = MrgOfi
    Almmmatg.PreOfi = Pre-Ofi.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'Codigo':U THEN DO:
      &Scope SORTBY-PHRASE BY LG-dmatpr.CODMAT
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Marca':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.DesMar BY LG-dmatpr.desmat
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
  {src/adm/template/row-list.i "LG-cmatpr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-cmatpr"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca_Codigo B-table-Win 
PROCEDURE Busca_Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-CODIGO AS CHAR .
X-CODMAT = X-CODIGO.
RUN dispatch IN THIS-PROCEDURE ('open-query':U). 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto B-table-Win 
PROCEDURE Genera-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR.
  DEF VAR x-Ok AS LOG.
  DEF VAR c-Moneda AS CHAR.
  DEF VAR f-PreNet AS DEC.
  
  SYSTEM-DIALOG GET-FILE x-Archivo    FILTERS 'Archivo texto' '*.txt'    ASK-OVERWRITE CREATE-TEST-FILE    DEFAULT-EXTENSION '.txt'    INITIAL-DIR 'c:\tmp'     RETURN-TO-START-DIR SAVE-AS    TITLE 'Migracion a Texto'    UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.
  

  DEFINE FRAME F-DetLis 
    LG-dmatpr.Codmat    FORMAT "X(6)"           COLUMN-LABEL 'Codigo'
    LG-Dmatpr.ArtPro    FORMAT "X(10)"          COLUMN-LABEL 'Codigo Proveedor'
    Almmmatg.DesMat     FORMAT "X(60)"          COLUMN-LABEL 'Descripcion'
    Almmmatg.DesMar     FORMAT "X(14)"          COLUMN-LABEL 'Marca'
    Almmmatg.UndStk     FORMAT "X(4)"           COLUMN-LABEL 'Und'
    C-MONEDA            FORMAT "X(3)"           COLUMN-LABEL 'Mon'
    LG-Dmatpr.PreAct    FORMAT ">>,>>9.9999"    COLUMN-LABEL 'Precio'
    LG-Dmatpr.Dsctos[1] FORMAT ">9.99"          COLUMN-LABEL '% Dsct 1'
    LG-Dmatpr.Dsctos[2] FORMAT ">9.99"          COLUMN-LABEL '% Dsct 2'
    LG-Dmatpr.Dsctos[3] FORMAT ">9.99"          COLUMN-LABEL '% Dsct 3'
    LG-Dmatpr.IgvMat    FORMAT ">9.99"          COLUMN-LABEL '% IGV'
    F-PRENET            FORMAT ">>>>,>>9.99"    COLUMN-LABEL 'Neto sin IGV'
    WITH NO-BOX NO-UNDERLINE STREAM-IO DOWN WIDTH 250.

  OUTPUT TO VALUE(x-Archivo).
  FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia
        AND LG-dmatpr.nrolis = LG-cmatpr.nrolis
        AND LG-dmatpr.codpro = LG-cmatpr.CodPro
        AND LG-dmatpr.tpobien = F-TpoBie 
        AND LG-dmatpr.Codmat BEGINS X-Codmat NO-LOCK,
        FIRST Almmmatg OF LG-dmatpr NO-LOCK:
    C-MONEDA = IF LG-Dmatpr.Codmon = 1 THEN "S/." ELSE "US$".
    F-PRENET = ROUND (LG-Dmatpr.PreCos + ( LG-Dmatpr.PreCos * (LG-Dmatpr.IgvMat / 100) ),2).
    DISPLAY
       LG-Dmatpr.Codmat 
       LG-Dmatpr.ArtPro 
       Almmmatg.DesMat
       Almmmatg.DesMar
       Almmmatg.UndStk
       C-MONEDA 
       LG-Dmatpr.PreAct  
       LG-Dmatpr.Dsctos[1] 
       LG-Dmatpr.Dsctos[2] 
       LG-Dmatpr.Dsctos[3] 
       LG-Dmatpr.IgvMat  
       F-PRENET 
       WITH FRAME F-DetLis.
  END.
  OUTPUT CLOSE.
  
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
/*  IF LG-cmatpr.FlgEst <> " " THEN DO:
 *      MESSAGE "No puede adicionar un item," SKIP
 *              "a una lista Inactiva/Activa " VIEW-AS ALERT-BOX ERROR.
 *      RETURN ERROR.
 *   END.*/
 
 
  /* Dispatch standard ADM method.                            */
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN LG-dmatpr.CodCia = LG-cmatpr.CodCia
         LG-dmatpr.nrolis = LG-cmatpr.nrolis
         LG-dmatpr.codpro = LG-cmatpr.codpro
         LG-dmatpr.FchEmi = LG-cmatpr.FchEmi
         LG-dmatpr.FchVto = LG-cmatpr.FchVto
         LG-dmatpr.tpobien = F-TpoBie
         LG-dmatpr.FlgEst  = LG-cmatpr.FlgEst.
  /*     LG-dmatpr.CodMon  = LG-cmatpr.CodMon. */
  CASE LG-dmatpr.tpobien:
       WHEN 1 THEN DO:
            FIND Almmmatg WHERE Almmmatg.CodCia = LG-dmatpr.CodCia 
                           AND  Almmmatg.codmat = LG-dmatpr.codmat 
                          NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN DO:
               F-CtoLis = ROUND(LG-dmatpr.PreAct * 
                          (1 - (LG-dmatpr.Dsctos[1] / 100)) * 
                          (1 - (LG-dmatpr.Dsctos[2] / 100)) * 
                          (1 - (LG-dmatpr.Dsctos[3] / 100)) ,4).
               F-CtoTot = ROUND(LG-dmatpr.PreAct * 
                          (1 - (LG-dmatpr.Dsctos[1] / 100)) *
                          (1 - (LG-dmatpr.Dsctos[2] / 100)) *
                          (1 - (LG-dmatpr.Dsctos[3] / 100)) *
                          (1 + (LG-dmatpr.IgvMat / 100)) , 4).
             
               ASSIGN LG-dmatpr.desmat = Almmmatg.DesMat
                      LG-dmatpr.PreAnt = Almmmatg.preant
                      LG-dmatpr.PreCos = F-CtoLis           
                      LG-dmatpr.CtoLis = F-CtoLis
                      LG-dmatpr.CtoTot = F-CtoTot.           
            END.
       END.
       WHEN 2 THEN DO:
       END.
  END CASE.

  /*Actualiza Tabla de Materiales*/
  FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
      AND almmmatg.codmat = LG-dmatpr.CodMat NO-ERROR.
  IF AVAIL almmmatg THEN ASSIGN Almmmatg.CtoLis = LG-dmatpr.PreCos.
     
  F-PRETOT = ROUND(LG-dmatpr.PreAct * 
              (1 - (LG-dmatpr.Dsctos[1] / 100)) *
              (1 - (LG-dmatpr.Dsctos[2] / 100)) *
              (1 - (LG-dmatpr.Dsctos[3] / 100)) *
              (1 + (LG-dmatpr.IgvMat / 100)) , 4).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LG-cmatpr.FlgEst <> "" THEN DO:
     MESSAGE "No puede eliminar un item," SKIP
             "de una lista Activa/Inactiva" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.

  /*Actualiza Tabla de Materiales*/
  FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
      AND almmmatg.codmat = LG-dmatpr.CodMat NO-ERROR.
  IF AVAIL almmmatg THEN ASSIGN Almmmatg.CtoLis = 0.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  IF LG-cmatpr.FlgEst = "A"         /* SOLO ACTIVOS */
  THEN DO:
    /*RUN update-almmmatg-after-local-add-record.*/
    /* RHC: 18.09.08 NUEVA RUTINA */
    RUN actualiza-lista-de-precios-mayorista.
  END.

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
  {src/adm/template/snd-list.i "LG-cmatpr"}
  {src/adm/template/snd-list.i "LG-dmatpr"}
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
/*     IF AVAILABLE LG-cmatpr AND LG-cmatpr.FlgEst <> "" THEN DO:
 *         MESSAGE "No puede  modificar un item," SKIP
 *                 "de una lista Activa/Inactiva" VIEW-AS ALERT-BOX ERROR.
 *         RETURN ERROR.
 *      END.*/
  END.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  IF p-state = 'Abrir-Query':U THEN RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Tipo-Bien B-table-Win 
PROCEDURE Tipo-Bien :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TB AS INTEGER.
F-TpoBie = TB.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-almmmatg-after-local-add-record B-table-Win 
PROCEDURE update-almmmatg-after-local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       FIND almmmatg WHERE almmmatg.codcia = S-CODCIA                                               
                      AND  almmmatg.codmat = LG-dmatpr.codmat                                       
                     EXCLUSIVE-LOCK NO-ERROR.                                                                          
       IF AVAILABLE almmmatg THEN DO:                                                               
            if ALmmmatg.MonVta = LG-dmatpr.CodMon then do:
/********************* monedas iguales ***********************************************************/            
                  IF Almmmatg.CtoLis <> LG-dmatpr.PreCos THEN ASSIGN Almmmatg.FchmPre[2] = TODAY.           
                  ASSIGN                                                                                    
                      ALmmmatg.ArtPro     = LG-dmatpr.ArtPro                                                
                      ALmmmatg.CodPr1     = LG-dmatpr.CodPro                                                
                      ALmmmatg.MonVta     = LG-dmatpr.CodMon                                                
                      Almmmatg.preant     = LG-dmatpr.PreAnt                                                
                      Almmmatg.preact     = LG-dmatpr.PreAct                                                
                      Almmmatg.CtoUnd     = LG-dmatpr.PreCos                                                
                      Almmmatg.CtoLis     = LG-dmatpr.PreCos                                                
                      Almmmatg.CtoTot     = LG-dmatpr.CtoTot.                                               
                    
            end.
            
/********************* monedas diferentes caso A******************************************************/
             if ALmmmatg.MonVta = 1 and LG-dmatpr.CodMon = 2 then do:
                  IF Almmmatg.CtoLis <> ( LG-dmatpr.PreCos * tpocmb ) THEN ASSIGN Almmmatg.FchmPre[2] = TODAY.           
                  ASSIGN                                                                                    
                      ALmmmatg.ArtPro     = LG-dmatpr.ArtPro                                                
                      ALmmmatg.CodPr1     = LG-dmatpr.CodPro                                                
                      Almmmatg.preant     = LG-dmatpr.PreAnt * tpocmb                                               
                      Almmmatg.preact     = LG-dmatpr.PreAct * tpocmb                                                
                      Almmmatg.CtoUnd     = LG-dmatpr.PreCos * tpocmb                                                
                      Almmmatg.CtoLis     = LG-dmatpr.PreCos * tpocmb                                                
                      Almmmatg.CtoTot     = LG-dmatpr.CtoTot * tpocmb.                     
            end.

/********************* monedas diferentes caso B******************************************************/
             if ALmmmatg.MonVta = 2 and LG-dmatpr.CodMon = 1 then do:
                  IF Almmmatg.CtoLis <> ( LG-dmatpr.PreCos / tpocmb ) THEN ASSIGN Almmmatg.FchmPre[2] = TODAY.           
                  ASSIGN                                                                                    
                      ALmmmatg.ArtPro     = LG-dmatpr.ArtPro                                                
                      ALmmmatg.CodPr1     = LG-dmatpr.CodPro                                                
                      Almmmatg.preant     = LG-dmatpr.PreAnt / tpocmb                                               
                      Almmmatg.preact     = LG-dmatpr.PreAct / tpocmb                                                
                      Almmmatg.CtoUnd     = LG-dmatpr.PreCos / tpocmb                                                
                      Almmmatg.CtoLis     = LG-dmatpr.PreCos / tpocmb                                                
                      Almmmatg.CtoTot     = LG-dmatpr.CtoTot / tpocmb.                 
            end.

            IF Almmmatg.AftIgv THEN X-IGV = 1 + (lg-cfgigv.PorIgv / 100).
            ELSE X-IGV = 1.            

            F-FACTOR = 1.        
            /****   Busca el Factor de conversion   ****/
            IF Almmmatg.UndA <> "" THEN DO:
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                               AND  Almtconv.Codalter = Almmmatg.UndA
                              NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almtconv THEN LEAVE.
                F-FACTOR = Almtconv.Equival.
                ASSIGN
                Almmmatg.Prevta[1] = Almmmatg.Prevta[2] / F-FACTOR.
                Almmmatg.PreBas    = Almmmatg.Prevta[1] / X-IGV.
                Almmmatg.Dsctos[1] = 0.
                Almmmatg.MrgUti    = ((Almmmatg.Prevta[1] / Almmmatg.CtoTot ) - 1 ) * 100.                
                Almmmatg.MrgUti-A  = (((Almmmatg.Prevta[2] / F-FACTOR) / Almmmatg.CtoTot ) - 1 ) * 100.
            END.
            ELSE
                ASSIGN
                    Almmmatg.Dsctos[1] = 0
                    Almmmatg.MrgUti-A = 0.


            F-FACTOR = 1.        
            /****   Busca el Factor de conversion   ****/
            IF Almmmatg.UndB <> "" THEN DO:
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                               AND  Almtconv.Codalter = Almmmatg.UndB
                              NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almtconv THEN LEAVE.
                F-FACTOR = Almtconv.Equival.
                ASSIGN
                Almmmatg.Dsctos[2] = ( 1 - ((Almmmatg.Prevta[3] / F-FACTOR) / Almmmatg.Prevta[1] )) * 100.
                Almmmatg.MrgUti-B  = (((Almmmatg.Prevta[3] / F-FACTOR) / Almmmatg.CtoTot ) - 1 ) * 100.
            END.
            ELSE 
                ASSIGN
                    Almmmatg.Dsctos[2] = 0           
                    Almmmatg.MrgUti-B  = 0.

            F-FACTOR = 1.        
            /****   Busca el Factor de conversion   ****/
            IF Almmmatg.UndC <> "" THEN DO:
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                               AND  Almtconv.Codalter = Almmmatg.UndC
                              NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almtconv THEN LEAVE.
                F-FACTOR = Almtconv.Equival.
                ASSIGN
                Almmmatg.Dsctos[3] = ( 1 - ((Almmmatg.Prevta[4] / F-FACTOR) / Almmmatg.Prevta[1] )) * 100.
                Almmmatg.MrgUti-C  = (((Almmmatg.Prevta[4] / F-FACTOR) / Almmmatg.CtoTot ) - 1 ) * 100.
            END.
            ELSE 
                ASSIGN
                    Almmmatg.Dsctos[3] = 0
                    Almmmatg.MrgUti-C  = 0.


            F-FACTOR = 1.
            /****   Busca el Factor de conversion   ****/
            IF Almmmatg.Chr__01 <> "" THEN DO:
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                               AND  Almtconv.Codalter = Almmmatg.Chr__01
                              NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almtconv THEN LEAVE.
                F-FACTOR = Almtconv.Equival.
                ASSIGN
                   Almmmatg.PreOfi = Almmmatg.Prevta[1] * F-FACTOR
                   Almmmatg.Dec__01 = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 
            END.
            ELSE ASSIGN
                   Almmmatg.PreOfi = 0
                   Almmmatg.Dec__01 = 0. 
       END.                                                                                         

       RELEASE Almmmatg.                                                                 

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
IF LG-dmatpr.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.

FIND FIRST DMATPR WHERE DMATPR.CodCia = LG-cmatpr.CodCia AND
     DMATPR.nrolis = LG-cmatpr.nrolis  AND
     DMATPR.codmat = LG-dmatpr.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF AVAILABLE DMATPR AND ROWID(DMATPR) <> ROWID(LG-dmatpr) THEN DO:
   MESSAGE "Articulo repetido" VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.

/* FIND FIRST DMATPR WHERE DMATPR.CodCia = LG-cmatpr.CodCia AND
     DMATPR.codmat = LG-dmatpr.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND 
     DMATPR.FlgEst = "" AND
     DMATPR.nrolis <> LG-cmatpr.nrolis  NO-LOCK NO-ERROR.
IF AVAILABLE DMATPR THEN DO:
   MESSAGE "Articulo ya fue asignado" SKIP
           "al proveedor " DMATPR.codpro SKIP
           "el la lista " DMATPR.nrolis VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".  
END. */
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

