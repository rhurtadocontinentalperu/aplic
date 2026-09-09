&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

    DEFINE STREAM report.
    DEFINE BUFFER B-Cuentas FOR cb-ctas.

    /* VARIABLES GENERALES :  IMPRESION,SISTEMA,MODULO,USUARIO */
    DEF NEW SHARED VAR input-var-1 AS CHAR.
    DEF NEW SHARED VAR input-var-2 AS CHAR.
    DEF NEW SHARED VAR input-var-3 AS CHAR.
    DEF NEW SHARED VAR output-var-1 AS ROWID.
    DEF NEW SHARED VAR output-var-2 AS CHAR.
    DEF NEW SHARED VAR output-var-3 AS CHAR.

    DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.
    DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,4,5".
    DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
    DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
    DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
    DEFINE        VARIABLE Ult-Nivel   AS INTEGER NO-UNDO.
    DEFINE        VARIABLE Max-Digitos AS INTEGER NO-UNDO.

    DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO.

    /*VARIABLES PARTICULARES DE LA RUTINA */
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(5)" NO-UNDO.
    DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(5)" NO-UNDO.
    DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(5)" NO-UNDO.
    DEFINE VARIABLE x-clfaux   LIKE cb-dmov.clfaux NO-UNDO.
    DEFINE VARIABLE x-codaux   LIKE cb-dmov.codaux NO-UNDO.
    DEFINE VARIABLE x-nroast   LIKE cb-dmov.nroast NO-UNDO.
    DEFINE VARIABLE x-codope   LIKE cb-dmov.codope NO-UNDO.
    DEFINE VARIABLE x-coddoc   LIKE cb-dmov.coddoc NO-UNDO.
    DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
    DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
    DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
    DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.

    DEFINE VARIABLE x-Cco      LIKE cb-dmov.Cco    NO-UNDO.

    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                               COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                               COLUMN-LABEL "e n t o s      !Abonos     " NO-UNDO.
    DEFINE VARIABLE x-saldoi   AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-"
                               COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.
    DEFINE VARIABLE x-saldof   AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-"
                               COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
    DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-"
                               COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
    DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                               COLUMN-LABEL "A c t u a l    !Acreedor   " NO-UNDO.
    DEFINE VARIABLE x-importe AS DECIMAL FORMAT "->>>>>>>,>>9.99" 
                               COLUMN-LABEL "Importe S/." NO-UNDO. 
    DEFINE VARIABLE c-debe     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE c-haber    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-debe     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-haber    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-saldoi   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-saldof   AS DECIMAL NO-UNDO.

    DEFINE VARIABLE x-conreg   AS INTEGER NO-UNDO.

    DEFINE VARIABLE v-Saldoi   AS DECIMAL   EXTENT 10 NO-UNDO.
    DEFINE VARIABLE v-Debe     AS DECIMAL   EXTENT 10 NO-UNDO.
    DEFINE VARIABLE v-Haber    AS DECIMAL   EXTENT 10 NO-UNDO.
    DEFINE VARIABLE v-CodCta   AS CHARACTER EXTENT 10 NO-UNDO.

    DEFINE SHARED VARIABLE s-NroMes    AS INTEGER.
    DEFINE SHARED VARIABLE s-periodo    AS INTEGER.
    DEFINE SHARED VARIABLE s-codcia AS INTEGER.
    DEFINE SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
    DEFINE SHARED VARIABLE x-DIRCIA AS CHARACTER FORMAT "X(40)".
    DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
    DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
    DEFINE SHARED VARIABLE pv-codcia AS INTEGER.

    DEFINE IMAGE IMAGE-1
         FILENAME "IMG/print"
         SIZE 5 BY 1.5.

    DEFINE FRAME F-Mensaje
         IMAGE-1 AT ROW 1.5 COL 5
         "Espere un momento" VIEW-AS TEXT
              SIZE 18 BY 1 AT ROW 1.5 COL 16
              font 4
         "por favor ...." VIEW-AS TEXT
              SIZE 10 BY 1 AT ROW 2.5 COL 19
              font 4
         "F10 = Cancela Reporte" VIEW-AS TEXT
              SIZE 21 BY 1 AT ROW 3.5 COL 12
              font 4          
         SPACE(10.28) SKIP(0.14)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
             BGCOLOR 15 FGCOLOR 0 
             TITLE "Imprimiendo ...".

    def var x-coddiv like cb-dmov.coddiv.

    def var x-codmon as integer init 1.
    def var x-clfaux-1 as char.
    def var x-clfaux-2 as char.

    DEF VAR G-NOMCTA AS CHAR FORMAT "X(60)".
    DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".
    DEFINE FRAME F-AUXILIAR
         X-MENSAJE
    WITH TITLE "Espere un momento por favor" VIEW-AS DIALOG-BOX CENTERED
              NO-LABELS.

    DEF VAR s-task-no AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS C-Moneda y-CodDiv C-Mes y-codope x-cta-ini ~
