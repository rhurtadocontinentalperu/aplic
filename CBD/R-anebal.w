&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR cb-CodCia AS INTEGER.
DEFINE SHARED VAR s-periodo AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR s-nromes  AS INTEGER.
DEFINE SHARED VAR CB-MAXNIVEL AS INTEGER.

DEFINE VAR x-Mensaje   AS CHAR FORMAT "X(50)".
DEFINE VAR s-CodBal    AS CHAR.
DEFINE VAR s-NomBal    AS CHAR.
DEFINE VAR i-Formato   AS INTEGER INITIAL 1.
DEFINE VAR b-acumulado AS LOGICAL.
DEFINE VAR s-Activo    AS LOGICAL.

DEFINE VAR impca1 AS DECIMAL.
DEFINE VAR impca2 AS DECIMAL.
DEFINE VAR impca3 AS DECIMAL.
DEFINE VAR impca4 AS DECIMAL.
DEFINE VAR impca5 AS DECIMAL.
DEFINE VAR impca6 AS DECIMAL.

DEFINE VAR ConActivo AS INTEGER.
DEFINE VAR ConPasivo AS INTEGER.

DEFINE STREAM REPORT.

DEFINE TEMP-TABLE T-BAL
       FIELD Item        AS INTEGER
       FIELD orden       AS INTEGER
       FIELD Glosa       LIKE cb-nbal.Glosa  
       FIELD Descripcion LIKE cb-nbal.DesGlo 
       FIELD Nota        LIKE cb-nbal.Nota   
       FIELD s-Cuenta    LIKE cb-ctas.CodCta 
       FIELD a-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" 
       FIELD p-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" 
       FIELD s-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".

DEFINE BUFFER B-ACMD FOR cb-acmd.

DEFINE FRAME f-mensaje x-Mensaje WITH NO-LABEL VIEW-AS DIALOG-BOX
       CENTERED TITLE "Calculando ... Espere un momento ...".

DEFINE VAR x-AcumQ1  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ2  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ3  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ4  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-TotGen  AS DECIMAL EXTENT 10 INITIAL 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME b-cb-cfgd

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-tbal

/* Definitions for BROWSE b-cb-cfgd                                     */
&Scoped-define FIELDS-IN-QUERY-b-cb-cfgd cb-tbal.CodBal cb-tbal.DesBal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cb-cfgd 
&Scoped-define QUERY-STRING-b-cb-cfgd FOR EACH cb-tbal ~
      WHERE cb-tbal.CodCia = cb-CodCia AND  ~
integral.cb-tbal.TpoBal = "1" NO-LOCK
&Scoped-define OPEN-QUERY-b-cb-cfgd OPEN QUERY b-cb-cfgd FOR EACH cb-tbal ~
      WHERE cb-tbal.CodCia = cb-CodCia AND  ~
integral.cb-tbal.TpoBal = "1" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-b-cb-cfgd cb-tbal
&Scoped-define FIRST-TABLE-IN-QUERY-b-cb-cfgd cb-tbal


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-b-cb-cfgd}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 b-cb-cfgd R-Tipo F-CodDiv ~
c-moneda Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-mes R-Tipo F-CodDiv c-moneda 

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
     SIZE 12 BY 1.58
     BGCOLOR 8 .

