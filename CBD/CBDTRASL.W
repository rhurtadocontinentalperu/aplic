&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
/* Connected Databases
          integral          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1
DEF    {&NEW} SHARED VAR  s-codcia LIKE cb-dmov.codcia  INITIAL 1.
DEF    {&NEW} SHARED VAR  s-periodo    LIKE cb-dmov.periodo INITIAL 1996.
DEF    {&NEW} SHARED VAR  s-NroMes     LIKE cb-dmov.nromes  INITIAL 12.
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5".

DEF        VAR  cb-codcia AS INTEGER INITIAL 0.
DEF VAR    PTO AS LOGICAL.
DEF VAR    l-CtaMov AS INTEGER.
DEF VAR XsCodCta-67 AS CHAR.
DEF VAR XsCodCta-77 AS CHAR.
DEF VAR XsCodCta-79 AS CHAR.
DEF VAR XsCodAux-67 AS CHAR.
DEF VAR XsCodAux-77 AS CHAR.

DEF VAR XsCodOpe    AS CHAR.
DEF VAR XsNroAst    AS CHAR INITIAL "000002".
DEF VAR Xftpocmb   LIKE cb-dmov.tpocmb.
DEF VAR x-msg1 AS CHAR FORMAT "X(35)".
DEF VAR x-msg2 AS CHAR FORMAT "X(35)".
DEF VAR x-msg3 AS CHAR FORMAT "X(35)".
DEF VAR x-msg4 AS CHAR FORMAT "X(35)".

DEFINE FRAME F-MENSAJE
       x-msg1 NO-LABEL  SKIP
       x-msg2 NO-LABEL  SKIP
       x-msg3 NO-LABEL  SKIP
       x-msg4 NO-LABEL
       WITH CENTERED
       TITLE "Espere un Momento por Favor"
       VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
       SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
       BGCOLOR 15 FGCOLOR 0.

DEF VAR  XfImpMn1  AS DECIMAL INITIAL 0.
DEF VAR  XfImpMn2  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoMn1  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoMn2  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoAjte AS DECIMAL INITIAL 0.
DEF VAR  XfSdoAct  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoPas  AS DECIMAL INITIAL 0.
DEF VAR  X-GloDoc  AS CHAR.
DEF VAR  XlTpoMov  AS LOGICAL.
DEF VAR  XiNroItm  AS INTEGER INITIAL 0.
DEF VAR  XcCodMon  AS INTEGER INITIAL 1.
DEF VAR  XdCodMon  AS INTEGER INITIAL 1.

PTO = SESSION:SET-WAIT-STATE("").

l-CtaMov = INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)).



DEF BUFFER detalle FOR cb-dmov.
DEF VAR x-recid    AS RECID.
DEF VAR  x-CodCta   LIKE cb-dmov.CodCta.
DEF VAR  x-clfaux   LIKE cb-dmov.clfaux.
DEF VAR  x-codaux   LIKE cb-dmov.codaux.
DEF VAR  x-coddoc   LIKE cb-dmov.coddoc.
DEF VAR  x-nrodoc   LIKE cb-dmov.nrodoc.
DEF VAR  x-nroref   LIKE cb-dmov.nroref.
DEF VAR  x-fchdoc   LIKE cb-dmov.fchdoc.
DEF VAR  x-fchvto   LIKE cb-dmov.fchvto.
DEF VAR  x-TpoItm   LIKE cb-dmov.TpoItm.
DEF VAR  x-Div      LIKE cb-dmov.Coddiv.

DEF VAR  Hay-division AS LOGICAL.

DEF VAR ImpCal1  AS DECIMAL.
DEF VAR ImpCal2  AS DECIMAL.
DEF VAR ImpCal3  AS DECIMAL.
DEF VAR ImpCal4  AS DECIMAL.
DEF VAR ImpCal5  AS DECIMAL.
DEF VAR ImpCal6  AS DECIMAL.

/****CONFIGURACION DE VARIABLES******/
IF S-NROMES = 0 THEN DO:
   MESSAGE "En el mes de apertura no existe " skip
           "diferencia de cambio/Traslaci¢n"
  VIEW-AS ALERT-BOX INFORMA.
  RETURN.
END.


cb-codcia = 0.
FIND EMPRESAS WHERE EMPRESAS.CodCia = s-codcia NO-LOCK .
IF EMPRESAS.Campo-CodCbd = FALSE THEN cb-codcia = s-codcia.

FIND CB-PERI WHERE CB-PERI.CODCIA  = S-CODCIA AND
                   CB-PERI.PERIODO = S-PERIODO
                   NO-LOCK .
