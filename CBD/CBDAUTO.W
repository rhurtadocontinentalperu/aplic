&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
def var pto as logical.
DEFINE VARIABLE x-GenAut   AS INTEGER.
DEFINE VARIABLE x-Cta-Auto LIKE  cb-cfga.genaut.
DEFINE VARIABLE x-Cc1Cta   LIKE  cb-cfga.cc1cta6.
DEFINE VARIABLE x-a-cc1cta LIKE  cb-cfga.cc1cta6.
DEFINE VARIABLE x-An1Cta   LIKE  cb-cfga.genaut.
DEFINE VARIABLE x-llave    AS CHARACTER.
DEFINE BUFFER   detalle    FOR cb-dmov.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE j AS INTEGER.
DEFINE VARIABLE X-NROITM  AS INTEGER.
DEFINE  VARIABLE cb-codcia AS INTEGER INITIAL 0.
PTO = SESSION:SET-WAIT-STATE("").    
FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia NO-LOCK NO-ERROR .
DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(45)".
DEFINE VAR X-MENSAJE-1 AS CHAR FORMAT "X(30)".

DEFINE FRAME F-Mensaje
     X-MENSAJE NO-LABEL SKIP
     X-MENSAJE-1 NO-LABEL 
     
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         NO-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         CENTERED
         TITLE "Espere un momento por favor ... ".

DEF BUFFER B-CTAS FOR CB-CTAS.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-cfga

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 cb-cfga.GenAut6 cb-cfga.Cc1Cta6 ~
cb-cfga.GenAut9 cb-cfga.Cc1Cta9 cb-cfga.GenAut 
&Scoped-define QUERY-STRING-DIALOG-1 FOR EACH cb-cfga SHARE-LOCK
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH cb-cfga SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DIALOG-1 cb-cfga
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 cb-cfga


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 Aceptar t-9 C-1 t-6 C-2 B-cancela t-3 
&Scoped-Define DISPLAYED-FIELDS cb-cfga.GenAut6 cb-cfga.Cc1Cta6 ~
cb-cfga.GenAut9 cb-cfga.Cc1Cta9 cb-cfga.GenAut 
&Scoped-define DISPLAYED-TABLES cb-cfga
&Scoped-define FIRST-DISPLAYED-TABLE cb-cfga
&Scoped-Define DISPLAYED-OBJECTS t-9 C-1 t-6 C-2 t-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Aceptar AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 14.43 BY 1.42.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 14.43 BY 1.42.

DEFINE VARIABLE C-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 7 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 7 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 1 GRAPHIC-EDGE    
     SIZE 74 BY 2.96.

DEFINE VARIABLE t-3 AS LOGICAL INITIAL no 
     LABEL "Regenerar  Otras Cuentas" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .69 NO-UNDO.

DEFINE VARIABLE t-6 AS LOGICAL INITIAL no 
     LABEL "Regenerar la Clase 6" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .69 NO-UNDO.

