&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

DEFINE NEW SHARED VARIABLE x-Nomope LIKE cb-oper.NomOpe.

DEF SHARED VAR s-codcia  AS INT.
/* DEF SHARED VAR s-CodDiv  AS CHAR. */
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes  AS INT.
DEF SHARED VAR s-user-id AS CHARACTER.
DEF SHARED VAR cb-codcia AS INT.

DEFINE SHARED VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE chnomctas LIKE cb-ctas.Nomcta.


DEFINE VARIABLE x-opcion AS INTEGER NO-UNDO.
DEFINE VARIABLE empresa  AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE division AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE state    AS INTEGER NO-UNDO.
DEFINE VARIABLE mon      AS CHARACTER.

DEFINE NEW SHARED VARIABLE x-codope LIKE cb-oper.CodOpe INIT '000'.
DEFINE VARIABLE p-tipo-egreso  AS CHAR  INITIAL "".
IF p-tipo-egreso = "" THEN DO :
   FOR EACH cb-oper NO-LOCK WHERE cb-oper.CodCia = cb-CodCia AND
                            cb-oper.Resume = TRUE AND 
                            (cb-oper.TipMov = "E" OR cb-oper.TipMov = "") :
       P-TIPO-EGRESO = P-TIPO-EGRESO + cb-oper.CodOpe + ",".                             
   END. 
   P-TIPO-EGRESO = SUBSTRING(P-TIPO-EGRESO, 1, LENGTH(P-TIPO-EGRESO) - 1 ).
END.

p-tipo-egreso = "002".
/*X-CODOPE    = ENTRY(1,P-TIPO-EGRESO).*/

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF AVAIL Empresas THEN empresa = Empresas.NomCia.

FIND cb-oper WHERE cb-oper.CodCia = cb-codcia
                   AND cb-oper.CodOpe = x-codope
                   NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper THEN DO:
    MESSAGE "No Configurado la Operaci¢n" + x-codope 
             VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.  
x-NomOpe = integral.cb-oper.Nomope.

DEFINE var X-PAG AS CHAR FORMAT "999". 
DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-impletra AS CHARACTER FORMAT "X(100)".
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
DEFINE VARIABLE x-con-reg  AS INTEGER.

/**FRAME F-FOOTER*/
DEF VAR X-IMPRESO AS CHAR FORMAT "X(35)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/99").

/* DEFINE FRAME F-footer                                                                                      */
/*     HEADER                                                                                                 */
/*     SKIP(2)                                                                                                */
/*     "SON : " AT 1 x-impletra SKIP                                                                          */
/*     "-----------------       -----------------        ----------------- "  AT 25 SKIP                      */
/*     "     " AT 25 s-user-id "            REVISADO              Vo.Bo.Gerencia          Impreso:" x-impreso */
/*     WITH WIDTH 155 NO-BOX STREAM-IO DOWN.                                                                  */
/*                                                                                                            */

/*IMPRESION DE CHQUES*/

DEFINE VARIABLE x-pos       AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-nota1     AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-nota2     AS CHARACTER NO-UNDO.
DEFINE VARIABLE s-task-no   AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-EnLetras  AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE x-girador   AS CHARACTER FORMAT "x(50)" NO-UNDO.

/*PROCESO*/
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     /*IMAGE-1 AT ROW 1.5 COL 5*/
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Cargando...".




