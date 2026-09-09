&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
{CBD/CBGLOBAL.I}
{BIN/S-GLOBAL.I}

DEFINE VAR x-mensaje AS CHAR FORMAT "x(40)".
DEFINE FRAME f-auxiliar x-mensaje
WITH TITLE  "Espere un momento por favor" 
VIEW-AS DIALOG-BOX CENTERED NO-LABELS.
     
DEF VAR X-NROAST AS CHAR.
DEF VAR X-NROMES AS INTEGER.
DEF VAR X-CODOPE AS CHAR.
DEF VAR X-CODDIV AS CHAR.
DEF VAR X-GLODOC AS CHAR.

ASSIGN X-NROMES = 13
       X-CODOPE = "100"
       X-GLODOC = "ASIENTO AUTOMATICO DE CIERRE"
       X-NROAST = "000001".

DEF VAR I AS INTEGER.
ASSIGN I = 0.       

DEF VAR T-NOTA-S1 AS DECIMAL.
DEF VAR T-NOTA-S2 AS DECIMAL.

DEF VAR T-TPOBAL AS CHAR.
DEF VAR T-CODBAL AS CHAR.

DEF BUFFER B-DMOV FOR CB-DMOV.

DEF VAR X-NroItm as integer.
ASSIGN X-NroItm = 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1
&Scoped-define BROWSE-NAME b-cb-cfgd

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.cb-tbal

/* Definitions for BROWSE b-cb-cfgd                                     */
&Scoped-define FIELDS-IN-QUERY-b-cb-cfgd integral.cb-tbal.TpoBal ~
integral.cb-tbal.CodBal integral.cb-tbal.DesBal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cb-cfgd 
&Scoped-define FIELD-PAIRS-IN-QUERY-b-cb-cfgd
&Scoped-define OPEN-QUERY-b-cb-cfgd OPEN QUERY b-cb-cfgd FOR EACH integral.cb-tbal ~
      WHERE integral.cb-tbal.CodCia = s-codcia AND  ~
integral.cb-tbal.TpoBal = "C" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-b-cb-cfgd integral.cb-tbal
&Scoped-define FIRST-TABLE-IN-QUERY-b-cb-cfgd integral.cb-tbal


