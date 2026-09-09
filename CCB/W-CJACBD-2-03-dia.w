&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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

    Modificó    Fecha       Objetivo
    --------    ----------- --------------------------------------------
    MLR-1       10/Set/2008 Guarda Codgigo y Referencia de Ingreso a Caja.

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
DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddiv  AS CHAR.
DEFINE SHARED VAR cb-codcia AS INT.

DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .
DEFINE NEW SHARED VARIABLE S-TIPO      AS CHAR INITIAL "@CJM69".  /* CAJA MENSUAL */

DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR x-codope  AS CHAR NO-UNDO.
DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.
DEFINE VAR x-tcajus  AS DECI NO-UNDO.
DEFINE VAR x-tvajus  AS DECI NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov
    FIELD Tipo   AS CHAR
    FIELD fchvta AS DATE
    FIELD fchast LIKE cb-cmov.fchast.
DEFINE TEMP-TABLE T-PREV-2 LIKE T-PREV.

/*
DEFINE NEW SHARED TEMP-TABLE t-prev
    FIELD Tipo    AS CHAR
    FIELD Banco   LIKE cb-dmov.CodBco
    FIELD Periodo LIKE cb-dmov.periodo
    FIELD NroMes LIKE cb-dmov.nromes
    FIELD Codope LIKE cb-dmov.codope
    FIELD Codcta LIKE cb-dmov.codcta
    FIELD CodDiv LIKE cb-dmov.coddiv
    FIELD Codmon LIKE cb-dmov.codmon
    FIELD Fchdoc LIKE cb-dmov.fchdoc
    FIELD Fchvto LIKE cb-dmov.fchvto
    FIELD Coddoc LIKE cb-dmov.coddoc
    FIELD Nrodoc LIKE cb-dmov.nrodoc
/*MLR-1*/ FIELD Codref LIKE cb-dmov.codref
    FIELD Nroref LIKE cb-dmov.nroref
    FIELD Glodoc LIKE cb-dmov.glodoc
    FIELD Tpocmb LIKE cb-dmov.tpocmb
    FIELD TpoMov LIKE cb-dmov.tpomov
    FIELD ImpMn1 LIKE cb-dmov.impmn1 
    FIELD ImpMn2 LIKE cb-dmov.impmn2
    FIELD clfaux LIKE cb-dmov.Clfaux
    FIELD codaux LIKE cb-dmov.Codaux
    INDEX IDX01 Tipo.
*/
DEFINE BUFFER B-prev  FOR t-prev.
DEFINE BUFFER B-Docum FOR FacDocum.
DEFINE NEW SHARED TEMP-TABLE t2-prev LIKE t-prev.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR x-tpocmb AS DECI NO-UNDO.
DEFINE VAR x-codcta  AS CHAR    NO-UNDO.

DEFINE VAR x-tpomov  AS LOGICAL NO-UNDO.
DEFINE VAR x-codcbd  AS CHAR    NO-UNDO.
DEFINE VAR x-glodoc  AS CHAR    NO-UNDO.
DEFINE VAR x-resumen AS LOGICAL NO-UNDO.
x-resumen = FALSE.

DEFINE VARIABLE x-ctalet LIKE FacDocum.CodCta NO-UNDO.

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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

    DEF VAR x-CodDiv AS CHAR NO-UNDO.       
    DEFINE VAR x-fchvto AS DATE NO-UNDO.
    DEFINE VAR x-codaux AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes B-pre-asto BUTTON-1 ~
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
DEFINE VARIABLE h_b-cjacbd-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-pre-asto 
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
     B-pre-asto AT ROW 2.15 COL 64
     BUTTON-1 AT ROW 2.15 COL 72 WIDGET-ID 22
     B-Transferir AT ROW 2.15 COL 79
     f-Division AT ROW 3.12 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Tpocmb AT ROW 3.38 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-TcCompra AT ROW 3.38 COL 42.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "T.C.Compra" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 44.72 WIDGET-ID 16
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 3.73 COL 79.43
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .5 AT ROW 3.88 COL 63.43
     "CIERRE  DE  CAJA" VIEW-AS TEXT
          SIZE 17.43 BY .85 AT ROW 1.19 COL 68
          FONT 6
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.27 COL 80
     "Fecha de Proceso" VIEW-AS TEXT
          SIZE 13.43 BY .5 AT ROW 1.38 COL 36 WIDGET-ID 12
     "T.C.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 32.57 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.14 BY 13.42
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
         TITLE              = "Generación de Asiento Contable"
         HEIGHT             = 13.42
         WIDTH              = 92.57
         MAX-HEIGHT         = 13.42
         MAX-WIDTH          = 92.57
         VIRTUAL-HEIGHT     = 13.42
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
ON END-ERROR OF W-Win /* Generación de Asiento Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generación de Asiento Contable */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-pre-asto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-pre-asto W-Win
ON CHOOSE OF B-pre-asto IN FRAME F-Main /* Button 5 */
DO:

    ASSIGN
       FILL-IN-fchast-1 FILL-IN-fchast-2 
       FILL-IN-Tpocmb FILL-IN-TcCompra 
       F-Division x-Periodo x-NroMes.

    IF FILL-IN-tpocmb = 0 THEN DO:
       MESSAGE 'Tipo de cambio no registrado' VIEW-AS ALERT-BOX.
       APPLY "ENTRY" TO FILL-IN-tpocmb.
    END.

    FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
        cb-peri.Periodo = YEAR(FILL-IN-fchast-1) NO-LOCK.
    IF AVAILABLE cb-peri THEN s-NroMesCie = cb-peri.MesCie[MONTH(FILL-IN-fchast-1) + 1].

    IF s-NroMesCie THEN DO:
       MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX WARNING.
    END.

    RUN proc_Carga-Temp.
    IF RETURN-VALUE = "ERROR" THEN RETURN NO-APPLY.

    FIND FIRST t-prev NO-LOCK NO-ERROR.
    IF AVAILABLE t-prev THEN DO:
        B-Transferir:SENSITIVE = YES.
        RUN dispatch IN h_p-updv10 ('view':U).
    END.
    ELSE RUN dispatch IN h_p-updv10 ('hide':U).

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
      AND cb-control.tipo   = s-Tipo
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

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Transferir-asiento.
  SESSION:SET-WAIT-STATE('').
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
  p-periodo = YEAR(FILL-IN-fchast-1).
  p-mes     = MONTH(FILL-IN-fchast-1).
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
             INPUT  'ccb/b-cjacbd-2-03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjacbd-01 ).
       RUN set-position IN h_b-cjacbd-01 ( 4.85 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cjacbd-01 ( 9.27 , 91.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 12.15 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.69 , 45.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cjacbd-01. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-cjacbd-01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cjacbd-01 ,
             FILL-IN-TcCompra:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-cjacbd-01 , 'AFTER':U ).
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
  ENABLE x-Periodo x-NroMes B-pre-asto BUTTON-1 f-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-BD W-Win 
PROCEDURE Graba-BD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER x-coddiv AS CHAR.
DEFINE INPUT PARAMETER x-codmon AS INTEGER.
DEFINE INPUT PARAMETER x-import AS DECIMAL.
DEFINE INPUT PARAMETER x-clfaux AS CHAR.
DEFINE INPUT PARAMETER x-codref AS CHAR.
DEFINE INPUT PARAMETER x-nrodoc AS CHAR.
DEFINE INPUT PARAMETER x-fchvto AS DATE.
DEFINE INPUT PARAMETER x-tpocmb AS DECIMAL.

DEFINE VAR x-detalle AS LOGICAL NO-UNDO.
DEFINE VAR x-codaux AS CHAR.
DEFINE VAR x-signo  AS DECI.

x-signo = 1.

FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
    CcbCDocu.CodDoc = x-CodRef AND 
    CcbCDocu.NroDoc = x-nrodoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbCDocu THEN DO:
   RETURN.
END.   
IF CcbCdocu.FlgEst = "A" THEN RETURN.

/* RHC 03.09.04 TOMAMOS LA DIVISION DEL DOCUMENTO ORIGEN PARA MATAR SALDOS */
x-CodDiv = CCBCDOCU.CodDiv.
/* ***************************************************** */
IF CcbCdocu.CodMon = 2 THEN DO: 
   FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCdocu.FchDoc
                      NO-LOCK NO-ERROR.
   IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.                    
END.                      

/* RHC 03.09.04 TOMAMOS EL AUXILIAR DEL CLIENTE */
X-CODAUX = CcbCDocu.CodCli.

FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                   cb-ctas.CodCta = x-codcta
                   NO-LOCK NO-ERROR.

IF AVAILABLE cb-ctas AND NOT cb-ctas.PidAux 
THEN ASSIGN
      x-codaux = ""
      x-clfaux = "".

CREATE t-prev.
ASSIGN
    /*t-prev.tipo    = CcbCCaja.Usuario + STRING(CcbCCaja.FchCie, '99/99/9999') + CcbCCaja.HorCie*/
    t-prev.tipo    = CcbCCaja.Usuario + STRING(CcbCCaja.FchCie, '99/99/9999')
    t-prev.periodo = INTEGER(x-periodo)
    t-prev.nromes  = INTEGER(x-nromes)
    t-prev.codope  = x-codope
    t-prev.coddiv  = x-CodDiv 
    t-prev.fchast  = CcbCCaja.FchCie
    t-prev.codmon  = x-codmon
    t-prev.codcta  = x-codcta
    t-prev.fchdoc  = CcbCCaja.FchCie 
    t-prev.fchvto  = x-fchvto
    t-prev.tpomov  = x-tpomov
    t-prev.clfaux  = x-clfaux
    t-prev.codaux  = x-codaux
    t-prev.coddoc  = x-Codcbd
    t-prev.nrodoc  = x-nrodoc
    t-prev.Tpocmb  = x-TpoCmb
    t-prev.glodoc  = x-glodoc
    t-prev.nroref  = CcbCCaja.Nrodoc.
IF x-codmon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-import * x-signo.
ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-import * x-signo
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2) * x-signo.
RELEASE t-prev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Dif W-Win 
PROCEDURE Graba-Dif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-codmon AS INTEGER.
    DEFINE INPUT PARAMETER x-import AS DECIMAL.

    CREATE T-PREV-2.
    ASSIGN
        T-PREV-2.tipo    = t-prev.tipo
        T-PREV-2.periodo = INTEGER(x-periodo)
        T-PREV-2.nromes  = INTEGER(x-nromes)
        T-PREV-2.codope  = x-codope
        T-PREV-2.coddiv  = f-Division     /*t-prev.CodDiv */
        T-PREV-2.codmon  = x-codmon
        T-PREV-2.codcta  = x-codcta
        T-PREV-2.fchdoc  = t-prev.fchdoc
        T-PREV-2.tpomov  = x-tpomov
        T-PREV-2.Tpocmb  = t-prev.TpoCmb
        T-PREV-2.glodoc  = 'Diferencia de Cambio'
        T-PREV-2.nroref  = '999999999'. /* Solo por presentacion */

    IF x-codmon = 1 THEN ASSIGN T-PREV-2.impmn1 = x-import.
    ELSE ASSIGN T-PREV-2.impmn2 = x-import.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-N/C W-Win 
