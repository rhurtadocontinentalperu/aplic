&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w

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

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR Cb-CodCia AS INTEGER.
DEFINE SHARED VAR Cl-CodCia AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHARACTER.
DEFINE SHARED VAR s-Periodo  AS INTEGER.
DEFINE SHARED VAR s-user-id AS CHAR.
/* Definimos Variables de impresoras */



/* Local Variable Definitions ---                                       */

DEFINE VARIABLE C-FLGEST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

DEFINE VAR C-BIMP AS CHAR.
DEFINE VAR C-ISC  AS CHAR.
DEFINE VAR C-IGV  AS CHAR.
DEFINE VAR C-TOT  AS CHAR.

/* BUSCANDO LAS CONFIGURACIONES DEL LIBRO DE VENTAS */

FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
     NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
   MESSAGE "No esta configurado el registro de Ventas" VIEW-AS 
   ALERT-BOX ERROR.
   RETURN.
END.

/* Configuraciones */
C-BIMP = cb-cfgg.CODCTA[1].
C-ISC  = cb-cfgg.CODCTA[2].
C-IGV  = cb-cfgg.CODCTA[3].
C-TOT  = cb-cfgg.CODCTA[4].

/* Definicion del Frame de Imprsión y sus Variables  */

DEFINE VAR x-CodDiv AS CHAR.
DEFINE VAR x-NroAst AS CHAR.
DEFINE VAR x-FchDoc AS DATE.
DEFINE VAR x-CodDoc AS CHAR.
DEFINE VAR x-NroDoc AS CHAR.
DEFINE VAR x-Ruc    AS CHAR.
DEFINE VAR x-NomCli AS CHAR.
DEFINE VAR x-Import AS DECIMAL EXTENT 10.
DEFINE VAR x-CodRef AS CHAR.
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-CodMon AS CHAR.
DEFINE VAR x-CodOpe AS CHAR.

/* OTRAS VARIABLES */

DEFINE VAR x-DesMes AS CHAR.

DEFINE TEMP-TABLE Registro
   FIELD CodOpe AS CHAR
   FIELD CodCia AS CHAR
   FIELD CodDiv AS CHAR
   FIELD NroAst AS CHAR
   FIELD FchDoc AS DATE
   FIELD CodDoc AS CHAR
   FIELD NroDoc AS CHAR
   FIELD CodRef AS CHAR
   FIELD NroRef AS CHAR
   FIELD NotDeb AS CHAR
   FIELD NotCre AS CHAR
   FIELD Ruc    AS CHAR
   FIELD NomCli AS CHAR
   FIELD CodMon AS CHAR
   FIELD Cco    AS CHAR
   FIELD Implin AS DECIMAL EXTENT 10.

DEFINE BUFFER B-Registro FOR Registro.
DEFINE TEMP-TABLE T-Registro LIKE Registro.

DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov.
DEFINE BUFFER B-prev  FOR t-prev.
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-Docum FOR FacDocum.
DEFINE TEMP-TABLE t-cmov LIKE CB-CMOV.
DEFINE TEMP-TABLE t-dmov LIKE CB-DMOV.
DEFINE TEMP-TABLE t-cdoc LIKE CcbCDocu.

