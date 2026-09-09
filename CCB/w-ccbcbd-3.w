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
DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.

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
DEFINE VAR x-Mes    AS INTEGER NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-42 B-Pre_Asto FILL-IN-division ~
FILL-IN-fchast 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-division FILL-IN-fchast ~
FILL-IN-periodo 

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
DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\b-print":U
     LABEL "Button 1" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Pre_Asto 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 5" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Transferir 
     IMAGE-UP FILE "img\climnu1":U
     LABEL "Transferir Asiento" 
     SIZE 6.43 BY 1.62.

DEFINE VARIABLE FILL-IN-division AS CHARACTER FORMAT "X(5)":U INITIAL "00000" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast AS DATE FORMAT "99/99/99":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     B-Pre_Asto AT ROW 2.42 COL 64
     B-Transferir AT ROW 2.42 COL 72.14
     B-Imprimir AT ROW 2.42 COL 80.29
     FILL-IN-division AT ROW 3.12 COL 33 NO-LABEL
     FILL-IN-fchast AT ROW 3.12 COL 39 COLON-ALIGNED NO-LABEL
     FILL-IN-periodo AT ROW 3.12 COL 50 COLON-ALIGNED NO-LABEL
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "Periodo" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 2.54 COL 52.14
     "División" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.54 COL 33
     "Fecha Asiento" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 2.54 COL 41
     "CUENTAS   POR   COBRAR" VIEW-AS TEXT
          SIZE 25.43 BY .85 AT ROW 1.19 COL 33
          FONT 12
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 4.15 COL 80.86
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     RECT-42 AT ROW 2.35 COL 31
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
         TITLE              = "Generacion de Asiento Contable (Cobranza de Letras en Banco)"
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
/* SETTINGS FOR BUTTON B-Imprimir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-division IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-periodo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Asiento Contable (Cobranza de Letras en Banco) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Asiento Contable (Cobranza de Letras en Banco) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-Win
ON CHOOSE OF B-Imprimir IN FRAME F-Main /* Button 1 */
DO:
  RUN Pre-impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Pre_Asto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Pre_Asto W-Win
ON CHOOSE OF B-Pre_Asto IN FRAME F-Main /* Button 5 */
DO:

    ASSIGN
        FILL-IN-division
        FILL-IN-fchast
        FILL-IN-periodo:SCREEN-VALUE = "0000".

    FIND Gn-Divi WHERE
        Gn-Divi.Codcia = S-CODCIA AND
        Gn-Divi.Coddiv = FILL-IN-division
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE
            "División " + FILL-IN-division + " no Existe" SKIP
            "Verifique Por Favor..."
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-division IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    IF FILL-IN-fchast = ? THEN DO:
        MESSAGE
            "Ingrese la Fecha del Asiento"
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-fchast IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    x-mes = MONTH(FILL-IN-fchast).
    FILL-IN-periodo = YEAR(FILL-IN-fchast).
    DISPLAY FILL-IN-periodo WITH FRAME {&FRAME-NAME}.

    FIND cb-peri WHERE
        cb-peri.CodCia = s-codcia AND
        cb-peri.Periodo = FILL-IN-periodo NO-LOCK.
    IF AVAILABLE cb-peri THEN
        s-NroMesCie = cb-peri.MesCie[x-mes + 1].
    IF s-NroMesCie THEN DO:
        MESSAGE "MES CERRADO!!!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    FIND FIRST cb-control WHERE
        cb-control.CodCia  = s-codcia AND
        cb-control.Coddiv  = FILL-IN-division AND
        cb-control.tipo    = '@CCB3' AND
        cb-control.fchpro  = FILL-IN-fchast NO-LOCK NO-ERROR.
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
        B-Imprimir:SENSITIVE = YES.
        RUN dispatch IN h_p-updv10 ('view':U).
    END.
    ELSE DO:
        B-Transferir:SENSITIVE = NO.
        B-Imprimir:SENSITIVE = NO.
        RUN dispatch IN h_p-updv10 ('hide':U).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:

    IF NOT CAN-FIND(FIRST t-prev) THEN RETURN NO-APPLY.
    RUN Transferir-asiento.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-division W-Win
