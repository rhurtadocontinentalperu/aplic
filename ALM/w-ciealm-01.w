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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VARIABLE D-INIMES  AS DATE.
DEFINE VARIABLE D-FINMES  AS DATE.
DEFINE VARIABLE D-FchCie  AS DATE.
DEFINE VARIABLE w-mes     AS integer.
DEFINE VARIABLE w-periodo AS integer.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fill-in-diacie w-ano Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS fill-in-diacie w-ano dia-1 dia-4 dia-5 ~
dia-6 dia-7 dia-8 dia-2 dia-3 dia-9 dia-10 dia-11 dia-12 TOGGLE-4 

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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\proces":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5.

DEFINE VARIABLE fill-in-diacie AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes a Procesar" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "         1","         2","         3","         3","         4","         5","         6","         7","         8","         9","        10","        11","        12" 
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE w-ano AS INTEGER FORMAT "9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .77
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.57 BY 6.77.

DEFINE VARIABLE dia-1 AS LOGICAL INITIAL no 
     LABEL "1" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-10 AS LOGICAL INITIAL no 
     LABEL "10" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-11 AS LOGICAL INITIAL no 
     LABEL "11" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-12 AS LOGICAL INITIAL no 
     LABEL "12" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-2 AS LOGICAL INITIAL no 
     LABEL "2" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-3 AS LOGICAL INITIAL no 
     LABEL "3" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-4 AS LOGICAL INITIAL no 
     LABEL "4" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-5 AS LOGICAL INITIAL no 
     LABEL "5" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-6 AS LOGICAL INITIAL no 
     LABEL "6" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-7 AS LOGICAL INITIAL no 
     LABEL "7" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-8 AS LOGICAL INITIAL no 
     LABEL "8" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-9 AS LOGICAL INITIAL no 
     LABEL "9" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE TOGGLE-4 AS LOGICAL INITIAL yes 
     LABEL "Dias Cerrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.43 BY .77
     FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     fill-in-diacie AT ROW 2.69 COL 10.86 COLON-ALIGNED
     w-ano AT ROW 1.19 COL 10.72 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.54 COL 21.72
     Btn_Cancel AT ROW 1.54 COL 35.72
     dia-1 AT ROW 5.08 COL 13
     dia-4 AT ROW 7.65 COL 13
     dia-5 AT ROW 8.5 COL 13
     dia-6 AT ROW 9.46 COL 13
     dia-7 AT ROW 5 COL 31.29
     dia-8 AT ROW 5.92 COL 31.14
     dia-2 AT ROW 5.92 COL 13
     dia-3 AT ROW 6.73 COL 13
     dia-9 AT ROW 6.88 COL 31.14
     dia-10 AT ROW 7.85 COL 31
     dia-11 AT ROW 8.73 COL 31
     dia-12 AT ROW 9.54 COL 31.14
     TOGGLE-4 AT ROW 11.31 COL 5.57
     RECT-54 AT ROW 4.23 COL 3.29
     "Enero" VIEW-AS TEXT
          SIZE 8.14 BY .54 AT ROW 5.15 COL 15.72
     "Octubre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 7.92 COL 34.14
     "Noviembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.85 COL 34
     "Diciembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.65 COL 34.14
     "Meses Cerrados" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 11.42 COL 8.14
          FONT 0
     "Meses:" VIEW-AS TEXT
          SIZE 8.29 BY .65 AT ROW 3.92 COL 12.72 RIGHT-ALIGNED
          FONT 6
     "Periodo :" VIEW-AS TEXT
          SIZE 7.72 BY .62 AT ROW 1.19 COL 4.72
          FONT 6
     "Febrero" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 6.04 COL 15.43
     "Marzo" VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 6.85 COL 15.57
     "Abril" VIEW-AS TEXT
          SIZE 4.29 BY .5 AT ROW 7.73 COL 15.43
     "Mayo" VIEW-AS TEXT
          SIZE 5.72 BY .5 AT ROW 8.54 COL 15.86
     "Junio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.58 COL 15.57
     "Julio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.12 COL 33.86
     "Agosto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6 COL 34.14
     "Setiembre" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.96 COL 34.14
     SPACE(5.14) SKIP(4.72)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cierre Mensual de Almacen".


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
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX dia-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-11 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-12 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-54 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TEXT-LITERAL "Meses:"
          SIZE 8.29 BY .65 AT ROW 3.92 COL 12.72 RIGHT-ALIGNED          */

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cierre Mensual de Almacen */
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
  ASSIGN FILL-IN-DiaCie w-ano.
  RUN Generar-Cierre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME w-ano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-ano D-Dialog