PROCEDURE Graba-N/C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-coddiv AS CHAR.
DEFINE INPUT PARAMETER x-codmon AS INTEGER.
DEFINE INPUT PARAMETER x-import AS DECIMAL.
DEFINE INPUT PARAMETER x-clfaux AS CHAR.
DEFINE INPUT PARAMETER x-codref AS CHAR.
DEFINE INPUT PARAMETER x-nrodoc AS CHAR.
DEFINE INPUT PARAMETER x-fchvto AS DATE.
DEFINE INPUT PARAMETER x-tpocmb AS DECIMAL.

DEFINE VAR x-detalle AS LOGICAL NO-UNDO.
DEFINE VAR x-codaux AS CHAR.
DEFINE VAr x-signo  AS DECI.
DEFINE VAR x-Tipo   AS CHAR NO-UNDO.

x-signo = 1.

FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                    CcbCDocu.CodDoc = x-CodRef AND 
                    CcbCDocu.NroDoc = x-nrodoc
                    NO-LOCK NO-ERROR.

IF NOT AVAILABLE CcbCDocu THEN RETURN.
IF CcbCdocu.FlgEst = "A" THEN RETURN.

/* RHC 03.09.04 TOMAMOS LA DIVISION DEL DOCUMENTO ORIGEN PARA MATAR SALDOS */
x-CodDiv = CCBCDOCU.CodDiv.
/* ***************************************************** */

FIND B-CDocu WHERE B-CDocu.Codcia = S-CODCIA AND
                   B-CDocu.Coddoc = CcbCDocu.Codref AND
                   B-CDocu.Nrodoc = CcbCDocu.Nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE B-CDocu THEN DO:
  MESSAGE 'Documento ' + CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc SKIP
          'Referencia  ' + CcbCDocu.CodRef + ' ' + CcbCDocu.NroRef + ' No Existe ' 
          VIEW-AS ALERT-BOX.
  RETURN .
END.
                   
FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA 
    AND Cb-cfgrv.CodDiv = F-DIVISION 
    AND Cb-cfgrv.Coddoc = X-codref 
    AND Cb-cfgrv.CodRef = CcbCDocu.Codref 
    AND Cb-cfgrv.Fmapgo = B-CDocu.Fmapgo 
    AND Cb-cfgrv.Codmon = Ccbcdocu.Codmon NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
    MESSAGE 'Cuenta No Configurada' SKIP
        'División:' f-Division SKIP
        'Documento:' x-codref SKIP
        'Referencia:' ccbcdocu.codref SKIP
        'Fma de pago:' b-cdocu.fmapgo SKIP
        'Moneda:' ccbcdocu.codmon
        VIEW-AS ALERT-BOX.
    RETURN.
END.
                            
IF CcbCdocu.CodMon = 2 THEN DO: 
   FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCdocu.FchDoc
                      NO-LOCK NO-ERROR.
   IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.                    
END.                      

/* RHC 03.09.04 TOMAMOS EL AUXILIAR DEL CLIENTE */
X-CODAUX = CcbCDocu.CodCli.
ASSIGN
    x-codcta  = Cb-cfgrv.Codcta
    x-detalle = Cb-cfgrv.Detalle
    x-glodoc  = 'Canc.' + x-codref + '-' + x-nrodoc + ' Cli.' + CcbCCaja.Codcli.     
/* RHC 20/11/2015 Adicionamos mas datos */
CASE Ccbcdocu.CndCre:
    WHEN "D" THEN DO:
        x-GloDoc = x-GloDoc + '|' + 'Por devolución de mercadería'.
    END.
    OTHERWISE DO:
        /* Buscamos el concepto */
        FIND FIRST Ccbddocu OF ccbcdocu NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN DO:
            FIND Ccbtabla WHERE CcbTabla.CodCia = Ccbddocu.codcia
                AND CcbTabla.Codigo = Ccbddocu.codmat
                AND CcbTabla.Tabla = Ccbddocu.coddoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE CcbTabla THEN x-GloDoc = x-GloDoc + '|' + CcbTabla.Nombre .
        END.
    END.
END CASE.
/* ************************************ */

/*MLR* 10/12/07 ***/
X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE "111111111".
X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE SUBSTRING(CcbCDocu.Nrodoc,1,3) + "111111".
/* ***/

FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                   cb-ctas.CodCta = x-codcta
                   NO-LOCK NO-ERROR.

IF AVAILABLE cb-ctas AND NOT cb-ctas.PidAux 
THEN ASSIGN
      x-codaux = ""
      x-clfaux = "".

/* Llave */
/*x-Tipo = CcbCCaja.Usuario + STRING(CcbCCaja.FchCie, '99/99/9999') + CcbCCaja.HorCie.*/
x-Tipo = CcbCCaja.Usuario + STRING(CcbCCaja.FchCie, '99/99/9999').
FIND t-prev WHERE t-prev.fchast  = CcbCCaja.FchCie 
    AND t-prev.coddoc = x-codcbd 
    AND t-prev.nrodoc = x-nrodoc 
    AND t-prev.codcta = x-codcta
    AND t-prev.tipo   = x-tipo
    NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:                  
    CREATE t-prev.
    ASSIGN
        t-prev.tipo    = x-Tipo
        t-prev.periodo = INTEGER(x-periodo)
        t-prev.nromes  = INTEGER(x-nromes)
        t-prev.codope  = x-codope
        t-prev.coddiv  = x-CodDiv 
        t-prev.fchast  = CcbCCaja.FchCie
        t-prev.codmon  = x-codmon
        t-prev.codcta  = x-codcta
        t-prev.fchdoc  = CcbCCaja.FchCie
        t-prev.fchvto  = x-fchvto
        t-prev.tpomov  = x-tpomov
        t-prev.clfaux  = x-clfaux
        t-prev.codaux  = x-codaux
        t-prev.coddoc  = x-Codcbd
        t-prev.nrodoc  = x-nrodoc
        t-prev.Tpocmb  = x-TpoCmb
        t-prev.glodoc  = x-glodoc
        t-prev.nroref  = CcbCCaja.Nrodoc.
END.    
IF x-codmon = 1 THEN
    ASSIGN
    t-prev.impmn1  = t-prev.impmn1 + x-import * x-signo.
ELSE 
    ASSIGN
        t-prev.impmn2  = t-prev.impmn2 + x-import * x-signo
        t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2) * x-signo.


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
  
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'RND' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-rndgan = cb-cfgg.codcta[1] 
        x-rndper = cb-cfgg.codcta[2].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Redondeo no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'C01' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-ctagan = cb-cfgg.codcta[2] 
        x-ctaper = cb-cfgg.codcta[1].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Diferencia de Cambio no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
  
  /* Verifico la configuracion de las cuentas de Ingreso a Caja */
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'CJA' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN x-codope = cb-cfgg.Codope.
  ELSE DO:
     MESSAGE 'Configuracion de Ctas de Ingreso a Caja no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
  
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
        PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN4}.
        RUN Imprimir.
        PAGE .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Carga-Temp W-Win 
