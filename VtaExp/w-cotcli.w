&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE CLIE LIKE gn-clie.



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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */
/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
/* DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0. */
/* DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0. */
/* DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0. */
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE TEMP-TABLE Tmp-CLIE
    FIELD tmp-codcli  LIKE FacCpedi.Codcli. 
DEFINE TEMP-TABLE   tmp-tempo
    FIELD t-codpro  LIKE Almmmatg.Codpr1
    FIELD t-nompro  LIKE Gn-Prov.Nompro 
    FIELD t-codalm  LIKE FacCpedi.Codalm
    FIELD t-codcli  LIKE FacCpedi.Codcli
    FIELD t-nomcli  LIKE FacCpedi.Nomcli
    FIELD t-codmat  LIKE FacDpedi.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-glosa   AS CHAR          FORMAT "X(30)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-compro  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-solici  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-atendi  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-pendie  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-totsol  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-totdol  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-codfam  LIKE Almmmatg.codfam
    INDEX Llave01   AS PRIMARY t-CodMat
    INDEX Llave02   t-CodCli t-CodMat
    INDEX Llave03   t-DesMar
    Index Llave04   t-CodPro.

DEF BUFFER B-FacCPedi FOR FacCPedi.
DEF BUFFER B-Almmmatg FOR Almmmatg.

