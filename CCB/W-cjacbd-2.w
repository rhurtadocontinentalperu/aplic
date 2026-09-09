&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE SHARED VAR cb-codcia AS INT.
DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .
DEFINE NEW SHARED VARIABLE S-TIPO      AS CHAR .

DEFINE VAR x-codope  AS CHAR NO-UNDO.
DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.
DEFINE VAR x-tcajus  AS DECI NO-UNDO.
DEFINE VAR x-tvajus  AS DECI NO-UNDO.

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
    FIELD Nroref LIKE cb-dmov.nroref
    FIELD Glodoc LIKE cb-dmov.glodoc
    FIELD Tpocmb LIKE cb-dmov.tpocmb
    FIELD TpoMov LIKE cb-dmov.tpomov
    FIELD ImpMn1 LIKE cb-dmov.impmn1 
    FIELD ImpMn2 LIKE cb-dmov.impmn2
    FIELD clfaux LIKE cb-dmov.Clfaux
    FIELD codaux LIKE cb-dmov.Codaux
    INDEX IDX01 Tipo.

DEFINE BUFFER B-prev  FOR t-prev.
DEFINE BUFFER B-Docum FOR FacDocum.
DEFINE NEW SHARED TEMP-TABLE t2-prev LIKE t-prev.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR x-tpocmb AS DECI NO-UNDO.
DEFINE VAR x-periodo AS INTEGER NO-UNDO.
DEFINE VAR x-nromes  AS INTEGER NO-UNDO.
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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR s-punto AS CHAR NO-UNDO.
s-punto = 'Todos'.

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

DEFINE TEMP-TABLE INGRESOS
    FIELD Usuario AS CHAR
    FIELD CodDiv AS CHAR
    FIELD EfeNac AS DEC
    FIELD EfeUsa AS DEC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-16 FILL-IN-fchast F-DIVISION B-filtro 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fchast C-Caja F-DIVISION ~
FILL-IN-Tpocmb FILL-IN-TcCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cjacbd AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-filtro 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 5" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\b-print":U
     LABEL "Button 1" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Transferir 
     IMAGE-UP FILE "img\climnu1":U
     LABEL "Transferir Asiento" 
     SIZE 6.43 BY 1.62.

