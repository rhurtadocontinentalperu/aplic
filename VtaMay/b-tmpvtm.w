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

/* Shared Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE FacDPedm.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-IMPTOT   AS DEC.

DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  

DEFINE SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                  */
DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE S-UNDBAS     AS CHARACTER NO-UNDO.
DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-OK         AS Logical   NO-UNDO.
DEFINE VARIABLE S-STKDIS     AS DEC       NO-UNDO.
DEFINE VARIABLE S-STKCOM     AS DEC       NO-UNDO.
DEFINE VARIABLE I-NroItm     AS INTEGER   NO-UNDO.
               
DEFINE VARIABLE F-PREVTA LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PorImp LIKE Almmmatg.PreBas NO-UNDO.

DEFINE BUFFER B-ITEM FOR ITEM.
DEFINE BUFFER B-Almtconv FOR Almtconv.

DEFINE VARIABLE X-FACTOR  AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-PREVTA1 LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE X-PREVTA2 LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE X-DSCTOS  LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE SW-LOG1 AS LOGICAL NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.

DEFINE VARIABLE x-password AS LOGICAL NO-UNDO INITIAL FALSE.

DEF VAR X-ESTADO AS LOGICAL.

DEFINE VARIABLE SW-STADO AS CHARACTER.

DEFINE VARIABLE X-VALIDA AS LOGICAL.

DEFINE BUFFER buf-almmmate FOR almmmate.

DEFINE VARIABLE Y-DSCTOS  LIKE Almmmatg.PorMax NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ITEM Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM.NroItm ITEM.codmat Almmmatg.DesMat Almmmatg.DesMar ITEM.UndVta ITEM.AlmDes ITEM.CanPed ITEM.PreUni ITEM.PorDto ITEM.Por_Dsctos[1] ITEM.ImpLin   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.codmat ~
ITEM.UndVta ~
ITEM.AlmDes ~
ITEM.CanPed /* ~
ITEM.PorDto ~
ITEM.Por_Dsctos[1] ~
ITEM.PreUni */   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM  NO-LOCK, ~
             FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH ITEM  NO-LOCK, ~
             FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS F-TotBrt F-ImpExo F-ImpDes F-ValVta ~
F-ImpIsc F-ImpIgv F-ImpTot 

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

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      ITEM.NroItm COLUMN-LABEL "No" FORMAT "Z9"
      ITEM.codmat COLUMN-LABEL "Articulo"   FORMAT "X(6)"
      Almmmatg.DesMat FORMAT "X(27)"
      Almmmatg.DesMar FORMAT "X(10)" COLUMN-LABEL "Marca"
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "X(10)"
      ITEM.AlmDes COLUMN-LABEL "Alm!Des" FORMAT "X(3)"
      ITEM.CanPed COLUMN-LABEL "Cantidad" FORMAT ">>>,>>>.9999"
      ITEM.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999"
      ITEM.PorDto COLUMN-LABEL "Dsct.!1" FORMAT "->9.99"
      ITEM.Por_Dsctos[1] COLUMN-LABEL "Dsct.!2" FORMAT "->9.99"
      ITEM.ImpLin COLUMN-LABEL "Importe" FORMAT ">,>>>,>>9.99"
  ENABLE
      ITEM.codmat
      ITEM.UndVta
      ITEM.AlmDes
      ITEM.CanPed
/*
      ITEM.PorDto HELP "F3-Password"
      ITEM.Por_Dsctos[1]
      ITEM.PreUni HELP "F3-Password"
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 89 BY 7.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-TotBrt AT ROW 9.42 COL 3 NO-LABEL
     F-ImpExo AT ROW 9.42 COL 14.86 NO-LABEL
     F-ImpDes AT ROW 9.42 COL 25 COLON-ALIGNED NO-LABEL
     F-ValVta AT ROW 9.42 COL 37.57 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 9.42 COL 50.14 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 9.42 COL 61.86 COLON-ALIGNED NO-LABEL
     F-ImpTot AT ROW 9.42 COL 75 COLON-ALIGNED NO-LABEL
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.92 COL 15
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.92 COL 27.43
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 8.92 COL 66.29
     "Total Importe" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 8.92 COL 77.29
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 8.92 COL 55.43
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.92 COL 41.14
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.92 COL 4.72
     RECT-11 AT ROW 8.85 COL 1
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
         HEIGHT             = 9.46
         WIDTH              = 89.57.
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
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ITEM  NO-LOCK,
      FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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
ON ENTRY OF br_table IN FRAME F-Main
DO:
/*  MESSAGE "HOLA" VIEW-AS ALERT-BOX.*/
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF ITEM.codmat, ITEM.UndVta, ITEM.AlmDes, ITEM.CanPed, ITEM.PorDto, ITEM.Por_Dsctos[1], ITEM.PreUni
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF ITEM.CodMat
DO: 
   X-VALIDA = FALSE.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.codmat = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   /* Valida Maestro Productos x Almacen */
   FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                  AND  Almmmate.CodAlm = S-CODALM 
                  AND  Almmmate.CodMat = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no esta asignado al" SKIP
              "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
