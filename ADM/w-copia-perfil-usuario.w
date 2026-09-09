&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEFINE VAR lUserId AS CHAR.

&SCOPED-DEFINE BROWSE-ALM BROWSE-3
&SCOPED-DEFINE BROWSE-DIV BROWSE-4
&SCOPED-DEFINE BROWSE-MOD BROWSE-5
&SCOPED-DEFINE BROWSE-USR BROWSE-7

&SCOPED-DEFINE CONDICION-ALM ( ~
            INTEGRAL.almusers.CodCia = s-codcia AND ~
            INTEGRAL.AlmUsers.USER-ID = lUserId)
&SCOPED-DEFINE CONDICION-DIV ( ~
            INTEGRAL.facusers.CodCia = s-codcia AND ~
            INTEGRAL.facusers.usuario = lUserId)

&SCOPED-DEFINE CONDICION-MOD ( ~
                INTEGRAL.pf-g004.USER-ID = lUserId)


define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
DEFINE VAR x-cajero AS CHAR.

DEF TEMP-TABLE tt-_user LIKE DICTDB._user.

DEFINE VAR x-quienes AS INT INIT 1.

/**/
DEFINE TEMP-TABLE t-user
    FIELD   cUSERID    LIKE _user._userid       COLUMN-LABEL 'Codigo'
    FIELD   user-name   LIKE _user._user-name   COLUMN-LABEL 'Nombres'
    FIELD   disabled    AS CHAR FORMAT 'x(15)'  COLUMN-LABEL 'Estado'
    FIELD   given_name  LIKE _user._given_name  COLUMN-LABEL 'Cod.Planilla'
    FIELD   create_date LIKE _user._create_date COLUMN-LABEL 'Creacion'
.

