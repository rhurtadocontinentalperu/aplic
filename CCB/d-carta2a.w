&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF INPUT PARAMETER x-Rowid AS ROWID.
DEFINE INPUT PARAMETE pHandle AS HANDLE.

DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR s-nomCia AS CHAR.
DEFINE VAR s-task-no AS INT.

/* Local Variable Definitions ---                                       */

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

FIND GN-CLIE WHERE ROWID(GN-CLIE) = x-Rowid NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE ttTempo
    FIELD   tcoddoc     AS  CHAR
    FIELD   tnrodoc     AS  CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog gn-clie.CodCli gn-clie.NomCli 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH gn-clie SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH gn-clie SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-62 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.NomCli 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-2 RADIO-SET-pdf FILL-IN-pdf 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/email.ico":U
     LABEL "Button 10" 
     SIZE 12 BY 1.62.

DEFINE BUTTON BUTTON-ruta 
     LABEL "..." 
     SIZE 3.29 BY .73.

DEFINE VARIABLE FILL-IN-pdf AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ruta PDF file" 
      VIEW-AS TEXT 
     SIZE 53 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-pdf AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impresora", 1,
"Enviar a PDF", 2,
"Generar PDF para enviar por correo", 3
     SIZE 52 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 6.85.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     gn-clie.CodCli AT ROW 1.54 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     gn-clie.NomCli AT ROW 2.5 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     x-FchDoc-1 AT ROW 3.38 COL 12.43 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.42 COL 30 COLON-ALIGNED
     RADIO-SET-pdf AT ROW 4.31 COL 14 NO-LABEL WIDGET-ID 16
     BUTTON-ruta AT ROW 5.27 COL 67.57 WIDGET-ID 12
     Btn_OK AT ROW 6.27 COL 31
     BUTTON-10 AT ROW 6.27 COL 43 WIDGET-ID 8
     Btn_Cancel AT ROW 6.27 COL 55
     FILL-IN-pdf AT ROW 5.31 COL 12 COLON-ALIGNED WIDGET-ID 10
     RECT-62 AT ROW 1.27 COL 2 WIDGET-ID 4
     SPACE(0.71) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ESTADO DE CUENTA POR CLIENTE"
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-10:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-ruta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pdf IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-pdf IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc-1 IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       x-FchDoc-1:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN x-FchDoc-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.gn-clie"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* ESTADO DE CUENTA POR CLIENTE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN
    x-FchDoc-1 x-FchDoc-2 radio-set-pdf /*tg-dudosa tg-letras*/.
  /*RUN dispatch IN THIS-PROCEDURE ('imprime':U).*/

  DEFINE VAR x-imprime AS LOG.

  x-imprime = YES.

  IF radio-set-pdf > 1 THEN DO:
      x-imprime = NO.
      IF TRUE <> (fill-in-pdf:SCREEN-VALUE > "") THEN DO:
            x-imprime = YES.
      END.
  END.

  IF x-imprime = YES THEN DO:
      RUN imprime-eecc.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 D-Dialog
ON CHOOSE OF BUTTON-10 IN FRAME D-Dialog /* Button 10 */
DO:
    /*
    ASSIGN
      x-FchDoc-1 x-FchDoc-2  /*tg-dudosa tg-letras*/.
    RUN Correo.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ruta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ruta D-Dialog
ON CHOOSE OF BUTTON-ruta IN FRAME D-Dialog /* ... */
DO:

    DEFINE VAR x-Directorio AS CHAR.

        SYSTEM-DIALOG GET-DIR x-Directorio  
           RETURN-TO-START-DIR 
           TITLE 'Elija Directorio'.
        IF x-Directorio <> "" THEN DO:
        fill-in-pdf:SCREEN-VALUE = x-directorio.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-pdf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-pdf D-Dialog
