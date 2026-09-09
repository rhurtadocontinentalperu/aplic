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

  DEFINE VAR x-flgest AS CHAR NO-UNDO.
  DEFINE VAR x-desmat AS CHAR NO-UNDO.
  DEFINE VAR X-Movi    AS CHAR NO-UNDO.
  DEFINE VAR X-NomR LIKE Almcmov.NomRef NO-UNDO.
  DEFINE VAR X-Usua LIKE Almcmov.usuario NO-UNDO.
  DEFINE VAR X-Ref1 LIKE Almcmov.NroRf1 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-60 desdeF C-Tipmov Btn_OK ~
I-CodMov hastaF Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Almacen desdeF C-Tipmov I-CodMov N-MOVI ~
hastaF 

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

DEFINE VARIABLE C-Tipmov AS CHARACTER FORMAT "X(256)":U INITIAL "Ingreso" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ingreso","Salida" 
     SIZE 9.43 BY .81 NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-CodMov AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .69 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.14 BY 3.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Almacen AT ROW 1.38 COL 3.85
     desdeF AT ROW 2.19 COL 8.57 COLON-ALIGNED
     C-Tipmov AT ROW 3 COL 8.57 COLON-ALIGNED
     Btn_OK AT ROW 4.46 COL 15.86
     I-CodMov AT ROW 3.04 COL 18.43 COLON-ALIGNED NO-LABEL
     N-MOVI AT ROW 3.04 COL 22.57 COLON-ALIGNED NO-LABEL
     hastaF AT ROW 2.19 COL 27.29 COLON-ALIGNED
     Btn_Cancel AT ROW 4.58 COL 37.72
     RECT-62 AT ROW 1.08 COL 1.57
     RECT-60 AT ROW 4.35 COL 1.86
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
         TITLE              = "Catalogo de Stock"
         HEIGHT             = 5.31
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
                                                                        */
/* SETTINGS FOR FILL-IN F-Almacen IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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
ON END-ERROR OF W-Win /* Catalogo de Stock */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Stock */
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
  ASSIGN C-TipMov DesdeF HastaF I-CodMov .
  IF I-CODMOV <> 0 THEN DO:
    FIND FIRST Almdmov WHERE Almdmov.CodCia  = S-CODCIA 
                        AND  Almdmov.CodAlm  = S-CODALM 
                        AND  Almdmov.TipMov  = C-TipMov 
                        AND  Almdmov.CodMov  = I-CodMov 
                       NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almdmov THEN DO:
        MESSAGE "CODIGO NO TIENE MOVIMIENTO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
      X-CODMOV = STRING(I-CODMOV,'99').
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


