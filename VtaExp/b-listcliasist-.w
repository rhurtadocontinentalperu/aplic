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

DEF STREAM REPORTE.
          
/* &SCOPED-DEFINE CONDICION ( ExpAsist.CodCia = S-CODCIA  AND ~ */
/*              ExpAsist.CodDiv = s-coddiv AND ~                */
/*              ExpAsist.FecPro >= 01/04/2012 AND ~             */
/*              ExpAsist.Estado[1] <> 'A' AND ~                 */
/*              ExpAsist.Estado[1] BEGINS rs-tipo AND ~         */
/*              LOOKUP(ExpAsist.Estado[2],'L,N') > 0 )          */
&SCOPED-DEFINE CONDICION ( ExpAsist.CodCia = S-CODCIA  AND ~
             ExpAsist.CodDiv = s-coddiv AND ~
             ExpAsist.Estado[1] <> 'A' AND ~
             (rs-tipo = "" OR ExpAsist.Estado[1] = rs-tipo) AND ~
             LOOKUP(ExpAsist.Estado[2],'L,N') > 0 )


&SCOPED-DEFINE CODIGO ExpAsist.CodCli 
&SCOPED-DEFINE FECHAASIS ExpAsist.fecha 
&SCOPED-DEFINE FILTRO1 ( ExpAsist.Nomcli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( ExpAsist.NomCli , FILL-IN-filtro ) <> 0 )

DEFINE BUFFER bexpasist FOR expasist.

DEFINE VARIABLE cDesEst AS CHARACTER   NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-br_table ExpAsist.CodCli ExpAsist.NomCli ~
gn-clie.NroCard gn-clie.Ruc ExpAsist.FecPro ExpAsist.HoraPro ~
ExpAsist.FecAsi[1] ExpAsist.HoraAsi[1] ExpAsist.FecAsi[2] ~
ExpAsist.HoraAsi[2] ExpAsist.FecAsi[3] ExpAsist.HoraAsi[3] ~
IF (ExpAsist.Estado[1] = 'C' ) THEN ('Asistio') ELSE ('Ausente') @ cDesEst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ExpAsist WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpAsist WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table ExpAsist gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpAsist
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-codigo CMB-filtro FILL-IN-filtro ~
rs-tipo BUTTON-2 BUTTON-3 br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo CMB-filtro FILL-IN-filtro ~
COMBO-BOX-Fechas COMBO-BOX-Horas rs-tipo 

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
Nombres que inicien con|y||INTEGRAL.ExpAsist.NomCli
Nombres que contengan|y||INTEGRAL.ExpAsist.NomCli
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
Codigo|y||INTEGRAL.ExpAsist.CodCli|yes
Descripcion|||INTEGRAL.gn-clie.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Codigo,Descripcion' + '",
     SortBy-Case = ':U + 'Codigo').

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Reimpresion  LABEL "Reimprime Etiqueta"
       MENU-ITEM m_Registra_Asitencia LABEL "Registra Asitencia"
       MENU-ITEM m_Anula_Registro LABEL "Anula Registro".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/balance.ico":U
     LABEL "@DD" 
     SIZE 11 BY 1.88.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 11 BY 1.88.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 28 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Fechas AS CHARACTER FORMAT "X(11)":U INITIAL "Todos" 
     LABEL "Fecha" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","24/10/2011","25/10/2011" 
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Horas AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Horario" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","07:00 - 22:00" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(12)":U 
     LABEL "Ingresar Código de Barras" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .85
     BGCOLOR 2 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .85
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE rs-tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "",
"No Asistieron", "P",
"Asistieron", "C"
     SIZE 49 BY 1.08
     BGCOLOR 8  NO-UNDO.

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
      ExpAsist.CodCli COLUMN-LABEL "Código" FORMAT "X(11)":U WIDTH 10.43
      ExpAsist.NomCli COLUMN-LABEL "<<<<Nombre o Razón Social>>>>" FORMAT "x(55)":U
            WIDTH 37.43
      gn-clie.NroCard COLUMN-LABEL "Nº Card" FORMAT "x(8)":U
      gn-clie.Ruc COLUMN-LABEL "RUC" FORMAT "x(11)":U WIDTH 10.86
      ExpAsist.FecPro COLUMN-LABEL "Fecha!Program" FORMAT "99/99/9999":U
            COLUMN-BGCOLOR 6
      ExpAsist.HoraPro COLUMN-LABEL "Hora!Program" FORMAT "x(10)":U
            WIDTH 7.57 COLUMN-BGCOLOR 11
      ExpAsist.FecAsi[1] COLUMN-LABEL "1º !Asistencia" FORMAT "99/99/9999":U
            WIDTH 9.72
      ExpAsist.HoraAsi[1] COLUMN-LABEL "Hora" FORMAT "x(10)":U
            WIDTH 8.43
      ExpAsist.FecAsi[2] COLUMN-LABEL "2º !Asistencia" FORMAT "99/99/9999":U
      ExpAsist.HoraAsi[2] COLUMN-LABEL "Hora" FORMAT "x(10)":U
            WIDTH 7.86
      ExpAsist.FecAsi[3] COLUMN-LABEL "3º !Asistencia" FORMAT "99/99/9999":U
      ExpAsist.HoraAsi[3] COLUMN-LABEL "Hora" FORMAT "x(10)":U
      IF (ExpAsist.Estado[1] = 'C' ) THEN ('Asistio') ELSE ('Ausente') @ cDesEst COLUMN-LABEL "Situación" FORMAT "X(15)":U
            WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140.29 BY 17.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codigo AT ROW 1.81 COL 30 COLON-ALIGNED WIDGET-ID 2
     CMB-filtro AT ROW 2.88 COL 5 NO-LABEL WIDGET-ID 14
     FILL-IN-filtro AT ROW 2.88 COL 34 NO-LABEL WIDGET-ID 16
     COMBO-BOX-Fechas AT ROW 3.96 COL 10 COLON-ALIGNED WIDGET-ID 22
     COMBO-BOX-Horas AT ROW 3.96 COL 43 COLON-ALIGNED WIDGET-ID 28
     rs-tipo AT ROW 5.04 COL 5 NO-LABEL WIDGET-ID 30
     BUTTON-2 AT ROW 2.35 COL 121 WIDGET-ID 18
     BUTTON-3 AT ROW 2.35 COL 107 WIDGET-ID 36
     br_table AT ROW 6.92 COL 2
     "Fuera de Lista" VIEW-AS TEXT
          SIZE 14.29 BY .62 AT ROW 4.77 COL 119 WIDGET-ID 44
          FONT 0
     "Ingresar Cliente" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 4.23 COL 118 WIDGET-ID 34
          FONT 0
     "Reporte" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 4.27 COL 108 WIDGET-ID 38
          FONT 0
     "Presione F10 para Reimprimir Etiquetas" VIEW-AS TEXT
          SIZE 41 BY .54 AT ROW 5.46 COL 60 WIDGET-ID 46
     "2018" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.12 COL 132 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 0 WIDGET-ID 100.


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
         HEIGHT             = 23.54
         WIDTH              = 142.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/bin/_prns.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table BUTTON-3 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

