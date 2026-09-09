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
DEFINE SHARED VAR s-coddiv  AS CHAR.

DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE NEW SHARED VARIABLE S-TIPO      AS CHAR INITIAL "@N/BM".

DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.

DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov
    FIELD Tipo   AS CHAR
    FIELD fchvta AS DATE
    FIELD fchast LIKE cb-cmov.fchast.

/* DEFINE NEW SHARED TEMP-TABLE t-prev    */
/*     FIELD Tipo   AS CHAR               */
/*     FIELD Banco   LIKE cb-dmov.CodBco  */
/*     FIELD Periodo LIKE cb-dmov.periodo */
/*     FIELD NroMes LIKE cb-dmov.nromes   */
/*     FIELD Codope LIKE cb-dmov.codope   */
/*     FIELD Codcta LIKE cb-dmov.codcta   */
/*     FIELD CodDiv LIKE cb-dmov.coddiv   */
/*     FIELD Codmon LIKE cb-dmov.codmon   */
/*     FIELD Fchdoc LIKE cb-dmov.fchdoc   */
/*     FIELD Fchvta LIKE cb-dmov.fchvto   */
/*     FIELD Coddoc LIKE cb-dmov.coddoc   */
/*     FIELD Nrodoc LIKE cb-dmov.nrodoc   */
/*     FIELD Codref LIKE cb-dmov.Codref   */
/*     FIELD Nroref LIKE cb-dmov.nroref   */
/*     FIELD Glodoc LIKE cb-dmov.glodoc   */
/*     FIELD Tpocmb LIKE cb-dmov.tpocmb   */
/*     FIELD TpoMov LIKE cb-dmov.tpomov   */
/*     FIELD ImpMn1 LIKE cb-dmov.impmn1   */
/*     FIELD ImpMn2 LIKE cb-dmov.impmn2   */
/*     FIELD clfaux LIKE cb-dmov.Clfaux   */
/*     FIELD codaux LIKE cb-dmov.Codaux   */
/*     INDEX IDX01 Tipo.                  */

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR x-tpocmb AS DECI NO-UNDO.
DEFINE VAR x-list   AS CHAR INITIAL '' NO-UNDO.
/*DEFINE VAR x-Mes    AS INTEGER NO-UNDO.*/

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE VARIABLE cCodOpe LIKE FacDocum.CodOpe NO-UNDO.
DEFINE VARIABLE lTpoDoc LIKE FacDocum.TpoDoc NO-UNDO.
DEFINE VARIABLE cCodCbd LIKE FacDocum.CodCbd NO-UNDO.
DEFINE VARIABLE cCodCta LIKE FacDocum.CodCta NO-UNDO.
DEFINE VARIABLE cCodCtab LIKE FacDocum.CodCta NO-UNDO.

FIND FacDocum WHERE
    FacDocum.CodCia = s-codcia AND
    FacDocum.CodDoc = 'LET' NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE
        'Documento LETRA NO ESTA CONFIGURADO en el sistema'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

lTpoDoc = NOT FacDocum.TpoDoc.
cCodCbd = FacDocum.CodCbd.
cCodOpe = FacDocum.CodOpe.
cCodCta[1] = FacDocum.CodCta[1].    /* Cuenta Soles */
cCodCta[2] = FacDocum.CodCta[2].    /* Cuenta Dólares */
/* Cuentas Fijas de Banco */
cCodCtab[1] = "12311100".             /* Cuenta Soles */
cCodCtab[2] = "12311110".             /* Cuenta Dólares */
/* Operación */
cCodOpe = "064".

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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes B-Pre_Asto BUTTON-1 ~
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
     B-Pre_Asto AT ROW 2.35 COL 64
     B-Transferir AT ROW 2.35 COL 72
     BUTTON-1 AT ROW 2.35 COL 80 WIDGET-ID 22
     f-Division AT ROW 3.12 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Tpocmb AT ROW 3.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-TcCompra AT ROW 3.5 COL 42.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "T.C.Compra" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 44.72 WIDGET-ID 16
     "T.C.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 32.57 WIDGET-ID 14
     "Fecha de Proceso" VIEW-AS TEXT
          SIZE 13.43 BY .5 AT ROW 1.38 COL 36 WIDGET-ID 12
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "CUENTAS   POR   COBRAR" VIEW-AS TEXT
          SIZE 25.43 BY .85 AT ROW 1.38 COL 62
          FONT 12
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIENTO CONTABLE DE COBRANZA DE LETRAS x N/B (MENSUAL)"
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
ON END-ERROR OF W-Win /* ASIENTO CONTABLE DE COBRANZA DE LETRAS x N/B (MENSUAL) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIENTO CONTABLE DE COBRANZA DE LETRAS x N/B (MENSUAL) */
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
        F-Division x-Periodo x-NroMes.
        
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


