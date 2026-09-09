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
DEFINE VARIABLE x   AS CHAR FORMAT "x(200)".



DEFINE VARIABLE I  AS INTEGER .
DEFINE VARIABLE II AS INTEGER .
DEFINE VARIABLE X-CODCAL AS CHAR.


FIND Empresas WHERE Empresas.Codcia = S-CODCIA 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Empresas THEN DO:
   MESSAGE "Tablas de Empresas no existe ....Verifique " 
           VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

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
&Scoped-Define ENABLED-OBJECTS RECT-22 RECT-17 CMB-mes F-CalEmp F-CalObr ~
CMB-sem-D CMB-sem-H Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS CMB-mes F-CalEmp F-CalObr CMB-sem-D ~
CMB-sem-H 

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

DEFINE VARIABLE CMB-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE CMB-sem-D AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Semana   De" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53" 
     SIZE 7.14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE CMB-sem-H AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "A" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53" 
     SIZE 7.14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CalEmp AS CHARACTER FORMAT "X(256)":U INITIAL "001,004,008" 
     LABEL "Empleados" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .69 NO-UNDO.

DEFINE VARIABLE F-CalObr AS CHARACTER FORMAT "X(256)":U INITIAL "001,004,008" 
     LABEL "Obreros" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 3.54.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.29 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     CMB-mes AT ROW 1.5 COL 9 COLON-ALIGNED
     F-CalEmp AT ROW 2.88 COL 11 COLON-ALIGNED
     F-CalObr AT ROW 3.62 COL 11 COLON-ALIGNED
     CMB-sem-D AT ROW 1.5 COL 28.57 COLON-ALIGNED
     CMB-sem-H AT ROW 1.5 COL 39 COLON-ALIGNED
     Btn_OK AT ROW 1.5 COL 52
     Btn_Cancel AT ROW 2.69 COL 52
     RECT-22 AT ROW 2.58 COL 2.29
     "Calculo" VIEW-AS TEXT
          SIZE 7.14 BY .5 AT ROW 2.35 COL 5.29
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
        F-CalEmp
        F-CalObr
        CMB-mes
        CMB-sem-D
        CMB-sem-H.

   x-archivo = "c:\0600" + string(s-periodo,"9999") + string(cmb-mes,"99") + trim(empresas.ruc) + ".djt".  
   RUN Empleados.
   RUN Obreros.
   RUN Procesa.

   MESSAGE "Se ha generado con exito el archivo " x-archivo 
            VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


ASSIGN
    CMB-mes    = s-nromes
    CMB-sem-D    = s-nrosem
    CMB-sem-H    = s-nrosem.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Empleados D-Dialog 
PROCEDURE Empleados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-codcal = f-calemp.

/* Cargamos el temporal con los ingresos */
FOR EACH PL-FLG-MES WHERE PL-FLG-MES.Codcia = s-codcia AND
                          PL-FLG-MES.Periodo = s-periodo AND
                          PL-FLG-MES.Codpln = 1 AND
                          PL-FLG-MES.Nromes = cmb-mes:
 FIND PL-PERS WHERE PL-PERS.COdcia = s-codcia AND
                    Pl-PERS.Codper = PL-FLG-MES.Codper 
                    NO-LOCK NO-ERROR.
 
 IF NOT AVAILABLE PL-PERS THEN NEXT.
                    
 DO I = 1 TO NUM-ENTRIES(X-CODCAL):
    FOR EACH PL-MOV-MES WHERE
            PL-MOV-MES.CodCia  = s-CodCia AND
            PL-MOV-MES.Periodo = s-Periodo AND
            PL-MOV-MES.NroMes  = cmb-mes AND
            PL-MOV-MES.CodPln  = 1 AND
            PL-MOV-MES.CodCal  = INTEGER(ENTRY(I,X-CODCAL)) AND
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
           CASE PL-MOV-MES.CodMov:
                WHEN 100 then tempo.nrodia    = tempo.nrodia + Pl-MOV-MES.ValCal. 
                WHEN 405 then tempo.valcal[1] = tempo.valcal[1] + Pl-MOV-MES.ValCal. 
                WHEN 305 then tempo.valcal[7] = tempo.valcal[7] + Pl-MOV-MES.ValCal.
                WHEN 408 then tempo.valcal[2] = tempo.valcal[2] + Pl-MOV-MES.ValCal. 
                WHEN 407 then tempo.valcal[3] = tempo.valcal[3] + Pl-MOV-MES.ValCal. 
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
  DISPLAY CMB-mes F-CalEmp F-CalObr CMB-sem-D CMB-sem-H 
      WITH FRAME D-Dialog.
  ENABLE RECT-22 RECT-17 CMB-mes F-CalEmp F-CalObr CMB-sem-D CMB-sem-H Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Obreros D-Dialog 
