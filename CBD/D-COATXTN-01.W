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
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE        VAR I-NroMes1 AS INTEGER NO-UNDO.
DEFINE        VAR I-NroMes2 AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE CoaCompra
   FIELD Ruc AS CHAR
   FIELD NomCli AS CHAR
   FIELD Implin AS DECIMAL
   FIELD Persona LIKE GN-PROV.Persona
   FIELD ApePat LIKE gn-prov.ApePat 
   FIELD ApeMat LIKE gn-prov.ApeMat 
   FIELD Nombre LIKE gn-prov.Nombre
   INDEX llave01 Ruc.

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
&Scoped-Define ENABLED-OBJECTS CB-Mes1 CB-Mes2 F-Nrouit F-UIT EDITOR-1 ~
FILL-IN-file Btn_OK Btn_Cancel RECT-14 RECT-56 RECT-58 
&Scoped-Define DISPLAYED-OBJECTS F-Periodo CB-Mes1 CB-Mes2 F-Nrouit F-UIT ~
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

DEFINE VARIABLE CB-Mes1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE CB-Mes2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 32.86 BY 2.46 NO-UNDO.

DEFINE VARIABLE F-Nrouit AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Nro UIT" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE F-Proceso AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesando" 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-UIT AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Valor U.I.T" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U INITIAL "N:~\costos.txt" 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.86 BY 9.04.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10.43 BY 1.5.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-Periodo AT ROW 2.23 COL 5.57 COLON-ALIGNED NO-LABEL
     CB-Mes1 AT ROW 1.38 COL 21.86 COLON-ALIGNED
     CB-Mes2 AT ROW 2.5 COL 21.72 COLON-ALIGNED
     F-Nrouit AT ROW 3.77 COL 8.43 COLON-ALIGNED
     F-UIT AT ROW 3.77 COL 27.14 COLON-ALIGNED
     EDITOR-1 AT ROW 4.88 COL 8 NO-LABEL
     F-Proceso AT ROW 7.73 COL 10 COLON-ALIGNED
     FILL-IN-file AT ROW 8.54 COL 10 COLON-ALIGNED
     Btn_OK AT ROW 2.73 COL 51
     Btn_Cancel AT ROW 5.04 COL 51
     " Periodo" VIEW-AS TEXT
          SIZE 6.29 BY .5 AT ROW 1.62 COL 6.72
          BGCOLOR 1 FGCOLOR 15 
     RECT-14 AT ROW 1 COL 1
     RECT-56 AT ROW 1.81 COL 5.57
     RECT-58 AT ROW 3.46 COL 2.57
     SPACE(23.85) SKIP(5.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DAOT - Compras".


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

/* SETTINGS FOR FILL-IN F-Periodo IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* DAOT - Compras */
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

    ASSIGN F-UIT F-nrouit CB-Mes1 CB-Mes2 FILL-IN-file.
    I-NroMes1 = LOOKUP(CB-MES1,CB-MES1:LIST-ITEMS).
    I-NroMes2 = LOOKUP(CB-MES2,CB-MES1:LIST-ITEMS).
    F-Proceso:VISIBLE = YES.
    RUN Genera-Texto.

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
  DISPLAY F-Periodo CB-Mes1 CB-Mes2 F-Nrouit F-UIT EDITOR-1 F-Proceso 
          FILL-IN-file 
      WITH FRAME D-Dialog.
  ENABLE CB-Mes1 CB-Mes2 F-Nrouit F-UIT EDITOR-1 FILL-IN-file Btn_OK Btn_Cancel 
         RECT-14 RECT-56 RECT-58 
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
define var s-codope as char init "060,081" NO-UNDO.
define var i as integer NO-UNDO.
define var ii as integer NO-UNDO.
define var x-ruc as char NO-UNDO.
define var x-nomcli as char NO-UNDO.
DEFINE VAR x-Debe AS DECIMAL NO-UNDO.
DEFINE VAR x-Haber AS DECIMAL NO-UNDO.
DEFINE VAR x-Import AS DECIMAL NO-UNDO.
DEFINE VAR x-Persona AS CHAR NO-UNDO.
DEFINE VAR x-ApePat AS CHAR NO-UNDO.
DEFINE VAR x-ApeMat AS CHAR NO-UNDO.
DEFINE VAR x-Nombre AS CHAR NO-UNDO.

EMPTY TEMP-TABLE CoaCompra.

DISPLAY "Procesando información..." @ F-Proceso WITH FRAME {&FRAME-NAME}.
FOR EACH cb-cmov NO-LOCK WHERE
    cb-cmov.CodCia = s-CodCia AND
    cb-cmov.Periodo = s-Periodo AND
    cb-cmov.NroMes >= I-NroMes1 AND
    cb-cmov.NroMes <= I-NroMes2 AND
    LOOKUP(cb-cmov.CodOpe,s-codope) > 0
    BREAK BY cb-cmov.NroAst:
    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.CodCia = cb-cmov.CodCia AND
        cb-dmov.Periodo = cb-cmov.Periodo AND
        cb-dmov.NroMes = cb-cmov.NroMes AND
        cb-dmov.CodOpe = cb-cmov.CodOpe AND
        cb-dmov.NroAst = cb-cmov.NroAst AND
        cb-dmov.coddoc <> "02"
        BREAK BY cb-dmov.CodDiv BY cb-dmov.NroAst:
        IF FIRST-OF (cb-dmov.CodDiv) THEN DO:
            x-NomCli = "".
            x-Ruc = "".
            x-Persona = 'J'.
            x-ApePat = ''.
            x-ApeMat = ''.
            x-Nombre = ''.
            x-Import = 0.
        END.
        IF NOT tpomov THEN DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        ELSE DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        CASE cb-dmov.TM:
            WHEN 3 THEN x-Import = x-Import + (x-Debe - x-Haber).
            WHEN 4 THEN x-Import = x-Import + (x-Debe - x-Haber).
            WHEN 8 THEN DO:
                FIND GN-PROV WHERE
                    GN-PROV.CodCia = pv-codcia AND
                    GN-PROV.codPro = cb-dmov.CodAux
                    NO-LOCK NO-ERROR.
                IF AVAILABLE GN-PROV THEN
                    ASSIGN
                        x-NomCli = GN-PROV.NomPro
                        x-ruc = GN-PROV.Ruc
                        x-Persona = gn-prov.persona
                        x-ApePat = gn-prov.apepat
                        x-ApeMat = gn-prov.apemat
                        x-Nombre = gn-prov.nombre.
                ELSE x-NomCli = cb-dmov.GloDoc.
            END.
        END CASE.
        IF LAST-OF(cb-dmov.CodDiv) AND
            (x-ruc BEGINS '1' OR x-ruc BEGINS '2')
            /*substring(x-ruc,1,1) <> "N" */
            THEN DO:
            FIND CoaCompra WHERE CoaCompra.Ruc = x-ruc NO-ERROR.
            IF NOT AVAILABLE CoaCompra THEN DO:
                CREATE CoaCompra.
                ASSIGN
                    CoaCompra.Ruc = x-Ruc
                    CoaCompra.NomCli = x-NomCli
                    CoaCompra.Persona = x-Persona
                    CoaCompra.ApePat = x-ApePat
                    CoaCompra.ApeMat = x-ApeMat
                    CoaCompra.Nombre = x-Nombre.
            END.
            CoaCompra.ImpLin = CoaCompra.ImpLin + x-Import.
        END.
    END. /* FOR EACH cb-dmov... */

END. /* FOR EACH cb-cmov... */

DISPLAY "Generando Archivo de texto..." @ F-Proceso WITH FRAME {&FRAME-NAME}.

define var x-cadena as char format "x(250)" NO-UNDO.
define var x as integer init 0 NO-UNDO.
MESSAGE "VA A GENERAR ARCHIVO" FILL-IN-file VIEW-AS ALERT-BOX INFORMA.
output to VALUE(FILL-IN-file).
for each coacompra no-lock where
    length(coacompra.ruc) = 11 break by coacompra.ruc descending:
    IF coacompra.implin < F-uit * F-nrouit THEN NEXT.
    x = x + 1.
    IF CoaCompra.Persona = 'J' THEN DO:
        x-cadena =
            TRIM(STRING(x,">>>9")) + "|6|20100038146|" +
            string(s-periodo,"9999") + "|02|6|" +
            string(coacompra.ruc,"X(11)") + "|" +
            TRIM(string(coacompra.implin,"->>>>>>>>>>>>>9")) +
            "|||||" + coacompra.nomcli + "|".
    END.
    ELSE DO:
        x-cadena =
            TRIM(STRING(x,">>>9")) + "|6|20100038146|" + 
            string(s-periodo,"9999") + "|01|6|" + 
            string(coacompra.ruc,"X(11)") + "|" +
            TRIM(string(coacompra.implin,"->>>>>>>>>>>>>9")) + "|" +
            TRIM(CoaCompra.ApePat) + "|" + TRIM(CoaCompra.ApeMat) + "|" +
            TRIM(CoaCompra.Nombre) + "|||".
    END.
    PUT UNFORMATTED x-cadena SKIP.
    pause 0.
END.
output close.
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
para la transferencia de información al PDT SUNAT                          
El Archivo de texto tiene el nombre costos.txt".
     CB-Mes1:SCREEN-VALUE = ENTRY(S-NroMes,CB-Mes1:LIST-ITEMS).
     CB-Mes2:SCREEN-VALUE = ENTRY(S-NroMes,CB-Mes2:LIST-ITEMS).
     F-Proceso:VISIBLE = NO.
     DISPLAY s-periodo @ F-Periodo.
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

