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
DEFINE SHARED VAR pv-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

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
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF VAR cl-codcia AS INT NO-UNDO.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR S-SUBTIT  AS CHAR.
DEFINE VAR X-TITU    AS CHAR INIT "E S T A D I S T I C A   D E    V E N T A S".
DEFINE VAR X-MONEDA  AS CHAR.
DEFINE VAR I         AS INTEGER   NO-UNDO.
DEFINE VAR II        AS INTEGER   NO-UNDO.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Totmn   AS DECI INIT 0.
DEFINE VAR T-Totme   AS DECI INIT 0.
DEFINE VAR T-Pormn   AS DECI INIT 0.
DEFINE VAR T-Porme   AS DECI INIT 0.
DEFINE VAR dev       AS DECI INIT 0.
DEFINE VAR tot       AS DECI INIT 0.
DEFINE VAR devt      AS DECI INIT 0.
DEFINE VAR tott      AS DECI INIT 0.
DEFINE VAR X-xcntj   AS DECI INIT 0.
DEFINE VAR T-Devmn   AS DECI INIT 0.
DEFINE VAR T-Devme   AS DECI INIT 0.
DEFINE VAR T-Vent    AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.
DEFINE VAR xcntj AS DEC  FORMAT "->>>>>>>>9.99" INIT 0.
DEFINE VAR x-coe     AS DECI INIT 0.
DEFINE VAR x-signo1  AS INTE INIT 1.
DEFINE VAR x-ImpTot  AS DEC NO-UNDO.     /* IMporte NETO de venta */
DEFINE VAR x-TpoCmbCmp AS DECI INIT 1.
DEFINE VAR x-TpoCmbVta AS DECI INIT 1.
DEFINE VAR x-Day       AS INTE FORMAT '99'   INIT 1.
DEFINE VAR x-Month     AS INTE FORMAT '99'   INIT 1.
DEFINE VAR x-Year      AS INTE FORMAT '9999' INIT 1.
DEFINE VAR f-factor    AS DECI INIT 0.
DEFINE VAR x-NroFchI   AS INTE INIT 0.
DEFINE VAR x-NroFchF   AS INTE INIT 0.
DEFINE VAR x-CodFchI   AS DATE FORMAT '99/99/9999' INIT TODAY.
DEFINE VAR x-CodFchF   AS DATE FORMAT '99/99/9999' INIT TODAY.
DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-ARTI    AS CHAR.
DEFINE VAR X-FAMILIA AS CHAR.
DEFINE VAR X-SUBFAMILIA AS CHAR.
DEFINE VAR X-CLIENTE  AS CHAR.
DEFINE VAR X-MARCA    AS CHAR.
DEFINE VAR X-PROVE    AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".

