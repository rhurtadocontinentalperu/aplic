&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/19/95 -  9:03 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER P-Crear AS LOGICAL.
DEFINE INPUT PARAMETER RegAct  AS RECID.
DEFINE INPUT PARAMETER x-CodMon LIKE integral.cb-ctas.Codmon.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE y-codmon AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER INITIAL 1.

DEFINE VARIABLE x-GenAut AS INTEGER.
DEFINE VARIABLE i        AS INTEGER.

DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE BUFFER B-DETALLE FOR cb-dmov.
FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

DEFINE VARIABLE RECID-stack AS RECID.

DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE {&NEW} SHARED VARIABLE x-MaxNivel AS INTEGER INITIAL 5.
DEFINE {&NEW} SHARED VARIABLE s-periodo  AS INTEGER INITIAL 2012.

DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

DEF BUFFER B-CTAS FOR CB-CTAS.

DEF VAR s-coddiv AS CHAR INIT '00000'.

/* Guarda último valor de campo */
DEFINE SHARED VARIABLE old_codaux AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE old_coddoc AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE old_nroruc AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE old_nrodoc AS CHARACTER NO-UNDO.

/*ML01* 24/Jun/2008 */
DEFINE SHARED VARIABLE fFchAst AS DATE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 cb-dmov.CodCta cb-dmov.CodDiv ~
cb-dmov.ClfAux cb-dmov.CodAux cb-dmov.CCo cb-dmov.NroRuc cb-dmov.CodDoc ~
cb-dmov.NroDoc cb-dmov.C-FCaja cb-dmov.OrdCmp cb-dmov.GloDoc cb-dmov.TpoCmb ~
cb-dmov.TpoMov cb-dmov.ImpMn1 cb-dmov.CodRef cb-dmov.NroRef cb-dmov.Dte_01 ~
cb-dmov.ImpMn2 cb-dmov.FchDoc cb-dmov.TM cb-dmov.FchVto cb-dmov.DisCco ~
cb-dmov.Log_01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1 cb-dmov.CodCta ~
cb-dmov.CodDiv cb-dmov.ClfAux cb-dmov.CodAux cb-dmov.CCo cb-dmov.NroRuc ~
cb-dmov.CodDoc cb-dmov.NroDoc cb-dmov.OrdCmp cb-dmov.GloDoc cb-dmov.TpoMov ~
cb-dmov.CodRef cb-dmov.NroRef cb-dmov.Dte_01 cb-dmov.FchDoc cb-dmov.TM ~
cb-dmov.FchVto cb-dmov.DisCco cb-dmov.Log_01 
&Scoped-define ENABLED-TABLES-IN-QUERY-DIALOG-1 cb-dmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DIALOG-1 cb-dmov
&Scoped-define QUERY-STRING-DIALOG-1 FOR EACH cb-dmov ~
      WHERE RECID(cb-dmov) = RegAct SHARE-LOCK
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH cb-dmov ~
      WHERE RECID(cb-dmov) = RegAct SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DIALOG-1 cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 cb-dmov


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-dmov.CodCta cb-dmov.CodDiv cb-dmov.ClfAux ~
cb-dmov.CodAux cb-dmov.CCo cb-dmov.NroRuc cb-dmov.CodDoc cb-dmov.NroDoc ~
cb-dmov.OrdCmp cb-dmov.GloDoc cb-dmov.TpoMov cb-dmov.CodRef cb-dmov.NroRef ~
cb-dmov.Dte_01 cb-dmov.FchDoc cb-dmov.TM cb-dmov.FchVto cb-dmov.DisCco ~
cb-dmov.Log_01 
&Scoped-define ENABLED-TABLES cb-dmov
&Scoped-define FIRST-ENABLED-TABLE cb-dmov
&Scoped-Define ENABLED-OBJECTS RECT-6 b-aceptar b-cancelar 
&Scoped-Define DISPLAYED-FIELDS cb-dmov.CodCta cb-dmov.CodDiv ~
cb-dmov.ClfAux cb-dmov.CodAux cb-dmov.CCo cb-dmov.NroRuc cb-dmov.CodDoc ~
cb-dmov.NroDoc cb-dmov.C-FCaja cb-dmov.OrdCmp cb-dmov.GloDoc cb-dmov.TpoCmb ~
cb-dmov.TpoMov cb-dmov.ImpMn1 cb-dmov.CodRef cb-dmov.NroRef cb-dmov.Dte_01 ~
cb-dmov.ImpMn2 cb-dmov.FchDoc cb-dmov.TM cb-dmov.FchVto cb-dmov.DisCco ~
cb-dmov.Log_01 
&Scoped-define DISPLAYED-TABLES cb-dmov
&Scoped-define FIRST-DISPLAYED-TABLE cb-dmov
&Scoped-Define DISPLAYED-OBJECTS x-NomCta FILL-IN-Cco FILL-IN-Discco 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-COMBO-BOX-2 
       MENU-ITEM m_01_Monto_Afecto_ComprasVent LABEL "01 Monto Afecto Compras/Ventas"
       MENU-ITEM m_02_Exonerado_ComprasVentas LABEL "02 Exonerado Compras/Ventas"
       MENU-ITEM m_03_Total_Facturado_Ventas LABEL "03 Total Facturado Ventas"
       MENU-ITEM m_04_Adelanto_Efectivo_Ventas LABEL "04 Adelanto Efectivo Ventas"
       MENU-ITEM m_05_Adelanto_Materiales LABEL "05 Adelanto Materiales"
       MENU-ITEM m_06_Fondo_Garantia_Ventas LABEL "06 Fondo Garantia Ventas"
       MENU-ITEM m_07_Fonavi_Ventas LABEL "07 Fonavi Ventas"
       MENU-ITEM m_08_Seguro_CAR LABEL "08 Seguro CAR" 
       MENU-ITEM m_09_IGV__Ventas LABEL "09 I.G.V  Ventas"
       MENU-ITEM m_10_Valorizacin_Ventas LABEL "10 Valorizaci¢n Ventas".


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-aceptar AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 11.43 BY 1.46 TOOLTIP "Aceptar".

DEFINE BUTTON b-cancelar AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 11.43 BY 1.46 TOOLTIP "Cancelar".

DEFINE VARIABLE moneda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "S/.","US$" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE campo-aux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .69
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE FILL-IN-Cco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Discco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .69 NO-UNDO.

