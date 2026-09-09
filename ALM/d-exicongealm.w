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
DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

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

/****************/
DEFINE VAR F-PESGEN  AS DECIMAL NO-UNDO.
DEFINE VAR C-MONEDA  AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR CATEGORIA AS CHAR INIT "CC".
DEFINE VAR X-DESCAT  AS CHAR .
/*****************/


DEFINE TEMP-TABLE Tempo 
       FIELD Codcia LIKE ALmmmatg.Codcia
       FIELD Catego AS CHAR FORMAT "X(2)"
       FIELD DesCat AS CHAR FORMAT "X(20)"
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD DesMat LIKE ALmmmatg.DesMat
       FIELD DesMar LIKE Almmmatg.DesMar 
       FIELD UndStk LIKE Almmmatg.UndStk 
       FIELD F-STKGEN  AS DECI FORMAT "->>>>>>>9.99"
       FIELD F-PRECTO  AS DECI FORMAT "->>>>9.9999"
       FIELD F-VALCTO  AS DECI FORMAT "->>>>>>>9.99"
       FIELD F-COSTO AS DECI FORMAT "->>>>9.9999"
       FIELD FT-COSTO AS DECI FORMAT "->>>>>>>9.99".

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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-61 RECT-59 RECT-58 RECT-56 ~
F-Catconta Btn_OK DesdeC HastaC F-marca1 F-provee1 Btn_Cancel D-Corte ~
F-Almacen R-Tipo I-CodMon T-Resumen 
&Scoped-Define DISPLAYED-OBJECTS F-Desconta F-Catconta DesdeC HastaC ~
F-marca1 F-provee1 D-Corte F-Almacen R-Tipo I-CodMon T-Resumen 

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

DEFINE VARIABLE D-Corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .69 NO-UNDO.

DEFINE VARIABLE F-Catconta AS CHARACTER FORMAT "X(3)":U 
     LABEL "Categoria Contable" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-Desconta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .69 NO-UNDO.

DEFINE VARIABLE F-marca1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 32.57 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 36 BY 1.42.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 15.72 BY 1.08.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 28.14 BY 1.27.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13.43 BY 9.65.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 9.69.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumen Por Categoria Contable" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.57 BY .73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Desconta AT ROW 1.65 COL 20 COLON-ALIGNED NO-LABEL
     F-Catconta AT ROW 1.69 COL 14 COLON-ALIGNED
     Btn_OK AT ROW 2.04 COL 57.57
     DesdeC AT ROW 2.58 COL 14 COLON-ALIGNED
     HastaC AT ROW 2.62 COL 43 COLON-ALIGNED
     F-marca1 AT ROW 3.46 COL 14 COLON-ALIGNED
     F-provee1 AT ROW 4.27 COL 14 COLON-ALIGNED
     Btn_Cancel AT ROW 4.5 COL 57.57
     D-Corte AT ROW 5.08 COL 14 COLON-ALIGNED
     F-Almacen AT ROW 5.92 COL 14.14 COLON-ALIGNED
     R-Tipo AT ROW 7.08 COL 17 NO-LABEL
     I-CodMon AT ROW 8.42 COL 17.14 NO-LABEL
     T-Resumen AT ROW 9.73 COL 17.43
     "Estado" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 7.35 COL 9.86
     "Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 8.85 COL 8.72
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-62 AT ROW 1.23 COL 1.57
     RECT-61 AT ROW 1.23 COL 56.57
     RECT-59 AT ROW 9.5 COL 16.29
     RECT-58 AT ROW 8.31 COL 16.14
     RECT-56 AT ROW 6.88 COL 16.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.86 BY 10.96
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
         TITLE              = "Existencias Generales X Categoria Contable"
         HEIGHT             = 10.04
         WIDTH              = 69.57
         MAX-HEIGHT         = 13.54
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 13.54
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-Desconta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Existencias Generales X Categoria Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Existencias Generales X Categoria Contable */
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
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Catconta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Catconta W-Win
ON LEAVE OF F-Catconta IN FRAME F-Main /* Categoria Contable */
DO:
   ASSIGN F-Catconta.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.

   FIND Almtabla WHERE Almtabla.Tabla  = "CC" AND
                       Almtabla.codigo = F-Catconta NO-LOCK NO-ERROR.
   IF AVAILABLE Almtabla THEN 
      DISPLAY Almtabla.Nombre @ F-Desconta WITH FRAME {&FRAME-NAME}.
      
     IF NOT AVAILABLE Almtabla THEN DO:
       MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca1 W-Win
