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
DEFINE VAR X-nombre  AS CHAR FORMAT "X(40)".
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
/*
DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-desfam  LIKE Almtfami.desfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-dessub  LIKE AlmSFam.dessub
    FIELD t-nrodoc  LIKE CcbCDocu.NroDoc
    FIELD t-coddoc  LIKE CcbCDocu.CodDoc
    FIELD t-nroref  LIKE CcbCDocu.NroRef
    FIELD t-fchdoc  LIKE CcbCDocu.FchDoc
    FIELD t-codcli  LIKE CcbCDocu.CodCli
    FIELD t-NomCli  LIKE CcbCDocu.NomCli
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
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
    FIELD t-xcntj   AS DEC  EXTENT 10 FORMAT "->>>,>>>,>>9.99".
*/
DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Gn-Clie.Codcia 
    FIELD t-canal   LIKE Gn-Clie.canal 
    FIELD t-nombre  LIKE almtabla.nombre FORMAT "X(40)"
    FIELD t-codcli  LIKE Gn-Clie.codcli 
    FIELD t-nomcli  LIKE Gn-Clie.nomcli  FORMAT "X(40)"
    FIELD t-ruc     LIKE Gn-Clie.ruc
    FIELD t-clfcli  LIKE Gn-Clie.clfcli
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>,>>>,>>9.99"  .

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
&Scoped-Define ENABLED-OBJECTS RECT-61 F-CodCli DesdeF HastaF nCodMon ~
Btn_OK Btn_Excel Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodCli x-NomCli DesdeF HastaF nCodMon ~
txt-msj 

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

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 2.15
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 5.92
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodCli AT ROW 2.27 COL 12 COLON-ALIGNED WIDGET-ID 4
     x-NomCli AT ROW 2.27 COL 24.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     DesdeF AT ROW 3.42 COL 12 COLON-ALIGNED WIDGET-ID 8
     HastaF AT ROW 3.42 COL 30 COLON-ALIGNED WIDGET-ID 10
     nCodMon AT ROW 4.58 COL 14 NO-LABEL
     txt-msj AT ROW 6.12 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     Btn_OK AT ROW 7.96 COL 24
     Btn_Excel AT ROW 7.96 COL 39 WIDGET-ID 2
     Btn_Cancel AT ROW 7.96 COL 54
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.27 COL 4.43
          FONT 6
     " Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.58 COL 7
     RECT-61 AT ROW 1.46 COL 3
     RECT-46 AT ROW 7.65 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
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
         TITLE              = "Ventas Totales"
         HEIGHT             = 9.54
         WIDTH              = 69.43
         MAX-HEIGHT         = 23.85
         MAX-WIDTH          = 145.86
         VIRTUAL-HEIGHT     = 23.85
         VIRTUAL-WIDTH      = 145.86
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
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE.

/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Ventas Totales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas Totales */
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
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
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
        ASSIGN F-CodCli
               DesdeF 
               HastaF
               nCodMon
               x-NomCli.
        X-CLIENTE     = "CLIENTE      : "  + F-CODCLI + " " + x-NomCli.
        S-SUBTIT      = "PERIODO          : "  + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
        X-FAMILIA     = "CANALES EVALUADOS: 0001, 0002, 0003, 0004, 0006, 0008" .
        X-MONEDA      = "MONEDA           : "  + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  
        IF DesdeF = ?  THEN DesdeF = 01/01/1900.
        IF HastaF = ?  THEN HastaF = 01/01/3000.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*