DEFINE VARIABLE x-NomCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .69
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE x-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .69
     BGCOLOR 7  NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 12.65.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DIALOG-1 FOR 
      cb-dmov SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     cb-dmov.CodCta AT ROW 1.54 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     x-NomCta AT ROW 1.54 COL 27 COLON-ALIGNED NO-LABEL
     cb-dmov.CodDiv AT ROW 2.35 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     x-NomDiv AT ROW 2.35 COL 27 COLON-ALIGNED NO-LABEL
     cb-dmov.ClfAux AT ROW 3.15 COL 14 COLON-ALIGNED
          LABEL "Clf. Auxiliar"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .69
          BGCOLOR 15 
     cb-dmov.CodAux AT ROW 3.15 COL 60 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .69
     campo-aux AT ROW 3.96 COL 14 COLON-ALIGNED NO-LABEL
     cb-dmov.CCo AT ROW 4.77 COL 14 COLON-ALIGNED
          LABEL "Centro de Costo"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
          BGCOLOR 15 
     FILL-IN-Cco AT ROW 4.77 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     cb-dmov.NroRuc AT ROW 4.77 COL 60 COLON-ALIGNED
          LABEL "R.U.C."
          VIEW-AS FILL-IN 
          SIZE 16 BY .69
     cb-dmov.CodDoc AT ROW 5.58 COL 14 COLON-ALIGNED
          LABEL "Cod. Docmto."
          VIEW-AS FILL-IN 
          SIZE 5.86 BY .69
          BGCOLOR 15 FGCOLOR 0 
     cb-dmov.NroDoc AT ROW 5.58 COL 60 COLON-ALIGNED
          LABEL "Nro. Documento" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .69
          BGCOLOR 15 
     cb-dmov.C-FCaja AT ROW 6.38 COL 14 COLON-ALIGNED
          LABEL "Cóncepto  F. Caja" FORMAT "x(7)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
     cb-dmov.OrdCmp AT ROW 6.38 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .69
     cb-dmov.GloDoc AT ROW 7.19 COL 14 COLON-ALIGNED FORMAT "x(254)"
          VIEW-AS FILL-IN 
          SIZE 57 BY .69
     moneda AT ROW 8 COL 14 COLON-ALIGNED HELP
          "Ingrese Moneda  --> Use flechas del cursor"
     cb-dmov.TpoCmb AT ROW 8 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     cb-dmov.TpoMov AT ROW 8.81 COL 14 COLON-ALIGNED
          LABEL "Tipo Mov" FORMAT "Haber/Debe"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Yes","No" 
          DROP-DOWN-LIST
          SIZE 9 BY 1
          BGCOLOR 15 
     cb-dmov.ImpMn1 AT ROW 8.81 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.72 BY .69
     cb-dmov.CodRef AT ROW 9.62 COL 14 COLON-ALIGNED
          LABEL "Nro. Referencia"
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .69
     cb-dmov.NroRef AT ROW 9.62 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .69
     cb-dmov.Dte_01 AT ROW 9.62 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 2 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     cb-dmov.ImpMn2 AT ROW 9.62 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.72 BY .69
     cb-dmov.FchDoc AT ROW 10.42 COL 14 COLON-ALIGNED
          LABEL "Fech. Documento"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     cb-dmov.TM AT ROW 10.42 COL 51.28
          LABEL "Tipo de Monto" FORMAT "99"
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .69
          BGCOLOR 15 
     cb-dmov.FchVto AT ROW 11.23 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME DIALOG-1
     cb-dmov.DisCco AT ROW 12.04 COL 14 COLON-ALIGNED FORMAT "999"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     FILL-IN-Discco AT ROW 12.04 COL 19 COLON-ALIGNED NO-LABEL
     cb-dmov.Log_01 AT ROW 12.85 COL 17 HELP
          "" NO-LABEL WIDGET-ID 6
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 12 BY .88
     b-aceptar AT ROW 14.19 COL 55
     b-cancelar AT ROW 14.19 COL 67.72
     "Gasto Sustentado?:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 13.12 COL 3 WIDGET-ID 10
     RECT-6 AT ROW 1.27 COL 2
     SPACE(0.56) SKIP(2.11)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Movimiento Contable".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN cb-dmov.C-FCaja IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN campo-aux IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       campo-aux:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.CCo IN FRAME DIALOG-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-dmov.ClfAux IN FRAME DIALOG-1
   EXP-LABEL                                                            */
ASSIGN 
       cb-dmov.ClfAux:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.CodAux IN FRAME DIALOG-1
   EXP-FORMAT                                                           */
ASSIGN 
       cb-dmov.CodAux:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.CodDiv:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.CodDoc IN FRAME DIALOG-1
   EXP-LABEL                                                            */
ASSIGN 
       cb-dmov.CodDoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.CodRef IN FRAME DIALOG-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-dmov.DisCco IN FRAME DIALOG-1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN cb-dmov.Dte_01 IN FRAME DIALOG-1
   EXP-FORMAT                                                           */
ASSIGN 
       cb-dmov.Dte_01:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.FchDoc IN FRAME DIALOG-1
   EXP-LABEL                                                            */
ASSIGN 
       cb-dmov.FchDoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.FchVto:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Cco IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Discco IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-dmov.GloDoc IN FRAME DIALOG-1
   EXP-FORMAT                                                           */
ASSIGN 
       cb-dmov.GloDoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.ImpMn1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-dmov.ImpMn2 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET cb-dmov.Log_01 IN FRAME DIALOG-1
   EXP-HELP                                                             */
/* SETTINGS FOR COMBO-BOX moneda IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN cb-dmov.NroDoc IN FRAME DIALOG-1
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       cb-dmov.NroDoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.NroRef:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.NroRuc IN FRAME DIALOG-1
   EXP-LABEL                                                            */
ASSIGN 
       cb-dmov.NroRuc:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.TM IN FRAME DIALOG-1
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
ASSIGN 
       cb-dmov.TM:POPUP-MENU IN FRAME DIALOG-1       = MENU POPUP-MENU-COMBO-BOX-2:HANDLE.

/* SETTINGS FOR FILL-IN cb-dmov.TpoCmb IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-dmov.TpoMov IN FRAME DIALOG-1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN x-NomCta IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomDiv IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-dmov"
     _Options          = "SHARE-LOCK"
     _Where[1]         = "RECID(cb-dmov) = RegAct"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-aceptar DIALOG-1
ON CHOOSE OF b-aceptar IN FRAME DIALOG-1 /* Aceptar */
DO:
    IF moneda:SCREEN-VALUE = "S/."  THEN y-codmon = 1.
    ELSE y-codmon = 2.
    /* Verificamos si todo los campos estan bien ingresados */
    /* CodCta */
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = cb-dmov.CodCta:SCREEN-VALUE
                       NO-LOCK NO-ERROR.
     
    IF NOT AVAILABLE cb-ctas OR LENGTH(cb-dmov.CodCta:SCREEN-VALUE) <>
         INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        MESSAGE "Invalido Código de Cuenta" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.CodCta.
        RETURN NO-APPLY.
    END.
    /* CodDiv */
    IF cb-cfga.CodDiv THEN DO:
        IF LENGTH(cb-dmov.CodDiv:SCREEN-VALUE) < 5   THEN DO:
            MESSAGE "Código de Divisionaria no es de ultimo Nivel" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.CodDiv.
            RETURN NO-APPLY.
        END.
        IF NOT CAN-FIND(GN-DIVI WHERE GN-DIVI.CodCia = S-codcia AND
                                      GN-DIVI.CodDIV = cb-dmov.CodDiv:SCREEN-VALUE)
        THEN DO:
            MESSAGE "Invalido Código de Divisionaria" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.CodDiv.
            RETURN NO-APPLY.
        END.    
    END.
    
    /* CodAux */
    IF cb-ctas.PidAux
    THEN 
        aux:
        DO:
            DO ON ERROR UNDO, LEAVE:
                RUN Cfg-CodAux.
                LEAVE aux.
            END.
            MESSAGE "Invalido Código Auxiliar" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.CodDiv.
            RETURN NO-APPLY.
        END.
    /* CodDoc */
    IF cb-ctas.PidDoc AND 
        NOT CAN-FIND(cb-tabl WHERE cb-tabl.Tabla  = "02" AND
                                 cb-tabl.Codigo = cb-dmov.CodDoc:SCREEN-VALUE)
    THEN DO:
        MESSAGE "Invalido Código de Documento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.CodDoc.
        RETURN NO-APPLY.
    END.
    /* NroDoc */
    IF cb-ctas.PidDoc AND cb-dmov.Nrodoc:SCREEN-VALUE = ""
    THEN DO:
        MESSAGE "Invalido No. de Documento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.NroDoc.
        RETURN NO-APPLY.
    END.