DEFINE VARIABLE C-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 7.86 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE c-moneda AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 15.57 BY .69
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Mensual", 1,
"Acumulado", 2
     SIZE 21 BY .69
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 1.15.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.86 BY 1.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY b-cb-cfgd FOR 
      cb-tbal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE b-cb-cfgd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cb-cfgd D-Dialog _STRUCTURED
  QUERY b-cb-cfgd NO-LOCK DISPLAY
      cb-tbal.CodBal FORMAT "X(8)":U
      cb-tbal.DesBal FORMAT "X(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 44.72 BY 4.08
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     b-cb-cfgd AT ROW 1.12 COL 1 HELP
          "Escoja Balance a Procesar"
     C-mes AT ROW 1.15 COL 59.86 COLON-ALIGNED
     R-Tipo AT ROW 2.69 COL 50.43 NO-LABEL
     F-CodDiv AT ROW 3.81 COL 59.86 COLON-ALIGNED
     c-moneda AT ROW 4.92 COL 55.86 NO-LABEL
     Btn_OK AT ROW 5.35 COL 2.72
     Btn_Cancel AT ROW 5.38 COL 15.57
     "Moneda" VIEW-AS TEXT
          SIZE 5.86 BY .69 AT ROW 4.92 COL 48.29
     RECT-1 AT ROW 2.46 COL 49.14
     RECT-2 AT ROW 4.77 COL 47.14
     SPACE(0.28) SKIP(1.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Impresión de Anexos de Balances".


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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB b-cb-cfgd RECT-2 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX C-mes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cb-cfgd
/* Query rebuild information for BROWSE b-cb-cfgd
     _TblList          = "integral.cb-tbal"
     _Options          = "NO-LOCK"
     _Where[1]         = "integral.cb-tbal.CodCia = cb-CodCia AND 
integral.cb-tbal.TpoBal = ""1"""
     _FldNameList[1]   = integral.cb-tbal.CodBal
     _FldNameList[2]   = integral.cb-tbal.DesBal
     _Query            is OPENED
*/  /* BROWSE b-cb-cfgd */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Impresión de Anexos de Balances */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME b-cb-cfgd
&Scoped-define SELF-NAME b-cb-cfgd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cb-cfgd D-Dialog
ON ITERATION-CHANGED OF b-cb-cfgd IN FRAME D-Dialog
DO:
   s-CodBal = cb-tbal.CodBal.
   s-NomBal = cb-Tbal.DesBal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cb-cfgd D-Dialog
ON ROW-DISPLAY OF b-cb-cfgd IN FRAME D-Dialog
DO:
  s-CodBal = cb-tbal.CodBal.
  s-NomBal = cb-Tbal.DesBal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN C-mes c-moneda R-tipo F-CodDiv.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDiv D-Dialog
ON LEAVE OF F-CodDiv IN FRAME D-Dialog /* División */
DO:
 ASSIGN F-CodDiv.
 IF F-CodDiv <> "" THEN DO:        
        FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                           Gn-Divi.Coddiv = F-CodDiv NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-CodDiv + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CodDiv IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
  END.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDiv D-Dialog
ON MOUSE-SELECT-DBLCLICK OF F-CodDiv IN FRAME D-Dialog /* División */
DO:
 {CBD/H-DIVI01.I NO SELF}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CALCULA-NOTA D-Dialog 
PROCEDURE CALCULA-NOTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-ForBal AS CHAR.
DEFINE INPUT PARAMETER x-Item   AS INTEGER.
DEFINE INPUT PARAMETER x-Nota   AS CHAR.

DEFINE VAR x-CodCta AS CHAR.
DEFINE VAR x-Metodo AS CHAR.
DEFINE VAR x-Signo  AS CHAR.
DEFINE VAR x-CodAux AS CHAR.
DEFINE VAR nTotal   AS DECIMAL.
DEFINE VAR ValHis   AS DECIMAL.
DEFINE VAR ValAju   AS DECIMAL.
DEFINE VAR x-Rowid  AS ROWID.
DEFINE VAR M-I      AS INTEGER.
DEFINE VAR I        AS INTEGER.
DEFINE VAR x-Debe-A AS DECIMAL.
DEFINE VAR x-Haber-A AS DECIMAL.
DEFINE VAR x-Saldo-A AS DECIMAL.

ValHis = 0.
ValAju = 0.

IF x-Nota = "*" THEN DO :
   FOR EACH cb-dbal NO-LOCK WHERE cb-dbal.CodCia = cb-codcia AND 
                                  cb-dbal.TpoBal = "1"      AND
                                  cb-dbal.CodBal = s-CodBal AND
                                  SUBSTRING(cb-dbal.ForBal,1,1) = x-ForBal AND
                                  cb-dbal.Item   = x-Item : 
       ConActivo = ConActivo + 1.    
       FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.CodCia = cb-codcia AND
                                cb-ctas.CodCta BEGINS cb-dbal.CodCta AND
                                LENGTH(cb-ctas.CodCta) = cb-maxnivel
                                BY cb-ctas.CodCta :                            
       nTotal = 0.
       x-CodCta = cb-ctas.CodCta.
       x-Signo  = cb-dbal.Signo.
       x-Metodo = cb-dbal.Metodo.
       x-CodAux = cb-dbal.CodAux.
       IF LOOKUP(x-Metodo,"X,Y") > 0 THEN 
          RUN cbd/cbd_impb.p(  s-Codcia, 
                           TRIM(x-CodCta),
                           TRIM(f-CodDiv),
                           s-periodo,                        
                           s-NroMes,                        
                           C-moneda,
                           OUTPUT impca1, 
                           OUTPUT impca2, 
                           OUTPUT impca3,
                           OUTPUT impca4 ).
       ELSE     
       RUN cbd/cbd_imp.p(  s-Codcia, 
                           TRIM(x-CodCta),
                           TRIM(f-CodDiv),
                           s-periodo,                        
                           s-NroMes,                        
                           C-moneda,
                           OUTPUT impca1, 
                           OUTPUT impca2, 
                           OUTPUT impca3,
                           OUTPUT impca4,
                           OUTPUT impca5,
                           OUTPUT impca6 ).    
                           
        IF R-Tipo = 1 THEN DO :
          CASE x-Metodo :
                 WHEN "D" THEN nTotal = ImpCa1.                 
                 WHEN "H" THEN nTotal = ImpCa2.
                 WHEN "S" THEN nTotal = ImpCa3.
                 WHEN "A" THEN nTotal = IF ImpCa3 > 0 THEN ImpCa3 ELSE 0.
                 WHEN "P" THEN nTotal = IF ImpCa3 > 0 THEN 0 ELSE ImpCa3.
                 WHEN "X" THEN nTotal = ImpCa1.                 
                 WHEN "Y" THEN nTotal = ImpCa2.
          END CASE.
        END.  
        ELSE DO :
          CASE x-Metodo :
                 WHEN "D" THEN nTotal = ImpCa4.
                 WHEN "H" THEN nTotal = ImpCa5.
                 WHEN "S" THEN nTotal = ImpCa6.
                 WHEN "A" THEN nTotal = IF ImpCa6 > 0 THEN ImpCa6 ELSE 0.
                 WHEN "P" THEN nTotal = IF ImpCa6 > 0 THEN 0 ELSE ImpCa6.
                 WHEN "X" THEN nTotal = ImpCa3.                 
                 WHEN "Y" THEN nTotal = ImpCa4.                 
          END CASE.
        END.  
        
        IF x-CodAux = "" THEN DO :            
           IF x-Signo = "+" THEN ValHis = ValHis + nTotal.
              ELSE ValHis = ValHis - nTotal.     
        END.
                    
        CREATE T-BAL.
        T-BAL.Orden    = ConActivo.
        T-BAL.s-Cuenta = cb-ctas.CodCta.
        T-BAL.Item     = ConActivo.
        T-BAL.Glosa    = cb-nbal.Glosa.
        T-BAL.Nota     = x-Nota.    
        T-bal.s-Import = ntotal.
    END.
    
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
  DISPLAY C-mes R-Tipo F-CodDiv c-moneda 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 b-cb-cfgd R-Tipo F-CodDiv c-moneda Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA-TEMPORAL D-Dialog 
PROCEDURE GENERA-TEMPORAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* PARA EL ACTIVO */

ConPasivo = 0.
ConActivo = 0.

FOR EACH cb-nbal NO-LOCK WHERE cb-nbal.CodCia = cb-codcia AND 
                               cb-nbal.TpoBal = "1"      AND
                               cb-nbal.CodBal = s-CodBal AND
                               cb-nbal.ForBal = "Activo"
                               BREAK BY cb-nbal.item :     
       x-Mensaje = cb-nbal.GLOSA.
       DISPLAY x-mensaje WITH FRAME f-mensaje.
       PAUSE 0.
       RUN CALCULA-NOTA("A", cb-nbal.Item, cb-nbal.Nota).
END. /*Fin del For Each*/

HIDE FRAME f-Mensaje.

/* PARA EL PASIVO */

FOR EACH cb-nbal no-lock WHERE cb-nbal.CodCia = cb-codcia AND 
                               cb-nbal.TpoBal = "1"      AND
                               cb-nbal.CodBal = s-CodBal AND
                               cb-nbal.ForBal = "Pasivo" 
                               BREAK BY cb-nbal.item :
       x-Mensaje = cb-nbal.GLOSA. 
       DISPLAY x-mensaje WITH FRAME f-mensaje.
       PAUSE 0.
       RUN CALCULA-NOTA("P", cb-nbal.Item, cb-nbal.Nota).
END.

HIDE FRAME f-Mensaje.

RUN IMPRE-01.

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
  DEFINE VAR x-Import  AS CHAR. 
  DEFINE VAR x-Glosa   AS CHAR.
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(100)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(100)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(100)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(100)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(100)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = "ANEXOS DEL " + s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "ANEXO " + x-Glosa + " MENSUAL ".
                 ELSE Titulo4 = "ANEXO " + x-Glosa + " ACUMULADO ".

  RUN BIN/_centrar.p ( INPUT Titulo1, 100 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 100 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 100 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 100 , OUTPUT Titulo4).          
  
  DEFINE FRAME f-cab  
  SPACE(15)
  T-BAL.s-Cuenta 
  cb-ctas.NomCta
  x-Import COLUMN-LABEL "IMPORTE" FORMAT "X(16)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 78 TODAY AT 88  SKIP
  SPACE(15)
  "DIVISION : " F-CODDIV
  "HORA   : " AT 78 STRING(TIME,"HH:MM") AT 88 SKIP
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  WITH DOWN  NO-BOX STREAM-IO WIDTH 100.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
* ***/

 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3} .
   
 FOR EACH T-BAL , FIRST cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                                      cb-ctas.CodCta = t-bal.s-Cuenta 
                BREAK BY T-BAL.ITEM 
                BY T-BAL.ORDEN :                      
     CASE T-bal.Nota  :
         WHEN "RS" THEN x-Import = FILL("-",16).
         WHEN "RD" THEN x-Import = FILL("=",16).         
         OTHERWISE x-Import = IF T-BAL.s-Import = 0 THEN "" 
                              ELSE STRING(T-BAL.s-Import,"(ZZZ,ZZZ,ZZ9.99)").                                 
     END CASE.            
  
     IF FIRST-OF (ITEM) THEN DO :
        x-Glosa  = T-BAL.Glosa.
        IF R-TIPO = 1  THEN Titulo4 = "ANEXO " + x-Glosa + " MENSUAL ".
                 ELSE Titulo4 = "ANEXO " + x-Glosa + " ACUMULADO ".
        RUN BIN/_centrar.p ( INPUT Titulo4, 100 , OUTPUT Titulo4).
        DISPLAY STREAM REPORT 
                x-Glosa @ cb-ctas.NomCta
                WITH FRAME F-Cab.
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
        
        UNDERLINE STREAM REPORT 
                  cb-ctas.NomCta 
                  WITH FRAME F-Cab.        
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
     END.
     
     DISPLAY STREAM REPORT 
             t-bal.s-Cuenta
             cb-ctas.NomCta
             x-Import
             WITH FRAME F-Cab.
     
     ACCUMULATE s-Import (SUB-TOTAL BY ITEM).
                  
     IF LAST-OF (ITEM) THEN DO :
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 

        UNDERLINE STREAM REPORT 
                  cb-ctas.NomCta 
                  WITH FRAME F-Cab.

        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
        
        DISPLAY STREAM REPORT 
                "TOTAL ANEXO " @ cb-ctas.NomCta
                ACCUM SUB-TOTAL BY ITEM s-IMport @ x-Import
                WITH FRAME F-Cab.
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
        
        UNDERLINE STREAM REPORT 
                  cb-ctas.NomCta 
                  WITH FRAME F-Cab.
        
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
        PAGE STREAM REPORT.
     END.        
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/

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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN GENERA-TEMPORAL.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
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

  C-mes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(s-NroMes,"99").  
  
  FIND FIRST GN-DIV WHERE gn-div.CodCia = s-codcia NO-LOCK NO-ERROR.  
  IF AVAILABLE GN-DIV THEN F-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-div.CodDiv.
  
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-tbal"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

