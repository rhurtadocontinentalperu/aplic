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

DEFINE VAR x-Mensaje   AS CHAR FORMAT "X(30)".
DEFINE VAR s-CodBal    AS CHAR.
DEFINE VAR s-NomBal    AS CHAR.
DEFINE VAR i-Formato   AS INTEGER INITIAL 1.
DEFINE VAR b-acumulado AS LOGICAL.
DEFINE VAR s-Activo    AS LOGICAL.
DEFINE VAR ii          AS INTEGER.

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
       FIELD ForBal      AS CHAR
       FIELD Item        AS INTEGER
       FIELD orden       AS INTEGER
       FIELD Glosa       LIKE cb-nbal.Glosa 
       FIELD Descripcion LIKE cb-nbal.DesGlo 
       FIELD Nota        LIKE cb-nbal.Nota   
       FIELD a-Porcen    AS DECIMAL FORMAT "(ZZ9,99)" INITIAL 0 EXTENT 13
       FIELD a-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" INITIAL 0 EXTENT 13.

DEFINE BUFFER B-ACMD FOR cb-acmd.
DEFINE BUFFER B-CB-NBAL FOR CB-NBAL.

DEFINE VAR R-NBAL AS ROWID.

DEFINE VAR a-Total AS DECIMAL EXTENT 13.
DEFINE VAR p-Total AS DECIMAL EXTENT 13.

DEFINE FRAME f-mensaje x-Mensaje WITH NO-LABEL VIEW-AS DIALOG-BOX
       CENTERED TITLE "Calculando ... Espere un momento ...".

DEFINE VAR x-AcumQ1  AS DECIMAL EXTENT 13 INITIAL 0.
DEFINE VAR x-AcumQ2  AS DECIMAL EXTENT 13 INITIAL 0.
DEFINE VAR x-AcumQ3  AS DECIMAL EXTENT 13 INITIAL 0.
DEFINE VAR x-AcumQ4  AS DECIMAL EXTENT 13 INITIAL 0.
DEFINE VAR x-TotGen  AS DECIMAL EXTENT 13 INITIAL 0.

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
      WHERE cb-tbal.CodCia = cb-codcia AND  ~
integral.cb-tbal.TpoBal = "1" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-b-cb-cfgd cb-tbal
&Scoped-define FIRST-TABLE-IN-QUERY-b-cb-cfgd cb-tbal


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-b-cb-cfgd}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 b-cb-cfgd C-FORMATO C-mesIni ~
R-Tipo Btn_OK c-moneda Btn_Cancel C-mesFin F-CodDiv 
&Scoped-Define DISPLAYED-OBJECTS C-FORMATO C-mesIni R-Tipo c-moneda ~
C-mesFin F-CodDiv 

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