/*     IF cb-oper.RESUME OR cb-ctas.CODCTA BEGINS "10" THEN DO:                      */
/*       FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND                   */
/*                                 cb-auxi.clfaux  =  "@FC"       AND                */
/*                                 cb-auxi.codaux  =  INPUT cb-dmov.C-FCAJA          */
/*                                 NO-LOCK NO-ERROR.                                 */
/*       IF NOT AVAIL cb-auxi THEN DO:                                               */
/*          MESSAGE "Código de Flujo de Caja no registrado" VIEW-AS ALERT-BOX ERROR. */
/*          RETURN NO-APPLY.                                                         */
/*       END.                                                                        */
/*     END.                                                                          */

    /* Centro de Costo */
    IF cb-ctas.PidCco THEN DO:
        FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                        AND cb-auxi.CLFAUX = "CCO"
                        AND cb-auxi.CodAUX = cb-dmov.CCO:SCREEN-VALUE
                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi
        THEN DO:
            MESSAGE "Centro de Costo NO Registrado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF cb-auxi.Libre_l01 = NO THEN DO:
            MESSAGE "Centro de Costo Descativado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        /* Código de distribución del centro de costo */
        FIND cb-tabl WHERE cb-tabl.tabla = '15'
            AND cb-tabl.codigo = cb-dmov.DisCco:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-tabl THEN DO:
            MESSAGE "Código de Distribución NO Registrado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.

    /* RHC 14.08.06 OrdCmp */
    IF cb-dmov.OrdCmp:VISIBLE = YES AND cb-dmov.OrdCmp:SENSITIVE = YES 
            AND LOOKUP(TRIM(cb-dmov.CodDoc:SCREEN-VALUE), '07,08') = 0      /* NO N/C ni N/D */
            AND s-Periodo >= 2012
            THEN DO:
        IF cb-dmov.OrdCmp:SCREEN-VALUE = '' THEN DO:
            MESSAGE 'Debe ingresar la Orden de Compra' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
            RETURN NO-APPLY.
        END.
        /* RHC 25.01.2012 AGREGAMOS COMPRAS ADMINISTATIVAS */
        FIND lg-cocmp WHERE lg-cocmp.codcia = s-codcia
            AND lg-cocmp.coddiv = s-coddiv
            AND lg-cocmp.NroDoc = INTEGER(cb-dmov.OrdCmp:SCREEN-VALUE)
            AND lg-cocmp.CodPro = INPUT cb-dmov.CodAux
            NO-LOCK NO-ERROR.
        IF AVAILABLE lg-cocmp THEN DO:
            IF LOOKUP(lg-cocmp.flgsit, 'P,T,C') = 0 THEN DO:
                MESSAGE 'Orden de Compra debe estar aprobada' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
                RETURN NO-APPLY.
            END.
            IF lg-cocmp.flgsit = 'P' THEN DO:
                MESSAGE 'Orden de Compra aún no ha sido cerrada' SKIP
                    'Continuamos con la actualización?'
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                    UPDATE rpta-1 AS LOG.
                IF rpta-1 = No THEN DO:
                    APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
                    RETURN NO-APPLY.
                END.
            END.
        END.
        ELSE DO:
            IF INDEX(cb-dmov.OrdCmp:SCREEN-VALUE, '-') > 0 THEN DO:
                FIND lg-coser WHERE lg-coser.CodCia = s-codcia
                    AND lg-coser.CodDoc = "OCA"
                    AND lg-coser.NroSer = INTEGER(ENTRY(1, cb-dmov.OrdCmp:SCREEN-VALUE,'-'))
                    AND lg-coser.NroDoc = INTEGER(ENTRY(2, cb-dmov.OrdCmp:SCREEN-VALUE,'-'))
                    AND lg-coser.CodPro = INPUT cb-dmov.CodAux
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE lg-coser THEN DO:
                    MESSAGE 'Orden de Compra no registrada' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
                    RETURN NO-APPLY.
                END.
                IF LOOKUP(lg-coser.flgsit, 'P,C') = 0 THEN DO:
                    MESSAGE 'Orden de Compra debe estar aprobada' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
                    RETURN NO-APPLY.
                END.
                IF lg-coser.flgsit = 'P' THEN DO:
                    MESSAGE 'Orden de Compra aún no ha sido cerrada' SKIP
                        'Continuamos con la actualización?'
                        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                        UPDATE rpta-2 AS LOG.
                    IF rpta-2 = No THEN DO:
                        APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
                        RETURN NO-APPLY.
                    END.
                END.
            END.
            ELSE DO:
                MESSAGE 'Orden de Compra no registrada' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO cb-dmov.OrdCmp.
                RETURN NO-APPLY.
            END.
        END.
    END.
    /* ******************* */
    
    /* Importes */
    IF y-CodMon = 1 THEN DO:
      IF INPUT cb-dmov.ImpMn1 < 0 THEN DO:
            MESSAGE "Invalido Importe Registrado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.ImpMn1.
            RETURN NO-APPLY.
      END.
    END.
    ELSE DO:
         IF INPUT cb-dmov.ImpMn2 < 0 THEN DO:
            MESSAGE "Invalido Importe Registrado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.ImpMn2.
            RETURN NO-APPLY.
         END.
    END.     
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut  = 0.
       
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):

        IF cb-dmov.CodCta:SCREEN-VALUE BEGINS ENTRY( i, cb-cfga.GenAut9 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta:SCREEN-VALUE BEGINS ENTRY( i, cb-cfga.GenAut6 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta:SCREEN-VALUE BEGINS ENTRY( i, cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> ""
            THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN cb-dmov.CtaAut = ""
           cb-dmov.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN cb-dmov.CtrCta = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN 
                cb-dmov.CtaAut = INPUT FRAME DIALOG-1 cb-dmov.CodAux.
             ELSE
                cb-dmov.CtaAut = cb-ctas.An1Cta.
             IF cb-dmov.CtrCta = ""  THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
             ASSIGN cb-dmov.CtrCta = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN 
                cb-dmov.CtaAut = INPUT FRAME DIALOG-1 cb-dmov.CodAux.
             ELSE
                cb-dmov.CtaAut = cb-ctas.An1Cta.
             IF cb-dmov.CtrCta = ""  THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
        END.
           
        WHEN 3 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
                     
                    END.
    END CASE.
    /* Chequendo las cuentas a generar en forma autom ticas */
   
    IF x-GenAut > 0
    THEN DO:
       
         
         IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                                              cb-ctas.CodCta = cb-dmov.CtaAut) 
                    AND LENGTH( cb-dmov.CtaAut)  <>
                        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
                 THEN DO:
                          MESSAGE "Cuentas Autom ticas a generar" SKIP
                                  "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
                          APPLY "ENTRY":U TO cb-dmov.CODCTA.
                          RETURN NO-APPLY.
                      END.
       
        
        IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                                       cb-ctas.CodCta = cb-dmov.CtrCta ) 
                    AND LENGTH( cb-dmov.CtrCta )  <>
                         INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
                 THEN DO:
                          MESSAGE "Cuentas Autom ticas a generar" SKIP
                                  "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
                          APPLY "ENTRY":U TO cb-dmov.CODCTA.
                          RETURN NO-APPLY.
                      END.
                      
    END. /*Fin del x-genaut > 0 */   
    ELSE /*Verifico si la provision se repite */
        DO:
            FIND FIRST cp-tpro WHERE cp-tpro.codcia = cb-codcia     AND
                                     cp-tpro.codope = cb-dmov.codope AND
                                     cp-tpro.codcta = INPUT cb-dmov.codcta 
                                     NO-LOCK NO-ERROR.
            IF AVAIL cp-tpro and P-crear THEN DO:                          
               /* VERIFICA EL COMPROBANTE */
               FIND FIRST B-DETALLE WHERE 
                    B-DETALLE.CODCIA  = cb-dmov.CODCIA        AND
                    B-DETALLE.PERIODO = cb-dmov.PERIODO       AND
                    B-DETALLE.CODOPE  = cb-dmov.CODOPE        AND
                    B-DETALLE.CODCTA  = INPUT cb-dmov.CODCTA  AND
                    B-DETALLE.CODAUX  = INPUT cb-dmov.CODAUX  AND
                    B-DETALLE.CODDOC  = INPUT cb-dmov.CODDOC  AND
                    B-DETALLE.NRODOC  = INPUT cb-dmov.NRODOC  AND
                    B-DETALLE.TPOMOV  = INPUT cb-dmov.TPOMOV
                    NO-LOCK NO-ERROR.
                IF AVAIL B-DETALLE THEN DO:
                    def var tmp as char.
                    IF INPUT cb-dmov.TPOMOV THEN tmp = " HABER ".
                                            ELSE tmp = " DEBE  ".
                    MESSAGE "Esta provision ya fue registrada en : " SKIP
                            "Mes      :    " + string(b-detalle.nromes,"99") SKIP
                            "Operacion:    " +        b-detalle.codope       SKIP
                            "Asiento  :    " +        b-detalle.nroast       SKIP
                            "Movimimiento: " +        tmp                    SKIP
                            "Importe S/.   " +  STRING(B-DETALLE.IMPMN1,"ZZ,ZZZ,ZZ9.99") skip
                            "Importe US$   " +  STRING(B-DETALLE.IMPMN2,"ZZ,ZZZ,ZZ9.99") skip(2)
                            "Desea Continuar ? "
                            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO 
                            UPDATE SEGUIR AS LOGICAL.
                    IF NOT SEGUIR THEN RETURN NO-APPLY.        
                END.     

               /* RHC 14.08.06 VERIFICA LA ORDEN DE COMPRA */
               IF INPUT cb-dmov.OrdCmp <> '' THEN DO:
                FIND FIRST B-DETALLE WHERE 
                     B-DETALLE.CODCIA  = cb-dmov.CODCIA        AND
                     B-DETALLE.PERIODO = cb-dmov.PERIODO       AND
                     B-DETALLE.CODOPE  = cb-dmov.CODOPE        AND
                     B-DETALLE.CODCTA  = INPUT cb-dmov.CODCTA  AND
                     B-DETALLE.CODAUX  = INPUT cb-dmov.CODAUX  AND
                     B-DETALLE.CODDOC  = INPUT cb-dmov.CODDOC  AND
                     INTEGER(B-DETALLE.ORDCMP)  = INTEGER(INPUT cb-dmov.ORDCMP)  AND
                     B-DETALLE.TPOMOV  = INPUT cb-dmov.TPOMOV
                     NO-LOCK NO-ERROR.
                 IF AVAIL B-DETALLE THEN DO:
                     def var tmp-2 as char.
                     IF INPUT cb-dmov.TPOMOV THEN tmp-2 = " HABER ".
                                             ELSE tmp-2 = " DEBE  ".
                     MESSAGE "Esta orden de compra ya fue registrada en : " SKIP
                             "Mes      :    " + string(b-detalle.nromes,"99") SKIP
                             "Operacion:    " +        b-detalle.codope       SKIP
                             "Asiento  :    " +        b-detalle.nroast       SKIP
                             "Movimimiento: " +        tmp-2                  SKIP
                             "Importe S/.   " +  STRING(B-DETALLE.IMPMN1,"ZZ,ZZZ,ZZ9.99") skip
                             "Importe US$   " +  STRING(B-DETALLE.IMPMN2,"ZZ,ZZZ,ZZ9.99") skip(2)
                             "Desea Continuar ? "
                             VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO 
                             UPDATE SEGUIR-2 AS LOGICAL.
                     IF NOT SEGUIR-2 THEN RETURN NO-APPLY.        
                 END.     
               END. 
                
            END.
        END.
    

    /* Asignando los datos registrados */
    ASSIGN FRAME DIALOG-1
           cb-dmov.Codcta
           cb-dmov.CodDiv
           cb-dmov.ClfAux
           cb-dmov.CodAux
           cb-dmov.NroRuc
           cb-dmov.CodDoc
           cb-dmov.NroDoc
           cb-dmov.OrdCmp
           cb-dmov.GloDoc
           cb-dmov.CodMon = y-codmon
           cb-dmov.TpoCmb
           cb-dmov.TpoMov
           cb-dmov.ImpMn1
           cb-dmov.ImpMn2
           cb-dmov.NroRef
           cb-dmov.CodRef
           cb-dmov.FchDoc
           cb-dmov.FchVto
           cb-dmov.Cco
           cb-dmov.Tm
           cb-dmov.C-FCAJA
           cb-dmov.DisCCo
/*MLR-01*/ cb-dmov.dte_01 /* 27/Ene/20009 Fecha de documento referencia */
           cb-dmov.flgact = FALSE
           cb-dmov.LOG_01.

    IF cb-dmov.codaux <> "" THEN old_codaux = cb-dmov.codaux.
    IF cb-dmov.coddoc <> "" THEN old_coddoc = cb-dmov.coddoc.
    IF cb-dmov.nroruc <> "" THEN old_nroruc = cb-dmov.nroruc.
    IF cb-dmov.nrodoc <> "" THEN old_nrodoc = cb-dmov.nrodoc.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.C-FCaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.C-FCaja DIALOG-1
ON F8 OF cb-dmov.C-FCaja IN FRAME DIALOG-1 /* Cóncepto  F. Caja */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.C-FCAJA DO:
   def var X-ROWID AS ROWID.
   RUN cbd/H-auxi01.w(s-codcia, "@FC",OUTPUT X-ROWID).
   IF X-ROWID <> ? THEN DO:
      FIND cb-auxi WHERE ROWID(cb-auxi) = X-ROWID
        NO-LOCK NO-ERROR.
      IF AVAIL cb-auxi THEN ASSIGN self:screen-value = cb-auxi.codaux.
      ELSE DO:
           MESSAGE "Concepto de Flujo de Caja no registrada" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.    
      END.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.C-FCaja DIALOG-1
ON LEAVE OF cb-dmov.C-FCaja IN FRAME DIALOG-1 /* Cóncepto  F. Caja */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND 
                             cb-auxi.clfaux  =  "@FC"  AND
                             cb-auxi.codaux  =  SELF:SCREEN-VALUE
                             NO-LOCK NO-ERROR.                                
     IF NOT AVAIL cb-auxi THEN DO:
        MESSAGE "Código de Flujo de Caja no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.                          
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CCo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CCo DIALOG-1
ON F8 OF cb-dmov.CCo IN FRAME DIALOG-1 /* Centro de Costo */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CCO DO:
   /*queda fija la clasificacion CCO para centro de costo*/
   DEF VAR T-ROWID AS ROWID.
   /*
   RUN cbd/q-auxi.w(cb-codcia,"CCO", OUTPUT RECID-stack).
   */
   RUN cbd/H-auxi01.w(s-codcia,"CCO", OUTPUT T-ROWID). 
   IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN cb-dmov.CCO:SCREEN-VALUE = cb-auxi.CodAux.
    END.
    RETURN NO-APPLY.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CCo DIALOG-1
ON LEAVE OF cb-dmov.CCo IN FRAME DIALOG-1 /* Centro de Costo */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN DO:
        MESSAGE "Centro de Costo no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FILL-IN-Cco:SCREEN-VALUE = cb-auxi.Nomaux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.ClfAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.ClfAux DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF cb-dmov.ClfAux IN FRAME DIALOG-1 /* Clf. Auxiliar */
OR "F8":U OF cb-dmov.Clfaux
DO:
    RUN cbd/q-clfaux.w("01", OUTPUT RECID-stack).
    IF RECID-stack <> 0 THEN DO:
       FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack NO-LOCK  NO-ERROR.
       IF AVAIL cb-tabl THEN DO:
            cb-dmov.Clfaux:SCREEN-VALUE = cb-tabl.codigo.
       END.
       ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodAux DIALOG-1
ON F8 OF cb-dmov.CodAux IN FRAME DIALOG-1 /* Auxiliar */
OR "MOUSE-SELECT-DBLCLICK":U OF CB-DMOV.codaux DO:
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  
    CASE cb-dmov.ClfAux:SCREEN-VALUE IN FRAME DIALOG-1:
    WHEN "@PV"  THEN DO:
        RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
        IF T-ROWID <> ? THEN DO:
           FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
           IF AVAILABLE gn-prov THEN DO:
              cb-dmov.CodAux:SCREEN-VALUE = gn-prov.CodPro.
              campo-aux:SCREEN-VALUE      = gn-prov.NomPro.
           END.
        END.
    END.
    WHEN "@CL" THEN DO:
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).    
        IF T-ROWID <> ? THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie THEN DO:
               cb-dmov.CodAux:SCREEN-VALUE = gn-clie.CodCli.
               campo-aux:SCREEN-VALUE      = gn-clie.NomCli.
            END.
        END.
    END.
    WHEN "@CT" THEN DO:
            RUN cbd/q-ctas2.w(cb-codcia, "9", OUTPUT T-RECID).
            IF T-RECID <> ?
            THEN DO:
                find cb-ctas WHERE RECID(cb-ctas) = T-RECID NO-LOCK  NO-ERROR.
                IF avail cb-ctas
                THEN DO:
                    cb-dmov.CodAux:SCREEN-VALUE = cb-ctas.CodCta.
                    campo-aux:SCREEN-VALUE      = cb-ctas.NomCta.
                END.
            END.
  
    END.
    OTHERWISE DO:
        RUN CBD/H-AUXI01(s-codcia,cb-dmov.ClfAux:SCREEN-VALUE, OUTPUT T-ROWID ).     
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN DO:
                cb-dmov.Codaux:SCREEN-VALUE = cb-auxi.CodAux.
                campo-aux:SCREEN-VALUE      = cb-auxi.NomAux.
            END.
        END.
    END.
    END CASE.
    RETURN NO-APPLY.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodAux DIALOG-1