&Scoped-define SELF-NAME FILL-IN-fchast-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fchast-2 W-Win
ON LEAVE OF FILL-IN-fchast-2 IN FRAME F-Main
DO:
    ASSIGN
       FILL-IN-fchast-2.
    p-periodo = YEAR(FILL-IN-fchast-2).
    p-mes     = MONTH(FILL-IN-fchast-2).
    FIND gn-tcmb WHERE gn-tcmb.fecha = FILL-IN-fchast-2 NO-LOCK NO-ERROR.
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
  APPLY 'LEAVE':U TO FILL-IN-fchast-2.
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
  APPLY 'LEAVE':U TO FILL-IN-fchast-2.
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

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ccbcbd ,
             FILL-IN-TcCompra:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE T-PREV.        
    DEF VAR pTpoCmb LIKE Ccbcdocu.TpoCmb NO-UNDO.
    DEF VAR lBancoResumido AS LOG NO-UNDO.

    FOR EACH CcbCMvto NO-LOCK WHERE CcbCMvto.CodCia = s-codcia 
        AND CcbCMvto.CodDoc = "N/B" 
        AND CcbCMvto.CodDiv = f-Division 
        AND CcbCMvto.FchCbd >= FILL-IN-fchast-1
        AND CcbCMvto.FchCbd <= FILL-IN-fchast-2,
        EACH CcbDCaja WHERE CcbDCaja.CodCia = CcbCMvto.CodCia 
        AND CcbDCaja.CodDoc = CcbCMvto.CodDoc 
        AND CcbDCaja.NroDoc = CcbCMvto.NroDoc,
        FIRST CcbCDocu WHERE CcbCDocu.CodCia = CcbDCaja.CodCia 
        AND CcbCDocu.CodDoc = CcbDCaja.CodRef 
        AND CcbCDocu.NroDoc = CcbDCaja.NroRef
        BREAK BY CcbCMvto.NroDoc:
        DISPLAY
            "  Procesando Letra: " + ccbdcaja.nroref @
            Fi-Mensaje
            WITH FRAME F-Proceso.

        IF FIRST-OF(CcbCMvto.NroDoc) THEN DO:
            pTpoCmb = ccbcmvto.TpoCmb.
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCMvto.FchCbd NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN pTpoCmb = gn-tcmb.venta.
            /* Banco: Definimos si la cuenta del banco es al detalle o resumida */
            lBancoResumido = YES.   /* Por defecto */
            FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
                AND cb-ctas.codcta = CcbCMvto.CodCta
                NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas AND cb-ctas.pidaux = YES AND cb-ctas.piddoc THEN lBancoResumido = NO.
            /* Cuenta del Banco (104 ó 455) */
            IF lBancoResumido = YES THEN DO:
                RUN Graba-Letra(
                    Ccbcmvto.fchcbd,
                    CcbCMvto.CodCta,
                    ccbcmvto.FchDoc,
                    pTpoCmb,        /*ccbcdocu.TpoCmb,*/
                    ccbcdocu.nomcli,
                    ccbcdocu.codcli,
                    lTpoDoc,
                    CcbCMvto.Imptot).
            END.
            /* Importe Egresos -> Cuenta Egresos */
            IF CcbCMvto.Libre_dec[2] <> 0 THEN DO:
                RUN Graba-Letra(
                    Ccbcmvto.fchcbd,
                    CcbCMvto.Libre_chr[2],
                    ccbcmvto.FchDoc,
                    pTpoCmb,        /*ccbcmvto.TpoCmb,*/
                    ccbcdocu.nomcli,
                    ccbcdocu.codcli,
                    lTpoDoc,
                    CcbCMvto.Libre_dec[2]).
            END.
            /* Importe Ingresos -> Cuenta Ingresos */
            IF CcbCMvto.Libre_dec[1] <> 0 THEN DO:
                RUN Graba-Letra(
                    Ccbcmvto.fchcbd,
                    CcbCMvto.Libre_chr[1],
                    ccbcmvto.FchDoc,
                    pTpoCmb,        /*ccbcmvto.TpoCmb,*/
                    ccbcdocu.nomcli,
                    ccbcdocu.codcli,
                    NOT lTpoDoc,
                    CcbCMvto.Libre_dec[1]).
            END.
        END.
        /* Letras */
        RUN Graba-Letra(
            Ccbcmvto.fchcbd,
            cCodCtab[ccbcmvto.CodMon],
            ccbcmvto.FchDoc,
            pTpoCmb,        /*ccbcmvto.TpoCmb,*/
            ccbcdocu.nomcli,
            ccbcdocu.codcli,
            NOT lTpoDoc,
            ccbdcaja.Imptot).
        /* De acuerdo a la cuenta dle banco va al detalle */
        IF lBancoResumido = NO THEN DO:
            RUN Graba-Letra(
                Ccbcmvto.fchcbd,
                CcbCMvto.CodCta,
                ccbcmvto.FchDoc,
                pTpoCmb,        /*ccbcdocu.TpoCmb,*/
                ccbcdocu.nomcli,
                ccbcdocu.codcli,
                lTpoDoc,
                ccbdcaja.Imptot).
        END.
    END.

    RUN dispatch IN h_b-ccbcbd ('open-query':U).
    RUN Totales IN h_b-ccbcbd.

    HIDE FRAME F-Proceso NO-PAUSE.

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
  ENABLE x-Periodo x-NroMes B-Pre_Asto BUTTON-1 f-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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


