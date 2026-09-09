&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE CMB-Profesion AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-Titulo    AS CHARACTER NO-UNDO.

DEF VAR x-TipoVia LIKE PL-PERS.TipoVia.
DEF VAR x-TipoZona LIKE PL-PERS.TipoZona.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PERS
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PERS


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PERS.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-PERS.DirNumero ~
INTEGRAL.PL-PERS.CodCia INTEGRAL.PL-PERS.DirInterior ~
INTEGRAL.PL-PERS.codper INTEGRAL.PL-PERS.sexper INTEGRAL.PL-PERS.patper ~
INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper INTEGRAL.PL-PERS.lmilit ~
INTEGRAL.PL-PERS.lelect INTEGRAL.PL-PERS.ctipss INTEGRAL.PL-PERS.fecnac ~
INTEGRAL.PL-PERS.dirper INTEGRAL.PL-PERS.localidad INTEGRAL.PL-PERS.distri ~
INTEGRAL.PL-PERS.telefo INTEGRAL.PL-PERS.provin INTEGRAL.PL-PERS.nacion ~
INTEGRAL.PL-PERS.titulo INTEGRAL.PL-PERS.profesion 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}DirNumero ~{&FP2}DirNumero ~{&FP3}~
 ~{&FP1}CodCia ~{&FP2}CodCia ~{&FP3}~
 ~{&FP1}DirInterior ~{&FP2}DirInterior ~{&FP3}~
 ~{&FP1}codper ~{&FP2}codper ~{&FP3}~
 ~{&FP1}patper ~{&FP2}patper ~{&FP3}~
 ~{&FP1}matper ~{&FP2}matper ~{&FP3}~
 ~{&FP1}nomper ~{&FP2}nomper ~{&FP3}~
 ~{&FP1}lmilit ~{&FP2}lmilit ~{&FP3}~
 ~{&FP1}lelect ~{&FP2}lelect ~{&FP3}~
 ~{&FP1}ctipss ~{&FP2}ctipss ~{&FP3}~
 ~{&FP1}fecnac ~{&FP2}fecnac ~{&FP3}~
 ~{&FP1}dirper ~{&FP2}dirper ~{&FP3}~
 ~{&FP1}localidad ~{&FP2}localidad ~{&FP3}~
 ~{&FP1}distri ~{&FP2}distri ~{&FP3}~
 ~{&FP1}telefo ~{&FP2}telefo ~{&FP3}~
 ~{&FP1}provin ~{&FP2}provin ~{&FP3}~
 ~{&FP1}nacion ~{&FP2}nacion ~{&FP3}
&Scoped-define ENABLED-TABLES INTEGRAL.PL-PERS
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-PERS
&Scoped-Define ENABLED-OBJECTS IMAGE-1 RECT-14 RECT-16 RECT-17 RECT-18 ~
RECT-19 RECT-20 RECT-21 RECT-22 RECT-23 RECT-24 RECT-25 RECT-26 RECT-27 ~
RECT-28 RECT-29 RECT-30 RECT-31 RECT-32 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-PERS.DirNumero ~
INTEGRAL.PL-PERS.CodCia INTEGRAL.PL-PERS.DirInterior ~
INTEGRAL.PL-PERS.codper INTEGRAL.PL-PERS.sexper INTEGRAL.PL-PERS.patper ~
INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper INTEGRAL.PL-PERS.lmilit ~
INTEGRAL.PL-PERS.lelect INTEGRAL.PL-PERS.ctipss INTEGRAL.PL-PERS.fecnac ~
INTEGRAL.PL-PERS.dirper INTEGRAL.PL-PERS.localidad INTEGRAL.PL-PERS.distri ~
INTEGRAL.PL-PERS.telefo INTEGRAL.PL-PERS.provin INTEGRAL.PL-PERS.nacion ~
INTEGRAL.PL-PERS.titulo INTEGRAL.PL-PERS.profesion 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_TipoVia COMBO-BOX_TipoZona ~
FILL-IN-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX_TipoVia AS CHARACTER FORMAT "x(15)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_TipoZona AS CHARACTER FORMAT "x(15)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .81 NO-UNDO.

