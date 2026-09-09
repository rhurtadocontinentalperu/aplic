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
DEFINE SHARED VAR cl-codcia AS INTEGER.
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
DEFINE VAR x-CtaICBPER AS CHAR NO-UNDO.

DEFINE VAR FILL-IN-fchast AS DATE NO-UNDO.

/*ML01*/ DEFINE VARIABLE cRuc AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE T-CDOC LIKE CCBCDOCU      /* ARCHIVO DE TRABAJO */
    INDEX LLAVE01 CodDiv Cco NroDoc.
    
DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov
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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes f-Division B-filtro 
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
DEFINE VARIABLE h_b-vtacbd3 AS HANDLE NO-UNDO.
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

DEFINE VARIABLE f-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 15
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
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 4.15 COL 80.86
     " REGISTRO  DE  VENTAS MENSUAL" VIEW-AS TEXT
          SIZE 34 BY .85 AT ROW 1.19 COL 58
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
         SIZE 137.29 BY 23.62
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
         TITLE              = "Generacion de Asiento Contable Mensual por Centro de Costo"
         HEIGHT             = 23.62
         WIDTH              = 137.29
         MAX-HEIGHT         = 24.77
         MAX-WIDTH          = 149.72
         VIRTUAL-HEIGHT     = 24.77
         VIRTUAL-WIDTH      = 149.72
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
ON END-ERROR OF W-Win /* Generacion de Asiento Contable Mensual por Centro de Costo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Asiento Contable Mensual por Centro de Costo */
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
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[MONTH(FILL-IN-fchast-1) + 1].

  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX WARNING.
     /*RETURN NO-APPLY.*/
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
    AND cb-control.tipo   = '@PV' 
    AND cb-control.fchpro >= FILL-IN-fchast-1
    AND cb-control.fchpro <= FILL-IN-fchast-2 
    NO-LOCK NO-ERROR.
  IF AVAILABLE cb-control THEN DO:
    MESSAGE
        "Asientos contables del mes ya existen "  SKIP
        "        Desea reemplazarlos?          "
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN NO-APPLY.
  END.

  DO FILL-IN-fchast = FILL-IN-fchast-1 TO FILL-IN-fchast-2:
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").  
    RUN Asiento-Detallado.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  END.
  MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
  
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
/*  ELSE do: 
 *   message "No se ha registrado el tipo de cambio "  skip
 *           "para la fecha ingresada (" FILL-IN-fchast ")" view-as alert-box.
 *   APPLY 'ENTRY':U TO FILL-IN-fchast.
 *   return no-apply.
 *   end.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-flag W-Win 
PROCEDURE Actualiza-flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FOR EACH CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND      */
/*                         CcbCDocu.Coddiv = F-DIVISION AND    */
/*                         CcbCDocu.CodDoc = t-prev.Coddoc AND */
/*                         CcbCDocu.Nrodoc = t-prev.Nrodoc AND */
/*                         CcbCdocu.FchDoc = t-prev.fchdoc:    */
/*        ASSIGN                                               */
/*           CcbCDocu.NroMes = Cb-Cmov.Nromes                  */
/*           CcbCDocu.Codope = Cb-Cmov.Codope                  */
/*           CcbCDocu.Nroast = Cb-Cmov.Nroast                  */
/*           CcbCDocu.FchCbd = TODAY                           */
/*           CcbCDocu.FlgCbd = TRUE.                           */
/*        RELEASE CcbCDocu.                                    */
/* END.                                                        */

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
             INPUT  'Vta/b-vtacbd3.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-vtacbd3 ).
       RUN set-position IN h_b-vtacbd3 ( 5.04 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-vtacbd3 ( 19.19 , 136.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 22.54 , 1.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 45.43 ) NO-ERROR.

       /* Links to SmartBrowser h_b-vtacbd3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-vtacbd3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-vtacbd3 ,
             x-Periodo:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-vtacbd3 , 'AFTER':U ).
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

p-codcia  = s-codcia.
p-periodo = YEAR(FILL-IN-fchast).
p-mes     = MONTH(FILL-IN-fchast).

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
   /*MESSAGE "No se ha generado " SKIP "ningun preasiento" VIEW-AS ALERT-BOX ERROR.*/
   RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* Limpio la informaci¢n de los movimientos transferidos anteriormente
   a contabilidad                                                   */
/* FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
 *                              cb-control.Coddiv  = F-DIVISION AND
 *                              cb-control.tipo    = '@PV' AND
 *                              cb-control.fchpro  = FILL-IN-fchast NO-LOCK NO-ERROR.
 *  IF AVAILABLE cb-control THEN DO:
 *     MESSAGE
 *         "Asientos contables del mes ya existen "  SKIP
 *         "        ¨Desea reemplazarlo? "
 *         VIEW-AS ALERT-BOX WARNING
 *         BUTTONS YES-NO UPDATE sigue AS LOGICAL.
 *     IF NOT sigue THEN RETURN.
 *  END.*/
 FOR EACH cb-control WHERE 
          cb-control.CodCia  = s-codcia AND
          cb-control.Coddiv  = F-DIVISION AND
          cb-control.tipo    = '@PV' AND
          cb-control.fchpro  = FILL-IN-fchast :
    DELETE cb-control.
 END.
 FOR EACH cb-cmov WHERE
          cb-cmov.codcia  = p-codcia AND
          cb-cmov.coddiv  = F-DIVISION AND
          cb-cmov.PERIODO = p-periodo AND
          cb-cmov.NROMES  = p-mes AND
          cb-cmov.CODOPE  = x-codope AND
          cb-cmov.fchast  = FILL-IN-fchast :
          RUN anula-asto(
            p-codcia,
            p-periodo,
            p-mes,
            cb-cmov.codope,
            cb-cmov.nroast ).
     /* Elimino la informacion del temporal */
     RUN anula-temporal(
         p-codcia,
         p-periodo,
         p-mes,
         cb-cmov.codope,
         cb-cmov.nroast ).
     DELETE cb-cmov.    
 END.   

FOR EACH t-prev WHERE t-prev.fchast = FILL-IN-fchast BREAK BY t-prev.coddiv BY t-prev.coddoc BY t-prev.nrodoc:
    IF FIRST-OF(t-prev.coddiv) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       p-codope = t-prev.codope.
       CREATE cb-control.
       ASSIGN
          cb-control.tipo    = '@PV'
          cb-control.CodCia  = p-codcia
          cb-control.Coddiv  = t-prev.coddiv
          cb-control.Periodo = p-periodo
          cb-control.Nromes  = p-mes 
          cb-control.fchpro  = FILL-IN-fchast
          cb-control.Codope  = p-Codope
          cb-control.Usuario = s-user-id
          cb-control.Hora    = STRING(TIME,'HH:MM:SS')
          cb-control.fecha   = TODAY.
       /* Verifico si el movimiento se realiz¢ anteriormente */
       p-codope = t-prev.codope.
       RUN cbd/cbdnast.p(cb-codcia,
                            p-codcia, 
                            p-periodo, 
                            p-Mes, 
                            p-codope, 
                            OUTPUT x-nroast). 
       p-nroast = STRING(x-nroast, '999999').
       d-uno  = 0.
       d-dos  = 0.
       h-uno  = 0.
       h-dos  = 0.
       j      = 0.
    END.

    FIND cb-ctas WHERE
        cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    x-clfaux = cb-ctas.clfaux.
    x-coddoc = cb-ctas.piddoc.
/*    IF t-prev.impmn1 > 0 OR t-prev.impmn2 > 0 THEN DO:*/
      DO:
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
        CB-DMOV.cco     = t-prev.cco.
        Cb-dmov.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        Cb-dmov.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        CB-DMOV.Nroruc  = IF x-clfaux <> '' THEN t-prev.nroruc ELSE ''.
        CB-DMOV.GLODOC  = t-prev.glodoc.
        CB-DMOV.tpomov  = t-prev.tpomov.
        CB-DMOV.impmn1  = t-prev.impmn1.
        CB-DMOV.impmn2  = t-prev.impmn2.
        CB-DMOV.FCHDOC  = t-prev.Fchdoc.
        CB-DMOV.FCHVTO  = t-prev.Fchvto.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.TM      = t-prev.tm.
        CB-DMOV.codmon  = t-prev.codmon.
        CB-DMOV.tpocmb  = t-prev.tpocmb.
        CB-DMOV.codref  = t-prev.codref.
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
        
        /* Carga del temporal */
        CREATE T-CB-DMOV.
        T-CB-DMOV.codcia  = p-codcia.
        T-CB-DMOV.PERIODO = p-periodo.
        T-CB-DMOV.NROMES  = p-mes.
        T-CB-DMOV.CODOPE  = p-codope.
        T-CB-DMOV.NROAST  = p-nroast.
        T-CB-DMOV.NROITM  = J.
        T-CB-DMOV.codcta  = t-prev.codcta.
        T-CB-DMOV.coddiv  = t-prev.coddiv.
        T-CB-DMOV.cco     = t-prev.cco.
        T-CB-DMOV.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        T-CB-DMOV.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        T-CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        T-CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        T-CB-DMOV.Nroruc  = IF x-clfaux <> '' THEN t-prev.nroruc ELSE ''.     
        T-CB-DMOV.GLODOC  = t-prev.glodoc.
        T-CB-DMOV.tpomov  = t-prev.tpomov.
        T-CB-DMOV.impmn1  = t-prev.impmn1.
        T-CB-DMOV.impmn2  = t-prev.impmn2.
        T-CB-DMOV.FCHDOC  = t-prev.Fchdoc.
        T-CB-DMOV.FCHVTO  = t-prev.Fchvto.
        T-CB-DMOV.FLGACT  = TRUE.
        T-CB-DMOV.RELACION = 0.
        T-CB-DMOV.TM      = t-prev.tm.
        T-CB-DMOV.codmon  = t-prev.codmon.
        T-CB-DMOV.tpocmb  = t-prev.tpocmb.
        T-CB-DMOV.codref  = t-prev.codref.
        T-CB-DMOV.nroref  = t-prev.nroref.

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
            detalle.codref   = cb-dmov.codref.
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
            detalle.codref   = cb-dmov.codref.
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
    END.
    IF LAST-OF(t-prev.coddiv) THEN DO:
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
       cb-cmov.Coddiv = t-prev.coddiv.
       cb-cmov.Fchast = FILL-IN-fchast.
       cb-cmov.TOTITM = J.
       cb-cmov.CODMON = t-prev.codmon.
       cb-cmov.TPOCMB = t-prev.tpocmb.
       cb-cmov.DBEMN1 = d-uno.
       cb-cmov.DBEMN2 = d-dos.
       cb-cmov.HBEMN1 = h-uno.
       cb-cmov.HBEMN2 = h-dos.
       cb-cmov.NOTAST = 'Provision al ' + STRING(FILL-IN-fchast).
       cb-cmov.GLOAST = 'Provision al ' + STRING(FILL-IN-fchast).
    END.
END.
RUN Actualiza-Flag.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-FAC-BOL W-Win 
PROCEDURE Carga-FAC-BOL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-coddoc  AS CHAR.
DEFINE INPUT PARAMETER X-codcta1 AS CHAR.
DEFINE INPUT PARAMETER X-codcta2 AS CHAR.
DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
DEFINE INPUT PARAMETER X-tpodoc  AS LOGICAL.

DEFINE VAR x-codcta  AS CHAR    NO-UNDO.
DEFINE VAR x-detalle AS LOGICAL NO-UNDO.
DEFINE VAR x-cco     AS CHAR    NO-UNDO.

X-nrodoc1 = ''.
X-nrodoc2 = ''.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.

/* CARGAMOS LA INFORMACION EN EL TEMPORAL */
EMPTY TEMP-TABLE T-CDOC.
FOR EACH CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND
        CcbCDocu.Coddiv = F-Division AND
        CcbCDocu.FchDoc = FILL-IN-fchast AND
        CcbCDocu.CodDoc = X-coddoc 
    /*AND ccbcdocu.nrodoc = '81800145766' AND ccbcdocu.coddoc = 'bol'*/
    AND Ccbcdocu.tpofac <> "B"
        NO-LOCK:
    /* PARCHE: Boletas anuladas NO deben pasar */
    IF Ccbcdocu.coddoc = 'BOL' AND Ccbcdocu.flgest = 'A' THEN NEXT.
    /* *************************************** */
    
    /* QUE PASA SI NO TIENE CENTRO DE COSTO */
    x-Cco = CcbCDocu.Cco.
    IF x-Cco = ''
    THEN DO:        /* Buscamos por el vendedor */
        FIND GN-VEN OF CcbCDocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-Cco = gn-ven.cco.
    END.
    /* RHC 12.11.04 Parche especial para Tda. 73 en San Miguel */
    IF x-Cco = '' AND ccbcdocu.coddiv = '00012' THEN x-Cco = '25'.
    /* ******************************************************* */
    CREATE T-CDOC.
    BUFFER-COPY ccbcdocu to t-cdoc
        ASSIGN 
        T-CDOC.Cco    = x-Cco
        T-CDOC.ImpDto = (Ccbcdocu.ImpDto + Ccbcdocu.Libre_d01)
        T-CDOC.ImpTot = (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]).

    /* ************************************************************** */
    /* RHC 03/09/2019 Todo a ImpBrt para eliminar la cuenta 784111100 */
    /* ************************************************************** */
    ASSIGN
        T-CDOC.ImpBrt = T-CDOC.ImpBrt - T-CDOC.ImpDto
        T-CDOC.ImpDto = 0.
    /* ************************************************************** */
    /* ************************************************************** */
    /* Ic - 11Ene2017, Transferencias Gratuitas */
    IF T-CDOC.fmapgo = '899' THEN ASSIGN T-CDOC.ImpTot = T-CDOC.ImpBrt + T-CDOC.ImpIgv.

    /*T-CDOC.ImpBrt = (Ccbcdocu.ImpBrt - Ccbcdocu.ImpExo)*/.
    /* CASO DE FACTURAS CON APLICACION DE ADELANTOS */
    DEF VAR x-Factor AS DEC NO-UNDO.
    IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0 AND Ccbcdocu.FlgEst <> 'A' AND Ccbcdocu.ImpTot2 > 0
        THEN DO:
        /* Recalculamos Importes */
        ASSIGN
            T-CDOC.ImpTot2      = Ccbcdocu.ImpTot2
            T-CDOC.ImpTot       = Ccbcdocu.ImpTot /* - Ccbcdocu.ImpTot2*/
            T-CDOC.Libre_d01    = Ccbcdocu.ImpTot.
        IF T-CDOC.ImpTot <= 0 THEN DO:
            ASSIGN
                T-CDOC.ImpTot = 0
                T-CDOC.ImpBrt = 0
                T-CDOC.ImpExo = 0
                T-CDOC.ImpDto = 0
                T-CDOC.ImpVta = 0
                T-CDOC.ImpIgv = 0.
        END.
        ELSE DO:            
            /*x-Factor = T-CDOC.ImpTot / (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]).*/
            x-Factor = T-CDOC.ImpTot / (Ccbcdocu.ImpTot + Ccbcdocu.ImpTot2).
            ASSIGN
                T-CDOC.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                T-CDOC.ImpIgv = T-CDOC.ImpTot - T-CDOC.ImpVta.
            ASSIGN
                T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto + T-CDOC.ImpExo.
        END.
    END.