/*
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
         TITLE "Procesando ..." FONT 7.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 x-Periodo x-NroMes x-operacion ~
x-Desde x-Hasta x-opciones x-Estado Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-NroMes x-operacion x-oper ~
x-Desde x-Hasta x-opciones x-Estado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "Img/b-cancel.bmp":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "O:/OpenEdge/on_in_co/IMG/b-ok.bmp":U
     LABEL "Aceptar" 
     SIZE 11.43 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE x-NroMes AS CHARACTER FORMAT "X(2)":U INITIAL "1" 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero","01",
                     "Febrero","02",
                     "Marzo","03",
                     "Abril","04",
                     "Mayo","05",
                     "Junio","06",
                     "Julio","07",
                     "Agosto","08",
                     "Setiembre","09",
                     "Octubre","10",
                     "Noviembre","11",
                     "Diciembre","12"
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE x-operacion AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "x(4)":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-Desde AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde Nro Asiento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Hasta AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-oper AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Estado AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activos", 1,
"Anulados", 2,
"Todos", 3
     SIZE 12 BY 2.42 NO-UNDO.

DEFINE VARIABLE x-opciones AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todas las cuentas", 1,
"Todas las cuentas ordenados por cuenta", 2
     SIZE 31 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66.43 BY 2.15
     BGCOLOR 7 FGCOLOR 14 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-Periodo AT ROW 1.19 COL 18 COLON-ALIGNED
     x-NroMes AT ROW 1.19 COL 36 COLON-ALIGNED
     x-operacion AT ROW 2.08 COL 18 COLON-ALIGNED WIDGET-ID 18
     x-oper AT ROW 2.08 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     x-Desde AT ROW 2.96 COL 18 COLON-ALIGNED WIDGET-ID 14
     x-Hasta AT ROW 3 COL 36 COLON-ALIGNED WIDGET-ID 16
     x-opciones AT ROW 4.19 COL 8 NO-LABEL WIDGET-ID 6
     x-Estado AT ROW 4.19 COL 48.57 NO-LABEL
     Btn_OK AT ROW 7.19 COL 44
     Btn_Cancel AT ROW 7.19 COL 56
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.35 COL 42
     "Tipo:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 4.35 COL 4 WIDGET-ID 10
     RECT-3 AT ROW 6.92 COL 1 WIDGET-ID 12
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "REPORTE DE VOUCHERS"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-oper IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* REPORTE DE VOUCHERS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  
  x-codope = x-operacion:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  x-opcion = INTEGER(X-OPCIONES:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  state = INTEGER(x-Estado:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  
  IF x-codope = ? THEN DO:
      MESSAGE "Seleccione Operación" VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
  END.
  ELSE DO:
      FIND Cb-Oper WHERE cb-oper.CodCia = cb-codcia 
          AND cb-oper.Codope = x-codope NO-LOCK NO-ERROR.
      IF AVAILABLE Cb-Oper THEN ASSIGN x-NomOpe = cb-oper.Nomope .
  END.

  ASSIGN
    x-Estado x-NroMes x-Periodo x-Desde x-Hasta x-operacion.
  
  IF x-Desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
      ASSIGN x-Desde = string(x-NroMes) + '0000'.
  END.
  
  IF x-Hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
      ASSIGN x-Hasta = string(x-NroMes) + '9999'.
  END.
 
  RUN Imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-operacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-operacion D-Dialog
ON VALUE-CHANGED OF x-operacion IN FRAME D-Dialog /* Operación */
DO:
  FOR EACH Cb-Oper WHERE Cb-Oper.CodCia = cb-CodCia AND
      cb-oper.Codope = x-operacion:SCREEN-VALUE:
      DISPLAY cb-oper.Nomope @ x-oper WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal1 D-Dialog 
PROCEDURE Carga-Temporal1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER F-CUENTAS AS INTEGER.
DEFINE FRAME f-det
    cb-dmov.coddiv COLUMN-LABEL "Division"
    cb-dmov.codcta COLUMN-LABEL "Cuenta"
    cb-dmov.clfaux COLUMN-LABEL "Clf!Aux"
    cb-dmov.codaux COLUMN-LABEL "Auxiliar"
    cb-dmov.nroref COLUMN-LABEL "Referencia"
    cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
    cb-dmov.nrodoc COLUMN-LABEL "Nro!Documento"
    cb-dmov.fchdoc COLUMN-LABEL "Fecha!Doc"
    x-glodoc       COLUMN-LABEL "Detalle"
    x-debe         COLUMN-LABEL "Cargos"
    x-haber        COLUMN-LABEL "Abonos"
    WITH WIDTH 190 NO-BOX STREAM-IO DOWN.