DEFINE INPUT PARAMETER PARAM_fchast AS DATE.
DEFINE INPUT PARAMETER param_codcta AS CHARACTER.
DEFINE INPUT PARAMETER param_fchdoc LIKE ccbcmvto.FchDoc.
DEFINE INPUT PARAMETER param_TpoCmb LIKE ccbcmvto.TpoCmb.
DEFINE INPUT PARAMETER param_NomCli LIKE ccbcdocu.NomCli.
DEFINE INPUT PARAMETER para_CodCli LIKE ccbcdocu.codcli.
DEFINE INPUT PARAMETER para_TpoDoc AS LOGICAL.
DEFINE INPUT PARAMETER para_imptot AS DECIMAL.

/* RHC Parche por tpocmb de referencia */
    FIND FIRST t-prev WHERE
        t-prev.coddiv = ccbdcaja.Coddiv AND
        t-prev.coddoc = cCodCbd AND
        t-prev.nrodoc = ccbdcaja.Nrodoc AND
        t-prev.codcta = param_codcta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-prev THEN DO:
        CREATE t-prev.
        ASSIGN
            t-prev.fchast  = PARAM_fchast
            t-prev.periodo = p-periodo
            t-prev.nromes  = p-mes
            t-prev.codope  = cCodOpe
            t-prev.coddiv  = ccbdcaja.CodDiv 
            t-prev.codcta  = param_codcta
            t-prev.fchdoc  = param_Fchdoc
            t-prev.tpomov  = para_TpoDoc
            t-prev.clfaux  = '@CL'
            t-prev.codaux  = para_CodCli
            t-prev.codmon  = ccbcmvto.CodMon
            t-prev.coddoc  = cCodCbd
            t-prev.nrodoc  = ccbdcaja.nroref
            t-prev.nroref  = ccbdcaja.nrodoc    /* de la N/B */
            t-prev.Tpocmb  = param_TpoCmb
            t-prev.glodoc  = param_NomCli.
    END.

    IF ccbcmvto.CodMon = 1 THEN
        ASSIGN t-prev.impmn1 = t-prev.impmn1 + para_imptot.
    ELSE
        ASSIGN
            t-prev.impmn2 = t-prev.impmn2 + para_imptot
            t-prev.impmn1 = t-prev.impmn1 + ROUND((para_imptot * t-prev.Tpocmb),2).

    RELEASE t-prev.

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

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
    BELL.
    MESSAGE
        "Plan de cuentas no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FOR EACH cb-control WHERE
    cb-control.CodCia = s-codcia AND
    cb-control.Coddiv = f-Division AND
    cb-control.tipo   = s-Tipo AND
    cb-control.periodo = p-periodo AND
    cb-control.nromes = p-mes NO-LOCK:
    FIND cb-cmov WHERE
        cb-cmov.codcia  = s-codcia AND
        cb-cmov.periodo = cb-control.periodo AND
        cb-cmov.nromes  = cb-control.nromes AND
        cb-cmov.codope  = cb-control.codope AND
        cb-cmov.nroast  = cb-control.nroast NO-ERROR.
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
        p-periodo,
        p-Mes,
        cb-control.codope,
        cb-control.nroast ).
END.

