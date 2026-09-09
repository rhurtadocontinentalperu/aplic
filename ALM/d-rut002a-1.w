&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



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
DEF INPUT PARAMETER x-Rowid AS ROWID.

/* Local Variable Definitions ---                                       */
def var hora1 as char.
def var hora2 as char.
FIND Di-RutaC WHERE ROWID(Di-RutaC) = x-Rowid NO-LOCK.

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

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
&Scoped-define INTERNAL-TABLES DI-RutaC

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog DI-RutaC.NroDoc DI-RutaC.FchDoc ~
DI-RutaC.HorSal DI-RutaC.HorRet DI-RutaC.KmtIni DI-RutaC.KmtFin ~
DI-RutaC.CodVeh DI-RutaC.CtoRut DI-RutaC.DesRut 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog DI-RutaC.HorRet ~
DI-RutaC.KmtFin 
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog DI-RutaC
&Scoped-define QUERY-STRING-D-Dialog FOR EACH DI-RutaC SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH DI-RutaC SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog DI-RutaC


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS DI-RutaC.HorRet DI-RutaC.KmtFin 
&Scoped-define ENABLED-TABLES DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE DI-RutaC
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS DI-RutaC.NroDoc DI-RutaC.FchDoc ~
DI-RutaC.HorSal DI-RutaC.HorRet DI-RutaC.KmtIni DI-RutaC.KmtFin ~
DI-RutaC.CodVeh DI-RutaC.CtoRut DI-RutaC.DesRut 
&Scoped-define DISPLAYED-TABLES DI-RutaC
&Scoped-define FIRST-DISPLAYED-TABLE DI-RutaC
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Marca 

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

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.5 COL 52
     DI-RutaC.NroDoc AT ROW 1.58 COL 18 COLON-ALIGNED
          LABEL "Nº de Hoja"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     DI-RutaC.FchDoc AT ROW 2.54 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Btn_Cancel AT ROW 2.69 COL 52
     DI-RutaC.HorSal AT ROW 3.5 COL 18 COLON-ALIGNED
          LABEL "Hora de salida"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     DI-RutaC.HorRet AT ROW 4.46 COL 18 COLON-ALIGNED
          LABEL "Hora de llegada" FORMAT "XXXX"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     DI-RutaC.KmtIni AT ROW 5.42 COL 18 COLON-ALIGNED
          LABEL "Kilometraje de salida" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     DI-RutaC.KmtFin AT ROW 6.38 COL 18 COLON-ALIGNED
          LABEL "Kilometraje de llegada" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     DI-RutaC.CodVeh AT ROW 7.35 COL 18 COLON-ALIGNED
          LABEL "Placa del vehiculo" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     FILL-IN-Marca AT ROW 7.35 COL 27 COLON-ALIGNED NO-LABEL
     DI-RutaC.CtoRut AT ROW 8.31 COL 18 COLON-ALIGNED
          LABEL "Costo S/."
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     DI-RutaC.DesRut AT ROW 9.27 COL 18 COLON-ALIGNED
          LABEL "Detalle de la ruta"
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     SPACE(7.99) SKIP(0.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "CIERRE DE HOJA DE RUTA"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN DI-RutaC.CodVeh IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN DI-RutaC.CtoRut IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.DesRut IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.FchDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Marca IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DI-RutaC.HorRet IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.HorSal IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN DI-RutaC.KmtFin IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN DI-RutaC.KmtIni IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN DI-RutaC.NroDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.DI-RutaC"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* CIERRE DE HOJA DE RUTA */
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
  RUN Valida.
  IF RETURN-VALUE = 'ADM-ERROR'
  THEN RETURN NO-APPLY.
  MESSAGE 'Se va a proceder al cierre de la Hoja de Ruta' SKIP
    'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = NO THEN RETURN NO-APPLY.
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Di-RutaC EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN NO-APPLY.
      ASSIGN
        DI-RutaC.HorRet 
        DI-RutaC.KmtFin
        DI-RutaC.CtoRut
        DI-RutaC.FlgEst = 'C'.
      /* GUIAS REMISION ENTREGADAS */
      /* RHC 10.06.2011 TODO EN EL TRIGGER */
  END.
  FIND CURRENT Di-RutaC NO-LOCK NO-ERROR.
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
  DISPLAY FILL-IN-Marca 
      WITH FRAME D-Dialog.
  IF AVAILABLE DI-RutaC THEN 
    DISPLAY DI-RutaC.NroDoc DI-RutaC.FchDoc DI-RutaC.HorSal DI-RutaC.HorRet 
          DI-RutaC.KmtIni DI-RutaC.KmtFin DI-RutaC.CodVeh DI-RutaC.CtoRut 
          DI-RutaC.DesRut 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK Btn_Cancel DI-RutaC.HorRet DI-RutaC.KmtFin 
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
    FIND GN-VEHIC WHERE gn-vehic.codcia = DI-RutaC.codcia
        AND gn-vehic.placa = DI-RutaC.CodVeh:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEHIC THEN FILL-IN-Marca:SCREEN-VALUE = gn-vehic.Marca.
    IF INDEX(FILL-IN-Marca:SCREEN-VALUE, 'TAXI') > 0
    THEN DI-RutaC.CtoRut:SENSITIVE = YES.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "DI-RutaC"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida D-Dialog 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
/*validacion de campo c.y*/
  hora1 = substring(DI-RutaC.HorRet:screen-value, 1, 2).
  IF int(hora1) >= 24 then do:
    MESSAGE 'ingresar menor a 24 horas'.
    APPLY 'ENTRY' TO di-rutac.horRet.
    RETURN 'ADM-ERROR'.
  END.
  
  hora2 = substring(DI-RutaC.HorRet:screen-value, 3, 2).
  if int(hora2) >= 60 then do:
    message 'ingresar menor a 60 minutos'.
    APPLY 'ENTRY' TO di-rutac.horRet.
    RETURN 'ADM-ERROR'.
  END.

      
    IF DI-RutaC.HorRet:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE 'Debe ingresar la hora de retorno' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO di-rutac.horret.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL(DI-RutaC.KmtFin:SCREEN-VALUE) <= 0
    THEN DO:
        MESSAGE 'Debe ingresar el kilometraje de retorno' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO di-rutac.kmtfin.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL(DI-RutaC.KmtIni:SCREEN-VALUE) >= DECIMAL(DI-RutaC.KmtFin:SCREEN-VALUE)
    THEN DO:
        MESSAGE 'Debe ingresar el kilometraje mayor al de Salida' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO di-rutac.kmtfin.
        RETURN 'ADM-ERROR'.
    END.

  IF DI-RutaC.CtoRut:SENSITIVE = YES AND DECIMAL(DI-RutaC.CtoRut:SCREEN-VALUE) = 0 THEN DO:
    MESSAGE 'Debe ingresar el gasto del Taxi'.
    APPLY 'ENTRY' TO di-rutac.ctorut.
    RETURN 'ADM-ERROR'.
  END.
END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

