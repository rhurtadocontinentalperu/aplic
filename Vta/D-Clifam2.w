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
DEFINE VAR J         AS INTEGER   NO-UNDO.
DEFINE VAR Z         AS INTEGER   NO-UNDO.
DEFINE VAR a         AS INTEGER   NO-UNDO.
DEFINE VAR b         AS INTEGER   NO-UNDO.
DEFINE VAR II        AS INTEGER   NO-UNDO.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Cont    AS INTE INIT 0.
DEFINE VAR T-Totmn   AS DECI INIT 0.
DEFINE VAR T-Totme   AS DECI INIT 0.
DEFINE VAR T-contador AS DECI INIT 0.
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
DEFINE VAR x-CodFchI   AS INTEGER FORMAT '99' .
DEFINE VAR x-CodFchF   AS INTEGER FORMAT '99' .
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
DEFINE VAR x-contador    AS INT  EXTENT 12 FORMAT "999" INITIAL 0.
DEFINE BUFFER B-CDOCU FOR CcbCdocu.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-nrodoc  LIKE CcbCDocu.NroDoc
    FIELD t-coddoc  LIKE CcbCDocu.CodDoc
    FIELD t-nroref  LIKE CcbCDocu.NroRef
    FIELD t-fchdoc  LIKE CcbCDocu.FchDoc
    FIELD t-codcli  LIKE CcbCDocu.CodCli
    FIELD t-NomCli  LIKE CcbCDocu.NomCli
    FIELD t-ventamn AS DEC            FORMAT "->>>,>>>,>>9.99" 
    FIELD t-ventame AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devolme AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devolmn AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-totalmn AS DEC            FORMAT "->>>,>>>,>>9.99" 
    FIELD t-totalme AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-venta   AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99"  
    FIELD t-total   AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99"
    FIELD t-xcntj   AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99"
    FIELD t-conta   AS INT  EXTENT 12 FORMAT "9999".