ON VALUE-CHANGED OF RADIO-SET-pdf IN FRAME D-Dialog
DO:

    DEFINE VAR x-value AS INT.
    DEFINE VAR x-user AS CHAR.

    DO WITH FRAME {&FRAME-NAME}:

        x-value = INTEGER(SELF:SCREEN-VALUE).
    
        DISABLE button-ruta .
    
        IF x-value > 1 THEN DO:
    
            ENABLE button-ruta .
    
            IF x-value = 2 THEN DO:
                fill-in-pdf:SCREEN-VALUE = SESSION:TEMP-DIRECTORY .
            END.
            ELSE DO:            
                x-user = USERID("DICTDB").
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'CONFIG-VTAS' AND
                                          vtatabla.llave_c1 = "EE.CC-EN-PDF" AND vtatabla.llave_c3 = x-user NO-LOCK NO-ERROR.
        
                IF AVAILABLE vtatabla THEN DO:
                    IF NOT (TRUE <> (vtatabla.llave_c4 > "")) THEN DO:
                        fill-in-pdf:SCREEN-VALUE = TRIM(vtatabla.llave_c4).
                    END.
                END.
                IF TRUE <> (fill-in-pdf:SCREEN-VALUE > "")  THEN DO:
                    fill-in-pdf:SCREEN-VALUE = SESSION:TEMP-DIRECTORY .
                END.        
            END.
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion D-Dialog 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Date-Format AS CHAR.

  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'Carta Estado de Cuenta Texto'       
    RB-INCLUDE-RECORDS = 'O'.
  /*
  IF tg-dudosa THEN DO:
      IF NOT tg-letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +
                          " AND (ccbcdocu.coddoc = 'FAC'" +
                          " OR ccbcdocu.coddoc = 'BOL'"+
                          " OR ccbcdocu.coddoc = 'DCO'"+
                          " OR ccbcdocu.coddoc = 'LET'" +
                          " OR ccbcdocu.coddoc = 'N/C'" +
                          " OR ccbcdocu.coddoc = 'N/D'" +
                          " OR ccbcdocu.coddoc = 'A/R'" +
                          " OR ccbcdocu.coddoc = 'BD'" +
                          " OR ccbcdocu.coddoc = 'CHQ'" +
                          " OR ccbcdocu.coddoc = 'A/C'" +
                          " OR ccbcdocu.coddoc = 'CHC')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +                          
                          " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
  ELSE DO:
      IF NOT tg-Letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND (ccbcdocu.coddoc = 'FAC'" +
                    " OR ccbcdocu.coddoc = 'BOL'"+
                    " OR ccbcdocu.coddoc = 'DCO'"+
                    " OR ccbcdocu.coddoc = 'LET'" +
                    " OR ccbcdocu.coddoc = 'N/C'" +
                    " OR ccbcdocu.coddoc = 'N/D'" +
                    " OR ccbcdocu.coddoc = 'A/R'" +
                    " OR ccbcdocu.coddoc = 'A/C'" +
                    " OR ccbcdocu.coddoc = 'BD'" +
                    " OR ccbcdocu.coddoc = 'CHQ')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
  */
  RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
              " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
              " AND (ccbcdocu.flgest = 'P'" +
              " OR  ccbcdocu.flgest = 'J')" +
              " AND (ccbcdocu.coddoc = 'FAC'" +
              " OR ccbcdocu.coddoc = 'BOL'"+
              " OR ccbcdocu.coddoc = 'DCO'"+
              " OR ccbcdocu.coddoc = 'LET'" +
              " OR ccbcdocu.coddoc = 'N/C'" +
              " OR ccbcdocu.coddoc = 'N/D'" +
              " OR ccbcdocu.coddoc = 'A/R'" +
              " OR ccbcdocu.coddoc = 'BD'" +
              " OR ccbcdocu.coddoc = 'CHQ'" +
              " OR ccbcdocu.coddoc = 'A/C'" +
              " OR ccbcdocu.coddoc = 'CHC')".

    RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.              

  x-Date-Format = SESSION:DATE-FORMAT.
  SESSION:DATE-FORMAT = 'mdy'.
  RB-FILTER = RB-FILTER +
                " AND ccbcdocu.fchdoc >= " + STRING(x-FchDoc-1) +
                " AND ccbcdocu.fchdoc <= " + STRING(x-FChDoc-2).
  SESSION:DATE-FORMAT = x-Date-Format.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-documentos D-Dialog 
