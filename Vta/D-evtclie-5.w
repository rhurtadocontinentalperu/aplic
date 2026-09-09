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
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
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


DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR S-SUBTIT  AS CHAR.
DEFINE VAR X-TITU    AS CHAR INIT "E S T A D I S T I C A   D E    V E N T A S".
DEFINE VAR X-MONEDA  AS CHAR.
DEFINE VAR I         AS INTEGER NO-UNDO.
DEFINE VAR W_ACU     AS DECIMAL INIT 0.
DEFINE VAR W_RESU    AS DECIMAL INIT 0.
DEFINE VAR W_PDOC    AS decimal INIT 0.
DEFINE VAR II        AS INTEGER   NO-UNDO.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR W_ACUP    AS DECIMAL INIT 0.
DEFINE VAR W_PDOCP   AS decimal INIT 0.





DEFINE VAR N-CANAL   AS CHAR.
DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-LLAVE   AS CHAR.
DEFINE VAR X-FECHA   AS DATE.
DEFINE VAR X-ENTRA   AS LOGICAL INIT FALSE.
DEFINE VAR X-CODDIA  AS INTEGER INIT 1.
DEFINE VAR X-CODANO  AS INTEGER .
DEFINE VAR X-CODMES  AS INTEGER .
DEFINE VAR X-NOMMES  AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR C-TIPO    AS CHAR INIT "Clientes".


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Evtdivi.Codcia 
    FIELD t-Codano  LIKE Evtdivi.Codano
    FIELD t-Codmes  LIKE Evtdivi.Codmes
    FIELD t-Coddia  LIKE Evtdivi.Codano
    FIELD t-fchdoc  LIKE Almdmov.fchdoc
    FIELD t-codcli  LIKE Evtclie.Codcli
    FIELD t-ruc     LIKE Gn-clie.Ruc
    FIELD t-nomcli  LIKE Gn-clie.Nomcli
    FIELD t-clfcli  LIKE Gn-clie.clfcli
    FIELD t-ventamn LIKE EvtClie.Vtaxdiame
    FIELD t-ventame LIKE EvtClie.Vtaxdiamn
    FIELD t-pedidos LIKE EvtClie.Ctoxdiamn.

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
&Scoped-Define ENABLED-OBJECTS RECT-63 RECT-61 BUTTON-5 F-DIVISION BUTTON-8 ~
F-canal f-clien DesdeF HastaF nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-canal f-clien DesdeF HastaF ~
nCodMon txt-msj 

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

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 8" 
     SIZE 4.29 BY .85.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-canal AS CHARACTER FORMAT "X(5)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.14 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.29 BY 6.73
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23.43 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 1.96 COL 24.86
     F-DIVISION AT ROW 2.04 COL 11.57 COLON-ALIGNED
     BUTTON-8 AT ROW 3.08 COL 25
     F-canal AT ROW 3.12 COL 11.57 COLON-ALIGNED
     f-clien AT ROW 4.12 COL 11.57 COLON-ALIGNED
     DesdeF AT ROW 5.31 COL 11.43 COLON-ALIGNED
     HastaF AT ROW 5.38 COL 33 COLON-ALIGNED
     nCodMon AT ROW 6.81 COL 34 NO-LABEL
     Btn_OK AT ROW 8.5 COL 20.57
     Btn_Cancel AT ROW 8.5 COL 31.86
     Btn_Help AT ROW 8.5 COL 43.29
     txt-msj AT ROW 8.88 COL 2.14 NO-LABEL WIDGET-ID 2
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.38 COL 31.86
          FONT 6
     RECT-63 AT ROW 6.5 COL 30
     RECT-46 AT ROW 8.38 COL 1.86
     RECT-61 AT ROW 1.58 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 54.72 BY 9.31
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
         HEIGHT             = 9.31
         WIDTH              = 54.72
         MAX-HEIGHT         = 9.31
         MAX-WIDTH          = 54.72
         VIRTUAL-HEIGHT     = 9.31
         VIRTUAL-WIDTH      = 54.72
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
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

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
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "CN".
    output-var-2 = "".
    RUN lkup\C-ALMTAB02.r("Canal de Ventas").
    IF output-var-2 <> ? THEN DO:
        F-Canal = output-var-2.
        DISPLAY F-Canal.
        APPLY "ENTRY" TO F-Canal.
        RETURN NO-APPLY.        
    END.
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-canal W-Win
ON LEAVE OF F-canal IN FRAME F-Main /* Canal */
DO:
  DO:
   ASSIGN F-Canal.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Canal = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                 AND  AlmTabla.Codigo = F-CANAL
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
      MESSAGE "Codigo de Canal no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
      END.
   ELSE DO :
            N-CANAL = ALMtABLA.NOMBRE.
        END.

  

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  ASSIGN F-clien .
  IF F-Clien = "" THEN DO:
     /*F-Nomcli:SCREEN-VALUE = "".*/
     RETURN.
  END.
  IF F-clien <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Codigo de Cliente NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-Clien IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.     
     END.
     /*F-Nomcli = gn-clie.Nomcli.*/
  END.
  /*DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-DIVISION.
    IF F-DIVISION = ""  THEN RETURN.
   
    IF F-DIVISION <> "" THEN DO:
           
           FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                              Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
           IF NOT AVAILABLE Gn-Divi THEN DO:
               MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                       "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
               RETURN NO-APPLY.
           END.    
         
     END.
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
  ASSIGN F-Division 
         F-clien
         DesdeF 
         HastaF 
         nCodMon .
  
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  IF F-DIVISION = "" THEN DO:
    X-CODDIV = "".
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
        X-CODDIV = X-CODDIV + SUBSTRING(Gn-Divi.Desdiv,1,10) + "," .
    END.
  END.
  ELSE DO:
   FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                      Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
   X-CODDIV = SUBSTRING(Gn-Divi.Desdiv,1,20) + "," .
  END.
  
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-orden W-Win 
PROCEDURE carga-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each tmp-tempo:
      for each faccpedi NO-LOCK  where faccpedi.codcia = 1
                          and (faccpedi.codDoc = "O/D" OR faccpedi.codDoc = "PED")
                          and FacCPedi.CodCli = tmp-tempo.t-codcli 
                          and FacCPedi.Flgest <> "A"
                          and FaccPedi.FchPed >= DesdeF
                          and FaccPedi.FchPed <= HastaF:
     IF faccpedi.codDoc = "O/D"
       THEN t-ventame[month(Faccpedi.FchPed)] = t-ventame[month(Faccpedi.FchPed)] + 1.
     IF faccpedi.codDoc = "PED" and faccpedi.ordcmp <> ""
        Then t-pedidos[month(Faccpedi.FchPed)] = t-pedidos[month(Faccpedi.FchPed)] + 1.
              /*
              DISPLAY faccpedi.Codcli  @ Fi-Mensaje LABEL "Cliente"
              FORMAT "X(18)" WITH FRAME F-Proceso.
              */
      end. 
      DO I = 1 TO 12 :        
       if t-pedidos[I] <> 0 then t-pedidos[13] = t-pedidos[13] + 1.
       if t-ventame[I] <> 0 then t-ventame[13] = t-ventame[13] + 1.
      end.
      
