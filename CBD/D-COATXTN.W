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
DEFINE        VAR X-TASK-NO AS INTEGER NO-UNDO.
DEFINE        VAR I-NroOpe  AS INTEGER NO-UNDO.
DEFINE        VAR L-Salir   AS LOGICAL INITIAL NO NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE TEMP-TABLE CoaCompra
   FIELD Ruc    AS CHAR
   FIELD Ruc11  As CHAR 
   FIELD NomCli AS CHAR
   FIELD Implin AS DECIMAL EXTENT 10
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
&Scoped-Define ENABLED-OBJECTS F-Nrouit F-UIT CB-Mes2 EDITOR-1 CB-Mes1 ~
Btn_OK Btn_Cancel RECT-14 RECT-56 RECT-58 
&Scoped-Define DISPLAYED-OBJECTS F-Nrouit F-UIT F-Periodo CB-Mes2 EDITOR-1 ~
CB-Mes1 F-Proceso 

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

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.86 BY 7.96.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10.43 BY 1.5.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-Nrouit AT ROW 3.77 COL 8.43 COLON-ALIGNED
     F-UIT AT ROW 3.77 COL 27.14 COLON-ALIGNED
     F-Periodo AT ROW 2.23 COL 5.57 COLON-ALIGNED NO-LABEL
     CB-Mes2 AT ROW 2.5 COL 21.72 COLON-ALIGNED
     EDITOR-1 AT ROW 4.88 COL 8 NO-LABEL
     CB-Mes1 AT ROW 1.38 COL 21.86 COLON-ALIGNED
     F-Proceso AT ROW 7.69 COL 10.29 COLON-ALIGNED
     Btn_OK AT ROW 2.81 COL 51
     Btn_Cancel AT ROW 5.04 COL 50.86
     "PERIODO" VIEW-AS TEXT
          SIZE 7.57 BY .5 AT ROW 1.62 COL 6.72
          BGCOLOR 1 FGCOLOR 15 
     RECT-14 AT ROW 1 COL 1
     RECT-56 AT ROW 1.81 COL 5.57
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

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
     F-UIT F-nrouit CB-Mes1 CB-Mes2.
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
  DISPLAY F-Nrouit F-UIT F-Periodo CB-Mes2 EDITOR-1 CB-Mes1 F-Proceso 
      WITH FRAME D-Dialog.
  ENABLE F-Nrouit F-UIT CB-Mes2 EDITOR-1 CB-Mes1 Btn_OK Btn_Cancel RECT-14 
         RECT-56 RECT-58 
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
/*  Integral = Contabilidad 2000(Integral192 Servidor INF213)
    Auxiliar = BD Actual(Integral192 Servidor INF210)
*/    

define var c-codmon as integer init 1.
define var s-codope as char init "060,081".
define var x-codope as char.
define var x-div as char init "".
define var i as integer.
define var ii as integer.
define var x-ruc as char.
define var x-ruc11 as char.
define var x-nomcli as char.
DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
DEFINE VAR x-Import AS DECIMAL EXTENT 10.
DEFINE VAR x-nromes AS INTEGER .
DEFINE VAR x-Persona AS CHAR.
DEFINE VAR x-ApePat AS CHAR.
DEFINE VAR x-ApeMat AS CHAR.
DEFINE VAR x-Nombre AS CHAR.

DO WITH FRAME {&FRAME-NAME}:

DO ii = I-NroMes1 to I-NroMes2:  
  x-nromes = ii.
  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH Integral.cb-cmov NO-LOCK WHERE Integral.cb-cmov.CodCia  = s-CodCia  AND
                                     Integral.cb-cmov.Periodo = s-Periodo AND
                                     Integral.cb-cmov.NroMes  = x-NroMes  AND
                                     Integral.cb-cmov.CodOpe  = x-CodOpe
                                     BREAK BY Integral.cb-cmov.NroAst :                                     
          FOR EACH Integral.cb-dmov NO-LOCK WHERE Integral.cb-dmov.CodCia  = Integral.cb-cmov.CodCia  AND
                                         Integral.cb-dmov.Periodo = Integral.cb-cmov.Periodo AND
                                         Integral.cb-dmov.NroMes  = Integral.cb-cmov.NroMes  AND
                                         Integral.cb-dmov.CodOpe  = Integral.cb-cmov.CodOpe  AND
                                         Integral.cb-dmov.NroAst  = Integral.cb-cmov.NroAst  AND
                                         Integral.cb-dmov.CodDiv  BEGINS x-Div 
                                         BREAK BY Integral.cb-dmov.CodDiv 
                                               by Integral.cb-dmov.NroAst :