x-cta-fin x-Clasificacion x-auxiliar FILL-IN-Cco x-Impresora Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-Moneda y-CodDiv C-Mes y-codope x-cta-ini ~
x-cta-fin x-Clasificacion x-auxiliar FILL-IN-Cco x-Impresora 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 11 BY 1.62.

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "OK" 
     SIZE 11 BY 1.62.

DEFINE VARIABLE C-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","Dólares" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Cco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Costo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-auxiliar AS CHARACTER FORMAT "X(11)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Clasificacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clasificación" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-cta-fin AS CHARACTER FORMAT "X(10)":U INITIAL "10" 
     LABEL "Hasta la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-cta-ini AS CHARACTER FORMAT "X(10)":U INITIAL "10" 
     LABEL "Desde la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE y-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE y-codope AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-Impresora AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Impresora matricial", 1,
"Impresora Laser", 2
     SIZE 17 BY 2.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     C-Moneda AT ROW 1.19 COL 9 COLON-ALIGNED WIDGET-ID 28
     y-CodDiv AT ROW 1.19 COL 41 COLON-ALIGNED WIDGET-ID 40
     C-Mes AT ROW 1.96 COL 9 COLON-ALIGNED WIDGET-ID 26
     y-codope AT ROW 1.96 COL 41 COLON-ALIGNED WIDGET-ID 42
     x-cta-ini AT ROW 2.73 COL 41 COLON-ALIGNED WIDGET-ID 38
     x-cta-fin AT ROW 3.5 COL 41 COLON-ALIGNED WIDGET-ID 36
     x-Clasificacion AT ROW 4.27 COL 19 COLON-ALIGNED WIDGET-ID 34
     x-auxiliar AT ROW 4.27 COL 41 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-Cco AT ROW 5.04 COL 41 COLON-ALIGNED WIDGET-ID 30
     x-Impresora AT ROW 5.31 COL 4 NO-LABEL WIDGET-ID 44
     Btn_OK AT ROW 7.73 COL 4 WIDGET-ID 4
     Btn_Cancel AT ROW 7.73 COL 15 WIDGET-ID 2
     SPACE(39.13) SKIP(0.83)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Libro Caja y Bancos Mensual" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Libro Caja y Bancos Mensual */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    ASSIGN x-cta-ini 
           x-cta-fin
           x-auxiliar    
           c-mes
           y-CodOpe
           y-coddiv
           x-Clasificacion
           FILL-IN-Cco
           x-Impresora.

    IF x-cta-fin < x-cta-ini 
    THEN DO:
        BELL.
        MESSAGE "La cuenta fin es menor" SKIP
                "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-cta-ini.
        RETURN NO-APPLY.
    END.

    ASSIGN x-Cta-Fin = SUBSTR( x-Cta-Fin + "9999999999", 1, 10).

    RUN bin/_mes.p ( INPUT c-Mes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).

    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = "(EXPRESADO EN DOLARES)".
    END.

    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-moneda,  40 , OUTPUT x-moneda ).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    Ult-Nivel   = NUM-ENTRIES(cb-niveles).
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).

    RUN Imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Moneda gDialog