DEFINE TEMP-TABLE tmp-tempo1 
    FIELD t-codcia1  LIKE Almdmov.Codcia 
    FIELD t-nrodoc1  LIKE CcbCDocu.NroDoc
    FIELD t-coddoc1  LIKE CcbCDocu.CodDoc
    FIELD t-nroref1  LIKE CcbCDocu.NroRef
    FIELD t-fchdoc1  LIKE CcbCDocu.FchDoc
    FIELD t-codcli1  LIKE CcbCDocu.CodCli
    FIELD t-NomCli1  LIKE CcbCDocu.NomCli
    FIELD t-ventamn1 AS DEC            FORMAT "->>>,>>>,>>9.99" 
    FIELD t-ventame1 AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devolme1 AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devolmn1 AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-totalmn1 AS DEC            FORMAT "->>>,>>>,>>9.99" 
    FIELD t-totalme1 AS DEC            FORMAT "->>>,>>>,>>9.99"
    FIELD t-devol1   AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99"
    FIELD t-total1   AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99"
    FIELD t-xcntj1   AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99"
    FIELD t-conta1   AS INT  EXTENT 12 FORMAT "9999"
    FIELD t-cont1    AS INT  EXTENT 12 FORMAT "9999".

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
Btn_OK Btn_Cancel 
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
     SIZE 66 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 2.15
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 7.12
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodCli AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 4
     x-NomCli AT ROW 2.62 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     DesdeF AT ROW 4.23 COL 10 COLON-ALIGNED WIDGET-ID 8
     HastaF AT ROW 4.23 COL 28 COLON-ALIGNED WIDGET-ID 10
     nCodMon AT ROW 5.85 COL 12 NO-LABEL
     txt-msj AT ROW 6.92 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     Btn_OK AT ROW 9.08 COL 48
     Btn_Cancel AT ROW 9.08 COL 60
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.31 COL 4.43
          FONT 6
     " Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.85 COL 5
     RECT-61 AT ROW 1.54 COL 3
     RECT-46 AT ROW 8.81 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.57 BY 10.27
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
         HEIGHT             = 10.27
         WIDTH              = 75.57
         MAX-HEIGHT         = 10.27
         MAX-WIDTH          = 75.57
         VIRTUAL-HEIGHT     = 10.27
         VIRTUAL-WIDTH      = 75.57
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
        S-SUBTIT      = "PERIODO      : "  + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
        X-MONEDA      = "MONEDA       : "  + IF NCODMON = 1 THEN "  NUEVOS SOLES " ELSE "  DOLARES AMERICANOS ".  
        IF DesdeF = ?  THEN DesdeF = 01/01/1900.
        IF HastaF = ?  THEN HastaF = 01/01/3000.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*******Inicializa la Tabla Temporal ******/
    FOR EACH tmp-tempo:
        DELETE tmp-tempo.
    END.
    FOR EACH tmp-tempo1:
        DELETE tmp-tempo1.
    END.
    /********************************/
    ASSIGN
        x-CodFchF = MONTH(HastaF)
        x-CodFchI = MONTH(DesdeF).

    /* Barremos las ventas */                                                               
    FOR EACH CcbCdocu NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA
        AND Ccbcdocu.fchdoc >= DesdeF
        AND Ccbcdocu.fchdoc <= HastaF
        AND CcbCdocu.CodCli BEGINS F-CodCli
        AND CcbCdocu.TpoFac <> 'A':      /* NO facturas adelantadas */       
        /* ***************** FILTROS ********************************** */
        IF Lookup(CcbCDocu.CodDoc,"FAC,BOL") = 0 THEN NEXT.
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
        /* *********************************************************** */
        x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
        ASSIGN x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */
        /* buscamos si hay una aplicación de fact adelantada */
        FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
        /* ************************************************* */
        FIND LAST Gn-Tcmb USE-INDEX Cmb01
            WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb USE-INDEX Cmb01
                WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.

        FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
            /* FILTROS */
            FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
                AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN NEXT.
            FIND Almtfami WHERE Almtfami.Codcia = Almmmatg.Codcia 
                AND Almtfami.CodFam = Almmmatg.CodFam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almtfami THEN NEXT.
            FIND AlmSFam  WHERE AlmSFam.Codcia  = Almmmatg.Codcia 
                AND AlmSFam.CodFam  = Almtfami.CodFam 
                AND AlmSFam.SubFam  = Almmmatg.SubFam NO-LOCK NO-ERROR.
            /*
            DISPLAY CcbCdocu.nrodoc @ Fi-Mensaje LABEL "Numero de Documento "
              FORMAT "X(11)" WITH FRAME F-Proceso. 
            */
            DISPLAY "Numero de Documento " + CcbCdocu.nrodoc @ txt-msj WITH FRAME {&FRAME-NAME}.

            IF NOT AVAILABLE AlmSFam THEN NEXT.
            IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
            /* ************************************************************** */
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = Ccbddocu.UndVta NO-LOCK NO-ERROR.
            F-FACTOR  = 1. 
            IF AVAILABLE Almtconv THEN DO:
               F-FACTOR = Almtconv.Equival.
               IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            T-Vtamn   = 0.
            T-Vtame   = 0.
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
            CREATE  tmp-tempo.
            ASSIGN  
                tmp-tempo.t-codcia  = S-CODCIA
                tmp-tempo.t-codcli  = CcbCDocu.CodCli
                tmp-tempo.t-NomCli  = CcbCDocu.NomCli
                tmp-tempo.t-nrodoc  = CcbCDocu.NroDoc
                tmp-tempo.t-coddoc  = CcbCDocu.CodDoc
                tmp-tempo.t-fchdoc  = CcbCDocu.FchDoc.
            tmp-tempo.T-Venta[MONTH(CcbCdocu.FchDoc)] = tmp-tempo.T-Venta[MONTH(CcbCdocu.FchDoc)] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame ).               
        END.           
       /* CREATE  tmp-tempo.
        ASSIGN  
            tmp-tempo.t-codcia  = S-CODCIA
            tmp-tempo.t-codcli  = CcbCDocu.CodCli
            tmp-tempo.t-NomCli  = CcbCDocu.NomCli
            tmp-tempo.t-nrodoc  = CcbCDocu.NroDoc
            tmp-tempo.t-coddoc  = CcbCDocu.CodDoc
            tmp-tempo.t-fchdoc  = CcbCDocu.FchDoc.
        tmp-tempo.T-Venta[MONTH(CcbCdocu.FchDoc)] = tmp-tempo.T-Venta[MONTH(CcbCdocu.FchDoc)] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame ).*/
    END.

    /* Barremos N/C */                                                               
    FOR EACH CcbCdocu NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA                                      
        AND Ccbcdocu.fchdoc >= DesdeF
        AND Ccbcdocu.fchdoc <= HastaF
        AND CcbCdocu.CodCli BEGINS F-CodCli
        AND CcbCDocu.CodDoc = "N/C" 
        AND CcbCdocu.TpoFac <> 'A':      /* NO facturas adelantadas */       
        /* ***************** FILTROS ********************************** */
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
        /* *********************************************************** */
        x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
        ASSIGN x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */
        /* buscamos si hay una aplicación de fact adelantada */
        FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
        /* ************************************************* */
        FIND LAST Gn-Tcmb USE-INDEX Cmb01
            WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb USE-INDEX Cmb01
                WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
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

        FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
            FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN NEXT.
            FIND Almtfami WHERE Almtfami.Codcia = Almmmatg.Codcia AND
                                Almtfami.CodFam = Almmmatg.CodFam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almtfami THEN NEXT.
            FIND AlmSFam  WHERE AlmSFam.Codcia  = Almmmatg.Codcia AND
                                AlmSFam.CodFam  = Almtfami.CodFam AND
                                AlmSFam.SubFam  = Almmmatg.SubFam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE AlmSFam THEN NEXT.
            IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                Almtconv.Codalter = Ccbddocu.UndVta
                                NO-LOCK NO-ERROR.
            F-FACTOR  = 1. 
            IF AVAILABLE Almtconv THEN DO:
               F-FACTOR = Almtconv.Equival.
               IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
            END.

            T-Devmn    = 0.
            T-Devme    = 0.
            t-contador = 0. 

            IF Ccbcdocu.CodMon = 1 THEN DO:
                IF x-signo1 = -1  THEN DO:
                    ASSIGN    
                         T-Devmn = T-Devmn + CcbDdocu.ImpLin
                         T-Devme = T-Devme + CcbDdocu.ImpLin / x-TpoCmbCmp.
                END.
            END.
            IF Ccbcdocu.CodMon = 2 THEN DO:
                IF x-signo1 = -1  THEN DO:
                    ASSIGN    
                         T-Devmn = T-Devmn + CcbDdocu.ImpLin * x-TpoCmbVta
                         T-Devme = T-Devme + CcbDdocu.ImpLin.
                END.
            END.
           /* FIND tmp-tempo1 WHERE t-codcia1  = S-CODCIA AND  
            tmp-tempo1.t-codcli1  = CcbDDocu.codcli  NO-ERROR.
            IF NOT AVAIL tmp-tempo1 THEN DO:
                 CREATE  tmp-tempo1.
                 ASSIGN  tmp-tempo1.t-codcia1  = S-CODCIA
                         tmp-tempo1.t-codcli1  = CcbCDocu.CodCli
                         tmp-tempo1.t-NomCli1  = CcbCDocu.NomCli
                         tmp-tempo1.t-nrodoc1  = CcbCDocu.NroDoc
                         tmp-tempo1.t-coddoc1  = CcbCDocu.CodDoc
                         tmp-tempo1.t-fchdoc1  = CcbCDocu.FchDoc.
            END.
        ASSIGN tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] = tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] + ( IF ncodmon = 1 THEN T-Devmn ELSE T-Devme ).
       MESSAGE "NOTA-CREDITO" SKIP 
                           "NroDoc: " CcbCDocu.NroDoc SKIP
                           "CodDoc: " CcbCDocu.CodDoc SKIP 
                           "CodRef: " CcbCDocu.CodRef SKIP
                           "NroRef: " CcbCDocu.NroRef SKIP
                           "Fecha: " CcbCdocu.FchDoc SKIP
                           "Devnac: " T-Devmn SKIP
                           "Devext: " T-Devme. */
        
            FIND tmp-tempo1 WHERE t-codcia1  = S-CODCIA 
                AND tmp-tempo1.t-codcli1  = CcbDDocu.codcli  NO-ERROR.
            IF NOT AVAIL tmp-tempo1 THEN DO:
                CREATE  tmp-tempo1.
                ASSIGN  
                    tmp-tempo1.t-codcia1  = S-CODCIA
                    tmp-tempo1.t-codcli1  = CcbCDocu.CodCli
                    tmp-tempo1.t-NomCli1  = CcbCDocu.NomCli
                    tmp-tempo1.t-nrodoc1  = CcbCDocu.NroDoc
                    tmp-tempo1.t-coddoc1  = CcbCDocu.CodDoc
                    tmp-tempo1.t-fchdoc1  = CcbCDocu.FchDoc.
            END.
            ASSIGN tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] = tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] + ( IF ncodmon = 1 THEN T-Devmn ELSE T-Devme ).
        END.
        /*******************************************/
                  
    END.
    
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
  ENABLE RECT-61 F-CodCli DesdeF HastaF nCodMon Btn_OK Btn_Cancel 
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
    DEFINE VAR x-ImpTot  AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99" INIT 0.
    DEFINE VAR x-doc     AS INT  EXTENT 12 FORMAT "9999"             INIT 0.
    DEFINE VAR x-Prom    AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99" INIT 0.
    DEFINE VAR x-TotDev  AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99" INIT 0.
    DEFINE VAR X-DOCDEV  AS INT  EXTENT 12 FORMAT "9999"             INIT 0.
    DEFINE VAR x-PromDev AS DEC  EXTENT 12 FORMAT "->>>,>>>,>>9.99" INIT 0.

    DEFINE FRAME F-REPORTE
        tmp-tempo.t-coddoc         FORMAT "X(4)"               COLUMN-LABEL 'DOC'
        tmp-tempo.t-nrodoc                                     COLUMN-LABEL 'NUMERO'
        tmp-tempo.t-Venta[1]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'ENERO'
        tmp-tempo.t-Venta[2]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'FEBRERO'
        tmp-tempo.t-Venta[3]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'MARZO'
        tmp-tempo.t-Venta[4]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'ABRIL'
        tmp-tempo.t-Venta[5]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'MAYO' 
        tmp-tempo.t-Venta[6]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'JUNIO' 
        tmp-tempo.t-Venta[7]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'JULIO'
        tmp-tempo.t-Venta[8]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'AGOSTO'
        tmp-tempo.t-Venta[9]       FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'SETIEMBRE'
        tmp-tempo.t-Venta[10]      FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'OCTUBRE'
        tmp-tempo.t-Venta[11]      FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'NOVIEMBRE'
        tmp-tempo.t-Venta[12]      FORMAT "->>>,>>>,>>9.99"    COLUMN-LABEL 'DICIEMBRE'
       WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 20 FORMAT "X(50)" 
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina :" TO 173 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZZ9" SKIP
         X-CLIENTE  AT 1  FORMAT "X(60)"
         "Fecha  :" TO 173 FORMAT "X(15)" TODAY TO 183 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 173 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 181   SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 SKIP
         WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY tmp-tempo.t-codcli BY tmp-tempo.t-fchdoc BY tmp-tempo.t-nrodoc :
      /*
      DISPLAY tmp-tempo.t-nrodoc @ Fi-Mensaje LABEL "Numero de Documento "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      DISPLAY "Numero de Documento " + tmp-tempo.t-nrodoc  @ txt-msj WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.
      DO i = 1 TO 12:   
          x-ImpTot[i] = x-ImpTot[i] + tmp-tempo.t-Venta[i].   
      END.      
      
      ACCUM  tmp-tempo.t-venta[1]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[2]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[3]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[4]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[5]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[6]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[7]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[8]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[9]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[10]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[11]  ( SUB-TOTAL BY t-nrodoc) .  
      ACCUM  tmp-tempo.t-venta[12]  ( SUB-TOTAL BY t-nrodoc) .  

      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      IF LAST-OF(t-nrodoc) THEN DO:
      DISPLAY STREAM REPORT 
         tmp-tempo.t-nrodoc                                    
         tmp-tempo.t-coddoc      
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[1])   @   tmp-tempo.t-venta[1] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[2])   @   tmp-tempo.t-venta[2]
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[3])   @   tmp-tempo.t-venta[3] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[4])   @   tmp-tempo.t-venta[4] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[5])   @   tmp-tempo.t-venta[5] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[6])   @   tmp-tempo.t-venta[6] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[7])   @   tmp-tempo.t-venta[7] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[8])   @   tmp-tempo.t-venta[8] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[9])   @   tmp-tempo.t-venta[9] 
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[10])  @   tmp-tempo.t-venta[10]
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[11])  @   tmp-tempo.t-venta[11]
         (ACCUM TOTAL BY t-nrodoc tmp-tempo.t-venta[12])  @   tmp-tempo.t-venta[12]   
         WITH FRAME F-REPORTE.
     x-Doc[MONTH(tmp-tempo.t-fchdoc)] = x-Doc[MONTH(tmp-tempo.t-fchdoc)] + 1. 
     IF LAST-OF(tmp-tempo.t-codcli) THEN DO:
        UNDERLINE STREAM REPORT        
           tmp-tempo.t-Venta[1] 
           tmp-tempo.t-Venta[2] 
           tmp-tempo.t-Venta[3] 
           tmp-tempo.t-Venta[4] 
           tmp-tempo.t-Venta[5] 
           tmp-tempo.t-Venta[6] 
           tmp-tempo.t-Venta[7] 
           tmp-tempo.t-Venta[8] 
           tmp-tempo.t-Venta[9] 
           tmp-tempo.t-Venta[10]
           tmp-tempo.t-Venta[11]
           tmp-tempo.t-Venta[12]         
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
           ("TOTAL VENTA: " ) @ tmp-tempo.t-nrodoc
           x-ImpTot[1]  @ tmp-tempo.t-Venta[1] 
           x-ImpTot[2]  @ tmp-tempo.t-Venta[2] 
           x-ImpTot[3]  @ tmp-tempo.t-Venta[3] 
           x-ImpTot[4]  @ tmp-tempo.t-Venta[4] 
           x-ImpTot[5]  @ tmp-tempo.t-Venta[5] 
           x-ImpTot[6]  @ tmp-tempo.t-Venta[6] 
           x-ImpTot[7]  @ tmp-tempo.t-Venta[7] 
           x-ImpTot[8]  @ tmp-tempo.t-Venta[8] 
           x-ImpTot[9]  @ tmp-tempo.t-Venta[9] 
           x-ImpTot[10] @ tmp-tempo.t-Venta[10]
           x-ImpTot[11] @ tmp-tempo.t-Venta[11]
           x-ImpTot[12] @ tmp-tempo.t-Venta[12]
           WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
           tmp-tempo.t-Venta[1]  
           tmp-tempo.t-Venta[2]  
           tmp-tempo.t-Venta[3]  
           tmp-tempo.t-Venta[4]  
           tmp-tempo.t-Venta[5]  
           tmp-tempo.t-Venta[6]  
           tmp-tempo.t-Venta[7]  
           tmp-tempo.t-Venta[8]  
           tmp-tempo.t-Venta[9]  
           tmp-tempo.t-Venta[10] 
           tmp-tempo.t-Venta[11] 
           tmp-tempo.t-Venta[12]    
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
           ("TOTAL DOCUMENTOS: " ) @ tmp-tempo.t-nrodoc
           X-doc[1]    @ tmp-tempo.t-Venta[1]  
           X-doc[2]    @ tmp-tempo.t-Venta[2]  
           X-doc[3]    @ tmp-tempo.t-Venta[3]  
           X-doc[4]    @ tmp-tempo.t-Venta[4]  
           X-doc[5]    @ tmp-tempo.t-Venta[5]  
           X-doc[6]    @ tmp-tempo.t-Venta[6]  
           X-doc[7]    @ tmp-tempo.t-Venta[7]  
           X-doc[8]    @ tmp-tempo.t-Venta[8]  
           X-doc[9]    @ tmp-tempo.t-Venta[9]  
           X-doc[10]   @ tmp-tempo.t-Venta[10] 
           X-doc[11]   @ tmp-tempo.t-Venta[11] 
           X-doc[12]   @ tmp-tempo.t-Venta[12] 
           WITH FRAME F-REPORTE.
        DO z = 1 TO 12:   
           IF X-DOC[z] <> 0 THEN DO:
              X-PROM[z]    = x-ImpTot[z] / X-DOC[z].
           END.
        END.
        UNDERLINE STREAM REPORT 
           tmp-tempo.t-Venta[1]  
           tmp-tempo.t-Venta[2]  
           tmp-tempo.t-Venta[3]  
           tmp-tempo.t-Venta[4]  
           tmp-tempo.t-Venta[5]  
           tmp-tempo.t-Venta[6]  
           tmp-tempo.t-Venta[7]  
           tmp-tempo.t-Venta[8]  
           tmp-tempo.t-Venta[9]  
           tmp-tempo.t-Venta[10] 
           tmp-tempo.t-Venta[11] 
           tmp-tempo.t-Venta[12]    
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
           ("PROMEDIOS VENTA: " ) @ tmp-tempo.t-nrodoc
           X-PROM[1]    @ tmp-tempo.t-Venta[1]  
           X-PROM[2]    @ tmp-tempo.t-Venta[2]  
           X-PROM[3]    @ tmp-tempo.t-Venta[3]  
           X-PROM[4]    @ tmp-tempo.t-Venta[4]  
           X-PROM[5]    @ tmp-tempo.t-Venta[5]  
           X-PROM[6]    @ tmp-tempo.t-Venta[6]  
           X-PROM[7]    @ tmp-tempo.t-Venta[7]  
           X-PROM[8]    @ tmp-tempo.t-Venta[8]  
           X-PROM[9]    @ tmp-tempo.t-Venta[9]  
           X-PROM[10]   @ tmp-tempo.t-Venta[10] 
           X-PROM[11]   @ tmp-tempo.t-Venta[11] 
           X-PROM[12]   @ tmp-tempo.t-Venta[12] 
           WITH FRAME F-REPORTE.
      END.
     END.
  
        FOR EACH tmp-tempo1 WHERE tmp-tempo1.t-codcli1 = tmp-tempo.t-codcli BREAK BY tmp-tempo1.t-codcli1  : 
            IF AVAILABLE tmp-tempo1 THEN DO:
                IF LAST-OF(tmp-tempo.t-codcli) THEN DO:
                    DO j = 1 TO 12:   
                       x-TotDev[j] = x-TotDev[j] + tmp-tempo1.T-Devol1[j].   
                    END.
                    IF LAST-OF(tmp-tempo1.t-codcli1) THEN DO:
                    UNDERLINE STREAM REPORT        
                       tmp-tempo.t-Venta[1] 
                       tmp-tempo.t-Venta[2] 
                       tmp-tempo.t-Venta[3] 
                       tmp-tempo.t-Venta[4] 
                       tmp-tempo.t-Venta[5] 
                       tmp-tempo.t-Venta[6] 
                       tmp-tempo.t-Venta[7] 
                       tmp-tempo.t-Venta[8] 
                       tmp-tempo.t-Venta[9] 
                       tmp-tempo.t-Venta[10]
                       tmp-tempo.t-Venta[11]
                       tmp-tempo.t-Venta[12]         
                    WITH FRAME F-REPORTE.
                    DISPLAY STREAM REPORT 
                       ("TOTAL DEVOLUCION: " )  @ tmp-tempo.t-nrodoc
                       x-TotDev[1]   @ tmp-tempo.t-Venta[1]   
                       x-TotDev[2]   @ tmp-tempo.t-Venta[2]   
                       x-TotDev[3]   @ tmp-tempo.t-Venta[3]   
                       x-TotDev[4]   @ tmp-tempo.t-Venta[4]   
                       x-TotDev[5]   @ tmp-tempo.t-Venta[5]   
                       x-TotDev[6]   @ tmp-tempo.t-Venta[6]   
                       x-TotDev[7]   @ tmp-tempo.t-Venta[7]   
                       x-TotDev[8]   @ tmp-tempo.t-Venta[8]   
                       x-TotDev[9]   @ tmp-tempo.t-Venta[9]   
                       x-TotDev[10]  @ tmp-tempo.t-Venta[10]  
                       x-TotDev[11]  @ tmp-tempo.t-Venta[11]  
                       x-TotDev[12]  @ tmp-tempo.t-Venta[12]
                       WITH FRAME F-REPORTE.  
                    x-Docdev[MONTH(tmp-tempo1.t-fchdoc1)] = x-Docdev[MONTH(tmp-tempo1.t-fchdoc1)] + 1.
                       UNDERLINE STREAM REPORT 
                       tmp-tempo.t-Venta[1]  
                       tmp-tempo.t-Venta[2]  
                       tmp-tempo.t-Venta[3]  
                       tmp-tempo.t-Venta[4]  
                       tmp-tempo.t-Venta[5]  
                       tmp-tempo.t-Venta[6]  
                       tmp-tempo.t-Venta[7]  
                       tmp-tempo.t-Venta[8]  
                       tmp-tempo.t-Venta[9]  
                       tmp-tempo.t-Venta[10] 
                       tmp-tempo.t-Venta[11] 
                       tmp-tempo.t-Venta[12]    
                   WITH FRAME F-REPORTE.
                   DISPLAY STREAM REPORT 
                       ("TOTAL DOCS. DEVOLUCION: " ) @ tmp-tempo.t-nrodoc
                       X-docdev[1]    @ tmp-tempo.t-Venta[1]  
                       X-docdev[2]    @ tmp-tempo.t-Venta[2]  
                       X-docdev[3]    @ tmp-tempo.t-Venta[3]  
                       X-docdev[4]    @ tmp-tempo.t-Venta[4]  
                       X-docdev[5]    @ tmp-tempo.t-Venta[5]  
                       X-docdev[6]    @ tmp-tempo.t-Venta[6]  
                       X-docdev[7]    @ tmp-tempo.t-Venta[7]  
                       X-docdev[8]    @ tmp-tempo.t-Venta[8]  
                       X-docdev[9]    @ tmp-tempo.t-Venta[9]  
                       X-docdev[10]   @ tmp-tempo.t-Venta[10] 
                       X-docdev[11]   @ tmp-tempo.t-Venta[11] 
                       X-docdev[12]   @ tmp-tempo.t-Venta[12] 
                   WITH FRAME F-REPORTE. 
                   DO a = 1 TO 12:   
                      IF X-DOCDEV[a] <> 0 THEN DO:
                         X-PROMDEV[a] = x-TotDev[a] / X-DOCDEV[a].
                      END.
                   END.
                   UNDERLINE STREAM REPORT 
                      tmp-tempo.t-Venta[1]  
                      tmp-tempo.t-Venta[2]  
                      tmp-tempo.t-Venta[3]  
                      tmp-tempo.t-Venta[4]  
                      tmp-tempo.t-Venta[5]  
                      tmp-tempo.t-Venta[6]  
                      tmp-tempo.t-Venta[7]  
                      tmp-tempo.t-Venta[8]  
                      tmp-tempo.t-Venta[9]  
                      tmp-tempo.t-Venta[10] 
                      tmp-tempo.t-Venta[11] 
                      tmp-tempo.t-Venta[12]    
                   WITH FRAME F-REPORTE.
                   DISPLAY STREAM REPORT 
                      ("PROMEDIOS DEVOLUCION: " ) @ tmp-tempo.t-nrodoc
                      X-PROMDEV[1]    @ tmp-tempo.t-Venta[1]  
                      X-PROMDEV[2]    @ tmp-tempo.t-Venta[2]  
                      X-PROMDEV[3]    @ tmp-tempo.t-Venta[3]  
                      X-PROMDEV[4]    @ tmp-tempo.t-Venta[4]  
                      X-PROMDEV[5]    @ tmp-tempo.t-Venta[5]  
                      X-PROMDEV[6]    @ tmp-tempo.t-Venta[6]  
                      X-PROMDEV[7]    @ tmp-tempo.t-Venta[7]  
                      X-PROMDEV[8]    @ tmp-tempo.t-Venta[8]  
                      X-PROMDEV[9]    @ tmp-tempo.t-Venta[9]  
                      X-PROMDEV[10]   @ tmp-tempo.t-Venta[10] 
                      X-PROMDEV[11]   @ tmp-tempo.t-Venta[11] 
                      X-PROMDEV[12]   @ tmp-tempo.t-Venta[12] 
                      WITH FRAME F-REPORTE.
                   END.
               END.
            END.
       END.                   
        
    END.
    
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
  /*
  HIDE FRAME F-PROCESO.
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
        ENABLE ALL EXCEPT txt-msj x-NomCli.
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
  
  /*FILL-IN-Periodo = s-Periodo.*/

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
IF NOT AVAILABLE B-CDOCU THEN RETURN.

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
        T-Devmn    = 0. 
        T-Devme    = 0.  
        IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                    T-Devmn = T-Devmn + CcbDdocu.ImpLin * x-coe
                    T-Devme = T-Devme + CcbDdocu.ImpLin / x-TpoCmbCmp * x-coe.
        IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                    T-Devmn = T-Devmn + CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                    T-Devme = T-Devme + CcbDdocu.ImpLin * x-coe.
        /*FIND tmp-tempo1 WHERE t-codcia1 = S-CODCIA AND  
        tmp-tempo1.t-codcli1  = CcbDDocu.codcli  NO-ERROR.
        IF NOT AVAIL tmp-tempo1 THEN DO:
        CREATE  tmp-tempo1.
        ASSIGN  tmp-tempo1.t-codcia1  = S-CODCIA
                tmp-tempo1.t-codcli1  = CcbCDocu.CodCli
                tmp-tempo1.t-NomCli1  = CcbCDocu.NomCli
                tmp-tempo1.t-nrodoc1  = CcbCDocu.NroDoc
                tmp-tempo1.t-coddoc1  = CcbCDocu.CodDoc
                tmp-tempo1.t-fchdoc1  = CcbCDocu.FchDoc.
       END.

       MESSAGE "PROCESA-NOTA" SKIP 
                           "NroDoc: " CcbCDocu.NroDoc SKIP
                           "CodDoc: " CcbCDocu.CodDoc SKIP 
                           "CodRef: " CcbCDocu.CodRef SKIP
                           "NroRef: " CcbCDocu.NroRef SKIP
                           "Fecha: " CcbCdocu.FchDoc SKIP
                           "Devnac: " T-Devmn SKIP
                           "Devext: " T-Devme.

       ASSIGN tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] = tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] + ( IF ncodmon = 1 THEN T-Devmn ELSE T-Devme ). */
   
                   FIND tmp-tempo1 WHERE t-codcia1 = S-CODCIA AND  
                        tmp-tempo1.t-codcli1  = CcbDDocu.codcli  NO-ERROR.
                   IF NOT AVAIL tmp-tempo1 THEN DO:
                        CREATE  tmp-tempo1.
                        ASSIGN  tmp-tempo1.t-codcia1  = S-CODCIA
                                tmp-tempo1.t-codcli1  = CcbCDocu.CodCli
                                tmp-tempo1.t-NomCli1  = CcbCDocu.NomCli
                                tmp-tempo1.t-nrodoc1  = CcbCDocu.NroDoc
                                tmp-tempo1.t-coddoc1  = CcbCDocu.CodDoc
                                tmp-tempo1.t-fchdoc1  = CcbCDocu.FchDoc.
                   END.
                   ASSIGN tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] = tmp-tempo1.T-Devol1[MONTH(CcbCdocu.FchDoc)] + ( IF ncodmon = 1 THEN T-Devmn ELSE T-Devme ).

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
DO WITH FRAME {&FRAME-NAME}:
    IF F-CodCli = "" THEN DO:
       MESSAGE "Ingrese un codigo de cliente por favor" VIEW-AS ALERT-BOX.
       RETURN "ADM-ERROR".
       APPLY "ENTRY" TO F-CodCli.
       RETURN NO-APPLY.     
    END.
    IF YEAR(HastaF) <> YEAR(DesdeF) THEN DO:
       MESSAGE "Ingrese el rango de fechas del mismo año" VIEW-AS ALERT-BOX.
       RETURN "ADM-ERROR".
       APPLY "ENTRY" TO DesdeF.
       RETURN NO-APPLY.      
    END.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