PROCEDURE proc_Carga-Temp :
/*------------------------------------------------------------------------------
  Notes:      Transferencia de movimientos correspondientes a cuentas por cobrar
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE t-prev.
    EMPTY TEMP-TABLE T-PREV-2.

    FIND cb-cfgcja WHERE
        cb-cfgcja.Codcia = S-CODCIA AND
        cb-cfgcja.CodDiv = F-DIVISION
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-cfgcja THEN DO:
        MESSAGE
            "Configuracion Cierre de Caja no existe." SKIP
            "Verifique y procese la generación de asientos"
           VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.

    ASSIGN
        FILL-IN-fchast-1 = DATE(11,29,2017)
        FILL-IN-fchast-2 = DATE(11,29,2017).

    x-codope = cb-cfgcja.codope.

    /* INGRESOS A CAJA */
    RUN proc_Ingresos.

    /* EGRESOS A CAJA */
    RUN proc_Egresos.

    x-tpocmb = 0.
    RUN proc_Graba-Diferencia.

    HIDE FRAME F-Proceso.
    RUN dispatch IN h_b-cjacbd-01('open-query':U).

    RUN Totales IN h_b-cjacbd-01.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Egresos W-Win 
PROCEDURE proc_Egresos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-entra  AS LOGICAL.
    DEFINE VAR x-fchvto AS DATE NO-UNDO.
    DEFINE VAR x-imptot AS DECIMAL NO-UNDO.

    FOR EACH CcbCCaja WHERE CcbCCaja.CodCia = s-codcia AND
        CcbCCaja.FlgCie = 'C' AND
        CcbCCaja.FchCie >= FILL-IN-fchast-1 AND
        CcbCCaja.FchCie <= FILL-IN-fchast-2 AND
        CcbCCaja.CodDiv = F-DIVISION AND
        CcbCCaja.Coddoc = "E/C" AND
        CcbCCaja.Tipo   <> "SENCILLO" AND
        CcbCCaja.FlgEst <> "A"
        NO-LOCK BREAK BY CcbCCaja.CodDiv BY CcbCCaja.FchCie BY CcbCCaja.Usuario BY ccbCCaja.HorCie:
        x-entra = false.
        IF x-entra = YES THEN NEXT.
        CASE CcbCCaja.Tipo:
            WHEN "DEVONC" THEN DO:
                FIND FacDocum WHERE
                    FacDocum.CodCia = s-codcia AND
                    FacDocum.CodDoc = SUBSTRING(CcbCCaja.Voucher[1],1,3)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE FacDocum THEN DO:
                    x-tpomov = FacDocum.TpoDoc.
                    x-codcbd = FacDocum.CodCbd.
                    x-tpocmb = 0.
                END.
                IF CcbCCaja.ImpNac[1] > 0 THEN DO:
                    x-imptot = CcbCCaja.ImpNac[1].
                    x-codcta = CcbCCaja.CodCta[1].
                    RUN Graba-N/C(
                        CcbCCaja.CodDiv, 
                        1, 
                        x-imptot, 
                        '@CL', 
                        "N/C" ,
                        SUBSTRING(CcbCCaja.Voucher[1],4), 
                        x-fchvto, 
                        x-tpocmb).
                END.
                IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
                    x-imptot = CcbCCaja.ImpUsa[1].
                    x-codcta = CcbCCaja.CodCta[1].
                    RUN Graba-N/C(
                        CcbCCaja.CodDiv, 
                        2, 
                        x-imptot, 
                        '@CL', 
                        "N/C" ,
                        SUBSTRING(CcbCCaja.Voucher[1],4), 
                        x-fchvto, 
                        x-tpocmb).
                END.
            END.
            WHEN "DEVOBD" THEN DO:
                FIND FacDocum WHERE
                    FacDocum.CodCia = s-codcia AND
                    FacDocum.CodDoc = SUBSTRING(CcbCCaja.Voucher[1], 1, 2)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE FacDocum THEN DO:
                    x-tpomov = FacDocum.TpoDoc.
                    x-codcbd = FacDocum.CodCbd.
                    x-tpocmb = 0.
                END.
                IF CcbCCaja.ImpNac[1] > 0 THEN DO:
                    x-imptot = CcbCCaja.ImpNac[1].
                    x-codcta = FacDocum.CodCta[1].
                    RUN Graba-BD(
                        CcbCCaja.CodDiv, 
                        1, 
                        x-imptot, 
                        '@CL', 
                        "BD" ,
                        SUBSTRING(CcbCCaja.Voucher[1], 4), 
                        x-fchvto, 
                        x-tpocmb).
                END.
                IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
                    x-imptot = CcbCCaja.ImpUsa[1].
                    x-codcta = FacDocum.CodCta[2].
                    RUN Graba-BD(
                        CcbCCaja.CodDiv, 
                        2, 
                        x-imptot, 
                        '@CL', 
                        "BD" ,
                        SUBSTRING(CcbCCaja.Voucher[1], 4), 
                        x-fchvto, 
                        x-tpocmb).
                END.
            END.
            WHEN "ANTREC" THEN DO:
                IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
                    x-codcbd = "34".
                    x-codcta = cb-cfgcja.codcta2[7].
                    x-tpocmb = CcbCCaja.TpoCmb.
                    x-glodoc = "Devolución-A/R" + '-' + CcbCcaja.CodDoc + "-" + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").
                    x-tpomov = FALSE.
                    RUN proc_Graba-Caja(
                        CcbCCaja.Coddiv,
                        2,
                        CcbCCaja.ImpUsa[1],
                        '@CL',
                        CcbCCaja.Codcli,
                        SUBSTRING(CcbCCaja.Voucher[1],4,15),
                        CcbCCaja.FchVto[3],
                        x-tpocmb).
                    x-tpomov = TRUE.
                    x-codcta = cb-cfgcja.codcta2[1].
                    RUN proc_Graba-Caja(
                        CcbCCaja.Coddiv,
                        2,
                        CcbCCaja.ImpUsa[1],
                        '@CL',
                        CcbCCaja.Codcli,
                        SUBSTRING(CcbCCaja.Voucher[1],4,15),
                        CcbCCaja.FchVto[3],
                        x-tpocmb).
                END.
                IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
                    x-codcbd = "34".
                    x-codcta = cb-cfgcja.codcta1[7].
                    x-tpocmb = 0.
                    x-glodoc = "Devocución-A/R" + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").
                    x-tpomov = FALSE.
                    RUN proc_Graba-Caja(
                        CcbCCaja.Coddiv,
                        1,
                        CcbCCaja.ImpNac[1],
                        '@CL',
                        CcbCCaja.Codcli,
                        SUBSTRING(CcbCCaja.Voucher[1],4,15),
                        CcbCCaja.FchVto[3],
                        x-tpocmb).
                    x-codcta = cb-cfgcja.codcta1[1].
                    x-tpomov = TRUE.
                    RUN proc_Graba-Caja(
                        CcbCCaja.Coddiv,
                        1,
                        CcbCCaja.ImpNac[1],
                        '@CL',
                        CcbCCaja.Codcli,
                        SUBSTRING(CcbCCaja.Voucher[1],4,15),
                        CcbCCaja.FchVto[3],
                        x-tpocmb).
                END.
            END.
            OTHERWISE DO:
                x-tpomov = FALSE.
                IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
                    CASE CcbCCaja.Tipo:
                        WHEN "REMEBOV" THEN x-codcta = cb-cfgcja.CodCta_2[1].
                        WHEN "REMECJC" THEN x-codcta = cb-cfgcja.CodCta_2[2].
                        OTHERWISE x-codcta = cb-cfgcja.CodCta2[1].
                    END CASE.
                    x-codcbd = SUBSTRING(CcbCCaja.Voucher[1],1,3).
                    x-tpocmb = CcbCCaja.Tpocmb.
                    x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
                    RUN proc_Graba-Caja(
                        CcbCCaja.Coddiv,
                        2,
                        CcbCCaja.ImpUsa[1],
                        '@CL',
                        CcbCCaja.Codcli,
                        SUBSTRING(CcbCCaja.Voucher[1],4,15),
                        CcbCCaja.FchVto[3],
                        x-tpocmb).
                END.
                IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
                    CASE CcbCCaja.Tipo:
                        WHEN "REMEBOV" THEN x-codcta = cb-cfgcja.CodCta_1[1].
                        WHEN "REMECJC" THEN x-codcta = cb-cfgcja.CodCta_1[2].
                        OTHERWISE x-codcta = cb-cfgcja.CodCta1[1].
                    END CASE.
                    x-codcbd = SUBSTRING(CcbCCaja.Voucher[1],1,3).
                    x-tpocmb = 0.
                    x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
                    RUN proc_Graba-Caja(
                        CcbCCaja.Coddiv,
                        1,
                        CcbCCaja.ImpNac[1],
                        '@CL',
                        CcbCCaja.Codcli,
                        SUBSTRING(CcbCCaja.Voucher[1],4,15),
                        CcbCCaja.FchVto[3],
                        x-tpocmb).
                END.
            END.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Caja W-Win 