DEFINE VAR x-ctaigv  AS CHAR NO-UNDO.
DEFINE VAR x-ctadto  AS CHAR NO-UNDO.
DEFINE VAR x-ctaisc  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.
DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.

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
        x-ctadto = cb-cfgg.codcta[10].
     END.
  ELSE DO:
     MESSAGE 'Configuracion de Registro de Ventas no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

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
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-12 x-Div s-CodOpe Btn_OK ~
Btn_Cancel BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS C-CodMon x-Div s-CodOpe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE s-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operaciones" 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 10 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.29 BY 3.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-CodMon AT ROW 2.23 COL 2.43 NO-LABEL
     x-Div AT ROW 2.35 COL 26 COLON-ALIGNED
     s-CodOpe AT ROW 3.12 COL 18.57
     Btn_OK AT ROW 6 COL 6
     Btn_Cancel AT ROW 6 COL 20
     BUTTON-1 AT ROW 6 COL 34
     "Moneda" VIEW-AS TEXT
          SIZE 7.14 BY .65 AT ROW 1.42 COL 2.86
     RECT-20 AT ROW 1.65 COL 1.72
     RECT-12 AT ROW 1.73 COL 15.72
     SPACE(1.70) SKIP(2.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas".


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR RADIO-SET C-CodMon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-CodOpe IN FRAME D-Dialog
   ALIGN-L                                                              */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas */
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
  ASSIGN C-CodMon s-CodOpe x-Div.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Button 1 */
DO:
  ASSIGN C-CodMon s-CodOpe x-Div.
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */  
  {src/adm/template/dialogmn.i}

  FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
       NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN DO:
     s-CodOpe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asiento-Detallado D-Dialog 
PROCEDURE Asiento-Detallado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR p-codcia  AS INTE NO-UNDO.
DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
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

DEFINE BUFFER detalle FOR t-dmov.

p-codcia  = s-codcia.
p-periodo = s-periodo.
p-mes     = s-nromes.

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
/*   BELL.
 *    MESSAGE "No se ha generado " SKIP "ning£n preasiento" VIEW-AS ALERT-BOX ERROR.*/
   RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
/*   BELL.
 *    MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.*/
   RETURN.
END.

FOR EACH t-prev BREAK BY t-prev.coddiv 
                      BY t-prev.fchdoc
                      BY t-prev.coddoc 
                      BY t-prev.nrodoc:
/*    display t-prev.coddiv t-prev.codope t-prev.nroast t-prev.coddoc t-prev.nrodoc t-prev.codaux t-prev.codcta t-prev.tm t-prev.impmn1
 *         with stream-io no-box width 200.*/
    IF FIRST-OF(t-prev.fchdoc) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       p-codope = t-prev.codope.
    END.
    IF FIRST-OF(t-prev.nrodoc) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       p-codope = t-prev.codope.
       p-nroast = t-prev.nroast.    /* OJO */
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
      DO:
        J = J + 1.
        CREATE t-dmov.
        t-dmov.codcia  = p-codcia.
        t-dmov.PERIODO = p-periodo.
        t-dmov.NROMES  = p-mes.
        t-dmov.CODOPE  = p-codope.
        t-dmov.NROAST  = p-nroast.
        t-dmov.NROITM  = J.
        t-dmov.codcta  = t-prev.codcta.
        t-dmov.coddiv  = t-prev.coddiv.
        t-dmov.cco     = t-prev.cco.
        t-dmov.Coddoc  = t-prev.coddoc.
        t-dmov.Nrodoc  = t-prev.nrodoc.
        t-dmov.clfaux  = x-clfaux.
        t-dmov.codaux  = t-prev.codaux.
        t-dmov.Nroruc  = t-prev.nroruc.
        t-dmov.GLODOC  = t-prev.glodoc.
        t-dmov.tpomov  = t-prev.tpomov.
        t-dmov.impmn1  = t-prev.impmn1.
        t-dmov.impmn2  = t-prev.impmn2.
        t-dmov.FCHDOC  = t-prev.Fchdoc.
        t-dmov.FCHVTO  = t-prev.Fchvto.
        t-dmov.FLGACT  = TRUE.
        t-dmov.RELACION = 0.
        t-dmov.TM      = t-prev.tm.
        t-dmov.codmon  = t-prev.codmon.
        t-dmov.tpocmb  = t-prev.tpocmb.
        t-dmov.codref  = t-prev.codref.
        t-dmov.nroref  = t-prev.nroref.
        IF t-dmov.tpomov THEN DO:
            h-uno = h-uno + t-dmov.impmn1.
            h-dos = h-dos + t-dmov.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + t-dmov.impmn1.
            d-dos = d-dos + t-dmov.impmn2.
        END.
    END.
    IF LAST-OF(t-prev.nrodoc) THEN DO:
       FIND t-cmov WHERE
           t-cmov.codcia  = p-codcia AND
           t-cmov.PERIODO = p-periodo AND
           t-cmov.NROMES  = p-mes AND
           t-cmov.CODOPE  = p-codope AND
           t-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE t-cmov THEN DO:
           CREATE t-cmov.
           t-cmov.codcia  = p-codcia.
           t-cmov.PERIODO = p-periodo.
           t-cmov.NROMES  = p-mes.
           t-cmov.CODOPE  = p-codope.
           t-cmov.NROAST  = p-nroast. 
       END.
       t-cmov.Coddiv = t-prev.coddiv.
       t-cmov.Fchast = t-prev.fchdoc.
       t-cmov.TOTITM = J.
       t-cmov.CODMON = t-prev.codmon.
       t-cmov.TPOCMB = t-prev.tpocmb.
       t-cmov.DBEMN1 = d-uno.
       t-cmov.DBEMN2 = d-dos.
       t-cmov.HBEMN1 = h-uno.
       t-cmov.HBEMN2 = h-dos.
       t-cmov.NOTAST = 'Provision al ' + STRING(t-prev.fchdoc).
       t-cmov.GLOAST = 'Provision al ' + STRING(t-prev.fchdoc).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CAPTURA D-Dialog 
PROCEDURE CAPTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR ii       AS INTEGER NO-UNDO.
  DEFINE VAR iii      AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR y-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR y-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR x-Cco    AS CHAR    NO-UNDO.

  DEFINE VAR x-CodCta AS CHAR.

  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH t-cmov NO-LOCK WHERE t-cmov.CodCia  = s-CodCia  AND
                                     t-cmov.Periodo = s-Periodo AND
                                     t-cmov.NroMes  = s-NroMes  AND
                                     t-cmov.CodOpe  = x-CodOpe
                                     BREAK BY t-cmov.NroAst :
          x-NroAst = t-cmov.NroAst.
          FOR EACH t-dmov OF t-cmov NO-LOCK BREAK BY t-dmov.CodDiv :
              IF FIRST-OF (t-dmov.CodDiv) THEN DO :
                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-Import[9] = 0.
                 x-CodDiv = t-dmov.CodDiv.
                 x-Cco    = ''.
              END.
              IF NOT tpomov THEN DO:
                 y-debe  = ImpMn2.
                 y-haber = 0.
                 CASE c-codmon:
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
                  y-haber = ImpMn2.
                  y-Debe  = 0.
                  CASE c-codmon:
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
              
              x-Cco = IF x-Cco = '' THEN t-dmov.Cco ELSE x-Cco.
              
              DO ii = 1 TO NUM-ENTRIES(C-BIMP) :
                 x-CodCta = ENTRY(ii,C-BIMP).
                 IF t-dmov.CodCta BEGINS x-CodCta THEN DO :                    
                    IF t-dmov.TM = 1 THEN DO :
                       x-Import[1] = x-Import[1] + (x-Haber - x-Debe).
                       x-Import[4] = x-Import[4] + (x-Haber - x-Debe).
                    END.   
                    IF t-dmov.TM = 2 THEN DO :
                       x-Import[2] = x-Import[2] + (x-Haber - x-Debe).
                    END.   

                 END.
              END.   
              
              IF t-dmov.CodCta BEGINS C-ISC OR 
                 LOOKUP(t-dmov.CodCta,C-ISC) > 0 THEN DO :
                 x-Import[3] = x-Import[3] + (x-Haber - x-Debe).
              END.  
                   
              IF t-dmov.CodCta BEGINS C-IGV OR 
                 LOOKUP(t-dmov.CodCta,C-IGV) > 0 THEN DO :
                 x-Import[5] = x-Import[5] + (x-Haber - x-Debe).
              END.  
              
              DO iii = 1 TO NUM-ENTRIES(C-TOT):
                x-CodCta = ENTRY(iii,C-TOT) .
                IF t-dmov.codcta BEGINS x-CodCta THEN DO:
                    x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
                    x-import[9] = x-import[9] + (y-Debe - y-Haber).
                    x-FchDoc = t-dmov.FchDoc.
                    x-CodDoc = t-dmov.CodDoc.
                    x-NroDoc = t-dmov.NroDoc.
                    x-CodMon = IF t-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                    x-NomCli = t-dmov.GloDoc.
                    x-Ruc    = t-dmov.NroRuc.
                    x-CodRef = t-dmov.CodRef.
                    x-NroRef = t-dmov.NroRef.
                    FIND GN-CLIE WHERE 
                         GN-CLIE.CodCia = cl-codcia AND
                         GN-CLIE.codcli = t-dmov.CodAux and 
                         GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
                    IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
                    ELSE x-NomCli = t-dmov.GloDoc.
                END.
              END.
/*              IF t-dmov.CodCta BEGINS C-TOT OR 
 *                  LOOKUP(t-dmov.CodCta,C-TOT) > 0 THEN DO :
 *                  x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
 *                  x-import[9] = x-import[9] + (y-Debe - y-Haber).
 *                  x-FchDoc = t-dmov.FchDoc.
 *                  x-CodDoc = t-dmov.CodDoc.
 *                  x-NroDoc = t-dmov.NroDoc.
 *                  x-CodMon = IF t-dmov.CodMon = 1 THEN "S/." ELSE "US$".
 *                  x-NomCli = t-dmov.GloDoc.
 *                  x-Ruc    = t-dmov.NroRuc.
 *                  x-CodRef = t-dmov.CodRef.
 *                  x-NroRef = t-dmov.NroRef.
 *                  FIND GN-CLIE WHERE 
 *                       GN-CLIE.CodCia = 0 AND
 *                       GN-CLIE.codcli = t-dmov.CodAux and 
 *                       GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
 *                  IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
 *                  ELSE x-NomCli = t-dmov.GloDoc.
 *               END.*/
              
              IF LAST-OF (t-dmov.CodDiv) THEN DO :
                 CREATE Registro.
                 Registro.CodOpe = x-CodOpe.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.FchDoc = x-FchDoc.
                 Registro.CodDoc = x-CodDoc.
                 CASE x-CodDoc :
                      WHEN "08" THEN Registro.NotDeb = x-NroDoc.
                      WHEN "08" THEN Registro.NotCre = x-NroDoc.
                      OTHERWISE Registro.NroDoc = x-NroDoc.
                 END CASE.
                 Registro.NroDoc = x-NroDoc.
                 Registro.CodRef = x-CodRef.
                 Registro.NroRef = x-NroRef.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.Cco    = x-Cco.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
                 Registro.ImpLin[9] = x-Import[9].
                 /* PARCHE 23.05.07 */
                 Registro.ImpLin[3] = 0.
                 Registro.ImpLin[1] = Registro.ImpLin[2] + Registro.ImpLin[3] + Registro.ImpLin[4].
              END.
              
          END. /* FIN DEL FOR t-dmov */        
                                     
      END. /* FIN DEL FOR t-cmov */
      
   END. /* FIN DEL DO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-2 D-Dialog 
PROCEDURE Captura-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH t-prev:
    DELETE t-prev.
  END.
  FOR EACH FacDocum WHERE FacDocum.CodCia = s-codcia NO-LOCK:
    IF FacDocum.CodDoc = 'FAC' THEN DO:
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

  /* Carga los asientos contables */
  RUN Asiento-Detallado.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-3 D-Dialog 
PROCEDURE Captura-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR ii       AS INTEGER NO-UNDO.
  DEFINE VAR iii      AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR y-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR y-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR x-Cco    AS CHAR    NO-UNDO.

  DEFINE VAR x-CodCta AS CHAR.

  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH t-cmov NO-LOCK WHERE t-cmov.CodOpe  = x-CodOpe BREAK BY t-cmov.NroAst :
        DISPLAY
            t-cmov.codope t-cmov.nroast SKIP
            WITH FRAME F-Mensaje VIEW-AS DIALOG-BOX CENTERED OVERLAY NO-LABELS 
                WIDTH 60 TITLE 'Cerrando Asientos'.
          x-NroAst = t-cmov.NroAst.
          FOR EACH t-dmov OF t-cmov NO-LOCK BREAK BY t-dmov.NroDoc:
              IF FIRST-OF (t-dmov.NroDoc) THEN DO :
                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-Import[9] = 0.
                 x-CodDiv = t-dmov.CodDiv.
                 x-Cco    = ''.
              END.
              IF NOT tpomov THEN DO:
                 y-debe  = ImpMn2.
                 y-haber = 0.
                 CASE c-codmon:
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
                  y-haber = ImpMn2.
                  y-Debe  = 0.
                  CASE c-codmon:
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
              
              x-Cco = IF x-Cco = '' THEN t-dmov.Cco ELSE x-Cco.
              
              DO ii = 1 TO NUM-ENTRIES(C-BIMP) :
                 x-CodCta = ENTRY(ii,C-BIMP).
                 IF t-dmov.CodCta BEGINS TRIM(x-CodCta) THEN DO :                    
                    IF t-dmov.TM = 1 THEN DO :
                       x-Import[1] = x-Import[1] + (x-Haber - x-Debe).
                       x-Import[4] = x-Import[4] + (x-Haber - x-Debe).
                    END.   
                    IF t-dmov.TM = 2 THEN DO :
                       /*IF t-dmov.coddiv = '00012' THEN x-Import[1] = x-Import[1] - (x-Haber - x-Debe).  /* RHC 31.08.06 */ */
                       x-Import[2] = x-Import[2] + (x-Haber - x-Debe).
                       /*
                       x-Import[4] = x-Import[4] - (x-Haber - x-Debe).  /* RHC 14.12.05 */
                       */
                    END.   

                 END.
              END.   
              
              DO ii = 1 TO NUM-ENTRIES(C-ISC) :
                 x-CodCta = ENTRY(ii,C-ISC).
                 IF t-dmov.CodCta BEGINS TRIM(x-CodCta) THEN DO :                    
                    x-Import[3] = x-Import[3] + (x-Haber - x-Debe).
                 END.
              END.   
                   
              IF t-dmov.CodCta BEGINS C-IGV OR 
                 LOOKUP(t-dmov.CodCta,C-IGV) > 0 THEN DO :
                 x-Import[5] = x-Import[5] + (x-Haber - x-Debe).
              END.  
              
              DO iii = 1 TO NUM-ENTRIES(C-TOT):
                x-CodCta = ENTRY(iii,C-TOT) .
                IF t-dmov.codcta BEGINS x-CodCta THEN DO:
                    x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
                    x-import[9] = x-import[9] + (y-Debe - y-Haber).
                    x-FchDoc = t-dmov.FchDoc.
                    x-CodDoc = t-dmov.CodDoc.
                    x-NroDoc = t-dmov.NroDoc.
                    x-CodMon = IF t-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                    x-NomCli = t-dmov.GloDoc.
                    x-Ruc    = t-dmov.NroRuc.
                    x-CodRef = t-dmov.CodRef.
                    x-NroRef = t-dmov.NroRef.
                    FIND GN-CLIE WHERE 
                         GN-CLIE.CodCia = 0 AND
                         GN-CLIE.codcli = t-dmov.CodAux and 
                         GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
                    IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
                    ELSE x-NomCli = t-dmov.GloDoc.
                END.
              END.
/*              IF t-dmov.CodCta BEGINS C-TOT OR 
 *                  LOOKUP(t-dmov.CodCta,C-TOT) > 0 THEN DO :
 *                  x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
 *                  x-import[9] = x-import[9] + (y-Debe - y-Haber).
 *                  x-FchDoc = t-dmov.FchDoc.
 *                  x-CodDoc = t-dmov.CodDoc.
 *                  x-NroDoc = t-dmov.NroDoc.
 *                  x-CodMon = IF t-dmov.CodMon = 1 THEN "S/." ELSE "US$".
 *                  x-NomCli = t-dmov.GloDoc.
 *                  x-Ruc    = t-dmov.NroRuc.
 *                  x-NroRef = t-dmov.NroRef.
 *                  FIND GN-CLIE WHERE 
 *                       GN-CLIE.CodCia = 0 AND
 *                       GN-CLIE.codcli = t-dmov.CodAux and 
 *                       GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
 *                  IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
 *                  ELSE x-NomCli = t-dmov.GloDoc.
 *               END.*/
              
              IF LAST-OF (t-dmov.NroDoc) THEN DO :
                 CREATE Registro.
                 Registro.CodOpe = x-CodOpe.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.FchDoc = x-FchDoc.
                 Registro.CodDoc = x-CodDoc.
                 CASE x-CodDoc :
                      WHEN "08" THEN Registro.NotDeb = x-NroDoc.
                      WHEN "08" THEN Registro.NotCre = x-NroDoc.
                      OTHERWISE Registro.NroDoc = x-NroDoc.
                 END CASE.
                 Registro.NroDoc = x-NroDoc.
                 Registro.NroRef = x-NroRef.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.Cco    = x-Cco.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
                 Registro.ImpLin[9] = x-Import[9].
                 /* PARCHE 23.05.07 */
                 Registro.ImpLin[3] = 0.
                 Registro.ImpLin[1] = Registro.ImpLin[2] + Registro.ImpLin[3] + Registro.ImpLin[4].
              END.
              
          END. /* FIN DEL FOR t-dmov */        
                                     
      END. /* FIN DEL FOR t-cmov */
      
   END. /* FIN DEL DO */
   HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-FAC-BOL D-Dialog 
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
DEFINE VAR x-detalle AS LOGICAL INIT YES NO-UNDO.
DEFINE VAR x-cco     AS CHAR    NO-UNDO.
DEFINE VAR x-nrodoc1 AS CHAR    NO-UNDO.
DEFINE VAR x-nrodoc2 AS CHAR    NO-UNDO.

X-nrodoc1 = ''.
X-nrodoc2 = ''.
x-cco     = ''.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.

FOR EACH t-cdoc:
    /* QUE PASA SI NO TIENE CENTRO DE COSTO */
    x-Cco = t-cdoc.Cco.
    IF x-Cco = ''
    THEN DO:        /* Buscamos por el vendedor */
        FIND GN-VEN OF t-cdoc NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-Cco = gn-ven.cco.
    END.
    /* RHC 12.11.04 Parche especial para Tda. 73 en San Miguel */
    IF x-Cco = '' AND t-cdoc.coddiv = '00012'
    THEN x-Cco = '25'.
    ASSIGN 
        T-CDOC.Cco = x-Cco.
END.

FOR EACH T-CDOC BREAK BY T-CDOC.Cco BY T-CDOC.FchDoc BY T-CDOC.NroDoc:
    DISPLAY
        x-div t-cdoc.coddiv t-cdoc.coddoc t-cdoc.nrodoc SKIP
        WITH FRAME F-Mensaje VIEW-AS DIALOG-BOX CENTERED OVERLAY NO-LABELS 
            WIDTH 60 TITLE 'Asiento de Facturas'.
    IF FIRST-OF(T-CDOC.cco) OR FIRST-OF(T-CDOC.FchDoc) 
    THEN ASSIGN
            x-cco     = T-CDOC.cco
            x-nrodoc1 = T-CDOC.nrodoc
            x-nrodoc2 = ''.
    X-nrodoc2 = T-CDOC.nrodoc.

    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = t-cdoc.CODCIA AND
                        Cb-cfgrv.CodDiv = t-cdoc.coddiv AND
                        Cb-cfgrv.Coddoc = t-cdoc.coddoc AND
                        Cb-cfgrv.Fmapgo = T-CDOC.Fmapgo AND
                        Cb-cfgrv.Codmon = T-CDOC.Codmon NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
      NEXT .
    END.
    ASSIGN
        X-codcta = Cb-cfgrv.Codcta.
        /*x-detalle = Cb-cfgrv.Detalle.*/
    IF T-CDOC.Flgest = 'A' THEN DO:
       x-codcta = IF T-CDOC.Coddoc = "FAC" THEN "121201" ELSE "121102".
       RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, 0, x-coddoc, 08, 01,x-detalle, x-cco).
       NEXT.        
    END.        
    
    RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpTot, x-coddoc, 08, T-CDOC.codmon,x-detalle, x-cco).

    /* CUENTA DE IGV */
    IF T-CDOC.ImpIgv > 0 THEN DO:
      x-codcta = x-ctaigv.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIgv, x-coddoc, 06, T-CDOC.codmon,x-detalle, x-cco).
    END.

   /* CUENTA DE ISC */
   IF T-CDOC.ImpIsc > 0 THEN DO:
      x-codcta = x-ctaisc.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIsc, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.
 
   /* CUENTA 70   --   Detalle  */
   IF T-CDOC.ImpBrt > 0 THEN DO:
      CASE T-CDOC.Tipo:
         WHEN 'Servicio' THEN x-codcta = cb-cfgg.codcta[9].
         OTHERWISE x-codcta = cb-cfgg.codcta[5].
      END.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpBrt, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.

   IF T-CDOC.ImpDto > 0 THEN DO:
      x-codcta = x-ctadto.
      RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpDto, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.

   IF T-CDOC.ImpExo > 0 THEN DO:
      x-codcta = cb-cfgg.codcta[6]. 
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpExo, x-coddoc, 02, T-CDOC.codmon,x-detalle, x-cco).
   END.
       
    CASE T-CDOC.TpoFac:
        WHEN 'T' THEN DO:
            IF T-CDOC.ImpVta > 0 THEN DO:
               x-codcta = cb-cfgg.codcta[5]. 
               RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpVta, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
            END.  
            IF T-CDOC.ImpExo > 0 THEN DO:
               x-codcta = cb-cfgg.codcta[6]. 
               RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpExo, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
            END.
            IF T-CDOC.ImpIgv > 0 THEN DO:
               x-codcta = cb-cfgg.codaux[3].
               RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpIgv, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
            END.
            IF T-CDOC.ImpIsc > 0 THEN DO:
               x-codcta = cb-cfgg.codaux[3].
               RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpIsc, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
            END.
            ASSIGN
                X-codcta = IF T-CDOC.codmon = 1 THEN X-codCta1 ELSE X-CodCta2
                X-codcta = IF X-codcta = '' THEN X-CodCta1 ELSE X-codcta.
            RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpTot, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
        END.
    END.

