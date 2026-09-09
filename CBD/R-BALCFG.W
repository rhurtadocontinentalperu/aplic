&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
       FIELD Glosa       LIKE cb-nbal.Glosa  EXTENT 2
       FIELD Descripcion LIKE cb-nbal.DesGlo EXTENT 2
       FIELD Nota        LIKE cb-nbal.Nota   EXTENT 2
       FIELD a-Porcen    AS DECIMAL FORMAT "(ZZ9,99)" EXTENT 2 
       FIELD p-Porcen    AS DECIMAL FORMAT "(ZZ9,99)" EXTENT 2 
       FIELD a-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)"  EXTENT 2
       FIELD p-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)"  EXTENT 2.

DEFINE BUFFER B-ACMD FOR cb-acmd.

DEFINE VAR a-Total AS DECIMAL EXTENT 2.
DEFINE VAR p-Total AS DECIMAL EXTENT 2.


DEFINE FRAME f-mensaje x-Mensaje WITH NO-LABEL VIEW-AS DIALOG-BOX
       CENTERED TITLE "Calculando ... Espere un momento ...".


DEFINE VAR x-AcumQ1  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ2  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ3  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ4  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-TotGen  AS DECIMAL EXTENT 10 INITIAL 0.


DEFINE TEMP-TABLE T-RATIO
       FIELD Item        AS INTEGER
       FIELD orden       AS INTEGER
       FIELD nota        AS CHAR
       FIELD Descripcion LIKE cb-nbal.DesGlo
       FIELD f-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME b-cb-cfgd

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-tbal

/* Definitions for BROWSE b-cb-cfgd                                     */
&Scoped-define FIELDS-IN-QUERY-b-cb-cfgd cb-tbal.CodBal cb-tbal.DesBal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cb-cfgd 
&Scoped-define FIELD-PAIRS-IN-QUERY-b-cb-cfgd
&Scoped-define OPEN-QUERY-b-cb-cfgd OPEN QUERY b-cb-cfgd FOR EACH cb-tbal ~
      WHERE cb-tbal.CodCia = cb-CodCia AND  ~
