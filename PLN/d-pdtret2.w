&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEFINE SHARED VARIABLE s-codcia  AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia  AS CHAR FORMAT 'X(35)'.
DEFINE SHARED VARIABLE s-periodo AS INTEGER.
DEFINE SHARED VARIABLE s-nromes  AS INTEGER.
DEFINE SHARED VARIABLE s-nrosem  AS INTEGER.

DEFINE VARIABLE X-ARCHIVO AS CHARACTER .
DEFINE VARIABLE x-lin     AS CHAR FORMAT "x(200)".
DEFINE VARIABLE x-sctr    AS CHAR FORMAT "x(1)".
DEFINE VARIABLE x-ipsvid  AS CHAR FORMAT "x(1)".
DEFINE VARIABLE x-pension AS CHAR FORMAT "x(1)".
DEFINE VARIABLE x-coddoc  AS CHAR FORMAT "x(2)".
DEFINE VARIABLE x-nrodoc  AS CHAR FORMAT "x(15)".
DEFINE VARIABLE x-sexo    AS CHAR FORMAT "x(1)".
DEFINE VARIABLE x-ok      AS LOGICAL.

DEFINE VARIABLE x-fecing AS CHAR FORMAT "X(10)".
DEFINE VARIABLE x-fecces AS CHAR FORMAT "X(10)".
DEFINE VARIABLE x-fecnac AS CHAR FORMAT "X(10)".
DEFINE VARIABLE x-fecpen AS CHAR FORMAT "X(10)".
DEFINE VARIABLE x-situ   AS CHAR FORMAT "X(2)".
DEFINE VARIABLE x-tipo   AS CHAR FORMAT "X(2)".
DEFINE VARIABLE I        AS INTEGER.
DEFINE VARIABLE II       AS INTEGER.
DEFINE VARIABLE x   AS CHAR FORMAT "x(200)".




FIND Gn-Cias WHERE Gn-Cias.Codcia = S-CODCIA 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-Cias THEN DO:
   MESSAGE "Tablas Gn-Cias no existe ....Verifique " 
           VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.



DEFINE TEMP-TABLE PERSONAL 
FIELD Codper LIKE PL-PERS.Codper.

DEFINE TEMP-TABLE Tempo 
    FIELD CodPer AS CHAR FORMAT "X(6)"
    FIELD Coddoc AS CHAR FORMAT "X(2)"
    FIELD NroDoc AS CHAR FORMAt "X(15)"
    FIELD NroDia AS DECI FORMAT ">9"
    FIELD ValCal AS DECI FORMAT ">>>>>>>>>9.99" EXTENT 8.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 CMB-mes F-CalCulo C-Planilla Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS CMB-mes F-CalCulo C-Planilla 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE C-Planilla AS CHARACTER FORMAT "X(20)":U 
     LABEL "Planilla" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 24 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE CMB-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CalCulo AS CHARACTER FORMAT "X(256)":U INITIAL "001,004,008" 
     LABEL "Calculo" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 3.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     CMB-mes AT ROW 1.31 COL 9 COLON-ALIGNED
     F-CalCulo AT ROW 2.73 COL 9 COLON-ALIGNED
     C-Planilla AT ROW 1.31 COL 24 COLON-ALIGNED
     Btn_OK AT ROW 1.5 COL 52
     Btn_Cancel AT ROW 2.69 COL 52
     RECT-17 AT ROW 1.08 COL 1.57
     SPACE(13.28) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Retenciones y Contribuciones 0600 PDT"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Retenciones y Contribuciones 0600 PDT */
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
    ASSIGN
        CMB-mes
        C-Planilla
        F-calculo.
   FIND PL-PLAN WHERE PL-PLAN.Despln BEGINS C-Planilla NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PL-PLAN THEN DO:
      MESSAGE "Seleccione Tipo de Planilla "
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO C-Planilla.
      RETURN NO-APPLY.
   END.
   

   IF AVAILABLE PL-PLAN THEN DO:
      IF PL-PLAN.TipPln THEN RUN Mensual.
      ELSE RUN Semanal.
   END.

   RUN Procesa.
         
   MESSAGE "Se ha generado con exito el archivo " x-archivo 
            VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


ASSIGN
    CMB-mes    = s-nromes.

