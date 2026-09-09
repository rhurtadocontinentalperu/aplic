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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-NroMes AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES INTEGRAL.PL-DHABIENTE INTEGRAL.PL-FLG-SEM
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.PL-DHABIENTE


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.PL-DHABIENTE, INTEGRAL.PL-FLG-SEM.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-DHABIENTE.TpoDocId ~
INTEGRAL.PL-DHABIENTE.NroDocId INTEGRAL.PL-DHABIENTE.SitDerHab ~
INTEGRAL.PL-DHABIENTE.FecNac INTEGRAL.PL-DHABIENTE.PatPer ~
INTEGRAL.PL-DHABIENTE.MatPer INTEGRAL.PL-DHABIENTE.Sexo ~
INTEGRAL.PL-DHABIENTE.FchAlta INTEGRAL.PL-DHABIENTE.NomPer ~
INTEGRAL.PL-DHABIENTE.TpoBaja INTEGRAL.PL-DHABIENTE.VinculoFam ~
INTEGRAL.PL-DHABIENTE.FchBaja INTEGRAL.PL-DHABIENTE.NroDocPat ~
INTEGRAL.PL-DHABIENTE.NroRelDir INTEGRAL.PL-DHABIENTE.IndDomici ~
INTEGRAL.PL-DHABIENTE.TpoVia INTEGRAL.PL-DHABIENTE.NomVia ~
INTEGRAL.PL-DHABIENTE.NroVia INTEGRAL.PL-DHABIENTE.IntVia ~
INTEGRAL.PL-DHABIENTE.TpoZona INTEGRAL.PL-DHABIENTE.NomZona ~
INTEGRAL.PL-DHABIENTE.DirReferen INTEGRAL.PL-DHABIENTE.Ubigeo 
&Scoped-define ENABLED-TABLES INTEGRAL.PL-DHABIENTE
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-DHABIENTE
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-2 RECT-1 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-DHABIENTE.TpoDocId ~
INTEGRAL.PL-DHABIENTE.NroDocId INTEGRAL.PL-DHABIENTE.SitDerHab ~
INTEGRAL.PL-DHABIENTE.FecNac INTEGRAL.PL-DHABIENTE.PatPer ~
INTEGRAL.PL-DHABIENTE.MatPer INTEGRAL.PL-DHABIENTE.Sexo ~
INTEGRAL.PL-DHABIENTE.FchAlta INTEGRAL.PL-DHABIENTE.NomPer ~
INTEGRAL.PL-DHABIENTE.TpoBaja INTEGRAL.PL-DHABIENTE.VinculoFam ~
INTEGRAL.PL-DHABIENTE.FchBaja INTEGRAL.PL-DHABIENTE.NroDocPat ~
INTEGRAL.PL-DHABIENTE.NroRelDir INTEGRAL.PL-DHABIENTE.IndDomici ~
INTEGRAL.PL-DHABIENTE.TpoVia INTEGRAL.PL-DHABIENTE.NomVia ~
INTEGRAL.PL-DHABIENTE.NroVia INTEGRAL.PL-DHABIENTE.IntVia ~
INTEGRAL.PL-DHABIENTE.TpoZona INTEGRAL.PL-DHABIENTE.NomZona ~
INTEGRAL.PL-DHABIENTE.DirReferen INTEGRAL.PL-DHABIENTE.Ubigeo 
&Scoped-define DISPLAYED-TABLES INTEGRAL.PL-DHABIENTE
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.PL-DHABIENTE
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TpoDocId FILL-IN-TpoBaja ~
COMBO-BOX-DocAcredita FILL-IN-TpoVia FILL-IN-TpoZona FILL-IN-region ~
FILL-IN-provincia FILL-IN-distrito 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-DocAcredita AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","1: Escritura Pública","2: Testamento","3: Sentencia de declaratoria de paternidad" 
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-distrito AS CHARACTER FORMAT "X(256)":U 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-provincia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Provincia" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-region AS CHARACTER FORMAT "X(256)":U 
     LABEL "Región" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoBaja AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoDocId AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoVia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoZona AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 3.85.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 3.46.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.PL-DHABIENTE.TpoDocId AT ROW 1.38 COL 11 COLON-ALIGNED
          LABEL "Tipo Doc"
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     FILL-IN-TpoDocId AT ROW 1.38 COL 14 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-DHABIENTE.NroDocId AT ROW 1.38 COL 52 COLON-ALIGNED
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     INTEGRAL.PL-DHABIENTE.SitDerHab AT ROW 1.38 COL 78.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Activo", "10":U,
"Baja", "11":U
          SIZE 8 BY 1.35
     INTEGRAL.PL-DHABIENTE.FecNac AT ROW 2.15 COL 52 COLON-ALIGNED
          LABEL "Fecha Nac"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     INTEGRAL.PL-DHABIENTE.PatPer AT ROW 2.19 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-DHABIENTE.MatPer AT ROW 3 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-DHABIENTE.Sexo AT ROW 3.12 COL 54 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Masculino", "1":U,
