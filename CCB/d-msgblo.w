&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}


DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pNroCard AS CHAR.
DEF OUTPUT PARAMETER pRpta AS CHAR.

/*
    DEF VAR pCodCli AS CHAR INIT '11111111111'.
    DEF VAR pNroCard AS CHAR INIT '000175'.
    DEF VAR pRpta AS CHAR.
*/

DEF VAR x-CodUnico AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

pRpta = 'OK'.

/* Buscamos el código unificado del cliente */
FIND FIRST Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
IF pCodCli = FacCfgGn.CliVar THEN DO:       /* Clientes Varios */
    IF pNroCard = '' THEN RETURN.
    FIND FIRST Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND GN-clie.nrocard = NroCard NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
        AND gn-clie.codcli = pCodCli
        NO-LOCK NO-ERROR.
END.
IF NOT AVAILABLE Gn-clie OR Gn-clie.codunico = '' THEN RETURN.

x-CodUnico = GN-clie.codunico.

/* BUscamos si existe algun mensaje */
FIND LAST gn-cliem WHERE gn-cliem.codcia = cl-codcia
    AND gn-cliem.codunico = x-codunico
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-cliem THEN RETURN.
IF gn-cliem.FchVto < TODAY THEN RETURN.

IF gn-cliem.Tipo = 'S' THEN pRpta = 'ADM-ERROR'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-cliem

/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define QUERY-STRING-gDialog FOR EACH gn-cliem SHARE-LOCK
&Scoped-define OPEN-QUERY-gDialog OPEN QUERY gDialog FOR EACH gn-cliem SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-gDialog gn-cliem
&Scoped-define FIRST-TABLE-IN-QUERY-gDialog gn-cliem


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Mensaje FILL-IN_ImpMn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "<<< REGRESAR" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "CONTINUAR >>>" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE EDITOR_Mensaje AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62 BY 6.46
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpMn AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "MONTO MAXIMO A RETENER S/." 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY gDialog FOR 
      gn-cliem SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     EDITOR_Mensaje AT ROW 1.54 COL 2 NO-LABEL WIDGET-ID 22
     FILL-IN_ImpMn AT ROW 8.54 COL 32 COLON-ALIGNED WIDGET-ID 24
     Btn_OK AT ROW 10.69 COL 2
     Btn_Cancel AT ROW 10.69 COL 19
     SPACE(31.13) SKIP(0.44)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "AVISO IMPORTANTE !!!"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR_Mensaje IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpMn IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _TblList          = "INTEGRAL.gn-cliem"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* AVISO IMPORTANTE !!! */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* <<< REGRESAR */
DO:
  pRpta = 'ADM-ERROR'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* CONTINUAR >>> */
DO:
    IF pRpta = 'ADM-ERROR' THEN DO:         /* Necesario Password del administrador */
        RUN Clave-Administrador.
        IF RETURN-VALUE = 'ADM-ERROR' 
        THEN pRpta = 'ADM-ERROR'.
        ELSE DO:
            pRpta = 'OK'.
            RUN Log-de-Control.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Clave-Administrador gDialog 
PROCEDURE Clave-Administrador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Valida Clave de Anulación */
    DEF VAR s-coddoc AS CHAR INIT 'I/C' NO-UNDO.

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY EDITOR_Mensaje FILL-IN_ImpMn 
      WITH FRAME gDialog.
  ENABLE Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  EDITOR_Mensaje = gn-cliem.Mensaje.
  FILL-IN_ImpMn  = gn-cliem.ImpMn.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF gn-cliem.Tipo = 'N' THEN FILL-IN_ImpMn:VISIBLE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Log-de-control gDialog 
PROCEDURE Log-de-control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR cTabla  AS CHAR NO-UNDO.
  DEF VAR cLlave  AS CHAR NO-UNDO.
  DEF VAR cEvento AS CHAR NO-UNDO.

  cTabla = 'gn-cliem'.      /* Tabla de mensajes por cliente */
  cLlave = x-CodUnico + '|' +  ~
      STRING(gn-cliem.NroMsg, '>>>9') + '|' + ~
      STRING(gn-cliem.ImpMn, '>>>>>>>>>.99') + '|' + ~
      STRING(gn-cliem.ImpMe, '>>>>>>>>>.99').
  cEvento = 'VENTA MOSTRADOR'.
  RUN lib/logtabla (cTabla, cLlave, cEvento).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

