&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-AlmDCdoc NO-UNDO LIKE AlmDCdoc.



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
DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-User-Id AS CHAR.
DEF SHARED VAR s-CodAlm AS CHAR.

/* VARIABLES A USAR EN EL BROWSE */
DEF VAR x-NomCli AS CHAR FORMAT 'x(45)' NO-UNDO.
DEF VAR x-CodAlm AS CHAR FORMAT 'x(3)'  NO-UNDO.
DEF VAR x-CodCli AS CHAR FORMAT 'x(11)' NO-UNDO.

DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES t-AlmDCdoc

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-AlmDCdoc.CodDoc t-AlmDCdoc.NroDoc ~
ENTRY(2,t-AlmDCdoc.CodCli,'|')  @ x-NomCli ~
ENTRY(3,t-AlmDCdoc.CodCli,'|')  @ x-CodAlm t-AlmDCdoc.Bultos ~
t-AlmDCdoc.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table t-AlmDCdoc.CodDoc ~
t-AlmDCdoc.NroDoc t-AlmDCdoc.Bultos t-AlmDCdoc.Observ 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table t-AlmDCdoc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table t-AlmDCdoc
&Scoped-define QUERY-STRING-br_table FOR EACH t-AlmDCdoc WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-AlmDCdoc WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-AlmDCdoc
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-AlmDCdoc


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-NroDoc br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroDoc FILL-IN-Cantidad 

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
DEFINE VARIABLE FILL-IN-Cantidad AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Guias Faltantes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de Hoja de Ruta" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1
     FONT 9 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-AlmDCdoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-AlmDCdoc.CodDoc FORMAT "x(15)":U WIDTH 7.43 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "G/R" 
                      DROP-DOWN-LIST 
      t-AlmDCdoc.NroDoc FORMAT "X(12)":U
      ENTRY(2,t-AlmDCdoc.CodCli,'|')  @ x-NomCli COLUMN-LABEL "Nombre" FORMAT "x(45)":U
      ENTRY(3,t-AlmDCdoc.CodCli,'|')  @ x-CodAlm COLUMN-LABEL "Alm." FORMAT "x(6)":U
      t-AlmDCdoc.Bultos FORMAT ">,>>>,>>9":U
      t-AlmDCdoc.Observ FORMAT "x(40)":U WIDTH 13.57
  ENABLE
      t-AlmDCdoc.CodDoc
      t-AlmDCdoc.NroDoc
      t-AlmDCdoc.Bultos
      t-AlmDCdoc.Observ
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 100 BY 13.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroDoc AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Cantidad AT ROW 1.27 COL 79 COLON-ALIGNED WIDGET-ID 4
     br_table AT ROW 2.62 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-AlmDCdoc T "?" NO-UNDO INTEGRAL AlmDCdoc
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
         HEIGHT             = 15.46
         WIDTH              = 106.29.
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
/* BROWSE-TAB br_table FILL-IN-Cantidad F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Cantidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-AlmDCdoc"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.t-AlmDCdoc.CodDoc
"t-AlmDCdoc.CodDoc" ? "x(15)" "character" ? ? ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," "G/R" ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-AlmDCdoc.NroDoc
"t-AlmDCdoc.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"ENTRY(2,t-AlmDCdoc.CodCli,'|')  @ x-NomCli" "Nombre" "x(45)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"ENTRY(3,t-AlmDCdoc.CodCli,'|')  @ x-CodAlm" "Alm." "x(6)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-AlmDCdoc.Bultos
"t-AlmDCdoc.Bultos" ? ">,>>>,>>9" "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-AlmDCdoc.Observ
"t-AlmDCdoc.Observ" ? ? "character" ? ? ? ? ? ? yes ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME t-AlmDCdoc.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-AlmDCdoc.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF t-AlmDCdoc.CodDoc IN BROWSE br_table /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN SELF:SCREEN-VALUE = "G/R".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-AlmDCdoc.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF t-AlmDCdoc.CodDoc IN BROWSE br_table /* Codigo */
DO:
    IF SELF:SCREEN-VALUE <> "" THEN DO:
      /* RUTINA CON EL SCANNER */
      CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):
        WHEN '1' THEN DO:           /* FACTURA */
            ASSIGN
                t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'FAC'.
        END.
        WHEN '9' THEN DO:           /* G/R */
            ASSIGN
                t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'G/R'.
        END.
        WHEN '3' THEN DO:           /* BOL */
            ASSIGN
                t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SUBSTRING(SELF:SCREEN-VALUE,2,3) +
                                                                        SUBSTRING(SELF:SCREEN-VALUE,6,6)
                SELF:SCREEN-VALUE = 'BOL'.
        END.
      END CASE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-AlmDCdoc.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-AlmDCdoc.NroDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF t-AlmDCdoc.NroDoc IN BROWSE br_table /* Numero */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND DI-RutaD OF DI-RutaC WHERE DI-RutaD.CodRef = t-AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND DI-RutaD.NroRef = t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  FIND Di-RutaG OF Di-RutaC WHERE Di-RutaG.serref = INTEGER(SUBSTRING(t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
      AND Di-RutaG.nroref = INTEGER(SUBSTRING(t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
      NO-LOCK NO-ERROR.
  FIND Di-RutaDG OF Di-RutaC WHERE Di-RutaDG.CodRef = t-AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND Di-RutaDG.NroRef = t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  ASSIGN
      x-CodCli = ''
      x-NomCli = ''
      x-CodAlm = ''.
  CASE TRUE:
      WHEN AVAILABLE Di-RutaD THEN DO:
          FIND CcbCDocu WHERE CcbCDocu.CodCia = DI-RutaD.CodCia AND 
              CcbCDocu.CodDoc = DI-RutaD.CodRef AND 
              CcbCDocu.NroDoc = DI-RutaD.NroRef 
              NO-LOCK NO-ERROR.
          IF AVAILABLE ccbcdocu THEN 
              ASSIGN
                x-CodCli = ccbcdocu.codcli
                x-NomCli = ccbcdocu.nomcli
                x-CodAlm = ccbcdocu.codalm.      
      END.
      WHEN AVAILABLE Di-RutaG THEN DO:
          FIND Almcmov WHERE Almcmov.CodAlm = Di-RutaG.CodAlm AND
              Almcmov.TipMov = Di-RutaG.Tipmov AND 
              Almcmov.CodMov = Di-RutaG.Codmov AND
              Almcmov.NroSer = Di-RutaG.serref AND 
              Almcmov.NroDoc = Di-RutaG.nroref
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almcmov THEN DO:
              ASSIGN
                  x-CodCli = almcmov.codcli
                  x-NomCli = almcmov.nomref
                  x-CodAlm = almcmov.codalm.
              /* 07.09.09 */
              IF x-nomcli = '' THEN DO:
                  FIND Almacen OF Almcmov NO-LOCK NO-ERROR.
                  IF AVAILABLE Almacen THEN x-nomcli = Almacen.Descripcion.
              END.
          END.
      END.
      WHEN AVAILABLE Di-RutaDG THEN DO:
          FIND CcbCDocu WHERE CcbCDocu.CodCia = DI-RutaDG.CodCia AND 
              CcbCDocu.CodDoc = DI-RutaDG.CodRef AND 
              CcbCDocu.NroDoc = DI-RutaDG.NroRef 
              NO-LOCK NO-ERROR.
          IF AVAILABLE ccbcdocu THEN 
              ASSIGN
                x-CodCli = ccbcdocu.codcli
                x-NomCli = ccbcdocu.nomcli
                x-CodAlm = ccbcdocu.codalm.      
      END.
      OTHERWISE DO:
          MESSAGE 'Comprobante NO registrado en la Hoja de Ruta' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
  END CASE.
  DISPLAY x-nomcli x-codalm WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc B-table-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* # de Hoja de Ruta */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  /* Buscamos la H/R */
  DEF VAR x-NroDoc AS CHAR NO-UNDO.

  IF SELF:SCREEN-VALUE BEGINS '*' THEN DO:
      x-NroDoc = REPLACE(SELF:SCREEN-VALUE,"*","").
      SELF:SCREEN-VALUE = x-NroDoc.
      FIND FacDocum WHERE FacDocum.CodCia = s-CodCia AND
          FacDocum.CodDoc = "H/R" AND
          FacDocum.CodCta[8] = SUBSTRING(x-NroDoc,1,3)
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE FacDocum THEN DO:
          MESSAGE 'El documento NO es una H/R' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
      x-NroDoc = SUBSTRING(x-NroDoc,4).
      SELF:SCREEN-VALUE = x-NroDoc.
  END.
  ELSE DO:
      x-NroDoc = SELF:SCREEN-VALUE.
  END.
  
  FIND DI-RutaC WHERE DI-RutaC.CodCia = s-CodCia AND
      DI-RutaC.CodDiv = s-CodDiv AND
      DI-RutaC.CodDoc = "H/R" AND 
      DI-RutaC.NroDoc = x-NroDoc AND
      DI-RutaC.Libre_l01 = YES AND
      DI-RutaC.FlgEst = "P"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DI-RutaC THEN DO:
      MESSAGE 'NO se ubicó la Hoja de Ruta' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  SELF:SENSITIVE = NO.
  ASSIGN {&self-name}.
  RUN Guias-Faltantes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF Bultos, t-AlmDCdoc.CodDoc, t-AlmDCdoc.NroDoc, t-AlmDCdoc.Observ
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Guias-Faltantes B-table-Win 
PROCEDURE Devuelve-Guias-Faltantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RETURN FILL-IN-Cantidad:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Comprobantes B-table-Win 
PROCEDURE Graba-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH t-AlmDCdoc:
    CREATE AlmDCDoc.
    BUFFER-COPY t-AlmDCDoc TO AlmDCDoc.
    ASSIGN
        AlmDCDoc.codcia  = s-codcia
        AlmDCDoc.fecha   = TODAY
        AlmDCDoc.hora    = STRING(TIME, 'HH:MM').
END.
RELEASE AlmDCDoc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Guias-Faltantes B-table-Win 
PROCEDURE Guias-Faltantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF VAR x-GuiasHR AS INT INIT 0 NO-UNDO.
FILL-IN-Cantidad = 0.

FOR EACH DI-RutaD OF DI-RutaC NO-LOCK:
    x-GuiasHR = x-GuiasHR + 1.
END.
FOR EACH Di-RutaG OF Di-RutaC NO-LOCK:
    x-GuiasHR = x-GuiasHR + 1.
END.
FOR EACH Di-RutaDG OF Di-RutaC NO-LOCK:
    x-GuiasHR = x-GuiasHR + 1.
END.
DEF BUFFER b-AlmDCdoc FOR t-AlmDCdoc.
FOR EACH b-AlmDCdoc NO-LOCK:
    x-GuiasHR = x-GuiasHR - 1.
END.
FILL-IN-Cantidad = x-GuiasHR.
DISPLAY FILL-IN-Cantidad WITH FRAME {&FRAME-NAME}.

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
  IF TRUE <> (FILL-IN-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} > '')
      THEN DO:
      MESSAGE 'Debe ingresar la Hoja de Ruta' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
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
  ASSIGN
      t-AlmDCdoc.codcia  = s-codcia
      t-AlmDCdoc.coddoc  = CAPS(t-AlmDCdoc.coddoc)
      t-AlmDCdoc.usuario = s-User-Id
      t-AlmDCdoc.codalm  = s-CodAlm
      t-AlmDCdoc.fecha   = TODAY
      t-AlmDCdoc.hora    = STRING(TIME, 'HH:MM')
      t-AlmDCdoc.codcli  = x-CodCli + '|' + x-NomCli + '|' + x-CodAlm.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Guias-Faltantes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Buttons').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Disable-Buttons').

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
  RUN Guias-Faltantes.

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
  {src/adm/template/snd-list.i "t-AlmDCdoc"}

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

  /* NO se puede repetir el comprobante */
  IF CAN-FIND(FIRST t-AlmDCdoc WHERE t-AlmDCdoc.CodDoc = t-AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              AND t-AlmDCdoc.NroDoc = t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              NO-LOCK)
      THEN DO:
      MESSAGE 'Comprobante repetido' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO t-AlmDCdoc.NroDoc.
      RETURN 'ADM-ERROR'.
  END.
  FIND DI-RutaD OF DI-RutaC WHERE DI-RutaD.CodRef = t-AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND DI-RutaD.NroRef = t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  FIND Di-RutaG OF Di-RutaC WHERE Di-RutaG.serref = INTEGER(SUBSTRING(t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,3))
      AND Di-RutaG.nroref = INTEGER(SUBSTRING(t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4))
      NO-LOCK NO-ERROR.
  FIND Di-RutaDG OF Di-RutaC WHERE Di-RutaDG.CodRef = t-AlmDCdoc.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND Di-RutaDG.NroRef = t-AlmDCdoc.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF AVAILABLE Di-RutaD OR AVAILABLE Di-RutaG OR AVAILABLE Di-RutaDG THEN RETURN 'OK'.
  ELSE DO:
      MESSAGE 'Comprobante NO registrado en la Hoja de Ruta' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO t-AlmDCdoc.NroDoc.
      RETURN 'ADM-ERROR'.
  END.

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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.

  RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