DEFINE IMAGE IMAGE-1
     SIZE 20.43 BY 5.81.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22 BY 6.15.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20 BY 1.35.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 1.35.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 1.35.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13 BY 1.35.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 1.35.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 1.35.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16 BY 1.35.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33 BY 1.35.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10 BY 1.35.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10 BY 1.35.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 1.35.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 1.35.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 1.35.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 21 BY 1.35.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 1.35.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 1.35.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_TipoVia AT ROW 8.31 COL 2 COLON-ALIGNED NO-LABEL
     COMBO-BOX_TipoZona AT ROW 10.04 COL 2 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-PERS.DirNumero AT ROW 8.31 COL 51 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     FILL-IN-1 AT ROW 2.73 COL 14 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-PERS.CodCia AT ROW 2.73 COL 9 COLON-ALIGNED
          LABEL "Compañia"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     INTEGRAL.PL-PERS.DirInterior AT ROW 8.31 COL 61 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     INTEGRAL.PL-PERS.codper AT ROW 1.38 COL 9 COLON-ALIGNED FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     INTEGRAL.PL-PERS.sexper AT ROW 1.38 COL 45 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 3
          LIST-ITEMS "Femenino","Masculino" 
          SIZE 13.14 BY 1
     INTEGRAL.PL-PERS.patper AT ROW 4.85 COL 2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.57 BY .81
     INTEGRAL.PL-PERS.matper AT ROW 4.85 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 17.29 BY .81
     INTEGRAL.PL-PERS.nomper AT ROW 4.85 COL 41 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16.86 BY .81
     INTEGRAL.PL-PERS.lmilit AT ROW 6.58 COL 15 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     INTEGRAL.PL-PERS.lelect AT ROW 6.58 COL 2 COLON-ALIGNED NO-LABEL FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .81
     INTEGRAL.PL-PERS.ctipss AT ROW 6.58 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .81
     INTEGRAL.PL-PERS.fecnac AT ROW 1.38 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
     INTEGRAL.PL-PERS.dirper AT ROW 8.31 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.localidad AT ROW 10.04 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27.29 BY .81
     INTEGRAL.PL-PERS.distri AT ROW 10.04 COL 49 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.telefo AT ROW 11.77 COL 34 COLON-ALIGNED NO-LABEL FORMAT "X(17)"
          VIEW-AS FILL-IN 
          SIZE 18.86 BY .81
     INTEGRAL.PL-PERS.provin AT ROW 11.77 COL 2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-PERS.nacion AT ROW 11.77 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27.14 BY .81
     INTEGRAL.PL-PERS.titulo AT ROW 13.5 COL 2 COLON-ALIGNED NO-LABEL FORMAT "X(20)"
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 29.57 BY 1
     INTEGRAL.PL-PERS.profesion AT ROW 13.5 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 27.72 BY 1
     IMAGE-1 AT ROW 1.38 COL 65
     RECT-14 AT ROW 1.19 COL 64
     RECT-16 AT ROW 4.46 COL 3
     RECT-17 AT ROW 4.46 COL 23
     RECT-18 AT ROW 4.46 COL 42
     RECT-19 AT ROW 6.19 COL 3
     RECT-20 AT ROW 6.19 COL 16
     RECT-21 AT ROW 6.19 COL 34
     RECT-22 AT ROW 7.92 COL 3
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-23 AT ROW 7.92 COL 19
     RECT-24 AT ROW 7.92 COL 52
     RECT-25 AT ROW 7.92 COL 62
     RECT-26 AT ROW 9.65 COL 3
     RECT-27 AT ROW 9.65 COL 50
     RECT-28 AT ROW 11.38 COL 3
     RECT-29 AT ROW 11.38 COL 35
     RECT-30 AT ROW 11.38 COL 56
     RECT-31 AT ROW 13.12 COL 3
     RECT-32 AT ROW 13.12 COL 35
     "Ap. paterno" VIEW-AS TEXT
          SIZE 8.57 BY .54 AT ROW 4.27 COL 5
     "Ap. materno" VIEW-AS TEXT
          SIZE 8.57 BY .54 AT ROW 4.27 COL 25
     "Nombres" VIEW-AS TEXT
          SIZE 6.43 BY .54 AT ROW 4.27 COL 44
     "DNI" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6 COL 5
     "LM" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6 COL 18
     "C. IPSS" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6 COL 36
     "Direccion" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 7.73 COL 22
     "Tipo de Vía" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 7.73 COL 5
     "Numero" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 7.73 COL 53
     "Interior" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 7.73 COL 63
     "Tipo de Zona" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 9.46 COL 5
     "Distrito" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.46 COL 52
     "Provincia y Departamento" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 11.19 COL 5
     "Telefono" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 11.19 COL 37
     "Nacionalidad" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 11.19 COL 58
     "Grado de Instruccion" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 12.92 COL 5
     "Profesion" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 12.92 COL 37
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 14.04
         WIDTH              = 88.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.CodCia IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.codper IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_TipoVia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_TipoZona IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.lelect IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.matper IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.nomper IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.patper IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.provin IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-PERS.telefo IN FRAME F-Main
   EXP-FORMAT                                                           */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME INTEGRAL.PL-PERS.CodCia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-PERS.CodCia V-table-Win