DEFINE VARIABLE C-FORMATO AS CHARACTER FORMAT "X(40)":U INITIAL "HISTORICO" 
     LABEL "Formato" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "HISTORICO ","AJUSTADO O TRIBUTARIO" 
     SIZE 36.86 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-mesFin AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "a" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-mesIni AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "De" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 6.86 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE c-moneda AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 16.14 BY .69 NO-UNDO.

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Mensual", 1,
"Acumulado", 2
     SIZE 22.43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23.57 BY 1.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25.43 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY b-cb-cfgd FOR 
      cb-tbal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE b-cb-cfgd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cb-cfgd D-Dialog _STRUCTURED
  QUERY b-cb-cfgd NO-LOCK DISPLAY
      cb-tbal.CodBal FORMAT "X(3)"
      cb-tbal.DesBal
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 44.72 BY 4.08
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     b-cb-cfgd AT ROW 1.04 COL 1 HELP
          "Escoja Balance a Procesar"
     C-FORMATO AT ROW 5.35 COL 6.72 COLON-ALIGNED
     C-mesIni AT ROW 1.23 COL 47.86 COLON-ALIGNED
     R-Tipo AT ROW 2.69 COL 49.14 NO-LABEL
     Btn_OK AT ROW 6 COL 46.57
     c-moneda AT ROW 4.69 COL 55.57 NO-LABEL
     Btn_Cancel AT ROW 6.04 COL 59.43
     C-mesFin AT ROW 1.23 COL 61.57 COLON-ALIGNED
     F-CodDiv AT ROW 3.69 COL 60.43 COLON-ALIGNED
     RECT-1 AT ROW 2.46 COL 48.57
     "Moneda" VIEW-AS TEXT
          SIZE 5.86 BY .69 AT ROW 4.69 COL 48.29
     RECT-2 AT ROW 4.54 COL 46.72
     SPACE(0.13) SKIP(2.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Impresión de Balances  Comparativos".


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
/* BROWSE-TAB b-cb-cfgd RECT-2 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cb-cfgd
/* Query rebuild information for BROWSE b-cb-cfgd
     _TblList          = "integral.cb-tbal"
     _Options          = "NO-LOCK"
     _Where[1]         = "integral.cb-tbal.CodCia = cb-codcia AND 
integral.cb-tbal.TpoBal = ""1"""
     _FldNameList[1]   > integral.cb-tbal.CodBal
"cb-tbal.CodBal" ? "X(3)" "character" ? ? ? ? ? ? no ?
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Impresión de Balances  Comparativos */
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
  ASSIGN C-FORMATO C-mesIni C-mesFin c-moneda R-tipo F-CodDiv .
  IF C-mesFin - C-mesIni > 6 THEN RETURN NO-APPLY.
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
/*  OR "MOUSE-SELECT-DBLCLICK":U OF cb-cmov.CODDIV DO:*/
  {CBD/H-DIVI01.I NO SELF}
/*END.*/


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
DEFINE INPUT PARAMETER x-Item   AS INTEGER.
DEFINE INPUT PARAMETER x-Nota   AS CHAR.
DEFINE INPUT PARAMETER x-Rowidn AS ROWID.

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

ConActivo = ConActivo + 1.          

DO ii = C-MesIni TO C-MesFin :
   ValHis = 0.
   ValAju = 0.
   x-Saldo-A = 0.
   IF x-Nota = "*" THEN DO :
      FOR EACH cb-dbal NO-LOCK WHERE cb-dbal.CodCia = cb-codcia AND 
                                     cb-dbal.TpoBal = "1"       AND
                                     cb-dbal.CodBal = s-CodBal  AND                                  
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
                               ii,                        
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
                               ii,                        
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
                                                       
            M-I = IF R-Tipo = 2 THEN 0 ELSE ii.
            
            FIND cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND
                               cb-acmd.Periodo = s-Periodo AND
                               cb-acmd.CodCta  = x-CodAux AND 
                               cb-acmd.coddiv  = "" NO-LOCK NO-ERROR .
            IF AVAIL cb-acmd THEN DO:     
               DO I = M-I TO ii :
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
  IF I-FORMATO = 1 THEN ValAju = ValHis.
     ELSE ValAju = ValAju + ValHis.
     
  FIND T-BAL WHERE t-bal.Orden = ConActivo NO-ERROR.
  IF NOT AVAILABLE T-BAL THEN DO :      
     CREATE T-BAL.
     T-BAL.ForBal   = cb-nbal.ForBal.
     T-BAL.Orden    = ConActivo.
     T-BAL.Item     = x-Item.            
  END.
  T-BAL.Glosa = cb-nbal.Glosa.
  T-BAL.Nota  = x-Nota.                       
  T-BAL.a-Import[ii - (C-MesIni - 1)] = ValAju.     
  
  x-Rowid = ROWID(T-BAL).        
                           
  RUN CALCULA-SUMAS (x-Rowid, x-Nota, ValAju, x-Rowidn, ii - (C-MesIni - 1), cb-nbal.ForBal).
  
END.

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
DEFINE INPUT PARAMETER pNota   AS CHAR.
DEFINE INPUT PARAMETER nValAju AS DECIMAL.
DEFINE INPUT PARAMETER nRowid  AS ROWID.
DEFINE INPUT PARAMETER nii     AS INTEGER.
DEFINE INPUT PARAMETER nForBal AS CHAR.

DEFINE VAR ff AS INTEGER.

FIND T-BAL WHERE ROWID(T-BAL) = pRowid.
FIND B-CB-NBAL WHERE ROWID(B-CB-NBAL) = nRowid.

IF pNota = "*" THEN DO :   
    x-AcumQ1[nii] = x-AcumQ1[nii] + nValAju.                   
    x-AcumQ2[nii] = x-AcumQ2[nii] + nValAju.
    x-AcumQ3[nii] = x-AcumQ3[nii] + nValAju.
    x-AcumQ4[nii] = x-AcumQ4[nii] + nValAju.
    x-TotGen[nii] = x-TotGen[nii] + nValAju.
END.   

IF pNota = "Q1" THEN DO :
   a-Import[nii] = x-AcumQ1[nii]. 
END.

IF pNota = "Q2" THEN DO :
   a-Import[nii] = x-AcumQ2[nii]. 
END.

IF pNota = "Q3" THEN DO :
   a-Import[nii] = x-AcumQ3[nii].    
END.   

IF pNota = "C1" THEN DO :
   CASE B-CB-NBAL.SigOpe :
        WHEN "*" THEN DO :        
             a-Import[nii] = ROUND(x-AcumQ1[nii] * B-CB-NBAL.ImpOpe, 2).
        END. 
        WHEN "+" THEN DO :        
             a-Import[nii] = x-AcumQ1[nii] + B-CB-NBAL.ImpOpe.
        END. 
   END CASE.                
   x-TotGen[nii] = x-TotGen[nii] + a-Import[nii].
END.


IF pNota = "RE" THEN DO :
   a-Import[nii] = a-total[nii] - x-TotGen[nii].
   x-TotGen[nii] = x-TotGen[nii] + a-Import[nii].
END.  


IF pNota = "TG" THEN DO :
   a-Import[nii] = x-TotGen[nii]. 
END.   
   
IF pNota = "I1" THEN DO : 
   x-AcumQ1 [nii] = 0.
END.

IF pNota = "I2" THEN DO :   
   x-AcumQ2[nii] = 0.
END.

IF pNota = "I3" THEN DO :   
   x-AcumQ3[nii] = 0.
END.

IF B-CB-NBAL.total% THEN DO :  
   IF nForBal = "Activo" THEN a-total[nii] = a-import[nii].
      ELSE p-total[nii] = a-import[nii].
   
   a-total[7] = 0.
   DO ff = 1 TO 6 :
      a-total[7] = a-total[7] + a-import[ff].
   END.   
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
  DISPLAY C-FORMATO C-mesIni R-Tipo c-moneda C-mesFin F-CodDiv 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 b-cb-cfgd C-FORMATO C-mesIni R-Tipo Btn_OK c-moneda 
         Btn_Cancel C-mesFin F-CodDiv 
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

DEFINE VAR iCon AS INTEGER.

ConPasivo = 0.
ConActivo = 0.

FOR EACH cb-nbal NO-LOCK WHERE cb-nbal.CodCia = cb-codcia AND 
                               cb-nbal.TpoBal = "1"       AND
                               cb-nbal.CodBal = s-CodBal
                               BREAK BY cb-nbal.ForBal 
                                     BY cb-nbal.item :
    IF FIRST-OF(cb-nbal.ForBal) THEN DO :
       DO iCon = 1 TO 13 :
            x-AcumQ1[icon] = 0.
            x-AcumQ2[icon] = 0.
            x-AcumQ3[icon] = 0.
            x-AcumQ4[icon] = 0.
            x-TotGen[icon] = 0.
       END.
    END.
    
    x-Mensaje = cb-nbal.GLOSA.
    DISPLAY x-mensaje WITH FRAME f-mensaje.
    PAUSE 0.
    RUN CALCULA-NOTA(cb-nbal.Item, cb-nbal.Nota, ROWID(cb-nbal)). 
       
END. /*Fin del For Each*/

FOR EACH T-BAL BREAK BY T-BAL.ForBal :
    x-Mensaje = "Totales y Porcentajes".
    DISPLAY x-mensaje WITH FRAME f-mensaje.
    PAUSE 0. 
    DO ii = 1 TO 6 : 
       a-import[7] = a-import[7] + a-import[ii].
    END.
   
    DO ii = 1 TO 7 :   
       IF T-bal.ForBal = "Activo" THEN DO :
          IF a-import[ii] <> 0 THEN a-Porcen[ii] = ROUND((a-import[ii] * 100) / a-total[ii], 2).    
             ELSE a-Porcen[ii] = 0.
       END.
       ELSE DO :
          IF a-import[ii] <> 0 THEN a-Porcen[ii] = ROUND((a-import[ii] * 100) / p-total[ii], 2).    
             ELSE a-Porcen[ii] = 0.       
       END.      
    END.   
END.

HIDE FRAME f-Mensaje.

CASE I-FORMATO :
   WHEN 1 THEN RUN IMPRE-01.
   WHEN 2 THEN RUN IMPRE-01.
END.   
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
  DEFINE VAR x-Import  AS CHAR EXTENT 13.
  DEFINE VAR x-Porcen  AS CHAR EXTENT 13.
  DEFINE VAR x-Glosa   AS CHAR.
  DEFINE VAR NomMes    AS CHAR FORMAT "X(240)".
  DEFINE VAR Encabe    AS CHAR EXTENT 7 FORMAT "X(240)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MESFIN, OUTPUT Encabe[1] ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MESFIN), 1, OUTPUT NomMes  ).    
  Encabe[2] = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Encabe[3] = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Encabe[3] = "(EXPRESADO EN DOLARES)".

  IF R-TIPO = 1  THEN Encabe[4] = C-FORMATO + " (MENSUAL)".
                 ELSE Encabe[4] = C-FORMATO + " (ACUMULADO)".
  
  Encabe[5] = "                                         **************** ********** **************** ********** **************** ********** **************** ********** **************** ********** **************** ********** **************** **********".
  Encabe[6] = "                                         NOVIEMBRE        PCJE %     DICIEMBRE        PCJE %     DICIEMBRE        PCJE %     DICIEMBRE        PCJE %     DICIEMBRE        PCJE %     DICIEMBRE        PCJE %     TOTAL            PCJE %    ".
  Encabe[7] = "                                         **************** ********** **************** ********** **************** ********** **************** ********** **************** ********** **************** ********** **************** **********".
  Encabe[6] = FILL(" ",41).
  
  DO ii = 1 TO 6 :     
     RUN bin/_mes.p ( INPUT ii + C-MesIni - 1, 1, OUTPUT NomMes).
     NomMes = FILL(" ", 16 - LENGTH(NomMes)) + NomMes + " ".
     Encabe[6] = Encabe[6] + NomMes.
     Encabe[6] = Encabe[6] + FILL(" ", 10 - LENGTH("PCJE %")) + "PCJE %" + " ".
  END.
  NomMes = "TOTAL".
  NomMes = FILL(" ", 16 - LENGTH(NomMes)) + NomMes + " ".
  Encabe[6] = Encabe[6] + NomMes.
  Encabe[6] = Encabe[6] + FILL(" ", 10 - LENGTH("PCJE %")) + "PCJE %" + " ".
  
  RUN BIN/_centrar.p ( INPUT Encabe[1], 240 , OUTPUT Encabe[1]).
  RUN BIN/_centrar.p ( INPUT Encabe[2], 240 , OUTPUT Encabe[2]).
  RUN BIN/_centrar.p ( INPUT Encabe[3], 240 , OUTPUT Encabe[3]).
  RUN BIN/_centrar.p ( INPUT Encabe[4], 240 , OUTPUT Encabe[4]).
  
  DEFINE FRAME f-cab
  x-Glosa  NO-LABEL FORMAT "X(40)"
  x-Import[1] COLUMN-LABEL "NOVIEMBRE" FORMAT "X(16)"
  x-Porcen[1] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"
  x-Import[2] COLUMN-LABEL "DICIEMBRE" FORMAT "X(16)"
  x-Porcen[2] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"
  x-Import[3] COLUMN-LABEL "DICIEMBRE" FORMAT "X(16)"
  x-Porcen[3] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"
  x-Import[4] COLUMN-LABEL "DICIEMBRE" FORMAT "X(16)"
  x-Porcen[4] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"
  x-Import[5] COLUMN-LABEL "DICIEMBRE" FORMAT "X(16)"
  x-Porcen[5] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"
  x-Import[6] COLUMN-LABEL "DICIEMBRE" FORMAT "X(16)"
  x-Porcen[6] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"
  x-Import[7] COLUMN-LABEL "TOTAL  "  FORMAT "X(16)"
  x-Porcen[7] COLUMN-LABEL "PCJE % "  FORMAT "X(10)"  
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA : " + STRING(TODAY,"99/99/9999") FORMAT "X(20)" TO 218 SKIP
  "DIVISION : " F-CODDIV

  "HORA  : " + STRING(TIME,"HH:MM") FORMAT "X(15)" TO 221 SKIP 
  Encabe[1] SKIP
  Encabe[2] SKIP
  Encabe[3] SKIP
  Encabe[4] SKIP(1)
  Encabe[5] SKIP
  Encabe[6] SKIP
  Encabe[7] SKIP
  WITH WIDTH 240 NO-LABELS NO-UNDERLINE NO-BOX DOWN STREAM-IO.  

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
      x-Glosa = T-BAL.Glosa.      
      DO ii = 1 TO 7 :
         x-Porcen[ii] = IF T-BAL.a-Porcen[ii] = 0 THEN "" 
                        ELSE STRING(T-BAL.a-Porcen[ii],"(ZZ9.99)").
      END. 
      CASE T-bal.Nota :
         WHEN "RS" THEN x-Import = FILL("-",16).
         WHEN "RD" THEN x-Import = FILL("=",16).
         WHEN "NE" THEN x-Glosa  = {&Prn6a} + x-Glosa + {&Prn6b}.
         OTHERWISE DO :
            DO ii = 1 TO 7 :
               x-Import[ii] = IF T-BAL.a-Import[ii] = 0 THEN "" 
                                 ELSE STRING(T-BAL.a-Import[ii],"(ZZZ,ZZZ,ZZ9.99)").
            END.                  
         END.                        
      END CASE.
             
      DISPLAY STREAM REPORT SPACE(34)
                            x-Glosa
                            x-Import[1]
                            x-Porcen[1]
                            x-Import[2]
                            x-Porcen[2]
                            x-Import[3]
                            x-Porcen[3]
                            x-Import[4]
                            x-Porcen[4]
                            x-Import[5]
                            x-Porcen[5]
                            x-Import[6]
                            x-Porcen[6]
                            x-Import[7]
                            x-Porcen[7]
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

  C-mesIni:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(s-NroMes,"99").
  C-mesFin:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(s-NroMes,"99").  
  
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