/*     IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 AND Ccbcdocu.ImpDto2 > 0 THEN DO: */
/*         T-CDOC.ImpDto = Ccbcdocu.ImpDto2 / ( 1 + Ccbcdocu.PorIgv / 100).            */
/*         T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto.              */
/*     END.                                                                            */
/*     BUFFER-COPY ccbcdocu to t-cdoc                            */
/*         ASSIGN                                                */
/*         T-CDOC.Cco = x-Cco                                    */
/*         T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpDto         */
/*         T-CDOC.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]. */

END.    
FOR EACH T-CDOC BREAK BY T-CDOC.CodDiv BY T-CDOC.Cco BY T-CDOC.NroDoc:
    IF FIRST-OF(T-CDOC.Cco) 
    THEN ASSIGN
            x-cco     = T-CDOC.Cco
            x-nrodoc1 = T-CDOC.NroDoc
            x-nrodoc2 = ''.
    ASSIGN        
        x-nrodoc2 = T-CDOC.nrodoc.
    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = T-CDOC.Codcia AND
                        Cb-cfgrv.CodDiv = T-CDOC.Coddiv AND
                        Cb-cfgrv.Coddoc = T-CDOC.Coddoc AND
                        Cb-cfgrv.Fmapgo = T-CDOC.Fmapgo AND
                        Cb-cfgrv.Codmon = T-CDOC.Codmon NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
    THEN DO:
      MESSAGE 'Cuenta No Configurada Para:' SKIP
                'Div.:' T-CDOC.Coddiv SKIP
                'Doc.:' T-CDOC.Coddoc SKIP
                'Nro.:' T-CDOC.Nrodoc SKIP
                'Pago:' T-CDOC.FmaPgo VIEW-AS ALERT-BOX.
      NEXT.
    END.
    ASSIGN
        x-codcta  = Cb-cfgrv.Codcta
        x-detalle = Cb-cfgrv.Detalle.

    /*  ASIENTO NORMAL */
    {vta/vtacbd3.i}
    
