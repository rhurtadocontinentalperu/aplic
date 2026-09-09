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
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.

DEFINE VAR I AS INTEGER.

DEFINE TEMP-TABLE CoaVenta
    FIELD Coddoc AS CHAR
    FIELD Ruc    AS CHAR
    FIELD Ruc11  As CHAR 
    FIELD NomCli AS CHAR
    FIELD Implin AS DECIMAL
    INDEX llave01 Ruc.

DEFINE STREAM REPORT.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-5 DesdeF HastaF F-Nrouit F-UIT ~
EDITOR-1 FILL-IN-file Btn_OK Btn_Cancel RECT-14 RECT-58 
&Scoped-Define DISPLAYED-OBJECTS DesdeF HastaF F-DIVISION F-Nrouit F-UIT ~
EDITOR-1 F-Proceso FILL-IN-file 

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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U NO-FOCUS
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
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .69
     BGCOLOR 15  NO-UNDO.

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

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U INITIAL "N:~\ingresos.txt" 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.86 BY 9.42.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BUTTON-5 AT ROW 2.42 COL 41.86
     DesdeF AT ROW 1.5 COL 5.86 COLON-ALIGNED
     HastaF AT ROW 1.5 COL 26.72 COLON-ALIGNED
     F-DIVISION AT ROW 2.42 COL 5.86 COLON-ALIGNED
     F-Nrouit AT ROW 3.77 COL 8.43 COLON-ALIGNED
     F-UIT AT ROW 3.77 COL 27.14 COLON-ALIGNED
     EDITOR-1 AT ROW 4.88 COL 8 NO-LABEL
     F-Proceso AT ROW 7.73 COL 10 COLON-ALIGNED
     FILL-IN-file AT ROW 8.54 COL 10 COLON-ALIGNED
     Btn_OK AT ROW 2.73 COL 51
     Btn_Cancel AT ROW 5.04 COL 51
     RECT-14 AT ROW 1 COL 1
     RECT-58 AT ROW 3.46 COL 2.57
     SPACE(23.85) SKIP(5.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DAOT - Ingresos".


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

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* SETTINGS FOR FILL-IN F-DIVISION IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* DAOT - Ingresos */
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

    ASSIGN F-uit F-nrouit F-Division DesdeF HastaF FILL-IN-file.

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
        DEF VAR x-Divisiones AS CHAR.
        x-Divisiones = f-Division:SCREEN-VALUE.
        RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
        f-Division:SCREEN-VALUE = x-Divisiones.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION D-Dialog
ON LEAVE OF F-DIVISION IN FRAME D-Dialog /* División */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN F-DIVISION.
        IF F-DIVISION <> "" THEN DO:
            DO I = 1 TO NUM-ENTRIES(F-DIVISION):
                FIND Gn-Divi WHERE
                    Gn-Divi.Codcia = S-CODCIA AND
                    Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Gn-Divi THEN DO:
                    MESSAGE
                        "División " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                        "Verifique Por Favor..."
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN NO-APPLY.
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
          FILL-IN-file 
      WITH FRAME D-Dialog.
  ENABLE BUTTON-5 DesdeF HastaF F-Nrouit F-UIT EDITOR-1 FILL-IN-file Btn_OK 
         Btn_Cancel RECT-14 RECT-58 
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

define var c-codmon as integer init 1 NO-UNDO.
define var x-import as deci init 0 NO-UNDO.
define var x-ruc as char init "" NO-UNDO.
define var x-nomcli as char init "" NO-UNDO.
define var x-tc as deci init 0 NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.

EMPTY TEMP-TABLE CoaVenta.
for each ccbcdocu no-lock where
    ccbcdocu.codcia = s-codcia and
    LOOKUP(ccbcdocu.coddiv,f-division) > 0 AND
    (ccbcdocu.fchdoc >= DesdeF and ccbcdocu.fchdoc <=  HastaF) AND
    LOOKUP (ccbcdocu.coddoc, "FAC,N/C,N/D") > 0 AND
    ccbcdocu.flgest <> "A":
    IF ccbcdocu.codcli = "" THEN NEXT.
    IF NOT (ccbcdocu.ruccli BEGINS '1'
        OR ccbcdocu.ruccli BEGINS '2')
        THEN NEXT.


    DISPLAY
        Ccbcdocu.Coddiv + " " + Ccbcdocu.Coddoc + "-" +
        ccbcdocu.nrodoc + " " + string(ccbcdocu.fchdoc,"99/99/9999")
        @ F-Proceso WITH FRAME {&FRAME-NAME}.

    ASSIGN
        x-NomCli = ccbcdocu.Nomcli
        x-Ruc    = CcbCDocu.RucCli
        x-Import = 0
        x-tc     = 0
        x-import = CcbcDocu.ImpVta.
    IF x-Import = 0 THEN x-Import = Ccbcdocu.ImpTot.

    /* CUANDO TENGAN APLICADO UN ADELANTO */
    IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
        AND Ccbcdocu.FlgEst <> 'A' 
        AND LOOKUP(Ccbcdocu.TpoFac, "S,A") = 0  /* NO Servicios NO Adelantos de Campaña */
        AND Ccbcdocu.ImpTot2 > 0
        THEN DO:
        /* Recalculamos Importes */
        IF (Ccbcdocu.ImpTot - Ccbcdocu.ImpTot2) <= 0 THEN DO:
            ASSIGN
                x-Import = 0.
        END.
        ELSE DO:
            x-Factor = (Ccbcdocu.ImpTot - Ccbcdocu.ImpTot2) / Ccbcdocu.ImpTot.
            ASSIGN
                x-Import = ROUND (Ccbcdocu.ImpVta * x-Factor, 2).
        END.
    END.
    /* ********************************** */
    IF codmon = 2 THEN DO:
        FIND Gn-tcmb WHERE Gn-tcmb.fecha = Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tcmb THEN x-tc = Gn-tcmb.Venta.
        x-import = x-import * x-tc.
    END.
    IF Ccbcdocu.Coddoc = "N/C" THEN DO:
        x-import = x-import * (-1).
    END.
    IF ccbcdocu.coddoc = "BOL" AND x-Import < F-UIT / 2 THEN NEXT.
    FIND CoaVenta WHERE CoaVenta.Ruc = x-ruc NO-ERROR.
    IF NOT AVAILABLE CoaVenta THEN DO:
        CREATE CoaVenta.
        ASSIGN
            coaventa.coddoc = ccbcdocu.coddoc
            CoaVenta.Ruc    = x-Ruc
            CoaVenta.NomCli = x-NomCli.
    END.
    CoaVenta.ImpLin = CoaVenta.ImpLin + x-Import.
END.

DEFINE var x-tipo as char NO-UNDO.
DEFINE var x as integer init 0 NO-UNDO.
DEF VAR x-ApePat AS CHAR NO-UNDO.
DEF VAR x-ApeMat AS CHAR NO-UNDO.
DEF VAR x-Nombre-1 AS CHAR NO-UNDO.
DEF VAR x-Nombre-2 AS CHAR NO-UNDO.

DISPLAY "Generando archivo..." @ F-Proceso WITH FRAME {&FRAME-NAME}.
MESSAGE "VA A GENERAR ARCHIVO" FILL-IN-file VIEW-AS ALERT-BOX INFORMA.
OUTPUT STREAM REPORT TO VALUE(FILL-IN-file).
FOR EACH coaventa BREAK BY coaventa.ruc DESCENDING:
    IF coaventa.implin < F-uit * F-nrouit THEN NEXT.
    x = x + 1.
    x-tipo = if substring(coaventa.ruc,1,1) = "1" then "01" else "02".
    coaventa.implin = ROUND(coaventa.implin,0).
    IF x-Tipo = "01" THEN DO:
        x-NomCli = TRIM(CoaVenta.NomCli).
        ASSIGN
            x-ApePat = ENTRY(1, x-NomCli, " ").
        IF INDEX(CoaVenta.NomCli, ",") > 0 
        THEN DO:
            x-Nombre-1 = TRIM( ENTRY(2, x-NomCli) ).
            x-ApeMat = TRIM ( SUBSTRING(x-NomCli, 
                                 INDEX(x-NomCli, " ") + 1, 
                                 INDEX(x-NomCli, ",") - INDEX(x-NomCli, " ") - 1) ).
        END.
        ELSE DO:
            x-ApeMat = ENTRY(2, x-NomCli, " ").
            x-Nombre-1 = TRIM ( SUBSTRING(x-NomCli, INDEX(x-NomCli, x-ApeMat) + LENGTH(x-ApeMat) + 1) ).
        END.
        IF NUM-ENTRIES(x-Nombre-1, " ") > 1 THEN DO:
            x-Nombre-2 = ENTRY(2, x-Nombre-1, " ").
            x-Nombre-1 = ENTRY(1, x-Nombre-1, " ").
        END.
    END.

    IF x-Tipo = '02' 
    THEN PUT STREAM REPORT UNFORMATTED
            x "|"
            "6|"
            "20100038146|"
            s-periodo "|"
            x-tipo "|"
            "6|"
            coaventa.ruc "|"
            coaventa.implin "|"
            "|"
            "|"
            "|"
            "|"
            coaventa.nomcli "|"
            SKIP.
    ELSE PUT STREAM REPORT UNFORMATTED
            x "|"
            "6|"
            "20100038146|"
            s-periodo "|"
            x-tipo "|"
            "6|"
            coaventa.ruc "|"
            coaventa.implin "|"
            x-ApePat "|"
            x-ApeMat "|"
            x-Nombre-1 "|"
            x-Nombre-2 "|"
            "|"
            SKIP.
end.
output STREAM REPORT close.

MESSAGE "ARCHIVO" FILL-IN-file "FUE GENERADO" VIEW-AS ALERT-BOX INFORMA.

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
El Archivo de texto tiene el nombre ingresos.txt".
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