------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 

    /*******Inicializa la Tabla Temporal ******/
    FOR EACH tmp-tempo :
        DELETE tmp-tempo.
    END.
    /********************************/
    /* Barremos las ventas */     
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FOR EACH EvtClie NO-LOCK USE-INDEX Llave01
            WHERE EvtClie.CodCia = gn-divi.codcia
            AND EvtClie.CodDiv = gn-divi.CodDiv
            AND EvtClie.CodCli BEGINS F-CodCli 
            AND (EvtClie.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99")) AND  
                 EvtClie.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
            FIRST Gn-Clie NO-LOCK WHERE Gn-Clie.codcia = cl-codcia 
            AND Gn-Clie.codcli = EvtClie.Codcli:

            IF Lookup(gn-clie.Canal,"0001,0002,0003,0004,0006,0008") = 0 THEN NEXT. 
            DISPLAY "Cliente: " + EvtClie.Codcli @ txt-msj 
                WITH FRAME {&FRAME-NAME}.

            T-Vtamn   = 0.
            T-Vtame   = 0.
            /*****************Capturando el Mes siguiente *******************/
            IF EvtClie.Codmes < 12 THEN DO:
                ASSIGN
                    X-CODMES = EvtClie.Codmes + 1
                    X-CODANO = EvtClie.Codano .
            END.
            ELSE DO: 
                ASSIGN
                    X-CODMES = 01
                    X-CODANO = EvtClie.Codano + 1 .
            END.

            /**********************************************************************/
            /*********************** Calculo Para Obtener los datos diarios ************/
            DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClie.Codmes,"99") + "/" + STRING(EvtClie.Codano,"9999")).
                IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                    FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha <= DATE(STRING(I,"99") + "/" + STRING(EvtClie.Codmes,"99") + "/" + STRING(EvtClie.Codano,"9999")) NO-LOCK NO-ERROR.
                    IF AVAILABLE Gn-tcmb THEN DO: 
                        T-Vtamn   = T-Vtamn   + EvtClie.Vtaxdiamn[I] + EvtClie.Vtaxdiame[I] * Gn-Tcmb.Venta.
                        T-Vtame   = T-Vtame   + EvtClie.Vtaxdiame[I] + EvtClie.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    END.
                END.
            END.      

            /**********************************************************************/
            CASE gn-clie.Canal:
                WHEN "0001" THEN X-nombre = "INSTITUCIONES PUBLICAS" .
                WHEN "0002" THEN X-nombre = "PROVEEDORES" .
                WHEN "0003" THEN X-nombre = "OFICINAS" .
                WHEN "0004" THEN X-nombre = "DISTRIBUIDOR LIMA" .
                WHEN "0006" THEN X-nombre = "LIBRERIA LIMA" .
                WHEN "0008" THEN X-nombre = "AUTOSERVICIO" .
            END CASE. 
            /******************************************************************************/      

            FIND tmp-tempo WHERE t-codcia  = S-CODCIA 
                AND T-codcli   = EvtClie.Codcli NO-ERROR. 
            IF NOT AVAIL tmp-tempo THEN DO:
                CREATE tmp-tempo.
                ASSIGN 
                    t-codcia  = S-CODCIA
                    T-Codcli  = EvtClie.Codcli
                    t-nombre  = X-nombre
                    /*t-canal  = gn-clie.Canal   
                    t-nomcli = gn-clie.Nomcli 
                    t-ruc    = gn-clie.ruc*/.   
                IF AVAILABLE gn-clie THEN 
                    ASSIGN 
                        t-canal  = gn-clie.Canal
                        t-nomcli = gn-clie.Nomcli
                        t-ruc    = gn-clie.ruc.         
            END.
            ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame ).
        END.
    END. /*For each gn-divi...*/

/*HIDE FRAME F-PROCESO.*/
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
  DISPLAY F-CodCli x-NomCli DesdeF HastaF nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 F-CodCli DesdeF HastaF nCodMon Btn_OK Btn_Excel Btn_Cancel 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 5.
chWorkSheet:COLUMNS("B"):ColumnWidth = 45.
chWorkSheet:COLUMNS("C"):ColumnWidth = 11.
chWorkSheet:COLUMNS("D"):ColumnWidth = 45.
chWorkSheet:COLUMNS("E"):ColumnWidth = 45.
chWorkSheet:COLUMNS("F"):ColumnWidth = 45.