FOR EACH t-prev BREAK BY t-prev.fchast BY t-prev.nroref:
    IF FIRST-OF(t-prev.fchast) OR FIRST-OF(t-prev.nroref) THEN DO:
        /* Verifica si el movimiento se realizó anteriormente */
        FIND cb-control WHERE
            cb-control.CodCia  = s-codcia AND
            cb-control.Coddiv  = t-prev.coddiv AND
            cb-control.tipo    = s-Tipo AND
            cb-control.tipmov  = t-prev.nroref AND
            cb-control.fchpro  = t-prev.fchast 
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
                p-Periodo,
                p-Mes,
                p-codope,
                OUTPUT x-nroast).
            p-nroast = STRING(x-nroast, '999999').
            CREATE cb-control.
            ASSIGN
                cb-control.CodCia  = s-codcia
                cb-control.Coddiv  = t-prev.coddiv
                cb-control.tipo    = s-Tipo
                cb-control.tipmov  = t-prev.nroref
                cb-control.fchpro  = t-prev.fchast
                cb-control.Periodo = p-Periodo
                cb-control.Nromes  = p-Mes 
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
        CB-DMOV.PERIODO = p-Periodo.
        CB-DMOV.NROMES  = p-Mes.
        CB-DMOV.CODOPE  = p-codope.
        CB-DMOV.NROAST  = p-nroast.
        CB-DMOV.NROITM  = J.
        CB-DMOV.codcta  = t-prev.codcta.
        CB-DMOV.coddiv  = t-prev.coddiv.
        Cb-dmov.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        Cb-dmov.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        Cb-dmov.NroRef  = t-prev.nroref.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        CB-DMOV.GLODOC  = t-prev.glodoc.
        CB-DMOV.tpomov  = t-prev.tpomov.
        CB-DMOV.impmn1  = t-prev.impmn1.
        CB-DMOV.impmn2  = t-prev.impmn2.
        CB-DMOV.FCHDOC  = t-prev.fchdoc.
        CB-DMOV.FCHVTO  = t-prev.fchdoc.
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

        /* Cargamos la tabla temporal */
/*         CREATE T-CB-DMOV.                                                 */
/*         T-CB-DMOV.codcia  = s-codcia.                                     */
/*         T-CB-DMOV.PERIODO = FILL-IN-periodo.                              */
/*         T-CB-DMOV.NROMES  = X-Mes.                                        */
/*         T-CB-DMOV.CODOPE  = p-codope.                                     */
/*         T-CB-DMOV.NROAST  = p-nroast.                                     */
/*         T-CB-DMOV.NROITM  = J.                                            */
/*         T-CB-DMOV.codcta  = t-prev.codcta.                                */
/*         T-CB-DMOV.coddiv  = t-prev.coddiv.                                */
/*         T-CB-DMOV.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.       */
/*         T-CB-DMOV.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.       */
/*         T-CB-DMOV.NroRef  = t-prev.nroref.                                */
/*         T-CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.      */
/*         T-CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''. */
/*         T-CB-DMOV.GLODOC  = t-prev.glodoc.                                */
/*         T-CB-DMOV.tpomov  = t-prev.tpomov.                                */
/*         T-CB-DMOV.impmn1  = t-prev.impmn1.                                */
/*         T-CB-DMOV.impmn2  = t-prev.impmn2.                                */
/*         T-CB-DMOV.FCHDOC  = t-prev.fchdoc.                                */
/*         T-CB-DMOV.FCHVTO  = t-prev.fchdoc.                                */
/*         T-CB-DMOV.FLGACT  = TRUE.                                         */
/*         T-CB-DMOV.RELACION = 0.                                           */
/*         T-CB-DMOV.codmon  = t-prev.codmon.                                */
/*         T-CB-DMOV.tpocmb  = t-prev.tpocmb.                                */
    END.
    IF LAST-OF(t-prev.fchast) OR LAST-OF(t-prev.nroref) THEN DO:
        FIND cb-cmov WHERE
            cb-cmov.codcia  = s-codcia AND
            cb-cmov.PERIODO = p-Periodo AND
            cb-cmov.NROMES  = p-Mes AND
            cb-cmov.CODOPE  = p-codope AND
            cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
            CREATE cb-cmov.
            cb-cmov.codcia  = s-codcia.
            cb-cmov.PERIODO = p-Periodo.
            cb-cmov.NROMES  = p-Mes.
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
        cb-cmov.GLOAST = "N/B: " + t-prev.nroref.
    END.
END.
MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