PROCEDURE proc_Graba-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-coddiv AS CHAR.
    DEFINE INPUT PARAMETER x-codmon AS INTEGER.
    DEFINE INPUT PARAMETER x-import AS DECIMAL.
    DEFINE INPUT PARAMETER x-clfaux AS CHAR.
    DEFINE INPUT PARAMETER x-codaux AS CHAR.
    DEFINE INPUT PARAMETER x-nrodoc AS CHAR.
    DEFINE INPUT PARAMETER x-fchvto AS DATE.
    DEFINE INPUT PARAMETER x-tpocmb AS DECIMAL.

    IF x-codcta = "" THEN DO:
        MESSAGE "ERROR CUENTA DE CAJA" x-codcta SKIP
            "Tipo:" CcbCCaja.Tipo SKIP
            "División:" CcbCCaja.CodDiv SKIP
            "Documento:" Ccbccaja.coddoc Ccbccaja.nrodoc SKIP(1)
            "Revise la Configuración Contable de Caja"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    CREATE t-prev.
    ASSIGN
        /*t-prev.tipo    = STRING(CcbCCaja.FchCie, '99/99/9999') + CcbCCaja.Usuario + CcbCCaja.HorCie*/
        t-prev.tipo    = STRING(CcbCCaja.FchCie, '99/99/9999') + CcbCCaja.Usuario
        t-prev.periodo = INTEGER(x-periodo)
        t-prev.nromes  = INTEGER(x-nromes)
        t-prev.codope  = x-codope
        t-prev.fchast  = CcbCCaja.FchCie
        t-prev.coddiv  = x-CodDiv 
        t-prev.fchast  = CcbCCaja.FchCie
        t-prev.codmon  = x-codmon
        t-prev.codcta  = x-codcta
        t-prev.fchdoc  = CcbCCaja.FchCie 
        t-prev.fchvto  = x-fchvto
        t-prev.tpomov  = x-tpomov
        t-prev.clfaux  = x-clfaux
        t-prev.codaux  = x-codaux
        t-prev.coddoc  = x-Codcbd
        t-prev.nrodoc  = x-nrodoc
        t-prev.Tpocmb  = x-TpoCmb
        t-prev.glodoc  = x-glodoc
/*MLR-1*/ t-prev.Codref = CcbCCaja.Coddoc
        t-prev.nroref  = CcbCCaja.Nrodoc.

    IF x-codmon = 1 THEN
        ASSIGN t-prev.impmn1  = t-prev.impmn1 + x-import.
    ELSE
        ASSIGN
            t-prev.impmn2  = t-prev.impmn2 + x-import
            t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2).
    RELEASE t-prev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Diferencia W-Win 
PROCEDURE proc_Graba-Diferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-s AS DECIMAL NO-UNDO.
    DEFINE VAR x-d AS DECIMAL NO-UNDO.
    
    FOR EACH t-prev NO-LOCK BREAK BY t-prev.tipo:
        IF FIRST-OF(t-prev.tipo) THEN DO:
            x-s = 0.
            x-d = 0.
        END.
        x-s = x-s + (t-prev.ImpMn1 * (IF t-prev.tpomov THEN -1 ELSE 1) ).
        x-d = x-d + (t-prev.ImpMn2 * (IF t-prev.tpomov THEN -1 ELSE 1) ).
        IF LAST-OF(t-prev.tipo) THEN DO:
            IF x-s <> 0  THEN DO:
                x-tpomov = x-s > 0.
                x-codcta = IF x-s > 0 THEN x-ctagan ELSE x-ctaper.
                RUN Graba-Dif (1, ABS(x-s)).
            END.
        END.
    END.

    FOR EACH T-PREV-2:
        CREATE T-PREV.
        BUFFER-COPY T-PREV-2 TO T-PREV.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Documento W-Win 
PROCEDURE proc_Graba-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-coddiv AS CHAR.
    DEFINE INPUT PARAMETER x-codmon AS INTEGER.
    DEFINE INPUT PARAMETER x-import AS DECIMAL.
    DEFINE INPUT PARAMETER x-clfaux AS CHAR.
    DEFINE INPUT PARAMETER x-codref AS CHAR.
    DEFINE INPUT PARAMETER x-nrodoc AS CHAR.
    DEFINE INPUT PARAMETER x-fchvto AS DATE.
    DEFINE INPUT PARAMETER x-tpocmb AS DECIMAL.

    DEFINE VAR x-detalle AS LOGICAL NO-UNDO.
    DEFINE VAR x-codaux AS CHAR.
    DEFINE VAr x-signo  AS DECI.
    DEFINE VAR x-ImpPer AS DEC NO-UNDO.
    DEFINE VAR x-Tipo   AS CHAR NO-UNDO.

    FIND CcbCDocu WHERE
        CcbCDocu.CodCia = s-codcia AND
        CcbCDocu.CodDoc = x-CodRef AND 
        CcbCDocu.NroDoc = x-nrodoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE
            'Documento no encontrado en los registros ' +
            x-codref + ' ' + x-nrodoc VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    IF CcbCdocu.FlgEst = "A" THEN RETURN.

    /* RHC 03.09.04 TOMAMOS LA DIVISION DEL DOCUMENTO ORIGEN PARA MATAR SALDOS */
    x-CodDiv = CCBCDOCU.CodDiv.

    /*MLR* 17/01/08 ***/
    IF ccbcdocu.coddoc <> "LET" THEN DO:
        IF LOOKUP(Ccbcdocu.coddoc, 'N/D,N/C') > 0
        THEN FIND Cb-cfgrv WHERE
            Cb-cfgrv.Codcia = S-CODCIA AND
            Cb-cfgrv.CodDiv = Ccbcdocu.CodDiv AND
            Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc AND
            Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo AND
            Cb-cfgrv.Codmon = Ccbcdocu.Codmon AND
            Cb-cfgrv.CodRef = Ccbcdocu.CodRef NO-LOCK NO-ERROR.
        ELSE FIND Cb-cfgrv WHERE
            Cb-cfgrv.Codcia = S-CODCIA AND
            Cb-cfgrv.CodDiv = Ccbcdocu.CodDiv AND
            Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc AND
            Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo AND
            Cb-cfgrv.Codmon = Ccbcdocu.Codmon NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
            MESSAGE
                'Cuenta No Configurada Para ' 
                CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc SKIP
                'División:' ccbcdocu.coddiv SKIP
                'Documento:' ccbcdocu.coddoc SKIP
                'Condición de venta:' ccbcdocu.fmapgo SKIP
                'Moneda:' ccbcdocu.codmon SKIP
                'Referencia:' ccbcdocu.codref
                VIEW-AS ALERT-BOX WARNING.
            RETURN.
        END.
    END.
    IF CcbCdocu.CodMon = 2 THEN DO: 
        FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.
        /* RHC 15.06.06 N/C toma el T.C. del documento de referencia */
        IF Ccbcdocu.coddoc = 'N/C' THEN DO:
            FIND B-CDOCU WHERE
                B-CDOCU.codcia = Ccbcdocu.codcia AND
                B-CDOCU.coddoc = Ccbcdocu.codref AND
                B-CDOCU.nrodoc = Ccbcdocu.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE B-CDOCU THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = B-CDOCU.FchDoc NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.
            END.
        END.
    END.
    /* TOMAMOS EL AUXILIAR DEL DOCUMENTO */
    X-CODAUX = CcbCDocu.CodCli.

    IF LOOKUP(CcbCDocu.CodDoc,'BOL,TCK') > 0 THEN
        /*x-CodAux = IF CcbCDocu.NroCard <> '' THEN CcbCDocu.NroCard ELSE '11111111111'.*/
        x-CodAux = '11111111111'.

    IF ccbcdocu.coddoc <> "LET" THEN DO:
        x-codcta  = Cb-cfgrv.Codcta.
        x-detalle = Cb-cfgrv.Detalle.
        x-glodoc  = 'Canc.' + CcbDCaja.CodRef + '-' + CcbDCaja.NroRef + ' Cli.' + CcbDCaja.Codcli.
    END.
    ELSE DO:
        x-codcta = x-ctalet[ccbcdocu.codmon].
        x-detalle = TRUE.
    END.

    X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE "111111111".
    X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE SUBSTRING(CcbCDocu.Nrodoc,1,3) + "111111".

    FIND cb-ctas WHERE
        cb-ctas.CodCia = cb-codcia AND
        cb-ctas.CodCta = x-codcta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-ctas OR x-CodCta = "" THEN DO:
        MESSAGE "ERROR en la cuenta" x-codcta SKIP
            "Comprobante:" Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
            "División:" Ccbcdocu.coddiv SKIP
            "Condición de Venta:" Ccbcdocu.fmapgo SKIP
            "Moneda:" Ccbcdocu.codmon SKIP
            "Referencia:" Ccbcdocu.codref SKIP(1)
            "Revisar la Configuración de los Asientos Automáticos del Registro de Ventas"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    IF AVAILABLE cb-ctas AND NOT cb-ctas.PidAux THEN
        ASSIGN
            x-codaux = ""
            x-clfaux = "".

    IF NOT x-detalle THEN DO:
        x-glodoc  = 'Resumen ' + '-' + CcbDCaja.CodRef.
    END.
    x-signo = IF CcbCCaja.Coddoc = "I/C" THEN 1 ELSE -1.

    /* LLAVE DE BUSQUEDA */
    /*x-Tipo = STRING(CcbCCaja.FchCie, '99/99/9999') + CcbCCaja.Usuario + CcbCCaja.HorCie.*/
    x-Tipo = STRING(CcbCCaja.FchCie, '99/99/9999') + CcbCCaja.Usuario.
    FIND t-prev WHERE t-prev.fchast  = CcbCCaja.FchCie
        AND t-prev.coddoc = x-codcbd
        AND t-prev.nrodoc = x-nrodoc
        AND t-prev.codcta = x-codcta
        AND t-prev.tipo   = x-tipo
        NO-ERROR.
    IF NOT AVAILABLE t-prev THEN DO:
        CREATE t-prev.
        ASSIGN
            t-prev.tipo    = x-Tipo
            t-prev.periodo = INTEGER(x-periodo)
            t-prev.nromes  = INTEGER(x-nromes)
            t-prev.codope  = x-codope
            t-prev.coddiv  = x-CodDiv
            t-prev.fchast  = CcbCCaja.FchCie
            t-prev.codmon  = x-codmon
            t-prev.codcta  = x-codcta
            t-prev.fchdoc  = CcbCCaja.FchCie 
            t-prev.fchvto  = x-fchvto
            t-prev.tpomov  = x-tpomov
            t-prev.clfaux  = x-clfaux
            t-prev.codaux  = x-codaux
            t-prev.coddoc  = x-Codcbd
            t-prev.nrodoc  = x-nrodoc
            t-prev.Tpocmb  = x-TpoCmb
            t-prev.glodoc  = x-glodoc
            t-prev.nroref  = CcbCCaja.Nrodoc.
    END.
    /* PAGO SIN INCLUIR LA PERCEPCION (UNA PROPORCION DE LA PERCEPCION) */
    IF Ccbcdocu.ImpTot <> 0 THEN
        ASSIGN
        x-ImpPer = Ccbcdocu.AcuBon[5] * ( x-Import / Ccbcdocu.ImpTot )
        x-Import = x-Import - x-ImpPer.
    IF x-codmon = 1 THEN
        ASSIGN
            t-prev.impmn1  = t-prev.impmn1 + x-import * x-signo.
    ELSE
        ASSIGN
            t-prev.impmn2  = t-prev.impmn2 + x-import * x-signo
            t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2) * x-signo.

    /* PAGO DE LA PERCEPCION */
    IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 AND Ccbcdocu.AcuBon[5] > 0 THEN DO:
        x-CodCta = "40111301".
        FIND t-prev WHERE t-prev.fchast  = CcbCCaja.FchCie
            AND t-prev.coddoc = x-codcbd 
            AND t-prev.nrodoc = x-nrodoc 
            AND t-prev.codcta = x-codcta
            AND t-prev.tipo   = x-tipo
            NO-ERROR.
        IF NOT AVAILABLE t-prev THEN DO:
            CREATE t-prev.
            ASSIGN
                t-prev.tipo    = x-Tipo
                t-prev.periodo = INTEGER(x-periodo)
                t-prev.nromes  = INTEGER(x-nromes)
                t-prev.codope  = x-codope
                t-prev.coddiv  = x-CodDiv
                t-prev.fchast  = CcbCCaja.FchCie
                t-prev.codmon  = x-codmon
                t-prev.codcta  = x-codcta
                t-prev.fchdoc  = CcbCCaja.FchDoc 
                t-prev.fchvto  = x-fchvto
                t-prev.tpomov  = x-tpomov
                t-prev.clfaux  = x-clfaux
                t-prev.codaux  = x-codaux
                t-prev.coddoc  = x-Codcbd
                t-prev.nrodoc  = x-nrodoc
                t-prev.Tpocmb  = x-TpoCmb
                t-prev.glodoc  = x-glodoc
                t-prev.nroref  = CcbCCaja.Nrodoc.
        END.
        /* PAGO SIN INCLUIR LA PERCEPCION */
        IF x-codmon = 1 THEN
            ASSIGN
                t-prev.impmn1  = t-prev.impmn1 + x-ImpPer * x-signo.
        ELSE
            ASSIGN
                t-prev.impmn2  = t-prev.impmn2 + x-ImpPer * x-signo
                t-prev.impmn1  = t-prev.impmn1 + ROUND((x-ImpPer * x-tpocmb),2) * x-signo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Ingresos W-Win 
