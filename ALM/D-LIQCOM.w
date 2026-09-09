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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/*
    @PRINTER2.W    VERSION 1.0
*/

{lib/def-prn.i}    
DEFINE STREAM REPORT.

/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.
DEFINE        VARIABLE L-FIN      AS LOGICAL.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/*** DEFINE VARIABLES SUB-TOTALES ***/

DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.

DEFINE VAR S-Procedencia AS CHAR FORMAT "X(55)" INIT "".
DEFINE VAR S-Moneda      AS CHAR FORMAT "X(32)"  INIT "".
DEFINE VAR S-Mon         AS CHAR FORMAT "X(4)"  INIT "".
DEFINE VAR S-Referencia1 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia2 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia3 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Encargado   AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-RUC         AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Movimiento  LIKE Almtmovm.Desmov INIT "".
DEFINE VAR S-TOTAL       AS DECIMAL INIT 0.
DEFINE VAR S-SUBTO       AS DECIMAL INIT 0.
DEFINE VAR S-Item        AS INTEGER INIT 0.
DEFINE VAR W-VTA0        AS DECIMAL INIT 0.
DEFINE VAR W-VTA1        AS DECIMAL INIT 0.
DEFINE VAR W-VTA2        AS DECIMAL INIT 0.
DEFINE VAR X-COMPRA      AS INTEGER INIT 02.
DEFINE VAR C-TIPMOV      AS CHAR     INIT "I" .
DEFIN  VAR X-TIPO        AS DECI     INIT 0.
DEFINE VAR X-LIQ         AS CHAR     INIT "LIQ".
FIND Faccfggn WHERE Faccfggn.Codcia = S-CODCIA NO-LOCK NO-ERROR.

/*ML01*/ DEFINE VARIABLE lEsAgente AS LOGICAL NO-UNDO.
/*ML01*/ DEFINE VARIABLE dPorRetencion AS DECIMAL NO-UNDO.
/*ML01*/ DEFINE VARIABLE dMontoMinimo AS DECIMAL NO-UNDO.
/*ML01*/ DEFINE VARIABLE iNroSer AS INTEGER NO-UNDO.
/*ML01*/ DEFINE VARIABLE cCodDoc AS CHARACTER INITIAL "RET" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS B-TOTAL F-factura i-codmov c-nrodoc c-imptot ~
R-moneda F-fecha R-compra Btn_OK Btn_Cancel Btn_Help RADIO-SET-1 ~
B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE RECT-49 RECT-5 ~
RECT-50 
&Scoped-Define DISPLAYED-OBJECTS F-factura F-TOTAL i-codmov c-nrodoc ~
c-imptot R-moneda F-fecha R-compra N-MOVI FILL-IN-3 RADIO-SET-1 ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-TOTAL  NO-CONVERT-3D-COLORS
     LABEL "Total" 
     SIZE 6 BY .69.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE i-codmov AS INTEGER FORMAT "99":U INITIAL 2 
     LABEL "Movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "02","17","06" 
     DROP-DOWN-LIST
     SIZE 5.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-imptot AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Importe Factura" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69 NO-UNDO.

DEFINE VARIABLE c-nrodoc AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Ingreso" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .81 NO-UNDO.

DEFINE VARIABLE F-factura AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Numero Factura" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Factura" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-TOTAL AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .69
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .69 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE R-compra AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pre-Compra", 1,
"Compra", 2
     SIZE 11.14 BY 1.5 NO-UNDO.

DEFINE VARIABLE R-moneda AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 8.29 BY 1.04 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 5.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 6.19.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.72 BY 11.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     B-TOTAL AT ROW 2.58 COL 28.43
     F-factura AT ROW 5.42 COL 12.14 COLON-ALIGNED
     F-TOTAL AT ROW 2.54 COL 33.29 COLON-ALIGNED NO-LABEL
     i-codmov AT ROW 1.15 COL 21 COLON-ALIGNED
     c-nrodoc AT ROW 2.54 COL 12 COLON-ALIGNED
     c-imptot AT ROW 3.81 COL 12 COLON-ALIGNED
     R-moneda AT ROW 3.69 COL 28 NO-LABEL
     F-fecha AT ROW 4.65 COL 12.14 COLON-ALIGNED
     R-compra AT ROW 4.46 COL 37.57 NO-LABEL
     Btn_OK AT ROW 2.27 COL 52.43
     Btn_Cancel AT ROW 5.08 COL 52.72
     Btn_Help AT ROW 7.81 COL 53
     N-MOVI AT ROW 1.23 COL 26.43 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 1.23 COL 1.85
     RADIO-SET-1 AT ROW 7.65 COL 2.43 NO-LABEL
     B-impresoras AT ROW 8.69 COL 15.57
     b-archivo AT ROW 9.69 COL 15.72
     RB-OUTPUT-FILE AT ROW 9.85 COL 19.57 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 11.38 COL 10.14 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 11.38 COL 24.86 COLON-ALIGNED
     RB-END-PAGE AT ROW 11.38 COL 39 COLON-ALIGNED
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 6.73 COL 1.14
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 10.77 COL 33.29
          FONT 6
     RECT-49 AT ROW 1 COL 1
     RECT-5 AT ROW 6.38 COL 1
     RECT-50 AT ROW 1 COL 50
     SPACE(0.70) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Liquidación de Compra".


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