END.
HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Movimientos D-Dialog 
PROCEDURE Carga-Movimientos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-CodOpe AS CHAR NO-UNDO.

  FOR EACH t-cmov:
    DELETE t-cmov.
  END.
  FOR EACH t-dmov:
    DELETE t-dmov.
  END.

  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
    x-codope = ENTRY(i, s-CodOpe).
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
            AND cb-dmov.codope = x-codope
            AND cb-dmov.periodo = s-periodo
            AND cb-dmov.nromes = s-nromes
            AND cb-dmov.coddiv = x-Div,
            FIRST cb-cmov OF cb-dmov NO-LOCK:
        DISPLAY
            cb-dmov.coddiv cb-dmov.codope cb-dmov.nroast SKIP
            WITH FRAME F-Mensaje VIEW-AS DIALOG-BOX CENTERED OVERLAY NO-LABELS 
                WIDTH 60 TITLE 'Cargando Asientos Contables'.
        FIND t-cmov OF cb-cmov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-cmov THEN DO:
            CREATE t-cmov.
            BUFFER-COPY cb-cmov TO t-cmov.
        END.
        CREATE t-dmov.
        BUFFER-COPY cb-dmov TO t-dmov.
    END.
  END.            
  HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Divisiones AS CHAR NO-UNDO.
  DEF VAR k AS INT NO-UNDO.
  
  x-Divisiones = TRIM(x-Div).
  IF x-Div = '' THEN DO:
    FOR EACH GN-DIVI WHERE GN-DIVI.codcia = s-codcia NO-LOCK:
        IF x-Divisiones = ''
        THEN x-Divisiones = TRIM(GN-DIVI.coddiv).
        ELSE x-Divisiones = x-Divisiones + ',' + TRIM(GN-DIVI.coddiv).
    END.
  END.

  /* cargamos los asientos sin filtrarlos */