DEFINE VARIABLE C-Caja AS CHARACTER FORMAT "X(256)":U 
     LABEL "CAJA" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 16.43 BY 1 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast AS DATE FORMAT "99/99/9999":U 
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

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.43 BY 2.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-fchast AT ROW 3.42 COL 2.14 COLON-ALIGNED NO-LABEL
     C-Caja AT ROW 4.77 COL 5.43 COLON-ALIGNED
     F-DIVISION AT ROW 3.42 COL 19.86 NO-LABEL
     FILL-IN-Tpocmb AT ROW 3.42 COL 29.43 COLON-ALIGNED NO-LABEL
     FILL-IN-TcCompra AT ROW 3.42 COL 41.86 COLON-ALIGNED NO-LABEL
     B-filtro AT ROW 2.42 COL 64
     B-Transferir AT ROW 2.42 COL 72.14
     B-Imprimir AT ROW 2.42 COL 80.29
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Fecha de Proceso" VIEW-AS TEXT
          SIZE 13.43 BY .5 AT ROW 2.96 COL 3.29
     "T.C.Compra" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.96 COL 44.14
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "T.C.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.96 COL 32
     "CIERRE  DE  CAJA" VIEW-AS TEXT
          SIZE 26.43 BY .85 AT ROW 1.23 COL 28.57
          FONT 12
     "Division" VIEW-AS TEXT
          SIZE 6.29 BY .5 AT ROW 2.96 COL 21.14
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 4.15 COL 80.86
     RECT-16 AT ROW 2.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.14 BY 17
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
         TITLE              = "Generacion de Asiento Contable"
         HEIGHT             = 14.35
         WIDTH              = 92.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 92.57
         VIRTUAL-HEIGHT     = 17
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR BUTTON B-Imprimir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX C-Caja IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-TcCompra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Tpocmb IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Asiento Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Asiento Contable */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-filtro W-Win
ON CHOOSE OF B-filtro IN FRAME F-Main /* Button 5 */
DO:
  ASSIGN
     F-DIVISION FILL-IN-fchast FILL-IN-Tpocmb FILL-IN-TcCompra.

  IF FILL-IN-fchast = ?  THEN DO:
     MESSAGE 'Fecha no registrada' VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO FILL-IN-fchast.
     RETURN NO-APPLY.
  END.
  
  x-periodo = YEAR(FILL-IN-fchast).
  x-nromes  = MONTH(FILL-IN-fchast).
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = x-periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[x-nromes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
                              cb-control.Coddiv  = F-DIVISION AND
                              cb-control.tipo    = '@CJ' AND
                              cb-control.fchpro  = FILL-IN-fchast NO-LOCK NO-ERROR.
  
  IF AVAILABLE cb-control THEN DO:
     MESSAGE "Asiento contable ha sido generado" SKIP
             "Desea reprocesarlo? " VIEW-AS ALERT-BOX WARNING
              BUTTONS YES-NO UPDATE sigue AS LOGICAL.
     IF NOT sigue THEN RETURN.
  END.

  RUN Carga-Temporal.
  
  B-Transferir:SENSITIVE = YES.
  B-Imprimir:SENSITIVE   = YES.  
  C-Caja:LIST-ITEMS = s-punto.
  C-Caja = ENTRY(1,s-punto).
  C-Caja:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-Win
ON CHOOSE OF B-Imprimir IN FRAME F-Main /* Button 1 */
DO:
  x-resumen = FALSE.
  RUN Pre-impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = x-Periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[x-nromes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  RUN Transferir-asiento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Caja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Caja W-Win
ON VALUE-CHANGED OF C-Caja IN FRAME F-Main /* CAJA */
DO: 
  ASSIGN C-Caja.
  S-TIPO = IF C-Caja = 'Todas' THEN '' ELSE TRIM(C-Caja).
  RUN dispatch IN h_b-cjacbd ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main
DO:
  ASSIGN F-DIVISION.
  IF F-DIVISION = "" THEN RETURN.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fchast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fchast W-Win
ON LEAVE OF FILL-IN-fchast IN FRAME F-Main
DO:
  ASSIGN
     FILL-IN-fchast.
/*
  p-periodo = YEAR(FILL-IN-fchast).
  p-mes     = MONTH(FILL-IN-fchast).
*/  
  FIND gn-tcmb WHERE gn-tcmb.fecha = FILL-IN-fchast NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     FILL-IN-tpocmb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gn-tcmb.venta, '999.999').
     FILL-IN-TcCompra:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gn-tcmb.compra, '999.999').
  END.
  ELSE do: 
  message "No se ha registrado el tipo de cambio "  skip
          "para la fecha ingresada (" FILL-IN-fchast ")" view-as alert-box.
  APPLY 'ENTRY':U TO FILL-IN-fchast.
  return no-apply.
  end.
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
FOR EACH CcbCCaja WHERE CcbCCaja.CodCia = s-codcia AND
    CcbCCaja.FlgCie = 'C' AND CcbCCaja.FchCie = FILL-IN-fchast AND
    CcbCCaja.CodDiv = F-DIVISION AND
    CcbCCaja.CodDoc = "I/C":
   FIND cb-control WHERE cb-control.CodCia  = s-codcia AND
                         cb-control.Coddiv  = F-DIVISION AND
                         cb-control.tipo    = '@CJ' AND
                         cb-control.fchpro  = FILL-IN-fchast AND
                         cb-control.tipmov  = CcbCCaja.Usuario NO-LOCK NO-ERROR.

    IF AVAILABLE cb-control THEN DO:
       ASSIGN
          CcbCCaja.FlgCbd = TRUE
          CcbCCaja.FchCbd = TODAY
          CcbCCaja.Codope = cb-control.Codope 
          CcbCCaja.NroMes = cb-control.Nromes 
          CcbCCaja.Nroast = cb-control.Nroast.
       RELEASE CcbCCaja.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/ccb/b-cjacbd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjacbd ).
       RUN set-position IN h_b-cjacbd ( 5.77 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.31 , 91.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 12.88 , 2.57 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.69 , 45.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cjacbd. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-cjacbd ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cjacbd ,
             FILL-IN-fchast:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-cjacbd , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-B/D W-Win 
PROCEDURE Carga-B/D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.CodRef AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN 
           IF CcbCMvto.codmon = 1 THEN DO:
              x-codcta = B-Docum.CodCta[1].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[1].
              RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[3].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              END.
           ELSE DO:
              x-codcta = B-Docum.CodCta[2].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[2].
              RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[4].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
           END.
    END.
    RUN Graba-Documento(x-CodCbd, CcbCMvto.CodCta, FALSE, (CcbCMvto.ImpTot - CcbCMvto.ImpInt),
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
    RUN Graba-Documento(x-CodCbd, x-ctagas, FALSE, CcbCMvto.ImpInt,
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
END.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-N/B W-Win 
PROCEDURE Carga-N/B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'P' THEN NEXT.
       FOR EACH CcbDcaja WHERE CcbDCaja.CodCia = s-codcia AND
          CcbDCaja.CodDoc = CcbCMvto.Coddoc AND 
          CcbDCaja.NroDoc = CcbCMvto.Nrodoc NO-LOCK:
          FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
               B-Docum.CodDoc = CcbDCaja.Codref NO-LOCK NO-ERROR.
          IF AVAILABLE B-Docum THEN DO:
             x-codcbd = B-Docum.CodCbd.
             x-tpomov = B-Docum.TpoDoc.
          END.
          FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
               CcbCDocu.CodDoc = CcbDCaja.Codref AND
               CcbCDocu.NroDoc = CcbDCaja.Nroref NO-LOCK NO-ERROR.
          IF AVAILABLE CcbCDocu THEN DO:
             IF CcbCDocu.FlgSit = 'D' THEN DO:
                FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                     B-Docum.CodDoc = 'B/D' NO-LOCK NO-ERROR.
                IF AVAILABLE B-Docum THEN DO:
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[3].
                   ELSE x-codcta = B-Docum.CodCta[4].
                   RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                       CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                   ELSE x-codcta = B-Docum.CodCta[2].
                   RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                       CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
                   END.
                END.
             ELSE DO:
               IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
               ELSE x-codcta = B-Docum.CodCta[2].
               x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
               RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                   CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
               RUN Carga-Ajuste(x-codcbd, x-codcta, CcbDCaja.Imptot, x-tipo, CcbCDocu.codmon, x-glodoc).
               /**/
               RUN Graba-Documento(x-CodCbd, CcbCMvto.CodCta, NOT x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                   CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbCMvto.tpocmb).
             END.
          END.
       END.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-P/C W-Win 
PROCEDURE Carga-P/C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.Codref AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
           IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
           ELSE x-codcta = B-Docum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
        END.
            
        CASE x-tipo:
            WHEN 'P/C' THEN DO:
                FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                     B-Docum.CodDoc = 'B/C' NO-LOCK NO-ERROR.
                IF AVAILABLE B-Docum THEN DO:
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                   ELSE x-codcta = B-Docum.CodCta[2].
                   x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
                END.
            END.
            WHEN 'P/G' THEN DO:
                FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                     B-Docum.CodDoc = 'B/G' NO-LOCK NO-ERROR.
                IF AVAILABLE B-Docum THEN DO:
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                   ELSE x-codcta = B-Docum.CodCta[2].
                   x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
                END.
            END.
        END CASE.
        RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
            CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).

        IF CcbCDocu.Codmon = 1 THEN x-codcta = FacDocum.CodCta[1].
        ELSE x-codcta = FacDocum.CodCta[2].
        x-codcta = IF x-codcta = '' THEN  FacDocum.CodCta[1] ELSE x-codcta.
        RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
            CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-P/D W-Win 
PROCEDURE Carga-P/D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.Codref AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
           IF CcbCDocu.Codmon = 1 THEN x-codcta = FacDocum.CodCta[1].
           ELSE x-codcta = FacDocum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN  FacDocum.CodCta[1] ELSE x-codcta.
           RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
               CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).
        END.
    END.
    RUN Graba-Documento(x-CodCbd, x-ctagas, FALSE, CcbCMvto.ImpInt,
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
    RUN Graba-Documento(x-CodCbd, CcbCMvto.CodCta, TRUE, (CcbCMvto.ImpInt + CcbCMvto.ImpTot),
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
END.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Notes:      Transferencia de movimientos correspondientes a cuentas por cobrar
------------------------------------------------------------------------------*/
DEFINE VAR x-imptot AS DECIMAL NO-UNDO.
DEFINE VAR x-fchvto AS DATE NO-UNDO.
DEFINE VAR x-efenac As DECI INIT 0.
DEFINE VAR x-efeusa As DECI INIT 0.
DEFINE VAR x-chqnac As DECI INIT 0.
DEFINE VAR x-chqusa As DECI INIT 0.
DEFINE VAR x-chdnac As DECI INIT 0.
DEFINE VAR x-chdusa As DECI INIT 0.
DEFINE VAR x-depnac As DECI INIT 0.
DEFINE VAR x-depusa As DECI INIT 0.
DEFINE VAR x-tpocmd As DECI INIT 0.
DEFINE VAR x-ruccli AS CHAR.
DEFINE VAR x-entra  AS LOGICAL.
DEFINE VAR x-codaux AS CHAR.

FOR EACH t-prev:
  DELETE t-prev.
END.
FIND cb-cfgcja WHERE cb-cfgcja.Codcia = S-CODCIA AND
                     cb-cfgcja.CodDiv = F-DIVISION
                     NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgcja  THEN DO:
   MESSAGE "Configuracion Cierre de Caja no existe"
           "Configure y procese la generacion "
           VIEW-AS ALERT-BOX.                     
           RETURN.               
END.                         
x-codope = cb-cfgcja.codope.

/* INGRESOS A CAJA */
RUN Ingresos.

/* EGRESOS A CAJA */
RUN Egresos.

x-tpocmb = 0.
RUN Graba-Diferencia.

HIDE FRAME F-Proceso.
RUN dispatch IN h_b-cjacbd ('open-query':U).

RUN Totales IN h_b-cjacbd.

FIND FIRST t-prev NO-LOCK NO-ERROR.
IF AVAILABLE t-prev THEN
   RUN dispatch IN h_p-updv10 ('view':U). 
ELSE
   RUN dispatch IN h_p-updv10 ('hide':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Old W-Win 
PROCEDURE Carga-Temporal-Old :
/*------------------------------------------------------------------------------
  Notes:      Transferencia de movimientos correspondientes a cuentas por cobrar
------------------------------------------------------------------------------*/
DEFINE VAR x-imptot AS DECIMAL NO-UNDO.
DEFINE VAR x-fchvto AS DATE NO-UNDO.
DEFINE VAR x-efenac As DECI INIT 0.
DEFINE VAR x-efeusa As DECI INIT 0.
DEFINE VAR x-chqnac As DECI INIT 0.
DEFINE VAR x-chqusa As DECI INIT 0.
DEFINE VAR x-chdnac As DECI INIT 0.
DEFINE VAR x-chdusa As DECI INIT 0.
DEFINE VAR x-depnac As DECI INIT 0.
DEFINE VAR x-depusa As DECI INIT 0.
DEFINE VAR x-tpocmd As DECI INIT 0.
DEFINE VAR x-ruccli AS CHAR.
DEFINE VAR x-entra  AS LOGICAL.
DEFINE VAR x-codaux AS CHAR.

FOR EACH t-prev:
  DELETE t-prev.
END.
FIND cb-cfgcja WHERE cb-cfgcja.Codcia = S-CODCIA AND
                     cb-cfgcja.CodDiv = F-DIVISION
                     NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgcja  THEN DO:
   MESSAGE "Configuracion Cierre de Caja no existe"
           "Configure y procese la generacion "
           VIEW-AS ALERT-BOX.                     
           RETURN.               
END.                         
x-codope = cb-cfgcja.codope.
FOR EACH CcbCCaja WHERE CcbCCaja.CodCia = s-codcia AND CcbCCaja.FlgCie = 'C' AND CcbCCaja.FchCie = FILL-IN-fchast AND
        CcbCCaja.CodDiv = F-DIVISION AND CcbCCaja.Coddoc = "I/C" NO-LOCK BREAK BY CcbCCaja.Usuario:
    IF LOOKUP(CcbCCaja.CodDiv, s-punto) = 0 THEN s-punto = s-punto + ',' + CcbCCaja.CodDiv.
    DISPLAY CcbCCaja.CodDoc + '-' + CcbCCaja.NroDoc @ Fi-Mensaje LABEL "Documento de cobranza "
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDCaja OF CcbCCaja NO-LOCK:
        /* Cancelo provision del documento */
        x-glodoc = 'Canc.' + CcbDCaja.CodRef + '-' + CcbDCaja.NroRef + ' Cli.' + CcbDCaja.Codcli.
        FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
             FacDocum.CodDoc = CcbDCaja.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
           x-tpomov = FacDocum.TpoDoc.
           x-codcbd = FacDocum.CodCbd.
           x-tpocmb = 0.
        END.
        IF LOOKUP(CcbDCaja.CodRef, 'TCK,FAC,BOL,N/C,N/D') > 0 THEN 
           RUN Graba-Documento (CcbCCaja.CodDiv, 
                                CcbDCaja.CodMon, 
                                CcbDCaja.ImpTot, 
                                '@CL', 
                                CcbDCaja.CodRef,
                                CcbDCaja.Nroref, 
                                x-fchvto, 
                                x-tpocmb).
        ELSE DO:     
            x-tpomov = TRUE.
            IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
                IF CcbCCaja.Tipo = "ANTREC" THEN DO:
                    x-codcbd = '34'.
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = 0.
                    x-glodoc = 'Anticipo-Recibido' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    2, 
                                    CcbCCaja.ImpUsa[1], 
                                    '@CL', 
                                    CcbCCaja.Codcli,
                                    SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                                    x-fchvto,
                                    x-tpocmb).
                END.
                ELSE DO:
                    x-codcbd = SUBSTRING(CcbCcaja.Voucher[1],1,3).
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = CcbCCaja.Tpocmb.
                    x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").                      
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    2, 
                                    CcbCCaja.ImpUsa[1], 
                                    '', 
                                    "",
                                    SUBSTRING(CcbCcaja.Voucher[1],4,15), 
                                    CcbCCaja.FchVto[3], 
                                    x-tpocmb).    
                END.
            END.                
            IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
                IF CcbCCaja.Tipo = "ANTREC" THEN DO:
                    x-codcbd = '34'.
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = 0.
                    x-glodoc = 'Anticipo-Recibido' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    1, 
                                    CcbCCaja.ImpNac[1], 
                                    '@CL', 
                                    CcbCCaja.Codcli,
                                    SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                                    x-fchvto,
                                    x-tpocmb).
                END.
                ELSE DO:
                    x-codcbd = SUBSTRING(CcbCcaja.Voucher[1],1,3).
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = 0.
                    x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").       
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    1, 
                                    CcbCCaja.ImpNac[1], 
                                    '', 
                                    "",
                                    SUBSTRING(CcbCcaja.Voucher[1],4,15), 
                                    CcbCCaja.FchVto[3], 
                                    x-tpocmb).
                END.               
            
            END.                

        END.
    END.    
    /* Ingreso a Caja */
    /* ASIGNAMOS LA MISMA DIVISION QUE LA PROVISION */
    DEF VAR x-CodDiv AS CHAR NO-UNDO.       
    x-CodDiv = CcbCCaja.CodDiv.
    FIND FIRST CcbDCaja OF CcbCCaja NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDCaja THEN DO:
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND CcbCDocu.CodDoc = CcbDCaja.CodRef 
            AND CcbCDocu.NroDoc = CcbDcaja.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN x-CodDiv = ccbcdocu.coddiv.
    END.
    /* ******************************************* */
    x-tpomov = FALSE.
    x-tpocmb = 0.
    IF CcbCCaja.ImpNac[1] > 0 THEN DO:
       x-imptot = CcbCCaja.ImpNac[1] - CcbCCaja.VueNac.
       IF CcbCCaja.ImpUsa[1] = 0 AND CcbCCaja.VueUsa > 0 THEN 
          x-imptot = x-imptot - ROUND((CcbCCaja.VueUsa * CcbCCaja.Tpocmb), 2).
       x-codcta = "".
       IF CcbCCaja.Coddoc = "I/C" THEN x-efenac = x-efenac + x-imptot.
       IF CcbCCaja.Coddoc = "E/C" THEN x-efenac = x-efenac - x-imptot.
    END.
    IF CcbCCaja.ImpNac[2] > 0 THEN DO:
       x-codcbd = '32'.
       x-chqnac = x-chqnac + CcbCCaja.ImpNac[2].
       x-codcta = cb-cfgcja.codcta1[2].
       x-tpocmb = 0.
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
       RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[2], '', "",
                            CcbCCaja.Voucher[2], x-fchvto,x-tpocmb).
    END.
    IF CcbCCaja.ImpNac[3] > 0 THEN DO:
       x-codcbd = '32'.
       x-chdnac = x-chdnac + CcbCCaja.ImpNac[3].
       x-codcta = cb-cfgcja.codcta1[3].       
       x-tpocmb = 0.
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[3], '', "",
                            CcbCCaja.Voucher[3], CcbCCaja.FchVto[3], x-tpocmb).
    END.
    IF CcbCCaja.ImpNac[4] > 0 THEN DO:
        x-codcta = cb-cfgcja.codcta1[4].
        x-codaux = ''.
        x-codcbd = ''.
        x-tpocmb = 0.
        x-glodoc = 'Canc-No-Deducible' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
        /* BUSCAMOS DATOS EL LA CUENTA */
        FIND FIRST CB-CTAS WHERE CB-CTAS.codcia = cb-codcia
             AND CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
        IF AVAILABLE CB-CTAS THEN x-codcbd = cb-ctas.Coddoc.
        CASE CcbCCaja.Voucher[8]:
            WHEN "Visa"         THEN x-codaux = '34119821'.
            WHEN "Mastercard"   THEN x-codaux = '43240552'.
            WHEN "American Express" THEN .
            WHEN "Dinners"      THEN .
        END CASE.
        RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[4], '', x-codaux,
            CcbCCaja.Voucher[4], x-fchvto, x-tpocmb).
    END.
    IF CcbCCaja.ImpNac[5] > 0 THEN DO:
       x-codcta = "".
       x-codcbd = '36'.
       x-tpocmb = 0.
       x-glodoc = 'Canc-Deposito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       x-depnac = x-depnac + CcbCCaja.ImpNac[5].
       FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = CcbCCaja.Codcli
                       AND  ccbboldep.nrodoc = CcbCCaja.Voucher[5]
                       NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ccbboldep THEN DO:
          MESSAGE 'Deposito no se encuentra registrado ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[5] 
                   VIEW-AS ALERT-BOX.
        
       END.                
       IF AVAILABLE ccbboldep THEN DO:
          x-codcta = ccbboldep.Codcta.
          RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[5], ' ', ' ',
                          CcbCCaja.Voucher[5], x-fchvto, x-tpocmb).
       END.                   
    END.
    /**/
    x-tpocmb = 0.
    FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCCaja.FchDoc
                       NO-LOCK NO-ERROR.
    IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.compra.                    

    IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
       x-imptot = CcbCCaja.ImpUsa[1] - CcbCCaja.VueUsa.
       IF CcbCCaja.ImpNac[1] = 0 AND CcbCCaja.VueNac > 0 THEN
          x-imptot = x-imptot - ROUND((CcbCCaja.VueNac / CcbCCaja.Tpocmb), 2).
       x-codcta = "".
       IF CcbCCaja.Coddoc = "I/C" THEN x-efeusa = x-efeusa + x-imptot.
       IF CcbCCaja.Coddoc = "E/C" THEN x-efeusa = x-efeusa - x-imptot.
    END.
    IF CcbCCaja.ImpUsa[2] > 0 THEN DO:
       x-codcbd = '32'.
       x-chqusa = x-chqusa + CcbCCaja.ImpUsa[2].
       x-codcta = cb-cfgcja.codcta2[2].       
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[2], '', "",
                            CcbCCaja.Voucher[2], x-fchvto, CcbCCaja.TpoCmb).
    END.
    IF CcbCCaja.ImpUsa[3] > 0 THEN DO:
       x-codcbd = '32'.
       x-chdusa = x-chdusa + CcbCCaja.ImpUsa[3].
       x-codcta = cb-cfgcja.codcta2[3].       
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[3], '', "",
                            CcbCCaja.Voucher[3], CcbCCaja.FchVto[3], CcbCCaja.TpoCmb).
    END.
    IF CcbCCaja.ImpUsa[4] > 0 THEN DO:
        x-codcta = cb-cfgcja.codcta2[4].
        x-codaux = ''.
        x-codcbd = ''.
        x-glodoc = 'Canc-No-Deducible' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.              
        /* BUSCAMOS DATOS EL LA CUENTA */
        FIND FIRST CB-CTAS WHERE CB-CTAS.codcia = cb-codcia
             AND CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
        IF AVAILABLE CB-CTAS THEN x-codcbd = cb-ctas.Coddoc.
        CASE CcbCCaja.Voucher[8]:
            WHEN "Visa"         THEN x-codaux = '34119821'.
            WHEN "Mastercard"   THEN x-codaux = '43240552'.
            WHEN "American Express" THEN .
            WHEN "Dinners"      THEN .
        END CASE.
       RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[4], '', x-codaux,
           CcbCCaja.Voucher[4], x-fchvto, x-tpocmb).
    END.
    IF CcbCCaja.ImpUsa[5] > 0 THEN DO:
       x-codcbd = '36'.
       x-depusa = x-depusa + CcbCCaja.ImpUsa[5].
       x-glodoc = 'Canc-Deposito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.              
       FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = CcbCCaja.Codcli
                       AND  ccbboldep.nrodoc = CcbCCaja.Voucher[5]
                       NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ccbboldep THEN DO:
          MESSAGE 'Deposito no se encuentra registrado ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[5] 
                   VIEW-AS ALERT-BOX.
        
       END.                
       IF AVAILABLE ccbboldep THEN DO:
          x-codcta = ccbboldep.Codcta.
          RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[5], ' ', ' ',
                          CcbCCaja.Voucher[5], x-fchvto, CcbCCaja.TpoCmb).
       END.                   
    END.
    IF LAST-OF(CcbCCaja.Usuario) THEN DO:
       x-glodoc = "C A J A " + CcbCCaja.Usuario + " " + STRING(CcbCCaja.FchCie, '99/99/9999').
       x-codcta = cb-cfgcja.codcta1[1].
       x-codcbd = ''.
       x-tpocmb = 0.
       RUN Graba-Caja (F-DIVISION, 1, x-efenac, ' ',
                   " ","" , x-fchvto, x-tpocmb).        
       FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCCaja.FchDoc
                          NO-LOCK NO-ERROR.
       IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.compra.                    
       x-codcta = cb-cfgcja.codcta2[1].
       RUN Graba-Caja (F-DIVISION, 2, x-efeusa, ' ',
                   "","", x-fchvto, x-tpocmb).       
       x-efenac = 0.
       x-efeusa = 0.         
    END.