END.

/* *********************************************************************

/* ASIENTOS POR TRANSFERENCIA GRATUTITA */
x-TpoDoc = NOT x-TpoDoc.
FOR EACH T-CDOC WHERE LOOKUP(T-CDOC.CodDoc, 'FAC,BOL') > 0 
        AND T-CDOC.FmaPgo = '900'
        BREAK BY T-CDOC.CodDiv BY T-CDOC.Cco BY T-CDOC.NroDoc:
    IF FIRST-OF(T-CDOC.Cco) 
    THEN ASSIGN
            x-cco     = T-CDOC.Cco
            x-nrodoc1 = T-CDOC.NroDoc
            x-nrodoc2 = ''.
    ASSIGN        
        x-nrodoc2 = T-CDOC.nrodoc.
    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = T-CDOC.Codcia AND
                        Cb-cfgrv.CodDiv = T-CDOC.Coddiv AND
                        Cb-cfgrv.Coddoc = T-CDOC.Coddoc AND
                        Cb-cfgrv.Fmapgo = T-CDOC.Fmapgo AND
                        Cb-cfgrv.Codmon = T-CDOC.Codmon NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
    THEN DO:
      MESSAGE 'Cuenta No Configurada Para:' SKIP
                'Div.:' T-CDOC.Coddiv SKIP
                'Doc.:' T-CDOC.Coddoc SKIP
                'Nro.:' T-CDOC.Nrodoc SKIP
                'Pago:' T-CDOC.FmaPgo VIEW-AS ALERT-BOX.
      NEXT.
    END.
    ASSIGN
        x-codcta  = Cb-cfgrv.Codcta
        x-detalle = Cb-cfgrv.Detalle.

    {vta/vtacbd3.i}