/*  DEF VAR i AS INT NO-UNDO.
 *   DEF VAR x-CodOpe AS CHAR NO-UNDO.*/


DO k = 1 TO NUM-ENTRIES(x-Divisiones):
  x-Div = ENTRY(k, x-Divisiones).
    
  RUN Carga-Movimientos.
/*  FOR EACH t-cmov:
 *     DELETE t-cmov.
 *   END.
 *   FOR EACH t-dmov:
 *     DELETE t-dmov.
 *   END.*/

/*  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
 *     x-codope = ENTRY(i, s-CodOpe).
 *     FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia  
 *             AND cb-cmov.Periodo = s-Periodo 
 *             AND cb-cmov.NroMes  = s-NroMes  
 *             AND cb-cmov.CodOpe  = x-CodOpe:
 *         CREATE t-cmov.
 *         BUFFER-COPY CB-CMOV TO t-cmov.
 *         FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.CodCia  
 *                 AND cb-dmov.Periodo = cb-cmov.Periodo 
 *                 AND cb-dmov.NroMes  = cb-cmov.NroMes  
 *                 AND cb-dmov.CodOpe  = cb-cmov.CodOpe  
 *                 AND cb-dmov.NroAst  = cb-cmov.NroAst  
 *                 AND cb-dmov.CodDiv  BEGINS x-Div:
 *             CREATE t-dmov.
 *             BUFFER-COPY cb-dmov TO t-dmov.
 *         END.
 *     END.
 *   END.            */

  /* Genera registro contable ("REGISTRO") */
  RUN Captura.
  
  /* Separamos las facturas al contado */
  RUN Separa-Facturas.