DEFINE VARIABLE t-9 AS LOGICAL INITIAL no 
     LABEL "Regenerar la Clase 9" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .69 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DIALOG-1 FOR 
      cb-cfga SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     cb-cfga.GenAut6 AT ROW 2.08 COL 16 COLON-ALIGNED
          LABEL "Crean la Clase 9"
          VIEW-AS FILL-IN 
          SIZE 34 BY .69
          BGCOLOR 7 
     cb-cfga.Cc1Cta6 AT ROW 2.08 COL 62 COLON-ALIGNED
          LABEL "Contra Cuenta" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 7 
     cb-cfga.GenAut9 AT ROW 2.88 COL 16 COLON-ALIGNED
          LABEL "Crean la Clase 6"
          VIEW-AS FILL-IN 
          SIZE 34 BY .69
          BGCOLOR 7 
     cb-cfga.Cc1Cta9 AT ROW 2.88 COL 62 COLON-ALIGNED
          LABEL "Contra Cuenta" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 7 
     cb-cfga.GenAut AT ROW 3.69 COL 16 COLON-ALIGNED
          LABEL "Crean Otras Cuentas"
          VIEW-AS FILL-IN 
          SIZE 34 BY .69
          BGCOLOR 7 
     Aceptar AT ROW 5 COL 56.14
     t-9 AT ROW 5.04 COL 2.57
     C-1 AT ROW 5.12 COL 39 COLON-ALIGNED
     t-6 AT ROW 6.12 COL 2.57
     C-2 AT ROW 6.12 COL 39 COLON-ALIGNED
     B-cancela AT ROW 6.62 COL 56.14
     t-3 AT ROW 7.19 COL 2.57
     "C O N F I G U R A C I O N" VIEW-AS TEXT
          SIZE 29 BY .69 AT ROW 1 COL 24
          FONT 0
     RECT-4 AT ROW 1.81 COL 1
     SPACE(2.28) SKIP(3.72)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Regeneración de Cuentas Automáticas".


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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN cb-cfga.Cc1Cta6 IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN cb-cfga.Cc1Cta9 IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN cb-cfga.GenAut IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN cb-cfga.GenAut6 IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN cb-cfga.GenAut9 IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-cfga"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Aceptar DIALOG-1
ON CHOOSE OF Aceptar IN FRAME DIALOG-1 /* Aceptar */
DO:
    ASSIGN 
           C-1
           C-2
           T-9
           T-6
           T-3. 
    IF C-1 > C-2 THEN DO:
       MESSAGE "Rango de meses Incorrecto"
       VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO C-1.
       RETURN  NO-APPLY.
    END.       
    RUN PROCESO.
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

ASSIGN C-1 = s-NroMes
       C-2 = s-NroMes.


     
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   RUN enable_UI.
   IF cb-cfga.genaut9  = "" THEN 
    DO: 
         T-9:SENSITIVE = FALSE.
    END.    
    IF cb-cfga.genaut6  = "" THEN 
    DO:
         T-6:SENSITIVE = FALSE.
    END.    
   IF cb-cfga.genaut  = ""  THEN 
    DO: 
         T-3:SENSITIVE = FALSE.
    END.    
   WAIT-FOR GO OF FRAME {&FRAME-NAME}.
   RUN disable_UI.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE con-mov DIALOG-1 
PROCEDURE con-mov :
FIND cb-cmov WHERE  cb-cmov.codcia   =  detalle.codcia    AND
                    cb-cmov.periodo  =  detalle.periodo   AND
                    cb-cmov.nromes   =  detalle.nromes    AND
                    cb-cmov.codope   =  detalle.codope    AND
                    cb-cmov.nroast   =  detalle.nroast 
                    NO-ERROR.
IF AVAIL cb-cmov THEN
    IF detalle.tpomov THEN
       ASSIGN  cb-cmov.hbemn1 = cb-cmov.hbemn1  + detalle.impmn1
               cb-cmov.hbemn2 = cb-cmov.hbemn2  + detalle.impmn2
               cb-cmov.hbemn3 = cb-cmov.hbemn3  + detalle.impmn3
               cb-cmov.totitm = cb-cmov.totitm + 1.
    ELSE
       ASSIGN  cb-cmov.dbemn1 = cb-cmov.dbemn1  + detalle.impmn1
               cb-cmov.dbemn2 = cb-cmov.dbemn2  + detalle.impmn2
               cb-cmov.dbemn3 = cb-cmov.dbemn3  + detalle.impmn3
               cb-cmov.totitm = cb-cmov.totitm  + 1.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cons-reg DIALOG-1 
PROCEDURE cons-reg :
DEFINE INPUT PARAMETER s-NroMes AS INTEGER.