END.

FOR EACH CcbCCaja WHERE CcbCCaja.CodCia = s-codcia AND
                        CcbCCaja.FlgCie = 'C' AND 
                        CcbCCaja.FchCie = FILL-IN-fchast AND
                        CcbCCaja.CodDiv = F-DIVISION AND
                        CcbCCaja.Coddoc = "E/C" 
                        NO-LOCK BREAK BY CcbCCaja.Usuario:
    x-entra = false.
    FOR EACH CcbDCaja OF CcbCCaja NO-LOCK:        
        IF LOOKUP(CcbDCaja.CodRef, 'FAC,BOL,N/C,N/D') > 0 THEN DO:
           FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
                FacDocum.CodDoc = CcbDCaja.CodRef NO-LOCK NO-ERROR.
           IF AVAILABLE FacDocum THEN DO:
              x-tpomov = FacDocum.TpoDoc.
              x-codcbd = FacDocum.CodCbd.
              x-tpocmb = 0.
           END.
           x-entra = true.
           RUN Graba-Documento (CcbCCaja.CodDiv, CcbDCaja.CodMon, CcbDCaja.ImpTot, '@CL', CcbDCaja.CodRef ,
                                CcbDCaja.Nroref, x-fchvto, x-tpocmb).
        END.
    END.    
    IF x-entra THEN NEXT.
    IF CcbCCaja.Voucher[10] <> "" THEN DO:
        FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
                            FacDocum.CodDoc = "N/C"
                            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
           x-tpomov = FacDocum.TpoDoc.
           x-codcbd = FacDocum.CodCbd.
           x-tpocmb = 0.
        END.
        IF CcbCCaja.ImpNac[1] > 0 THEN DO:
           x-imptot = CcbCCaja.ImpNac[1].
           x-codcta = CcbCCaja.CodCta[1].
           RUN Graba-N/C (CcbCCaja.CodDiv, 1, x-imptot, '@CL', "N/C" ,
                          Voucher[10] , x-fchvto, x-tpocmb).

        END.
        IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
           x-imptot = CcbCCaja.ImpUsa[1].
           x-codcta = CcbCCaja.CodCta[1].
           RUN Graba-N/C (CcbCCaja.CodDiv, 2, x-imptot, '@CL', "N/C" ,
                          Voucher[10] , x-fchvto, x-tpocmb).
        END.   
        NEXT.
    END.
    IF CcbCCaja.Tipo = "DEVONC" THEN DO:
        FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
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
           RUN Graba-N/C (CcbCCaja.CodDiv, 
                            1, 
                            x-imptot, 
                            '@CL', 
                            "N/C" ,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                            x-fchvto, 
                            x-tpocmb).

        END.
        IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
           x-imptot = CcbCCaja.ImpUsa[1].
           x-codcta = CcbCCaja.CodCta[1].
           RUN Graba-N/C (CcbCCaja.CodDiv, 
                            2, 
                            x-imptot, 
                            '@CL', 
                            "N/C" ,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                            x-fchvto, 
                            x-tpocmb).
        END.   
        NEXT.
    END.
    x-tpomov = FALSE. 
    IF CcbCCaja.Tipo = "ANTREC" THEN DO:
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            x-codcbd = "34".
            x-codcta = CCbCCaja.CodCta[1].
            x-tpocmb = 0.
            x-glodoc = "Aplicacion-Anticipo" + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            x-codcbd = "34".
            x-codcta = CCbCCaja.CodCta[1].
            x-tpocmb = 0.
            x-glodoc = "Aplicacion-Anticipo" + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
    END.
    ELSE DO:
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            x-codcbd = SUBSTRING(CcbCCaja.Voucher[1],1,3).
            /*x-codcta = CCbCCaja.CodCta[2].*/
            x-codcta = cb-cfgcja.CodCta2[1].
            x-tpocmb = CcbCCaja.Tpocmb.
            x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            x-codcbd = SUBSTRING(CcbCCaja.Voucher[1],1,3).
            /*x-codcta = CCbCCaja.CodCta[1].*/
            x-codcta = cb-cfgcja.CodCta1[1].
            x-tpocmb = 0.
            x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
    END.