DEF VAR chtpodocu AS CHARACTER NO-UNDO.
DEF VAR x-fentdesde AS DATE NO-UNDO.
DEF VAR x-fenthasta AS DATE NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-41 Btn_OK f-desde f-hasta ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 F-entrega1 F-entrega2 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS f-desde f-hasta FILL-IN-FchPed-1 ~
FILL-IN-FchPed-2 F-entrega1 F-entrega2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cliente AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Cotizaciones Emitidas Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-entrega1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Con Cotizaciones a Entregar Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-entrega2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Con Pedidos Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 2.35 COL 60 WIDGET-ID 10
     f-desde AT ROW 2.62 COL 26 COLON-ALIGNED WIDGET-ID 12
     f-hasta AT ROW 2.62 COL 44 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-FchPed-1 AT ROW 3.42 COL 26 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-FchPed-2 AT ROW 3.42 COL 44 COLON-ALIGNED WIDGET-ID 22
     F-entrega1 AT ROW 4.23 COL 26 COLON-ALIGNED WIDGET-ID 14
     F-entrega2 AT ROW 4.23 COL 44 COLON-ALIGNED WIDGET-ID 16
     Btn_Cancel AT ROW 4.23 COL 60 WIDGET-ID 8
     "Rango de Fechas" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 1.27 COL 3
          FONT 6
     RECT-41 AT ROW 2.08 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 20
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CLIE T "NEW SHARED" ? INTEGRAL gn-clie
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Pedido Pendiente Por Atender"
         HEIGHT             = 12.46
         WIDTH              = 71.86
         MAX-HEIGHT         = 27.73
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.73
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Pedido Pendiente Por Atender */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Pedido Pendiente Por Atender */
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
  ASSIGN f-Desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 F-entrega1 F-entrega2.

  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 
  IF F-entrega1 = ? THEN ASSIGN x-fentdesde = 01/01/2000. ELSE ASSIGN x-fentdesde = F-entrega1.
  IF F-entrega2 = ? THEN ASSIGN x-fenthasta = 12/31/3000. ELSE ASSIGN x-fenthasta = F-entrega2.
  
  RUN Imprime.            
  
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtaexp/b-cliente.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cliente ).
       RUN set-position IN h_b-cliente ( 6.12 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cliente ( 7.00 , 55.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 6.12 , 60.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.04 , 12.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cliente. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-cliente ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cliente ,
             Btn_Cancel:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-cliente , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
  DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
  DEFINE VAR x-StkCom    AS DECIMAL INIT 0.

  FOR EACH TMP-TEMPO:
     DELETE tmp-tempo.
  END.
  
  INICIO:
FOR EACH Clie NO-LOCK WHERE Clie.CodCia = CL-CODCIA,
    EACH FacCpedi NO-LOCK WHERE
        FacCpedi.CodCia = S-CODCIA AND
        FacCpedi.CodDiv = S-CODDIV AND
        FacCpedi.CodDoc = "COT"    AND
        FacCpedi.FlgEst = "P"      AND
        FacCpedi.Codcli BEGINS Clie.CodCli AND
        FacCpedi.FchPed >= F-desde AND
        FacCpedi.FchPed <= F-hasta: 
        /* Filtro por Fecha de Entrega */
        IF f-Entrega1 <> ? AND FacCpedi.FchEnt < f-Entrega1 THEN NEXT INICIO.
        IF f-Entrega2 <> ? AND FacCpedi.FchEnt > f-Entrega2 THEN NEXT INICIO.
        
        /*AND 
        FacCpedi.FchEnt >= x-fentdesde AND
        FacCPedi.FchEnt <= x-fenthasta
        EACH FacDpedi OF FacCpedi NO-LOCK:,*/
       
   /* IF CANPED - CANATE <= 0 THEN NEXT.*/
        
    /* Filtro por fecha de pedido */
    IF FILL-IN-FchPed-1 <> ? OR FILL-IN-FchPed-2 <> ?
    THEN DO:
        FIND FIRST B-FacCPedi WHERE B-FacCPedi.CodCia = s-CodCia
            AND B-FacCPedi.CodDiv = s-CodDiv
            AND B-FacCPedi.CodDoc = 'PED'
            AND B-FacCPedi.FlgEst <> 'A'
            AND B-FacCPedi.FchPed >= FILL-IN-FchPed-1
            AND B-FacCPedi.FchPed <= FILL-IN-FchPed-2
            AND B-FacCPedi.NroRef = FacCPedi.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacCPedi THEN NEXT INICIO.
    END.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.canped - Facdpedi.canate > 0:
    FIND FIRST B-Almmmatg WHERE B-Almmmatg.CodCia = S-CODCIA 
        AND B-Almmmatg.CodmAT = FacDpedi.CodMat
        NO-LOCK NO-ERROR. 
    FIND FIRST Almtconv WHERE Almtconv.CodUnid  = B-Almmmatg.UndBas 
        AND Almtconv.Codalter = FacDpedi.UndVta
        NO-LOCK NO-ERROR.
    F-FACTOR  = 1. 
    IF NOT AVAILABLE B-Almmmatg THEN RETURN "ADM-ERROR".
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF B-Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / B-Almmmatg.FacEqu.
    END.
      
      FIND Tmp-Tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
                           Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         CREATE Tmp-Tempo.
         ASSIGN   Tmp-Tempo.t-CodAlm = Faccpedi.CodAlm
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = B-Almmmatg.DesMat
                  Tmp-Tempo.t-DesMar = B-Almmmatg.DesMar
                  Tmp-Tempo.t-UndBas = B-Almmmatg.UndBas.
      END.  
         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
  END.
END.
  FOR EACH Tmp-Tempo NO-LOCK:
    /* STOCK COMPROMETIDO */
    x-StkCom = 0.
    RUN Stock-Comprometido (Tmp-Tempo.t-CodMat, OUTPUT x-StkCom).
    /* ****************** */
    ASSIGN
        Tmp-Tempo.t-Compro = x-StkCom.
  END.
END PROCEDURE.

/*DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  

FOR EACH TMP-TEMPO:
 delete tmp-tempo.
end.


FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "PED"    AND
          FacCpedi.FlgEst = "P"      AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien ,
   EACH FacDpedi OF FacCpedi  :
          
    


     IF CANPED - CANATE = 0 THEN NEXT.
     
     FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                         Almmmatg.CodmAT = FacDpedi.CodMat
                         NO-LOCK NO-ERROR. 

     /*FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmatg.CodmAT = FacDpedi.CodMat
                         NO-LOCK NO-ERROR. */

     
     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                         Almtconv.Codalter = FacDpedi.UndVta
                         NO-LOCK NO-ERROR.
  
      F-FACTOR  = 1. 
          
      IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
      END.
      
      FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
                           Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         CREATE Tmp-Tempo.  /*Faccpedi.CodAlm*/
         ASSIGN   Tmp-Tempo.t-CodAlm = cbo-almd
                  Tmp-Tempo.t-CodAlm1 = cbo-almt  
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                  Tmp-Tempo.t-UndBas = Almmmatg.UndBas. 

       END.  
/*         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.*/
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
/*         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.*/
         /*Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.*/
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).

 END.
 FOR EACH Tmp-Tempo:
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     
     IF AVAILABLE Almmmate THEN DO:
        IF Almmmate.stkact >= tmp-tempo.t-solici THEN Tmp-Tempo.t-pendie = 0.
        IF Almmmate.stkact = tmp-tempo.t-solici THEN Tmp-Tempo.t-pendie = 0.
        IF Almmmate.stkact < tmp-tempo.t-solici THEN Tmp-Tempo.t-pendie = (tmp-tempo.t-solici - Almmmate.stkact).
       
     End.
END.*/

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
  DISPLAY f-desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 F-entrega1 
          F-entrega2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-41 Btn_OK f-desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 
         F-entrega1 F-entrega2 Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato W-Win 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL .   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(20)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>>,>>9.99"
        tmp-tempo.t-compro FORMAT "->>>,>>>,>>9.99"
        tmp-tempo.t-solici FORMAT ">>>,>>>,>>9.99"
        tmp-tempo.t-atendi FORMAT ">>>,>>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>>,>>9.99"
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 DEFINE FRAME H-REP
        HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Emitidas Desde : " AT 50 FORMAT "X(20)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)" SKIP
        "Pedidos  Desde : "  AT 50 FORMAT "X(20)" STRING(FILL-IN-FchPed-1,"99/99/9999") FORMAT "X(10)" "Al" STRING(FILL-IN-FchPed-2,"99/99/9999") FORMAT "X(12)" SKIP
        "Entrega  Desde : "  AT 50 FORMAT "X(20)" STRING(F-entrega1,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-entrega2,"99/99/9999") FORMAT "X(12)" SKIP
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                             C    A    N    T    I    D    A    D      " SKIP
        " Codigos      Descripcion              Marca          Pedidos                  U.M.    Stock Comprometido Solicitado Atendido Pendiente" 
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP        
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

