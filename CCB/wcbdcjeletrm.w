&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
    MLR     27/Ago/2008 - Ref 000002
            Generación de asiento para Letras Canjeadas Aprobadas.

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
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov
    FIELD Tipo   AS CHAR
    FIELD fchvta AS DATE
    FIELD fchast LIKE cb-cmov.fchast.

DEFINE TEMP-TABLE tt-prev LIKE t-prev.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR x-tpocmb AS DECI NO-UNDO.
DEFINE VAR x-list   AS CHAR INITIAL '' NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE VARIABLE cCodOpe LIKE FacDocum.CodOpe NO-UNDO.
DEFINE VARIABLE lTpoDoc LIKE FacDocum.TpoDoc NO-UNDO.
DEFINE VARIABLE cCodCbd LIKE FacDocum.CodCbd NO-UNDO.
DEFINE VARIABLE cCodCta LIKE FacDocum.CodCta NO-UNDO.
DEFINE VARIABLE pTipo   LIKE cb-control.Tipo INIT "@REFLET" NO-UNDO.

/* REFINANCIACION */
FIND FacDocum WHERE
    FacDocum.CodCia = s-codcia AND
    FacDocum.CodDoc = 'REF' NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodOpe = "" THEN DO:
    MESSAGE
        'REFINANCIACION (REF) MALCONFIGURADO en el sistema'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
cCodOpe = FacDocum.CodOpe.

/* LETRA */
FIND FacDocum WHERE
    FacDocum.CodCia = s-codcia AND
    FacDocum.CodDoc = 'LET' NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodOpe = "" THEN DO:
    MESSAGE
        'LETRA (LET) MAL CONFIGURADA en el sistema'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
