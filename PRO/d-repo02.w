&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

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

/*******/

/* Local Variable Definitions ---                                       */
DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
DEFINE VAR x-titulo3 AS CHAR NO-UNDO.
DEFINE VAR x-titulo4 AS CHAR NO-UNDO.
DEFINE VAR x-titulo5 AS CHAR NO-UNDO.
DEFINE VAR x-tipmov  AS CHAR NO-UNDO.
DEFINE VAR x-desmat  AS CHAR NO-UNDO.
DEFINE VAR x-desmar  AS CHAR NO-UNDO.
DEFINE VAR x-flgest  AS CHAR NO-UNDO.
DEFINE VAR X-Movi    AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-60 RECT-62 i-CodMov desdeF hastaF ~
Btn_OK Btn_Cancel F-AlmDes 
&Scoped-Define DISPLAYED-OBJECTS c-TipMov i-CodMov desdeF hastaF F-NomDes ~
N-MOVI F-AlmDes 

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

DEFINE VARIABLE i-CodMov AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE c-TipMov AS CHARACTER FORMAT "X(256)":U INITIAL "Ingreso" 
     LABEL "Tipo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proc/Dest" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.14 BY 4.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-TipMov AT ROW 2.54 COL 8 COLON-ALIGNED
     i-CodMov AT ROW 2.54 COL 19 COLON-ALIGNED NO-LABEL
     desdeF AT ROW 1.58 COL 8 COLON-ALIGNED
     hastaF AT ROW 1.58 COL 26.72 COLON-ALIGNED
     Btn_OK AT ROW 5.46 COL 15.57
     Btn_Cancel AT ROW 5.46 COL 37.43
     F-NomDes AT ROW 3.69 COL 14.72 COLON-ALIGNED NO-LABEL
     N-MOVI AT ROW 2.54 COL 26 COLON-ALIGNED NO-LABEL
     F-AlmDes AT ROW 3.69 COL 8 COLON-ALIGNED
     RECT-60 AT ROW 5.35 COL 1.57
     RECT-62 AT ROW 1.08 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
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
         TITLE              = "Productos con Costo Cero"
         HEIGHT             = 6.27
         WIDTH              = 54.43
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-TipMov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Productos con Costo Cero */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Productos con Costo Cero */
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
  ASSIGN C-TipMov DesdeF HastaF I-CodMov F-Almdes.
  CASE C-tipmov:
       WHEN "Ingreso" THEN X-Tipmov = "I".
       WHEN "Salida"  THEN X-Tipmov = "S".
  END.

  IF I-CODMOV <> 0 THEN DO:
        FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                            Almtmovm.tipmov = X-TIPMOV AND
                            Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
        IF AVAILABLE Almtmovm THEN
        assign N-MOVI:screen-value = Almtmovm.Desmov.
        ELSE DO:
            MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO I-Codmov.
            RETURN "ADM-ERROR".   
        END.
  END.
  ELSE  X-CODMOV = "".
  
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-AlmDes W-Win
ON LEAVE OF F-AlmDes IN FRAME F-Main /* Proc/Dest */
DO:
  
  ASSIGN F-Almdes.
  IF F-Almdes = "" THEN DO:
     F-NomDes:SCREEN-VALUE = "". 
     RETURN.
  END.
  IF F-Almdes = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND  
                     Almacen.CodAlm = F-AlmDes
                     NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen no existe......." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-CodMov W-Win
ON VALUE-CHANGED OF i-CodMov IN FRAME F-Main
DO:
  FIND Almtmovm WHERE Almtmov.codcia = s-codcia
    AND Almtmovm.tipmov = x-TipMov
    AND Almtmovm.codmov = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN n-Movi:SCREEN-VALUE = Almtmovm.Desmov.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes.

  CASE C-TipMov:
     WHEN 'Ingreso' THEN ASSIGN
           X-Tipmov = "I".
     WHEN 'Salida'  THEN ASSIGN
           X-Tipmov = "S".
  END CASE.

  x-titulo2 = 'Del ' + STRING(DesdeF, '99/99/9999') + ' Al ' + STRING(HastaF, '99/99/9999').
  x-titulo1 = 'ANALISIS DE MOVIMIENTOS POR ARTICULO'.
  x-titulo3 = "".
  x-titulo4 = "Movimiento  : " + X-tipmov + STRING(I-Codmov,"99") + Almtmovm.Desmov .
  x-titulo5 = "Proc/Destino: " + F-AlmDes + " " + F-NomDes:SCREEN-VALUE.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY c-TipMov i-CodMov desdeF hastaF F-NomDes N-MOVI F-AlmDes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-60 RECT-62 i-CodMov desdeF hastaF Btn_OK Btn_Cancel F-AlmDes 
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
  DEF VAR x-Importe AS DEC NO-UNDO.
  DEF VAR x-ImpTot  AS DEC NO-UNDO.
  DEF VAR x-CanDes  AS DEC NO-UNDO.

  DEFINE FRAME F-REP
         Almdmov.CodAlm  
         Almdmov.Nrodoc  
         Almdmov.AlmOri  FORMAT "X(5)"  
         Almdmov.FchDoc  FORMAT "99/99/9999"
         Almcmov.NomRef  FORMAT 'X(35)'
         Almcmov.Nrorf1  
         Almcmov.Usuario 
         Almdmov.CodUnd  
         Almdmov.CanDes  FORMAT "(>,>>>,>>9.99)"
         Almdmov.PreUni  FORMAT "(>,>>>,>>9.9999)" 