/*
              DISPLAY STRING(cb-dmov.Periodo,"9999") + 
                      STRING(cb-dmov.nromes,"99") + "-" +
                      STRING(cb-dmov.codope,"999") + 
                      cb-dmov.nroast + "-"
                      cb-dmov.coddiv 
                      @ F-Proceso WITH FRAME {&FRAME-NAME}.
*/                     
                      
              IF FIRST-OF (Integral.cb-dmov.CodDiv) THEN DO :
                 x-NomCli = "".
                 x-Ruc    = "".
                 x-Persona = 'J'.
                 x-ApePat = ''.
                 x-ApeMat = ''.
                 x-Nombre = ''.
                 x-Import[1] = 0.
              END.
              IF NOT tpomov THEN DO:
                 CASE c-codmon:
                 WHEN 1 THEN DO:
                      x-debe  = ImpMn1.
                      x-haber = 0.
                 END.
                 WHEN 2 THEN DO:
                      x-debe  = ImpMn2.
                      x-haber = 0.
                 END.
                 END CASE.
              END.
              ELSE DO:      
                  CASE c-codmon:
                  WHEN 1 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn1.
                  END.
                  WHEN 2 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn2.
                  END.
                  END CASE.            
              END.
              
              CASE cb-dmov.TM :
                   WHEN 3 THEN x-Import[1] = x-Import[1] + (x-Debe - x-Haber).
                   WHEN 4 THEN x-Import[1] = x-Import[1] + (x-Debe - x-Haber).
                   WHEN 8 THEN DO :                          
                          FIND Integral.GN-PROV WHERE Integral.GN-PROV.CodCia = pv-codcia AND
                                                      Integral.GN-PROV.codPro = Integral.cb-dmov.CodAux NO-LOCK NO-ERROR.
                          IF AVAILABLE Integral.GN-PROV 
                          THEN ASSIGN
                             x-NomCli = Integral.GN-PROV.NomPro
                             x-ruc    = Integral.GN-PROV.Ruc
                             x-Persona = gn-prov.persona
                             x-ApePat = gn-prov.apepat
                             x-ApeMat = gn-prov.apemat
                             x-Nombre = gn-prov.nombre.
                          ELSE x-NomCli = Integral.cb-dmov.GloDoc.                   
                   END.
                                      
              END CASE.
     

              IF LAST-OF (Integral.cb-dmov.CodDiv) THEN DO :
   
                 IF substring(x-ruc,1,1) = "N" THEN NEXT.

                 FIND CoaCompra WHERE CoaCompra.Ruc = x-ruc  NO-ERROR .
                 IF NOT AVAILABLE CoaCompra THEN DO:
                    CREATE CoaCompra.
                    ASSIGN
                        CoaCompra.Ruc    = x-Ruc
                        CoaCompra.Ruc11  = x-Ruc11
                        CoaCompra.NomCli = x-NomCli
                        CoaCompra.Persona = x-Persona
                        CoaCompra.ApePat = x-ApePat
                        CoaCompra.ApeMat = x-ApeMat
                        CoaCompra.Nombre = x-Nombre.
                 END.
                 CoaCompra.ImpLin[1] = CoaCompra.ImpLin[1] + x-Import[1].
              END.
              
          END. 
                                     
      END. 
      
   END. 
   
END.

message "Generando Archivo de texto ".

define var x-cadena as char format "x(250)".
define var x-tipo as char .
define var x as integer init 0.
output to "c:\temp\costos.txt".
for each coacompra where length(coacompra.ruc) = 11 
         break by coacompra.ruc descending:

  IF coacompra.implin[1] < F-uit * F-nrouit THEN NEXT.

  x = x + 1.
  
/*  x-tipo = if substring(coacompra.ruc,1,1) = "1" then "01" else "02".
 *   x-cadena = STRING(x,">>>9") + "|6|20100038146|" + 
 *             string(s-periodo,"9999") + "|" + x-tipo + "|6|" + 
 *             string(coacompra.ruc,"X(11)") + "|" + string(coacompra.implin[1],"->>>>>>>>>>>>>9") + 
 *             "|||||" + coacompra.nomcli + "|". */

    IF CoaCompra.Persona = 'J' THEN DO:
        x-tipo = "02".
        x-cadena = STRING(x,">>>9") + "|6|20100038146|" + 
            string(s-periodo,"9999") + "|" + x-tipo + "|6|" + 
            string(coacompra.ruc,"X(11)") + "|" + string(coacompra.implin[1],"->>>>>>>>>>>>>9") + 
            "|||||" + coacompra.nomcli + "|". 

    END.
    ELSE DO:
        x-tipo = "01".
        x-cadena = STRING(x,">>>9") + "|6|20100038146|" + 
            string(s-periodo,"9999") + "|" + x-tipo + "|6|" + 
            string(coacompra.ruc,"X(11)") + "|" + string(coacompra.implin[1],"->>>>>>>>>>>>>9") + "|" +
            TRIM(CoaCompra.ApePat) + "|" + TRIM(CoaCompra.ApeMat) + "|" + TRIM(CoaCompra.Nombre) + "|||".
    END.

  display    x-cadena with width 300 no-labels.
  pause 0.
end.
    
END.

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
para la transferencia de información al PDT SUNAT                          
El Archivo de texto tiene el nombre C:\Temp\costos.txt".
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

