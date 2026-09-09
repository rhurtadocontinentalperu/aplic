&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

/*
&SCOPED-DEFINE CONDICION-ALM ( ~
            INTEGRAL.almusers.CodCia = s-codcia AND ~
            INTEGRAL.AlmUsers.USER-ID = lUserId)

&SCOPED-DEFINE CONDICION-DIV ( ~
            INTEGRAL.facusers.CodCia = s-codcia AND ~
            INTEGRAL.facusers.usuario = lUserId)

&SCOPED-DEFINE CONDICION-MOD ( ~
                INTEGRAL.pf-g004.USER-ID = lUserId)
*/

define var x-sort-direccion as char init "".
define var x-sort-column as char init "".

DEF TEMP-TABLE tt-_user LIKE DICTDB._user.

DEFINE VAR x-diadelasemana AS INT INIT 0.

DEFINE BUFFER usuarios-sistema FOR dictdb._user.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-10

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report _user

/* Definitions for BROWSE BROWSE-10                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-10 tt-w-report.Campo-L[1] ~
tt-w-report.Campo-C[1] tt-w-report.Campo-C[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-10 tt-w-report.Campo-L[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-10 tt-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-10 tt-w-report
&Scoped-define QUERY-STRING-BROWSE-10 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-10 OPEN QUERY BROWSE-10 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-10 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-10 tt-w-report


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 _user._userid _user._user-name _user._disabled _user._create_date _user._user-misc _user._u-misc2[2] _user._u-misc2[1]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7   
&Scoped-define SELF-NAME BROWSE-7
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH _user WHERE _user._disabled = NO BY _user._userid INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY {&SELF-NAME} FOR EACH _user WHERE _user._disabled = NO BY _user._userid INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 _user
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 _user


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-10}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-7 BROWSE-10 btnCopiar ~
RADIO-SET-picosesion 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-cargo FILL-IN-nombre ~
FILL-IN-userid FILL-IN-seccion RADIO-SET-picosesion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cargo-seccion W-Win 
FUNCTION cargo-seccion RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCopiar 
     LABEL "Grabar horario del Usuario" 
     SIZE 21 BY 1.12.

DEFINE VARIABLE FILL-IN-cargo AS CHARACTER FORMAT "X(80)":U 
     LABEL "Cargo" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(80)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 38.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-seccion AS CHARACTER FORMAT "X(80)":U 
     LABEL "Seccion" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-userid AS CHARACTER FORMAT "X(15)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-picosesion AS CHARACTER INITIAL "SI" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SI", "SI",
"NO", "NO"
     SIZE 10.43 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-10 FOR 
      tt-w-report SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      _user SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-10 W-Win _STRUCTURED
  QUERY BROWSE-10 NO-LOCK DISPLAY
      tt-w-report.Campo-L[1] COLUMN-LABEL "Sele" FORMAT "Si/No":U
            COLUMN-FONT 6 VIEW-AS TOGGLE-BOX
      tt-w-report.Campo-C[1] COLUMN-LABEL "Desde" FORMAT "X(8)":U
            WIDTH 9.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Hasta" FORMAT "X(8)":U
            WIDTH 8.72
  ENABLE
      tt-w-report.Campo-L[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36 BY 13.38
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _FREEFORM
  QUERY BROWSE-7 NO-LOCK DISPLAY
      _user._userid COLUMN-LABEL 'Usuario' FORMAT "x(15)":U WIDTH 8.57
_user._user-name COLUMN-LABEL 'Nombres' FORMAT "x(50)":U WIDTH 25.57
_user._disabled COLUMN-LABEL 'Inactivo' WIDTH 5.57
_user._create_date COLUMN-LABEL 'Creacion' WIDTH 14.57
_user._user-misc COLUMN-LABEL 'Tipo!Usuario' WIDTH 8.57
_user._u-misc2[2] COLUMN-LABEL 'Pico!Sesion' WIDTH 5.57
_user._u-misc2[1] COLUMN-LABEL 'Empresa' FORMAT "x(25)" WIDTH 12.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 8.23
         FONT 4
         TITLE "USUARIOS DEL SISTEMA" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-7 AT ROW 1.04 COL 1.29 WIDGET-ID 600
     BROWSE-10 AT ROW 9.35 COL 4.57 WIDGET-ID 700
     FILL-IN-cargo AT ROW 11.88 COL 47.29 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-nombre AT ROW 10.88 COL 47.43 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-userid AT ROW 9.77 COL 47.43 COLON-ALIGNED WIDGET-ID 12
     btnCopiar AT ROW 20.81 COL 43 WIDGET-ID 10
     FILL-IN-seccion AT ROW 12.92 COL 47.29 COLON-ALIGNED WIDGET-ID 18
     RADIO-SET-picosesion AT ROW 14 COL 58 NO-LABEL WIDGET-ID 34
     "Pico y Session ?" VIEW-AS TEXT
          SIZE 12.29 BY .62 AT ROW 14.04 COL 44.43 WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 22.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Configuracion de PICO y SESSION"
         HEIGHT             = 22.04
         WIDTH              = 89.72
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-7 1 F-Main */
/* BROWSE-TAB BROWSE-10 BROWSE-7 F-Main */
ASSIGN 
       BROWSE-7:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-cargo IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-cargo:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-nombre:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-seccion IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-seccion:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-userid IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-userid:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-10
