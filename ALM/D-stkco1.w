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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
DEFINE BUFFER T-MATE FOR Almmmate.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-46 TipoStk F-CodFam F-SubFam ~
DesdeC HastaC Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS TipoStk F-CodFam F-SubFam F-DesFam ~
F-DesSub DesdeC HastaC F-DesMatD F-DesMatH 

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
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(2)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesMatD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesMatH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Fam" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE TipoStk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Articulos con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 41.43 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 1.08.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 2.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     TipoStk AT ROW 6.31 COL 4.14 NO-LABEL
     F-CodFam AT ROW 1.31 COL 7.14 COLON-ALIGNED
     F-SubFam AT ROW 2.19 COL 7.14 COLON-ALIGNED
     F-DesFam AT ROW 1.27 COL 13 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.19 COL 13 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 4.04 COL 9.43 COLON-ALIGNED
     HastaC AT ROW 5 COL 9.43 COLON-ALIGNED
     Btn_OK AT ROW 7.69 COL 17.86
     F-DesMatD AT ROW 4.04 COL 20.72 COLON-ALIGNED NO-LABEL
     F-DesMatH AT ROW 5 COL 20.86 COLON-ALIGNED NO-LABEL
     Btn_Cancel AT ROW 7.69 COL 34.72
     RECT-14 AT ROW 6.15 COL 1.43
     RECT-46 AT ROW 3.35 COL 1.43
     "Articulos" VIEW-AS TEXT
          SIZE 9.29 BY .65 AT ROW 3.19 COL 2.86
          FONT 1
     SPACE(49.41) SKIP(6.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Stock Consolidado".


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

/* SETTINGS FOR FILL-IN F-DesFam IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesMatD IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesMatH IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME D-Dialog
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

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Stock Consolidado */
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
  ASSIGN DesdeC HastaC TipoStk F-CodFam F-SubFam.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ F-DesMatD WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam D-Dialog
ON LEAVE OF F-CodFam IN FRAME D-Dialog /* Familia */
DO:
   ASSIGN F-CodFam.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND
        Almtfami.codfam = F-CodFam NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam D-Dialog
ON LEAVE OF F-SubFam IN FRAME D-Dialog /* Sub-Fam */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA AND
        AlmSFami.codfam = F-CodFam AND
        AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN 
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ F-DesMatH WITH FRAME {&FRAME-NAME}.
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
  DISPLAY TipoStk F-CodFam F-SubFam F-DesFam F-DesSub DesdeC HastaC F-DesMatD 
          F-DesMatH 
      WITH FRAME D-Dialog.
  ENABLE RECT-14 RECT-46 TipoStk F-CodFam F-SubFam DesdeC HastaC Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  
  DEFINE FRAME F-REPORTE
         Almmmate.codmat AT 3
         Almmmatg.desmat AT 12
         Almmmatg.undstk AT 65 
         Almmmate.codalm AT 72 
         AlmmmatE.stkact AT 80 FORMAT '->>>,>>>,>>9.999'
         F-PESALM        FORMAT ">>>>,>>>,>>9.99"
         F-TOTAL         FORMAT '>>>>>>9.999'
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn3} FORMAT "X(50)" AT 1 SKIP
         "STOCK CONSOLIDADO" AT 45 FORMAT 'X(40)'
         "Pagina :" TO 114 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         "Al " AT 47 TODAY FORMAT '99/99/9999' 
         "Fecha :" TO 114 TODAY TO 126 FORMAT "99/99/9999" SKIP
         "Hora :"  TO 114 STRING(TIME,"HH:MM") TO 126 SKIP
         IF TipoStk = 1 THEN "Solo materiales con stock" ELSE "Todos los productos" FORMAT 'X(40)' SKIP
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                               UND     COD               STOCK           PESO        STOCK    " SKIP
         "  CODIGO          DESCRIPCION                                  STK     ALM                ALM            KILOS      GENERAL   " SKIP
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  
  IF HastaC = "" THEN HastaC = "999999".
  FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                     AND  Almmmate.CodMat >= DesdeC 
                     AND  Almmmate.CodMat <= HastaC,
           EACH Almmmatg OF Almmmate 
                    WHERE Almmmatg.codfam BEGINS F-CodFam 
                     AND  Almmmatg.subfam BEGINS F-SubFam 
                    NO-LOCK
                    BREAK BY Almmmate.codcia 
                          BY Almmmatg.CodFam 
                          BY Almmmatg.Subfam 
                          BY Almmmate.Codmat:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmate.codmat
                 Almtfami.desfam @ Almmmatg.DesMat 
                 WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = Almmmatg.CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almsfami.subfam @ Almmmate.codmat
                 AlmSFami.dessub @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
         END.
      END.
      F-TOTAL = 0.
      FOR EACH T-MATE WHERE T-MATE.codcia = s-codcia 
                       AND  T-MATE.Codmat = Almmmate.codmat 
                      NO-LOCK:
          F-TOTAL = F-TOTAL + Almmmate.stkact.
      END.        
      IF TipoStk = 1 AND F-TOTAL = 0 THEN NEXT.
      F-TOTAL = 0.
      IF FIRST-OF(Almmmate.codmat) THEN DO:
         DISPLAY STREAM REPORT 
            Almmmate.codmat 
            Almmmatg.desmat 
            Almmmatg.undstk 
            WITH FRAME F-REPORTE.
         F-STKGEN = 0.
      END.
      F-STKGEN = F-STKGEN + Almmmate.stkact.
      F-PESALM = Almmmatg.Pesmat * Almmmate.stkact.
      IF LAST-OF(Almmmate.codmat) THEN F-TOTAL = F-STKGEN.
      DISPLAY STREAM REPORT
         Almmmate.codalm
         Almmmate.stkact 
         F-PESALM
         F-TOTAL WHEN F-TOTAL > 0  
         WITH FRAME F-REPORTE.
  END.
  PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------".
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
   
  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

  CASE s-salida-impresion:
/*       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file).*/
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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