lTpoDoc = NOT FacDocum.TpoDoc.
cCodCbd = FacDocum.CodCbd.
cCodCta[1] = FacDocum.CodCta[1].    /* Cuenta Letra Soles */
cCodCta[2] = FacDocum.CodCta[2].    /* Cuenta Letra Dólares */
cCodCta[3] = "12211100".              /* Cuenta Letra Adelantada Soles */
cCodCta[4] = "12211110".              /* Cuenta Letra Adelantada Dólares */

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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes BUTTON-1 B-Pre_Asto ~
f-Division 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo FILL-IN-fchast-1 ~
FILL-IN-fchast-2 x-NroMes f-Division FILL-IN-Tpocmb FILL-IN-TcCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ccbcbd AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Pre_Asto 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 5" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Transferir 
     IMAGE-UP FILE "img\climnu1":U
     LABEL "Transferir Asiento" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Btn 1" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE f-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroMes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "9999":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TcCompra AS DECIMAL FORMAT ">>9.999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-Tpocmb AS DECIMAL FORMAT ">>9.999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 1.19 COL 9 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-fchast-1 AT ROW 1.96 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-fchast-2 AT ROW 1.96 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     x-NroMes AT ROW 2.15 COL 9 COLON-ALIGNED WIDGET-ID 18
     BUTTON-1 AT ROW 2.35 COL 80 WIDGET-ID 22
     B-Pre_Asto AT ROW 2.42 COL 64 WIDGET-ID 24
     B-Transferir AT ROW 2.42 COL 72.14 WIDGET-ID 26
     f-Division AT ROW 3.12 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Tpocmb AT ROW 3.38 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-TcCompra AT ROW 3.38 COL 42.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "T.C.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 32.57 WIDGET-ID 14
     "Fecha de Proceso" VIEW-AS TEXT
          SIZE 13.43 BY .5 AT ROW 1.38 COL 36 WIDGET-ID 12
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43 WIDGET-ID 30
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14 WIDGET-ID 34
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57 WIDGET-ID 36
     "T.C.Compra" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 44.72 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.57 BY 15.58
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIENTO POR REFINANCIACION DE LETRAS MENSUAL"
         HEIGHT             = 15.58
         WIDTH              = 92.57
         MAX-HEIGHT         = 15.58
         MAX-WIDTH          = 92.57
         VIRTUAL-HEIGHT     = 15.58
         VIRTUAL-WIDTH      = 92.57
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fchast-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fchast-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TcCompra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Tpocmb IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIENTO POR REFINANCIACION DE LETRAS MENSUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIENTO POR REFINANCIACION DE LETRAS MENSUAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Pre_Asto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Pre_Asto W-Win
ON CHOOSE OF B-Pre_Asto IN FRAME F-Main /* Button 5 */
DO:
    ASSIGN
        FILL-IN-fchast-1 FILL-IN-fchast-2 
        FILL-IN-Tpocmb FILL-IN-TcCompra 
        F-Division x-Periodo x-NroMes
        .

    FIND cb-peri WHERE
        cb-peri.CodCia = s-codcia AND
        cb-peri.Periodo = INTEGER(x-Periodo) NO-LOCK.
    IF AVAILABLE cb-peri THEN s-NroMesCie = cb-peri.MesCie[INTEGER(x-NroMes) + 1].
    IF s-NroMesCie THEN DO:
        MESSAGE "MES CERRADO!!!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
        cb-control.Coddiv  = f-Division AND
        cb-control.tipo    = pTipo AND
        cb-control.periodo  = INTEGER(x-Periodo)
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-control THEN DO:
        MESSAGE
            "Asiento contable ha sido generado" SKIP
            "¿Desea reprocesarlo?"
            VIEW-AS ALERT-BOX WARNING
            BUTTONS YES-NO UPDATE sigue AS LOGICAL.
        IF NOT sigue THEN RETURN NO-APPLY.
    END.
    
    RUN Carga-Temporal.

    IF CAN-FIND(FIRST t-prev) THEN DO:
        
        B-Transferir:SENSITIVE = YES.
    END.
    ELSE DO:
        
        B-Transferir:SENSITIVE = NO.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:
    FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                       cb-peri.Periodo = INTEGER(x-Periodo) NO-LOCK.
    IF AVAILABLE cb-peri THEN
       s-NroMesCie = cb-peri.MesCie[INTEGER(x-nromes) + 1].

    IF s-NroMesCie THEN DO:
       MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia 
        AND cb-control.Coddiv = F-DIVISION 
        AND cb-control.tipo   = pTipo
        AND cb-control.fchpro >= FILL-IN-fchast-1
        AND cb-control.fchpro <= FILL-IN-fchast-2 
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-control THEN DO:
        MESSAGE "Asientos contables del mes ya existen "  SKIP
            "        Desea reemplazarlos?          "
            VIEW-AS ALERT-BOX WARNING
            BUTTONS YES-NO UPDATE sigue AS LOGICAL.
        IF NOT sigue THEN RETURN NO-APPLY.
    END.

    IF NOT CAN-FIND(FIRST t-prev) THEN RETURN NO-APPLY.
    RUN Transferir-asiento.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Btn 1 */
DO:
    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    FIND FIRST t-Prev NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-Prev THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    pOptions = pOptions + CHR(1) + "SkipList:Llave".

    SESSION:SET-WAIT-STATE('GENERAL').
    SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-file (TEMP-TABLE t-Prev:HANDLE, pArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').


    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fchast-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fchast-1 W-Win
ON LEAVE OF FILL-IN-fchast-1 IN FRAME F-Main
DO:
  ASSIGN
     FILL-IN-fchast-1.
  FIND gn-tcmb WHERE gn-tcmb.fecha = FILL-IN-fchast-1 NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     FILL-IN-tpocmb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gn-tcmb.venta, '999.999').
     FILL-IN-TcCompra:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gn-tcmb.compra, '999.999').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroMes W-Win
ON VALUE-CHANGED OF x-NroMes IN FRAME F-Main /* Mes */
DO:
  ASSIGN {&SELF-NAME}.
  RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
  DISPLAY 
    FILL-IN-fchast-1 FILL-IN-fchast-2
    WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO FILL-IN-fchast-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Periodo W-Win
