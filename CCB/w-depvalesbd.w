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

/*
    Modificó    : Miguel Landeo (ML01)
    Fecha       : 03/Oct/2009
    Objetivo    : Carga RUC de ccbcdocu.
*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR x-ctaigv  AS CHAR NO-UNDO.
DEFINE VAR x-ctadto  AS CHAR NO-UNDO.
DEFINE VAR x-ctaisc  AS CHAR NO-UNDO.
DEFINE VAR x-codope  AS CHAR NO-UNDO.
DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.

DEFINE VAR FILL-IN-fchast AS DATE NO-UNDO.

/*ML01*/ DEFINE VARIABLE cRuc AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE T-DMOV LIKE CcbDMvto
    INDEX Llave01 CodCia CodDiv.
    
DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov
    FIELD Tipo   AS CHAR
    FIELD fchvta AS DATE
    FIELD fchast LIKE cb-cmov.fchast.
    
DEFINE BUFFER B-prev  FOR t-prev.
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-Docum FOR FacDocum.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR X-nrodoc1 AS CHAR INITIAL '' NO-UNDO.
DEFINE VAR X-nrodoc2 AS CHAR INITIAL '' NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(50)" .

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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes f-Division B-filtro ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-NroMes f-Division ~
FILL-IN-fchast-1 FILL-IN-fchast-2 FILL-IN-Tpocmb FILL-IN-TcCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-chqdifcbd AS HANDLE NO-UNDO.

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
     x-Periodo AT ROW 1.19 COL 9 COLON-ALIGNED
     x-NroMes AT ROW 2.15 COL 9 COLON-ALIGNED
     f-Division AT ROW 3.12 COL 9 COLON-ALIGNED
     FILL-IN-fchast-1 AT ROW 1.96 COL 30 COLON-ALIGNED NO-LABEL
     FILL-IN-fchast-2 AT ROW 1.96 COL 42 COLON-ALIGNED NO-LABEL
     FILL-IN-Tpocmb AT ROW 3.38 COL 30 COLON-ALIGNED NO-LABEL
     FILL-IN-TcCompra AT ROW 3.38 COL 42.43 COLON-ALIGNED NO-LABEL
     B-filtro AT ROW 2.42 COL 64
     B-Transferir AT ROW 2.42 COL 72.14
     B-Imprimir AT ROW 2.42 COL 80.29
     BUTTON-1 AT ROW 2.35 COL 88 WIDGET-ID 22
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 4.15 COL 80.86
     "DEPOSITO DE VALES SODEXHO" VIEW-AS TEXT
          SIZE 36 BY .85 AT ROW 1.19 COL 58
          FONT 12
     "Fecha de Proceso" VIEW-AS TEXT
          SIZE 13.43 BY .5 AT ROW 1.38 COL 36
     "T.C.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 32.57
     "T.C.Compra" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 44.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.29 BY 17
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
         TITLE              = "ASIENTO CONTABLE POR DEPOSITO DE VALES SODEXHO"
         HEIGHT             = 14.23
         WIDTH              = 94.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 95.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 95.57
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON B-Imprimir IN FRAME F-Main
   NO-ENABLE                                                            */
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
ON END-ERROR OF W-Win /* ASIENTO CONTABLE POR DEPOSITO DE VALES SODEXHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIENTO CONTABLE POR DEPOSITO DE VALES SODEXHO */
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

    RUN Carga-Temporal.
    B-Transferir:SENSITIVE = YES.
    B-Imprimir:SENSITIVE   = YES.  
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


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = YEAR(FILL-IN-fchast-1) NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[MONTH(FILL-IN-fchast-1) + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia 
    AND cb-control.Coddiv = F-DIVISION 
    AND cb-control.tipo   = '@VAL' 
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

  /* SE VA A GENERAR UN SOLO ASIENTO POR DIVISION */
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").  
  RUN Asiento-Detallado.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
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
             INPUT  'CCB/b-chqdifcbd.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-chqdifcbd ).
       RUN set-position IN h_b-chqdifcbd ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-chqdifcbd ( 10.00 , 91.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-chqdifcbd ,
             x-Periodo:HANDLE IN FRAME F-Main , 'BEFORE':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ajusta-Redondeo W-Win 
PROCEDURE Ajusta-Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-debe1  AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VAR x-haber1 AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VAR x-tpomov AS LOGICAL NO-UNDO.
DEFINE VAR x-codcta AS CHAR    NO-UNDO.
DEFINE BUFFER B-T-PREV FOR t-prev.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.

/* Verifico si existe Diferencia de Cambio */
FOR EACH t-prev BREAK BY t-prev.coddiv
                      BY t-prev.coddoc
                      BY t-prev.nrodoc:
  
   IF FIRST-OF(t-prev.nrodoc) THEN DO:
      x-debe1 = 0.
      x-haber1 = 0.
   END.
   IF t-prev.tpomov THEN x-haber1 = x-haber1 + t-prev.impmn1.
   ELSE x-debe1 = x-debe1 + t-prev.impmn1.
   IF LAST-OF(t-prev.nrodoc) THEN DO:
      IF x-debe1 <> x-haber1 AND  ROUND(ABSOLUTE(x-debe1 - x-haber1),2) > 0 THEN DO:         
         FIND B-T-PREV WHERE B-T-PREV.Coddiv = t-prev.coddiv AND
                             B-T-PREV.Coddoc = t-prev.coddoc AND
                             B-T-PREV.nrodoc = t-prev.nrodoc AND
                             B-T-PREV.Codcta = cb-cfgg.codcta[5] NO-ERROR.
         IF AVAILABLE B-T-PREV THEN DO:
            IF x-debe1 > x-haber1 THEN DO:
               IF b-t-prev.tpomov THEN b-t-prev.impmn1 = b-t-prev.impmn1 + ( x-debe1 - x-haber1 ) .
               ELSE b-t-prev.impmn1 = b-t-prev.impmn1 - ( x-debe1 - x-haber1 ) .
            END.
            IF x-debe1 < x-haber1 THEN DO:
               IF b-t-prev.tpomov THEN b-t-prev.impmn1 = b-t-prev.impmn1 - ( x-haber1 - x-debe1 ) .
               ELSE b-t-prev.impmn1 = b-t-prev.impmn1 + ( x-haber1 - x-debe1 ) .
            END.
            RELEASE B-T-PREV.
         END.
      END.
    END.     
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asiento-Detallado W-Win 
PROCEDURE Asiento-Detallado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR p-codcia  AS INTE NO-UNDO.
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

ASSIGN
    p-codcia  = s-codcia
    p-periodo = INTEGER(x-Periodo)
    p-mes     = INTEGER(x-NroMes).

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN RETURN.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia AND
    cb-control.CodDiv  = F-DIVISION AND
    cb-control.Periodo = p-Periodo AND
    cb-control.NroMes  = p-Mes AND
    cb-control.Tipo    = '@VAL':
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
        DELETE cb-cmov.    
    END.
    DELETE cb-control.
END.

FOR EACH t-prev BREAK BY t-prev.coddiv BY t-prev.coddoc BY t-prev.nrodoc:
    IF FIRST-OF(t-prev.coddiv) THEN DO:
       p-codope = t-prev.codope.
       RUN cbd/cbdnast.p(cb-codcia,
                         p-codcia, 
                         p-periodo, 
                         p-Mes, 
                         p-codope, 
                         OUTPUT x-nroast). 
       ASSIGN
           p-nroast = STRING(x-nroast, '999999')
           d-uno  = 0
           d-dos  = 0
           h-uno  = 0
           h-dos  = 0
           j      = 0.
       CREATE cb-control.
       ASSIGN
           cb-control.tipo    = '@VAL'
           cb-control.CodCia  = p-codcia
           cb-control.Coddiv  = t-prev.coddiv
           cb-control.Periodo = p-periodo
           cb-control.Nromes  = p-mes 
           cb-control.NroAst  = p-NroAst
           cb-control.fchpro  = FILL-IN-fchast-2
           cb-control.Codope  = p-Codope
           cb-control.Usuario = s-user-id
           cb-control.Hora    = STRING(TIME,'HH:MM:SS')
           cb-control.fecha   = TODAY.
    END.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    ASSIGN
        x-clfaux = cb-ctas.clfaux
        x-coddoc = cb-ctas.piddoc.
        J = J + 1.
    CREATE CB-DMOV.
    ASSIGN
        CB-DMOV.codcia  = p-codcia
        CB-DMOV.PERIODO = p-periodo
        CB-DMOV.NROMES  = p-mes
        CB-DMOV.CODOPE  = p-codope
        CB-DMOV.NROAST  = p-nroast
        CB-DMOV.NROITM  = J
        CB-DMOV.codcta  = t-prev.codcta
        CB-DMOV.coddiv  = t-prev.coddiv
        CB-DMOV.cco     = t-prev.cco
        Cb-dmov.Coddoc  = (IF x-coddoc THEN t-prev.coddoc ELSE '')
        Cb-dmov.Nrodoc  = (IF x-coddoc THEN t-prev.nrodoc ELSE '')
        CB-DMOV.clfaux  = (IF x-clfaux <> '' THEN x-clfaux ELSE '')
        CB-DMOV.codaux  = (IF x-clfaux <> '' THEN t-prev.codaux ELSE '')
        CB-DMOV.Nroruc  = (IF x-clfaux <> '' THEN t-prev.nroruc ELSE '')
        CB-DMOV.GLODOC  = t-prev.glodoc
        CB-DMOV.tpomov  = t-prev.tpomov
        CB-DMOV.impmn1  = t-prev.impmn1
        CB-DMOV.impmn2  = t-prev.impmn2
        CB-DMOV.FCHDOC  = t-prev.Fchdoc
        CB-DMOV.FCHVTO  = t-prev.Fchvto
        CB-DMOV.FLGACT  = TRUE
        CB-DMOV.RELACION = 0
        CB-DMOV.TM      = t-prev.tm
        CB-DMOV.codmon  = t-prev.codmon
        CB-DMOV.tpocmb  = t-prev.tpocmb
        CB-DMOV.codref  = t-prev.codref
        CB-DMOV.nroref  = t-prev.nroref.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
    IF CB-DMOV.tpomov THEN DO:
        h-uno = h-uno + CB-DMOV.impmn1.
        h-dos = h-dos + CB-DMOV.impmn2.
    END.
    ELSE DO:
        d-uno = d-uno + CB-DMOV.impmn1.
        d-dos = d-dos + CB-DMOV.impmn2.
    END.
    /* Preparando para Autom ticas */
    x-GenAut = 0.
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
        ASSIGN
            detalle.CodCia   = cb-dmov.CodCia
            detalle.Periodo  = cb-dmov.Periodo
            detalle.NroMes   = cb-dmov.NroMes
            detalle.CodOpe   = cb-dmov.CodOpe
            detalle.NroAst   = cb-dmov.NroAst
            detalle.TpoItm   = "A"
            detalle.Relacion = RECID(cb-dmov)
            detalle.CodMon   = cb-dmov.CodMon
            detalle.TpoCmb   = cb-dmov.TpoCmb
            detalle.NroItm   = cb-dmov.NroItm
            detalle.Codcta   = cb-dmov.CtaAut
            detalle.CodDiv   = cb-dmov.CodDiv
            detalle.ClfAux   = cb-dmov.ClfAux
            detalle.CodAux   = cb-dmov.CodCta
            detalle.NroRuc   = cb-dmov.NroRuc
            detalle.CodDoc   = cb-dmov.CodDoc
            detalle.NroDoc   = cb-dmov.NroDoc
            detalle.GloDoc   = cb-dmov.GloDoc
            detalle.CodMon   = cb-dmov.CodMon
            detalle.TpoCmb   = cb-dmov.TpoCmb
            detalle.TpoMov   = cb-dmov.TpoMov
            detalle.NroRef   = cb-dmov.NroRef
            detalle.FchDoc   = cb-dmov.FchDoc
            detalle.FchVto   = cb-dmov.FchVto
            detalle.ImpMn1   = cb-dmov.ImpMn1
            detalle.ImpMn2   = cb-dmov.ImpMn2
            detalle.ImpMn3   = cb-dmov.ImpMn3
            detalle.Tm       = cb-dmov.Tm
            detalle.CCO      = cb-dmov.CCO
            detalle.codref   = cb-dmov.codref
            detalle.nroref   = cb-dmov.nroref.
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
        ASSIGN
            detalle.CodCia   = cb-dmov.CodCia
            detalle.Periodo  = cb-dmov.Periodo
            detalle.NroMes   = cb-dmov.NroMes
            detalle.CodOpe   = cb-dmov.CodOpe
            detalle.NroAst   = cb-dmov.NroAst
            detalle.TpoItm   = "A"
            detalle.Relacion = RECID(cb-dmov)
            detalle.CodMon   = cb-dmov.CodMon
            detalle.TpoCmb   = cb-dmov.TpoCmb
            detalle.NroItm   = cb-dmov.NroItm
            detalle.Codcta   = cb-dmov.Ctrcta
            detalle.CodDiv   = cb-dmov.CodDiv
            detalle.ClfAux   = cb-dmov.ClfAux
            detalle.CodAux   = cb-dmov.CodCta
            detalle.NroRuc   = cb-dmov.NroRuc
            detalle.CodDoc   = cb-dmov.CodDoc
            detalle.NroDoc   = cb-dmov.NroDoc
            detalle.GloDoc   = cb-dmov.GloDoc
            detalle.CodMon   = cb-dmov.CodMon
            detalle.TpoCmb   = cb-dmov.TpoCmb
            detalle.TpoMov   = NOT cb-dmov.TpoMov
            detalle.ImpMn1   = cb-dmov.ImpMn1
            detalle.ImpMn2   = cb-dmov.ImpMn2
            detalle.ImpMn3   = cb-dmov.ImpMn3
            detalle.NroRef   = cb-dmov.NroRef
            detalle.FchDoc   = cb-dmov.FchDoc
            detalle.FchVto   = cb-dmov.FchVto
            detalle.Tm       = cb-dmov.Tm
            detalle.CCO      = cb-dmov.CCO
            detalle.codref   = cb-dmov.codref
            detalle.nroref   = cb-dmov.nroref.
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
    IF LAST-OF(t-prev.coddiv) THEN DO:
       FIND cb-cmov WHERE cb-cmov.codcia  = p-codcia AND
           cb-cmov.PERIODO = p-periodo AND
           cb-cmov.NROMES  = p-mes AND
           cb-cmov.CODOPE  = p-codope AND
           cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
           CREATE cb-cmov.
           ASSIGN
               cb-cmov.codcia  = p-codcia
               cb-cmov.PERIODO = p-periodo
               cb-cmov.NROMES  = p-mes
               cb-cmov.CODOPE  = p-codope
               cb-cmov.NROAST  = p-nroast. 
       END.
       ASSIGN
           cb-cmov.Coddiv = t-prev.coddiv
           cb-cmov.Fchast = FILL-IN-fchast-2
           cb-cmov.TOTITM = J
           cb-cmov.CODMON = t-prev.codmon
           cb-cmov.TPOCMB = t-prev.tpocmb
           cb-cmov.DBEMN1 = d-uno
           cb-cmov.DBEMN2 = d-dos
           cb-cmov.HBEMN1 = h-uno
           cb-cmov.HBEMN2 = h-dos
           cb-cmov.NOTAST = 'DEPOSITO DE TARJETAS DE CREDITO'
           cb-cmov.GLOAST = ''.
    END.
END.
/*MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.*/
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
DEFINE INPUT PARAMETER x-codcbd AS CHAR.
DEFINE INPUT PARAMETER x-coddoc AS CHAR.

DEFINE VAR x-debe1  AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VAR x-haber1 AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VAR x-tpomov AS LOGICAL NO-UNDO.
DEFINE VAR x-codcta AS CHAR    NO-UNDO.

/* Verifico si existe Diferencia de Cambio */
FOR EACH t-prev WHERE t-prev.coddoc = X-CodCbd BREAK BY t-prev.coddiv:
   IF FIRST-OF(t-prev.coddiv) THEN DO:
      x-debe1 = 0.
      x-haber1 = 0.
   END.
   IF t-prev.tpomov THEN x-haber1 = x-haber1 + t-prev.impmn1.
   ELSE x-debe1 = x-debe1 + t-prev.impmn1.
   IF LAST-OF(t-prev.coddiv) THEN DO:
      IF x-debe1 <> x-haber1 AND  ROUND(ABSOLUTE(x-debe1 - x-haber1),2) > 0 THEN DO:         
         IF x-debe1 > x-haber1 THEN DO:
           x-tpomov = TRUE.
           x-codcta = x-ctaper.
           END.
         ELSE DO:
           x-tpomov = FALSE.
           x-codcta = x-ctagan.
         END.
         FIND B-prev WHERE B-prev.coddoc = X-CodCbd AND B-prev.codcta = x-codcta AND
              B-prev.coddiv = t-prev.Coddiv AND
              B-prev.tpomov = x-tpomov NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-prev THEN DO:
           CREATE B-prev.
           ASSIGN
              B-prev.periodo = p-periodo
              B-prev.nromes  = p-mes
              B-prev.codope  = x-codope
              B-prev.coddiv  = t-prev.CodDiv 
              B-prev.codmon  = 1
              B-prev.codcta  = x-codcta
              B-prev.fchdoc  = FILL-IN-fchast
              B-prev.tpomov  = x-tpomov
              B-prev.clfaux  = '@CL'
              B-prev.codaux  = '01'
              B-prev.coddoc  = X-CodCbd
              B-prev.nrodoc  = STRING(FILL-IN-fchast, '99/99/9999')
              B-prev.tm      = 01.
         END.
         ASSIGN
            B-prev.impmn1  = B-prev.impmn1 + ABSOLUTE(x-debe1 - x-haber1)
            B-prev.Tpocmb  = FILL-IN-Tpocmb
            B-prev.glodoc  = 'Ajuste Dif.Cambio'.
      END.
   END.
END.

/* Verifico rendondeo del importe en dolares */
FOR EACH t-prev WHERE t-prev.coddoc = X-CodCbd BREAK BY t-prev.coddiv:
   IF FIRST-OF(t-prev.coddiv) THEN DO:
      x-debe1 = 0.
      x-haber1 = 0.
   END.
   IF t-prev.tpomov THEN x-haber1 = x-haber1 + t-prev.impmn2.
   ELSE x-debe1 = x-debe1 + t-prev.impmn2.
   IF LAST-OF(t-prev.coddiv) THEN DO:
      IF x-debe1 <> x-haber1 AND  ROUND(ABSOLUTE(x-debe1 - x-haber1),2) > 0 THEN DO:         
         IF x-debe1 > x-haber1 THEN DO:
           x-tpomov = TRUE.
           x-codcta = x-rndper.
           END.
         ELSE DO:
           x-tpomov = FALSE.
           x-codcta = x-rndgan.
         END.
         FIND B-prev WHERE B-prev.coddoc = X-CodCbd AND B-prev.codcta = x-codcta AND
              B-prev.coddiv = t-prev.Coddiv AND
              B-prev.tpomov = x-tpomov NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-prev THEN DO:
           CREATE B-prev.
           ASSIGN
              B-prev.periodo = p-periodo
              B-prev.nromes  = p-mes
              B-prev.codope  = x-codope
              B-prev.coddiv  = t-prev.CodDiv 
              B-prev.codmon  = 1
              B-prev.codcta  = x-codcta
              B-prev.fchdoc  = FILL-IN-fchast
              B-prev.tpomov  = x-tpomov
              B-prev.clfaux  = '@CL'
              B-prev.codaux  = '01'
              B-prev.coddoc  = X-CodCbd
              B-prev.nrodoc  = STRING(FILL-IN-fchast, '99/99/9999')
              B-prev.tm      = 01.
         END.
         ASSIGN
            B-prev.impmn2  = B-prev.impmn2 + ABSOLUTE(x-debe1 - x-haber1)
            B-prev.Tpocmb  = FILL-IN-Tpocmb
            B-prev.glodoc  = 'Ajuste por Rendondeo'.
      END.
   END.
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

DEF VAR x-CodCta AS CHAR.
DEF VAR x-Importe AS DEC.
DEF VAR x-CodMon AS INT.
DEF VAR x-NroDoc AS CHAR.
DEF VAR x-CodAux AS CHAR.

/* Cuenta del TCR (Tarjetas de Crédito) */
FIND FIRST Facdocum WHERE Facdocum.codcia = s-codcia
    AND Facdocum.coddoc = "VAL"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Facdocum OR FacDocum.CodCta[1] = '' OR Facdocum.CodCta[2] = '' THEN DO:
    MESSAGE 'NO está configurado el documento TCR' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
x-CodCta = FacDocum.CodCta[1].      /* Una sola cuenta para los dos */

/* BARREMOS TODO EL MES */
EMPTY TEMP-TABLE t-prev.

/* CARGAMOS LA INFORMACION EN EL TEMPORAL */
EMPTY TEMP-TABLE T-DMOV.
FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.codcia = s-codcia
    AND Ccbdmvto.coddiv = f-Division
    AND Ccbdmvto.coddoc = "I/C"
    AND Ccbdmvto.codref = "VAL"
    AND Ccbdmvto.flgest = "C"
    AND Ccbdmvto.fchemi >= FILL-IN-fchast-1
    AND Ccbdmvto.fchemi <= FILL-IN-fchast-2:
    CREATE T-DMOV.
    BUFFER-COPY Ccbdmvto TO T-DMOV.
END.
/* CARGAMOS ASIENTO */
FOR EACH T-DMOV WHERE T-DMOV.CodCta <> '' BREAK BY T-DMOV.CodDiv:
    /* ********************* CUENTA 16291100 ***************** */
    ASSIGN
        x-Importe = ( T-DMOV.DepNac[1] + T-DMOV.DepNac[2] )
        x-CodCta = FacDocum.CodCta[1]
        x-CodAux = ""
        x-CodMon = (IF T-DMOV.DepNac[2] > 0 THEN 2 ELSE 1).
    RUN Graba-Documentos ("13", x-CodCta, YES, x-Importe, x-NroDoc, x-CodMon, x-CodAux).
    /* ************* CUENTA 104XXXXX ***************** */
    ASSIGN
        x-Importe = ( T-DMOV.DepNac[1] + T-DMOV.DepNac[2] ) * 0.941
        x-CodCta = T-DMOV.codcta
        x-NroDoc = T-DMOV.NroDep.
    RUN Graba-Documentos ("13", x-CodCta, NO, x-Importe, x-NroDoc, x-CodMon, x-CodAux).
END.

/*RUN Ajusta-Redondeo.   */
HIDE FRAME F-Proceso.

RUN dispatch IN h_b-chqdifcbd ('open-query':U).
RUN Totales IN h_b-chqdifcbd.

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
  DISPLAY x-Periodo x-NroMes f-Division FILL-IN-fchast-1 FILL-IN-fchast-2 
          FILL-IN-Tpocmb FILL-IN-TcCompra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo x-NroMes f-Division B-filtro BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Documentos W-Win 
PROCEDURE Graba-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
DEFINE INPUT PARAMETER X-codcta  AS CHAR.
DEFINE INPUT PARAMETER X-tpomov  AS LOGICAL.
DEFINE INPUT PARAMETER X-importe AS DECIMAL.
DEFINE INPUT PARAMETER X-nrodoc  AS CHAR.
DEFINE INPUT PARAMETER X-codmon  AS INTEGER.
DEFINE INPUT PARAMETER x-CodAux  AS CHAR.


FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
    cb-ctas.codcta = x-codcta NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN MESSAGE 'Cuenta' x-codcta 'NO configurada' VIEW-AS ALERT-BOX ERROR.

/* VARIABLES QUE GUARDAN EN TIPO DE CAMBIO */
DEF VAR x-TCVenta  AS DEC.
DEF VAR x-TCCompra AS DEC.
DEF VAR x-CodCli   AS CHAR.
/*DEF VAR x-CodAux   AS CHAR.*/
DEF VAR x-Glosa    AS CHAR.
 
ASSIGN
    x-TCVenta = FILL-IN-Tpocmb
    x-TCCompra = FILL-IN-TcCompra
    x-CodOpe   = "001".     /* BANCO INGRESOS */

/* TIPO DE CAMBIO DEL DIA */
FIND gn-tcmb WHERE gn-tcmb.fecha = T-DMOV.FchEmi NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-tcmb 
THEN MESSAGE 'Tipo de cambio del dia' T-DMOV.FchEmi  'NO está configurado'
        VIEW-AS ALERT-BOX WARNING.
ELSE ASSIGN
        x-TCVenta  = gn-tcmb.venta
        x-TCCompra = gn-tcmb.compra.
 
ASSIGN
     X-CODCLI = T-DMOV.CodCli
     /*X-CODAUX = T-DMOV.CodCli*/
     X-GLOSA  = 'Depósito de vales Sodexho'.
 
 FIND CB-CTAS WHERE CB-CTAS.codcia = cb-codcia AND 
     CB-CTAS.codcta = x-codcta NO-LOCK NO-ERROR.
 IF AVAILABLE CB-CTAS 
 THEN DO:
    /*x-Cco    = IF CB-CTAS.PidCco THEN x-Cco    ELSE ''.*/
    /*x-CodAux = IF CB-CTAS.PidAux THEN x-CodAux ELSE ''.*/
 END.    

        
CREATE t-prev.
ASSIGN
     t-prev.periodo = p-periodo
     t-prev.nromes  = p-mes
     t-prev.codope  = x-codope
     t-prev.coddiv  = T-DMOV.CodDiv 
     t-prev.codcta  = x-codcta
     t-prev.fchdoc  = T-DMOV.FchEmi
     t-prev.fchvto  = T-DMOV.FchVto
     t-prev.tpomov  = x-tpomov
     t-prev.clfaux  = (IF x-codcta BEGINS '104' THEN '@PV' ELSE '@CL')
     t-prev.nroruc  = (IF cRuc <> "" THEN cRuc ELSE x-codcli)
     t-prev.codaux  = X-CodAux
     t-prev.codmon  = x-codmon
     t-prev.coddoc  = X-CodCbd
     t-prev.nrodoc  = x-nrodoc.

IF x-CodMon = 1 
THEN ASSIGN
        t-prev.impmn1  = x-importe.
ELSE ASSIGN
        t-prev.impmn2  = x-importe
        t-prev.impmn1  = ROUND(( x-importe * x-TCVenta ) ,2).  
ASSIGN
     t-prev.Tpocmb  = (IF x-CodMon = 2 THEN x-TCVenta ELSE 0)
     t-prev.glodoc  = (IF T-DMOV.FlgEst = "A" THEN "ANULADO" ELSE X-GLOSA)
     t-prev.codaux  = (IF T-DMOV.FlgEst = "A" THEN "" ELSE t-prev.codaux)
     t-prev.nroruc  = (IF T-DMOV.FlgEst = "A" THEN "" ELSE t-prev.nroruc)
     t-prev.clfaux  = (IF T-DMOV.FlgEst = "A" THEN "" ELSE t-prev.clfaux).
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
DEFINE VAR I-nroitm AS INTEGER NO-UNDO.
DEFINE VAR x-debe   AS DECIMAL NO-UNDO.
DEFINE VAR x-haber  AS DECIMAL NO-UNDO.

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 110 TODAY SKIP(1)
    {&PRN6A} + "REGISTRO DE VENTAS" + {&PRN6B} + {&PRND} AT 50 FORMAT "X(45)" SKIP(1)
    "Operacion      : " x-codope SKIP
    "Fecha          : " FILL-IN-fchast SPACE(10) "Tipo de cambio : " AT 65 FILL-IN-tpocmb SKIP
    "--------------------------------------------------------------------------------------------------------------------------" SKIP
    "           CUENTA       CLF  CODIGO   COD.  NUMERO                                   TIP                                  " SKIP
    "DIVISION  CONTABLE  CCO AUX AUXILIAR  DOC. DOCUMENTO     C O N C E P T O             MOV           DEBE          HABER    " SKIP
    "--------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-prev.coddiv  
    t-prev.codcta  
    t-prev.cco
    t-prev.clfaux  
    t-prev.codaux
    t-prev.coddoc
    t-prev.nrodoc
    t-prev.glodoc
    t-prev.tpomov
    x-debe  FORMAT ">>>>,>>>,>>9.99" 
    x-haber FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

/*MLR* 26/11/07 ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT PRINTER TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT PRINTER TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT PRINTER TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

I-NroItm = 0.
FOR EACH t-prev BREAK BY t-prev.coddiv BY t-prev.coddoc :
    VIEW FRAME F-Header.
    IF FIRST-OF(t-prev.coddiv) THEN  I-Nroitm = 0.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (TOTAL BY t-prev.coddiv).
    ACCUMULATE x-haber (TOTAL BY t-prev.coddiv).
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        t-prev.coddiv  
        t-prev.codcta  
        t-prev.cco
        t-prev.clfaux  
        t-prev.codaux
        t-prev.coddoc
        t-prev.nrodoc
        t-prev.glodoc
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
            "        TOTAL "    @ t-prev.glodoc
            ACCUM TOTAL BY t-prev.coddiv x-debe  @ x-debe
            ACCUM TOTAL BY t-prev.coddiv x-haber @ x-haber
            WITH FRAME F-Detalle.
        PAGE.
    END.
END.
/*MLR* 26/11/07 ***
OUTPUT CLOSE.
* ***/
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
        x-ctagan = cb-cfgg.codcta[1] 
        x-ctaper = cb-cfgg.codcta[2].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Redondeo no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
  
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN DO:
     ASSIGN
        x-ctaisc = cb-cfgg.codcta[2] 
        x-ctaigv = cb-cfgg.codcta[3]
        x-ctadto = cb-cfgg.codcta[10]
        x-codope = cb-cfgg.Codope.
     END.
  ELSE DO:
     MESSAGE 'Configuracion de Registro de Ventas no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.

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
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Imprimir.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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

