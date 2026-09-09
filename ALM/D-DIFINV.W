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

/****************/
DEFINE VAR F-STKALM  AS DECIMAL.
DEFINE VAR F-STKGEN  AS DECIMAL.
DEFINE VAR F-VALCTO  AS DECIMAL.
DEFINE VAR I-NROITM  AS INTEGER.
DEFINE VAR X-TASK-NO AS INTEGER.
DEFINE VAR C-TPOINV  AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE VAR I AS INTEGER.
DEFINE VAR X-TIPMOV AS CHAR INIT "I,S".
define        var x-tcamb  as decimal.
DEFINE BUFFER DMOV FOR ALMDMOV.    .

/*****************/

DEFINE TEMP-TABLE tmp-temporal
    FIELD t-codigo LIKE Almmmate.CodMat
    FIELD t-desmat LIKE Almmmatg.DesMat
    FIELD t-desmar LIKE Almmmatg.DesMar
    FIELD t-undstk LIKE Almmmatg.UndStk
    FIELD t-linea  LIKE Almmmatg.codfam
    FIELD t-subfam LIKE Almmmatg.subfam
    FIELD t-codubi LIKE Almmmate.CodUbi
    FIELD t-stkgen AS DECIMAL   FORMAT "(>>>,>>9.99)"
    FIELD t-valcto AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkalm AS DECIMAL   FORMAT "(>>>,>>9.99)"
    FIELD t-costo AS DECIMAL    FORMAT "(>>>,>>9.9999)"
    FIELD t-stkact AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkcon AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkrec AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkdif AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-imptot AS DECIMAL   FORMAT "(>>,>>>,>>9.99)"
    FIELD t-sw AS LOGICAL INITIAL FALSE
    INDEX idx01 IS PRIMARY t-codigo
    INDEX idx02 t-linea t-subfam t-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 DesdeC HastaC D-FchInv ICodMon ~
COMBO-BOX-1 R-costo B-expor Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DesdeC HastaC D-FchInv ICodMon COMBO-BOX-1 ~
R-costo F-DesMatD F-DesMatH 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-expor 
     LABEL "Exportar" 
     SIZE 11 BY 1.5.

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

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Sub-linea" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE D-FchInv AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha del Inventario" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesMatD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesMatH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE ICodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .54 NO-UNDO.

DEFINE VARIABLE R-costo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposicion", 2,
"Costo Comercial (sin igv)", 3
     SIZE 40.57 BY .54 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 68 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 8.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DesdeC AT ROW 2.62 COL 17.14 COLON-ALIGNED
     HastaC AT ROW 3.58 COL 17.14 COLON-ALIGNED
     D-FchInv AT ROW 4.54 COL 17.14 COLON-ALIGNED
     ICodMon AT ROW 5.54 COL 19.14 NO-LABEL
     COMBO-BOX-1 AT ROW 6.23 COL 17.14 COLON-ALIGNED
     R-costo AT ROW 7.35 COL 19.14 NO-LABEL
     F-DesMatD AT ROW 2.62 COL 28.14 COLON-ALIGNED NO-LABEL
     F-DesMatH AT ROW 3.58 COL 28.14 COLON-ALIGNED NO-LABEL
     B-expor AT ROW 10.31 COL 31.43
     Btn_OK AT ROW 10.31 COL 43.86
     Btn_Cancel AT ROW 10.31 COL 56.29
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.23 COL 1
     "Valorizado" VIEW-AS TEXT
          SIZE 7.72 BY .5 AT ROW 5.58 COL 10.72
     "Tipo de Costo" VIEW-AS TEXT
          SIZE 10.14 BY .5 AT ROW 7.35 COL 8.29
     RECT-57 AT ROW 1.19 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.29 BY 11.5
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
         TITLE              = "Diferencia de Inventarios"
         HEIGHT             = 10.92
         WIDTH              = 68.29
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 68.29
         VIRTUAL-HEIGHT     = 11.5
         VIRTUAL-WIDTH      = 68.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR FILL-IN F-DesMatD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesMatH IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Diferencia de Inventarios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Diferencia de Inventarios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-expor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-expor W-Win