PROCEDURE cargar-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sec AS INT.
DEFINE VAR x-signo AS INT.
DEFINE VAR x-doc AS CHAR.
DEFINE VAR x-estados AS CHAR.
DEFINE VAR x-situacion AS CHAR.
DEFINE VAR x-banco AS CHAR.
DEFINE VAR x-nrounico AS CHAR.
DEFINE VAR x-grupo AS CHAR.
DEFINE VAR x-grupo2 AS CHAR.
DEFINE VAR x-documentos AS CHAR.

DEFINE VAR x-ubicacion AS CHAR.

/* Ic - 18Dic2019, LPA - Ticket 68717*/

x-documentos = "A/C,A/R,LPA,LET,FAC,BOL,DCO,N/C,N/D,BD".
/*x-documentos = "A/R,LPA,LET,FAC,BOL,DCO,N/C,N/D,BD".*/

EMPTY TEMP-TABLE ttTempo.

FOR EACH ccbcdocu  WHERE ccbcdocu.codcia = s-codcia AND 
    ccbcdocu.codcli = gn-clie.codcli AND
    LOOKUP(ccbcdocu.coddoc,x-documentos) > 0 AND 
    ccbcdocu.sdoact > 0 NO-LOCK:
    IF ccbcdocu.flgest = 'A' THEN NEXT.
    
    x-banco = "".
    x-nrounico = "".
    x-ubicacion = "".
    x-situacion = "".
    /* FILTRANDO DOCUMENTOS */
    IF ccbcdocu.coddoc = 'LET' THEN DO:
        /**/        
        x-ubicacion = ccbcdocu.flgubi.
        IF ccbcdocu.flgubi = 'C' THEN x-ubicacion = "Cartera".
        IF ccbcdocu.flgubi = 'B' THEN x-ubicacion = "Banco".

        RUN gn/fFlgSitCCB.r(INPUT ccbcdocu.flgsit, OUTPUT x-situacion).

        IF ccbcdocu.flgsit = 'P' AND ccbcdocu.flgubi = 'C' THEN DO:
            /* Ic - 19Set2018 / Correo de Julissa (14Set2018) si la LET esta Protestada y en Cartera, no mostrar Banco ni Nro Unico */
        END.
        ELSE DO:
            FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND 
                                        cb-ctas.codcta = ccbcdocu.codcta
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN DO:
                FIND FIRST cb-tabl WHERE cb-tabl.tabla = "04" AND
                                            cb-tabl.codigo = cb-ctas.codbco NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN DO:
                    x-banco = cb-tabl.nombre.
                END.
            END.
            x-nrounico = ccbcdocu.nrosal.
        END.
        /**/
        /* Pendiente, Judicial y En Trámite */
        IF LOOKUP(ccbcdocu.flgest,'P,J,X') = 0 THEN NEXT.
    END.
    ELSE DO:
        /* Pendiente, Judicial */
        IF LOOKUP(ccbcdocu.flgest,'P,J') = 0  THEN NEXT.
    END.    
    /* */
    FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
    /* */
    x-signo = 1.

    x-Grupo = "E.- LETRAS PENDIENTES".  /* Por Defecto */
    IF ccbcdocu.coddoc = 'A/R' THEN x-grupo = "A.- ANTICIPOS RECIBIDOS".
    IF ccbcdocu.coddoc = 'A/C' THEN x-grupo = "A.- ANTICIPOS DE CAMPAÑA".
    IF ccbcdocu.coddoc = 'LPA' THEN x-grupo = "A.- LETRA PRE-ACEPTADA".     /* Ticket 68717 */
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN x-grupo = "B.- LETRAS POR ACEPTAR".

    /* A pedido de Julissa Calderon - 06Feb2019, Letras en Descuento debe estar en el mismo grupo de Letras Pendientes */
    /*IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'D' THEN x-grupo = "C.- LETRAS EN DESCUENTO".*/
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'T' THEN x-grupo = "D.- LETRAS ACEPTADA EN TRANSITO".
    IF ccbcdocu.coddoc = "FAC" THEN x-grupo = "F.- FACTURAS".
    IF ccbcdocu.coddoc = "BOL" THEN x-grupo = "G.- BOLETAS".
    IF ccbcdocu.coddoc = "DCO" THEN x-grupo = "H.- DOCUMENTOS DE COBRANZAS".
    IF ccbcdocu.coddoc = 'N/C' THEN x-grupo = "I.- NOTAS DE CREDITO".
    IF ccbcdocu.coddoc = 'N/D' THEN x-grupo = "J.- NOTAS DE DEBITO".
    IF ccbcdocu.coddoc = 'BD' THEN x-grupo = "K.- BOLETAS DE DEPOSITO".
    /* */
    x-Grupo2 = "LETRA(S) PENDIENTE(S)".    /* Por Defecto */
    IF ccbcdocu.coddoc = 'A/R' THEN x-grupo2 = "ANTICIPOS RECIBIDOS".
    IF ccbcdocu.coddoc = 'A/C' THEN x-grupo2 = "ANTICIPOS DE CAMPAÑA".
    IF ccbcdocu.coddoc = 'LPA' THEN x-grupo2 = "LETRA PRE-ACEPTADA".        /* Ticket 68717 */
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN x-grupo2 = "LETRA(S) POR ACEPTAR".
    /* A pedido de Julissa Calderon - 06Feb2019, Letras en Descuento debe estar en el mismo grupo de Letras Pendientes */
    /*IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'D' THEN x-grupo2 = "LETRA(S) EN DESCUENTO".*/
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'T' THEN x-grupo2 = "LETRA(S) ACEPTADA EN TRANSITO".
    /*IF lookup(ccbcdocu.coddoc,"FAC,BOL,DCO") > 0 THEN x-grupo2 = "FACTURAS".    /*"FACTURAS/BOLETAS/DOC.COBRANZAS".*/*/
    IF ccbcdocu.coddoc = "FAC" THEN x-grupo2 = "FACTURA(S) PENDIENTE(S)".
    IF ccbcdocu.coddoc = "BOL" THEN x-grupo2 = "BOLETA(S) PENDIENTES(S)".
    IF ccbcdocu.coddoc = "DCO" THEN x-grupo2 = "DOCUMENTO(S) DE COBRANZA PENDIENTE(S)".
    IF ccbcdocu.coddoc = 'N/C' THEN x-grupo2 = "NOTAS DE CREDITO(S) PENDIENTE(S)".
    IF ccbcdocu.coddoc = 'N/D' THEN x-grupo2 = "NOTAS DE DEBITO(S) PENDIENTE(S)".
    IF ccbcdocu.coddoc = 'BD' THEN x-grupo2 = "BOLETA(S) DE DEPOSITO(S)".
    /* Signos */
    IF ccbcdocu.coddoc = 'A/R' THEN x-signo = -1.       
    IF ccbcdocu.coddoc = 'A/C' THEN x-signo = -1.       
    IF ccbcdocu.coddoc = 'LPA' THEN x-signo = -1.       /* Ticket 68717 */
    IF ccbcdocu.coddoc = 'N/C' THEN x-signo = -1.
    IF ccbcdocu.coddoc = 'BD' THEN x-signo = -1.
    
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no 
        w-report.llave-c = x-Grupo
        w-report.campo-c[1] = "1.- DOCUMENTOS"
        w-report.campo-c[2] = ccbcdocu.coddoc
        w-report.campo-c[3] = ccbcdocu.nrodoc
        w-report.campo-d[1] = ccbcdocu.fchdoc
        w-report.campo-d[2] = ccbcdocu.FchVto
        w-report.campo-c[4] = x-ubicacion
        w-report.campo-c[5] = x-situacion
        /*
        w-report.campo-c[4] = ccbcdocu.fmapgo
        w-report.campo-c[5] = IF(AVAILABLE gn-convt) THEN gn-convt.vencmtos ELSE ""
        */
        w-report.campo-c[6] = x-banco
        w-report.campo-c[7] = x-nrounico
        w-report.campo-f[1] = ccbcdocu.imptot 
        w-report.campo-c[8] = IF(ccbcdocu.codmon = 1) THEN "S/" ELSE "US$"
        w-report.campo-f[2] = ccbcdocu.sdoact
        w-report.campo-i[2] = IF (TODAY - CcbCDocu.FchVto) > 0 THEN (TODAY - CcbCDocu.FchVto) ELSE 0        
        w-report.campo-f[3] = ccbcdocu.sdoact     /* Para la sumatoria */
        /* para los subtotales */
        w-report.campo-f[4] = IF(ccbcdocu.codmon = 2) THEN 0 ELSE ccbcdocu.sdoact       /* Soles */
        w-report.campo-f[5] = IF(ccbcdocu.codmon = 2) THEN ccbcdocu.sdoact ELSE 0       /* Dolares */
        w-report.campo-f[6] = 0
        w-report.campo-f[7] = 0.
        
    /* para el total gral */
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN DO:
        /* B.- LETRAS POR ACEPTAR no suma al total general es referencial */
        ASSIGN w-report.campo-f[6] = 0
                w-report.campo-f[7] = 0.
    END.
    ELSE DO:
        ASSIGN w-report.campo-f[6] = IF(ccbcdocu.codmon = 2) THEN 0 ELSE ccbcdocu.sdoact       /* Soles */
                w-report.campo-f[7] = IF(ccbcdocu.codmon = 2) THEN ccbcdocu.sdoact ELSE 0.       /* Dolares */   
    END.
    ASSIGN 
        w-report.campo-f[6] = w-report.campo-f[6] * x-signo
        w-report.campo-f[7] = w-report.campo-f[7] * x-signo.
        
    ASSIGN  
        w-report.campo-c[25] = x-grupo2
        w-report.campo-c[26] = " ".         /* "DOCUMENTOS PENDIENTES". - Correo de Julissa Calderon 14Ago2018 */

    /* Para Letras pendientes por aceptar, guardo los canjes */        
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN DO:
        FIND FIRST ttTempo WHERE ttTempo.tcoddoc = CcbCDocu.codref AND
                                    ttTempo.tnrodoc = CcbCDocu.nroref NO-ERROR.
        IF NOT AVAILABLE ttTempo THEN DO:
            CREATE ttTempo.
                ASSIGN ttTempo.tcoddoc = CcbCDocu.codref
                        ttTempo.tnrodoc = CcbCDocu.nroref.
        END.
    END.