END.
x-tpocmb = 0.
RUN Graba-Diferencia.
HIDE FRAME F-Proceso.
RUN dispatch IN h_b-cjacbd ('open-query':U).
RUN Totales IN h_b-cjacbd.
FIND FIRST t-prev NO-LOCK NO-ERROR.
IF AVAILABLE t-prev THEN
   RUN dispatch IN h_p-updv10 ('view':U). 
ELSE
   RUN dispatch IN h_p-updv10 ('hide':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Egresos W-Win 
PROCEDURE Egresos :
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
                        CcbCCaja.FchCie = FILL-IN-fchast AND
                        CcbCCaja.CodDiv = F-DIVISION AND
                        CcbCCaja.Coddoc = "E/C" 
                        NO-LOCK BREAK BY CcbCCaja.Usuario:
    x-entra = false.
    FOR EACH CcbDCaja OF CcbCCaja NO-LOCK:        
        IF LOOKUP(CcbDCaja.CodRef, 'FAC,BOL,N/C,N/D') > 0 THEN DO:
           FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
                FacDocum.CodDoc = CcbDCaja.CodRef NO-LOCK NO-ERROR.
           IF AVAILABLE FacDocum THEN DO:
              x-tpomov = FacDocum.TpoDoc.
              x-codcbd = FacDocum.CodCbd.
              x-tpocmb = 0.
           END.
           x-entra = true.
           RUN Graba-Documento (CcbCCaja.CodDiv, CcbDCaja.CodMon, CcbDCaja.ImpTot, '@CL', CcbDCaja.CodRef ,
                                CcbDCaja.Nroref, x-fchvto, x-tpocmb).
        END.
    END.    
    IF x-entra THEN NEXT.
    IF CcbCCaja.Voucher[10] <> "" THEN DO:
        FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
                            FacDocum.CodDoc = "N/C"
                            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
           x-tpomov = FacDocum.TpoDoc.
           x-codcbd = FacDocum.CodCbd.
           x-tpocmb = 0.
        END.
        IF CcbCCaja.ImpNac[1] > 0 THEN DO:
           x-imptot = CcbCCaja.ImpNac[1].
           x-codcta = CcbCCaja.CodCta[1].
           RUN Graba-N/C (CcbCCaja.CodDiv, 1, x-imptot, '@CL', "N/C" ,
                          Voucher[10] , x-fchvto, x-tpocmb).

        END.
        IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
           x-imptot = CcbCCaja.ImpUsa[1].
           x-codcta = CcbCCaja.CodCta[1].
           RUN Graba-N/C (CcbCCaja.CodDiv, 2, x-imptot, '@CL', "N/C" ,
                          Voucher[10] , x-fchvto, x-tpocmb).
        END.   
        NEXT.
    END.
    IF CcbCCaja.Tipo = "DEVONC" THEN DO:
        FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
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
           RUN Graba-N/C (CcbCCaja.CodDiv, 
                            1, 
                            x-imptot, 
                            '@CL', 
                            "N/C" ,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                            x-fchvto, 
                            x-tpocmb).

        END.
        IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
           x-imptot = CcbCCaja.ImpUsa[1].
           x-codcta = CcbCCaja.CodCta[1].
           RUN Graba-N/C (CcbCCaja.CodDiv, 
                            2, 
                            x-imptot, 
                            '@CL', 
                            "N/C" ,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                            x-fchvto, 
                            x-tpocmb).
        END.   
        NEXT.
    END.
    x-tpomov = FALSE. 
    IF CcbCCaja.Tipo = "ANTREC" THEN DO:
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            x-codcbd = "34".
            x-codcta = CCbCCaja.CodCta[1].
            x-tpocmb = 0.
            x-glodoc = "Aplicacion-Anticipo" + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            x-codcbd = "34".
            x-codcta = CCbCCaja.CodCta[1].
            x-tpocmb = 0.
            x-glodoc = "Aplicacion-Anticipo" + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
    END.
    ELSE DO:
        IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
            x-codcbd = SUBSTRING(CcbCCaja.Voucher[1],1,3).
            /*x-codcta = CCbCCaja.CodCta[2].*/
            x-codcta = cb-cfgcja.CodCta2[1].
            x-tpocmb = CcbCCaja.Tpocmb.
            x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 2, CcbCCaja.ImpUsa[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
        IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
            x-codcbd = SUBSTRING(CcbCCaja.Voucher[1],1,3).
            /*x-codcta = CCbCCaja.CodCta[1].*/
            x-codcta = cb-cfgcja.CodCta1[1].
            x-tpocmb = 0.
            x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + ' Cli.' + CcbCCaja.Codcli + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").         
            RUN Graba-Caja (CcbCCaja.Coddiv, 1, CcbCCaja.ImpNac[1], '@CL', CcbCCaja.Codcli,
                            SUBSTRING(CcbCCaja.Voucher[1],4,15), CcbCCaja.FchVto[3], x-tpocmb).
        END.                
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-fchast C-Caja F-DIVISION FILL-IN-Tpocmb FILL-IN-TcCompra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-16 FILL-IN-fchast F-DIVISION B-filtro 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Ajuste W-Win 
PROCEDURE Graba-Ajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-coddiv AS CHAR.
DEFINE INPUT PARAMETER X-import AS DECIMAL.
DEFINE INPUT PARAMETER X-codmon AS INTEGER.

DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
DEFINE VAR x-ajuste AS DECIMAL NO-UNDO.
DEFINE VAR x-tpomov AS LOGICAL NO-UNDO.

FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
     cb-ctas.Codcta = x-codcta NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN DO:
   MESSAGE 'Cuenta contable ' + x-codcta + ' no existe' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.

IF NOT cb-ctas.AftDcb THEN RETURN.

IF cb-ctas.Codmon = 1 THEN x-tpocmb = x-tcajus.
ELSE x-tpocmb = x-tvajus.

x-tpocmb = CcbCDocu.tpocmb.

IF CcbCDocu.codmon = 1 THEN 
   x-ajuste = ROUND((x-import / x-tpocmb) - (x-import / CcbDCaja.tpocmb), 2).
ELSE 
   x-ajuste = ROUND((x-import * x-tpocmb) - (x-import * CcbDCaja.tpocmb), 2).


IF x-ajuste <> 0 THEN DO:
   IF x-ajuste > 0 THEN x-tpomov = TRUE.
   ELSE x-tpomov = FALSE.
   CREATE t-prev.
   ASSIGN
      t-prev.tipo    = CcbCCaja.CodCaja
      t-prev.periodo = x-periodo
      t-prev.nromes  = x-nromes
      t-prev.codope  = x-codope
      t-prev.coddiv  = x-CodDiv 
      t-prev.codmon  = x-codmon
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = FILL-IN-fchast
      t-prev.tpomov  = x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.codaux  = CcbDCaja.Codcli
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = CcbDCaja.Nroref
      t-prev.nroref  = CcbCCaja.nrodoc.
      
   IF CcbDCaja.CodMon = 1 THEN
      ASSIGN
         t-prev.impmn2 = ABSOLUTE(x-ajuste).
   ELSE 
      ASSIGN
         t-prev.impmn1 = ABSOLUTE(x-ajuste).
   ASSIGN
      t-prev.Tpocmb  = CcbCCaja.TpoCmb
      t-prev.glodoc  = 'Ajuste por Dif.Cambio'.
   RELEASE t-prev.

   IF x-ajuste > 0 THEN x-codcta = x-ctagan.
   ELSE x-codcta = x-ctaper.
   CREATE t-prev.
   ASSIGN
      t-prev.tipo    = CcbCCaja.CodCaja
      t-prev.periodo = x-periodo
      t-prev.nromes  = x-nromes
      t-prev.codope  = x-codope
      t-prev.coddiv  = x-CodDiv 
      t-prev.codmon  = 1
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = FILL-IN-fchast
      t-prev.tpomov  = NOT x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.codaux  = CcbCDocu.Codcli
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = CcbDCaja.Nroref
      t-prev.nroref  = CcbCCaja.nrodoc.
            
   IF CcbDCaja.CodMon = 1 THEN
      ASSIGN
         t-prev.impmn2 = ABSOLUTE(x-ajuste).
   ELSE 
      ASSIGN
         t-prev.impmn1 = ABSOLUTE(x-ajuste).
   ASSIGN
      t-prev.Tpocmb  = CcbCCaja.TpoCmb
      t-prev.glodoc  = 'Ajuste por Dif.Cambio'.
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Caja W-Win 
PROCEDURE Graba-Caja :
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

 CREATE t-prev.
 ASSIGN
    t-prev.tipo    = CcbCCaja.Usuario
    t-prev.periodo = x-periodo
    t-prev.nromes  = x-nromes
    t-prev.codope  = x-codope
    t-prev.coddiv  = x-CodDiv 
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
    
 IF x-codmon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-import.
/*       t-prev.impmn2  = t-prev.impmn2 + ROUND((x-import / CcbCCaja.TpoCmb),2).*/
 ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-import
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2).

 RELEASE t-prev.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Diferencia W-Win 
PROCEDURE Graba-Diferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-s AS DECIMAL NO-UNDO.
DEFINE VAR x-d AS DECIMAL NO-UNDO.
DEFINE BUFFER B-prev FOR t-prev.

FOR EACH t-prev NO-LOCK BREAK BY t-prev.coddiv BY t-prev.tipo BY t-prev.nroref BY t-prev.codcta :
    IF FIRST-OF(t-prev.coddiv) THEN DO:
       x-s = 0.
       x-d = 0.
    END.
    x-s = x-s + (t-prev.ImpMn1 * IF t-prev.tpomov THEN -1 ELSE 1).
    x-d = x-d + (t-prev.ImpMn2 * IF t-prev.tpomov THEN -1 ELSE 1).
    IF LAST-OF(t-prev.coddiv) THEN DO:
       IF x-s <> 0  THEN DO:
          x-tpomov = x-s > 0.
          x-codcta = IF x-s > 0 THEN x-ctagan ELSE x-ctaper.
          RUN Graba-Dif (1, ABS(x-s)).
       END.
       /*
       IF x-d <> 0  THEN DO:
          x-tpomov = x-d > 0.
          x-codcta = IF x-d > 0 THEN x-rndgan ELSE x-rndper.
          RUN Graba-Rnd (2, ABS(x-d)).
       END.
       */
    END.
END.
END PROCEDURE.

PROCEDURE Graba-Dif:
/******************/
DEFINE INPUT PARAMETER x-codmon AS INTEGER.
DEFINE INPUT PARAMETER x-import AS DECIMAL.

 CREATE B-prev.
 ASSIGN
    B-prev.tipo    = t-prev.tipo
    B-prev.periodo = x-periodo
    B-prev.nromes  = x-nromes
    B-prev.codope  = x-codope
    B-prev.coddiv  = t-prev.CodDiv 
    B-prev.codmon  = x-codmon
    B-prev.codcta  = x-codcta
    B-prev.fchdoc  = t-prev.fchdoc
    B-prev.tpomov  = x-tpomov
    B-prev.Tpocmb  = t-prev.TpoCmb
    B-prev.glodoc  = 'Diferencia de Cambio'
    B-prev.nroref  = '999999999'. /* Solo por presentacion */
    
 IF x-codmon = 1 THEN ASSIGN B-prev.impmn1  = x-import.
 ELSE ASSIGN B-prev.impmn2  = x-import.

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

FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                    CcbCDocu.CodDoc = x-CodRef AND 
                    CcbCDocu.NroDoc = x-nrodoc
                    NO-LOCK NO-ERROR.

IF NOT AVAILABLE CcbCDocu THEN DO:
   MESSAGE 'Documento no encontrado en los registros ' + x-codref + ' ' + x-nrodoc  VIEW-AS ALERT-BOX.
   RETURN.
END.   
IF CcbCdocu.FlgEst = "A" THEN RETURN.

/* RHC 03.09.04 TOMAMOS LA DIVISION DEL DOCUMENTO ORIGEN PARA MATAR SALDOS */
x-CodDiv = CCBCDOCU.CodDiv.
/* ***************************************************** */

/*MLR* 17/01/08 ***/
IF ccbcdocu.coddoc <> "LET" THEN DO:
FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA AND
                    Cb-cfgrv.CodDiv = Ccbcdocu.CodDiv AND
                    Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc AND
                    Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo AND
                    Cb-cfgrv.Codmon = Ccbcdocu.Codmon NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
    /* buscamos tambien con la referencia */
    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA 
        AND Cb-cfgrv.CodDiv = Ccbcdocu.CodDiv 
        AND Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc 
        AND Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo 
        AND Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
        AND Cb-cfgrv.CodRef = Ccbcdocu.CodRef
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
        MESSAGE 'I/C:Cuenta No Configurada Para ' + CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc  VIEW-AS ALERT-BOX.
        RETURN.
    END.
END.
END.
IF CcbCdocu.CodMon = 2 THEN DO: 
    FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCdocu.FchDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.                    
    /* RHC 15.06.06 N/C toma el T.C. del documento de referencia */
    IF Ccbcdocu.coddoc = 'N/C' THEN DO:
        FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
            AND B-CDOCU.coddoc = Ccbcdocu.codref
            AND B-CDOCU.nrodoc = Ccbcdocu.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU THEN DO:
            FIND Gn-tcmb WHERE Gn-tcmb.Fecha = B-CDOCU.FchDoc NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.                    
        END.
    END.
END.                      
/* TOMAMOS EL AUXILIAR DEL DOCUMENTO */
X-CODAUX = CcbCDocu.CodCli.
/* ********************************* */

/*MLR* 17/12/07 ***
/* RHC 19.10.04 */
IF CcbCDocu.CodDoc = 'BOL'
* ***/
/*MLR* 17/12/07 ***/
IF LOOKUP(CcbCDocu.CodDoc,'BOL,TCK') > 0
THEN x-CodAux = IF CcbCDocu.NroCard <> '' THEN CcbCDocu.NroCard ELSE '11111111111'.
/* ************ */

IF ccbcdocu.coddoc <> "LET" THEN DO:
x-codcta  = Cb-cfgrv.Codcta.       
x-detalle = Cb-cfgrv.Detalle.
END.
ELSE DO:
    x-codcta = x-ctalet[ccbcdocu.codmon].
    x-detalle = TRUE.
END.


x-glodoc  = 'Canc.' + CcbDCaja.CodRef + '-' + CcbDCaja.NroRef + ' Cli.' + CcbDCaja.Codcli.      

/*MLR* 15/12/07 ***/
    X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE "111111111".
    X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE SUBSTRING(CcbCDocu.Nrodoc,1,3) + "111111".
/*MLR* ***/
   
FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                   cb-ctas.CodCta = x-codcta
                   NO-LOCK NO-ERROR.

IF AVAILABLE cb-ctas AND NOT cb-ctas.PidAux 
THEN ASSIGN
      x-codaux = ""
      x-clfaux = "".

IF NOT x-detalle THEN DO:
   x-glodoc  = 'Resumen ' + '-' + CcbDCaja.CodRef.      
   
END.
x-signo = IF CcbCCaja.Coddoc = "I/C" THEN 1 ELSE -1.

FIND t-prev WHERE t-prev.coddoc = x-codcbd AND
                  t-prev.nrodoc = x-nrodoc 
                  NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:                  
  CREATE t-prev.
  ASSIGN
    t-prev.tipo    = CcbCCaja.Usuario
    t-prev.periodo = x-periodo
    t-prev.nromes  = x-nromes
    t-prev.codope  = x-codope
    t-prev.coddiv  = x-CodDiv 
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
    
IF x-codmon = 1 
THEN ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-import * x-signo.
/*       t-prev.impmn2  = t-prev.impmn2 + ROUND((x-import / CcbCCaja.TpoCmb),2).*/
ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-import * x-signo
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2) * x-signo.