IF CB-PERI.mescie[S-NROMES + 1 ] THEN DO:
   MESSAGE "...Mes cerrado..."
   VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND CB-CFGG WHERE cb-cfgg.CodCia = cb-codcia AND
                   cb-cfgg.CodCfg = "C02" NO-LOCK NO-ERROR.
IF NOT AVAIL CB-CFGG THEN DO:
   MESSAGE "No Configurado el proceso " SKIP
           "de Diferencia de Cambio"
           VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

XsCodCta-67 = cb-cfgg.CodCta[1] .
XsCodCta-77 = cb-cfgg.CodCta[2] .
XsCodCta-79 = cb-cfgg.CodCta[3].
XsCodAux-67 = cb-cfgg.CodAux[1] .
XsCodAux-77 = cb-cfgg.CodAux[2] .
XsCodOpe    = cb-cfgg.CodOpe.

FIND FIRST cb-cmov WHERE cb-cmov.CODCIA   = s-codcia AND
                         cb-cmov.PERIODO  = s-periodo    AND
                         cb-cmov.NROMES   = s-NroMes
                         NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cmov THEN DO:
   MESSAGE "No Existen Movimientos " SKIP
           "en este Mes"
           VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND cb-cfga WHERE cb-cfga.CODCIA = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfga THEN DO:
             MESSAGE "No existe configuraci¢n Principal" SKIP
                          "del Sistema (Plan de Cuentas)"
             VIEW-AS ALERT-BOX ERROR.
             RETURN.
             END.

Hay-Division = cb-cfga.CodDiv.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 B-ACEPTAR RECT-13 B-Cancelar ~
XfTpoCmb-Compra XfTpoCmb-Venta
&Scoped-Define DISPLAYED-FIELDS integral.Empresas.NomCia ~
integral.cb-cfgg.Codope integral.cb-cfgg.codcta[1] integral.cb-cfgg.codcta[2] ~
integral.cb-cfgg.codaux[1] integral.cb-cfgg.codaux[2] ~
integral.cb-cfgg.codcta[3] integral.cb-cmov.Periodo integral.cb-cmov.Nromes
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 XfTpoCmb-Compra XfTpoCmb-Venta

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-ACEPTAR AUTO-GO
     LABEL "&Aceptar"
     SIZE 9.72 BY 1.08.

DEFINE BUTTON B-Cancelar AUTO-END-KEY
     LABEL "&Cancelar"
     SIZE 9.72 BY 1.08.

