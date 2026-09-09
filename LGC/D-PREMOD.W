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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE. 

/* Parameters Definitions ---                                           

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "lgc\rblgc.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Precios Modificados".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".      */

/* Definimos Variables de impresoras */
DEFINE VARIABLE s-printer-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name AS CHAR format "x(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.




/* Local Variable Definitions ---                                       */
DEFINE VAR sub-tit AS CHARACTER.
DEFINE VAR X-TIPO AS DECIMAL.
DEFINE VAR I-NroItm AS INTEGER.
DEFINE VAR X-SOL AS DECIMAL.
DEFINE VAR X-DOL AS DECIMAL.
DEFINE VAR T-SOLES AS DECIMAL.
DEFINE VAR T-DOLAR AS DECIMAL.
DEFINE VAR FAMILIA AS CHARACTER.
DEFINE VAR SUBFAMI AS CHARACTER.
DEFINE VAR marca AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 fechad fechah Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS fechad fechah 

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
     SIZE 12 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.69
     BGCOLOR 8 .

DEFINE VARIABLE fechad AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81 NO-UNDO.

DEFINE VARIABLE fechah AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.72 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     fechad AT ROW 3.04 COL 9.29 COLON-ALIGNED
     fechah AT ROW 3.08 COL 30.14 COLON-ALIGNED
     Btn_OK AT ROW 1.65 COL 50
     Btn_Cancel AT ROW 4.08 COL 50
     RECT-1 AT ROW 1.62 COL 2.72
     "Ingrese rango de fechas" VIEW-AS TEXT
          SIZE 17.86 BY .5 AT ROW 1.35 COL 3.57
          BGCOLOR 1 FGCOLOR 15 
     SPACE(40.99) SKIP(4.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Catalogo de Precios Modificados".


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
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

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
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Catalogo de Precios Modificados */
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
  ASSIGN fechad fechah.
          
  IF fechah < fechad THEN DO:
  MESSAGE "Rango de Fecha mal ingresado " view-as alert-box.
  APPLY "ENTRY":U  TO fechah.
  RETURN NO-APPLY.
  END. 
  
  FIND first ALMMMATG WHERE ALMMMATG.CODCIA = S-CODCIA AND
                      ALMMMATG.FchmPre[3] >= FECHAD AND 
                      ALMMMATG.FchmPre[3] <= FECHAH NO-LOCK NO-ERROR.  
  IF AVAILABLE ALMMMATG THEN 
    RUN CONFIGURA-IMPRESORA.
  ELSE DO:
    MESSAGE "No hay precios modificados" VIEW-AS ALERT-BOX.
    APPLY "ENTRY":U  TO fechah.
    RETURN NO-APPLY.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Configura-impresora D-Dialog 
PROCEDURE Configura-impresora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN imprimir.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  DISPLAY fechad fechah 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 fechad fechah Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrMOD
    HEADER
    SKIP(2)
    "TAI HENG S.A." SKIP(2)
    "CATALOGO PRECIOS MODIFICADOS" at 35 "DEL " fechad space(2) "AL " fechah 
    "Fecha  : " at 110 today  format "99/99/9999" SKIP(2) 
    "Tipo de Cambio: " at 3 X-TIPO skip
    "----------------------------------------------------------------------------------------------------------------------------------------------------" skip
    "     Familia                  Marca          Sub-familia                                                                             I m p o r t e   "  SKIP
    "                                                 Fch.Cambio   Articulo                                                Unidad       Soles     Dolares" skip   
    "-----------------------------------------------------------------------------------------------------------------------------------------------------" skip

/*  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890  */
/*            1         2         3         4         5         6         7         8         9         10        11        12        13        14        15 */    
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO DOWN WIDTH 200. 
   
DEFINE FRAME F-DetaMOD
    Almmmatg.codfam    
    FAMILIA format "x(25)"  space(2)
    Marca format "x(15)"  
    Almmmatg.subfam AT 46
    SUBFAMI  format "x(35)" 
    Almmmatg.fchmpre[3] AT 50 space(2)
    Almmmatg.codmat AT 63 space(3)
    Almmmatg.desmat format "x(45)" SPACE(4)
    Almmmatg.undstk space(2) 
    x-sol FORMAT ">>>,>>9.99" 
    x-dol FORMAT ">>>,>>9.99"
    WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

/*MLR* 27/11/07 ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/


/*********** Seleccion de datos para el reporte *******************/
PUT CONTROL CHR(27) "@".
PUT CONTROL CHR(27) "C" CHR(66).
PUT CONTROL CHR(27) CHR(120) 0.
PUT CONTROL CHR(15).

 FIND FACCFGGN WHERE FACCFGGN.CODCIA = S-CODCIA NO-LOCK NO-ERROR.
 IF AVAILABLE FACCFGGN THEN
    X-TIPO = FACCFGGN.TPOCMB[1].

 FOR EACH ALMMMATG WHERE ALMMMATG.CODCIA = S-CODCIA AND
                      ALMMMATG.FchmPre[3] >= FECHAD AND 
                      ALMMMATG.FchmPre[3] <= FECHAH
                      BREAK BY ALMMMATG.codCIA
                            BY ALMMMATG.CODFAM
                            BY ALMMMATG.CODMAR 
                            BY ALMMMATG.SUBFAM
                            BY ALMMMATG.DESMAT :
    VIEW FRAME F-HdrMOD.
    IF FIRST-OF (ALMMMATG.CODFAM) THEN DO:
        FIND FIRST ALMTFAMI WHERE ALMTFAMI.CODFAM = ALMMMATG.CODFAM NO-LOCK NO-ERROR.
        IF  AVAILABLE ALMTFAMI THEN
            DISPLAY  ALMMMATG.CODFAM ALMTFAMI.DESFAM @ FAMILIA WITH FRAME F-DetaMOD.
            DOWN WITH FRAME F-DetaMOD.
    END.    

    IF FIRST-OF (ALMMMATG.codmar) THEN DO:
        DISPLAY ALMMMATG.desmar @ marca WITH FRAME F-DetaMOD.
        DOWN WITH FRAME F-DetaMOD.
    END.
    
    IF FIRST-OF (ALMMMATG.subfam) THEN DO:
        FIND ALMSFAMI WHERE ALMSFAMI.CODFAM = ALMTFAMI.CODFAM AND
                            ALMSFAMI.SUBFAM = ALMMMATG.SUBFAM NO-LOCK NO-ERROR.
        IF AVAILABLE ALMSFAMI THEN 
            DISPLAY ALMMMATG.SUBFAM ALMSFAMI.DESSUB @ SUBFAMI WITH FRAME F-DetaMOD.
            DOWN WITH FRAME F-DetaMOD.
    END.
    x-sol = 0.00 .
    x-dol = 0.00 .

    IF MONVTA = 1 THEN DO:
        X-SOL = ALMMMATG.PREVTA[1].
        X-DOL = ALMMMATG.PREVTA[1] / X-TIPO.
        t-soles = t-soles + ALMMMATG.PREVTA[1].
        t-soles = t-dolar + ALMMMATG.PREVTA[1].
    END.
    IF MONVTA = 2 THEN DO:
        X-DOL = ALMMMATG.PREVTA[1].
        X-SOL = ALMMMATG.PREVTA[1] * X-TIPO.
        t-dolar = t-dolar + ALMMMATG.PREVTA[1].
    END.
   DISPLAY  ALMMMATG.FCHMPRE[3] 
            ALMMMATG.CODMAT   
            ALMMMATG.DESMAT
            ALMMMATG.UNDSTK
            X-SOL 
            X-DOL 
          WITH FRAME F-DetaMOD.
          IF LAST-OF(ALMMMATG.codcia) THEN
          PAGE.
 END.
/*MLR* 27/11/07 ***
OUTPUT CLOSE.
* ***/
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

 ASSIGN
    FechaD:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY)
    fechaH:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
    
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


