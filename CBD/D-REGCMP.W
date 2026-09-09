&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE        VAR X-TASK-NO AS INTEGER NO-UNDO.
DEFINE        VAR I-NroMes  AS INTEGER NO-UNDO.
DEFINE        VAR I-NroItm  AS INTEGER NO-UNDO.
DEFINE        VAR I-NroOpe  AS INTEGER NO-UNDO.
DEFINE        VAR L-Salir   AS LOGICAL INITIAL NO NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "cbd\rbcbd.prl".


DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Registro de Compras".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

FIND cb-cfgg WHERE cb-cfgg.CODCIA = 0 AND cb-cfgg.CODCFG = "R01" NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
   MESSAGE "No esta configurado el registro de Compras" VIEW-AS 
   ALERT-BOX ERROR.
   RETURN.
END.

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
&Scoped-Define ENABLED-OBJECTS CB-Mes F-CodDiv F-CodDoc CB-CodOpe R-CodMon ~
Btn_OK Btn_Cancel RECT-13 RECT-14 
&Scoped-Define DISPLAYED-OBJECTS CB-Mes F-CodDiv F-CodDoc CB-CodOpe ~
R-CodMon F-Proceso 

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
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE CB-CodOpe AS CHARACTER FORMAT "X(5)":U 
     LABEL "Operaciones" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8.57 BY 1 NO-UNDO.

DEFINE VARIABLE CB-Mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .81 NO-UNDO.