DEFINE VARIABLE EDITOR-1 AS CHARACTER INITIAL "Este Proceso tiene por finalidad  Generar   Automaticamente un Asiento Mensual de Traslaci¢n.   Ajusta los Saldos de las Cuentas de Caja Bancos en Soles y Todos los Saldos de los Documentos en Soles de las Cu
entas Corrientes."
     VIEW-AS EDITOR
     SIZE 59.57 BY 2.04
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE XfTpoCmb-Compra AS DECIMAL FORMAT "ZZZZ9.9999":U INITIAL 0
     LABEL "Compra"
     VIEW-AS FILL-IN
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE XfTpoCmb-Venta AS DECIMAL FORMAT "ZZZZ9.9999":U INITIAL 0
     LABEL "Venta"
     VIEW-AS FILL-IN
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 48.72 BY 3.62.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 23.43 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     integral.Empresas.NomCia AT ROW 1.5 COL 3 NO-LABEL
          VIEW-AS FILL-IN
          SIZE 43 BY .81
          BGCOLOR 1 FGCOLOR 15
     EDITOR-1 AT ROW 4 COL 8 NO-LABEL
     integral.cb-cfgg.Codope AT ROW 7.38 COL 14.29 COLON-ALIGNED HELP
          "Codigo de la Operacion"
          LABEL "Operaci¢n" FORMAT "x(3)"
          VIEW-AS FILL-IN
          SIZE 9 BY .81
          BGCOLOR 1 FGCOLOR 15
     integral.cb-cfgg.codcta[1] AT ROW 8.38 COL 14.29 COLON-ALIGNED HELP
          ""
          LABEL "Cuenta Perdida D.C" FORMAT "X(10)"
          VIEW-AS FILL-IN
          SIZE 9 BY .81
          BGCOLOR 1 FGCOLOR 15
     integral.cb-cfgg.codcta[2] AT ROW 9.38 COL 14.29 COLON-ALIGNED HELP
          ""
          LABEL "Cuenta Ganacia D.C" FORMAT "X(10)"
          VIEW-AS FILL-IN
          SIZE 9 BY .81
          BGCOLOR 1 FGCOLOR 15
     B-ACEPTAR AT ROW 11.42 COL 14
     integral.cb-cfgg.codaux[1] AT ROW 8.38 COL 25 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 9 BY .81
          BGCOLOR 1 FGCOLOR 15
     integral.cb-cfgg.codaux[2] AT ROW 9.42 COL 25 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 9 BY .81
          BGCOLOR 1 FGCOLOR 15
     integral.cb-cfgg.codcta[3] AT ROW 8.38 COL 35.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 9 BY .81
          BGCOLOR 1 FGCOLOR 15
     B-Cancelar AT ROW 11.42 COL 51
     XfTpoCmb-Compra AT ROW 7.42 COL 56.43 COLON-ALIGNED
     XfTpoCmb-Venta AT ROW 8.42 COL 56.43 COLON-ALIGNED
     integral.cb-cmov.Periodo AT ROW 1.5 COL 63 COLON-ALIGNED
          LABEL "Periodo Contable"
          VIEW-AS FILL-IN
          SIZE 8 BY .81
          BGCOLOR 1 FGCOLOR 15
     integral.cb-cmov.Nromes AT ROW 2.5 COL 63 COLON-ALIGNED HELP
          "Ingrese el Mes Contable"
          LABEL "Mes Contable" FORMAT "99"
          VIEW-AS FILL-IN
          SIZE 4 BY .81
          BGCOLOR 1 FGCOLOR 15
     "CONFIGURACION" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 6.38 COL 3
     RECT-12 AT ROW 6.92 COL 1.14
     "TIPO DE CAMBIO AJUSTE" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 6.31 COL 51
     RECT-13 AT ROW 6.96 COL 51
     SPACE(1.85) SKIP(3.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         FONT 4
         TITLE "Ajuste por Traslaci¢n".



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN integral.cb-cfgg.codaux[1] IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cfgg.codaux[2] IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cfgg.codcta[1] IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN integral.cb-cfgg.codcta[2] IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN integral.cb-cfgg.codcta[3] IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cfgg.Codope IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN
       EDITOR-1:READ-ONLY IN FRAME DIALOG-1        = TRUE.

/* SETTINGS FOR FILL-IN integral.Empresas.NomCia IN FRAME DIALOG-1
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Nromes IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Periodo IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME






/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-ACEPTAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ACEPTAR DIALOG-1
ON CHOOSE OF B-ACEPTAR IN FRAME DIALOG-1 /* Aceptar */
DO:
  ASSIGN XfTpoCmb-Compra XfTpoCmb-Venta.
  IF XfTpoCmb-Compra = 0 OR XfTpoCmb-Venta = 0 THEN DO:
     MESSAGE "Tipo de Cambio de Ajuste no " SKIP
             "no puede ser Cero (0)"
             VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO XFTPOCMB-VENTA.
     RETURN NO-APPLY.
  END.
  RUN PROCEDE.

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
DEF VAR U-DIA-MES AS DATE.
IF S-NROMES = 12
 THEN U-DIA-MES = DATE(12,31,S-PERIODO).
 ELSE U-DIA-MES = DATE(S-NROMES + 1, 1 , S-PERIODO) - 1.
FIND GN-TCMB WHERE GN-TCMB.FECHA = U-DIA-MES
NO-LOCK NO-ERROR.

IF AVAIL GN-TCMB THEN ASSIGN   XfTpoCmb-Compra = GN-TCMB.COMPRA
                               XfTpoCmb-Venta  = GN-TCMB.VENTA.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE borra-movimiento-anterior DIALOG-1
PROCEDURE borra-movimiento-anterior :
x-msg1 = "Eliminando Movimiento Anterior".
DISPLAY x-msg1 WITH FRAME F-MENSAJE.
PAUSE 0.
FOR EACH cb-dmov WHERE cb-dmov.Codcia  = s-codcia  AND
                       cb-dmov.Periodo = s-periodo     AND
                       cb-dmov.NroMes  = s-NroMes     AND
                       cb-dmov.CodOpe  = XsCodOpe  AND
                       cb-dmov.NroAst  = XsNroAst :
    RUN cbd/cb-acmd(RECID(cb-dmov),NO,YES).
    DELETE cb-dmov.
END.
FIND cb-cmov WHERE cb-cmov.CODCIA  = s-codcia AND
                   cb-cmov.PERIODO = s-periodo    AND
                   cb-cmov.NROMES  = s-NroMes    AND
                   cb-cmov.CODOPE  = XsCodOpe AND
                   cb-cmov.NROAST  = XsNroAst
                   NO-ERROR.
IF AVAIL cb-cmov THEN DELETE cb-cmov.
CREATE cb-cmov.
ASSIGN
        cb-cmov.CodCia  = s-codcia
        cb-cmov.Periodo = s-periodo
        cb-cmov.NroMes  = s-NroMes
        cb-cmov.CodOpe  = XsCodOpe
        cb-cmov.NroAst  = XsNroAst
        cb-cmov.CodMon  = XcCodMon
        cb-cmov.NotAst  = "Asiento Automatico Dif/Cambio"
        cb-cmov.GloAst  = "Asiento Automatico Dif/Cambio".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CTA10 DIALOG-1
PROCEDURE CTA10 :
XfSdoMn1  = 0.
       XfSdoMn2  = 0.
       XfSdoAjte = 0.
       x-clfaux = cb-ctas.clfaux.
       x-codaux = "".
       x-coddoc = "".
       x-nrodoc = "".
       x-nroref = "".
       x-fchdoc = ?.
       x-fchvto = ?.
FOR EACH cb-dmov WHERE cb-dmov.CODCIA   = s-codcia     AND
                       cb-dmov.PERIODO  = s-periodo        AND
                       cb-dmov.NROMES  <= s-NroMes        AND
                       cb-dmov.CODCTA   = X-CODCTA  :
    XfSdoMn1 = IF TPOMOV THEN XfSdoMn1 - ImpMn1 ELSE XfSdoMn1 + ImpMn1.
    XfSdoMn2 = IF TPOMOV THEN XfSdoMn2 - ImpMn2 ELSE XfSdoMn2 + ImpMn2.
END.

IF cb-ctas.TpoCmb = 3  THEN
    IF XfSdoMn1  > 0 THEN XfTpoCmb = XfTpoCmb-Compra.
                     ELSE XfTpoCmb = XfTpoCmb-Venta.

    X-GloDoc = "AJUSTE x D.C./" + STRING(XfTpoCmb,"ZZZZ9.9999").
    XfSdoAjte = ROUND(XfSdoMn2 * XfTpoCmb - XfSdoMn1,2).
    IF (XfSdoAjte <> 0 AND XfSdoAjte <> ?) THEN DO:
    IF XfSdoAjte > 0 THEN XfSdoAct = XfSdoAct + XfSdoAjte.
                     ELSE XfSdoPas = XfSdoPas + XfSdoAjte.
    IF XfSdoAjte > 0 THEN DO:
             XfImpMn1 = XfSdoAjte.
             XfImpMn2 = 0.
             XlTpoMov = FALSE.
    END.
    ELSE DO:
             XfImpMn1 = ABS(XfSdoAjte).
             XfImpMn2 = 0.
             XlTpoMov = TRUE.
    END.
    XiNroItm = XiNroItm + 1.
    RUN GRABA.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CTA10-DIVISION DIALOG-1
PROCEDURE CTA10-DIVISION :
ASSIGN
       XfSdoMn1  = 0
       XfSdoMn2  = 0
       XfSdoAjte = 0
       x-clfaux = cb-ctas.clfaux
       x-codaux = ""
       x-coddoc = ""
       x-nrodoc = ""
       x-nroref = ""
       x-fchdoc = ?
       x-fchvto = ?
       X-GloDoc = "AJUSTE x TRASLACION TC./" + STRING(XfTpoCmb,"ZZZZ9.9999").

FOR EACH cb-dmov NO-LOCK
                 WHERE cb-dmov.CODCIA   = s-codcia     AND
                       cb-dmov.PERIODO  = s-periodo    AND
                       cb-dmov.NROMES  <= s-NroMes     AND
                       cb-dmov.CODCTA   = X-CODCTA     AND
                       cb-dmov.coddiv   = x-div :
    XfSdoMn1 = IF cb-dmov.TPOMOV THEN XfSdoMn1 - cb-dmov.ImpMn1 ELSE XfSdoMn1 + cb-dmov.ImpMn1.
    XfSdoMn2 = IF cb-dmov.TPOMOV THEN XfSdoMn2 - cb-dmov.ImpMn2 ELSE XfSdoMn2 + cb-dmov.ImpMn2.
END.
IF cb-ctas.TpoCmb = 3  THEN
  IF XfSdoMn1  > 0 THEN XfTpoCmb = XfTpoCmb-Compra.
                   ELSE XfTpoCmb = XfTpoCmb-Venta.


XfSdoAjte = ROUND(XfSdoMn1 / XfTpoCmb - XfSdoMn2,2).

IF (XfSdoAjte <> 0 AND XfSdoAjte <> ?) THEN DO:
        IF XfSdoAjte > 0 THEN XfSdoAct = XfSdoAct + XfSdoAjte.
                         ELSE XfSdoPas = XfSdoPas + XfSdoAjte.
        IF XfSdoAjte > 0 THEN DO:
             XfImpMn1 = 0.
             XfImpMn2 = XfSdoAjte.
             XlTpoMov = FALSE.
        END.
        ELSE DO:
             XfImpMn1 = 0.
             XfImpMn2 = ABS(XfSdoAjte).
             XlTpoMov = TRUE.
        END.
        XiNroItm = XiNroItm + 1.
        RUN GRABA.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CtaCte DIALOG-1
PROCEDURE CtaCte :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

FOR EACH cb-dmov WHERE cb-dmov.CODCIA   = s-codcia     AND
                       cb-dmov.PERIODO  = s-periodo        AND
                       cb-dmov.NROMES  <= s-NroMes        AND
                       cb-dmov.CODCTA   = X-CODCTA
                       BREAK BY CODAUX
                             BY CODDOC
                             BY NRODOC :
    IF FIRST-OF(NRODOC) THEN DO:
       XfSdoMn1  = 0.
       XfSdoMn2  = 0.
       XfSdoAjte = 0.
       X-ClfAux = CLFAUX.
       X-CodAux = CODAUX.
       X-CodDoc = CODDOC.
       X-NroDoc = NRODOC.
       X-NroRef = NROREF.
    END.

    XfSdoMn1 = IF TPOMOV THEN XfSdoMn1 - ImpMn1 ELSE XfSdoMn1 + ImpMn1.
    XfSdoMn2 = IF TPOMOV THEN XfSdoMn2 - ImpMn2 ELSE XfSdoMn2 + ImpMn2.

    IF LAST-OF(NroDoc)  THEN  DO:
       IF cb-ctas.TpoCmb = 3  THEN
          IF XfSdoMn1  > 0 THEN XfTpoCmb = XfTpoCmb-Compra.
                           ELSE XfTpoCmb = XfTpoCmb-Venta.
       X-GloDoc = "AJUSTE x D.C./" + STRING(XfTpoCmb,"ZZZZ9.9999").
       XfSdoAjte = ROUND(XfSdoMn2 * XfTpoCmb - XfSdoMn1,2).
       IF (XfSdoAjte <> 0 AND XfSdoAjte <> ?) THEN DO:
         IF XfSdoAjte > 0 THEN XfSdoAct = XfSdoAct + XfSdoAjte.
         ELSE                  XfSdoPas = XfSdoPas + XfSdoAjte.
         IF XfSdoAjte > 0 THEN DO:
             XfImpMn1 = XfSdoAjte.
             XfImpMn2 = 0.
             XlTpoMov = FALSE.
         END.
         ELSE DO:
             XfImpMn1 = ABS(XfSdoAjte).
             XfImpMn2 = 0.
             XlTpoMov = TRUE.
         END.
         XiNroItm = XiNroItm + 1.
         RUN GRABA.
    END. /*FIN DEL LAST-OF*/
    END.
END. /* FIN DEL FOR EACH cb-dmov  GENERAL */
  /*

   IF ABS(SdoAjte) > 0 .AND. LiCodMon = 2
      DO CASE
         CASE SdoAjte > 0
            SdoAct = SdoAct + SdoAjte
         OTHER
            SdoPas = SdoPas + SdoAjte
      ENDCASE
      IF SdoAjte > 0
         XfImport = SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "D"
      ELSE
         XfImport = -SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "H"
      ENDIF
      XiNroItm = XiNroItm + 1
      RegAct1  = Recno()
      SET ORDER TO RMOV01
      DO GRABA
      SELECT RMOV
      SET ORDER TO RMOV06
      GOTO RegAct1
   ENDIF
   SELECT RMOV
ENDDO
RETURN
*/

END PROCEDURE.

/*
IF CTAS->TpoCmb = 1
   fTpoCmb = XfTC_Cmp
ELSE
   fTpoCmb = XfTC_Vta
ENDIF
IF CTAS->CodMon = 2   .AND. INLIST(XsCodCta,"10")
   DO CBDAcumd WITH XsCodCta , 0 , _Mes
   SdoNac  =  XvCalc(6 )
   SdoExt  =  XvCalc(12)
   IF CTAS->TpoCmb = 3
      IF SdoExt > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   SdoAjte = ROUND(SdoExt*fTpoCmb - SdoNac,2)
   IF SdoAjte <> 0
      DO CASE
         CASE SdoAjte > 0
            SdoAct = SdoAct + SdoAjte
         OTHER
            SdoPas = SdoPas + SdoAjte
      ENDCASE
      IF SdoAjte > 0
         XfImport = SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "D"
      ELSE
         XfImport = -SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "H"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
ELSE
   DO ActCtCte
ENDIF
RETURN
**********************************************************************
* GRABA AUTOMATICAS
**********************************************************************
PROCEDURE GRABA
**** Grabando la linea activa ****
XcEliItm = " "
DO MOVbgrab in CBDMMOVM
DO PINTALIN
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   RETURN
ENDIF
**** Actualizando Cuentas Automÿticas ****
XcEliItm = "£"
TsClfAux = "04 "
TsCodAux = CTAS->TpoGto
TsAn1Cta = RMOV->CodAux
TsCC1Cta = CTAS->CC1Cta
  ** Verificamos su existencia **
IF ! SEEK(TsAn1Cta,"CTAS")
   GsMsgErr = "Cuenta Automÿtica no existe. Actualizaci½n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Automÿtica no existe. Actualizaci½n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
XiNroItm = XiNroItm + 1
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbgrab in CBDMMOVM
DO PINTALIN
XiNroItm = XiNroItm + 1
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = ""
XsCodAux = ""
DO MOVbgrab in CBDMMOVM
DO PINTALIN
RETURN
**********************************************************************
* Genera el Item por Diferencia de Cambio cuando existe Cta.Cte.
**********************************************************************
PROCEDURE ActCtCte
******************
**** Buscamos si existe la cuenta en TPRO ***
SELECT PROV
GOTO TOP
DO WHILE ! EOF()
   IF XsCodCta$CodCta
      EXIT
   ENDIF
   SKIP
ENDDO
SELECT RMOV
SET ORDER TO RMOV06
SEEK XsCodCta
CiCodMon = CTAS->CodMon
CiTpoCmb = CTAS->TpoCmb

DO WHILE CodCta = XsCodCta .AND. !EOF()
   XsClfAux = ClfAux
   XsCodAux = CodAux
   XsNroDoc = NroDoc
   XsNroRef = NroRef
   IF CiCodMon = 2
      LiCodMon = 2
   ELSE
      LiCodMon = CodMon
   ENDIF
   Llave  = XsCodCta+XsCodAux+XsNroDoc
   LfSdoNac = 0
   LfSdoExt = 0
   DO WHILE LLave = ( CodCta+CodAux+Nrodoc ) .AND. ! EOF()
      IF VAL(NroMes) <= _Mes
         IF CodOpe == PROV->CodOpe
            IF CiCodMon # 2
               LiCodMon = CodMon
            ENDIF
         ENDIF
         IF TpoMov = "H"
            LfSdoNac = LfSdoNac - Import
            LfSdoExt = LfSdoExt - ImpUsa
         ELSE
            LfSdoNac = LfSdoNac + Import
            LfSdoExt = LfSdoExt + ImpUsa
         ENDIF
      ENDIF
      SKIP
   ENDDO
   IF CiTpoCmb = 3
      IF LfSdoNac > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   SALDO   = LfSdoExt*fTpoCmb
   SdoAjte = ROUND(Saldo - LfSdoNac , 2)
   IF ABS(SdoAjte) > 0 .AND. LiCodMon = 2
      DO CASE
         CASE SdoAjte > 0
            SdoAct = SdoAct + SdoAjte
         OTHER
            SdoPas = SdoPas + SdoAjte
      ENDCASE
      IF SdoAjte > 0
         XfImport = SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "D"
      ELSE
         XfImport = -SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "H"
      ENDIF
      XiNroItm = XiNroItm + 1
      RegAct1  = Recno()
      SET ORDER TO RMOV01
      DO GRABA
      SELECT RMOV
      SET ORDER TO RMOV06
      GOTO RegAct1
   ENDIF
   SELECT RMOV
ENDDO
RETURN
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CTACTE-DIVISION DIALOG-1
PROCEDURE CTACTE-DIVISION :
FOR EACH cb-dmov WHERE cb-dmov.CODCIA   = s-codcia     AND
                       cb-dmov.PERIODO  = s-periodo    AND
                       cb-dmov.NROMES  <= s-NroMes     AND
                       cb-dmov.CODCTA   = X-CODCTA     AND
                       cb-dmov.coddiv   = x-div
                       BREAK BY CODAUX
                             BY CODDOC
                             BY NRODOC :
    IF FIRST-OF(NRODOC) THEN DO:
       XfSdoMn1  = 0.
       XfSdoMn2  = 0.
       XfSdoAjte = 0.
       X-ClfAux = CLFAUX.
       X-CodAux = CODAUX.
       X-CodDoc = CODDOC.
       X-NroDoc = NRODOC.
       X-NroRef = NROREF.
    END.

    XfSdoMn1 = IF TPOMOV THEN XfSdoMn1 - ImpMn1 ELSE XfSdoMn1 + ImpMn1.
    XfSdoMn2 = IF TPOMOV THEN XfSdoMn2 - ImpMn2 ELSE XfSdoMn2 + ImpMn2.

    IF LAST-OF(NroDoc)  THEN  DO:
       IF cb-ctas.TpoCmb = 3  THEN
          IF XfSdoMn1  > 0 THEN XfTpoCmb = XfTpoCmb-Compra.
                           ELSE XfTpoCmb = XfTpoCmb-Venta.
       X-GloDoc = "AJUSTE x T.R./" + STRING(XfTpoCmb,"ZZZZ9.9999").
       XfSdoAjte = ROUND(XfSdoMn1 / XfTpoCmb - XfSdoMn2,2).
       IF (XfSdoAjte <> 0 AND XfSdoAjte <> ?) THEN DO:
         IF XfSdoAjte > 0 THEN XfSdoAct = XfSdoAct + XfSdoAjte.
         ELSE                  XfSdoPas = XfSdoPas + XfSdoAjte.
         IF XfSdoAjte > 0 THEN DO:
             XfImpMn2 = XfSdoAjte.
             XfImpMn1 = 0.
             XlTpoMov = FALSE.
         END.
         ELSE DO:
             XfImpMn2 = ABS(XfSdoAjte).
             XfImpMn1 = 0.
             XlTpoMov = TRUE.
         END.
         XiNroItm = XiNroItm + 1.
         RUN GRABA.
    END. /*FIN DEL LAST-OF*/
    END.
END. /* FIN DEL FOR EACH cb-dmov  GENERAL */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 XfTpoCmb-Compra XfTpoCmb-Venta
      WITH FRAME DIALOG-1.
  IF AVAILABLE integral.cb-cfgg THEN
    DISPLAY integral.cb-cfgg.Codope integral.cb-cfgg.codcta[1]
          integral.cb-cfgg.codcta[2] integral.cb-cfgg.codaux[1]
          integral.cb-cfgg.codaux[2] integral.cb-cfgg.codcta[3]
      WITH FRAME DIALOG-1.
  IF AVAILABLE integral.cb-cmov THEN
    DISPLAY integral.cb-cmov.Periodo integral.cb-cmov.Nromes
      WITH FRAME DIALOG-1.
  IF AVAILABLE integral.Empresas THEN
    DISPLAY integral.Empresas.NomCia
      WITH FRAME DIALOG-1.
  ENABLE RECT-12 B-ACEPTAR RECT-13 B-Cancelar XfTpoCmb-Compra XfTpoCmb-Venta
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE graba DIALOG-1
PROCEDURE graba :
CREATE DETALLE.
ASSIGN  DETALLE.CodCia  = s-codcia
        DETALLE.Periodo = s-periodo
        DETALLE.NroMes  = s-NroMes
        DETALLE.CodOpe  = XsCodOpe
        DETALLE.NroAst  = XsNroAst
        DETALLE.CodCta  = x-codcta
        DETALLE.CodDiv  = x-Div
        DETALLE.GloDoc  = x-glodoc
        DETALLE.ClfAux  = x-clfaux
        DETALLE.CodAux  = x-codaux
        DETALLE.CodDoc  = x-coddoc
        DETALLE.NroDoc  = x-nrodoc
        DETALLE.NroRef  = x-nroref
        DETALLE.FchDoc  = x-fchdoc
        DETALLE.FchVto  = x-fchvto
        DETALLE.NroItm  = XiNroItm
        DETALLE.TpoMov  = XlTpoMov
        DETALLE.ImpMn1  = 0
        DETALLE.ImpMn2  = XfImpMn2
        DETALLE.RELACION = X-RECID
        DETALLE.TpoItm   = x-TpoItm
        DETALLE.FlgAct  = YES.

IF DETALLE.TPOMOV THEN cb-cmov.HBEMN2 = cb-cmov.HBEMN2 + DETALLE.IMPMN2.
ELSE                   cb-cmov.DBEMN2 = cb-cmov.DBEMN2 + DETALLE.IMPMN2.

RUN cbd/cb-acmd(RECID(DETALLE),YES,NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCEDE DIALOG-1
PROCEDURE PROCEDE :
HIDE FRAME {&FRAME-NAME}.
RUN borra-movimiento-anterior.
X-RECID = ?.
XiNroItm = 0 .

FOR EACH GN-DIVI
    WHERE GN-DIVI.CODCIA = S-CODCIA
    AND   LENGTH(GN-DIVI.CODDIV) = 5
    NO-LOCK :
  ASSIGN
        XfSdoPas = 0
        XfSDoAct = 0.

FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.CodCia = cb-codcia         AND
                               LENGTH(cb-ctas.CodCta) = l-CtaMov  AND
                               cb-ctas.AftDcb                     AND
                               cb-ctas.CodMon <> 2                AND
                               cb-ctas.CodCta < "6" :

   IF cb-ctas.TpoCmb = 1 THEN XfTpoCmb = XfTpoCmb-Compra.
   ELSE                       XfTpoCmb = XfTpoCmb-Venta .
   x-msg2 = "Cuenta   : " + cb-ctas.Codcta.
   x-msg1 = "Divisi¢n : " + gn-divi.coddiv.
   DISPLAY x-msg1
           x-msg2
           WITH FRAME F-MENSAJE.
   PAUSE 0.
   x-codcta = cb-ctas.CodCta.
   x-div    = gn-divi.coddiv.
   IF cb-ctas.CodCta BEGINS "10" THEN
        RUN CTA10-DIVISION.
   ELSE RUN CTACTE-DIVISION.

END. /*FIN DEL FOR EACH CUENTAS*/

IF XfSdoPas <> 0 THEN DO:
   x-codcta = XsCodCta-67.
   x-codaux = XsCodAux-67.
   x-coddoc = "".
   x-nrodoc = "".
   x-nroref = "".
   x-fchdoc = ?.
   x-fchvto = ?.
   x-glodoc = "Ajuste Automatico Traslaci¢n".
   XfImpMn2 = ABS(XfSdoPas).
   XfImpMn1 = 0.
   XlTpoMov = FALSE.
   find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
                      cb-ctas.codCta = x-CodCta
                      NO-LOCK NO-ERROR.
   X-ClfAux = "".
   IF avail cb-ctas THEN DO:
      IF cb-ctas.PIDAUX THEN X-ClfAux = cb-ctas.ClfAux.
   END.

   XiNroItm = XiNroItm + 1.
   run GRABA.

   /*CUENTA 9X*/
   X-RECID = RECID(DETALLE).
   x-TpoItm = "A".
   x-codcta = XsCodAux-67.
   x-codaux = "".
   x-coddoc = "".
   x-nrodoc = "".
   x-nroref = "".
   x-fchdoc = ?.
   x-fchvto = ?.
   x-glodoc = "Ajuste Automatico Traslaci¢n".
   XfImpMn2 = ABS(XfSdoPas).
   XfImpMn1 = 0.
   XlTpoMov = FALSE.
   find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
                      cb-ctas.codCta = x-CodCta
                      NO-LOCK NO-ERROR.
   X-ClfAux = "".
   IF avail cb-ctas THEN DO:
      IF cb-ctas.PIDAUX THEN X-ClfAux = cb-ctas.ClfAux.
   XiNroItm = XiNroItm + 1.
   run GRABA.
   END.
   /*Cuenta 79*/
   x-codcta = XsCodCta-79.
   x-codaux = "".
   x-coddoc = "".
   x-nrodoc = "".
   x-nroref = "".
   x-fchdoc = ?.
   x-fchvto = ?.
   x-glodoc = "Ajuste Automatico Traslaci¢n".
   XfImpMn2 = ABS(XfSdoPas).
   XfImpMn1 = 0.
   XlTpoMov = TRUE.
   find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
                      cb-ctas.codCta = x-CodCta
                      NO-LOCK NO-ERROR.
   X-ClfAux = "".
   IF avail cb-ctas THEN DO:
      IF cb-ctas.PIDAUX THEN X-ClfAux = cb-ctas.ClfAux.
   XiNroItm = XiNroItm + 1.
   run GRABA.
   END.
END.
X-RECID = ?.
x-TpoItm = "".
IF XfSdoAct <> 0 THEN DO:
   x-codcta = XsCodCta-77.
   x-codaux = XsCodAux-77.
   x-coddoc = "".
   x-nrodoc = "".
   x-nroref = "".
   x-fchdoc = ?.
   x-fchvto = ?.
   x-glodoc = "Ajuste Automatico Traslaci¢n".
   XfImpMn2 = ABS(XfSdoAct).
   XfImpMn1 = 0.
   XlTpoMov = TRUE.
   find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
                      cb-ctas.codCta = x-CodCta
                      NO-LOCK NO-ERROR.
   X-ClfAux = "".
   IF avail cb-ctas THEN DO:
      IF cb-ctas.PIDAUX THEN X-ClfAux = cb-ctas.ClfAux.
   END.
   XiNroItm = XiNroItm + 1.
   run GRABA.
END.

END. /* FIN DEL FOR EACH DIVISIONES */
ASSIGN CB-CMOV.TOTITM = XiNroItm.

HIDE FRAME F-MENSAJE.
MESSAGE "Proceso Completado"
        VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


