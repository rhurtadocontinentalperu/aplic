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




FIND Gn-Cias WHERE Gn-Cias.Codcia = S-CODCIA 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-Cias THEN DO:
   MESSAGE "Tablas Gn-Cias no existe ....Verifique " 
           VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.


X-ARCHIVO = "c:\" + TRIM(Gn-Cias.Libre-C[1]) + ".ase".

DEFINE TEMP-TABLE Tempo 
FIELD Codper LIKE PL-PERS.Codper.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 CMB-mes R-Tipo C-Planilla Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS CMB-mes R-Tipo C-Planilla 

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

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo ingresantes del mes", 2,
"Solo cesados del mes", 3
     SIZE 39 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 3.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     CMB-mes AT ROW 1.31 COL 9 COLON-ALIGNED
     R-Tipo AT ROW 2.73 COL 11 NO-LABEL
     C-Planilla AT ROW 1.31 COL 24 COLON-ALIGNED
     Btn_OK AT ROW 1.5 COL 52
     Btn_Cancel AT ROW 2.69 COL 52
     RECT-17 AT ROW 1.08 COL 1.57
     SPACE(13.28) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Importar Trabajadores PDT"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Importar Trabajadores PDT */
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
        R-Tipo
        C-Planilla.
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
  DISPLAY CMB-mes R-Tipo C-Planilla 
      WITH FRAME D-Dialog.
  ENABLE RECT-17 CMB-mes R-Tipo C-Planilla Btn_OK Btn_Cancel 
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
OUTPUT TO VALUE(x-archivo).

FOR EACH pl-pers WHERE pl-pers.Codcia = S-CODCIA :

  FIND PL-FLG-MES WHERE PL-FLG-MES.Codcia = PL-PERS.Codcia AND
                        PL-FLG-MES.Periodo = S-PERIODO AND
                        Pl-FLG-MES.Nromes = CMB-mes AND
                        PL-FLG-MES.Codpln = PL-PLAN.Codpln AND
                        PL-FLG-MES.Codper = PL-PERS.Codper
                        NO-LOCK NO-ERROR.     

  IF NOT AVAILABLE PL-FLG-MES THEN NEXT .                            
  
  x-ok = TRUE. 
  IF R-Tipo = 2 THEN DO:
     IF MONTH(pl-flg-mes.fecing) = cmb-mes AND
        YEAR(pl-flg-mes.fecing) = s-periodo 
     THEN x-ok = TRUE.
     ELSE x-ok = FALSE.
     
  END.
  IF R-Tipo = 3 THEN DO:
     IF MONTH(pl-flg-mes.vcontr) = cmb-mes AND
        YEAR(pl-flg-mes.vcontr) = s-periodo 
     THEN x-ok = TRUE.
     ELSE x-ok = FALSE.    
  END.

  x-pension = "1".
  IF PL-FLG-MES.Codafp = 0 THEN x-pension = "2".

  
  FIND PL-MOV-MES WHERE PL-MOV-MES.Codcia = PL-PERS.Codcia AND
                        Pl-MOV-MES.Periodo = S-PERIODO AND
                        PL-MOV-MES.Nromes = CMB-mes AND
                        PL-MOV-MES.Codpln = PL-PLAN.Codpln AND
                        PL-MOV-MES.Codcal = 0 AND
                        Pl-MOV-MES.Codper = PL-PERS.Codper AND
                        PL-MOV-MES.Codmov = 227
                        NO-LOCK NO-ERROR.
                        
  x-ipsvid = "0".
  IF AVAILABLE Pl-MOV-MES THEN x-ipsvid = "1" .

  FIND PL-MOV-MES WHERE PL-MOV-MES.Codcia = PL-PERS.Codcia AND
                        Pl-MOV-MES.Periodo = S-PERIODO AND
                        PL-MOV-MES.Nromes = CMB-mes AND
                        PL-MOV-MES.Codpln = PL-PLAN.Codpln AND
                        PL-MOV-MES.Codcal = 0 AND
                        Pl-MOV-MES.Codper = PL-PERS.Codper AND
                        PL-MOV-MES.Codmov = 304
                        NO-LOCK NO-ERROR.
                        
  x-sctr = "0".
  IF AVAILABLE Pl-MOV-MES THEN x-sctr = "1" .



  IF NOT x-ok THEN NEXT.
  
  x-situ   = "11".
  x-situ   = IF PL-FLG-MES.Sitact = "Inactivo" THEN "13" ELSE x-situ.
  x-situ   = IF pl-flg-mes.vcontr <> ? THEN "13" ELSE x-situ.
  
  x-tipo   = IF pl-plan.codpln = 3 THEN "98" ELSE "21".
  x-sexo   = IF pl-pers.sexper = "Masculino" THEN "1" ELSE "2".
  x-fecing = IF pl-flg-mes.fecing <> ? THEN string(pl-flg-mes.fecing,"99/99/9999") ELSE "".
  x-fecnac = IF pl-pers.fecnac <> ? THEN string(pl-pers.fecnac,"99/99/9999") ELSE "".
  x-fecces = IF pl-flg-mes.vcontr <> ? THEN string(pl-flg-mes.vcontr,"99/99/9999") ELSE "".
  x-fecpen = IF pl-flg-mes.fchinsrgp <> ? THEN string(pl-flg-mes.fchinsrgp,"99/99/9999") ELSE "".
  
  
  IF pl-pers.NroDocId <> "" then do:
     ASSIGN
     x-coddoc = "01"
     x-nrodoc = pl-pers.NroDocId.
  end.