ON CHOOSE OF B-expor IN FRAME F-Main /* Exportar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Carga-Temporal.
  RUN Exporta.
  RUN Habilita.
  RUN Inicializa-Variables.

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


&Scoped-define SELF-NAME D-FchInv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-FchInv W-Win
ON LEAVE OF D-FchInv IN FRAME F-Main /* Fecha del Inventario */
DO:
    ASSIGN D-FchInv.
    
    IF D-FchInv = ? THEN RETURN.
    
     FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                     AND  InvConfig.CodAlm = S-CODALM 
                     AND  InvConfig.FchInv = D-FchInv
                    NO-LOCK NO-ERROR.
     IF NOT AVAILABLE InvConfig THEN DO:
        MESSAGE "Fecha de Inventario no existe"
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Desde */
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


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* Hasta */
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
  ASSIGN DesdeC HastaC D-FchInv ICodMon COMBO-BOX-1 R-costo.
  
  IF HastaC = "" THEN HastaC = "999999".

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
define var f-prcprm as decimal format ">>,>>9.9999".
IF HastaC = "" THEN HastaC = "999999".

    FOR EACH tmp-temporal:
        DELETE tmp-temporal.
    END.

FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                   AND  Almmmate.CodAlm = S-CODALM 
                   AND  (Almmmate.CodMat >= DesdeC
                   AND   Almmmate.CodMat <= HastaC) 
                  NO-LOCK USE-INDEX Mate01:
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.
  
    /* UBICAMOS EL STOCK GENERAL */
    FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
                       /*AND  Almdmov.Codalm = Almmmate.CodAlm*/
                       AND  Almdmov.CodMat = Almmmate.CodMat 
                       AND  Almdmov.fchdoc <= InvConfig.FchInv 
                      USE-INDEX Almd02 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN 
        F-STKGEN = Almdmov.StkAct.
    ELSE 
        F-STKGEN = 0.

    IF AVAILABLE Almdmov AND ICodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
    IF AVAILABLE Almdmov AND ICodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
  
    /* UBICAMOS EL STOCK DE ALMACEN */
    FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
                       AND  Almdmov.CodAlm = Almmmate.CodAlm 
                       AND  Almdmov.CodMat = Almmmate.CodMat 
                       AND  Almdmov.fchdoc <= InvConfig.FchInv 
                      USE-INDEX Almd03 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN 
          F-STKALM = Almdmov.StkSub.
        /*  F-STKALM = Almdmov.Stkact.*/    
    ELSE 
        F-STKALM = 0.
    /****************Descuenta el Ajuste por Inventario***************/

    FOR EACH Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
                      AND  Almdmov.CodAlm = Almmmate.CodAlm 
                      AND  Almdmov.CodMat = Almmmate.CodMat 
                      AND  Almdmov.fchdoc = InvConfig.FchInv 
                      AND  Almdmov.TipMov = "I" 
                      AND  Almdmov.CodMov = 01
                      USE-INDEX Almd03 NO-LOCK :
    
      F-STKALM = F-STKALM - Almdmov.CanDes .
    END.
    FOR EACH Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
                      AND  Almdmov.CodAlm = Almmmate.CodAlm 
                      AND  Almdmov.CodMat = Almmmate.CodMat 
                      AND  Almdmov.fchdoc = InvConfig.FchInv 
                      AND  Almdmov.TipMov = "S"
                      AND  Almdmov.CodMov = 01
                      USE-INDEX Almd03 NO-LOCK :
    
      F-STKALM = F-STKALM + Almdmov.CanDes .
    END.
      
    /*******************************************************************/

    /* UBICAMOS EL CONTEO Y RECONTEO */
    FIND InvConteo WHERE InvConteo.CodCia = Almmmate.CodCia 
                    AND  InvConteo.CodAlm = Almmmate.CodAlm 
                    AND  InvConteo.FchInv = InvConfig.FchInv
                    AND  InvConteo.CodMat = Almmmate.CodMat 
                    USE-INDEX Invcn02 NO-LOCK NO-ERROR.
    FIND InvRecont WHERE InvRecont.CodCia = Almmmate.CodCia 
                    AND  InvRecont.CodAlm = Almmmate.CodAlm 
                    AND  InvRecont.FchInv = InvConfig.FchInv
                    AND  InvRecont.CodMat = Almmmate.CodMat 
                    USE-INDEX Invcn02 NO-LOCK NO-ERROR.
                   
    /* GENERAMOS DETALLE SEGUN TIPO DE INVENTARIO */
    IF (C-TpoInv = "P" AND (AVAILABLE InvRecont OR AVAILABLE InvConteo)) OR 
        C-TpoInv = "T" THEN DO:
       F-VALCTO = IF F-STKGEN <> 0 THEN F-VALCTO ELSE 0.
       
       FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia 
                      AND  Almmmatg.CodMat = Almmmate.CodMat 
                     USE-INDEX Matg01 NO-LOCK NO-ERROR.

       CREATE tmp-temporal.
       ASSIGN t-codigo = Almmmate.CodMat
              t-desmat = Almmmatg.DesMat
              t-desmar = Almmmatg.DesMar
              t-undstk = Almmmatg.UndStk
              t-linea  = Almmmatg.codfam
              t-subfam = Almmmatg.subfam
              t-codubi = Almmmate.CodUbi
              t-stkgen = F-STKGEN
              t-valcto = F-VALCTO
              t-stkalm = F-STKALM.
              t-sw = TRUE.

     case R-costo:
       when 1 then 
           t-costo = (IF (t-stkgen > 0) then ROUND(t-valcto / t-stkgen,2) else 0).
       when 2 then do:
            FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
                               AND  Almdmov.CodAlm = Almmmate.CodAlm 
                               AND  Almdmov.CodMat = Almmmate.CodMat 
                               AND  Almdmov.fchdoc <= InvConfig.FchInv 
                               AND  Almdmov.TipMov = "I"
                               AND  Almdmov.CodMov = 02
                              USE-INDEX Almd03 NO-LOCK NO-ERROR.
            IF AVAILABLE Almdmov THEN 
               t-costo = Almdmov.PreUni.
            ELSE 
               t-costo = 0.
           
           /************MAGM********************/
            t-costo = Almmmatg.CtoLis.
            IF ICodMon <> Almmmatg.MonVta THEN DO:
             IF ICodMon = 1 THEN t-costo = t-costo * Almmmatg.TpoCmb. 
             IF ICodMon = 2 THEN t-costo = t-costo / Almmmatg.TpoCmb. 
            END.
           /*********************************/
       END.
       when 3 then do:
            find first almmmatg where almmmatg.codcia = Almmmate.CodCia 
                                 AND  almmmatg.CodMat = Almmmate.CodMat 
                                 USE-INDEX Matg01 NO-LOCK NO-ERROR.
            IF AVAILABLE almmmatg THEN do:
                t-costo = almmmatg.ctolis.
                IF ICodMon <> almmmatg.monvta THEN DO:
                    IF ICodMon = 1 THEN t-costo = t-costo * almmmatg.tpocmb. 
                    IF ICodMon = 2 THEN t-costo = t-costo / almmmatg.tpocmb. 
                END.
        
            end.
        end.
       End.       
       
       

       /****    Conteo  ****/
       FOR EACH InvConteo WHERE InvConteo.CodCia = Almmmate.CodCia 
                           AND  InvConteo.CodAlm = Almmmate.CodAlm 
                           AND  InvConteo.FchInv = InvConfig.FchInv
                           AND  InvConteo.CodMat = Almmmate.CodMat 
                          USE-INDEX INVCN02 NO-LOCK :
           ASSIGN t-stkcon = t-stkcon + InvConteo.CanInv
                  t-sw = TRUE.
       END.
       
       /****    Reconteo    ****/
       FOR EACH InvRecont WHERE InvRecont.CodCia = Almmmate.CodCia 
                           AND  InvRecont.CodAlm = Almmmate.CodAlm 
                           AND  InvRecont.FchInv = InvConfig.FchInv
                           AND  InvRecont.CodMat = Almmmate.CodMat 
                          USE-INDEX INVCN02 NO-LOCK:
           ASSIGN t-stkrec = t-stkrec + InvRecont.CanInv.
                  t-sw = TRUE.
       END.
       
       IF t-stkcon > 0 AND t-stkrec = 0 THEN
          ASSIGN t-stkdif = t-stkcon - t-stkalm.
       IF t-stkcon = 0 AND t-stkrec > 0 THEN
          ASSIGN t-stkdif = t-stkrec - t-stkalm.
       IF t-stkrec > 0 AND t-stkcon > 0 THEN 
          ASSIGN t-stkdif = MINIMUM(t-stkcon,t-stkrec) - t-stkalm.
       IF t-stkrec = 0 AND t-stkcon =  0 THEN 
          ASSIGN t-stkdif = t-stkdif - t-stkalm.
          
       t-imptot = t-stkdif * t-costo.
       IF t-stkdif = 0  THEN DELETE tmp-temporal.
   END.
