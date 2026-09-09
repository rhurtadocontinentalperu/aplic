&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cb-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE CMB-Profesion AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-Titulo    AS CHARACTER NO-UNDO.

DEF VAR x-TpoDocId LIKE PL-PERS.TpodocId NO-UNDO.
DEF VAR x-TipoVia LIKE PL-PERS.TipoVia NO-UNDO.
DEF VAR x-TipoZona LIKE PL-PERS.TipoZona NO-UNDO.

DEFINE BUFFER B-PERS FOR PL-PERS.
DEFINE BUFFER B-CIAS FOR PF-CIAS.

/* VARIABLE PARA MIGRAR A CONTABILIDAD */
DEF VAR x-ClfAux LIKE cb-auxi.clfaux INIT 'PE' NO-UNDO.
DEF VAR x-CodAux LIKE cb-auxi.codaux NO-UNDO.
DEF VAR x-NomAux LIKE cb-auxi.nomaux NO-UNDO.

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Fotocheck".
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE TEMP-TABLE ttImage NO-UNDO
    FIELD bImage AS BLOB.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PERS
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PERS


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PERS.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-PERS.CodCia ~
INTEGRAL.PL-PERS.patper INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper ~
INTEGRAL.PL-PERS.fecnac INTEGRAL.PL-PERS.sexper INTEGRAL.PL-PERS.NroDocId ~
INTEGRAL.PL-PERS.CodNac INTEGRAL.PL-PERS.E-Mail INTEGRAL.PL-PERS.telefo ~
INTEGRAL.PL-PERS.lmilit INTEGRAL.PL-PERS.Essalud INTEGRAL.PL-PERS.Domici ~
INTEGRAL.PL-PERS.dirper INTEGRAL.PL-PERS.DirNumero ~
INTEGRAL.PL-PERS.DirInterior INTEGRAL.PL-PERS.NomZona ~
INTEGRAL.PL-PERS.DirReferen INTEGRAL.PL-PERS.Ubigeo INTEGRAL.PL-PERS.titulo ~
INTEGRAL.PL-PERS.distri INTEGRAL.PL-PERS.profesion INTEGRAL.PL-PERS.ctipss 
&Scoped-define ENABLED-TABLES INTEGRAL.PL-PERS
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-PERS
&Scoped-Define ENABLED-OBJECTS IMAGE-1 RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-PERS.codper ~
INTEGRAL.PL-PERS.CodCia INTEGRAL.PL-PERS.patper INTEGRAL.PL-PERS.matper ~
INTEGRAL.PL-PERS.nomper INTEGRAL.PL-PERS.fecnac INTEGRAL.PL-PERS.sexper ~
INTEGRAL.PL-PERS.NroDocId INTEGRAL.PL-PERS.CodNac INTEGRAL.PL-PERS.E-Mail ~
INTEGRAL.PL-PERS.telefo INTEGRAL.PL-PERS.lmilit INTEGRAL.PL-PERS.Essalud ~
INTEGRAL.PL-PERS.Domici INTEGRAL.PL-PERS.dirper INTEGRAL.PL-PERS.DirNumero ~
INTEGRAL.PL-PERS.DirInterior INTEGRAL.PL-PERS.NomZona ~
INTEGRAL.PL-PERS.DirReferen INTEGRAL.PL-PERS.Ubigeo INTEGRAL.PL-PERS.titulo ~
INTEGRAL.PL-PERS.distri INTEGRAL.PL-PERS.profesion INTEGRAL.PL-PERS.ctipss 
&Scoped-define DISPLAYED-TABLES INTEGRAL.PL-PERS
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.PL-PERS
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchCes FILL-IN-FchIng ~
FILL-IN-NomCia COMBO-BOX_TpoDocId FILL-IN-nacion COMBO-BOX_TipoVia ~
COMBO-BOX_TipoZona FILL-IN-region FILL-IN-provincia FILL-IN-distrito 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-loadimg 
     LABEL "Cargar foto..." 
     SIZE 15 BY .81.

