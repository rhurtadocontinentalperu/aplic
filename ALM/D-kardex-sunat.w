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

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
/*
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>,>>>,>>9.9999)" NO-UNDO.
*/
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>>>,>>9.9999)" NO-UNDO.

DEFINE VAR F-VALCTO  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

/*
DEFINE BUFFER DMOV FOR Almdmov. 
DEFINE VAR I-NROITM  AS INTEGER.
*/

DEFINE VAR nCodMon AS INT INIT 1.
DEFINE VAR r-tipo AS CHAR INIT "".
DEFINE VAR t-resumen AS LOGICAL INIT NO.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.

DEFINE TEMP-TABLE tt-kardex-sunat
            FIELDS tt-periodo AS CHAR FORMAT 'x(8)'
            FIELDS tt-coduniope AS CHAR FORMAT 'x(40)'
        FIELDS tt-numcorrasto AS CHAR FORMAT 'x(10)'
        FIELDS tt-almacen AS CHAR FORMAT 'x(7)'
        FIELDS tt-catalogo AS CHAR FORMAT 'x(1)'
        FIELDS tt-tipo AS CHAR FORMAT 'x(15)'   /*?????*/
        FIELDS tt-codigo AS CHAR FORMAT 'x(24)'
        FIELDS tt-codexisOSCE AS CHAR FORMAT 'x(8)'
        FIELDS tt-femision AS CHAR FORMAT 'x(10)'
        FIELDS tt-tpodoc AS CHAR FORMAT 'x(2)'
        FIELDS tt-nroserie AS CHAR FORMAT 'x(20)'
        FIELDS tt-nrodcto AS CHAR FORMAT 'x(20)'
        FIELDS tt-tipope AS CHAR FORMAT 'x(2)'
        FIELDS tt-desmat AS CHAR FORMAT 'x(80)'
        FIELDS tt-undmed AS CHAR FORMAT 'x(3)'
        FIELDS tt-meteval AS CHAR FORMAT 'x(1)'
        FIELDS tt-qingreso AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qcostoing AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qcosttotaling AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qsalidas AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qcostosal AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qcosttotalsal AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qfinal AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qcostofin AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-qcosttotalfin AS DEC FORMAT '>>,>>>,>>9.9999'
        FIELDS tt-estado AS CHAR FORMAT 'x(1)'
        FIELDS tt-filer AS CHAR FORMAT 'x(200)'.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 F-CodFam F-SubFam x-Licencia DesdeC ~
HastaC DesdeF HastaF Btn_OK Btn_Cancel BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-DesFam F-SubFam F-DesSub ~
x-Licencia x-NomLic DesdeC HastaC DesdeF HastaF x-mensaje 

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

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE x-Licencia AS CHARACTER FORMAT "X(3)":U 
     LABEL "Licenciatario" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomLic AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.88
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.86 BY 10.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.85 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 1.85 COL 24.29 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.62 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.62 COL 24.29 COLON-ALIGNED NO-LABEL
     x-Licencia AT ROW 3.42 COL 18 COLON-ALIGNED WIDGET-ID 2
     x-NomLic AT ROW 3.42 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     DesdeC AT ROW 4.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.12 COL 47 COLON-ALIGNED
     DesdeF AT ROW 4.81 COL 18 COLON-ALIGNED
     HastaF AT ROW 4.81 COL 47 COLON-ALIGNED
     x-mensaje AT ROW 10.15 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 11.69 COL 2.14
     Btn_Cancel AT ROW 11.69 COL 13.72
     BUTTON-1 AT ROW 11.69 COL 25.29
     BUTTON-2 AT ROW 11.69 COL 37.86 WIDGET-ID 6
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 11.5 COL 1
     RECT-57 AT ROW 1.19 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.14 BY 12.69
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
         TITLE              = "Kardex General Contable"
         HEIGHT             = 12.69
         WIDTH              = 81.14
         MAX-HEIGHT         = 12.69
         MAX-WIDTH          = 81.14
         VIRTUAL-HEIGHT     = 12.69
         VIRTUAL-WIDTH      = 81.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomLic IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Kardex General Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Kardex General Contable */
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
  RUN Asigna-Variables.
  RUN Inhabilita.
  /*RUN Imprime.*/
  RUN Formato.
  RUN Excel.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Texto.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    RUN Asigna-Variables.
    RUN Inhabilita.
    IF T-Resumen THEN RUN Excel3.
    ELSE RUN Excel.
    RUN Habilita.
    RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