END.

/* Docuemntos que involucran el canje */
FOR EACH ttTempo.
    FOR EACH ccbdmvto WHERE ccbdmvto.codcia = s-codcia AND 
                                ccbdmvto.coddoc = ttTempo.tcoddoc AND 
                                ccbdmvto.nrodoc = ttTempo.tnrodoc NO-LOCK:

        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                    ccbcdocu.coddoc = ccbdmvto.codref AND 
                                    ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
        END.       

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = "B.- LETRAS POR ACEPTAR"
            w-report.campo-c[1] = "2.- DOCUMENTOS COMPROMETIDOS EN EL CANJE"
            w-report.campo-c[2] = ccbdmvto.codref
            w-report.campo-c[3] = ccbdmvto.nroref
            w-report.campo-d[1] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.fchdoc ELSE ? 
            w-report.campo-d[2] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.FchVto ELSE ?
            w-report.campo-c[4] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.fmapgo ELSE ""
            w-report.campo-c[5] = IF(AVAILABLE gn-convt) THEN gn-convt.vencmtos ELSE ""
            w-report.campo-c[6] = "" 
            w-report.campo-c[7] = ""
            w-report.campo-c[8] = if(AVAILABLE ccbcdocu) THEN (IF(ccbcdocu.codmon = 1) THEN "S/" ELSE "US$") ELSE ""
            /* A pedido de Julisa Calderon con Autorizacion de Daniel Llican, 04Feb2019 - 16:11pm - Este no va
            w-report.campo-f[1] = if(AVAILABLE ccbcdocu) THEN (ccbdmvto.imptot * IF(ccbcdocu.codmon = 2) THEN ccbcdocu.tpocmb ELSE 1) ELSE 0            
            w-report.campo-f[2] = if(AVAILABLE ccbcdocu) THEN (ccbcdocu.sdoact * IF(ccbcdocu.codmon = 2) THEN ccbcdocu.tpocmb ELSE 1) ELSE 0 
            */
            w-report.campo-f[1] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.imptot ELSE 0            
            w-report.campo-f[2] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.sdoact ELSE 0 
            w-report.campo-i[2] = if(AVAILABLE ccbcdocu) THEN (IF (TODAY - CcbCDocu.FchVto) > 0 THEN (TODAY - CcbCDocu.FchVto) ELSE 0) ELSE 0
            w-report.campo-f[3] = 0
            /* Para el SubtTotal */
            w-report.campo-f[4] = IF(ccbcdocu.codmon = 2) THEN 0 ELSE ccbcdocu.sdoact       /* Soles */
            w-report.campo-f[5] = IF(ccbcdocu.codmon = 2) THEN ccbcdocu.sdoact ELSE 0       /* Dolares */
            /* Para el total GRAl, no considerar como deuda */
            w-report.campo-f[6] = 0
            w-report.campo-f[7] = 0
            .
        ASSIGN w-report.campo-c[25] = "LETRA(S) POR ACEPTAR"
                w-report.campo-c[26] = "DOCUMENTOS COMPROMETIDOS EN EL CANJE".
    END.
