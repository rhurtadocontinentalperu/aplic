&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
CREATE WIDGET-POOL.
DEFINE VAR OK-W-S AS LOGICAL NO-UNDO.
OK-W-S = SESSION:SET-WAIT-STATE("").

DEF VAR E-CONTENIDO AS CHAR.

E-CONTENIDO = 
"   Este procedimiento tiene por finalidad trasladar los saldos 
del presente per¡odo o a¤o contable al mes de apertura del 
siguiente per¡odo contable; Si ya se realiz¢ se anular  la apertura 
anterior y se trasladaran nuevamente los saldos actualizados. 
Las cuentas de Balance que esten configuradas como : [X] Cierre Anual Resumido,
 trasladar n su saldo total y 
Las cuentas de Balance que esten configuradas como :
  [ ] Cierre Anual Resumido trasladar n saldos individulaes por 
cada documento.".

     
    
DEF VAR RELOJ AS LOGICAL.

DEF VAR X-MENSAJE AS CHAR FORMAT "X(50)".

DEFINE FRAME F-AUXILIAR 
X-MENSAJE
WITH TITLE "Espere un momento por favor"
     CENTERED VIEW-AS DIALOG-BOX NO-LABELS.
     
{BIN/S-GLOBAL.I}
{CBD/CBGLOBAL.I}     

DEF VAR x-sdonac   AS DECIMAL INITIAL 0.
DEF VAR x-sdousa   AS DECIMAL INITIAL 0.
DEF BUFFER detalle FOR cb-dmov.
DEF VAR x-ROWID    AS ROWID.

DEF VAR  x-d1      AS DECIMAL  INITIAL 0.
DEF VAR  x-h1      AS DECIMAL  INITIAL 0.
DEF VAR  x-d2      AS DECIMAL  INITIAL 0.
DEF VAR  x-h2      AS DECIMAL  INITIAL 0.

DEF VAR  T-d1      AS DECIMAL  INITIAL 0.
DEF VAR  T-h1      AS DECIMAL  INITIAL 0.
DEF VAR  T-d2      AS DECIMAL  INITIAL 0.
DEF VAR  T-h2      AS DECIMAL  INITIAL 0.



DEF VAR  x-nromes  AS INTEGER INITIAL 0.
DEF VAR  x-codope  AS CHAR INITIAL "000".
DEF VAR  x-tpomov  AS LOGICAL.
DEF VAR  x-nroast  AS CHAR INITIAL "000001".
DEF VAR  x-CodCta  AS CHAR.
DEF VAR  x-CodMon  AS INTEGER.
DEF VAR  x-nroitm  AS INTEGER INITIAL  0.
DEF VAR  y-glodoc   as char.
DEF VAR  x-tpocmb   as decimal.
DEF VAR  x-clfaux   as char.
DEF VAR  x-codaux   as char.
DEF VAR  x-coddoc   as char.
DEF VAR  x-nrodoc   as char.
DEF VAR  x-nroref   as char.
DEF VAR  x-fchdoc   as date.
DEF VAR  x-fchvto   as date.
DEF VAR  x-coddiv   as char.
def var  x-nroruc   as char.
def var  x-cfcAja    as char.
def var  x-cco      as char.
DEF VAR x-glodoc  AS CHAR INITIAL "ASIENTO AUTOMATICO DE APERTURA".

