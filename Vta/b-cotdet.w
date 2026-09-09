&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED BUFFER b-Almdmov FOR Almdmov.
DEFINE SHARED TEMP-TABLE DMOV LIKE Almdmov.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEFINE SHARED VARIABLE s-codcia  AS INT.
DEFINE SHARED VARIABLE PV-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB  AS DECIMAL.  
DEFINE SHARED VARIABLE s-codalm  AS CHAR.
DEFINE SHARED VARIABLE s-coddiv  AS CHAR.
DEFINE SHARED VARIABLE cl-codcia AS INT.

DEFINE SHARED VARIABLE p-monto  AS DECIMAL.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE Price       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dMargen     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dCto        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE List        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dPriceList  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dNewPrice   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotDif     AS DECIMAL     NO-UNDO.

DEFINE VARIABLE lOk AS LOGICAL     NO-UNDO.
DEFINE VARIABLE x-lista  AS LOGICAL.
/*
DEFINE TEMP-TABLE ttalmdmov
    FIELDS nrodoc LIKE almcmov.nrorf1
    FIELDS codpro LIKE almcmov.codpro
    FIELDS nompro LIKE gn-prov.nompro
    FIELDS fchdoc AS DATE
    FIELDS codmat LIKE almmmatg.codmat
    FIELDS desmat LIKE almmmatg.desmat
    FIELDS preuni LIKE almmmatg.prebas.
    
*/

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacDPedi.codmat Almmmatg.DesMat ~
List @ List FacDPedi.UndVta FacDPedi.CanPed dPriceList @ dPriceList ~
Price @ Price dNewPrice @ dNewPrice dTotDif @ dTotDif dMargen @ dMargen ~
FacDPedi.PorDto FacDPedi.Por_Dsctos[1] dCto @ dCto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = FacDPedi.CodCia ~
  AND Almmmatg.codmat = FacDPedi.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = FacDPedi.CodCia ~
  AND Almmmatg.codmat = FacDPedi.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacDPedi
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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacDPedi.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 10.57
      Almmmatg.DesMat FORMAT "X(45)":U
      List @ List COLUMN-LABEL "Lista" FORMAT "X(3)":U
      FacDPedi.UndVta FORMAT "XXXX":U
      FacDPedi.CanPed FORMAT ">,>>>,>>9.9999":U
      dPriceList @ dPriceList COLUMN-LABEL "Precio Lista" FORMAT "->>,>>>,>>9.9999":U
      Price @ Price COLUMN-LABEL "Precio Unit." FORMAT "->>,>>>,>>9.9999":U
      dNewPrice @ dNewPrice COLUMN-LABEL "Precio Calc" FORMAT "->>,>>>,>>9.9999":U
      dTotDif @ dTotDif COLUMN-LABEL "Diferencia" FORMAT "->>,>>>,>>9.9999":U
      dMargen @ dMargen COLUMN-LABEL "% Margen" FORMAT "->>,>>>,>>9.9999":U
      FacDPedi.PorDto COLUMN-LABEL "% Dscto 1." FORMAT ">>9.99":U
      FacDPedi.Por_Dsctos[1] COLUMN-LABEL "% Dscto 2" FORMAT "->>9.99":U
      dCto @ dCto COLUMN-LABEL "Costo" FORMAT "->>,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 124 BY 8.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-Almdmov B "NEW SHARED" ? INTEGRAL Almdmov
      TABLE: DMOV T "SHARED" ? INTEGRAL Almdmov
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
         HEIGHT             = 9.69
         WIDTH              = 127.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

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

ASSIGN 
       FacDPedi.codmat:AUTO-RESIZE IN BROWSE br_table = TRUE
       dCto:VISIBLE IN BROWSE br_table = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi,INTEGRAL.Almmmatg WHERE INTEGRAL.FacDPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ","
     _JoinCode[2]      = "Almmmatg.CodCia = FacDPedi.CodCia
  AND Almmmatg.codmat = FacDPedi.codmat"
     _FldNameList[1]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "10.57" yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > "_<CALC>"
"List @ List" "Lista" "X(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.FacDPedi.UndVta
     _FldNameList[5]   = INTEGRAL.FacDPedi.CanPed
     _FldNameList[6]   > "_<CALC>"