"Femenino", "2":U
          SIZE 10 BY 1.35
     INTEGRAL.PL-DHABIENTE.FchAlta AT ROW 3.12 COL 77 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     INTEGRAL.PL-DHABIENTE.NomPer AT ROW 3.81 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-DHABIENTE.TpoBaja AT ROW 5.23 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     FILL-IN-TpoBaja AT ROW 5.23 COL 60 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-DHABIENTE.VinculoFam AT ROW 5.62 COL 3 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Hijo", "1":U,
"Cónyuge", "2":U,
"Concubina(0)", "3":U,
"Gestante", "4":U
          SIZE 12 BY 2.5
     COMBO-BOX-DocAcredita AT ROW 5.81 COL 14 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-DHABIENTE.FchBaja AT ROW 6.04 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     INTEGRAL.PL-DHABIENTE.NroDocPat AT ROW 7.35 COL 14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.PL-DHABIENTE.NroRelDir AT ROW 7.54 COL 50 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.PL-DHABIENTE.IndDomici AT ROW 8.31 COL 72 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Domicilio Trabajador", "0":U,
"Otro Domicilio", "1":U
          SIZE 17 BY 1.35
     INTEGRAL.PL-DHABIENTE.TpoVia AT ROW 8.69 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     FILL-IN-TpoVia AT ROW 8.69 COL 12 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-DHABIENTE.NomVia AT ROW 8.69 COL 31 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.PL-DHABIENTE.NroVia AT ROW 8.69 COL 51 COLON-ALIGNED
          LABEL "Nro"
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     INTEGRAL.PL-DHABIENTE.IntVia AT ROW 8.69 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     INTEGRAL.PL-DHABIENTE.TpoZona AT ROW 9.5 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-TpoZona AT ROW 9.5 COL 12 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-DHABIENTE.NomZona AT ROW 9.5 COL 31 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.PL-DHABIENTE.DirReferen AT ROW 10.31 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     INTEGRAL.PL-DHABIENTE.Ubigeo AT ROW 10.31 COL 46 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     FILL-IN-region AT ROW 10.31 COL 59 COLON-ALIGNED
     FILL-IN-provincia AT ROW 11.12 COL 59 COLON-ALIGNED
     FILL-IN-distrito AT ROW 11.92 COL 59 COLON-ALIGNED
     "Documento que acredita la paternidad" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 6.77 COL 16
     " Vínculo Familiar" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 4.85 COL 3
          BGCOLOR 1 FGCOLOR 15 
     "Sexo:" VIEW-AS TEXT
          SIZE 4.43 BY .5 AT ROW 3.31 COL 49
     "Situación:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.58 COL 71
     "Nro Resolución Directorial Incapacidad Hijo Mayor" VIEW-AS TEXT
          SIZE 34 BY .5 AT ROW 6.96 COL 52
     " Indicador de Domicilio" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 7.73 COL 72
          BGCOLOR 1 FGCOLOR 15 
     "Tipo de Documento que acredita la paternidad" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 5.23 COL 16
     RECT-3 AT ROW 7.92 COL 70
     RECT-2 AT ROW 5.04 COL 1
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PL-DHABIENTE,INTEGRAL.PL-FLG-SEM
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
         HEIGHT             = 11.92
         WIDTH              = 91.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-DocAcredita IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-DHABIENTE.FecNac IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-distrito IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-provincia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-region IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoBaja IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoDocId IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoVia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoZona IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-DHABIENTE.NroDocId IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-DHABIENTE.NroVia IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-DHABIENTE.TpoDocId IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME INTEGRAL.PL-DHABIENTE.TpoBaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-DHABIENTE.TpoBaja V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-DHABIENTE.TpoBaja IN FRAME F-Main /* Tipo Baja */