integral.cb-tbal.TpoBal = "1" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-b-cb-cfgd cb-tbal
&Scoped-define FIRST-TABLE-IN-QUERY-b-cb-cfgd cb-tbal


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-b-cb-cfgd}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 b-cb-cfgd T-RATIOS C-FORMATO ~
R-Tipo Btn_OK c-moneda Btn_Cancel F-CodDiv 
&Scoped-Define DISPLAYED-OBJECTS T-RATIOS C-FORMATO R-Tipo c-moneda C-mes ~
F-CodDiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD QUITA-CONJUNTO D-Dialog 
FUNCTION QUITA-CONJUNTO RETURNS CHAR
  ( INPUT FORMULA AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD VALOR-F D-Dialog 
FUNCTION VALOR-F RETURNS DECIMAL
  ( INPUT FORMULA AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD VALOR-V D-Dialog 
FUNCTION VALOR-V RETURNS DECIMAL
  ( INPUT VALOR-V AS CHAR )  FORWARD.

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
     SIZE 12 BY 1.58
     BGCOLOR 8 .

DEFINE VARIABLE C-FORMATO AS CHARACTER FORMAT "X(40)":U INITIAL "HISTORICO" 
     LABEL "Formato" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "HISTORICO","AJUSTADO O TRIBUTARIO","HISTORICO Y AJUSTADO COMPARATIVO","HISTORICO (%)","AJUSTADO O TRIBUTARIO (%)","HISTORICO Y AJUSTADO COMPARATIVO (%)" 
     SIZE 36.86 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
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

DEFINE VARIABLE T-RATIOS AS LOGICAL INITIAL no 
     LABEL "Imprime Ratios" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.14 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY b-cb-cfgd FOR 
      cb-tbal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE b-cb-cfgd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cb-cfgd D-Dialog _STRUCTURED
  QUERY b-cb-cfgd NO-LOCK DISPLAY
      cb-tbal.CodBal
      cb-tbal.DesBal
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 44.72 BY 4.08
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     b-cb-cfgd AT ROW 1.04 COL 1 HELP
          "Escoja Balance a Procesar"
     T-RATIOS AT ROW 7.04 COL 2.43
     C-FORMATO AT ROW 5.35 COL 6.72 COLON-ALIGNED
     R-Tipo AT ROW 2.69 COL 50.43 NO-LABEL
     Btn_OK AT ROW 6.46 COL 46.72
     c-moneda AT ROW 4.92 COL 55.86 NO-LABEL
     Btn_Cancel AT ROW 6.5 COL 59.57
     C-mes AT ROW 1.15 COL 59.86 COLON-ALIGNED
     F-CodDiv AT ROW 3.81 COL 59.86 COLON-ALIGNED
     RECT-2 AT ROW 4.77 COL 47.14
     RECT-1 AT ROW 2.46 COL 49.14
     "Moneda" VIEW-AS TEXT
          SIZE 5.86 BY .69 AT ROW 4.92 COL 48.29
     SPACE(18.13) SKIP(2.85)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Impresión de Balances Configurados".


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
                                                                        */
/* BROWSE-TAB b-cb-cfgd TEXT-1 D-Dialog */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Impresión de Balances Configurados */
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
  ASSIGN C-FORMATO C-mes c-moneda R-tipo F-CodDiv T-RATIOS.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-FORMATO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-FORMATO D-Dialog
ON VALUE-CHANGED OF C-FORMATO IN FRAME D-Dialog /* Formato */
DO:
   DO WITH FRAME {&FRAME-NAME} :
    I-FORMATO = LOOKUP (C-FORMATO:SCREEN-VALUE , C-FORMATO:LIST-ITEMS).
   END.
                         
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
DEFINE INPUT PARAMETER x-total% AS CHAR.

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
x-Saldo-A = 0.
IF x-Nota = "*" THEN DO :
   FOR EACH cb-dbal NO-LOCK WHERE cb-dbal.CodCia = cb-codcia AND 
                                  cb-dbal.TpoBal = "1"      AND
                                  cb-dbal.CodBal = s-CodBal AND
                                  SUBSTRING(cb-dbal.ForBal,1,1) = x-ForBal AND
                                  cb-dbal.Item   = x-Item :                             
       nTotal = 0.
       x-CodCta = cb-dbal.CodCta.
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
          END.
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
          END.
        END.  
        
        IF x-CodAux = "" THEN DO :            
           IF x-Signo = "+" THEN ValHis = ValHis + nTotal.
              ELSE ValHis = ValHis - nTotal.     
        END.
                                                   
        M-I = IF R-Tipo = 2 THEN 0 ELSE C-MES.
        
        FIND cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND
                           cb-acmd.Periodo = s-Periodo AND
                           cb-acmd.CodCta  = x-CodAux AND 
                           cb-acmd.coddiv  BEGINS F-CodDiv NO-LOCK NO-ERROR .
        IF AVAIL cb-acmd THEN DO:     
           DO I = M-I TO C-MES :
              CASE c-moneda :
                   WHEN 1 THEN ASSIGN 
                               x-Debe-A  = x-Debe-A  + cb-acmd.DbeMn1[ i + 1 ]
                               x-Haber-A = x-Haber-A + cb-acmd.HbeMn1[ i + 1 ] .
                   WHEN 2 THEN ASSIGN 
                               x-Debe-A  = x-Debe-A  + cb-acmd.DbeMn2[ i + 1 ]
                               x-Haber-A = x-Haber-A + cb-acmd.HbeMn2[ i + 1 ] .
              END CASE.                                
           END.
           IF x-Signo = "+" THEN ASSIGN x-Saldo-A = (x-Debe-A - x-Haber-A).
              ELSE ASSIGN x-Saldo-A = - (x-Debe-A - x-Haber-A).                        
       END.
    END.                                                               
END.

ValAju = x-Saldo-A.
ValAju = ValAju + ValHis.

IF x-ForBal = "A" THEN DO :
   ConActivo = ConActivo + 1.
   FIND T-BAL WHERE t-bal.Orden = ConActivo NO-ERROR.
   IF NOT AVAILABLE T-BAL THEN DO :      
      CREATE T-BAL.
      T-BAL.Orden    = ConActivo.
      T-BAL.Item     = x-Item.            
   END.
   T-BAL.Glosa[1] = cb-nbal.Glosa.
   T-BAL.Nota[1]  = x-Nota.            
END.   
ELSE DO :
   ConPasivo = ConPAsivo + 1.
   FIND T-BAL WHERE t-bal.Orden = ConPasivo NO-ERROR.
   IF NOT AVAILABLE T-BAL THEN DO :            
      CREATE T-BAL.
      T-BAL.Orden    = ConPasivo.
      T-BAL.Item     = x-Item.                  
   END.   
   T-BAL.Glosa[2] = cb-nbal.Glosa.
   T-BAL.Nota[2]  = x-Nota.
END.

IF x-ForBal = "A" THEN DO :
   T-BAL.a-Import[1] = ValHis.
   T-BAL.a-Import[2] = ValAju.
END.
ELSE DO :
   T-BAL.p-Import[1] = ValHis.
   T-BAL.p-Import[2] = ValAju.
END.

x-Rowid = ROWID(T-BAL).

RUN CALCULA-SUMAS (x-Rowid, x-ForBal, x-Nota, ValHis, ValAju, x-total% ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CALCULA-SUMAS D-Dialog 
PROCEDURE CALCULA-SUMAS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pRowid  AS ROWID.
DEFINE INPUT PARAMETER pForBal AS CHAR.
DEFINE INPUT PARAMETER pNota   AS CHAR.
DEFINE INPUT PARAMETER nValHis AS DECIMAL.
DEFINE INPUT PARAMETER nValAju AS DECIMAL.
DEFINE INPUT PARAMETER nTotal% AS LOGICAL.

FIND T-BAL WHERE ROWID(T-BAL) = pRowid.

IF pNota = "*" THEN DO :   
   IF pForBal = "A" THEN DO :
      x-AcumQ1[1] = x-AcumQ1[1] + nValHis.
      x-AcumQ1[2] = x-AcumQ1[2] + nValAju.
                   
      x-AcumQ2[1] = x-AcumQ2[1] + nValHis.
      x-AcumQ2[2] = x-AcumQ2[2] + nValAju.                         
   
      x-AcumQ3[1] = x-AcumQ3[1] + nValHis.
      x-AcumQ3[2] = x-AcumQ3[2] + nValAju.
             
      x-TotGen[1] = x-TotGen[1] + nValHis.
      x-TotGen[2] = x-TotGen[2] + nValAju.
   END.
   ELSE DO :          
      x-AcumQ1[3] = x-AcumQ1[3] + nValHis.
      x-AcumQ1[4] = x-AcumQ1[4] + nValAju.
   
      x-AcumQ2[3] = x-AcumQ2[3] + nValHis.
      x-AcumQ2[4] = x-AcumQ2[4] + nValAju.
   
      x-AcumQ3[3] = x-AcumQ3[3] + nValHis.
      x-AcumQ3[4] = x-AcumQ3[4] + nValAju.
             
      x-TotGen[3] = x-TotGen[3] + nValHis.
      x-TotGen[4] = x-TotGen[4] + nValAju.       
  END.           
END.   

IF pNota = "Q1" THEN DO :
   IF pForBal = "A" THEN 
      ASSIGN a-Import[1] = x-AcumQ1[1] 
             a-Import[2] = x-AcumQ1[2].
   ELSE 
      ASSIGN p-Import[1] = x-AcumQ1[3]
             p-Import[2] = x-AcumQ1[4].
END.   

IF pNota = "Q2" THEN DO :
   IF pForBal = "A" THEN 
      ASSIGN a-Import[1] = x-AcumQ2[1] 
             a-Import[2] = x-AcumQ2[2].
   ELSE 
      ASSIGN p-Import[1] = x-AcumQ2[3]
             p-Import[2] = x-AcumQ2[4].
END.   

IF pNota = "Q3" THEN DO :
   IF pForBal = "A" THEN 
      ASSIGN a-Import[1] = x-AcumQ3[1] 
             a-Import[2] = x-AcumQ3[2].
   ELSE 
      ASSIGN p-Import[1] = x-AcumQ3[3]
             p-Import[2] = x-AcumQ3[4].
END.   


IF pNota = "RE" THEN DO :
   ASSIGN p-Import[1] = x-TotGen[1] - x-TotGen[3]
          p-Import[2] = x-TotGen[2] - x-TotGen[4]
          x-TotGen[3] = x-TotGen[3] + p-Import[1] 
          x-TotGen[4] = x-TotGen[4] + p-Import[2].
END.   

IF pNota = "TG" THEN DO :
   IF pForBal = "A" THEN 
      ASSIGN a-Import[1] = x-TotGen[1] 
             a-Import[2] = x-TotGen[2].
   ELSE 
      ASSIGN p-Import[1] = x-TotGen[3]
             p-Import[2] = x-TotGen[4].
END.   
   
IF pNota = "I1" THEN DO : 
   x-AcumQ1 [1] = 0.
   x-AcumQ1 [2] = 0.
   x-AcumQ1 [3] = 0.
   x-AcumQ1 [4] = 0.   
END.

IF pNota = "I2" THEN DO :   
   x-AcumQ2 [1] = 0.
   x-AcumQ2 [2] = 0.
   x-AcumQ2 [3] = 0.
   x-AcumQ2 [4] = 0.
END.

IF pNota = "I3" THEN DO :   
   x-AcumQ3 [1] = 0.
   x-AcumQ3 [2] = 0.
   x-AcumQ3 [3] = 0.
   x-AcumQ3 [4] = 0.
END.

IF ntotal% THEN DO :
   IF pForBal = "A" THEN ASSIGN a-total[1] = a-import[1]
                                a-total[2] = a-import[2].
      ELSE ASSIGN p-total[1] = p-import[1]
                  p-total[2] = p-import[2].
END.

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
  DISPLAY T-RATIOS C-FORMATO R-Tipo c-moneda C-mes F-CodDiv 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 RECT-1 b-cb-cfgd T-RATIOS C-FORMATO R-Tipo Btn_OK c-moneda 
         Btn_Cancel F-CodDiv 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA-RATIOS D-Dialog 
PROCEDURE GENERA-RATIOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR Formu AS CHAR.
FOR EACH cb-rbal NO-LOCK WHERE cb-rbal.CodCia = cb-codcia AND 
                               cb-rbal.TpoBal = "1"       AND
                               cb-rbal.CodBal = s-CodBal 
                               BREAK BY cb-rbal.item :         
    CREATE T-RATIO.
    T-RATIO.Item        = cb-rbal.item.
    T-RATIO.orden       = 1.
    T-RATIO.Nota        = cb-rbal.Nota.
    T-RATIO.Descripcion = cb-rbal.Glosa.
    Formu               = QUITA-CONJUNTO (cb-rbal.Formula).    
    T-RATIO.f-Import    = VALOR-F(Formu).                                                          
END.                           

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
       RUN CALCULA-NOTA("A", cb-nbal.Item, cb-nbal.Nota, cb-nbal.total% ).            
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
       RUN CALCULA-NOTA("P", cb-nbal.Item, cb-nbal.Nota, cb-nbal.total% ).
END.

FOR EACH T-BAL :
    x-Mensaje = "Porcentajes".
    DISPLAY x-mensaje WITH FRAME f-mensaje.
    PAUSE 0.    
    a-Porcen[1] = ROUND((a-import[1] * 100) / a-total[1], 2).
    a-Porcen[2] = ROUND((a-import[2] * 100) / a-total[2], 2).
    p-Porcen[1] = ROUND((p-import[1] * 100) / p-total[1], 2).
    p-Porcen[2] = ROUND((p-import[2] * 100) / p-total[2], 2).      
END.

IF T-RATIOS THEN RUN GENERA-RATIOS.

HIDE FRAME f-Mensaje.

CASE I-FORMATO :
   WHEN 1 THEN RUN IMPRE-01.
   WHEN 2 THEN RUN IMPRE-02.
   WHEN 3 THEN RUN IMPRE-03.
   WHEN 4 THEN RUN IMPRE-04.
   WHEN 5 THEN RUN IMPRE-05.
   WHEN 6 THEN RUN IMPRE-06.
END.   

IF T-RATIOS THEN RUN IMPRIME-RATIOS.

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
  DEFINE VAR x-Import  AS CHAR EXTENT 2 .
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2 .
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(150)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(150)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 150 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 150 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 150 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 150 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  SPACE(8)
  x-Glosa[2]  NO-LABEL FORMAT "X(40)"
  x-Import[2] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108  SKIP
  "DIVISION : " F-CODDIV

  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 108 SKIP
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  {&Prn7a} + "ACTIVO" + {&Prn7b} AT 20
  {&Prn7a} + "PASIVO Y PATRIMONIO NETO" + {&Prn7b} FORMAT "X(20)" AT 75
  SKIP(2)
  WITH WIDTH 150 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/
  
 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3} .
 
 FIND FIRST T-BAL NO-ERROR.
  
 FOR EACH T-BAL BREAK BY ORDEN :      
      x-Glosa[1]  = T-BAL.Glosa[1].
      x-Glosa[2]  = T-BAL.Glosa[2].
      
      CASE T-bal.Nota [1] :
         WHEN "RS" THEN x-Import[1] = FILL("-",16).
         WHEN "RD" THEN x-Import[1] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE x-Import[1] = IF T-BAL.a-Import[1] = 0 THEN "" 
                                 ELSE STRING(T-BAL.a-Import[1],"(ZZZ,ZZZ,ZZ9.99)").                                 
      END CASE.
           
      CASE T-bal.Nota [2] :         
         WHEN "RS" THEN x-Import[2] = FILL("-",16).
         WHEN "RD" THEN x-Import[2] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[2]  = {&Prn6a} + x-Glosa[2] + {&Prn6b}. 
         OTHERWISE x-Import[2] =  IF T-BAL.p-Import[1] = 0 THEN "" 
                                  ELSE STRING(T-BAL.p-Import[1],"(ZZZ,ZZZ,ZZ9.99)").
      END CASE. 
  
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            SPACE(8)
                            x-Glosa[2] 
                            x-Import[2] 
                            WITH FRAME f-cab.                            
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/
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
  DEFINE VAR x-Import  AS CHAR EXTENT 2 .
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2 .
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(150)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(150)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 150 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 150 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 150 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 150 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  SPACE(8)
  x-Glosa[2]  NO-LABEL FORMAT "X(40)"
  x-Import[2] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108 SKIP
  "DIVISION : " F-CODDIV
  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 108 SKIP
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  {&Prn7a} + "ACTIVO" + {&Prn7b} AT 20
  {&Prn7a} + "PASIVO Y PATRIMONIO NETO" + {&Prn7b} FORMAT "X(20)" AT 75
  SKIP(2)
  WITH WIDTH 150 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/

 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3} .
 
 FIND FIRST T-BAL NO-ERROR.
 
  FOR EACH T-BAL BREAK BY ORDEN :      
      x-Glosa[1]  = T-BAL.Glosa[1].
      x-Glosa[2]  = T-BAL.Glosa[2].
      
      CASE T-bal.Nota [1] :
         WHEN "RS" THEN x-Import[1] = FILL("-",16).
         WHEN "RD" THEN x-Import[1] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE x-Import[1] = IF T-BAL.a-Import[2] = 0 THEN "" 
                                 ELSE STRING(T-BAL.a-Import[2],"(ZZZ,ZZZ,ZZ9.99)").                                 
      END CASE.
           
      CASE T-bal.Nota [2] :         
         WHEN "RS" THEN x-Import[2] = FILL("-",16).
         WHEN "RD" THEN x-Import[2] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[2]  = {&Prn6a} + x-Glosa[2] + {&Prn6b}. 
         OTHERWISE x-Import[2] =  IF T-BAL.p-Import[2] = 0 THEN "" 
                                  ELSE STRING(T-BAL.p-Import[2],"(ZZZ,ZZZ,ZZ9.99)").
      END CASE. 
  
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            SPACE(8)
                            x-Glosa[2] 
                            x-Import[2] 
                            WITH FRAME f-cab.                            
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/

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
  DEFINE VAR x-Import  AS CHAR EXTENT 4 .
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2 .
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(150)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(150)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 150 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 150 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 150 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 150 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  x-Import[2] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  SPACE(8)
  x-Glosa[2]  NO-LABEL FORMAT "X(40)"
  x-Import[3] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  x-Import[4] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108 SKIP
  "DIVISION : " F-CODDIV
  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 108 SKIP 
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  {&Prn7a} + "ACTIVO" + {&Prn7b} AT 20
  {&Prn7a} + "PASIVO Y PATRIMONIO NETO" + {&Prn7b} FORMAT "X(20)" AT 75
  SKIP(2)
  WITH WIDTH 200 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/

 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4} .
 
 FIND FIRST T-BAL NO-ERROR.
 
  FOR EACH T-BAL BREAK BY ORDEN :      
      x-Glosa[1]  = T-BAL.Glosa[1].
      x-Glosa[2]  = T-BAL.Glosa[2].
      
      CASE T-bal.Nota [1] :
         WHEN "RS" THEN ASSIGN x-Import[1] = FILL("-",16)
                               x-Import[2] = FILL("-",16).
         WHEN "RD" THEN ASSIGN x-Import[1] = FILL("=",16)
                               x-Import[2] = FILL("-",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE DO :
              x-Import[1] = IF T-BAL.a-Import[1] = 0 THEN "" 
                            ELSE STRING(T-BAL.a-Import[1],"(ZZZ,ZZZ,ZZ9.99)").                                 
              x-Import[2] = IF T-BAL.a-Import[2] = 0 THEN "" 
                            ELSE STRING(T-BAL.a-Import[2],"(ZZZ,ZZZ,ZZ9.99)").
         END.                    
      END CASE.
           
      CASE T-bal.Nota [2] :         
         WHEN "RS" THEN ASSIGN x-Import[3] = FILL("-",16)
                               x-Import[4] = FILL("-",16).
         WHEN "RD" THEN ASSIGN x-Import[3] = FILL("=",16)
                               x-Import[4] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[2]  = {&Prn6a} + x-Glosa[2] + {&Prn6b}. 
         OTHERWISE DO :
              x-Import[3] = IF T-BAL.p-Import[1] = 0 THEN "" 
                            ELSE STRING(T-BAL.p-Import[1],"(ZZZ,ZZZ,ZZ9.99)").
              x-Import[4] = IF T-BAL.p-Import[2] = 0 THEN "" 
                            ELSE STRING(T-BAL.p-Import[2],"(ZZZ,ZZZ,ZZ9.99)").              
         END.                   
                            
      END CASE. 
  
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            x-Import[2]
                            SPACE(8)
                            x-Glosa[2] 
                            x-Import[3] 
                            x-Import[4]
                            WITH FRAME f-cab.                            
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/

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
  DEFINE VAR x-Import  AS CHAR EXTENT 2 .
  DEFINE VAR x-Porcen  AS CHAR EXTENT 2 .
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2 .
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(150)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(150)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 150 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 150 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 150 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 150 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  x-Porcen[1] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  SPACE(8)
  x-Glosa[2]  NO-LABEL FORMAT "X(40)"
  x-Import[2] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  x-Porcen[2] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108 SKIP 
  "DIVISION : " F-CODDIV
  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 108
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  {&Prn7a} + "ACTIVO" + {&Prn7b} AT 20
  {&Prn7a} + "PASIVO Y PATRIMONIO NETO" + {&Prn7b} FORMAT "X(20)" AT 75
  SKIP(2)
  WITH WIDTH 150 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/

 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3} .
 
 FIND FIRST T-BAL NO-ERROR.
 
  FOR EACH T-BAL BREAK BY ORDEN :      
      x-Glosa[1]  = T-BAL.Glosa[1].
      x-Glosa[2]  = T-BAL.Glosa[2].
      x-porcen[1] = IF T-BAL.a-Porcen[1] = 0 THEN "" 
                       ELSE STRING(T-BAL.a-Porcen[1],"(ZZZ9.99)").
      x-porcen[2] = IF T-BAL.p-Porcen[1] = 0 THEN "" 
                       ELSE STRING(T-BAL.p-Porcen[1],"(ZZZ9.99)").
                       
      CASE T-bal.Nota [1] :
         WHEN "RS" THEN x-Import[1] = FILL("-",16).
         WHEN "RD" THEN x-Import[1] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE x-Import[1] = IF T-BAL.a-Import[1] = 0 THEN "" 
                                 ELSE STRING(T-BAL.a-Import[1],"(ZZZ,ZZZ,ZZ9.99)").                                 
      END CASE.
           
      CASE T-bal.Nota [2] :         
         WHEN "RS" THEN x-Import[2] = FILL("-",16).
         WHEN "RD" THEN x-Import[2] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[2]  = {&Prn6a} + x-Glosa[2] + {&Prn6b}. 
         OTHERWISE x-Import[2] =  IF T-BAL.p-Import[1] = 0 THEN "" 
                                  ELSE STRING(T-BAL.p-Import[1],"(ZZZ,ZZZ,ZZ9.99)").
      END CASE. 
  
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            x-porcen[1]
                            SPACE(8)
                            x-Glosa[2] 
                            x-Import[2] 
                            x-porcen[2]
                            WITH FRAME f-cab.                            
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRE-05 D-Dialog 
PROCEDURE IMPRE-05 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-Import  AS CHAR EXTENT 2 .
  DEFINE VAR x-Porcen  AS CHAR EXTENT 2 .  
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2 .
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(150)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(150)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 150 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 150 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 150 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 150 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  x-Porcen[1] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  SPACE(8)
  x-Glosa[2]  NO-LABEL FORMAT "X(40)"
  x-Import[2] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  x-Porcen[2] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108 SKIP
  "DIVISION : " F-CODDIV
  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 108 SKIP
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  {&Prn7a} + "ACTIVO" + {&Prn7b} AT 20
  {&Prn7a} + "PASIVO Y PATRIMONIO NETO" + {&Prn7b} FORMAT "X(20)" AT 75
  SKIP(2)
  WITH WIDTH 150 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