END.
        
************************************************************************ */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-NC W-Win 
PROCEDURE Carga-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-coddoc  AS CHAR.
DEFINE INPUT PARAMETER X-codcta1 AS CHAR.
DEFINE INPUT PARAMETER X-codcta2 AS CHAR.
DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
DEFINE INPUT PARAMETER X-tpodoc  AS LOGICAL.

DEFINE VAR X-codcta  AS CHAR    NO-UNDO.
DEFINE VAR X-detalle AS LOGICAL NO-UNDO.
DEFINE VAR X-Cco     AS CHAR    NO-UNDO.

X-nrodoc1 = ''.
X-nrodoc2 = ''.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.

/* CARGAMOS LA INFORMACION EN EL TEMPORAL */
EMPTY TEMP-TABLE T-CDOC.
FOR EACH CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND
        CcbCDocu.Coddiv = F-Division AND
        CcbCDocu.FchDoc = FILL-IN-fchast AND
        CcbCDocu.TpoFac <> 'B' AND
        CcbCDocu.CodDoc = X-coddoc NO-LOCK:
    /* QUE PASA SI NO TIENE CENTRO DE COSTO */
    x-Cco = CcbCDocu.Cco.
    IF x-Cco = ''
    THEN DO:        /* Buscamos por el vendedor */
        FIND GN-VEN OF CcbCDocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-Cco = gn-ven.cco.
    END.
    /* RHC 12.11.04 Parche especial para Tda. 73 en San Miguel */
    IF x-Cco = '' AND ccbcdocu.coddiv = '00012'
    THEN x-Cco = '25'.
    /* ******************************************************* */
    CREATE T-CDOC.
    BUFFER-COPY ccbcdocu 
        TO t-cdoc
        ASSIGN 
        T-CDOC.Cco = x-Cco
        T-CDOC.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5].
END.    
FOR EACH T-CDOC BREAK BY T-CDOC.CodDiv BY T-CDOC.Cco BY T-CDOC.NroDoc:
    DISPLAY T-CDOC.Coddiv + ':' + T-CDOC.Coddoc + '-' + T-CDOC.Nrodoc  @ Fi-Mensaje LABEL 'Documento'
                FORMAT "X(30)" WITH FRAME F-Proceso.
    IF FIRST-OF(T-CDOC.Cco) 
    THEN ASSIGN
            x-cco     = T-CDOC.Cco
            x-nrodoc1 = T-CDOC.NroDoc
            x-nrodoc2 = ''.
    ASSIGN        
        x-nrodoc2 = T-CDOC.nrodoc.
        
    FIND B-CDocu WHERE B-CDocu.Codcia = S-CODCIA AND
                       /*B-CDocu.Coddiv = T-CDOC.Coddiv AND*/
                       B-CDocu.Coddoc = T-CDOC.Codref AND
                       B-CDocu.Nrodoc = T-CDOC.Nroref NO-LOCK NO-ERROR.

    IF NOT AVAILABLE B-CDocu THEN DO:
      MESSAGE 'Documento ' + T-CDOC.Coddoc + ' ' + T-CDOC.Nrodoc SKIP
              'Referencia  ' + T-CDOC.CodRef + ' ' + T-CDOC.NroRef + ' No Existe ' 
              VIEW-AS ALERT-BOX.
      NEXT.
    END.

/*ML01*/ cRuc = T-CDOC.RucCli.

    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA AND
                Cb-cfgrv.CodDiv = F-DIVISION AND
                Cb-cfgrv.Coddoc = X-coddoc AND
                Cb-cfgrv.CodRef = T-CDOC.Codref AND
                Cb-cfgrv.Fmapgo = B-CDocu.Fmapgo AND
                Cb-cfgrv.Codmon = T-CDOC.Codmon NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
      MESSAGE 'Cuenta No Configurada Para:' SKIP
                'Div.:' T-CDOC.Coddiv SKIP
                'Doc.:' T-CDOC.Coddoc SKIP
                'Nro.:' T-CDOC.Nrodoc SKIP
                'Pago:' B-CDocu.FmaPgo VIEW-AS ALERT-BOX.
      NEXT .
    END.

    X-codcta  = Cb-cfgrv.Codcta .       
    X-detalle = Cb-cfgrv.Detalle.
    
    IF T-CDOC.Flgest = 'A' THEN DO:
        x-codcta = "12122100".
        RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, 0, x-coddoc, 08, 01,x-detalle, x-cco).        
        NEXT.        
    END.