/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-b-cb-cfgd}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 b-cb-cfgd EDITOR-1 B-imprime ~
B-cancela 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Procesar" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 58.57 BY 5.04
     BGCOLOR 15 FGCOLOR 7 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.86 BY 2.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY b-cb-cfgd FOR 
      integral.cb-tbal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE b-cb-cfgd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cb-cfgd DIALOG-1 _STRUCTURED
  QUERY b-cb-cfgd NO-LOCK DISPLAY
      integral.cb-tbal.TpoBal
      integral.cb-tbal.CodBal
      integral.cb-tbal.DesBal
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 58.57 BY 4.19
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     b-cb-cfgd AT ROW 1 COL 1 HELP
          "Escoja Balance a Procesar"
     EDITOR-1 AT ROW 5.27 COL 1 NO-LABEL
     B-imprime AT ROW 10.77 COL 5.86
     B-cancela AT ROW 10.77 COL 44.14
     RECT-7 AT ROW 10.46 COL 1
     SPACE(0.70) SKIP(0.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Cierre de Período".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
/* BROWSE-TAB b-cb-cfgd RECT-7 DIALOG-1 */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME DIALOG-1        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cb-cfgd
/* Query rebuild information for BROWSE b-cb-cfgd
     _TblList          = "integral.cb-tbal"
     _Options          = "NO-LOCK"
     _Where[1]         = "integral.cb-tbal.CodCia = s-codcia AND 
integral.cb-tbal.TpoBal = ""C"""
     _FldNameList[1]   = integral.cb-tbal.TpoBal
     _FldNameList[2]   = integral.cb-tbal.CodBal
     _FldNameList[3]   = integral.cb-tbal.DesBal
     _Query            is OPENED
*/  /* BROWSE b-cb-cfgd */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Cierre de Período */
DO:
    APPLY "CHOOSE" TO B-imprime.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime DIALOG-1
ON CHOOSE OF B-imprime IN FRAME DIALOG-1 /* Procesar */
DO:
   T-TPOBAL = CB-TBAL.TpoBal:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
   T-CODBAL = CB-TBAL.CodBal:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
   IF I = 0 THEN 
   RUN GEN-TMP.
   I = I + 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME b-cb-cfgd
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

EDITOR-1 = "Este proceso tiene por finalidad Generar asientos automáticos de Cierre " +
           "resumidos en el mes 13, operación 000, Asiento 000001. " + 
           "Si ya existe un asiento este sera anulado y generado nuevamente. Este " +
           "proceso deber ser exclusivo y el único que ejecuten los usuarios del sistema. " + 
           "El asiento es asignado a una sola división para resumirlo".
           
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   RUN enable_UI.
   IF  SESSION:SET-WAIT-STATE("") THEN.    
   WAIT-FOR GO OF FRAME {&FRAME-NAME}.
   RUN disable_UI.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ANULA DIALOG-1 
PROCEDURE ANULA :
FOR EACH cb-dmov WHERE      cb-dmov.codcia   = s-codcia          AND
                            cb-dmov.periodo  = s-periodo         AND
                            cb-dmov.nromes   = x-nromes          AND   
                            cb-dmov.codope   = x-codope          AND
                            cb-dmov.nroast   = x-nroast :
    RUN cbd/cb-acmd.p(RECID(cb-dmov), NO, YES). 
    DELETE cb-dmov.
END.

FIND cb-cmov WHERE     cb-cmov.codcia   = s-codcia       AND
                       cb-cmov.periodo  = s-periodo      AND
                       cb-cmov.nromes   = x-nromes       AND
                       cb-cmov.codope   = x-codope       AND
                       cb-cmov.nroast   = x-nroast  
                       NO-ERROR.
IF AVAIL cb-cmov THEN DELETE cb-cmov.                   

RUN GRABA-CAB.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CALCULA-NOTA DIALOG-1 
PROCEDURE CALCULA-NOTA :
ASSIGN 
 T-NOTA-S1 = 0
 T-NOTA-S2 = 0.
    
FOR EACH CB-DBAL NO-LOCK WHERE CB-DBAL.TPOBAL = T-TPOBAL AND
                               CB-DBAL.CODBAL = T-CODBAL AND
                               CB-DBAL.ITEM = CB-NBAL.ITEM AND
                               CB-DBAL.CODCTA <> "" 
                               BREAK BY CB-DBAL.CODAUX :                               
    DISPLAY CB-DBAL.CODCTA  @ x-mensaje
    WITH FRAME f-auxiliar.
    PAUSE 0.
    IF CB-DBAL.CODAUX = "" THEN RUN INVIERTE-CUENTA.
    IF LAST-OF(CB-DBAL.CODAUX) AND
               CB-DBAL.CODAUX <> "" 
               THEN RUN TOTALIZA-NOTA.
END.

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
  DISPLAY EDITOR-1 
      WITH FRAME DIALOG-1.
  ENABLE RECT-7 b-cb-cfgd EDITOR-1 B-imprime B-cancela 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN-TMP DIALOG-1 
PROCEDURE GEN-TMP :
FIND FIRST GN-DIVI WHERE GN-DIVI.CODCIA = S-CODCIA AND
                         LENGTH(GN-DIVI.CODDIV ) = 5 NO-LOCK NO-ERROR.
IF  AVAIL GN-DIVI THEN X-CODDIV = GN-DIVI.CODDIV.

DISPLAY  "Eliminando movimiento Anterior" @  x-mensaje WITH FRAME F-AUXILIAR.
PAUSE 0.
RUN ANULA.

FOR EACH CB-NBAL NO-LOCK WHERE CB-NBAL.CodCia = s-codcia AND                                
                               CB-NBAL.TpoBal = T-TPOBAL AND 
                               CB-NBAL.CodBal = T-CODBAL AND 
                               CB-NBAL.NOTA   = "*" 
                               BREAK BY CB-NBAL.item     :                     
        DISPLAY CB-NBAL.Glosa  @ x-mensaje
        WITH FRAME f-auxiliar.
        PAUSE 0.
        RUN CALCULA-NOTA.
            
END. /*Fin del For Each*/
    
HIDE FRAME f-auxiliar.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRABA-CAB DIALOG-1 
PROCEDURE GRABA-CAB :
CREATE cb-cmov.
     ASSIGN 
        cb-cmov.CodCia  = s-codcia
        cb-cmov.Periodo = s-periodo 
        cb-cmov.NroMes  = x-nromes
        cb-cmov.CodOpe  = x-CodOpe
        cb-cmov.NroAst  = X-NROAST
        cb-cmov.FchAst  = DATE( 12, 31, s-periodo )
        cb-cmov.TpoCmb  = 1
        cb-cmov.Notast  = x-glodoc
        cb-cmov.GloAst  = x-glodoc
        cb-cmov.codmon  = 1
        CB-CMOV.USUARIO = S-USER-ID.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE INVIERTE-CUENTA DIALOG-1 
PROCEDURE INVIERTE-CUENTA :
DEF VAR T-SALDO1 AS DECIMAL.
DEF VAR T-SALDO2 AS DECIMAL.
  
FOR EACH CB-DMOV NO-LOCK WHERE CB-DMOV.CODCIA  = S-CODCIA   AND
                               CB-DMOV.PERIODO = S-PERIODO  AND
                               CB-DMOV.CODCTA  BEGINS CB-DBAL.CODCTA 
                               BREAK BY CB-DMOV.CODCTA : 
    IF FIRST-OF(CB-DMOV.CODCTA) THEN DO:          
       ASSIGN T-SALDO1 = 0 T-SALDO2 = 0.
       DISPLAY cb-DMOV.CODCTA  @ x-mensaje
       WITH FRAME f-auxiliar.
       PAUSE 0.
    END.         

    IF CB-DMOV.TPOMOV 
       THEN ASSIGN T-SALDO1   = T-SALDO1   + CB-DMOV.IMPMN1
                   T-SALDO2   = T-SALDO2   + CB-DMOV.IMPMN2      
                   T-NOTA-S1  = T-NOTA-S1  - CB-DMOV.IMPMN1
                   T-NOTA-S2  = T-NOTA-S2  - CB-DMOV.IMPMN2.

       ELSE ASSIGN T-SALDO1   = T-SALDO1   - CB-DMOV.IMPMN1
                   T-SALDO2   = T-SALDO2   - CB-DMOV.IMPMN2
                   T-NOTA-S1  = T-NOTA-S1  + CB-DMOV.IMPMN1
                   T-NOTA-S2  = T-NOTA-S2  + CB-DMOV.IMPMN2.
                   
    IF LAST-OF(CB-DMOV.CODCTA) THEN DO:
       IF T-SALDO1 <> 0 OR T-SALDO2 <> 0 THEN DO:
          X-NROITM = X-NROITM + 1.
          CREATE B-DMOV.
          ASSIGN B-DMOV.CODCIA    = S-CODCIA
                 B-DMOV.PERIODO   = S-PERIODO
                 B-DMOV.NROMES    = X-NROMES
                 B-DMOV.CODOPE    = X-CODOPE
                 B-DMOV.NROAST    = X-NROAST
                 B-DMOV.CODCTA    = CB-DMOV.CODCTA
                 B-DMOV.GLODOC    = X-GLODOC
                 B-DMOV.CODDIV    = X-CODDIV
                 B-DMOV.IMPMN1    = ABS(T-SALDO1)
                 B-DMOV.IMPMN2    = ABS(T-SALDO2)
                 B-DMOV.TPOMOV    = (T-SALDO1 < 0 )
                 B-DMOV.NROITM    = X-NROITM.
       END.   
    END.               
END.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TOTALIZA-NOTA DIALOG-1 
PROCEDURE TOTALIZA-NOTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF T-NOTA-S1 <> 0 OR T-NOTA-S2 <> 0 THEN DO:
   x-nroitm = x-nroitm + 1.
   CREATE B-DMOV.
   ASSIGN B-DMOV.CODCIA    = S-CODCIA
          B-DMOV.PERIODO   = S-PERIODO
          B-DMOV.NROMES    = X-NROMES
          B-DMOV.CODOPE    = X-CODOPE
          B-DMOV.NROAST    = X-NROAST
          B-DMOV.CODCTA    = CB-DBAL.CODCTA
          B-DMOV.GLODOC    = X-GLODOC
          B-DMOV.CODDIV    = X-CODDIV
          B-DMOV.IMPMN1    = ABS(T-NOTA-S1)
          B-DMOV.IMPMN2    = ABS(T-NOTA-S2)
          B-DMOV.TPOMOV    = (T-NOTA-S1 < 0 )
          B-DMOV.NROITM    = X-NROITM.
          IF CB-DBAL.CODCTA <> CB-DBAL.CODAUX THEN DO:
             IF B-DMOV.TPOMOV THEN ASSIGN B-DMOV.CODCTA = CB-DBAL.CODAUX.
             ELSE ASSIGN B-DMOV.CODCTA = CB-DBAL.CODCTA.
          END.
END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


