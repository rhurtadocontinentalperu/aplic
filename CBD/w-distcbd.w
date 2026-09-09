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
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR x-codope  AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-CDOC LIKE CCBCDOCU      /* ARCHIVO DE TRABAJO */
    INDEX LLAVE01 CodDiv Cco NroDoc.
    
DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov
    FIELD fchast LIKE cb-cmov.fchast.
    
DEFINE BUFFER B-prev  FOR t-prev.
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-Docum FOR FacDocum.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodOpe x-Periodo x-NroMes B-filtro 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodOpe FILL-IN-FchAst-1 x-Periodo ~
x-NroMes FILL-IN-FchAst-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-distcbd AS HANDLE NO-UNDO.

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

DEFINE VARIABLE FILL-IN-CodOpe AS CHARACTER FORMAT "X(256)":U INITIAL "060" 
     LABEL "Libro" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "060","070","075","073","076","002" 
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

DEFINE VARIABLE FILL-IN-FchAst-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAst-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodOpe AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-FchAst-1 AT ROW 3.31 COL 29 COLON-ALIGNED WIDGET-ID 2
     x-Periodo AT ROW 3.31 COL 9 COLON-ALIGNED
     x-NroMes AT ROW 4.27 COL 9 COLON-ALIGNED
     B-filtro AT ROW 2.42 COL 64
     B-Transferir AT ROW 2.42 COL 72.14
     B-Imprimir AT ROW 2.42 COL 80.29
     FILL-IN-FchAst-2 AT ROW 4.12 COL 29 COLON-ALIGNED WIDGET-ID 4
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 4.15 COL 80.86
     "ASIENTO DE REDISTRIBUCION DE CENTROS DE COSTO" VIEW-AS TEXT
          SIZE 53 BY .85 AT ROW 1.27 COL 21
          FONT 12
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
         TITLE              = "Generacion de Asiento Contable Mensual por Centro de Costo"
         HEIGHT             = 14.23
         WIDTH              = 92.43
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
/* SETTINGS FOR FILL-IN FILL-IN-FchAst-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchAst-2 IN FRAME F-Main
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
     x-Periodo x-NroMes FILL-IN-CodOpe.

  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
      cb-peri.Periodo = INTEGER(x-Periodo) NO-LOCK NO-ERROR.
  IF AVAILABLE cb-peri THEN s-NroMesCie = cb-peri.MesCie[INTEGER(x-NroMes) + 1].

  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX WARNING.
     /*RETURN NO-APPLY.*/
  END.

  RUN Carga-Temporal.

  ASSIGN
      B-Transferir:SENSITIVE = YES
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
  
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia AND
      cb-peri.Periodo = INTEGER(x-Periodo) NO-LOCK.
  IF AVAILABLE cb-peri THEN s-NroMesCie = cb-peri.MesCie[INTEGER(x-NroMes) + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia 
      AND cb-control.tipo   = '@DCC' 
      AND cb-control.fchpro >= FILL-IN-FchAst-1
      AND cb-control.fchpro <= FILL-IN-FchAst-2
      NO-LOCK NO-ERROR.
  IF AVAILABLE cb-control THEN DO:
    MESSAGE
        "Asientos contables del mes ya existen "  SKIP
        "        Desea reemplazarlos?          "
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN NO-APPLY.
  END.

  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").  
  RUN Asiento-Detallado.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
  
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
             INPUT  'cbd/b-distcbd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-distcbd ).
       RUN set-position IN h_b-distcbd ( 5.04 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-distcbd ( 10.00 , 91.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-distcbd ,
             FILL-IN-FchAst-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

DEFINE BUFFER Detalle FOR CB-DMOV.


FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
   RETURN.
END.

/* Fijamos la Operación */
x-CodOpe = '074'.

ASSIGN
    p-codcia  = s-codcia
    p-periodo = INTEGER(x-Periodo)
    p-mes     = INTEGER(x-NroMes)
    p-codope  = x-CodOpe.

/* Limpio la información de los movimientos transferidos anteriormente a contabilidad                                                   */
FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia AND
    cb-control.Codope  = FILL-IN-CodOpe AND                 /* OJO */
    cb-control.tipo    = '@DCC' AND
    cb-control.fchpro >= FILL-IN-FchAst-1 AND
    cb-control.fchpro <= FILL-IN-FchAst-2:
    FIND cb-cmov WHERE cb-cmov.codcia  = p-codcia AND
        cb-cmov.PERIODO = p-periodo AND
        cb-cmov.NROMES  = p-mes AND
        cb-cmov.CODOPE  = p-codope AND
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

FOR EACH t-prev WHERE BREAK BY t-prev.nroast:
    IF FIRST-OF(t-prev.nroast) THEN DO:
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
            cb-control.tipo    = '@DCC'
            cb-control.CodCia  = p-codcia
            cb-control.Coddiv  = t-prev.coddiv
            cb-control.Periodo = p-periodo
            cb-control.Nromes  = p-mes 
            cb-control.fchpro  = t-prev.fchast
            cb-control.Codope  = FILL-IN-CodOpe     /* OJO */
            /*cb-control.Codope  = p-Codope*/
            cb-control.nroast  = p-NroAst   /* OJO */
            cb-control.Usuario = s-user-id
            cb-control.Hora    = STRING(TIME,'HH:MM:SS')
            cb-control.fecha   = TODAY.
    END.
    J = J + 1.
    CREATE CB-DMOV.
    BUFFER-COPY T-PREV TO CB-DMOV
        ASSIGN
            CB-DMOV.codcia  = p-codcia
            CB-DMOV.PERIODO = p-periodo
            CB-DMOV.NROMES  = p-mes
            CB-DMOV.CODOPE  = p-codope
            CB-DMOV.NROAST  = p-nroast
            CB-DMOV.NROITM  = J.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
    IF CB-DMOV.tpomov THEN DO:
        h-uno = h-uno + CB-DMOV.impmn1.
        h-dos = h-dos + CB-DMOV.impmn2.
    END.
    ELSE DO:
        d-uno = d-uno + CB-DMOV.impmn1.
        d-dos = d-dos + CB-DMOV.impmn2.
    END.
    IF LAST-OF(t-prev.nroast) THEN DO:
        FIND cb-cmov WHERE
            cb-cmov.codcia  = p-codcia AND
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
            cb-cmov.Fchast = t-prev.fchast
            cb-cmov.TOTITM = J
            cb-cmov.CODMON = t-prev.codmon
            cb-cmov.TPOCMB = t-prev.tpocmb
            cb-cmov.DBEMN1 = d-uno
            cb-cmov.DBEMN2 = d-dos
            cb-cmov.HBEMN1 = h-uno
            cb-cmov.HBEMN2 = h-dos
            cb-cmov.NOTAST = 'Registro de Compras ' + t-prev.codope + ' ' + t-prev.nroast
            cb-cmov.GLOAST = 'Registro de Compras ' + t-prev.codope + ' ' + t-prev.nroast.
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

DEF VAR x-ImpMn1 LIKE cb-dmov.ImpMn1.
DEF VAR x-ImpMn2 LIKE cb-dmov.ImpMn2.
DEF VAR x-ImpMn3 LIKE cb-dmov.ImpMn3.

EMPTY TEMP-TABLE t-prev.

/* Buscamos la operacion de origen 060 */
FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = INTEGER(x-Periodo)
    AND cb-cmov.nromes = INTEGER(x-NroMes)
    AND cb-cmov.codope = FILL-IN-CodOpe,                        /* OJO */
    EACH cb-dmov OF cb-cmov NO-LOCK WHERE cb-dmov.cco = "00"    /* Por distribuir */
    AND cb-dmov.discco <> 000,                                  /* Por distribuir */
    FIRST cb-auxi NO-LOCK WHERE cb-auxi.codcia = cb-codcia
    AND cb-auxi.clfaux = "CCO"
    AND cb-auxi.codaux = cb-dmov.cco,
    FIRST cb-tabl NO-LOCK WHERE cb-tabl.Tabla = '15'
    AND cb-tabl.Codigo = STRING (cb-dmov.discco, '999'),
    FIRST cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
    AND cb-ctas.codcta = cb-dmov.codcta
    AND cb-ctas.pidcco = YES:   /* Piden CCO */
    DISPLAY cb-cmov.codope + ' ' + cb-cmov.nroast @ fi-mensaje WITH FRAME F-Proceso.
    /* 1ro. volteamos la cuenta origen */
    CREATE T-PREV.
    BUFFER-COPY cb-dmov TO T-PREV
        ASSIGN 
            T-PREV.FchAst = cb-cmov.fchast
            T-PREV.TpoMov = NOT cb-dmov.TpoMov.
    /* 2do. distribuimos los importes */
    ASSIGN
        x-ImpMn1 = cb-dmov.ImpMn1
        x-ImpMn2 = cb-dmov.ImpMn2
        x-ImpMn3 = cb-dmov.ImpMn3.
    FOR EACH cb-DisCC NO-LOCK WHERE cb-DisCC.DisCCo = INTEGER(cb-tabl.Codigo)
        AND cb-DisCC.CodCia = s-codcia
        BREAK BY cb-discc.discco:
        CREATE T-PREV.
        BUFFER-COPY cb-dmov 
            TO T-PREV
            ASSIGN
            T-PREV.CodCta = cb-DisCC.Codcta
            T-PREV.FchAst = cb-cmov.fchast
            T-PREV.ImpMn1 = ROUND (cb-dmov.ImpMn1 * cb-discc.factor / 100, 2)
            T-PREV.ImpMn2 = ROUND (cb-dmov.ImpMn2 * cb-discc.factor / 100, 2)
            T-PREV.ImpMn3 = ROUND (cb-dmov.ImpMn3 * cb-discc.factor / 100, 2)
            T-PREV.Cco    = cb-discc.cco.
        ASSIGN
            x-ImpMn1 = x-ImpMn1 - T-PREV.ImpMn1
            x-ImpMn2 = x-ImpMn2 - T-PREV.ImpMn2
            x-ImpMn3 = x-ImpMn3 - T-PREV.ImpMn3.
        IF LAST-OF(cb-discc.discco) THEN DO:    /* Redondeamos */
            ASSIGN
                T-PREV.ImpMn1 = T-PREV.ImpMn1 + x-ImpMn1
                T-PREV.ImpMn2 = T-PREV.ImpMn2 + x-ImpMn2
                T-PREV.ImpMn3 = T-PREV.ImpMn3 + x-ImpMn3.
        END.
    END.
END.

HIDE FRAME F-Proceso.

RUN dispatch IN h_b-distcbd ('open-query':U).
RUN Totales IN h_b-distcbd.


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
  DISPLAY FILL-IN-CodOpe FILL-IN-FchAst-1 x-Periodo x-NroMes FILL-IN-FchAst-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodOpe x-Periodo x-NroMes B-filtro 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
/*
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
*/
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
  ASSIGN
      x-CodOpe = "076".
  FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Cb-Peri NO-LOCK WHERE Cb-peri.codcia = s-codcia:
        x-Periodo:ADD-LAST(STRING(Cb-peri.periodo)).
    END.
    x-Periodo = STRING(YEAR(TODAY), '9999').
    RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
    DISPLAY 
        x-Periodo
        FILL-IN-fchast-1 FILL-IN-fchast-2.
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

