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

{act/def-Imp.i}

DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR cb-CodCia AS INTEGER.
DEFINE SHARED VAR s-NomCia AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 F-DesPar F-hasPar F-CodMov Btn_OK ~
RECT-5 R-Orden Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DesPar F-hasPar F-CodMov R-Orden 

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

DEFINE VARIABLE F-CodMov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origen" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesPar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde Partida" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-hasPar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta Partida" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE R-Orden AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Partidas", 1,
"Familias", 2,
"Origen  ", 3,
"Cuenta  ", 4
     SIZE 11.14 BY 2.88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 6.92.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15 BY 3.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-DesPar AT ROW 1.38 COL 11.14 COLON-ALIGNED
     F-hasPar AT ROW 1.38 COL 32.57 COLON-ALIGNED
     F-CodMov AT ROW 2.35 COL 11.14 COLON-ALIGNED
     Btn_OK AT ROW 3.31 COL 29
     R-Orden AT ROW 4.27 COL 6 NO-LABEL
     Btn_Cancel AT ROW 5.04 COL 29
     RECT-4 AT ROW 1 COL 1
     "Ordenado por :" VIEW-AS TEXT
          SIZE 11 BY .81 AT ROW 3.5 COL 6
     RECT-5 AT ROW 3.69 COL 5
     SPACE(26.99) SKIP(0.65)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Activos Fijos".

 

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
   L-To-R                                                               */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Activos Fijos */
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
  ASSIGN F-CodMov F-DesPar F-hasPar R-Orden.
  F-DesPar = TRIM ( F-DesPar ).
  F-HasPar = TRIM ( F-HasPar ) + CHR(255).  
  RUN IMPRIMIR.
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
  DISPLAY F-DesPar F-hasPar F-CodMov R-Orden 
      WITH FRAME D-Dialog.
  ENABLE RECT-4 F-DesPar F-hasPar F-CodMov Btn_OK RECT-5 R-Orden Btn_Cancel 
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
CASE R-Orden :
     WHEN 1 THEN RUN IMPRE-01.
     WHEN 2 THEN RUN IMPRE-02.
     WHEN 3 THEN RUN IMPRE-03.
     WHEN 4 THEN RUN IMPRE-04.
END CASE.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRE-01 D-Dialog 
PROCEDURE IMPRE-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-Cab
    AC-PARTI.CodFam  COLUMN-LABEL "Cod.Fam."
    AC-PARTI.CodPar  COLUMN-LABEL "Partida "
    AC-PARTI.DesPar  COLUMN-LABEL "Descripci¢n "
    AC-PARTI.CodCta  COLUMN-LABEL "Cuenta!Contable"
    AC-PARTI.FchComp COLUMN-LABEL "Fecha de!Compra"
    AC-PARTI.FchCese COLUMN-LABEL "Fecha de!Cese"
    AC-PARTI.FchDepr COLUMN-LABEL "Fecha de!Depreci."
    AC-PARTI.FchIngr COLUMN-LABEL "Fecha de!Ingreso"
    AC-PARTI.Ccosto  COLUMN-LABEL "C.Costo"
    AC-PARTI.CodDiv  COLUMN-LABEL "Divi."
    AC-PARTI.CodMov  COLUMN-LABEL "Origen "
    AC-PARTI.ValCmpMn1 COLUMN-LABEL "Valor de Compra "
    HEADER   
    {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "X(60)" 
    "Fecha :" TO 120 TODAY AT 121 
    "Pagina : " AT 131 PAGE-NUMBER(Report) FORMAT "ZZZZ9" AT 140 SKIP(1)
    {&Prn7a} + "CATALOGO DE ACTIVOS" + {&Prn7b} FORMAT "X(60)" AT 74 SKIP
    "ORDENADO POR PARTIDAS" AT 80 SKIP(2)    
    WITH DOWN NO-BOX STREAM-IO WIDTH 170.
    CASE s-salida-impresion :
         WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
         WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE ( s-port-name )  PAGE-SIZE 62.
         WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
    END CASE. 
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4}.
            
    FOR EACH AC-PARTI WHERE ac-parti.CodPar >= F-Despar AND
                            ac-parti.CodPar <= F-HasPar AND
                            ac-parti.CodMov BEGINS F-CodMov 
                            BREAK BY ac-parti.CodPar :
                            
        DISPLAY STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.
                            
    END.         
    OUTPUT STREAM REPORT CLOSE.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRE-02 D-Dialog 