DEFINE BUFFER B-CDOCU FOR CcbCdocu.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-desfam  LIKE Almtfami.desfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-dessub  LIKE AlmSFam.dessub
    FIELD t-undbas  LIKE Almmmatg.undbas
    FIELD t-codcli  LIKE CcbCDocu.CodCli
    FIELD t-NomCli  LIKE CcbCDocu.NomCli
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-ventamn AS DEC            FORMAT "->>>,>>>,>>9.99" 
    FIELD t-ventame AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devolme AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devolmn AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-totalmn AS DEC            FORMAT "->>>,>>>,>>9.99" 
    FIELD t-totalme AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>,>>>,>>9.99"  
    FIELD t-devol   AS DEC  EXTENT 10 FORMAT "->>>,>>>,>>9.99"
    FIELD t-total   AS DEC  EXTENT 10 FORMAT "->>>,>>>,>>9.99"
    FIELD t-xcntj   AS DEC  EXTENT 10 FORMAT "->>>,>>>,>>9.99"
    FIELD t-canti   AS DEC            FORMAT "->>>,>>>,>>9.99"
    INDEX Llave01 t-codcia t-codcli t-codfam t-subfam.

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
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-58 F-CodCli F-CodFam BUTTON-1 ~
F-SubFam BUTTON-2 DesdeF HastaF nCodMon Btn_OK Btn_Cancel C-tipo 
&Scoped-Define DISPLAYED-OBJECTS F-CodCli x-NomCli F-CodFam F-SubFam DesdeF ~
HastaF nCodMon x-Mensaje C-tipo 

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
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 1" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 2" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(23)":U INITIAL "Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Cliente","Familia","Familia-SubFamilia" 
     DROP-DOWN-LIST
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Famila" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 2.15
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.86 BY 2.15.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 7.54
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodCli AT ROW 2.35 COL 12 COLON-ALIGNED WIDGET-ID 4
     x-NomCli AT ROW 2.35 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     F-CodFam AT ROW 3.42 COL 12 COLON-ALIGNED
     BUTTON-1 AT ROW 3.42 COL 26
     F-SubFam AT ROW 4.5 COL 12 COLON-ALIGNED
     BUTTON-2 AT ROW 4.5 COL 26
     DesdeF AT ROW 5.58 COL 12 COLON-ALIGNED WIDGET-ID 8
     HastaF AT ROW 5.58 COL 30 COLON-ALIGNED WIDGET-ID 10
     nCodMon AT ROW 6.65 COL 14 NO-LABEL
     x-Mensaje AT ROW 7.69 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     Btn_OK AT ROW 9.42 COL 15
     Btn_Cancel AT ROW 9.42 COL 29
     C-tipo AT ROW 9.96 COL 49 COLON-ALIGNED NO-LABEL
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 6.65 COL 7
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 14.57 BY .65 AT ROW 8.88 COL 50
          FONT 6
     RECT-61 AT ROW 1.54 COL 3
     RECT-46 AT ROW 9.15 COL 3
     RECT-58 AT ROW 9.15 COL 49
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.57 BY 10.54
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
         TITLE              = "Reporte Clientes por Linea"
         HEIGHT             = 10.54
         WIDTH              = 75.57
         MAX-HEIGHT         = 10.54
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 10.54
         VIRTUAL-WIDTH      = 320
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
   FRAME-NAME                                                           */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Clientes por Linea */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Clientes por Linea */
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
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        F-CODFAM = output-var-2.
        DISPLAY F-CODFAM.
        IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
        F-SUBFAM:SENSITIVE = FALSE
        F-SUBFAM:SCREEN-VALUE = ""
        BUTTON-2:SENSITIVE = FALSE.
        ELSE ASSIGN 
        F-SUBFAM:SENSITIVE = TRUE
        BUTTON-2:SENSITIVE = TRUE.
        APPLY "ENTRY" TO F-CODFAM .
        RETURN NO-APPLY.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = F-CODFAM.
    output-var-2 = "".
    RUN lkup\C-SubFam02.r("SubFamilias").
    IF output-var-2 <> ? THEN DO:
        F-SUBFAM = output-var-2.
        DISPLAY F-SUBFAM.
        APPLY "ENTRY" TO F-SUBFAM .
        RETURN NO-APPLY.

        
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo W-Win
ON VALUE-CHANGED OF C-tipo IN FRAME F-Main
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN C-TIPO.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCli W-Win
ON LEAVE OF F-CodCli IN FRAME F-Main /* Cliente */
DO:
  /*FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-clie THEN x-NomCli:SCREEN-VALUE = Gn-clie.nomcli.
*/
    ASSIGN F-Codcli .
    IF F-Codcli = "" THEN DO:
       x-NomCli:SCREEN-VALUE = "".
       RETURN.
    END.
    IF F-Codcli <> "" THEN DO: 
       FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
            gn-clie.Codcli = F-Codcli NO-LOCK NO-ERROR.
       IF NOT AVAILABLE gn-clie THEN DO:
          MESSAGE "Codigo de Cliente NO Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO F-Codcli IN FRAME {&FRAME-NAME}.
          RETURN NO-APPLY.     
       END.
       x-NomCli = gn-clie.Nomcli.
    END.
    DISPLAY x-NomCli WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Famila */