DEFINE TEMP-TABLE t-pf-g004 LIKE pf-g004.

 /*
      _user._userid COLUMN-LABEL 'Usuario' FORMAT "x(15)":U WIDTH 8.57
 COLUMN-LABEL 'Nombres' FORMAT "x(50)":U WIDTH 25.57
_user._disabled COLUMN-LABEL 'Inactivo' WIDTH 5.57
_user._given_name COLUMN-LABEL 'Codigo!Planilla' WIDTH 10.57
(IF (AVAILABLE UsrCjaCo) THEN "SI" ELSE "NO") @ x-cajero COLUMN-LABEL 'Cajero' WIDTH 5.57
_user._create_date COLUMN-LABEL 'Creacion' WIDTH 14.57
_user._user-misc COLUMN-LABEL 'Tipo!Usuario' WIDTH 8.57
_user._u-misc2[2] COLUMN-LABEL 'Pico!Sesion' WIDTH 5.57
_user._u-misc2[1] COLUMN-LABEL 'Empresa' FORMAT "x(25)" WIDTH 12.57

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AlmUsers Almacen FacUsers GN-DIVI PF-G004 ~
_user UsrCjaCo

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 AlmUsers.CodAlm Almacen.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH AlmUsers ~
      WHERE {&CONDICION-ALM} NO-LOCK, ~
      EACH Almacen OF AlmUsers NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH AlmUsers ~
      WHERE {&CONDICION-ALM} NO-LOCK, ~
      EACH Almacen OF AlmUsers NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 AlmUsers Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 AlmUsers
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Almacen


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 FacUsers.CodDiv FacUsers.CodAlm ~
FacUsers.Niveles GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH FacUsers ~
      WHERE {&CONDICION-DIV} NO-LOCK, ~
      EACH GN-DIVI OF FacUsers NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH FacUsers ~
      WHERE {&CONDICION-DIV} NO-LOCK, ~
      EACH GN-DIVI OF FacUsers NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 FacUsers GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 FacUsers
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 GN-DIVI


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 PF-G004.Aplic-Id PF-G004.Seguridad 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH PF-G004 ~
      WHERE {&CONDICION-MOD} NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH PF-G004 ~
      WHERE {&CONDICION-MOD} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 PF-G004
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 PF-G004


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 _user._userid _user._user-name _user._disabled _user._given_name (IF (AVAILABLE UsrCjaCo) THEN "SI" ELSE "NO") @ x-cajero _user._create_date _user._user-misc _user._u-misc2[2] _user._u-misc2[1]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7   
&Scoped-define SELF-NAME BROWSE-7
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH _user WHERE (x-quienes = 1) OR                                             (x-quienes = 2 AND _user._disabled = NO) OR                                             (x-quienes = 3 AND _user._disabled = YES) NO-LOCK, ~
                                                   EACH UsrCjaCo WHERE (UsrCjaCo.codcia = s-codcia AND UsrCjaCo.usuario = _user._userid) OUTER-JOIN NO-LOCK                                         BY _user._userid
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY {&SELF-NAME} FOR EACH _user WHERE (x-quienes = 1) OR                                             (x-quienes = 2 AND _user._disabled = NO) OR                                             (x-quienes = 3 AND _user._disabled = YES) NO-LOCK, ~
                                                   EACH UsrCjaCo WHERE (UsrCjaCo.codcia = s-codcia AND UsrCjaCo.usuario = _user._userid) OUTER-JOIN NO-LOCK                                         BY _user._userid .
&Scoped-define TABLES-IN-QUERY-BROWSE-7 _user UsrCjaCo
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 _user
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-7 UsrCjaCo


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-4 BROWSE-5 BROWSE-7 BROWSE-3 BUTTON-5 ~
RADIO-SET-quienes txtNuevoUser COMBO-BOX-empresa txtNombre txtcodper ~
RADIO-SET-picosesion RADIO-SET-tipo ChkCopiaAlmacen ChkCopiaDivision ~
chkActualizar chkPassword chkb-del-mod btnDarBaja btnCopiar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-usrref FILL-IN-1 RADIO-SET-quienes ~
txtNuevoUser COMBO-BOX-empresa txtNombre txtcodper txtNomPer ~
RADIO-SET-picosesion RADIO-SET-tipo ChkCopiaAlmacen ChkCopiaDivision ~
chkInhabilitar chkActualizar chkPassword chkb-del-mod 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCopiar 
     LABEL "Realizar la Copia" 
     SIZE 21 BY 1.12.

DEFINE BUTTON btnDarBaja 
     LABEL "Inactivar usuario" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Excel" 
     SIZE 15 BY .96.

DEFINE VARIABLE COMBO-BOX-empresa AS CHARACTER FORMAT "X(25)":U 
     LABEL "Empresa" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "CONTINENTAL","UTILEX","STANDFORD" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(100)":U INITIAL "Que usuarios debe mostrarse en pantalla" 
      VIEW-AS TEXT 
     SIZE 35 BY .5
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-usrref AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario referencial" 
      VIEW-AS TEXT 
     SIZE 19 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtcodper AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cod.Planilla" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY 1 NO-UNDO.

DEFINE VARIABLE txtNombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre Usuario" 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY 1 NO-UNDO.

DEFINE VARIABLE txtNomPer AS CHARACTER FORMAT "X(120)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .92
     FONT 1 NO-UNDO.

DEFINE VARIABLE txtNuevoUser AS CHARACTER FORMAT "X(11)":U 
     LABEL "Nuevo Usuario" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-picosesion AS CHARACTER INITIAL "SI" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SI", "SI",
"NO", "NO"
     SIZE 10.43 BY .77 NO-UNDO.

DEFINE VARIABLE RADIO-SET-quienes AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo Activos", 2,
"Solo Inactivos", 3
     SIZE 46 BY .77 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipo AS CHARACTER INITIAL "PERSONAL" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Personal", "PERSONAL",
"Generico", "GENERICO"
     SIZE 24 BY .77 NO-UNDO.

DEFINE VARIABLE chkActualizar AS LOGICAL INITIAL no 
     LABEL "Si existe el usuario actualizar..." 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .77 NO-UNDO.

DEFINE VARIABLE chkb-del-mod AS LOGICAL INITIAL no 
     LABEL "Si usuario existe, ELIMINAR sus modulos/app antes de grabar" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .77 NO-UNDO.

DEFINE VARIABLE ChkCopiaAlmacen AS LOGICAL INITIAL no 
     LABEL "Copiar los almacenes asignados" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY .77 NO-UNDO.

DEFINE VARIABLE ChkCopiaDivision AS LOGICAL INITIAL no 
     LABEL "Copiar la division asignada" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .77 NO-UNDO.

DEFINE VARIABLE chkInhabilitar AS LOGICAL INITIAL no 
     LABEL "Copiar inhabilitado" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .77 NO-UNDO.

DEFINE VARIABLE chkPassword AS LOGICAL INITIAL no 
     LABEL "Blanquear Password" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      AlmUsers, 
      Almacen SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      FacUsers, 
      GN-DIVI SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      PF-G004 SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      _user, 
      UsrCjaCo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      AlmUsers.CodAlm FORMAT "x(3)":U
      Almacen.Descripcion FORMAT "X(40)":U WIDTH 22.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 34 BY 7.81
         FONT 4
         TITLE "ALMACENES ASIGNADOS AL USUARIO" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      FacUsers.CodDiv COLUMN-LABEL "Division" FORMAT "x(5)":U WIDTH 7.43
      FacUsers.CodAlm FORMAT "x(3)":U
      FacUsers.Niveles FORMAT "X(20)":U WIDTH 6
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 15.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 41.72 BY 7.77
         FONT 4
         TITLE "DIVISION DEL USUARIO" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      PF-G004.Aplic-Id FORMAT "X(5)":U WIDTH 5.72
      PF-G004.Seguridad FORMAT "X(200)":U WIDTH 126.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.29 BY 10.38
         FONT 4
         TITLE "APLICACION DEL PERFIL DEL USUARIO".

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _FREEFORM
  QUERY BROWSE-7 NO-LOCK DISPLAY
      _user._userid COLUMN-LABEL 'Usuario' FORMAT "x(15)":U WIDTH 8.57
_user._user-name COLUMN-LABEL 'Nombres' FORMAT "x(50)":U WIDTH 25.57
_user._disabled COLUMN-LABEL 'Inactivo' WIDTH 5.57
_user._given_name COLUMN-LABEL 'Codigo!Planilla' WIDTH 10.57
(IF (AVAILABLE UsrCjaCo) THEN "SI" ELSE "NO") @ x-cajero COLUMN-LABEL 'Cajero' WIDTH 5.57
_user._create_date COLUMN-LABEL 'Creacion' WIDTH 14.57
_user._user-misc COLUMN-LABEL 'Tipo!Usuario' WIDTH 8.57
_user._u-misc2[2] COLUMN-LABEL 'Pico!Sesion' WIDTH 5.57
_user._u-misc2[1] COLUMN-LABEL 'Empresa' FORMAT "x(25)" WIDTH 12.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 10.15
         FONT 4
         TITLE "USUARIOS DEL SISTEMA" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-4 AT ROW 1.12 COL 125.29 WIDGET-ID 400
     BROWSE-5 AT ROW 12.73 COL 1.72 WIDGET-ID 500
     BROWSE-7 AT ROW 2.54 COL 1.43 WIDGET-ID 600
     BROWSE-3 AT ROW 1.08 COL 90.72 WIDGET-ID 300
     FILL-IN-usrref AT ROW 14.46 COL 135 COLON-ALIGNED WIDGET-ID 48
     BUTTON-5 AT ROW 1.38 COL 68 WIDGET-ID 46
     FILL-IN-1 AT ROW 1.12 COL 2.57 NO-LABEL WIDGET-ID 44
     RADIO-SET-quienes AT ROW 1.65 COL 2.57 NO-LABEL WIDGET-ID 40
     txtNuevoUser AT ROW 9.38 COL 105.29 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-empresa AT ROW 9.38 COL 131.29 COLON-ALIGNED WIDGET-ID 32
     txtNombre AT ROW 10.42 COL 105.14 COLON-ALIGNED WIDGET-ID 4
     txtcodper AT ROW 11.46 COL 105.29 COLON-ALIGNED WIDGET-ID 18
     txtNomPer AT ROW 11.46 COL 115.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     RADIO-SET-picosesion AT ROW 12.54 COL 107.43 NO-LABEL WIDGET-ID 34
     RADIO-SET-tipo AT ROW 13.42 COL 107.43 NO-LABEL WIDGET-ID 26
     ChkCopiaAlmacen AT ROW 16 COL 98.14 WIDGET-ID 6
     ChkCopiaDivision AT ROW 16 COL 125.72 WIDGET-ID 8
     chkInhabilitar AT ROW 17.46 COL 98 WIDGET-ID 14
     chkActualizar AT ROW 18.23 COL 98 WIDGET-ID 12
     chkPassword AT ROW 19.08 COL 98 WIDGET-ID 24
     chkb-del-mod AT ROW 20.15 COL 107 WIDGET-ID 16
     btnDarBaja AT ROW 21.58 COL 98 WIDGET-ID 22
     btnCopiar AT ROW 21.58 COL 121 WIDGET-ID 10
     "Pico y Session ?" VIEW-AS TEXT
          SIZE 12.29 BY .62 AT ROW 12.58 COL 105.86 RIGHT-ALIGNED WIDGET-ID 38
     "Tipo de Usuario" VIEW-AS TEXT
          SIZE 12.29 BY .62 AT ROW 13.5 COL 105.86 RIGHT-ALIGNED WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 166.72 BY 22.19
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Copiar perfil de un USUARIO a OTRO NUEVO"
         HEIGHT             = 22.19
         WIDTH              = 166.72
         MAX-HEIGHT         = 25.15
         MAX-WIDTH          = 173.57
         VIRTUAL-HEIGHT     = 25.15
         VIRTUAL-WIDTH      = 173.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-4 1 F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-4 F-Main */
