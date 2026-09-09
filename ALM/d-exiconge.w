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
       FIELD UndStk AS CHAR FORMAT 'x(7)' 
       FIELD catcon LIKE Almmmatg.catconta
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
&Scoped-Define ENABLED-OBJECTS x-Linea F-Catconta DesdeC HastaC F-marca1 ~
F-provee1 D-Corte R-Tipo I-CodMon T-Resumen Btn_OK Btn_Cancel Btn_Excel ~
RECT-56 RECT-58 RECT-59 RECT-61 RECT-62 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje x-Linea F-Desconta F-Catconta ~
DesdeC HastaC F-marca1 F-provee1 D-Corte R-Tipo I-CodMon T-Resumen 

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

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Salida a Excel".

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE D-Corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-Catconta AS CHARACTER FORMAT "X(3)":U 
     LABEL "Categoria Contable" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Desconta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.

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
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81 NO-UNDO.

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
     SIZE 13 BY 11.04.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55.29 BY 11.04.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumen Por Categoria Contable" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.57 BY .73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 11.12 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     x-Linea AT ROW 2.54 COL 14 COLON-ALIGNED
     F-Desconta AT ROW 1.65 COL 20 COLON-ALIGNED NO-LABEL
     F-Catconta AT ROW 1.69 COL 14 COLON-ALIGNED
     DesdeC AT ROW 3.5 COL 14 COLON-ALIGNED
     HastaC AT ROW 3.54 COL 43.43 COLON-ALIGNED
     F-marca1 AT ROW 4.38 COL 14 COLON-ALIGNED
     F-provee1 AT ROW 5.19 COL 14 COLON-ALIGNED
     D-Corte AT ROW 6 COL 14 COLON-ALIGNED
     R-Tipo AT ROW 7.12 COL 17.29 NO-LABEL
     I-CodMon AT ROW 8.46 COL 17.43 NO-LABEL
     T-Resumen AT ROW 9.77 COL 17.72
     Btn_OK AT ROW 2.08 COL 58
     Btn_Cancel AT ROW 6.38 COL 58
     Btn_Excel AT ROW 4.23 COL 58 WIDGET-ID 2
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 7.38 COL 10.14
     "Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 8.88 COL 9
     RECT-56 AT ROW 6.96 COL 16
     RECT-58 AT ROW 8.5 COL 16
     RECT-59 AT ROW 9.46 COL 16
     RECT-61 AT ROW 1.27 COL 57
     RECT-62 AT ROW 1.27 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.72 BY 11.58
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
         HEIGHT             = 11.58
         WIDTH              = 69.72
         MAX-HEIGHT         = 11.58
         MAX-WIDTH          = 69.72
         VIRTUAL-HEIGHT     = 11.58
         VIRTUAL-WIDTH      = 69.72
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN F-Desconta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
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


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:                            
    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Excel. 
    RUN Habilita.
    RUN Inicializa-Variables.
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
  /*SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").*/
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
  /*SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").*/
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
         F-marca1 F-provee1
         x-Linea.
  
  IF I-CodMon = 1 THEN C-MONEDA = "NUEVOS SOLES".
  ELSE C-MONEDA = "DOLARES AMERICANOS".
  
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  /*IF HastaC    = "" THEN HastaC    = "999999999".*/
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
  DEF VAR F-Saldo AS DEC.
   
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  (x-Linea = 'Todas' OR Almmmatg.codfam = x-Linea)
        AND  (TRUE <> (DesdeC > '') OR Almmmatg.CodMat >= DesdeC)
        AND  (TRUE <> (HastaC > '') OR Almmmatg.CodMat <= HastaC)
        AND  Almmmatg.CodMar BEGINS F-marca1 
        AND  Almmmatg.CodPr1 BEGINS F-provee1
        AND  Almmmatg.Catconta[1] BEGINS F-Catconta 
        AND  Almmmatg.TpoArt BEGINS R-Tipo: 
      DISPLAY "Codigo de Articulo: " +  Almmmatg.CodMat @ x-mensaje
          WITH FRAME {&FRAME-NAME}.

      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= D-CORTE NO-LOCK NO-ERROR.

    /* Saldo Logistico */
    ASSIGN
        F-Saldo = 0.
    /* Costo Unitario */
    FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
        AND almstkge.codmat = almmmatg.codmat
        AND almstkge.fecha <= D-Corte
        NO-LOCK NO-ERROR.

    IF AVAILABLE Almstkge THEN f-Saldo = AlmStkge.StkAct.
    IF f-Saldo = 0 THEN NEXT.
    IF Almstkge.CtoUni = ? THEN DO:
        MESSAGE 'Código' Almmmatg.codmat 'presenta un error el el costo promedio'
            VIEW-AS ALERT-BOX WARNING.
        NEXT.
    END.
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
    IF AVAILABLE Almstkge THEN Tempo.f-PreCto = Almstkge.CtoUni.
    Tempo.f-StkGen = F-Saldo.
    IF I-CodMon = 1 THEN DO: 
        Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO.
    END.
    IF I-CodMon = 2 THEN DO: 
        Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO / Gn-Tcmb.Compra. 
    END.
    
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
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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
  DISPLAY x-mensaje x-Linea F-Desconta F-Catconta DesdeC HastaC F-marca1 
          F-provee1 D-Corte R-Tipo I-CodMon T-Resumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Linea F-Catconta DesdeC HastaC F-marca1 F-provee1 D-Corte R-Tipo 
         I-CodMon T-Resumen Btn_OK Btn_Cancel Btn_Excel RECT-56 RECT-58 RECT-59 
         RECT-61 RECT-62 
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
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
chWorkSheet:COLUMNS("B"):ColumnWidth = 4.
chWorkSheet:COLUMNS("C"):ColumnWidth = 4.
chWorkSheet:COLUMNS("D"):ColumnWidth = 7.
chWorkSheet:COLUMNS("E"):ColumnWidth = 50.
chWorkSheet:COLUMNS("F"):ColumnWidth = 15.
chWorkSheet:COLUMNS("G"):ColumnWidth = 5.
chWorkSheet:COLUMNS("H"):ColumnWidth = 10.
chWorkSheet:COLUMNS("I"):ColumnWidth = 10.
chWorkSheet:COLUMNS("J"):ColumnWidth = 10.
chWorkSheet:COLUMNS("K"):ColumnWidth = 10.
chWorkSheet:COLUMNS("L"):ColumnWidth = 10.