RELEASE t-prev.
 
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

x-signo = 1.

FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                    /*CcbCDocu.CodDiv = x-coddiv AND*/
                    CcbCDocu.CodDoc = x-CodRef AND 
                    CcbCDocu.NroDoc = x-nrodoc
                    NO-LOCK NO-ERROR.

IF NOT AVAILABLE CcbCDocu THEN DO:
/*   MESSAGE 'Documento no encontrado en los registros ' + x-codref + ' ' + x-nrodoc  VIEW-AS ALERT-BOX.*/
   RETURN.
END.   
IF CcbCdocu.FlgEst = "A" THEN RETURN.

/* RHC 03.09.04 TOMAMOS LA DIVISION DEL DOCUMENTO ORIGEN PARA MATAR SALDOS */
x-CodDiv = CCBCDOCU.CodDiv.
/* ***************************************************** */

FIND B-CDocu WHERE B-CDocu.Codcia = S-CODCIA AND
                   /*B-CDocu.Coddiv = CcbCDocu.Coddiv AND*/
                   B-CDocu.Coddoc = CcbCDocu.Codref AND
                   B-CDocu.Nrodoc = CcbCDocu.Nroref NO-LOCK NO-ERROR.

IF NOT AVAILABLE B-CDocu THEN DO:
  MESSAGE 'Documento ' + CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc SKIP
          'Referencia  ' + CcbCDocu.CodRef + ' ' + CcbCDocu.NroRef + ' No Existe ' 
          VIEW-AS ALERT-BOX.
  RETURN .