PROCEDURE IMPRE-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-DesFam AS CHAR FORMAT "X(60)".

  DEFINE FRAME F-Cab
    AC-PARTI.CodFam  COLUMN-LABEL "Cod.Fam."
    AC-PARTI.CodPar  COLUMN-LABEL "Partida "
    AC-PARTI.DesPar  COLUMN-LABEL "Descripci¢n "
    AC-PARTI.CodCta  COLUMN-LABEL "Cuenta!Contable"
    AC-PARTI.FchComp COLUMN-LABEL "Fecha de!Compra"
    AC-PARTI.FchCese COLUMN-LABEL "Fecha de!Cese"
    AC-PARTI.FchDepr COLUMN-LABEL "Fecha de!Depreci."
    AC-PARTI.FchIngr COLUMN-LABEL "Fecha de!Ingreso"
    AC-PARTI.Ccosto  COLUMN-LABEL "C.Costo"
    AC-PARTI.CodDiv  COLUMN-LABEL "Divi."
    AC-PARTI.CodMov  COLUMN-LABEL "Origen "
    AC-PARTI.ValCmpMn1 COLUMN-LABEL "Valor de Compra "
    HEADER   
    {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "X(60)" 
    "Fecha :" TO 120 TODAY AT 121 
    "Pagina : " AT 131 PAGE-NUMBER(Report) FORMAT "ZZZZ9" AT 140 SKIP(1)
    {&Prn7a} + "CATALOGO DE ACTIVOS" + {&Prn7b} FORMAT "X(60)" AT 74 SKIP
    "ORDENADO POR FAMILIAS" AT 80 SKIP(2)    
    WITH DOWN NO-BOX STREAM-IO WIDTH 170.
    
    CASE s-salida-impresion :
         WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
         WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE ( s-port-name )  PAGE-SIZE 62.
         WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
    END CASE. 
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4}.
            
    FOR EACH AC-PARTI WHERE ac-parti.CodPar >= F-Despar AND
                            ac-parti.CodPar <= F-HasPar AND
                            ac-parti.CodMov BEGINS F-CodMov 
                            BREAK BY ac-parti.CodFam :
                            
        IF FIRST-OF (ac-parti.CodFam) THEN DO :           
           FIND AC-FAMI WHERE ac-fami.CodFam = ac-parti.CodFam NO-LOCK NO-ERROR.                
           IF AVAILABLE AC-FAMI THEN DO :               
              x-DesFam = ac-fami.DesFam.
              DISPLAY STREAM REPORT {&Prn7a} + AC-PARTI.CodFam + "-" + x-DesFam + {&Prn7a} @ AC-PARTI.DesPar
                                    WITH FRAME f-cab.
              UNDERLINE STREAM REPORT AC-PARTI.DesPar WITH FRAME f-cab.
           END.
        END.
        
        DISPLAY STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.
       
       IF LAST-OF (ac-parti.CodFam) THEN DO :
          UNDERLINE STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.       
       END.                         
    END.         
    OUTPUT STREAM REPORT CLOSE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRE-03 D-Dialog 
PROCEDURE IMPRE-03 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-DesMov AS CHAR FORMAT "X(60)".

  DEFINE FRAME F-Cab
    AC-PARTI.CodFam  COLUMN-LABEL "Cod.Fam."
    AC-PARTI.CodPar  COLUMN-LABEL "Partida "
    AC-PARTI.DesPar  COLUMN-LABEL "Descripci¢n "
    AC-PARTI.CodCta  COLUMN-LABEL "Cuenta!Contable"
    AC-PARTI.FchComp COLUMN-LABEL "Fecha de!Compra"
    AC-PARTI.FchCese COLUMN-LABEL "Fecha de!Cese"
    AC-PARTI.FchDepr COLUMN-LABEL "Fecha de!Depreci."
    AC-PARTI.FchIngr COLUMN-LABEL "Fecha de!Ingreso"
    AC-PARTI.Ccosto  COLUMN-LABEL "C.Costo"
    AC-PARTI.CodDiv  COLUMN-LABEL "Divi."
    AC-PARTI.CodMov  COLUMN-LABEL "Origen "
    AC-PARTI.ValCmpMn1 COLUMN-LABEL "Valor de Compra "
    HEADER   
    {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "X(60)" 
    "Fecha :" TO 120 TODAY AT 121 
    "Pagina : " AT 131 PAGE-NUMBER(Report) FORMAT "ZZZZ9" AT 140 SKIP(1)
    {&Prn7a} + "CATALOGO DE ACTIVOS" + {&Prn7b} FORMAT "X(60)" AT 74 SKIP
    "ORDENADO POR FAMILIAS" AT 80 SKIP(2)    
    WITH DOWN NO-BOX STREAM-IO WIDTH 170.
    
    CASE s-salida-impresion :
         WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
         WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE ( s-port-name )  PAGE-SIZE 62.
         WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
    END CASE. 
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4}.
            
    FOR EACH AC-PARTI WHERE ac-parti.CodPar >= F-Despar AND
                            ac-parti.CodPar <= F-HasPar AND
                            ac-parti.CodMov BEGINS F-CodMov 
                            BREAK BY ac-parti.CodFam :
                            
        IF FIRST-OF (ac-parti.CodFam) THEN DO :           
           FIND AC-TMOV WHERE ac-tmov.CodMov = ac-parti.CodMov NO-LOCK NO-ERROR.                
           IF AVAILABLE AC-TMOV THEN DO :               
              x-DesMov = ac-tmov.DesMov.
              DISPLAY STREAM REPORT {&Prn7a} + TRIM(AC-PARTI.CodMov) + "-" + x-DesMov + {&Prn7a} @ AC-PARTI.DesPar
                                    WITH FRAME f-cab.
              UNDERLINE STREAM REPORT AC-PARTI.DesPar WITH FRAME f-cab.
           END.
        END.
        
        DISPLAY STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.
       
       IF LAST-OF (ac-parti.CodFam) THEN DO :
          UNDERLINE STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.       
       END.                         
    END.         
    OUTPUT STREAM REPORT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRE-04 D-Dialog 
