&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tmp-AlmDInv NO-UNDO LIKE AlmDInv.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia     AS INTEGER INIT 1.
DEF SHARED VAR s-user-id    AS CHARACTER.
DEF SHARED VAR s-codalm     AS CHARACTER.

DEFINE VARIABLE iNroPag AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNroSec AS INTEGER     NO-UNDO.
DEFINE VARIABLE iHour   AS INTEGER INITIAL 3600000 NO-UNDO.

DEFINE VARIABLE iNroPagina AS INTEGER   NO-UNDO.
DEFINE VARIABLE cCodMat    AS CHARACTER NO-UNDO.
DEFINE VARIABLE dFchInv    AS DATE        NO-UNDO.

DEFINE VARIABLE lSave      AS LOGICAL NO-UNDO INIT NO.

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
&Scoped-define INTERNAL-TABLES tmp-AlmDInv Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tmp-AlmDInv.CodUbi ~
tmp-AlmDInv.codmat Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas ~
tmp-AlmDInv.QtyConteo tmp-AlmDInv.CodUserCon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tmp-AlmDInv.CodUbi ~
tmp-AlmDInv.codmat tmp-AlmDInv.QtyConteo tmp-AlmDInv.CodUserCon 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tmp-AlmDInv
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tmp-AlmDInv
&Scoped-define QUERY-STRING-br_table FOR EACH tmp-AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND tmp-AlmDInv.Codcia = s-codcia ~
 AND tmp-AlmDInv.CodAlm = "11x" NO-LOCK, ~
      EACH Almmmatg OF tmp-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tmp-AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND tmp-AlmDInv.Codcia = s-codcia ~
 AND tmp-AlmDInv.CodAlm = "11x" NO-LOCK, ~
      EACH Almmmatg OF tmp-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tmp-AlmDInv Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tmp-AlmDInv
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-codmat br_table btn-consulta btn-save ~
btn-exit 
&Scoped-Define DISPLAYED-OBJECTS txt-codmat 

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
DEFINE BUTTON btn-consulta 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Grabar" 
     SIZE 10.43 BY 1.62.

DEFINE BUTTON btn-exit AUTO-GO 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Grabar" 
     SIZE 10.29 BY 1.62.

DEFINE BUTTON btn-save 
     IMAGE-UP FILE "IMG/save.bmp":U
     LABEL "Grabar" 
     SIZE 10.43 BY 1.62.

DEFINE VARIABLE txt-codmat AS CHARACTER FORMAT "X(8)":U 
     LABEL "Búsqueda por Articulo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tmp-AlmDInv, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tmp-AlmDInv.CodUbi FORMAT "x(6)":U
      tmp-AlmDInv.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 40
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 25
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U WIDTH 5
      tmp-AlmDInv.QtyConteo FORMAT "->>>,>>>,>>9.99":U
      tmp-AlmDInv.CodUserCon FORMAT "x(8)":U
  ENABLE
      tmp-AlmDInv.CodUbi
      tmp-AlmDInv.codmat
      tmp-AlmDInv.QtyConteo
      tmp-AlmDInv.CodUserCon
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 116.72 BY 12.08
         FONT 4
         TITLE "Ingreso Manual de Conteo".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codmat AT ROW 1.27 COL 17 COLON-ALIGNED WIDGET-ID 20
     br_table AT ROW 2.31 COL 2.29
     btn-consulta AT ROW 6.46 COL 120.43 WIDGET-ID 18
     btn-save AT ROW 8.12 COL 120.43 WIDGET-ID 12
     btn-exit AT ROW 9.73 COL 120.57 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tmp-AlmDInv T "?" NO-UNDO INTEGRAL AlmDInv
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
         HEIGHT             = 13.92
         WIDTH              = 131.57.
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
/* BROWSE-TAB br_table txt-codmat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tmp-AlmDInv,INTEGRAL.Almmmatg OF Temp-Tables.tmp-AlmDInv"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "Temp-Tables.tmp-AlmDInv.Codcia = s-codcia
 AND Temp-Tables.tmp-AlmDInv.CodAlm = ""11x"""
     _FldNameList[1]   > Temp-Tables.tmp-AlmDInv.CodUbi
"tmp-AlmDInv.CodUbi" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tmp-AlmDInv.codmat
"tmp-AlmDInv.codmat" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tmp-AlmDInv.QtyConteo
"tmp-AlmDInv.QtyConteo" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tmp-AlmDInv.CodUserCon
"tmp-AlmDInv.CodUserCon" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Ingreso Manual de Conteo */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Ingreso Manual de Conteo */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Ingreso Manual de Conteo */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-consulta B-table-Win
ON CHOOSE OF btn-consulta IN FRAME F-Main /* Grabar */
DO:
    ASSIGN txt-codmat.
    RUN Carga-Temporal.
    RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit B-table-Win
