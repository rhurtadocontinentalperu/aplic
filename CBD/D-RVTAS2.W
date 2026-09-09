&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w

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

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR Cb-CodCia AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHARACTER.
DEFINE SHARED VAR s-Periodo  AS INTEGER.

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

DEFINE VAR C-BIMP AS CHAR.
DEFINE VAR C-ISC  AS CHAR.
DEFINE VAR C-IGV  AS CHAR.
DEFINE VAR C-TOT  AS CHAR.

/* BUSCANDO LAS CONFIGURACIONES DEL LIBRO DE VENTAS */

FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
     NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
   MESSAGE "No esta configurado el registro de Ventas" VIEW-AS 
   ALERT-BOX ERROR.
   RETURN.
END.

/* Configuraciones */
C-BIMP = cb-cfgg.CODCTA[1].
C-ISC  = cb-cfgg.CODCTA[2].
C-IGV  = cb-cfgg.CODCTA[3].
C-TOT  = cb-cfgg.CODCTA[4].

/* Definicion del Frame de Imprsión y sus Variables  */

DEFINE VAR x-CodDiv AS CHAR.
DEFINE VAR x-NroAst AS CHAR.
DEFINE VAR x-FchDoc AS DATE.
DEFINE VAR x-CodDoc AS CHAR.
DEFINE VAR x-NroDoc AS CHAR.
DEFINE VAR x-Ruc    AS CHAR.
DEFINE VAR x-NomCli AS CHAR.
DEFINE VAR x-Import AS DECIMAL EXTENT 6.
DEFINE VAR x-CodRef AS CHAR.
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-CodMon AS CHAR.
DEFINE VAR x-CodOpe AS CHAR.

/* OTRAS VARIABLES */

DEFINE VAR x-DesMes AS CHAR.

DEFINE WORK-TABLE Registro
   FIELD CodDiv AS CHAR
   FIELD NroAst AS CHAR
   FIELD FchDoc AS DATE
   FIELD CodDoc AS CHAR
   FIELD NroDoc AS CHAR
   FIELD Ruc    AS CHAR
   FIELD NomCli AS CHAR
   FIELD CodMon AS CHAR
   FIELD Implin AS DECIMAL EXTENT 6.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 C-CodMon RECT-12 Btn_OK x-Div ~
s-CodOpe Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-CodMon x-Div s-CodOpe 

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
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 10 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.72 BY 2.85.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 13 BY 2.27.