end.              

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

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/
FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                 AND Gn-Divi.CodDiv BEGINS F-DIVISION:

FOR EACH EvtClie NO-LOCK WHERE EvtClie.CodCia = S-CODCIA
                         AND   EvtClie.CodDiv = Gn-Divi.Coddiv
                         AND   EvtClie.Codcli BEGINS F-clien
                         AND   lookup(Evtclie.codcli,"11111111111,11111111") = 0
                         AND   (EvtClie.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   EvtClie.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))),                          
                         EACH  gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                               gn-clie.Codcli = EvtClie.Codcli  AND 
                               GN-CLIE.CANAL begins f-canal     and
                               gn-clie.Flgsit = "A":
      /*
      DISPLAY EvtClie.Codcli + " " + STRING(EvtClie.CodAno,"9999") + STRING(EvtClie.CodMes,"99") @ Fi-Mensaje LABEL "Cliente"
              FORMAT "X(18)" WITH FRAME F-Proceso.
      */
      FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND
                           T-codcli  = EvtClie.Codcli
                           NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:

        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               T-Codcli  = EvtClie.Codcli .
               t-nomcli  = gn-clie.Nomcli.
               t-ruc     = gn-clie.ruc.
               t-clfcli  = gn-clie.clfcli.         
      
      END.
      ASSIGN      
      t-ventamn[codmes] = t-ventamn[codmes] +  IF ncodmon = 1 THEN  (EvtClie.VTAxMesMN / 1.18) ELSE  (EvtClie.VTAxMesMe / 1.18).
      t-ventamn[14]     = t-ventamn[14] + IF ncodmon = 1 THEN  (EvtClie.VTAxMesMN / 1.18) ELSE  (EvtClie.VTAxMesMe / 1.18).
      if EvtClie.VTAxMesMN <> 0 Then t-ventamn[13] = t-ventamn[13] + 1.
       
      
      
      
    END.
