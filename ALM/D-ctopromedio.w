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

/* Local Variable Definitions ---                                       */

def var s-codcia as inte init 1.
def var s-nomcia as char init ''.
def var f-stkact as deci no-undo.
def var f-stkactcbd as deci no-undo.
def var f-stkgen as deci no-undo.
def var f-stkgencbd as deci no-undo.
def var f-vctomn as deci no-undo.
def var f-vctomncbd as deci no-undo.
def var f-vctome as deci no-undo.
def var f-vctomecbd as deci no-undo.
def var f-tctomn as deci no-undo.
def var f-tctome as deci no-undo.
def var f-pctomn as deci no-undo.
def var f-pctome as deci no-undo.

def buffer almdmov2 for almdmov.
def buffer almacen2 for almacen.
def buffer almcmov2 for almcmov.
def buffer ccbcdocu2 for ccbcdocu.

def var f-candes as deci no-undo.
def var x-next as inte init 1.
def var x-indi as deci no-undo.
def var m as integer init 5.

DEF SHARED VAR s-user-id AS CHAR.

def buffer B-STKAL FOR AlmStkAl.
def buffer B-STKGE FOR AlmStkGe.
def buffer b-mov   FOR Almtmov.

def var x-signo  as deci no-undo.  
def var x-ctomed as deci no-undo.
def var x-stkgen as deci no-undo.
def var x-cto    as deci no-undo.
def var x-factor as inte no-undo.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-14 RECT-16 RECT-15 RECT-17 ~
RADIO-SET-Tipo DesdeC Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodAlm FILL-IN-DesAlm ~
RADIO-SET-Tipo DesdeC NroOrden i-fchdoc FILL-IN-Proceso 

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
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesAlm AS CHARACTER FORMAT "X(300)":U 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Proceso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.86 BY .92
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE i-fchdoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81.

