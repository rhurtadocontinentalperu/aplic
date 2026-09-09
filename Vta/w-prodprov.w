&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR CANT AS INTEGER.

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


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE almmmatg.codcia
    FIELD t-coddoc  LIKE ccbcdocu.coddoc
    FIELD t-coddiv  LIKE ccbcdocu.coddiv
    FIELD t-candes  LIKE ccbddocu.candes
    FIELD t-factor  LIKE ccbddocu.factor
    FIELD t-codmat  LIKE ccbddocu.codmat
    FIELD t-desmat  LIKE almmmatg.desmat
    FIELD t-codmar  LIKE almmmatg.codmar
    FIELD t-desmar  LIKE almmmatg.desmar
    FIELD t-codpr1  LIKE almmmatg.codpr1
    FIELD t-undbas  LIKE almmmatg.undbas
    FIELD t-codpro  LIKE gn-prov.codpro
    FIELD t-nompro  LIKE gn-prov.nompro.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS HastaF DesdeF F-DIVISION BUTTON-6 F-prov1 ~
BUTTON-4 Btn_OK Btn_Cancel cbo-doc 
&Scoped-Define DISPLAYED-OBJECTS HastaF DesdeF F-DIVISION F-prov1 cbo-doc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 4" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE cbo-doc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "FAC","BOL","TCK" 
     DROP-DOWN-LIST
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     HastaF AT ROW 2.15 COL 22.43 COLON-ALIGNED
     DesdeF AT ROW 2.19 COL 9 COLON-ALIGNED
     F-DIVISION AT ROW 3.69 COL 9 COLON-ALIGNED
     BUTTON-6 AT ROW 3.69 COL 22.72
     F-prov1 AT ROW 4.46 COL 9 COLON-ALIGNED
     BUTTON-4 AT ROW 4.46 COL 22.57
     Btn_OK AT ROW 4.85 COL 37
     Btn_Cancel AT ROW 4.85 COL 48.29
     cbo-doc AT ROW 5.42 COL 9 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.43 BY 6.15
         FONT 4.


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
         TITLE              = "Proveedor x Producto"
         HEIGHT             = 6.15
         WIDTH              = 62.43
         MAX-HEIGHT         = 6.15
         MAX-WIDTH          = 62.43
         VIRTUAL-HEIGHT     = 6.15
         VIRTUAL-WIDTH      = 62.43
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

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Proveedor x Producto */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Proveedor x Producto */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
assign desdef hastaf f-division f-prov1 cbo-doc.
  RUN Asigna-Variables.
  /*IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-provee02.r("Proveedores").
    IF output-var-2 <> ? THEN DO:
        F-PROV1 = output-var-2.
        DISPLAY F-PROV1.
        APPLY "ENTRY" TO F-PROV1 .
        RETURN NO-APPLY.

    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
/*DO:
 *  DO WITH FRAME {&FRAME-NAME}:
 * 
 *  ASSIGN F-DIVISION.
 *  IF F-DIVISION = "" AND ( LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0 ) THEN DO:
 *      SELF:SCREEN-VALUE = "".
 *      ENABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.  
 *      F-DIVISION-1 = "00001" .
 *      F-DIVISION-2 = "00002" .
 *      F-DIVISION-3 = "00003" .
 *      F-DIVISION-4 = "00000" .
 *      F-DIVISION-5 = "00005" .
 *      F-DIVISION-6 = "00006" .
 *      DISPLAY F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 .
 *      RUN local-initialize.
 *      RETURN.
 *  END.
 * 
 *  IF F-DIVISION <> "" THEN DO:
 *         
 *         FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
 *                            Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
 *         IF NOT AVAILABLE Gn-Divi THEN DO:
 *             MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
 *                     "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
 *             APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
 *             RETURN NO-APPLY.
 *         END.    
 *         IF  LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0  THEN DO:                         
 *             F-DIVISION-1 = F-DIVISION .
 *             F-NOMDIV-1 = Gn-Divi.DesDiv.           
 *             F-DIVISION-2 = "" .
 *             F-DIVISION-3 = "" .
 *             F-DIVISION-4 = "" .
 *             F-DIVISION-5 = "" .
 *             F-DIVISION-6 = "" .
 *             F-NOMDIV-2   = "".
 *             F-NOMDIV-3   = "".
 *             F-NOMDIV-4   = "".
 *             F-NOMDIV-5   = "".
 *             F-NOMDIV-6   = "".
 *             DISPLAY F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 
 *                     F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 
 *                     WITH FRAME {&FRAME-NAME}.
 *             DISABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.
 *         END.
 *       
 *   END.
 *  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN    desdef
            hastaf
            f-division
            f-prov1
            cbo-doc.
end.            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH tmp-tempo:
    DELETE tmp-tempo.
  END.

for each ccbcdocu where ccbcdocu.codcia = s-codcia and
                                ccbcdocu.coddiv = f-division and
                                ccbcdocu.coddoc = cbo-doc and
                                ccbcdocu.fchdoc >= desdef and
                                ccbcdocu.fchdoc <= hastaf and
                                ccbcdocu.flgest <> 'A' no-lock,
    each ccbddocu of ccbcdocu no-lock,
    
    first almmmatg of ccbddocu where almmmatg.codpr1 begins f-prov1 no-lock,
        first gn-prov where gn-prov.codcia = pv-codcia AND gn-prov.codpro = almmmatg.codpr1 no-lock:
    find tmp-tempo where t-codcia = s-codcia and
                         t-codpro = gn-prov.codpro and
                         t-codmat = almmmatg.codmat exclusive-lock no-error.  
    if not available tmp-tempo 
    then create tmp-tempo.
    assign  
        tmp-tempo.t-codcia  = s-codcia
        tmp-tempo.t-codpro  = gn-prov.codpro
        tmp-tempo.t-nompro  = gn-prov.nompro
        tmp-tempo.t-codmat  = almmmatg.codmat
        tmp-tempo.t-desmat  = almmmatg.desmat
        tmp-tempo.t-desmar  = almmmatg.desmar
        tmp-tempo.t-undbas  = almmmatg.undbas
        tmp-tempo.t-candes  = tmp-tempo.t-candes + (ccbddocu.candes * ccbddocu.factor).
end.
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
  DISPLAY HastaF DesdeF F-DIVISION F-prov1 cbo-doc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE HastaF DesdeF F-DIVISION BUTTON-6 F-prov1 BUTTON-4 Btn_OK Btn_Cancel 
         cbo-doc 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
DEFINE VARIABLE X-TEL     AS CHAR INIT "349-0114" format "X(8)".
DEFINE VARIABLE X-EMP     AS CHAR INIT "CONTINENTAL S.A.C" format "X(18)".
DEFINE VARIABLE X-DIR     AS CHAR INIT "CL. RENNE DESCARTES MZ-C LT-1 LIMA-03" format "X(50)".
run carga-temporal.
  DEFINE FRAME F-cab
         tmp-tempo.t-codmat
         tmp-tempo.t-desmat  
         tmp-tempo.t-desmar    
         tmp-tempo.t-undbas
         tmp-tempo.t-candes

        WITH WIDTH 150 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         
         "EMPRESA  :  " X-EMP       "   R.U.C. :  " AT 40  X-Ruc  SKIP
         "DIRECCION:  " X-DIR       " Telefono :  " AT 40  X-TEL 
         "Pag.  : " AT 90 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 90 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
"------------------------------------------------------------------------------------------------------------" SKIP
"Codigo   Descripcion                                 Descripcion                                            " SKIP
"Material Material                                    Marca                         Unidad      Cantidad     " SKIP
"------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 150 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  VIEW STREAM REPORT FRAME H-REP.


for each tmp-tempo break BY tmp-tempo.t-codpro BY tmp-tempo.t-codmat :

    DISPLAY STREAM REPORT WITH FRAME F-CAB.
                  
  IF FIRST-OF(tmp-tempo.t-codpro) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  tmp-tempo.t-codpro " " tmp-tempo.t-nompro   SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
  END.
                  
                DISPLAY STREAM REPORT
                    tmp-tempo.t-codmat
                    tmp-tempo.t-desmat  
                    tmp-tempo.t-desmar    
                    tmp-tempo.t-undbas
                    tmp-tempo.t-candes 
                  WITH FRAME F-cab.   

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.
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
assign
    desdef = today
    hastaf = today.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