/* BROWSE-TAB BROWSE-7 BROWSE-5 F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-7 F-Main */
ASSIGN 
       BROWSE-7:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR TOGGLE-BOX chkInhabilitar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-usrref IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNomPer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TEXT-LITERAL "Pico y Session ?"
          SIZE 12.29 BY .62 AT ROW 12.58 COL 105.86 RIGHT-ALIGNED       */

/* SETTINGS FOR TEXT-LITERAL "Tipo de Usuario"
          SIZE 12.29 BY .62 AT ROW 13.5 COL 105.86 RIGHT-ALIGNED        */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.AlmUsers,INTEGRAL.Almacen OF INTEGRAL.AlmUsers"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&CONDICION-ALM}"
     _FldNameList[1]   = INTEGRAL.AlmUsers.CodAlm
     _FldNameList[2]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.FacUsers,INTEGRAL.GN-DIVI OF INTEGRAL.FacUsers"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&CONDICION-DIV}"
     _FldNameList[1]   > INTEGRAL.FacUsers.CodDiv
"FacUsers.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.FacUsers.CodAlm
     _FldNameList[3]   > INTEGRAL.FacUsers.Niveles
"FacUsers.Niveles" ? ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.PF-G004"
     _Options          = "NO-LOCK"
     _Where[1]         = "{&CONDICION-MOD}"
     _FldNameList[1]   > INTEGRAL.PF-G004.Aplic-Id