/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY CMB-mes F-CalCulo C-Planilla 
      WITH FRAME D-Dialog.
  ENABLE RECT-17 CMB-mes F-CalCulo C-Planilla Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  DEF VAR F-Planilla AS CHAR.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-Planilla = " ".
    FOR EACH integral.PL-PLAN NO-LOCK:
        ASSIGN F-Planilla = F-Planilla + "," + integral.PL-PLAN.Despln.
    END.
    ASSIGN C-Planilla:LIST-ITEMS IN FRAME {&FRAME-NAME} = F-Planilla.
  
  END.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Mensual D-Dialog 
PROCEDURE Mensual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Cargamos el temporal con los ingresos */
FOR EACH PL-FLG-MES WHERE PL-FLG-MES.Codcia = s-codcia AND
                          PL-FLG-MES.Periodo = s-periodo AND
                          PL-FLG-MES.Codpln = PL-PLAN.Codpln AND
                          PL-FLG-MES.Nromes = cmb-mes:
 FIND PL-PERS WHERE PL-PERS.COdcia = s-codcia AND
                    Pl-PERS.Codper = PL-FLG-MES.Codper 
                    NO-LOCK NO-ERROR.
 
 IF NOT AVAILABLE PL-PERS THEN NEXT.
                    
 DO I = 1 TO NUM-ENTRIES(F-calculo):
    FOR EACH PL-MOV-MES WHERE
            PL-MOV-MES.CodCia  = s-CodCia AND
            PL-MOV-MES.Periodo = s-Periodo AND
            PL-MOV-MES.NroMes  = cmb-mes AND
            PL-MOV-MES.CodPln  = PL-PLAN.Codpln AND
            PL-MOV-MES.CodCal  = INTEGER(ENTRY(I,f-calculo)) AND
            PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer :
            
        IF PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
           FIND Tempo WHERE Tempo.Codper = PL-MOV-MES.CodPer
                            NO-ERROR.
           IF NOT AVAILABLE Tempo THEN DO:                 
              CREATE Tempo.
              ASSIGN
              Tempo.Codper = Pl-MOV-MES.Codper
              Tempo.Coddoc = "01"
              Tempo.Nrodoc = PL-PERS.NroDocId.
           END.

/*
           IF PL-MOV-MES.CodMov = 100 AND
              (PL-MOV-MES.CodCal = 01 OR
              PL-MOV-MES.CodCal = 03)
              THEN DO:                  
                  tempo.Nrodia = tempo.Nrodia + PL-MOV-MES.ValCal.
              END.
           IF PL-MOV-MES.CodMov = 405 AND 
              (PL-MOV-MES.CodCal = 01 OR 
               PL-MOV-MES.CodCal = 03) THEN DO:
               tempo.valcal[1] = tempo.valcal[1] + Pl-MOV-MES.ValCal.               
           END.

*/           
           If   PL-MOV-MES.CodMov = 118 OR 
                PL-MOV-MES.CodMov = 142 OR 
                PL-MOV-MES.CodMov = 501 OR 
                PL-MOV-MES.CodMov = 502 OR 
                PL-MOV-MES.CodMov = 503 OR 
                PL-MOV-MES.CodMov = 504 
           THEN tempo.nrodia    = tempo.nrodia + Pl-MOV-MES.ValCal.            
           
           CASE PL-MOV-MES.CodMov:
                WHEN 408 then tempo.valcal[3] = tempo.valcal[3] + Pl-MOV-MES.ValCal. 
                WHEN 407 then tempo.valcal[4] = tempo.valcal[4] + Pl-MOV-MES.ValCal. 
                WHEN 405 then tempo.valcal[5] = tempo.valcal[5] + Pl-MOV-MES.ValCal. 
                WHEN 215 then tempo.valcal[6] = tempo.valcal[6] + Pl-MOV-MES.ValCal.
                                            
           END.          
        END.
    END.
 END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa D-Dialog 
PROCEDURE Procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
x-archivo = "c:\0600" + string(s-periodo,"9999") + string(cmb-mes,"99") + TRIM(Gn-Cias.Libre-C[1]) + ".djt".  
def var x-dias as integer.
def var x-fec as date.
if cmb-mes = 12 then x-fec = date(01,01,s-periodo + 1) - 1.
else x-fec = date(cmb-mes + 1,01,s-periodo) - 1.
x-dias = day(x-fec).

output to value(x-archivo).