chWorkSheet:Range("A1: L5"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE = "ESTADISTICAS DE VENTAS - CLIENTES X CANAL ". 
chWorkSheet:Range("A2"):VALUE = "PERIODO                        : " + STRING(DesdeF,"99/99/9999") + 
" AL " + STRING(HastaF,"99/99/9999"). 
chWorkSheet:Range("A3"):VALUE = "CANALES EVALUADOS: 0001, 0002, 0003, 0004, 0006, 0008" .
chWorkSheet:Range("A5"):VALUE = "Canal".
chWorkSheet:Range("B5"):VALUE = "Descripción".
chWorkSheet:Range("C5"):VALUE = "Código".
chWorkSheet:Range("D5"):VALUE = "RUC".
chWorkSheet:Range("E5"):VALUE = "Cliente".
chWorkSheet:Range("F5"):VALUE = "Venta Efectiva".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH   tmp-tempo:
    DELETE tmp-tempo.
END.

RUN Carga-temporal.

loopREP:
FOR EACH tmp-tempo WHERE t-codcia = s-codcia 
    BREAK BY t-codcia
    BY t-canal
    BY t-codcli:
    ACCUM  t-venta[10]  ( TOTAL BY t-codcli) .
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-canal.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-nombre.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-codcli.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-ruc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-nomcli.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = STRING ((ACCUM TOTAL BY t-codcli t-venta[10]), "->>,>>>,>>>,>>9.99").
    /*
         DISPLAY t-codcli @ Fi-Mensaje LABEL "Codigo de Cliente "
            FORMAT "X(11)" WITH FRAME F-Proceso.
            READKEY PAUSE 0.
            IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.             
    */
    DISPLAY "Codigo de Cliente: " +  t-codcli @ txt-msj WITH FRAME {&FRAME-NAME}.
END.
HIDE FRAME F-Proceso NO-PAUSE.

DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
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
         t-canal     AT 1
         t-nombre    FORMAT "X(30)"
         t-codcli    FORMAT "X(11)"
         t-ruc       FORMAT "X(11)"
         t-nomcli    FORMAT "X(40)"
         t-venta[10] FORMAT "->>,>>>,>>>,>>9.99"
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU      AT 20 FORMAT "X(65)"  SKIP(1)
         S-SUBTIT    AT 1  FORMAT "X(60)" 
         "Pagina  :" TO 90 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-FAMILIA   AT 1  FORMAT "X(60)" 
         "Fecha  :"  TO 90 FORMAT "X(15)" TODAY TO 123 FORMAT "99/99/9999" SKIP
         X-MONEDA    AT 1  FORMAT "X(60)"
         "Hora   :"  TO 90 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 121   SKIP
         "-----------------------------------------------------------------------------------------------------------------------------" SKIP
         "Canal    Descripción                    Código      RUC         Nombre o Razon Social                               Importe  " SKIP
         "-----------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo WHERE t-codcia = s-codcia
                     BREAK BY t-codcia
                           BY t-canal
                           BY t-codcli:
      DISPLAY "Codigo de Cliente: " +  t-codcli @ txt-msj WITH FRAME {&FRAME-NAME}.
      /*
      DISPLAY t-codcli @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */        
      VIEW STREAM REPORT FRAME F-HEADER.  
      ACCUM  t-venta[10]  ( TOTAL BY t-codcli) .
      DOWN STREAM REPORT WITH FRAME F-REPORTE. 
      IF LAST-OF(t-codcli) THEN DO:
         DISPLAY STREAM REPORT 
             t-canal 
             t-nombre
             t-codcli
             t-ruc   
             t-nomcli
             (ACCUM TOTAL BY t-codcli t-venta[10]) @ t-venta[10]
             WITH FRAME F-REPORTE.
      END.   
  END.

  DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
  /*HIDE FRAME F-PROCESO.*/
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
        ENABLE ALL EXCEPT txt-msj.
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

        RUN Formato1.

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
  ASSIGN F-CodCli
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
IF AVAILABLE B-CDOCU THEN DO:
    x-ImpTot = B-CDOCU.ImpTot.     /* <<< OJO <<< */
    /* buscamos si hay una aplicación de fact adelantada */
    FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
    /* ************************************************* */
           x-coe = Ccbcdocu.ImpTot / x-ImpTot.
           FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
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
               IF B-CDOCU.CodMon = 1 THEN DO:
                    /*IF x-signo1 = 1 THEN DO:
                            ASSIGN
                                 T-Vtamn = T-Vtamn + x-signo1 * B-CDOCU.ImpLin
                                 T-Vtame = T-Vtame + x-signo1 * B-CDOCU.ImpLin / x-TpoCmbCmp.
                    END.
                    ELSE DO:*/
                        IF x-signo1 = -1  THEN DO:
                            ASSIGN    
                                 T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin
                                 T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
                        END.
                   /* END.
                    ASSIGN T-Totmn = T-Vtamn + ( T-Devmn * (-1) )
                           T-Totme = T-Vtame + ( T-Devme * (-1) ).
                    ASSIGN T-Pormn = ( T-Devmn * (-1) ) / T-Totmn 
                           T-Porme = ( T-Devme * (-1) ) / T-Totme. */
               END.
               IF B-CDOCU.CodMon = 2 THEN DO:
                    /*IF x-signo1 = 1 THEN DO:
                            ASSIGN
                                 T-Vtamn = T-Vtamn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                                 T-Vtame = T-Vtame + x-signo1 * CcbDdocu.ImpLin.
                    END.
                    ELSE DO:*/
                        IF x-signo1 = -1  THEN DO:
                            ASSIGN    
                                 T-Devmn = T-Devmn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                                 T-Devme = T-Devme + x-signo1 * CcbDdocu.ImpLin.
                        END.
                   /* END.
                    ASSIGN T-Totmn = T-Vtamn + ( T-Devmn * (-1) )
                           T-Totme = T-Vtame + ( T-Devme * (-1) ).
                    ASSIGN T-Pormn = ( T-Devmn * (-1) ) / T-Totmn 
                           T-Porme = ( T-Devme * (-1) ) / T-Totme. */
               END.
                
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

    /*CASE HANDLE-CAMPO:name:
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.*/
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
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