"PF-G004.Aplic-Id" ? ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.PF-G004.Seguridad
"PF-G004.Seguridad" ? "X(200)" "character" ? ? ? ? ? ? no ? no no "126.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH _user WHERE (x-quienes = 1) OR
                                            (x-quienes = 2 AND _user._disabled = NO) OR
                                            (x-quienes = 3 AND _user._disabled = YES) NO-LOCK,
                                            EACH UsrCjaCo WHERE (UsrCjaCo.codcia = s-codcia AND UsrCjaCo.usuario = _user._userid) OUTER-JOIN NO-LOCK
                                        BY _user._userid .
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Copiar perfil de un USUARIO a OTRO NUEVO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Copiar perfil de un USUARIO a OTRO NUEVO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON START-SEARCH OF BROWSE-7 IN FRAME F-Main /* USUARIOS DEL SISTEMA */
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-7:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF lColumName = "x-cajero" THEN RETURN.

    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.

    hQueryHandle = BROWSE BROWSE-7:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /*hQueryHandle:QUERY-PREPARE("FOR EACH Detalle NO-LOCK, EACH INTEGRAL.PL-PERS OF Detalle NO-LOCK BY " + lColumName + " " + x-sort-direccion).*/
    /*hQueryHandle:QUERY-PREPARE("FOR EACH _user NO-LOCK BY " + lColumName + " " + x-sort-direccion).    */

    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH _user WHERE (" + string(x-quienes) + " = 1) OR " .
    x-sql = x-sql + "(" + string(x-quienes) + " = 2 AND _user._disabled = NO) OR ".
    x-sql = x-sql + "(" + string(x-quienes) + " = 3 AND _user._disabled = YES) NO-LOCK, ".
    x-sql = x-sql + "EACH UsrCjaCo WHERE (UsrCjaCo.codcia = " + string(s-codcia) + " AND UsrCjaCo.usuario = _user._userid) OUTER-JOIN NO-LOCK " .   
    x-sql = x-sql + "BY " + lColumName + " " + x-sort-direccion.

    SESSION:SET-WAIT-STATE("GENERAL").
    hQueryHandle:QUERY-PREPARE(x-sql).   
    hQueryHandle:QUERY-OPEN().
    SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON VALUE-CHANGED OF BROWSE-7 IN FRAME F-Main /* USUARIOS DEL SISTEMA */
