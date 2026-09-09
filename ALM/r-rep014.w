&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

define stream REPORT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodFam x-SubFam txtArtDesde txtArthasta ~
rbCuales rbQuienes Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-CodFam x-NomFam x-SubFam x-NomSub ~
txtArtDesde txtArthasta rbCuales rbQuienes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Archivo TXT" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE txtArtDesde AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Articulo desde" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81 NO-UNDO.

DEFINE VARIABLE txtArthasta AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-familia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE rbCuales AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Sin ninguna condicion", 1,
"Solo los que tengan EAN13 y ningun EAN14", 2,
"Solo los que tengan EAN13 y algun EAN14", 3,
"Solo los que tengan EAN13 y todos los EAN14", 4,
"Solo los que NO tengan EAN13 y algun EAN14", 5,
"Solo los que NO tengan EAN13 y tampoco EAN14", 6
     SIZE 41 BY 5.38 NO-UNDO.

DEFINE VARIABLE rbQuienes AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Activos", 2,
"Inactivos", 3
     SIZE 14 BY 2.31 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     x-CodFam AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 4
     x-NomFam AT ROW 2.08 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     x-SubFam AT ROW 3.15 COL 9 COLON-ALIGNED WIDGET-ID 8
     x-NomSub AT ROW 3.15 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtArtDesde AT ROW 4.42 COL 14.72 COLON-ALIGNED WIDGET-ID 20
     txtArthasta AT ROW 4.42 COL 30 COLON-ALIGNED WIDGET-ID 22
     rbCuales AT ROW 5.88 COL 6 NO-LABEL WIDGET-ID 12
     rbQuienes AT ROW 6 COL 49 NO-LABEL WIDGET-ID 24
     Btn_OK AT ROW 12.54 COL 5
     Btn_Cancel AT ROW 12.54 COL 22
     SPACE(29.85) SKIP(0.65)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "REPORTE DE CODIGOS DE BARRAS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-NomFam IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomSub IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* REPORTE DE CODIGOS DE BARRAS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* Archivo TXT */
