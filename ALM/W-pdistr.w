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

/*DEFINE VAR s-nomcia AS CHAR INIT "CONTINENTAL S.A.C.".*/
DEFINE VAR X-TITU AS CHAR INIT "DISTRIBUCION DE MERCADERIA X ZONAS".
define var x as int.
define var y as int.
define var x-fecini as date.
define var x-fecfin as date.
define var i as integer .
define var x-canped as deci .

DEFINE VAR x-desarT AS CHAR.
DEFINE VAR S-CODMAT AS CHAR.






DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR cl-codcia AS INT.
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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
         
         


DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR S-SUBTIT  AS CHAR.
/*DEFINE VAR X-TITU    AS CHAR INIT "ESTADISTICA DE VENTAS Vs. COSTOS X VENDEDOR Y FAMILIA".*/
DEFINE VAR X-MONEDA  AS CHAR.
/*DEFINE VAR I         AS INTEGER   NO-UNDO.*/
DEFINE VAR II        AS INTEGER   NO-UNDO.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.
/*DEFINE VAR x         AS int  INIT 0.*/
DEFINE VAR x-desfam  AS char.
DEFINE VAR X-MARGEN  AS deci INIT 0.

DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-FAM     AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR C-TIPO   AS CHAR INIT "Clientes".



DEFINE TEMP-TABLE tmp-tempo

    FIELD t-divi   LIKE facCpedi.coddiv
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-FchPed LIKE FaccPedi.FchPed
    FIELD t-Codcli LIKE FacCPedi.Codcli FORMAT "x(10)"
    FIELD t-Codubi LIKE FacCPedi.Codcli FORMAT "x(6)"
    FIELD t-Nomubi LIKE FacCPedi.NomCli FORMAT "x(35)"
    FIELD t-NomCli LIKE FacCPedi.NomCli FORMAT "x(35)"
    FIELD t-Canped LIKE FacDPedi.CanPed
    FIELD t-stock  LIKE FacDPedi.CanPed
    FIELD t-Vende  LIKE FaccPedi.Codven.

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
&Scoped-Define ENABLED-OBJECTS RECT-48 W_FECINI w_fecfin Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS W_FECINI w_fecfin 

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
     SIZE 11.29 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE w_fecfin AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE W_FECINI AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36.29 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.72 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     W_FECINI AT ROW 1.58 COL 8.72 COLON-ALIGNED
     w_fecfin AT ROW 1.58 COL 23.86 COLON-ALIGNED
     Btn_OK AT ROW 4 COL 4.72
     Btn_Cancel AT ROW 4 COL 15.72
     Btn_Help AT ROW 4 COL 27.43
     RECT-48 AT ROW 1.12 COL 2.14
     RECT-46 AT ROW 3.81 COL 3.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76 BY 10.77
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
         TITLE              = "Distribucion de Mercaderia"
         HEIGHT             = 5.77
         WIDTH              = 40.29
         MAX-HEIGHT         = 27.85
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.85
         VIRTUAL-WIDTH      = 146.29
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Distribucion de Mercaderia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Distribucion de Mercaderia */
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


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  /*RUN Asigna-Variables.*/
  /*RUN Valida.*/
  /*IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME w_fecfin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w_fecfin W-Win
ON LEAVE OF w_fecfin IN FRAME F-Main /* Hasta */
DO:
  assign w_fecfin.
  x-fecfin = w_fecfin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME W_FECINI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W_FECINI W-Win
ON LEAVE OF W_FECINI IN FRAME F-Main /* Desde */
DO:
  assign w_fecini.
  x-fecini = w_fecini.
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
/*   ALMACENES    */
/*********   Barremos las O/D que son parciales y totales    ****************/
FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia
                   AND  FacDPedi.CodDoc = 'O/D' 
                   and  FacDPedi.Fchped >= x-fecini
                   and  FacDpedi.Fchped <= x-fecfin
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
   FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND Faccpedi.coddiv  = FacDpedi.Coddiv
                                     AND Faccpedi.coddoc  = Facdpedi.coddoc
                                     AND Faccpedi.Nroped  = Facdpedi.Nroped
                                     AND Faccpedi.Codalm  = S-CODALM
                                     AND Faccpedi.FlgEst  = "P"
                                     NO-LOCK NO-ERROR.


    DISPLAY Facdpedi.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.


    IF NOT AVAIL FacCPedi THEN NEXT.
    FIND tmp-tempo WHERE t-divi  = FacCpedi.coddiv
                   and   t-codcli = FacCpedi.codcli
                   and   t-codmat = Facdpedi.codmat
                   NO-ERROR.
    IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN 
          t-divi   = facCpedi.coddiv
          t-vende  = faccpedi.codVen
          t-CodDoc = FacCPedi.codDoc
          t-NroPed = FacCPedi.NroPed
          t-FchPed = FacCPedi.FchPed
          t-codcli = faccpedi.codcli
          t-NomCli = FacCPedi.NomCli
          t-codmat = FacDPedi.CodMat
          t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
         end.
    ELSE  assign t-CanPed = t-canped + (FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate )).
    
    /*END.*/