DEFINE VARIABLE s-CodOpe AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 10 BY 1.92
     BGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-CodMon AT ROW 2.23 COL 2.43 NO-LABEL
     Btn_OK AT ROW 5 COL 19.57
     x-Div AT ROW 1.77 COL 24.43 COLON-ALIGNED
     s-CodOpe AT ROW 1.69 COL 38.43 NO-LABEL
     Btn_Cancel AT ROW 5 COL 36.29
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .65 AT ROW 1.12 COL 2.14
     RECT-20 AT ROW 1.88 COL 1.72
     RECT-12 AT ROW 1.35 COL 15.72
     SPACE(0.55) SKIP(2.79)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas".

 

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas */
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
  ASSIGN C-CodMon s-CodOpe x-Div.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

 
  
  FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
       NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN DO:
     s-CodOpe:LIST-ITEMS IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
     s-CodOpe:SCREEN-VALUE = ENTRY( 1 , cb-cfgg.codope ).
  END.  
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CAPTURA D-Dialog 
PROCEDURE CAPTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia  AND
                                     cb-cmov.Periodo = s-Periodo AND
                                     cb-cmov.NroMes  = s-NroMes  AND
                                     cb-cmov.CodOpe  = x-CodOpe
                                     BREAK BY cb-cmov.NroAst :
                                     
          x-NroAst = cb-cmov.NroAst.
          
          FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                                         cb-dmov.Periodo = cb-cmov.Periodo AND
                                         cb-dmov.NroMes  = cb-cmov.NroMes  AND
                                         cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                                         cb-dmov.NroAst  = cb-cmov.NroAst  AND
                                         cb-dmov.CodDiv  BEGINS x-Div 
                                         BREAK BY cb-dmov.CodDiv :
              IF FIRST-OF (cb-dmov.CodDiv) THEN DO :
                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-CodDiv = cb-dmov.CodDiv.
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
              
              IF cb-dmov.CodCta BEGINS C-BIMP OR 
                 LOOKUP(cb-dmov.CodCta,C-BIMP) > 0 THEN DO :
                 IF cb-dmov.TM = 1 THEN DO:
                    x-Import[1] = x-Import[1] + (x-Haber - x-Debe).
                    x-Import[4] = x-Import[4] + (x-Haber - x-Debe).
                    END.
                 ELSE x-Import[2] = x-Import[2] + (x-Haber - x-Debe).
              END.
              
              IF cb-dmov.CodCta BEGINS C-ISC OR 
                 LOOKUP(cb-dmov.CodCta,C-ISC) > 0 THEN DO :
                 x-Import[3] = x-Import[3] + (x-Haber - x-Debe).
              END.  
                   
              IF cb-dmov.CodCta BEGINS C-IGV OR 
                 LOOKUP(cb-dmov.CodCta,C-IGV) > 0 THEN DO :
                 x-Import[5] = x-Import[5] + (x-Haber - x-Debe).
              END.  
              
              IF cb-dmov.CodCta BEGINS C-TOT OR 
                 LOOKUP(cb-dmov.CodCta,C-TOT) > 0 THEN DO :
                 x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
                 x-FchDoc = cb-dmov.FchDoc.
                 x-CodDoc = cb-dmov.CodDoc.
                 x-NroDoc = cb-dmov.NroDoc.
                 x-CodMon = "S/.".
                 x-NomCli = cb-dmov.GloDoc.
              END.
              
              IF LAST-OF (cb-dmov.CodDiv) THEN DO :
                 CREATE Registro.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.FchDoc = x-FchDoc.
                 Registro.CodDoc = x-CodDoc.
                 Registro.NroDoc = x-NroDoc.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
              END.
              
          END. /* FIN DEL FOR cb-dmov */        
                                     
      END. /* FIN DEL FOR cb-cmov */
      
   END. /* FIN DEL DO */
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
  DISPLAY C-CodMon x-Div s-CodOpe 
      WITH FRAME D-Dialog.
  ENABLE RECT-20 C-CodMon RECT-12 Btn_OK x-Div s-CodOpe Btn_Cancel 
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
 DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
 
 RUN CAPTURA.
 
 RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     
 
 Titulo1 = "R E G I S T R O  D E  V E N T A S".
 Titulo2 = "DEL MES DE " + x-DesMes.
 Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
 
 
 RUN BIN/_centrar.p ( INPUT Titulo1, 230, OUTPUT Titulo1).
 RUN BIN/_centrar.p ( INPUT Titulo2, 230, OUTPUT Titulo2).
 RUN BIN/_centrar.p ( INPUT Titulo3, 230, OUTPUT Titulo3).
 
 DEFINE FRAME f-cab
       Registro.CodDiv    COLUMN-LABEL "División"
       Registro.NroAst    COLUMN-LABEL "Nro.Ast"
       Registro.FchDoc    COLUMN-LABEL "Fecha de!Emisión"
       Registro.CodDoc    COLUMN-LABEL "Cod.!Doc."
       Registro.NroDoc    COLUMN-LABEL "Nro.!Documento"
       Registro.Ruc       COLUMN-LABEL "Nro.!R.U.C."
       Registro.NomCli    COLUMN-LABEL "C l i e n t e" FORMAT "X(40)"
       Registro.CodMon    COLUMN-LABEL "Moneda"
       Registro.ImpLin[1] COLUMN-LABEL "Valor!Venta" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[3] COLUMN-LABEL "I.S.C" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[4] COLUMN-LABEL "Base!Imponible" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[5] COLUMN-LABEL "I.G.V." FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[2] COLUMN-LABEL "Importe!Exonerado" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[6] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       HEADER
       S-NOMCIA FORMAT "X(60)" 
       "FECHA  : " TO 163 TODAY 
       "PAGINA : " TO 193 PAGE-NUMBER(REPORT) FORMAT "ZZ9"        
       Titulo1 
       Titulo2 SKIP 
       Titulo3 SKIP(2)              
       WITH WIDTH 230 NO-BOX STREAM-IO DOWN.
    
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 
 PUT STREAM REPORT CONTROL CHR(27) "@".
 PUT STREAM REPORT CONTROL CHR(27) "C" CHR(66).
 PUT STREAM REPORT CONTROL CHR(27) CHR(120) 0.
 PUT STREAM REPORT CONTROL CHR(15).
 
 FOR EACH Registro BREAK BY Registro.CodDiv :
     IF FIRST-OF (Registro.CodDiv) THEN DO :
     END.
     DISPLAY STREAM REPORT  
             Registro.CodDiv
             Registro.NroAst    
             Registro.FchDoc    
             Registro.CodDoc    
             Registro.NroDoc    
             Registro.Ruc       
             Registro.NomCli    
             Registro.CodMon    
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDiv ).
     
     IF LAST-OF (Registro.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL POR DIVISION " + x-CodDiv @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
 END.
 
 PAGE STREAM REPORT.
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