END.

RELEASE w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Correo D-Dialog 
PROCEDURE Correo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Pasamos la informacion al w-report */
  DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-MEMO-FILE AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1 NO-UNDO.
  DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0 NO-UNDO.
  DEF VAR RB-END-PAGE AS INTEGER INITIAL 0 NO-UNDO.
  DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO NO-UNDO.
  DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "" NO-UNDO.
  DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES NO-UNDO.
  DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES NO-UNDO.
  DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO NO-UNDO.
  DEF VAR RB-STATUS-FILE AS CHAR INITIAL "" NO-UNDO.

  DEFINE VAR s-print-file AS CHAR INIT 'Archivo_texto.txt' NO-UNDO.
  DEFINE VAR rpta AS LOG NO-UNDO.

  SYSTEM-DIALOG GET-FILE s-print-file
      FILTERS "txt" "*.txt"
      ASK-OVERWRITE
      CREATE-TEST-FILE
      DEFAULT-EXTENSION ".txt"
      SAVE-AS
      TITLE "Archivo de salida"
      USE-FILENAME
      UPDATE rpta.
  IF rpta = NO THEN RETURN.
      
  DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.
  
  GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.
  
  ASSIGN cDelimeter = CHR(32).
  IF NOT (cDatabaseName = ? OR
      cHostName = ? OR
      cNetworkProto = ? OR
      cPortNumber = ?) THEN DO:
      ASSIGN
          cNewConnString =
          "-db" + cDelimeter + cDatabaseName + cDelimeter +
          "-H" + cDelimeter + cHostName + cDelimeter +
          "-N" + cDelimeter + cNetworkProto + cDelimeter +
          "-S" + cDelimeter + cPortNumber + cDelimeter.
      RB-DB-CONNECTION = cNewConnString.
  END.

  RUN Carga-Impresion.
  /************************  PUNTEROS EN POSICION  *******************************/
  ASSIGN
      RB-BEGIN-PAGE = 1
      RB-END-PAGE   = 999999
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = 1.

  RB-PRINT-DESTINATION = "A".   /* Archivo */

  RUN aderb/_prntrb2(
                     RB-REPORT-LIBRARY,
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
                     RB-OTHER-PARAMETERS,
                     RB-STATUS-FILE
                     ).

  DEF VAR pEmailTo AS CHAR.
  DEF VAR pAttach  AS CHAR.
  DEF VAR pBody    AS CHAR.

  pAttach = s-print-file.
  pBody = s-print-file.
  RUN lib/d-sendmail ( 
      INPUT "",
      INPUT gn-clie.E-Mail, 
      INPUT "Estado de Cuenta",
      INPUT pAttach,
      INPUT pBody
      ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY x-FchDoc-2 RADIO-SET-pdf FILL-IN-pdf 
      WITH FRAME D-Dialog.
  IF AVAILABLE gn-clie THEN 
    DISPLAY gn-clie.CodCli gn-clie.NomCli 
      WITH FRAME D-Dialog.
  ENABLE RECT-62 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-eecc D-Dialog 
PROCEDURE imprime-eecc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-linea-credito AS CHAR.
DEFINE VAR x-credito-utilizado AS CHAR.
DEFINE VAR x-credito-disponible AS CHAR.

/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    /*AND w-report.llave-c = s-user-id*/ NO-LOCK)
        THEN DO:
        
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = "**BORRAR-LINEA**".        
        LEAVE.
    END.