/*  DEF VAR x-NroDoc1 AS CHAR NO-UNDO.
 *   DEF VAR x-NroDoc2 AS CHAR NO-UNDO.
 * 
 *   FOR EACH t-cmov:
 *     DELETE t-cmov.
 *   END.
 *   FOR EACH t-dmov:
 *     DELETE t-dmov.
 *   END.    
 *   DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
 *     x-codope = ENTRY(i, s-CodOpe).
 *     FOR EACH t-cdoc:
 *         DELETE t-cdoc.
 *     END.
 *     FOR EACH Registro WHERE Registro.coddoc = '01' 
 *             AND Registro.codope = x-codope
 *             AND Registro.nomcli BEGINS 'FAC ' + TRIM(Registro.nrodoc) + '/':
 *         ASSIGN
 *             x-NroDoc1 = Registro.nrodoc
 *             x-NroDoc2 = SUBSTRING(Registro.nomcli, INDEX(Registro.nomcli, '/') + 1).
 *         FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
 *                 AND Ccbcdocu.coddoc = 'FAC'
 *                 AND Ccbcdocu.nrodoc >= x-NroDoc1
 *                 AND Ccbcdocu.nrodoc <= x-NroDoc2 NO-LOCK:
 *             FIND t-cdoc OF Ccbcdocu NO-LOCK NO-ERROR.
 *             IF NOT AVAILABLE t-cdoc THEN DO:
 *                 CREATE t-cdoc.
 *                 BUFFER-COPY Ccbcdocu TO t-cdoc
 *                     ASSIGN t-cdoc.nroast = Registro.nroast. /* OJO */
 *             END.
 *         END.            
 *         DELETE Registro.
 *     END.
 *     /* Generamos los asientos contables */
 *     RUN Captura-2.
 *   END.*/

  RUN Captura-3.  

  RUN Guarda-Registros.
END.
RUN Recupera-Registros.
  
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
  DISPLAY C-CodMon x-Div s-CodOpe 
      WITH FRAME D-Dialog.
  ENABLE RECT-20 RECT-12 x-Div s-CodOpe Btn_OK Btn_Cancel BUTTON-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO D-Dialog 
