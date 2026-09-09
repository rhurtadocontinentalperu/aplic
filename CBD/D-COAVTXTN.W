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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE        VAR I-NroMes1 AS INTEGER NO-UNDO.
DEFINE        VAR I-NroMes2 AS INTEGER NO-UNDO.
DEFINE        VAR X-TASK-NO AS INTEGER NO-UNDO.
DEFINE        VAR I-NroOpe  AS INTEGER NO-UNDO.
DEFINE        VAR L-Salir   AS LOGICAL INITIAL NO NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE VAR I AS INTEGER.

  DEFINE TEMP-TABLE CoaVenta
   FIELD Coddoc AS CHAR
   FIELD Ruc    AS CHAR
   FIELD Ruc11  As CHAR 
   FIELD NomCli AS CHAR
   FIELD Implin AS DECIMAL EXTENT 10
   INDEX llave01 Ruc .

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
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-58 DesdeF HastaF F-DIVISION ~
BUTTON-5 Btn_OK F-Nrouit F-UIT EDITOR-1 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DesdeF HastaF F-DIVISION F-Nrouit F-UIT ~
EDITOR-1 F-Proceso 

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

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 32.86 BY 2.46 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(250)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-Nrouit AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Nro UIT" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Proceso AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesando" 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-UIT AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Valor U.I.T" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.86 BY 7.96.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     DesdeF AT ROW 1.5 COL 5.86 COLON-ALIGNED
     HastaF AT ROW 1.58 COL 26.72 COLON-ALIGNED
     F-DIVISION AT ROW 2.42 COL 5.72 COLON-ALIGNED
     BUTTON-5 AT ROW 2.42 COL 41.86
     Btn_OK AT ROW 2.81 COL 51
     F-Nrouit AT ROW 3.77 COL 8.43 COLON-ALIGNED
     F-UIT AT ROW 3.77 COL 27.14 COLON-ALIGNED
     EDITOR-1 AT ROW 4.88 COL 8 NO-LABEL
     Btn_Cancel AT ROW 5.04 COL 50.86
     F-Proceso AT ROW 7.69 COL 10.29 COLON-ALIGNED
     RECT-14 AT ROW 1 COL 1
     RECT-58 AT ROW 3.46 COL 2.57
     SPACE(23.85) SKIP(4.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Archivos Texto".


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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Archivos Texto */
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
  ASSIGN
     F-uit F-nrouit F-Division DesdeF HastaF.

  F-Proceso:VISIBLE = YES.

  RUN Genera-Texto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 D-Dialog
ON CHOOSE OF BUTTON-5 IN FRAME D-Dialog /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION D-Dialog
ON LEAVE OF F-DIVISION IN FRAME D-Dialog /* Division */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 ASSIGN F-DIVISION.
 
 IF F-DIVISION <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-DIVISION):
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
            /*
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
            */
          END.                             
        END.
 END.
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
  DISPLAY DesdeF HastaF F-DIVISION F-Nrouit F-UIT EDITOR-1 F-Proceso 
      WITH FRAME D-Dialog.
  ENABLE RECT-14 RECT-58 DesdeF HastaF F-DIVISION BUTTON-5 Btn_OK F-Nrouit 
         F-UIT EDITOR-1 Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto D-Dialog 