END. 

SESSION:SET-WAIT-STATE('GENERAL').

RUN cargar-documentos.

SESSION:SET-WAIT-STATE('').

/* Code placed here will execute AFTER standard behavior.    */
GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
ASSIGN
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
RB-REPORT-NAME = 'eecc-clientes'       
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) + " and w-report.llave-c <> ''".

/* -- */
RUN get-linea-credito IN pHandle(OUTPUT x-linea-credito,OUTPUT x-credito-utilizado,OUTPUT x-credito-disponible).

FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                        gn-ven.codven = gn-clie.codven NO-LOCK NO-ERROR.


/*MESSAGE x-linea-credito x-credito-utilizado x-credito-disponible.*/

RB-OTHER-PARAMETERS = "s-nomcli = " + IF(AVAILABLE gn-clie) THEN gn-clie.nomcli ELSE " ".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-direccion = " + IF(AVAILABLE gn-clie) THEN gn-clie.dircli ELSE " ".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-hasta = " + STRING(TODAY,"99/99/9999").
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-ruc = " + IF(AVAILABLE gn-clie) THEN gn-clie.ruc ELSE " ".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-linea-credito = " + x-linea-credito.
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-credito-utilizado = " + x-credito-utilizado.
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-credito-disponible = " + x-credito-disponible.
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-telefono = 715-8888".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-fax = 715-8888".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-vendedor = " + IF(AVAILABLE gn-ven) THEN gn-ven.nomven ELSE "".
                              

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).