ON LEAVE OF w-ano IN FRAME D-Dialog
DO:
  ASSIGN W-ANO.
  RUN abrir-dat.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Abrir-Dat D-Dialog 
PROCEDURE Abrir-Dat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
D-INIMES = DATE(01,01,w-ano). /*DATE(l-meses,01,w-ano).*/
D-FINMES = DATE(12,31,w-ano). /*D-INIMES + 32 - DAY(D-INIMES + 32).*/
 
 DIA-1  = NO.
 DIA-2  = NO.
 DIA-3  = NO.
 DIA-4  = NO.
 DIA-5  = NO.
 DIA-6  = NO.
 DIA-7  = NO.
 DIA-8  = NO.
 DIA-9  = NO.
 DIA-10 = NO.
 DIA-11 = NO.
 DIA-12 = NO.
FOR EACH AlmCieAl WHERE 
         AlmCieAl.CodCia = S-CODCIA   AND
         AlmCieAl.CodAlm = S-CODALM   AND
         AlmCieAl.FchCie >= D-INIMES  AND 
         AlmCieAl.FchCie <= D-FINMES  :
    IF month(AlmCieAl.FchCie) = 01 AND AlmCieAl.FlgCie THEN DIA-1 = YES.
    IF month(AlmCieAl.FchCie) = 02 AND AlmCieAl.FlgCie THEN DIA-2 = YES.
    IF month(AlmCieAl.FchCie) = 03 AND AlmCieAl.FlgCie THEN DIA-3 = YES.
    IF month(AlmCieAl.FchCie) = 04 AND AlmCieAl.FlgCie THEN DIA-4 = YES.
    IF month(AlmCieAl.FchCie) = 05 AND AlmCieAl.FlgCie THEN DIA-5 = YES.
    IF month(AlmCieAl.FchCie) = 06 AND AlmCieAl.FlgCie THEN DIA-6 = YES.
    IF month(AlmCieAl.FchCie) = 07 AND AlmCieAl.FlgCie THEN DIA-7 = YES.
    IF month(AlmCieAl.FchCie) = 08 AND AlmCieAl.FlgCie THEN DIA-8 = YES.
    IF month(AlmCieAl.FchCie) = 09 AND AlmCieAl.FlgCie THEN DIA-9 = YES.
    IF month(AlmCieAl.FchCie) = 10 AND AlmCieAl.FlgCie THEN DIA-10 = YES.
    IF month(AlmCieAl.FchCie) = 11 AND AlmCieAl.FlgCie THEN DIA-11 = YES.
    IF month(AlmCieAl.FchCie) = 12 AND AlmCieAl.FlgCie THEN DIA-12 = YES.
  
END.
DO WITH FRAME {&FRAME-NAME}:
   DISPLAY DIA-1  DIA-2  DIA-3  DIA-4  DIA-5  DIA-6  DIA-7  DIA-8  DIA-9  DIA-10 
           DIA-11 DIA-12.
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY fill-in-diacie w-ano dia-1 dia-4 dia-5 dia-6 dia-7 dia-8 dia-2 dia-3 
          dia-9 dia-10 dia-11 dia-12 TOGGLE-4 
      WITH FRAME D-Dialog.
  ENABLE fill-in-diacie w-ano Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Cierre D-Dialog 
PROCEDURE Generar-Cierre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
w-mes = FILL-IN-DiaCie.
w-periodo = w-ano.
D-INIMES = DATE(W-MES,01,w-periodo).
D-FINMES = D-INIMES + 32 - DAY(D-INIMES + 32).
DEFINE VAR D-FchCie AS DATE NO-UNDO.
DO D-FchCie = D-INIMES TO D-FINMES:
   FIND AlmCieAl WHERE 
        AlmCieAl.CodCia = S-CODCIA AND
        AlmCieAl.CodAlm = S-CODALM AND
        AlmCieAl.FchCie = D-FchCie 
        EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmCieAl THEN DO:
      CREATE AlmCieAl.
      ASSIGN AlmCieAl.CodCia = S-CODCIA
             AlmCieAl.CodAlm = S-CODALM 
             AlmCieAl.FchCie = D-FchCie.
   END.
   if AlmCieAl.FlgCie   = YES then 
     ASSIGN AlmCieAl.FlgCie   = NO
          AlmCieAl.UsuCierr = S-USER-ID.
   else DO:
     ASSIGN AlmCieAl.FlgCie   = YES
          AlmCieAl.UsuCierr = S-USER-ID.
   end.
   RELEASE AlmCieAl.       
END.
RUN ABRIR-DAT.
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
  ASSIGN w-ano = year(today)
         FILL-IN-DiaCie = month(TODAY).
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Abrir-Dat.
  
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


