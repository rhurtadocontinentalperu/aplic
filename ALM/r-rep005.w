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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle
    FIELD nrorf1 LIKE almcmov.nrorf1
    FIELD nrodoc LIKE almcmov.nrodoc
    FIELD fchdoc LIKE almcmov.fchdoc
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD undbas LIKE almmmatg.undbas
    FIELD candes130 AS DEC EXTENT 2
    FIELD candes143 AS DEC EXTENT 2
    FIELD candes151 AS DEC EXTENT 2
    FIELD candes11  AS DEC EXTENT 2
    FIELD observ AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodMat FILL-IN-NroRf1 ~
FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-2 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN-DesMat ~
FILL-IN-DesMar FILL-IN-NroRf1 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 2" 
     SIZE 8 BY 1.54.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Material" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRf1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referencia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1.38 COL 14 COLON-ALIGNED
     FILL-IN-DesMat AT ROW 1.38 COL 22 COLON-ALIGNED NO-LABEL
     FILL-IN-DesMar AT ROW 2.35 COL 14 COLON-ALIGNED
     FILL-IN-NroRf1 AT ROW 3.31 COL 14 COLON-ALIGNED
     FILL-IN-FchDoc-1 AT ROW 4.27 COL 14 COLON-ALIGNED
     FILL-IN-FchDoc-2 AT ROW 5.23 COL 14 COLON-ALIGNED
     BUTTON-2 AT ROW 6.19 COL 4
     Btn_Done AT ROW 6.19 COL 13
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
         TITLE              = "MOVIMIENTOS DE IMPORTACION"
         HEIGHT             = 7.12
         WIDTH              = 71.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN FILL-IN-DesMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
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
ON END-ERROR OF W-Win /* MOVIMIENTOS DE IMPORTACION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MOVIMIENTOS DE IMPORTACION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
    FILL-IN-CodMat FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-NroRf1.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Material */
