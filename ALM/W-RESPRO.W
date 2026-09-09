&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE VAR C-DESMOV AS CHAR.
DEFINE VAR C-OP AS CHAR.
DEFINE STREAM REPORT.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov AS CHAR NO-UNDO.
DEFINE VAR S-SUBTIT AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-DMOV 
   FIELD Codfam LIKE Almmmatg.codfam
   FIELD Subfam LIKE Almmmatg.subfam
   FIELD Codmat LIKE Almdmov.codmat
   FIELD Desmat LIKE Almmmatg.desmat
   FIELD Undstk LIKE Almmmatg.undstk
   FIELD CanUnd LIKE Almdmov.candes
   FIELD CanKgs LIKE Almdmov.candes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 I-CodMov F-CodFam F-SubFam RECT-19 ~
C-TipMov DesdeF HastaF Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS I-CodMov F-CodFam F-SubFam N-MOVI F-DesFam ~
F-DesSub C-TipMov DesdeF HastaF 

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
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(2)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Fam" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-CodMov AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Cod.Mov." 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .81 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.14 BY .81 NO-UNDO.

DEFINE VARIABLE C-TipMov AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ingresos", "I",
"Salidas", "S"
     SIZE 14 BY 1.46 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 1.92.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 7.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     I-CodMov AT ROW 3.69 COL 8.29 COLON-ALIGNED
     F-CodFam AT ROW 4.92 COL 8.29 COLON-ALIGNED
     F-SubFam AT ROW 5.81 COL 8.29 COLON-ALIGNED
     N-MOVI AT ROW 3.69 COL 14.14 COLON-ALIGNED NO-LABEL
     F-DesFam AT ROW 4.88 COL 14.14 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 5.81 COL 14.14 COLON-ALIGNED NO-LABEL
     C-TipMov AT ROW 1.58 COL 22.86 NO-LABEL
     DesdeF AT ROW 6.96 COL 23.29 COLON-ALIGNED
     HastaF AT ROW 7.73 COL 23.29 COLON-ALIGNED
     Btn_OK AT ROW 2.69 COL 50.72
     Btn_Cancel AT ROW 5 COL 50.72
     RECT-20 AT ROW 1 COL 1
     "Tipo Movimiento" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 2.08 COL 8.29
     RECT-19 AT ROW 1.38 COL 20.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "Resumen por Movimentos por Producto"
         HEIGHT             = 7.85
         WIDTH              = 62.14
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen por Movimentos por Producto */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen por Movimentos por Producto */
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
  ASSIGN C-TipMov DesdeF HastaF I-CodMov.
  IF I-CODMOV <> 0 THEN DO:
    FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA AND
                           Almcmov.CodAlm  = S-CODALM AND
                           Almcmov.TipMov  = C-TipMov AND
                           Almcmov.CodMov  = I-CodMov NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
        MESSAGE "CODIGO NO TIENE MOVIMIENTO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
      X-CODMOV = STRING(I-CODMOV).
  END.
  ELSE  X-CODMOV = "".
  
  
  FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA AND
                           Almcmov.Fchdoc >= DESDEF AND 
                           Almcmov.Fchdoc <= HASTAF NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almcmov THEN DO:
        MESSAGE "RANGO DE FECHAS SIN MOVIMIENTOS" VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO DESDEF.
        RETURN NO-APPLY.
  END.
    
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-TipMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-TipMov W-Win
ON VALUE-CHANGED OF C-TipMov IN FRAME F-Main
DO:
  ASSIGN C-TIPMOV.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Familia */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-Fam */
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