DEFINE VARIABLE F-Proceso AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesando" 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE R-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.29 BY .92.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.43 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     CB-Mes AT ROW 1.35 COL 9.57 COLON-ALIGNED
     F-CodDiv AT ROW 2.58 COL 9.57 COLON-ALIGNED
     F-CodDoc AT ROW 2.58 COL 30.14 COLON-ALIGNED
     CB-CodOpe AT ROW 3.96 COL 9.57 COLON-ALIGNED
     R-CodMon AT ROW 5.46 COL 12 NO-LABEL
     F-Proceso AT ROW 6.73 COL 9.57 COLON-ALIGNED
     Btn_OK AT ROW 1.85 COL 44
     Btn_Cancel AT ROW 5.04 COL 44
     "Moneda :" VIEW-AS TEXT
          SIZE 6.29 BY .65 AT ROW 5.46 COL 4
     RECT-13 AT ROW 5.31 COL 11.57
     RECT-14 AT ROW 1 COL 1
     SPACE(15.99) SKIP(0.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Compras".


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

/* SETTINGS FOR FILL-IN F-Proceso IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Compras */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  L-Salir = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN CB-CodOpe F-CodDiv F-CodDoc R-CodMon CB-Mes.
  I-NroMes = LOOKUP(CB-MES,CB-MES:LIST-ITEMS).
  I-NroOpe = IF CB-CodOpe = "" THEN CB-CodOpe:NUM-ITEMS - 1 ELSE 1.
  IF CB-CodOpe = "" THEN CB-CodOpe = SUBSTRING(CB-CodOpe:LIST-ITEMS,2).
  F-Proceso:VISIBLE = YES.
  RUN Imprime.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo D-Dialog 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose: Carga archivo temporal segun parametros ingresados    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR L-Ubica   AS LOGICAL INIT YES NO-UNDO. 
DEFINE VAR F-IMPORTE AS DECIMAL NO-UNDO.
DEFINE VAR jj        AS INTEGER NO-UNDO.
DEFINE VAR C-OPER    AS CHAR    NO-UNDO.
I-NroItm = 0.
REPEAT WHILE L-Ubica:
       X-TASK-NO = RANDOM(900000,999999).
       FIND FIRST w-report WHERE w-report.task-no = X-TASK-NO NO-LOCK NO-ERROR.
       IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

RegCmp:
DO jj = 1 TO I-NroOpe:
    C-OPER = ENTRY(jj,CB-CodOpe).
    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.Codcia = S-CODCIA AND
             cb-cmov.Periodo = S-PERIODO AND
             cb-cmov.Nromes = I-NroMes   AND
             cb-cmov.Codope = C-OPER     AND
             NOT L-Salir: 
        IF F-CodDiv NE "" AND F-CodDiv NE cb-cmov.CodDiv THEN NEXT.
        F-Proceso = "VOUCHER : " + cb-cmov.Codope + "-" + cb-cmov.NroAst.
        DISPLAY F-Proceso WITH FRAME {&FRAME-NAME}.
        RegDet:
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.Codcia = cb-cmov.Codcia AND
             cb-dmov.Periodo = cb-cmov.Periodo AND
             cb-dmov.Nromes = cb-cmov.Nromes  AND
             cb-dmov.Codope = cb-cmov.Codope AND
             cb-dmov.NroAst = cb-cmov.NroAst 
             BREAK BY cb-dmov.NroAst:
             IF FIRST-OF(cb-dmov.NroAst) THEN DO:
                CREATE w-report.
                ASSIGN w-report.Task-No = X-TASK-NO
                       w-report.Llave-I = cb-dmov.CodCia
                       w-report.Llave-C = cb-dmov.CodOpe + "-" + cb-dmov.NroAst
                       w-report.Campo-I[1] = cb-dmov.NroMes
                       w-report.Campo-I[2] = cb-dmov.periodo.
             END.
             /* IF cb-dmov.TpoItm = "A" OR cb-dmov.TpoItm = "N" THEN NEXT. */
             IF cb-dmov.TpoItm <> "" THEN NEXT.
             I-NroItm = I-NroItm + 1.
             L-Ubica = NO.
             F-IMPORTE = IF R-CodMon = 1 THEN cb-dmov.ImpMn1 ELSE cb-dmov.ImpMn2.
             IF (cb-dmov.CodCta BEGINS "6" OR cb-dmov.CodCta BEGINS "7" OR
                cb-dmov.CodCta BEGINS "33" OR cb-dmov.CodCta BEGINS "34" OR cb-dmov.CodCta BEGINS "4011") OR 
                (cb-dmov.CodCta = "42130101") OR (cb-dmov.CodCta = "42130102") OR
                (cb-dmov.CodCta BEGINS "162101") OR (cb-dmov.CodCta BEGINS "462101") OR
                cb-dmov.CodCta BEGINS "38" OR cb-dmov.CodCta BEGINS "46910102" THEN DO:
                IF cb-dmov.TpoMov THEN F-IMPORTE = F-IMPORTE * -1.
                IF cb-dmov.tm = 0 THEN ASSIGN w-report.Campo-F[10] = w-report.Campo-F[10] + F-IMPORTE.
                ELSE ASSIGN w-report.Campo-F[cb-dmov.tm] = w-report.Campo-F[cb-dmov.tm] + F-IMPORTE.
                L-Ubica = YES.
             END.
             IF NOT L-Ubica AND cb-dmov.CodCta BEGINS "40" AND cb-dmov.TpoMov AND
                NOT cb-dmov.CodCta BEGINS "4011" THEN DO:
                ASSIGN w-report.Campo-F[11] = w-report.Campo-F[11] + F-IMPORTE.
                L-Ubica = YES.
             END.
             IF NOT L-Ubica AND (cb-dmov.CodCta BEGINS "42" OR cb-dmov.CodCta BEGINS "46") AND
                (cb-dmov.CodCta NE "42130101" AND cb-dmov.CodCta NE "42130102") THEN DO:
                IF NOT cb-dmov.TpoMov THEN F-IMPORTE = F-IMPORTE * -1.
                ASSIGN w-report.Campo-F[11] = w-report.Campo-F[11] + F-IMPORTE
                       w-report.Campo-C[1]  = cb-dmov.CodOpe + "-" + cb-dmov.NroAst
                       w-report.Campo-D[1]  = cb-dmov.FchDoc
                       w-report.Campo-C[2]  = cb-dmov.CodDoc
                       w-report.Campo-C[3]  = cb-dmov.NroDoc.
                IF cb-dmov.CodDoc = "07" OR cb-dmov.CodDoc = "08" THEN
                   ASSIGN w-report.Campo-C[6]  = cb-dmov.CodRef
                          w-report.Campo-C[7]  = cb-dmov.NroRef.
                FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                     gn-prov.CodPro = cb-dmov.CodAux NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN 
                   ASSIGN w-report.Campo-C[4] = gn-prov.Ruc
                          w-report.Campo-C[5] = gn-prov.NomPro.
                ELSE 
                   ASSIGN w-report.Campo-C[4]  = cb-dmov.NroRuc
                          w-report.Campo-C[5]  = cb-dmov.GloDoc.
                L-Ubica = YES.
             END.
        END.
        PROCESS EVENTS.
    END.
END.
IF F-CodDoc NE "" THEN DO: 
   FOR EACH w-report where w-report.Task-No = X-TASK-NO:
       IF F-CodDoc <> w-report.Campo-C[2] THEN DELETE w-report.
   END.
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
  DISPLAY CB-Mes F-CodDiv F-CodDoc CB-CodOpe R-CodMon F-Proceso 
      WITH FRAME D-Dialog.
  ENABLE CB-Mes F-CodDiv F-CodDoc CB-CodOpe R-CodMon Btn_OK Btn_Cancel RECT-13 
         RECT-14 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN Carga-Tempo.
    
    IF  I-NroItm = 0 THEN DO:
        MESSAGE "No existen registros a listar" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    
    RB-FILTER = "w-report.task-no = " + STRING(X-TASK-NO).

    /*RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA.*/
    
    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            


    DELETE FROM w-report WHERE w-report.task-no = X-TASK-NO.
    
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

  CB-CodOpe:LIST-ITEMS IN FRAME {&FRAME-NAME} = "," + cb-cfgg.codope.
  CB-Mes:SCREEN-VALUE = ENTRY(S-NroMes,CB-Mes:LIST-ITEMS).
  F-Proceso:VISIBLE = NO.

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
        WHEN "F-CodDoc" THEN ASSIGN input-var-1 = "02".
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