ON LEAVE OF FILL-IN-division IN FRAME F-Main
DO:

    ASSIGN FILL-IN-division.

    IF FILL-IN-division = "" THEN RETURN NO-APPLY.

    IF FILL-IN-division <> "" THEN DO:
        FIND Gn-Divi WHERE
            Gn-Divi.Codcia = S-CODCIA AND
            Gn-Divi.Coddiv = FILL-IN-division
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE
                "División " + FILL-IN-division + " no Existe" SKIP
                "Verifique Por Favor..."
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN-division IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.    
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fchast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fchast W-Win
ON LEAVE OF FILL-IN-fchast IN FRAME F-Main
DO:

    ASSIGN FILL-IN-fchast.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-flag W-Win 
PROCEDURE Actualiza-flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     FOR EACH CcbCMvto WHERE                    */
/*         CcbCMvto.CodCia = s-codcia AND         */
/*         CcbCMvto.CodDoc = "N/B" AND            */
/*         CcbCMvto.CodDiv = FILL-IN-division AND */
/*         CcbCMvto.FchDoc = FILL-IN-fchast:      */
/*         ASSIGN                                 */
/*             CcbCMvto.FlgCbd = TRUE             */
/*             CcbCMvto.FchCbd = TODAY.           */
/*     END.                                       */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             FILL-IN-periodo:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

    FOR EACH t-prev NO-LOCK:
        IF t-prev.tpomov THEN dCargo = dCargo + t-prev.impmn1.
        ELSE dAbono = dAbono + t-prev.impmn1.
    END.

    IF dCargo - dAbono <> 0 THEN DO:

        CREATE t-prev.
        ASSIGN
            t-prev.tipo    = param_tipo
            t-prev.periodo = FILL-IN-periodo
            t-prev.nromes  = x-mes
            t-prev.codope  = cCodOpe
            t-prev.coddiv  = FILL-IN-division
            t-prev.codcta  =
               IF dCargo - dAbono > 0 THEN x-ctagan ELSE x-ctaper
            t-prev.fchdoc  = TODAY
            t-prev.tpomov  =
                IF dCargo - dAbono > 0 THEN FALSE ELSE TRUE
            t-prev.codmon  = 1
            t-prev.glodoc  = 'Ajuste por Dif.Cambio'
            t-prev.impmn1 = ABSOLUTE(dCargo - dAbono).
        
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

    FOR EACH t-prev:
        DELETE t-prev.
    END.

    FOR EACH CcbCMvto NO-LOCK WHERE
        CcbCMvto.CodCia = s-codcia AND
        CcbCMvto.CodDoc = "N/B" AND
        CcbCMvto.CodDiv = FILL-IN-division AND
        /*CcbCMvto.FchDoc = FILL-IN-fchast,*/
        CcbCMvto.FchCbd = FILL-IN-fchast,
        EACH CcbDCaja WHERE
        CcbDCaja.CodCia = CcbCMvto.CodCia AND
        CcbDCaja.CodDoc = CcbCMvto.CodDoc AND
        CcbDCaja.NroDoc = CcbCMvto.NroDoc,
        FIRST CcbCDocu WHERE
        CcbCDocu.CodCia = CcbDCaja.CodCia AND
        CcbCDocu.CodDoc = CcbDCaja.CodRef AND
        CcbCDocu.NroDoc = CcbDCaja.NroRef
        BREAK BY CcbDCaja.NroDoc:

        DISPLAY
            "  Procesando Letra: " + ccbdcaja.nroref @
            Fi-Mensaje
            WITH FRAME F-Proceso.

        IF FIRST-OF(CcbDCaja.NroDoc) THEN DO:
            /* Banco */
            RUN Graba-Letra(
                CcbCMvto.CodCta,
                ccbcmvto.FchDoc,
                ccbcdocu.TpoCmb,
                ccbcdocu.nomcli,
                ccbcdocu.codcli,
                lTpoDoc,
                CcbCMvto.Imptot).
            IF CcbCMvto.Libre_dec[2] <> 0 THEN DO:
                RUN Graba-Letra(
                    CcbCMvto.Libre_chr[2],
                    ccbcmvto.FchDoc,
                    ccbcmvto.TpoCmb,
                    ccbcdocu.nomcli,
                    ccbcdocu.codcli,
                    lTpoDoc,
                    CcbCMvto.Libre_dec[2]).
            END.
            IF CcbCMvto.Libre_dec[1] <> 0 THEN DO:
                RUN Graba-Letra(
                    CcbCMvto.Libre_chr[1],
                    ccbcmvto.FchDoc,
                    ccbcmvto.TpoCmb,
                    ccbcdocu.nomcli,
                    ccbcdocu.codcli,
                    NOT lTpoDoc,
                    CcbCMvto.Libre_dec[1]).
            END.
        END.

        /* Letras */
        RUN Graba-Letra(
            cCodCtab[ccbcmvto.CodMon],
            ccbcmvto.FchDoc,
            ccbcmvto.TpoCmb,
            ccbcdocu.nomcli,
            ccbcdocu.codcli,
            NOT lTpoDoc,
            ccbdcaja.Imptot).

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
  DISPLAY FILL-IN-division FILL-IN-fchast FILL-IN-periodo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-42 B-Pre_Asto FILL-IN-division FILL-IN-fchast 
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER param_codcbd  AS CHAR.
    DEFINE INPUT PARAMETER param_codcta  AS CHAR.
    DEFINE INPUT PARAMETER param_tpomov  AS LOGICAL.
    DEFINE INPUT PARAMETER param_importe AS DECIMAL.
    DEFINE INPUT PARAMETER param_tipo    AS CHARACTER.

    FIND t-prev WHERE
        t-prev.coddiv = FILL-IN-division AND
        t-prev.coddoc = param_CodCbd AND 
        t-prev.nrodoc = ccbcdocu.Nrodoc AND
        t-prev.codcta = param_codcta AND
        t-prev.tpomov = param_tpomov
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-prev THEN DO:
        CREATE t-prev.
        ASSIGN
            t-prev.tipo    = param_tipo
            t-prev.periodo = FILL-IN-periodo
            t-prev.nromes  = x-mes
            t-prev.codope  = cCodOpe
            t-prev.coddiv  = FILL-IN-division
            t-prev.codcta  = param_codcta
            t-prev.fchdoc  = ccbcdocu.Fchdoc
            t-prev.tpomov  = param_tpomov
            t-prev.clfaux  = '@CL'
            t-prev.codaux  = ccbcdocu.CodCli
            t-prev.codmon  = ccbcdocu.codmon
            t-prev.coddoc  = param_CodCbd
            t-prev.nrodoc  = ccbcdocu.Nrodoc
            t-prev.Tpocmb  = ccbcdocu.TpoCmb
            t-prev.glodoc  = ccbcdocu.Nomcli.
    END.

    IF ccbcdocu.CodMon = 1 THEN
        ASSIGN t-prev.impmn1 = t-prev.impmn1 + param_importe.
    ELSE
        ASSIGN
            t-prev.impmn2 = t-prev.impmn2 + param_importe
            t-prev.impmn1 = t-prev.impmn1 + ROUND((param_importe * t-prev.Tpocmb),2).

    RELEASE t-prev.

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

    DEFINE INPUT PARAMETER param_codcta AS CHARACTER.
    DEFINE INPUT PARAMETER param_fchdoc LIKE ccbcmvto.FchDoc.
    DEFINE INPUT PARAMETER param_TpoCmb LIKE ccbcmvto.TpoCmb.
    DEFINE INPUT PARAMETER param_NomCli LIKE ccbcdocu.NomCli.
    DEFINE INPUT PARAMETER para_CodCli LIKE ccbcdocu.codcli.
    DEFINE INPUT PARAMETER para_TpoDoc AS LOGICAL.
    DEFINE INPUT PARAMETER para_imptot AS DECIMAL.

    FIND FIRST t-prev WHERE
        t-prev.coddiv = ccbdcaja.Coddiv AND
        t-prev.coddoc = cCodCbd AND
        t-prev.nrodoc = ccbdcaja.Nrodoc AND
        t-prev.codcta = param_codcta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-prev THEN DO:
        CREATE t-prev.
        ASSIGN
            t-prev.periodo = FILL-IN-periodo
            t-prev.nromes  = x-mes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-nroitm  AS INTEGER NO-UNDO.
