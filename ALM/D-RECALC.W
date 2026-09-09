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
DEFINE BUFFER MATG FOR Almmmatg.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE VAR I-CODMAT AS CHAR    NO-UNDO.
DEFINE VAR F-STKACT AS DECIMAL NO-UNDO.
DEFINE VAR F-VCTOMN AS DECIMAL NO-UNDO.
DEFINE VAR F-VCTOME AS DECIMAL NO-UNDO.
DEFINE VAR F-PMAXMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PMAXME AS DECIMAL NO-UNDO.
DEFINE VAR F-PULTMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PULTME AS DECIMAL NO-UNDO.
DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
DEFINE VAR F-PREUMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PREUME AS DECIMAL NO-UNDO.
DEFINE VAR F-CANDES AS DECIMAL NO-UNDO.
DEFINE VAR F-PREUNI AS DECIMAL NO-UNDO.
DEFINE VAR F-TCTOMN AS DECIMAL NO-UNDO.
DEFINE VAR F-TCTOME AS DECIMAL NO-UNDO.
DEFINE VAR F-PCTOMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PCTOME AS DECIMAL NO-UNDO.
DEFINE VAR D-ULTCMP AS DATE NO-UNDO.
DEFINE VAR L-REPASA AS LOGICAL NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Auxiliar" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 DesdeC HastaC Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DesdeC HastaC 

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
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde el Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta el Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.86 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     DesdeC AT ROW 2 COL 18.14 COLON-ALIGNED
     HastaC AT ROW 4.15 COL 18.14 COLON-ALIGNED
     Btn_OK AT ROW 1.81 COL 37.14
     Btn_Cancel AT ROW 3.85 COL 37.14
     RECT-11 AT ROW 1.46 COL 6.14
     SPACE(19.99) SKIP(0.64)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Regeneracion de Costo Promedio".


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
                                                                        */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Regeneracion de Costo Promedio */
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
  ASSIGN DesdeC HastaC.
  RUN Calcula.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde el Codigo */
DO:
IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta el Codigo */
DO:
IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
END.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula D-Dialog 
PROCEDURE Calcula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF HastaC = "" THEN HastaC = "999999".

FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA
    AND Almmmatg.CodMat >= DesdeC 
    USE-INDEX Matg01
    NO-LOCK NO-ERROR.