PROCEDURE IMPRE-04 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-DesCta AS CHAR FORMAT "X(60)".

  DEFINE FRAME F-Cab
    AC-PARTI.CodFam  COLUMN-LABEL "Cod.Fam."
    AC-PARTI.CodPar  COLUMN-LABEL "Partida "
    AC-PARTI.DesPar  COLUMN-LABEL "Descripci¢n "
    AC-PARTI.CodCta  COLUMN-LABEL "Cuenta!Contable"
    AC-PARTI.FchComp COLUMN-LABEL "Fecha de!Compra"
    AC-PARTI.FchCese COLUMN-LABEL "Fecha de!Cese"
    AC-PARTI.FchDepr COLUMN-LABEL "Fecha de!Depreci."
    AC-PARTI.FchIngr COLUMN-LABEL "Fecha de!Ingreso"
    AC-PARTI.Ccosto  COLUMN-LABEL "C.Costo"
    AC-PARTI.CodDiv  COLUMN-LABEL "Divi."
    AC-PARTI.CodMov  COLUMN-LABEL "Origen "
    AC-PARTI.ValCmpMn1 COLUMN-LABEL "Valor de Compra "
    HEADER   
    {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "X(60)" 
    "Fecha :" TO 120 TODAY AT 121 
    "Pagina : " AT 131 PAGE-NUMBER(Report) FORMAT "ZZZZ9" AT 140 SKIP(1)
    {&Prn7a} + "CATALOGO DE ACTIVOS" + {&Prn7b} FORMAT "X(60)" AT 74 SKIP
    "ORDENADO POR CUENTA CONTABLE" AT 80 SKIP(2)    
    WITH DOWN NO-BOX STREAM-IO WIDTH 170.
    
    CASE s-salida-impresion :
         WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
         WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE ( s-port-name )  PAGE-SIZE 62.
         WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE ( s-print-file ) PAGE-SIZE 62.
    END CASE. 
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4}.
            
    FOR EACH AC-PARTI WHERE ac-parti.CodPar >= F-Despar AND
                            ac-parti.CodPar <= F-HasPar AND
                            ac-parti.CodMov BEGINS F-CodMov 
                            BREAK BY ac-parti.CodCta :
                            
        IF FIRST-OF (ac-parti.CodCta) THEN DO :           
           FIND CB-CTAS WHERE cb-ctas.codcia = cb-codcia AND 
                              cb-ctas.CodCta = ac-parti.CodCta NO-LOCK NO-ERROR.                
           IF AVAILABLE CB-CTAS THEN DO :               
              x-DesCta = cb-ctas.NomCta.
              DISPLAY STREAM REPORT {&Prn7a} + TRIM(AC-PARTI.CodCta) + "-" + x-DesCta + {&Prn7a} @ AC-PARTI.DesPar
                                    WITH FRAME f-cab.
              UNDERLINE STREAM REPORT AC-PARTI.DesPar WITH FRAME f-cab.
           END.
        END.
        
        DISPLAY STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.
       
       IF LAST-OF (ac-parti.CodCta) THEN DO :
          UNDERLINE STREAM REPORT AC-PARTI.CodFam 
                              AC-PARTI.CodPar 
                              AC-PARTI.DesPar 
                              AC-PARTI.CodCta  
                              AC-PARTI.FchComp 
                              AC-PARTI.FchCese 
                              AC-PARTI.FchDepr 
                              AC-PARTI.FchIngr 
                              AC-PARTI.Ccosto 
                              AC-PARTI.CodDiv 
                              AC-PARTI.CodMov 
                              AC-PARTI.ValCmpMn1 WITH FRAME f-cab.       
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