END.

/*******************************************************/

/* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
FOR EACH Facdpedm WHERE Facdpedm.CodCia = s-codcia 
                   and  FacDPedm.Fchped >= x-fecini
                   and  FacDpedm.Fchped <= x-fecfin
                   AND  Facdpedm.FlgEst = "P" :
   FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                     AND  Faccpedm.coddiv  = FacDpedm.Coddiv
                                     AND  Faccpedm.coddoc = Facdpedm.coddoc
                                     AND  Faccpedm.Nroped = Facdpedm.Nroped
                                     AND  Faccpedm.Codalm = s-codalm
                                     AND  Faccpedm.FlgEst = "P"  
                                    NO-LOCK NO-ERROR. 
                                    
   DISPLAY Facdpedm.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

    IF NOT AVAIL Faccpedm THEN NEXT.
    
    TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
    IF TimeOut > 0 THEN DO:
        IF TimeNow <= TimeOut   /* Dentro de la valides */
        THEN DO:
            /* cantidad en reservacion */
            FIND tmp-tempo WHERE t-divi   = FacCpedi.coddiv
                            /*AND  t-CodDoc = FacCPedm.codDoc
                            AND  t-NroPed = FacCPedm.NroPed*/
                            and  t-codcli = facCpedm.codcli
                            and  t-codmat = Facdpedi.codmat
                           NO-ERROR.
            IF NOT AVAIL tmp-tempo THEN DO:
                CREATE tmp-tempo.
                ASSIGN 
                  t-divi   = facCpedm.coddiv
                  t-vende  = faccpedm.codVen
                  t-CodDoc = FacCPedm.codDoc
                  t-NroPed = FacCPedm.NroPed
                  t-FchPed = FacCPedm.FchPed
                  t-codcli = faccpedm.codcli
                  t-NomCli = FacCPedm.NomCli
                  t-codmat = FacDPedm.CodMat
                  t-CanPed = FacDPedm.Factor * FacDPedm.CanPed.
                  end.
            ELSE  assign t-CanPed = t-canped + (FacDPedm.Factor * FacDPedm.CanPed).
            /*END.*/
            /* cantidad en reservacion */
        END.
    END.
END.


for each tmp-tempo:
  find first gn-clie where gn-clie.codcia = cl-codcia 
        and gn-clie.codcli = tmp-tempo.t-codcli no-lock no-error.
  if available gn-clie then do:
    assign  tmp-tempo.t-codubi = gn-clie.coddept  + gn-clie.codprov + gn-clie.coddist.
  end.
  FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN assign t-Nomubi = TabDepto.NomDepto + "/".
    
  FIND TabProvi WHERE Tabprovi.CodDepto = gn-clie.CodDept and TabProvi.CodProvi = gn-clie.CodProv NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN assign t-Nomubi = t-Nomubi + TabProvi.NomProvi + "/".

  FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept and TabDistr.CodProvi = gn-clie.CodProv and 
                      TabDistr.CodDistr = gn-clie.CodDist NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN assign t-Nomubi = t-Nomubi + TabDistr.NomDistr.
end.
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
  DISPLAY W_FECINI w_fecfin 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-48 W_FECINI w_fecfin Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
    ENABLE ALL. /*EXCEPT F-NOMven.*/
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
        RUN Reporte.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte W-Win 
PROCEDURE Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Carga-Temporal.
  
  DEFINE FRAME F-REPORTE
     /*t-codubi format "x(10)" */
     t-nomubi 
     t-CodMat format "x(6)"  
     x-desart format "x(40)" 
     T-CODDOC 
     T-NroPed
     t-codcli
     t-nomcli
     t-Canped format ">>>>9.99"
     WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 75 FORMAT "X(70)" SKIP
         " Almacen : " s-codalm
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha  :" TO  135 FORMAT "X(15)" TODAY TO 152 FORMAT "99/99/9999" SKIP
         "Hora   :" TO  135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 152   SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                                                           " SKIP
        "Z   O   N   A   S                              Codigo Descripcion                                    Cliente   Nombre del Cliente                  Cantidad" SKIP               
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 


  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

                            
  FOR EACH tmp-tempo  WHERE  BREAK BY t-codubi
                               BY t-codmat:

      VIEW STREAM REPORT FRAME F-HEADER.
      y = 0.
      if first-of(t-Codubi) then do:
       y = 1.
      end.
      
      x = 0.
      if first-of(t-Codmat) then do:
       x = 1.
      end.


      FIND Almmmatg WHERE Almmmatg.codmat = tmp-tempo.t-codmat
                          and almmmatg.codcia = s-codcia 
                          NO-LOCK NO-ERROR.
      x-desart = "".
      if available Almmmatg then x-desart = Almmmatg.desmat.

      DISPLAY STREAM REPORT
       /*t-codubi when y = 1 */
       t-nomubi when y = 1
       t-CodMat when x = 1
       x-desart when x = 1
       T-CODDOC 
       T-NroPed
       t-codcli
       t-nomcli
       t-Canped 
      WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      
  END.

  HIDE FRAME F-PROCESO.
  
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