DEFINE VARIABLE COMBO-BOX_TipoVia AS CHARACTER FORMAT "x(255)" 
     LABEL "Dirección" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18.43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_TipoZona AS CHARACTER FORMAT "x(255)" 
     LABEL "Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18.43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_TpoDocId AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Doc" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29.86 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-distrito AS CHARACTER FORMAT "X(256)":U 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchCes AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Cese" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIng AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Ingreso" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-provincia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Provincia" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-region AS CHARACTER FORMAT "X(256)":U 
     LABEL "Región" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE IMAGE IMAGE-1
     SIZE 20.43 BY 6.54.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 7.12.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 5.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchCes AT ROW 12.73 COL 14 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchIng AT ROW 11.96 COL 14 COLON-ALIGNED WIDGET-ID 6
     BUTTON-loadimg AT ROW 8.27 COL 70 WIDGET-ID 4
     INTEGRAL.PL-PERS.codper AT ROW 1.77 COL 11 COLON-ALIGNED FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     INTEGRAL.PL-PERS.CodCia AT ROW 1.77 COL 27 COLON-ALIGNED
          LABEL "Compañia"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     FILL-IN-NomCia AT ROW 1.77 COL 32 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-PERS.patper AT ROW 2.73 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.matper AT ROW 3.54 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.nomper AT ROW 4.35 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.fecnac AT ROW 2.73 COL 51 COLON-ALIGNED
          LABEL "Fecha Nac"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.PL-PERS.sexper AT ROW 3.69 COL 53.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Masculino", "1":U,
"Femenino", "2":U
          SIZE 10 BY 1.35
     COMBO-BOX_TpoDocId AT ROW 5.15 COL 11 COLON-ALIGNED
     INTEGRAL.PL-PERS.NroDocId AT ROW 5.15 COL 49 COLON-ALIGNED
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     INTEGRAL.PL-PERS.CodNac AT ROW 5.96 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-nacion AT ROW 5.96 COL 16 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-PERS.E-Mail AT ROW 6.77 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     INTEGRAL.PL-PERS.telefo AT ROW 5.96 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.PL-PERS.lmilit AT ROW 6.77 COL 52 COLON-ALIGNED
          LABEL "Cel"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.PL-PERS.Essalud AT ROW 7.58 COL 38 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-PERS.Domici AT ROW 8.88 COL 13 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "2":U
          SIZE 10 BY .77
     COMBO-BOX_TipoVia AT ROW 9.65 COL 10.57 COLON-ALIGNED
     INTEGRAL.PL-PERS.dirper AT ROW 9.65 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.DirNumero AT ROW 9.65 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     INTEGRAL.PL-PERS.DirInterior AT ROW 9.65 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     COMBO-BOX_TipoZona AT ROW 10.46 COL 10.57 COLON-ALIGNED
     INTEGRAL.PL-PERS.NomZona AT ROW 10.46 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.PL-PERS.DirReferen AT ROW 10.46 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.Ubigeo AT ROW 11.27 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-region AT ROW 11.27 COL 54 COLON-ALIGNED
     FILL-IN-provincia AT ROW 12.08 COL 54 COLON-ALIGNED
     FILL-IN-distrito AT ROW 12.88 COL 54 COLON-ALIGNED
     INTEGRAL.PL-PERS.titulo AT ROW 14.08 COL 12 COLON-ALIGNED
          LABEL "Título" FORMAT "X(20)"
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 29.57 BY 1
     INTEGRAL.PL-PERS.distri AT ROW 14.08 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.profesion AT ROW 15.04 COL 12 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 27.72 BY 1
     INTEGRAL.PL-PERS.ctipss AT ROW 15.04 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     " Domicilio" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 8.5 COL 5
          BGCOLOR 1 FGCOLOR 15 
     " Datos Generales" VIEW-AS TEXT
          SIZE 12.14 BY .5 AT ROW 1.19 COL 5
          BGCOLOR 1 FGCOLOR 15 
     "Sexo:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 4 COL 48.72
     "Domiciliado:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 9.08 COL 4
     "ESSALUD + Vida:" VIEW-AS TEXT
          SIZE 12.86 BY .5 AT ROW 7.65 COL 25
     IMAGE-1 AT ROW 1.58 COL 67
     RECT-1 AT ROW 1.38 COL 2
     RECT-2 AT ROW 8.69 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-PERS
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 15.15
         WIDTH              = 87.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-loadimg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.CodCia IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.codper IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_TipoVia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_TipoZona IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_TpoDocId IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.fecnac IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-distrito IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchCes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchIng IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-provincia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-region IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.lmilit IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.NroDocId IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX INTEGRAL.PL-PERS.titulo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-loadimg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-loadimg V-table-Win