ON CHOOSE OF btn-exit IN FRAME F-Main /* Grabar */
DO:
    IF NOT lSave THEN DO:
        MESSAGE 'Asegurese de haber grabado' SKIP
                'para no perder los cambios' SKIP
                '     ¿Desea Continuar?    '
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE "" UPDATE choice AS LOGICAL.
        CASE choice:
            WHEN YES THEN RUN adm-exit.
            OTHERWISE RETURN "ADM-ERROR".
        END CASE. 
    END.
    ELSE RUN adm-exit.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-save B-table-Win
ON CHOOSE OF btn-save IN FRAME F-Main /* Grabar */
DO:
    FIND FIRST tmp-AlmDInv NO-LOCK NO-ERROR.
    IF AVAILABLE tmp-AlmDInv THEN RUN Actualiza-Tabla.
    RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON "LEAVE":U OF tmp-AlmDInv.codmat, tmp-AlmDInv.CodUbi, tmp-AlmDInv.CodUserCon, tmp-AlmDInv.QtyConteo
DO:   
  IF tmp-AlmDInv.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
     APPLY "ENTRY" TO tmp-AlmDInv.CodMat IN BROWSE {&BROWSE-NAME}.
     RETURN NO-APPLY.
  END.
  APPLY "TAB":U.
    RETURN NO-APPLY.
END.

ON "RETURN":U OF tmp-AlmDInv.CodMat
DO:   
  IF tmp-AlmDInv.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
     APPLY "ENTRY" TO tmp-AlmDInv.CodMat IN BROWSE {&BROWSE-NAME}.
     RETURN NO-APPLY.
  END.
  APPLY "TAB":U.
    RETURN NO-APPLY.
END.

