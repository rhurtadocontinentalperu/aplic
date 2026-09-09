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
DEFINE VAR X-TITU    AS CHAR INIT "VENTAS BRUTAS POR FAMILIAS Y SUB-FAMILIAS EN CANTIDADES".
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

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-codfam  LIKE Almmmatg.codfam
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-desfam  LIKE Almtfami.desfam
    FIELD t-dessub  LIKE Almsfami.dessub
    FIELD t-venta   AS DEC  EXTENT 12   FORMAT "->>>,>>>,>>9.99"  
    FIELD t-total   AS DEC              FORMAT "->>>,>>>,>>9.99"
    INDEX Llave01 t-codcia t-codfam t-subfam.

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
&Scoped-Define ENABLED-OBJECTS RECT-61 F-CodCli DesdeF HastaF Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodCli x-NomCli DesdeF HastaF x-Mensaje 

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

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 1.88
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 5.38
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodCli AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 4
     x-NomCli AT ROW 2.62 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     DesdeF AT ROW 4.23 COL 10 COLON-ALIGNED WIDGET-ID 8
     HastaF AT ROW 4.23 COL 28 COLON-ALIGNED WIDGET-ID 10
     x-Mensaje AT ROW 5.58 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     Btn_OK AT ROW 7.19 COL 44
     Btn_Cancel AT ROW 7.19 COL 60
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.27 COL 4.43
          FONT 6
     RECT-61 AT ROW 1.54 COL 3
     RECT-46 AT ROW 7 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75 BY 8.54
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
         TITLE              = "Ventas Totales en Cantidades"
         HEIGHT             = 8.54
         WIDTH              = 75
         MAX-HEIGHT         = 8.54
         MAX-WIDTH          = 75
         VIRTUAL-HEIGHT     = 8.54
         VIRTUAL-WIDTH      = 75
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
ON END-ERROR OF W-Win /* Ventas Totales en Cantidades */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas Totales en Cantidades */
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
               /*nCodMon*/
               x-NomCli.
        X-CLIENTE     = "CLIENTE      : "  + F-CODCLI + " " + x-NomCli.
        S-SUBTIT      = "PERIODO      : "  + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
        /*X-MONEDA      = "MONEDA       : "  + IF NCODMON = 1 THEN "  NUEVOS SOLES " ELSE "  DOLARES AMERICANOS ".  */
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
    DEF VAR x-CodDoc AS CHAR INIT 'FAC,BOL,TCK' NO-UNDO.
    DEF VAR j AS INT NO-UNDO.

    /*******Inicializa la Tabla Temporal ******/
    FOR EACH tmp-tempo:
        DELETE tmp-tempo.
    END.
    /********************************/
    ASSIGN
        x-CodFchF = MONTH(HastaF)
        x-CodFchI = MONTH(DesdeF).

    /* Barremos las ventas */       
    /*DO j = 1 TO 3:*/
    FOR EACH CcbCdocu USE-INDEX Llave13 NO-LOCK 
        WHERE CcbCdocu.CodCia = S-CODCIA                                      
        AND LOOKUP(Ccbcdocu.coddoc,x-CodDoc) > 0
        AND Ccbcdocu.fchdoc >= DesdeF
        AND Ccbcdocu.fchdoc <= HastaF:

        IF NOT CcbCdocu.CodCli BEGINS F-CodCli THEN NEXT.        

        /* ***************** FILTROS ********************************** */
        IF Ccbcdocu.TpoFac = 'A' THEN NEXT.         /* NO facturas adelantadas */       
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
        /* *********************************************************** */