/*
  IF pl-pers.paspor <> "" and pl-pers.NroDocId = "" then do:
     ASSIGN
     x-coddoc = "04"
     x-nrodoc = pl-pers.paspor.
  end.
*/  

  x-lin = x-lin + 
          x-coddoc + "|" + 
          x-nrodoc + "|" + 
          pl-pers.patper + "|" + 
          pl-pers.matper + "|" + 
          pl-pers.nomper + "|" + 
          x-fecnac + "|" +
          x-sexo + "|" +
          pl-pers.telefo + "|" +
          x-fecing + "|" +
          x-situ + "|" + 
          x-tipo + "|" +
          x-fecces + "|" +
          "" + "|" +
          x-ipsvid + "|" +
          x-pension + "|" +
          x-sctr + "|" +
          x-fecpen + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|".          
  DISPLAY x-lin WITH NO-BOX NO-LABELS NO-UNDERLINE WIDTH 300.
  x-lin = "".

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
OUTPUT TO VALUE(x-archivo).
DEF VAR CMB-SEM AS INT .
FOR EACH pl-pers WHERE pl-pers.Codcia = S-CODCIA :
FOR EACH PL-SEM NO-LOCK WHERE PL-SEM.COdcia = S-CODCIA AND
                      PL-SEM.Periodo = S-PERIODO AND
                      PL-SEM.Nromes  = CMB-Mes:
  CMB-Sem = PL-SEM.NroSem.                    
  FIND PL-FLG-SEM WHERE PL-FLG-SEM.Codcia = PL-PERS.Codcia AND
                        PL-FLG-SEM.Periodo = S-PERIODO AND
                        Pl-FLG-SEM.Nrosem = CMB-sem AND
                        PL-FLG-SEM.Codpln = PL-PLAN.Codpln AND
                        PL-FLG-SEM.Codper = PL-PERS.Codper
                        NO-LOCK NO-ERROR.     

  IF NOT AVAILABLE PL-FLG-SEM THEN NEXT .                            
  
  x-ok = TRUE. 
  IF R-Tipo = 2 THEN DO:
     IF MONTH(pl-flg-sem.fecing) = cmb-mes AND
        YEAR(pl-flg-sem.fecing) = s-periodo 
     THEN x-ok = TRUE.
     ELSE x-ok = FALSE.
     
  END.
  IF R-Tipo = 3 THEN DO:
     IF MONTH(pl-flg-sem.vcontr) = cmb-mes AND
        YEAR(pl-flg-sem.vcontr) = s-periodo 
     THEN x-ok = TRUE.
     ELSE x-ok = FALSE.    
  END.


  x-pension = "1".
  IF PL-FLG-SEM.Codafp = 0 THEN x-pension = "2".
  
  FIND PL-MOV-SEM WHERE PL-MOV-SEM.Codcia = PL-PERS.Codcia AND
                        Pl-MOV-SEM.Periodo = S-PERIODO AND
                        PL-MOV-SEM.Nrosem  = CMB-sem AND
                        PL-MOV-SEM.Codpln = PL-PLAN.Codpln AND
                        PL-MOV-SEM.Codcal = 0 AND
                        Pl-MOV-SEM.Codper = PL-PERS.Codper AND
                        PL-MOV-SEM.Codmov = 227
                        NO-LOCK NO-ERROR.
                        
  x-ipsvid = "0".
  IF AVAILABLE Pl-MOV-SEM THEN x-ipsvid = "1" .

  FIND PL-MOV-SEM WHERE PL-MOV-SEM.Codcia = PL-PERS.Codcia AND
                        Pl-MOV-SEM.Periodo = S-PERIODO AND
                        PL-MOV-SEM.Nrosem = CMB-sem AND
                        PL-MOV-SEM.Codpln = PL-PLAN.Codpln AND
                        PL-MOV-SEM.Codcal = 0 AND
                        Pl-MOV-SEM.Codper = PL-PERS.Codper AND
                        PL-MOV-SEM.Codmov = 304
                        NO-LOCK NO-ERROR.
                        
  x-sctr = "0".
  IF AVAILABLE Pl-MOV-SEM THEN x-sctr = "1" .



  IF NOT x-ok THEN NEXT.
  
  x-situ   = "11".
  x-situ   = IF PL-FLG-SEM.Sitact = "Inactivo" THEN "13" ELSE x-situ.
  x-situ   = IF PL-flg-sem.vcontr <> ? THEN "13" ELSE x-situ.
  
  x-tipo   = "20".
  
  x-sexo   = IF pl-pers.sexper = "Masculino" THEN "1" ELSE "2".
  x-fecing = IF pl-flg-sem.fecing <> ? THEN string(pl-flg-sem.fecing,"99/99/9999") ELSE "".
  x-fecnac = IF pl-pers.fecnac <> ? THEN string(pl-pers.fecnac,"99/99/9999") ELSE "".
  x-fecces = IF pl-flg-sem.vcontr <> ? THEN string(pl-flg-sem.vcontr,"99/99/9999") ELSE "".
  x-fecpen = IF pl-flg-sem.fchinsrgp <> ? THEN string(pl-flg-sem.fchinsrgp,"99/99/9999") ELSE "".
  
  
  IF pl-pers.NroDocId <> "" then do:
     ASSIGN
     x-coddoc = "01"
     x-nrodoc = pl-pers.NroDocId.
  end.
  
  FIND Tempo WHERE  Tempo.Codper = PL-FLG-SEM.Codper 
  NO-ERROR.
  IF AVAILABLE Tempo THEN NEXT.
  CREATE Tempo.
  ASSIGN
  Tempo.CodPer = PL-FLG-SEM.Codper.

  x-lin = x-lin + 
          x-coddoc + "|" + 
          x-nrodoc + "|" + 
          pl-pers.patper + "|" + 
          pl-pers.matper + "|" + 
          pl-pers.nomper + "|" + 
          x-fecnac + "|" +
          x-sexo + "|" +
          pl-pers.telefo + "|" +
          x-fecing + "|" +
          x-situ + "|" + 
          x-tipo + "|" +
          x-fecces + "|" +
          "" + "|" +
          x-ipsvid + "|" +
          x-pension + "|" +
          x-sctr + "|" +
          x-fecpen + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|" +
          "" + "|".          
  DISPLAY x-lin WITH NO-BOX NO-LABELS NO-UNDERLINE WIDTH 300.

  x-lin = "".
  
end.  
END.
output close.



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


