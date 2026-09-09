&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttCcbDDocu NO-UNDO LIKE CcbDDocu.



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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VAR lh_handle AS HANDLE.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE ttLineasAutorizadas
    FIELD   tlinea  AS  CHAR.

/* Lineas asignadas a el usuario */
/*IF s-user-id <> 'ADMIN' THEN DO:*/
    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = 'LP' AND 
                                vtatabla.llave_c1 = s-user-id NO-LOCK:
        CREATE ttLineasAutorizadas.
            ASSIGN ttLineasAutorizadas.tlinea = vtatabla.llave_c2.
    END.
/*END.*/

DEFINE BUFFER x-almmmatg FOR almmmatg.

/* Partes de Ingreso Pendientes */
/* Se usa en : ccb/d-inconsistencias-pnc.r */
DEFINE TEMP-TABLE tt-pi-pendiente
    FIELD   ttipo       AS  CHAR
    FIELD   tcodalm     AS  CHAR
    FIELD   tserie      AS  INT     INIT 0
    FIELD   tnrodoc     AS  INT     INIT 0
    FIELD   tfchdoc     AS  DATE
    FIELD   ttabla      AS  CHAR
    FIELD   tcodmat     AS  CHAR
    FIELD   tmsgerror   AS  CHAR.

DEFINE TEMP-TABLE x-ttccbddocu LIKE ttccbddocu.

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttCcbDDocu Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ttCcbDDocu.AftIsc ttCcbDDocu.NroItm ~
ttCcbDDocu.codmat Almmmatg.DesMat Almmmatg.DesMar ttCcbDDocu.UndVta ~
ttCcbDDocu.CanDes ttCcbDDocu.PreUni ttCcbDDocu.ImpLin ~
ttCcbDDocu.ImpDcto_Adelanto[1] ttCcbDDocu.Por_Dsctos[1] ~
ttCcbDDocu.Por_Dsctos[2] ttCcbDDocu.Por_Dsctos[3] ttCcbDDocu.PreVta[1] ~
ttCcbDDocu.PreVta[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ttCcbDDocu.AftIsc 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ttCcbDDocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ttCcbDDocu
&Scoped-define QUERY-STRING-br_table FOR EACH ttCcbDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ttCcbDDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ttCcbDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ttCcbDDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ttCcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ttCcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-34 BUTTON-35 BUTTON-36 

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
DEFINE BUTTON BUTTON-34 
     LABEL "Seleccionar Todos" 
     SIZE 18.29 BY .92.

DEFINE BUTTON BUTTON-35 
     LABEL "Ninguno" 
     SIZE 18 BY .92.

DEFINE BUTTON BUTTON-36 
     LABEL "Grabar" 
     SIZE 18.29 BY .92
     BGCOLOR 2 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ttCcbDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ttCcbDDocu.AftIsc COLUMN-LABEL "Sele" FORMAT "Si/No":U VIEW-AS TOGGLE-BOX
      ttCcbDDocu.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U WIDTH 4.29
      ttCcbDDocu.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
            WIDTH 6.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 34.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 20.43
      ttCcbDDocu.UndVta FORMAT "x(8)":U WIDTH 5.43
      ttCcbDDocu.CanDes FORMAT ">,>>>,>>9.99":U WIDTH 6.43
      ttCcbDDocu.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">,>>>,>>9.9999":U
            WIDTH 7.43
      ttCcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 11.43
      ttCcbDDocu.ImpDcto_Adelanto[1] COLUMN-LABEL "Impte !Anterior" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 8.43 COLUMN-BGCOLOR 11
      ttCcbDDocu.Por_Dsctos[1] COLUMN-LABEL "Impte!Dsctos N/C" FORMAT "->>,>>9.99":U
            WIDTH 9.29 COLUMN-BGCOLOR 11
      ttCcbDDocu.Por_Dsctos[2] COLUMN-LABEL "Importe!Final" FORMAT "->>,>>9.99":U
            COLUMN-BGCOLOR 11
      ttCcbDDocu.Por_Dsctos[3] COLUMN-LABEL "Precio!Final" FORMAT "->>,>>9.9999":U
            WIDTH 8.43 COLUMN-BGCOLOR 11
      ttCcbDDocu.PreVta[1] COLUMN-LABEL "Nuevo!Precio" FORMAT "->>,>>9.9999":U
            WIDTH 9.43 COLUMN-BGCOLOR 11
      ttCcbDDocu.PreVta[2] COLUMN-LABEL "%Dscto" FORMAT "->,>>9.9999":U
            COLUMN-BGCOLOR 11
  ENABLE
      ttCcbDDocu.AftIsc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 115.86 BY 10.5
         FONT 4 ROW-HEIGHT-CHARS .42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.14
     BUTTON-34 AT ROW 3.88 COL 118 WIDGET-ID 6
     BUTTON-35 AT ROW 5.04 COL 118 WIDGET-ID 8
     BUTTON-36 AT ROW 6.19 COL 118 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ttCcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
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
         HEIGHT             = 10.65
         WIDTH              = 139.86.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ttCcbDDocu,INTEGRAL.Almmmatg OF Temp-Tables.ttCcbDDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.ttCcbDDocu.AftIsc
"ttCcbDDocu.AftIsc" "Sele" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttCcbDDocu.NroItm
"ttCcbDDocu.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttCcbDDocu.codmat
"ttCcbDDocu.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no "" no no "34.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttCcbDDocu.UndVta
"ttCcbDDocu.UndVta" ? ? "character" ? ? ? ? ? ? no "" no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttCcbDDocu.CanDes
"ttCcbDDocu.CanDes" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttCcbDDocu.PreUni
"ttCcbDDocu.PreUni" "Precio!Unitario" ">,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttCcbDDocu.ImpLin
"ttCcbDDocu.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttCcbDDocu.ImpDcto_Adelanto[1]
"ttCcbDDocu.ImpDcto_Adelanto[1]" "Impte !Anterior" ? "decimal" 11 ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ttCcbDDocu.Por_Dsctos[1]
"ttCcbDDocu.Por_Dsctos[1]" "Impte!Dsctos N/C" "->>,>>9.99" "decimal" 11 ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttCcbDDocu.Por_Dsctos[2]
"ttCcbDDocu.Por_Dsctos[2]" "Importe!Final" "->>,>>9.99" "decimal" 11 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ttCcbDDocu.Por_Dsctos[3]
"ttCcbDDocu.Por_Dsctos[3]" "Precio!Final" "->>,>>9.9999" "decimal" 11 ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.ttCcbDDocu.PreVta[1]
"ttCcbDDocu.PreVta[1]" "Nuevo!Precio" "->>,>>9.9999" "decimal" 11 ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ttCcbDDocu.PreVta[2]
"ttCcbDDocu.PreVta[2]" "%Dscto" "->,>>9.9999" "decimal" 11 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-34
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-34 B-table-Win
ON CHOOSE OF BUTTON-34 IN FRAME F-Main /* Seleccionar Todos */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").

    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST br_table.
        DO  WHILE AVAILABLE ttccbddocu:
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
            ASSIGN ttccbddocu.aftisc = YES.
            GET NEXT br_table.
        END.
    END.
    {&open-query-br_table}

    SESSION:SET-WAIT-STATE("").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-35
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-35 B-table-Win
ON CHOOSE OF BUTTON-35 IN FRAME F-Main /* Ninguno */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").

    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST br_table.
        DO  WHILE AVAILABLE ttccbddocu:
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
            ASSIGN ttccbddocu.aftisc = NO.
            GET NEXT br_table.
        END.
    END.
    {&open-query-br_table}

    SESSION:SET-WAIT-STATE("").  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-36
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-36 B-table-Win
ON CHOOSE OF BUTTON-36 IN FRAME F-Main /* Grabar */
DO:

    IF NOT AVAILABLE ttccbddocu THEN DO:
        MESSAGE "No existen items para grabar" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    
    DEFINE VAR x-aprobados AS INT.
    DEFINE VAR x-desaprobados AS INT.

    RUN validar-informacion(OUTPUT x-aprobados, OUTPUT x-desaprobados).

            
    MESSAGE "Seguro de :" SKIP
            "APROBAR    :" + STRING(x-aprobados,">,>>9") + " Item(s)" SKIP
            "DESAPROBAR :" + STRING(x-desaprobados,">,>>9") + " Item(s)" 
            VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.

    IF rpta = NO THEN RETURN NO-APPLY.

    RUN grabar-aprobaciones.

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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-aprobaciones B-table-Win 
PROCEDURE grabar-aprobaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").  

DEFINE VAR x-aprobado AS LOG.
DEFINE VAR x-articulo AS CHAR.
DEFINE VAR x-lineas-aprobas AS CHAR.
DEFINE VAR x-lineas-trabajadas AS CHAR.
DEFINE VAR x-msg-error AS CHAR.
DEFINE VAR x-nuevo-estado AS CHAR.

/* Valida que no supere la suma de las N/Cs al comprobante */
DEFINE VAR hxProc AS HANDLE NO-UNDO.            /* Handle Libreria */
DEFINE VAR x-retval AS CHAR.

RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
                                                 
RUN notas-creditos-supera-comprobante IN hxProc (INPUT ccbcdocu.codref,     /* FAC,BOL */
                                             INPUT ccbcdocu.nroref,     
                                             OUTPUT x-retval).

DELETE PROCEDURE hxProc.                        /* Release Libreria */

/* 
    pRetVal : NO (importes de N/C NO superan al comprobante)
*/
IF x-retval <> "NO" THEN DO:

    SESSION:SET-WAIT-STATE("").

    MESSAGE "El comprobante " + ccbcdocu.codref + " " + ccbcdocu.nroref SKIP
            " tiene emitida varias N/Cs que superan el monto total" SKIP 
            " del comprobante" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

x-lineas-aprobas = "".

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

/* Lineas trabajadas */
GET FIRST br_table.
DO  WHILE AVAILABLE ttccbddocu:
    FIND FIRST x-almmmatg OF ttccbddocu NO-LOCK NO-ERROR.    
    IF AVAILABLE x-almmmatg THEN DO:
        IF LOOKUP(x-almmmatg.codfam,x-lineas-aprobas) = 0 THEN DO:
            IF x-lineas-aprobas <> "" THEN x-lineas-aprobas = x-lineas-aprobas + ",".
            x-lineas-aprobas = x-lineas-aprobas + TRIM(x-almmmatg.codfam).
        END.
    END.
    GET NEXT br_table.
END.

x-msg-error = "GRABANDO DATOS...".

/* Verificamos todos los item de la PNC */
DEFINE VAR x-todos-revisados AS LOG.

EMPTY TEMP-TABLE x-ttccbddocu.

IF AVAILABLE ccbcdocu THEN DO:
    /* Cargo todos los Items en un temporal (x-ttccbddocu) */
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
        CREATE x-ttccbddocu.
        BUFFER-COPY ccbddocu TO x-ttccbddocu.
    END.
END.

/* Los que estan en pantalla actualizarlos en el temporal (x-ttccbddocu)*/
GET FIRST br_table.
DO  WHILE AVAILABLE ttccbddocu:
    x-articulo = {&FIRST-TABLE-IN-QUERY-br_table}.codmat.
    FIND FIRST x-ttccbddocu WHERE x-ttccbddocu.codmat = x-articulo EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE x-ttccbddocu THEN DO:
        IF {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES THEN DO:
            ASSIGN x-ttccbddocu.flg_factor = "APROBADO|ZZZZZ".
        END.
        ELSE DO:
            ASSIGN x-ttccbddocu.flg_factor = "EXCLUIDO|ZZZZZ".
        END.
    END.
    GET NEXT br_table.
END.

DEFINE VAR x-estados AS CHAR.

/* 
    x-estados, debe tener 3 espacios, A:Aprobado E:Excluido *:Aun no trabajado
    posicion 1 = A, posicion 2 = E,  posicion 3 = *
*/
x-estados = "   ".      
x-nuevo-estado = "T".

x-todos-revisados = YES.
VERIFICANDO:
FOR EACH x-ttccbddocu:
    IF TRUE <> (x-ttccbddocu.flg_factor > "") THEN DO:
        /* Aun sin revisar*/
        x-estados = SUBSTRING(x-estados,1,2) + "*".      /* POS 3 */
    END.
    ELSE DO:
        IF ENTRY(1,x-ttccbddocu.flg_factor,"|") = "APROBADO" THEN DO:
            x-estados = "A" + SUBSTRING(x-estados,2,2).     /* POS 1 */
        END.
        ELSE DO:
            x-estados = SUBSTRING(x-estados,1,1) + "E" + SUBSTRING(x-estados,3,1).      /* POS 2 */
        END.
    END.
    IF INDEX(x-estados," ") = 0 THEN DO:
        LEAVE VERIFICANDO.
    END.
END.

x-estados = REPLACE(x-estados," ","").

IF x-estados = "A" THEN x-nuevo-estado = "P".           /* APROBADO */
IF x-estados = "E" THEN x-nuevo-estado = "R".           /* Rechazado Total */
IF x-estados = "AE" THEN x-nuevo-estado = "AP".         /* Aceptacion Parcial */
IF x-estados = "A*" THEN x-nuevo-estado = "D".           /* En Proceso */
IF x-estados = "E*" THEN x-nuevo-estado = "D".           /* En Proceso */
IF x-estados = "AE*" THEN x-nuevo-estado = "D".         /* En Proceso */

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
    DO:
        /* Header update block */
        FIND FIRST b-ccbcdocu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.

        IF LOCKED b-ccbcdocu THEN DO:
            x-msg-error = "Tabla CCBCDOCU esta bloqueada".                
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        IF NOT AVAILABLE b-ccbcdocu THEN DO:
           x-msg-error = "Inconsistencia en la informacion - documento : " + ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc.
           UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.            
        END.

        x-lineas-trabajadas = "".
        IF NOT (TRUE <> (b-ccbcdocu.libre_c02 > "")) THEN DO:
            x-lineas-trabajadas = TRIM(b-ccbcdocu.libre_c02).
        END.
        IF x-lineas-trabajadas <> "" THEN x-lineas-trabajadas = x-lineas-trabajadas + ",".
        x-lineas-trabajadas = x-lineas-trabajadas + x-lineas-aprobas.

        /*
        /* Si todas las lineas fueron trabajados cambiar el estado a APROBADO */
        x-nuevo-estado = "D".
        /*IF TRIM(x-lineas-trabajadas) = TRIM(b-ccbcdocu.libre_c01) THEN x-nuevo-estado = "P".    /* APROBADO */*/
        IF x-todos-revisados = YES THEN x-nuevo-estado = "P".    /* APROBADO */
        */

        ASSIGN b-ccbcdocu.libre_c02 = TRIM(x-lineas-trabajadas)
                b-ccbcdocu.flgest = x-nuevo-estado NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg-error = "ERROR : " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.            

    END.

    GET FIRST br_table.
    DO  WHILE AVAILABLE ttccbddocu:
        x-aprobado = {&FIRST-TABLE-IN-QUERY-br_table}.aftisc.
        
        FIND FIRST ccbddocu USE-INDEX llave04 WHERE ccbddocu.codcia = {&FIRST-TABLE-IN-QUERY-br_table}.codcia AND
                                                ccbddocu.coddiv = {&FIRST-TABLE-IN-QUERY-br_table}.coddiv AND
                                                ccbddocu.coddoc = {&FIRST-TABLE-IN-QUERY-br_table}.coddoc AND
                                                ccbddocu.nrodoc = {&FIRST-TABLE-IN-QUERY-br_table}.nrodoc AND
                                                ccbddocu.codmat = {&FIRST-TABLE-IN-QUERY-br_table}.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED ccbddocu THEN DO:
            x-msg-error = "Tabla CCBDDOCU esta bloqueada".                
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        IF NOT AVAILABLE ccbddocu THEN DO:
           x-msg-error = "Inconsistencia en la informacion - articulo : " + ttccbddocu.codmat.
           UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.            
        END.

        IF x-aprobado THEN DO:
            ASSIGN ccbddocu.flg_factor = "APROBADO|" + s-user-id + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS") NO-ERROR.
        END.
        ELSE DO:
            ASSIGN ccbddocu.flg_factor = "EXCLUIDO|" + s-user-id + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS") NO-ERROR.
        END.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg-error = "ERROR : " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.

        GET NEXT br_table.
    END.
    x-msg-error = "OK".
END. /* TRANSACTION block */

RELEASE ccbddocu.
RELEASE b-ccbcdocu.

IF x-msg-error = "OK" THEN DO:
    MESSAGE "Los datos se grabaron OK" 
            VIEW-AS ALERT-BOX INFORMATION.
    /*  */
    RUN refrescar.

    /*  */
    RUN refrescar-hdr IN lh_handle.
END.
ELSE DO:
    MESSAGE "ERROR al grabar los datos"  SKIP
            x-msg-error
            VIEW-AS ALERT-BOX INFORMATION.
END.

SESSION:SET-WAIT-STATE("").  


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN refrescar.
  
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar B-table-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE ttccbddocu.           
           
IF AVAILABLE ccbcdocu THEN DO:
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
        /* Los no trabajados */
        IF TRUE <> (ccbddocu.flg_factor > "") THEN DO:
            /*IF s-user-id <> 'ADMIN' THEN DO:*/
                FIND FIRST x-almmmatg OF ccbddocu NO-LOCK NO-ERROR.
                IF NOT AVAILABLE x-almmmatg THEN DO:
                    NEXT.
                END.
                ELSE DO:
                    FIND FIRST ttLineasAutorizadas WHERE ttLineasAutorizadas.tlinea = x-almmmatg.codfam NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ttLineasAutorizadas THEN DO:
                        NEXT.
                    END.
                END.
            /*END.*/
            CREATE ttccbddocu.
            BUFFER-COPY ccbddocu TO ttccbddocu.
            ASSIGN ttccbddocu.flg_factor = ''
                    ttccbddocu.aftisc = YES.
        END.
    END.
END.

{&OPEN-QUERY-br_table}

SESSION:SET-WAIT-STATE("").


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
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "ttCcbDDocu"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-informacion B-table-Win 
PROCEDURE validar-informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER x-aprobados AS INT.
DEFINE OUTPUT PARAMETER x-desaprobados AS INT.

DEFINE VAR x-dato AS LOG.

SESSION:SET-WAIT-STATE("GENERAL").  

x-aprobados = 0.
x-desaprobados = 0.

/**/
DEFINE VAR x-preuni AS DEC.
DEFINE VAR x-codmon AS INT.
DEFINE VAR x-TpoCmb AS DEC.
DEFINE VAR x-margen AS DEC.
DEFINE VAR x-limite AS DEC.
DEFINE VAR x-msgerror AS CHAR.

x-codmon = 1.       /* La PNC esta en SOLES */
x-TpoCmb = 1.       /* Tipo de cambio */

EMPTY TEMP-TABLE tt-pi-pendiente.

GET FIRST br_table.
DO  WHILE AVAILABLE ttccbddocu:
    x-dato = {&FIRST-TABLE-IN-QUERY-br_table}.aftisc.
    IF x-dato THEN DO:
        x-aprobados = x-aprobados + 1.
        /* Verificar Margen de Utilidad */

          x-preuni = ttccbddocu.preuni.
    
          x-Margen = 0.
          X-LIMITE = 0.
    
          RUN vtagn/p-margen-utilidad (
              ttccbddocu.CodMat,      /* Producto */
              x-PreUni,  /* Precio de venta unitario */
              ttccbddocu.UndVta,
              x-CodMon,       /* Moneda de venta */
              x-TpoCmb,       /* Tipo de cambio */
              NO,            /* Muestra el error */
              "",
              OUTPUT x-Margen,        /* Margen de utilidad */
              OUTPUT x-Limite,        /* Margen mínimo de utilidad */
              OUTPUT x-msgError           /* Control de errores: "OK" "ADM-ERROR" */
              ).

        IF X-MARGEN < X-LIMITE THEN DO:
            CREATE tt-pi-pendiente.
                ASSIGN    tt-pi-pendiente.ttipo = "ALERTA"
                          tt-pi-pendiente.tcodalm = ""
                          tt-pi-pendiente.tfchdoc = ?
                          tt-pi-pendiente.tserie = 0
                          tt-pi-pendiente.tnrodoc = 0
                          tt-pi-pendiente.tcodmat = ttccbddocu.CodMat
                          tt-pi-pendiente.ttabla = "MARGEN DE UTILIDAD MUY BAJO"
                          tt-pi-pendiente.tmsgerror = "El margen es de " + STRING(x-Margen,"->,>>9.9999") + 
                                              "%, no debe ser menor a " + STRING(x-Limite,"->,>>9.9999") + "%".
    
        END.

    END.
    ELSE DO:
        x-desaprobados = x-desaprobados + 1.
    END.
    GET NEXT br_table.
END.

SESSION:SET-WAIT-STATE("").  

FIND FIRST tt-pi-pendiente NO-LOCK NO-ERROR.
IF AVAILABLE tt-pi-pendiente THEN DO:
    RUN ccb/d-inconsistencias-pnc.r(INPUT TABLE tt-pi-pendiente).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

