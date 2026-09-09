&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODALM AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE x-string AS CHARACTER FORMAT 'X(100)'.
DEFINE VAR x-glosa  AS CHAR NO-UNDO.
DEFINE VAR x-fchdoc AS DATE NO-UNDO.

SESSION:DATE-FORMAT = 'DMY'.

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
&Scoped-Define ENABLED-OBJECTS F-FecIni F-FecFin Btn_Cancel Btn_OK RECT-50 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 F-Observacion F-FecIni F-FecFin 

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
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 46.72 BY 4
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE F-FecFin AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-FecIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Observacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     EDITOR-1 AT ROW 1.27 COL 2.14 NO-LABEL
     F-Observacion AT ROW 7 COL 3.86 COLON-ALIGNED NO-LABEL
     F-FecIni AT ROW 5.62 COL 10.86 COLON-ALIGNED
     F-FecFin AT ROW 5.62 COL 29.43 COLON-ALIGNED
     Btn_Cancel AT ROW 4.65 COL 50.29
     Btn_OK AT ROW 2.58 COL 50.29
     RECT-50 AT ROW 5.35 COL 2
     SPACE(14.28) SKIP(1.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "TRANSFERENCIA DE DATOS".


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
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Observacion IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* TRANSFERENCIA DE DATOS */
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
  ASSIGN F-FecFin F-FecIni.
  IF F-Fecini = ? THEN DO:
     MESSAGE 'Fecha inicial no ha sido ingresada' VIEW-AS ALERT-BOX.
     APPLY 'ENTRY':U TO F-Fecini.
     RETURN NO-APPLY.
  END.
  IF F-Fecfin = ? THEN DO:
     MESSAGE 'Fecha final no ha sido ingresada' VIEW-AS ALERT-BOX.
     APPLY 'ENTRY':U TO F-Fecfin.
     RETURN NO-APPLY.
  END.
  RUN Traslado-Almacen.
  RUN Traslado-Ventas.
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
  DISPLAY EDITOR-1 F-Observacion F-FecIni F-FecFin 
      WITH FRAME D-Dialog.
  ENABLE F-FecIni F-FecFin Btn_Cancel Btn_OK RECT-50 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
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
  DO WITH FRAME {&FRAME-NAME}:
     EDITOR-1 = 'Este proceso que permite la transferencia de la información de los 
módulos de ALMACEN Y VENTAS al nuevo sistema; se transferirá la información 
de un rango de fecha ingresado '. /*y se verificará en el módulo de VENTAS todos 
los documentos ANULADOS' */
     F-FecFin = TODAY - 1.
     F-FecIni = TODAY - 1.
     DISPLAY EDITOR-1 F-FecFin F-FecIni.
  END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Traslado-Almacen D-Dialog 
PROCEDURE Traslado-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Limpia DATOS */
FOR EACH Almcmov WHERE Almcmov.codcia = s-codcia AND
    Almcmov.codalm = s-codalm AND
    Almcmov.fchdoc >= F-Fecini AND Almcmov.fchdoc <= F-Fecfin :
    FOR EACH Almdmov OF Almcmov:
        DELETE Almdmov.
    END.
    DELETE Almcmov.
END.

/* TRANSFERENCIA DE DATOS */
DEFINE VAR x-nroant AS INTEGER NO-UNDO.
DEFINE VAR x-nrodoc AS INTEGER NO-UNDO.

INPUT FROM H:\TRASLADOS\ALMACEN\SEQALM9.TXT.
REPEAT:
   IMPORT UNFORMATTED x-string.
   x-glosa = ''.
   x-fchdoc = DATE(SUBSTRING(x-string,10,8)).
   IF x-fchdoc >= F-Fecini AND x-fchdoc <= F-Fecfin THEN DO:
      DISPLAY 'Documento ALMACEN : ' + SUBSTRING(x-string,4,6) @ F-Observacion WITH FRAME {&FRAME-NAME}.
      CREATE Almdmov.
      ASSIGN
           Almdmov.AftIgv = IF DECIMAL(SUBSTRING(x-string,141,7)) > 0 THEN TRUE ELSE FALSE
           Almdmov.CanDes = DECIMAL(SUBSTRING(x-string,30,13))
           Almdmov.CodAlm = 'A01'
           Almdmov.CodAnt = SUBSTRING(x-string,113,6)
           Almdmov.CodCia = s-codcia
           Almdmov.CodMon = IF SUBSTRING(x-string,20,1) = '$' THEN 2 ELSE 1
           Almdmov.CodMov = INTEGER(SUBSTRING(x-string,2,2))
           Almdmov.CodUnd = IF SUBSTRING(x-string,71,14) = 'PZS' THEN 'PZ' ELSE SUBSTRING(x-string,71,14)
           Almdmov.Pesmat = DECIMAL(SUBSTRING(x-string,43,14)) * Almdmov.Candes
           Almdmov.Factor = 1
           Almdmov.FchDoc = DATE(SUBSTRING(x-string,10,8))
           Almdmov.TpoCmb = DECIMAL(SUBSTRING(x-string,21,9))
           Almdmov.ImpCto = DECIMAL(SUBSTRING(x-string,85,14))
           Almdmov.ImpMn1 = DECIMAL(SUBSTRING(x-string,85,14))
           Almdmov.ImpMn2 = Almdmov.Impmn1 / Almdmov.Tpocmb
           Almdmov.NroDoc = INTEGER(SUBSTRING(x-string,4,6))
           Almdmov.NroAnt = INTEGER(SUBSTRING(x-string,4,6))
           Almdmov.NroItm = INTEGER(SUBSTRING(x-string,18,2))
           Almdmov.PreUni = DECIMAL(SUBSTRING(x-string,57,14)) /* S O L E S */
           Almdmov.TipMov = SUBSTRING(x-string,1,1).
     
    /* Se convierte el precio unitario de acuerdo a la moneda */
    /* no se realizara la conversion porque varia el importe en soles 
    IF Almdmov.Codmon = 2 THEN
       ASSIGN 
          Almdmov.PreUni = ROUND(Almdmov.Impmn2 / Almdmov.Candes, 2)
          Almdmov.Impcto = Almdmov.ImpMn2.*/
          
    IF Almdmov.codmon = 2 THEN 
       ASSIGN
          Almdmov.codmon = 1
          x-glosa        = 'Mov.Original en dolares'.
  
    /* Actualizar el nuevo codigo de producto */
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND 
         Almmmatg.codant = Almdmov.codant NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN
       ASSIGN Almdmov.codmat = Almmmatg.codmat.
       
    IF Almdmov.Tpocmb = 0 THEN DO:
       FIND gn-tcmb WHERE gn-tcmb.fecha = Almdmov.fchdoc NO-LOCK NO-ERROR.
       IF AVAILABLE gn-tcmb THEN 
          ASSIGN 
              Almdmov.Tpocmb = gn-tcmb.venta
              Almdmov.ImpMn2 = Almdmov.Impmn1 / Almdmov.Tpocmb.
    END.   

    IF x-nroant <> INTEGER(SUBSTRING(x-string,4,6)) THEN DO:

       /*************************************/
       /*  Asigno el numero del correlativo */
       /*************************************/
       FIND Almtdocm WHERE Almtdocm.codcia = Almdmov.codcia AND
            Almtdocm.codalm = Almdmov.codalm AND Almtdocm.tipmov = Almdmov.tipmov AND
            Almtdocm.codmov = Almdmov.codmov NO-ERROR.
       IF AVAILABLE Almtdocm THEN
          ASSIGN 
             Almtdocm.nrodoc = Almtdocm.nrodoc + 1
             x-nrodoc = Almtdocm.nrodoc.
    END.
    
    ASSIGN
       Almdmov.nrodoc = x-nrodoc.
    
    /********************/
    /* Grabar Cabecera */
    /*******************/
    FIND Almcmov WHERE Almcmov.codcia = Almdmov.codcia AND
         Almcmov.Codalm = Almdmov.codalm AND 
         Almcmov.Tipmov = Almdmov.tipmov AND
         Almcmov.Codmov = Almdmov.codmov AND
         Almcmov.Nrodoc = Almdmov.Nrodoc NO-ERROR.
    IF NOT AVAILABLE Almcmov THEN DO:
       CREATE Almcmov.
       ASSIGN
          Almcmov.Observ = x-glosa
          Almcmov.codcia = Almdmov.codcia
          Almcmov.Codalm = Almdmov.codalm
          Almcmov.Tipmov = Almdmov.tipmov
          Almcmov.Codmov = Almdmov.codmov
          Almcmov.Nrodoc = Almdmov.nrodoc
          Almcmov.CodMon = Almdmov.Codmon
          Almcmov.TpoCmb = Almdmov.Tpocmb
          Almcmov.usuario = SUBSTRING(x-string,148,14)
          Almcmov.NroFac = SUBSTRING(x-string,119,3) + SUBSTRING(x-string,122,8)
          Almcmov.NroRf1 = SUBSTRING(x-string,119,3) + SUBSTRING(x-string,122,8)
          Almcmov.NroRf2 = SUBSTRING(x-string,130,3) + SUBSTRING(x-string,133,8)
          Almcmov.FchDoc = Almdmov.Fchdoc
          Almcmov.CodPro = SUBSTRING(x-string,162,4)
          Almcmov.Observ = 'Mov.Original en dólares'.
    END.
    ASSIGN
       Almcmov.ImpMn1 = Almcmov.ImpMn1 + Almdmov.Impmn1
       Almcmov.ImpMn2 = Almcmov.ImpMn2 + Almdmov.Impmn2
       Almcmov.TotItm = Almcmov.TotItm + 1.
   END.
END.
INPUT CLOSE.
DISPLAY ' '  @ F-Observacion WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Traslado-Ventas D-Dialog 
PROCEDURE Traslado-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Limpia DATOS */
FOR EACH CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND
    CcbCDocu.Fchdoc >= F-Fecini AND CcbCDocu.Fchdoc <= F-Fecfin :
    FOR EACH CcbDDocu OF CcbCDocu:
        DELETE CcbDDocu.
    END.
    DELETE CcbCDocu.
END.

/* TRANSFERENCIA DE DATOS --  CABECERA  -- */

INPUT FROM H:\TRASLADOS\ALMACEN\SEQfacH9.TXT.
repeat:
   IMPORT UNFORMATTED x-string.
   x-fchdoc = DATE(SUBSTRING(x-string,12,8)).
   IF x-fchdoc >= F-Fecini AND x-fchdoc <= F-Fecfin THEN DO:
        DISPLAY 'Documento VENTAS : ' + SUBSTRING(x-string,3,9) @ F-Observacion WITH FRAME {&FRAME-NAME}.
        CREATE CCBCDOCU.
        ASSIGN
           CcbCDocu.Coddiv = '00000'
           CcbCDocu.Tpofac = 'R'
           CcbCDocu.TipVta = '1'
           CcbCDocu.CodAlm = 'A01'
           CcbCDocu.CodCia = s-codcia
           CcbCDocu.Nrodoc = SUBSTRING(x-string,3,9).
        CASE SUBSTRING(x-string,1,2):
           WHEN '07' OR WHEN '08' OR WHEN '17' OR WHEN '18' THEN 
                ASSIGN CcbCDocu.Coddoc = 'N/C'.
           WHEN '87' OR WHEN '97' THEN 
                ASSIGN CcbCDocu.Coddoc = 'N/D'.
           WHEN '80' OR WHEN '81' OR WHEN '84' OR WHEN '85' THEN 
                ASSIGN CcbCDocu.Coddoc = 'FAC'.
           WHEN '82' OR WHEN '83' THEN    
                ASSIGN CcbCDocu.Coddoc = 'BOL'.
           OTHERWISE 
                ASSIGN CcbCDocu.Coddoc = SUBSTRING(x-string,1,2).
        END.
           
        ASSIGN
           CcbCDocu.FchDoc = DATE(SUBSTRING(x-string,12,8))
           CcbCDocu.Codcli = SUBSTRING(x-string,136,8)
           CcbCDocu.Nomcli = SUBSTRING(x-string,26,50)
           CcbCDocu.Dircli = SUBSTRING(x-string,76,60)
           CcbCDocu.Ruccli = SUBSTRING(x-string,136,8)
           CcbCDocu.Nroped = SUBSTRING(x-string,144,8)
           CcbCDocu.CodMon = IF SUBSTRING(x-string,152,1) = '$' THEN 2 ELSE 1
           CcbCDocu.Flgest = IF SUBSTRING(x-string,153,1) = 'S' THEN 'A' ELSE 'P'
           CcbCDocu.Glosa  = IF CcbCDocu.Flgest = 'A' THEN 'A N U L A D O' ELSE ''
           CcbCDocu.Usuario = SUBSTRING(x-string,154,14)
           CcbCDocu.Impdto = DECIMAL(SUBSTRING(x-string,168,14)) + DECIMAL(SUBSTRING(x-string,182,14))
           CcbCDocu.Impvta = DECIMAL(SUBSTRING(x-string,196,14))
           CcbCDocu.Impbrt = CcbCDocu.Impvta + CcbCDocu.Impdto
           CcbCDocu.Impigv = DECIMAL(SUBSTRING(x-string,224,14))
           CcbCDocu.Imptot = CcbCDocu.Impvta + CcbCDocu.Impigv
           CcbCDocu.Sdoact = CcbCDocu.Imptot
           CcbCDocu.PorIgv = IF CcbCDocu.Impigv <> 0 THEN 18 ELSE 0
           CcbCDocu.Fchvto = CcbCDocu.Fchdoc
           CcbCDocu.TpoCmb = DECIMAL(SUBSTRING(x-string,282,9))
           CcbCDocu.Codven = SUBSTRING(x-string,272,4)
           CcbCDocu.Nroref = SUBSTRING(x-string,245,9)
           CcbCDocu.FmaPgo = IF LOOKUP(substring(x-string,1,2),'80,82,84') > 0 THEN '000' ELSE ''.
     
        CASE SUBSTRING(x-string,243,2):
           WHEN '07' OR WHEN '08' OR WHEN '17' OR WHEN '18' THEN 
                ASSIGN CcbCDocu.CodRef = 'N/C'.
           WHEN '87' OR WHEN '97' THEN 
                ASSIGN CcbCDocu.CodRef = 'N/D'.
           WHEN '80' OR WHEN '81' OR WHEN '84' OR WHEN '85' THEN 
                ASSIGN CcbCDocu.CodRef = 'FAC'.
           WHEN '82' OR WHEN '83' THEN    
                ASSIGN CcbCDocu.CodRef = 'BOL'.
           OTHERWISE 
                ASSIGN CcbCDocu.CodRef = SUBSTRING(x-string,1,2).
        END.
         IF CcbCDocu.Coddoc = 'FAC' OR CcbCDocu.Coddoc = 'BOL' THEN DO: 
            IF SUBSTRING(x-string,291,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref =  SUBSTRING(x-string,291,6).
            IF SUBSTRING(x-string,297,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,297,6).
            IF SUBSTRING(x-string,303,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,303,6).
            IF SUBSTRING(x-string,309,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,309,6).
            IF SUBSTRING(x-string,315,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,315,6).
            IF SUBSTRING(x-string,321,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,321,6).
            IF SUBSTRING(x-string,327,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,327,6).
            IF SUBSTRING(x-string,333,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,333,6).
            IF SUBSTRING(x-string,339,6) <> '000000' THEN 
               ASSIGN CcbCDocu.Nroref = CcbCDocu.Nroref + ',' + SUBSTRING(x-string,339,6).
         END.
         IF CcbCDocu.Coddoc = 'FAC' OR CcbCDocu.Coddoc = 'BOL' THEN DO: 
            IF SUBSTRING(x-string,276,6) = '000000' THEN
               ASSIGN
                  CcbCDocu.FchVto = CcbCDocu.Fchdoc.
            ELSE
               ASSIGN
                  CcbCDocu.Fchvto = DATE(SUBSTRING(x-string,276,4) + '19' + SUBSTRING(x-string,280,2)).
         END.
         /* Actualizo el codigo del cliente */
         IF CcbCDocu.Codcli =  ' ' THEN DO:
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
                 gn-clie.codant = SUBSTRING(x-string,22,4) NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN 
               ASSIGN CcbCDocu.Codcli = gn-clie.codcli.
         END.
   END.
END.
INPUT CLOSE.
DISPLAY '   '  @ F-Observacion WITH FRAME {&FRAME-NAME}.

/*  TRANSFERENCIA DE DATOS --  DETALLE --  */
DEFINE VAR x-coddoc AS CHAR NO-UNDO.
INPUT FROM H:\TRASLADOS\ALMACEN\SEQfacd9.TXT.

REPEAT:
   IMPORT UNFORMATTED x-string.
   CASE SUBSTRING(x-string,1,2):
       WHEN '07' OR WHEN '08' OR WHEN '17' OR WHEN '18' THEN 
            x-Coddoc = 'N/C'.
       WHEN '87' OR WHEN '97' THEN 
            x-Coddoc = 'N/D'.
       WHEN '80' OR WHEN '81' OR WHEN '84' OR WHEN '85' THEN 
            x-Coddoc = 'FAC'.
       WHEN '82' OR WHEN '83' THEN    
            x-Coddoc = 'BOL'.
       OTHERWISE 
            x-Coddoc = SUBSTRING(x-string,1,2).
   END.
   DISPLAY 'Verifica Detalle de VENTAS '  @ F-Observacion WITH FRAME {&FRAME-NAME}.

   FIND CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND
        CcbCDocu.coddoc = x-coddoc AND 
        CcbCDocu.nrodoc = SUBSTRING(x-string,3,9) NO-LOCK NO-ERROR.
   IF NOT AVAILABLE CcbCDocu THEN DO:
      DISPLAY 'Documento VENTAS : ' + x-coddoc + '-' + SUBSTRING(x-string,3,9) @ F-Observacion WITH FRAME {&FRAME-NAME}.
      CREATE CcbDDocu.
      ASSIGN
           CcbDDocu.CodCia = s-codcia
           CcbDDocu.NroDoc = SUBSTRING(x-string,3,9)
           CcbDDocu.AftIgv = IF DECIMAL(SUBSTRING(x-string,123,7)) > 0 THEN TRUE ELSE FALSE
           CcbDDocu.CanDes = DECIMAL(SUBSTRING(x-string,32,13))
           CcbDDocu.Factor = 1
           CcbDDocu.ImpLin = DECIMAL(SUBSTRING(x-string,162,18))
           CcbDDocu.NroItm = INTEGER(SUBSTRING(x-string,20,2))
           CcbDDocu.PorDto = DECIMAL(SUBSTRING(x-string,152,5))
           CcbDDocu.PorDto2 = DECIMAL(SUBSTRING(x-string,157,5))
           CcbDDocu.PreUni = DECIMAL(SUBSTRING(x-string,180,16)) 
           CcbDDocu.UndVta = IF SUBSTRING(x-string,73,14) = 'PZS' THEN 'PZ' ELSE SUBSTRING(x-string,71,14).
     
           /* Se incluye el importe de Igv en el precio unitario */
           IF CcbDDocu.Aftigv = TRUE AND LOOKUP(SUBSTRING(x-string,1,2), '80,81,82,83,84,85') > 0 THEN
              ASSIGN CcbDDocu.PreUni = ROUND(CcbDDocu.PreUni * 1.18, 2)
                     CcbDDocu.Impigv = ROUND(CcbDDocu.ImpLin * .18, 2)
                     CcbDDocu.Implin = CcbDDocu.Implin + CcbDDocu.Impigv.
     
           ASSIGN 
              CcbDDocu.PreBas = CcbDDocu.Preuni
              CcbDDocu.Impdto = (CcbDDocu.Preuni * CcbDDocu.Candes) - CcbDDocu.Implin.
     
     
           /* Actualizar el nuevo codigo de producto */
           FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND 
                Almmmatg.codant = SUBSTRING(x-string,101,6) NO-LOCK NO-ERROR.
           IF AVAILABLE Almmmatg THEN
              ASSIGN CcbDDocu.codmat = Almmmatg.codmat.
     
           CASE SUBSTRING(x-string,1,2):
              WHEN '07' OR WHEN '08' OR WHEN '17' OR WHEN '18' THEN 
                   ASSIGN CcbDDocu.Coddoc = 'N/C'.
              WHEN '87' OR WHEN '97' THEN 
                   ASSIGN CcbDDocu.Coddoc = 'N/D'.
              WHEN '80' OR WHEN '81' OR WHEN '84' OR WHEN '85' THEN 
                   ASSIGN CcbDDocu.Coddoc = 'FAC'.
              WHEN '82' OR WHEN '83' THEN    
                   ASSIGN CcbDDocu.Coddoc = 'BOL'.
              OTHERWISE 
                   ASSIGN CcbDDocu.Coddoc = SUBSTRING(x-string,1,2).
           END.
   END.
END.
DISPLAY '   '  @ F-Observacion WITH FRAME {&FRAME-NAME}.
INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