/*   IF SELF:SCREEN-VALUE = "" THEN RETURN.                           */
/*   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999"). */
/*   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA                   */
/*                  AND  Almmmatg.CodMat = SELF:SCREEN-VALUE          */
/*                 NO-LOCK NO-ERROR.                                  */
/*   IF NOT AVAILABLE Almmmatg THEN DO:                               */
/*      MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.           */
/*      RETURN NO-APPLY.                                              */
/*   END.                                                             */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                  AND  Almtfami.codfam = F-CodFam 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-linea */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
/*    IF SELF:SCREEN-VALUE = "" THEN RETURN.                          */
/*   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999"). */
/*   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA                   */
/*                  AND  Almmmatg.CodMat = SELF:SCREEN-VALUE          */
/*                 NO-LOCK NO-ERROR.                                  */
/*   IF NOT AVAILABLE Almmmatg THEN DO:                               */
/*      MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.           */
/*      RETURN NO-APPLY.                                              */
/*   END.                                                             */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Licencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Licencia W-Win
ON LEAVE OF x-Licencia IN FRAME F-Main /* Licenciatario */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND almtabla WHERE almtabla.Tabla = "LC" AND
         almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtabla THEN DO:
     MESSAGE "Codigo de Licencia no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
    END.
    x-NomLic:SCREEN-VALUE = almtabla.Nombre.
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
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF x-Licencia.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE 
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).


  IF HastaC = "" THEN HastaC = "999999".
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

END.

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
  DISPLAY F-CodFam F-DesFam F-SubFam F-DesSub x-Licencia x-NomLic DesdeC HastaC 
          DesdeF HastaF x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 F-CodFam F-SubFam x-Licencia DesdeC HastaC DesdeF HastaF 
         Btn_OK Btn_Cancel BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*******************************************************/
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Periodo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo Unico Operacion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro Correlativo Asiento".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Establecimiento".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo Catalogo".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Tipo Existencia".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo Articulo".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo OSCE".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Documento".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Tipo Documento".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Serie Documento".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro Documento".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Tipo Operacion".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion Existencia".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Unidad Medida".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Metodo Evaluacion".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad Ingreso".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Ingreso".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total Ingreso".
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad Salida".
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Salida".
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total Salida".
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo final".
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Unitario Final".
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total Final".
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = "Estado Operacion".
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = "Libre".

    FOR EACH tt-kardex-sunat:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-periodo.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-coduniope.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-numcorrasto.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-almacen.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-catalogo.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-tipo.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-codigo.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-codexisOSCE.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-femision.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-tpodoc.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-nroserie.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-nrodcto.
        cRange = "M" + cColumn.        
        chWorkSheet:Range(cRange):Value = tt-tipope.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-desmat.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-undmed.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-meteval.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qingreso.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qcostoing.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qcosttotaling.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qsalidas.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qcostosal.
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qcosttotalsal.
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qfinal.
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qcostofin.
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-qcosttotalfin.
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-estado.
    END.    
    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 W-Win 