PROCEDURE proc_Ingresos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-imptot AS DECIMAL NO-UNDO.

    FOR EACH CcbCCaja NO-LOCK WHERE CcbCCaja.CodCia = s-codcia 
        AND CcbCCaja.FlgCie = 'C' 
        AND CcbCCaja.FchCie >= FILL-IN-fchast-1 
        AND CcbCCaja.FchCie <= FILL-IN-fchast-2 
        AND CcbCCaja.CodDiv = F-DIVISION 
        AND CcbCCaja.Coddoc = "I/C" 
        AND CcbCCaja.Tipo <> "SENCILLO" 
        AND CcbCCaja.FlgEst <> "A":
        DISPLAY CcbCCaja.CodDoc + '-' + CcbCCaja.NroDoc @ Fi-Mensaje LABEL "Documento de cobranza" FORMAT "X(16)" WITH FRAME F-Proceso.
        FOR EACH CcbDCaja OF CcbCCaja NO-LOCK:
            /* Cancelo provision del documento */
            x-glodoc = 'Canc.' + CcbDCaja.CodRef + '-' + CcbDCaja.NroRef + ' Cli.' + CcbDCaja.Codcli.
            FIND FacDocum WHERE
                FacDocum.CodCia = s-codcia AND
                FacDocum.CodDoc = CcbDCaja.CodRef
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacDocum THEN
                ASSIGN
                    x-ctalet[1] = FacDocum.CodCta[1]
                    x-ctalet[2] = FacDocum.CodCta[2]
                    x-tpomov = FacDocum.TpoDoc
                    x-codcbd = FacDocum.CodCbd
                    x-tpocmb = 0.
            IF LOOKUP(CcbDCaja.CodRef,'TCK,FAC,BOL,N/C,N/D,LET,CHQ') > 0 THEN DO:
                RUN proc_Graba-Documento(CcbCCaja.CodDiv, CcbDCaja.CodMon, CcbDCaja.ImpTot, '@CL', CcbDCaja.CodRef, CcbDCaja.Nroref, x-fchvto, x-tpocmb).
            END.
        END.        
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            x-tpocmb = CcbCCaja.TpoCmb.
            IF CcbCCaja.Tipo = "ANTREC" THEN DO:
                x-codcbd = '34'.
                x-codcta = cb-cfgcja.codcta2[7].
                x-glodoc = 'Anticipo-Recibido' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                x-tpomov = TRUE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '@CL', CcbCCaja.Codcli, SUBSTRING(CcbCCaja.Voucher[1],4,15), x-fchvto, x-tpocmb).
                x-codcta = cb-cfgcja.codcta2[1].
                x-tpomov = FALSE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '@CL', CcbCCaja.Codcli, SUBSTRING(CcbCCaja.Voucher[1],4,15), x-fchvto, x-tpocmb).
            END.
            ELSE IF CcbCCaja.Tipo = "DEVONC" THEN DO:
                x-codcbd = SUBSTRING(CcbCcaja.Voucher[1],1,3).
                x-codcta = CCbCCaja.CodCta[1].
                x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").
                x-tpomov = TRUE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '', "", SUBSTRING(CcbCcaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
                x-tpomov = FALSE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '', "", SUBSTRING(CcbCcaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
            END.
        END.                
        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            x-tpocmb = 0.
            IF CcbCCaja.Tipo = "ANTREC" THEN DO:
                x-codcbd = '34'.
                x-codcta = cb-cfgcja.codcta1[7].
                x-glodoc = 'Anticipo-Recibido' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                x-tpomov = TRUE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '@CL', CcbCCaja.Codcli, SUBSTRING(CcbCCaja.Voucher[1],4,15), x-fchvto, x-tpocmb).
            END.
            ELSE IF CcbCCaja.Tipo = "DEVONC" THEN DO:
                x-codcbd = SUBSTRING(CcbCcaja.Voucher[1],1,3).
                x-codcta = CCbCCaja.CodCta[1].
                x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").
                x-tpomov = TRUE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '', "", SUBSTRING(CcbCcaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
                x-tpomov = FALSE.
                RUN proc_Graba-Caja(CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '', "", SUBSTRING(CcbCcaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
            END.
        END.
        /* ASIGNAMOS LA MISMA DIVISION QUE LA PROVISION */
        x-CodDiv = CcbCCaja.CodDiv.
        FIND FIRST CcbDCaja OF CcbCCaja NO-LOCK NO-ERROR.
        IF AVAILABLE CcbDCaja THEN DO:
            FIND CcbCDocu WHERE
                CcbCDocu.CodCia = s-codcia AND
                CcbCDocu.CodDoc = CcbDCaja.CodRef AND
                CcbCDocu.NroDoc = CcbDcaja.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN x-CodDiv = ccbcdocu.coddiv.
        END.
        x-tpomov = FALSE.
        x-tpocmb = 0.
        IF CcbCCaja.ImpNac[2] > 0 THEN DO:
            x-codcbd = '32'.
            x-codcta = cb-cfgcja.codcta1[2].
            x-tpocmb = 0.
            x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(x-Coddiv, 1, CcbCCaja.ImpNac[2], '', "", CcbCCaja.Voucher[2], x-fchvto, x-tpocmb).
        END.
        IF CcbCCaja.ImpNac[3] > 0 THEN DO:
            x-codcbd = '32'.
            x-codcta = cb-cfgcja.codcta1[3].       
            x-tpocmb = 0.
            x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
            RUN proc_Graba-Caja(x-Coddiv, 1, CcbCCaja.ImpNac[3], '', "", CcbCCaja.Voucher[3], CcbCCaja.FchVto[3], x-tpocmb).
        END.
        IF CcbCCaja.ImpNac[4] > 0 THEN DO:
            x-codcta = cb-cfgcja.codcta1[4].
            x-codaux = ''.
            x-codcbd = ''.
            x-tpocmb = 0.
            x-glodoc = 'Canc-Tarjeta-Credito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            /* BUSCAMOS DATOS EL LA CUENTA */
            FIND FIRST CB-CTAS WHERE
                CB-CTAS.codcia = cb-codcia AND
                CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
            IF AVAILABLE CB-CTAS THEN x-codcbd = cb-ctas.Coddoc.
            FIND FacTabla WHERE
                FacTabla.CodCia = s-CodCia AND
                FacTabla.Tabla = "TC" AND
                FacTabla.Codigo = SUBSTRING(CcbCCaja.Voucher[9],1,2)
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla THEN x-codaux = STRING(FacTabla.Valor[1],"99999999").
            RUN proc_Graba-Caja(x-Coddiv, 1, CcbCCaja.ImpNac[4], '', x-codaux, CcbCCaja.Voucher[4], x-fchvto, x-tpocmb).
        END.
        IF CcbCCaja.ImpNac[5] > 0 THEN DO:
            x-codcta = "".
            x-codcbd = '36'.
            x-tpocmb = 0.
            x-glodoc = 'Canc-Deposito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
            FIND ccbcdocu WHERE
                ccbcdocu.CodCia = S-CodCia AND
                ccbcdocu.CodDoc = "BD" AND
                /*ccbcdocu.CodCli = CcbCCaja.Codcli AND*/
                ccbcdocu.nrodoc = CcbCCaja.Voucher[5]
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbcdocu THEN DO:
                MESSAGE 'Depósito no se encuentra registrado ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[5]
                    VIEW-AS ALERT-BOX WARNING.
            END.
            IF AVAILABLE ccbcdocu THEN DO:
                x-codcbd = '34'.
                x-codcta = '12211100'.
                RUN proc_Graba-Caja(ccbcdocu.coddiv, 1, CcbCCaja.ImpNac[5],'@CLI', ccbcdocu.CodCli, CcbCCaja.Voucher[5], x-fchvto, x-tpocmb).
            END.
        END.
        /* Nota de Crédito */
        IF CcbCCaja.ImpNac[6] > 0 THEN DO:
            FOR EACH Ccbdmov NO-LOCK WHERE CCBDMOV.CodCia = CcbCCaja.CodCia 
                AND CCBDMOV.CodDiv = CcbCCaja.CodDiv 
                AND CCBDMOV.CodRef = CcbCCaja.coddoc    /* I/C */
                AND CCBDMOV.NroRef = CcbCCaja.nrodoc 
                AND CCBDMOV.CodDoc = "N/C",
                FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdmov.codcia
                    AND Ccbcdocu.coddoc = Ccbdmov.coddoc
                    AND Ccbcdocu.nrodoc = Ccbdmov.nrodoc:
                x-codcta = cb-cfgcja.codcta1[6].
                x-codcbd = '07'.
                x-tpocmb = 0.
                x-glodoc = 'Canc-N/C' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                FIND Cb-cfgrv WHERE Cb-cfgrv.CodCia = s-codcia
                        AND Cb-cfgrv.CodDiv = F-Division
                        AND Cb-cfgrv.CodDoc = "N/C"
                        AND Cb-cfgrv.CodRef = Ccbcdocu.codref   /* FAC */
                        AND Cb-cfgrv.FmaPgo = Ccbcdocu.fmapgo
                        AND Cb-cfgrv.CodMon = Ccbcdocu.codmon
                        NO-LOCK NO-ERROR.
                IF AVAILABLE Cb-cfgrv THEN x-codcta = Cb-cfgrv.CodCta.
                IF ccbcdocu.CodCli BEGINS "11111111" THEN x-codaux = "11111111111".
                ELSE x-codaux = ccbcdocu.CodCli.
                RUN proc_Graba-Caja(ccbcdocu.coddiv, 1, Ccbdmov.ImpTot, '@CLI', x-codaux, CcbDMov.NroDoc, x-fchvto, x-tpocmb).
            END.

            /* ***************
            /* Muchas N/C contra muchas FAC */
            DEF VAR x-ImpFac AS DEC NO-UNDO.
            DEF VAR x-Factor AS DEC NO-UNDO.
            /* Sumamos importes aplicados a las facturas */
            x-ImpFac = 0.
            FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK,
                FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
                AND Ccbcdocu.coddoc = Ccbdcaja.codref
                AND Ccbcdocu.nrodoc = Ccbdcaja.nroref:
                x-Impfac = x-ImpFac + Ccbdcaja.imptot.
            END.
            /* Aplicamos por cada N/C */
            FOR EACH Ccbdmov NO-LOCK WHERE CCBDMOV.CodCia = CcbCCaja.CodCia 
                AND CCBDMOV.CodDiv = CcbCCaja.CodDiv 
                AND CCBDMOV.CodRef = CcbCCaja.coddoc    /* I/C */
                AND CCBDMOV.NroRef = CcbCCaja.nrodoc 
                AND CCBDMOV.CodDoc = "N/C":
                FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK,
                    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
                    AND Ccbcdocu.coddoc = Ccbdcaja.codref
                    AND Ccbcdocu.nrodoc = Ccbdcaja.nroref:
                    x-Factor = Ccbdmov.ImpTot * Ccbdcaja.ImpTot / x-ImpFac.
                    x-codcta = cb-cfgcja.codcta1[6].
                    x-codcbd = '07'.
                    x-tpocmb = 0.
                    x-glodoc = 'Canc-N/C' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                    IF ccbcdocu.CodCli BEGINS "11111111" THEN x-codaux = "11111111111".
                    ELSE x-codaux = ccbcdocu.CodCli.
                    FIND Cb-cfgrv WHERE Cb-cfgrv.CodCia = s-codcia
                        AND Cb-cfgrv.CodDiv = F-Division
                        AND Cb-cfgrv.CodDoc = "N/C"
                        AND Cb-cfgrv.CodRef = Ccbcdocu.coddoc
                        AND Cb-cfgrv.FmaPgo = Ccbcdocu.fmapgo
                        AND Cb-cfgrv.CodMon = Ccbdmov.codmon
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Cb-cfgrv THEN x-codcta = Cb-cfgrv.CodCta.
                    RUN proc_Graba-Caja(ccbcdocu.coddiv, 1, x-Factor, '@CLI', x-codaux, CcbDMov.NroDoc, x-fchvto, x-tpocmb).
                END.
            END.
            ************** */

/*             x-codcta = cb-cfgcja.codcta1[6].                                                                                    */
/*             x-codcbd = '07'.                                                                                                    */
/*             x-tpocmb = 0.                                                                                                       */
/*             x-glodoc = 'Canc-N/C' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.                        */
/*             /* Aplicación Notas de Créditos */                                                                                  */
/*             FOR EACH CCBDMOV WHERE                                                                                              */
/*                 CCBDMOV.CodCia = CcbCCaja.CodCia AND                                                                            */
/*                 CCBDMOV.CodDiv = CcbCCaja.CodDiv AND                                                                            */
/*                 CCBDMOV.CodRef = CcbCCaja.coddoc AND                                                                            */
/*                 CCBDMOV.NroRef = CcbCCaja.nrodoc NO-LOCK:                                                                       */
/*                 IF CCBDMOV.CodDoc <> "N/C" OR CCBDMOV.CodMon <> 1 THEN NEXT.   /* N/C en Soles */                               */
/*                 FIND FIRST CcbCDocu WHERE                                                                                       */
/*                     CcbCDocu.CodCia = CCBDMOV.CodCia AND                                                                        */
/*                     /*CcbCDocu.CodCli = CCBDMOV.CodCli AND*/                                                                    */
/*                     CcbCDocu.CodDoc = CCBDMOV.CodDoc AND                                                                        */
/*                     CcbCDocu.NroDoc = CCBDMOV.NroDoc                                                                            */
/*                     NO-LOCK NO-ERROR.                                                                                           */
/*                 IF NOT AVAILABLE CcbCDocu THEN DO:                                                                              */
/*                     MESSAGE                                                                                                     */
/*                         'Nota de Crédito:'  CCBDMOV.NroDoc 'no existe' SKIP                                                     */
/*                         'Cliente:' CcbCCaja.Codcli SKIP                                                                         */
/*                         'Referencia:' Ccbccaja.coddoc Ccbccaja.nrodoc                                                           */
/*                         VIEW-AS ALERT-BOX ERROR.                                                                                */
/*                     NEXT.                                                                                                       */
/*                 END.                                                                                                            */
/*                 IF ccbcdocu.CodCli BEGINS "11111111" THEN x-codaux = "11111111111".                                             */
/*                 ELSE x-codaux = ccbcdocu.CodCli.                                                                                */
/*                 RUN proc_Graba-Caja(ccbcdocu.coddiv, 1, CCBDMOV.ImpTot, '@CLI', x-codaux, CcbCDocu.NroDoc, x-fchvto, x-tpocmb). */
/*             END.                                                                                                                */
        END.
        /* Anticipos */
        IF CcbCCaja.ImpNac[7] > 0 THEN DO:
            x-codcta = cb-cfgcja.codcta1[7].
            x-codcbd = '34'.
            x-tpocmb = 0.
            x-glodoc = 'Canc-Anticip' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
                AND CcbCDocu.CodCli = CcbCCaja.Codcli 
                AND CcbCDocu.CodDoc = CcbCCaja.CodBco[7]       /*'A/R' AND*/
                AND CcbCDocu.NroDoc = CcbCCaja.Voucher[7]
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CcbCDocu THEN DO:
                MESSAGE 'Anticipo no existe ' CcbCCaja.Codcli  CcbCCaja.Voucher[7] SKIP
                    ccbccaja.coddiv ccbccaja.coddoc ccbccaja.nrodoc
                    VIEW-AS ALERT-BOX ERROR.
            END.
            ELSE DO:
                x-codcbd = '34'.
                RUN proc_Graba-Caja(ccbcdocu.coddiv, 1, CcbCCaja.ImpNac[7], '@CLI', ccbcdocu.CodCli, CcbCCaja.Voucher[7], x-fchvto, x-tpocmb).
            END.
        END.
        /* Comisiones */
        IF CcbCCaja.ImpNac[8] > 0 THEN DO:
            x-codcbd = '32'.
            x-tpocmb = 0.
            x-codcta = cb-cfgcja.codcta1[8].
            x-glodoc = 'Comision Factoring' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(CcbCCaja.CodDiv, 1, CcbCCaja.ImpNac[8], '', "", CcbCCaja.Voucher[8], x-fchvto, CcbCCaja.TpoCmb).
        END.
        /* Retenciones */
        IF CcbCCaja.ImpNac[9] > 0 THEN DO:
            x-codcbd = '20'.
            x-tpocmb = 0.
            x-codcta = cb-cfgcja.codcta1[9].
            x-glodoc = 'Retenciones' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(CcbCCaja.CodDiv, 1, CcbCCaja.ImpNac[9], '', "", CcbCCaja.Voucher[9], x-fchvto, CcbCCaja.TpoCmb).
        END.
        /* Vales Consumo */
        IF CcbCCaja.ImpNac[10] > 0 THEN DO:
            x-codcbd = '32'.
            x-tpocmb = 0.
            x-codcta = cb-cfgcja.codcta1[10].
            x-glodoc = 'Vales Consumo' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(CcbCCaja.CodDiv, 1, CcbCCaja.ImpNac[10], '', "", '', x-fchvto, CcbCCaja.TpoCmb).
        END.

        RUN Proc_Ingresos_Usa.

    END. /* FOR EACH CcbCCaja... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proc_Ingresos_Nac W-Win 
PROCEDURE Proc_Ingresos_Nac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proc_Ingresos_Usa W-Win 
PROCEDURE Proc_Ingresos_Usa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        x-tpocmb = 0.
        FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCCaja.FchDoc NO-LOCK NO-ERROR.
        IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.compra.
        IF CcbCCaja.ImpUsa[2] > 0 THEN DO:
            x-codcbd = '32'.
            x-codcta = cb-cfgcja.codcta2[2].
            x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(x-Coddiv, 2, CcbCCaja.ImpUsa[2], '', "", CcbCCaja.Voucher[2], x-fchvto, CcbCCaja.TpoCmb).
        END.
        IF CcbCCaja.ImpUsa[3] > 0 THEN DO:
            x-codcbd = '32'.
            x-codcta = cb-cfgcja.codcta2[3].       
            x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(x-Coddiv, 2, CcbCCaja.ImpUsa[3], '', "", CcbCCaja.Voucher[3], CcbCCaja.FchVto[3], CcbCCaja.TpoCmb).
        END.
        IF CcbCCaja.ImpUsa[4] > 0 THEN DO:
            x-codcta = cb-cfgcja.codcta2[4].
            x-codaux = ''.
            x-codcbd = ''.
            x-glodoc = 'Canc-Tarjeta-Credito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            /* BUSCAMOS DATOS EL LA CUENTA */
            FIND FIRST CB-CTAS WHERE
                CB-CTAS.codcia = cb-codcia AND
                CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
            IF AVAILABLE CB-CTAS THEN x-codcbd = cb-ctas.Coddoc.
            FIND FacTabla WHERE
                FacTabla.CodCia = s-CodCia AND
                FacTabla.Tabla = "TC" AND
                FacTabla.Codigo = SUBSTRING(CcbCCaja.Voucher[9],1,2)
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla THEN x-codaux = STRING(FacTabla.Valor[1],"99999999").
            RUN proc_Graba-Caja(x-Coddiv, 2, CcbCCaja.ImpUsa[4], '', x-codaux, CcbCCaja.Voucher[4], x-fchvto, x-tpocmb).
        END.
        IF CcbCCaja.ImpUsa[5] > 0 THEN DO:
            x-codcbd = '34'.
            x-glodoc = 'Canc-Deposito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            FIND ccbcdocu WHERE
                ccbcdocu.CodCia = S-CodCia AND
                ccbcdocu.CodDoc = "BD" AND
                ccbcdocu.CodCli = CcbCCaja.Codcli AND
                ccbcdocu.nrodoc = CcbCCaja.Voucher[5]
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbcdocu THEN DO:
                MESSAGE
                    'Depósito no se encuentra registrado ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[5] 
                    VIEW-AS ALERT-BOX WARNING.
            END.
            ELSE DO:
                x-codcbd = '34'.
                x-codcta = '12211110'.
                RUN proc_Graba-Caja(ccbcdocu.coddiv, 2, CcbCCaja.ImpUsa[5], '@CLI', ccbcdocu.CodCli, CcbCCaja.Voucher[5], x-fchvto, CcbCCaja.TpoCmb).
            END.
        END.
        /* Nota de Crédito */
        IF CcbCCaja.ImpUsa[6] > 0 THEN DO:
            x-codcta = cb-cfgcja.codcta2[6].
            x-codcbd = '07'.
            x-glodoc = 'Canc-N/C' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            /* Aplicación Notas de Créditos */
            FOR EACH CCBDMOV WHERE
                CCBDMOV.CodCia = CcbCCaja.CodCia AND
                CCBDMOV.CodDiv = CcbCCaja.CodDiv AND
                CCBDMOV.CodRef = CcbCCaja.coddoc AND
                CCBDMOV.NroRef = CcbCCaja.nrodoc NO-LOCK:
                IF CCBDMOV.CodDoc <> "N/C" OR CCBDMOV.CodMon <> 2 THEN NEXT.   /* N/C en Dolares */
                FIND FIRST CcbCDocu WHERE
                    CcbCDocu.CodCia = CCBDMOV.CodCia AND
                    CcbCDocu.CodCli = CCBDMOV.CodCli AND
                    CcbCDocu.CodDoc = CCBDMOV.CodDoc AND
                    CcbCDocu.NroDoc = CCBDMOV.NroDoc
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE CcbCDocu THEN DO:
                    MESSAGE
                        'Nota de Crédito no existe ' + CcbCCaja.Codcli + ' ' + CCBDMOV.NroDoc SKIP
                        Ccbccaja.coddoc Ccbccaja.nrodoc
                        VIEW-AS ALERT-BOX ERROR.
                    NEXT.
                END.
                IF ccbcdocu.CodCli BEGINS "11111111" THEN x-codaux = "11111111111".
                ELSE x-codaux = ccbcdocu.CodCli.
                RUN proc_Graba-Caja(ccbcdocu.coddiv, 2, CCBDMOV.ImpTot, '@CLI', x-codaux, CCBDMOV.NroDoc, x-fchvto, CcbCCaja.TpoCmb).
            END.
        END.
        /* Anticipos */
        IF CcbCCaja.ImpUsa[7] > 0 THEN DO:
            x-codcta = cb-cfgcja.codcta2[7].
            x-codcbd = '34'.
            x-glodoc = 'Canc-Anticip' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            FIND FIRST CcbCDocu WHERE
                CcbCDocu.CodCia = s-codcia AND
                CcbCDocu.CodCli = CcbCCaja.Codcli AND
                CcbCDocu.CodDoc = 'A/R' AND
                CcbCDocu.NroDoc = CcbCCaja.Voucher[7]
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CcbCDocu THEN DO:
                MESSAGE
                    'Anticipo no existe ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[7]
                    VIEW-AS ALERT-BOX ERROR.
            END.
            IF AVAILABLE ccbcdocu THEN DO:
                x-codcbd = '34'.
                RUN proc_Graba-Caja(ccbcdocu.coddiv, 2, CcbCCaja.ImpUsa[7], '@CLI', ccbcdocu.CodCli, CcbCCaja.Voucher[7], x-fchvto, CcbCCaja.TpoCmb).
            END.
        END.
        /* Comisiones Factoring */
        IF CcbCCaja.ImpUsa[8] > 0 THEN DO:
            x-codcbd = '32'.
            x-codcta = cb-cfgcja.codcta2[8].
            x-glodoc = 'Comisiones Factoring' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(CcbCCaja.CodDiv, 2, CcbCCaja.ImpUsa[8], '', "", CcbCCaja.Voucher[8], x-fchvto, CcbCCaja.TpoCmb).
        END.
        /* Retenciones */
        IF CcbCCaja.ImpUsa[9] > 0 THEN DO:
            x-codcbd = '20'.
            x-codcta = cb-cfgcja.codcta2[9].
            x-glodoc = 'Retenciones' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(CcbCCaja.CodDiv, 2, CcbCCaja.ImpUsa[9], '', "", CcbCCaja.Voucher[9], x-fchvto, CcbCCaja.TpoCmb).
        END.
        /* Vales Consumo */
        IF CcbCCaja.ImpUsa[10] > 0 THEN DO:
            x-codcbd = '32'.
            x-codcta = cb-cfgcja.codcta2[10].
            x-glodoc = 'Vales Consumo' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
            RUN proc_Graba-Caja(CcbCCaja.CodDiv, 2, CcbCCaja.ImpUsa[10], '', "", '', x-fchvto, CcbCCaja.TpoCmb).
        END.

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

DEFINE VAR p-codcia  AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-codope  AS CHAR NO-UNDO.
DEFINE VAR p-nroast  AS CHAR NO-UNDO.
DEFINE VAR x-nroast  AS INTE NO-UNDO.
DEFINE VAR p-fchast  AS DATE NO-UNDO.
DEFINE VAR d-uno     AS DECI NO-UNDO.
DEFINE VAR d-dos     AS DECI NO-UNDO.
DEFINE VAR h-uno     AS DECI NO-UNDO.
DEFINE VAR h-dos     AS DECI NO-UNDO.
DEFINE VAR x-clfaux  AS CHAR NO-UNDO.
DEFINE VAR x-genaut  AS INTE NO-UNDO.
DEFINE VAR I         AS INTE NO-UNDO.
DEFINE VAR J         AS INTE NO-UNDO.
DEFINE VAR x-coddoc  AS LOGI NO-UNDO.

DEFINE BUFFER detalle FOR CB-DMOV.

p-codcia  = s-codcia.
p-periodo = INTEGER(x-periodo).
p-mes     = INTEGER(x-nromes).

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
   BELL.
   MESSAGE "No se ha generado " SKIP "ning£n preasiento" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   BELL.
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.
FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                   Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-Divi THEN DO:
   BELL.
   MESSAGE "Division No existe" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* Limpio la informaci¢n de los movimientos transferidos anteriormente
   a contabilidad                                                   */
FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia AND
    cb-control.CodDiv  = F-DIVISION AND
    cb-control.Periodo = p-Periodo AND
    cb-control.NroMes  = p-Mes AND
    cb-control.Tipo    = s-Tipo:
    FIND cb-cmov WHERE cb-cmov.codcia  = cb-control.codcia AND
        cb-cmov.coddiv  = cb-control.coddiv AND
        cb-cmov.PERIODO = cb-control.periodo AND
        cb-cmov.NROMES  = cb-control.nromes AND
        cb-cmov.CODOPE  = cb-control.codope AND
        cb-cmov.NroAst  = cb-control.nroast
        NO-ERROR.
    IF AVAILABLE cb-cmov THEN DO:
        RUN anula-asto(
            cb-cmov.codcia,
            cb-cmov.periodo,
            cb-cmov.nromes,
            cb-cmov.codope,
            cb-cmov.nroast ).
    END.
END.
/* RHC 20/11/2015 UN SOLO ASIENTO PARA TODOS LOS CIERRES DE CAJA */
FOR EACH t-prev, FIRST cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia 
    AND cb-ctas.codcta = t-prev.codcta 
    BREAK BY t-prev.Tipo:
    IF FIRST-OF(T-Prev.Tipo) THEN DO:
        /* RHC 04.05.2012 LA OPERACION ES UNICA POR CADA USARIO Y FECHA CIERRE DE CAJA */
        p-CodOpe = x-CodOpe.
        /* Verifico si el movimiento se realiz¢ anteriormente */
        FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
            cb-control.Coddiv  = F-DIVISION AND
            cb-control.tipo    = s-Tipo AND
            cb-control.periodo = p-Periodo AND
            cb-control.nromes  = p-Mes AND
            cb-control.tipmov  = t-prev.tipo
            NO-ERROR.
        /* ****************************************************** */
        IF AVAILABLE cb-control THEN DO:
           ASSIGN
              p-nroast = cb-control.Nroast.
        END.
        ELSE DO:
           RUN cbd/cbdnast.p(cb-codcia,
                             p-codcia, 
                             p-periodo, 
                             p-Mes, 
                             p-codope, 
                             OUTPUT x-nroast). 
           p-nroast = STRING(x-nroast, '999999').
           CREATE cb-control.
        END.
        ASSIGN
           cb-control.tipo    = s-Tipo
           cb-control.CodCia  = p-codcia
           cb-control.Periodo = p-periodo
           cb-control.Nromes  = p-mes 
           cb-control.fchpro  = t-prev.fchdoc
           cb-control.Codope  = p-Codope
           cb-control.Nroast  = p-nroast
           cb-control.coddiv  = F-DIVISION            /* t-prev.coddiv. */
           cb-control.tipmov  = t-prev.tipo.
       /* ****************************************************** */
       ASSIGN
          cb-control.Usuario = s-user-id
          cb-control.Hora    = STRING(TIME,'HH:MM:SS')
          cb-control.fecha   = TODAY.
       d-uno  = 0.
       d-dos  = 0.
       h-uno  = 0.
       h-dos  = 0.
    END.
    ASSIGN
        x-clfaux = cb-ctas.clfaux
        x-coddoc = cb-ctas.piddoc.
    IF t-prev.impmn1 > 0 OR t-prev.impmn2 > 0 THEN DO:
        J = J + 1.
        CREATE CB-DMOV.
        CB-DMOV.codcia  = p-codcia.
        CB-DMOV.PERIODO = p-periodo.
        CB-DMOV.NROMES  = p-mes.
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
        CB-DMOV.FCHVTO  = IF t-prev.fchvto = ? THEN t-prev.fchdoc ELSE t-prev.fchvto.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = t-prev.codmon.
        CB-DMOV.tpocmb  = t-prev.tpocmb.
        cb-dmov.C-FCaja = "12".
/*MLR-1*/ cb-dmov.codref = t-prev.codref.
/*MLR-1*/ cb-dmov.nroref = t-prev.nroref.
        RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
        IF CB-DMOV.tpomov THEN DO:
            h-uno = h-uno + CB-DMOV.impmn1.
            h-dos = h-dos + CB-DMOV.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.

        /* Cargamos la tabla temporal */
        cb-dmov.C-FCaja = "12".

        x-GenAut = 0.
        /* Preparando para Autom ticas */
        /* Verificamos si la Cuenta genera automaticas de Clase 9 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                    x-GenAut = 1.
                    LEAVE.
                END.
            END.
        END.
        /* Verificamos si la Cuenta genera automaticas de Clase 6 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                    x-GenAut = 2.
                    LEAVE.
                END.
           END.
        END.
        /* Verificamos si la Cuenta genera automaticas de otro tipo */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                    x-GenAut = 3.
                    LEAVE.
                END.
           END.
        END.
        cb-dmov.CtaAut = "".
        cb-dmov.CtrCta = "".
        CASE x-GenAut:
            /* Genera Cuentas Clase 9 */
            WHEN 1 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
            END.
            /* Genera Cuentas Clase 6 */
            WHEN 2 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN
                    cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
            END.
            WHEN 3 THEN DO:
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            END.
        END CASE.
        /* Chequendo las cuentas a generar en forma autom tica */
        IF x-GenAut > 0 THEN DO:
            IF NOT CAN-FIND(FIRST cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtaAut = "".
            END.
            IF NOT CAN-FIND( cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtrCta = "".
            END.
        END. /*Fin del x-genaut > 0 */
        IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.CtaAut.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = cb-dmov.TpoMov.
/*MLR-1*/   detalle.CodRef   = cb-dmov.CodRef.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            detalle.C-FCaja  = cb-dmov.C-FCaja.

            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.Ctrcta.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = NOT cb-dmov.TpoMov.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
/*MLR-1*/   detalle.CodRef   = cb-dmov.CodRef.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            detalle.C-FCaja  = cb-dmov.C-FCaja.            
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
    END.
    IF LAST-OF(t-prev.Tipo) THEN DO:
       FIND cb-cmov WHERE
           cb-cmov.codcia  = p-codcia AND
           cb-cmov.PERIODO = p-periodo AND
           cb-cmov.NROMES  = p-mes AND
           cb-cmov.CODOPE  = p-codope AND
           cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
           CREATE cb-cmov.
           cb-cmov.codcia  = p-codcia.
           cb-cmov.PERIODO = p-periodo.
           cb-cmov.NROMES  = p-mes.
           cb-cmov.CODOPE  = p-codope.
           cb-cmov.NROAST  = p-nroast. 
       END.
       cb-cmov.Coddiv = F-DIVISION.         /* t-prev.coddiv. */
       cb-cmov.Fchast = t-prev.FchDoc.
       cb-cmov.TOTITM = J.
       cb-cmov.CODMON = 1.
       cb-cmov.TPOCMB = x-Tpocmb.
       cb-cmov.FlgEst = "".
       cb-cmov.DBEMN1 = d-uno.
       cb-cmov.DBEMN2 = d-dos.
       cb-cmov.HBEMN1 = h-uno.
       cb-cmov.HBEMN2 = h-dos.
       cb-cmov.NOTAST = 'CIERRE DE CAJA TIENDA ' + F-DIVISION + "-" + Gn-Divi.DesDiv.
       cb-cmov.GLOAST = 'CIERRE DE CAJA TIENDA ' + F-DIVISION + "-" + Gn-Divi.DesDiv.
    END.
END.
MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