ON CHOOSE OF BUTTON-loadimg IN FRAME F-Main /* Cargar foto... */
DO:

    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE cFile
        FILTERS "JPG" "*.jpg", "BMP" "*.bmp", "Todos" "*"
        UPDATE lOk.

    IF lOk <> TRUE THEN RETURN NO-APPLY.

    IMAGE-1:LOAD-IMAGE(cFile).

    FIND FIRST ttImage NO-ERROR.
    IF NOT AVAILABLE ttImage THEN CREATE ttImage.

    COPY-LOB FROM FILE cFile TO ttImage.bImage.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-PERS.CodCia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.CodCia V-table-Win
ON LEAVE OF INTEGRAL.PL-PERS.CodCia IN FRAME F-Main /* Compañia */
DO:
    FIND FIRST B-CIAS WHERE
        B-CIAS.CodCia = INPUT PL-PERS.CodCia
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CIAS THEN DO:
        MESSAGE
            'Compañíia no existe ' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO PL-PERS.Codcia.
        RETURN NO-APPLY.
    END.
    ASSIGN FILL-IN-NomCia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = B-CIAS.NomCia.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-PERS.CodNac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.CodNac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-PERS.CodNac IN FRAME F-Main /* Nacionalidad */
OR F8 OF PL-PERS.CodNac DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "04"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Nacionalidad").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ INTEGRAL.PL-PERS.CodNac
                pl-tabl.Nombre @ FILL-IN-nacion
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-PERS.codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.codper V-table-Win
ON LEAVE OF INTEGRAL.PL-PERS.codper IN FRAME F-Main /* Código */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        BELL.
        MESSAGE "Ingrese c¢digo de personal"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CAN-FIND(FIRST integral.PL-PERS WHERE
        integral.PL-PERS.CodPer = SELF:SCREEN-VALUE) THEN DO:
        BELL.
        MESSAGE "C¢digo de personal ya existe"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.PL-PERS.CodPer.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-PERS.profesion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.profesion V-table-Win
ON ENTRY OF INTEGRAL.PL-PERS.profesion IN FRAME F-Main /* Profesión */
DO:
    ASSIGN CMB-Profesion = "".
    FOR EACH integral.PL-PROF NO-LOCK:
        ASSIGN CMB-Profesion = CMB-Profesion + "," + integral.PL-PROF.Profesion.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-Profesion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-PERS.titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.titulo V-table-Win
ON ENTRY OF INTEGRAL.PL-PERS.titulo IN FRAME F-Main /* Título */
DO:
    ASSIGN CMB-Titulo = "".
    FOR EACH integral.PL-TITU NO-LOCK:
        ASSIGN CMB-Titulo = CMB-Titulo + "," + integral.PL-TITU.titulo.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-Titulo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-PERS.Ubigeo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.Ubigeo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-PERS.Ubigeo IN FRAME F-Main /* Ubigeo */
OR F8 OF PL-PERS.Ubigeo DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = SELF:SCREEN-VALUE
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        output-var-2 = ""
        output-var-3 = ""
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-UBIGEO.r.
        IF OUTPUT-VAR-2 <> "" THEN DO:
            PL-PERS.Ubigeo:SCREEN-VALUE = OUTPUT-VAR-2.
            FILL-IN-region = TRIM(ENTRY(1,OUTPUT-VAR-3)).
            FILL-IN-provincia = TRIM(ENTRY(2,OUTPUT-VAR-3)).
            FILL-IN-distrito = TRIM(ENTRY(3,OUTPUT-VAR-3)).
            DISPLAY
                FILL-IN-region
                FILL-IN-provincia
                FILL-IN-distrito
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    RUN _inicia-lista.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "integral.PL-PERS"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PERS"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Barras V-table-Win 
PROCEDURE Barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).
 * 
 * IF LOOKUP("Barras", s-printer-list) = 0 THEN DO:
 *    MESSAGE "Impresora " "Barras"" no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *    RETURN ERROR.
 * END.
 * 
 * s-port-name = ENTRY(LOOKUP("Barras", s-printer-list), s-port-list).
 * s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