ON VALUE-CHANGED OF x-Periodo IN FRAME F-Main /* Periodo */
DO:
  ASSIGN {&SELF-NAME}.
  RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
  DISPLAY 
    FILL-IN-fchast-1 FILL-IN-fchast-2
    WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO FILL-IN-fchast-1.
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
             INPUT  'aplic/ccb/b-ccbcbd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ccbcbd ).
       RUN set-position IN h_b-ccbcbd ( 5.42 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-ccbcbd ( 10.77 , 90.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 14.65 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.69 , 45.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ccbcbd. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-ccbcbd ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ccbcbd ,
             FILL-IN-TcCompra:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-ccbcbd , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-asto W-Win 
PROCEDURE anula-asto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
    DEFINE INPUT PARAMETER p-periodo AS INTEGER.
    DEFINE INPUT PARAMETER p-mes     AS INTEGER.
    DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
    DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.

    DEFINE BUFFER C-DMOV FOR CB-DMOV.

    FOR EACH CB-DMOV WHERE
        CB-DMOV.codcia  = p-codcia AND
        CB-DMOV.periodo = p-periodo AND
        CB-DMOV.nromes  = p-mes AND
        CB-DMOV.codope  = p-codope AND
        CB-DMOV.nroast  = p-nroast:
        FOR EACH C-DMOV WHERE C-DMOV.RELACION = RECID(CB-DMOV) :
            RUN cbd/cb-acmd.p(RECID(C-DMOV),NO,YES).
            DELETE C-DMOV.
        END.
        RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
        DELETE CB-DMOV.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-temporal W-Win 
PROCEDURE anula-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
    DEFINE INPUT PARAMETER p-periodo AS INTEGER.
    DEFINE INPUT PARAMETER p-mes     AS INTEGER.
    DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
    DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.

    FOR EACH T-CB-DMOV WHERE
        T-CB-DMOV.codcia  = p-codcia AND
        T-CB-DMOV.periodo = p-periodo AND
        T-CB-DMOV.nromes  = p-mes AND
        T-CB-DMOV.codope  = p-codope AND
        T-CB-DMOV.nroast  = p-nroast:
        DELETE T-CB-DMOV.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ajuste W-Win 
PROCEDURE Carga-Ajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER param_tipo AS CHARACTER.

    DEFINE VARIABLE dCargo AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dAbono AS DECIMAL NO-UNDO.

    FOR EACH t-prev BREAK BY t-prev.fchast:
        IF FIRST-OF(t-prev.fchast) THEN DO:
            EMPTY TEMP-TABLE tt-prev.
            ASSIGN dAbono = 0 dCargo = 0.
        END.
        IF t-prev.tpomov THEN dCargo = dCargo + t-prev.impmn1.
        ELSE dAbono = dAbono + t-prev.impmn1.
        IF LAST-OF(t-prev.fchast) THEN DO:
            IF dCargo - dAbono <> 0 THEN DO:
                CREATE tt-prev.
                BUFFER-COPY t-prev TO tt-prev
                    ASSIGN
                    tt-prev.tipo    = param_tipo
                    tt-prev.codcta  = (IF dCargo - dAbono > 0 THEN x-ctagan ELSE x-ctaper)
                    tt-prev.fchdoc  = TODAY
                    tt-prev.tpomov  =(IF dCargo - dAbono > 0 THEN FALSE ELSE TRUE)
                    tt-prev.codmon  = 1
                    tt-prev.glodoc  = 'Ajuste por Dif.Cambio'
                    tt-prev.impmn1 = ABSOLUTE(dCargo - dAbono).
            END.
        END.
    END.
    FOR EACH tt-prev:
        CREATE t-prev.
        BUFFER-COPY tt-prev TO t-prev.
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

    DEFINE VARIABLE cNomCli LIKE ccbcdocu.nomcli NO-UNDO.
    DEFINE VARIABLE cCtaAux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodcbd AS CHARACTER NO-UNDO.

    DEFINE BUFFER b_dmvto FOR ccbdmvto.

    /* REFINANCIACION (REF) DE LETRAS (LET) */
    EMPTY TEMP-TABLE t-prev.
    FOR EACH B-cdocu NO-LOCK WHERE B-cdocu.codcia = s-codcia
        AND B-cdocu.coddiv = f-Division
        AND B-cdocu.coddoc = "LET"
        /*
        AND B-cdocu.fchdoc >= FILL-IN-fchast-1
        AND B-cdocu.fchdoc <= FILL-IN-fchast-2
        */
        AND B-cdocu.codref = "REF", 
        FIRST Ccbcmvto NO-LOCK WHERE Ccbcmvto.codcia = B-cdocu.codcia
            AND Ccbcmvto.coddiv = B-cdocu.coddiv
            AND Ccbcmvto.coddoc = B-cdocu.codref
            AND Ccbcmvto.nrodoc = B-cdocu.nroref
            AND Ccbcmvto.flgest = "E"
            AND Ccbcmvto.fchapr >= FILL-IN-fchast-1
            AND Ccbcmvto.fchapr <= FILL-IN-fchast-2
            BREAK BY B-cdocu.codref BY B-cdocu.nroref:
        cNomCli = B-CDocu.CodDoc + " " + B-cdocu.nomcli.
        /* Documento Origen (LET y/o N/D) */
        IF FIRST-OF(B-cdocu.codref) OR FIRST-OF(B-cdocu.nroref) THEN 
            FOR EACH b_dmvto NO-LOCK WHERE b_dmvto.CodCia = ccbcmvto.codcia 
                AND b_dmvto.CodDiv = ccbcmvto.coddiv
                AND b_dmvto.CodDoc = ccbcmvto.coddoc 
                AND b_dmvto.NroDoc = ccbcmvto.nrodoc 
                AND b_dmvto.TpoRef = "O",
                FIRST CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = b_dmvto.CodCia 
                AND CcbCDocu.CodDoc = b_dmvto.CodRef 
                AND CcbCDocu.NroDoc = b_dmvto.NroRef:
                FIND FacDocum WHERE FacDocum.CodCia = CcbCDocu.codcia 
                    AND FacDocum.CodDoc = CcbCDocu.CodDoc NO-LOCK NO-ERROR.
                IF NOT AVAILABLE FacDocum THEN NEXT.
                RUN Graba-Documento(FacDocum.Codcbd,
                                    (IF Ccbcdocu.codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2]),
                                    FacDocum.TpoDoc,
                                    b_dmvto.Imptot,
                                    B-CDOCU.FchDoc,
                                    pTipo).
            END.
        /* Letras */
        RUN Graba-Letra(
            B-cdocu.CodMon,
            B-cdocu.FchDoc,
            ccbcmvto.TpoCmb,
            cNomCli,
            Ccbcmvto.fchapr,    /*B-CDOCU.FchDoc,*/
            pTipo).
    END.

    IF CAN-FIND(FIRST t-prev) THEN RUN Carga-Ajuste(pTipo).

    RUN Abrir-Browse IN h_b-ccbcbd (INPUT SUBSTRING(ENTRY(1,x-list),1,3)).
    RUN Totales IN h_b-ccbcbd.

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
  DISPLAY x-Periodo FILL-IN-fchast-1 FILL-IN-fchast-2 x-NroMes f-Division 
          FILL-IN-Tpocmb FILL-IN-TcCompra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo x-NroMes BUTTON-1 B-Pre_Asto f-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Documento W-Win 
PROCEDURE Graba-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>                                                 C
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER param_codcbd  AS CHAR.
    DEFINE INPUT PARAMETER param_codcta  AS CHAR.
    DEFINE INPUT PARAMETER param_tpomov  AS LOGICAL.
    DEFINE INPUT PARAMETER param_importe AS DECIMAL.
    DEFINE INPUT PARAMETER PARAM_fchast  AS DATE.
    DEFINE INPUT PARAMETER param_tipo    AS CHARACTER.

    CREATE t-prev.
    ASSIGN
        t-prev.tipo    = param_tipo
        t-prev.periodo = INTEGER(x-Periodo)
        t-prev.nromes  = INTEGER(x-NroMes)
        t-prev.fchast  = param_fchast
        t-prev.codope  = cCodOpe
        t-prev.coddiv  = f-Division
        t-prev.codcta  = param_codcta
        t-prev.fchdoc  = Ccbcdocu.Fchdoc
        t-prev.tpomov  = param_tpomov
        t-prev.clfaux  = '@CL'
        t-prev.codaux  = Ccbcdocu.CodCli
        t-prev.codmon  = Ccbcdocu.codmon
        t-prev.coddoc  = param_CodCbd
        t-prev.nrodoc  = Ccbcdocu.Nrodoc
        t-prev.Tpocmb  = Ccbcdocu.TpoCmb
        t-prev.glodoc  = Ccbcdocu.Nomcli.

    IF ccbcdocu.CodMon = 1 THEN
        ASSIGN t-prev.impmn1 = t-prev.impmn1 + param_importe.
    ELSE
        ASSIGN
            t-prev.impmn2 = t-prev.impmn2 + param_importe
            t-prev.impmn1 = t-prev.impmn1 + ROUND((param_importe * t-prev.Tpocmb),2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Letra W-Win 
PROCEDURE Graba-Letra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER param_codmon LIKE ccbcmvto.CodMon.
    DEFINE INPUT PARAMETER param_fchdoc LIKE ccbcmvto.FchDoc.
    DEFINE INPUT PARAMETER param_TpoCmb LIKE ccbcmvto.TpoCmb.
    DEFINE INPUT PARAMETER param_NomCli LIKE ccbcdocu.NomCli.
    DEFINE INPUT PARAMETER PARAM_FchAst AS DATE.
    DEFINE INPUT PARAMETER param_tipo AS CHARACTER.

    FIND t-prev WHERE t-prev.coddiv = ccbcmvto.Coddiv 
        AND t-prev.coddoc = cCodCbd 
        AND t-prev.nrodoc = ccbcmvto.Nrodoc 
        AND t-prev.codcta = cCodCta[param_CodMon] 
        AND t-prev.tpomov = lTpoDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-prev THEN DO:
        CREATE t-prev.
        ASSIGN
            t-prev.tipo    = param_tipo
            t-prev.fchast  = PARAM_fchast
            t-prev.periodo = INTEGER(x-Periodo)
            t-prev.nromes  = INTEGER(x-NroMes)
            t-prev.codope  = cCodOpe
            t-prev.coddiv  = ccbcmvto.CodDiv 
            t-prev.codcta  = cCodCta[param_CodMon]
            t-prev.fchdoc  = param_Fchdoc
            t-prev.Fchvta  = B-cdocu.FchVto
            t-prev.tpomov  = lTpoDoc
            t-prev.clfaux  = '@CL'
            t-prev.codaux  = ccbcmvto.CodCli
            t-prev.codmon  = param_CodMon
            t-prev.coddoc  = cCodCbd
            t-prev.nrodoc  = B-cdocu.nrodoc
            t-prev.Tpocmb  = param_TpoCmb
            t-prev.glodoc  = param_NomCli.
    END.
    IF param_CodMon = 1 THEN ASSIGN t-prev.impmn1 = t-prev.impmn1 + B-cdocu.Imptot.
    ELSE ASSIGN
            t-prev.impmn2 = t-prev.impmn2 + B-cdocu.Imptot
            t-prev.impmn1 = t-prev.impmn1 + ROUND((B-cdocu.Imptot * t-prev.Tpocmb),2).

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
  x-NroMes  = STRING(MONTH(TODAY), '99').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    FIND cb-cfgg WHERE
        cb-cfgg.CodCia = cb-codcia AND
        cb-cfgg.Codcfg = 'C01' NO-LOCK NO-ERROR.
    IF AVAILABLE cb-Cfgg THEN
        ASSIGN
            x-ctagan = cb-cfgg.codcta[1]
            x-ctaper = cb-cfgg.codcta[2].
    ELSE DO:
        MESSAGE
            'Configuración de Cuentas de Ganancia/Pérdida no existe'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia  NO-LOCK NO-ERROR.
    RUN dispatch IN h_p-updv10 ('hide':U).

  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Cb-Peri NO-LOCK WHERE Cb-peri.codcia = s-codcia:
        x-Periodo:ADD-LAST(STRING(Cb-peri.periodo)).
    END.
    x-Periodo = STRING(YEAR(TODAY), '9999').
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        f-Division:ADD-LAST(Gn-divi.coddiv).
    END.
    F-DIVISION = S-CODDIV.
    RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
    DISPLAY 
        F-DIVISION
        x-Periodo
        FILL-IN-fchast-1 FILL-IN-fchast-2.
    APPLY 'LEAVE':U TO FILL-IN-fchast-1.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-impresion W-Win 
PROCEDURE Pre-impresion :
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
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT CONTROL {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
        RUN Imprimir.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferir-asiento W-Win 
PROCEDURE Transferir-asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR p-codope  AS CHAR NO-UNDO.
DEFINE VAR p-nroast  AS CHAR NO-UNDO.
DEFINE VAR x-nroast  AS INTE NO-UNDO.
DEFINE VAR d-uno     AS DECI NO-UNDO.
DEFINE VAR d-dos     AS DECI NO-UNDO.
DEFINE VAR h-uno     AS DECI NO-UNDO.
DEFINE VAR h-dos     AS DECI NO-UNDO.
DEFINE VAR x-clfaux  AS CHAR NO-UNDO.
DEFINE VAR I         AS INTE NO-UNDO.
DEFINE VAR J         AS INTE NO-UNDO.
DEFINE VAR x-coddoc  AS LOGI NO-UNDO.

DEFINE BUFFER detalle FOR CB-DMOV.

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
    BELL.
    MESSAGE
        "No se ha generado" SKIP
        "ningún preasiento"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
    BELL.
    MESSAGE
        "Plan de cuentas no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* BORRAMOS CUALQUIER ASIENTO QUE HAYA EXISTIDO ANTES */
FOR EACH cb-control NO-LOCK WHERE cb-control.CodCia = s-codcia 
    AND cb-control.Coddiv = f-Division 
    AND cb-control.tipo   = pTipo 
    AND cb-control.periodo = INTEGER(x-Periodo) 
    AND cb-control.nromes = INTEGER(x-NroMes):
    FIND cb-cmov WHERE cb-cmov.codcia  = cb-control.codcia
        AND cb-cmov.periodo = cb-control.periodo
        AND cb-cmov.nromes  = cb-control.nromes 
        AND cb-cmov.codope  = cb-control.codope 
        AND cb-cmov.nroast  = cb-control.nroast 
        NO-ERROR.
    IF AVAILABLE cb-cmov THEN
        RUN anula-asto(
            cb-cmov.codcia,
            cb-cmov.periodo,
            cb-cmov.nromes,
            cb-cmov.codope,
            cb-cmov.nroast).
    /* Elimina la información del temporal */
    RUN anula-temporal(
        s-codcia,
        INTEGER(x-Periodo),
        INTEGER(x-NroMes),
        cb-control.codope,
        cb-control.nroast ).
END.
/* CREAMOS/ACTUALIZAMOS ASIENTOS */
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.fchast:
    IF FIRST-OF(t-prev.tipo) OR FIRST(t-prev.fchast) THEN DO:
        /* Verifica si el movimiento se realizó anteriormente */
        FIND cb-control WHERE cb-control.CodCia  = s-codcia 
            AND cb-control.Coddiv  = f-Division 
            AND cb-control.tipo    = pTipo 
            AND cb-control.fchpro  = t-prev.fchast 
            AND cb-control.periodo = INTEGER(x-Periodo) 
            AND cb-control.nromes = INTEGER(x-NroMes)
            NO-ERROR.
        IF AVAILABLE cb-control THEN 
            ASSIGN
                p-Codope = cb-control.Codope 
                p-nroast = cb-control.Nroast.
        ELSE DO:
            p-codope = t-prev.codope.
            RUN cbd/cbdnast.p(
                cb-codcia,
                s-codcia,
                INTEGER(x-Periodo),
                INTEGER(x-NroMes),
                p-codope,
                OUTPUT x-nroast).
            p-nroast = STRING(x-nroast, '999999').
            CREATE cb-control.
            ASSIGN
                cb-control.CodCia  = s-codcia
                cb-control.Coddiv  = f-Division
                cb-control.tipo    = pTipo
                cb-control.Periodo = INTEGER(x-Periodo)
                cb-control.Nromes  = INTEGER(x-NroMes)
                cb-control.Codope  = p-Codope
                cb-control.Nroast  = p-nroast.
        END.
        ASSIGN
            cb-control.Usuario = s-user-id
            cb-control.Hora    = STRING(TIME,'HH:MM:SS')
            cb-control.fecha   = TODAY.
        d-uno = 0.
        d-dos = 0.
        h-uno = 0.
        h-dos = 0.
    END.
    FIND cb-ctas WHERE
        cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    x-clfaux = cb-ctas.clfaux.
    x-coddoc = cb-ctas.piddoc.
    IF t-prev.impmn1 > 0 OR t-prev.impmn2 > 0 THEN DO:
        J = J + 1.
        CREATE CB-DMOV.
        CB-DMOV.codcia  = s-codcia.
        CB-DMOV.PERIODO = INTEGER(x-Periodo).
        CB-DMOV.NROMES  = INTEGER(x-NroMes).
        CB-DMOV.CODOPE  = p-codope.
        CB-DMOV.NROAST  = p-nroast.
        CB-DMOV.NROITM  = J.
        CB-DMOV.codcta  = t-prev.codcta.
        CB-DMOV.coddiv  = t-prev.coddiv.
        Cb-dmov.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        Cb-dmov.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        CB-DMOV.GLODOC  = t-prev.glodoc.
        CB-DMOV.tpomov  = t-prev.tpomov.
        CB-DMOV.impmn1  = t-prev.impmn1.
        CB-DMOV.impmn2  = t-prev.impmn2.
        CB-DMOV.FCHDOC  = t-prev.fchdoc.
        CB-DMOV.FCHVTO  = t-prev.fchvta.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = t-prev.codmon.
        CB-DMOV.tpocmb  = t-prev.tpocmb.
        RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
        IF CB-DMOV.tpomov THEN DO:
            h-uno = h-uno + CB-DMOV.impmn1.
            h-dos = h-dos + CB-DMOV.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.
    END.
    IF LAST(t-prev.tipo) OR LAST-OF(t-prev.fchast) THEN DO:
        FIND cb-cmov WHERE
            cb-cmov.codcia  = s-codcia AND
            cb-cmov.PERIODO = INTEGER(x-Periodo) AND
            cb-cmov.NROMES  = INTEGER(x-NroMes) AND
            cb-cmov.CODOPE  = p-codope AND
            cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
            CREATE cb-cmov.
            cb-cmov.codcia  = s-codcia.
            cb-cmov.PERIODO = INTEGER(x-Periodo).
            cb-cmov.NROMES  = INTEGER(x-NroMes).
            cb-cmov.CODOPE  = p-codope.
            cb-cmov.NROAST  = p-nroast. 
        END.
        cb-cmov.Coddiv = t-prev.coddiv.
        cb-cmov.Fchast = t-prev.fchast.
        cb-cmov.TOTITM = J.
        cb-cmov.CODMON = 1.
        cb-cmov.TPOCMB = t-prev.Tpocmb.
        cb-cmov.DBEMN1 = d-uno.
        cb-cmov.DBEMN2 = d-dos.
        cb-cmov.HBEMN1 = h-uno.
        cb-cmov.HBEMN2 = h-dos.
        cb-cmov.NOTAST = t-prev.glodoc.
        cb-cmov.GLOAST = t-prev.glodoc.
    END.
END.
/*RUN Actualiza-Flag.*/

MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