/*MESSAGE 'uno'.*/
    RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpTot, x-coddoc, 08, T-CDOC.codmon,x-detalle, x-cco).

   /* Ajuste por Diferencia de Cambio de provision contra devoluci¢n */
   /* RUN Ajuste( x-codcbd, T-CDOC.CodRef, T-CDOC.NroRef, T-CDOC.Imptot, x-codcta, T-CDOC.codmon). */

   /* CUENTA DE IGV */
   IF T-CDOC.ImpIgv > 0 THEN DO:
      x-codcta = x-ctaigv.
      /*MESSAGE 'dos igv'.*/
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIgv, x-coddoc, 06, T-CDOC.codmon,x-detalle, x-cco).
   END.
 
   /* CUENTA DE ISC */
   IF T-CDOC.ImpIsc > 0 THEN DO:
      x-codcta = x-ctaisc.
      /*MESSAGE 'tres igv'.*/
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIsc, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.
   
   /* CUENTA 70   --   Detalle  */
   IF T-CDOC.Cndcre = 'D' THEN DO:
      FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
           CcbTabla.Tabla = 'N/C' AND CcbTabla.Codigo = "00004" NO-LOCK NO-ERROR.
      IF AVAILABLE CcbTabla THEN x-codcta = CcbTabla.Codcta. 
      ELSE x-codcta = ''.
      IF T-CDOC.ImpVta > 0 THEN DO:
          /*MESSAGE 'impvta'.*/
          RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpVta, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
      END.
      IF T-CDOC.ImpExo > 0 THEN DO:
          /*MESSAGE 'exonerado'.*/
          RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpExo, x-coddoc, 02, T-CDOC.codmon,x-detalle, x-cco).
      END.
   END.
   ELSE
       IF T-CDOC.TpoFac = "PMR" THEN DO:    /* N/C Mesa Redonda */
           FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
               CcbTabla.Tabla = 'N/C' AND CcbTabla.Codigo = T-CDOC.CodCta NO-LOCK NO-ERROR.
           IF AVAILABLE CcbTabla THEN x-codcta = CcbTabla.Codcta.
           ELSE x-codcta = ''.
           FOR EACH CcbDDocu WHERE ccbddocu.codcia = T-CDOC.codcia
                 AND ccbddocu.coddoc = T-CDOC.coddoc
                 AND ccbddocu.nrodoc = T-CDOC.nrodoc NO-LOCK:
               /*MESSAGE 'mesa redonda'.*/
             RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, (CcbDDocu.ImpLin - CcbDDocu.ImpIgv - CcbDDocu.ImpIsc + CcbDDocu.Impdto), x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
           END.
       END.
       ELSE DO:
           FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
               CcbTabla.Tabla = 'N/C' AND CcbTabla.Codigo = T-CDOC.CodCta NO-LOCK NO-ERROR.
           IF AVAILABLE CcbTabla THEN x-codcta = CcbTabla.Codcta. 
           ELSE x-codcta = ''.
           RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpVta, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
/*            FOR EACH CcbDDocu WHERE ccbddocu.codcia = T-CDOC.codcia                                                                                                                         */
/*                AND ccbddocu.coddoc = T-CDOC.coddoc                                                                                                                                         */
/*                AND ccbddocu.nrodoc = T-CDOC.nrodoc NO-LOCK:                                                                                                                                */
/*                FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND                                                                                                                          */
/*                    CcbTabla.Tabla = 'N/C' AND CcbTabla.Codigo = CcbDDocu.codmat NO-LOCK NO-ERROR.                                                                                          */
/*                IF AVAILABLE CcbTabla THEN x-codcta = CcbTabla.Codcta.                                                                                                                      */
/*                ELSE x-codcta = ''.                                                                                                                                                         */
/*                     /*MESSAGE 'otros'.*/                                                                                                                                                   */
/*                RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, (CcbDDocu.ImpLin - CcbDDocu.ImpIgv - CcbDDocu.ImpIsc + CcbDDocu.Impdto), x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco). */
/*            END.                                                                                                                                                                            */
       END.
END.
/*RUN Carga-Ajuste (x-codcbd, x-coddoc).*/

END PROCEDURE.

PROCEDURE Ajuste:
/***************/
DEFINE INPUT PARAMETER x-codcbd AS CHAR.
DEFINE INPUT PARAMETER x-codref AS CHAR.
DEFINE INPUT PARAMETER x-nroref AS CHAR.
DEFINE INPUT PARAMETER x-import AS DECIMAL.
DEFINE INPUT PARAMETER x-codcta AS CHAR.
DEFINE INPUT PARAMETER x-codmon AS INTEGER.

DEFINE VAR x-import1 AS DECIMAL NO-UNDO.
DEFINE VAR x-tpomov  AS LOGICAL NO-UNDO.

FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia AND 
     B-CDocu.CodDoc = x-codref AND B-CDocu.NroDoc = x-nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDocu THEN DO:
   MESSAGE 'Provisi¢n del documento ' + x-codref + '-' + x-nroref + ' no existe' 
           VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.
FIND gn-tcmb WHERE gn-tcmb.fecha = B-CDocu.fchdoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-tcmb THEN RETURN.
FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
     cb-ctas.Codcta = x-codcta NO-LOCK NO-ERROR.
IF AVAILABLE cb-ctas THEN DO:
   IF cb-ctas.Tpocmb = 1 THEN
      x-import1 = (x-import * gn-tcmb.compra) - (x-import * FILL-IN-TcCompra).
   ELSE
      x-import1 = (x-import * gn-tcmb.venta) - (x-import * FILL-IN-Tpocmb).
END.
x-tpomov  = NOT(x-import1 > 0).
FIND t-prev WHERE t-prev.coddoc = x-CodCbd AND t-prev.codcta = x-codcta AND
     t-prev.coddiv = T-CDOC.Coddiv AND
     t-prev.tpomov = x-tpomov NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
   CREATE t-prev.
   ASSIGN
      t-prev.periodo = p-periodo
      t-prev.nromes  = p-mes
      t-prev.codope  = x-codope
      t-prev.coddiv  = T-CDOC.CodDiv 
      t-prev.codmon  = x-codmon
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = FILL-IN-fchast
      t-prev.tpomov  = x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.codaux  = FacCfgGn.CliVar
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = STRING(FILL-IN-fchast, '99/99/9999')
      t-prev.tm      = 01.