/*RUN lib/_port-name (INPUT 'Barras',
 *                     OUTPUT s-port-name).
 * IF s-port-name = '' THEN RETURN.
 * 
 * OUTPUT TO VALUE(s-port-name) .*/

DEF VAR Rpta AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta.
IF Rpta = NO THEN RETURN.
OUTPUT TO PRINTER.

put control chr(27) + '^XA^LH000,012'.  /*&& Inicio de formato*/
put control chr(27) + '^FO155,00'.  /*&& Coordenadas de origen campo1  DESPRO1*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + TRIM(Pl-pers.PatPer) + " " + TRIM(Pl-Pers.MatPer) .
put control chr(27) + '^FS'.  /*&& Fin de Campo1*/
put control chr(27) + '^FO130,00'.  /*&& Coordenadas de origen campo2  DESPRO2*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + TRIM(Pl-pers.NomPer).
put control chr(27) + '^FS'.  /*&& Fin de Campo2*/
put control chr(27) + '^FO55,30'.  /*&& Coordenadas de origen barras  CODPRO*/
put control chr(27) + '^BCR,80'.  
put control chr(27) + '^FD' + Pl-pers.CodPer.
put control chr(27) + '^FS'. 
 
put control chr(27) + '^LH210,012'.  /*&& Inicio de formato*/
put control chr(27) + '^FO155,00'.  /*&& Coordenadas de origen campo1  DESPRO1*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + TRIM(Pl-pers.PatPer) + " " + TRIM(Pl-Pers.MatPer) .
put control chr(27) + '^FS'.  
put control chr(27) + '^FO130,00'.  
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + TRIM(Pl-pers.NomPer).
put control chr(27) + '^FS'.  
put control chr(27) + '^FO55,30'.  
put control chr(27) + '^BCR,80'.  
put control chr(27) + '^FD' + Pl-pers.CodPer.
put control chr(27) + '^FS'. 

put control chr(27) + '^LH420,12'. 
put control chr(27) + '^FO155,00'. 
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + TRIM(Pl-pers.PatPer) + " " + TRIM(Pl-Pers.MatPer) .
put control chr(27) + '^FS'.
put control chr(27) + '^FO130,00'. 
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + TRIM(Pl-pers.NomPer).
put control chr(27) + '^FS'.
put control chr(27) + '^FO55,30'.
put control chr(27) + '^BY2'.  
put control chr(27) + '^BCR,80'.  
put control chr(27) + '^FD' + Pl-pers.CodPer.
put control chr(27) + '^FS'.  


put control chr(27) + '^LH630,012'.  
put control chr(27) + '^FO155,00'.  
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + TRIM(Pl-pers.PatPer) + " " + TRIM(Pl-Pers.MatPer) .
put control chr(27) + '^FS'.  
put control chr(27) + '^FO130,00'.  
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + TRIM(Pl-pers.NomPer).
put control chr(27) + '^FS'.  
put control chr(27) + '^FO55,30'.  
put control chr(27) + '^BY2'.  
put control chr(27) + '^BCR,80'.  
put control chr(27) + '^FD' + Pl-pers.CodPer.
put control chr(27)  + '^FS'.  




put control chr(27) + '^PQ' + string(1,"x(9)"). /*&&Cantidad a imprimir*/
put control chr(27) + '^PR' + '2'.   /*&&Velocidad de impresion Pulg/seg*/
put control chr(27) + '^XZ'.  /*&& Fin de formato*/