DO:
  
    lUserId = _user._userid:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .
    txtNuevoUser:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lUserId.
    fill-in-usrref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lUserId.
    txtNombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = _user._user-name.


    DEF BUFFER gn-user FOR gn-user.    
        
    FIND FIRST gn-user WHERE gn-user.codcia = s-codcia AND 
               gn-user.USER-ID = lUserId NO-LOCK NO-ERROR.
        
    IF AVAILABLE gn-user THEN DO:
        txtCodPer:SCREEN-VALUE = if(gn-user.codper = ?) THEN "" ELSE gn-user.codper.
    END.


    txtNomPer:SCREEN-VALUE = "".
    DEFINE VAR lCodPer AS CHAR.

    lCodPer = txtCodPer:SCREEN-VALUE.
  
    FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                            pl-pers.codper = lCodPer NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:

        txtNomPer:SCREEN-VALUE = TRIM(TRIM(pl-pers.nomper) + " " + TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper)).
        /*
        txtNomPer:SCREEN-VALUE = trim(pl-pers.patper) + " " + 
                                    TRIM(pl-pers.matper) + " " +
                                    TRIM(pl-pers.nomper).
        */
    END.

    radio-set-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PERSONAL".
    IF NOT (TRUE <> (_user._user-misc > "")) THEN DO:
        IF TRIM(_user._user-misc) = "generico" OR 
           TRIM( _user._user-misc) = "personalizado" THEN DO:
            radio-set-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                IF (TRIM(_user._user-misc) = "generico") THEN "GENERICO" ELSE "PERSONAL".
        END.        
    END.

    radio-set-picosesion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
    IF NOT (TRUE <> (_user._U-misc2[2] > "")) THEN DO:
        IF TRIM(_user._U-misc2[2]) = "SI" OR 
           TRIM(_user._U-misc2[2]) = "NO" THEN DO:
            radio-set-picosesion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(_user._U-misc2[2]).
        END.        
    END.

    combo-box-empresa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CONTINENTAL".
    
    IF NOT (TRUE <> (_user._U-misc2[1] > "")) THEN DO:
        IF LOOKUP(TRIM(_user._U-misc2[1]),"CONTINENTAL,,UTILEX,STANDFORD") > 0 THEN DO:
            combo-box-empresa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(_user._U-misc2[1]).
        END.        
    END.
    

    {&OPEN-QUERY-BROWSE-3}
    {&OPEN-QUERY-BROWSE-4}
    {&OPEN-QUERY-BROWSE-5}
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCopiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCopiar W-Win
ON CHOOSE OF btnCopiar IN FRAME F-Main /* Realizar la Copia */
DO:
  ASSIGN txtNuevoUser txtNombre ChkCopiaAlmacen ChkCopiaDivision ChkActualizar ChkPassword
        ChkInhabilitar txtCodPer radio-set-tipo radio-set-picosesion combo-box-empresa fill-in-usrref chkb-del-mod.

  IF LENGTH(TRIM(txtNuevoUser)) < 3 THEN DO:
      MESSAGE "Codigo Usuario debe Tener al menos 5 digitos " VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
  IF LENGTH(TRIM(txtNombre)) < 10 THEN DO:
      MESSAGE "Nombre de Usuario debe Tener al menos 10 digitos " VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
  IF LENGTH(txtCodPer) < 6 THEN DO:
      MESSAGE "Ingrese codigo de planilla " VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.

  DEFINE VAR lCodPer AS CHAR.

  lCodPer = txtCodPer.

  FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                          pl-pers.codper = lCodPer NO-LOCK NO-ERROR.
  IF NOT AVAILABLE pl-pers THEN DO:
      MESSAGE "Codigo de planilla NO EXISTE" VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.


        MESSAGE 'Desea Copiar el Perfil al nuevo Usuario?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN ue-add-user.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDarBaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDarBaja W-Win
ON CHOOSE OF btnDarBaja IN FRAME F-Main /* Inactivar usuario */
DO:
  
    ASSIGN txtNuevoUser.

    IF AVAILABLE _user THEN DO:

        DEFINE VAR lRowId AS ROWID.

        MESSAGE 'Seguro de INACTIVAR a ' _user._userid  VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
        
        DEF BUFFER b-_user FOR DICTDB._user.
        /**/
        FIND FIRST b-_user WHERE b-_user._userid = txtNuevoUser EXCLUSIVE NO-ERROR.
        IF AVAILABLE b-_user THEN DO:
             ASSIGN b-_user._disabled = YES
                    b-_user._account_expires = NOW.
        END.

        RELEASE b-_user.    

        ASSIGN lRowId = ROWID(_user).

        {&OPEN-QUERY-BROWSE-7}

        REPOSITION {&BROWSE-USR}  TO ROWID lRowId.

        MESSAGE "Se INACTIVO al usuario " _user._userid VIEW-AS ALERT-BOX.


    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Excel */
DO:
  RUN excel-usuarios.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-quienes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-quienes W-Win