VIEW STREAM REPORT FRAME H-REP.

FOR EACH tmp-tempo BREAK
        BY tmp-tempo.t-Codcli
        BY tmp-tempo.t-codmat:  

        
        /* VIEW STREAM REPORT FRAME H-REP.*/
         DISPLAY STREAM REPORT WITH FRAME F-CAB.

     IF FIRST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT "CLIENTE  : "  tmp-tempo.t-Codcli  "  " tmp-tempo.t-NomCli SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.
         
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND           
          Almmmate.CodAlm = tmp-tempo.t-CodAlm      AND      
          Almmmate.CodmAT = tmp-tempo.t-CodMat           
          NO-LOCK NO-ERROR.                              
     X-STOCK = 0.
     If AVAILABLE almmmate THEN X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codcli) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codcli) .                     
            
     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-compro
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie
        WITH FRAME F-Cab.
 
     IF LAST-OF(tmp-tempo.t-Codcli) THEN DO:
        PUT STREAM REPORT ' ' SKIP.
        PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
        PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totsol) FORMAT ">>>,>>>,>>>,>>>,>99.99" AT 60 .
        PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
        PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totdol) FORMAT ">>>,>>>,>>>,>>>,>99.99" AT 110  SKIP.

     END. 
 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime W-Win 
PROCEDURE imprime :
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
assign
    f-desde = today
    f-hasta = today.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
DO WITH FRAME {&FRAME-NAME}:
    /*FOR EACH almacen NO-LOCK by codalm desc:
        cbo-almd:add-first(almacen.codalm).
    END.
    FOR EACH almacen NO-LOCK by codalm desc:
        cbo-almt:add-first(almacen.codalm).
    END.*/
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Stock-Comprometido W-Win 
PROCEDURE Stock-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER s-CodMat AS CHAR.
  DEF OUTPUT PARAMETER x-CanPed AS DEC.

  DEF VAR x-PedCon AS DEC INIT 0 NO-UNDO.
  
        /****/
        FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia 
                           AND  FacDPedi.almdes = s-codalm
                           AND  FacDPedi.codmat = s-codmat 
                           AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                           AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
            FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                             AND  FacCPedi.CodAlm = FacDPedi.almdes
                                             AND  Faccpedi.FlgEst = "P"
                                             AND  Faccpedi.TpoPed = "1"
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL Faccpedi THEN NEXT.
        
            X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
        END.
        
        /*********   Barremos las O/D que son parciales y totales    ****************/
        FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia
                           AND  FacDPedi.almdes = s-codalm
                           AND  FacDPedi.codmat = s-codmat 
                           AND  LOOKUP(FacDPedi.CodDoc,'O/D') > 0 
                           AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
            FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                             AND  FacCPedi.CodAlm = s-codalm 
                                             AND  Faccpedi.FlgEst = "P"
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL FacCPedi THEN NEXT.
            X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
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
                           AND  Facdpedm.AlmDes = S-CODALM
                           AND  Facdpedm.codmat = s-codmat 
                           AND  Facdpedm.FlgEst = "P" :
            FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                             AND  Faccpedm.CodAlm = s-codalm 
                                             AND  Faccpedm.FlgEst = "P"  
                                            NO-LOCK NO-ERROR. 
            IF NOT AVAIL Faccpedm THEN NEXT.
            
            TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
            TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
                      (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
            IF TimeOut > 0 THEN DO:
                IF TimeNow <= TimeOut   /* Dentro de la valides */
                THEN DO:
                    /* cantidad en reservacion */
                    X-CanPed = X-CanPed + FacDPedm.Factor * FacDPedm.CanPed.
                END.
            END.
        END.
        X-PedCon = X-CanPed.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