output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fotocheck V-table-Win 
PROCEDURE Fotocheck :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR S-NOMDIV AS CHAR.
    DEFINE VAR S-CARGO  AS CHAR.
    DEFINE VAR S-CODDIV AS CHAR.

    FIND LAST PL-FLG-MES WHERE
        Pl-FLG-MES.Codcia = PL-PERS.Codcia AND
        Pl-FLG-MES.CodPer = PL-PERS.CodPer
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-FLG-MES THEN DO:
        S-CODDIV = PL-FLG-MES.CodDiv.
        S-CARGO  = PL-FLG-MES.Cargos.
        FIND Gn-Divi WHERE
            Gn-Divi.Codcia = PL-FLG-MES.Codcia AND
            GN-Divi.CodDiv = PL-FLG-MES.CodDiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Divi THEN S-NOMDIV = Gn-Divi.DesDiv.
    END.
    ELSE DO:
        FIND LAST PL-FLG-SEM WHERE
            PL-FLG-SEM.CodCia = PL-PERS.CodCia AND
            PL-FLG-SEM.CodPer = PL-PERS.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-SEM THEN DO:
            S-CODDIV = PL-FLG-SEM.CodDiv.
            S-CARGO  = PL-FLG-SEM.Cargos.
            FIND Gn-Divi WHERE
                Gn-Divi.Codcia = PL-FLG-SEM.Codcia AND
                GN-Divi.CodDiv = PL-FLG-SEM.CodDiv
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-Divi THEN S-NOMDIV = Gn-Divi.DesDiv.                    
        END.
    END.

/*
 /* LOGICA PRINCIPAL */
  /* Pantalla general de parametros de impresion */
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.

  /* test de impresion */
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "Pl-pers.CodCia = " + STRING(Pl-pers.Codcia) +
              " AND Pl-pers.CodPer = '" + Pl-Pers.CodPer + "'".  
  
  RB-OTHER-PARAMETERS = "s-cargo = " + s-cargo +
                        "~ns-coddiv = " + s-coddiv +
                        "~ns-nomdiv = " + s-nomdiv .

  /* Captura parametros de impresion */
  ASSIGN
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  
/* RHC 13.01.05 prueba de nuevo fotocheck */
/*IF s-user-id = 'ADMIN'
 * THEN RB-REPORT-NAME = "Fotocheck-2".*/

RB-REPORT-NAME = "Fotocheck-2".     /* NUEVO FOTOCHECK */

  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS).    