DO:
    ASSIGN
    x-codfam x-subfam txtArtDesde txtArtHasta rbCuales rbQuienes.

    DEFINE VAR lImprimir AS LOG.
    DEFINE VAR lEan13 AS LOG.
    DEFINE VAR lEan14a AS LOG.
    DEFINE VAR lEan14b AS LOG.
    DEFINE VAR lEan14c AS LOG.
    DEFINE VAR lEan14d AS LOG.
    DEFINE VAR lEan14e AS LOG.

    DEFINE VAR lCodMatDesde AS CHAR.
    DEFINE VAR lCodMatHasta AS CHAR.
    DEFINE VAR lCodEan13 AS CHAR.
    DEFINE VAR lCodEan14a AS CHAR.
    DEFINE VAR lCodEan14b AS CHAR.
    DEFINE VAR lCodEan14c AS CHAR.
    DEFINE VAR lCodEan14d AS CHAR.
    DEFINE VAR lCodEan14e AS CHAR.
    DEFINE VAR lEquEan14a AS DEC.
    DEFINE VAR lEquEan14b AS DEC.
    DEFINE VAR lEquEan14c AS DEC.
    DEFINE VAR lEquEan14d AS DEC.
    DEFINE VAR lEquEan14e AS DEC.
    DEFINE VAR lStock AS DEC.
    /*
    IF x-codfam = '' THEN DO:
    MESSAGE 'Ingrese el código de la familia' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
    END.
    RUN Imprimir.
    */
    DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.
    
    x-Archivo = STRING(NOW,"99-99-9999 hh:mm:ss").
    x-Archivo = REPLACE(x-Archivo,"-","").
    x-Archivo = REPLACE(x-Archivo,":","").
    x-Archivo = "EANS-" + REPLACE(x-Archivo," ","") + ".txt".
    /*x-Archivo = 'PagSinIngreso.txt'.*/
    SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
    IF x-rpta = NO THEN RETURN.

    IF txtArtHasta <= 0 THEN txtArtHasta = 999999.

    lCodMatDesde = STRING(txtArtDesde,"999999").
    lCodMatHasta = STRING(txtArtHasta,"999999").
    
    X-codfam = TRIM(X-codfam).
    X-Subfam = TRIM(X-Subfam).

    OUTPUT STREAM REPORT TO VALUE(x-Archivo).
    PUT STREAM REPORT
        "Codigo|" 
        "Descripcion|"      
        "Marca|"      
        "Stock|"
        "EAN13|"      
        "EAN14-1|"      
        "EQUIVALENCIA|"
        "EAN14-2|"      
        "EQUIVALENCIA|"
        "EAN14-3|"
        "EQUIVALENCIA|"
        "EAN14-4|"
        "EQUIVALENCIA|"
        "EAN14-5|"
        "EQUIVALENCIA|"
        "Status" SKIP.

    SESSION:SET-WAIT-STATE('GENERAL').

    FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codfam BEGINS X-codfam AND 
        almmmatg.subfam BEGINS X-Subfam AND 
        (almmmatg.codmat >= lCodmatDesde AND almmmatg.codmat <= lCodMatHasta ) NO-LOCK:

        FIND FIRST almmmat1 OF almmmatg NO-LOCK NO-ERROR.

        lEan13 = FALSE.
        lEan14a = FALSE.
        lEan14b = FALSE.
        lEan14c = FALSE.
        lEan14d = FALSE.
        lEan14e = FALSE.
        lCodEan14a = "".
        lCodEan14b = "".
        lCodEan14c = "".
        lCodEan14d = "".
        lCodEan14e = "".
        lCodEan13 = "".
        lEquEan14a = 0.
        lEquEan14b = 0.
        lEquEan14c = 0.
        lEquEan14d = 0.
        lEquEan14e = 0.
        
        lCodEan13 = if(almmmatg.codbrr <> ?) THEN trim(almmmatg.codbrr) ELSE "".
        IF lCodEan13 <> '' THEN lEan13 = TRUE.

        IF AVAILABLE almmmat1 THEN DO:
            lCodEan14a = if(almmmat1.barras[1] <> ?) THEN trim(almmmat1.barras[1]) ELSE "".
            lCodEan14b = if(almmmat1.barras[2] <> ?) THEN trim(almmmat1.barras[2]) ELSE "".
            lCodEan14c = if(almmmat1.barras[3] <> ?) THEN trim(almmmat1.barras[3]) ELSE "".
            lCodEan14d = if(almmmat1.barras[4] <> ?) THEN trim(almmmat1.barras[4]) ELSE "".
            lCodEan14e = if(almmmat1.barras[5] <> ?) THEN trim(almmmat1.barras[5]) ELSE "".
            IF lCodEan14a <> '' THEN lEan14a = TRUE.
            IF lCodEan14b <> '' THEN lEan14b = TRUE.
            IF lCodEan14c <> '' THEN lEan14c = TRUE.
            IF lCodEan14d <> '' THEN lEan14d = TRUE.
            IF lCodEan14e <> '' THEN lEan14e = TRUE.
            ASSIGN
                lEquEan14a = Almmmat1.Equival[1] 
                lEquEan14b = Almmmat1.Equival[2] 
                lEquEan14c = Almmmat1.Equival[3] 
                lEquEan14d = Almmmat1.Equival[4] 
                lEquEan14e = Almmmat1.Equival[5]
                .
        END.
        lStock = 0.
        FIND LAST almstkal WHERE almstkal.codcia = s-codcia AND almstkal.codalm = s-codalm AND
                almstkal.codmat = almmmatg.codmat AND almstkal.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE almstkal THEN lStock = almstkal.stkact.

        lImprimir = FALSE.
        CASE rbCuales:
            WHEN 1 THEN DO : 
                lImprimir = TRUE.
            END.
            WHEN 2 THEN DO:
                IF lEan13 = TRUE AND lEan14a = FALSE 
                    AND lEan14b = FALSE AND lEan14c = FALSE 
                    AND lEan14d = FALSE AND lEan14e = FALSE THEN lImprimir = TRUE.
            END.
            WHEN 3 THEN DO:
                IF lEan13 = TRUE AND (lEan14a = TRUE
                    OR lEan14b = TRUE OR lEan14c = TRUE
                    OR lEan14d = TRUE OR lEan14e = TRUE ) THEN lImprimir = TRUE.
            END.
            WHEN 4 THEN DO:
                IF lEan13 = TRUE AND lEan14a = TRUE 
                    AND lEan14b = TRUE AND lEan14c = TRUE 
                    AND lEan14d = TRUE AND lEan14e = TRUE THEN lImprimir = TRUE.
            END.
            WHEN 5 THEN DO:
                IF lEan13 = FALSE AND (lEan14a = TRUE
                    OR lEan14b = TRUE OR lEan14c = TRUE 
                    OR lEan14d = TRUE OR lEan14e = TRUE) 
                    THEN lImprimir = TRUE.
            END.
            WHEN 6 THEN DO:
                IF lEan13 = FALSE AND lEan14a = FALSE 
                    AND lEan14b = FALSE AND lEan14c = FALSE 
                    AND lEan14d = FALSE AND lEan14e = FALSE 
                    THEN lImprimir = TRUE.
            END.
        END CASE.

        CASE rbQuienes:
            WHEN 2 THEN DO:
                IF almmmatg.tpoart <> 'A' THEN lImprimir = FALSE.
            END.
            WHEN 3 THEN DO:
                IF almmmatg.tpoart = 'A' THEN lImprimir = FALSE.
            END.
        END CASE.

        IF lImprimir = TRUE THEN DO:
            PUT STREAM REPORT
                almmmatg.codmat "|"
                almmmatg.desmat "|"
                almmmatg.desmar "|"
                lstock "|"
                lCodEan13 FORMAT 'x(15)' "|"
                lCodEan14a FORMAT 'x(15)' "|"
                lEquEan14a FORMAT '>>>,>>9.99' "|"
                lCodEan14b FORMAT 'x(15)' "|"
                lEquEan14b FORMAT '>>>,>>9.99' "|"
                lCodEan14c FORMAT 'x(15)' "|"
                lEquEan14c FORMAT '>>>,>>9.99' "|"
                lCodEan14d FORMAT 'x(15)' "|"
                lEquEan14d FORMAT '>>>,>>9.99' "|"
                lCodEan14e FORMAT 'x(15)' "|"
                lEquEan14e FORMAT '>>>,>>9.99' "|"
                almmmatg.tpoart SKIP.
        END.
    END.
    
    SESSION:SET-WAIT-STATE('').

    OUTPUT STREAM REPORT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam gDialog