OR F8 OF PL-DHABIENTE.TpoBaja DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "20"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Tipo de Baja").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-DHABIENTE.TpoBaja
                pl-tabl.Nombre @ FILL-IN-TpoBaja
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-DHABIENTE.TpoDocId
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-DHABIENTE.TpoDocId V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-DHABIENTE.TpoDocId IN FRAME F-Main /* Tipo Doc */
OR F8 OF PL-DHABIENTE.TpoDocId DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "03"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Tipo Documento").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-DHABIENTE.TpoDocId
                pl-tabl.Nombre @ FILL-IN-TpoDocId
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-DHABIENTE.TpoVia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-DHABIENTE.TpoVia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-DHABIENTE.TpoVia IN FRAME F-Main /* Tipo Vía */
OR F8 OF PL-DHABIENTE.TpoVia DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "05"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Tipo Vía").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-DHABIENTE.TpoVia
                pl-tabl.Nombre @ FILL-IN-TpoVia
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-DHABIENTE.TpoZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-DHABIENTE.TpoZona V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-DHABIENTE.TpoZona IN FRAME F-Main /* Tipo Zona */
OR F8 OF PL-DHABIENTE.TpoZona DO:

    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "06"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Tipo Zona").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-DHABIENTE.TpoZona
                pl-tabl.Nombre @ FILL-IN-TpoZona
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-DHABIENTE.Ubigeo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-DHABIENTE.Ubigeo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-DHABIENTE.Ubigeo IN FRAME F-Main /* Ubigeo */
OR F8 OF PL-DHABIENTE.Ubigeo DO:

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
            PL-DHABIENTE.Ubigeo:SCREEN-VALUE = OUTPUT-VAR-2.
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