/* Query rebuild information for BROWSE BROWSE-10
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-L[1]
"tt-w-report.Campo-L[1]" "Sele" ? "logical" ? ? 6 ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Desde" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Hasta" ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-10 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH _user WHERE _user._disabled = NO BY _user._userid INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Configuracion de PICO y SESSION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Configuracion de PICO y SESSION */
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
    hQueryHandle:QUERY-PREPARE("FOR EACH _user NO-LOCK BY " + lColumName + " " + x-sort-direccion).    
    hQueryHandle:QUERY-OPEN().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON VALUE-CHANGED OF BROWSE-7 IN FRAME F-Main /* USUARIOS DEL SISTEMA */
DO:
   
    lUserId = _user._userid:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .
    FILL-in-userid:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lUserId.
    fill-in-nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = _user._user-name.

    FILL-in-cargo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FILL-in-seccion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".


    DEFINE VAR x-codper AS CHAR.
    DEFINE VAR x-year AS INT.
    DEFINE VAR x-mes AS INT.

    x-codper = _user._given_name.
    x-year = YEAR(TODAY).
    x-mes = MONTH(TODAY).

    FIND LAST pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia AND
                                pl-flg-mes.codper = x-codper AND
                                pl-flg-mes.periodo <= x-year AND
                                pl-flg-mes.nromes <= x-mes NO-LOCK NO-ERROR.
    IF AVAILABLE pl-flg-mes THEN DO:
        FILL-in-cargo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pl-flg-mes.cargos.
        FILL-in-seccion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pl-flg-mes.seccion.
    END.

    radio-set-picosesion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
    IF NOT (TRUE <> (_user._U-misc2[2] > "")) THEN DO:
        IF TRIM(_user._U-misc2[2]) = "SI" OR 
           TRIM(_user._U-misc2[2]) = "NO" THEN DO:
            radio-set-picosesion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(_user._U-misc2[2]).
        END.        
    END.


    /*
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
        txtNomPer:SCREEN-VALUE = trim(pl-pers.patper) + " " + 
                                    TRIM(pl-pers.matper) + " " +
                                    TRIM(pl-pers.nomper).
    END.

    radio-set-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PERSONAL".
    IF NOT (TRUE <> (_user._user-misc > "")) THEN DO:
        IF TRIM(_user._user-misc) = "generico" OR 
           TRIM( _user._user-misc) = "personalizado" THEN DO:
            radio-set-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                IF (TRIM(_user._user-misc) = "generico") THEN "GENERICO" ELSE "PERSONAL".
        END.        
    END.

    radio-set-picosesion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "SI".
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
    */

    SESSION:SET-WAIT-STATE("GENERAL").

    lUserId = _user._userid:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .

    FOR EACH tt-w-report:
        ASSIGN tt-w-report.campo-l[1] = NO.
        /*  */
        FIND FIRST usuario_horario WHERE usuario_horario.codcia = s-codcia AND
                                            usuario_horario.usuario = lUserId AND
                                            usuario_horario.diadelasemana = tt-w-report.campo-i[2] AND
                                            usuario_horario.correlativo = tt-w-report.campo-i[1] NO-LOCK NO-ERROR.
        IF AVAILABLE usuario_horario THEN ASSIGN tt-w-report.campo-l[1] = YES.
            .
    END.

    {&OPEN-QUERY-BROWSE-10}

    SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCopiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCopiar W-Win
ON CHOOSE OF btnCopiar IN FRAME F-Main /* Grabar horario del Usuario */
DO:
    /*
  ASSIGN txtNuevoUser txtNombre ChkCopiaAlmacen ChkCopiaDivision ChkActualizar ChkPassword
        ChkInhabilitar txtCodPer radio-set-tipo radio-set-picosesion combo-box-empresa.

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
    */

    MESSAGE 'Desea Copiar el horario al Usuario?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE("GENERAL").

    ASSIGN fill-in-userid radio-set-picosesion.

    /*lUserId = _user._userid:SCREEN-VALUE IN BROWSE {BROWSE-7} .*/

    FIND FIRST _user WHERE _user._userid = fill-in-userid EXCLUSIVE NO-ERROR.

    IF AVAILABLE _user THEN DO:
        ASSIGN _user._U-misc2[2] = radio-set-picosesion.
    END.

    RELEASE _user.
    

    FOR EACH tt-w-report:
        /*  */
        FIND FIRST usuario_horario WHERE usuario_horario.codcia = s-codcia AND
                                            usuario_horario.usuario = fill-in-userid AND
                                            usuario_horario.diadelasemana = tt-w-report.campo-i[2] AND
                                            usuario_horario.correlativo = tt-w-report.campo-i[1] EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE usuario_horario THEN DO:
            IF tt-w-report.campo-l[1] = NO THEN DO:
                DELETE usuario_horario.
            END.
        END.
        ELSE DO:
            IF tt-w-report.campo-l[1] = YES THEN DO:
                CREATE usuario_horario.
                ASSIGN usuario_horario.codcia = s-codcia
                        usuario_horario.usuario = fill-in-userid
                        usuario_horario.diadelasemana = tt-w-report.campo-i[2]
                        usuario_horario.correlativo = tt-w-report.campo-i[1]
                    .
            END.
        END.
            
        RELEASE usuario_horario.
    END.

    SESSION:SET-WAIT-STATE("").