DEFINE VAR x-debe    AS DECIMAL NO-UNDO.
DEFINE VAR x-haber   AS DECIMAL NO-UNDO.
DEFINE VAR x-dolares AS DECIMAL NO-UNDO.
DEFINE VAR x-nommes  AS CHAR    NO-UNDO.
DEFINE VAR x-opera   AS CHAR    NO-UNDO.
RUN bin/_mes.p(X-Mes, 1, OUTPUT x-nommes).

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" SKIP(1)
    {&PRN6A} + "CUENTAS POR COBRAR" + {&PRN6B} + {&PRND} AT 55 FORMAT "X(45)"
    "Fecha  : " AT 109 TODAY SKIP(1)
    "Operacion : " x-opera FORMAT 'X(40)' SKIP
    "Mes       : " x-nommes SPACE(10) SKIP
    "--------------------------------------------------------------------------------------------------------------------------------" SKIP
    "           CUENTA    CLF  CODIGO    COD.  NUMERO                                            TIP                S O L E S        " SKIP
    "DIVISION  CONTABLE   AUX AUXILIAR   DOC. DOCUMENTO   C O N C E P T O                    US$ MOV            DEBE          HABER  " SKIP
    "--------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-prev.coddiv  
    t-prev.codcta  
    t-prev.clfaux  
    t-prev.codaux
    t-prev.coddoc
    t-prev.nrodoc
    t-prev.glodoc
    x-dolares FORMAT ">>>,>>9.99" 
    t-prev.tpomov
    x-debe  FORMAT ">>>>,>>>,>>9.99" 
    x-haber FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