DEFINE VARIABLE NroOrden AS CHARACTER FORMAT "X(6)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por artículo", 1,
"Por Orden de Trabajo", 2,
"Todos los artículos", 3
     SIZE 44 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.86 BY 1.73.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.72 BY 1.62.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 1.46.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.14 BY 1.62.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.72 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-CodAlm AT ROW 2.08 COL 1.14 COLON-ALIGNED NO-LABEL
     FILL-IN-DesAlm AT ROW 2.08 COL 7.14 COLON-ALIGNED NO-LABEL
     RADIO-SET-Tipo AT ROW 3.42 COL 3 NO-LABEL WIDGET-ID 8
     DesdeC AT ROW 5.23 COL 10.72 COLON-ALIGNED
     NroOrden AT ROW 5.23 COL 33.72 COLON-ALIGNED WIDGET-ID 2
     i-fchdoc AT ROW 7.19 COL 10.86 COLON-ALIGNED
     FILL-IN-Proceso AT ROW 9.19 COL 3.57 NO-LABEL
     Btn_OK AT ROW 10.69 COL 2.14
     Btn_Cancel AT ROW 10.69 COL 13.14
     "Articulo :" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 4.5 COL 3.14
          FGCOLOR 9 FONT 0
     "Estado :":50 VIEW-AS TEXT
          SIZE 10.29 BY .5 AT ROW 8.58 COL 3
          FGCOLOR 9 FONT 0
     "Compañia :":40 VIEW-AS TEXT
          SIZE 12.29 BY .5 AT ROW 1.35 COL 3.14
          FGCOLOR 9 FONT 0
     "Fecha:":40 VIEW-AS TEXT
          SIZE 8.72 BY .5 AT ROW 6.62 COL 3.29
          FGCOLOR 9 FONT 0
     "Orden de Trabajo:" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 4.5 COL 26.14 WIDGET-ID 6
          FGCOLOR 9 FONT 0
     RECT-11 AT ROW 1.54 COL 2.14
     RECT-14 AT ROW 4.73 COL 2.14
     RECT-16 AT ROW 8.77 COL 2
     RECT-15 AT ROW 6.88 COL 2.29
     RECT-17 AT ROW 4.73 COL 25.14 WIDGET-ID 4
     SPACE(17.99) SKIP(6.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Regeneracion de Costo y Stock por Compañia".


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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Proceso IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN i-fchdoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NroOrden IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Regeneracion de Costo y Stock por Compañia */
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
  ASSIGN DesdeC i-fchdoc RADIO-SET-Tipo NroOrden.

  IF YEAR(i-fchdoc) < YEAR(TODAY) THEN DO:
      IF (YEAR(TODAY) - YEAR(i-fchdoc)) > 1 THEN DO:
          MESSAGE "No puede recalcular Costos con mas de un año de antiguedad".
          RETURN NO-APPLY.
      END.
  END.

  CASE RADIO-SET-Tipo:
      WHEN 1 THEN RUN Calculo_Costo_Promedio.
      WHEN 2 THEN RUN Calculo_Costo_Promedio-2.
      WHEN 3 THEN RUN Calculo_Costo_Promedio-3.
  END CASE.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Código */
do:
  DEFINE VAR cFiler AS CHAR.
  cFiler = desdec:screen-value.
  if input desdec:screen-value = '' then do:
      find first almmmatg where almmmatg.codcia = s-codcia
                          use-index matg01
                          no-lock no-error.
      if avail almmmatg then desdec:screen-value = almmmatg.codmat.
  end.    
  desdec:screen-value = string(integer(desdec:screen-value),'999999') NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
        desdec:SCREEN-VALUE = cFiler.
  END.
  find first almmmatg where almmmatg.codcia = s-codcia
                        and almmmatg.codmat = desdec:screen-value
                        no-lock no-error.
  if not avail almmmatg then do:
      message "Artículo no existe en el catalogo" view-as alert-box error.
      return no-apply.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fchdoc D-Dialog
ON LEAVE OF i-fchdoc IN FRAME D-Dialog /* Inicio */
do:
  if input i-fchdoc:screen-value = '' or  input i-fchdoc:screen-value = ? then do:
    i-fchdoc:screen-value = string(today).
  end.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NroOrden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NroOrden D-Dialog
ON LEAVE OF NroOrden IN FRAME D-Dialog /* Número */
do:
  if input desdec:screen-value = '' then do:
      find first almmmatg where almmmatg.codcia = s-codcia
                          use-index matg01
                          no-lock no-error.
      if avail almmmatg then desdec:screen-value = almmmatg.codmat.
  end.    
  desdec:screen-value = string(integer(desdec:screen-value),'999999').
  find first almmmatg where almmmatg.codcia = s-codcia
                        and almmmatg.codmat = desdec:screen-value
                        no-lock no-error.
  if not avail almmmatg then do:
      message "Artículo no existe en el catalogo" view-as alert-box error.
      return no-apply.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Tipo D-Dialog
ON VALUE-CHANGED OF RADIO-SET-Tipo IN FRAME D-Dialog
DO:
  CASE INPUT {&self-name}:
      WHEN 1 THEN ASSIGN DesdeC:SENSITIVE = YES NroOrden:SENSITIVE = NO.
      WHEN 2 THEN ASSIGN DesdeC:SENSITIVE = NO NroOrden:SENSITIVE = YES.
      WHEN 3 THEN ASSIGN DesdeC:SENSITIVE = NO NroOrden:SENSITIVE = NO.
  END CASE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo_Costo_Promedio D-Dialog 
PROCEDURE Calculo_Costo_Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA 
    AND Almmmatg.codmat = desdec 
    USE-INDEX matg01 :
    /*RUN Actualiza-Producto.*/
    RUN alm/calc-costo-promedio (Almmmatg.codmat, I-FchDoc, OUTPUT pMensaje).
    IF pMensaje > '' THEN MESSAGE pMensaje.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo_Costo_Promedio-2 D-Dialog 
PROCEDURE Calculo_Costo_Promedio-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND PR-ODPC WHERE PR-ODPC.CodCia = S-CODCIA 
    AND PR-ODPC.NumOrd = NroOrden
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-ODPC THEN RETURN.
FOR EACH PR-ODPCX OF PR-ODPC NO-LOCK,
    EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = PR-ODPCX.Codcia
    AND Almmmatg.codmat = PR-ODPCX.codart:
    /*RUN Actualiza-Producto.*/
    RUN alm/calc-costo-promedio (Almmmatg.codmat, I-FchDoc, OUTPUT pMensaje).
    IF pMensaje > '' THEN MESSAGE pMensaje.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo_Costo_Promedio_3 D-Dialog 
PROCEDURE Calculo_Costo_Promedio_3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Se van a procesar TODOS los artículos' SKIP
    'Está seguro de continuar con el proceso?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA USE-INDEX matg01 :
    RUN alm/calc-costo-promedio (Almmmatg.codmat, I-FchDoc, OUTPUT pMensaje).
    IF pMensaje > '' THEN MESSAGE pMensaje.
END.

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
  DISPLAY FILL-IN-CodAlm FILL-IN-DesAlm RADIO-SET-Tipo DesdeC NroOrden i-fchdoc 
          FILL-IN-Proceso 
      WITH FRAME D-Dialog.
  ENABLE RECT-11 RECT-14 RECT-16 RECT-15 RECT-17 RADIO-SET-Tipo DesdeC Btn_OK 
         Btn_Cancel 
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
  
  MESSAGE 'Al ejecutar este proceso tenga presente lo siguiente:' skip
          '1. Este proceso causa excesiva congestión al SIE' skip
          '2. Ejecutesé sobre algunos articulos, no todos.' skip
          '3. La interrupcion de este proceso puede causar daños en los stocks.' skip
          '4. Si requiere procesar todos los articulos, solicitelo a Informática.' skip
          '5. Los usuarios que incumplan estas observaciones seran reportados a las áreas afectadas.' skip
          skip
          '                                                               INFORMATICA'
          view-as alert-box information  
          title 'IMPORTANTE. LEASÉ ANTES DE CONTINUAR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  find first gn-cias where GN-CIAS.CodCia = S-CodCia
                       no-lock no-error.
  if avail gn-cias then s-nomcia = GN-CIAS.NomCia.                     



  FIND LAST AlmCieAl WHERE AlmCieAl.Codcia = S-CODCIA 
    AND AlmCieAl.FlgCie = YES
    NO-LOCK NO-ERROR.
                      
  IF AVAILABLE AlmCieAl THEN i-fchdoc = AlmCieAl.FchCie + 1.   

  IF i-fchdoc = ? THEN i-fchdoc = DATE(01,01,YEAR(TODAY)).

  RUN gn/fecha-de-cierre (OUTPUT i-fchdoc).
  i-fchdoc = i-fchdoc - (3 * 30).
  DISPLAY S-CODCIA @ FILL-IN-CodAlm  
          S-NOMCIA @ FILL-IN-DesAlm 
          i-fchdoc @ i-fchdoc 
           WITH FRAME {&FRAME-NAME}.

/* 12Ene2026 */
  DEFINE VAR lFechaEditable AS LOG INIT NO.
  DEFINE VAR cUsuariosPermitidos AS CHAR.

  DEFINE VAR cTabla AS CHAR.
  DEFINE VAR cLlave_c1 AS CHAR.
  DEFINE VAR cLlave_c2 AS CHAR.
  DEFINE VAR cLlave_c3 AS CHAR.

  cTabla = "CONFIG-ALM".
  cLlave_c1 = "REGENERACION".
  cLlave_c2 = "COSTO Y STOCK".
  cLlave_c3 = "FECHAEDITABLE".

  FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.llave_c1 = cLlave_c1 AND 
                            vtatabla.llave_c2 = cLlave_c2 AND vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN cUsuariosPermitidos = TRIM(vtatabla.llave_c5).
  IF NOT (TRUE <> (cUsuariosPermitidos > "")) AND LOOKUP(s-user-id,cUsuariosPermitidos) > 0 THEN lFechaEditable = YES.

  IF lFechaEditable = YES THEN i-fchdoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
     
  /*IF s-user-id = 'ADMIN' OR s-user-id = 'FMC-00' THEN i-fchdoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.*/

  
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

