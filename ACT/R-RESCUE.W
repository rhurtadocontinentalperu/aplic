&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

{act/def-imp.i}

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR s-periodo AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR cb-CodCia AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 F-DesCta F-HasCta Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DesCta F-HasCta 

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

DEFINE VARIABLE F-DesCta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-HasCta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64.14 BY 1.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-DesCta AT ROW 1.38 COL 15.43 COLON-ALIGNED
     F-HasCta AT ROW 1.38 COL 40.43 COLON-ALIGNED
     Btn_OK AT ROW 3.12 COL 18.86
     Btn_Cancel AT ROW 3.12 COL 33.14
     RECT-6 AT ROW 1 COL 1
     SPACE(0.00) SKIP(2.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resumen de Cuentas Afectas a Ajuste".

 

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resumen de Cuentas Afectas a Ajuste */
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
  ASSIGN F-DesCta F-HasCta.
  F-DesCta = TRIM(F-DesCta).
  F-HasCta = TRIM(F-HasCta) + CHR(255).
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */


{src/adm/template/dialogmn.i}

IF AVAIL cb-cfga THEN DO:
   ASSIGN f-DesCta:FORMAT    = cb-cfga.DETCFG.
   ASSIGN f-HasCta:FORMAT    = cb-cfga.DETCFG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY F-DesCta F-HasCta 
      WITH FRAME D-Dialog.
  ENABLE RECT-6 F-DesCta F-HasCta Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO D-Dialog 
PROCEDURE FORMATO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-DesFam AS CHAR FORMAT "X(60)".

  DEFINE FRAME F-Cab
    SPACE(10)
    AC-RPAR.CodCta  COLUMN-LABEL "Cuenta!Contable"
    AC-RPAR.CodDiv  COLUMN-LABEL "Divi."
    AC-RPAR.CodPar  COLUMN-LABEL "Partida "          
    AC-RPAR.ValHis  COLUMN-LABEL "Valor!Historico"
    AC-RPAR.Factor  COLUMN-LABEL "Factor!Ajuste"
    AC-RPAR.ValAjt  COLUMN-LABEL "Valor!Ajustado"
    AC-RPAR.Rei     COLUMN-LABEL "R E I"
    AC-RPAR.ValAjtA COLUMN-LABEL "Ajuste Anterior"
    AC-RPAR.ValAjtM COLUMN-LABEL "Ajuste del!Mes"
    HEADER   
    {&Prn4} + {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "X(60)" 
    "Fecha :" TO 100 TODAY AT 101
    "Pagina : " AT 111 PAGE-NUMBER(Report) FORMAT "ZZZZ9" AT 120 SKIP(1)
    {&Prn7a} + "RESUMEN DE CUENTAS AFECTAS A AJUSTE POR INFLACION" + {&Prn7b} 
    FORMAT "X(60)" AT 10 SKIP
    {&Prn7a} + "MES " + STRING(s-NroMes,"99") + {&Prn7b} + {&Prn3} AT 30 SKIP(2)
        
    WITH DOWN NO-BOX STREAM-IO WIDTH 170.
    
    CASE s-salida-impresion :
         WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
         WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE ( s-port-name )  PAGE-SIZE 62.
         WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
    END CASE. 
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3}.
            
    FOR EACH AC-RPAR WHERE ac-rpar.CodCia  = s-CodCia  AND
                           ac-rpar.periodo = s-periodo AND
                           ac-rpar.NroMes  = s-NroMes  AND
                           ac-rpar.CodCta >= F-DesCta  AND
                           ac-rpar.CodCta <= F-HasCta                           
                           BREAK BY SUBSTRING(ac-rpar.CodCta,1,3) :
                            
        IF FIRST-OF (SUBSTRING(ac-rpar.CodCta,1,3)) THEN DO :           
           
        END.
        
        DISPLAY STREAM REPORT 
                AC-RPAR.CodCta  
                AC-RPAR.CodDiv  
                AC-RPAR.CodPar             
                AC-RPAR.ValHis  
                AC-RPAR.Factor  
                AC-RPAR.ValAjt  
                AC-RPAR.Rei     
                AC-RPAR.ValAjtA 
                AC-RPAR.ValAjtM WITH FRAME f-cab.
           
       IF LAST-OF (SUBSTRING(ac-rpar.CodCta,1,3)) THEN DO :
          UNDERLINE STREAM REPORT 
                AC-RPAR.CodCta  
                AC-RPAR.CodDiv  
                AC-RPAR.CodPar             
                AC-RPAR.ValHis  
                AC-RPAR.Factor  
                AC-RPAR.ValAjt  
                AC-RPAR.Rei     
                AC-RPAR.ValAjtA 
                AC-RPAR.ValAjtM WITH FRAME f-cab.
       END.                         
    END.         
    OUTPUT STREAM REPORT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
  
  /* Captura datos de impresion       */
  
  RUN aderb/_prlist.p ( OUTPUT s-printer-list,
                        OUTPUT s-port-list,
                        OUTPUT s-printer-count).
                        
  s-port-name = ENTRY( LOOKUP ( s-printer-name, s-printer-list ) , s-port-list ).
  s-port-name = REPLACE( s-port-name, ":", "").
  
  IF s-salida-impresion = 1 THEN
     s-print-file = SESSION:TEMP-DIRECTORY + 
                    STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
     
  RUN FORMATO.
  
  CASE s-salida-impresion :
       WHEN 1 OR WHEN 3 THEN RUN BIN/_VCAT.P(s-print-file).
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