{src/adm/method/containr.i}
{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN F-TOTAL IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Liquidación de Compra */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo D-Dialog
ON CHOOSE OF b-archivo IN FRAME D-Dialog /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresi¢n ..."
        FILTERS    "Archivos Impresi¢n (*.txt)"   "*.txt",
                   "Todos (*.*)"   "*.*"
        INITIAL-DIR "./txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN
        RB-OUTPUT-FILE:SCREEN-VALUE = RB-OUTPUT-FILE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras D-Dialog
ON CHOOSE OF B-impresoras IN FRAME D-Dialog
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-TOTAL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-TOTAL D-Dialog
ON CHOOSE OF B-TOTAL IN FRAME D-Dialog /* Total */
DO:
  DEFINE VAR X-Sub    LIKE Almdmov.Candes NO-UNDO INIT 0. 
  DEFINE VAR X-Tot    LIKE Almdmov.Candes NO-UNDO INIT 0. 
  DEFINE VAR x-igv    AS DECI INIT 0. 

  ASSIGN C-ImpTot I-CodMov C-Nrodoc R-Compra R-MONEDA F-FECHA F-FACTURA.
  
    FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                        AND  Almcmov.CodAlm  = S-CODALM 
                        AND  Almcmov.TipMov  = C-TipMov 
                        AND  Almcmov.CodMov  = I-CodMov
                        AND  Almcmov.NroDoc  = C-NroDoc 
                        NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
        MESSAGE "MOVIMIENTO NO REGISTRADO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
  
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha =  F-FECHA NO-LOCK NO-ERROR.
  x-tipo = IF AVAILABLE gn-tcmb THEN  gn-tcmb.venta ELSE 0.

  IF SUBSTRING(AlmcMov.Observ,1,3) = X-LIQ OR Almcmov.CodMov = X-COMPRA THEN DO:
      FOR EACH ALMDMOV OF ALMCMOV NO-LOCK:
        FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                       AND  Almmmatg.codmat = Almdmov.codmat 
                       NO-LOCK NO-ERROR.
        x-sub  = Almdmov.PreUni.
        IF R-MONEDA = 1 THEN DO:
          x-sub = IF Almdmov.Codmon = R-MONEDA THEN x-sub ELSE  x-sub * x-tipo.
        END.  
        IF R-MONEDA = 2 THEN DO:
          x-sub = IF Almdmov.Codmon = R-MONEDA THEN x-sub ELSE  x-sub / x-tipo.
        END.  
         x-igv     = Almdmov.Igvmat.
         x-sub     = ROUND(( x-sub + ( x-sub * ( x-igv / 100 ))),4).
         x-sub     = ROUND( x-sub * Almdmov.Candes,2).
         X-TOT     = X-TOT + X-SUB.
      END.
      F-TOTAL:SCREEN-VALUE = STRING(X-TOT,"->>,>>9.99").
  END.
  ELSE DO:
      FOR EACH ALMDMOV OF ALMCMOV NO-LOCK:
        FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                       AND  Almmmatg.codmat = Almdmov.codmat 
                       NO-LOCK NO-ERROR.
        x-sub  = Almmmatg.CtoLis.
        IF R-MONEDA = 1 THEN DO:
          x-sub = IF Almmmatg.Monvta = R-MONEDA THEN x-sub ELSE  x-sub * x-tipo.
        END.  
        IF R-MONEDA = 2 THEN DO:
          x-sub = IF Almmmatg.Monvta = R-MONEDA THEN x-sub ELSE  x-sub / x-tipo.
        END.  
         x-igv     = IF Almmmatg.AftIgv THEN Faccfggn.PorIgv ELSE 0.
         x-sub     = ROUND(( x-sub + ( x-sub * ( x-igv / 100 ))),4).
         x-sub     = ROUND( x-sub * Almdmov.Candes,2).
         X-TOT     = X-TOT + X-SUB.
      END.
      F-TOTAL:SCREEN-VALUE = STRING(X-TOT,"->>,>>9.99").
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  L-FIN = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN C-ImpTot I-CodMov C-Nrodoc R-Compra R-MONEDA F-FECHA F-FACTURA.
  IF I-CODMOV <> 0 THEN DO:
    FIND FIRST Almdmov WHERE Almdmov.CodCia  = S-CODCIA 
                        AND  Almdmov.CodAlm  = S-CODALM 
                        AND  Almdmov.TipMov  = C-TipMov 
                        AND  Almdmov.CodMov  = I-CodMov
                        AND  Almdmov.NroDoc  = C-NroDoc 
                       NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almdmov THEN DO:
        MESSAGE "MOVIMIENTO NO REGISTRADO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
      /*X-CODMOV = I-CODMOV.*/
  END.
 FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                     AND  Almcmov.CodAlm  = S-CODALM 
                     AND  Almcmov.TipMov  = C-TipMov 
                     AND  Almcmov.CodMov  = I-CodMov
                     AND  Almcmov.NroDoc  = C-NroDoc 
                     NO-ERROR.
  
  IF SUBSTRING(AlmcMov.Observ,1,3) = X-LIQ AND R-COMPRA = 2  THEN DO:
    MESSAGE "MOVIMIENTO YA REGISTRA COMPRA " .
  END.
  
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha =  F-FECHA NO-LOCK NO-ERROR.
  x-tipo = IF AVAILABLE gn-tcmb THEN  gn-tcmb.venta ELSE 0.

  P-largo   = 33.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".
  
     
       
  FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
             Almtmovm.Tipmov = Almcmov.TipMov AND 
             Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO:
     S-Movimiento = CAPS(Almtmovm.Desmov).
     IF Almtmovm.PidCli THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = 0 AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN 
           FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
                gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN S-Procedencia = "Cliente          : " + gn-clie.NomCli.
           S-RUC = "R.U.C.          :   " + Almcmov.CodCli.
                                        
     END.
     IF Almtmovm.PidPro THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
             gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN 
          FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
          S-RUC = "R.U.C.          :   " + Almcmov.CodPro.
/*ML01* Inicio de bloque */
        iNroSer = 0.
        lEsAgente = FALSE.
        IF AVAILABLE gn-prov THEN DO:

            lEsAgente = (
                gn-prov.Libre_C01 = "Si" OR
                gn-prov.Libre_C02 = "Si" OR
                gn-prov.Libre_C03 = "Si"
                ).

            FOR EACH faccorre WHERE
                faccorre.codcia = s-codcia AND
                faccorre.coddoc = cCodDoc AND
                faccorre.NroSer >= 0 NO-LOCK:
                IF faccorre.FlgEst THEN DO:
                    iNroSer = faccorre.NroSer.
                    LEAVE.
                END.
            END.

            IF iNroSer <> 0 THEN DO:
                FIND FIRST cb-tabl WHERE cb-tabl.Tabla = "RET" NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN
                    ASSIGN
                        dPorRetencion = DECIMAL(cb-tabl.Codigo)
                        dMontoMinimo = DECIMAL(cb-tabl.Digitos) NO-ERROR.
            END.

        END.
/*ML01* Fin de bloque */
     END.
     IF Almtmovm.Movtrf THEN DO:
        S-Moneda = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
             Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
           IF Almcmov.TipMov = "I" THEN
              S-Procedencia = "Procedencia      : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.
           ELSE 
              S-Procedencia = "Destino          : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.   
           END.            
     END.   
     IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.
     IF Almtmovm.PidRef3 THEN ASSIGN S-Referencia3 = Almtmovm.GloRf3.
  END.

  
  
     
  IF P-select = 2 
     THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  ELSE RUN setup-print.      
     IF P-select <> 1 
     THEN P-copias = 1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-factura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-factura D-Dialog
ON LEAVE OF F-factura IN FRAME D-Dialog /* Numero Factura */
DO:
  f-factura:SCREEN-VALUE = string(integer(SUBSTRING(f-factura:SCREEN-VALUE,1,3)),"999") + 
      "-" + string(integer(SUBSTRING(f-factura:SCREEN-VALUE,5,6)),"999999").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-codmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codmov D-Dialog
ON VALUE-CHANGED OF i-codmov IN FRAME D-Dialog /* Movimiento */
DO:
  FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = C-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
DO:
    IF SELF:SCREEN-VALUE = "3"
    THEN ASSIGN b-archivo:VISIBLE = YES
                RB-OUTPUT-FILE:VISIBLE = YES
                b-archivo:SENSITIVE = YES
                RB-OUTPUT-FILE:SENSITIVE = YES.
    ELSE ASSIGN b-archivo:VISIBLE = NO
                RB-OUTPUT-FILE:VISIBLE = NO
                b-archivo:SENSITIVE = NO
                RB-OUTPUT-FILE:SENSITIVE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

ASSIGN F-FACTURA = ""
       C-IMPTOT = 0
       R-COMPRA = 1
       R-MONEDA = 1
       F-FECHA  = TODAY
       /*I-CODMOV = 17*/
       /* s-codalm = "11"*/
       FILL-IN-3 = S-CODALM
       FRAME {&FRAME-NAME}:TITLE  = "[ Liquidacióon de Compra ]".

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME D-DIALOG:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN IMPRIMIR.
    OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  
  SESSION:IMMEDIATE-DISPLAY =   l-immediate-display.
  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 

  END.    
  HIDE FRAME F-Mensaje.  
  RETURN.
END.


RUN disable_UI.

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
  DISPLAY F-factura F-TOTAL i-codmov c-nrodoc c-imptot R-moneda F-fecha R-compra 
          N-MOVI FILL-IN-3 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE B-TOTAL F-factura i-codmov c-nrodoc c-imptot R-moneda F-fecha R-compra 
         Btn_OK Btn_Cancel Btn_Help RADIO-SET-1 B-impresoras RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE RECT-49 RECT-5 RECT-50 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-desmat AS CHAR NO-UNDO.
  DEFINE VAR X-preuni LIKE Almdmov.Prelis NO-UNDO. 
  DEFINE VAR X-Sub    LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR X-Tot    LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR Y-Tot    LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR x-igv    AS DECI INIT 0. 

  IF R-COMPRA = 1 THEN   S-Movimiento = S-Movimiento  + " Pre-Compra" .
  IF R-COMPRA = 2 THEN   S-Movimiento = S-Movimiento  + " Compra" .

  IF R-Moneda = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
  END.
  

     DEFINE FRAME H-REP
          Almdmov.codmat  FORMAT "X(8)"
          Almmmatg.DesMat AT 9 FORMAT "X(35)"
          Almdmov.CodUnd  AT 45 FORMAT "X(6)" 
          Almdmov.CanDes  FORMAT  "(>>>,>>9.99)" 
          Almdmov.Prelis  FORMAT  "(>>>,>>9.9999)"
          X-Sub           FORMAT  "(>>>,>>9.99)" 
          Almmmatg.UndA      AT 95  FORMAT "X(4)"
          Almmmatg.MrgUti-A  AT 100 FORMAT "(>>9.99)"
          Almmmatg.UndB      AT 110 FORMAT "X(4)" 
          Almmmatg.MrgUti-B  AT 115 FORMAT "(>>9.99)"
          Almmmatg.UndC      AT 125 FORMAT "X(4)"
          Almmmatg.MrgUti-C  AT 130 FORMAT "(>>9.99)"
          HEADER
          {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
          "*INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
          {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + S-CODALM + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
          S-Movimiento  AT 52  "Pag. " AT 108  SKIP(1)
          S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
          S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
          S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
          "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP

          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
          "                                                                                               Undidad-A      Unidad-B       Unidad-C  " SKIP
          "Articulo        Descripcion                    Unid      Cantidad         Costo     Subtotal  Und  Margen    Und  Margen    Und  Margen" SKIP
          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
      
  FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                    AND  Almdmov.CodAlm = S-CODALM 
                    AND  Almdmov.TipMov = C-TipMov 
                    AND  Almdmov.CodMov = I-CodMov
                    AND  Almdmov.NroDoc = C-NroDoc
                    BREAK BY Almdmov.CodCia
                         BY Almdmov.CodAlm
                         BY Almdmov.TipMov
                         BY Almdmov.CodMov
                         BY Almdmov.NroSer 
                         BY Almdmov.Nrodoc 
                         ON ERROR UNDO, LEAVE :
      {&new-page}.        

      
      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                     AND  Almmmatg.codmat = Almdmov.codmat 
                    NO-LOCK NO-ERROR.

      IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
      ELSE x-desmat = Almmmatg.DesMat.
       
               x-preuni  = Almmmatg.CtoLis.
                
               IF R-MONEDA = 1 THEN DO:
                x-preuni = IF Almmmatg.Monvta = R-MONEDA THEN x-preuni ELSE  x-preuni * x-tipo.
               END.  
               IF R-MONEDA = 2 THEN DO:
                x-preuni = IF Almmmatg.Monvta = R-MONEDA THEN x-preuni ELSE  x-preuni / x-tipo.
               END.  
               
                
                x-igv     = IF Almmmatg.AftIgv THEN Faccfggn.PorIgv ELSE 0.
                x-sub     = ROUND(( x-preuni + ( x-preuni * ( x-igv / 100 ))),4).
                x-sub     = ROUND( x-sub * Almdmov.Candes,2).
                IF R-Compra = 2 THEN DO:
                 Almdmov.PreLis = x-preuni .
                 Almdmov.PreUni = x-preuni .
                 Almdmov.IgvMat = x-igv .
                 Almdmov.ImpCto = x-preuni * Almdmov.Candes.
                 Almdmov.TpoCmb = x-tipo.
                 Almdmov.dsctos[1] = 0.
                 Almdmov.dsctos[2] = 0.
                 Almdmov.dsctos[3] = 0.
                
                END.
           Y-TOT = Y-TOT + Almdmov.ImpCto.
           X-TOT = X-TOT + X-SUB.

      DISPLAY STREAM REPORT 
              Almdmov.codmat 
              x-desmat @ Almmmatg.DesMat
              Almdmov.CodUnd 
              Almdmov.CanDes 
              X-SUB / Almdmov.Candes @ Almdmov.Prelis
              x-sub    
              Almmmatg.UndA      
              Almmmatg.MrgUti-A  
              Almmmatg.UndB      
              Almmmatg.MrgUti-B  
              Almmmatg.UndC      
              Almmmatg.MrgUti-C  
              
              WITH FRAME H-REP.
      IF LAST-OF(Almdmov.Nrodoc) THEN DO:
           IF R-Compra = 2 THEN DO:
             Almcmov.Observ = "LIQ/" + Almcmov.Observ .
             Almcmov.Codmon = R-moneda.
             Almcmov.TpoCmb = x-tipo.
             Almcmov.ImpMn1 = IF R-MONEDA = 1 THEN Y-TOT ELSE Y-TOT * x-tipo.
             Almcmov.ImpMn2 = IF R-MONEDA = 2 THEN Y-TOT ELSE Y-TOT / x-tipo.
             /*Almcmov.NroRf2 = f-factura.*/
             Almcmov.NroRf3 = f-factura.
           END.
           PUT STREAM REPORT 
           SKIP
           "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
           "Importe Calculado   : " AT 30
           X-tot          AT 65  FORMAT  "(>>>,>>>,>>9.99)" SKIP
           "Importe Ingresado   : " AT 30
           C-IMPTOT       AT 65  FORMAT  "(>>>,>>>,>>9.99)" SKIP
           "Diferencia          : " AT 30
           X-TOT - C-IMPTOT AT 65 FORMAT "(>>>,>>>,>>9.99)" skip
           "---------------------------------------------------------------------------------------------------------------------------------------".

          DOWN STREAM REPORT 1 WITH FRAME F-REP. 
      END.
      PROCESS EVENTS.
  END.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 D-Dialog 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-flgest AS CHAR NO-UNDO.
  DEFINE VAR x-desmat AS CHAR NO-UNDO.
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR X-Movi    AS CHAR NO-UNDO.
  DEFINE VAR X-NomR LIKE Almcmov.NomRef NO-UNDO.
  DEFINE VAR X-Usua LIKE Almcmov.usuario NO-UNDO.
  DEFINE VAR X-Ref1 LIKE Almcmov.NroRf1 NO-UNDO. 
  DEFINE VAR X-Sub  LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR X-Mon  AS CHAR initial "DOLARES" NO-UNDO. 
  DEFINE VAR X-Tot  LIKE Almdmov.Candes NO-UNDO. 
  
/*ML01*/ DEFINE VARIABLE cRetencion AS CHARACTER FORMAT "x(60)" NO-UNDO.

  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
     R-MONEDA = 1.
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
     R-MONEDA = 2.
  END.

  
  x-titulo2 = ' P R O D U C T O S ' .
  CASE C-TipMov:
     WHEN 'I' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
     WHEN 'S' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
  END CASE.

     DEFINE FRAME H-REP
          Almdmov.codmat  FORMAT "X(8)"
          Almmmatg.DesMat AT 9 FORMAT "X(35)"
          Almdmov.CodUnd  AT 45 FORMAT "X(6)" 
          Almdmov.CanDes  FORMAT  "(>>>,>>9.99)" 
          Almdmov.Prelis  FORMAT  "(>>>,>>9.9999)"
          X-Sub           FORMAT  "(>>>,>>9.99)" 
          Almmmatg.UndA      AT 95  FORMAT "X(4)"
          Almmmatg.MrgUti-A  AT 100 FORMAT "(>>9.99)"
          Almmmatg.UndB      AT 110 FORMAT "X(4)" 
          Almmmatg.MrgUti-B  AT 115 FORMAT "(>>9.99)"
          Almmmatg.UndC      AT 125 FORMAT "X(4)"
          Almmmatg.MrgUti-C  AT 130 FORMAT "(>>9.99)"

          HEADER
          
          {&PRN2} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN3} FORMAT "X(45)" 
          "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
          {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + S-CODALM + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
          S-Movimiento  AT 52  "Pag. " AT 108  SKIP(1)
          S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
          S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
          S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
          "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP

          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
          "                                                                                               Undidad-A      Unidad-B       Unidad-C  " SKIP
          "Articulo        Descripcion                    Unid      Cantidad         Costo     Subtotal  Und  Margen    Und  Margen    Und  Margen" SKIP
          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  
       
 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4}.
      
  FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                    AND  Almdmov.CodAlm = S-CODALM 
                    AND  Almdmov.TipMov = C-TipMov 
                    AND  Almdmov.CodMov = I-CodMov
                    AND  Almdmov.NroDoc = C-NroDoc
                    BREAK BY Almdmov.CodCia
                         BY Almdmov.CodAlm
                         BY Almdmov.TipMov
                         BY Almdmov.CodMov
                         BY Almdmov.NroSer 
                         BY Almdmov.Nrodoc 
                         ON ERROR UNDO, LEAVE :
      {&new-page}.        
      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                     AND  Almmmatg.codmat = Almdmov.codmat 
                    NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
      ELSE x-desmat = Almmmatg.DesMat.
           W-VTA0 = almdmov.prelis * (1 - (Almdmov.dsctos[1] / 100)).
           W-VTA1 = w-vta0  * (1 - (Almdmov.dsctos[2] / 100)).
           W-VTA2 = w-vta1  * (1 - (Almdmov.dsctos[3] / 100)).
           IF Almmmatg.AftIgv THEN    
               X-SUB = ROUND(( W-VTA2 + ( W-VTA2 * (Almdmov.IgvMat / 100 ))) * ALMDMOV.CANDES,2).
           ELSE 
               X-SUB = ROUND( W-VTA2  * ALMDMOV.CANDES,2).
            X-TOT = X-TOT + X-SUB.
      IF R-Compra = 2 THEN DO:
         Almdmov.Tpocmb = x-tipo.
      END.
      DISPLAY STREAM REPORT 
              Almdmov.codmat 
              x-desmat @ Almmmatg.DesMat
              Almdmov.CodUnd 
              Almdmov.CanDes 
              X-SUB / AlmdmoV.Candes @ Almdmov.Prelis
              x-sub    
              Almmmatg.UndA      
              Almmmatg.MrgUti-A  
              Almmmatg.UndB      
              Almmmatg.MrgUti-B  
              Almmmatg.UndC      
              Almmmatg.MrgUti-C  
              WITH FRAME H-REP.

      IF LAST-OF(Almdmov.Nrodoc) THEN DO:
           IF R-Compra = 2 THEN DO:
             Almcmov.Observ = If substring(Almcmov.Observ,1,3) = X-LIQ  + Almcmov.Observ THEN "" ELSE X-LIQ + Almcmov.Observ .
             Almcmov.NroRf3 = f-factura.
             Almcmov.Tpocmb = x-tipo.
             Almcmov.ImpMn1 = IF R-MONEDA = 1 THEN X-TOT ELSE X-TOT * x-tipo.
             Almcmov.ImpMn2 = IF R-MONEDA = 2 THEN X-TOT ELSE X-TOT / x-tipo.
           END.
           
/*ML01* Inicio de bloque */
            IF NOT lEsAgente THEN
                cRetencion =
                    "  Retencion: " +
                    TRIM(STRING(dPorRetencion,">9.9<%")) + " " +
                    TRIM(STRING(ROUND((C-IMPTOT * dPorRetencion / 100),2),"(>,>>>,>>9.99)")) + "  " +
                    "Saldo: " + TRIM(STRING(ROUND((C-IMPTOT - (C-IMPTOT * dPorRetencion / 100)),2),"(>,>>>,>>9.99)")).
            ELSE cRetencion = "".
/*ML01* Fin de bloque */

           PUT STREAM REPORT 
           SKIP
           "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*ML01* Inicio de bloque */
            "Importe Calculado: " TO 30 X-tot            TO 45 FORMAT  "(>,>>>,>>9.99)" SKIP
            "Importe Ingresado: " TO 30 C-IMPTOT         TO 45 FORMAT  "(>,>>>,>>9.99)" cRetencion SKIP
            "Diferencia       : " TO 30 X-TOT - C-IMPTOT TO 45 FORMAT  "(>,>>>,>>9.99)" skip
/*ML01* Fin de bloque */
           "---------------------------------------------------------------------------------------------------------------------------------------".

          DOWN STREAM REPORT 1 WITH FRAME F-REP. 
      END.
      PROCESS EVENTS.
  END.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2a D-Dialog 
PROCEDURE Formato2a :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-flgest AS CHAR NO-UNDO.
  DEFINE VAR x-desmat AS CHAR NO-UNDO.
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR X-Movi    AS CHAR NO-UNDO.
  DEFINE VAR X-NomR LIKE Almcmov.NomRef NO-UNDO.
  DEFINE VAR X-Usua LIKE Almcmov.usuario NO-UNDO.
  DEFINE VAR X-Ref1 LIKE Almcmov.NroRf1 NO-UNDO. 
  DEFINE VAR X-Sub  LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR X-Mon  AS CHAR initial "DOLARES" NO-UNDO. 
  DEFINE VAR X-Tot  LIKE Almdmov.Candes NO-UNDO. 
  
/*ML01*/ DEFINE VARIABLE cRetencion AS CHARACTER FORMAT "x(60)" NO-UNDO.

  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
     R-MONEDA = 1.
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
     R-MONEDA = 2.
  END.

  
  x-titulo2 = ' P R O D U C T O S ' .
  CASE C-TipMov:
     WHEN 'I' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
     WHEN 'S' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
  END CASE.

     DEFINE FRAME H-REP
          Almdmov.codmat  FORMAT "X(8)"
          Almmmatg.DesMat AT 9 FORMAT "X(35)"
          Almdmov.CodUnd  AT 45 FORMAT "X(6)" 
          Almdmov.CanDes  FORMAT  "(>>>,>>9.99)" 
          Almdmov.Prelis  FORMAT  "(>>>,>>9.9999)"
          X-Sub           FORMAT  "(>>>,>>9.99)" 
          Almmmatg.UndA      AT 95  FORMAT "X(4)"
          Almmmatg.MrgUti-A  AT 100 FORMAT "(>>9.99)"
          Almmmatg.UndB      AT 110 FORMAT "X(4)" 
          Almmmatg.MrgUti-B  AT 115 FORMAT "(>>9.99)"
          Almmmatg.UndC      AT 125 FORMAT "X(4)"
          Almmmatg.MrgUti-C  AT 130 FORMAT "(>>9.99)"

          HEADER
          
          {&PRN2} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN3} FORMAT "X(45)" 
          "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
          {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + S-CODALM + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
          S-Movimiento  AT 52  "Pag. " AT 108  SKIP(1)
          S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
          S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
          S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
          "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP

          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
          "                                                                                               Undidad-A      Unidad-B       Unidad-C  " SKIP
          "Articulo        Descripcion                    Unid      Cantidad         Costo     Subtotal  Und  Margen    Und  Margen    Und  Margen" SKIP
          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  
       
 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4}.
      
  FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                    AND  Almdmov.CodAlm = S-CODALM 
                    AND  Almdmov.TipMov = C-TipMov 
                    AND  Almdmov.CodMov = I-CodMov
                    AND  Almdmov.NroDoc = C-NroDoc
                    BREAK BY Almdmov.CodCia
                         BY Almdmov.CodAlm
                         BY Almdmov.TipMov
                         BY Almdmov.CodMov
                         BY Almdmov.NroSer 
                         BY Almdmov.Nrodoc 
                         ON ERROR UNDO, LEAVE :
      {&new-page}.        
      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                     AND  Almmmatg.codmat = Almdmov.codmat 
                    NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
      ELSE x-desmat = Almmmatg.DesMat.
           W-VTA0 = almdmov.prelis * (1 - (Almdmov.dsctos[1] / 100)).
           W-VTA1 = w-vta0  * (1 - (Almdmov.dsctos[2] / 100)).
           W-VTA2 = w-vta1  * (1 - (Almdmov.dsctos[3] / 100)).
           IF Almmmatg.AftIgv THEN    
               X-SUB = ROUND(( W-VTA2 + ( W-VTA2 * (Almdmov.IgvMat / 100 ))) * ALMDMOV.CANDES,2).
           ELSE 
               X-SUB = ROUND( W-VTA2  * ALMDMOV.CANDES,2).
            X-TOT = X-TOT + X-SUB.
      IF R-Compra = 2 THEN DO:
         Almdmov.Tpocmb = x-tipo.
      END.
      FIND VtaListaMIn WHERE VtaListaMin.CodCia = s-codcia
          AND VtaListaMin.CodDiv = Almacen.coddiv 
          AND VtaListaMin.codmat = Almdmov.codmat
          NO-LOCK NO-ERROR.
      DISPLAY STREAM REPORT 
              Almdmov.codmat 
              x-desmat @ Almmmatg.DesMat
              Almdmov.CodUnd 
              Almdmov.CanDes 
              X-SUB / AlmdmoV.Candes @ Almdmov.Prelis
              x-sub    
              VtaListaMin.Chr__01 WHEN AVAILABLE(Vtalistamin) @ Almmmatg.UndA      
              VtaListaMin.Dec__01 WHEN AVAILABLE(Vtalistamin) @ Almmmatg.MrgUti-A  
              WITH FRAME H-REP.

      IF LAST-OF(Almdmov.Nrodoc) THEN DO:
           IF R-Compra = 2 THEN DO:
             Almcmov.Observ = If substring(Almcmov.Observ,1,3) = X-LIQ  + Almcmov.Observ THEN "" ELSE X-LIQ + Almcmov.Observ .
             Almcmov.NroRf3 = f-factura.
             Almcmov.Tpocmb = x-tipo.
             Almcmov.ImpMn1 = IF R-MONEDA = 1 THEN X-TOT ELSE X-TOT * x-tipo.
             Almcmov.ImpMn2 = IF R-MONEDA = 2 THEN X-TOT ELSE X-TOT / x-tipo.
           END.
           
/*ML01* Inicio de bloque */
            IF NOT lEsAgente THEN
                cRetencion =
                    "  Retencion: " +
                    TRIM(STRING(dPorRetencion,">9.9<%")) + " " +
                    TRIM(STRING(ROUND((C-IMPTOT * dPorRetencion / 100),2),"(>,>>>,>>9.99)")) + "  " +
                    "Saldo: " + TRIM(STRING(ROUND((C-IMPTOT - (C-IMPTOT * dPorRetencion / 100)),2),"(>,>>>,>>9.99)")).
            ELSE cRetencion = "".
/*ML01* Fin de bloque */

           PUT STREAM REPORT 
           SKIP
           "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*ML01* Inicio de bloque */
            "Importe Calculado: " TO 30 X-tot            TO 45 FORMAT  "(>,>>>,>>9.99)" SKIP
            "Importe Ingresado: " TO 30 C-IMPTOT         TO 45 FORMAT  "(>,>>>,>>9.99)" cRetencion SKIP
            "Diferencia       : " TO 30 X-TOT - C-IMPTOT TO 45 FORMAT  "(>,>>>,>>9.99)" skip
/*ML01* Fin de bloque */
           "---------------------------------------------------------------------------------------------------------------------------------------".

          DOWN STREAM REPORT 1 WITH FRAME F-REP. 
      END.
      PROCESS EVENTS.
  END.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

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

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-codalm NO-LOCK.
IF Almacen.coddiv = '00023'         /* UTILEX */
THEN RUN Formato2a.
ELSE RUN Formato2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE D-Dialog 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin  THEN DO:
       RETURN ERROR.
    END.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina  THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1  THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
               PAGED PAGE-SIZE 62.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 62.
            IF P-select = 3 THEN
                 PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar D-Dialog 
PROCEDURE remvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER IN-VAR AS CHARACTER.
    DEFINE OUTPUT PARAMETER OU-VAR AS CHARACTER.
    DEFINE VARIABLE P-pos AS INTEGER.
    OU-VAR = IN-VAR.
    IF P-select = 2 THEN DO:
        OU-VAR = "".
        RETURN.
    END.
    P-pos =  INDEX(OU-VAR, "[NULL]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(0) + SUBSTR(OU-VAR, P-pos + 6).
    P-pos =  INDEX(OU-VAR, "[#B]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(P-Largo) + SUBSTR(OU-VAR, P-pos + 4).
    P-pos =  INDEX(OU-VAR, "[#]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     STRING(P-Largo, ">>9" ) + SUBSTR(OU-VAR, P-pos + 3).
    RETURN.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup-Print D-Dialog 
PROCEDURE Setup-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND integral.P-Codes WHERE integral.P-Codes.Name = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.P-Codes
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" XTerm
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT integral.P-Codes.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT integral.P-Codes.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT integral.P-Codes.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT integral.P-Codes.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT integral.P-Codes.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT integral.P-Codes.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT integral.P-Codes.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT integral.P-Codes.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT integral.P-Codes.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT integral.P-Codes.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT integral.P-Codes.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT integral.P-Codes.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT integral.P-Codes.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT integral.P-Codes.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT integral.P-Codes.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT integral.P-Codes.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT integral.P-Codes.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT integral.P-Codes.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT integral.P-Codes.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT integral.P-Codes.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT integral.P-Codes.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT integral.P-Codes.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT integral.P-Codes.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT integral.P-Codes.Lpi,      OUTPUT P-Lpi).
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