ON VALUE-CHANGED OF C-Moneda IN FRAME gDialog /* Moneda */
DO:
  
  x-codmon = lookup (self:screen-value,c-moneda:list-items).
  
                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Cco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Cco gDialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-Cco IN FRAME gDialog /* Centro de Costo */
OR F8 OF FILL-IN-Cco
DO:
  ASSIGN
    input-var-1 = 'CCO'
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/c-auxil ('Centro de Costos').
  IF output-var-1 <> ?
  THEN DO:
    FIND cb-auxi WHERE ROWID(cb-auxi) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi
    THEN DO:
        SELF:SCREEN-VALUE = cb-auxi.codaux.
        RETURN NO-APPLY.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-auxiliar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-auxiliar gDialog
ON LEFT-MOUSE-DBLCLICK OF x-auxiliar IN FRAME gDialog /* Auxiliar */
OR F8 OF x-auxiliar DO:

x-clfaux = "".
assign
  x-clfaux-1 = ""
  x-clfaux-2 = "".
  
find cb-ctas where cb-ctas.codcia = cb-codcia and
                   cb-ctas.codcta = x-cta-ini:screen-value
                   no-lock no-error.
                   
if avail cb-ctas then  x-clfaux-1 = cb-ctas.clfaux.
                      
find cb-ctas where cb-ctas.codcia = cb-codcia and
                   cb-ctas.codcta = x-cta-fin:screen-value
                   no-lock no-error.
if avail cb-ctas then  x-clfaux-2 = cb-ctas.clfaux.

if x-clfaux-1 = x-clfaux-2 then x-clfaux = x-clfaux-1.

if x-clfaux-1 <> "" and  x-clfaux-2  = "" then return no-apply.
if x-clfaux-1 =  "" and  x-clfaux-2 <> "" then return no-apply.


if x-clfaux = "" then return.
  

  
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  

    
    CASE X-CLFAUX :
    WHEN "@PV"  THEN DO:
        RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov
            THEN  SELF:SCREEN-VALUE  = gn-prov.CodPro.
        END.
    END.
    WHEN "@CL" THEN DO:
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).    
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie
            THEN SELF:SCREEN-VALUE  = gn-clie.codcli.
        END.
    END.
    WHEN "@CT" THEN DO:
            RUN cbd/q-ctas2.w(cb-codcia, "9", OUTPUT T-RECID).
            IF T-RECID <> ?
            THEN DO:
                find cb-ctas WHERE RECID(cb-ctas) = T-RECID NO-LOCK  NO-ERROR.
                IF avail cb-ctas
                THEN  self:screen-value = cb-ctas.CodCta.
            END.
  
    END.
    OTHERWISE DO:
        RUN CBD/H-AUXI01(s-codcia, X-ClfAux , OUTPUT T-ROWID ).     
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN self:screen-value = cb-auxi.CodAux.
        END.
    END.
    END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Clasificacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Clasificacion gDialog
ON MOUSE-SELECT-DBLCLICK OF x-Clasificacion IN FRAME gDialog /* Clasificación */
OR "F8" OF x-Clasificacion
DO:
   DEFINE VAR RECID-STACK AS RECID NO-UNDO.
   RUN cbd/q-clfaux.w("01", OUTPUT RECID-stack).
   IF RECID-stack <> 0 THEN DO:
      FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack NO-LOCK  NO-ERROR.
      IF AVAIL cb-tabl THEN x-Clasificacion:SCREEN-VALUE = cb-tabl.codigo.
      ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cta-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-fin gDialog