END.
                   
FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA AND
            Cb-cfgrv.CodDiv = F-DIVISION AND
            Cb-cfgrv.Coddoc = X-codref AND
            Cb-cfgrv.CodRef = CcbCDocu.Codref AND
            Cb-cfgrv.Fmapgo = B-CDocu.Fmapgo AND
            Cb-cfgrv.Codmon = Ccbcdocu.Codmon NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
  MESSAGE 'Cuenta No Configurada Para ' + CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc  VIEW-AS ALERT-BOX.
  RETURN.
END.
                            
IF CcbCdocu.CodMon = 2 THEN DO: 
   FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCdocu.FchDoc
                      NO-LOCK NO-ERROR.
   IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.Venta.                    
END.                      

/* RHC 03.09.04 TOMAMOS EL AUXILIAR DEL CLIENTE */
X-CODAUX = CcbCDocu.CodCli.

/*X-CODAUX = CCbcdocu.Ruccli.
 * IF LENGTH(X-CODAUX) > 8 THEN X-CODAUX = SUBSTRING(X-CODAUX,3,8).*/

ASSIGN
    x-codcta  = Cb-cfgrv.Codcta
    x-detalle = Cb-cfgrv.Detalle
    x-glodoc  = 'Canc.' + x-codref + '-' + x-nrodoc + ' Cli.' + CcbCCaja.Codcli.      

/*MLR* 15/12/07 ***/
X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE "111111111".
X-NRODOC = IF X-DETALLE THEN CcbCDocu.Nrodoc ELSE SUBSTRING(CcbCDocu.Nrodoc,1,3) + "111111".
/*MLR* ***/

FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                   cb-ctas.CodCta = x-codcta
                   NO-LOCK NO-ERROR.

IF AVAILABLE cb-ctas AND NOT cb-ctas.PidAux 
THEN ASSIGN
      x-codaux = ""
      x-clfaux = "".

FIND t-prev WHERE t-prev.coddoc = x-codcbd AND
                  t-prev.nrodoc = x-nrodoc 
                  NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:                  
   
 CREATE t-prev.
 ASSIGN
    t-prev.tipo    = CcbCCaja.Usuario
    t-prev.periodo = x-periodo
    t-prev.nromes  = x-nromes
    t-prev.codope  = x-codope
    t-prev.coddiv  = x-CodDiv 
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
 IF x-codmon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-import * x-signo.
/*       t-prev.impmn2  = t-prev.impmn2 + ROUND((x-import / CcbCCaja.TpoCmb),2).*/
 ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-import * x-signo
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * x-tpocmb),2) * x-signo.


 RELEASE t-prev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Redondeo W-Win 
PROCEDURE Graba-Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-s AS DECIMAL NO-UNDO.
DEFINE VAR x-d AS DECIMAL NO-UNDO.
DEFINE BUFFER B-prev FOR t-prev.

FOR EACH t-prev NO-LOCK BREAK BY t-prev.coddiv BY t-prev.tipo BY t-prev.nroref BY t-prev.codcta :
    IF FIRST-OF(t-prev.coddiv) THEN DO:
       x-s = 0.
       x-d = 0.
    END.
    x-s = x-s + (t-prev.ImpMn1 * IF t-prev.tpomov THEN -1 ELSE 1).
    x-d = x-d + (t-prev.ImpMn2 * IF t-prev.tpomov THEN -1 ELSE 1).
    IF LAST-OF(t-prev.coddiv) THEN DO:
       IF x-s <> 0  THEN DO:
          x-tpomov = x-s > 0.
          x-codcta = IF x-s > 0 THEN x-rndgan ELSE x-rndper.
          RUN Graba-Rnd (1, ABS(x-s)).
       END.
       IF x-d <> 0  THEN DO:
          x-tpomov = x-d > 0.
          x-codcta = IF x-d > 0 THEN x-rndgan ELSE x-rndper.
          RUN Graba-Rnd (2, ABS(x-d)).
       END.
    END.
END.
END PROCEDURE.

PROCEDURE Graba-Rnd:
/******************/
DEFINE INPUT PARAMETER x-codmon AS INTEGER.
DEFINE INPUT PARAMETER x-import AS DECIMAL.

 CREATE B-prev.
 ASSIGN
    B-prev.tipo    = t-prev.tipo
    B-prev.periodo = x-periodo
    B-prev.nromes  = x-nromes
    B-prev.codope  = x-codope
    B-prev.coddiv  = t-prev.CodDiv 
    B-prev.codmon  = x-codmon
    B-prev.codcta  = x-codcta
    B-prev.fchdoc  = t-prev.fchdoc
    B-prev.tpomov  = x-tpomov
    B-prev.Tpocmb  = t-prev.TpoCmb
    B-prev.glodoc  = 'Diferencia por Redondeo'
    B-prev.nroref  = '999999999'. /* Solo por presentacion */
    
 IF x-codmon = 1 THEN ASSIGN B-prev.impmn1  = x-import.
 ELSE ASSIGN B-prev.impmn2  = x-import.

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
DEFINE VAR x-codcja  AS CHAR    NO-UNDO.
DEFINE VAR x-opera   AS CHAR    NO-UNDO.
DEFINE VAR x-glosa   AS CHAR    NO-UNDO FORMAT "x(40)".
RUN bin\_mes.p(x-nromes, 1, OUTPUT x-nommes).

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN4} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 99 TODAY SKIP(1)
    {&PRN6A} + "CIERRE  DE  CAJA" + {&PRN6B} + {&PRND} AT 50 FORMAT "X(45)" SKIP(1)
    "Division       : " x-codcja SKIP
    "Operacion      : " x-opera FORMAT 'X(40)' SKIP
    "Fecha          : " FILL-IN-fchast  SPACE(10) "Tipo de cambio : " AT 95 x-tpocmb FORMAT '>>>9.999' SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "           CUENTA   CLF  CODIGO   COD.  NUMERO                                                       TIP               S O L E S        " SKIP
    "DIVISION  CONTABLE  AUX AUXILIAR  DOC. DOCUMENTO     C O N C E P T O                             US$ MOV           DEBE          HABER  " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-prev.coddiv  
    t-prev.codcta  
    t-prev.clfaux  
    t-prev.codaux
    t-prev.coddoc
    t-prev.nrodoc
    t-prev.glodoc  FORMAT "X(40)"   
    x-dolares FORMAT "->>>,>>9.99" 
    t-prev.tpomov
    x-debe  FORMAT "->>>>,>>>,>>9.99" 
    x-haber FORMAT "->>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
/*
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN4}.
*/
I-NroItm = 0.
FOR EACH t-prev BREAK BY t-prev.coddiv BY t-prev.tipo BY t-prev.nroref BY t-prev.codcta:
    x-opera = ''.
    FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
         cb-oper.Codope = t-prev.codope NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN 
       x-opera = cb-oper.codope + ' - ' + cb-oper.Nomope.
    x-codcja = t-prev.coddiv.
    VIEW FRAME F-Header.
    IF FIRST-OF(t-prev.tipo) THEN I-Nroitm = 0.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    x-dolares = t-prev.impmn2.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (TOTAL BY t-prev.coddiv BY t-prev.tipo).
    ACCUMULATE x-haber (TOTAL BY t-prev.coddiv BY t-prev.tipo).

    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        t-prev.coddiv  
        t-prev.codcta  
        t-prev.clfaux  
        t-prev.codaux
        t-prev.coddoc
        t-prev.nrodoc
        t-prev.glodoc  FORMAT "X(40)"   
        x-dolares 
        t-prev.tpomov
        x-debe  WHEN x-debe <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-Detalle.
    IF LAST-OF(t-prev.coddiv) THEN DO:
        UNDERLINE 
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        DISPLAY 
            "        TOTAL "    @     t-prev.glodoc 
            ACCUM TOTAL BY t-prev.coddiv x-debe  @ x-debe
            ACCUM TOTAL BY t-prev.coddiv x-haber @ x-haber
            WITH FRAME F-Detalle.
        PAGE.
    END.
END.
/*
OUTPUT CLOSE.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingresos W-Win 
PROCEDURE Ingresos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-fchvto AS DATE NO-UNDO.
DEFINE VAR x-imptot AS DECIMAL NO-UNDO.
DEFINE VAR x-efenac As DECI INIT 0.
DEFINE VAR x-efeusa As DECI INIT 0.
DEFINE VAR x-chqnac As DECI INIT 0.
DEFINE VAR x-chqusa As DECI INIT 0.
DEFINE VAR x-chdnac As DECI INIT 0.
DEFINE VAR x-chdusa As DECI INIT 0.
DEFINE VAR x-depnac As DECI INIT 0.
DEFINE VAR x-depusa As DECI INIT 0.
DEFINE VAR x-codaux AS CHAR.

FOR EACH Ingresos:
    DELETE Ingresos.
END.   

FOR EACH CcbCCaja WHERE CcbCCaja.CodCia = s-codcia AND CcbCCaja.FlgCie = 'C' 
        AND CcbCCaja.FchCie = FILL-IN-fchast 
        AND CcbCCaja.CodDiv = F-DIVISION AND CcbCCaja.Coddoc = "I/C" 
        NO-LOCK BREAK BY CcbCCaja.Usuario:
    IF LOOKUP(CcbCCaja.CodDiv, s-punto) = 0 THEN s-punto = s-punto + ',' + CcbCCaja.CodDiv.
    DISPLAY CcbCCaja.CodDoc + '-' + CcbCCaja.NroDoc @ Fi-Mensaje LABEL "Documento de cobranza "
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDCaja OF CcbCCaja NO-LOCK:
        /* Cancelo provision del documento */
        x-glodoc = 'Canc.' + CcbDCaja.CodRef + '-' + CcbDCaja.NroRef + ' Cli.' + CcbDCaja.Codcli.
        FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
             FacDocum.CodDoc = CcbDCaja.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum 
        THEN ASSIGN
                x-ctalet[1] = FacDocum.CodCta[1]
                x-ctalet[2] = FacDocum.CodCta[2]
                x-tpomov = FacDocum.TpoDoc
                x-codcbd = FacDocum.CodCbd
                x-tpocmb = 0.