ASSIGN 
       cDesEst:VISIBLE IN BROWSE br_table = FALSE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Fechas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Horas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.ExpAsist,INTEGRAL.gn-clie WHERE INTEGRAL.ExpAsist ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&condicion}"
     _JoinCode[2]      = "gn-clie.CodCli = ExpAsist.CodCli"
     _Where[2]         = "gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.ExpAsist.CodCli
"ExpAsist.CodCli" "Código" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ExpAsist.NomCli
"ExpAsist.NomCli" "<<<<Nombre o Razón Social>>>>" "x(55)" "character" ? ? ? ? ? ? no ? no no "37.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.NroCard
"gn-clie.NroCard" "Nº Card" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.gn-clie.Ruc
"gn-clie.Ruc" "RUC" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ExpAsist.FecPro
"ExpAsist.FecPro" "Fecha!Program" ? "date" 6 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ExpAsist.HoraPro
"ExpAsist.HoraPro" "Hora!Program" ? "character" 11 ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.ExpAsist.FecAsi[1]
"ExpAsist.FecAsi[1]" "1º !Asistencia" ? "date" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.ExpAsist.HoraAsi[1]
"ExpAsist.HoraAsi[1]" "Hora" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.ExpAsist.FecAsi[2]
"ExpAsist.FecAsi[2]" "2º !Asistencia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.ExpAsist.HoraAsi[2]
"ExpAsist.HoraAsi[2]" "Hora" ? "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.ExpAsist.FecAsi[3]
"ExpAsist.FecAsi[3]" "3º !Asistencia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.ExpAsist.HoraAsi[3]
"ExpAsist.HoraAsi[3]" "Hora" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"IF (ExpAsist.Estado[1] = 'C' ) THEN ('Asistio') ELSE ('Ausente') @ cDesEst" "Situación" "X(15)" ? ? ? ? ? ? ? no ? no no "9" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
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
ON F10 OF br_table IN FRAME F-Main
DO:
    RUN Imprime-Barras.
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
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* @DD */
DO:
    RUN VtaExp\w-regclieasist.w.
    RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
    RUN Reporte-Excel.
    SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro B-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:

    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE AND
        rs-tipo = rs-tipo:SCREEN-VALUE AND
        COMBO-BOX-fechas = COMBO-BOX-fechas:SCREEN-VALUE AND
        COMBO-BOX-horas = COMBO-BOX-horas:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro
        rs-tipo
        COMBO-BOX-fechas
        COMBO-BOX-horas.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Fechas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Fechas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Fechas IN FRAME F-Main /* Fecha */
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Horas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Horas B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Horas IN FRAME F-Main /* Horario */
DO:
   APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo B-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Ingresar Código de Barras */