ON LEAVE OF x-CodFam IN FRAME gDialog /* Familia */
DO:
  x-nomfam:SCREEN-VALUE = ''.
  FIND almtfami WHERE almtfami.codcia = s-codcia
      AND almtfami.codfam = x-codfam:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE almtfami THEN x-nomfam:SCREEN-VALUE =  Almtfami.desfam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-SubFam gDialog
ON LEAVE OF x-SubFam IN FRAME gDialog /* Sub-familia */
DO:
    x-nomsub:SCREEN-VALUE = ''.
    FIND almsfami WHERE almsfami.codcia = s-codcia
        AND almsfami.codfam = x-codfam:SCREEN-VALUE
        AND almsfami.subfam = x-subfam:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE almsfami THEN x-nomsub:SCREEN-VALUE =  Almsfami.dessub.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY x-CodFam x-NomFam x-SubFam x-NomSub txtArtDesde txtArthasta rbCuales 
          rbQuienes 
      WITH FRAME gDialog.
  ENABLE x-CodFam x-SubFam txtArtDesde txtArthasta rbCuales rbQuienes Btn_OK 
         Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir gDialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
   
RB-REPORT-NAME = 'Codigos de Barras'.
GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm/rbalm.prl".
RB-INCLUDE-RECORDS = 'O'.
RB-FILTER = "almmmatg.codcia = " + STRING(s-codcia) +
            " AND almmmatg.codfam = '" + x-codfam + "'" +
            " AND almmmatg.subfam BEGINS '" + x-subfam + "'".
RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros gDialog 
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
        WHEN "x-subfam" THEN
            ASSIGN
                input-var-1 = x-codfam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