PROCEDURE FORMATO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Miluska AS CHAR NO-UNDO.
DEF VAR x-CodDoc  AS CHAR NO-UNDO.

 DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
 DEFINE VAR VAN     AS DECI EXTENT 10.
 DEFINE VAR X-LLAVE AS LOGICAL.
 DEFINE VAR x-NroSer AS CHAR.
 DEFINE VAR x-NroDoc AS CHAR.
 DEFINE VAR x-SerRef AS CHAR.
 DEFINE VAR x-NroRef AS CHAR.
  
 RUN Carga-Temporal.
 
 RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     
 
 Titulo1 = "R E G I S T R O  D E  V E N T A S".
 Titulo2 = "DEL MES DE " + x-DesMes.
 Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
 
 
 RUN BIN/_centrar.p ( INPUT Titulo1, 230, OUTPUT Titulo1).
 RUN BIN/_centrar.p ( INPUT Titulo2, 230, OUTPUT Titulo2).
 RUN BIN/_centrar.p ( INPUT Titulo3, 230, OUTPUT Titulo3).
 
 DEFINE FRAME f-cab
       Registro.CodDiv    COLUMN-LABEL "División"
       Registro.NroAst    COLUMN-LABEL "Nro.Ast"
       Registro.FchDoc    COLUMN-LABEL "Fecha de!Emisión"
       Registro.CodDoc    COLUMN-LABEL "Cod.!Doc." FORMAT "X(4)"
       x-NroSer           COLUMN-LABEL "Nro.!Serie" FORMAT "X(5)"
       x-NroDoc           COLUMN-LABEL "Nro.!Documento" FORMAT "X(11)"
       Registro.CodRef    COLUMN-LABEL "Cod.!Doc." FORMAT "X(4)"
       x-SerRef           COLUMN-LABEL "Nro.!Serie" FORMAT "X(5)"
       x-NroRef           COLUMN-LABEL "Nro.!Referencia" FORMAT "X(11)"
       Registro.Ruc       COLUMN-LABEL "Nro.!R.U.C." FORMAT "X(11)"
       Registro.NomCli    COLUMN-LABEL "C l i e n t e" FORMAT "X(40)"
       Registro.ImpLin[1] COLUMN-LABEL "Valor!Venta" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[2] COLUMN-LABEL "Importe!Exonerado" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[3] COLUMN-LABEL "I.S.C" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[4] COLUMN-LABEL "Base!Imponible" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[5] COLUMN-LABEL "I.G.V.!I.P.M." FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[6] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       Registro.ImpLin[9] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       HEADER
       S-NOMCIA FORMAT "X(60)" 
       /*"FECHA  : " TO 163 TODAY */
       "PAGINA : " TO 193 PAGE-NUMBER(REPORT) FORMAT "ZZ9"        
       Titulo1 
       Titulo2 SKIP 
       Titulo3 SKIP(2)               
       "-------- -------- -------- ---- ----- ----------- ---- ----- ----------- ----------- ---------------------------------------- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ----------------"
       "                  Fecha de Cod. Nro.  Nro.        Cod. Ref.  Nro.        Nro.                                                            Valor          Importe                              Base           I.G.V.          Importe   Importe Total "
       "División Nro.Ast  Emisión  Doc. Serie Documento   Doc. Serie Referencia  R.U.C.      C l i e n t e                                       Venta        Exonerado            I.S.C        Imponible           I.P.M.            Total       US$       "
       "-------- -------- -------- ---- ----- ----------- ---- ----- ----------- ----------- ---------------------------------------- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ----------------"