END.
ASSIGN
   t-prev.impmn1  = t-prev.impmn1 + ABSOLUTE(x-import1)
   t-prev.Tpocmb  = 1
   t-prev.glodoc  = 'Ajuste Dif.Cambio'.
RELEASE  t-prev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-ND W-Win 
PROCEDURE Carga-ND :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-coddoc  AS CHAR.
DEFINE INPUT PARAMETER X-codcta1 AS CHAR.
DEFINE INPUT PARAMETER X-codcta2 AS CHAR.
DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
DEFINE INPUT PARAMETER X-tpodoc  AS LOGICAL.

DEFINE VAR X-codcta  AS CHAR    NO-UNDO.
DEFINE VAR X-detalle AS LOGICAL INIT YES NO-UNDO.       /* N/D AL DETALLE */
DEFINE VAR X-cco     AS CHAR    NO-UNDO.

X-nrodoc1 = ''.
X-nrodoc2 = ''.

/* CARGAMOS LA INFORMACION EN EL TEMPORAL */
EMPTY TEMP-TABLE T-CDOC.
FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.Coddiv = F-Division AND
        ccbcdocu.FchDoc = FILL-IN-fchast AND
        ccbcdocu.CodDoc = X-coddoc NO-LOCK:
    /* QUE PASA SI NO TIENE CENTRO DE COSTO */
    x-Cco = CcbCDocu.Cco.
    IF x-Cco = ''
    THEN DO:        /* Buscamos por el vendedor */
        FIND GN-VEN OF CcbCDocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-Cco = gn-ven.cco.
    END.
    /* RHC 12.11.04 Parche especial para Tda. 73 en San Miguel */
    IF x-Cco = '' AND ccbcdocu.coddiv = '00012'
    THEN x-Cco = '25'.
    /* ******************************************************* */
    CREATE T-CDOC.
    BUFFER-COPY ccbcdocu 
        TO t-cdoc
        ASSIGN T-CDOC.Cco = x-Cco.
END.    
FOR EACH T-CDOC BREAK BY T-CDOC.CodDiv BY T-CDOC.Cco BY T-CDOC.NroDoc:
    DISPLAY T-CDOC.Coddiv + ':' + T-CDOC.Coddoc + '-' + T-CDOC.Nrodoc  @ Fi-Mensaje LABEL 'Documento'
                FORMAT "X(30)" WITH FRAME F-Proceso.
    IF FIRST-OF(T-CDOC.Cco) THEN 
        ASSIGN
        x-cco     = T-CDOC.Cco
        x-nrodoc1 = T-CDOC.NroDoc
        x-nrodoc2 = ''.
    ASSIGN        
        x-nrodoc2 = T-CDOC.nrodoc.
    IF T-CDOC.Flgest = 'A' THEN DO:
        x-codcta = "12122100".
        RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, 0, x-coddoc, 08, 01,x-detalle, x-cco).        
        NEXT.  
    END.
    FIND B-CDocu WHERE B-CDocu.Codcia = S-CODCIA 
        AND /*B-CDocu.Coddiv = T-CDOC.Coddiv AND */ B-CDocu.Coddoc = T-CDOC.Codref 
        AND B-CDocu.Nrodoc = T-CDOC.Nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDocu THEN DO:
        MESSAGE 'Documento ' + T-CDOC.Coddoc + ' ' + T-CDOC.Nrodoc SKIP
            'Referencia  ' + T-CDOC.CodRef + ' ' + T-CDOC.NroRef + ' No Existe ' 
            VIEW-AS ALERT-BOX.
        NEXT .
    END.
    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA 
        AND Cb-cfgrv.CodDiv = F-DIVISION 
        AND Cb-cfgrv.Coddoc = X-coddoc 
        AND Cb-cfgrv.CodRef = T-CDOC.Codref 
        AND Cb-cfgrv.Fmapgo = B-CDocu.Fmapgo 
        AND Cb-cfgrv.Codmon = T-CDOC.Codmon NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = ""  THEN DO:
        MESSAGE 'Revisar la Configuración de Asientos Automáticos' SKIP
            'Cuenta no configurada para los siguientes parámetros:' SKIP
            'División:' f-Division SKIP
            'Documento:' x-coddoc SKIP
            'Número:' t-cdoc.nrodoc SKIP
            'Referencia:' t-cdoc.codref SKIP
            'Número:' t-cdoc.nroref SKIP
            'Condición de venta:' b-cdocu.fmapgo SKIP
            'Moneda:' t-cdoc.codmon
            /*'Cuenta No Configurada Para ' + T-CDOC.Coddoc + ' ' + T-CDOC.Nrodoc  */
            VIEW-AS ALERT-BOX.
        NEXT .
    END.
    X-codcta = Cb-cfgrv.Codcta .       
    RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpTot, x-coddoc, 08, T-CDOC.Codmon,x-detalle, x-cco).

   /* CUENTA DE IGV */
   IF T-CDOC.ImpIgv > 0 THEN DO:
      x-codcta = x-ctaigv.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIgv, x-coddoc, 06, T-CDOC.Codmon,x-detalle, x-cco).
   END.
 
   /* CUENTA DE ISC */
   IF T-CDOC.ImpIsc > 0 THEN DO:
      x-codcta = x-ctaisc.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIsc, x-coddoc, 01, T-CDOC.Codmon,x-detalle, x-cco).
   END.
   
   /* CUENTA 70   --   Detalle  */
   IF T-CDOC.TpoFac = "PMR" THEN DO:    /* N/D Mesa Redonda */
       FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
            CcbTabla.Tabla = 'N/D' AND CcbTabla.Codigo = T-CDOC.CodCta NO-LOCK NO-ERROR.
       IF AVAILABLE CcbTabla THEN x-codcta = CcbTabla.CodCta.
       ELSE x-codcta = ''.
       FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = s-codcia AND
           CcbDDocu.CodDoc = T-CDOC.coddoc  
           AND CcbDDocu.NroDoc = T-CDOC.nrodoc NO-LOCK:
           RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, (CcbDDocu.ImpLin - CcbDDocu.ImpIgv - CcbDDocu.ImpIsc + CcbDDocu.Impdto), x-coddoc, 01, T-CDOC.Codmon,x-detalle, x-cco).
       END.
   END.
   ELSE DO:
       FOR EACH CcbDDocu NO-LOCK WHERE CcbDDocu.CodCia = s-codcia 
           AND CcbDDocu.CodDoc = T-CDOC.coddoc  
           AND CcbDDocu.NroDoc = T-CDOC.nrodoc
           AND CcbDDocu.CodMat <> '':
            FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
                 CcbTabla.Tabla = 'N/D' AND CcbTabla.Codigo = CcbDDocu.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE CcbTabla THEN x-codcta = CcbTabla.Codcta.
            ELSE x-codcta = ''.
            RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, (CcbDDocu.ImpLin - CcbDDocu.ImpIgv - CcbDDocu.ImpIsc + CcbDDocu.Impdto), x-coddoc, 01, T-CDOC.Codmon,x-detalle, x-cco).
       END.
   END.