/*                 DISPLAY CcbCdocu.nrodoc @ Fi-Mensaje LABEL "Numero de Documento " */
/*                   FORMAT "X(11)" WITH FRAME F-Proceso.                            */

        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cargando: " + ccbcdocu.coddiv + ' ' + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + string(ccbcdocu.fchdoc).

        ASSIGN x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */

        /* buscamos si hay una aplicación de fact adelantada */
        FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).

        /* ************************************************* */
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb USE-INDEX Cmb01
                WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.
        
        FOR EACH CcbDdocu OF CcbCdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            /* FILTROS */
            FIND Almtfami WHERE Almtfami.Codcia = Almmmatg.Codcia 
                AND Almtfami.CodFam = Almmmatg.CodFam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almtfami THEN NEXT.
            FIND AlmSFam  WHERE AlmSFam.Codcia  = Almmmatg.Codcia 
                AND AlmSFam.CodFam  = Almtfami.CodFam 
                AND AlmSFam.SubFam  = Almmmatg.SubFam NO-LOCK NO-ERROR.
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
            FIND tmp-tempo WHERE tmp-tempo.t-codcia = Ccbcdocu.codcia
                AND tmp-tempo.t-codfam = Almmmatg.codfam
                AND tmp-tempo.t-subfam = Almmmatg.subfam NO-ERROR.
            IF NOT AVAILABLE tmp-tempo THEN DO:
                CREATE tmp-tempo.
                ASSIGN
                    tmp-tempo.t-codcia = Ccbcdocu.codcia
                    tmp-tempo.t-codfam = Almmmatg.codfam
                    tmp-tempo.t-subfam = Almmmatg.subfam
                    tmp-tempo.t-desfam = Almtfami.desfam
                    tmp-tempo.t-dessub = Almsfami.dessub.
            END.
            tmp-tempo.T-Venta[MONTH(CcbCdocu.FchDoc)] = tmp-tempo.T-Venta[MONTH(CcbCdocu.FchDoc)] + Ccbddocu.candes * f-Factor.
        END.           
    END.

    /*END.*/
    FOR EACH tmp-tempo:
        tmp-tempo.t-total = tmp-tempo.t-venta[1] +
                            tmp-tempo.t-venta[2] +
                            tmp-tempo.t-venta[3] +
                            tmp-tempo.t-venta[4] +
                            tmp-tempo.t-venta[5] +
                            tmp-tempo.t-venta[6] +
                            tmp-tempo.t-venta[7] +
                            tmp-tempo.t-venta[8] +
                            tmp-tempo.t-venta[9] +
                            tmp-tempo.t-venta[10] +
                            tmp-tempo.t-venta[11] +
                            tmp-tempo.t-venta[12].
    END.

    HIDE FRAME F-PROCESO.
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
  DISPLAY F-CodCli x-NomCli DesdeF HastaF x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 F-CodCli DesdeF HastaF Btn_OK Btn_Cancel 
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
        tmp-tempo.t-codfam                                  COLUMN-LABEL 'FAMILIA'
        tmp-tempo.t-desfam                                  COLUMN-LABEL 'DESCRIPCION'
        tmp-tempo.t-subfam                                  COLUMN-LABEL 'SUB-FAMILIA'
        tmp-tempo.t-dessub                                  COLUMN-LABEL 'DESCRIPCION'
        tmp-tempo.t-Venta[1]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'ENERO'
        tmp-tempo.t-Venta[2]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'FEBRERO'
        tmp-tempo.t-Venta[3]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'MARZO'
        tmp-tempo.t-Venta[4]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'ABRIL'
        tmp-tempo.t-Venta[5]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'MAYO' 
        tmp-tempo.t-Venta[6]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'JUNIO' 
        tmp-tempo.t-Venta[7]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'JULIO'
        tmp-tempo.t-Venta[8]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'AGOSTO'
        tmp-tempo.t-Venta[9]       FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'SETIEMBRE'
        tmp-tempo.t-Venta[10]      FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'OCTUBRE'
        tmp-tempo.t-Venta[11]      FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'NOVIEMBRE'
        tmp-tempo.t-Venta[12]      FORMAT ">,>>>,>>9.99"    COLUMN-LABEL 'DICIEMBRE'
        tmp-tempo.t-Total          FORMAT ">>,>>>,>>9.99"   COLUMN-LABEL 'TOTAL'
       WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 20 FORMAT "X(50)" 
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina :" TO 173 PAGE-NUMBER(REPORT) FORMAT "ZZZ9" SKIP
         X-CLIENTE  AT 1  FORMAT "X(60)"
         "Fecha  :" TO 173 TODAY TO 183 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 173 STRING(TIME,"HH:MM:SS") TO 181   SKIP
         WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo :
      VIEW STREAM REPORT FRAME F-HEADER.
      DISPLAY STREAM REPORT 
          tmp-tempo.t-codfam
          tmp-tempo.t-desfam
          tmp-tempo.t-subfam
          tmp-tempo.t-dessub
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
          tmp-tempo.t-Total
          WITH FRAME F-REPORTE.
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
        ENABLE ALL EXCEPT x-Mensaje x-NomCli.
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
         /*nCodMon*/
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
/*     IF F-CodCli = "" THEN DO:                                              */
/*        MESSAGE "Ingrese un codigo de cliente por favor" VIEW-AS ALERT-BOX. */
/*        RETURN "ADM-ERROR".                                                 */
/*        APPLY "ENTRY" TO F-CodCli.                                          */
/*        RETURN NO-APPLY.                                                    */
/*     END.                                                                   */
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

