&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

DEFINE VAR I-TPOREP AS INTEGER INIT 1.

/* Local Variable Definitions ---                                       */
def var tporep as integer.
def var subtit as character.
def var subdiv as character.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-40 RECT-41 RECT-44 F-Division x-docu ~
Cliented clienteH x-moneda t-cambio Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DESDIV F-Division x-docu x-nombre ~
Cliented d-clie clienteH h-clie x-moneda t-cambio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-docu AS CHARACTER FORMAT "X(3)":U 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE Cliented AS CHARACTER FORMAT "X(8)":U 
     LABEL "Del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE clienteH AS CHARACTER FORMAT "X(8)":U 
     LABEL "Al cliente" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE d-clie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE F-DESDIV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE h-clie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .85 NO-UNDO.

DEFINE VARIABLE t-cambio AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE x-moneda AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 27.57 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.86 BY 5.19.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.72 BY 2.81.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15.72 BY 8.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-DESDIV AT ROW 1.81 COL 22 COLON-ALIGNED NO-LABEL
     F-Division AT ROW 1.77 COL 13 COLON-ALIGNED
     x-docu AT ROW 2.69 COL 13 COLON-ALIGNED
     x-nombre AT ROW 2.73 COL 22 COLON-ALIGNED NO-LABEL
     Cliented AT ROW 3.96 COL 11.14 COLON-ALIGNED
     d-clie AT ROW 3.96 COL 22 COLON-ALIGNED NO-LABEL
     clienteH AT ROW 5 COL 11.29 COLON-ALIGNED
     h-clie AT ROW 4.96 COL 22 COLON-ALIGNED NO-LABEL
     x-moneda AT ROW 7.15 COL 19.43 NO-LABEL
     t-cambio AT ROW 8.08 COL 13.29 COLON-ALIGNED
     Btn_OK AT ROW 2.92 COL 50.57
     Btn_Cancel AT ROW 5.42 COL 50.57
     RECT-40 AT ROW 1.04 COL 1
     RECT-41 AT ROW 6.27 COL 1.14
     RECT-44 AT ROW 1.04 COL 48
     "   Ingrese parametros" VIEW-AS TEXT
          SIZE 16.14 BY .5 AT ROW 1.23 COL 2.29
     " Tipo Moneda" VIEW-AS TEXT
          SIZE 10.29 BY .5 AT ROW 7.15 COL 5
     SPACE(48.43) SKIP(1.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Ctas. x Cobrar por Antiguedad 15-30-60-90".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN d-clie IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DESDIV IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN h-clie IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nombre IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Ctas. x Cobrar por Antiguedad 15-30-60-90 */
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
  ASSIGN x-docu cliented clienteh  x-moneda  t-cambio.
  
  IF t-cambio <= 0 THEN DO:
     Message "Ingrese el Tipo de Cambio" view-as alert-box.
     APPLY "ENTRY":U to t-cambio.
     RETURN NO-APPLY.
  END.
  
  IF clienteh = "" THEN clienteh = "99999999".
  
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Cliented
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Cliented D-Dialog
ON LEAVE OF Cliented IN FRAME D-Dialog /* Del Cliente */
DO:
  IF Cliented:SCREEN-VALUE = "" THEN  RETURN.
  ASSIGN Cliented.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = cliented NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  d-clie:SCREEN-VALUE = gn-clie.nomcli.
  FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND 
             CcbcDocu.codcli = cliented NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbcDocu THEN DO:
     MESSAGE  "Cliente no tiene documentos pendientes" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clienteH
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clienteH D-Dialog
ON LEAVE OF clienteH IN FRAME D-Dialog /* Al cliente */
DO:
  IF ClienteH:SCREEN-VALUE = "" THEN  RETURN.
  ASSIGN ClienteH.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = ClienteH NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  d-clie:SCREEN-VALUE = gn-clie.nomcli.
  FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND 
             CcbcDocu.codcli = ClienteH NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbcDocu THEN DO:
     MESSAGE "Cliente no tiene documentos pendientes" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division D-Dialog
ON LEAVE OF F-Division IN FRAME D-Dialog /* Division */
DO:
    Find gn-divi where gn-divi.codcia = s-codcia and gn-divi.coddiv = F-Division:screen-value no-lock no-error.
    If available gn-divi then
        F-DesDiv:screen-value = gn-divi.desdiv.
    else
        F-DesDiv:screen-value = "".
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-docu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-docu D-Dialog
ON VALUE-CHANGED OF x-docu IN FRAME D-Dialog /* Documento */
DO:
  IF x-docu:screen-value <> "" THEN DO:
    Find first integral.ccbcdocu where integral.ccbcdocu.CodCia = s-codcia and 
                       ccbcdocu.coddoc = x-docu:screen-value No-Lock No-Error.
    IF not available ccbcdocu THEN DO:
        Message "Codigo de documento no existe" view-as alert-box.
        APPLY "ENTRY":U to x-docu.
        RETURN NO-APPLY.
    END.
    FIND facdocum where facdocum.codcia = s-codcia and
                        facdocum.coddoc = x-docu:screen-value no-lock no-error.
    IF AVAILABLE facdocum THEN
        x-nombre:screen-value = facdocum.nomdoc .
  END.
  ELSE DO:
   /* Message "Seleccione el Codigo de Documento" view-as alert-box.
    APPLY "ENTRY":U to x-docu.
    RETURN NO-APPLY.*/
    
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

DEFINE VAR XDOCINI AS CHAR.
DEFINE VAR XDOCFIN AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY F-DESDIV F-Division x-docu x-nombre Cliented d-clie clienteH h-clie 
          x-moneda t-cambio 
      WITH FRAME D-Dialog.
  ENABLE RECT-40 RECT-41 RECT-44 F-Division x-docu Cliented clienteH x-moneda 
         t-cambio Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato D-Dialog 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE F-Impor AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Saldo AS DECIMAL NO-UNDO.
 DEFINE VARIABLE F-Rango AS DECIMAL EXTENT 6 NO-UNDO.
 DEFINE VARIABLE F-Dias  AS INTEGER NO-UNDO.

 DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "PAG.  : " AT 118 PAGE-NUMBER(REPORT) AT 130 FORMAT "ZZ9" SKIP
        "* D-ANTXDC *" AT 1  "CUENTAS POR COBRAR POR ANTIGUEDAD 15-30-60-90+" AT 50 
        "FECHA : " AT 130 TODAY SKIP       
        SubDiv AT 62 FORMAT "X(30)" 
        {&PRN6A} + "HORA : " + {&PRN6B} AT 130 STRING(TIME,"HH:MM") SKIP
        "T.Cambio : " AT 1 string(T-Cambio,">9.9999") AT 15
        {&PRN6A} + SubTit + {&PRN6B} AT 55 FORMAT "X(32)" SKIP
/*
        "-------------------------------------------------- ------------------------------------------------------------------------------------------------- " SKIP
        "Tip   Numero     Fecha      Fecha         Importe                              (                         DIAS VENCIDOS                            )  " SKIP
        "Doc Documento  Documento   Vencmto.        Total          Saldo    Por Vencer         1-15         15-30         30-60        60-90          > 90    " SKIP
        "-------------------------------------------------- ------------------------------------------------------------------------------------------------- " SKIP
*/
        "-------------------------------------------------- -------------------------------------------------------" SKIP
        "Tip   Numero     Fecha      Fecha    (                         DIAS VENCIDOS                            ) " SKIP
        "Doc Documento  Documento   Vencmto.         1-15         15-30         30-60        60-90          > 90   " SKIP
        "-------------------------------------------------- -------------------------------------------------------" SKIP

        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.


 DEFINE FRAME F-Detalle
        CcbCDocu.CodDoc COLUMN-LABEL "Tip!Doc" FORMAT "X(3)"
        CcbCDocu.NroDoc COLUMN-LABEL "Numero de!Documento" FORMAT "XXX-XXXXXX"
        CcbCDocu.FchDoc COLUMN-LABEL "Fecha de!Documento"
        CcbCDocu.FchVto COLUMN-LABEL "Fecha de!Vencimient"
/*        F-Impor         COLUMN-LABEL "Importe!Total" FORMAT "(>>>>,>>9.99)"
 *         F-Saldo         COLUMN-LABEL "Saldo"         FORMAT "(>>>>,>>9.99)" 
 *         F-Rango[1]      COLUMN-LABEL "Por Vencer"    FORMAT "(>>>>,>>9.99)"*/
        F-Rango[2]      COLUMN-LABEL "Hace 15 Dias"  FORMAT "(>>>>,>>9.99)"
        F-Rango[3]      COLUMN-LABEL "15-30 Dias"    FORMAT "(>>>>,>>9.99)"
        F-Rango[4]      COLUMN-LABEL "30-60 Dias"    FORMAT "(>>>>,>>9.99)"
        F-Rango[5]      COLUMN-LABEL "60-90 Dias"    FORMAT "(>>>>,>>9.99)"
        F-Rango[6]      COLUMN-LABEL " > 90 Dias"    FORMAT "(>>>>,>>9.99)"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.
  
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.

 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN4}.

 FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-codcia     
                    AND  CcbCDocu.coddoc BEGINS x-docu  
                    AND  CcbCDocu.codcli >= clienteD    
                    AND  CcbCDocu.codcli <= clienteH    
                    AND  CcbCDocu.flgest = "P"          
                    AND  CcbCDocu.FchVto <= TODAY
                    AND  CcbCDocu.CodDiv BEGINS F-Division
                BREAK BY CcbCDocu.CodCia
                      BY CcbCDocu.CodCli
                      BY CcbCDocu.coddoc
                      BY CcbCDocu.nrodoc:
     VIEW STREAM REPORT FRAME F-Titulo.
     IF FIRST-OF(CcbCDocu.CodCli) THEN DO:
        PUT STREAM REPORT 
            SKIP(1)
            {&PRN6A} + "Cliente : " AT 1 FORMAT "X(15)" CcbCDocu.codcli FORMAT "X(12)" CcbCDocu.NomCli + {&PRN6B} FORMAT "X(60)" SKIP(1).
     END.
     F-Impor = CcbCDocu.ImpTot.
     F-Saldo = CcbCDocu.SdoAct.
     IF X-Moneda = 1 AND CcbCDocu.codmon = 2 THEN DO:
        ASSIGN F-Impor = (CcbCDocu.imptot) * t-cambio
               F-Saldo   = (CcbCDocu.sdoact) * t-cambio.
     END.
     IF X-Moneda = 2 AND CcbCDocu.CodMon = 1 THEN DO:
        ASSIGN F-Impor = CcbCDocu.ImpTot / t-cambio
               F-Saldo   = CcbCDocu.SdoAct / t-cambio.
     END.
     FIND FacDocum WHERE FacDocum.codcia = S-CODCIA AND
          FacDocum.CodDoc = CcbCDocu.coddoc NO-LOCK NO-ERROR.
     IF AVAILABLE FacDocum AND NOT FacDocum.TpoDoc THEN
        ASSIGN F-Impor = F-Impor * -1
               F-Saldo = F-Saldo * -1.
     F-Rango[1] = 0.
     F-Rango[2] = 0.
     F-Rango[3] = 0.
     F-Rango[4] = 0.
     F-Rango[5] = 0.
     F-Rango[6] = 0.
     IF CcbCDocu.FchVto >= TODAY THEN F-Rango[1] = F-Impor.
     ELSE DO:
         F-DIAS = TODAY - CcbCDocu.FchVto.
         IF F-DIAS > 90 THEN                 F-Rango[6] = F-Saldo. /* 90-mas */
         IF F-DIAS > 60 AND F-DIAS < 91 THEN F-Rango[5] = F-Saldo. /* 61-90  */
         IF F-DIAS > 30 AND F-DIAS < 61 THEN F-Rango[4] = F-Saldo. /* 31-60  */
         IF F-DIAS > 15 AND F-DIAS < 31 THEN F-Rango[3] = F-Saldo. /* 15-30  */
         IF F-DIAS > 0  AND F-DIAS < 16 THEN F-Rango[2] = F-Saldo. /*  0-15  */
     END.
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc
             CcbCDocu.NroDoc
             CcbCDocu.FchDoc
             CcbCDocu.FchVto