END.
/*RUN Carga-Ajuste (x-codcbd, x-coddoc).*/

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

EMPTY TEMP-TABLE t-prev.
/* POR TODO EL MES */
/* FILL-IN-fchast-1 = 02/19/2015. */
/* FILL-IN-fchast-2 = 02/19/2015. */
DO FILL-IN-FchAst = FILL-IN-fchast-1 TO FILL-IN-fchast-2:
    /* TIPO DE CAMBIO DEL DIA */
    FIND gn-tcmb WHERE gn-tcmb.fecha = FILL-IN-fchast NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-tcmb THEN DO:
        MESSAGE 'Tipo de cambio del dia' FILL-IN-FchAst 'NO está configurado'
            VIEW-AS ALERT-BOX WARNING.
        NEXT.
    END.
    ASSIGN
        FILL-IN-tpocmb = gn-tcmb.venta
        FILL-IN-TcCompra = gn-tcmb.compra.

    FOR EACH FacDocum WHERE FacDocum.CodCia = s-codcia NO-LOCK:
        IF LOOKUP(FacDocum.CodDoc, 'FAC,BOL,N/C,N/D,TCK') > 0 THEN DO:
        /*IF FacDocum.CodDoc = 'TCK' THEN DO:*/
           IF FacDocum.CodCta[1] = '' THEN DO:
              MESSAGE 'Cuenta contable de ' + FacDocum.Coddoc + ' no configurada' VIEW-AS ALERT-BOX.
              NEXT.
           END.
           CASE FacDocum.CodDoc:
              WHEN 'TCK' THEN RUN Carga-FAC-BOL ('TCK',FacDocum.CodCta[1],FacDocum.CodCta[2],FacDocum.Codcbd,FacDocum.TpoDoc).
              WHEN 'FAC' THEN RUN Carga-FAC-BOL ('FAC',FacDocum.CodCta[1],FacDocum.CodCta[2],FacDocum.Codcbd,FacDocum.TpoDoc).
              WHEN 'BOL' THEN RUN Carga-FAC-BOL ('BOL',FacDocum.CodCta[1],FacDocum.CodCta[2],FacDocum.Codcbd,FacDocum.TpoDoc).
              WHEN 'N/C' THEN RUN Carga-NC ('N/C',FacDocum.CodCta[1],FacDocum.CodCta[2],FacDocum.Codcbd,FacDocum.TpoDoc).
              WHEN 'N/D' THEN RUN Carga-ND ('N/D',FacDocum.CodCta[1],FacDocum.CodCta[2],FacDocum.Codcbd,FacDocum.TpoDoc).
           END CASE.
        END.
    END. 
END.

/* DEF VAR X AS DEC.                                           */
/* FOR EACH t-prev BREAK BY t-prev.codcta:                     */
/*     IF FIRST-OF(t-prev.codcta) THEN X = 0.                  */
/*     X = X + t-prev.impmn1.                                  */
/*     IF LAST-OF(t-prev.codcta) THEN MESSAGE t-prev.codcta X. */
/* END.                                                        */

RUN Ajusta-Redondeo.   
HIDE FRAME F-Proceso.

RUN dispatch IN h_b-vtacbd3 ('open-query':U).
RUN Totales IN h_b-vtacbd3.

FIND FIRST t-prev NO-LOCK NO-ERROR.
IF AVAILABLE t-prev THEN
   RUN dispatch IN h_p-updv10 ('view':U).