ON F8 OF x-cta-fin IN FRAME gDialog /* Hasta la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA-FIN DO:
   {ADM/H-CTAS01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cta-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-ini gDialog
ON F8 OF x-cta-ini IN FRAME gDialog /* Desde la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA-INI DO: 
   {ADM/H-CTAS01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-CodDiv gDialog
ON F8 OF y-CodDiv IN FRAME gDialog /* División */
DO: 
   {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-CodDiv gDialog
ON LEFT-MOUSE-DBLCLICK OF y-CodDiv IN FRAME gDialog /* División */
DO:
   {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-codope gDialog
ON F8 OF y-codope IN FRAME gDialog /* Operación */
DO:
   DEF VAR X AS RECID.
   RUN cbd/q-oper(cb-codcia,output X).
   FIND cb-oper WHERE RECID(cb-oper) = X
        NO-LOCK NO-ERROR.
   IF AVAILABLE cb-oper THEN DO:
        ASSIGN {&SELF-NAME} = cb-oper.CodOpe.
        DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
   END.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-codope gDialog
ON LEFT-MOUSE-DBLCLICK OF y-codope IN FRAME gDialog /* Operación */
DO:
   DEF VAR X AS RECID.
   RUN cbd/q-oper(cb-codcia,output X).
   FIND cb-oper WHERE RECID(cb-oper) = X
        NO-LOCK NO-ERROR.
   IF AVAILABLE cb-oper THEN DO:
        ASSIGN {&SELF-NAME} = cb-oper.CodOpe.
        DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
   END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal gDialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.
    DEF VAR x-Orden AS INT INIT 1.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.
    
    ASSIGN t-debe   = 0
           t-haber  = 0
           t-saldoi = 0
           t-saldof = 0
           con-ctas = 0 .

    DISPLAY "Seleccionando información solicitada" @ x-mensaje with frame f-auxiliar.
    PAUSE 0.

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND cb-ctas.ClfAux BEGINS x-Clasificacion
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        BREAK BY (cb-ctas.Codcta):
        x-CodCta = cb-ctas.CodCta.
        ASSIGN c-debe   = 0
               c-haber  = 0
               x-saldoi = 0 
               xi       = 0 
               No-tiene-mov = yes.
        IF y-codope   = "" AND y-coddiv   = "" AND x-auxiliar = "" 
        THEN /* SALDO INICIAL */
            FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                                       AND cb-dmov.periodo = s-periodo 
                                       AND cb-dmov.nromes  < c-mes
                                       AND cb-dmov.codcta  = x-CodCta :
                 CASE x-codmon :
                      when 1 then if (not cb-dmov.tpomov) 
                                  then x-saldoi = x-saldoi + cb-dmov.impmn1.
                                  else x-saldoi = x-saldoi - cb-dmov.impmn1.     
                      when 2 then if (not cb-dmov.tpomov) 
                                  then x-saldoi = x-saldoi + cb-dmov.impmn2.
                                  else x-saldoi = x-saldoi - cb-dmov.impmn2.     
                 END case.

            END.
        t-saldoi = t-saldoi + x-saldoi.
        ASSIGN x-nroast = x-codcta
               x-GloDoc = ""
               x-fchast = ""
               x-codope = ""
               x-fchDoc = ""
               x-nroDoc = ""
               x-fchVto = ""
               x-nroref = "".
        x-GloDoc = "S a l d o  I n i c i a l " .
        IF x-saldoi <> 0 THEN DO:
            xi = xi + 1.
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no 
                w-report.Llave-C = s-user-id 
                w-report.campo-c[1] = cb-ctas.codcta
                w-report.campo-c[2] = cb-ctas.nomcta
                w-report.campo-c[12] = x-glodoc
                w-report.campo-f[1] = x-saldoi
                w-report.llave-i = x-Orden.
            x-Orden = x-Orden + 1.
        END.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  = c-mes
            AND cb-dmov.codope BEGINS (y-codope)
            AND cb-dmov.codcta  = x-CodCta
            AND cb-dmov.clfaux  begins x-Clasificacion
            AND cb-dmov.codaux  begins x-auxiliar
            AND cb-dmov.coddiv  begins y-coddiv
            AND cb-dmov.cco     BEGINS FILL-IN-Cco
            BREAK BY cb-dmov.CodOpe BY cb-dmov.NroAst BY cb-dmov.NroItm:
            No-tiene-mov = no.
            IF xi = 0 THEN DO:
               xi = xi + 1.
            END.    
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                           AND cb-cmov.periodo = cb-dmov.periodo 
                           AND cb-cmov.nromes  = cb-dmov.nromes
                           AND cb-cmov.codope  = cb-dmov.codope
                           AND cb-cmov.nroast  = cb-dmov.nroast
                           NO-LOCK NO-ERROR.
             IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast).
             ASSIGN x-glodoc = cb-dmov.glodoc
                    x-NroAst = cb-dmov.NroAst
                    x-CodOpe = cb-dmov.CodOpe
                    x-codaux = cb-dmov.codaux
                    x-NroDoc = cb-dmov.NroDoc
                    x-NroRef = cb-dmov.NroRef
                    x-coddiv = cb-dmov.CodDiv
                    x-clfaux = cb-dmov.clfaux
                    x-coddoc = cb-dmov.coddoc
                    x-cco    = cb-dmov.cco.
             IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
             IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                        AND gn-clie.CodCia = cl-codcia
                                    NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN
                            x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                        AND gn-prov.CodCia = pv-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE gn-prov THEN 
                            x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        find b-cuentas WHERE b-cuentas.codcta = cb-dmov.codaux
                                        AND b-cuentas.CodCia = cb-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE b-cuentas THEN x-glodoc = b-cuentas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                        AND cb-auxi.codaux = cb-dmov.codaux
                                        AND cb-auxi.CodCia = cb-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN 
                            x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = ImpMn1.
                        x-haber = 0.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = ImpMn2.
                        x-haber = 0.
                    END.
                END CASE.
            END.
            ELSE DO:
                x-importe = ImpMn1 * -1. 
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn1.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn2.
                    END.
                END CASE.            
            END.
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                x-fchdoc = STRING(cb-dmov.fchdoc).  
                x-fchvto = STRING(cb-dmov.fchvto).
                t-Debe  = t-Debe  + x-Debe.
                t-Haber = t-Haber + x-Haber.
                c-Debe  = c-Debe  + x-Debe.
                c-Haber = c-Haber + x-Haber.
                CREATE w-report.
                ASSIGN
                    w-report.task-no = s-task-no 
                    w-report.Llave-C = s-user-id 
                    w-report.campo-c[1] = cb-ctas.codcta
                    w-report.campo-c[2] = cb-ctas.nomcta
                    w-report.campo-c[3] = x-coddiv
                    w-report.campo-c[4] = x-cco
                    w-report.campo-c[20] = (IF x-fchast <> ? THEN x-fchast ELSE "")
                    w-report.campo-c[5] = x-nroast
                    w-report.campo-c[6] = x-codope
                    w-report.campo-c[7] = x-clfaux
                    w-report.campo-c[8] = x-codaux
                    w-report.campo-c[21] = (IF x-fchdoc <> ? THEN x-fchdoc ELSE "")
                    w-report.campo-c[9] = x-coddoc
                    w-report.campo-c[10] = x-nrodoc
                    w-report.campo-c[22] = (IF x-fchvto <> ? THEN x-fchvto ELSE "")
                    w-report.campo-c[11] = x-nroref
                    w-report.campo-c[12] = x-glodoc
                    w-report.llave-i = x-Orden.
                x-Orden = x-Orden + 1.
                IF x-debe <> 0 THEN DO:
                    w-report.campo-f[1] = x-debe.
                END.
                IF x-haber <> 0 THEN DO:
                    w-report.campo-f[2] = x-haber.
                END.
                IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                    w-report.campo-f[3] = x-importe.
                END.
                x-conreg = x-conreg + 1.
            END.            
        END.
        IF no-tiene-mov THEN NEXT.
        con-ctas = con-ctas + 1 .
    END.
    HIDE FRAME f-auxiliar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY C-Moneda y-CodDiv C-Mes y-codope x-cta-ini x-cta-fin x-Clasificacion 
          x-auxiliar FILL-IN-Cco x-Impresora 
      WITH FRAME gDialog.
  ENABLE C-Moneda y-CodDiv C-Mes y-codope x-cta-ini x-cta-fin x-Clasificacion 
         x-auxiliar FILL-IN-Cco x-Impresora Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel gDialog 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "L I B R O   M A Y O R    G E N E R A L".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = pinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-expres.
    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Division".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "C. Costo".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Asiento".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Comprobante".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Libro".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Clf. Aux.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Aux.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Doc.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Refer.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Detalle".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cargos".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Abonos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Final".
    iCount = iCount + 1.

    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.

    ASSIGN t-debe   = 0
           t-haber  = 0
           t-saldoi = 0
           t-saldof = 0
           con-ctas = 0 .

    DISPLAY "Seleccionando información solicitada" @ x-mensaje with frame f-auxiliar.
    PAUSE 0.

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND cb-ctas.ClfAux BEGINS x-Clasificacion
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        BREAK BY (cb-ctas.Codcta)
        ON ERROR UNDO, LEAVE:

        x-CodCta = cb-ctas.CodCta.
        ASSIGN c-debe   = 0
               c-haber  = 0
               x-saldoi = 0 
               xi       = 0 
               No-tiene-mov = yes.

        IF y-codope   = "" AND y-coddiv   = "" AND x-auxiliar = "" 
        THEN /* SALDO INICIAL */
            FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                                       AND cb-dmov.periodo = s-periodo 
                                       AND cb-dmov.nromes  < c-mes
                                       AND cb-dmov.codcta  = x-CodCta :
                 CASE x-codmon :
                      when 1 then if (not cb-dmov.tpomov) 
                                  then x-saldoi = x-saldoi + cb-dmov.impmn1.
                                  else x-saldoi = x-saldoi - cb-dmov.impmn1.     
                      when 2 then if (not cb-dmov.tpomov) 
                                  then x-saldoi = x-saldoi + cb-dmov.impmn2.
                                  else x-saldoi = x-saldoi - cb-dmov.impmn2.     
                 END case.

            END.
        t-saldoi = t-saldoi + x-saldoi.
        ASSIGN x-nroast = x-codcta
               x-GloDoc = ""
               x-fchast = ""
               x-codope = ""
               x-fchDoc = ""
               x-nroDoc = ""
               x-fchVto = ""
               x-nroref = "".
        x-GloDoc = "S a l d o  I n i c i a l " .
        IF x-saldoi <> 0 THEN DO:
            xi = xi + 1.
            G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = G-NOMCTA.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = x-fchast.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nroast.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = x-codope.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = x-fchdoc.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nrodoc.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nroref.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = x-glodoc.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = x-saldoi.
            iCount = iCount + 1.
        END.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  = c-mes
            AND cb-dmov.codope BEGINS (y-codope)
            AND cb-dmov.codcta  = x-CodCta
            AND cb-dmov.clfaux  begins x-Clasificacion
            AND cb-dmov.codaux  begins x-auxiliar
            AND cb-dmov.coddiv  begins y-coddiv
            AND cb-dmov.cco     BEGINS FILL-IN-Cco
            BREAK BY cb-dmov.CodOpe BY cb-dmov.NroAst BY cb-dmov.NroItm:

            No-tiene-mov = no.

            IF xi = 0 THEN DO:
               xi = xi + 1.
               G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
               cColumn = STRING(iCount).
               cRange = "A" + cColumn.
               chWorkSheet:Range(cRange):Value = G-NOMCTA.
               iCount = iCount + 1.
            END.    

            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                           AND cb-cmov.periodo = cb-dmov.periodo 
                           AND cb-cmov.nromes  = cb-dmov.nromes
                           AND cb-cmov.codope  = cb-dmov.codope
                           AND cb-cmov.nroast  = cb-dmov.nroast
                           NO-LOCK NO-ERROR.
             IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast).
             ASSIGN x-glodoc = cb-dmov.glodoc
                    x-NroAst = cb-dmov.NroAst
                    x-CodOpe = cb-dmov.CodOpe
                    x-codaux = cb-dmov.codaux
                    x-NroDoc = cb-dmov.NroDoc
                    x-NroRef = cb-dmov.NroRef
                    x-coddiv = cb-dmov.CodDiv
                    x-clfaux = cb-dmov.clfaux
                    x-coddoc = cb-dmov.coddoc
                    x-cco    = cb-dmov.cco.

             IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
             IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                        AND gn-clie.CodCia = cl-codcia
                                    NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN
                            x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                        AND gn-prov.CodCia = pv-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE gn-prov THEN 
                            x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        find b-cuentas WHERE b-cuentas.codcta = cb-dmov.codaux
                                        AND b-cuentas.CodCia = cb-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE b-cuentas THEN x-glodoc = b-cuentas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                        AND cb-auxi.codaux = cb-dmov.codaux
                                        AND cb-auxi.CodCia = cb-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN 
                            x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = ImpMn1.
                        x-haber = 0.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = ImpMn2.
                        x-haber = 0.
                    END.
                END CASE.
            END.
            ELSE DO:
                x-importe = ImpMn1 * -1. 
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn1.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn2.
                    END.
                END CASE.            
            END.
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                x-fchdoc = STRING(cb-dmov.fchdoc).  
                x-fchvto = STRING(cb-dmov.fchvto).
                t-Debe  = t-Debe  + x-Debe.
                t-Haber = t-Haber + x-Haber.
                c-Debe  = c-Debe  + x-Debe.
                c-Haber = c-Haber + x-Haber.
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = x-coddiv.
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = x-cco.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = (IF x-fchast <> ? THEN x-fchast ELSE "").
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroast.
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = x-codope.
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = x-clfaux.
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = x-codaux.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = (IF x-fchdoc <> ? THEN x-fchdoc ELSE "").
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = x-coddoc.
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nrodoc.
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroref.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                IF x-debe <> 0 THEN DO:
                    cRange = "M" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-debe.
                END.
                IF x-haber <> 0 THEN DO:
                    cRange = "N" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-haber.
                END.
                IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                    cRange = "O" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-importe.
                END.
                iCount = iCount + 1.                                                                                                         
                x-conreg = x-conreg + 1.
            END.            
        END.

        IF no-tiene-mov THEN NEXT.

        ASSIGN x-Debe   = c-Debe
               x-Haber  = c-Haber
               x-SaldoF = x-SaldoI + x-Debe - x-Haber
               x-nroast = x-codcta
               x-fchast = ""
               x-codope = ""
               x-fchDoc = ""
               x-nroDoc = "TOTAL"
               x-nroref = x-CodCta
               x-GloDoc = cb-ctas.NomCta.
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = x-nroref.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = x-glodoc.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = x-debe.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = x-haber.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = x-saldof.
        iCount = iCount + 1.
        con-ctas = con-ctas + 1 .
    END.
    HIDE FRAME f-auxiliar.
    ASSIGN x-saldoi = t-saldoi
           x-Debe   = t-Debe
           x-Haber  = t-Haber
           x-SaldoF = t-SaldoI + x-Debe - x-Haber
           x-nroast = x-codcta
           x-fchast = ""
           x-codope = ""
           x-fchDoc = ""
           x-nroDoc = ""
           x-fchVto = ""
           x-nroref = ""
           x-GloDoc = "T O T A L   G E N E R A L ".

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = x-nroref.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = x-glodoc.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = x-debe.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = x-haber.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = x-saldof.
    iCount = iCount + 1.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR gDialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.
    
RUN Carga-Temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "CBD\RBCBD.PRL"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + 
                                "~npinta-mes = " + pinta-mes +
                                "~nx-expres = " + x-expres.
    IF x-Impresora = 1 
    THEN RB-REPORT-NAME = "Libro Caja Banco Draft-B".
    ELSE RB-REPORT-NAME = "Libro Caja Banco Laser".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id:
        DELETE w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  assign c-mes = s-nromes.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