*/    

    GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "pln\reporte\mes\formatos.prl"
        RB-REPORT-NAME = "Fotocheck-2"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "Pl-pers.CodCia = " + STRING(Pl-pers.Codcia) +
            " AND Pl-pers.CodPer = '" + Pl-Pers.CodPer + "'"
        RB-OTHER-PARAMETERS =
            "s-cargo = " + s-cargo +
            "~ns-coddiv = " + s-coddiv +
            "~ns-nomdiv = " + s-nomdiv.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND LAST B-Pers NO-LOCK NO-ERROR.
  IF AVAILABLE B-Pers THEN DO:
      ASSIGN 
          PL-PERS.codper:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(INTEGER(B-Pers.CodPer) + 1, '999999').
  END.
  DO WITH FRAME {&FRAME-NAME}:
      IMAGE-1:LOAD-IMAGE("c:\dlc\gui\adeicon\blank.bmp").
      IMAGE-1:SCREEN-VALUE = "c:\dlc\gui\adeicon\blank.bmp".
      DISPLAY IMAGE-1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute ('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND LAST B-Pers WHERE B-Pers.CodPer <> "" EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE B-Pers THEN DO:
          IF LOCKED(B-Pers) THEN DO:
              RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
              UNDO, RETURN "ADM-ERROR".
          END.
          x-CodAux = '000001'.
      END.
      x-CodAux = STRING(INTEGER(B-Pers.CodPer) + 1, '999999').
  END.
  ELSE x-CodAux = PL-PERS.CodPer.
  ASSIGN
      PL-PERS.CodPer = x-CodAux
      x-NomAux = TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + TRIM(PL-PERS.nomper).
  FIND CB-AUXI WHERE cb-auxi.codcia = cb-codcia
      AND cb-auxi.clfaux = x-clfaux
      AND cb-auxi.codaux = x-codaux
      EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE CB-AUXI THEN CREATE CB-AUXI.
  ASSIGN
      CB-AUXI.codcia = cb-codcia
      CB-AUXI.clfaux = x-clfaux
      CB-AUXI.codaux = x-codaux
      CB-AUXI.nomaux = x-nomaux.
  /* ****************** */
  ASSIGN FRAME {&FRAME-NAME}
      COMBO-BOX_TpoDocId
      COMBO-BOX_TipoVia
      COMBO-BOX_TipoZona.
  ASSIGN
      PL-PERS.TpoDocId = ENTRY(LOOKUP(COMBO-BOX_TpoDocId, COMBO-BOX_TpoDocId:LIST-ITEMS IN FRAME {&FRAME-NAME}), x-TpoDocId)
      PL-PERS.TipoVia  = ENTRY(LOOKUP(COMBO-BOX_TipoVia, COMBO-BOX_TipoVia:LIST-ITEMS IN FRAME {&FRAME-NAME}), x-TipoVia)
      PL-PERS.TipoZona = ENTRY(LOOKUP(COMBO-BOX_TipoZona, COMBO-BOX_TipoZona:LIST-ITEMS IN FRAME {&FRAME-NAME}), x-TipoZona).
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' AND PL-PERS.TpoDocId = '01' THEN DO:        /* DNI */
      /* Validacion en la lista negra */
      FIND pl-negra WHERE pl-negra.DocIdentidad = PL-PERS.NroDocId NO-LOCK NO-ERROR.
      IF AVAILABLE pl-negra THEN DO:
          MESSAGE 'Esta persona se encuentra registrada en la LISTA NEGRA' SKIP
              'Grabación rechazada'
              VIEW-AS ALERT-BOX WARNING.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* Búsqueda en la lista negra por apellidos y nombres */
      FIND FIRST pl-negra WHERE pl-negra.patper = pl-pers.patper 
          AND pl-negra.matper = pl-pers.matper 
          AND pl-negra.nomper = pl-pers.nomper 
          NO-LOCK NO-ERROR.
      IF AVAILABLE pl-negra THEN DO:
          MESSAGE 'Esta persona se encuentra registrada en la LISTA NEGRA' SKIP
              'Grabación rechazada'
              VIEW-AS ALERT-BOX WARNING.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  IF AVAILABLE(B-Pers) THEN RELEASE B-Pers.
  IF AVAILABLE(cb-auxi) THEN RELEASE cb-auxi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        COMBO-BOX_TpoDocId:SENSITIVE IN FRAME F-Main = FALSE
        COMBO-BOX_TipoVia:SENSITIVE IN FRAME F-Main = FALSE
        COMBO-BOX_TipoZona:SENSITIVE IN FRAME F-Main = FALSE
        PL-PERS.codper:SENSITIVE IN FRAME F-Main = FALSE
        BUTTON-loadimg:SENSITIVE IN FRAME F-Main = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN integral.PL-PERS.codper:SENSITIVE IN FRAME F-Main = TRUE.
    APPLY "ENTRY" TO integral.PL-PERS.codper.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    IF CAN-FIND(FIRST PL-FLG-MES WHERE PL-FLG-MES.CodPer = PL-PERS.CodPer) THEN DO:
        BELL.
        MESSAGE "No puede eliminar este personal" SKIP
            "porque presenta movimientos" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    IF CAN-FIND(FIRST PL-FLG-SEM WHERE PL-FLG-SEM.CodPer = PL-PERS.CodPer) THEN DO:
        BELL.
        MESSAGE "No puede eliminar este personal" SKIP
            "porque presenta movimientos" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE PL-PERS
  THEN DO WITH FRAME {&FRAME-NAME}:
    IF PL-PERS.Titulo = "" THEN PL-PERS.Titulo:SCREEN-VALUE = " ".
    IF PL-PERS.Profesion = "" THEN Pl-PERS.Profesion:SCREEN-VALUE = " ".
    FIND FIRST B-CIAS WHERE B-CIAS.Codcia = INTEGER(PL-PERS.CodCia:SCREEN-VALUE) NO-ERROR.
    IF AVAILABLE B-Cias 
    THEN FILL-IN-NomCia:SCREEN-VALUE = B-Cias.Nomcia.
    ELSE FILL-IN-NomCia:SCREEN-VALUE = ' '.

    FIND pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '04' AND
        pl-tabla.codigo = pl-pers.CodNac NO-LOCK NO-ERROR.
    IF AVAILABLE pl-tabla THEN FILL-IN-Nacion:SCREEN-VALUE = pl-tabla.nombre.
    ELSE FILL-IN-Nacion:SCREEN-VALUE = ' '.

    IF SEARCH(PL-PERS.Codbar) <> ? THEN
        IMAGE-1:LOAD-IMAGE(PL-PERS.Codbar).
    ELSE
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").

    ASSIGN
        COMBO-BOX_TpoDocId:SCREEN-VALUE = ENTRY(LOOKUP(PL-PERS.TpoDocId, x-TpoDocId), COMBO-BOX_TpoDocId:LIST-ITEMS)
        COMBO-BOX_TipoVia:SCREEN-VALUE = ENTRY(LOOKUP(PL-PERS.TipoVia, x-TipoVia), COMBO-BOX_TipoVia:LIST-ITEMS)
        COMBO-BOX_TipoZona:SCREEN-VALUE = ENTRY(LOOKUP(PL-PERS.TipoZona, x-TipoZona), COMBO-BOX_TipoZona:LIST-ITEMS).

    /* Region */
    FIND TabDepto WHERE
        TabDepto.CodDepto = SUBSTRING(PL-PERS.ubigeo:SCREEN-VALUE,1,2)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDepto THEN FILL-IN-region = "".
    ELSE FILL-IN-region = TabDepto.NomDepto.

    /* Provincia */
    FIND TabProvi WHERE
        TabProvi.CodDepto = SUBSTRING(PL-PERS.ubigeo:SCREEN-VALUE,1,2) AND
        TabProvi.CodProvi = SUBSTRING(PL-PERS.ubigeo:SCREEN-VALUE,3,2)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabProvi THEN FILL-IN-provincia = "".
    ELSE FILL-IN-provincia = TabProvi.NomProvi.

    /* Distrito */
    FIND TabDistr WHERE
        TabDistr.CodDepto = SUBSTRING(PL-PERS.ubigeo:SCREEN-VALUE,1,2) AND
        TabDistr.CodProvi = SUBSTRING(PL-PERS.ubigeo:SCREEN-VALUE,3,2) AND
        TabDistr.CodDistr = SUBSTRING(PL-PERS.ubigeo:SCREEN-VALUE,5,2)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr THEN FILL-IN-distrito = "".
    ELSE FILL-IN-distrito = TabDistr.NomDistr.

    DISPLAY FILL-IN-region FILL-IN-provincia FILL-IN-distrito.

    /* Fecha de ingreso y cese */
    ASSIGN
        FILL-IN-FchCes = ?
        FILL-IN-FchIng = ?.
    FIND LAST pl-flg-mes USE-INDEX IDX02 WHERE pl-flg-mes.codcia = s-codcia
        AND pl-flg-mes.codper = pl-pers.codper
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-flg-mes THEN
        ASSIGN
        FILL-IN-FchIng = pl-flg-mes.fecing
        FILL-IN-FchCes = pl-flg-mes.vcontr.
    DISPLAY FILL-IN-FchCes FILL-IN-FchIng.


/* Posteriormente ***
    IF pl-pers.foto <> ? THEN DO:
        ASSIGN
            cFile = SESSION:TEMP-DIRECTORY + "\" +
            pl-pers.codper:SCREEN-VALUE + ".jpg".
        COPY-LOB pl-pers.foto TO FILE cFile.
    END.
    ELSE cFile = "adeicon\blank.bmp".
    IMAGE-1:LOAD-IMAGE(cFile).
    OS-DELETE cFile.
* ***/

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    COMBO-BOX_TpoDocId:SENSITIVE IN FRAME F-Main = TRUE
    COMBO-BOX_TipoVia:SENSITIVE IN FRAME F-Main = TRUE
    COMBO-BOX_TipoZona:SENSITIVE IN FRAME F-Main = TRUE
    PL-PERS.codper:SENSITIVE IN FRAME F-Main = FALSE
    BUTTON-loadimg:SENSITIVE IN FRAME F-Main = TRUE.

/* Posteriormente *
    FIND FIRST ttImage NO-ERROR.
    IF NOT AVAILABLE ttImage THEN CREATE ttImage.
    ELSE ttImage.bImage = ?.
    IF AVAILABLE pl-pers THEN ttImage.bImage = pl-pers.foto.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    DO WITH FRAME {&FRAME-NAME}:
        BUTTON-loadimg:VISIBLE = FALSE.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Valida.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        COMBO-BOX_TpoDocId:SENSITIVE IN FRAME F-Main = FALSE
        COMBO-BOX_TipoVia:SENSITIVE IN FRAME F-Main = FALSE
        COMBO-BOX_TipoZona:SENSITIVE IN FRAME F-Main = FALSE
        BUTTON-loadimg:SENSITIVE IN FRAME F-Main = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida V-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        FIND FIRST B-PERS WHERE B-PERS.patper = PL-PERS.patper:SCREEN-VALUE
            AND B-PERS.matper = PL-PERS.matper:SCREEN-VALUE
            AND B-PERS.nomper = PL-PERS.nomper:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-PERS THEN DO:
            MESSAGE 'YA existe una persona registrada con el mismo nombre' SKIP
                'Codigo:' B-PERS.codper SKIP
                'Apellidos' B-PERS.patper B-PERS.matper SKIP
                'Nombres:' B-PERS.nomper SKIP
                '# Doc. Identidad:' B-PERS.NroDocId SKIP
                'Continuamos con la grabación?'
                VIEW-AS ALERT-BOX question BUTTONS YES-NO
                UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN 'ADM-ERROR'.
        END.
        IF PL-PERS.NroDocId:SCREEN-VALUE <> '' THEN DO:
            FIND FIRST B-PERS WHERE B-PERS.nrodocid = PL-PERS.NroDocId:SCREEN-VALUE
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-PERS THEN DO:
                MESSAGE 'YA existe una persona registrada con el mismo documento de identidad' SKIP
                    'Codigo:' B-PERS.codper SKIP
                    'Apellidos' B-PERS.patper B-PERS.matper SKIP
                    'Nombres:' B-PERS.nomper SKIP
                    '# Doc. Identidad:' B-PERS.NroDocId SKIP
                    'Continuamos con la grabación?'
                    VIEW-AS ALERT-BOX question BUTTONS YES-NO
                    UPDATE rpta2 AS LOG.
                IF rpta2 = NO THEN RETURN 'ADM-ERROR'.
            END.
        END.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _inicia-lista V-table-Win 
PROCEDURE _inicia-lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Titulos */
    ASSIGN CMB-titulo = "".
    FOR EACH integral.PL-TITU NO-LOCK:
        ASSIGN CMB-titulo = CMB-titulo + "," + integral.PL-TITU.Titulo.
    END.
    ASSIGN integral.PL-PERS.Titulo:LIST-ITEMS IN FRAME F-Main = CMB-titulo.

    /* Profesiones */
    ASSIGN CMB-Profesion = "".
    FOR EACH integral.PL-PROF NO-LOCK:
        ASSIGN CMB-Profesion = CMB-Profesion + "," + integral.PL-PROF.Profesion.
    END.
    ASSIGN integral.PL-PERS.Profesion:LIST-ITEMS IN FRAME F-Main = CMB-Profesion.

    DO WITH FRAME {&FRAME-NAME}:
        /* Documento de Identidad */
        FOR EACH PL-TABLA WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '03' NO-LOCK:
            COMBO-BOX_TpoDocId:ADD-LAST(pl-tabla.nombre).
            IF x-TpoDocId = '' THEN x-TpoDocId = pl-tabla.codigo.
            ELSE x-TpoDocId = x-TpoDocId + ',' + pl-tabla.codigo.
        END.
        /* Tipo de Via */
        FOR EACH PL-TABLA WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '05' NO-LOCK:
            COMBO-BOX_TipoVia:ADD-LAST(pl-tabla.nombre).
            IF x-TipoVia = '' THEN x-TipoVia = pl-tabla.codigo.
            ELSE x-TipoVia = x-TipoVia + ',' + pl-tabla.codigo.
        END.
        /* Tipo de Zona */
        FOR EACH PL-TABLA WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '06' NO-LOCK:
            COMBO-BOX_TipoZona:ADD-LAST(pl-tabla.nombre).
            IF x-TipoZona = '' THEN x-TipoZona = pl-tabla.codigo.
            ELSE x-TipoZona = x-TipoZona + ',' + pl-tabla.codigo.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