* ***/

 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3} .
 
 FIND FIRST T-BAL NO-ERROR.
 
  FOR EACH T-BAL BREAK BY ORDEN :      
      x-Glosa[1]  = T-BAL.Glosa[1].
      x-Glosa[2]  = T-BAL.Glosa[2].
      x-porcen[1] = IF T-BAL.a-Porcen[2] = 0 THEN "" 
                       ELSE STRING(T-BAL.a-Porcen[2],"(ZZZ9.99)").
      x-porcen[2] = IF T-BAL.p-Porcen[2] = 0 THEN "" 
                       ELSE STRING(T-BAL.p-Porcen[2],"(ZZZ9.99)").
      
      CASE T-bal.Nota [1] :
         WHEN "RS" THEN x-Import[1] = FILL("-",16).
         WHEN "RD" THEN x-Import[1] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE x-Import[1] = IF T-BAL.a-Import[2] = 0 THEN "" 
                                 ELSE STRING(T-BAL.a-Import[2],"(ZZZ,ZZZ,ZZ9.99)").                                 
      END CASE.
           
      CASE T-bal.Nota [2] :         
         WHEN "RS" THEN x-Import[2] = FILL("-",16).
         WHEN "RD" THEN x-Import[2] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[2]  = {&Prn6a} + x-Glosa[2] + {&Prn6b}. 
         OTHERWISE x-Import[2] =  IF T-BAL.p-Import[2] = 0 THEN "" 
                                  ELSE STRING(T-BAL.p-Import[2],"(ZZZ,ZZZ,ZZ9.99)").
      END CASE. 
  
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            x-porcen[1]
                            SPACE(8)
                            x-Glosa[2] 
                            x-Import[2]
                            x-porcen[2] 
                            WITH FRAME f-cab.                            
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRE-06 D-Dialog 
PROCEDURE IMPRE-06 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-Import  AS CHAR EXTENT 4.
  DEFINE VAR x-Porcen  AS CHAR EXTENT 4.
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2.
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(180)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(180)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(180)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(180)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(180)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 180 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 180 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 180 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 180 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  x-Porcen[1] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  x-Import[2] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  x-Porcen[2] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  SPACE(8)
  x-Glosa[2]  NO-LABEL FORMAT "X(40)"
  x-Import[3] COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  x-Porcen[3] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  x-Import[4] COLUMN-LABEL "AJUSTADO" FORMAT "X(16)"
  x-Porcen[4] COLUMN-LABEL "Porcentaje" FORMAT "X(10)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 168 TODAY AT 178 SKIP
  "DIVISION : " F-CODDIV
  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 178 SKIP 
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  {&Prn7a} + "ACTIVO" + {&Prn7b} AT 20
  {&Prn7a} + "PASIVO Y PATRIMONIO NETO" + {&Prn7b} FORMAT "X(20)" AT 75
  SKIP(2)
  WITH WIDTH 200 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/

 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4} .
 
 FIND FIRST T-BAL NO-ERROR.
 
  FOR EACH T-BAL BREAK BY ORDEN :      
      x-Glosa[1]  = T-BAL.Glosa[1].
      x-Glosa[2]  = T-BAL.Glosa[2].
      x-porcen[1] = IF T-BAL.a-Porcen[1] = 0 THEN "" 
                       ELSE STRING(T-BAL.a-Porcen[1],"(ZZZ9.99)").
      x-porcen[2] = IF T-BAL.a-Porcen[2] = 0 THEN "" 
                       ELSE STRING(T-BAL.a-Porcen[2],"(ZZZ9.99)").
      x-porcen[3] = IF T-BAL.p-Porcen[1] = 0 THEN ""
                       ELSE STRING(T-BAL.p-Porcen[1],"(ZZZ9.99)").
      x-porcen[4] = IF T-BAL.p-Porcen[2] = 0 THEN "" 
                       ELSE STRING(T-BAL.p-Porcen[2],"(ZZZ9.99)").
                             
      CASE T-bal.Nota [1] :
         WHEN "RS" THEN ASSIGN x-Import[1] = FILL("-",16)
                               x-Import[2] = FILL("-",16).
         WHEN "RD" THEN ASSIGN x-Import[1] = FILL("=",16)
                               x-Import[2] = FILL("-",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE DO :
              x-Import[1] = IF T-BAL.a-Import[1] = 0 THEN "" 
                            ELSE STRING(T-BAL.a-Import[1],"(ZZZ,ZZZ,ZZ9.99)").                                 
              x-Import[2] = IF T-BAL.a-Import[2] = 0 THEN "" 
                            ELSE STRING(T-BAL.a-Import[2],"(ZZZ,ZZZ,ZZ9.99)").
         END.                    
      END CASE.
           
      CASE T-bal.Nota [2] :         
         WHEN "RS" THEN ASSIGN x-Import[3] = FILL("-",16)
                               x-Import[4] = FILL("-",16).
         WHEN "RD" THEN ASSIGN x-Import[3] = FILL("=",16)
                               x-Import[4] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[2]  = {&Prn6a} + x-Glosa[2] + {&Prn6b}. 
         OTHERWISE DO :
              x-Import[3] = IF T-BAL.p-Import[1] = 0 THEN "" 
                            ELSE STRING(T-BAL.p-Import[1],"(ZZZ,ZZZ,ZZ9.99)").
              x-Import[4] = IF T-BAL.p-Import[2] = 0 THEN "" 
                            ELSE STRING(T-BAL.p-Import[2],"(ZZZ,ZZZ,ZZ9.99)").              
         END.                   
                            
      END CASE. 
  
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            x-Porcen[1]
                            x-Import[2]
                            x-Porcen[2]
                            SPACE(8)
                            x-Glosa[2] 
                            x-Import[3] 
                            x-Porcen[3]
                            x-Import[4]
                            x-Porcen[4]
                            WITH FRAME f-cab.                            
  END.

/*MLR* 09/11/07 ***
  OUTPUT STREAM REPORT CLOSE.
* ***/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME-RATIOS D-Dialog 
PROCEDURE IMPRIME-RATIOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-Import  AS CHAR EXTENT 2 .
  DEFINE VAR x-Glosa   AS CHAR EXTENT 2 .
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(150)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(150)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(150)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = "RATIOS DE " + s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  RUN BIN/_centrar.p ( INPUT Titulo1, 150 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 150 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 150 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 150 , OUTPUT Titulo4).
  
  DEFINE FRAME f-cab
  x-Glosa[1]  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "IMPORTE" FORMAT "X(16)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108  SKIP
  "HORA : " + STRING(TIME,"HH:MM") FORMAT "X(15)" AT 108 SKIP
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP(2)
  WITH WIDTH 150 NO-BOX DOWN STREAM-IO.

/*MLR* 09/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) APPEND PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name) PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) APPEND PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
* ***/
    
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3} .
  
  FOR EACH T-RATIO BREAK BY T-RATIO.ITEM :   
      x-Glosa[1]  = T-RATIO.Descripcion.
      
      CASE T-RATIO.Nota :
         WHEN "RS" THEN x-Import[1] = FILL("-",16).
         WHEN "RD" THEN x-Import[1] = FILL("=",16).
         WHEN "NE" THEN x-Glosa[1]  = {&Prn6a} + x-Glosa[1] + {&Prn6b}.
         OTHERWISE x-Import[1] = IF T-RATIO.f-Import = 0 THEN "" 
                                 ELSE STRING(T-RATIO.f-Import,"(ZZZ,ZZZ,ZZ9.99)").                                 
      END CASE.
           
      DISPLAY STREAM REPORT x-Glosa[1]
                            x-Import[1]
                            WITH FRAME f-cab.                            
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION QUITA-CONJUNTO D-Dialog 
FUNCTION QUITA-CONJUNTO RETURNS CHAR
  ( INPUT FORMULA AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR a-Formula AS CHAR EXTENT 5.
DEFINE VAR IniBucle  AS INTEGER.
DEFINE VAR FinBucle  AS INTEGER.
DEFINE VAR i         AS INTEGER.
DEFINE VAR ValCadena AS CHAR.
DEFINE VAR EnBucle   AS LOGICAL.
DEFINE VAR NvaFormu  AS CHAR.

IniBucle = 0.
FinBucle = 0.

DO i = 1 TO NUM-ENTRIES (Formula , " ") :
   ValCadena = ENTRY ( i, Formula , " " ).
   
   CASE ValCadena :
        WHEN "(" THEN DO :
             IniBucle  = IniBucle + 1.
             EnBucle   = TRUE.
             ValCadena = "".
        END.
        WHEN ")" THEN DO :
             FinBucle  = FinBucle + 1.
             EnBucle   = FALSE.             
             ValCadena = STRING ( VALOR-f ( TRIM ( a-Formula[IniBucle] ) ) ).
        END.
   END CASE.
   
   IF IniBucle > 0 THEN DO :
      a-Formula[IniBucle] = a-Formula[IniBucle] + " " + ValCadena. 
   END.     
   
   IF Not EnBucle THEN DO :
      NvaFormu = NvaFormu + " " + ValCadena.
   END.
      
END.   

RETURN TRIM(NvaFormu).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION VALOR-F D-Dialog 
FUNCTION VALOR-F RETURNS DECIMAL
  ( INPUT FORMULA AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR VALOR-C AS CHAR.
DEFINE VAR VALOR-N AS DECIMAL.
DEFINE VAR VALOR-CA AS DECIMAL.
DEFINE VAR PROCESA AS LOGICAL.
DEFINE VAR S-SIGNO AS CHAR.
DEFINE VAR I AS INTEGER.

VALOR-N = 0.
S-SIGNO = "".
PROCESA = FALSE.

/* FORMULA = QUITA-CONJUNTO (FORMULA). */

DO i = 1 TO NUM-ENTRIES(FORMULA," " ) :
   VALOR-C = ENTRY(i, FORMULA, " " ).   
   IF VALOR-C BEGINS "A" OR VALOR-C BEGINS "P" THEN DO :
      VALOR-N = VALOR-V ( VALOR-C ).      
   END.   
   ELSE DO :
      IF LOOKUP(VALOR-C,"+,-,*,/") > 0 THEN S-SIGNO = VALOR-C.   
         ELSE VALOR-N = DECIMAL(VALOR-C). 
   END.  
   IF I = 1 THEN VALOR-CA = VALOR-N.   
   IF PROCESA THEN DO :         
      CASE S-SIGNO :     
           WHEN "+" THEN VALOR-CA = ( VALOR-CA + VALOR-N ).
           WHEN "-" THEN VALOR-CA = ( VALOR-CA - VALOR-N ).
           WHEN "*" THEN VALOR-CA = ( VALOR-CA * VALOR-N ).
           WHEN "/" THEN VALOR-CA = ( VALOR-CA / VALOR-N ).
      END CASE.           
   END.       
   
   IF LOOKUP(VALOR-C,"+,-,*,/") > 0 THEN PROCESA = TRUE.
      ELSE PROCESA = FALSE.         
END.

  RETURN VALOR-CA.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION VALOR-V D-Dialog 
FUNCTION VALOR-V RETURNS DECIMAL
  ( INPUT VALOR-V AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR L-ITEM AS  INTEGER NO-UNDO.
  DEFINE VAR L-TIPO AS  CHAR NO-UNDO.
  DEFINE VAR L-VALOR AS DECIMAL NO-UNDO.
  
  L-TIPO = SUBSTRING(VALOR-V, 1, 1).
  L-ITEM = INTEGER ( SUBSTRING(VALOR-V, 2) ).
  
  FIND T-BAL WHERE T-BAL.item = L-ITEM NO-LOCK NO-ERROR.
  
  IF AVAILABLE T-BAL THEN DO :
     IF L-TIPO = "A" THEN L-VALOR = ABSOLUTE( T-BAL.a-Import[1] ).
        ELSE L-VALOR = ABSOLUTE( T-BAL.p-Import[1] ).  
  END.
  ELSE L-VALOR = 0.
      
  RETURN L-VALOR.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


