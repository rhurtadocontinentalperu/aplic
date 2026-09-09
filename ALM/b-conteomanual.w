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

DEFINE VARIABLE iNroPag AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNroSec AS INTEGER     NO-UNDO.
DEFINE VARIABLE iHour  AS INTEGER INITIAL 3600000 NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-br_table tmp-AlmDInv.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.UndBas tmp-AlmDInv.QtyConteo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tmp-AlmDInv.codmat ~
tmp-AlmDInv.QtyConteo 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tmp-AlmDInv
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tmp-AlmDInv
&Scoped-define QUERY-STRING-br_table FOR EACH tmp-AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND tmp-AlmDInv.Codcia = s-codcia ~
 AND tmp-AlmDInv.CodAlm = txt-almacen NO-LOCK, ~
      EACH Almmmatg OF tmp-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tmp-AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND tmp-AlmDInv.Codcia = s-codcia ~
 AND tmp-AlmDInv.CodAlm = txt-almacen NO-LOCK, ~
      EACH Almmmatg OF tmp-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tmp-AlmDInv Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tmp-AlmDInv
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-almacen txt-ubicacion txt-contador ~
br_table BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS txt-almacen txt-ubicacion txt-contador 

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
     IMAGE-UP FILE "IMG/save.bmp":U
     LABEL "Grabar" 
     SIZE 11.72 BY 1.62.

DEFINE BUTTON BUTTON-4 AUTO-GO 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Grabar" 
     SIZE 11.72 BY 1.62.

DEFINE VARIABLE txt-almacen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txt-contador AS CHARACTER FORMAT "X(256)":U 
     LABEL "Contador" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE txt-ubicacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ubicacion" 
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
      tmp-AlmDInv.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 40
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 25
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U WIDTH 5
      tmp-AlmDInv.QtyConteo FORMAT "->>>,>>>,>>9.99":U
  ENABLE
      tmp-AlmDInv.codmat
      tmp-AlmDInv.QtyConteo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 104 BY 11.04
         FONT 4
         TITLE "Ingreso Manual de Conteo".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-almacen AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 6
     txt-ubicacion AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 10
     txt-contador AT ROW 1.27 COL 51 COLON-ALIGNED WIDGET-ID 14
     br_table AT ROW 2.23 COL 2
     BUTTON-3 AT ROW 7.46 COL 108 WIDGET-ID 12
     BUTTON-4 AT ROW 9.08 COL 108 WIDGET-ID 16
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
         HEIGHT             = 12.46
         WIDTH              = 119.72.
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
/* BROWSE-TAB br_table txt-contador F-Main */
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
 AND Temp-Tables.tmp-AlmDInv.CodAlm = txt-almacen"
     _FldNameList[1]   > Temp-Tables.tmp-AlmDInv.codmat
"tmp-AlmDInv.codmat" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tmp-AlmDInv.QtyConteo
"tmp-AlmDInv.QtyConteo" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Grabar */
DO:
  ASSIGN
      txt-almacen txt-contador txt-ubicacion.
  RUN Actualiza-Tabla.
  FOR EACH tmp-AlmDInv:
      DELETE tmp-AlmDInv.
  END.
  RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Grabar */
DO:
  RUN adm-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-almacen B-table-Win