/*   IF Almmmate.StkAct <= 1000 THEN DO:
 *       MESSAGE "   <<<<<<  O  J  O  >>>>>>   " SKIP
 *               "No existe STOCK : " Almmmate.StkAct SKIP
 *               VIEW-AS ALERT-BOX WARNING.
 *    END.*/
   /****    Selecciona las unidades de medida   ****/

    RUN lkup\c-uniabc.r("Unidades de Venta",
                        Almmmate.CodMat
                        ).
    IF output-var-2 = ? THEN DO:
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "".
      RETURN NO-APPLY.
    END.
   /************************************************/
   S-UNDBAS = Almmmatg.UndBas.
   F-FACTOR = 1.
   RUN Calculo-Precios.
   DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
           Almmmatg.DesMar @ Almmmatg.DesMar
           output-var-2 /*Almmmatg.UndStk*/ @ ITEM.UndVta 
           s-codalm @ ITEM.AlmDes
           F-DSCTOS @ ITEM.PorDto
           F-PREVTA @ ITEM.PreUni
           WITH BROWSE {&BROWSE-NAME}.
   /*******************Variable Descuento****************/
   Y-DSCTOS = 0.
   /****************************************************/
   FIND Almtconv WHERE 
        Almtconv.CodUnid = Almmmatg.UndBas AND  
        Almtconv.Codalter = output-var-2 
        NO-LOCK NO-ERROR.
   IF AVAILABLE Almtconv THEN
      F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
   ELSE DO:
        MESSAGE "Equivalencia no Registrado"
                VIEW-AS ALERT-BOX.
        APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
   END.
   
   X-VALIDA = TRUE.
   
   APPLY "ENTRY" TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}.
   RETURN NO-APPLY.
END.

ON "ANY-PRINTABLE":U OF ITEM.UndVta
DO:
  RETURN NO-APPLY.
END.

ON "ENTRY":U OF ITEM.UndVta
DO:
  IF NOT X-VALIDA THEN DO:
    APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

ON "LEAVE":U OF ITEM.UndVta
DO:
END.

ON "ENTRY":U OF ITEM.AlmDes
DO:
  IF NOT X-VALIDA THEN DO:
    APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

ON "LEAVE":U OF ITEM.AlmDes
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF SELF:SCREEN-VALUE <> S-CODALM 
  THEN DO:
    IF LOOKUP(SELF:SCREEN-VALUE, "03A,04A,05A,04") > 0
    THEN DO:
        FIND Almacen WHERE Almacen.CodCia = S-CodCia 
            AND  Almacen.CodAlm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen 
        THEN DO:
           MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}.
           RETURN NO-APPLY.
        END.
        /* CONSISTENCIA SI SE QUIERE VENDER DE VITRINA */
        IF LOOKUP(SELF:SCREEN-VALUE, "03A,04A,05A") > 0
            AND NOT (SELF:SCREEN-VALUE BEGINS s-codalm)
        THEN DO:
            MESSAGE "No puede sacar material de esta vitrina"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
      MESSAGE "Almacen No Autorizado para Despachos " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
    END.
  END.
END.

ON "ENTRY":U OF ITEM.CanPed
DO:
  IF NOT X-VALIDA THEN DO:
    APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

ON "LEAVE":U OF ITEM.CanPed
DO:

    IF DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.CanPed IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
    END.
    
    /****   Valida si acepta solo cantidades enteras    ****/
    /*******************************************************/

