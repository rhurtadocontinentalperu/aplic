&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-pickeador-col AS CHAR.
DEFINE VAR x-tipo-pickeador-col AS CHAR.

DEFINE VAR x-fecha AS DATE INIT TODAY.

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
&Scoped-define INTERNAL-TABLES rut-pers-turno chkchequeador PL-PERS ~
gn-users

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table rut-pers-turno.dni ~
nombre-pickeador(rut-pers-turno.dni) @ x-pickeador-col ~
x-tipo-pickeador-col @ x-tipo-pickeador-col rut-pers-turno.rol ~
rut-pers-turno.turno chkchequeador.mesa chkchequeador.fchasignacion ~
gn-users.User-Id 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH rut-pers-turno WHERE ~{&KEY-PHRASE} ~
      AND rut-pers-turno.codcia = s-codcia and  ~
rut-pers-turno.coddiv = s-coddiv and  ~
rut-pers-turno.fchasignada = x-fecha and ~
rut-pers-turno.rol = "CHEQUEADOR" NO-LOCK, ~
      LAST chkchequeador WHERE chkchequeador.codcia = rut-pers-turno.codcia ~
  AND chkchequeador.coddiv = rut-pers-turno.coddiv ~
  AND chkchequeador.codper = rut-pers-turno.dni ~
 ~
      AND chkchequeador.flgest = "A" OUTER-JOIN NO-LOCK, ~
      FIRST PL-PERS WHERE PL-PERS.CodCia = rut-pers-turno.codcia ~
  AND PL-PERS.NroDocId = rut-pers-turno.dni OUTER-JOIN NO-LOCK, ~
      FIRST gn-users OF PL-PERS OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH rut-pers-turno WHERE ~{&KEY-PHRASE} ~
      AND rut-pers-turno.codcia = s-codcia and  ~
rut-pers-turno.coddiv = s-coddiv and  ~
rut-pers-turno.fchasignada = x-fecha and ~
rut-pers-turno.rol = "CHEQUEADOR" NO-LOCK, ~
      LAST chkchequeador WHERE chkchequeador.codcia = rut-pers-turno.codcia ~
  AND chkchequeador.coddiv = rut-pers-turno.coddiv ~
  AND chkchequeador.codper = rut-pers-turno.dni ~
 ~
      AND chkchequeador.flgest = "A" OUTER-JOIN NO-LOCK, ~
      FIRST PL-PERS WHERE PL-PERS.CodCia = rut-pers-turno.codcia ~
  AND PL-PERS.NroDocId = rut-pers-turno.dni OUTER-JOIN NO-LOCK, ~
      FIRST gn-users OF PL-PERS OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table rut-pers-turno chkchequeador ~