DEFINE FRAME f-cabe
    HEADER
    SKIP(1)
    empresa    
    x-NomOpe AT 65   
    "FECHA     : " AT 100 cb-cmov.fchast SKIP
    "VOUCHER No: " AT 60  cb-cmov.codope "-" cb-cmov.nroast SKIP
    "DIVISION  : " AT 1 cb-cmov.coddiv " " division
    "T.CAMBIO  : " AT 100 cb-cmov.tpocmb FORMAT "ZZZ9.9999" SKIP 
    "CUENTA    : " AT 1 chnomctas SKIP
    "DOCUMENTO : " AT 1 cb-cmov.coddoc cb-cmov.nrochq 
    "IMPORTE   : " AT 100 mon cb-cmov.impchq FORMAT "**********9.99" SKIP
    "PAGADO A  : " cb-cmov.girado SKIP
    "CONCEPTO  : " cb-cmov.notast
    "----------------------------------------------------------------------------------------------------------------------------------------------------"
    WITH WIDTH 190 NO-BOX STREAM-IO.

FOR EACH cb-cmov WHERE cb-cmov.CodCia = s-CodCia 
    AND cb-cmov.periodo =  INTEGER(x-periodo)
    AND cb-cmov.nromes  =  INTEGER(x-NroMes)
    AND cb-cmov.codope  =  x-codope AND
    ((cb-cmov.FlgEst EQ "" AND state = 1) OR
    (cb-cmov.FlgEst EQ "A" AND state = 2) OR 
    (state EQ 3))
    AND cb-cmov.nroast  >= x-Desde
    AND cb-cmov.nroast  <= x-Hasta NO-LOCK,
    EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-cmov.CodCia
    AND cb-dmov.periodo =  cb-cmov.periodo
    AND cb-dmov.nromes  =  cb-cmov.nromes
    AND cb-dmov.codope  =  cb-cmov.codope
    AND cb-dmov.nroast  =  cb-cmov.nroast
    BREAK BY (cb-dmov.nroast) ON ERROR UNDO, LEAVE: 
    IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
    x-glodoc = glodoc.
    IF x-glodoc = "" THEN DO:
        CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                    AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                    AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                FIND cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                    AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                    AND cb-auxi.codaux = cb-dmov.codaux
                    AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
            END.
        END CASE.
    END. /* IF x-glodoc = ""... */
    IF x-glodoc = "" THEN DO:
        IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
    END.
    CASE x-codmon:
        WHEN 2 THEN DO:
            SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
        END.
    END CASE.
    IF cb-dmov.tpomov THEN DO:
        x-debe  = 0.
        x-haber = ImpMn1.
    END.
    ELSE DO:
        x-debe  = ImpMn1.
        x-haber = 0.
    END.

    IF cb-cmov.CodMon = 1 THEN mon = 'S/. '. ELSE mon = '$. '.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
         AND cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN ASSIGN chnomctas = cb-ctas.nomcta. ELSE chnomctas = "".
    IF cb-cmov.FlgEst = 'A' THEN VIEW STREAM Report FRAME f-cabe.
    
    IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
        ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
        ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
        IF LINE-COUNTER(report) + 3 > PAGE-SIZE(report) THEN DO:
            X-PAG =  STRING(PAGE-NUMBER(report),"999").
            UNDERLINE STREAM report
                cb-dmov.coddiv
                cb-dmov.codcta
                x-glodoc
                x-debe
                x-haber
                WITH FRAME f-det.    
            DOWN STREAM report with frame f-det.
            DISPLAY STREAM report
                "PAG."              @ cb-dmov.coddiv
                X-PAG               @ cb-dmov.codcta
                "    .....Van.... " @ x-glodoc
                ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-det.
            X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").
            DOWN STREAM report with frame f-det.
            PAGE stream report.
            DISPLAY STREAM report
                "PAG."              @ cb-dmov.coddiv
                X-PAG               @ cb-dmov.codcta
                "    .....Vienen.... " @ x-glodoc
                ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-det.    
            DOWN STREAM report with frame f-det.
            UNDERLINE STREAM report
                cb-dmov.coddiv
                cb-dmov.codcta
                x-glodoc
                x-debe 
                x-haber
                WITH FRAME f-det.    
            DOWN STREAM report with frame f-det.
        END. 
        RUN bin/_numero.p ( cb-cmov.impchq,2,1, OUTPUT x-impletra ).
        IF cb-cmov.codmon = 1 THEN x-impletra = x-impletra + "----NUEVOS SOLES".
        ELSE x-impletra = x-impletra + "----DOLARES AMERICANOS".
        FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = cb-cmov.coddiv.
        IF AVAIL gn-divi THEN division = GN-DIVI.DesDiv. ELSE division = "".

        IF FIRST-OF (cb-dmov.nroast) THEN VIEW STREAM Report FRAME f-cabe.  /*Frame Cabecera*/
        
        DISPLAY STREAM report
            cb-dmov.coddiv
            cb-dmov.codcta
            cb-dmov.clfaux
            cb-dmov.codaux
            cb-dmov.nroref
            cb-dmov.coddoc
            cb-dmov.nrodoc
            cb-dmov.fchdoc
            x-glodoc
            x-debe   WHEN (x-debe  <> 0)
            x-haber  WHEN (x-haber <> 0) 
            WITH FRAME f-det.
        DISPLAY
            cb-cmov.nroast @ FI-MENSAJE LABEL " No.Asiento"
            WITH FRAME F-PROCESO.

    END.
    IF LAST-OF(cb-dmov.nroast) THEN DO: 
        x-glodoc = "                    TOTALES :".
        IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
        THEN PAGE stream report.
        DOWN STREAM report 1 WITH FRAME f-det.
        UNDERLINE STREAM report 
            x-glodoc
            x-debe 
            x-haber
            WITH FRAME f-det.                                      
        DOWN STREAM report with frame f-det.
        DISPLAY STREAM report 
            x-glodoc
            ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
            ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
            WITH FRAME f-det.   
        /* Muestra el monto total el texto*/
        DEFINE FRAME F-Monto
            HEADER
            "SON : " AT 1 x-impletra
            WITH WIDTH 150 NO-BOX STREAM-IO DOWN.
        VIEW STREAM report FRAME f-Monto.
        DO WHILE LINE-COUNTER(report) < 28 :
            DOWN STREAM report 1 WITH FRAME f-monto.
        END. 
        /*FOOTER*/                        
        DEFINE FRAME F-footer
            HEADER
            "-----------------       -----------------        ----------------- "  AT 25 SKIP
            "    " AT 25 cb-cmov.Usuario "            REVISADO              Vo.Bo.Gerencia          Impreso :" x-impreso
            WITH WIDTH 190 NO-BOX STREAM-IO DOWN.
        VIEW STREAM report FRAME f-Footer.
        PAGE STREAM Report.                                                                     
    END. /* IF LAST-OF(cb-dmov.nroast)... */