/*MLR* 17/01/2008 ***
        IF LOOKUP(CcbDCaja.CodRef, 'TCK,FAC,BOL,N/C,N/D') > 0 
*MLR* ***/
        IF LOOKUP(CcbDCaja.CodRef, 'TCK,FAC,BOL,N/C,N/D,LET') > 0
        THEN RUN Graba-Documento (CcbCCaja.CodDiv, 
                                CcbDCaja.CodMon, 
                                CcbDCaja.ImpTot, 
                                '@CL', 
                                CcbDCaja.CodRef,
                                CcbDCaja.Nroref, 
                                x-fchvto, 
                                x-tpocmb).
        ELSE DO:     
            x-tpomov = TRUE.
            IF CcbCCaja.ImpUsa[1] <> 0 THEN DO:
                IF CcbCCaja.Tipo = "ANTREC" THEN DO:
                    x-codcbd = '34'.
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = CcbCCaja.Tpocmb.
                    x-glodoc = 'Anticipo-Recibido' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    2, 
                                    CcbCCaja.ImpUsa[1], 
                                    '@CL', 
                                    CcbCCaja.Codcli,
                                    SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                                    x-fchvto,
                                    x-tpocmb).
                END.
                ELSE DO:
                    x-codcbd = SUBSTRING(CcbCcaja.Voucher[1],1,3).
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = CcbCCaja.Tpocmb.
                    x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").                      
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    2, 
                                    CcbCCaja.ImpUsa[1], 
                                    '', 
                                    "",
                                    SUBSTRING(CcbCcaja.Voucher[1],4,15), 
                                    CcbCCaja.FchVto[3], 
                                    x-tpocmb).    
                END.
            END.                
            IF CcbCCaja.ImpNac[1] <> 0 THEN DO:
                IF CcbCCaja.Tipo = "ANTREC" THEN DO:
                    x-codcbd = '34'.
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = 0.
                    x-glodoc = 'Anticipo-Recibido' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    1, 
                                    CcbCCaja.ImpNac[1], 
                                    '@CL', 
                                    CcbCCaja.Codcli,
                                    SUBSTRING(CcbCCaja.Voucher[1],4,15), 
                                    x-fchvto,
                                    x-tpocmb).
                END.
                ELSE DO:
                    x-codcbd = SUBSTRING(CcbCcaja.Voucher[1],1,3).
                    x-codcta = CCbCCaja.CodCta[1].
                    x-tpocmb = 0.
                    x-glodoc = CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' ' + SUBSTRING(CcbCCaja.Glosa,1,14,"CHARACTER").       
                    RUN Graba-Caja (CcbCCaja.Coddiv, 
                                    1, 
                                    CcbCCaja.ImpNac[1], 
                                    '', 
                                    "",
                                    SUBSTRING(CcbCcaja.Voucher[1],4,15), 
                                    CcbCCaja.FchVto[3], 
                                    x-tpocmb).
                END.               
            
            END.                

        END.
    END.    
    /* ASIGNAMOS LA MISMA DIVISION QUE LA PROVISION */
    DEF VAR x-CodDiv AS CHAR NO-UNDO.       
    x-CodDiv = CcbCCaja.CodDiv.
    FIND FIRST CcbDCaja OF CcbCCaja NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDCaja THEN DO:
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND CcbCDocu.CodDoc = CcbDCaja.CodRef 
            AND CcbCDocu.NroDoc = CcbDcaja.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN x-CodDiv = ccbcdocu.coddiv.
    END.
    /* ******************************************* */
    x-tpomov = FALSE.
    x-tpocmb = 0.
    IF CcbCCaja.ImpNac[1] > 0 THEN DO:
       x-imptot = CcbCCaja.ImpNac[1] - CcbCCaja.VueNac.
       IF CcbCCaja.ImpUsa[1] = 0 AND CcbCCaja.VueUsa > 0 THEN 
          x-imptot = x-imptot - ROUND((CcbCCaja.VueUsa * CcbCCaja.Tpocmb), 2).
       x-codcta = "".
       x-efenac = x-efenac + x-imptot.
       FIND Ingresos WHERE ingresos.usuario = ccbccaja.usuario
        AND ingresos.coddiv = x-coddiv EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE Ingresos THEN CREATE Ingresos.
       ASSIGN
        Ingresos.usuario = ccbccaja.usuario
        Ingresos.coddiv = x-coddiv
        Ingresos.efenac = Ingresos.efenac + x-imptot.
    END.
    IF CcbCCaja.ImpNac[2] > 0 THEN DO:
       x-codcbd = '32'.
       x-chqnac = x-chqnac + CcbCCaja.ImpNac[2].
       x-codcta = cb-cfgcja.codcta1[2].
       x-tpocmb = 0.
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
       RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[2], '', "",
                            CcbCCaja.Voucher[2], x-fchvto,x-tpocmb).
    END.
    IF CcbCCaja.ImpNac[3] > 0 THEN DO:
       x-codcbd = '32'.
       x-chdnac = x-chdnac + CcbCCaja.ImpNac[3].
       x-codcta = cb-cfgcja.codcta1[3].       
       x-tpocmb = 0.
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[3], '', "",
                            CcbCCaja.Voucher[3], CcbCCaja.FchVto[3], x-tpocmb).
    END.
    IF CcbCCaja.ImpNac[4] > 0 AND LOOKUP(TRIM(CcbCCaja.CodDiv), '00012,00009') > 0 THEN DO:
        x-codcta = cb-cfgcja.codcta1[4].
        x-codaux = ''.
        x-codcbd = ''.
        x-tpocmb = 0.
        /*x-glodoc = 'Canc-No-Deducible' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.*/
        x-glodoc = 'Canc-Tarjeta-Credito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
        /* BUSCAMOS DATOS EL LA CUENTA */
        FIND FIRST CB-CTAS WHERE CB-CTAS.codcia = cb-codcia
             AND CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
        IF AVAILABLE CB-CTAS THEN x-codcbd = cb-ctas.Coddoc.
        CASE CcbCCaja.Voucher[8]:
            WHEN "Visa"         THEN x-codaux = '34119821'.
            WHEN "Mastercard"   THEN x-codaux = '43240552'.
            WHEN "American Express" THEN .
            WHEN "Dinners"      THEN .
        END CASE.
        RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[4], '', x-codaux,
            CcbCCaja.Voucher[4], x-fchvto, x-tpocmb).
    END.
    IF CcbCCaja.ImpNac[5] > 0 THEN DO:
       x-codcta = "".
       x-codcbd = '36'.
       x-tpocmb = 0.
       x-glodoc = 'Canc-Deposito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       x-depnac = x-depnac + CcbCCaja.ImpNac[5].
       FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = CcbCCaja.Codcli
                       AND  ccbboldep.nrodoc = CcbCCaja.Voucher[5]
                       NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ccbboldep THEN DO:
          MESSAGE 'Deposito no se encuentra registrado ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[5] 
                   VIEW-AS ALERT-BOX.
        
       END.                
       IF AVAILABLE ccbboldep THEN DO:
/*          x-codcta = ccbboldep.Codcta.
 *           RUN Graba-Caja (x-Coddiv, 1, CcbCCaja.ImpNac[5], ' ', ' ',
 *                           CcbCCaja.Voucher[5], x-fchvto, x-tpocmb).*/
          x-codcbd = '34'.
          x-codcta = '122101'.
          RUN Graba-Caja (ccbboldep.coddiv /*x-Coddiv*/, 1, CcbCCaja.ImpNac[5], '@CLI', CcbBolDep.CodCli,
                          CcbCCaja.Voucher[5], x-fchvto, x-tpocmb).
       END.                   
    END.
    /**/
    x-tpocmb = 0.
    FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCCaja.FchDoc
                       NO-LOCK NO-ERROR.
    IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.compra.                    

    IF CcbCCaja.ImpUsa[1] > 0 THEN DO:
       x-imptot = CcbCCaja.ImpUsa[1] - CcbCCaja.VueUsa.
       IF CcbCCaja.ImpNac[1] = 0 AND CcbCCaja.VueNac > 0 THEN
          x-imptot = x-imptot - ROUND((CcbCCaja.VueNac / CcbCCaja.Tpocmb), 2).
       x-codcta = "".
       x-efeusa = x-efeusa + x-imptot.
       FIND Ingresos WHERE ingresos.usuario = ccbccaja.usuario
        AND ingresos.coddiv = x-coddiv EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE Ingresos THEN CREATE Ingresos.
       ASSIGN
        Ingresos.usuario = ccbccaja.usuario
        Ingresos.coddiv = x-coddiv
        Ingresos.efeusa = Ingresos.efeusa + x-imptot.
    END.
    IF CcbCCaja.ImpUsa[2] > 0 THEN DO:
       x-codcbd = '32'.
       x-chqusa = x-chqusa + CcbCCaja.ImpUsa[2].
       x-codcta = cb-cfgcja.codcta2[2].       
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[2], '', "",
                            CcbCCaja.Voucher[2], x-fchvto, CcbCCaja.TpoCmb).
    END.
    IF CcbCCaja.ImpUsa[3] > 0 THEN DO:
       x-codcbd = '32'.
       x-chdusa = x-chdusa + CcbCCaja.ImpUsa[3].
       x-codcta = cb-cfgcja.codcta2[3].       
       x-glodoc = 'Canc-Cheque' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.       
       RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[3], '', "",
                            CcbCCaja.Voucher[3], CcbCCaja.FchVto[3], CcbCCaja.TpoCmb).
    END.
    IF CcbCCaja.ImpUsa[4] > 0 AND CcbCCaja.CodDiv = '00012' THEN DO:
        x-codcta = cb-cfgcja.codcta2[4].
        x-codaux = ''.
        x-codcbd = ''.
        /*x-glodoc = 'Canc-No-Deducible' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.              */
        x-glodoc = 'Canc-Tarjeta-Credito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.
        /* BUSCAMOS DATOS EL LA CUENTA */
        FIND FIRST CB-CTAS WHERE CB-CTAS.codcia = cb-codcia
             AND CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
        IF AVAILABLE CB-CTAS THEN x-codcbd = cb-ctas.Coddoc.
        CASE CcbCCaja.Voucher[8]:
            WHEN "Visa"         THEN x-codaux = '34119821'.
            WHEN "Mastercard"   THEN x-codaux = '43240552'.
            WHEN "American Express" THEN .
            WHEN "Dinners"      THEN .
        END CASE.
       RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[4], '', x-codaux,
           CcbCCaja.Voucher[4], x-fchvto, x-tpocmb).
    END.
    IF CcbCCaja.ImpUsa[5] > 0 THEN DO:
       x-codcbd = '36'.
       x-depusa = x-depusa + CcbCCaja.ImpUsa[5].
       x-glodoc = 'Canc-Deposito' + CcbCcaja.CodDoc + '-' + CcbCCaja.Nrodoc + ' Cli.' + CcbCCaja.Codcli.              
       FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = CcbCCaja.Codcli
                       AND  ccbboldep.nrodoc = CcbCCaja.Voucher[5]
                       NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ccbboldep THEN DO:
          MESSAGE 'Deposito no se encuentra registrado ' + CcbCCaja.Codcli + ' ' + CcbCCaja.Voucher[5] 
                   VIEW-AS ALERT-BOX.
        
       END.                
       IF AVAILABLE ccbboldep THEN DO:
/*          x-codcta = ccbboldep.Codcta.
 *           RUN Graba-Caja (x-Coddiv, 2, CcbCCaja.ImpUsa[5], ' ', ' ',
 *                           CcbCCaja.Voucher[5], x-fchvto, CcbCCaja.TpoCmb).*/
          x-codcbd = '34'.
          x-codcta = '122102'.
          RUN Graba-Caja (ccbboldep.coddiv /*x-Coddiv*/, 2, CcbCCaja.ImpUsa[5], '@CLI', CcbBolDep.CodCli,
                          CcbCCaja.Voucher[5], x-fchvto, CcbCCaja.TpoCmb).
       END.                   
    END.
    IF LAST-OF(CcbCCaja.Usuario) THEN DO:
/*        RHC 10.01.05 a pedido de Miluska Cano
 *         x-glodoc = "C A J A " + CcbCCaja.Usuario + " " + STRING(CcbCCaja.FchCie, '99/99/9999').
 *         x-codcta = cb-cfgcja.codcta1[1].
 *         x-codcbd = ''.
 *         x-tpocmb = 0.
 *         FOR EACH Ingresos WHERE Ingresos.usuario = ccbccaja.usuario:
 *             IF Ingresos.EfeNac <> 0
 *             THEN DO:
 *                 x-codcta = cb-cfgcja.codcta1[1].
 *                 x-tpocmb = 0.
 *                 RUN Graba-Caja (Ingresos.CodDiv, 1, Ingresos.efenac, ' '," ","" , x-fchvto, x-tpocmb).
 *             END.
 *             IF Ingresos.EfeUsa <> 0
 *             THEN DO:
 *                 FIND Gn-tcmb WHERE Gn-tcmb.Fecha = CcbCCaja.FchDoc
 *                     NO-LOCK NO-ERROR.
 *                 IF AVAILABL Gn-tcmb THEN x-tpocmb = Gn-tcmb.compra.                    
 *                 x-codcta = cb-cfgcja.codcta2[1].
 *                 RUN Graba-Caja (Ingresos.coddiv, 2, Ingresos.efeusa, ' ',"","", x-fchvto, x-tpocmb).       
 *             END.
 *         END.
 *         x-efenac = 0.
 *         x-efeusa = 0.         */
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
  
  F-DIVISION = S-CODDIV .
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
        TODAY @ FILL-IN-fchast
        F-DIVISION.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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
p-periodo = x-periodo.
p-mes     = x-nromes.

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
 FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
                             cb-control.Coddiv  = F-DIVISION AND
                             cb-control.tipo    = '@CJ' AND
                             cb-control.fchpro  = FILL-IN-fchast NO-LOCK NO-ERROR.

 IF AVAILABLE cb-control THEN DO:
    MESSAGE "Asiento contable ya existe ¨Desea reemplazarlo? " VIEW-AS ALERT-BOX WARNING
             BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN.
 END.
 FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia AND
                           cb-control.Coddiv  = F-DIVISION AND
                           cb-control.tipo    = '@CJ' AND
                           cb-control.fchpro  = FILL-IN-fchast NO-LOCK .

     FIND cb-cmov WHERE cb-cmov.codcia  = p-codcia AND
         cb-cmov.PERIODO = p-periodo AND
         cb-cmov.NROMES  = p-mes     AND
         cb-cmov.CODOPE  = cb-control.codope AND
         cb-cmov.NROAST  = cb-control.nroast NO-ERROR.
     IF AVAILABLE cb-cmov THEN 
        RUN anula-asto(
            p-codcia,
            p-periodo,
            p-mes,
            cb-control.codope,
            cb-control.nroast ).
     /* Elimino la informacion del temporal */
     RUN anula-temporal(
         p-codcia,
         p-periodo,
         p-mes,
         cb-control.codope,
         cb-control.nroast ).
 END.
   
FOR EACH t-prev BREAK BY t-prev.tipo :
    IF FIRST-OF(t-prev.tipo) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
                             cb-control.Coddiv  = F-DIVISION AND
                             cb-control.tipo    = '@CJ' AND
                             cb-control.fchpro  = FILL-IN-fchast AND
                             cb-control.tipmov  = t-prev.tipo
                             NO-ERROR.

       IF AVAILABLE cb-control THEN 
          ASSIGN
             p-Codope = cb-control.Codope 
             p-nroast = cb-control.Nroast.
       ELSE DO:
          p-codope = t-prev.codope.
          RUN cbd/cbdnast.p(cb-codcia,
                            p-codcia, 
                            p-periodo, 
                            p-Mes, 
                            p-codope, 
                            OUTPUT x-nroast). 
          p-nroast = STRING(x-nroast, '999999').
          CREATE cb-control.
          ASSIGN
             cb-control.tipo    = '@CJ'
             cb-control.CodCia  = p-codcia
             cb-control.Periodo = x-periodo
             cb-control.Nromes  = x-nromes 
             cb-control.fchpro  = FILL-IN-fchast
             cb-control.Codope  = p-Codope
             cb-control.Nroast  = p-nroast
             cb-control.coddiv  = F-DIVISION            /* t-prev.coddiv. */
             cb-control.tipmov  = t-prev.tipo.
       END.
       ASSIGN
          cb-control.Usuario = s-user-id
          cb-control.Hora    = STRING(TIME,'HH:MM:SS')
          cb-control.fecha   = TODAY.
       d-uno  = 0.
       d-dos  = 0.
       h-uno  = 0.
       h-dos  = 0.
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
        CB-DMOV.FCHDOC  = FILL-IN-fchast.
        CB-DMOV.FCHVTO  = IF t-prev.fchvto = ? THEN FILL-IN-fchast ELSE t-prev.fchvto.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = t-prev.codmon.
        CB-DMOV.tpocmb  = t-prev.tpocmb.
        cb-dmov.C-FCaja = "12".
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
        T-CB-DMOV.codcia  = p-codcia.
        T-CB-DMOV.PERIODO = p-periodo.
        T-CB-DMOV.NROMES  = p-mes.
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
        T-CB-DMOV.FCHDOC  = FILL-IN-fchast.
        T-CB-DMOV.FCHVTO  = FILL-IN-fchast.
        T-CB-DMOV.FLGACT  = TRUE.
        T-CB-DMOV.RELACION = 0.
        T-CB-DMOV.codmon  = t-prev.codmon.
        T-CB-DMOV.tpocmb  = t-prev.tpocmb.
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
    IF LAST-OF(t-prev.tipo) THEN DO:
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
       cb-cmov.Fchast = FILL-IN-fchast.
       cb-cmov.TOTITM = J.
       cb-cmov.CODMON = 1.
       cb-cmov.TPOCMB = x-Tpocmb.
       cb-cmov.DBEMN1 = d-uno.
       cb-cmov.DBEMN2 = d-dos.
       cb-cmov.HBEMN1 = h-uno.
       cb-cmov.HBEMN2 = h-dos.
       cb-cmov.NOTAST = 'CIERRE DE CAJA TIENDA ' + F-DIVISION + "-" + Gn-Divi.DesDiv.
       cb-cmov.GLOAST = 'CIERRE DE CAJA TIENDA ' + F-DIVISION + "-" + Gn-Divi.DesDiv.

    END.
END.

RUN Actualiza-Flag.
MESSAGE ' PROCESO CONCLUIDO  ' SKIP
        'Periodo : ' + STRING(cb-control.periodo, '9999') SKIP
        'Mes     : ' + STRING(cb-control.nromes, '99') SKIP 
        'Asiento : ' + cb-control.codope + '-' + cb-control.nroast
        VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