ON LEAVE OF F-marca1 IN FRAME F-Main /* Marca */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND almtabla WHERE almtabla.Tabla = "MK" 
                  AND  almtabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee1 W-Win
ON LEAVE OF F-provee1 IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
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
  ASSIGN D-Corte DesdeC HastaC I-CodMon 
         F-Catconta F-Desconta 
         T-Resumen R-Tipo
         F-marca1 F-provee1 F-Almacen.
  
  IF I-CodMon = 1 THEN C-MONEDA = "NUEVOS SOLES".
  ELSE C-MONEDA = "DOLARES AMERICANOS".
  
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  IF HastaC    = "" THEN HastaC    = "999999999".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo W-Win 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I AS INTEGER.
  DEFINE VAR x-stock AS DECI.
  DEFINE VAR x-ctouni AS DECI.
    
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.CodMat >= DesdeC  
                             AND  Almmmatg.CodMat <= HastaC 
                             AND  Almmmatg.CodMar BEGINS F-marca1 
                             AND  Almmmatg.CodPr1 BEGINS F-provee1
                             AND  Almmmatg.Catconta[1] BEGINS F-Catconta 
                             AND  Almmmatg.TpoArt BEGINS R-Tipo: 
                                  
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      
      
      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= D-CORTE NO-LOCK NO-ERROR.
      
      x-stock = 0.
      DO I = 1 TO NUM-ENTRIES(F-Almacen):
        FIND LAST AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA AND
                          AlmStkAl.Codmat = Almmmatg.Codmat AND
                          AlmStkAl.CodAlm = ENTRY(I,F-Almacen) AND
                          AlmStkAl.Fecha <= D-Corte
                          NO-LOCK NO-ERROR.
                          
        IF AVAILABLE AlmStkAl THEN 
           ASSIGN
           x-stock = x-stock + AlmStkAl.StkAct
           x-CtoUni = AlmStkal.CtoUni.
      
      END.
      IF x-stock = 0 THEN NEXT.
      
      FIND Tempo WHERE Tempo.Codcia = S-CODCIA AND
                       Tempo.Codmat = Almmmatg.Codmat
                       EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAILABLE Tempo THEN DO:
         X-DESCAT = "".
         FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                       AND  Almtabla.codigo = Almmmatg.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN X-DESCAT = Almtabla.Nombre.
         
         CREATE Tempo.
         ASSIGN 
         Tempo.Codcia = Almmmatg.Codcia 
         Tempo.Codmat = Almmmatg.Codmat
         Tempo.Desmat = Almmmatg.Desmat
         Tempo.DesMar = Almmmatg.DesMar
         Tempo.UndStk = Almmmatg.UndStk
         Tempo.Catego = Almmmatg.Catconta[1]
         Tempo.Descat = X-DESCAT.   
      END.        

      F-STKGEN = x-stock.
      F-PRECTO = x-CtoUni.
      
      IF I-CodMon = 1 THEN F-VALCTO = F-STKGEN * F-PRECTO.
      IF I-CodMon = 2 THEN F-VALCTO = F-STKGEN * F-PRECTO / Gn-Tcmb.Compra. 

 

      /***************Costo Ultima Reposicion********MAGM***********/
      F-COSTO = 0.
      IF F-COSTO = 0 THEN DO:
         F-COSTO = Almmmatg.Ctolis.
         IF I-CodMon <> Almmmatg.MonVta THEN DO:
            IF I-CodMon = 1 THEN F-costo = F-costo * gn-tcmb.venta. 
            IF I-CodMon = 2 THEN F-costo = F-costo / gn-tcmb.venta. 
         END.            
      END.
      FT-COSTO = F-COSTO * F-STKGEN.
      
      /***************************************************************/

  END.
  HIDE FRAME F-PROCESO.
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
  DISPLAY F-Desconta F-Catconta DesdeC HastaC F-marca1 F-provee1 D-Corte 
          F-Almacen R-Tipo I-CodMon T-Resumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-61 RECT-59 RECT-58 RECT-56 F-Catconta Btn_OK DesdeC 
         HastaC F-marca1 F-provee1 Btn_Cancel D-Corte F-Almacen R-Tipo I-CodMon 
         T-Resumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4 W-Win 