END. /*fin del for each principal*/

HIDE FRAME f-proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 D-Dialog 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER F-CUENTAS AS INTEGER.
    /* 1 TODAS LAS CUENTAS
       2 OMITIR AUTOMATICAS 
    */   

DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Division"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux LABEL "Auxiliar"
        cb-dmov.nroref LABEL "Provision"
        cb-dmov.coddoc LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 190 NO-BOX STREAM-IO DOWN.

  DEFINE FRAME f-cabe
        HEADER
        SKIP(1)
        empresa    
        x-nomope AT 65
        "FECHA     : " AT 115 cb-cmov.fchast   SKIP
        "VOUCHER No: " AT 60  cb-cmov.codope "-" cb-cmov.nroast SKIP
        "DIVISION  : " AT 1 cb-cmov.coddiv " " division
        "T.CAMBIO  : " AT 115 cb-cmov.tpocmb FORMAT "ZZZ9.9999" SKIP
        "CUENTA    : " AT 1 chnomctas SKIP
        "DOCUMENTO : " AT 1 cb-cmov.coddoc cb-cmov.nrochq 
        "Importe   : " AT 115 mon cb-cmov.impchq  FORMAT "**********9.99" SKIP
        "PAGADO A  : " cb-cmov.girado SKIP
        "CONCEPTO  : " cb-cmov.notast SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------"
        WITH WIDTH 190 NO-BOX STREAM-IO.
        
 FOR EACH cb-cmov WHERE cb-cmov.CodCia = s-CodCia 
       AND cb-cmov.periodo =  INTEGER(x-periodo)
       AND cb-cmov.nromes  =  INTEGER(x-NroMes)
       AND cb-cmov.codope  =  x-codope AND
       ((cb-cmov.FlgEst EQ "" AND state = 1) OR
        (cb-cmov.FlgEst EQ "A" AND state = 2) OR 
        (state EQ 3))
       AND cb-cmov.nroast  >= x-Desde
       AND cb-cmov.nroast  <= x-Hasta NO-LOCK,
       EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-cmov.CodCia
                    AND cb-dmov.periodo =  cb-cmov.periodo
                    AND cb-dmov.nromes  =  cb-cmov.nromes
                    AND cb-dmov.codope  =  cb-cmov.codope
                    AND cb-dmov.nroast  =  cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) 
        BY cb-dmov.codcta
        ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN DO:
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                        AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                        AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                        AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                   IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                        AND cb-auxi.codaux = cb-dmov.codaux
                        AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                    IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
                END.
            END CASE. /*CASE cb-dmov.clfaux....*/
        END. /* IF x-glodoc = "" ....*/
        IF x-glodoc = "" THEN DO:
            IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
        END.
        CASE x-codmon:
            WHEN 2 THEN DO:
                SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
            END.
        END CASE.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        ELSE DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.

        IF cb-cmov.CodMon = 1 THEN mon = 'S/. '. ELSE mon = '$. '.
        FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
            AND cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
        IF AVAILABLE cb-ctas THEN ASSIGN chnomctas = cb-ctas.nomcta. ELSE chnomctas = "".
        IF cb-cmov.FlgEst = 'A' THEN VIEW STREAM Report FRAME f-cabe.

        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF LINE-COUNTER(report)  + 5 > PAGE-SIZE(report) THEN DO :
                X-PAG =  STRING(PAGE-NUMBER(report),"999").
                UNDERLINE STREAM report 
                    cb-dmov.coddiv
                    cb-dmov.codcta
                    x-glodoc
                    x-debe 
                    x-haber
                WITH FRAME f-cab.    
                DOWN STREAM report with frame f-cab.
                
                DISPLAY STREAM report 
                    "PAG."              @ cb-dmov.coddiv
                    X-PAG               @ cb-dmov.codcta
                    "    .....Van.... " @ x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.    
                X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").  
                DOWN STREAM report with frame f-cab.
                PAGE stream report.
                
                DISPLAY STREAM report 
                    "PAG."              @ cb-dmov.coddiv
                    X-PAG               @ cb-dmov.codcta
                    "    .....Vienen.... " @ x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.    
                DOWN STREAM report with frame f-cab.
                UNDERLINE STREAM report 
                    cb-dmov.coddiv
                    cb-dmov.codcta
                    x-glodoc
                    x-debe 
                    x-haber
                WITH FRAME f-cab.    
                DOWN STREAM report with frame f-cab.                                          
            END. /*IF LINE-COUNTER(report) ...*/ 

            RUN bin/_numero.p ( cb-cmov.impchq,2,1, OUTPUT x-impletra ).
            IF cb-cmov.codmon = 1 THEN x-impletra = x-impletra + "----NUEVOS SOLES". ELSE x-impletra = x-impletra + "----DOLARES AMERICANOS".

            FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = cb-cmov.coddiv . 
            IF AVAIL gn-divi THEN division = GN-DIVI.DesDiv. ELSE division = "". 

            IF FIRST-OF (cb-dmov.nroast) THEN VIEW STREAM Report FRAME f-cabe. /*Frame Header*/
            
            DISPLAY STREAM report 
                cb-dmov.coddiv
                cb-dmov.codcta
                cb-dmov.clfaux
                cb-dmov.codaux
                cb-dmov.nroref
                cb-dmov.coddoc
                cb-dmov.nrodoc
                cb-dmov.fchdoc
                x-glodoc
                x-debe   WHEN (x-debe  <> 0)
                x-haber  WHEN (x-haber <> 0) 
            WITH FRAME f-cab.
            DISPLAY
              cb-cmov.nroast @ FI-MENSAJE LABEL " No.Asiento"
            WITH FRAME F-PROCESO.
        END. /*IF NOT (x-haber = 0 AND x-debe = 0) ......*/
        IF LAST-OF(cb-dmov.nroast) THEN DO:
            x-glodoc = "                    TOTALES :".
            IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
            THEN PAGE stream report.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report 
                 x-glodoc
                 x-debe 
                 x-haber
            WITH FRAME f-cab. 
            DOWN STREAM report with frame f-cab.
            DISPLAY STREAM report 
                x-glodoc
                ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.   
                
            /* Muestra el monto total el texto*/
            DEFINE FRAME F-Monto
                   HEADER
                   "SON : " AT 1 x-impletra
            WITH WIDTH 150 NO-BOX STREAM-IO DOWN.                 
            VIEW STREAM report FRAME f-Monto.
            DOWN STREAM report with frame f-cab.

            DO WHILE LINE-COUNTER(report) < 28 :
               DOWN STREAM report 1 WITH FRAME f-monto.
            END. 
            
            /*FOOTER*/
            DEFINE FRAME F-footer
                HEADER
                "-----------------       -----------------        ----------------- "  AT 25 SKIP
                "    " AT 25 cb-cmov.Usuario "            REVISADO              Vo.Bo.Gerencia          Impreso :" x-impreso
                WITH WIDTH 190 NO-BOX STREAM-IO DOWN.
                VIEW STREAM report FRAME f-Footer.
                DOWN STREAM report with frame f-Monto.
                PAGE STREAM Report.     
        END. /*IF LAST-OF(cb-dmov.nroast) .....*/
 END. /*Fin del For Each Principal*/
 HIDE FRAME f-proceso.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY x-Periodo x-NroMes x-operacion x-oper x-Desde x-Hasta x-opciones 
          x-Estado 
      WITH FRAME D-Dialog.
  ENABLE RECT-3 x-Periodo x-NroMes x-operacion x-Desde x-Hasta x-opciones 
         x-Estado Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 31.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 31. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(33) + {&Prn4}.
        /*PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .*/

        CASE x-opcion:
            WHEN 1 THEN RUN Carga-Temporal1(1).
            WHEN 2 THEN RUN Carga-Temporal2(1).
            WHEN 3 THEN RUN Carga-Temporal3.
        END CASE.

        /*RUN Formato.*/
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Cb-Peri NO-LOCK WHERE Cb-Peri.codcia = s-codcia:
        x-Periodo:ADD-LAST(STRING(Cb-Peri.Periodo, '9999')).
    END.
    FOR EACH Cb-Oper WHERE Cb-Oper.CodCia = cb-CodCia:
        x-operacion:ADD-LAST(STRING(Cb-Oper.CodOpe, '999')).
    END.

    ASSIGN
        x-operacion = ENTRY(1,x-operacion:LIST-ITEMS)
        x-Periodo = STRING(s-Periodo, '9999')
        x-NroMes = STRING(s-NroMes,'99').
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   
  DISPLAY x-NomOpe @ x-oper WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