ON LEAVE OF cb-dmov.CodAux IN FRAME DIALOG-1 /* Auxiliar */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.

    DO ON ERROR UNDO, LEAVE:
        RUN Cfg-CodAux.
        RETURN.
    END.
    MESSAGE "Auxiliar no Registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodCta DIALOG-1
ON F8 OF cb-dmov.CodCta IN FRAME DIALOG-1 /* Cuenta Contable */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.codcta DO:
  /*  RUN cbd/q-ctas4.w(cb-codcia,cb-dmov.CodCta:SCREEN-VALUE,s-codcia,OUTPUT T-ROWID).
  */
    DEF VAR T-ROWID AS ROWID.
    RUN CBD/H-CTAS01.W(s-codcia, 0,OUTPUT T-ROWID).
    IF T-ROWID <> ?
    THEN DO:
        find cb-ctas WHERE ROWID(cb-ctas) = T-ROWID NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            cb-dmov.CodCta:SCREEN-VALUE = cb-ctas.CodCta.
            x-NomCta:SCREEN-VALUE       = cb-ctas.NomCta.
            IF cb-ctas.PidAux
            THEN DISPLAY cb-ctas.ClfAux @ cb-dmov.ClfAux WITH FRAME DIALOG-1.
            IF cb-ctas.PidDoc
            THEN DISPLAY cb-ctas.CodDoc @ cb-dmov.CodDoc WITH FRAME DIALOG-1.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    APPLY "CHOOSE":U TO cb-dmov.CodCta.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodCta DIALOG-1