END.
/*
HIDE FRAME F-PROCESO.
*/
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
  DISPLAY F-DIVISION F-canal f-clien DesdeF HastaF nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-63 RECT-61 BUTTON-5 F-DIVISION BUTTON-8 F-canal f-clien DesdeF 
         HastaF nCodMon Btn_OK Btn_Cancel Btn_Help 
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
    ENABLE ALL .
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
        txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        RUN Reporte.
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
  ASSIGN F-Division 
         F-clien
         DesdeF 
         HastaF 
         nCodMon .
  
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
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
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
  RUN cARGA-ORDEN.
  
  DEFINE FRAME F-REPORTE
         t-clfcli       FORMAT "X(1)"  
         t-Codcli       FORMAT "X(11)"
         t-nomcli       FORMAT "X(25)"
         t-ventamn[ 1]  FORMAT "->,>>>,>>9" 
         t-ventamn[ 2]  FORMAT "->,>>>,>>9"
         t-ventamn[ 3]  FORMAT "->,>>>,>>9"
         t-ventamn[ 4]  FORMAT "->,>>>,>>9"
         t-ventamn[ 5]  FORMAT "->,>>>,>>9"
         t-ventamn[ 6]  FORMAT "->,>>>,>>9"
         t-ventamn[ 7]  FORMAT "->,>>>,>>9"
         t-ventamn[ 8]  FORMAT "->,>>>,>>9"
         t-ventamn[ 9]  FORMAT "->,>>>,>>9"
         t-ventamn[10]  FORMAT "->,>>>,>>9"
         t-ventamn[11]  FORMAT "->,>>>,>>9"
         t-ventamn[12]  FORMAT "->,>>>,>>9"
         t-ventamn[14]  FORMAT "->,>>>,>>9.99"
         w_resu         FORMAT "->,>>>,>>9.99" skip
          
         t-ventame[ 1]  AT 41 FORMAT "->,>>>,>>9"
         t-ventame[ 2]  FORMAT "->,>>>,>>9"
         t-ventame[ 3]  FORMAT "->,>>>,>>9"
         t-ventame[ 4]  FORMAT "->,>>>,>>9"
         t-ventame[ 5]  FORMAT "->,>>>,>>9"
         t-ventame[ 6]  FORMAT "->,>>>,>>9"
         t-ventame[ 7]  FORMAT "->,>>>,>>9"
         t-ventame[ 8]  FORMAT "->,>>>,>>9"
         t-ventame[ 9]  FORMAT "->,>>>,>>9"
         t-ventame[10]  FORMAT "->,>>>,>>9"
         t-ventame[11]  FORMAT "->,>>>,>>9"
         t-ventame[12]  FORMAT "->,>>>,>>9"
         w_acu          FORMAT "->,>>>,>>9.99"
         w_pdoc         FORMAT "->,>>>,>>9.99" SKIP
         
         t-pedidos[ 1]  AT 41 FORMAT "->,>>>,>>9"
         t-pedidos[ 2]  FORMAT "->,>>>,>>9"
         t-pedidos[ 3]  FORMAT "->,>>>,>>9"
         t-pedidos[ 4]  FORMAT "->,>>>,>>9"
         t-pedidos[ 5]  FORMAT "->,>>>,>>9"
         t-pedidos[ 6]  FORMAT "->,>>>,>>9"
         t-pedidos[ 7]  FORMAT "->,>>>,>>9"
         t-pedidos[ 8]  FORMAT "->,>>>,>>9"
         t-pedidos[ 9]  FORMAT "->,>>>,>>9"
         t-pedidos[10]  FORMAT "->,>>>,>>9"
         t-pedidos[11]  FORMAT "->,>>>,>>9"
         t-pedidos[12]  FORMAT "->,>>>,>>9"
         w_acup         FORMAT "->,>>>,>>9.99"
         w_pdocp        FORMAT "->,>>>,>>9.99" SKIP

 
  
        WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 150 FORMAT "X(10)" PAGE-NUMBER(REPORT) at 160 FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  : " TO 150 FORMAT "X(10)" TODAY TO 160 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   : " TO 150 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") TO 160   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "CANAL  : " + F-CANAL + " " + N-CANAL  FORMAT "X(50)" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Codigo    Nombre o Razon Social              Enero    Febrero      Marzo      Abril       Mayo      Junio      Julio     Agosto  Setiembre    Octubre  Noviembre  Diciembre         Total      Promedio " SKIP
        "                                            No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D     No.O/D                             " SKIP
        "                                            No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C     No.O/C                             " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  NO-LOCK
                     BREAK BY T-Codcia
                     BY T-CLFCLI
                     BY t-ventamn[14] DESCEN:
      w_resu = t-ventamn[14] / t-ventamn[13].
      w_acu  = ( t-ventame[1] + t-ventame[2] + t-ventame[3] + t-ventame[4] + t-ventame[5] + t-ventame[6] + t-ventame[7] + t-ventame[8] + t-ventame[9] + t-ventame[10] + t-ventame[11] + t-ventame[12]).
      w_pdoc = w_acu / t-ventame[13].
      
      w_acup  = ( t-pedidos[1] + t-pedidos[2] + t-pedidos[3] + t-pedidos[4] + t-pedidos[5] + t-pedidos[6] + t-pedidos[7] + t-pedidos[8] + t-pedidos[9] + t-pedidos[10] + t-pedidos[11] + t-pedidos[12]).
      w_pdocp = w_acup / t-pedidos[13].


      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUM  t-ventamn[14] ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-clfcli                
                t-Codcli
                t-nomcli
                t-ventamn[ 1] when t-ventamn[ 1] <> 0
                t-ventamn[ 2] when t-ventamn[ 2] <> 0
                t-ventamn[ 3] when t-ventamn[ 3] <> 0
                t-ventamn[ 4] when t-ventamn[ 4] <> 0
                t-ventamn[ 5] when t-ventamn[ 5] <> 0
                t-ventamn[ 6] when t-ventamn[ 6] <> 0
                t-ventamn[ 7] when t-ventamn[ 7] <> 0
                t-ventamn[ 8] when t-ventamn[ 8] <> 0
                t-ventamn[ 9] when t-ventamn[ 9] <> 0
                t-ventamn[10] when t-ventamn[10] <> 0
                t-ventamn[11] when t-ventamn[11] <> 0
                t-ventamn[12] when t-ventamn[12] <> 0
                T-ventamn[14] 
                w_resu 
                
                t-ventame[ 1] when t-ventamn[ 1] <> 0
                t-ventame[ 2] when t-ventamn[ 2] <> 0
                t-ventame[ 3] when t-ventamn[ 3] <> 0
                t-ventame[ 4] when t-ventamn[ 4] <> 0
                t-ventame[ 5] when t-ventamn[ 5] <> 0
                t-ventame[ 6] when t-ventamn[ 6] <> 0
                t-ventame[ 7] when t-ventamn[ 7] <> 0
                t-ventame[ 8] when t-ventamn[ 8] <> 0
                t-ventame[ 9] when t-ventamn[ 9] <> 0
                t-ventame[10] when t-ventamn[10] <> 0
                t-ventame[11] when t-ventamn[11] <> 0
                t-ventame[12] when t-ventamn[12] <> 0
                w_acu
                w_pdoc 
                
                t-pedidos[ 1] when t-pedidos[ 1] <> 0
                t-pedidos[ 2] when t-pedidos[ 2] <> 0
                t-pedidos[ 3] when t-pedidos[ 3] <> 0
                t-pedidos[ 4] when t-pedidos[ 4] <> 0
                t-pedidos[ 5] when t-pedidos[ 5] <> 0
                t-pedidos[ 6] when t-pedidos[ 6] <> 0
                t-pedidos[ 7] when t-pedidos[ 7] <> 0
                t-pedidos[ 8] when t-pedidos[ 8] <> 0
                t-pedidos[ 9] when t-pedidos[ 9] <> 0
                t-pedidos[10] when t-pedidos[10] <> 0
                t-pedidos[11] when t-pedidos[11] <> 0
                t-pedidos[12] when t-pedidos[12] <> 0
 

             
              WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      /*IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
        t-ventamn[14]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
           ("TOTAL VENTA SIN I.G.V.: " )            @ t-ventamn[10]
           (ACCUM TOTAL BY t-codcia t-ventamn[14])  @ t-ventamn[14]
            WITH FRAME F-REPORTE.
      END.*/
     

  END.
  /*
  HIDE FRAME F-PROCESO.
  */
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
IF F-DIVISION <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-DIVISION):
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

