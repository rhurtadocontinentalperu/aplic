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

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NROMES AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

/* Definimos Variables de impresoras */
DEFINE VARIABLE s-printer-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name AS CHAR format "x(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE C-FLGEST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-15 F-DesFch C-DOC FILL-IN-3 F-HasFch ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DesFch C-DOC FILL-IN-3 F-HasFch 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDialogCues" D-Dialog _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartDialog,uib,49267
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-DOC AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 10.72 BY .88 NO-UNDO.

DEFINE VARIABLE F-DesFch AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81 NO-UNDO.

DEFINE VARIABLE F-HasFch AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.43 BY 4.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-DesFch AT ROW 1.46 COL 7.14 COLON-ALIGNED
     C-DOC AT ROW 2.92 COL 12.43 COLON-ALIGNED
     FILL-IN-3 AT ROW 3.88 COL 12.43 COLON-ALIGNED
     F-HasFch AT ROW 1.46 COL 27.57 COLON-ALIGNED
     Btn_OK AT ROW 1.19 COL 46.43
     Btn_Cancel AT ROW 2.85 COL 46.43
     RECT-15 AT ROW 1 COL 1
     SPACE(15.13) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Documentos Programados".

 

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
   Default                                                              */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Documentos Programados */
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
  ASSIGN F-DesFch F-HasFch C-DOC.
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
  DISPLAY F-DesFch C-DOC FILL-IN-3 F-HasFch 
      WITH FRAME D-Dialog.
  ENABLE RECT-15 F-DesFch C-DOC FILL-IN-3 F-HasFch Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato D-Dialog 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR x-ImpPgo AS DECIMAL EXTENT 2 NO-UNDO. 
 DEFINE VAR x-CodMon AS CHAR NO-UNDO.
  
 DEFINE FRAME f-cab
        cp-drol.CodBco COLUMN-LABEL "Cod.!Bco." FORMAT "X(4)"
        cp-drol.Glosa 
        cp-drol.Coddoc COLUMN-LABEL "Cod.!Doc."
        cp-drol.FchVto 
        x-CodMon       COLUMN-LABEL "Cod.!Mon."
        x-ImpPgo [1]   COLUMN-LABEL "Imp.Soles"    FORMAT "(>>,>>>,>>9.99)"
        x-ImpPgo [2]   COLUMN-LABEL "Imp.Dolares." FORMAT "(>>,>>>,>>9.99)"
        cp-drol.NroRol COLUMN-LABEL "Nro.Rol"
        cp-drol.CodOpe COLUMN-LABEL "Cod.!Ope."
        HEADER
        S-NOMCIA FORMAT "X(40)"
        "DOCUMENTOS PROGRAMADOS" TO 75
        "PAGINA : " TO 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "DESDE : " F-DesFch  " AL " F-HasFch
        "FECHA : " TO 120 TODAY SKIP(2)
         WITH WIDTH 165 NO-BOX STREAM-IO DOWN.
 
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 
 PUT STREAM REPORT CONTROL CHR(27) "@".
 PUT STREAM REPORT CONTROL CHR(27) "C" CHR(66).
 PUT STREAM REPORT CONTROL CHR(27) CHR(120) 0.
 PUT STREAM REPORT CONTROL CHR(15).
 
 FOR EACH cp-drol NO-LOCK WHERE cp-drol.CodCia = s-CodCia AND 
                                ( cp-drol.FchVto >= F-DesFch AND cp-drol.FchVto <= F-hasFch ) AND
                                 cp-drol.FlgPgo = FALSE AND cp-drol.CodDoc BEGINS C-Doc 
                                 BREAK BY cp-drol.NroRol :
     
    IF FIRST-OF (cp-drol.NroRol) THEN DO :
    END.
    
    x-CodMon = IF cp-drol.CodMon = 1 THEN "S/." ELSE "US$".
    
    IF cp-drol.CodMon = 1 THEN DO :
       x-ImpPgo[1] = IF cp-drol.TpoMov THEN cp-drol.ImpPgo ELSE cp-drol.ImpPgo * -1.
       x-ImpPgo[2] = 0.
    END.   
    ELSE DO :
       x-ImpPgo[2] = IF cp-drol.TpoMov THEN cp-drol.ImpPgo ELSE cp-drol.ImpPgo * -1.
       x-ImpPgo[1] = 0.
    END.   
    
    DISPLAY STREAM REPORT cp-drol.CodBco 
                          cp-drol.Glosa 
                          cp-drol.Coddoc                           
                          cp-drol.FchVto 
                          x-CodMon
                          x-ImpPgo[1] WHEN x-ImpPgo[1] <> 0
                          x-ImpPgo[2] WHEN x-ImpPgo[2] <> 0
                          cp-drol.NroRol 
                          cp-drol.CodOpe WITH FRAME f-Cab.
                               
    ACCUMULATE x-ImpPgo[1] (SUB-TOTAL BY cp-drol.NroRol).
    ACCUMULATE x-ImpPgo[2] (SUB-TOTAL BY cp-drol.NroRol).
    
    IF LAST-OF (cp-drol.NroRol) THEN DO :
       
       x-ImpPgo[1] = ACCUM SUB-TOTAL BY cp-drol.NroRol x-ImpPgo[1].
       x-ImpPgo[2] = ACCUM SUB-TOTAL BY cp-drol.NroRol x-ImpPgo[2].
                
       UNDERLINE STREAM REPORT cp-drol.Glosa 
                               x-ImpPgo [1]
                               x-ImpPgo [2] WITH FRAME f-Cab.
                               
       DISPLAY STREAM REPORT "TOTAL >>>  " + STRING (cp-drol.NroRol,"999999") @ cp-drol.Glosa 
                             x-ImpPgo[1] WHEN x-ImpPgo[1] <> 0
                             x-ImpPgo[2] WHEN x-ImpPgo[2] <> 0
                             WITH FRAME f-Cab.
       
       UNDERLINE STREAM REPORT cp-drol.Glosa 
                               x-ImpPgo[1]
                               x-ImpPgo[2] WITH FRAME f-Cab.                        
    END.
                           
 END.
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  
  RUN Formato.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN BIN/_VCAT.P(s-print-file). 
  END CASE. 
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
  
   ASSIGN 
      F-DesFch:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
      F-HasFch:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
  
   DO WITH FRAME {&FRAME-NAME} :
     DEF VAR L-DOCS AS CHAR INIT "Todos".
     FOR EACH CP-TPRO NO-LOCK  WHERE CP-TPRO.CODCIA = CB-CODCIA AND
               CP-TPRO.CORRELATIVO = YES BREAK BY CP-TPRO.CODDOC:
         IF FIRST-OF(CP-TPRO.CODDOC) THEN DO:
             ASSIGN L-DOCS = L-DOCS + "," + CP-TPRO.CODDOC .
         END.
     END.
     IF L-DOCS <> "" THEN DO:
        C-DOC:LIST-ITEMS = L-DOCS.
        C-DOC = ENTRY(1,L-DOCS).
     END.     
  END.
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