END.

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
FOR EACH tmp-temporal:
     DELETE tmp-temporal.
END.

DO I = 1 TO NUM-ENTRIES(X-TIPMOV):
FOR EACH Almcmov WHERE Almcmov.Codcia = S-CODCIA AND
                       Almcmov.Codalm = S-CODALM AND
                       Almcmov.Tipmov = ENTRY(I,X-TIPMOV) AND
                       Almcmov.Codmov = 01 AND
                       Almcmov.FchDoc = D-FCHINV:
   FOR EACH ALMDMOV OF ALMCMOV:
        DISPLAY Almdmov.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(8)" WITH FRAME F-Proceso.

       FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                           Almmmatg.Codmat = ALmdmov.Codmat
                           NO-LOCK NO-ERROR.
       FIND Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                           Almmmate.Codalm = S-CODALM AND
                           Almmmate.Codmat = ALmdmov.Codmat
                           NO-LOCK NO-ERROR.                    
                           
       CREATE tmp-temporal.
       ASSIGN t-codigo = Almdmov.CodMat
              t-desmat = Almmmatg.DesMat
              t-desmar = Almmmatg.DesMar
              t-undstk = Almmmatg.UndStk
              t-linea  = Almmmatg.codfam
              t-subfam = Almmmatg.subfam
              t-codubi = Almmmate.CodUbi
              t-sw = TRUE.

       case R-costo:
       when 1 then do: 
           FIND LAST ALmstkal WHERE Almstkal.Codcia = S-CODCIA AND
                               Almstkal.Codalm = S-CODALM AND
                               Almstkal.Codmat = ALmdmov.Codmat AND
                               ALmstkal.Fecha < D-FCHINV
                               NO-LOCK NO-ERROR.
           IF AVAILABLE ALmstkal THEN DO:
              t-costo = Almstkal.CtoUni.
              IF ICodMon = 2 THEN t-costo = t-costo / x-tcamb.
           END.
       end.    
       when 2 then do:
            FIND LAST dmov WHERE dmov.CodCia = S-CODCIA 
                               AND  dmov.CodAlm = S-CODALM 
                               AND  dmov.CodMat = Almdmov.Codmat 
                               AND  dmov.fchdoc <= D-FCHINV 
                               AND  dmov.TipMov = "I"
                               AND  dmov.CodMov = 02
                              USE-INDEX Almd03 NO-LOCK NO-ERROR.
            IF AVAILABLE dmov THEN 
               t-costo = dmov.PreUni.
            ELSE 
               t-costo = 0.
           
           /************MAGM********************/
            t-costo = Almmmatg.CtoLis.
            IF ICodMon <> Almmmatg.MonVta THEN DO:
              IF ICodMon = 1 THEN t-costo = t-costo * x-tcamb. 
              IF ICodMon = 2 THEN t-costo = t-costo / x-tcamb.
            END.
           /*********************************/
        END.
        when 3 then do:
            IF AVAILABLE almmmatg THEN do:
                t-costo = almmmatg.ctolis.
                IF ICodMon <> almmmatg.monvta THEN DO:
                    IF ICodMon = 1 THEN t-costo = t-costo * x-tcamb. 
                    IF ICodMon = 2 THEN t-costo = t-costo / x-tcamb. 
                END.
        
            end.
         end.
       End.       


       FOR EACH InvConteo WHERE InvConteo.CodCia = S-CODCIA  
                           AND  InvConteo.CodAlm = Almdmov.CodAlm 
                           AND  InvConteo.FchInv = D-FCHINV
                           AND  InvConteo.CodMat = Almdmov.CodMat 
                           NO-LOCK :
          t-stkcon = t-stkcon +  InvConteo.CanInv.
          t-stkrec = t-stkrec +  InvConteo.CanInv.
       END.

       IF Almdmov.TipMov = "I" THEN DO:
        t-stkdif = Almdmov.Candes * 1.
        t-stkalm = t-stkcon - Almdmov.Candes. 
       END.
       IF Almdmov.TipMov = "S" THEN DO:
        t-stkdif = Almdmov.Candes * -1.
        t-stkalm = t-stkcon + Almdmov.Candes. 
       END.
       t-imptot = t-stkdif * t-costo.

                           
   END.
                          
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
  DISPLAY DesdeC HastaC D-FchInv ICodMon COMBO-BOX-1 R-costo F-DesMatD F-DesMatH 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 DesdeC HastaC D-FchInv ICodMon COMBO-BOX-1 R-costo B-expor 
         Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta W-Win 