/**IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "Und" **/
/*    IF Almmmatg.FlgPre THEN DO:*/
        IF Almtconv.Multiplos <> 0 THEN DO:
           IF DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
              INT(DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
              MESSAGE " La Cantidad debe de ser un, " SKIP
                      " multiplo de : " Almtconv.Multiplos
                      VIEW-AS ALERT-BOX WARNING.
              RETURN NO-APPLY.
           END.
        END.

        X-FACTOR = 1.
        X-PREVTA1 = 0.
        X-PREVTA2 = 0.
        SW-LOG1 = FALSE.
        
        /****   PRECIO C    ****/
        IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndC 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.

            IF (DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN  
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[3].
                IF Almmmatg.MonVta = 1 THEN
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                         
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
            END.
        END.
    
        /****   PRECIO B    ****/
        IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndB 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[2].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
            END.
        END.
    
        /****   PRECIO A    ****/
        IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndA 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[1].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
            END.
            ELSE DO:
                SW-LOG1 = FALSE.
                F-DSCTOS = Almmmatg.dsctos[1].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) /* * F-FACTOR*/.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) /* * F-FACTOR*/.
            END.
        END.       
 
        Y-DSCTOS = 0.
        
        /************Descuento Promocional ************/
        DEFINE VAR J AS INTEGER .
        DO J = 1 TO 10 :
           IF Almmmatg.PromDivi[J] = S-CODDIV AND
                            TODAY >= Almmmatg.PromFchD[J] AND 
                            TODAY <= Almmmatg.PromFchH[J] THEN DO:
              F-DSCTOS = Almmmatg.PromDto[J] .         
              F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
              Y-DSCTOS = Almmmatg.PromDto[J] .
              SW-LOG1  = TRUE.
              /*MESSAGE "Producto " + Almmmatg.Codmat + " Tiene Descuento Promocional " VIEW-AS ALERT-BOX INFORMATION.*/
              
              FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                               AND  B-Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
                               NO-LOCK NO-ERROR.
                 IF AVAILABLE B-Almtconv THEN
                     X-FACTOR = B-Almtconv.Equival.
                     IF Almmmatg.Monvta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                     ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                     X-PREVTA1 = X-PREVTA1 * X-FACTOR.
                     X-PREVTA2 = X-PREVTA2 * X-FACTOR.
              
              
           END.   
        END.
        /************************************************/
     
        /***************Descuento Volumen****************/
        IF DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> 0 THEN DO:
           DEFINE VAR X-RANGO AS INTEGER INIT 0.   
           DEFINE VAR X-CANTI AS DECI    INIT 0.   
           FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                           AND  B-Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
                           NO-LOCK NO-ERROR.
           IF AVAILABLE B-Almtconv THEN DO:
              X-FACTOR = B-Almtconv.Equival.
              X-CANTI = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * X-FACTOR .
           END.
                       
           DO J = 1 TO 10 :
              IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
                 
                 IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
                 IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
                    X-RANGO  = Almmmatg.DtoVolR[J] .
                    F-DSCTOS = Almmmatg.DtoVolD[J] .         
                    F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
                    Y-DSCTOS = Almmmatg.DtoVolD[J] .
                    SW-LOG1  = TRUE.                    
                    /*MESSAGE "Producto " + Almmmatg.Codmat + " Tiene Descuento X Volumen" VIEW-AS ALERT-BOX INFORMATION.*/
                    
                    
                       IF Almmmatg.MonVta = 1 THEN 
                          ASSIGN X-PREVTA1 = F-PREVTA
                                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                       ELSE
                          ASSIGN X-PREVTA2 = F-PREVTA
                                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                          X-PREVTA1 = X-PREVTA1 * X-FACTOR.
                          X-PREVTA2 = X-PREVTA2 * X-FACTOR.                                        
                 END.   
              END.   
           END.
         END.        
        /************************************************/
       
        IF S-CODMON = 1 THEN 
            F-PREVTA = X-PREVTA1.
        ELSE 
            F-PREVTA = X-PREVTA2.
       
         DISPLAY F-DSCTOS @ ITEM.PorDto
                F-PREVTA @ ITEM.PreUni
                WITH BROWSE {&BROWSE-NAME}.
/*    END.    /****   Fin valida precios  ****/*/

END.

ON "ANY-PRINTABLE":U OF ITEM.PorDto
DO:
  IF NOT x-password THEN RETURN NO-APPLY.
END.

ON "ENTRY":U OF ITEM.PorDto
DO:
  IF NOT X-VALIDA THEN DO:
    APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

ON "F3":U OF ITEM.PorDto
DO:
  DEFINE VAR RPTA AS CHAR.
  DEFINE VAR NIV  AS CHAR.
  DEFINE VAR X-MAXDSC AS DEC.
  DEFINE VAR X-NEWDSC AS DEC.
  DEFINE VAR X-NEWPRE AS DEC.
  
  IF x-password = FALSE THEN DO:
      RUN VTA/D-CLAVE.R("D",
                        "DESCUENTOS",
                        OUTPUT NIV,
                        OUTPUT RPTA).
      IF RPTA = "ERROR" THEN x-password = FALSE.
      ELSE x-password = TRUE.
  END.
  IF x-password = TRUE THEN DO:
    RUN VTA/D-DSCTO.R(DEC(ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) + 
                      DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}),    /* Add by C.Q. 23/03/2000 */
                      DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}),
                      Almmmatg.UndBas,
                      output-var-2,
                      Almmmatg.PorMax,
                      Almmmatg.PreVta[1],
                      Almmmatg.MonVta,
                      Almmmatg.TpoCmb,
                      NIV,
                      OUTPUT X-NEWDSC,
                      OUTPUT X-NEWPRE
                      ).
/*     ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(X-NEWDSC).*/
     ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = IF X-NEWDSC <> 0 THEN 
                                                                STRING(X-NEWDSC - DEC(ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}))
                                                                ELSE "".   /* Add by C.Q. 23/03/2000 */
     ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(X-NEWPRE).
  END.
  x-password = FALSE.
  APPLY "ENTRY" TO ITEM.PorDto IN BROWSE {&BROWSE-NAME}.
  RETURN NO-APPLY.
END.

ON "LEAVE":U OF ITEM.PorDto
DO:
  x-password = FALSE.
END.