ELSE
   RUN dispatch IN h_p-updv10 ('hide':U).

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
  ENABLE x-Periodo x-NroMes f-Division B-filtro 
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
 DEFINE INPUT PARAMETER X-coddoc  AS CHAR.
 DEFINE INPUT PARAMETER X-tm      AS INTEGER.
 DEFINE INPUT PARAMETER X-codmon  AS INTEGER.
 DEFINE INPUT PARAMETER X-detalle AS LOGICAL.
 DEFINE INPUT PARAMETER X-cco     AS CHAR.


 IF x-codcta = "" THEN DO:
     MESSAGE "ERROR: el código de cuenta está en blanco" SKIP
         "Doc:" x-codcbd SKIP
         "Ref:" x-coddoc SKIP
         "Ref:" T-CDOC.Nrodoc
         VIEW-AS ALERT-BOX ERROR.
     RETURN.
 END.
 DEFINE VAR X-CODCLI AS CHAR INIT "".
 DEFINE VAR X-NRODOC AS CHAR INIT "".
 DEFINE VAR X-GLOSA AS CHAR.
 DEFINE VAR X-CODAUX AS CHAR .

 IF X-coddoc = 'BOL' THEN DO:  
          /*MESSAGE "BOLETA IGV " X-importe T-CDOC.Nrodoc X-codcta X-tpomov X-tm.*/
 END.

 /* VARIABLES QUE GUARDAN EN TIPO DE CAMBIO, EN CASO DE N/C DEPENDE DEL DOC DE REF: */
 DEF VAR x-TCVenta AS DEC NO-UNDO.
 DEF VAR x-TCCompra AS DEC NO-UNDO.
 
 ASSIGN
    x-TCVenta = FILL-IN-Tpocmb
    x-TCCompra = FILL-IN-TcCompra. 
 
 IF x-tm = 0 THEN x-tm = 01.
 
 X-CODCLI = T-CDOC.CodCli.
 X-CODAUX = T-CDOC.CodCli.
 X-GLOSA  = T-CDOC.Nomcli.
 cRuc = T-CDOC.RucCli.
 /* RUC DEL MAESTRO DE CLIENTES */
 FIND gn-clie WHERE gn-clie.codcia = cl-codcia
     AND gn-clie.codcli = T-CDOC.CodCli
     NO-LOCK NO-ERROR.
 IF AVAILABLE gn-clie AND gn-clie.Ruc <> '' THEN cRuc = gn-clie.ruc.
 /* *************************** */
 IF x-Detalle = Yes THEN x-NroDoc = T-CDOC.Nrodoc. 
 ELSE DO:
    X-NRODOC = SUBSTRING(T-CDOC.Nrodoc,1,3) + "111111".       /* UN SOLO NUMERO DE DOCUMENTO (SIN DETALLE) */
    X-GLOSA  = "VENTAS CONTADO".
    X-CODAUX = '11111111111'.
    cRuc = "".
 END.

 FIND CB-CTAS WHERE CB-CTAS.codcia = cb-codcia AND CB-CTAS.codcta = x-codcta
        NO-LOCK NO-ERROR.
 IF AVAILABLE CB-CTAS 
 THEN DO:
    x-Cco    = IF CB-CTAS.PidCco THEN x-Cco    ELSE ''.
    x-CodAux = IF CB-CTAS.PidAux THEN x-CodAux ELSE ''.
 END.    
        
 FIND t-prev WHERE t-prev.coddiv = T-CDOC.Coddiv AND
                   t-prev.coddoc = X-CodCbd AND 
                   t-prev.nrodoc = X-NroDoc AND
                   t-prev.codcta = X-codcta AND
                   t-prev.tpomov = x-tpomov AND
                   t-prev.tm     = x-tm     AND
                   t-prev.cco    = x-cco    AND
                   t-prev.fchast = FILL-IN-FchAst
                   NO-LOCK NO-ERROR.
                    
 IF NOT AVAILABLE t-prev THEN DO:
   CREATE t-prev.
   ASSIGN
      t-prev.periodo = p-periodo
      t-prev.nromes  = p-mes
      t-prev.codope  = x-codope
      t-prev.coddiv  = T-CDOC.CodDiv 
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = T-CDOC.Fchdoc
      t-prev.fchvto  = T-CDOC.Fchvto
      t-prev.tpomov  = x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.nroruc  = IF cRuc <> "" THEN cRuc ELSE x-codcli /*Gn-Clie.Ruc*/
      t-prev.codaux  = X-CodAux
      t-prev.codmon  = x-codmon
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = x-nrodoc /*T-CDOC.Nrodoc*/
      t-prev.tm      = x-tm
      t-prev.cco     = x-cco
      t-prev.fchast  = FILL-IN-fchast.
    /* RHC 17.10.05 CASO DE NOTAS DE CREDITO */
    IF T-CDOC.CodDoc = 'N/C' THEN DO:
        FIND B-CDOCU WHERE B-CDOCU.codcia = T-CDOC.codcia
            AND B-CDOCU.coddoc = T-CDOC.codref
            AND B-CDOCU.nrodoc = T-CDOC.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU THEN DO:
            ASSIGN
                t-prev.nroref = B-CDOCU.nrodoc.
            FIND B-Docum OF B-CDOCU NO-LOCK NO-ERROR.
            IF AVAILABLE B-Docum THEN t-prev.codref = B-Docum.CodCbd.
        END.
        /* T.Cambio del doc de referencia */
/*         FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= B-CDOCU.FchDoc NO-LOCK NO-ERROR. */
/*         IF AVAILABLE Gn-Tcmb                                                      */
/*         THEN ASSIGN                                                               */
/*                 x-TCVenta = Gn-Tcmb.Venta                                         */
/*                 x-TCCompra = Gn-Tcmb.Compra.                                      */
    END.
 END.
 
 IF T-CDOC.CodMon = 1 
 THEN ASSIGN
        t-prev.impmn1  = t-prev.impmn1 + x-importe.
 ELSE ASSIGN
        t-prev.impmn2  = t-prev.impmn2 + x-importe
        t-prev.impmn1  = t-prev.impmn1 + ROUND(( x-importe * x-TCVenta ) ,2).  
 ASSIGN
    t-prev.Tpocmb  = (IF x-CodMon = 2 THEN x-TCVenta ELSE 0)
    t-prev.glodoc  = IF T-CDOC.FlgEst = "A" THEN "ANULADO" ELSE X-GLOSA
    t-prev.codaux  = IF T-CDOC.FlgEst = "A" THEN "" ELSE t-prev.codaux
    t-prev.nroruc  = IF T-CDOC.FlgEst = "A" THEN "" ELSE t-prev.nroruc
    t-prev.clfaux  = IF T-CDOC.FlgEst = "A" THEN "" ELSE t-prev.clfaux.
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
DEFINE VAR I-nroitm AS INTEGER FORMAT '>>>>9' NO-UNDO.
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
   /*>>>>9 12345 12345678 123*/
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   
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
        I-NroItm       AT 1   
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
        x-codope = cb-cfgg.Codope
        x-CtaICBPER = cb-cfgg.CodAux[8].
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
  RUN dispatch IN h_p-updv10 ('hide':U).
  
  
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