/*             F-Impor    WHEN    F-Impor <> 0
 *              F-Saldo    WHEN    F-Saldo <> 0
 *              F-Rango[1] WHEN F-Rango[1] <> 0*/
             F-Rango[2] WHEN F-Rango[2] <> 0
             F-Rango[3] WHEN F-Rango[3] <> 0
             F-Rango[4] WHEN F-Rango[4] <> 0
             F-Rango[5] WHEN F-Rango[5] <> 0
             F-Rango[6] WHEN F-Rango[6] <> 0
             WITH FRAME F-Detalle.
            
     ACCUMULATE F-Impor    (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Saldo    (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[1] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[2] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[3] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[4] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[5] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[6] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Impor    (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Saldo    (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[1] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[2] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[3] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[4] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[5] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[6] (SUB-TOTAL BY CcbCDocu.CodCli).
     
     IF LAST-OF(CcbCDocu.CodCli) THEN DO:
        UNDERLINE STREAM REPORT 
/*                  F-Impor        
 *                   F-Saldo        
 *                   F-Rango[1]     */
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                " TOTAL  >>"   @ CcbCDocu.FchVto    
/*                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Impor    @ F-Impor 
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Saldo    @ F-Saldo 
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[1] @ F-Rango[1]*/
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[2] @ F-Rango[2]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[3] @ F-Rango[3]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[4] @ F-Rango[4]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[5] @ F-Rango[5]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[6] @ F-Rango[6]
                WITH FRAME F-Detalle.
        DOWN STREAM REPORT WITH FRAME F-Detalle.
     END.
     IF LAST-OF(CcbCDocu.CodCia) THEN DO:
        UNDERLINE STREAM REPORT 
/*                  F-Impor        
 *                   F-Saldo        
 *                   F-Rango[1]     */
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                "     TOTAL"   @ CcbCDocu.FchDoc
                "GENERAL >>"   @ CcbCDocu.FchVto
/*                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Impor    @ F-Impor
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Saldo    @ F-Saldo
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[1] @ F-Rango[1]*/
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[2] @ F-Rango[2]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[3] @ F-Rango[3]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[4] @ F-Rango[4]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[5] @ F-Rango[5]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[6] @ F-Rango[6]
                WITH FRAME F-Detalle.
        UNDERLINE STREAM REPORT 
/*                  F-Impor        
 *                   F-Saldo        
 *                   F-Rango[1]     */
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6] WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
     END.
 END.
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir D-Dialog 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF F-Division = "" THEN  subdiv = "".
   ELSE  subdiv = "Division : " + F-Division.
       
   IF X-Moneda = 1 THEN subtit = "(Importes Expresados en Soles )" .
   ELSE subtit = "(Importes Expresados en Dolares)" .

   RUN bin/_prnctr.p.
   IF s-salida-impresion = 0 THEN RETURN.
   
   /* Captura parametros de impresion */
   /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
   RUN aderb/_prlist.p(
       OUTPUT s-printer-list,
       OUTPUT s-port-list,
       OUTPUT s-printer-count).
   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
   s-port-name = REPLACE(S-PORT-NAME, ":", "").
   
   IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   
   RUN Formato.
  
   CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
   END CASE. 
   
   DELETE FROM W-REPORT WHERE w-report.Task-No = S-TASK-NO.

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
    DEF VAR xx as logical.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
  /* Code placed here will execute AFTER standard behavior.    */
    
    FOR EACH facdocum with frame {&FRAME-NAME} :
         xx = x-docu:add-last(facdocum.coddoc).
    END.
    
    F-Division:screen-value = S-CODDIV.
    FIND GN-DIVI WHERE S-CODDIV = GN-DIVI.CodDiv AND S-CODCIA = GN-DIVI.CodCia.
    IF AVAILABLE GN-DIVI THEN F-DesDiv:screen-value = GN-DIVI.DesDiv.
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