PROCEDURE Formato4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Tempo:
      DELETE Tempo.
  END.
  
  RUN Carga-Tempo.
  
  DEFINE FRAME F-REPORTE
         Tempo.Codmat
         Tempo.DesMat FORMAT "X(35)" 
         Tempo.DesMar FORMAT "X(10)" 
         Tempo.UndStk 
         Tempo.F-STKGEN     
         Tempo.F-PRECTO     
         Tempo.F-VALCTO 
         Tempo.F-COSTO 
         Tempo.FT-COSTO
         HEADER
         S-NOMCIA  FORMAT "X(50)" SKIP
         "EXISTENCIAS GENERALES X CATEGORIA CONTABLE AL "  AT 30  D-Corte
         "Pagina :" TO 115 PAGE-NUMBER(REPORT) TO 136 FORMAT "ZZZZZ9" SKIP
         "Fecha :" TO 115 TODAY TO 136 FORMAT "99/99/9999" SKIP
         "Hora :" TO 115 STRING(TIME,"HH:MM:SS") TO 136 SKIP
         "Moneda : " C-MONEDA SKIP
         "Almacenes Evaluados : " F-Almacen FORMAT "X(150)" SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                P R O M E D I O        R E P O S I C I O N      " SKIP
         " Codigo      Descripcion                       Marca     Unid    Cantidad    Costo Unit.     Total     Costo Unit.   Total      " SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Tempo 
      BREAK BY Tempo.codcia 
            BY Tempo.Catego
            BY Tempo.CodMat:
                                  
         IF FIRST-OF(Tempo.Catego) AND NOT T-Resumen THEN DO:   
               DISPLAY STREAM REPORT 
                    Tempo.Catego @ Tempo.codmat
                    Tempo.Descat @ Tempo.DesMat
               WITH FRAME F-REPORTE.
               DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         END.
         
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Tempo.Codmat 
                 Tempo.DesMat
                 Tempo.DesMar
                 Tempo.UndStk 
                 Tempo.F-STKGEN  
                 Tempo.F-PRECTO  
                 Tempo.F-VALCTO 
                 Tempo.F-COSTO
                 Tempo.FT-COSTO 
                 WITH FRAME F-REPORTE.
         END.
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Tempo.Catego).
         ACCUMULATE F-VALCTO (TOTAL).
         ACCUMULATE FT-COSTO (SUB-TOTAL BY Tempo.Catego).
         ACCUMULATE FT-COSTO (TOTAL).
      
      IF LAST-OF(Tempo.Catego) THEN DO:      
         IF T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Tempo.Catego @ Tempo.codmat
                 Tempo.Descat @ Tempo.DesMat
                 ACCUM SUB-TOTAL BY Tempo.Catego Tempo.F-VALCTO @ Tempo.F-VALCTO 
                 ACCUM SUB-TOTAL BY Tempo.Catego Tempo.FT-COSTO @ Tempo.FT-COSTO  
            WITH FRAME F-REPORTE.
         END.
         ELSE DO:
            UNDERLINE STREAM REPORT 
            Tempo.F-VALCTO 
            Tempo.FT-COSTO 
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Categoria  --> ' @ Tempo.Desmat
                ACCUM SUB-TOTAL BY Tempo.Catego Tempo.F-VALCTO @ Tempo.F-VALCTO 
                ACCUM SUB-TOTAL BY Tempo.Catego Tempo.FT-COSTO @ Tempo.FT-COSTO 
            WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Tempo.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT 
         Tempo.F-VALCTO 
         Tempo.FT-COSTO 
         WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Tempo.Desmat
             ACCUM TOTAL Tempo.F-VALCTO @ Tempo.F-VALCTO 
             ACCUM TOTAL Tempo.FT-COSTO @ Tempo.FT-COSTO 
         WITH FRAME F-REPORTE.
         
         UNDERLINE STREAM REPORT 
         Tempo.F-VALCTO 
         Tempo.FT-COSTO 
         WITH FRAME F-REPORTE.
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
    ENABLE ALL EXCEPT F-Desconta.
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
   
  RUN Formato4.
  
  
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
  ASSIGN D-Corte DesdeC HastaC I-CodMon 
         F-Catconta F-Desconta 
         T-Resumen R-Tipo
         F-marca1 F-provee1 .
  
  IF HastaC <> "" THEN HastaC = "".

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
     D-Corte = TODAY.
     R-Tipo = ''.
     DISPLAY D-Corte R-Tipo.
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
        WHEN "F-Catconta" THEN ASSIGN input-var-1 = "CC".
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
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