PROCEDURE Exporta :
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
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 2.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 45.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 8.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
chWorkSheet:Columns("I"):ColumnWidth = 20.
chWorkSheet:Columns("J"):ColumnWidth = 20.
chWorkSheet:Columns("K"):ColumnWidth = 20.


chWorkSheet:Range("A1:K2"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Almacen " + S-CODALM.
chWorkSheet:Range("A2"):Value = "Codigo".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "U.M".
chWorkSheet:Range("E2"):Value = "Zona".
chWorkSheet:Range("F2"):Value = "Costo".
chWorkSheet:Range("G2"):Value = "Stock Teorico".
chWorkSheet:Range("H2"):Value = "Conteo".
chWorkSheet:Range("I2"):Value = "Reconteo".
chWorkSheet:Range("J2"):Value = "Diferencia".
chWorkSheet:Range("K2"):Value = "Importe".



chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */


for each tmp-temporal:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codigo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-Desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-undstk.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codubi.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-costo.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-stkalm.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-stkcon.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-stkrec.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-stkdif.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = t-imptot.
    

END.
/*
f-Column = "H" + string(t-Column).
chWorkSheet:Range("A1:" + f-column):Select().
*/
/*chExcelApplication:Selection:Style = "Currency".*/


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

FOR EACH tmp-temporal:
 DELETE tmp-temporal.
END.
HIDE FRAME F-PROCESO.

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

  
    FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                    AND  InvConfig.CodAlm = S-CODALM 
                    AND  InvConfig.FchInv = D-FchInv
                   USE-INDEX invcfg01 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE InvConfig THEN DO:
       MESSAGE "No existe la configuracion de inventario" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    C-TpoInv = InvConfig.TipInv.
    
    RUN Carga-Temporal.
    
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  DEFINE VAR TipCosto  AS CHAR.
  case R-costo: 
    when 1 then TipCosto="Promedio".
    when 2 then TipCosto="Reposicion".
    when 3 then TipCosto="Comercial".
  end.

  DEFINE FRAME F-REPORTE
/*         Almmmate.codmat AT 3
         Almmmatg.desmat AT 12
         Almmmatg.undstk AT 65 
         Almmmate.codalm AT 72 
         AlmmmatE.stkact AT 80 FORMAT '->>>,>>>,>>9.999'
         F-PESALM        FORMAT ">>>>,>>>,>>9.99"
         F-TOTAL         FORMAT '>>>>>>9.999'*/
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER 
          HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "( " + S-CODALM + ")" AT 1 FORMAT "X(10)" "DIFERENCIA DE INVENTARIOS" AT 73 FORMAT 'X(40)'
         "Pagina :" TO 154 PAGE-NUMBER(REPORT) TO 166 FORMAT "ZZZZZ9" SKIP
         "Al " AT 80 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 154 TODAY TO 166 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO "  TipCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 75 FORMAT "X(22)"
         "Hora   :" TO 154 STRING(TIME,"HH:MM") TO 166 SKIP 
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                      UND  COD         VALOR DE        STOCK                                                        TOTAL " SKIP
    "CODIGO    A  R  T  I  C  U  L  O  S                  MARCA            STK  ZON         COSTO         TEORICO         CONTEO       RECONTEO     DIFERENCIA           VALOR " SKIP
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*   12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 */
/*            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7 */
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

DO WITH FRAME F-REPORTE:
IF COMBO-BOX-1:screen-value in frame {&frame-name} = "CODIGO" THEN DO:
  FOR EACH tmp-temporal NO-LOCK 
                        WHERE t-sw
                        BREAK BY t-codigo:
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUMULATE t-imptot (TOTAL).
        DISPLAY STREAM REPORT 
            t-codigo
            t-desmat
            t-desmar    FORMAT "X(16)"
            t-undstk
            t-codubi
            t-costo
            t-stkalm format "->>>,>>>.99"
            t-stkcon
            t-stkrec
            t-stkdif format "->>>,>>>.99"
            t-imptot
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST(t-codigo) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            "TOTAL GENERAL" @ t-desmat
            (ACCUM TOTAL t-imptot) @ t-imptot
            WITH FRAME F-REPORTE.
      END.

  END.
END.
ELSE DO:
  FOR EACH tmp-temporal NO-LOCK 
                        WHERE t-sw
                        BREAK BY t-linea
                              BY t-subfam
                              BY t-codigo:
      VIEW STREAM REPORT FRAME F-HEADER.
      IF FIRST-OF(t-linea) THEN DO:
        FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                       AND  Almtfami.codfam = t-linea 
                      USE-INDEX fami01 NO-LOCK NO-ERROR.
        DISPLAY STREAM REPORT 
            t-linea @ t-codigo
            Almtfami.desfam @ t-desmat
            WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
            t-codigo
            t-desmat
            WITH FRAME F-REPORTE.
      END.
      IF FIRST-OF(t-subfam) THEN DO:
        FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                       AND  AlmSFami.codfam = t-linea 
                       AND  AlmSFami.subfam = t-subfam
                      USE-INDEX sfam01 NO-LOCK NO-ERROR.
        DISPLAY STREAM REPORT 
            t-subfam @ t-codigo
            AlmSFami.dessub @ t-desmat
            WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
            t-codigo
            t-desmat
            WITH FRAME F-REPORTE.
      END.
      
      ACCUMULATE t-imptot (SUB-TOTAL BY t-linea).
      ACCUMULATE t-imptot (SUB-TOTAL BY t-subfam).
      ACCUMULATE t-imptot (TOTAL).

        DISPLAY STREAM REPORT 
            t-codigo
            t-desmat
            t-desmar    FORMAT "X(16)"
            t-undstk
            t-codubi
            t-costo
            t-stkalm
            t-stkcon
            t-stkrec
            t-stkdif
            t-imptot
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-subfam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL SUB-LINEA : " + t-subfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-subfam t-imptot) @ t-imptot
            WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(t-linea) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL LINEA : " + t-linea) @ t-desmat
            (ACCUM SUB-TOTAL BY t-line t-imptot) @ t-imptot
            WITH FRAME F-REPORTE.
      END.

      IF LAST(t-line) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            "TOTAL GENERAL" @ t-desmat
            (ACCUM TOTAL t-imptot) @ t-imptot
            WITH FRAME F-REPORTE.
      END.

  END.
END.
END.

  PUT STREAM REPORT "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------".
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
    ENABLE ALL EXCEPT F-DesMatD F-DesMatH.
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
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
   
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
  ASSIGN DesdeC HastaC ICodMon COMBO-BOX-1 R-costo.
  
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
     FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                          AND  InvConfig.CodAlm = S-CODALM 
                         NO-LOCK NO-ERROR.
     IF AVAILABLE InvConfig THEN D-FchInv = InvConfig.FchInv.
     DISPLAY D-FchInv.
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
/*        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/
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