&Scoped-define SELF-NAME I-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON LEAVE OF I-CodMov IN FRAME F-Main /* Movimiento */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeF HastaF C-tipmov I-Codmov.

  x-titulo2 = 'Del ' + STRING(DesdeF, '99/99/9999') + ' Al ' + STRING(HastaF, '99/99/9999').
  CASE C-TipMov:
     WHEN 'Ingreso' THEN x-titulo1 = 'ANALISIS DE DOCUMENTOS - INGRESOS'.
     WHEN 'Salida'  THEN x-titulo1 = 'ANALISIS DE DOCUMENTOS - SALIDAS'.
  END CASE.

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
  DISPLAY F-Almacen desdeF C-Tipmov I-CodMov N-MOVI hastaF 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-60 desdeF C-Tipmov Btn_OK I-CodMov hastaF Btn_Cancel 
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

  DEFINE FRAME F-REP
         Almdmov.codmat AT 16 FORMAT "X(8)"
         Almmmatg.DesMat AT 28 FORMAT "X(40)"
         Almmmatg.DesMar AT 75 FORMAT "X(10)"
         Almdmov.CodUnd AT 90
         Almdmov.CanDes FORMAT "(>,>>>,>>9.99)" 
  WITH WIDTH 250 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         "( " + S-CODALM + ")"  FORMAT "X(15)"
         x-titulo1 AT 37 FORMAT "X(35)"
         "Pag.  : " AT 87 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Desde : " AT 50 FORMAT "X(10)" STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
         "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
         "----------------------------------------------------------------------------------------------------------------------------------" SKIP
         " Nro.  Almacen Fecha/Doc.          D e s t i n o                Respons.  Doc.Refer.    M o v i m i e n t o               Estado  " SKIP
         " Doc.          Cod/Articulo   Descripcion                                 Marca          Unid      Cantidad                       " SKIP
         "----------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

       FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                    AND  Almdmov.CodAlm = S-CODALM
                    AND  Almdmov.TipMov = C-TipMov 
                    AND  string(Almdmov.CodMov, "99") begins X-CodMov                   
                    AND  Almdmov.FchDoc >= DesdeF   
                    AND  Almdmov.FchDoc <= HastaF   
                   BREAK BY Almdmov.CodCia
                         BY Almdmov.CodAlm
                         BY Almdmov.TipMov
                         BY Almdmov.CodMov
                         BY Almdmov.NroSer 
                         BY Almdmov.Nrodoc 
                         BY Almdmov.CodMat:

      VIEW STREAM REPORT FRAME H-REP.

      IF FIRST-OF(Almdmov.Nrodoc) THEN DO:
          X-NomR = "".
          X-Usua = "".
          X-Ref1 = "". 
          x-flgest = 'RECIBIDO'.
          FIND Almcmov OF Almdmov NO-LOCK NO-ERROR.
          IF AVAILABLE Almcmov THEN DO:
             IF Almcmov.flgest = 'A' THEN x-flgest = 'ANULADO'.
             ELSE x-flgest = 'RECIBIDO'.
             X-NomR = Almcmov.NomRef.
             X-Usua = Almcmov.usuario.
             X-Ref1 = Almcmov.NroRf1. 
          END.
          X-Movi = Almdmov.TipMov + STRING(Almdmov.CodMov, '99') + '-'.
          FIND Almtmovm WHERE Almtmovm.CodCia = Almdmov.CodCia 
                         AND  Almtmovm.tipmov = Almdmov.tipmov 
                         AND  Almtmovm.codmov = Almdmov.CodMov 
                        NO-LOCK NO-ERROR.
          IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.
          PUT STREAM REPORT 
                   Almdmov.NroDoc AT 1
                   Almdmov.CodAlm AT 10
                   Almdmov.FchDoc AT 16 FORMAT "99/99/9999"
                   X-NomR         AT 28 FORMAT 'X(35)'
                   X-Usua         AT 65
                   X-Ref1         AT 75
                   X-Movi         AT 87 FORMAT 'X(33)' 
                   x-flgest       AT 120 FORMAT 'X(10)'.
           DOWN STREAM REPORT WITH FRAME F-REP. 
      END.
      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                     AND  Almmmatg.codmat = Almdmov.codmat 
                    NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
      ELSE x-desmat = Almmmatg.DesMat.
      DISPLAY STREAM REPORT 
              Almdmov.codmat 
              x-desmat @ Almmmatg.DesMat
              Almmmatg.DesMar
              Almdmov.CodUnd 
              Almdmov.CanDes WITH FRAME F-REP.
      IF LAST-OF(Almdmov.Nrodoc) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REP. 
      END.
  END.  
  
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-L-Codigo W-Win 
PROCEDURE Formato-C-L-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
 DEFINE FRAME F-REPORTE
        Almmmate.CodMat    AT 2   FORMAT "X(6)"
        Almmmatg.DesMat    AT 10  FORMAT "X(50)"
        Almmmatg.DesMar    AT 61  FORMAT "X(15)"
        Almmmatg.UndBas    AT 78  FORMAT "X(4)"
        Almmmate.FacEqu    AT 84  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    AT 100  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    AT 119 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    AT 134 FORMAT "->,>>>,>>9.99"
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                          F A C T O R                S    T    O    C    K    S           " SKIP
        "ARTICULO  D E S C R I P C I O N                            MARCA       UNIDAD    EQUIVALENCIA     A C T U A L       M I N I M O     M A X I M O  " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.CodMat :

     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
  
     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Familia  ***********/
      IF FIRST-OF(Almmmatg.Codfam) THEN DO:
         FIND AlmTfami WHERE AlmTfami.Codcia = S-CODCIA AND 
                             AlmTfami.CodFam = Almmmatg.CodFam
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTfami THEN do:                    
            DISPLAY STREAM REPORT
            {&PRN2} + {&PRN6A} + AlmTfami.Codfam + "- " + CAPS(AlmTfami.Desfam) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
            DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
        END.    
      END.
          
     DISPLAY STREAM REPORT
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     
 END.
 */
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
    ENABLE ALL EXCEPT N-MOVI.
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

/*  IF s-salida-impresion = 1 THEN 
 *      s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".*/
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov.

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
            I-CodMov = 0
            C-tipmov.
            
    
    FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                        Almtmovm.tipmov = C-TIPMOV AND
                        Almtmovm.codmov = I-CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm THEN N-MOVI = Almtmovm.Desmov.
    DISPLAY DesdeF HastaF I-Codmov C-tipmov N-movi
            S-CODALM @ F-Almacen.    
  
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