DO:
   ASSIGN F-CodFam.
   IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
       F-SUBFAM:SENSITIVE = FALSE
       F-SUBFAM:SCREEN-VALUE = ""
       BUTTON-2:SENSITIVE = FALSE.
   ELSE ASSIGN
    F-SUBFAM:SENSITIVE = TRUE
    BUTTON-2:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-Familia */
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
   IF NOT AVAILABLE AlmSFami THEN DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
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
        ASSIGN C-tipo
               F-CodCli
               F-CodFam 
               F-SubFam
               DesdeF 
               HastaF
               nCodMon
               x-NomCli.
        X-FAMILIA     = "FAMILIA      : "  + F-CODFAM.
        X-SUBFAMILIA  = "SUBFAMILIA   : "  + F-SUBFAM .
        X-CLIENTE     = "CLIENTE      : "  + F-CODCLI + " " + x-NomCli.
        S-SUBTIT      = "PERIODO      : "  + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
        X-MONEDA      = "MONEDA  : "  + IF NCODMON = 1 THEN "  NUEVOS SOLES " ELSE "  DOLARES AMERICANOS ".  
        IF DesdeF = ?  THEN DesdeF = 01/01/1900.
        IF HastaF = ?  THEN HastaF = 01/01/3000.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/* ------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    DEF VAR x-CodDoc AS CHAR INIT 'FAC,BOL,TCK' NO-UNDO.
    DEF VAR j        AS INT NO-UNDO.
    
    /*******Inicializa la Tabla Temporal ******/
    FOR EACH tmp-tempo :
        DELETE tmp-tempo.
    END.
    /********************************/
    DO WITH FRAME {&FRAME-NAME}:
        x-CodFchF = HastaF.
        x-CodFchI = DesdeF.
    END.
    /* Barremos las ventas */      
    
    FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia:
        FOR EACH CcbCdocu NO-LOCK USE-INDEX Llave10
            WHERE CcbCdocu.CodCia = S-CODCIA                                      
            AND CcbCdocu.CodDiv = gn-divi.coddiv
            AND CcbCdocu.FchDoc >= x-CodFchI                                    
            AND CcbCdocu.FchDoc <= x-CodFchF 
            AND LOOKUP(CcbCDocu.CodDoc,x-CodDoc) > 0
            AND CcbCdocu.CodCli BEGINS F-CodCli:

            /* ***************** FILTROS ********************************** */
            IF CcbCdocu.TpoFac = 'A' THEN NEXT.        /* NO facturas adelantadas */ 
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
            /* *********************************************************** */

            x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.coddiv + ' ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + string(ccbcdocu.fchdoc).

            ASSIGN x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */

            /* buscamos si hay una aplicación de fact adelantada */
            FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
            IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
            /* ************************************************* */

            FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc USE-INDEX Cmb01 NO-LOCK NO-ERROR.
            IF NOT AVAIL Gn-Tcmb THEN 
                FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc USE-INDEX Cmb01 NO-LOCK NO-ERROR.
                IF AVAIL Gn-Tcmb THEN 
                    ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.

            FOR EACH CcbDdocu OF CcbCdocu NO-LOCK WHERE Ccbddocu.implin > 0,     /* <<< OJO <<< */
                FIRST Almmmatg OF Ccbddocu NO-LOCK:

                IF f-CodFam <> '' AND Almmmatg.codfam <> f-CodFam THEN NEXT.
                IF f-SubFam <> '' AND Almmmatg.subfam <> f-SubFam THEN NEXT.
                
                FIND Almtfami WHERE Almtfami.Codcia = Almmmatg.Codcia AND
                    Almtfami.CodFam = Almmmatg.CodFam NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almtfami THEN NEXT.
                FIND AlmSFam  WHERE AlmSFam.Codcia  = Almmmatg.Codcia 
                    AND AlmSFam.CodFam  = Almtfami.CodFam 
                    AND AlmSFam.SubFam  = Almmmatg.SubFam NO-LOCK NO-ERROR.
                IF NOT AVAILABLE AlmSFam THEN NEXT.
                
                /*Conversion*/
                F-FACTOR  = 1. 
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = Ccbddocu.UndVta NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival.
                    IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.

                T-Vtamn   = 0.
                T-Vtame   = 0.

                CASE Ccbcdocu.CodMon:
                    WHEN 1 THEN
                        ASSIGN
                            T-Vtamn = T-Vtamn + x-signo1 * CcbDdocu.ImpLin
                            T-Vtame = T-Vtame + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
                    WHEN 2 THEN
                        ASSIGN
                            T-Vtamn = T-Vtamn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                            T-Vtame = T-Vtame + x-signo1 * CcbDdocu.ImpLin.
                END CASE.

                /*
                IF Ccbcdocu.CodMon = 1 THEN DO:
                    IF x-signo1 = 1 THEN DO:
                        ASSIGN
                            T-Vtamn = T-Vtamn + x-signo1 * CcbDdocu.ImpLin
                            T-Vtame = T-Vtame + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
                    END.
                END.

                IF Ccbcdocu.CodMon = 2 THEN DO:
                    IF x-signo1 = 1 THEN DO:
                        ASSIGN
                            T-Vtamn = T-Vtamn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                            T-Vtame = T-Vtame + x-signo1 * CcbDdocu.ImpLin.
                        END.
                END.
                */
                /*******************************************/

                FIND tmp-tempo WHERE t-codcia  = S-CODCIA 
                    AND t-codcli = CcbDDocu.codcli 
                    AND t-codfam = Almmmatg.codfam
                    AND t-subfam = Almmmatg.subfam NO-ERROR.
                
                IF NOT AVAIL tmp-tempo THEN DO:
                    CREATE  tmp-tempo.
                    ASSIGN  
                        t-codcia  = S-CODCIA
                        t-codcli  = CcbCDocu.CodCli
                        t-NomCli  = CcbCDocu.NomCli
                        t-codfam  = Almmmatg.codfam 
                        t-Desfam  = Almtfami.desfam 
                        t-subfam  = Almmmatg.subfam
                        t-Dessub  = AlmSFam.dessub
                        t-UndBas  = Almmmatg.undbas.
                END.
                ASSIGN 
                    T-Venta[10] = T-Venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                    T-Canti     = T-Canti     + x-signo1 * Ccbddocu.candes * f-Factor.
    
            END.
        END.
    END.

    /* barremos notas de crédito */
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
        FOR EACH CcbCdocu NO-LOCK USE-INDEX Llave10
            WHERE CcbCdocu.CodCia = S-CODCIA       
            AND CcbCdocu.CodDiv = gn-divi.coddiv
            AND CcbCDocu.CodDoc = "N/C" 
            AND CcbCdocu.FchDoc >= x-CodFchI                                    
            AND CcbCdocu.FchDoc <= x-CodFchF 
            AND CcbCdocu.CodCli BEGINS F-CodCli
            AND CcbCdocu.TpoFac <> 'A':     /* NO facturas adelantadas */       

            /* ***************** FILTROS ********************************** */
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
            /* *********************************************************** */

            x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.coddiv + ' ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + string(ccbcdocu.fchdoc).
            x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.

            ASSIGN x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */
            
            /* buscamos si hay una aplicación de fact adelantada */
            FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
            IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
            /* ************************************************* */

            FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc USE-INDEX Cmb01 NO-LOCK NO-ERROR.
            IF NOT AVAIL Gn-Tcmb THEN 
                FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc USE-INDEX Cmb01 NO-LOCK NO-ERROR.
            IF AVAIL Gn-Tcmb THEN 
                ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.           
            
            /* NOTAS DE CREDITO por OTROS conceptos */
            T-Devmn   = 0. 
            T-Devme   = 0. 

            IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN DO:
                RUN PROCESA-NOTA. NEXT.
            END.
            FOR EACH CcbDdocu OF CcbCdocu WHERE Ccbddocu.implin > 0 NO-LOCK,   /* <<< OJO <<< */
                FIRST Almmmatg OF Ccbddocu NO-LOCK:
                IF f-CodFam <> '' AND Almmmatg.codfam <> f-CodFam THEN NEXT.
                IF f-SubFam <> '' AND Almmmatg.subfam <> f-SubFam THEN NEXT.