ON LEAVE OF cb-dmov.CodCta IN FRAME DIALOG-1 /* Cuenta Contable */
DO:     
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = INPUT cb-dmov.CodCta
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        BELL.
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-dmov.CodCta IN FRAME DIALOG-1.
        RETURN NO-APPLY.
    END.
    IF LENGTH(cb-dmov.CodCta:SCREEN-VALUE) <> 
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        BELL.
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Cfg-CodCta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDiv DIALOG-1
ON F8 OF cb-dmov.CodDiv IN FRAME DIALOG-1 /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CODDIV DO:
  {CBD/H-DIVI01.i YES x-NomDiv}
          
  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDiv DIALOG-1
ON LEAVE OF cb-dmov.CodDiv IN FRAME DIALOG-1 /* División */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    
    FIND gn-divi  WHERE gn-divi.CodCia = S-codcia
                    AND gn-divi.coddiv = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi
    THEN DO:
        MESSAGE "C¢digo de Divisionaria no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomDiv:SCREEN-VALUE = GN-DIVI.DESDIV.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDoc DIALOG-1
ON F8 OF cb-dmov.CodDoc IN FRAME DIALOG-1 /* Cod. Docmto. */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CodDoc DO:
    RUN cbd/q-clfaux.w("02", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-dmov.CodDoc:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDoc DIALOG-1
ON LEAVE OF cb-dmov.CodDoc IN FRAME DIALOG-1 /* Cod. Docmto. */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodRef DIALOG-1
ON F8 OF cb-dmov.CodRef IN FRAME DIALOG-1 /* Nro. Referencia */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CodRef DO:
    RUN cbd/q-clfaux.w("02", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-dmov.CodRef:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.DisCco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.DisCco DIALOG-1
ON LEAVE OF cb-dmov.DisCco IN FRAME DIALOG-1 /* Distr. C.C. */
DO:
/*         FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack            */
/*               NO-LOCK  NO-ERROR.                                     */
/*         IF AVAIL cb-tabl THEN DO:                                    */
/*              cb-dmov.DisCCo:SCREEN-VALUE = cb-tabl.codigo.           */
/*         END.                                                         */
/*         ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR */
/*             BUTTONS OK.                                              */
  FILL-IN-Discco:SCREEN-VALUE = ''.
  FIND cb-tabl WHERE cb-tabl.tabla = '15'
    AND cb-tabl.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE cb-tabl THEN FILL-IN-Discco:SCREEN-VALUE = cb-tabl.nombre.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.DisCco DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF cb-dmov.DisCco IN FRAME DIALOG-1 /* Distr. C.C. */
OR "F8":U OF cb-dmov.DisCCo
DO:
    RUN cbd/q-clfaux.w("15", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-dmov.DisCCo:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.FchDoc DIALOG-1
ON LEAVE OF cb-dmov.FchDoc IN FRAME DIALOG-1 /* Fech. Documento */
DO:
  DEFINE VAR ftpocmb AS DECIMAL.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT cb-dmov.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO :     
        IF cb-oper.TpoCmb = 1 THEN fTpoCmb = gn-tcmb.Compra.
           ELSE fTpoCmb = gn-tcmb.Venta.           
        END.     
        ELSE MESSAGE "No existe Tipo de Cambio" SKIP
                     "para la fecha registrada" VIEW-AS ALERT-BOX.

  IF INPUT cb-dmov.TpoCmb <> ftpocmb THEN DO :
     MESSAGE "Desea Cambiar el Tipo de cambio" VIEW-AS
     ALERT-BOX QUESTION BUTTONS YES-NO
           TITLE "" UPDATE Respuesta AS LOGICAL.
  END.
  IF Respuesta THEN DO :
     cb-dmov.TpoCmb = fTpoCmb.
  END.
  DISPLAY cb-dmov.TpoCmb WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.ImpMn1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.ImpMn1 DIALOG-1
ON LEAVE OF cb-dmov.ImpMn1 IN FRAME DIALOG-1 /* Importe (S/.) */
DO:
    IF cb-oper.CodMon <> 4 OR cb-dmov.ImpMn2 = 0 THEN DO:
        DISPLAY DECIMAL(cb-dmov.ImpMn1:SCREEN-VALUE) / DECIMAL(cb-dmov.TpoCmb:SCREEN-VALUE)
                @ cb-dmov.ImpMn2 WITH FRAME DIALOG-1.
        cb-dmov.ImpMn2 = INPUT cb-dmov.ImpMn2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.ImpMn2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.ImpMn2 DIALOG-1
ON LEAVE OF cb-dmov.ImpMn2 IN FRAME DIALOG-1 /* Importe (US$) */
DO:
        IF cb-oper.CodMon <> 4 OR cb-dmov.ImpMn2 = 0 THEN DO:
            DISPLAY DECIMAL(cb-dmov.ImpMn2:SCREEN-VALUE) * DECIMAL(cb-dmov.TpoCmb:SCREEN-VALUE)
                @ cb-dmov.ImpMn1 WITH FRAME DIALOG-1.
            cb-dmov.ImpMn1 = INPUT cb-dmov.ImpMn1.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moneda DIALOG-1
ON RETURN OF moneda IN FRAME DIALOG-1 /* Moneda */
DO:
  APPLY "TAB":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moneda DIALOG-1
ON VALUE-CHANGED OF moneda IN FRAME DIALOG-1 /* Moneda */
DO:
    IF moneda:SCREEN-VALUE = "S/."
    THEN y-CodMon = 1.
    ELSE y-CodMon = 2.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_01_Monto_Afecto_ComprasVent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_01_Monto_Afecto_ComprasVent DIALOG-1
ON CHOOSE OF MENU-ITEM m_01_Monto_Afecto_ComprasVent /* 01 Monto Afecto Compras/Ventas */
DO:
  DO WITH FRAME {&FRAME-NAME} :
    integral.cb-dmov.tm:SCREEN-VALUE = "01".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_02_Exonerado_ComprasVentas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_02_Exonerado_ComprasVentas DIALOG-1
ON CHOOSE OF MENU-ITEM m_02_Exonerado_ComprasVentas /* 02 Exonerado Compras/Ventas */
DO:
   DO WITH FRAME {&FRAME-NAME} :
    integral.cb-dmov.tm:SCREEN-VALUE = "02".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.NroRuc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.NroRuc DIALOG-1
ON LEAVE OF cb-dmov.NroRuc IN FRAME DIALOG-1 /* R.U.C. */
DO:
   IF SELF:SCREEN-VALUE = "" THEN DO:
        MESSAGE "N£mero ruc debe tener 8 caracteres"
        VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.TM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.TM DIALOG-1
ON F8 OF cb-dmov.TM IN FRAME DIALOG-1 /* Tipo de Monto */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.TM DO:
  RUN cbd/q-clfaux.w("05", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-dmov.TM:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.TpoCmb DIALOG-1
ON LEAVE OF cb-dmov.TpoCmb IN FRAME DIALOG-1 /* Tpo. Cambio */
DO:
  IF y-CodMon = 1 THEN DO :     
      DISPLAY DECIMAL(cb-dmov.ImpMn1:SCREEN-VALUE) / DECIMAL(cb-dmov.TpoCmb:SCREEN-VALUE)
                      @ cb-dmov.ImpMn2 WITH FRAME DIALOG-1.
                      cb-dmov.ImpMn2 = INPUT cb-dmov.ImpMn2.     
  END.   
  ELSE DO :
        DISPLAY DECIMAL(cb-dmov.ImpMn2:SCREEN-VALUE) * DECIMAL(cb-dmov.TpoCmb:SCREEN-VALUE)
               @ cb-dmov.ImpMn1 WITH FRAME DIALOG-1.
               cb-dmov.ImpMn1 = INPUT cb-dmov.ImpMn1.
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.TpoMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.TpoMov DIALOG-1
ON RETURN OF cb-dmov.TpoMov IN FRAME DIALOG-1 /* Tipo Mov */
DO:
  APPLY "TAB":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
    RUN enable_UI.
    FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
        NO-LOCK NO-ERROR.

    IF AVAILABLE cb-cfga 
    THEN IF cb-cfga.CodDiv
        THEN ASSIGN cb-dmov.CodDiv:VISIBLE  = YES
                    x-NomDiv:VISIBLE        = YES.
        ELSE ASSIGN cb-dmov.CodDiv:VISIBLE  = NO
                    x-NomDiv:VISIBLE        = NO.
                    
    FIND cb-oper WHERE  cb-oper.CodCia = cb-codcia AND
                        cb-oper.CodOpe = cb-dmov.CodOpe NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN 
       CASE cb-oper.CodMon:
                WHEN 1  THEN cb-dmov.ImpMn1:SENSITIVE = YES.
                WHEN 2  THEN cb-dmov.ImpMn2:SENSITIVE = YES.
                WHEN 3  THEN IF x-CodMon = 1
                             THEN    cb-dmov.ImpMn1:SENSITIVE = YES.
                             ELSE    cb-dmov.ImpMn2:SENSITIVE = YES.
                WHEN 4  THEN ASSIGN Moneda:SENSITIVE = YES
                                    cb-dmov.TpoCmb:SENSITIVE = YES
                                    cb-dmov.ImpMn1:SENSITIVE = YES
                                    cb-dmov.ImpMn2:SENSITIVE = YES.
                OTHERWISE cb-dmov.ImpMn1:SENSITIVE = YES.
       END CASE. 
    ELSE DO:
        MESSAGE "No existe Código de Operación" VIEW-AS ALERT-BOX ERROR.
        UNDO, LEAVE MAIN-BLOCK.
    END.
        
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN RUN Cfg-CodCta.

    IF cb-dmov.CodMon = 1
    THEN moneda:SCREEN-VALUE = "S/.".
    ELSE moneda:SCREEN-VALUE = "US$".
    y-CodMon = cb-dmov.codmon.
    /* RHC 23.04.2012 */
    IF p-Crear = YES THEN cb-dmov.LOG_01:SCREEN-VALUE = "Si".
    /* ************** */
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    RUN disable_UI.
    RETURN.
END.
RUN disable_UI.
RETURN ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-CodAux DIALOG-1 
PROCEDURE Cfg-CodAux :
CASE cb-dmov.ClfAux:SCREEN-VALUE IN FRAME DIALOG-1:
    WHEN "@PV" THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
            AND gn-prov.CodPro = cb-dmov.CodAux:SCREEN-VALUE IN FRAME DIALOG-1
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov
        THEN RETURN ERROR.
        /* cesado o activo */
        IF gn-prov.flgsit = 'C' THEN DO:
            MESSAGE 'Proveedor Cesado' VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.
        DISPLAY gn-prov.NomPro @ campo-aux       WITH FRAME DIALOG-1.
        IF cb-dmov.NroRuc:SCREEN-VALUE = "" THEN DO :
           IF gn-prov.RUC <> "" THEN
              DISPLAY gn-prov.Ruc @ cb-dmov.NroRuc  WITH FRAME DIALOG-1.
        END.   
                   
    END.
    WHEN "@CL" THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
                            gn-clie.CodCli = cb-dmov.CodAux:SCREEN-VALUE  IN FRAME DIALOG-1
                            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN RETURN ERROR.                       
        DISPLAY  gn-clie.NomCli @ campo-aux      WITH FRAME DIALOG-1.
        DISPLAY  gn-clie.Ruc    @ cb-dmov.NroRuc WITH FRAME DIALOG-1.
    END.
    WHEN "@CT"  THEN DO:         
            IF LENGTH(cb-dmov.Codaux:SCREEN-VALUE IN FRAME DIALOG-1) <>
                INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)) THEN RETURN ERROR.
            FIND B-CTAS WHERE B-CTAS.CodCia = cb-codcia AND
                 B-CTAS.CodCta = cb-dmov.CodAux:SCREEN-VALUE IN FRAME DIALOG-1
                 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-CTAS THEN RETURN ERROR.
            DISPLAY B-CTAS.NomCta @ campo-aux  WITH FRAME DIALOG-1.                                
    END.  
    OTHERWISE DO:
        FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
                           cb-auxi.ClfAux = cb-dmov.ClfAux:SCREEN-VALUE IN FRAME DIALOG-1 AND
                           cb-auxi.CodAux = cb-dmov.CodAux:SCREEN-VALUE IN FRAME DIALOG-1
                           NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi 
        THEN RETURN ERROR.   
        DISPLAY cb-auxi.NomAux @ campo-aux  WITH FRAME DIALOG-1.
    END.
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-CodCta DIALOG-1 
PROCEDURE Cfg-CodCta :
DISPLAY cb-ctas.NomCta @ x-NomCta WITH FRAME DIALOG-1.

    IF cb-cfga.CodDiv AND cb-dmov.CodDiv = "" THEN cb-dmov.CodDiv:SCREEN-VALUE = cb-ctas.CodDiv.    
    
    IF cb-ctas.PidAux THEN DO:
       IF cb-ctas.ClfAux <> cb-dmov.ClfAux:SCREEN-VALUE IN FRAME DIALOG-1
          THEN DISPLAY cb-ctas.ClfAux @ cb-dmov.ClfAux WITH FRAME DIALOG-1.
       ASSIGN 
           cb-dmov.CodAux:VISIBLE = YES.               
       DO ON ERROR UNDO,LEAVE:
          RUN Cfg-CodAux.
       END.
       IF LOOKUP( cb-dmov.ClfAux:SCREEN-VALUE, "@PV,@CL" ) = 0
       THEN cb-dmov.NroRuc:HIDDEN  = YES.
       ELSE cb-dmov.NroRuc:VISIBLE = YES.
    END.
    ELSE DO:
            ASSIGN
                cb-dmov.ClfAux:HIDDEN = YES
                cb-dmov.CodAux:HIDDEN = YES                
                campo-aux:HIDDEN      = YES
                cb-dmov.NroRuc:HIDDEN = YES.
    END.
    
    /* cb-dmov.TpoMov:SCREEN-VALUE = STRING(cb-ctas.MovCta,"H/D"). */
    
    IF cb-ctas.Pidcco THEN 
       ASSIGN cb-dmov.cco:VISIBLE = YES
              cb-dmov.DisCco:VISIBLE = YES.              
    ELSE ASSIGN cb-dmov.Cco:HIDDEN  = YES
                cb-dmov.DisCco:HIDDEN = YES.
    
    IF (cb-oper.resume OR INPUT cb-dmov.CODCTA BEGINS "10" ) THEN 
       ASSIGN cb-dmov.c-fcaja:VISIBLE = YES.  
    ELSE cb-dmov.c-fcaja:HIDDEN  = YES.
  
    ENABLE cb-dmov.TM WITH FRAME DIALOG-1. 
          ASSIGN cb-dmov.TM:VISIBLE = YES.
    IF cb-ctas.PidDoc THEN DO:
        IF cb-dmov.CodDoc:SCREEN-VALUE = ""
        THEN DISPLAY cb-ctas.CodDoc @ cb-dmov.CodDoc WITH FRAME DIALOG-1.
        ASSIGN cb-dmov.CodDoc:VISIBLE = YES               
               cb-dmov.NroDoc:VISIBLE = YES
               cb-dmov.FchDoc:VISIBLE = YES
               cb-dmov.FchVto:VISIBLE = YES
               cb-dmov.CodDoc:SENSITIVE = TRUE
               cb-dmov.NroDoc:SENSITIVE = TRUE.
    END.
    ELSE DO:
        ASSIGN cb-dmov.CodDoc:HIDDEN = YES               
               cb-dmov.NroDoc:HIDDEN = YES
               cb-dmov.FchDoc:HIDDEN = YES
               cb-dmov.FchVto:HIDDEN = YES
               cb-dmov.CodDoc:SCREEN-VALUE = ""
               cb-dmov.NroDoc:SCREEN-VALUE = "".
    END.
    IF cb-ctas.PidRef
    THEN ASSIGN cb-dmov.NroRef:VISIBLE      = YES
                cb-dmov.Dte_01:VISIBLE      = YES
                cb-dmov.CodRef:VISIBLE      = YES.
                
    ELSE ASSIGN cb-dmov.NroRef:HIDDEN       = YES
                cb-dmov.Dte_01:HIDDEN       = YES
                cb-dmov.CodRef:HIDDEN       = YES
                cb-dmov.NroRef:SCREEN-VALUE = ""
                cb-dmov.Dte_01:SCREEN-VALUE = ?
                cb-dmov.CodRef:SCREEN-VALUE = "".

    /* RHC 14.08.06 Control de Orden de Compra */
/*ML01* Inhibe condición 25/02/08 ***
    ASSIGN 
        cb-dmov.OrdCmp:VISIBLE = NO
        cb-dmov.OrdCmp:SENSITIVE = NO
        cb-dmov.OrdCmp:SCREEN-VALUE = ''.
*ML01* ***/
    IF cb-ctas.PidAux = YES AND cb-ctas.PidDoc = YES 
        AND cb-ctas.ClfAux = '@PV' AND cb-ctas.CodCta BEGINS '60'
        AND NOT cb-ctas.CodCta BEGINS '609' 
        AND NOT cb-ctas.CodCta BEGINS '606101'
    THEN DO:
        ASSIGN 
            cb-dmov.OrdCmp:VISIBLE = YES               
            cb-dmov.OrdCmp:SENSITIVE = YES.
    END.
/*ML01* 25/02/08 ***/
    ELSE DO:
        ASSIGN 
            cb-dmov.OrdCmp:VISIBLE = NO
            cb-dmov.OrdCmp:SENSITIVE = NO
            cb-dmov.OrdCmp:SCREEN-VALUE = ''.
    END.

    /* RHC 31.01.2012 Gasto sustentado */
    IF cb-ctas.Sustento = YES THEN DO:
        ASSIGN
            cb-dmov.Log_01:VISIBLE = YES
            cb-dmov.Log_01:SENSITIVE = YES.
    END.
    ELSE DO:
        ASSIGN
            cb-dmov.Log_01:VISIBLE = NO
            cb-dmov.Log_01:SENSITIVE = NO.
    END.

    IF NEW cb-dmov THEN DO:
        IF cb-dmov.codaux:VISIBLE THEN
            DISPLAY old_codaux @ cb-dmov.codaux WITH FRAME {&FRAME-NAME}.
        IF cb-dmov.coddoc:VISIBLE THEN
            DISPLAY old_coddoc @ cb-dmov.coddoc WITH FRAME {&FRAME-NAME}.
        IF cb-dmov.nroruc:VISIBLE THEN
            DISPLAY old_nroruc @ cb-dmov.nroruc WITH FRAME {&FRAME-NAME}.
        IF cb-dmov.nrodoc:VISIBLE THEN
            DISPLAY old_nrodoc @ cb-dmov.nrodoc WITH FRAME {&FRAME-NAME}.
        IF cb-dmov.LOG_01:VISIBLE THEN cb-dmov.LOG_01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Yes' .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-DIALOG-1}
  GET FIRST DIALOG-1.
  DISPLAY x-NomCta FILL-IN-Cco FILL-IN-Discco 
      WITH FRAME DIALOG-1.
  IF AVAILABLE cb-dmov THEN 
    DISPLAY cb-dmov.CodCta cb-dmov.CodDiv cb-dmov.ClfAux cb-dmov.CodAux 
          cb-dmov.CCo cb-dmov.NroRuc cb-dmov.CodDoc cb-dmov.NroDoc 
          cb-dmov.C-FCaja cb-dmov.OrdCmp cb-dmov.GloDoc cb-dmov.TpoCmb 
          cb-dmov.TpoMov cb-dmov.ImpMn1 cb-dmov.CodRef cb-dmov.NroRef 
          cb-dmov.Dte_01 cb-dmov.ImpMn2 cb-dmov.FchDoc cb-dmov.TM cb-dmov.FchVto 
          cb-dmov.DisCco cb-dmov.Log_01 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 cb-dmov.CodCta cb-dmov.CodDiv cb-dmov.ClfAux cb-dmov.CodAux 
         cb-dmov.CCo cb-dmov.NroRuc cb-dmov.CodDoc cb-dmov.NroDoc 
         cb-dmov.OrdCmp cb-dmov.GloDoc cb-dmov.TpoMov cb-dmov.CodRef 
         cb-dmov.NroRef cb-dmov.Dte_01 cb-dmov.FchDoc cb-dmov.TM cb-dmov.FchVto 
         cb-dmov.DisCco cb-dmov.Log_01 b-aceptar b-cancelar 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

