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

DEFINE SHARED VAR s-codcia   AS INT.
DEFINE SHARED VAR cl-codcia  AS INT.
DEFINE SHARED VAR s-coddiv   AS CHAR.
DEFINE SHARED VAR s-user-id  AS CHAR.

&SCOPED-DEFINE CONDICION ( ExpAsist.CodCia = S-CODCIA  AND ~
    ExpAsist.CodDiv = s-coddiv AND ~
    ExpAsist.FecPro >= (TODAY - 3) )

DEFINE STREAM REPORTE.

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
&Scoped-define INTERNAL-TABLES ExpAsist gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ~
fEstado(ExpAsist.Estado[1]) @ ExpAsist.Libre_c01 ExpAsist.CodCli ~
ExpAsist.NomCli ExpAsist.FecPro ExpAsist.HoraPro ExpAsist.FecAsi[1] ~
ExpAsist.HoraAsi[1] ExpAsist.FecAsi[2] ExpAsist.HoraAsi[2] ~
ExpAsist.FecAsi[3] ExpAsist.HoraAsi[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ExpAsist WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpAsist WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table ExpAsist gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpAsist
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-6 BUTTON-4 FILL-IN-NomCli ~
FILL-IN-CodCli BUTTON-5 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomCli FILL-IN-CodCli 

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
NomCli|y||INTEGRAL.ExpAsist.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'NomCli' + '",
     SortBy-Case = ':U + 'NomCli').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "INGRESAR NO INVITADO" 
     SIZE 28 BY 1.12.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "IMG/btn-down.bmp":U
     LABEL "Button 4" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "IMG/btn-up.bmp":U
     LABEL "Button 5" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "BORRAR REGISTRO" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "INGRESE CODIGO DEL CLIENTE" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "BUSCAR EL NOMBRE" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ExpAsist, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      fEstado(ExpAsist.Estado[1]) @ ExpAsist.Libre_c01 COLUMN-LABEL "Situación" FORMAT "x(15)":U
            WIDTH 11.43
      ExpAsist.CodCli COLUMN-LABEL "Código" FORMAT "X(11)":U WIDTH 10.43
      ExpAsist.NomCli COLUMN-LABEL "Nombre o Razón Social" FORMAT "x(60)":U
            WIDTH 44.43
      ExpAsist.FecPro COLUMN-LABEL "Dia!Programado" FORMAT "99/99/9999":U
            WIDTH 9.86
      ExpAsist.HoraPro COLUMN-LABEL "Hora" FORMAT "x(8)":U WIDTH 9
      ExpAsist.FecAsi[1] COLUMN-LABEL "1ra!Asistencia" FORMAT "99/99/9999":U
            WIDTH 9.29
      ExpAsist.HoraAsi[1] COLUMN-LABEL "Hora" FORMAT "x(8)":U WIDTH 7.86
      ExpAsist.FecAsi[2] COLUMN-LABEL "2da!Asistencia" FORMAT "99/99/9999":U
            WIDTH 9
      ExpAsist.HoraAsi[2] COLUMN-LABEL "Hora" FORMAT "x(8)":U WIDTH 8.29
      ExpAsist.FecAsi[3] COLUMN-LABEL "3ra!Asistencia" FORMAT "99/99/9999":U
            WIDTH 8.57
      ExpAsist.HoraAsi[3] COLUMN-LABEL "Hora" FORMAT "x(8)":U WIDTH 5.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 143 BY 22.31
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 3.88 COL 1
     BUTTON-6 AT ROW 2.35 COL 116 WIDGET-ID 20
     BUTTON-4 AT ROW 2.35 COL 98 WIDGET-ID 6
     FILL-IN-NomCli AT ROW 2.35 COL 31 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CodCli AT ROW 1.19 COL 31 COLON-ALIGNED WIDGET-ID 2
     BUTTON-5 AT ROW 2.35 COL 103 WIDGET-ID 8
     BUTTON-2 AT ROW 1.19 COL 116 WIDGET-ID 18
     "F10: Reimprimir Código de Barras" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 3.31 COL 1 WIDGET-ID 10
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "F9: Registrar Asistencia del Cliente Seleccionado" VIEW-AS TEXT
          SIZE 41 BY .62 AT ROW 3.31 COL 32 WIDGET-ID 12
          BGCOLOR 1 FGCOLOR 15 FONT 6
     SPACE(60.29) SKIP(1.11)
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
         HEIGHT             = 25.27
         WIDTH              = 143.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
     _TblList          = "INTEGRAL.ExpAsist,INTEGRAL.gn-clie WHERE INTEGRAL.ExpAsist ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = INTEGRAL.ExpAsist.CodCli"
     _Where[2]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > "_<CALC>"
"fEstado(ExpAsist.Estado[1]) @ ExpAsist.Libre_c01" "Situación" "x(15)" ? ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ExpAsist.CodCli
"ExpAsist.CodCli" "Código" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ExpAsist.NomCli
"ExpAsist.NomCli" "Nombre o Razón Social" "x(60)" "character" ? ? ? ? ? ? no ? no no "44.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ExpAsist.FecPro
"ExpAsist.FecPro" "Dia!Programado" ? "date" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ExpAsist.HoraPro
"ExpAsist.HoraPro" "Hora" "x(8)" "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ExpAsist.FecAsi[1]
"ExpAsist.FecAsi[1]" "1ra!Asistencia" ? "date" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.ExpAsist.HoraAsi[1]
"ExpAsist.HoraAsi[1]" "Hora" "x(8)" "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.ExpAsist.FecAsi[2]
"ExpAsist.FecAsi[2]" "2da!Asistencia" ? "date" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.ExpAsist.HoraAsi[2]
"ExpAsist.HoraAsi[2]" "Hora" "x(8)" "character" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.ExpAsist.FecAsi[3]
"ExpAsist.FecAsi[3]" "3ra!Asistencia" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.ExpAsist.HoraAsi[3]
"ExpAsist.HoraAsi[3]" "Hora" "x(8)" "character" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 1.19
       COLUMN          = 119
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 14
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F10 OF br_table IN FRAME F-Main
DO:

    IF NOT AVAILABLE ExpAsist THEN RETURN.
    IF ExpAsist.Estado[1] <> 'C' THEN RETURN.
    IF ExpAsist.FecAsi[2] = ? AND ExpAsist.FecAsi[3] = ? THEN RUN Imprime-Barras. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON F9 OF br_table IN FRAME F-Main
DO:
    RUN Registra-Asistencias.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* INGRESAR NO INVITADO */
DO:
    /*RUN VtaExp\w-regclieasist.w.*/
    RUN vta2/w-expregvisita.
    RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    GET CURRENT {&BROWSE-NAME}.
    GET NEXT {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE ExpAsist:
        IF INDEX(ExpAsist.NomCli, FILL-IN-NomCli) > 0 THEN DO:
            REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.
            LEAVE.
        END.
        GET NEXT {&BROWSE-NAME}.
    END.
    SESSION:SET-WAIT-STATE('').
    IF NOT AVAILABLE ExpAsist THEN DO:
        MESSAGE 'Fin de Archivo'.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    GET CURRENT {&BROWSE-NAME}.
    GET PREV {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE ExpAsist:
        IF INDEX(ExpAsist.NomCli, FILL-IN-NomCli) > 0 THEN DO:
            REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.
            LEAVE.
        END.
        GET PREV {&BROWSE-NAME}.
    END.
    SESSION:SET-WAIT-STATE('').
    IF NOT AVAILABLE ExpAsist THEN DO:
        MESSAGE 'Inicio de Archivo'.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 B-table-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* BORRAR REGISTRO */
DO:
   RUN Anula-Registro.
   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
   RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame B-table-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

     RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli B-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* INGRESE CODIGO DEL CLIENTE */
DO:
  ASSIGN {&self-name}.
  IF FILL-IN-CodCli = "" THEN RETURN.
  ASSIGN SELF:SCREEN-VALUE = "".
  FIND FIRST ExpAsist WHERE {&Condicion} 
      AND ExpAsist.CodCli = FILL-IN-CodCli
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ExpAsist THEN DO:
      MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.        
  REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.        
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  RUN Registra-Asistencias.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  FILL-IN-CodCli = "".
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NomCli B-table-Win
ON LEAVE OF FILL-IN-NomCli IN FRAME F-Main /* BUSCAR EL NOMBRE */
DO:
  ASSIGN {&self-name}.
  IF {&self-name} = "" THEN RETURN.
/*   FIND FIRST ExpAsist WHERE {&Condicion} AND INDEX(ExpAsist.NomCli, {&self-name}) > 0 */
/*       NO-LOCK NO-ERROR.                                                               */
/*   REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.                        */
/*   IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.                                         */
  SESSION:SET-WAIT-STATE('GENERAL').
  GET FIRST {&Browse-name}.
  REPEAT WHILE AVAILABLE ExpAsist:
      IF INDEX(ExpAsist.NomCli, FILL-IN-NomCli) > 0 THEN DO:
          REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpAsist) NO-ERROR.
          LEAVE.
      END.
      GET NEXT {&BROWSE-NAME}.
  END.
  SESSION:SET-WAIT-STATE('').
  IF NOT AVAILABLE ExpAsist THEN DO:
      MESSAGE 'Fin de Archivo'.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY ExpAsist.NomCli
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Registro B-table-Win 
PROCEDURE Anula-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ExpAsist THEN RETURN 'ADM-ERROR'.

IF ExpAsist.Estado[2] <> "N" THEN DO:
    MESSAGE 'Cliente pertenece a listado'
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN 'ADM-ERROR'.
END.
IF ExpAsist.Estado[1] = "A" THEN RETURN "ADM-ERROR".

MESSAGE 'Esta seguro de eliminar registro'
    VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
    TITLE '' UPDATE lchoice AS LOGICAL.
IF lChoice = NO THEN RETURN 'ADM-ERROR'.
FIND CURRENT ExpAsist EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE ExpAsist THEN RETURN 'ADM-ERROR'.
ASSIGN 
    ExpAsist.Estado[1] = 'A'
    ExpAsist.Estado[5] = STRING(TODAY) + '|' + STRING(TIME,"HH:MM:SS")
    ExpAsist.usuario   = s-user-id.  
FIND CURRENT ExpAsist NO-LOCK.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load B-table-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "b-expinvitados.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "b-expinvitados.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Barras B-table-Win 
PROCEDURE Imprime-Barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRucCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHARACTER   FORMAT "99999999999" NO-UNDO.
  DEFINE VARIABLE iNumCop AS INTEGER     NO-UNDO.
  DEF VAR rpta AS LOG.  
    
  iNumCop = INT(1).

  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = ExpAsist.CodCli NO-LOCK NO-ERROR.
  IF NOT AVAIL gn-clie THEN DO:
      MESSAGE "Cliente no registrado en el sistema"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN.
  END.
  
  ASSIGN 
      cNomCli = gn-clie.nomcli
      cRucCli = gn-clie.ruc
      cCodCli = gn-clie.codcli.

/*   SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta. */
/*   IF rpta = NO THEN RETURN.                */
  /**OUTPUT STREAM REPORTE TO PRINTER.*/
  /*OUTPUT STREAM REPORTE TO PRINTER .*/

  RUN lib/_port-name ("Barras", OUTPUT s-port-name).
  IF s-port-name = '' THEN RETURN.
  
  IF s-OpSys = 'WinVista' OR s-OpSys = 'WinXP'
      THEN OUTPUT STREAM REPORTE TO PRINTER VALUE(s-port-name).
  ELSE OUTPUT STREAM REPORTE TO VALUE(s-port-name).  
      PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
      {vtaexp/ean-clientes.i}
      PUT STREAM REPORTE '^PQ' + TRIM(STRING(iNumCop))      SKIP.  /* Cantidad a imprimir */
      PUT STREAM REPORTE '^PR' + '4'                  SKIP.   /* Velocidad de impresion Pulg/seg */
      PUT STREAM REPORTE '^XZ'                        SKIP.
  
  OUTPUT STREAM REPORTE CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Asistencias B-table-Win 
PROCEDURE Registra-Asistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND CURRENT ExpAsist EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ExpAsist THEN RETURN 'ADM-ERROR'.
    IF ExpAsist.Fecha = TODAY THEN DO:
        MESSAGE 'Cliente ya ha sido registrado hoy' 
            VIEW-AS ALERT-BOX WARNING.
        FIND CURRENT ExpAsist NO-LOCK NO-ERROR.
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        ExpAsist.Estado[1]     = 'C'
        ExpAsist.Fecha         = TODAY     /*Campo Referencial*/
        ExpAsist.Hora          = STRING(TIME,"HH:MM:SS")
        ExpAsist.usuario       = s-user-id.
    IF ExpAsist.FecAsi[1] = ? THEN 
        ASSIGN 
            ExpAsist.FecAsi[1]  = TODAY
            ExpAsist.HoraAsi[1] = STRING(TIME,"HH:MM:SS").
    ELSE IF ExpAsist.FecAsi[2] = ? THEN 
        ASSIGN 
            ExpAsist.FecAsi[2]  = TODAY
            ExpAsist.HoraAsi[2] = STRING(TIME,"HH:MM:SS").
    ELSE ASSIGN 
            ExpAsist.FecAsi[3]  = TODAY
            ExpAsist.HoraAsi[3] = STRING(TIME,"HH:MM:SS").

    IF ExpAsist.FecAsi[2] = ? AND ExpAsist.FecAsi[3] = ? THEN RUN Imprime-Barras. 
    FIND CURRENT ExpAsist NO-LOCK.
    RETURN 'OK'.

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
  {src/adm/template/snd-list.i "ExpAsist"}
  {src/adm/template/snd-list.i "gn-clie"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

CASE pEstado:
    WHEN ""  THEN RETURN "AUN NO LLEGA".
    WHEN "C" THEN RETURN "ASISTIÓ".
END CASE.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