PROCEDURE Excel2 :
/*------------------------------------------------------------------------------
  Purpose:     Kardex resumido EN SOLES
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezados */
    DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
    DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
    DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
    DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
    DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
    DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
    DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-total AS DECIMAL.

    /* PARCHE: TODO EXPRESADO EN SOLES */
    DEF VAR nCodMon AS INT NO-UNDO.
    nCodMon = 1.
    /* ******************************* */

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "KARDEX GENERAL".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = s-subtit.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = IF nCodmon = 1 THEN "Expresado en Nuevos Soles " ELSE "Expresado en Dolares Americanos".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cat Contable".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Unidad".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Inicial".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Promedio Inicial".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Inicial".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ingresos".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Ingresos".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Salidas".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Salidas".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Promedio".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total".

    ASSIGN
       x-inggen = 0
       x-salgen = 0
       x-totgen = 0  
       x-total  = 0.
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.
    KARDEX:
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC  
        AND  Almmmatg.codfam BEGINS F-CodFam 
        AND  Almmmatg.TpoArt BEGINS R-Tipo 
        /*AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0*/
        AND  Almmmatg.Licencia[1] BEGINS x-Licencia
        BREAK BY Almmmatg.CodCia BY Almmmatg.CodMat:

        FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
            AND almstkge.codmat = almmmatg.codmat
            AND almstkge.fecha <= HastaF
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmStkGe OR Almstkge.stkact = 0 THEN NEXT.

        DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        IF FIRST-OF(Almmmatg.CodMat) THEN DO:
           /* BUSCAMOS SI TIENE MOVIMIENTOS ANTERIORES A DesdeF */
           FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia 
               AND AlmstkGe.CodMat = Almmmatg.CodMat 
               AND AlmstkGe.Fecha < DesdeF
               NO-LOCK NO-ERROR.
           ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
           ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).
           ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
           ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).
           ASSIGN
               F-STKGEN = 0
               F-SALDO  = 0
               F-PRECIO = 0
               F-VALCTO = 0.
           IF AVAILABLE AlmStkGe THEN DO:
              F-STKGEN = AlmStkGe.StkAct.
              F-SALDO  = AlmStkGe.StkAct.
              F-PRECIO = AlmStkGe.CtoUni.
              F-VALCTO = F-STKGEN * F-PRECIO.
           END.
           iCount = iCount + 1.
           cColumn = STRING(iCount).
           cRange = "A" + cColumn.
           chWorkSheet:Range(cRange):Value = "'" + Almmmatg.codmat.
           cRange = "B" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.desmat.
           cRange = "C" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.catconta[1].
           cRange = "D" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.desmar.
           cRange = "E" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.undstk.
           cRange = "F" + cColumn.
           chWorkSheet:Range(cRange):Value = f-saldo.
           cRange = "G" + cColumn.
           chWorkSheet:Range(cRange):Value = f-precio.
           cRange = "H" + cColumn.
           chWorkSheet:Range(cRange):Value = f-valcto.
        END.

        ASSIGN
            F-Ingreso = 0
            F-TotIng = 0
            F-Salida = 0
            F-TotSal = 0.
        FOR EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
                AND  Almdmov.codmat = Almmmatg.CodMat 
                AND  Almdmov.FchDoc >= DesdeF 
                AND  Almdmov.FchDoc <= HastaF,
                FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
                    AND Almtmovm.TipMov = Almdmov.TipMov 
                    AND Almtmovm.Codmov = Almdmov.Codmov
                    AND Almtmovm.Movtrf = No,
                FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = YES AND Almacen.AlmCsg = No:
            FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                          AND  Almcmov.CodAlm = Almdmov.codalm 
                          AND  Almcmov.TipMov = Almdmov.tipmov 
                          AND  Almcmov.CodMov = Almdmov.codmov 
                          AND  Almcmov.NroDoc = Almdmov.nrodoc 
                         NO-LOCK NO-ERROR.

            IF AVAILABLE Almcmov THEN DO:
               ASSIGN
                  x-codpro = Almcmov.codpro
                  x-codcli = Almcmov.codcli
                  x-nrorf1 = Almcmov.nrorf1
                  x-nrorf2 = Almcmov.nrorf2
                  x-codmon = Almcmov.codmon
                  x-tpocmb = Almcmov.tpocmb.
            END.


            S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
            /* INGRESOS */
            F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
            F-PreIng  = 0.
            F-TotIng  = 0.
            IF nCodmon = x-Codmon THEN DO:
               IF Almdmov.Tipmov = 'I' THEN DO:
                  F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                  F-TotIng  = Almdmov.ImpCto.
               END.
               ELSE DO:
                  F-PreIng  = 0.
                  F-TotIng  = F-PreIng * F-Ingreso.
               END.
               END.
            ELSE DO:
               IF nCodmon = 1 THEN DO:
                  IF Almdmov.Tipmov = 'I' THEN DO:
                     F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                     F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                  END.
                  IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                     F-PreIng  = 0.
                     F-TotIng  = F-PreIng * F-Ingreso.
                  END.
                  END.
               ELSE DO:
                  IF Almdmov.Tipmov = 'I' THEN DO:
                     F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                     F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                  END.
                  IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                     F-PreIng  = 0.
                     F-TotIng  = F-PreIng * F-Ingreso.
                  END.
               END.
            END.
            /* SALIDAS */