PL-PERS gn-users
&Scoped-define FIRST-TABLE-IN-QUERY-br_table rut-pers-turno
&Scoped-define SECOND-TABLE-IN-QUERY-br_table chkchequeador
&Scoped-define THIRD-TABLE-IN-QUERY-br_table PL-PERS
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table gn-users


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-Refrescar BUTTON-7 ~
FILL-IN-fecha BUTTON-Asignar-mesa BUTTON-Reasignar-mesa 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fecha 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD nombre-pickeador B-table-Win 
FUNCTION nombre-pickeador RETURNS CHARACTER
  ( INPUT pDni AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-7 
     LABEL "Cerrar Session" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-Asignar-mesa 
     LABEL "Asignar Mesa" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Reasignar-mesa 
     LABEL "Reasignar Mesa" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      rut-pers-turno, 
      chkchequeador
    FIELDS(chkchequeador.mesa
      chkchequeador.fchasignacion), 
      PL-PERS, 
      gn-users
    FIELDS(gn-users.User-Id) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      rut-pers-turno.dni COLUMN-LABEL "D.N.I." FORMAT "x(12)":U
            WIDTH 16.14 COLUMN-FONT 0
      nombre-pickeador(rut-pers-turno.dni) @ x-pickeador-col COLUMN-LABEL "Nombre" FORMAT "x(50)":U
            WIDTH 27.57 COLUMN-FONT 0
      x-tipo-pickeador-col @ x-tipo-pickeador-col COLUMN-LABEL "Tipo" FORMAT "x(10)":U
            WIDTH 12.43 COLUMN-FONT 0
      rut-pers-turno.rol COLUMN-LABEL "ROL" FORMAT "x(15)":U COLUMN-FONT 0
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "CHEQUEADOR","PICADOR" 
                      DROP-DOWN-LIST 
      rut-pers-turno.turno COLUMN-LABEL "TURNO" FORMAT "x(15)":U
            COLUMN-FONT 0 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "MAÑANA","TARDE","NOCHE" 
                      DROP-DOWN-LIST 
      chkchequeador.mesa COLUMN-LABEL "MESA" FORMAT "x(8)":U WIDTH 18
      chkchequeador.fchasignacion COLUMN-LABEL "ASIGNACION" FORMAT "99/99/9999":U
            WIDTH 12.14
      gn-users.User-Id FORMAT "x(12)":U WIDTH 12.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 136.29 BY 16.23
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.65 COL 1.72
     BUTTON-Refrescar AT ROW 1.27 COL 31 WIDGET-ID 12
     BUTTON-7 AT ROW 19.31 COL 91 WIDGET-ID 6
     FILL-IN-fecha AT ROW 1.38 COL 13 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Asignar-mesa AT ROW 19.31 COL 2 WIDGET-ID 4
     BUTTON-Reasignar-mesa AT ROW 19.31 COL 18 WIDGET-ID 10
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
         HEIGHT             = 19.96
         WIDTH              = 141.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.rut-pers-turno,INTEGRAL.chkchequeador WHERE INTEGRAL.rut-pers-turno ...,INTEGRAL.PL-PERS WHERE INTEGRAL.rut-pers-turno ...,INTEGRAL.gn-users OF INTEGRAL.PL-PERS"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", LAST OUTER USED, FIRST OUTER, FIRST OUTER USED"
     _Where[1]         = "rut-pers-turno.codcia = s-codcia and 
rut-pers-turno.coddiv = s-coddiv and 
rut-pers-turno.fchasignada = x-fecha and
rut-pers-turno.rol = ""CHEQUEADOR"""
     _JoinCode[2]      = "chkchequeador.codcia = rut-pers-turno.codcia
  AND chkchequeador.coddiv = rut-pers-turno.coddiv
  AND chkchequeador.codper = rut-pers-turno.dni
"
     _Where[2]         = "chkchequeador.flgest = ""A"""
     _JoinCode[3]      = "PL-PERS.CodCia = rut-pers-turno.codcia
  AND PL-PERS.NroDocId = rut-pers-turno.dni"
     _FldNameList[1]   > INTEGRAL.rut-pers-turno.dni
"rut-pers-turno.dni" "D.N.I." "x(12)" "character" ? ? 0 ? ? ? no ? no no "16.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"nombre-pickeador(rut-pers-turno.dni) @ x-pickeador-col" "Nombre" "x(50)" ? ? ? 0 ? ? ? no ? no no "27.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"x-tipo-pickeador-col @ x-tipo-pickeador-col" "Tipo" "x(10)" ? ? ? 0 ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.rut-pers-turno.rol
"rut-pers-turno.rol" "ROL" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "CHEQUEADOR,PICADOR" ? 5 no 0 no no
     _FldNameList[5]   > INTEGRAL.rut-pers-turno.turno
"rut-pers-turno.turno" "TURNO" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "MAÑANA,TARDE,NOCHE" ? 5 no 0 no no
     _FldNameList[6]   > INTEGRAL.chkchequeador.mesa
"chkchequeador.mesa" "MESA" ? "character" ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.chkchequeador.fchasignacion
"chkchequeador.fchasignacion" "ASIGNACION" ? "date" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.gn-users.User-Id
"gn-users.User-Id" ? ? "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME rut-pers-turno.dni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rut-pers-turno.dni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF rut-pers-turno.dni IN BROWSE br_table /* D.N.I. */
DO:
    DEFINE VAR x-nombre AS CHAR.
    DEFINE VAR y-dni AS CHAR.
    DEFINE VAR x-nombre-picador AS CHAR.
    DEFINE VAR x-origen-picador AS CHAR.

    /* */
    y-dni = rut-pers-turno.dni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    RUN logis/p-busca-por-dni(INPUT y-dni, 
                              OUTPUT x-nombre-picador,
                              OUTPUT x-origen-picador).

    x-tipo-pickeador-col = x-origen-picador.

    IF x-origen-picador = "" THEN DO:
        x-nombre = "< No existe >".
    END.
    ELSE DO:
        x-nombre = x-nombre-picador.
    END.

    x-pickeador-col:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-nombre.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Cerrar Session */
DO:
    IF AVAILABLE rut-pers-turno THEN DO:
        MESSAGE 'Desea cerrar Sesion del codigo(' + rut-pers-turno.dni + ') ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        DEFINE VAR x-retval AS CHAR.
        RUN cerrar-sesion(OUTPUT x-retval, INPUT rut-pers-turno.dni).

        IF x-retval = "OK" THEN DO:
            {&OPEN-QUERY-BROWSE-2}
        END.
        ELSE MESSAGE x-retval.

    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Asignar-mesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Asignar-mesa B-table-Win
ON CHOOSE OF BUTTON-Asignar-mesa IN FRAME F-Main /* Asignar Mesa */
DO:
  RUN Asignar-Mesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Reasignar-mesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Reasignar-mesa B-table-Win
ON CHOOSE OF BUTTON-Reasignar-mesa IN FRAME F-Main /* Reasignar Mesa */
DO:
  RUN Reasignar-Mesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar B-table-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fecha B-table-Win
ON LEAVE OF FILL-IN-fecha IN FRAME F-Main /* Fecha */
DO:
    ASSIGN fill-in-fecha.

    x-fecha = fill-in-fecha.

  {&open-query-br_table}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF  fill-in-fecha, rut-pers-turno.dni, rut-pers-turno.rol, rut-pers-turno.turno
DO:
    APPLY 'TAB'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Mesa B-table-Win 
PROCEDURE Asignar-Mesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-codigo AS CHAR.
    DEFINE BUFFER x-ChkChequeador FOR ChkChequeador.
    DEFINE VAR x-nueva-mesa AS CHAR.
    DEFINE VAR x-anterior-mesa AS CHAR.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN FILL-in-fecha.
        IF br_table:NUM-SELECTED-ROWS <= 0 THEN DO:
            MESSAGE "Seleccione un personal, por favor" VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
        /* RHC Verificar que no haya mesas sin cerrar del día anterior */
        IF CAN-FIND(FIRST ChkChequeador WHERE chkchequeador.codcia = s-codcia AND
                    chkchequeador.coddiv = s-coddiv AND
                    chkchequeador.flgest = "A" AND      /* Asignado */
                    chkchequeador.fchasignacion < TODAY NO-LOCK)
            THEN DO:
            IF s-user-id <> 'ADMIN' THEN DO:
/*                 MESSAGE 'Tienes mesas activas por cerrar de días anteriores' SKIP */
/*                     'Favor verificar' VIEW-AS ALERT-BOX WARNING.                  */
/*                 RETURN NO-APPLY.                                                  */
                MESSAGE 'Tienes mesas activas por cerrar de días anteriores' SKIP 
                    'Favor verificar' VIEW-AS ALERT-BOX WARNING.
            END.
        END.

        x-codigo = rut-pers-turno.dni:SCREEN-VALUE IN BROWSE {&browse-name}.
        FIND FIRST x-ChkChequeador WHERE x-ChkChequeador.codcia = s-codcia AND 
            x-ChkChequeador.coddiv = s-coddiv AND 
            x-ChkChequeador.codper = x-codigo AND
            x-ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.
        IF AVAILABLE x-ChkChequeador THEN DO:
            MESSAGE "Codigo de trabajador ya tiene la MESA (" + x-ChkChequeador.mesa + ") asignada!!! el" x-chkchequeador.fchasignacion
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN.
        END.
        RUN logis/d-chequeador-mesa-v2.r(INPUT x-codigo).
        {&OPEN-QUERY-BROWSE-2}
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cerrar-sesion B-table-Win 
PROCEDURE cerrar-sesion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.
DEFINE INPUT PARAMETER pCodigo AS CHAR.

DEFINE BUFFER b-ChkChequeador FOR ChkChequeador.

FIND FIRST b-ChkChequeador WHERE b-ChkChequeador.codcia = s-codcia AND 
    b-ChkChequeador.coddiv = s-coddiv AND 
    b-ChkChequeador.codper = pcodigo AND
    /*b-ChkChequeador.fchasignacion = fill-in-fecha AND*/
    b-ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.

pRetVal = "OK".

IF AVAILABLE b-ChkChequeador THEN DO:
    /* Validar que no tenga Tarea Asignada */
    FIND FIRST ChkTareas WHERE ChkTareas.codcia = s-codcia AND
        ChkTareas.coddiv = b-ChkChequeador.coddiv AND 
        ChkTareas.mesa = b-ChkChequeador.mesa AND 
        ChkTareas.flgest = 'P' NO-LOCK NO-ERROR.
    IF AVAILABLE ChkTareas THEN DO:
        pRetVal = "La mesa(" + b-ChkChequeador.mesa + ") aun tiene una tarea asignada (" + ChkTareas.coddoc + " " + ChkTareas.NroPed + ") Imposible cerrar la Sesion!!!".
        RETURN.
    END.
    /* Cerrar la Sesion */
    /*DEFINE BUFFER b-ChkChequeador FOR ChkChequeador.*/
    /*
    DEFINE VAR x-rowid AS ROWID.    

    x-rowid = ROWID(ChkChequeador).
    */
    FIND CURRENT b-ChkChequeador EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE b-ChkChequeador THEN DO:
        /* Libero la Mesa */
        FIND FIRST ChkMesas WHERE ChkMesas.codcia = s-codcia AND 
                                    ChkMesas.coddiv = b-ChkChequeador.coddiv AND 
                                    ChkMesas.mesa = b-ChkChequeador.mesa EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ChkMesas THEN DO:
            ASSIGN ChkMesas.flgest = 'L'.
            /**/
            ASSIGN b-ChkChequeador.flgest = 'C'.        
        END.
        ELSE pRetVal = "No se pudo liberar la Mesa".        
    END.
    ELSE DO:
        pRetVal = "Hubo problemas al cerrar la sesion, intente de nuevo!!!".
    END.   

    RELEASE b-ChkChequeador.        
    RELEASE ChkMesas.
END.
ELSE DO:
    pRetVal = "No existe????(" + pcodigo + "), intente de nuevo!!!".
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
         DO WITH FRAME {&FRAME-NAME}:
           DISABLE fill-in-fecha.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN rut-pers-turno.codcia = s-codcia 
        rut-pers-turno.fchasignada = fill-in-fecha
        rut-pers-turno.coddiv = s-coddiv
      .

 
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

    DO WITH FRAME {&FRAME-NAME}:
           /*ENABLE fill-in-fecha.*/
        END.

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
       DO WITH FRAME {&FRAME-NAME}:
           ENABLE fill-in-fecha.
           END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

     DO WITH FRAME {&FRAME-NAME}:
           /*ENABLE fill-in-fecha.*/
           END.

 
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

  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "NO" THEN DO:
   /* Esta MODIFICANDO */
   {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.dni:READ-ONLY 
       IN BROWSE {&BROWSE-NAME}= YES.    
  END.
  ELSE DO:
        /* Esta ADICIONADO */
   {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.dni:READ-ONLY 
       IN BROWSE {&BROWSE-NAME}= NO.

  END.

         DO WITH FRAME {&FRAME-NAME}:
           DISABLE fill-in-fecha.
        END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update B-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
     DO WITH FRAME {&FRAME-NAME}:
           /*ENABLE fill-in-fecha.*/
           END.

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
  
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-fecha:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
  END.
  ASSIGN fill-in-fecha.

  {&open-query-br_table}
  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reasignar-Mesa B-table-Win 
PROCEDURE Reasignar-Mesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-codigo AS CHAR.
    DEFINE BUFFER x-ChkChequeador FOR ChkChequeador.
    DEFINE VAR x-nueva-mesa AS CHAR.
    DEFINE VAR x-anterior-mesa AS CHAR.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
            FILL-in-fecha.
        IF br_table:NUM-SELECTED-ROWS <= 0 THEN DO:
            MESSAGE "Seleccione un personal, por favor" VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.

        x-codigo = rut-pers-turno.dni:SCREEN-VALUE IN BROWSE {&browse-name}.

        FIND FIRST x-ChkChequeador WHERE x-ChkChequeador.codcia = s-codcia AND 
            x-ChkChequeador.coddiv = s-coddiv AND 
            x-ChkChequeador.codper = x-codigo AND
            x-ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-ChkChequeador THEN DO:
            MESSAGE "Código de trabajador NO tiene MESA asignada" VIEW-AS ALERT-BOX INFORMATION.
            RETURN.
        END.
        MESSAGE "Codigo de trabajador ya tiene la MESA (" + x-ChkChequeador.mesa + ") asignada!!!" SKIP
                'Desea reasignar Mesa?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN.

        FIND FIRST ChkTareas WHERE ChkTareas.codcia = s-codcia AND
            ChkTareas.coddiv = x-ChkChequeador.coddiv AND 
            ChkTareas.mesa = x-ChkChequeador.mesa AND 
            ChkTareas.flgest = 'P' NO-LOCK NO-ERROR.
        IF AVAILABLE ChkTareas THEN DO:
            MESSAGE "La mesa(" + x-ChkChequeador.mesa + ") aun tiene una tarea asignada (" + ChkTareas.coddoc + " " + ChkTareas.NroPed + ") !!!".
            RETURN.
        END.

        RUN logis/d-chequeador-modifica-mesa-v2.r(INPUT x-codigo, INPUT fill-in-fecha, OUTPUT x-nueva-mesa).

        IF x-nueva-mesa <> "" THEN DO:
            x-anterior-mesa = x-ChkChequeador.mesa.
            /* Asignamos la nueva mesa */
            FIND CURRENT x-ChkChequeador EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE x-ChkChequeador THEN DO:
                ASSIGN x-ChkChequeador.mesa = x-nueva-mesa.
            END.
            /* Liberamos la mesa anterior */
            FIND FIRST ChkMesas WHERE ChkMesas.codcia = s-codcia AND
                                        ChkMesas.coddiv = s-coddiv AND 
                                        ChkMesas.mesa = x-anterior-mesa
                                        EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE ChkMesas THEN DO:        
                /* Mesa Liberada */
                ASSIGN ChkMesas.flgest = 'L'.
            END.

            RELEASE ChkMesas.
            RELEASE x-ChkChequeador.

        END.

        {&OPEN-QUERY-BROWSE-2}
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
  {src/adm/template/snd-list.i "rut-pers-turno"}
  {src/adm/template/snd-list.i "chkchequeador"}
  {src/adm/template/snd-list.i "PL-PERS"}
  {src/adm/template/snd-list.i "gn-users"}

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

DEFINE VAR x-dni AS CHAR.  
DEFINE VAR x-rol AS CHAR.  
DEFINE VAR x-turno AS CHAR.  
DEFINE VAR x-nombre-picador AS CHAR.
DEFINE VAR x-origen-picador AS CHAR.

x-dni = rut-pers-turno.dni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
x-rol = rut-pers-turno.rol:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
x-turno = rut-pers-turno.turno:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

IF TRUE <> (x-dni > "") THEN DO:
    MESSAGE "Ingrese el Nro del DNI, por favor!!" VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO rut-pers-turno.dni IN BROWSE {&BROWSE-NAME}.
    RETURN "ADM-ERROR".
END.
IF TRUE <> (x-turno > "") THEN DO:
    MESSAGE "Ingrese el TURNO, por favor!!" VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO rut-pers-turno.turno IN BROWSE {&BROWSE-NAME}.
    RETURN "ADM-ERROR".
END.
IF TRUE <> (x-rol > "") THEN DO:
    MESSAGE "Ingrese el ROL, por favor!!" VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO rut-pers-turno.rol IN BROWSE {&BROWSE-NAME}.
    RETURN "ADM-ERROR".
END.

DO WITH FRAME {&FRAME-NAME} :
    ASSIGN fill-in-fecha .
END.

RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
IF RETURN-VALUE = "YES" THEN DO:

    RUN logis/p-busca-por-dni(INPUT x-dni, 
                              OUTPUT x-nombre-picador,
                              OUTPUT x-origen-picador).

    x-tipo-pickeador-col = x-origen-picador.

    IF x-origen-picador = "" THEN DO:
        MESSAGE "El DNI no existe ingrese correctamente el dato, por favor!!" VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO rut-pers-turno.dni IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".        
    END.
    x-pickeador-col:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-nombre-picador.

    DEFINE BUFFER x-rut-pers-turno FOR rut-pers-turno.

    FIND FIRST x-rut-pers-turno WHERE x-rut-pers-turno.codcia = s-codcia AND 
                                        x-rut-pers-turno.coddiv = s-coddiv AND
                                        x-rut-pers-turno.fchasignada = fill-in-fecha AND
                                        x-rut-pers-turno.dni = x-dni NO-LOCK NO-ERROR.
    IF AVAILABLE x-rut-pers-turno THEN DO:
        MESSAGE "Nro de DNI ya esta registrado!!" VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO rut-pers-turno.dni IN BROWSE {&BROWSE-NAME}.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION nombre-pickeador B-table-Win 
FUNCTION nombre-pickeador RETURNS CHARACTER
  ( INPUT pDni AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-nombre-picador AS CHAR.
    DEFINE VAR x-origen-picador AS CHAR.

    RUN logis/p-busca-por-dni(INPUT pDni, 
                              OUTPUT x-nombre-picador,
                              OUTPUT x-origen-picador).

    x-tipo-pickeador-col = x-origen-picador.
    x-retval = x-nombre-picador.

    RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