x-Mensaje = "PROCESANDO MES: " + STRING(s-NroMes,"99").
DISPLAY x-Mensaje WITH FRAME F-MENSAJE.
PAUSE 0.
LAZO_I:
DO i = 1 TO NUM-ENTRIES( x-cta-auto ):

    x-llave = ENTRY(i,  x-cta-auto).    
    IF x-Llave = "" THEN NEXT LAZO_I.
    
    FOR EACH cb-dmov WHERE cb-dmov.codcia  = s-codcia    AND
                           cb-dmov.periodo = s-periodo   AND
                           cb-dmov.nromes  = s-NroMes    AND
                           cb-dmov.codcta  BEGINS (x-llave)    :
       X-NROITM = cb-dmov.NroItm.                    
       X-MENSAJE-1 = "PROCESANDO CUENTA: " + CB-DMOV.CODCTA.
       DISPLAY  X-MENSAJE-1 WITH FRAME F-MENSAJE.                    
       PAUSE 0.
       
       FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
                          cb-ctas.codcta = cb-dmov.codcta 
                          NO-LOCK NO-ERROR.
       IF avail cb-ctas  THEN DO: 
          CASE x-genaut : 
               WHEN 1 THEN DO:  
                    IF cb-ctas.CLFAUX = "@CT" THEN DO:
                       x-an1cta =  cb-dmov.codaux.
                       FIND B-CTAS WHERE B-CTAS.CODCIA = 0 AND
                                         B-CTAS.CODCTA = x-an1cta
                                         NO-LOCK NO-ERROR.
                       IF NOT AVAIL B-CTAS THEN x-an1cta = cb-ctas.an1cta.                  
                    END.  
                    ELSE x-an1cta = cb-ctas.an1cta.
                    
                    IF x-an1cta = "" THEN x-an1cta = cb-ctas.an1cta.
               END.
               OTHERWISE
                    x-an1cta = cb-ctas.an1cta.
          END CASE. 
          
          x-cc1cta = cb-ctas.cc1cta.
          
          FIND cb-ctas WHERE cb-ctas.codcia =  cb-codcia  AND 
                             cb-ctas.codcta =  x-an1cta
                             NO-LOCK NO-ERROR.
          IF avail cb-ctas THEN DO:   
             x-cc1cta = cb-ctas.cc1cta.
             IF x-cc1cta  = "" THEN  x-cc1cta = x-a-cc1cta.
                FIND cb-ctas WHERE cb-ctas.codcia =  cb-codcia  AND 
                                   cb-ctas.codcta =  x-Cc1cta
                                   NO-LOCK NO-ERROR.
                IF avail cb-ctas THEN DO:
                   X-NROITM = X-NROITM  + 1.
                   RUN GRABA(x-an1cta,cb-dmov.tpomov ).
                   RUN CON-MOV.
                   X-NROITM = X-NROITM + 1.
                   RUN GRABA(X-CC1CTA,NOT cb-dmov.tpomov ).
                   RUN CON-MOV.    
                END.
          END.
      END.
    END. /*FIN DEL FOR EACH */
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE del-mov DIALOG-1 
PROCEDURE del-mov :
FIND cb-cmov WHERE  cb-cmov.codcia   =  detalle.codcia    AND
                    cb-cmov.periodo  =  detalle.periodo   AND
                    cb-cmov.nromes   =  detalle.nromes    AND
                    cb-cmov.codope   =  detalle.codope    AND
                    cb-cmov.nroast   =  detalle.nroast 
                    NO-ERROR.
IF AVAIL cb-cmov THEN
    IF detalle.tpomov THEN
       ASSIGN  cb-cmov.hbemn1 = cb-cmov.hbemn1  - detalle.impmn1
               cb-cmov.hbemn2 = cb-cmov.hbemn2  - detalle.impmn2
               cb-cmov.hbemn3 = cb-cmov.hbemn3  - detalle.impmn3
               cb-cmov.totitm = cb-cmov.totitm - 1.
    ELSE
       ASSIGN  cb-cmov.dbemn1 = cb-cmov.dbemn1  - detalle.impmn1
               cb-cmov.dbemn2 = cb-cmov.dbemn2  - detalle.impmn2
               cb-cmov.dbemn3 = cb-cmov.dbemn3  - detalle.impmn3
               cb-cmov.totitm = cb-cmov.totitm - 1.
          
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
  DISPLAY t-9 C-1 t-6 C-2 t-3 
      WITH FRAME DIALOG-1.
  IF AVAILABLE cb-cfga THEN 
    DISPLAY cb-cfga.GenAut6 cb-cfga.Cc1Cta6 cb-cfga.GenAut9 cb-cfga.Cc1Cta9 
          cb-cfga.GenAut 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 Aceptar t-9 C-1 t-6 C-2 B-cancela t-3 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE graba DIALOG-1 