PROCEDURE Obreros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
x-codcal = f-calobr.
/* Cargamos el temporal con los ingresos */
DO II = cmb-sem-d TO cmb-sem-h:
FOR EACH PL-FLG-SEM WHERE PL-FLG-SEM.Codcia = s-codcia AND
                          PL-FLG-SEM.Periodo = s-periodo AND
                          PL-FLG-SEM.Codpln = 2 AND
                          PL-FLG-SEM.Nrosem = II:
 FIND PL-PERS WHERE PL-PERS.COdcia = s-codcia AND
                    Pl-PERS.Codper = PL-FLG-SEM.Codper 
                    NO-LOCK NO-ERROR.
 
 IF NOT AVAILABLE PL-PERS THEN NEXT.
                    
 DO I = 1 TO NUM-ENTRIES(X-CODCAL):
    FOR EACH PL-MOV-SEM WHERE
            PL-MOV-SEM.CodCia  = s-CodCia AND
            PL-MOV-SEM.Periodo = s-Periodo AND
            PL-MOV-SEM.Nrosem  = II AND
            PL-MOV-SEM.CodPln  = 2 AND
            PL-MOV-SEM.CodCal  = INTEGER(ENTRY(I,X-CODCAL)) AND
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
           CASE PL-MOV-SEM.CodMov:
                WHEN 100 then tempo.nrodia    = tempo.nrodia + Pl-MOV-SEM.ValCal. 
                WHEN 405 then tempo.valcal[1] = tempo.valcal[1] + Pl-MOV-SEM.ValCal. 
                WHEN 305 then tempo.valcal[7] = tempo.valcal[7] + Pl-MOV-SEM.ValCal. 
                WHEN 408 then tempo.valcal[2] = tempo.valcal[2] + Pl-MOV-SEM.ValCal. 
                WHEN 407 then tempo.valcal[3] = tempo.valcal[3] + Pl-MOV-SEM.ValCal. 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa D-Dialog 
PROCEDURE Procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

output to value(x-archivo).

for each tempo :
/*
  IF TEMPO.NRODIA = 0 THEN TEMPO.NRODIA = 30.
  IF Tempo.Nrodia = 30 AND FILL-IN-NRO-MES = 2 THEN DO:
     Tempo.Nrodia = DAY(DATE(03,01,s-periodo) - 1).
  END.
*/
  if tempo.valcal[6] = 0 Then tempo.valcal[5] = 0.
  if tempo.valcal[7] = 0 Then tempo.valcal[1] = 0.
  x = x + tempo.coddoc + "|" + tempo.nrodoc + "|" + STRING(tempo.nrodia) + "|" .
  x = x + if tempo.valcal[1] > 0 then string(tempo.valcal[1],">>>>>>>>9.99") + "|" else "|" .
  x = x + if tempo.valcal[2] > 0 then string(tempo.valcal[2],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[3] > 0 then string(tempo.valcal[3],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[4] > 0 then string(tempo.valcal[4],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[5] > 0 then string(tempo.valcal[5],">>>>>>>>9.99") + "|" else "|".
  x = x + if tempo.valcal[6] > 0 then string(tempo.valcal[6],">>>>>>>>9.99") + "|" else "|".
  

  DISPLAY x WITH no-labels  WIDTH 300.
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