ON LEAVE OF INTEGRAL.PL-PERS.CodCia IN FRAME F-Main /* Compañia */
DO:
   FIND FIRST B-CIAS WHERE INPUT PL-PERS.CodCia = B-CIAS.CodCia
        NO-ERROR .
   IF NOT AVAILABLE B-CIAS THEN DO:
      MESSAGE 'Compa¤ia no existe ' VIEW-AS ALERT-BOX.
      APPLY 'ENTRY' TO PL-PERS.Codcia.
      RETURN NO-APPLY.
   END.
   ASSIGN FILL-IN-1:SCREEN-VALUE IN FRAME F-MAIN = B-CIAS.NomCia.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
    ASSIGN integral.PL-PERS.codper:SENSITIVE IN FRAME F-Main = TRUE.
    APPLY "ENTRY" TO integral.PL-PERS.codper.

  RUN get-attribute ('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
     FIND LAST B-Pers.
     IF AVAILABLE B-Pers THEN DO:
        ASSIGN 
           PL-PERS.codper:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                   STRING(INTEGER(B-Pers.CodPer) + 1, '999999').
     END.
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
     ASSIGN integral.PL-PERS.CodPer:SENSITIVE IN FRAME F-Main = FALSE.
  END.
  ASSIGN
    x-CodAux = STRING(INTEGER(PL-PERS.codper), '99999999')
    x-NomAux = TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' +
                TRIM(PL-PERS.nomper)
    NO-ERROR.
  IF ERROR-STATUS:ERROR = NO
  THEN DO:
    FIND CB-AUXI WHERE cb-auxi.codcia = 0
        AND cb-auxi.clfaux = x-clfaux
        AND cb-auxi.codaux = x-codaux
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE CB-AUXI
    THEN CREATE CB-AUXI.
    ASSIGN
        CB-AUXI.codcia = 0
        CB-AUXI.clfaux = x-clfaux
        CB-AUXI.codaux = x-codaux
        CB-AUXI.nomaux = x-nomaux.
    RELEASE CB-AUXI.          
  END.
  /* ****************** */
  ASSIGN FRAME {&FRAME-NAME}
    COMBO-BOX_TipoVia COMBO-BOX_TipoZona.
  ASSIGN
    INTEGRAL.PL-PERS.TipoVia  = ENTRY(LOOKUP(COMBO-BOX_TipoVia, COMBO-BOX_TipoVia:LIST-ITEMS IN FRAME {&FRAME-NAME}), x-TipoVia)
    INTEGRAL.PL-PERS.TipoZona = ENTRY(LOOKUP(COMBO-BOX_TipoZona, COMBO-BOX_TipoZona:LIST-ITEMS IN FRAME {&FRAME-NAME}), x-TipoZona).

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
    COMBO-BOX_TipoVia:SENSITIVE IN FRAME F-Main = FALSE
    COMBO-BOX_TipoZona:SENSITIVE IN FRAME F-Main = FALSE
    integral.PL-PERS.codper:SENSITIVE IN FRAME F-Main = FALSE.

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
  IF AVAILABLE integral.PL-PERS
  THEN DO WITH FRAME {&FRAME-NAME}:
    IF integral.PL-PERS.Titulo = "" THEN integral.PL-PERS.Titulo:SCREEN-VALUE = " ".
    IF integral.PL-PERS.Profesion = "" THEN integral.Pl-PERS.Profesion:SCREEN-VALUE = " ".
    FIND FIRST B-CIAS WHERE B-CIAS.Codcia = INTEGER(PL-PERS.CodCia:SCREEN-VALUE) NO-ERROR.
    IF AVAILABLE B-Cias 
    THEN FILL-IN-1:SCREEN-VALUE = B-Cias.Nomcia.
    ELSE FILL-IN-1:SCREEN-VALUE = ' '.
    IF IMAGE-1:LOAD-IMAGE(PL-PERS.Codbar) 
    THEN DO:
        DISPLAY IMAGE-1.
    END.
    ELSE DO:
        IMAGE-1:LOAD-IMAGE("c:\dlc\gui\adeicon\blank.bmp").
        IMAGE-1:SCREEN-VALUE = "c:\dlc\gui\adeicon\blank.bmp".
        DISPLAY IMAGE-1.
    END.  
    ASSIGN
        COMBO-BOX_TipoVia:SCREEN-VALUE = ENTRY(LOOKUP(PL-PERS.TipoVia, x-TipoVia), COMBO-BOX_TipoVia:LIST-ITEMS)
        COMBO-BOX_TipoZona:SCREEN-VALUE = ENTRY(LOOKUP(PL-PERS.TipoZona, x-TipoZona), COMBO-BOX_TipoZona:LIST-ITEMS).
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
    COMBO-BOX_TipoVia:SENSITIVE IN FRAME F-Main = TRUE
    COMBO-BOX_TipoZona:SENSITIVE IN FRAME F-Main = TRUE
    integral.PL-PERS.codper:SENSITIVE IN FRAME F-Main = FALSE.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH PL-TABLA WHERE pl-tabla.codcia = s-codcia
            AND pl-tabla.tabla = '01' NO-LOCK:
        COMBO-BOX_TipoVia:ADD-LAST(pl-tabla.nombre).
        IF x-TipoVia = ''
        THEN x-TipoVia = pl-tabla.codigo.
        ELSE x-TipoVia = x-TipoVia + ',' + pl-tabla.codigo.
    END.            
    FOR EACH PL-TABLA WHERE pl-tabla.codcia = s-codcia
            AND pl-tabla.tabla = '02' NO-LOCK:
        COMBO-BOX_TipoZona:ADD-LAST(pl-tabla.nombre).
        IF x-TipoZona = ''
        THEN x-TipoZona = pl-tabla.codigo.
        ELSE x-TipoZona = x-TipoZona + ',' + pl-tabla.codigo.
    END.            
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
    COMBO-BOX_TipoVia:SENSITIVE IN FRAME F-Main = FALSE
    COMBO-BOX_TipoZona:SENSITIVE IN FRAME F-Main = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