for each tempo :
/*
  x = x + tempo.coddoc + "|" + tempo.nrodoc + "|" + STRING(tempo.nrodia) + "|" .
  x = x + if tempo.valcal[1] > 0 then string(tempo.valcal[1],">>>>>>>>9.99") + "|" else "|" .
  x = x + if tempo.valcal[2] > 0 then string(tempo.valcal[2],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[3] > 0 then string(tempo.valcal[3],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[4] > 0 then string(tempo.valcal[4],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[5] > 0 then string(tempo.valcal[5],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[6] > 0 then string(tempo.valcal[6],">>>>>>>>9.99") + "|" else "|".
  x = x + "||".
*/
  x = x + tempo.coddoc + "|" + tempo.nrodoc + "|" + STRING(x-dias - tempo.nrodia) + "|" .
  x = x + "|" .
  x = x + string(tempo.valcal[3],">>>>>>>>9.99") + "|" .
  x = x + string(tempo.valcal[4],">>>>>>>>9.99") + "|" .
  x = x + "|" .
  x = x + string(tempo.valcal[5],">>>>>>>>9.99") + "|" .
  x = x + string(tempo.valcal[6],">>>>>>>>9.99") + "|" .
  x = x + "||".

  DISPLAY x WITH no-box no-labels no-underline WIDTH 300.
  x = "".
end.  

output close.


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Semanal D-Dialog 
PROCEDURE Semanal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Cargamos el temporal con los ingresos */

FOR EACH PL-SEM NO-LOCK WHERE PL-SEM.COdcia = S-CODCIA AND
                              PL-SEM.Periodo = S-PERIODO AND
                              PL-SEM.Nromes  = CMB-Mes:
II = PL-SEM.NroSem.                    

FOR EACH PL-FLG-SEM WHERE PL-FLG-SEM.Codcia = s-codcia AND
                          PL-FLG-SEM.Periodo = s-periodo AND
                          PL-FLG-SEM.Codpln = PL-PLAN.Codpln AND
                          PL-FLG-SEM.Nrosem = II:
 FIND PL-PERS WHERE PL-PERS.COdcia = s-codcia AND
                    Pl-PERS.Codper = PL-FLG-SEM.Codper 
                    NO-LOCK NO-ERROR.
 
 IF NOT AVAILABLE PL-PERS THEN NEXT.
                    
 DO I = 1 TO NUM-ENTRIES(F-Calculo):
    FOR EACH PL-MOV-SEM WHERE
            PL-MOV-SEM.CodCia  = s-CodCia AND
            PL-MOV-SEM.Periodo = s-Periodo AND
            PL-MOV-SEM.Nrosem  = II AND
            PL-MOV-SEM.CodPln  = PL-PLAN.Codpln AND
            PL-MOV-SEM.CodCal  = INTEGER(ENTRY(I,F-Calculo)) AND
            PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer :
            
        IF PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
           FIND Tempo WHERE Tempo.Codper = PL-MOV-SEM.CodPer
                            NO-ERROR.
           IF NOT AVAILABLE Tempo THEN DO:                 
              CREATE Tempo.
              ASSIGN
              Tempo.Codper = Pl-MOV-SEM.Codper
              Tempo.Coddoc = "01"
              Tempo.Nrodoc = PL-PERS.NroDocId.
           END.

/*
           IF PL-MOV-MES.CodMov = 100 AND
              (PL-MOV-MES.CodCal = 01 OR
              PL-MOV-MES.CodCal = 03)
              THEN DO:                  
                  tempo.Nrodia = tempo.Nrodia + PL-MOV-MES.ValCal.
              END.
           IF PL-MOV-MES.CodMov = 405 AND 
              (PL-MOV-MES.CodCal = 01 OR 
               PL-MOV-MES.CodCal = 03) THEN DO:
               tempo.valcal[1] = tempo.valcal[1] + Pl-MOV-MES.ValCal.               
           END.
*/           
           If   PL-MOV-SEM.CodMov = 118 OR 
                PL-MOV-SEM.CodMov = 142 OR 
                PL-MOV-SEM.CodMov = 501 OR 
                PL-MOV-SEM.CodMov = 502 OR 
                PL-MOV-SEM.CodMov = 503 OR 
                PL-MOV-SEM.CodMov = 504 
           THEN tempo.nrodia    = tempo.nrodia + Pl-MOV-MES.ValCal.            

           CASE PL-MOV-SEM.CodMov:
                WHEN 405 then tempo.valcal[5] = tempo.valcal[5] + Pl-MOV-SEM.ValCal. 
                WHEN 215 then tempo.valcal[6] = tempo.valcal[6] + Pl-MOV-SEM.ValCal.                
           END.          
           
        END.
    END.
 END.
END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