/*         x-Importe       FORMAT "(>,>>>,>>9.99)"*/
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  DEFINE FRAME F-Quiebre
        "MATERIAL:" Almdmov.codmat Almmmatg.desmat 
        WITH WIDTH 250 NO-BOX NO-LABELS STREAM-IO DOWN.

  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         x-titulo1 AT 45 FORMAT "X(40)"
         "Pag.  : " AT 115 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Desde : " AT 045 STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
         "Fecha : " AT 115 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
         x-titulo3 FORMAT "X(80)" SKIP
         x-titulo4 FORMAT "X(80)" SKIP
         x-titulo5 FORMAT "X(80)" SKIP
         "VALORIZADO AL COSTO PROMEDIO EN MONEDA NACIONAL" SKIP
         "--------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Alm NroDoc Proc/Dest Fecha       R e f e r e n c i a s                      Usuario  Unid        Cantidad        Costo Unitario " SKIP
         "--------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
          123 123456 12345 99/99/9999 12345678901234567890123456789012345 1234567890 1234567890 1234567890 (>,>>>,>>9.99) (>,>>>,>>9.9999) (>,>>>,>>9.99)
*/

        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

    FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = S-CODCIA AND  
                                      Almdmov.CodAlm = s-CodAlm AND
                                      Almdmov.FchDoc >= DesdeF  AND  
                                      Almdmov.FchDoc <= HastaF  AND
                                      Almdmov.TipMov = X-TipMov AND  
                                      Almdmov.CodMov = I-CodMov AND  
                                      Almdmov.AlmOri BEGINS F-AlmDes AND
                                      Almdmov.PreUni = 0,
                                      FIRST Almcmov OF Almdmov NO-LOCK,
                                      FIRST Almmmatg OF Almdmov NO-LOCK
                                      BREAK BY Almdmov.CodCia BY ALmdmov.CodMat /*BY Almdmov.NroDoc*/:
       
          DISPLAY Almdmov.NroDoc @ Fi-Mensaje LABEL "Numero de Movimiento"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.
          VIEW STREAM REPORT FRAME H-REP.

        IF FIRST-OF(Almdmov.codmat) THEN DO:
            DISPLAY STREAM REPORT
                Almdmov.codmat
                Almmmatg.desmat
                WITH FRAME F-Quiebre.
            UNDERLINE STREAM REPORT
                Almdmov.codmat
                Almmmatg.desmat
                WITH FRAME F-Quiebre.
            DOWN STREAM REPORT 1 WITH FRAME F-Quiebre.
        END.
          x-Importe = Almdmov.CanDes * Almdmov.VCtoMn1.
          DISPLAY STREAM REPORT
                Almdmov.CodAlm
                Almdmov.Nrodoc  
                Almdmov.AlmOri  
                Almdmov.FchDoc 
                Almcmov.NomRef 
                Almcmov.Nrorf1  
                Almcmov.Usuario 
                Almdmov.CodUnd  
                Almdmov.CanDes
                Almdmov.PreUni
/*                x-Importe */
                WITH FRAME F-REP.
        ACCUMULATE almdmov.candes (TOTAL).
        ACCUMULATE x-Importe      (TOTAL).
        IF LAST-OF(almdmov.codcia)
        THEN DO:
            UNDERLINE STREAM REPORT 
                almdmov.candes 
                x-importe
                WITH FRAME F-REP.
            DISPLAY STREAM REPORT 
                ACCUM TOTAL almdmov.candes @ almdmov.candes 
                ACCUM TOTAL x-importe      @ x-importe
                WITH FRAME F-REP.
            x-candes = ACCUM TOTAL almdmov.candes.
            x-imptot = ACCUM TOTAL x-importe.
            IF x-candes > 0
            THEN DO:
                UNDERLINE STREAM REPORT 
                    x-importe
                    WITH FRAME F-REP.
                DISPLAY STREAM REPORT 
                    (x-imptot / x-candes) @ x-importe
                WITH FRAME F-REP.
            END.
        END.
    END.
  HIDE FRAME F-PROCESO.

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
   ENABLE ALL EXCEPT N-MOVI F-Nomdes.

   FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
 
   IF AVAILABLE Almtmovm AND Almtmovm.MovTrf THEN DO:
      F-AlmDes:SENSITIVE = YES.
     
   END.
   ELSE DO:
      F-AlmDes:SENSITIVE = NO.
      F-NomDes:SCREEN-VALUE = "".
      F-AlmDes:SCREEN-VALUE = "".
   END.


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

    DEFINE VARIABLE c-copias AS INTEGER NO-UNDO.

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
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY
            HastaF = TODAY
            F-Almdes = ""
            F-Nomdes = ""
            I-CodMov = 0
            C-tipmov.
    i-CodMov:DELETE(1).
    FOR EACH Almtmovm WHERE Almtmovm.codcia = s-codcia
        AND Almtmovm.tipmov = 'I'
        AND Almtmovm.tpocto = 1 NO-LOCK:
        i-CodMov:ADD-LAST(STRING(Almtmovm.codmov, '99')).
        i-CodMov = Almtmovm.codmov.
    END.        

            
    CASE C-tipmov:
         WHEN "Ingreso" THEN X-Tipmov = "I".
         WHEN "Salida"  THEN X-Tipmov = "S".
    END.
    FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                        Almtmovm.tipmov = X-TIPMOV AND
                        Almtmovm.codmov = I-CodMov NO-LOCK NO-ERROR.

    IF AVAILABLE Almtmovm THEN N-MOVI = Almtmovm.Desmov.
    DISPLAY DesdeF HastaF I-Codmov C-tipmov N-movi.
 
    F-AlmDes:SENSITIVE = NO.
            
  
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