PROCEDURE graba :
DEFINE INPUT PARAMETER P-CODCTA AS CHAR.

DEFINE INPUT PARAMETER P-TPOMOV AS LOGICAL.

    CREATE DETALLE.
    ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
           DETALLE.Periodo  = cb-dmov.Periodo
           DETALLE.NroMes   = cb-dmov.NroMes
           DETALLE.CodOpe   = cb-dmov.CodOpe
           DETALLE.NroAst   = cb-dmov.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.Relacion = RECID(cb-dmov)
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.NroItm   = x-NroItm
           DETALLE.Codcta   = P-CODCTA
           DETALLE.CodDiv   = cb-dmov.CodDiv
           DETALLE.ClfAux   = cb-dmov.CLFAUX
           DETALLE.CodAux   = cb-dmov.CodCta
           DETALLE.NroRuc   = cb-dmov.NroRuc
           DETALLE.CodDoc   = cb-dmov.CodDoc
           DETALLE.NroDoc   = cb-dmov.NroDoc
           DETALLE.GloDoc   = cb-dmov.GloDoc
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.NroRef   = cb-dmov.NroRef
           DETALLE.FchDoc   = cb-dmov.FchDoc
           DETALLE.FchVto   = cb-dmov.FchVto
           DETALLE.tpomov   = p-tpomov
           DETALLE.ImpMn1   = cb-dmov.ImpMn1
           DETALLE.ImpMn2   = cb-dmov.ImpMn2
           DETALLE.ImpMn3   = cb-dmov.ImpMn3
           DETALLE.CCO      = cb-dmov.CCO
           DETALLE.TM       = cb-dmov.TM.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso DIALOG-1 
PROCEDURE proceso :
MESSAGE "Este procedimiento elimina las cuentas autom ticas"       SKIP
        "de los meses contables Seleccionados  y las regenera."    SKIP (2)
        "Se recomienda que su uso sea exclusivo y luego de"        SKIP 
        "concluido ejecutar el proceso de regeneraci¢n de saldos." SKIP (2)
        "Desea Continuar ? "  
    VIEW-AS ALERT-BOX BUTTONS YES-NO 
    TITLE  "Generaci¢n de Cuentas Autom ticas" 
    UPDATE rpta AS LOGICAL.
IF  NOT rpta THEN RETURN.    



PAUSE 0.           
SESSION:IMMEDIATE-DISPLAY = YES.

DO J= C-1 TO C-2 :
   X-MENSAJE = "".
   X-MENSAJE-1 = "Eliminando Automaticas Generadas del mes: " + STRING (J,"99").
   DISPLAY  X-MENSAJE-1 WITH FRAME F-MENSAJE.                    
   PAUSE 0.

   FOR EACH detalle WHERE detalle.codcia  = s-codcia  AND
                          detalle.periodo = s-periodo AND
                          detalle.nromes  = J AND 
                          detalle.TpoItm = "A" :
       RUN DEL-MOV.
       DELETE detalle.  
   END.    

   IF cb-cfga.genaut9  <> "" THEN 
      DO: 
        x-GenAut   = 1.
        x-cta-auto = cb-cfga.genaut9.
        x-a-cc1cta   = cb-cfga.cc1cta9.
        IF T-9 THEN RUN cons-reg(J).
      END.    
   IF cb-cfga.genaut6  <> "" THEN 
      DO:
        x-GenAut   = 2.
        x-cta-auto = cb-cfga.genaut6.
        x-a-cc1cta   = cb-cfga.cc1cta6.  
        IF T-6 THEN RUN cons-reg(J).
      END.    
    
   IF cb-cfga.genaut  <> ""  THEN 
      DO: 
        x-GenAut   = 3.
        x-cta-auto = cb-cfga.genaut.
        x-a-cc1cta   = "". 
        IF T-3 THEN RUN  cons-reg(J).
      END.    

END.
HIDE FRAME F-MENSAJE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

