&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEFINE VAR x-Mensaje1 AS CHAR FORMAT "X(40)".

DEFINE FRAME f-Mensaje x-Mensaje1 WITH NO-LABELS VIEW-AS DIALOG-BOX CENTERED
       TITLE "Procesando, espere un momento por favor ... ".
        

/* Parameters Definitions ---                                           */

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR cb-CodCia AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-periodo AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VAR x-CodOpe AS CHAR.
DEFINE VAR x-NroAst AS CHAR.
DEFINE VAR x-fchast AS DATE.
DEFINE VAR x-TpoCmb AS DECIMAL.
DEFINE VAR x-TotItm AS DECIMAL.
DEFINE VAR x-dbemn1 AS DECIMAL.
DEFINE VAR x-Hbemn1 AS DECIMAL.
DEFINE VAR F-CAB AS LOGICAL INIT NO.
DEFINE VAR I-31-12-Per-ant AS DECIMAL.

DEFINE BUFFER B-DMOV FOR CB-DMOV.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES aj-cfga

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog aj-cfga.Codope aj-cfga.Nroast 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH aj-cfga SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH aj-cfga SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog aj-cfga
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog aj-cfga


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-23 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS aj-cfga.Codope aj-cfga.Nroast 
&Scoped-define DISPLAYED-TABLES aj-cfga
&Scoped-define FIRST-DISPLAYED-TABLE aj-cfga
&Scoped-Define DISPLAYED-OBJECTS F-NroMes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Salir" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Generar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE F-NroMes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 4.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      aj-cfga SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 2.35 COL 32.57
     F-NroMes AT ROW 2.54 COL 16.43 COLON-ALIGNED
     aj-cfga.Codope AT ROW 3.35 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .81
     Btn_Cancel AT ROW 3.54 COL 32.57
     aj-cfga.Nroast AT ROW 4.15 COL 16.43 COLON-ALIGNED
          LABEL "N£mero de Asiento"
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .81
     "Asiento Contable a Generar" VIEW-AS TEXT
          SIZE 20.14 BY .81 AT ROW 1.38 COL 2.86
     RECT-23 AT ROW 1.08 COL 1.29
     SPACE(0.27) SKIP(0.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Generaci¢n de Asiento de Ajuste"
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

/* SETTINGS FOR FILL-IN aj-cfga.Codope IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroMes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN aj-cfga.Nroast IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.aj-cfga"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Generaci¢n de Asiento de Ajuste */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Generar */
DO:
  RUN PROCESO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AGOTAMIENTO D-Dialog 
PROCEDURE AGOTAMIENTO :
/*------------------------------------------------------------------------------
  Purpose: AGOTAMIENTO    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcta AS CHAR.
DEFINE INPUT PARAMETER p-ctaaft AS CHAR.
DEFINE INPUT PARAMETER p-ctrcta AS CHAR.

DEFINE VAR VAL-HIS      AS DECIMAL.
DEFINE VAR REI-ANT      AS DECIMAL.
DEFINE VAR REI-MES      AS DECIMAL.
DEFINE VAR Val-Ajt      AS DECIMAL.
DEFINE VAR cargos       AS DECIMAL EXTENT 14.
DEFINE VAR i            AS INTEGER.
DEFINE VAR Mes-inicio   AS INTEGER.
DEFINE VAR saldo        AS DECIMAL.
DEFINE VAR saldo-ant    AS DECIMAL.
DEFINE VAR t-rowid      AS ROWID.
DEFINE VAR x-indice     AS DECIMAL.

FOR EACH CB-DMOV NO-LOCK WHERE CB-DMOV.CODCIA  =  S-CODCIA  AND
                               CB-DMOV.PERIODO =  S-PERIODO AND
                               CB-DMOV.CODCTA  =  P-CODCTA  AND
                               CB-DMOV.NROMES <=  S-NROMES
                           BREAK BY CB-DMOV.CODDIV
                                 BY CB-DMOV.CODAUX
                                 BY CB-DMOV.CODDOC
                                 BY CB-DMOV.NRODOC :
      
                                          
       IF FIRST-OF (CB-DMOV.NRODOC) THEN DO:
          T-ROWID = ROWID(CB-DMOV).
          Mes-Inicio   = CB-DMOV.NROMES.
          saldo        = 0.
          saldo-ant    = 0.
          VAL-HIS      = 0.
          Val-Ajt      = 0.
          REI-ANT      = 0.
          REI-MES      = 0.
          x-indice     = 0.
          DO i = 1 TO 14 : 
             cargos[i] = 0. 
          END.
       END.
       
       IF NOT cb-dmov.tpomov THEN
          cargos[ cb-dmov.nromes + 1 ] = cargos[ cb-dmov.nromes + 1 ] + cb-dmov.impmn1.
          
       VAL-HIS = IF CB-DMOV.TPOMOV THEN VAL-HIS - CB-DMOV.IMPMN1 ELSE VAL-HIS + CB-DMOV.IMPMN1.
       IF LAST-OF (CB-DMOV.NRODOC) THEN DO:
          saldo = VAL-HIS.
          LAZO:
          DO I = S-NROMES + 1 TO 1 by -1 :                
             saldo-ant = saldo.
             saldo = saldo  - cargos[ i ] .
             IF I = 1 THEN x-indice = I-31-12-PER-ANT.
             ELSE          x-indice = aj-inme.indice[ i - 1].             
             IF saldo > 0 then val-ajt = val-ajt + cargos[i] * aj-inme.indice[s-nromes] / x-indice.
             ELSE DO:
                  val-ajt = val-ajt + saldo-ant * aj-inme.indice[s-nromes] / x-indice.
                  LEAVE LAZO.
             END.
          END.
          FIND LAST B-DMOV WHERE B-DMOV.CODCIA  = CB-DMOV.CODCIA  AND
                                 B-DMOV.PERIODO = CB-DMOV.PERIODO AND          
                                 B-DMOV.CODCTA  = P-CTAAFT        AND
                                 B-DMOV.CODDIV  = CB-DMOV.CODDIV  AND
                                 B-DMOV.CODAUX  = CB-DMOV.CODAUX  AND
                                 B-DMOV.CODDOC  = CB-DMOV.CODDOC  AND
                                 B-DMOV.NRODOC  = CB-DMOV.NRODOC  AND
                                 B-DMOV.NROMES  < CB-DMOV.NROMES
                                 NO-LOCK NO-ERROR.
          IF AVAIL B-DMOV THEN REI-ANT = B-DMOV.IMPMN1 .
                          ELSE REI-ANT = VAL-HIS.                      
          REI-MES = VAL-AJT - REI-ANT.
          IF REI-MES <> 0 THEN DO:
             RUN GEN-LIN(P-CTAAFT , REI-MES , FALSE  , T-rowid ).
             RUN GEN-LIN(P-CTRCTA , REI-MES , TRUE   , T-rowid ).
          END.   
       END.
      
END. /* FIN DEL FOR EACH */
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
  DISPLAY F-NroMes 
      WITH FRAME D-Dialog.
  IF AVAILABLE aj-cfga THEN 
    DISPLAY aj-cfga.Codope aj-cfga.Nroast 
      WITH FRAME D-Dialog.
  ENABLE RECT-23 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN-CAB D-Dialog 
PROCEDURE GEN-CAB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
create cb-cmov.
assign
cb-cmov.Codcia = s-codcia 
cb-cmov.Codope = x-codope 
cb-cmov.DbeMn1 = x-DbeMn1
cb-cmov.HbeMn1 = x-HbeMn1
cb-cmov.Fchast = x-fchast  
cb-cmov.GloAst = "ASIENTO AUTOMATICO DE AJUSTE"  
cb-cmov.Notast = "ASIENTO AUTOMATICO DE AJUSTE"  
cb-cmov.Nroast = x-nroast 
cb-cmov.Nromes = s-nromes
cb-cmov.Periodo = s-periodo 
cb-cmov.Totitm  = x-totitm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN-LIN D-Dialog 
PROCEDURE GEN-LIN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER P-CODCTA AS CHAR.
DEFINE INPUT PARAMETER P-S-AJTE AS DECIMAL.
DEFINE INPUT PARAMETER P-TPOMOV AS LOGICAL.
DEFINE INPUT PARAMETER P-ROWID  AS ROWID.

FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                   CB-CTAS.CODCTA = P-CODCTA
                   NO-LOCK NO-ERROR.

IF NOT AVAIL CB-CTAS THEN DO:
   Message "Cuenta no registrada"
   VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.                   

FIND B-DMOV WHERE ROWID(B-DMOV) = P-ROWID NO-LOCK NO-ERROR.
IF NOT AVAIL B-DMOV THEN DO:
   Message "Registro no entrado en GEN-LIN"
   VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.


CREATE CB-DMOV.
X-TotItm = X-TotItm + 1.

ASSIGN
cb-dmov.CodCia    = s-codcia
cb-dmov.Periodo   = s-periodo
cb-dmov.Codope    = x-codope
cb-dmov.NroMes    = s-nromes
cb-dmov.Nroitm    = X-TotItm
cb-dmov.cco       = B-DMOV.cco 
cb-dmov.Clfaux    = B-DMOV.clfaux
cb-dmov.Codaux    = B-DMOV.codaux
cb-dmov.Codcta    = P-CODCTA
cb-dmov.CodDiv    = B-DMOV.CODDIV
cb-dmov.Coddoc    = B-DMOV.CODDOC
cb-dmov.Codmon    = 1  
cb-dmov.Fchdoc    = x-fchast 
cb-dmov.Fchvto    = x-fchast
cb-dmov.flgact    = yes 
cb-dmov.Glodoc    = B-DMOV.GLODOC
cb-dmov.ImpMn1    = ABS(P-S-AJTE)
cb-dmov.Nroast    = X-nroast
cb-dmov.Nrodoc    = B-DMOV.NRODOC
cb-dmov.Nroref    = B-DMOV.NroRef
cb-dmov.TpoMov    = IF P-S-AJTE < 0 THEN NOT P-TPOMOV ELSE P-TPOMOV.

IF cb-dmov.TpoMov then x-dbeMn1 = x-DbeMn1 + cb-dmov.impmn1.
                  else x-dbeMn1 = x-HbeMn1 + cb-dmov.impmn1.

run cbd/cb-acmd.p  ( recid(cb-dmov) , yes , yes ).

F-CAB = YES.

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
  FIND FIRST aj-cfga NO-LOCK NO-ERROR.
  IF NOT AVAILABLE aj-cfga THEN DO :
     MESSAGE " NO se ha configurado el ASIENTO destino " VIEW-AS ALERT-BOX.
     RETURN "ERROE".
  END.   
  
  x-CodOpe = aj-cfga.CodOpe.
  f-NroMes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(s-NroMes).
  aj-cfga.CodOpe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = aj-cfga.CodOpe.
  aj-cfga.NroAst:SCREEN-VALUE IN FRAME {&FRAME-NAME} = aj-cfga.NroAst.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO D-Dialog 
PROCEDURE PROCESO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR i as integer.
/* Anulando movimiento anterior */

RUN VALIDA.
IF RETURN-VALUE = "ERROR" THEN RETURN.

FIND FIRST cb-dmov WHERE cb-dmov.CodCia  = s-CodCia  AND
                         cb-dmov.periodo = s-Periodo AND 
                         cb-dmov.NroMes  = s-NroMes  AND 
                         cb-dmov.CodOpe  = x-Codope  AND
                         cb-dmov.NroAst  = x-NroAst
                         NO-LOCK NO-ERROR.
IF AVAIL( cb-dmov) THEN 
        RUN ADM/CB-ANAST.P( cb-dmov.CodCia  ,
                   cb-dmov.Periodo ,
                   cb-dmov.NroMes  ,
                   cb-dmov.CodOpe  ,
                   cb-dmov.NroAst ).

IF S-NroMes = 12 THEN x-fchast = date ( 12, 31 , s-periodo).
                 ELSE x-fchast = date ( s-nromes + 1 , 1, s-periodo) - 1.


FOR EACH CB-CFGC NO-LOCK WHERE CB-CFGC.CODCIA = CB-CODCIA AND
                               CB-CFGC.CODCFG = 1         AND
                               CB-CFGC.CTAAFT <> ""       AND
                               CB-CFGC.CTRCTA <> ""       AND
                               CB-CFGC.ORIGEN   
                               BREAK BY CB-CFGC.CODCTA :
                               
    FOR EACH CB-CTAS NO-LOCK WHERE cb-Ctas.CodCta BEGINS ( CB-CFGC.CodCta ) : 
        X-MENSAJE1 = "Procesando Cuenta: " +  CB-CTAS.CODCTA .
        DISPLAY X-MENSAJE1 WITH FRAME F-MENSAJE.
        PAUSE 0.                   
        CASE CB-CFGC.METODO :
             WHEN "S" THEN RUN SALDO-PARTIDA(cb-ctas.codcta ,
                                             cb-cfgc.ctaaft ,
                                             cb-cfgc.ctrcta) .
             WHEN "A" THEN RUN AGOTAMIENTO  (cb-ctas.codcta ,
                                             cb-cfgc.ctaaft ,
                                             cb-cfgc.ctrcta) .                                         
        END.                     
    END.

END.

RUN GEN-CAB.

HIDE FRAME F-MENSAJE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saldo-partida D-Dialog 
PROCEDURE saldo-partida :
/*------------------------------------------------------------------------------
  Purpose: SALDO DE PARTIDA    
  Parameters:  <none>
  Notes: W.R.C.      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-codcta AS CHAR.
  DEFINE INPUT PARAMETER p-ctaaft AS CHAR.
  DEFINE INPUT PARAMETER p-ctrcta AS CHAR.
  
  DEFINE VAR VAL-HIS AS DECIMAL.
  DEFINE VAR REI-ANT AS DECIMAL.
  DEFINE VAR REI-MES AS DECIMAL.
  DEFINE VAR Val-Ajt AS DECIMAL.
  
  DEFINE VAR Mes-inicio AS INTEGER.
  
  DEFINE VAR t-rowid AS ROWID.
  
  FOR EACH CB-DMOV NO-LOCK WHERE CB-DMOV.CODCIA  =  S-CODCIA  AND
                                 CB-DMOV.PERIODO =  S-PERIODO AND
                                 CB-DMOV.CODCTA  =  P-CODCTA  AND
                                 CB-DMOV.NROMES <=  S-NROMES
                                 BREAK BY CB-DMOV.CODDIV
                                       BY CB-DMOV.CODAUX
                                       BY CB-DMOV.CODDOC
                                       BY CB-DMOV.NRODOC :
                                            
      IF FIRST-OF (CB-DMOV.NRODOC) THEN DO:
         T-ROWID = ROWID(CB-DMOV).
         Mes-Inicio   = CB-DMOV.NROMES.
         VAL-HIS      = 0.
         Val-Ajt      = 0.
         REI-ANT      = 0.
         REI-MES      = 0.
      END.
  
      IF CB-DMOV.NROMES < Mes-Inicio THEN DO:
         Mes-Inicio = CB-DMOV.NROMES.
         T-ROWID = ROWID(CB-DMOV).
      END.   
      
      VAL-HIS = IF CB-DMOV.TPOMOV THEN VAL-HIS - CB-DMOV.IMPMN1 ELSE VAL-HIS + CB-DMOV.IMPMN1.
  
      IF LAST-OF (CB-DMOV.NRODOC) THEN DO:
         IF Mes-Inicio = 0 THEN VAL-AJT  =  VAL-HIS * aj-inme.indice[s-nromes] / I-31-12-Per-ant.
                           ELSE VAL-AJT  =  VAL-HIS * aj-inme.indice[s-nromes] / aj-inme.indice[Mes-Inicio].
         FIND LAST B-DMOV WHERE B-DMOV.CODCIA  = CB-DMOV.CODCIA  AND
                                B-DMOV.PERIODO = CB-DMOV.PERIODO AND          
                                B-DMOV.CODCTA  = P-CTAAFT        AND
                                B-DMOV.CODDIV  = CB-DMOV.CODDIV  AND
                                B-DMOV.CODAUX  = CB-DMOV.CODAUX  AND
                                B-DMOV.CODDOC  = CB-DMOV.CODDOC  AND
                                B-DMOV.NRODOC  = CB-DMOV.NRODOC  AND
                                B-DMOV.NROMES  < CB-DMOV.NROMES
                                NO-LOCK NO-ERROR.
         IF AVAIL B-DMOV THEN REI-ANT = IF NOT CB-DMOV.TPOMOV THEN CB-DMOV.IMPMN1 
                                                            ELSE - CB-DMOV.IMPMN1.
                         ELSE REI-ANT = VAL-HIS.
                                                                                    
         REI-MES = VAL-AJT - REI-ANT.
         
         IF REI-MES <> 0 THEN DO:
            RUN GEN-LIN(P-CTAAFT , REI-MES , FALSE  , T-rowid ).
            RUN GEN-LIN(P-CTRCTA , REI-MES , TRUE   , T-rowid ).
         END.   
      END.
  END. /* FIN DEL FOR EACH */

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "aj-cfga"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDA D-Dialog 
PROCEDURE VALIDA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR I AS INTEGER.
  
  IF s-NroMes < 1 or s-NroMes > 14 THEN DO :
     MESSAGE "Invalido Nro de Mes " s-nromes
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR".   
  END.
  
  FIND CB-PERI WHERE CB-PERI.CodCia  = s-Codcia  AND
                     CB-PERI.PERIODO = s-periodo
                     NO-LOCK NO-ERROR.
  IF NOT AVAIL CB-PERI THEN DO:
     MESSAGE "Periodo no Registrado"
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR". 
  END.
  
  IF CB-PERI.MesCie[s-nromes + 1 ] THEN DO:
     MESSAGE "Mes contable cerrado" 
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR". 
  END.
  
  IF AVAIL AJ-CFGA THEN DO:
     x-Codope = AJ-CFGA.CodOpe.
     x-NroAst = AJ-CFGA.NroAst.
  END.
  
  ELSE DO:
     MESSAGE "Configuraci¢n de Asiento a generar incorrecta"
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR".
  END.
  
  FIND cb-oper WHERE cb-oper.CODCIA = CB-CODCIA AND
                     cb-oper.CODOPE = x-CodOpe 
                     NO-LOCK NO-ERROR.
  IF NOT AVAIL cb-oper THEN DO:
    MESSAGE "Operaci¢n " x-codope " no registrada" 
    VIEW-AS ALERT-BOX ERROR.
    RETURN "ERROR".
  END.     
  
  FIND AJ-INME WHERE AJ-INME.PERIODO = s-periodo - 1 NO-LOCK NO-ERROR.
  IF NOT AVAIL AJ-INME THEN DO:
     MESSAGE "Registro de indices mensuales del " SKIP
             "periodo anterior no registrado"
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR".
  END.
  
  IF aj-inme.indice[12] = 0 THEN DO :
     MESSAGE "Indice mensual" aj-inme.periodo "-"  "12 incorrecto"
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR".
  END.
  
  I-31-12-Per-Ant = aj-inme.indice[12].
  
  FIND AJ-INME WHERE AJ-INME.PERIODO = S-PERIODO NO-LOCK NO-ERROR.
  
  IF NOT AVAIL AJ-INME THEN DO:
     MESSAGE "Registro de indices mensuales del periodo no registrado"
     VIEW-AS ALERT-BOX ERROR.
     RETURN "ERROR".
  END.
  
  DO i = 1 TO s-nromes :  
     IF aj-inme.indice[i] <= 0 THEN DO :
        MESSAGE "Indice mensual" aj-inme.periodo "-" i "incorrecto"
        VIEW-AS ALERT-BOX ERROR.
        RETURN "ERROR".  
     END.  
  END.
    
  RETURN "".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