I-NroItm = 0.
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.coddiv:
    x-opera = ''.
    FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
         cb-oper.Codope = t-prev.codope NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN 
       x-opera = cb-oper.codope + ' - ' + cb-oper.Nomope.
    VIEW FRAME F-Header.
    IF FIRST-OF(t-prev.tipo) THEN  I-Nroitm = 0.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    x-dolares = t-prev.impmn2.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (TOTAL BY t-prev.tipo).
    ACCUMULATE x-haber (TOTAL BY t-prev.tipo).
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        t-prev.coddiv  
        t-prev.codcta  
        t-prev.clfaux  
        t-prev.codaux
        t-prev.coddoc
        t-prev.nrodoc
        t-prev.glodoc
        x-dolares 
        t-prev.tpomov
        x-debe  WHEN x-debe <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-Detalle.
    IF LAST-OF(t-prev.tipo) THEN DO:
        UNDERLINE 
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        DISPLAY 
            "        TOTAL "    @ t-prev.glodoc
            ACCUM TOTAL BY t-prev.tipo x-debe  @ x-debe
            ACCUM TOTAL BY t-prev.tipo x-haber @ x-haber
            WITH FRAME F-Detalle.
        PAGE.
    END.
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
        FILL-IN-fchast = TODAY.
        FILL-IN-periodo = YEAR(TODAY).
        DISPLAY FILL-IN-fchast FILL-IN-periodo.
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

FIND FIRST cb-control WHERE
    cb-control.CodCia  = s-codcia AND
    cb-control.Coddiv  = FILL-IN-division AND
    cb-control.tipo    = '@CCB3' AND
    cb-control.fchpro  = FILL-IN-fchast
    NO-LOCK NO-ERROR.