ON "LEAVE":U OF tmp-AlmDInv.CodMat
DO:
   IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN RETURN.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.   
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
       AND  Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.      
       RETURN NO-APPLY.
   END.
   FIND FIRST AlmDInv WHERE AlmDInv.CodCia = s-codcia
       AND AlmDInv.CodAlm = "11x"
       AND AlmDInv.NomCia = "CONTISTAND"
       /*AND AlmDInv.CodUbi = tmp-AlmDInv.CodUbi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}*/
       AND AlmDInv.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmDInv THEN DO:
       MESSAGE "Articulo ya registrado en página: " AlmDInv.NroPagina
           VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY. 
   END.
   DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
       Almmmatg.DesMar @ Almmmatg.DesMar
       Almmmatg.UndBas @ Almmmatg.UndBas
       WITH BROWSE {&BROWSE-NAME}.   
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Tabla B-table-Win 
PROCEDURE Actualiza-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lcCrea   AS LOGICAL  INIT NO NO-UNDO.
    DEFINE VARIABLE iNroPag  AS INTEGER  NO-UNDO.
    DEFINE VARIABLE iNroSec  AS INTEGER  NO-UNDO INIT 0.    

    /*Verifica si se cargo data*/
    FIND FIRST tmp-AlmDInv NO-LOCK NO-ERROR.
    IF NOT AVAIL tmp-AlmDInv THEN RETURN "ADM-ERROR".
    lcCrea = YES.

    /*Verifica si el almacen ha sido cargado*/
    FIND FIRST almcinv WHERE almcinv.codcia = s-codcia
        AND AlmCInv.CodAlm = "11x"
        AND AlmCInv.NomCia = "CONTISTAND" NO-LOCK NO-ERROR.
    IF AVAIL almcinv THEN dFchInv = DATE(almcinv.fecupdate).
    ELSE DO:
        MESSAGE "    No se ha cargado    " SKIP
                "informacion del almacen " 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "ADM-ERROR".
    END.

    /*Correlativo*/
    FIND LAST almdinv WHERE almdinv.codcia = s-codcia
        AND almdinv.codalm = "11x"
        AND almdinv.nomcia = "CONTISTAND" 
        AND almdinv.nropagina >= 9000 NO-LOCK NO-ERROR.
    MESSAGE  almdinv.nropagina SKIP
        almdinv.nrosecuencia.

    IF NOT AVAIL almdinv THEN
        ASSIGN
            iNroPag = 8999
            iNroSec = 0.
    ELSE DO:
        iNroPag = almdinv.nropagina.
        iNroSec = almdinv.nrosecuencia.
    END.

    
    FOR EACH tmp-AlmDInv NO-LOCK:
        MESSAGE tmp-AlmDInv.CodMat.
        FIND FIRST almdinv WHERE almdinv.codcia = s-codcia
            AND almdinv.codalm = "11x"
            AND almdinv.nomcia = "CONTISTAND"
            AND almdinv.codmat = tmp-AlmDInv.CodMat NO-ERROR.
        IF NOT AVAILABLE almdinv THEN DO:
            CREATE almdinv.
            IF iNroSec MOD 25 = 0 THEN DO: 
                iNroPag = iNroPag + 1.     
                iNroSec = 1.                
                lcCrea  = YES.
            END.
            ELSE DO: 
                iNroSec = iNroSec + 1.
                lcCrea  = NO.
            END.
            ASSIGN 
                almdinv.codcia       = s-codcia
                AlmDInv.NroPagina    = iNroPag
                AlmDInv.NroSecuencia = iNroSec
                AlmDInv.CodAlm       = tmp-AlmDInv.CodAlm
                AlmDInv.NomCia       = tmp-AlmDInv.NomCia
                AlmDInv.CodUbi       = tmp-AlmDInv.CodUbi
                AlmDInv.CodMat       = tmp-AlmDInv.CodMat
                AlmDInv.QtyConteo    = tmp-AlmDInv.QtyConteo
                AlmDInv.CodUserCon   = tmp-AlmDInv.CodUserCon
                AlmDInv.Libre_f01    = dFchInv
                AlmDInv.Libre_d01    = tmp-AlmDInv.QtyConteo.
            /*Actualiza Cabecera*/
            IF lcCrea THEN DO:
                CREATE almcinv.
                ASSIGN
                    AlmCInv.CodCia    = tmp-AlmDInv.CodCia
                    AlmcInv.CodAlm    = tmp-AlmDInv.CodAlm    
                    AlmcInv.NroPagina = iNroPag
                    AlmcInv.NomCia    = "CONTISTAND"
                    AlmCInv.SwConteo  = YES
                    AlmCInv.CodUser   = s-user-id
                    AlmCInv.FecUpdate = dFchInv.                
            END.
        END.
        ELSE DO:
            ASSIGN 
                AlmdInv.QtyConteo = tmp-AlmDInv.QtyConteo
                AlmdInv.libre_d01 = tmp-AlmDInv.QtyConteo.
        END.
    END.
    lSave = YES.
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
    /*Borra Temporal*/
    FOR EACH tmp-AlmDInv:
        DELETE tmp-AlmDInv.
    END.

    FOR EACH AlmDInv WHERE AlmDInv.CodCia = s-codcia
        AND AlmdInv.CodAlm    =  "11x"
        AND AlmDInv.NroPagina >= 9000
        AND AlmDInv.NomCia    =  "CONTISTAND"
        AND AlmDInv.CodMat BEGINS txt-codmat NO-LOCK:
        CREATE tmp-AlmDInv.
        BUFFER-COPY AlmDInv TO tmp-AlmDInv.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /*Contador dentro del temporal*/
  FIND LAST tmp-AlmDInv WHERE tmp-AlmDInv.CodCia = s-codcia
      AND tmp-AlmDInv.CodAlm = "11x"
      AND tmp-AlmDInv.NomCia = "CONTISTAND" NO-LOCK NO-ERROR.
  IF AVAILABLE tmp-AlmDInv THEN DO:
      iNroPag = tmp-AlmDInv.NroPagina.
      iNroSec = tmp-AlmDInv.NroSecuencia.  
  END.
  ELSE DO:
      iNroPag = 9000.
      iNroSec = 0.      
  END.
  lSave = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  FIND FIRST almcinv WHERE almcinv.codcia = s-codcia
      AND AlmCInv.CodAlm = "11x"
      AND AlmCInv.NomCia = "CONTISTAND" NO-LOCK NO-ERROR.
  IF AVAIL almcinv THEN dFchInv = DATE(almcinv.fecupdate).
  ELSE DO:
      MESSAGE "No existe informacion para este almacen" 
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY" TO tmp-AlmDInv.codmat IN BROWSE {&BROWSE-NAME}.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN
      tmp-AlmDInv.Codcia       = s-codcia
      tmp-AlmDInv.CodAlm       = "11x"      
      tmp-AlmDInv.NroPagina    = iNroPag
      tmp-AlmDInv.NroSecuencia = iNroSec + 1     
      tmp-AlmDInv.NomCia       = "CONTISTAND"
      tmp-AlmDInv.FecCon       = dFchInv.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN 
      iNroPagina = tmp-AlmDInv.NroPagina
      cCodMat    = tmp-AlmDInv.CodMat.

  MESSAGE "nropag " + STRING( inropagina).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  FIND FIRST AlmDInv WHERE AlmDIn.CodCia = s-CodCia
      AND AlmDInv.CodAlm    = "11x"
      AND AlmDInv.NomCia    = "CONTISTAND"
      AND AlmDInv.CodMat    = cCodMat EXCLUSIVE-LOCK NO-ERROR.
  IF AVAIL AlmDInv THEN DELETE AlmDInv.

  /*Busca Cabecera*/

  FIND FIRST almdinv WHERE almdinv.codcia = s-codcia
      AND almdinv.codalm = "11x"
      AND almdinv.nomcia = "CONTISTAND"
      AND almdinv.nropagina = iNroPagina NO-ERROR.
  IF NOT AVAIL almdinv THEN DO:
      FIND FIRST almcinv OF almdinv NO-ERROR.
      IF AVAIL almcinv THEN DELETE almcinv.
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
  {src/adm/template/snd-list.i "tmp-AlmDInv"}
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
DEFINE BUFFER b-tmp FOR tmp-AlmDInv.
DEFINE VARIABLE cCodMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dCantCont AS DECIMAL     NO-UNDO.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').

IF RETURN-VALUE = 'YES' THEN DO:
    cCodMat = tmp-AlmDInv.CodMat:SCREEN-VALUE IN BROWSE {&browse-NAME}.
    IF cCodMat <> '' THEN DO:
        FIND FIRST b-tmp WHERE b-tmp.CodCia = s-codcia
            AND b-tmp.NomCia = "CONTISTAND"
            AND b-tmp.CodMat = cCodMat NO-LOCK NO-ERROR.
        IF AVAILABLE b-tmp THEN DO:
            MESSAGE "Código del Artículo ya ha sido registrado"
                VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY' TO tmp-AlmDInv.codmat.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.

    dCantCont = DECIMAL(tmp-AlmDInv.QtyConteo:SCREEN-VALUE IN BROWSE {&browse-NAME}).
    IF dCantCont = 0 THEN DO:
        MESSAGE "Cantidad debe ser diferente de 0"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY 'ENTRY' TO tmp-AlmDInv.QtyConteo.
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
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