ON LEAVE OF txt-almacen IN FRAME F-Main /* Almacén */
DO:
    IF {&SELF-NAME} <> '' THEN DO:
        FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
            AND Almacen.CodAlm = INPUT {&SELF-NAME} NO-LOCK NO-ERROR.
        IF NOT AVAIL Almacen THEN DO:
            MESSAGE "Almacen Inválido"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN 'ADM-ERROR'.            
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON "LEAVE":U OF tmp-AlmDInv.CodMat
DO:
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

   FIND FIRST AlmDInv WHERE AlmDInv.CodCia = s-codcia
       AND AlmDInv.CodAlm = txt-almacen
       AND AlmDInv.CodUbi = txt-ubicacion
       AND AlmDInv.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmDInv THEN DO:
       MESSAGE "Articulo ya registrado" VIEW-AS ALERT-BOX ERROR.
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
    DEFINE VARIABLE lCrea   AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE iNroPag AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroSec AS INTEGER     NO-UNDO.

    FOR EACH tmp-AlmDInv NO-LOCK:
        FIND FIRST AlmCInv 
            WHERE AlmcInv.CodCia = tmp-AlmDInv.CodCia
            AND AlmcInv.CodAlm    = tmp-AlmDInv.CodAlm
            AND AlmcInv.NroPagina = tmp-AlmDInv.NroPagina EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmCInv THEN DO:
            CREATE AlmCInv.
            ASSIGN
                AlmCInv.CodCia    = tmp-AlmDInv.CodCia
                AlmcInv.CodAlm    = tmp-AlmDInv.CodAlm    
                AlmcInv.NroPagina = tmp-AlmDInv.NroPagina .
        END.
        ASSIGN
            AlmCInv.SwConteo  = YES
            AlmCInv.CodUser   = s-user-id
            AlmCInv.FecUpdate = NOW + (24 * iHour)
            AlmCInv.CodUserCon = txt-contador.
        lCrea = YES.
    END.

    IF lCrea = YES THEN DO:
        FOR EACH tmp-AlmDInv NO-LOCK:
            iNroSec = iNroSec + 1.
            FIND FIRST AlmDInv
                WHERE AlmDInv.CodCia       = tmp-AlmDInv.CodCia
                AND   AlmDInv.CodAlm       = tmp-AlmDInv.CodAlm
                AND   AlmDInv.CodUbi       = tmp-AlmDInv.CodUbi
                AND   AlmDInv.NroPagina    = tmp-AlmDInv.NroPagina
                AND   AlmDInv.NroSecuencia = tmp-AlmDInv.NroSecuencia
                AND   AlmdInv.CodMAt       = tmp-AlmDInv.CodMat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE AlmDInv THEN DO:
                CREATE AlmDInv.
                BUFFER-COPY tmp-AlmDInv TO AlmDInv.
            END.       
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables B-table-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        txt-almacen 
        txt-contador 
        txt-ubicacion.
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

  RUN Asigna-Variables.

  /*Contador dentro del temporal*/
  FIND LAST tmp-AlmDInv WHERE tmp-AlmDInv.CodCia = s-codcia
      AND tmp-AlmDInv.CodAlm = txt-almacen
      /*AND tmp-AlmDInv.CodUbi = txt-ubicacion*/ NO-LOCK NO-ERROR.
  IF AVAILABLE tmp-AlmDInv THEN DO:
      iNroPag = tmp-AlmDInv.NroPagina.
      iNroSec = tmp-AlmDInv.NroSecuencia.      
      IF (iNroSec MOD 30) = 0 THEN DO:
          iNroPag = tmp-AlmDInv.NroPagina + 1.
          iNroSec = 0.
      END.
  END.
  ELSE DO:
      FIND LAST AlmDInv WHERE AlmDInv.CodCia = s-codcia
          AND AlmDInv.CodAlm = txt-almacen
          AND AlmDInv.NroPagina >= 9000
          /*AND AlmDInv.CodUbi = txt-ubicacion*/ NO-LOCK NO-ERROR.
      IF AVAILABLE AlmDInv THEN DO:
          iNroPag = AlmDInv.NroPagina.
          iNroSec = AlmDInv.NroSecuencia.
      END.
      ELSE DO:
          iNroPag = 9000.
          iNroSec = 0.
      END.
  END.

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
  ASSIGN
      tmp-AlmDInv.Codcia       = s-codcia
      tmp-AlmDInv.CodAlm       = txt-almacen
      tmp-AlmDInv.CodUbi       = txt-ubicacion
      tmp-AlmDInv.NroPagina    = iNroPag
      tmp-AlmDInv.NroSecuencia = iNroSec + 1
      tmp-AlmDInv.CodUserCon   = txt-contador  
      tmp-AlmDInv.FecCon       = NOW + (24 * iHour ).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */  
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

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    cCodMat = tmp-AlmDInv.CodMat:SCREEN-VALUE IN BROWSE {&browse-NAME}.
    FIND FIRST b-tmp WHERE b-tmp.CodCia = s-codcia
        AND b-tmp.CodMat = cCodMat NO-LOCK NO-ERROR.
    IF AVAILABLE b-tmp THEN DO:
        MESSAGE "Código del Artículo ya ha sido registrado"
            VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY' TO tmp-AlmDInv.codmat.
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