/* Borar el temporal */
SESSION:SET-WAIT-STATE('GENERAL').
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

SESSION:SET-WAIT-STATE('').

/**/
  DEFINE VAR x-user AS CHAR.
  x-user = USERID("DICTDB").
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'CONFIG-VTAS' AND
                            vtatabla.llave_c1 = "EE.CC-EN-PDF" AND 
                            vtatabla.llave_c2 = "RUTA" AND
                            vtatabla.llave_c3 = x-user EXCLUSIVE-LOCK NO-ERROR.

  IF NOT ERROR-STATUS:ERROR THEN DO:
      IF NOT AVAILABLE vtatabla THEN DO:
          CREATE vtatabla.
          ASSIGN vtatabla.codcia = s-codcia
                vtatabla.tabla = "CONFIG-VTAS"
                vtatabla.llave_c1 = "EE.CC-EN-PDF"
                vtatabla.llave_c2 = "RUTA"
                vtatabla.llave_c3 = x-user.
      END.
      ASSIGN vtatabla.llave_c4 = fill-in-pdf.
  END.
  RELEASE vtatabla NO-ERROR.



END PROCEDURE.

/*
o       Anticipos  (A/R*)
o       Letras por Aceptar (LET)
o       Letras en Descuento (LET)
o       Letra Aceptada en transito (LET)
o       Factura/Boletas de ventas (FAC,BOL,DCO)
o       Notas de Credito (N/C*)
o       Notas de Debito  (N/D*).

*/