DO:
  FILL-IN-DesMat:SCREEN-VALUE = ''.
  FILL-IN-DesMar:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE ALmmmatg 
  THEN ASSIGN
        FILL-IN-DesMat:SCREEN-VALUE = Almmmatg.desmat
        FILL-IN-DesMar:SCREEN-VALUE = Almmmatg.desmar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
  FOR EACH Detalle:
    DELETE Detalle.
  END.
  
  FOR EACH almacen WHERE almacen.codcia = s-codcia
        AND LOOKUP(TRIM(codalm), '130,143,151,11') > 0 NO-LOCK:
    FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
            AND almcmov.codalm = almacen.codalm
            AND (almcmov.tipmov = 'I' OR almcmov.tipmov = 'S')
            AND (almcmov.codmov = 06 OR almcmov.codmov = 07)
            AND almcmov.fchdoc >= FILL-IN-FchDoc-1
            AND almcmov.fchdoc <= FILL-IN-FchDoc-2
            AND almcmov.nrorf1 BEGINS FILL-IN-NroRf1,
            EACH almdmov OF almcmov WHERE almdmov.codmat BEGINS FILL-IN-CodMat NO-LOCK,
            FIRST almmmatg OF almdmov NO-LOCK:
        IF almcmov.tipmov = 'S' AND almcmov.codmov = 07 THEN NEXT.  /* OJO */
        CREATE Detalle.
        ASSIGN
            detalle.nrorf1 = almcmov.nrorf1
            detalle.nrodoc = almcmov.nrodoc
            detalle.fchdoc = almcmov.fchdoc
            detalle.codmat = almdmov.codmat
            detalle.desmat = almmmatg.desmat
            detalle.desmar = almmmatg.desmar
            detalle.undbas = almmmatg.undbas
            detalle.observ = almcmov.observ.
        IF almcmov.tipmov = 'I'
        THEN CASE almcmov.codalm:
                WHEN '130' THEN detalle.candes130[1] = almdmov.candes * almdmov.factor.
                WHEN '143' THEN detalle.candes143[1] = almdmov.candes * almdmov.factor.
                WHEN '151' THEN detalle.candes151[1] = almdmov.candes * almdmov.factor.
                WHEN '11'  THEN detalle.candes11[1]  = almdmov.candes * almdmov.factor.
            END CASE.
        IF almcmov.tipmov = 'S'
        THEN CASE almcmov.codalm:
                WHEN '130' THEN detalle.candes130[2] = almdmov.candes * almdmov.factor.
                WHEN '143' THEN detalle.candes143[2] = almdmov.candes * almdmov.factor.
                WHEN '151' THEN detalle.candes151[2] = almdmov.candes * almdmov.factor.
                WHEN '11'  THEN detalle.candes11[2]  = almdmov.candes * almdmov.factor.
            END CASE.
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
  DISPLAY FILL-IN-CodMat FILL-IN-DesMat FILL-IN-DesMar FILL-IN-NroRf1 
          FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodMat FILL-IN-NroRf1 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
         BUTTON-2 Btn_Done 
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
  DEFINE FRAME F-DETALLE
    DETALLE.nrorf1      COLUMN-LABEL "Referencia"           FORMAT "X(15)"
    DETALLE.nrodoc      COLUMN-LABEL "Documento"           
    DETALLE.fchdoc      COLUMN-LABEL "Fecha"                FORMAT "99/99/9999"
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(40)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.undbas      COLUMN-LABEL "Unidad"               FORMAT 'X(5)'     
    DETALLE.candes130[1] COLUMN-LABEL "Almacen!I-06/I-07"  FORMAT ">>>>,>>9.99"  
    DETALLE.candes130[2] COLUMN-LABEL "130      !S-06"     FORMAT ">>>>,>>9.99"  
    DETALLE.candes143[1] COLUMN-LABEL "Almacen!I-06/I-07"  FORMAT ">>>>,>>9.99"  
    DETALLE.candes143[2] COLUMN-LABEL "143      !S-06"     FORMAT ">>>>,>>9.99"  
    DETALLE.candes151[1] COLUMN-LABEL "Almacen!I-06/I-07"  FORMAT ">>>>,>>9.99"  
    DETALLE.candes151[2] COLUMN-LABEL "151      !S-06"     FORMAT ">>>>,>>9.99"  
    DETALLE.candes11[1]  COLUMN-LABEL "Almacen!I-06/I-07"  FORMAT ">>>>,>>9.99"  
    DETALLE.candes11[2]  COLUMN-LABEL "11       !S-06"     FORMAT ">>>>,>>9.99"  
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT "X(50)" AT 1 SKIP
    "MOVIMIENTOS DE IMPORTACION" AT 20 
    "Pagina :" TO 180 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :"  TO 180 TODAY FORMAT "99/99/9999" SKIP
  WITH PAGE-TOP WIDTH 196 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT 
        DETALLE.nrorf1
        DETALLE.nrodoc
        DETALLE.fchdoc
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.undbas
        DETALLE.candes130[1]
        DETALLE.candes130[2]      
        DETALLE.candes143[1]
        DETALLE.candes143[2]      
        DETALLE.candes151[1]
        DETALLE.candes151[2]      
        DETALLE.candes11[1]
        DETALLE.candes11[2]      
        WITH FRAME F-DETALLE.
    ACCUMULATE DETALLE.candes130[1] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes130[2] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes143[1] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes143[2] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes151[1] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes151[2] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes11[1] (TOTAL BY DETALLE.codmat).
    ACCUMULATE DETALLE.candes11[2] (TOTAL BY DETALLE.codmat).
    IF LAST-OF(DETALLE.codmat) THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.candes130[1]
            DETALLE.candes130[2]
            DETALLE.candes143[1]
            DETALLE.candes143[2]
            DETALLE.candes151[1]
            DETALLE.candes151[2]
            DETALLE.candes11[1]
            DETALLE.candes11[2]
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL -> " @ DETALLE.desmar
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes130[1] @ DETALLE.candes130[1]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes130[2] @ DETALLE.candes130[2]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes143[1] @ DETALLE.candes143[1]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes143[2] @ DETALLE.candes143[2]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes151[1] @ DETALLE.candes151[1]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes151[2] @ DETALLE.candes151[2]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes11[1] @ DETALLE.candes11[1]
            ACCUM TOTAL BY DETALLE.codmat DETALLE.candes11[2] @ DETALLE.candes11[2]
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT 2 WITH FRAME F-DETALLE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN Carga-Temporal.

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
        RUN formato.
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
  ASSIGN
    FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
    FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-parametros W-Win 
PROCEDURE Procesa-parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-parametros W-Win 
PROCEDURE Recoge-parametros :
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