REPEAT WHILE AVAILABLE Almmmatg 
    AND Almmmatg.CodCia = S-CODCIA AND
    Almmmatg.CodMat <= HastaC:
    
    I-CODMAT = Almmmatg.CodMat.
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.

    FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodMat = I-CODMAT 
        USE-INDEX Mate03:
        ASSIGN Almmmate.StkAct = 0.
    END.

    F-STKACT = 0.
    F-VCTOMN = 0.
    F-VCTOME = 0.
    F-PMAXMN = 0.
    F-PMAXME = 0.
    F-PULTMN = 0.
    F-PULTME = 0.
    F-STKGEN = 0.
    L-REPASA = NO.

    FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
        AND Almdmov.CodMat = I-CODMAT USE-INDEX Almd02:
        
        FIND Almcmov WHERE Almcmov.CodCia = Almdmov.CodCia 
            AND Almcmov.CodAlm = Almdmov.CodAlm 
            AND Almcmov.TipMov = Almdmov.TipMov 
            AND Almcmov.CodMov = Almdmov.CodMov 
            AND Almcmov.NroDoc = Almdmov.NroDoc NO-LOCK NO-ERROR.

        IF Almdmov.Codmov = 03 OR Almdmov.Codmov = 77 OR Almdmov.Codmov = 76 THEN NEXT.                        
        FIND Almacen WHERE Almacen.Codcia = 1 AND
                           Almacen.Codalm = Almdmov.Codalm NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN NEXT.
        IF NOT Almacen.FlgRep  THEN NEXT.

        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN DO:
           IF AVAILABLE Almcmov AND Almcmov.FchDoc <> Almdmov.FchDoc THEN DO:
              ASSIGN Almdmov.FchDoc = Almcmov.FchDoc  
              L-REPASA = YES.    
              LEAVE.
           END.
           release almcmov.
        END.

        IF Almdmov.CodMon = 1 THEN DO:
           F-PREUMN = Almdmov.PreUni.
           IF Almdmov.TpoCmb > 0 THEN F-PREUME = ROUND(Almdmov.PreUni / Almdmov.TpoCmb,4).
           ELSE F-PREUME = 0.
        END.      
        ELSE ASSIGN F-PREUMN = ROUND(Almdmov.PreUni * Almdmov.TpoCmb,4)
                    F-PREUME = Almdmov.PreUni.
        
        IF Almdmov.Factor > 0 THEN 
            ASSIGN 
            F-PREUMN = F-PREUMN / Almdmov.Factor
            F-PREUME = F-PREUME / Almdmov.Factor.
        
        F-CANDES = Almdmov.CanDes.
        F-PREUNI = Almdmov.PreUni.

        FIND Almtmovm WHERE Almtmovm.CodCia = Almdmov.CodCia AND
            Almtmovm.Tipmov = Almdmov.TipMov AND
            Almtmovm.Codmov = Almdmov.CodMov NO-LOCK NO-ERROR.

        IF AVAILABLE Almtmovm AND Almtmovm.ModCsm AND F-CANDES > 0 THEN DO:  
           IF Almdmov.FchDoc >= D-ULTCMP THEN 
              ASSIGN 
              D-ULTCMP = Almdmov.FchDoc
              F-PULTMN = F-PREUMN
              F-PULTME = F-PREUME
              F-PMAXMN = MAXIMUM(F-PMAXMN,F-PREUMN)
              F-PMAXME = MAXIMUM(F-PMAXME,F-PREUME).
        END.

        IF AVAILABLE Almtmovm AND Almtmovm.PidPco THEN ASSIGN Almdmov.CodAjt = "A".
        ELSE ASSIGN Almdmov.CodAjt = "".

        IF Almdmov.CodMon = 1 THEN DO:
           F-TCTOMN = Almdmov.ImpCto.
           IF Almdmov.TpoCmb > 0 THEN 
              F-TCTOME = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb,4).
           ELSE F-TCTOME = 0.
           ASSIGN 
           Almdmov.ImpMn1 = F-TCTOMN
           Almdmov.ImpMn2 = F-TCTOME.
        END.
        ELSE DO:
           F-TCTOMN = ROUND(Almdmov.ImpCto * Almdmov.TpoCmb,4).
           F-TCTOME = Almdmov.ImpCto.
           ASSIGN Almdmov.ImpMn1 = F-TCTOMN
           Almdmov.ImpMn2 = F-TCTOME.
        END.
        
        IF Almdmov.Factor > 0 THEN  F-CANDES = Almdmov.CanDes * Almdmov.Factor.
        
        IF F-STKACT > 0 THEN 
            ASSIGN 
            F-PCTOMN = ROUND(F-VCTOMN / F-STKACT,4)
            F-PCTOME = ROUND(F-VCTOME / F-STKACT,4).
        ELSE 
            ASSIGN 
            F-PCTOMN = 0 
            F-PCTOME = 0.
        
        F-PCTOMN  = IF F-PCTOMN < 0 THEN 0 ELSE F-PCTOMN.
        F-PCTOME  = IF F-PCTOME < 0 THEN 0 ELSE F-PCTOME.
        IF Almdmov.CodAjt <> "A" THEN DO:
           F-TCTOMN = ROUND(F-PCTOMN * F-CANDES,4).
           F-TCTOME = ROUND(F-PCTOME * F-CANDES,4).
           ASSIGN 
           Almdmov.ImpMn1 = F-TCTOMN
           Almdmov.ImpMn2 = F-TCTOME.
        END.

        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN 
           ASSIGN 
           F-VCTOMN = F-VCTOMN + Almdmov.ImpMn1
           F-VCTOME = F-VCTOME + Almdmov.ImpMn2.
        ELSE  
            ASSIGN 
            F-VCTOMN = F-VCTOMN - Almdmov.ImpMn1
            F-VCTOME = F-VCTOME - Almdmov.ImpMn2.
            F-VCTOMN = IF F-VCTOMN < 0 THEN 0 ELSE F-VCTOMN.
            F-VCTOME = IF F-VCTOME < 0 THEN 0 ELSE F-VCTOME.

        FIND Almmmate WHERE Almmmate.CodCia = Almdmov.CodCia
            AND Almmmate.CodAlm = Almdmov.CodAlm 
            AND Almmmate.CodMat = Almdmov.CodMat EXCLUSIVE-LOCK NO-ERROR.
        
        IF NOT AVAILABLE Almmmate THEN DO:
           CREATE Almmmate.
           ASSIGN 
           Almmmate.CodCia = Almdmov.CodCia
           Almmmate.CodAlm = Almdmov.CodAlm
           Almmmate.CodMat = Almdmov.CodMat
           Almmmate.Desmat = Almmmatg.desmat
           Almmmate.UndVta = Almmmatg.UndStk
           Almmmate.FacEqu = 1.
        END.

        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN DO:
            ASSIGN 
            Almmmate.StkAct = Almmmate.StkAct + F-CANDES.
            F-STKGEN = F-STKGEN + F-CANDES.
        END.
        ELSE DO:
            ASSIGN Almmmate.StkAct = Almmmate.StkAct - F-CANDES.
            IF Almmmatg.FchUSal < Almdmov.FchDoc AND Almdmov.TipMov = "S" THEN DO:
                FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN MATG.FchUSal = Almdmov.FchDoc.
                FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) NO-LOCK NO-ERROR.
            END.
            F-STKGEN = F-STKGEN - F-CANDES.
        END.
        
        ASSIGN 
        Almdmov.VCtoMn1 = F-VCTOMN
        Almdmov.VCtoMn2 = F-VCTOME
        Almdmov.StkSub  = Almmmate.StkAct
        Almdmov.StkAct  = F-STKGEN.
        F-STKACT = Almdmov.StkAct.
        Release almmmate.
        
        FIND Almmmate WHERE Almmmate.CodCia = Almdmov.CodCia 
            AND Almmmate.CodAlm = Almdmov.CodAlm 
            AND Almmmate.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
        
        release almdmov.
    END.
    
    IF NOT L-REPASA THEN DO:
       FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) EXCLUSIVE-LOCK NO-ERROR.
       ASSIGN 
       MATG.PMaxMn1 = F-PMAXMN
       MATG.PMaxMn2 = F-PMAXME
       MATG.VCtMn1  = F-VCTOMN
       MATG.VCtMn2  = F-VCTOME
       MATG.PUltMn1 = F-PULTMN
       MATG.PUltMn2 = F-PULTME
       MATG.FchUCmp = D-ULTCMP.
       
       FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) NO-LOCK NO-ERROR.
       FIND NEXT Almmmatg USE-INDEX Matg01.
       release matg.
       release almmmatg.
    END.
END.
HIDE FRAME F-Proceso.
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
  DISPLAY DesdeC HastaC 
      WITH FRAME D-Dialog.
  ENABLE RECT-11 DesdeC HastaC Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
        WHEN "" THEN .
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