/*
        12345678 12345678 99/99/99 1234 12345 12345678901 1234 12345 12345678901 12345678901 1234567890123456789012345678901234567890 (>>>,>>>,>>9.99) (>>>,>>>,>>9.99) (>>>,>>>,>>9.99) (>>>,>>>,>>9.99) (>>>,>>>,>>9.99) (>>>,>>>,>>9.99) (>>>,>>>,>>9.99) 
*/
       WITH WIDTH 255 NO-BOX STREAM-IO NO-LABELS NO-UNDERLINE DOWN.
    
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 
 PUT STREAM REPORT CONTROL CHR(27) "@".
 PUT STREAM REPORT CONTROL CHR(27) "C" CHR(66).
 PUT STREAM REPORT CONTROL CHR(27) CHR(120) 0.
 PUT STREAM REPORT CONTROL CHR(15).
 PUT STREAM REPORT CONTROL {&PRN4}.
 FOR EACH Registro BREAK BY Registro.CodCia BY Registro.CodDiv BY Registro.CodDoc BY Registro.NroDoc:
     IF FIRST-OF (Registro.CodDiv) THEN DO :
     END.
     IF PAGE-NUMBER(REPORT) > 1 AND X-LLAVE = TRUE THEN DO:
        DISPLAY STREAM REPORT  
                 "V I E N E N  . . . . . . . . "  @ Registro.NomCli    
                 Van[1]  @ Registro.ImpLin[1] 
                 Van[2]  @ Registro.ImpLin[2] 
                 Van[3]  @ Registro.ImpLin[3] 
                 Van[4]  @ Registro.ImpLin[4] 
                 Van[5]  @ Registro.ImpLin[5] 
                 Van[6]  @ Registro.ImpLin[6] 
                 WITH FRAME F-cab.
        DOWN STREAM REPORT 2 WITH FRAME F-cab.
        X-LLAVE = FALSE.
     END.
    CASE Registro.CodDoc:
        WHEN '01' THEN x-coddoc = 'FAC'.
        WHEN '03' THEN x-coddoc = 'BOL'.
        WHEN '07' THEN x-coddoc = 'N/C'.
        WHEN '08' THEN x-coddoc = 'N/D'.
        OTHERWISE x-coddoc = ''.
    END CASE.    
    
    FIND ccbcdocu where ccbcdocu.codcia = s-codcia 
        AND ccbcdocu.coddoc = x-coddoc
        AND ccbcdocu.nrodoc = Registro.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN x-Miluska = ccbcdocu.codven.
    ELSE x-Miluska = Registro.NroRef.
    /*x-Miluska = Registro.cco.*/

    ASSIGN
        x-NroSer = SUBSTRING(Registro.NroDoc,1,3)
        x-NroDoc = SUBSTRING(Registro.NroDoc,4).
    IF Registro.CodDiv = '00012' AND Registro.NomCli BEGINS 'TCK'
    THEN ASSIGN
            x-NroSer = 'A4UK'
            x-NroDoc = '016216'.
     DISPLAY STREAM REPORT  
             Registro.CodDiv
             Registro.NroAst    
             Registro.FchDoc    
             Registro.CodDoc    
             x-NroSer
             x-NroDoc
             Registro.CodRef                
             SUBSTRING(Registro.NroRef,1,3) @ x-SerRef
             SUBSTRING(Registro.NroRef,4)   @ x-NroRef
             Registro.Ruc           WHEN NOT ( Registro.CodDoc = '03' OR (AVAILABLE ccbcdocu AND ccbcdocu.codref = 'BOL') )
             Registro.NomCli    
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[9] WHEN Registro.ImpLin[9] > 0 
             WITH FRAME F-CAB. 
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodCia ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDiv ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDoc ).
     
     Van[1] = Van[1] + Registro.ImpLin[1].
     Van[2] = Van[2] + Registro.ImpLin[2].
     Van[3] = Van[3] + Registro.ImpLin[3].
     Van[4] = Van[4] + Registro.ImpLin[4].
     Van[5] = Van[5] + Registro.ImpLin[5].
     Van[6] = Van[6] + Registro.ImpLin[6].
     
     IF LINE-COUNTER(Report) > (PAGE-SIZE(Report) - 3) THEN DO:
        X-LLAVE = TRUE.
        DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 1 :
           PUT STREAM Report "" skip.
        END.
        UNDERLINE STREAM REPORT 
             Registro.NomCli 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             WITH FRAME F-CAB. 

        DISPLAY STREAM REPORT  
                 "V A N  . . . . . . . . "  @ Registro.NomCli    
                 Van[1]  @ Registro.ImpLin[1] 
                 Van[2]  @ Registro.ImpLin[2] 
                 Van[3]  @ Registro.ImpLin[3] 
                 Van[4]  @ Registro.ImpLin[4] 
                 Van[5]  @ Registro.ImpLin[5] 
                 Van[6]  @ Registro.ImpLin[6] 
                 WITH FRAME F-cab.
        DOWN STREAM REPORT 2 WITH FRAME F-cab.

     END.

     IF LAST-OF (Registro.CodDoc) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL  " + Registro.CodDoc @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.             
     END.
     
     IF LAST-OF (Registro.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL POR DIVISION " + x-CodDiv @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
     IF LAST-OF (Registro.CodCia) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL GENERAL "  @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
 END.
 
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Documentos D-Dialog 
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
 DEFINE INPUT PARAMETER X-CCO     AS CHAR.

 DEFINE VAR X-CODCLI AS CHAR INIT "".
 DEFINE VAR X-NRODOC AS CHAR INIT "".
 DEFINE VAR X-GLOSA AS CHAR.
 DEFINE VAR X-CODAUX AS CHAR .
 DEFINE VAR x-venta   AS DECI NO-UNDO.
 DEFINE VAR x-compra  AS DECI NO-UNDO.
 
 
 IF x-tm = 0 THEN x-tm = 01.
 
 X-CODCLI = T-CDOC.Ruccli.
 X-GLOSA  = T-CDOC.Nomcli.
 X-CODAUX = T-CDOC.Codcli.
 X-NRODOC = IF X-DETALLE THEN T-CDOC.Nrodoc ELSE "111111111".

 /* RHC 19.10.04 */
 IF x-CodCbd = '03' /* BOLETAS */
 THEN DO:
    x-CodAux = IF T-CDOC.NroCard <> '' THEN T-CDOC.NroCard ELSE '11111111'.
 END.
 /* ************ */

 IF X-NRODOC =  "111111111" THEN DO:
    X-CODCLI = "".
    X-GLOSA  = "VENTAS CONTADO".
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
                   t-prev.cco    = x-cco
                   NO-LOCK NO-ERROR.
                    
 IF NOT AVAILABLE t-prev THEN DO:
   CREATE t-prev.
   ASSIGN
      t-prev.periodo = s-periodo
      t-prev.nromes  = s-nromes
      t-prev.codope  = x-codope
      t-prev.nroast  = T-CDOC.NroAst    /* OJO */
      t-prev.coddiv  = T-CDOC.CodDiv 
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = T-CDOC.Fchdoc
      t-prev.fchvto  = T-CDOC.Fchvto
      t-prev.tpomov  = x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.nroruc  = x-codcli /*Gn-Clie.Ruc*/
      t-prev.codaux  = X-CodAux
      t-prev.codmon  = x-codmon
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = x-nrodoc /*T-CDOC.Nrodoc*/
      t-prev.tm      = x-tm
      t-prev.cco     = x-cco.
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
    END.
 END.

 FIND gn-tcmb WHERE gn-tcmb.fecha = T-CDOC.fchdoc 
                    NO-LOCK NO-ERROR.
 IF AVAILABLE gn-tcmb THEN DO:
    x-venta = gn-tcmb.venta.
    x-compra = gn-tcmb.compra.
 END.
 ELSE DO:
  x-venta  = 0.
  x-compra = 0.
 END.

 IF T-CDOC.CodMon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-importe.
 ELSE DO:
   ASSIGN
   t-prev.impmn2  = t-prev.impmn2 + x-importe
   t-prev.impmn1  = t-prev.impmn1 + ROUND(( x-importe * x-venta ) ,2).  
 END.
 ASSIGN
    t-prev.Tpocmb  = IF x-codmon = 2 THEN x-venta ELSE 0
    t-prev.glodoc  = IF T-CDOC.FlgEst = "A" THEN "ANULADO" ELSE X-GLOSA
    t-prev.codaux  = IF T-CDOC.FlgEst = "A" THEN "" ELSE t-prev.codaux
    t-prev.nroruc  = IF T-CDOC.FlgEst = "A" THEN "" ELSE t-prev.nroruc
    t-prev.clfaux  = IF T-CDOC.FlgEst = "A" OR X-CODCLI = "" THEN " " ELSE t-prev.clfaux.

 RELEASE t-prev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Guarda-Registros D-Dialog 
PROCEDURE Guarda-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Registro:
    CREATE T-Registro.
    BUFFER-COPY Registro TO T-Registro.
    DELETE Registro.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  
  RUN Formato.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN BIN/_VCAT.P(s-print-file). 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
       NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN DO:
     s-CodOpe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
  END.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recupera-Registros D-Dialog 
PROCEDURE Recupera-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-Registro:
    CREATE Registro.
    BUFFER-COPY T-Registro TO Registro.
    DELETE T-Registro.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Separa-Facturas D-Dialog 
PROCEDURE Separa-Facturas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-NroDoc1 AS CHAR NO-UNDO.
  DEF VAR x-NroDoc2 AS CHAR NO-UNDO.
  DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
  DEF VAR x-FchDoc-2 AS DATE NO-UNDO.

  RUN bin/_dateif(s-NroMes, s-Periodo, OUTPUT x-FchDoc-1, OUTPUT x-FchDoc-2).

  FOR EACH t-cmov:
    DELETE t-cmov.
  END.
  FOR EACH t-dmov:
    DELETE t-dmov.
  END.    
  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
    x-codope = ENTRY(i, s-CodOpe).
    FOR EACH t-cdoc:
        DELETE t-cdoc.
    END.
    FOR EACH Registro WHERE Registro.coddoc = '01' 
            AND Registro.codope = x-codope
            AND Registro.nomcli BEGINS 'FAC ' + TRIM(Registro.nrodoc) + '/':
        ASSIGN
            x-NroDoc1 = Registro.nrodoc
            x-NroDoc2 = SUBSTRING(Registro.nomcli, INDEX(Registro.nomcli, '/') + 1).
        FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddiv = Registro.coddiv
                AND Ccbcdocu.coddoc = 'FAC'
                AND Ccbcdocu.nrodoc >= x-NroDoc1
                AND Ccbcdocu.nrodoc <= x-NroDoc2 
                AND Ccbcdocu.fchdoc >= x-FchDoc-1
                AND Ccbcdocu.fchdoc <= x-FchDoc-2
                NO-LOCK:
            DISPLAY
                Ccbcdocu.coddiv Registro.codope Registro.nroast Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                WITH FRAME F-Mensaje VIEW-AS DIALOG-BOX CENTERED OVERLAY NO-LABELS 
                    WIDTH 60 TITLE 'Separando Facturas'.

            /* *** */
            FIND FIRST B-Registro WHERE B-Registro.coddiv = Ccbcdocu.coddiv
                AND B-Registro.coddoc = '01'
                AND B-Registro.nrodoc = Ccbcdocu.nrodoc
                AND ROWID(B-Registro) <> ROWID(Registro)
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-Registro THEN NEXT.
            /* *** */

            FIND t-cdoc OF Ccbcdocu NO-LOCK NO-ERROR.
            IF NOT AVAILABLE t-cdoc THEN DO:
                CREATE t-cdoc.
                BUFFER-COPY Ccbcdocu TO t-cdoc
                    ASSIGN t-cdoc.nroast = Registro.nroast. /* OJO */
            END.
        END.            
        DELETE Registro.
    END.
    /* Generamos los asientos contables */
    RUN Captura-2.
  END.
  HIDE FRAME f-Mensaje.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto D-Dialog 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.
  DEF VAR x-CodDoc  AS CHAR NO-UNDO.

  DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
  DEFINE VAR VAN     AS DECI EXTENT 10.
  DEFINE VAR X-LLAVE AS LOGICAL.
 
  x-Archivo = 'Ventas' + STRING(s-Periodo, '9999') + STRING(s-NroMes, '99') + 's.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN Carga-Temporal.
 
 DEFINE FRAME f-cab
       Registro.CodDiv    COLUMN-LABEL "Division"
       Registro.NroAst    COLUMN-LABEL "Nro.Ast"
       Registro.FchDoc    COLUMN-LABEL "Fecha de!Emision"
       Registro.CodDoc    COLUMN-LABEL "Cod.!Doc." FORMAT "X(4)"
       Registro.NroDoc    COLUMN-LABEL "Nro.!Documento" FORMAT "999-9999999"
       Registro.NroRef    COLUMN-LABEL "Nro.!Referencia" FORMAT "999-9999999"
       Registro.NotDeb    COLUMN-LABEL "Notas de!Debito" FORMAT "999-9999999"
       Registro.NotCre    COLUMN-LABEL "Notas de!Credito" FORMAT "999-9999999"
       Registro.Ruc       COLUMN-LABEL "Nro.!R.U.C." FORMAT "X(11)"
       Registro.NomCli    COLUMN-LABEL "C l i e n t e" FORMAT "X(40)"
       Registro.CodMon    COLUMN-LABEL "Mon" FORMAT "X(3)"
       Registro.ImpLin[1] COLUMN-LABEL "Valor!Venta" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[2] COLUMN-LABEL "Importe!Exonerado" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[3] COLUMN-LABEL "I.S.C" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[4] COLUMN-LABEL "Base!Imponible" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[5] COLUMN-LABEL "I.G.V.!I.P.M." FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[6] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       Registro.ImpLin[9] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       WITH WIDTH 255 NO-BOX STREAM-IO DOWN.
    
  OUTPUT STREAM REPORT TO VALUE(x-Archivo).
  FOR EACH Registro BREAK BY Registro.CodCia BY Registro.CodDiv BY Registro.CodDoc BY Registro.NroDoc:
    CASE Registro.CodDoc:
        WHEN '01' THEN x-coddoc = 'FAC'.
        WHEN '03' THEN x-coddoc = 'BOL'.
        WHEN '07' THEN x-coddoc = 'N/C'.
        WHEN '08' THEN x-coddoc = 'N/D'.
        OTHERWISE x-coddoc = ''.
    END CASE.    
    DISPLAY STREAM REPORT  
             Registro.CodDiv
             Registro.NroAst    
             Registro.FchDoc    
             Registro.CodDoc    
             Registro.NroDoc    
             Registro.NroRef
             Registro.Ruc           WHEN NOT ( Registro.CodDoc = '03' OR (AVAILABLE ccbcdocu AND ccbcdocu.codref = 'BOL') )
             Registro.NomCli    
             Registro.CodMon    
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[9] WHEN Registro.ImpLin[9] > 0 
             WITH FRAME F-CAB. 
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodCia ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDiv ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDoc ).
     
     Van[1] = Van[1] + Registro.ImpLin[1].
     Van[2] = Van[2] + Registro.ImpLin[2].
     Van[3] = Van[3] + Registro.ImpLin[3].
     Van[4] = Van[4] + Registro.ImpLin[4].
     Van[5] = Van[5] + Registro.ImpLin[5].
     Van[6] = Van[6] + Registro.ImpLin[6].
     
     IF LAST-OF (Registro.CodDoc) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL  " + Registro.CodDoc @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.             
     END.
     
     IF LAST-OF (Registro.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL POR DIVISION " + x-CodDiv @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
     IF LAST-OF (Registro.CodCia) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL GENERAL "  @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