chWorkSheet:Range("A1: L3"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "EXISTENCIAS GENERALES X CATEGORIA CONTABLE" +
    " AL " + STRING(D-Corte) .
chWorkSheet:Range("A2"):VALUE = "Cat.".
chWorkSheet:Range("A3"):VALUE = "Con.".
chWorkSheet:Range("B2"):VALUE = "Cod.".
chWorkSheet:Range("B3"):VALUE = "Fam.".
chWorkSheet:Range("C2"):VALUE = "Sub.".
chWorkSheet:Range("C3"):VALUE = "Fam.".
chWorkSheet:Range("D3"):VALUE = "Código".
chWorkSheet:Range("E3"):VALUE = "Descripción".
chWorkSheet:Range("F3"):VALUE = "Marca".
chWorkSheet:Range("G3"):VALUE = "Unid.".
chWorkSheet:Range("H3"):VALUE = "Cantidad.".
chWorkSheet:Range("I2"):VALUE = "PROMEDIO".
chWorkSheet:Range("I3"):VALUE = "Costo Unit.".
chWorkSheet:Range("J2"):VALUE = "PROMEDIO".
chWorkSheet:Range("J3"):VALUE = "Total".
chWorkSheet:Range("K2"):VALUE = "REPOSICION".
chWorkSheet:Range("K3"):VALUE = "Costo Unit.".
chWorkSheet:Range("L2"):VALUE = "REPOSICION".
chWorkSheet:Range("L3"):VALUE = "Total".

chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
/*chWorkSheet:COLUMNS("H"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".
chWorkSheet:COLUMNS("K"):NumberFormat = "@".
chWorkSheet:COLUMNS("L"):NumberFormat = "@".*/

chWorkSheet = chExcelApplication:Sheets:Item(1).

EMPTY TEMP-TABLE Tempo.

RUN Carga-Tempo.

loopREP:
FOR EACH Tempo NO-LOCK, FIRST Almmmatg OF Tempo NO-LOCK
      BREAK BY Tempo.codcia 
            BY Tempo.Catego
            BY Tempo.DesMat:

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Tempo.Catego.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.codfam.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.subfam.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Tempo.Codmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Tempo.DesMat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = TRIM(Tempo.DesMar).
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Tempo.UndStk.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(Tempo.F-STKGEN, "->>>>>>.99").
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(Tempo.F-PRECTO, "->>>>>>.9999").
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(Tempo.F-VALCTO, "->>>>>>.99").
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(Tempo.F-COSTO, "->>>>>>.9999").
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(Tempo.FT-COSTO, "->>>>>>.99").
    
    /*  
      DISPLAY Tempo.Codmat @ Fi-Mensaje LABEL "Código de Material"
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
    READKEY PAUSE 0.
    IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.
    */

    DISPLAY "Código de Material: " + Tempo.Codmat @ x-mensaje
        WITH FRAME {&FRAME-NAME}.
END.
/*
HIDE FRAME F-Proceso NO-PAUSE.
*/
DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}. 

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

  EMPTY TEMP-TABLE Tempo.
  
  RUN Carga-Tempo.
  
  DEFINE FRAME F-REPORTE
         Tempo.Catego format "x(4)"
         Almmmatg.codfam
         Almmmatg.subfam
         Tempo.Codmat
         Tempo.DesMat FORMAT "X(35)" 
         Tempo.DesMar FORMAT "X(10)" 
         Tempo.UndStk FORMAT 'x(6)'
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
         "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cat  Cod Sub                                                                             P R O M E D I O        R E P O S I C I O N       " SKIP
         "Con  Fam Fam Codigo      Descripcion                       Marca     Unid    Cantidad    Costo Unit.     Total     Costo Unit.   Total    " SKIP
         "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
          1234 123 123 123456 12345678901234567890123456789012345 1234567890 123456 ->>>>>>>9.99 ->>>>>>>9.99 ->>>>>>>9.99 ->>>>>>>9.99 ->>>>>>>9.99 12
          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                   1         2         3         4         5         6         7         8         9        10        11        12        13        14
*/

  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Tempo NO-LOCK, FIRST Almmmatg OF Tempo NO-LOCK
      BREAK BY Tempo.codcia 
            BY Tempo.Catego
            BY Tempo.DesMat:
                                  
         IF FIRST-OF(Tempo.Catego) AND NOT T-Resumen THEN DO:   
               DISPLAY STREAM REPORT 
                    Tempo.Catego @ Tempo.codmat
                    Tempo.Descat @ Tempo.DesMat
               WITH FRAME F-REPORTE.
               DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         END.
         
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Tempo.Catego 
                 Almmmatg.codfam
                 Almmmatg.subfam
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
    ENABLE ALL EXCEPT F-Desconta x-mensaje.
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
        RUN Formato4.
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
     FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia:
        x-Linea:ADD-LAST(Almtfami.codfam).
     END.
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