ON VALUE-CHANGED OF RADIO-SET-quienes IN FRAME F-Main
DO:
  x-quienes = INTEGER(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

  {&open-query-browse-7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtcodper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtcodper W-Win
ON LEAVE OF txtcodper IN FRAME F-Main /* Cod.Planilla */
DO:
    txtNomPer:SCREEN-VALUE = "".
  DEFINE VAR lCodPer AS CHAR.

  lCodPer = txtCodPer:SCREEN-VALUE.
  
  FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                            pl-pers.codper = lCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN DO:
      /*
        txtNomPer:SCREEN-VALUE = trim(pl-pers.patper) + " " + 
                                    TRIM(pl-pers.matper) + " " +
                                    TRIM(pl-pers.nomper).
        txtNombre:SCREEN-VALUE = trim(pl-pers.patper) + " " + 
                                    TRIM(pl-pers.matper) + " " +
                                    TRIM(pl-pers.nomper).
        */
        txtNombre:SCREEN-VALUE = TRIM(TRIM(pl-pers.nomper) + " " + TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper)).
        txtNomPer:SCREEN-VALUE = TRIM(TRIM(pl-pers.nomper) + " " + TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtcodper W-Win
ON LEFT-MOUSE-DBLCLICK OF txtcodper IN FRAME F-Main /* Cod.Planilla */
OR F8 OF txtCodPer DO:
  input-var-1 = ''.
  input-var-2 = ''.
  input-var-3 = ''.
  output-var-1 = ?.
  RUN pln/c-plnper.
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


/*
_user._given_name COLUMN-LABEL 'Codigo!Planilla' WIDTH 10.57
(IF (AVAILABLE UsrCjaCo) THEN "SI" ELSE "NO") @ x-cajero COLUMN-LABEL 'Cajero' WIDTH 5.57
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-usrref FILL-IN-1 RADIO-SET-quienes txtNuevoUser 
          COMBO-BOX-empresa txtNombre txtcodper txtNomPer RADIO-SET-picosesion 
          RADIO-SET-tipo ChkCopiaAlmacen ChkCopiaDivision chkInhabilitar 
          chkActualizar chkPassword chkb-del-mod 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-4 BROWSE-5 BROWSE-7 BROWSE-3 BUTTON-5 RADIO-SET-quienes 
         txtNuevoUser COMBO-BOX-empresa txtNombre txtcodper 
         RADIO-SET-picosesion RADIO-SET-tipo ChkCopiaAlmacen ChkCopiaDivision 
         chkActualizar chkPassword chkb-del-mod btnDarBaja btnCopiar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excel-usuarios W-Win 
PROCEDURE excel-usuarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
          /*
    FIELD   cUSERID    LIKE _user._userid       COLUMN-LABEL 'Codigo'
    FIELD   user-name   LIKE _user._user-name   COLUMN-LABEL 'Nombres'
    FIELD   disabled    AS CHAR FORMAT 'x(15)'  COLUMN-LABEL 'Estado'
    FIELD   given_name  LIKE _user._given_name  COLUMN-LABEL 'Cod.Planilla'
    FIELD   create_date LIKE _user._create_date COLUMN-LABEL 'Creacion'

        VtaDList.codmat:SCREEN-VALUE IN BROWSE {browse-7}
        */

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE t-user.           
           
GET FIRST BROWSE-7.

DO  WHILE AVAILABLE _user:

    CREATE t-user.
        ASSIGN  t-user.cUSERID = _user._USERID
                t-user.user-name = _user._user-name
                t-user.DISABLED = if(_user._DISABLED = ?) THEN "ACTIVO" ELSE "INACTIVO"
                t-user.given_name = _user._given_name
                t-user.create_date = _user._create_date
                .
    if(_user._DISABLED <> ?) THEN DO:
        if(_user._DISABLED = YES) THEN DO:
            ASSIGN t-user.DISABLED = "INACTIVO".
        END.
        ELSE DO:
            ASSIGN t-user.DISABLED = "ACTIVO".
        END.
    END.
    GET NEXT browse-7.
END.

GET FIRST BROWSE-7.


DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'd:\xpciman\UsersActivos.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer t-user:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer t-user:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "_user"}
  {src/adm/template/snd-list.i "UsrCjaCo"}
  {src/adm/template/snd-list.i "PF-G004"}
  {src/adm/template/snd-list.i "FacUsers"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "AlmUsers"}
  {src/adm/template/snd-list.i "Almacen"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-add-user W-Win 
PROCEDURE ue-add-user :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR lRowId AS ROWID.

    DEF BUFFER b-_user FOR DICTDB._user.
    EMPTY TEMP-TABLE tt-_user.

    DEFINE VAR x-seguridad-old AS CHAR.
    DEFINE VAR x-seguridad-new AS CHAR.
    
    /**/
    FIND FIRST b-_user WHERE b-_user._userid = txtNuevoUser EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-_user THEN DO:
        IF ChkActualizar = NO THEN DO:
            MESSAGE "Usuario ya existe...ingrese nuevo" VIEW-AS ALERT-BOX.
            RELEASE b-_user.
             RETURN NO-APPLY.
        END.
        ELSE DO:
            IF ChkPassword = YES THEN DO:
                /* Blanqueo de Password */
                BUFFER-COPY b-_user TO tt-_user.

                ASSIGN tt-_user._user-name     = txtNombre
                    tt-_user._disabled = ChkInhabilitar
                    tt-_user._last_login = NOW
                    tt-_user._account_expires = ?
                    tt-_user._user-misc = radio-set-tipo
                    tt-_user._given_name = txtCodper
                    tt-_user._U-misc2[1] = combo-box-empresa
                    tt-_user._U-misc2[2] = radio-set-picosesion
                    .
            
                    ASSIGN tt-_user._password = "pjqtudckibycRKbj"
                            tt-_user._logins = 0.

                DELETE b-_user.

                CREATE b-_user.
                    BUFFER-COPY tt-_user TO b-_user.

                    ASSIGN lRowId = ROWID(b-_user).

            END.
            ELSE DO:
                ASSIGN b-_user._user-name     = txtNombre
                   b-_user._disabled = ChkInhabilitar
                   b-_user._account_expires = ?
                   b-_user._last_login = NOW
                   b-_user._user-misc = radio-set-tipo
                   b-_user._given_name = txtCodper
                   b-_user._U-misc2[1] = combo-box-empresa
                   b-_user._U-misc2[2] = radio-set-picosesion
                .

                ASSIGN lRowId = ROWID(b-_user).
            END.
        END.
    END.
    ELSE DO: 
        CREATE b-_user.
        ASSIGN b-_user._userid     = txtNuevoUser     
                b-_user._user-name     = txtNombre
                b-_user._password = "pjqtudckibycRKbj"
                b-_user._CREATE_date   = NOW /*TODAY*/
                b-_user._disabled = ChkInhabilitar                
                b-_user._last_login = NOW
                b-_user._user-misc = radio-set-tipo
                b-_user._given_name = txtCodper
                b-_user._U-misc2[1] = combo-box-empresa
                b-_user._U-misc2[2] = radio-set-picosesion
            .

        ASSIGN lRowId = ROWID(b-_user).

    END.

    RELEASE b-_user.    

    /**/
    DEF BUFFER b-gn-user FOR gn-user.    

        
    FIND FIRST b-gn-user WHERE b-gn-user.codcia = s-codcia AND 
               b-gn-user.USER-ID = txtNuevoUser EXCLUSIVE NO-ERROR.
        
    IF AVAILABLE b-gn-user THEN DO:
        IF ChkActualizar = NO THEN DO:
            /*
            MESSAGE "Usuario ya existe...ingrese nuevo" VIEW-AS ALERT-BOX.
            RELEASE b-gn-user.
             RETURN NO-APPLY.
            */
        END.
        ASSIGN b-gn-user.USER-name     = txtNombre
                b-gn-user.codper = txtCodPer.            

    END.
    ELSE CREATE b-gn-user.    
        ASSIGN b-gn-user.codcia     = s-codcia 
            b-gn-user.USER-ID       = txtNuevoUser
            b-gn-user.USER-name     = txtNombre
            b-gn-user.CREATE-date   = TODAY
            b-gn-user.codper = txtCodPer.

    RELEASE b-gn-user.        

    DEF BUFFER b-pf-g004 FOR pf-g004.

    /* Limpiamos la tabla y cargamos los modulos del usuario referenciado */
    EMPTY TEMP-TABLE t-pf-g004.
    FOR EACH b-pf-g004 WHERE b-pf-g004.codcia = pf-g004.codcia AND 
                            b-pf-g004.USER-ID = fill-in-usrref :
        BUFFER-COPY b-pf-g004 TO t-pf-g004.
    END.

    /* Eliminar sus modulos actuales al crear un nuevo usuario si es que ya existe */
    IF chkb-del-mod = YES THEN DO:
        FOR EACH b-pf-g004 WHERE b-pf-g004.codcia = pf-g004.codcia AND 
                                b-pf-g004.USER-ID = txtNuevoUser :
            DELETE b-pf-g004.
        END.
    END.

    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-perfil AS CHAR.

    /* Los Modulos para el nuevo usuario  */        
    GET FIRST {&BROWSE-MOD} .
    DO  WHILE AVAILABLE pf-g004:
        IF pf-g004.seguridad <> ? AND pf-g004.seguridad <> "" THEN DO:
            IF pf-g004.aplic-id <> ? AND pf-g004.aplic-id <> "" THEN DO:

                x-seguridad-old = TRIM(pf-g004.seguridad).
                x-seguridad-new = "".

                FIND FIRST b-pf-g004 WHERE b-pf-g004.codcia = pf-g004.codcia AND 
                    b-pf-g004.USER-ID = txtNuevoUser AND b-pf-g004.aplic-id = pf-g004.aplic-id EXCLUSIVE NO-ERROR.
                IF NOT AVAILABLE b-pf-g004 THEN DO:
                    CREATE b-pf-g004.
                    ASSIGN b-pf-g004.codcia = pf-g004.codcia
                        b-pf-g004.USER-ID   = txtNuevoUser
                        b-pf-g004.aplic-id  = pf-g004.aplic-id
                        .
                    x-seguridad-new = "".
                END.                
                ELSE DO:
                    x-seguridad-new = TRIM(b-pf-g004.seguridad).
                    IF chkb-del-mod = YES THEN DO:
                        x-seguridad-new = "".
                    END.
                END.                

                ASSIGN b-pf-g004.admin     = pf-g004.admin.
                /*
                MESSAGE "PRE " SKIP
                        "x-seguridad-new " x-seguridad-new SKIP
                        "x-seguridad-old " x-seguridad-old.
                */
                /* Adicionamos los perfiles del usuario referencial hacia el nuevo usuario */
                REPEAT x-sec = 1 TO NUM-ENTRIES(x-seguridad-old,","):
                    x-perfil = ENTRY(x-sec,x-seguridad-old,",").
                    IF LOOKUP(x-perfil,x-seguridad-new) = 0 THEN DO:
                        IF x-seguridad-new = "" THEN DO:
                            x-seguridad-new = x-perfil.
                        END.
                        ELSE DO:
                            x-seguridad-new = x-seguridad-new + "," + x-perfil.
                        END.                        
                    END.
                END.

                ASSIGN b-pf-g004.seguridad = x-seguridad-new.
                /* 
                MESSAGE "POST " SKIP
                        "x-seguridad-new " x-seguridad-new SKIP
                        "x-seguridad-old " x-seguridad-old.
                */

            END.
        END.
        GET NEXT {&BROWSE-MOD}.
    END.
    RELEASE b-pf-g004.
    
    /* Almacenes */
    /*ChkCopiaAlmacen ChkCopiaDivision.*/
    IF ChkCopiaAlmacen = YES THEN DO:
        DEFINE BUFFER b-almusers FOR almusers.
        GET FIRST {&BROWSE-ALM}.
        DO WHILE AVAILABLE almusers:
            IF almusers.codalm <> ? AND almusers.codalm <> "" THEN DO:
                FIND FIRST b-almusers WHERE b-almusers.codcia = almusers.codcia AND
                    b-almusers.USER-ID = txtNuevoUser AND b-almusers.codalm = almusers.codalm EXCLUSIVE NO-ERROR.
                IF NOT AVAILABLE b-almusers THEN DO:
                    CREATE b-almusers.
                        ASSIGN b-almusers.codcia    = almusers.codcia
                            b-almusers.USER-ID      = txtNuevoUser
                            b-almusers.codalm       = almusers.codalm.
                END.
            END.
            GET NEXT {&BROWSE-ALM}.
        END.
        RELEASE b-almusers.        
    END.    

    /* Divisiones */
    IF ChkCopiaDivision THEN DO:
        DEFINE BUFFER b-facusers FOR facusers.
        GET FIRST {&BROWSE-DIV}.
        DO WHILE AVAILABLE facusers:
            IF facusers.coddiv <> ? AND facusers.coddiv <> "" THEN DO:
                FIND FIRST b-facusers WHERE b-facusers.codcia = facusers.codcia AND
                    b-facusers.usuario = txtNuevoUser AND 
                    b-facusers.coddiv = facusers.coddiv
                    EXCLUSIVE NO-ERROR.
                IF NOT AVAILABLE b-facusers THEN DO:
                    CREATE b-facusers.
                    ASSIGN  b-facusers.codcia   = facusers.codcia
                        b-facusers.usuario  = txtNuevoUser
                        b-facusers.coddiv   = facusers.coddiv
                        b-facusers.codven   = facusers.codven
                        b-facusers.codalm   = facusers.codalm
                        b-facusers.niveles  = facusers.niveles.
                END.
            END.
            GET NEXT {&BROWSE-DIV}.
        END.
        RELEASE b-facusers.
    END.       
    
    /*{&OPEN-QUERY-BROWSE-2}*/
    {&OPEN-QUERY-BROWSE-7}

    REPOSITION {&BROWSE-USR}  TO ROWID lRowId.

    MESSAGE "Copia de Perfil se copio OK" VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