DO:
    DEF VAR UltimaTecla AS INT NO-UNDO.

    UltimaTecla = LASTKEY.

    IF INPUT FILL-IN-codigo = "" THEN RETURN.

    /*IF LENGTH(SELF:SCREEN-VALUE) = 12 THEN SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,2).*/

    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = FILL-IN-codigo:SCREEN-VALUE )
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION br_table TO ROWID ROWID( expasist ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
/*             MESSAGE                                                 */
/*                 "Registro no se encuentra en el filtro actual" SKIP */
/*                 "       Deshacer la actual selección ?       "      */
/*                 VIEW-AS ALERT-BOX QUESTION                          */
/*                 BUTTONS YES-NO TITLE "Pregunta"                     */
/*                 UPDATE answ AS LOGICAL.                             */
/*             IF answ THEN DO:                                        */
                ASSIGN
                    FILL-IN-filtro:SCREEN-VALUE = ""
                    CMB-filtro:SCREEN-VALUE = CMB-filtro:ENTRY(1).
                APPLY "VALUE-CHANGED" TO CMB-filtro.
                RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
                REPOSITION br_table TO ROWID ROWID( expasist ) NO-ERROR.
/*             END. */
        END.
        /*ASSIGN SELF:SCREEN-VALUE = "".*/
    &ENDIF
     APPLY "VALUE-CHANGED" TO CMB-filtro.
     RUN Registra-Asistencia.

     ASSIGN SELF:SCREEN-VALUE = "".

     RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
     IF UltimaTecla = 13 THEN DO:
         APPLY "Entry" TO fill-in-codigo.
         RETURN NO-APPLY.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON ANY-PRINTABLE OF FILL-IN-filtro IN FRAME F-Main
DO:
   /*APPLY "VALUE-CHANGED" TO CMB-filtro.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    /*APPLY "VALUE-CHANGED" TO CMB-filtro.*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anula_Registro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anula_Registro B-table-Win
ON CHOOSE OF MENU-ITEM m_Anula_Registro /* Anula Registro */
DO:
  
    FIND FIRST bexpasist WHERE ROWID(bexpasist) = ROWID(expasist) NO-ERROR.
    IF AVAIL bexpasist AND bexpasist.estado[2] = 'N' THEN DO:  
        MESSAGE 'Esta seguro de eliminar registro'
            VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
            TITLE '' UPDATE lchoice AS LOGICAL.
        IF lchoice THEN DO:
            ASSIGN 
                bexpasist.Estado[1] = 'A'
                bexpasist.Estado[5] = STRING(TODAY)
                bexpasist.Hora      = STRING(TIME,"HH:MM:SS")
                bexpasist.usuario   = s-user-id.  
        END.
    END.
    ELSE DO:
        MESSAGE 'Cliente pertenece a listado'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'adm-error'.
    END.
    IF AVAILABLE(bexpasist) THEN RELEASE bexpasist.
    RUN adm-open-query.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Registra_Asitencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Registra_Asitencia B-table-Win
ON CHOOSE OF MENU-ITEM m_Registra_Asitencia /* Registra Asitencia */
DO:
  RUN Registra-Asistencia.
  RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
  APPLY "Entry" TO fill-in-codigo IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Reimpresion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Reimpresion B-table-Win
ON CHOOSE OF MENU-ITEM m_Reimpresion /* Reimprime Etiqueta */
DO:
    RUN Imprime-Barras.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo B-table-Win
ON VALUE-CHANGED OF rs-tipo IN FRAME F-Main
DO:
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF fill-in-codigo, fill-in-filtro DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY ExpAsist.CodCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY gn-clie.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY ExpAsist.CodCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY gn-clie.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY ExpAsist.CodCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY gn-clie.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
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

/* RHC 05/10/2012 NO POR AHORA */
/*RETURN.*/
/* *************************** */

  DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRucCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHARACTER   FORMAT "99999999999" NO-UNDO.
  DEFINE VAR lNroCorre AS CHAR.
  DEFINE VAR lClas AS CHAR.
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
      /*
      cRucCli = TRIM(gn-clie.codcli) + (IF expasist.libre_c03 = "VIP" THEN "*" ELSE "")
      */
      /* Cliente VIP */
      cRucCli = TRIM(gn-clie.codcli).
      lClas = IF (expasist.libre_c03 <> ?) THEN TRIM(expasist.libre_c03) ELSE 'N9999'.
      IF SUBSTRING(lClas,1,1) = 'V' THEN cRucCli = TRIM(cRucCli) + "*".
      IF SUBSTRING(lClas,1,1) = 'E' THEN cRucCli = TRIM(cRucCli) + "-".
      cCodCli = gn-clie.codcli.
      lNroCorre = SUBSTRING(TRIM(lClas),2).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    RUN get-attribute ('Keys-Accepted').

    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
        ASSIGN
            CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
            CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE.
     
    ASSIGN CMB-filtro = "Todos".
    DISPLAY CMB-filtro WITH FRAME {&FRAME-NAME}.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY "ENTRY":U TO FILL-IN-Codigo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Asistencia B-table-Win 
PROCEDURE Registra-Asistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*IF expasist.Fecha = TODAY THEN DO:  */
    IF {&FECHAASIS} = TODAY THEN DO:
        MESSAGE 'Cliente ya ha sido registrado el dia de hoy ' 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "entry" TO fill-in-codigo IN FRAME {&FRAME-NAME}. 
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST bexpasist WHERE ROWID(bexpasist) = ROWID(expasist) NO-ERROR.
    IF AVAIL bexpasist THEN DO:
        ASSIGN
            bexpasist.Estado[1]     = 'C'
            bexpasist.Fecha         = TODAY     /*Campo Referencial*/
            bexpasist.Hora          = STRING(TIME,"HH:MM:SS")
            bexpasist.usuario       = s-user-id.

        IF bexpasist.FecAsi[1] = ? THEN 
            ASSIGN 
                bexpasist.FecAsi[1]  = TODAY
                bexpasist.HoraAsi[1] = STRING(TIME,"HH:MM:SS").
        ELSE IF bexpasist.FecAsi[1] = TODAY THEN bexpasist.HoraAsi[1] = STRING(TIME,"HH:MM:SS").
        ELSE IF bexpasist.FecAsi[2] = ? THEN 
            ASSIGN 
                bexpasist.FecAsi[2]  = TODAY
                bexpasist.HoraAsi[2] = STRING(TIME,"HH:MM:SS").
        ELSE IF bexpasist.FecAsi[2] = TODAY THEN bexpasist.HoraAsi[2] = STRING(TIME,"HH:MM:SS").
        ELSE 
            ASSIGN 
                bexpasist.FecAsi[3]  = TODAY
                bexpasist.HoraAsi[3] = STRING(TIME,"HH:MM:SS").

    END.
    IF bexpasist.FecAsi[2] = ? AND bexpasist.FecAsi[3] = ? THEN RUN Imprime-Barras. 
    IF AVAILABLE (expasist) THEN RELEASE expasist.
    IF AVAILABLE (bexpasist) THEN RELEASE bexpasist.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte-Excel B-table-Win 
PROCEDURE Reporte-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE cEstado AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = NO.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 10.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 40.
chWorkSheet:Columns("E"):ColumnWidth = 15.
chWorkSheet:Columns("F"):ColumnWidth = 30.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
cColumn = STRING(t-Column).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre o Razon Social".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Departamento".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Provincia".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Distrito".

cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "  Fecha Programada  ".

cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora Programada  ".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "  1º Asistencia  ".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora  ".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "  2º Asistencia ".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora  ".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "  3º Asistencia  ".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "  Hora  ".


FOR EACH ExpAsist WHERE {&CONDICION} NO-LOCK,
    FIRST GN-CLIE WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = ExpAsist.codcli NO-LOCK:
    cEstado = "".
    IF expasist.Estado[1] = 'P' THEN cEstado = 'Ausente'.
    IF expasist.Estado[1] = 'C' THEN cEstado = 'Asistio'.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + gn-clie.codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = cEstado.
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = TabDepto.NomDepto.
    END.
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept
        AND Tabprovi.Codprovi = gn-clie.CodProv NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN DO:
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = TabProvi.NomProvi.
    END.
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
        AND Tabdistr.Codprovi = gn-clie.codprov
        AND Tabdistr.Coddistr = gn-clie.CodDist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN DO:
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = TabDistr.NomDistr.
    END.

    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecPro).
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraPro).

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecAsi[1]).
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraAsi[1]).
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecAsi[2]).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraAsi[2]).
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.FecAsi[3]).
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ExpAsist.HoraAsi[3]).
END.
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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