PROCEDURE Genera-Texto :
/*------------------------------------------------------------------------------
  Purpose: Carga archivo temporal segun parametros ingresados    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var c-codmon as integer init 1.
define var x-coddiv as char init "00000".
define var x-import as deci init 0.
define var x-ruc as char init "".
define var x-nomcli as char init "".
define var x-tc as deci init 0.

x-coddiv = f-division.
  
DO I = 1 TO NUM-ENTRIES(x-coddiv):
       
for each gn-divi no-lock where gn-divi.codcia = s-codcia and
                       gn-divi.coddiv = entry(I,x-coddiv) :
    for each ccbcdocu no-lock where ccbcdocu.codcia = s-codcia and 
                            ccbcdocu.coddiv = gn-divi.coddiv and 
                            (ccbcdocu.fchdoc >= DesdeF and
                            ccbcdocu.fchdoc <=  HastaF ) 
                            AND NOT ccbcdocu.nrodoc BEGINS '099'
                            AND lookup(ccbcdocu.coddoc,"FAC,BOL,N/C,N/D") > 0 and
                            flgest <> "A" :
        DISPLAY Ccbcdocu.Coddiv + " " + Ccbcdocu.Coddoc + "-" + ccbcdocu.nrodoc + " " + string(ccbcdocu.fchdoc,"99/99/9999") 
                @ F-Proceso WITH FRAME {&FRAME-NAME} .
        if codcli = "" THEN NEXT.
/*      if codcli = "11111111" or codcli = "11111111111" then NEXT.*/
      x-NomCli = "".
      x-Ruc    = "".
      x-Import = 0.      
      x-tc     = 0.
    
      CASE c-codmon:
           WHEN 1 THEN DO:
                IF codmon = 1 THEN DO:
                   x-import = imptot.
                END.
                IF codmon = 2 THEN DO:
                   FIND Gn-tcmb WHERE Gn-tcmb.fecha = Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                   IF AVAILABLE Gn-tcmb THEN x-tc = Gn-tcmb.Venta.
                   x-import = imptot * x-tc.
                END.
                
           END.
           WHEN 2 THEN DO:
                IF codmon = 2 THEN DO:
                   x-import = imptot.
                END.
                IF codmon = 1 THEN DO:
                   FIND Gn-tcmb WHERE Gn-tcmb.fecha = Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                   IF AVAILABLE Gn-tcmb THEN x-tc = Gn-tcmb.Venta.
                   x-import = imptot / x-tc.
                END.
           END.
      END CASE.

      IF Coddoc = "N/C" THEN DO:
         x-import = x-import * (-1).
      END.
              
        FIND Integral.GN-Clie WHERE Integral.GN-clie.CodCia = cl-codcia AND
                                    Integral.GN-clie.codcli = Integral.ccbcdocu.Codcli NO-LOCK NO-ERROR.
        IF AVAILABLE Integral.GN-clie THEN ASSIGN
           x-NomCli = Integral.GN-clie.NomCli
           x-ruc    = Integral.GN-clie.Ruc.
        ELSE x-NomCli = Integral.ccbcdocu.Nomcli.                   
                                 
        FIND CoaVenta WHERE CoaVenta.Ruc = x-ruc  NO-ERROR .
        
         
        /*find coaventa where coaventa.coddoc = ccbcdocu.coddoc no-error.*/
        
        IF NOT AVAILABLE CoaVenta THEN DO:
           CREATE CoaVenta.
           ASSIGN
           coaventa.coddoc = ccbcdocu.coddoc
           CoaVenta.Ruc    = x-Ruc
           CoaVenta.NomCli = x-NomCli.
        END.
        CoaVenta.ImpLin[1] = CoaVenta.ImpLin[1] + x-Import.
              
    end.                                      
end.

END.

/*
for each cv:
    find coaventa where coaventa.ruc = cv.ruc no-error.
    IF NOT AVAILABLE CoaVenta THEN DO:
       CREATE CoaVenta.
       ASSIGN
       CoaVenta.Ruc    = cv.Ruc
       CoaVenta.NomCli = cv.nombre.
    END.
    CoaVenta.ImpLin[1] = CoaVenta.ImpLin[1] + cv.impvta.
end.
*/

define var x-archivo  as char.
define var xx as deci init 0.
define var x-tipo as char .
define var x as integer init 0.
/*x-archivo = "c:\mis documentos\" + x-coddiv + "-" + string(MONTH(x-fecini),"99") + ".txt".*/

output to "c:\TEMP\ingresos.txt".

/*output to value(x-archivo).*/

for each coaventa break by coaventa.ruc descending:
/* display x-coddiv coaventa.coddoc x-fecini x-fecfin coaventa.implin[1] format "->>>>>>>>>>>>>9.99".*/

/*  xx = xx + coaventa.implin[1].*/
  IF coaventa.implin[1] < F-uit * F-nrouit THEN NEXT.
  
  x = x + 1.  
  x-tipo = if substring(coaventa.ruc,1,1) = "1" then "01" else "02".

  display    x
             "|"
             6
             "|"
             "20100038146" 
             "|"
             s-periodo format "9999"
             "|"
             x-tipo
             "|"
             6
             "|"
             coaventa.ruc format "x(11)" 
             "|"
             coaventa.implin[1] / 1.19  format "->>>>>>>>>>>>>9" 
             "|"
             "|"
             "|"
             "|"
             "|"
             coaventa.nomcli format "x(40)"               
             "|"
             with width 300.
  pause 0.
end.
/*display x-coddiv x-fecini x-fecfin xx format "->>>>>>>>>>>>>9.99".*/

output close.













    
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
     EDITOR-1:SCREEN-VALUE = "Este proceso permite generar los archivos texto necesarios 
para la transferencia de información al PDT SUNAT, si desea evaluar mas de una Division separarelo por comas
El Archivo de texto tiene el nombre C:\Temp\ingresos.txt".
     DesdeF:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
     HastaF:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
     F-Proceso:VISIBLE = NO.
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