ON "ANY-PRINTABLE":U OF ITEM.Por_Dsctos[1]
DO:
  RETURN NO-APPLY.
END.

ON "ENTRY":U OF ITEM.Por_Dsctos[1]
DO:
  IF NOT X-VALIDA THEN DO:
    APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

ON "ANY-PRINTABLE":U OF ITEM.PreUni
DO:
  IF NOT x-password THEN RETURN NO-APPLY.
END.

ON "ENTRY":U OF ITEM.PreUni
DO:
  IF NOT X-VALIDA THEN DO:
    APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

ON "F3":U OF ITEM.PreUni
DO:
  DEFINE VAR RPTA AS CHAR.
  DEFINE VAR NIV  AS CHAR.
  DEFINE VAR X-MAXDSC AS DEC.
  DEFINE VAR X-NEWDSC AS DEC.
  DEFINE VAR X-NEWPRE AS DEC.
  
  IF x-password = FALSE THEN DO:
      RUN VTA/D-CLAVE.R("P",
                        "PRECIOS",
                        OUTPUT NIV,
                        OUTPUT RPTA).
      IF RPTA = "ERROR" THEN x-password = FALSE.
      ELSE x-password = TRUE.
  END.
  IF x-password = TRUE THEN DO:
    RUN VTA/D-PREUNI.R(DEC(ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) + 
                       DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}),    /* Add by C.Q. 23/03/2000 */
                      DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}),
                      Almmmatg.UndBas,
                      output-var-2,
                      Almmmatg.PorMax,
                      Almmmatg.PreVta[1],
                      Almmmatg.MonVta,
                      Almmmatg.TpoCmb,
                      NIV,
                      OUTPUT X-NEWDSC,
                      OUTPUT X-NEWPRE
                      ).
/*     ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(X-NEWDSC).*/
     ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = IF X-NEWDSC <> 0 THEN 
                                                                STRING(X-NEWDSC - DEC(ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}))
                                                                ELSE "".   /* Add by C.Q. 23/03/2000 */
     ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(X-NEWPRE).
  END.
  x-password = FALSE.
  APPLY "ENTRY" TO ITEM.PreUni IN BROWSE {&BROWSE-NAME}.
  RETURN NO-APPLY.
END.

ON "LEAVE":U OF ITEM.PreUni
DO:
  x-password = FALSE.
END.

/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos B-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I AS INTEGER INIT 1 NO-UNDO.
   DEFINE VARIABLE C-CODIGO AS CHAR NO-UNDO.
   DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
   DEFINE VARIABLE I-NITM  AS INTEGER INIT 0 NO-UNDO.
   DEFINE VAR x-Prevta1 AS DECIMAL.
   DEFINE VAR x-Prevta2 AS DECIMAL.
   DEFINE VAR x-univta AS CHARACTER.

   I-NroItm = 0.
   FOR EACH B-ITEM BY B-ITEM.NroItm:
       N-ITMS = N-ITMS + 1.
       I-NroItm = B-ITEM.NroItm.
   END.  
   IF (N-ITMS + 1) > FacCfgGn.Items_PedMos  THEN RETURN "ADM-ERROR".
         
   ASSIGN input-var-1 = STRING(I-ListPr).
         
   RUN LKUP\C-AsgArt.r("ASIGNACION DE ARTICULOS").
   IF output-var-2 <> "" AND output-var-2 <> ? THEN DO:
      I-NITM = MAXIMUM(NUM-ENTRIES(output-var-2),(FacCfgGn.Items_PedMos - N-ITMS)).
      DO I = 1 TO NUM-ENTRIES(output-var-2) WHILE (N-ITMS + NUM-ENTRIES(output-var-2)) <= FacCfgGn.Items_PedMos :
         C-CODIGO = ENTRY(I,output-var-2).
         FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                        AND  Almmmate.CodAlm = S-CODALM 
                        AND  Almmmate.codmat = C-CODIGO 
                       NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almmmate THEN NEXT.
         RUN vta/stkdispo (s-codcia, s-codalm, C-CODIGO, 1, OUTPUT S-OK, OUTPUT S-STKDIS).
         IF S-OK = NO THEN NEXT.
         FIND B-ITEM WHERE B-ITEM.CODCIA = S-CODCIA 
                      AND  B-ITEM.CodMat = C-CODIGO 
                     NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-ITEM THEN DO:
            FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                           AND  Almmmatg.codmat = C-CODIGO 
                          NO-LOCK NO-ERROR.
            S-UNDBAS = Almmmatg.UndBas.
            I-NroItm = I-NroItm + 1.
            F-FACTOR = 1.