END.

/*
    lUserId = _user._userid:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .

    FOR EACH tt-w-report:
        ASSIGN tt-w-report.campo-l[1] = NO.
        /*  */
        FIND FIRST usuario_horario WHERE usuario_horario.codcia = s-codcia AND
                                            usuario_horario.usuario = lUserId AND
                                            usuario_horario.diadelasemana = tt-w-report.campo-i[2] AND
                                            usuario_horario.correlativo = tt-w-report.campo-i[1] NO-LOCK NO-ERROR.
        IF AVAILABLE usuario_horario THEN ASSIGN tt-w-report.campo-l[1] = YES.
            .
    END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-10
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

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
  DISPLAY FILL-IN-cargo FILL-IN-nombre FILL-IN-userid FILL-IN-seccion 
          RADIO-SET-picosesion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-7 BROWSE-10 btnCopiar RADIO-SET-picosesion 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  FOR EACH horario WHERE horario.codcia = s-codcia AND
                        horario.diadelasemana = x-diadelasemana NO-LOCK:
      CREATE tt-w-report.
            ASSIGN tt-w-report.campo-c[1] = STRING(horario.hinicio,"99.99")
                    tt-w-report.campo-c[2] = STRING(horario.htermino,"99.99")
                    tt-w-report.campo-i[1] = horario.correlativo
                    tt-w-report.campo-i[2] = horario.diadelasemana
                    tt-w-report.campo-l[1] = NO
                .
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {&open-query-browse-10}

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
  {src/adm/template/snd-list.i "tt-w-report"}

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
    /*
    DEFINE VAR lRowId AS ROWID.

    DEF BUFFER b-_user FOR DICTDB._user.
    EMPTY TEMP-TABLE tt-_user.
    
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

    /* Eliminar sus modulos actuales al crear un nuevo usuario si es que ya existe */
    IF chkb-del-mod = YES THEN DO:
        FOR EACH b-pf-g004 WHERE b-pf-g004.codcia = pf-g004.codcia AND 
                                b-pf-g004.USER-ID = txtNuevoUser :
            DELETE b-pf-g004.
        END.
    END.

    /* Los Modulos para el nuevo usuario  */        
    GET FIRST {&BROWSE-MOD} .
    DO  WHILE AVAILABLE pf-g004:
        IF pf-g004.seguridad <> ? AND pf-g004.seguridad <> "" THEN DO:
            IF pf-g004.aplic-id <> ? AND pf-g004.aplic-id <> "" THEN DO:
                FIND FIRST b-pf-g004 WHERE b-pf-g004.codcia = pf-g004.codcia AND 
                    b-pf-g004.USER-ID = txtNuevoUser AND b-pf-g004.aplic-id = pf-g004.aplic-id
                    EXCLUSIVE NO-ERROR.
                IF NOT AVAILABLE b-pf-g004 THEN DO:
                    CREATE b-pf-g004.
                END.                
                    ASSIGN b-pf-g004.codcia = pf-g004.codcia
                        b-pf-g004.USER-ID   = txtNuevoUser
                        b-pf-g004.aplic-id  = pf-g004.aplic-id
                        b-pf-g004.admin     = pf-g004.admin
                        b-pf-g004.seguridad = pf-g004.seguridad.
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
    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cargo-seccion W-Win 
FUNCTION cargo-seccion RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-cargo AS CHAR.
    DEFINE VAR x-seccion AS CHAR.

    DEFINE VAR x-retval AS CHAR INIT "|".

    DEFINE VAR x-codper AS CHAR.
    DEFINE VAR x-year AS INT.
    DEFINE VAR x-mes AS INT.

    x-codper = pCodPer.
    x-year = YEAR(TODAY).
    x-mes = MONTH(TODAY).

    FIND LAST pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia AND
                                pl-flg-mes.codper = x-codper AND
                                pl-flg-mes.periodo <= x-year AND
                                pl-flg-mes.nromes <= x-mes NO-LOCK NO-ERROR.
    IF AVAILABLE pl-flg-mes THEN DO:
        x-cargo = TRIM(pl-flg-mes.cargos).
        x-seccion = TRIM(pl-flg-mes.seccion).

        x-retval = x-cargo + "|" + x-seccion.
    END.


    RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