/*MESSAGE cb-maxnivel.*/

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
&Scoped-Define ENABLED-OBJECTS X-PER x-gan Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS X-PER x-gan EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "Cancel" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "OK" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 59.14 BY 6.04
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE x-gan AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta de Ganancias Acumuladas" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-PER AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta de Pérdidas Acumuladas" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     X-PER AT ROW 1.15 COL 32.43 COLON-ALIGNED
     x-gan AT ROW 2.08 COL 32.43 COLON-ALIGNED
     EDITOR-1 AT ROW 3.08 COL 1.14 NO-LABEL
     Btn_OK AT ROW 9.27 COL 9.57
     Btn_Cancel AT ROW 9.27 COL 40
     SPACE(9.28) SKIP(0.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Apertura del nuevo Periodo Contable".


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-1:AUTO-INDENT IN FRAME D-Dialog      = TRUE
       EDITOR-1:AUTO-RESIZE IN FRAME D-Dialog      = TRUE
       EDITOR-1:RETURN-INSERTED IN FRAME D-Dialog  = TRUE
       EDITOR-1:READ-ONLY IN FRAME D-Dialog        = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Apertura del nuevo Periodo Contable */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    ASSIGN X-PER X-GAN.
    
    RUN PROCESO.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-gan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-gan D-Dialog
ON F8 OF x-gan IN FRAME D-Dialog /* Cuenta de Ganancias Acumuladas */
OR "MOUSE-SELECT-DBLCLICK":U OF X-GAN DO:
    DEF VAR T-ROWID AS ROWID.
    RUN CBD/H-CTAS01.W(s-codcia, 0,OUTPUT T-ROWID).
    IF T-ROWID <> ?
    THEN DO:
        find cb-ctas WHERE ROWID(cb-ctas) = T-ROWID NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            X-GAN:SCREEN-VALUE = cb-ctas.CodCta.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    APPLY "CHOOSE":U TO X-GAN.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-PER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-PER D-Dialog
ON F8 OF X-PER IN FRAME D-Dialog /* Cuenta de Pérdidas Acumuladas */
OR "MOUSE-SELECT-DBLCLICK":U OF X-PER DO:
    DEF VAR T-ROWID AS ROWID.
    RUN CBD/H-CTAS01.W(s-codcia, 0,OUTPUT T-ROWID).
    IF T-ROWID <> ?
    THEN DO:
        find cb-ctas WHERE ROWID(cb-ctas) = T-ROWID NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            X-PER:SCREEN-VALUE = cb-ctas.CodCta.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    APPLY "CHOOSE":U TO X-PER.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
EDITOR-1 = E-CONTENIDO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ANULA D-Dialog 
PROCEDURE ANULA :
MESSAGE 'periodo a borra:' s-periodo + 1 SKIP
    'mes a borrar' x-nromes.
FOR EACH cb-dmov WHERE cb-dmov.codcia   = s-codcia          
    AND cb-dmov.periodo  = s-periodo + 1     
    AND cb-dmov.nromes   = x-nromes:
    DELETE cb-dmov.
END.
FOR EACH cb-cmov WHERE cb-cmov.codcia   = s-codcia          
    AND cb-cmov.periodo  = s-periodo + 1     
    AND cb-cmov.nromes   = x-nromes:
    DELETE cb-cmov.
END.
IF AVAILABLE(cb-cmov) THEN RELEASE cb-cmov.
IF AVAILABLE(cb-dmov) THEN RELEASE cb-dmov.

    
/* FOR EACH cb-dmov WHERE      cb-dmov.codcia   = s-codcia          AND */
/*                             cb-dmov.periodo  = s-periodo + 1     AND */
/*                             cb-dmov.nromes   = x-nromes          AND */
/*                             cb-dmov.codope   = x-codope          AND */
/*                             cb-dmov.nroast   = x-nroast :            */
/*     /*RUN cbd/cb-acmd.p(RECID(cb-dmov), NO, YES). */                 */
/*     DELETE cb-dmov.                                                  */
/* END.                                                                 */
/*                                                                      */
/* FIND cb-cmov WHERE     cb-cmov.codcia   = s-codcia       AND         */
/*                        cb-cmov.periodo  = s-periodo + 1  AND         */
/*                        cb-cmov.nromes   = x-nromes       AND         */
/*                        cb-cmov.codope   = x-codope       AND         */
/*                        cb-cmov.nroast   = x-nroast                   */
/*                        NO-ERROR.                                     */
/* IF AVAIL cb-cmov THEN DELETE cb-cmov.                                */
/*                                                                      */
/* /* RHC 12-01-2004 Se va a modificar la transaccion */                */
/* /*RUN GRABA-CAB.*/                                                   */

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
  DISPLAY X-PER x-gan EDITOR-1 
      WITH FRAME D-Dialog.
  ENABLE X-PER x-gan Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA D-Dialog 
PROCEDURE GENERA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR H-D1 AS DECIMAL.
DEF VAR H-D2 AS DECIMAL.
DEF VAR H-H1 AS DECIMAL.
DEF VAR H-H2 AS DECIMAL.

RUN GRABA-CAB.

RUN LIMPIA-DATOS.

/* **************************************** */
FOR EACH GN-DIVI WHERE GN-DIVI.CODCIA = S-CODCIA NO-LOCK:
    ASSIGN
        x-d1 = 0 
        x-d2 = 0
        x-h1 = 0
        x-d1 = 0
        x-Coddiv = gn-divi.coddiv.
    FOR EACH CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA 
            AND LENGTH(CB-CTAS.CODCTA) = CB-MAXNIVEL 
            AND CB-CTAS.CODCTA  < "6" 
            NO-LOCK:
        ASSIGN 
            X-CODMON = CB-CTAS.CODMON
            X-CODCTA = CB-CTAS.CODCTA.
        IF CB-CTAS.CIERES 
        THEN RUN GRAB-SALDO.
        ELSE RUN GRAB-CTACTE.
        DISPLAY "Procesando: " + x-coddiv + "-" + x-codcta  @ x-mensaje
            WITH FRAME f-auxiliar.
        PAUSE 0.
   END.
   ASSIGN
        H-D1 = X-D1
        H-D2 = X-D2
        H-H1 = X-H1
        H-H2 = X-H2.
   RUN GRAB-TOTAL(X-GAN ,
                    H-D1,
                    H-D2,
                    YES).
   RUN GRAB-TOTAL(X-PER ,
                    H-H1,
                    H-H2,
                    FALSE).

   RUN GRABA-TOTAL-TOTAL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRAB-CTACTE D-Dialog 
PROCEDURE GRAB-CTACTE :
DEFINE VARIABLE iCodMon LIKE cb-cmov.codmon NO-UNDO.

iCodMon = X-CODMON.

FOR EACH cb-dmov  NO-LOCK
                  WHERE  cb-dmov.codcia  = s-codcia  AND
                         cb-dmov.periodo = s-periodo AND
                         cb-dmov.NroMes  < 13        AND
                         cb-dmov.coddiv  = x-coddiv  AND 
                         cb-dmov.codcta  = x-codcta                               
                         BREAK 
                         BY cb-dmov.codaux  
                         BY cb-dmov.coddoc 
                         BY cb-dmov.nrodoc 
                         BY cb-dmov.fchdoc  :

    IF FIRST-OF(cb-dmov.nrodoc) THEN DO:
         ASSIGN 
           y-glodoc = cb-dmov.glodoc
           x-tpocmb = cb-dmov.tpocmb
           x-clfaux = cb-dmov.clfaux
           x-codaux = cb-dmov.codaux
           x-coddoc = cb-dmov.coddoc
           x-nrodoc = cb-dmov.nrodoc
           x-nroref = cb-dmov.nroref
           x-fchdoc = cb-dmov.fchdoc
           x-fchvto = cb-dmov.fchvto
           x-cco    = cb-dmov.cco
           x-nroruc = cb-dmov.nroruc
           x-cfcaja = cb-dmov.c-fcaja.
           IF X-CODMON = 3 THEN X-CodMon = cb-dmov.codmon.
        x-sdonac = 0.
        x-sdousa = 0.
    END. 
    
    IF NOT cb-dmov.TpoMov 
      THEN ASSIGN x-Sdonac = x-SdoNac + cb-dmov.ImpMn1           
                  x-Sdousa = x-SdoUsa + cb-dmov.ImpMn2.
      ELSE ASSIGN x-Sdonac = x-SdoNac - cb-dmov.ImpMn1           
                  x-Sdousa = x-SdoUsa - cb-dmov.ImpMn2.           
              
     IF LAST-OF(cb-dmov.nrodoc) THEN
     DO:
        /*MLR* 28/Mar/2008 */
        IF iCodMon = 3 OR cb-ctas.AftDcb = YES THEN DO:
            IF (x-sdonac <> 0) OR (x-sdousa <> 0) THEN RUN GRAB-DETALLE.
        END.
        ELSE DO:
            IF (x-sdonac <> 0) AND (x-sdousa <> 0) THEN RUN GRAB-DETALLE.
            ELSE IF (x-codmon = 1 AND x-sdonac <> 0) THEN RUN GRAB-DETALLE.
            ELSE IF (x-codmon = 2 AND x-sdousa <> 0) THEN RUN GRAB-DETALLE.
        END.
     END.
END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRAB-DETALLE D-Dialog 
PROCEDURE GRAB-DETALLE :
CREATE detalle.
  x-nroitm = x-nroitm + 1.
  IF (x-sdonac <>0 )  THEN x-tpomov = (x-sdonac < 0).       
                      ELSE x-tpomov = (x-sdousa < 0).
  x-sdousa = ABS(x-sdousa).
  x-sdonac = ABS(x-sdonac).
  ASSIGN
        detalle.CodCia   = s-codcia
        detalle.Periodo  = s-periodo + 1
        detalle.coddiv   = x-coddiv
        detalle.Codcta   = x-codcta
        detalle.Codmon   = x-codmon
        detalle.Codope   = x-codope
        detalle.Glodoc   = y-glodoc
        detalle.ImpMn1   = x-sdonac
        detalle.ImpMn2   = x-sdousa
        detalle.Nroast   = x-nroast
        detalle.Nroitm   = x-nroitm 
        detalle.NroMes   = x-nromes
        detalle.Tpocmb   = x-tpocmb
        detalle.clfaux   = x-clfaux
        detalle.codaux   = x-codaux
        detalle.coddoc   = x-coddoc
        detalle.nrodoc   = x-nrodoc
        detalle.nroref   = x-nroref
        detalle.fchdoc   = x-fchdoc
        detalle.fchvto   = x-fchvto
        detalle.TpoMov   = x-tpomov
        detalle.cco      = x-cco  
        detalle.nroruc   = x-nroruc 
        detalle.c-fcaja  = x-cfcaja.
  RUN SUMA.
/*  RUN cbd/cb-acmd.p(RECID(detalle), YES, YES).*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRAB-SALDO D-Dialog 
PROCEDURE GRAB-SALDO :
ASSIGN 
           y-glodoc = X-glodoc
           x-tpocmb = 0
           x-clfaux = ""
           x-codaux = ""
           x-coddoc = ""
           x-nrodoc = ""
           x-nroref = ""
           x-fchdoc = ?
           x-fchvto = ?
           x-cco    = ""
           x-nroruc = ""
           x-cfcaja = ""
           x-sdonac = 0
           x-sdousa = 0.


FOR EACH cb-dmov  NO-LOCK WHERE  
         cb-dmov.codcia  = s-codcia  AND
         cb-dmov.periodo = s-periodo AND
         cb-dmov.coddiv  = x-coddiv  AND 
         cb-dmov.codcta  = x-codcta  AND
         cb-dmov.NroMes  < 13 :
    
    IF NOT cb-dmov.TpoMov 
      THEN ASSIGN x-Sdonac = x-SdoNac + cb-dmov.ImpMn1           
                  x-Sdousa = x-SdoUsa + cb-dmov.ImpMn2.
      ELSE ASSIGN x-Sdonac = x-SdoNac - cb-dmov.ImpMn1           
                  x-Sdousa = x-SdoUsa - cb-dmov.ImpMn2.           
              
END. 
        /*MLR* 28/Mar/2008 */
        IF cb-ctas.Codmon = 3 OR cb-ctas.AftDcb = YES THEN DO:
            IF (x-sdonac <> 0) OR (x-sdousa <> 0) THEN RUN GRAB-DETALLE.
        END.
        ELSE DO:
            IF (x-sdonac <> 0) AND (x-sdousa <> 0) THEN RUN GRAB-DETALLE.
            ELSE IF (x-codmon = 1 AND x-sdonac <> 0) THEN RUN GRAB-DETALLE.
            ELSE IF (x-codmon = 2 AND x-sdousa <> 0) THEN RUN GRAB-DETALLE.
        END.

/* IF (x-sdonac <> 0) AND (x-sdousa <> 0) THEN RUN GRAB-DETALLE.        */
/* ELSE IF (x-codmon = 1 AND x-sdonac <> 0) THEN RUN GRAB-DETALLE.      */
/*      ELSE IF (x-codmon = 2 AND x-sdousa <> 0) THEN RUN GRAB-DETALLE. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRAB-TOTAL D-Dialog 
PROCEDURE GRAB-TOTAL :
DEFINE INPUT PARAMETER X-CODCTA AS CHAR.
DEFINE INPUT PARAMETER X-SDONAC AS DECIMAL.
DEFINE INPUT PARAMETER X-SDOUSA AS DECIMAL.
DEFINE INPUT PARAMETER X-TPOMOV AS LOGICAL.


CREATE detalle.
  x-nroitm = x-nroitm + 1.
  x-sdousa = ABS(x-sdousa).
  x-sdonac = ABS(x-sdonac).
  ASSIGN
        detalle.CodCia   = s-codcia
        detalle.Codcta   = x-codcta
        detalle.coddiv   = x-coddiv
        detalle.Codmon   = 1
        detalle.Codope   = x-codope
        detalle.Glodoc   = x-glodoc
        detalle.ImpMn1   = x-sdonac
        detalle.ImpMn2   = x-sdousa
        detalle.Nroast   = x-nroast
        detalle.Nroitm   = x-nroitm 
        detalle.NroMes   = x-nromes
        detalle.Periodo  = s-periodo + 1
        detalle.Tpocmb   = 1
        detalle.TpoMov   = x-tpomov.
   RUN SUMA. 
   /* RUN CBD/cb-acmd.p(RECID(detalle), YES, NO).  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRABA-CAB D-Dialog 
PROCEDURE GRABA-CAB :
CREATE integral.cb-cmov.
  ASSIGN 
    integral.cb-cmov.CodCia  = s-codcia
    integral.cb-cmov.Periodo = s-periodo + 1
    integral.cb-cmov.NroMes  = x-nromes
    integral.cb-cmov.CodOpe  = x-CodOpe
    integral.cb-cmov.NroAst  = STRING(1,"999999")
    integral.cb-cmov.FchAst  = DATE( 1, 1, s-periodo + 1) - 1
    integral.cb-cmov.TpoCmb  = 1
    integral.cb-cmov.Notast  = x-glodoc
    integral.cb-cmov.GloAst  = x-glodoc
    integral.cb-cmov.codmon  = 1.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRABA-TOTAL-TOTAL D-Dialog 
PROCEDURE GRABA-TOTAL-TOTAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF AVAIL CB-CMOV  THEN DO:
       FIND CURRENT CB-CMOV EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE Cb-CMOV THEN
           ASSIGN 
               CB-CMOV.DBEMN1 = T-D1
               CB-CMOV.DBEMN2 = T-D2
               CB-CMOV.HBEMN1 = T-H1
               CB-CMOV.HBEMN2 = T-H2
               CB-CMOV.TOTITM = X-NROITM.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LIMPIA-DATOS D-Dialog 
PROCEDURE LIMPIA-DATOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 07/09/2015 LIMPIAMOS PLAN DE CUENTAS */
FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia TRANSACTION:
    cb-ctas.codcta = TRIM(cb-ctas.codcta).
END.
/* RHC 09/09/2015 Corregimos movimientos contables */
/* FOR EACH cb-dmov WHERE cb-dmov.codcia  = s-codcia */
/*     AND cb-dmov.periodo = s-periodo               */
/*     AND cb-dmov.coddiv  = ""                      */
/*     AND cb-dmov.NroMes  < 13,                     */
/*     FIRST cb-cmov OF cb-dmov NO-LOCK              */
/*     cb-dmov.coddiv = cb-cmov.coddiv.              */
/* END.                                              */
FOR EACH cb-cmov WHERE cb-cmov.codcia  = s-codcia  
    AND cb-cmov.periodo = s-periodo 
    AND cb-cmov.NroMes  < 13 TRANSACTION:
    FIND gn-divi WHERE gn-div.codcia = s-codcia
        AND gn-divi.coddiv = cb-cmov.coddiv NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN cb-cmov.coddiv = "00000".
END.
FOR EACH cb-dmov WHERE cb-dmov.codcia  = s-codcia  
    AND cb-dmov.periodo = s-periodo 
    AND cb-dmov.NroMes  < 13,
    FIRST cb-cmov OF cb-dmov NO-LOCK TRANSACTION:
    FIND gn-divi WHERE gn-div.codcia = s-codcia
        AND gn-divi.coddiv = cb-dmov.coddiv NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN cb-dmov.coddiv = cb-cmov.coddiv.
END.
IF AVAILABLE cb-ctas THEN RELEASE cb-ctas.
IF AVAILABLE cb-cmov THEN RELEASE cb-cmov.
IF AVAILABLE cb-dmov THEN RELEASE cb-dmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO D-Dialog 
PROCEDURE PROCESO :
/* RHC 12-01-2004 */
DISPLAY  "Eliminando movimiento Anterior" @  x-mensaje WITH FRAME F-AUXILIAR.
PAUSE 0.
RUN ANULA.  /* En este proceso se anulo la generacion de la cabecera, ahora se hace en GENERA */

DISPLAY "Seleccionando información a procesar " @ x-mensaje
    WITH FRAME f-auxIliar.
PAUSE 0.
RUN GENERA.

HIDE FRAME F-AUXILIAR.

/* ************* RHC 12-01-2004 Se va a partir la transaccion en dos 
DEF VAR H-D1 AS DECIMAL.
DEF VAR H-D2 AS DECIMAL.
DEF VAR H-H1 AS DECIMAL.
DEF VAR H-H2 AS DECIMA.

DISPLAY  "Eliminando movimiento Anterior" @  x-mensaje WITH FRAME F-AUXILIAR.
PAUSE 0.
RUN ANULA.

DISPLAY "Seleccionando información a procesar " @ x-mensaje
with frame f-auxIliar.
pause 0.

FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.CODCIA = S-CODCIA AND
                        LENGTH(GN-DIVI.CODDIV) = 5 :
    assign x-d1 = 0 
           x-d2 = 0
           x-h1 = 0
           x-d1 = 0
           x-Coddiv = gn-divi.coddiv.    
    FOR EACH CB-CTAS WHERE CB-CTAS.CODCIA  = CB-CODCIA AND
                    LENGTH(CB-CTAS.CODCTA) = CB-MAXNIVEL 
                    AND    CB-CTAS.CODCTA  < "6" :
        ASSIGN X-CODMON = CB-CTAS.CODMON
               X-CODCTA = CB-CTAS.CODCTA.
        IF CB-CTAS.CIERES THEN RUN GRAB-SALDO.
                          ELSE RUN GRAB-CTACTE.
                           
        DISPLAY "Procesando: " + x-coddiv + "-" + x-codcta  @ x-mensaje
        with frame f-auxiliar.
        pause 0.
   END.
   ASSIGN
        H-D1 = X-D1
        H-D2 = X-D2
        H-H1 = X-H1
        H-H2 = X-H2.
   RUN GRAB-TOTAL(X-GAN ,
                    H-D1,
                    H-D2,
                    YES).
   RUN GRAB-TOTAL(X-PER ,
                    H-H1,
                    H-H2,
                    FALSE).
END.
IF AVAIL CB-CMOV THEN ASSIGN CB-CMOV.DBEMN1 = T-D1
                             CB-CMOV.DBEMN2 = T-D2
                             CB-CMOV.HBEMN1 = T-H1
                             CB-CMOV.HBEMN2 = T-H2
                             CB-CMOV.TOTITM = X-NROITM.
HIDE FRAME F-AUXILIAR.
*************************************************************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SUMA D-Dialog 
PROCEDURE SUMA :
IF detalle.tpomov  THEN
DO:
   x-h1 = x-h1 + detalle.impmn1.
   x-h2 = x-h2 + detalle.impmn2.
END.
ELSE
DO:
   x-d1 = x-d1 + detalle.impmn1.
   x-d2 = x-d2 + detalle.impmn2.
END.   

IF detalle.tpomov  THEN
DO:
   T-h1 = T-h1 + detalle.impmn1.
   T-h2 = T-h2 + detalle.impmn2.
END.
ELSE
DO:
   T-d1 = T-d1 + detalle.impmn1.
   T-d2 = T-d2 + detalle.impmn2.
END.   



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