/*             F-Salida = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.                                        */
/*             IF nCodMon = 1 THEN DO:                                                                                                              */
/*                 F-TotSal = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor * Almdmov.VctoMn1) ELSE 0.                  */
/*             END.                                                                                                                                 */
/*             ELSE DO:                                                                                                                             */
/*                 F-TotSal = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor * Almdmov.VctoMn1 / Almdmov.TpoCmb) ELSE 0. */
/*             END.                                                                                                                                 */
            f-Salida = 0.
            IF LOOKUP (Almdmov.TipMov, 'S,T') > 0 THEN DO:
                f-Salida = Almdmov.CanDes * Almdmov.Factor.
                /* Costo Unitario */
                FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                    AND almstkge.codmat = almmmatg.codmat
                    AND almstkge.fecha <= Almdmov.fchdoc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE AlmStkGe THEN f-TotSal = Almdmov.CanDes * Almdmov.Factor * AlmStkge.CtoUni.
            END.
            
            /* ACUMULADOS */
            ASSIGN
                F-Saldo   = Almdmov.StkAct
                F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1
                F-PRECIO = Almdmov.VctoMn1.
            ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
            ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).
            ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
            ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).
        END.

        IF LAST-OF(Almmmatg.CodMat) THEN DO:
            /* Costo Unitario */
            FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                AND almstkge.codmat = almmmatg.codmat
                AND almstkge.fecha <= HastaF
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmStkGe THEN DO:
                ASSIGN
                    f-Saldo = AlmStkge.StkAct
                    f-Precio = AlmStkge.CtoUni
                    f-ValCto = f-Saldo * f-Precio.
            END.
            cColumn = STRING(iCount).
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-Ingreso).
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-TotIng).
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-Salida).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-TotSal).
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = F-Precio.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = F-Saldo.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = F-ValCto.
            x-total = x-total + F-VALCTO.
        END.
    END.    
    /*
    HIDE FRAME F-PROCESO.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel3 W-Win 
PROCEDURE Excel3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezados */
    DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
    DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
    DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
    DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
    DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
    DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
    DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-total AS DECIMAL.

    /* PARCHE: TODO EXPRESADO EN SOLES */
    DEF VAR nCodMon AS INT NO-UNDO.
    nCodMon = 1.
    /* ******************************* */

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "KARDEX GENERAL".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = s-subtit.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = IF nCodmon = 1 THEN "Expresado en Nuevos Soles " ELSE "Expresado en Dolares Americanos".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cat Contable".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Unidad".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Inicial".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Promedio Inicial".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Inicial".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ingresos".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Ingresos".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Salidas".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Salidas".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Promedio".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total".

    ASSIGN
       x-inggen = 0
       x-salgen = 0
       x-totgen = 0  
       x-total  = 0.
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.
    KARDEX:
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC  
        AND  Almmmatg.codfam BEGINS F-CodFam 
        AND  Almmmatg.TpoArt BEGINS R-Tipo 
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0
        AND  Almmmatg.Licencia[1] BEGINS x-Licencia,
        EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
            AND  Almdmov.codmat = Almmmatg.CodMat 
            AND  Almdmov.FchDoc >= DesdeF 
            AND  Almdmov.FchDoc <= HastaF,
            FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
                AND Almtmovm.TipMov = Almdmov.TipMov 
                AND Almtmovm.Codmov = Almdmov.Codmov
                AND Almtmovm.Movtrf = No,
                FIRST Almacen OF Almdmov NO-LOCK 
                    WHERE Almacen.FlgRep = YES AND Almacen.AlmCsg = No
                    BREAK BY Almmmatg.CodCia BY Almmmatg.CodMat:

        FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
            AND almstkge.codmat = almmmatg.codmat
            AND almstkge.fecha <= HastaF
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmStkGe OR Almstkge.stkact = 0 THEN NEXT.

        DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        IF FIRST-OF(Almmmatg.CodMat) THEN DO:
           /* BUSCAMOS SI TIENE MOVIMIENTOS ANTERIORES A DesdeF */
           FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia 
               AND AlmstkGe.CodMat = Almmmatg.CodMat 
               AND AlmstkGe.Fecha < DesdeF
               NO-LOCK NO-ERROR.
           ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
           ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).
           ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
           ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).
           ASSIGN
               F-STKGEN = 0
               F-SALDO  = 0
               F-PRECIO = 0
               F-VALCTO = 0.
           IF AVAILABLE AlmStkGe THEN DO:
              F-STKGEN = AlmStkGe.StkAct.
              F-SALDO  = AlmStkGe.StkAct.
              F-PRECIO = AlmStkGe.CtoUni.
              F-VALCTO = F-STKGEN * F-PRECIO.
           END.
           iCount = iCount + 1.
           cColumn = STRING(iCount).
           cRange = "A" + cColumn.
           chWorkSheet:Range(cRange):Value = "'" + Almmmatg.codmat.
           cRange = "B" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.desmat.
           cRange = "C" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.catconta[1].
           cRange = "D" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.desmar.
           cRange = "E" + cColumn.
           chWorkSheet:Range(cRange):Value = Almmmatg.undstk.
           cRange = "F" + cColumn.
           chWorkSheet:Range(cRange):Value = f-saldo.
           cRange = "G" + cColumn.
           chWorkSheet:Range(cRange):Value = f-precio.
           cRange = "H" + cColumn.
           chWorkSheet:Range(cRange):Value = f-valcto.
        END.

        ASSIGN
            F-Ingreso = 0
            F-TotIng = 0
            F-Salida = 0
            F-TotSal = 0.

        FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
            AND  Almcmov.CodAlm = Almdmov.codalm 
            AND  Almcmov.TipMov = Almdmov.tipmov 
            AND  Almcmov.CodMov = Almdmov.codmov 
            AND  Almcmov.NroDoc = Almdmov.nrodoc NO-LOCK NO-ERROR.

        IF AVAILABLE Almcmov THEN DO:
            ASSIGN
                x-codpro = Almcmov.codpro
                x-codcli = Almcmov.codcli
                x-nrorf1 = Almcmov.nrorf1
                x-nrorf2 = Almcmov.nrorf2
                x-codmon = Almcmov.codmon
                x-tpocmb = Almcmov.tpocmb.
        END.

        S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
        
        /* INGRESOS */
        F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-PreIng  = 0.
        F-TotIng  = 0.
        IF nCodmon = x-Codmon THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
                F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                F-TotIng  = Almdmov.ImpCto.
            END.
            ELSE DO:
                F-PreIng  = 0.
                F-TotIng  = F-PreIng * F-Ingreso.
            END.
        END.
        ELSE DO:
            IF nCodmon = 1 THEN DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                    F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
            ELSE DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                    F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
        END.
        f-Salida = 0.
        IF LOOKUP (Almdmov.TipMov, 'S,T') > 0 THEN DO:
            f-Salida = Almdmov.CanDes * Almdmov.Factor.
            /* Costo Unitario */
            FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                AND almstkge.codmat = almmmatg.codmat
                AND almstkge.fecha <= Almdmov.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE AlmStkGe THEN f-TotSal = Almdmov.CanDes * Almdmov.Factor * AlmStkge.CtoUni.
        END.
            
        /* ACUMULADOS */
        ASSIGN
            F-Saldo   = Almdmov.StkAct
            F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1
            F-PRECIO = Almdmov.VctoMn1.
        ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
        ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).
        ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
        ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).
        
        IF LAST-OF(Almmmatg.CodMat) THEN DO:
            /* Costo Unitario */
            FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                AND almstkge.codmat = almmmatg.codmat
                AND almstkge.fecha <= HastaF
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmStkGe THEN DO:
                ASSIGN
                    f-Saldo = AlmStkge.StkAct
                    f-Precio = AlmStkge.CtoUni
                    f-ValCto = f-Saldo * f-Precio.
            END.
            cColumn = STRING(iCount).
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-Ingreso).
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-TotIng).
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-Salida).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY Almmmatg.CodMat F-TotSal).
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = F-Precio.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = F-Saldo.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = F-ValCto.
            x-total = x-total + F-VALCTO.
        END.
    END.    
    /*
    HIDE FRAME F-PROCESO.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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

DEFINE VAR lCodMovIngresos  AS CHAR.
DEFINE VAR lCodMovSalidas AS CHAR.
DEFINE VAR lOperaIngresos  AS CHAR.
DEFINE VAR lOperaSalidas AS CHAR.
DEFINE VAR lPosOpera AS INT.
DEFINE VAR lTipoOperacion AS CHAR.

DEFINE VAR lserie AS CHAR.
DEFINE VAR lnrodoc AS CHAR.
DEFINE VAR ltipodoc AS CHAR.

DEFINE VAR lCodMov AS CHAR.
DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.
DEFINE VAR lPeriodo AS CHAR.

lCodMovIngresos = "02,06,09,03,50,13,14".
lOperaIngresos  = "02,02,05,10,99,99,99".

lCodMovSalidas = "02,09,50,51,55,56,12,13,14".
lOperaSalidas  = "01,06,10,10,10,10,12,99,99".

EMPTY TEMP-TABLE tt-kardex-sunat.

FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                     AND  Almmmatg.CodMat >= DesdeC  
                     AND  Almmmatg.CodMat <= HastaC  
                     AND  Almmmatg.codfam BEGINS F-CodFam 
                     AND  Almmmatg.TpoArt BEGINS R-Tipo 
                     /*AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0*/
                     AND  Almmmatg.Licencia[1] BEGINS x-Licencia,
    EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
                    AND  Almdmov.codmat = Almmmatg.CodMat 
                    AND  Almdmov.FchDoc >= DesdeF 
                    AND  Almdmov.FchDoc <= HastaF,
    FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
                    AND Almtmovm.TipMov = Almdmov.TipMov 
                    AND Almtmovm.Codmov = Almdmov.Codmov
                    AND Almtmovm.Movtrf = No,
    FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = Yes
                    AND Almacen.AlmCsg = No
                   BREAK BY Almmmatg.CodCia 
                         BY Almmmatg.CodMat
                         BY Almdmov.FchDoc:

    FIND FIRST almtabla WHERE almtabla.tabla = 'CC' AND almtabla.codigo = TRIM(Almmmatg.CatConta[1]) NO-LOCK NO-ERROR.

    lCodMov = STRING(almdmov.codmov,"99").
    IF almdmov.tipmov = 'I' THEN DO:
        lPosOpera = LOOKUP(lCodMov,lCodMovIngresos).
    END.
    ELSE DO:
        lPosOpera = LOOKUP(lCodMov,lCodMovSalidas).
    END.
    
    IF (almdmov.tipmov = 'I' AND LOOKUP(lCodMov,lCodMovIngresos) > 0) OR 
         (almdmov.tipmov = 'S' AND LOOKUP(lCodMov,lCodMovSalidas) > 0) THEN DO:        
        
        IF almdmov.tipmov = 'I' THEN DO:
            lTipoOperacion = ENTRY(lPosOpera,lOperaIngresos,",").
        END.
        ELSE DO:
            lTipoOperacion = ENTRY(lPosOpera,lOperaSalidas,",").
        END.
        

        IF FIRST-OF(Almmmatg.CodMat) THEN DO:
            FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia AND
                                   AlmstkGe.CodMat = Almmmatg.CodMat AND
                                   AlmstkGe.Fecha < DesdeF
                                   NO-LOCK NO-ERROR.
            F-STKGEN = 0.
            F-SALDO  = 0.
            F-PRECIO = 0.
            F-VALCTO = 0.

            IF AVAILABLE AlmStkGe THEN DO:
               F-STKGEN = AlmStkGe.StkAct.
               F-SALDO  = AlmStkGe.StkAct.
               F-PRECIO = AlmStkGe.CtoUni.
               IF F-PRECIO = ? THEN F-PRECIO = 0.
               F-VALCTO = F-STKGEN * F-PRECIO.
            END.
            
        END.
        FIND FIRST Almcmov
             WHERE Almcmov.CodCia = Almdmov.codcia 
                      AND  Almcmov.CodAlm = Almdmov.codalm 
                      AND  Almcmov.TipMov = Almdmov.tipmov 
                      AND  Almcmov.CodMov = Almdmov.codmov 
                      AND  Almcmov.NroDoc = Almdmov.nrodoc 
                     NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almcmov THEN DO:
            DISPLAY almdmov.codalm almdmov.tipmov almdmov.codmov almdmov.nrodoc.
        END.

        x-codmon = Almcmov.codmon.
        x-tpocmb = Almcmov.tpocmb.

        F-Ingreso = ( IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0 ).
        F-PreIng  = 0.
        F-TotIng  = 0.
        IF nCodmon = x-Codmon THEN DO:
           IF Almdmov.Tipmov = 'I' THEN DO:
              F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
              F-TotIng  = Almdmov.ImpCto.
           END.
           ELSE DO:
               IF Almtmovm.TipMov = "S" AND Almtmov.MovCmp = YES THEN DO:
                   F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                   F-TotIng  = Almdmov.ImpCto.
               END.
               ELSE DO:
                   F-PreIng  = 0.
                   F-TotIng  = F-PreIng * F-Ingreso.
               END.
           END.
        END.
        ELSE DO:
           IF nCodmon = 1 THEN DO:
              IF Almdmov.Tipmov = 'I' THEN DO:
                 F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                 F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
              END.
              IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                 F-PreIng  = 0.
                 F-TotIng  = F-PreIng * F-Ingreso.
              END.
              IF Almtmovm.TipMov = "S" AND Almtmov.MovCmp = YES THEN DO:
                  F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                  F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
              END.
           END.
           ELSE DO:
              IF Almdmov.Tipmov = 'I' THEN DO:
                 F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                 F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
              END.
              IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                 F-PreIng  = 0.
                 F-TotIng  = F-PreIng * F-Ingreso.
              END.
              IF Almtmovm.TipMov = "S" AND Almtmov.MovCmp = YES THEN DO:
                  F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                  F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
              END.
           END.
        END.
    
        F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-Saldo   = Almdmov.StkAct.
    
        IF Almdmov.VctoMn1 = ?  THEN DO:
          F-VALCTO = 0.
          F-PRECIO = 0.
        END.
        ELSE DO: 
            F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
            F-PRECIO = Almdmov.VctoMn1.
        END.               
        /**/
        lPeriodo = STRING(almdmov.fchdoc,"99/99/9999").
        SUBSTRING(lperiodo,7,4) + SUBSTRING(lperiodo,4,2) + "00".

        ltipodoc = "".
        lserie = "".
        lnrodoc = "".
        IF almdmov.tipmov = 'I' THEN DO:
            CASE almdmov.codmov:
                WHEN 2 THEN DO:
                    ltipodoc = "09".
                    IF INDEX(almcmov.nrorf3,"-") > 0 THEN DO:
                        lserie = SUBSTRING(almcmov.nrorf3,1,INDEX(almcmov.nrorf3,"-") - 1).
                        lnrodoc = SUBSTRING(almcmov.nrorf3,INDEX(almcmov.nrorf3,"-") + 1).
                    END.
                    ELSE DO:
                        lserie = SUBSTRING(almcmov.nrorf3,1,3).
                        lnrodoc = SUBSTRING(almcmov.nrorf3,4).                       
                    END.
                END.
                WHEN 3 THEN DO:
                    ltipodoc = "09".
                    lserie = SUBSTRING(almcmov.nrorf1,1,3).
                    lnrodoc = SUBSTRING(almcmov.nrorf1,4).                       
                END.
                WHEN 13 THEN DO:
                    ltipodoc = "99".
                    lSerie = STRING(almcmov.nroser,"999").
                    lnrodoc = STRING(almcmov.nrodoc,"999999").
                END.
                WHEN 14 THEN DO:
                    ltipodoc = "99".
                    lSerie = STRING(almcmov.nroser,"999").
                    lnrodoc = STRING(almcmov.nrodoc,"999999").
                END.
                WHEN 50 THEN DO:
                    ltipodoc = "99".
                    lSerie = STRING(almcmov.nroser,"999").
                    lnrodoc = STRING(almcmov.nrodoc,"999999").
                END.
            END CASE.
        END.
        ELSE DO:
            CASE almdmov.codmov:
                WHEN 2 THEN DO:
                    ltipodoc = "09".
                    lserie = SUBSTRING(almcmov.nroref,1,3).
                    lnrodoc = SUBSTRING(almcmov.nroref,4).                       
                END.
                WHEN 3 THEN DO:
                    ltipodoc = "99".
                    lSerie = STRING(almcmov.nroser,"999").
                    lnrodoc = STRING(almcmov.nrodoc,"999999").
                END.
                WHEN 13 THEN DO:
                    ltipodoc = "99".
                    lSerie = STRING(almcmov.nroser,"999").
                    lnrodoc = STRING(almcmov.nrodoc,"999999").
                END.
                WHEN 14 THEN DO:
                    ltipodoc = "99".
                    lSerie = STRING(almcmov.nroser,"999").
                    lnrodoc = STRING(almcmov.nrodoc,"999999").
                END.
            END CASE.
        END.

        CREATE tt-kardex-sunat.
            ASSIGN tt-periodo = lPeriodo
                tt-coduniope    = ""
                tt-numcorrasto  = ""
                tt-almacen      = "0001"
                tt-catalogo     = "9"                
                tt-tipo         = IF ( AVAILABLE almtabla) THEN almtabla.nomant ELSE ( "99 " + TRIM(Almmmatg.CatConta[1]))
                tt-codigo       = almdmov.codmat
                tt-codexisOSCE  = ""
                tt-femision     = STRING(almdmov.fchdoc,"99/99/9999")
                tt-tpodoc       = ltipodoc
                tt-nroserie     = lserie
                tt-nrodcto      = lnrodoc
                tt-tipope       = lTipoOperacion
                tt-desmat       = almmmatg.desmat
                tt-undmed       = "*"
                tt-meteval      = '1'
                tt-qingreso     = F-ingreso
                tt-qcostoing    = F-PreIng
                tt-qcosttotaling = F-TotIng
                tt-qsalidas     = F-salida
                tt-qcostosal    = F-PreIng
                tt-qcosttotalsal = F-TotIng
                tt-qfinal       = f-saldo
                tt-qcostofin    = f-precio
                tt-qcosttotalfin = f-valcto.

    END.
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
    ENABLE ALL EXCEPT F-DesFam F-DesSub x-NomLic x-mensaje.
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
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF .
  
  IF HastaC <> "" THEN HastaC = "".
  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.

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
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
            R-Tipo = ''.
     DISPLAY DesdeF HastaF R-Tipo.
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "x-Licencia" THEN ASSIGN input-var-1 = "LC".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-nrorf3 LIKE Almcmov.nrorf3 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.

  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  DEFINE VARIABLE x-total AS DECIMAL.

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.

  x-Archivo = 'KardexContable.txt'.
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


  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

  OUTPUT STREAM REPORT TO VALUE(x-Archivo).

    PUT STREAM REPORT UNFORMATTED
        "CODIGO|"
        "DESCRIPCION|"
        "CAT CONTABLE|"
        "MARCA|"
        "UM|"
        "ALMACEN|"
        "CODMOV|"
        "NUMERO|"
        "ALM ORIGEN|"
        "PROVEEDOR|"
        "CLIENTE|"
        "NRO DOCUMENTO|"
        "REFERENCIA|"
        "FAC|"
        "FECHA|"
        "INGRESO|"
        "SALIDA|"
        "CTO INGRESO|"
        "CTO PROMEDIO|"
        "SALDO|"
        "CTO TOTAL|"
        SKIP.
       
  ASSIGN
     x-inggen = 0
     x-salgen = 0
     x-totgen = 0  
     x-total  = 0.
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.CodMat >= DesdeC  
                             AND  Almmmatg.CodMat <= HastaC  
                             AND  Almmmatg.codfam BEGINS F-CodFam 
                             AND  Almmmatg.TpoArt BEGINS R-Tipo 
                             AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0,
      EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
                            AND  Almdmov.codmat = Almmmatg.CodMat 
                            AND  Almdmov.FchDoc >= DesdeF 
                            AND  Almdmov.FchDoc <= HastaF,
      FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
                            AND Almtmovm.TipMov = Almdmov.TipMov 
                            AND Almtmovm.Codmov = Almdmov.Codmov
                            AND Almtmovm.Movtrf = No,
      FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = Yes
                            AND Almacen.AlmCsg = No
                           BREAK BY Almmmatg.CodCia 
                                 BY Almmmatg.CodMat
                                 BY Almdmov.FchDoc:

      /*
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
      */
      DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje
          WITH FRAME {&FRAME-NAME}.

      IF FIRST-OF(Almmmatg.CodMat) THEN DO:

         /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
         FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia AND
                                AlmstkGe.CodMat = Almmmatg.CodMat AND
                                AlmstkGe.Fecha < DesdeF
                                NO-LOCK NO-ERROR.
         F-STKGEN = 0.
         F-SALDO  = 0.
         F-PRECIO = 0.
         F-VALCTO = 0.
     
         IF AVAILABLE AlmStkGe THEN DO:
            F-STKGEN = AlmStkGe.StkAct.
            F-SALDO  = AlmStkGe.StkAct.
            F-PRECIO = AlmStkGe.CtoUni.
            F-VALCTO = F-STKGEN * F-PRECIO.
         END.

      END.

      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".
      x-nrorf3 = "".

      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.

      IF AVAILABLE Almcmov THEN DO:
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2
            X-nrorf3 = Almcmov.nrorf3
            x-codmon = Almcmov.codmon
            x-tpocmb = Almcmov.tpocmb.
      END.
                  
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 

      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-PreIng  = 0.
      F-TotIng  = 0.

      IF nCodmon = x-Codmon THEN DO:
         IF Almdmov.Tipmov = 'I' THEN DO:
            F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
            F-TotIng  = Almdmov.ImpCto.
         END.
         ELSE DO:
            F-PreIng  = 0.
            F-TotIng  = F-PreIng * F-Ingreso.
         END.
         END.
      ELSE DO:
         IF nCodmon = 1 THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
               F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = 0.
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
            END.
         ELSE DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
               F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = 0.
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
         END.
      END.

      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Saldo   = Almdmov.StkAct.
      F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
      F-PRECIO = Almdmov.VctoMn1.
      ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).

        PUT STREAM REPORT UNFORMATTED
            Almmmatg.CodMat "|"
            Almmmatg.DesMat "|"
            Almmmatg.catconta[1] "|"
            Almmmatg.DesMar "|"
            Almmmatg.UndStk "|"
            Almdmov.CodAlm  "|"
            S-CODMOV "|"
            STRING(Almdmov.NroDoc,">999999") "|".
        IF Almdmov.Codmov = 03 THEN PUT STREAM REPORT UNFORMATTED Almdmov.Almori "|".
        ELSE PUT STREAM REPORT UNFORMATTED "|".
        PUT STREAM REPORT UNFORMATTED
            x-CodPro "|"
            x-CodCli "|"
            x-NroRf1 "|"
            x-NroRf2 "|"
            x-NroRf3 "|"
            Almdmov.FchDoc "|"
            F-Ingreso "|"
            F-Salida "|".
        IF Almdmov.TipMov = "I" AND (ALmtmovm.TpoCto = 0 OR ALmtmovm.TpoCto = 1) THEN
            PUT STREAM REPORT UNFORMATTED F-PreIng "|".
        ELSE PUT STREAM REPORT UNFORMATTED "|".
        PUT STREAM REPORT UNFORMATTED
            F-PRECIO "|"
            F-SALDO "|"
            F-VALCTO "|"
            SKIP.
      IF LAST-OF(Almmmatg.CodMat) THEN DO:
        x-total = x-total + F-VALCTO.
      END.
  END.    
  /*
  HIDE FRAME F-PROCESO.
  */
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