/*            RUN Calculo-Precios.*/
/******/
          ASSIGN x-Prevta1 = 0
                 x-Prevta2 = 0
                 x-univta = "".
    /****   PRECIO A    ****/
    IF Almmmatg.UndA <> "" THEN DO:
        x-univta = Almmmatg.UndA.
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN
          ASSIGN x-Prevta1 = Almmmatg.Prevta[2]
                 x-Prevta2 = ROUND(x-Prevta1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN x-Prevta2 = Almmmatg.Prevta[2]
                 x-Prevta1 = ROUND(x-Prevta2 * Almmmatg.TpoCmb,6).
    END.
    ELSE DO:

    /****   PRECIO C    ****/
    IF Almmmatg.UndB <> "" THEN DO:
        x-univta = Almmmatg.UndB.
        F-DSCTOS = Almmmatg.dsctos[2].
        IF Almmmatg.MonVta = 1 THEN
          ASSIGN x-Prevta1 = Almmmatg.Prevta[3]
                 x-Prevta2 = ROUND(x-Prevta1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN x-Prevta2 = Almmmatg.Prevta[3]
                 x-Prevta1 = ROUND(x-Prevta2 * Almmmatg.TpoCmb,6).
    END.
    ELSE DO:

    /****   PRECIO C    ****/
    IF Almmmatg.UndC <> "" THEN DO:
        x-univta = Almmmatg.UndC.
        F-DSCTOS = Almmmatg.dsctos[3].
        IF Almmmatg.MonVta = 1 THEN
          ASSIGN x-Prevta1 = Almmmatg.Prevta[4]
                 x-Prevta2 = ROUND(x-Prevta1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN x-Prevta2 = Almmmatg.Prevta[4]
                 x-Prevta1 = ROUND(x-Prevta2 * Almmmatg.TpoCmb,6).
    END.
    END.
    END.

    F-PREVTA = IF S-CODMON = 1 THEN x-Prevta1
                       ELSE x-Prevta2.

/******/            
            CREATE B-ITEM.
            ASSIGN B-ITEM.CodCia = S-CODCIA
                   B-ITEM.codmat = C-CODIGO
                   B-ITEM.NroItm = I-NroItm
                   B-ITEM.UndVta = x-univta
                   B-ITEM.Factor = F-FACTOR
                   B-ITEM.PreBas = F-PreBas 
                   B-ITEM.AftIgv = Almmmatg.AftIgv 
                   B-ITEM.AftIsc = Almmmatg.AftIsc
                   B-ITEM.PreUni = F-PREVTA
                   B-ITEM.PorDto = F-DSCTOS
                   B-ITEM.CanPed = 1
                   B-ITEM.AlmDes = S-CODALM
                   B-ITEM.Por_Dsctos[1] = 0
                   B-ITEM.ImpDto = ROUND( B-ITEM.PreUni * (B-ITEM.Por_Dsctos[1] / 100) * B-ITEM.CanPed , 2 ).
                   B-ITEM.ImpLin = ROUND( B-ITEM.PreUni * B-ITEM.CanPed , 2 ) /*- B-ITEM.ImpDto*/.
            IF B-ITEM.AftIsc THEN 
               B-ITEM.ImpIsc = ROUND(B-ITEM.PreBas * B-ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            IF B-ITEM.AftIgv THEN  
               B-ITEM.ImpIgv = B-ITEM.ImpLin - ROUND(B-ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
         END.
      END.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
   END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios B-table-Win 
PROCEDURE Calculo-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*   F-PorImp = 1.
 *    IF Almmmatg.AftIsc THEN F-PorImp = (1 + Almmmatg.PorIsc / 100).
 *    IF Almmmatg.AftIgv THEN F-PorImp = F-PorImp * (1 + FacCfgGn.PorIgv / 100).
 *    IF S-CODMON = 1 THEN DO:
 *       IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = Almmmatg.PreBas * F-PorImp * F-FACTOR.
 *       ELSE ASSIGN F-PREBAS = ROUND(Almmmatg.PreBas * F-PorImp,2) * FacCfgGn.Tpocmb[1] * F-FACTOR.
 * /*    ELSE ASSIGN F-PREBAS = Almmmatg.PreBas * F-FACTOR * FacCfgGn.Tpocmb[1] .  */
 *    END.
 *    IF S-CODMON = 2 THEN DO:
 *       IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = Almmmatg.PreBas * F-PorImp * F-FACTOR.
 *       ELSE ASSIGN F-PREBAS = (Almmmatg.PreBas * F-PorImp / FacCfgGn.Tpocmb[1]) * F-FACTOR.
 * 
 * /*    ELSE ASSIGN F-PREBAS = (Almmmatg.PreBas / FacCfgGn.Tpocmb[1]) * F-FACTOR.*/      
 *    END.
 *    CASE I-ListPr:
 *         WHEN 2 THEN F-DSCTOS = Almmmatg.PorVta[1].
 *         WHEN 3 THEN F-DSCTOS = Almmmatg.PorVta[2].
 *         WHEN 4 THEN DO:
 *                F-DSCTOS = 0.
 *                F-PREBAS = F-PREBAS * (1 + (Almmmatg.PorVta[4] / 100)).
 *           END.
 *    END CASE. 
 *    
 *    F-PREVTA = ROUND(F-PREBAS,2).*/
      
/* F-PREVTA = ROUND(F-PREBAS * F-PorImp, 2).*/

    F-PREBAS = output-var-4.

/*    MaxCat = 0.
 *     MaxVta = 0.
 *     
 *     FIND ClfClie WHERE ClfClie.Categoria = gn-clie.clfCli
 *                  NO-LOCK NO-ERROR.
 *     IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc.
 * /*    ELSE DO:
 *  *         MESSAGE "Clasificacion de Cliente no existe"
 *  *                 VIEW-AS ALERT-BOX ERROR.
 *  * /*        RETURN.*/
 *  *     END.*/
 *     FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
 *                  AND  Dsctos.clfCli = "N" 
 *                 NO-LOCK NO-ERROR.
 *     IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
 * /*    ELSE DO:
 *  *         MESSAGE "Porcentaje para condicion de Venta no existe"
 *  *                 VIEW-AS ALERT-BOX ERROR.
 *  * /*        RETURN.*/
 *  *     END.*/
 * 
 *    IF NOT AVAIL ClfClie THEN
 *        F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
 *    ELSE
 *        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.*/
       
   F-DSCTOS = output-var-5.
   F-PREVTA = output-var-4.

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
ASSIGN F-ImpDes = 0
       F-ImpExo = 0
       F-ImpIgv = 0
       F-ImpIsc = 0
       F-ImpTot = 0
       F-TotBrt = 0
       F-ValVta = 0.
FOR EACH B-ITEM:
    F-ImpTot = F-ImpTot + B-ITEM.ImpLin.
    F-Igv = F-Igv + B-ITEM.ImpIgv.
    F-Isc = F-Isc + B-ITEM.ImpIsc.
    F-ImpDes = F-ImpDes + B-ITEM.ImpDto.
    IF NOT B-ITEM.AftIgv THEN F-ImpExo = F-ImpExo + B-ITEM.ImpLin.
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

S-IMPTOT = F-ImpTot.

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
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  I-NroITm = 0.
  X-ESTADO = FALSE.
  FOR EACH B-ITEM:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-ITEM.NroItm.
  END.
  IF (N-ITMS + 1) > FacCfgGn.Items_PedMos THEN DO:
     MESSAGE "El Numero de Items No Puede Ser Mayor a " FacCfgGn.Items_PedMos 
             VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
    I-NroItm = I-NroItm + 1.
    
  APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
  RETURN NO-APPLY.

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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN ITEM.CodCia = S-CODCIA
           ITEM.Factor = F-FACTOR
           ITEM.NroItm = I-NroItm.
  
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                   AND  Almmmatg.codmat = ITEM.codmat 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
/*       RUN Calculo-Precios.*/
       ASSIGN ITEM.PreBas = F-PreBas
              ITEM.AftIgv = Almmmatg.AftIgv
              ITEM.AftIsc = Almmmatg.AftIsc
              ITEM.Flg_factor = IF SW-LOG1 THEN "1" ELSE "0"   /* Add by C.Q. 23/03/2000 */
              ITEM.AlmDes = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              ITEM.PreUni = DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) /*F-PREVTA*/
              ITEM.PorDto = DEC(ITEM.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) /*F-DSCTOS*/
              ITEM.Por_Dsctos[1] = DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})    /* Add by C.Q. 23/03/2000 */
              ITEM.Por_Dsctos[2] = Almmmatg.PorMax    /* Add by C.Q. 23/03/2000 */
              ITEM.Por_Dsctos[3] = Y-DSCTOS .
              ITEM.ImpDto = ROUND( ITEM.PreUni * (ITEM.Por_Dsctos[1] / 100) * (IF SW-LOG1 THEN ITEM.CanPed ELSE (ITEM.CanPed * F-FACTOR)), 2 ).
/*              ITEM.ImpDto = 0.*/
              ITEM.ImpLin = ROUND( ITEM.PreUni * (IF SW-LOG1 THEN ITEM.CanPed ELSE (ITEM.CanPed * F-FACTOR)) , 2 ) - ITEM.ImpDto.
              ITEM.UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
       IF ITEM.AftIsc THEN
          ITEM.ImpIsc = ROUND(ITEM.PreBas * (IF SW-LOG1 THEN ITEM.CanPed ELSE (ITEM.CanPed * F-FACTOR)) * (Almmmatg.PorIsc / 100),4).
       IF ITEM.AftIgv THEN
          ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
    END.
  END.
  
  X-VALIDA = FALSE.
  
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

    X-VALIDA = FALSE.
    
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

  FOR EACH B-ITEM:
      I-NroItm = I-NroItm - 1.
      I-NroItm = B-ITEM.NroItm.
  END.

  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-ITEM BY B-ITEM.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = N-ITMS.
/*    MESSAGE B-ITEM.NROITM I-NROITM N-ITMS.*/

  END.


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
  
  DO WITH FRAME {&FRAME-NAME}:

  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND  gn-clie.CodCli = S-CODCLI 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN I-ListPr = INTEGER(gn-clie.TpoCli).

  RUN Imp-Total.
  
  END.

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
FOR EACH B-ITEM:
    F-FACTOR = B-ITEM.Factor.
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                   AND  Almmmatg.codmat = B-ITEM.codmat 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
       RUN Calculo-Precios.

        X-FACTOR = 1.
        X-PREVTA1 = 0.
        X-PREVTA2 = 0.
        SW-LOG1 = FALSE.
        
        /****   PRECIO C    ****/
        IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndC 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (B-ITEM.CanPed * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN  
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[3].
                IF Almmmatg.MonVta = 1 THEN
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                         
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
            END.
        END.
    
        /****   PRECIO B    ****/
        IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndB 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (B-ITEM.CanPed * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[2].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
            END.
        END.
    
        /****   PRECIO A    ****/
        IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:
            FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                             AND  B-Almtconv.Codalter = Almmmatg.UndA 
                            NO-LOCK NO-ERROR.
            IF AVAILABLE B-Almtconv THEN
               X-FACTOR = B-Almtconv.Equival.
    
            IF (B-ITEM.CanPed * F-FACTOR) >= 
               (0.25 * X-FACTOR) THEN
            DO:
                SW-LOG1 = TRUE.
                F-DSCTOS = Almmmatg.dsctos[1].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
            END.
            ELSE DO:
                SW-LOG1 = FALSE.
                F-DSCTOS = Almmmatg.dsctos[1].
                IF Almmmatg.MonVta = 1 THEN 
                  ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                         X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                         X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
                X-PREVTA1 = (X-PREVTA1 / X-FACTOR) /* * F-FACTOR*/.
                X-PREVTA2 = (X-PREVTA2 / X-FACTOR) /* * F-FACTOR*/.
            END.
        END.       
 
        Y-DSCTOS = 0.
        
        /************Descuento Promocional ************/
        DEFINE VAR J AS INTEGER .
        DO J = 1 TO 10 :
           IF Almmmatg.PromDivi[J] = S-CODDIV AND
                            TODAY >= Almmmatg.PromFchD[J] AND 
                            TODAY <= Almmmatg.PromFchH[J] THEN DO:
              F-DSCTOS = Almmmatg.PromDto[J] .         
              F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
              Y-DSCTOS = Almmmatg.PromDto[J] .
              SW-LOG1  = TRUE.
              
              FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                               AND  B-Almtconv.Codalter = B-ITEM.UndVta 
                               NO-LOCK NO-ERROR.
                 IF AVAILABLE B-Almtconv THEN
                     X-FACTOR = B-Almtconv.Equival.
                     IF Almmmatg.Monvta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                     ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                     X-PREVTA1 = X-PREVTA1 * X-FACTOR.
                     X-PREVTA2 = X-PREVTA2 * X-FACTOR.
              
              
           END.   
        END.
        /************************************************/
     
        /***************Descuento Volumen****************/
        IF B-ITEM.CanPed <> 0 THEN DO:
           DEFINE VAR X-RANGO AS INTEGER INIT 0.   
           DEFINE VAR X-CANTI AS DECI    INIT 0.   
           FIND B-Almtconv WHERE B-Almtconv.CodUnid = Almmmatg.UndBas 
                           AND  B-Almtconv.Codalter = B-ITEM.UndVta
                           NO-LOCK NO-ERROR.
           IF AVAILABLE B-Almtconv THEN DO:
              X-FACTOR = B-Almtconv.Equival.
              X-CANTI = B-ITEM.CanPed * X-FACTOR .
           END.
                       
           DO J = 1 TO 10 :
              IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
                 
                 IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
                 IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
                    X-RANGO  = Almmmatg.DtoVolR[J] .
                    F-DSCTOS = Almmmatg.DtoVolD[J] .         
                    F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
                    Y-DSCTOS = Almmmatg.DtoVolD[J] .
                    SW-LOG1  = TRUE.                                  
                    
                       IF Almmmatg.MonVta = 1 THEN 
                          ASSIGN X-PREVTA1 = F-PREVTA
                                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                       ELSE
                          ASSIGN X-PREVTA2 = F-PREVTA
                                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                          X-PREVTA1 = X-PREVTA1 * X-FACTOR.
                          X-PREVTA2 = X-PREVTA2 * X-FACTOR.                                        
                 END.   
              END.   
           END.
         END.        
        /************************************************/
       
        IF S-CODMON = 1 THEN 
            F-PREVTA = X-PREVTA1.
        ELSE 
            F-PREVTA = X-PREVTA2.

       ASSIGN B-ITEM.PreBas = F-PreBas
              B-ITEM.AftIgv = Almmmatg.AftIgv
              B-ITEM.AftIsc = Almmmatg.AftIsc
              B-ITEM.PreUni = F-PREVTA
              B-ITEM.PorDto = F-DSCTOS
              B-ITEM.Por_Dsctos[2] = Almmmatg.PorMax    /* Add by C.Q. 23/03/2000 */
              B-ITEM.Por_Dsctos[3] = Y-DSCTOS .
              B-ITEM.ImpDto = ROUND( B-ITEM.PreUni * (B-ITEM.Por_Dsctos[1] / 100) * B-ITEM.CanPed , 2 ).
/*            B-ITEM.ImpDto = 0.*/
              B-ITEM.ImpLin = ROUND( B-ITEM.PreUni * B-ITEM.CanPed , 2 ) - B-ITEM.ImpDto.
     IF B-ITEM.AftIsc THEN
        B-ITEM.ImpIsc = ROUND(B-ITEM.PreBas * B-ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
     IF B-ITEM.AftIgv THEN
        B-ITEM.ImpIgv = B-ITEM.ImpLin - ROUND(B-ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).


/*
     ASSIGN B-ITEM.PreBas = F-PreBas
            B-ITEM.AftIgv = Almmmatg.AftIgv
            B-ITEM.AftIsc = Almmmatg.AftIsc
            B-ITEM.PreUni = F-PREVTA
            B-ITEM.PorDto = F-DSCTOS
            B-ITEM.ImpDto = ROUND( B-ITEM.PreUni * (F-DSCTOS / 100) * B-ITEM.CanPed , 2 ).
            B-ITEM.ImpLin = ROUND( B-ITEM.PreUni * B-ITEM.CanPed , 2 ) - B-ITEM.ImpDto.
     IF B-ITEM.AftIsc THEN
        B-ITEM.ImpIsc = ROUND(B-ITEM.PreBas * B-ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
     IF B-ITEM.AftIgv THEN
        B-ITEM.ImpIgv = B-ITEM.ImpLin - ROUND(B-ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
*/
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
        WHEN "codmat" THEN ASSIGN input-var-1 = STRING(I-ListPr).
        WHEN "UndVta" THEN ASSIGN input-var-1 = S-UNDBAS.
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
  
  SW-STADO = p-state.

  IF p-state = 'update-begin':U THEN DO:
     X-ESTADO = TRUE.
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
/*     APPLY "ENTRY" TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.*/
  END.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
/*
  APPLY "ENTRY" TO ITEM.CanPed IN BROWSE {&BROWSE-NAME}.
  RETURN NO-APPLY.
*/
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
IF INTEGER(ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
               AND  Almmmatg.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF DECIMAL(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
/*FIND FIRST B-ITEM WHERE 
 *      B-ITEM.CODCIA = S-CODCIA AND  
 *      B-ITEM.CodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND  
 *      B-ITEM.UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} NO-LOCK NO-ERROR.
 * IF AVAILABLE  B-ITEM AND ROWID(B-ITEM) <> ROWID(ITEM) THEN DO:
 *    MESSAGE "Codigo de Articulo con Unidad de Venta repetido" VIEW-AS ALERT-BOX ERROR.
 *    RETURN "ADM-ERROR".
 * END.*/
FIND FIRST B-ITEM WHERE 
     B-ITEM.CODCIA = S-CODCIA AND  
     B-ITEM.CodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
     NO-LOCK NO-ERROR.
IF AVAILABLE  B-ITEM AND ROWID(B-ITEM) <> ROWID(ITEM) THEN DO:
   MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
               AND  Almmmate.CodAlm = S-CODALM 
               AND  Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE "Articulo no asignado al almacen" s-codalm VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

IF S-CNDVTA <> "002" THEN DO:
    RUN vta/stkdispo (s-codcia, 
                      ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} /*s-codalm*/, 
                      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                      F-FACTOR * DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 
                      OUTPUT S-OK, 
                      OUTPUT S-STKDIS /*,
                      OUTPUT S-STKCOM */
                      ).
    IF S-OK = NO THEN DO:
        FIND buf-almmmate WHERE buf-Almmmate.CodCia = s-codcia 
                           AND  buf-Almmmate.CodAlm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
                           AND  buf-Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
                          NO-LOCK NO-ERROR.
        IF NOT AVAILABLE buf-almmmate THEN DO:
            MESSAGE "Producto no esta registrado" SKIP
                    "en Almmmate" SKIP
                    VIEW-AS ALERT-BOX WARNING.
        END.
        
        MESSAGE "No hay STOCK disponible" SKIP(1)
                "       STOCK ACTUAL : " buf-almmmate.StkAct SKIP
                " STOCK COMPROMETIDO : " S-STKCOM SKIP
                "   STOCK DISPONIBLE : " S-STKDIS SKIP
                VIEW-AS ALERT-BOX ERROR.
        RELEASE buf-almmmate.
        RETURN "ADM-ERROR".
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
IF NOT AVAILABLE ITEM THEN RETURN "ADM-ERROR".
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
     Almmmatg.codmat = ITEM.codmat NO-LOCK NO-ERROR.
S-UNDBAS = Almmmatg.UndBas.
I-NroItm = ITEM.NroItm.
F-FACTOR = ITEM.Factor.
output-var-2 = ITEM.UndVta.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