&Scoped-define SELF-NAME INTEGRAL.PL-DHABIENTE.VinculoFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-DHABIENTE.VinculoFam V-table-Win
ON VALUE-CHANGED OF INTEGRAL.PL-DHABIENTE.VinculoFam IN FRAME F-Main /* Vin!Fam */
DO:
    CASE PL-DHABIENTE.VinculoFam:SCREEN-VALUE:
        WHEN '4' THEN DO:
            COMBO-BOX-DocAcredita:SENSITIVE = TRUE.
            PL-DHABIENTE.NroDocPat:SENSITIVE = TRUE.
        END.
        OTHERWISE DO:
            PL-DHABIENTE.NroDocPat:SCREEN-VALUE = ' '.
            COMBO-BOX-DocAcredita:SCREEN-VALUE = ' '.
            COMBO-BOX-DocAcredita:SENSITIVE = FALSE.
            PL-DHABIENTE.NroDocPat:SENSITIVE = FALSE.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "INTEGRAL.PL-DHABIENTE"}
  {src/adm/template/row-list.i "INTEGRAL.PL-FLG-SEM"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.PL-DHABIENTE"}
  {src/adm/template/row-find.i "INTEGRAL.PL-FLG-SEM"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

    DO WITH FRAME {&FRAME-NAME}:
        RUN get-attribute ('ADM-NEW-RECORD').
        IF RETURN-VALUE = 'YES' THEN DO:
            ASSIGN
                PL-DHABIENTE.CodCia = PL-FLG-SEM.CodCia
                PL-DHABIENTE.Periodo = PL-FLG-SEM.Periodo
                PL-DHABIENTE.CodPln = PL-FLG-SEM.CodPln
                PL-DHABIENTE.NroMes = s-NroMes
                PL-DHABIENTE.CodPer = PL-FLG-SEM.CodPer.
        END.
        IF PL-DHABIENTE.VinculoFam:SCREEN-VALUE = '4' THEN DO:
            PL-DHABIENTE.TpoDocPat = SUBSTRING(COMBO-BOX-DocAcredita:SCREEN-VALUE,1,1).
        END.
        ELSE DO:
            PL-DHABIENTE.TpoDocPat = "".
            PL-DHABIENTE.NroDocPat = "".
        END.
        PL-DHABIENTE.NroDocPat:SENSITIVE = FALSE.
        COMBO-BOX-DocAcredita:SENSITIVE = FALSE.

        IF PL-DHABIENTE.SitDerHab:SCREEN-VALUE <> '11' THEN
            PL-DHABIENTE.TpoBaja = "".

    END.

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
    DO WITH FRAME {&FRAME-NAME}:
        COMBO-BOX-DocAcredita:SENSITIVE = FALSE.
        PL-DHABIENTE.NroDocPat:SENSITIVE = FALSE.
    END.

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
    DEFINE VARIABLE ind AS INTEGER NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:

        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '03' AND
            pl-tabla.codigo = PL-DHABIENTE.TpoDocId:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-TpoDocId:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-TpoDocId:SCREEN-VALUE = ''.
        COMBO-BOX-DocAcredita = "".
        IF AVAILABLE PL-DHABIENTE THEN
            DO ind = 1 TO NUM-ENTRIES(COMBO-BOX-DocAcredita:LIST-ITEMS):
            IF SUBSTRING(ENTRY(ind,COMBO-BOX-DocAcredita:LIST-ITEMS),1,1) =
                PL-DHABIENTE.TpoDocPat THEN DO:
                COMBO-BOX-DocAcredita = ENTRY(ind,COMBO-BOX-DocAcredita:LIST-ITEMS).
                LEAVE.
            END.
        END.
        IF COMBO-BOX-DocAcredita = "" THEN
            COMBO-BOX-DocAcredita:SCREEN-VALUE = ' '.
        ELSE COMBO-BOX-DocAcredita:SCREEN-VALUE = COMBO-BOX-DocAcredita.

        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '20' AND
            pl-tabla.codigo = PL-DHABIENTE.TpoBaja:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-TpoBaja:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-TpoBaja:SCREEN-VALUE = ''.

        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '05' AND
            pl-tabla.codigo = PL-DHABIENTE.TpoVia:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-TpoVia:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-TpoVia:SCREEN-VALUE = ''.

        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '06' AND
            pl-tabla.codigo = PL-DHABIENTE.TpoZona:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-TpoZona:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-TpoZona:SCREEN-VALUE = ''.

        /* Region */
        FIND TabDepto WHERE
            TabDepto.CodDepto = SUBSTRING(PL-DHABIENTE.ubigeo:SCREEN-VALUE,1,2)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabDepto THEN FILL-IN-region = "".
        ELSE FILL-IN-region = TabDepto.NomDepto.

        /* Provincia */
        FIND TabProvi WHERE
            TabProvi.CodDepto = SUBSTRING(PL-DHABIENTE.ubigeo:SCREEN-VALUE,1,2) AND
            TabProvi.CodProvi = SUBSTRING(PL-DHABIENTE.ubigeo:SCREEN-VALUE,3,2)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabProvi THEN FILL-IN-provincia = "".
        ELSE FILL-IN-provincia = TabProvi.NomProvi.

        /* Distrito */
        FIND TabDistr WHERE
            TabDistr.CodDepto = SUBSTRING(PL-DHABIENTE.ubigeo:SCREEN-VALUE,1,2) AND
            TabDistr.CodProvi = SUBSTRING(PL-DHABIENTE.ubigeo:SCREEN-VALUE,3,2) AND
            TabDistr.CodDistr = SUBSTRING(PL-DHABIENTE.ubigeo:SCREEN-VALUE,5,2)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE TabDistr THEN FILL-IN-distrito = "".
        ELSE FILL-IN-distrito = TabDistr.NomDistr.

        DISPLAY FILL-IN-region FILL-IN-provincia FILL-IN-distrito.

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
    DO WITH FRAME {&FRAME-NAME}:
        APPLY "VALUE-CHANGED":U TO PL-DHABIENTE.VinculoFam.
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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
  {src/adm/template/snd-list.i "INTEGRAL.PL-DHABIENTE"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-FLG-SEM"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '03' AND
        pl-tabla.codigo = PL-DHABIENTE.TpoDocId:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Tipo de Documento no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.TpoDocId.
        RETURN "ADM-ERROR".
    END.

    IF PL-DHABIENTE.PatPer:SCREEN-VALUE = "" THEN DO:
        MESSAGE
            "Debe ingresar el Apellido Paterno"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.PatPer.
        RETURN "ADM-ERROR".
    END.
    IF PL-DHABIENTE.MatPer:SCREEN-VALUE = "" THEN DO:
        MESSAGE
            "Debe ingresar el Apellido Materno"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.MatPer.
        RETURN "ADM-ERROR".
    END.
    IF PL-DHABIENTE.NomPer:SCREEN-VALUE = "" THEN DO:
        MESSAGE
            "Debe ingresar el Nombre"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.NomPer.
        RETURN "ADM-ERROR".
    END.

    IF PL-DHABIENTE.VinculoFam:SCREEN-VALUE = '4' THEN DO:
        ASSIGN COMBO-BOX-DocAcredita.
        IF COMBO-BOX-DocAcredita = "" THEN DO:
            MESSAGE
                "Tipo de Documento no es Válido"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO COMBO-BOX-DocAcredita.
            RETURN "ADM-ERROR".
        END.
        IF PL-DHABIENTE.NroDocPat:SCREEN-VALUE = "" THEN DO:
            MESSAGE
                "Número de Documento no es Válido"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO PL-DHABIENTE.NroDocPat.
            RETURN "ADM-ERROR".
        END.
    END.

    IF PL-DHABIENTE.SitDerHab:SCREEN-VALUE = '11' AND
        NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '20' AND
        pl-tabla.codigo = PL-DHABIENTE.TpoBaja:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Tipo de Baja no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.TpoBaja.
        RETURN "ADM-ERROR".
    END.

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '05' AND
        pl-tabla.codigo = PL-DHABIENTE.TpoVia:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Tipo de Vía no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.TpoVia.
        RETURN "ADM-ERROR".
    END.

    IF PL-DHABIENTE.TpoZona:SCREEN-VALUE <> "" AND
        NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '06' AND
        pl-tabla.codigo = PL-DHABIENTE.TpoZona:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Tipo de Zona no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-DHABIENTE.TpoZona.
        RETURN "ADM-ERROR".
    END.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