/*                    FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND               */
/*                                        Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR. */
/*                    IF NOT AVAILABLE Almmmatg THEN NEXT.                                    */
                
                   FIND Almtfami WHERE Almtfami.Codcia = Almmmatg.Codcia AND
                                       Almtfami.CodFam = Almmmatg.CodFam NO-LOCK NO-ERROR.
                   IF NOT AVAILABLE Almtfami THEN NEXT.
                   FIND AlmSFam  WHERE AlmSFam.Codcia  = Almmmatg.Codcia AND
                                       AlmSFam.CodFam  = Almtfami.CodFam AND
                                       AlmSFam.SubFam  = Almmmatg.SubFam NO-LOCK NO-ERROR.
                   IF NOT AVAILABLE AlmSFam THEN NEXT.
                   
                /*IF Ccbddocu.implin <= 0 THEN NEXT.     */
                
                F-FACTOR  = 1. 
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = Ccbddocu.UndVta NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival.
                    IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.

                T-Devmn   = 0.
                T-Devme   = 0.

                CASE Ccbcdocu.CodMon:
                    WHEN 1 THEN
                        ASSIGN    
                        T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin
                        T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
                    WHEN 2 THEN
                        ASSIGN    
                        T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                        T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin.
                END CASE.

                /*
                IF Ccbcdocu.CodMon = 1 THEN DO:
                       IF x-signo1 = -1  THEN DO:
                           ASSIGN    
                                T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin
                                T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
                       END.
                   END.
                   IF Ccbcdocu.CodMon = 2 THEN DO:
                       IF x-signo1 = -1  THEN DO:
                           ASSIGN    
                                T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                                T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin.
                       END.
                   END.
                */    

                /*******************************************/
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA 
                    AND t-codcli = CcbDDocu.codcli 
                    AND t-codfam = Almmmatg.codfam
                    AND t-subfam = Almmmatg.subfam NO-ERROR.

                IF NOT AVAIL tmp-tempo THEN DO:
                    CREATE  tmp-tempo.
                    ASSIGN  
                        t-codcia  = S-CODCIA
                        t-codcli  = CcbCDocu.CodCli
                        t-NomCli  = CcbCDocu.NomCli
                        t-codfam  = Almmmatg.codfam 
                        t-Desfam  = Almtfami.desfam 
                        t-subfam  = Almmmatg.subfam
                        t-Dessub  = AlmSFam.dessub
                        t-UndBas  = Almmmatg.undbas.
                END.
                ASSIGN 
                    T-Devol[10] = T-Devol[10] + ( IF ncodmon = 1 THEN T-Devmn ELSE T-Devme )
                    T-Canti     = T-Canti     + x-signo1 * Ccbddocu.candes * f-Factor.                
            END.
        END.
    END.

    FOR EACH tmp-tempo WHERE t-codcia  = S-CODCIA NO-LOCK:
        ASSIGN T-Total[10] = T-Venta[10] + T-Devol[10] 
               T-Xcntj[10] = ( ( T-Devol[10] * -1) / T-Venta[10] ) * 100.
    END.

    HIDE FRAME f-Proceso.
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DISPLAY F-CodCli x-NomCli F-CodFam F-SubFam DesdeF HastaF nCodMon x-Mensaje 
          C-tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-58 F-CodCli F-CodFam BUTTON-1 F-SubFam BUTTON-2 DesdeF 
         HastaF nCodMon Btn_OK Btn_Cancel C-tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
         t-codcli       AT 1                        COLUMN-LABEL 'CODIGO'
         Gn-Clie.Nomcli FORMAT "X(40)"              COLUMN-LABEL 'NOMBRE DEL CLIENTE'
         t-Venta[10]    FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'VENTA TOTAL'
         t-Devol[10]    FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'DEVOLUCION'
         t-total[10]    FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'VENTA EFECTIVA'
         t-Xcntj[10]    FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL '% DEVOLUCION'
         t-Canti        FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'CANTIDAD'
         WITH WIDTH 200 NO-BOX /*NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 20 FORMAT "X(50)" 
         "(" + "Por " + C-TIPO + ")"  AT 80 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 90 TODAY TO 103 FORMAT "99/99/9999" SKIP
         X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 90 STRING(TIME,"HH:MM:SS") TO 101   SKIP
         X-CLIENTE  AT 1  FORMAT "X(60)" 
         X-MONEDA AT 82  FORMAT "X(60)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   AT 1 SKIP(1)
/*         "-------------------------------------------------------------------------------------------------------------------------" SKIP */
/*         "  CODIGO      N O M B R E  C L I E N T E                 VENTA TOTAL      DEVOLUCION  VENTA EFECTIVA    % DEVOLUCION     " SKIP */
/*         "-------------------------------------------------------------------------------------------------------------------------" SKIP */
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO /*CENTERED*/ DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo WHERE t-codcia = s-codcia ,
      EACH Gn-Clie WHERE Gn-Clie.codcia = cl-codcia AND
           Gn-Clie.codcli = tmp-tempo.t-codcli
                     BREAK BY t-codcia
                           BY t-codcli:
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUM  t-venta[10]  ( TOTAL BY t-codcli) .              
      ACCUM  t-devol[10]  ( TOTAL BY t-codcli) .              
      ACCUM  t-total[10]  ( TOTAL BY t-codcli) .  
      ACCUM  t-canti      ( TOTAL BY t-codcli) .  
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      ACCUM  t-devol[10]  ( TOTAL BY t-codcia) .
      ACCUM  t-total[10]  ( TOTAL BY t-codcia) .
      ACCUM  t-canti      ( TOTAL BY t-codcia) .  
      DOWN STREAM REPORT WITH FRAME F-REPORTE.   

      IF LAST-OF(t-codcli) THEN DO:
         dev = (ACCUM TOTAL BY t-codcli t-devol[10]).
         tot = (ACCUM TOTAL BY t-codcli t-venta[10]). 
         X-xcntj = ( dev * (-1) / tot ) * 100.
         DISPLAY STREAM REPORT 
             t-codcli
             Gn-Clie.Nomcli
             (ACCUM TOTAL BY t-codcli t-venta[10]) @ t-venta[10]
             (ACCUM TOTAL BY t-codcli t-devol[10]) @ t-devol[10]
             (ACCUM TOTAL BY t-codcli t-total[10]) @ t-total[10]
             X-xcntj @ t-xcntj[10]
             (ACCUM TOTAL BY t-codcli t-canti) @ t-canti
             WITH FRAME F-REPORTE.
      END.  
      IF LAST-OF(t-codcia) THEN DO:
         devt = (ACCUM TOTAL BY t-codcia t-devol[10]).
         tott = (ACCUM TOTAL BY t-codcia t-venta[10]). 
         T-Pormn = ( devt * (-1) / tott ) * 100.
         UNDERLINE STREAM REPORT 
             t-venta[10]
             t-devol[10]
             t-total[10]
             t-xcntj[10]
             t-canti
         WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             ("TOTAL GENERAL : " ) @ Gn-Clie.Nomcli
             (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
             (ACCUM TOTAL BY t-codcia t-devol[10]) @ t-devol[10]
             (ACCUM TOTAL BY t-codcia t-total[10]) @ t-total[10]
             T-Pormn @ t-xcntj[10]
             (ACCUM TOTAL BY t-codcia t-canti) @ t-canti
             WITH FRAME F-REPORTE.
      END.  
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE FRAME F-REPORTE
         t-CodCli     AT 1                      COLUMN-LABEL 'CODIGO'
         t-NomCli     FORMAT "X(40)"            COLUMN-LABEL 'NOMBRE DEL CLIENTE'
         t-CodFam     FORMAT "X(6)"             COLUMN-LABEL 'FAMILIA'
         t-DesFam     FORMAT "X(40)"            COLUMN-LABEL 'DESCRIPCION'
         t-Venta[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'VENTA TOTAL'
         t-Devol[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'DEVOLUCION'
         t-total[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'VENTA EFECTIVA'
         t-Xcntj[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL '% DEVOLUCION'
         t-Canti      FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'CANTIDAD'
         WITH WIDTH 200 NO-BOX /*NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN.  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 20 FORMAT "X(50)" 
         "(" + "Por " + C-TIPO + ")"  AT 80 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 90 TODAY TO 103 FORMAT "99/99/9999" SKIP
         X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 90 STRING(TIME,"HH:MM:SS") TO 101   SKIP
         X-CLIENTE  AT 1  FORMAT "X(60)" 
         X-MONEDA AT 82  FORMAT "X(60)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 SKIP(1)
/*          "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
/*          "  CODIGO    N O M B R E    C L I E N T E         FAMILIA    D E S C R I P C I O N                        VENTA TOTAL      DEVOLUCION  VENTA EFECTIVA    % DEVOLUCION     " SKIP             */
/*          "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
         WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO /*CENTERED*/ DOWN. 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo WHERE t-codcia = s-codcia
                     BREAK BY t-codcia
                           BY t-codcli
                           BY t-codfam :
      DISPLAY t-codcli @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUM  t-venta[10]  ( TOTAL BY t-codfam) .              
      ACCUM  t-devol[10]  ( TOTAL BY t-codfam) .                                    
      ACCUM  t-total[10]  ( TOTAL BY t-codfam) .                                    
      ACCUM  t-canti      ( TOTAL BY t-codfam) .                                    
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .                           
      ACCUM  t-devol[10]  ( TOTAL BY t-codcia) .                           
      ACCUM  t-total[10]  ( TOTAL BY t-codcia) .                           
      ACCUM  t-canti      ( TOTAL BY t-codcia) .                                    
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      IF LAST-OF(t-codfam) THEN DO:
         dev = (ACCUM TOTAL BY t-codfam t-devol[10]).
         tot = (ACCUM TOTAL BY t-codfam t-venta[10]). 
         X-xcntj = ( dev * (-1) / tot ) * 100.
         DISPLAY STREAM REPORT 
              t-codcli
              t-nomcli
              t-codfam                                    
              t-desfam 
              t-canti
              (ACCUM TOTAL BY t-codfam t-venta[10]) @ t-venta[10]
              (ACCUM TOTAL BY t-codfam t-devol[10]) @ t-devol[10]
              (ACCUM TOTAL BY t-codfam t-total[10]) @ t-total[10]
              X-xcntj @ t-xcntj[10] 
             (ACCUM TOTAL BY t-codfam t-canti) @ t-canti
              WITH FRAME F-REPORTE.
      END. 
      IF LAST-OF(t-codcia) THEN DO:
          devt = (ACCUM TOTAL BY t-codcia t-devol[10]).
          tott = (ACCUM TOTAL BY t-codcia t-venta[10]). 
          T-Pormn = ( devt * (-1) / tott ) * 100.
          UNDERLINE STREAM REPORT 
              t-venta[10]
              t-devol[10]
              t-total[10]
              t-xcntj[10]
              t-canti
          WITH FRAME F-REPORTE.
          DISPLAY STREAM REPORT 
              ("TOTAL GRAL. :" ) @ t-desfam
              (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
              (ACCUM TOTAL BY t-codcia t-devol[10]) @ t-devol[10]
              (ACCUM TOTAL BY t-codcia t-total[10]) @ t-total[10]
              T-Pormn @ t-xcntj[10]
              (ACCUM TOTAL BY t-codcia t-canti) @ t-canti
              WITH FRAME F-REPORTE.
      END.  
  END.
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 W-Win 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-CodCli     AT 1                      COLUMN-LABEL 'CODIGO'
         t-NomCli     FORMAT "X(40)"            COLUMN-LABEL 'NOMBRE DEL CLIENTE'
         t-CodFam     FORMAT "X(6)"             COLUMN-LABEL 'FAMILIA'
         t-subfam     FORMAT "X(6)"             COLUMN-LABEL 'SUBFAMILIA'
         t-DesSub     FORMAT "X(40)"            COLUMN-LABEL 'DESCRIPCION'
         t-UndBas     FORMAT "x(5)"             COLUMN-LABEL 'UNIDAD'
         t-Venta[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'VENTA TOTAL'
         t-Devol[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'DEVOLUCION'
         t-total[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'VENTA EFECTIVA'
         t-Xcntj[10]  FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL '% DEVOLUCION'
         t-canti      FORMAT "->>>,>>>,>>9.99"  COLUMN-LABEL 'CANTIDAD'
         WITH WIDTH 200 NO-BOX /*NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 20 FORMAT "X(50)" 
         "(" + "Por " + C-TIPO + ")"  AT 80 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 90 TODAY TO 103 FORMAT "99/99/9999" SKIP
         X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 90 STRING(TIME,"HH:MM:SS") TO 101   SKIP
         X-CLIENTE  AT 1  FORMAT "X(60)" 
         X-MONEDA AT 82  FORMAT "X(60)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   AT 1 SKIP(1)
/*         "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
/*         "SUB"  AT 61 SKIP                                                                                                                                                                             */
/*         "  CODIGO    N O M B R E    C L I E N T E          FAMILIA FAMILIA  D E S C R I P C I O N                        VENTA TOTAL      DEVOLUCION  VENTA EFECTIVA    % DEVOLUCION      " SKIP      */
/*         "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO /*CENTERED*/ DOWN. 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo WHERE t-codcia = s-codcia
                     BREAK BY t-codcia
                           BY t-codcli
                           BY t-codfam 
                           BY t-subfam:
      DISPLAY t-codcli @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUM  t-venta[10]  ( TOTAL BY t-subfam) .              
      ACCUM  t-devol[10]  ( TOTAL BY t-subfam) .                                    
      ACCUM  t-total[10]  ( TOTAL BY t-subfam) .                                                
      ACCUM  t-canti      ( TOTAL BY t-subfam) .                                                
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .                           
      ACCUM  t-devol[10]  ( TOTAL BY t-codcia) .                           
      ACCUM  t-total[10]  ( TOTAL BY t-codcia) .                           
      ACCUM  t-canti      ( TOTAL BY t-codcia) .                           
      DOWN STREAM REPORT WITH FRAME F-REPORTE.  
      IF LAST-OF(t-subfam) THEN DO:
          dev = (ACCUM TOTAL BY t-subfam t-devol[10]).
          tot = (ACCUM TOTAL BY t-subfam t-venta[10]). 
          X-xcntj = ( dev * (-1) / tot ) * 100.
          DISPLAY STREAM REPORT 
              t-codcli
              t-nomcli
              t-codfam
              t-subfam                                    
              t-dessub 
              t-undbas
              (ACCUM TOTAL BY t-subfam t-venta[10]) @ t-venta[10]
              (ACCUM TOTAL BY t-subfam t-devol[10]) @ t-devol[10]
              (ACCUM TOTAL BY t-subfam t-total[10]) @ t-total[10]
              X-xcntj @ t-xcntj[10]
              (ACCUM TOTAL BY t-subfam t-canti) @ t-canti
              WITH FRAME F-REPORTE.
      END. 
      IF LAST-OF(t-codcia) THEN DO:
          devt = (ACCUM TOTAL BY t-codcia t-devol[10]).
          tott = (ACCUM TOTAL BY t-codcia t-venta[10]). 
          T-Pormn = ( devt * (-1) / tott ) * 100.
          UNDERLINE STREAM REPORT 
              t-venta[10]
              t-devol[10]
              t-total[10]
              t-xcntj[10]
              t-canti
          WITH FRAME F-REPORTE.
          DISPLAY STREAM REPORT 
              ("TOTAL GRAL. :" ) @ t-dessub
              (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
              (ACCUM TOTAL BY t-codcia t-devol[10]) @ t-devol[10]
              (ACCUM TOTAL BY t-codcia t-total[10]) @ t-total[10]
              T-Pormn @ t-xcntj[10]
              (ACCUM TOTAL BY t-codcia t-canti) @ t-canti
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
        ENABLE ALL EXCEPT x-Mensaje.
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

    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        CASE C-Tipo:
            WHEN "Cliente"             THEN RUN Formato1.
            WHEN "Familia"             THEN RUN Formato2.
            WHEN "Familia-SubFamilia"  THEN RUN Formato3.
        END CASE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN C-tipo
         F-CodCli
         F-CodFam 
         F-SubFam 
         DesdeF 
         HastaF 
         nCodMon
         x-NomCli.
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
        DISPLAY DesdeF HastaF  .
  END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-NOTA W-Win 
PROCEDURE PROCESA-NOTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                   B-CDOCU.CodDoc = CcbCdocu.Codref AND
                   B-CDOCU.NroDoc = CcbCdocu.Nroref 
                   NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN NEXT.

    x-ImpTot = B-CDOCU.ImpTot.     /* <<< OJO <<< */
    /* buscamos si hay una aplicación de fact adelantada */
    FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
    /* ************************************************* */
    x-coe = Ccbcdocu.ImpTot / x-ImpTot.
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
        IF f-CodFam <> '' AND Almmmatg.codfam <> f-CodFam THEN NEXT.
        IF f-SubFam <> '' AND Almmmatg.subfam <> f-SubFam THEN NEXT.
/*         FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND               */
/*                             Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR. */
/*         IF NOT AVAILABLE Almmmatg THEN NEXT.                                    */
        IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                            Almtconv.Codalter = Ccbddocu.UndVta
                            NO-LOCK NO-ERROR.
        F-FACTOR  = 1. 
        IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.
        T-Devmn   = 0. 
        T-Devme   = 0.  
        IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                    T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin * x-coe
                    T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp * x-coe.
        IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                    T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                    T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin * x-coe.
        /*******************************************/
        FIND tmp-tempo WHERE t-codcia  = S-CODCIA 
            AND t-codcli = CcbDDocu.codcli  
            AND t-codfam = Almmmatg.codfam
            AND t-subfam = Almmmatg.subfam
            NO-ERROR.
        IF NOT AVAIL tmp-tempo THEN DO:
             CREATE  tmp-tempo.
             ASSIGN  t-codcia  = S-CODCIA
                     t-codcli  = CcbCDocu.CodCli
                     t-NomCli  = CcbCDocu.NomCli
                     t-codfam  = Almmmatg.codfam 
                     t-Desfam  = Almtfami.desfam 
                     t-subfam  = Almmmatg.subfam
                     t-Dessub  = AlmSFam.dessub.
        END.
        ASSIGN 
            T-Devol[10] = T-Devol[10] + ( IF ncodmon = 1 THEN T-Devmn ELSE T-Devme )
            t-Canti     = T-Canti     + x-signo1 * Ccbddocu.candes * f-Factor.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*IF F-PERIODO = "" THEN DO:
   MESSAGE "Ingrese un periodo valido" VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
   APPLY "ENTRY" TO F-PERIODO.
   RETURN NO-APPLY.     
END.*/

IF F-CODFAM <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-CODFAM):
          FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA AND
                              AlmtFami.CodFam = ENTRY(I,F-CODFAM) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmtFami THEN DO:
            MESSAGE "Familia " + ENTRY(I,F-CODFAM) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CODFAM IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

/*
IF F-CODCLI <> "" THEN DO:
  DO I = 1 TO NUM-ENTRIES(F-PROV1):
          FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia AND 
                             GN-PROV.CODPRO = ENTRY(I,F-PROV1) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Prov THEN DO:
            MESSAGE "Proveedor " + ENTRY(I,F-PROV1) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-PROV1 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
  END.

END.*/

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