/*
  RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
            " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
            " AND (ccbcdocu.flgest = 'P'" +
            " OR  ccbcdocu.flgest = 'J')" +
            " AND (ccbcdocu.coddoc = 'FAC*'" +
            " OR ccbcdocu.coddoc = 'BOL*'"+
            " OR ccbcdocu.coddoc = 'DCO*'"+
            " OR ccbcdocu.coddoc = 'LET*'" +
            " OR ccbcdocu.coddoc = 'N/C*'" +
            " OR ccbcdocu.coddoc = 'N/D*'" +
            " OR ccbcdocu.coddoc = 'A/R'" +
            " OR ccbcdocu.coddoc = 'BD'" +
            " OR ccbcdocu.coddoc = 'CHQ'" +
            " OR ccbcdocu.coddoc = 'A/C'" +
            " OR ccbcdocu.coddoc = 'CHC')".

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime D-Dialog 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Date-Format AS CHAR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'Carta Estado de Cuenta2'       
    RB-INCLUDE-RECORDS = 'O'.
  /*
  IF tg-dudosa THEN DO:
      IF NOT tg-letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +
                          " AND (ccbcdocu.coddoc = 'FAC'" +
                          " OR ccbcdocu.coddoc = 'BOL'"+
                          " OR ccbcdocu.coddoc = 'DCO'"+
                          " OR ccbcdocu.coddoc = 'LET'" +
                          " OR ccbcdocu.coddoc = 'N/C'" +
                          " OR ccbcdocu.coddoc = 'N/D'" +
                          " OR ccbcdocu.coddoc = 'A/R'" +
                          " OR ccbcdocu.coddoc = 'BD'" +
                          " OR ccbcdocu.coddoc = 'CHQ'" +
                          " OR ccbcdocu.coddoc = 'A/C'" +
                          " OR ccbcdocu.coddoc = 'CHC')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +                          
                          " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
  ELSE DO:
      IF NOT tg-Letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND (ccbcdocu.coddoc = 'FAC'" +
                    " OR ccbcdocu.coddoc = 'BOL'"+
                    " OR ccbcdocu.coddoc = 'DCO'"+
                    " OR ccbcdocu.coddoc = 'LET'" +
                    " OR ccbcdocu.coddoc = 'N/C'" +
                    " OR ccbcdocu.coddoc = 'N/D'" +
                    " OR ccbcdocu.coddoc = 'A/R'" +
                    " OR ccbcdocu.coddoc = 'A/C'" +
                    " OR ccbcdocu.coddoc = 'BD'" +
                    " OR ccbcdocu.coddoc = 'CHQ')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
  */
  RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
            " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
            " AND (ccbcdocu.flgest = 'P'" +
            " OR  ccbcdocu.flgest = 'J')" +
            " AND (ccbcdocu.coddoc = 'FAC'" +
            " OR ccbcdocu.coddoc = 'BOL'"+
            " OR ccbcdocu.coddoc = 'DCO'"+
            " OR ccbcdocu.coddoc = 'LET'" +
            " OR ccbcdocu.coddoc = 'N/C'" +
            " OR ccbcdocu.coddoc = 'N/D'" +
            " OR ccbcdocu.coddoc = 'A/R'" +
            " OR ccbcdocu.coddoc = 'BD'" +
            " OR ccbcdocu.coddoc = 'CHQ'" +
            " OR ccbcdocu.coddoc = 'A/C'" +
            " OR ccbcdocu.coddoc = 'CHC')".

    RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.              

  x-Date-Format = SESSION:DATE-FORMAT.
  SESSION:DATE-FORMAT = 'mdy'.
  RB-FILTER = RB-FILTER +
                " AND ccbcdocu.fchdoc >= " + STRING(x-FchDoc-1) +
                " AND ccbcdocu.fchdoc <= " + STRING(x-FChDoc-2).
  SESSION:DATE-FORMAT = x-Date-Format.
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
    x-FchDoc-1 = DATE(01,01,YEAR(TODAY))
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  DISABLE button-ruta WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "gn-clie"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