"dPriceList @ dPriceList" "Precio Lista" "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"Price @ Price" "Precio Unit." "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"dNewPrice @ dNewPrice" "Precio Calc" "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"dTotDif @ dTotDif" "Diferencia" "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"dMargen @ dMargen" "% Margen" "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacDPedi.PorDto
"FacDPedi.PorDto" "% Dscto 1." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacDPedi.Por_Dsctos[1]
"FacDPedi.Por_Dsctos[1]" "% Dscto 2" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"dCto @ dCto" "Costo" "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
    FOR EACH dmov: 
        DELETE dmov. 
    END.                                             
    RUN Carga-OrdCmp.    

 /************ 

  /*RUN Vta\w-detordcmp2 .*/
       RUN Vta\w-detordcmp0.w PERSISTENT.
  MESSAGE "vUELVE"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

    
      OPEN QUERY BROWSE-4 FOR EACH B-almdmov WHERE
        B-almdmov.CodCia = FacDPedi.CodCia AND
        b-almdmov.tipmov = "I" AND
        b-almdmov.codmov = 02  AND 
        B-almdmov.CodMat = FacDPedi.CodMat NO-LOCK /*INDEXED-REPOSITION*/ .  
  /*
  APPLY "VALUE-CHANGED" TO SELF.
  */
  
  ***********/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
  
    DEFINE VARIABLE f-Dscto  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-cto1   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-cto2   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-cto    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-uni    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-margen AS DECIMAL     NO-UNDO.
     
    F-DSCTO = DEC(FacDPedi.Por_DSCTOS[1]).
    Price = ((FacDPedi.Preuni / ( 1 - FacDPedi.Por_DSCTOS[1] / 100 ) - (FacDPedi.Preuni / ( 1 - FacDPedi.Por_DSCTOS[1] / 100 ) * (F-DSCTO / 100) ))).

    /* CALCULO DEL MARGEN */
    ASSIGN
        x-cto1 = 0
        x-cto2 = 0
        x-cto  = 0
        x-uni  = 0
        x-uni    = Price
        x-margen = Almmmatg.CtoTot.

    IF Almmmatg.MonVta = 1 THEN
        ASSIGN 
          x-cto1 = x-margen
          x-cto2 = ROUND(x-margen / FacCPedi.TpoCmb,4).
    ELSE
        ASSIGN 
            x-cto2 = x-margen
            x-cto1 = ROUND(x-margen * FacCPedi.TpoCmb,4).
    ASSIGN
        x-cto    = IF FacCPedi.CodMon = 1 THEN x-cto1 ELSE x-cto2
        x-margen = ROUND((( x-uni - x-cto ) / x-cto) * 100 ,2).
        dMargen = x-margen.

    IF FacDPedi.Por_Dscto[1] <> 0 THEN dMargen:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
    IF dMargen < 0 THEN dMargen:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
    
    /*Lista de Campaña*/
    List = ''.
    dPriceList = 0.
    IF x-lista THEN DO:
        FIND FIRST VtaCatCam WHERE VtaCatCam.CodCia = s-codcia
            AND VtaCatCam.CodMat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE VtaCatCam THEN DO:
            ASSIGN 
                List        = '***'.
            IF VtaCatCam.MonVta = 2 THEN dPriceList  = (VtaCatCam.Prevta[1] * VtaCatCam.TpoCmb).
            ELSE dPriceList  = VtaCatCam.Prevta[1].
        END.
        ELSE DO:
            FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.CodMat = FacDPedi.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN DO:
                IF Almmmatg.MonVta = 2 THEN dPriceList  = (Almmmatg.PreOfi * Almmmatg.TpoCmb).
                ELSE dPriceList  = Almmmatg.PreOfi.
            END.
        END.
    END.
    ELSE DO:
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.CodMat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO:
            IF Almmmatg.MonVta = 2 THEN dPriceList  = (Almmmatg.PreOfi * Almmmatg.TpoCmb).
            ELSE dPriceList  = Almmmatg.PreOfi.
        END.
    END.

    /*Precio Sugerido*/ 
    dNewPrice = 0.
    dTotDif   = 0.
    dNewPrice = (dPriceList * (1 - (p-monto / 100))).    
    dTotDif   = (Price - dNewPrice).
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-OrdCmp B-table-Win 
PROCEDURE Carga-OrdCmp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE u AS INTEGER     NO-UNDO.
    FOR EACH almdmov USE-INDEX Almd03
        WHERE almdmov.codcia = s-CodCia
        AND almdmov.codalm = s-codalm
        AND almdmov.CodMat = FacDPEdi.CodMat 
        AND almdmov.fchdoc <= TODAY
        AND almdmov.TipMov = "I"
        AND almdmov.CodMov = 02 NO-LOCK
        BREAK BY almdmov.fchdoc DESC:

        FIND FIRST dmov WHERE dmov.nrodoc = almdmov.nrodoc NO-LOCK NO-ERROR.
        IF NOT AVAIL dmov THEN DO:
            CREATE dmov.
            BUFFER-COPY almdmov TO dmov.   
            ASSIGN 
                DMOV.PreBas = DECIMAL(Price:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
                DMOV.CodMon = FacCPedi.CodMon.

            u = u + 1.
        END.
        IF u = 5 THEN LEAVE.
        PAUSE 0.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
  /*Si es un cliente especial*/
  x-lista = NO.
  FIND FIRST VtaCliCam WHERE VtaCliCam.CodCia = cl-codcia
      AND VtaCliCam.Codcli = FacCPedi.CodCli NO-LOCK NO-ERROR.
  IF AVAIL VtaCliCam THEN x-lista = YES.
  
  /* Code placed here will execute PRIOR to standard behavior. */ 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  lOk = br_table:REFRESH() IN FRAME {&FRAME-NAME}.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula B-table-Win 
PROCEDURE Recalcula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    {&OPEN-QUERY-{&BROWSE-NAME}}
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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "FacDPedi"}
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
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