&Scoped-define SELF-NAME I-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON LEAVE OF I-CodMov IN FRAME F-Main /* Cod.Mov. */
DO:
  FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = C-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Almdmov WHERE 
           Almdmov.CodCia  = S-CODCIA AND
           Almdmov.CodAlm  = S-CODALM AND
           Almdmov.TipMov  = C-TipMov AND
           string(Almdmov.CodMov) begins X-CodMov AND 
           Almdmov.FchDoc >= DesdeF   AND
           Almdmov.FchDoc <= HastaF   NO-LOCK:
      FIND Almmmatg WHERE Almmmatg.codcia = S-Codcia AND
           Almmmatg.codmat = Almdmov.Codmat NO-LOCK NO-ERROR.
      IF NOT(Almmmatg.codfam BEGINS F-CodFam AND Almmmatg.subfam BEGINS F-SubFam) THEN NEXT.
      FIND T-DMOV WHERE T-DMOV.Codmat = Almdmov.codmat NO-ERROR.
      IF NOT AVAILABLE T-DMOV THEN DO:
         CREATE T-DMOV.
         ASSIGN
            T-DMOV.Codmat = Almdmov.codmat
            T-DMOV.Codfam = Almmmatg.codfam
            T-DMOV.Subfam = Almmmatg.subfam
            T-DMOV.Desmat = Almmmatg.desmat
            T-DMOV.Undstk = Almmmatg.undstk.
      END.
      ASSIGN
         T-DMOV.CanUnd = T-DMOV.CanUnd + (Almdmov.CanDes * Almdmov.Factor).
      IF Almmmatg.UndStk BEGINS 'Kg' THEN
         ASSIGN
            T-DMOV.CanKgs = T-DMOV.CanKgs + (Almdmov.CanDes * Almdmov.Factor).
      ELSE DO:
         IF Almdmov.Tipmov = 'I' THEN 
            ASSIGN
               T-DMOV.CanKgs = T-DMOV.CanKgs + 
                               (Almdmov.CanDes * Almdmov.Factor * Almdmov.pesmat / 1000).
         ELSE
            ASSIGN
               T-DMOV.CanKgs = T-DMOV.CanKgs + Almdmov.pesmat.
      END.
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
  DISPLAY I-CodMov F-CodFam F-SubFam N-MOVI F-DesFam F-DesSub C-TipMov DesdeF 
          HastaF 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-20 I-CodMov F-CodFam F-SubFam RECT-19 C-TipMov DesdeF HastaF 
         Btn_OK Btn_Cancel 
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
  DEFINE FRAME F-REPORTE
         T-DMOV.codmat  COLUMN-LABEL "Codigo" FORMAT "X(9)"
         T-DMOV.DesMat  COLUMN-LABEL "Descripcion" FORMAT "X(50)"
         T-DMOV.UndStk  AT 64 COLUMN-LABEL "Unidad"
         T-DMOV.CanUnd  COLUMN-LABEL "Und Stock" FORMAT ">>,>>>,>>9.99"
         T-DMOV.CanKgs  COLUMN-LABEL "Cantidad"  FORMAT ">>,>>>,>>9.99" SKIP
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} AT 6 FORMAT "X(50)" SKIP
         "RESUMEN DE MOVIMIENTOS" AT 40 
         "Pagina : " TO 87 PAGE-NUMBER(REPORT) TO 97 FORMAT "ZZZZZ9" SKIP
         " Fecha : " TO 87 TODAY TO 97 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 87 STRING(TIME,"HH:MM:SS") TO 97 SKIP
         "Movimiento : " (IF I-CodMov = 0 THEN "Todos" ELSE X-Codmov) SKIP
         S-SUBTIT FORMAT 'X(40)' SKIP
         "-------------------------------------------------------------------------------------------------" SKIP
         "                                                              Und       C  A  N  T  I  D  A  D   " SKIP
         "   Codigo    Descripci¢n                                      Stk         Stock         Kilos    " SKIP
         "-------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.
  
  FOR EACH T-DMOV BREAK BY T-DMOV.Codfam BY T-DMOV.Subfam:
      IF FIRST-OF(T-DMOV.Codfam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-codcia AND
              Almtfami.codfam = T-DMOV.Codfam NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
            PUT STREAM REPORT 'FAMILIA : ' Almtfami.desfam.
            DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         END.
      END.
      IF FIRST-OF(T-DMOV.Subfam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-codcia AND
              Almsfami.codfam = T-DMOV.Codfam AND
              Almsfami.subfam = T-DMOV.Subfam NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
            DISPLAY STREAM REPORT 
                T-DMOV.Subfam   @ T-DMOV.Codmat
                Almsfami.dessub @ T-DMOV.desmat WITH FRAME F-REPORTE.
            DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         END.
      END.
      DISPLAY STREAM REPORT 
            T-DMOV.Codmat
            T-DMOV.Desmat
            T-DMOV.UndStk
            T-DMOV.CanUnd
            T-DMOV.CanKgs WITH FRAME F-REPORTE. 
      ACCUMULATE T-DMOV.CanUnd (SUB-TOTAL BY T-DMOV.Codfam).
      ACCUMULATE T-DMOV.CanKgs (SUB-TOTAL BY T-DMOV.Codfam).
      ACCUMULATE T-DMOV.CanUnd (SUB-TOTAL BY T-DMOV.Subfam).
      ACCUMULATE T-DMOV.CanKgs (SUB-TOTAL BY T-DMOV.Subfam).
      IF LAST-OF(T-DMOV.Codfam) THEN DO:
         UNDERLINE STREAM REPORT
             T-DMOV.CanUnd T-DMOV.CanKgs WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT
             ACCUM SUB-TOTAL BY T-DMOV.Codfam T-DMOV.Canund @ T-DMOV.Canund
             ACCUM SUB-TOTAL BY T-DMOV.Codfam T-DMOV.Cankgs @ T-DMOV.Cankgs
             WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
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
  S-SUBTIT = 'Desde el ' + STRING(DesdeF) + 'al ' + STRING(HastaF).

  RUN Carga-Temporal.
  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE. 

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
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
     DISPLAY DesdeF HastaF.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
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
        WHEN "I-CodMov" THEN 
               ASSIGN input-var-1 = C-TipMov:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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