IF AVAILABLE cb-control THEN DO:
    MESSAGE
        "Asiento contable ya existe ¿Desea reemplazarlo?"
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN.
END.
FOR EACH cb-control WHERE
    cb-control.CodCia = s-codcia AND
    cb-control.Coddiv = FILL-IN-division AND
    cb-control.tipo   = '@CCB3' AND
    cb-control.fchpro = FILL-IN-fchast NO-LOCK:
    FIND cb-cmov WHERE
        cb-cmov.codcia  = s-codcia AND
        cb-cmov.periodo = FILL-IN-periodo AND
        cb-cmov.nromes  = x-mes AND
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
        FILL-IN-periodo,
        X-Mes,
        cb-control.codope,
        cb-control.nroast ).
END.

FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.coddiv:
    IF FIRST(t-prev.tipo) THEN DO:
        /* Verifica si el movimiento se realizó anteriormente */
        FIND cb-control WHERE
            cb-control.CodCia  = s-codcia AND
            cb-control.Coddiv  = FILL-IN-division AND
            cb-control.tipo    = '@CCB3' AND
            cb-control.fchpro  = FILL-IN-fchast AND
            cb-control.tipmov  = '@CCB' NO-ERROR.
        IF AVAILABLE cb-control THEN 
            ASSIGN
                p-Codope = cb-control.Codope 
                p-nroast = cb-control.Nroast.
        ELSE DO:
            p-codope = t-prev.codope.
            RUN cbd/cbdnast.p(
                cb-codcia,
                s-codcia,
                FILL-IN-periodo,
                X-Mes,
                p-codope,
                OUTPUT x-nroast).
            p-nroast = STRING(x-nroast, '999999').
            CREATE cb-control.
            ASSIGN
                cb-control.CodCia  = s-codcia
                cb-control.Coddiv  = FILL-IN-division
                cb-control.tipo    = '@CCB3'
                cb-control.fchpro  = FILL-IN-fchast
                cb-control.tipmov  = '@CCB'
                cb-control.Periodo = FILL-IN-periodo
                cb-control.Nromes  = X-Mes 
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
        CB-DMOV.PERIODO = FILL-IN-periodo.
        CB-DMOV.NROMES  = X-Mes.
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
        CREATE T-CB-DMOV.
        T-CB-DMOV.codcia  = s-codcia.
        T-CB-DMOV.PERIODO = FILL-IN-periodo.
        T-CB-DMOV.NROMES  = X-Mes.
        T-CB-DMOV.CODOPE  = p-codope.
        T-CB-DMOV.NROAST  = p-nroast.
        T-CB-DMOV.NROITM  = J.
        T-CB-DMOV.codcta  = t-prev.codcta.
        T-CB-DMOV.coddiv  = t-prev.coddiv.
        T-CB-DMOV.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        T-CB-DMOV.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        T-CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        T-CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        T-CB-DMOV.GLODOC  = t-prev.glodoc.
        T-CB-DMOV.tpomov  = t-prev.tpomov.
        T-CB-DMOV.impmn1  = t-prev.impmn1.
        T-CB-DMOV.impmn2  = t-prev.impmn2.
        T-CB-DMOV.FCHDOC  = t-prev.fchdoc.
        T-CB-DMOV.FCHVTO  = t-prev.fchdoc.
        T-CB-DMOV.FLGACT  = TRUE.
        T-CB-DMOV.RELACION = 0.
        T-CB-DMOV.codmon  = t-prev.codmon.
        T-CB-DMOV.tpocmb  = t-prev.tpocmb.
    END.
    IF LAST(t-prev.tipo) THEN DO:
        FIND cb-cmov WHERE
            cb-cmov.codcia  = s-codcia AND
            cb-cmov.PERIODO = FILL-IN-periodo AND
            cb-cmov.NROMES  = X-Mes AND
            cb-cmov.CODOPE  = p-codope AND
            cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
            CREATE cb-cmov.
            cb-cmov.codcia  = s-codcia.
            cb-cmov.PERIODO = FILL-IN-periodo.
            cb-cmov.NROMES  = X-Mes.
            cb-cmov.CODOPE  = p-codope.
            cb-cmov.NROAST  = p-nroast. 
        END.
        cb-cmov.Coddiv = t-prev.coddiv.
        cb-cmov.Fchast = FILL-IN-fchast.
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
RUN Actualiza-Flag.

MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

