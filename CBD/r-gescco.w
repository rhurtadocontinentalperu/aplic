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
       FIELD a-Porcen    AS DECIMAL FORMAT "(ZZ9,99)"  
       FIELD p-Porcen    AS DECIMAL FORMAT "(ZZ9,99)"
       FIELD a-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)"  
       FIELD p-Import    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".

DEFINE BUFFER B-ACMD FOR cb-acmd.
DEFINE BUFFER B-CB-NBAL FOR CB-NBAL.

DEFINE VAR R-NBAL AS ROWID.

DEFINE VAR a-Total AS DECIMAL.
DEFINE VAR p-Total AS DECIMAL.

DEFINE FRAME f-mensaje x-Mensaje WITH NO-LABEL VIEW-AS DIALOG-BOX
       CENTERED TITLE "Calculando ... Espere un momento ...".

DEFINE VAR x-AcumQ1  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ2  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ3  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ4  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-TotGen  AS DECIMAL EXTENT 10 INITIAL 0.

DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS x-Cco R-Tipo c-moneda Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-Cco C-mes R-Tipo FILL-IN-NomAux c-moneda 

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

DEFINE VARIABLE FILL-IN-NomAux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE x-Cco AS CHARACTER FORMAT "X(256)":U 
     LABEL "C. Costo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-Cco AT ROW 3.12 COL 15 COLON-ALIGNED
     C-mes AT ROW 1.19 COL 15 COLON-ALIGNED
     R-Tipo AT ROW 2.15 COL 17 NO-LABEL
     FILL-IN-NomAux AT ROW 3.12 COL 24 COLON-ALIGNED NO-LABEL
     c-moneda AT ROW 4.27 COL 17 NO-LABEL
     Btn_OK AT ROW 5.62 COL 3
     Btn_Cancel AT ROW 5.65 COL 15.86
     "Moneda" VIEW-AS TEXT
          SIZE 5.86 BY .69 AT ROW 4.27 COL 11
     SPACE(55.42) SKIP(2.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Impresión de Estados de Gestión  Configurados".


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
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX C-mes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAux IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Impresión de Estados de Gestión  Configurados */
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
  ASSIGN C-mes c-moneda R-tipo x-Cco.
  IF x-Cco = "" 
  THEN DO:        
    MESSAGE 'Ingrese el centro de costo' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO x-Cco.
    RETURN NO-APPLY.
  END.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Cco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Cco D-Dialog
ON LEAVE OF x-Cco IN FRAME D-Dialog /* C. Costo */
DO:
  ASSIGN 
    x-Cco
    FILL-IN-NomAux:SCREEN-VALUE = ''.
  IF x-Cco <> "" THEN DO:        
    FIND cb-auxi WHERE Cb-auxi.codcia = 0
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = x-Cco
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN DO:
        MESSAGE "Centro de costo " + x-Cco + " No Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomAux:SCREEN-VALUE = CB-AUXI.NomAux.
  END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Cco D-Dialog
ON LEFT-MOUSE-DBLCLICK OF x-Cco IN FRAME D-Dialog /* C. Costo */
OR F8 OF x-Cco
DO:
  ASSIGN
    input-var-1 = 'CCO'
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/c-auxil ('Centro de Costos').
  IF output-var-1 <> ?
  THEN DO:
    FIND cb-auxi WHERE ROWID(cb-auxi) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi
    THEN DO:
        SELF:SCREEN-VALUE = cb-auxi.codaux.
        RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CALCULA-GASTOS-INDIRECTOS D-Dialog 
PROCEDURE CALCULA-GASTOS-INDIRECTOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-RowidN AS ROWID.
  
  DEF VAR M-I AS INT NO-UNDO.
  DEF VAR ValHis AS DEC NO-UNDO.
  DEF VAR ValAju AS DEC NO-UNDO.
  DEF VAR x-Rowid AS ROWID NO-UNDO.
  
  CREATE T-BAL.
  ASSIGN        
    ConActivo = ConActivo + 1
    T-BAL.Orden = ConActivo
    T-BAL.Nota  = 'NE'
    T-BAL.Glosa = 'Gastos Indirectos'.

  M-I = IF R-Tipo = 2 THEN 1 ELSE C-MES.
  FOR EACH CB-CCDDG WHERE cb-ccddg.codcia = s-codcia
        AND cb-ccddg.periodo = s-periodo
        AND cb-ccddg.nromes >= M-I
        AND cb-ccddg.nromes <= C-MES
        AND cb-ccddg.ccoD = x-Cco
        BREAK BY cb-ccddg.ccoD BY cb-ccddg.cco:
    IF FIRST-OF(CB-CCDDG.CcoD) OR FIRST-OF (CB-CCDDG.Cco)
    THEN ASSIGN
            ValHis = 0
            ValAju = 0.
    IF c-Moneda = 1
    THEN ASSIGN
            ValHis = ValHis - CB-CCDDG.ImpGtoMn.
    ELSE ASSIGN
            ValHis = ValHis - CB-CCDDG.ImpGtoMe.
    IF LAST-OF (CB-CCDDG.CcoD) OR LAST-OF(CB-CCDDG.Cco)
    THEN DO:
        FIND Cb-Auxi WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = cb-ccddg.cco
            NO-LOCK NO-ERROR.
        CREATE T-BAL.
        ASSIGN        
            ConActivo = ConActivo + 1
            T-BAL.Orden    = ConActivo
            T-BAL.Nota  = '*'
            T-BAL.a-Import = ValHis
            T-BAL.p-Import = ValAju.
        IF AVAILABLE Cb-Auxi THEN T-BAL.Glosa = Cb-Auxi.NomAux.
        x-Rowid = ROWID(T-BAL).
        RUN CALCULA-SUMAS (x-Rowid, '*', ValHis, ValAju, x-RowidN).
    END.
  END.
  /* Raya Simple */
  CREATE T-BAL.
  ASSIGN        
    ConActivo = ConActivo + 1
    T-BAL.Orden = ConActivo
    T-BAL.Nota  = 'RS'
    x-Rowid = ROWID(T-BAL).
  RUN CALCULA-SUMAS (x-Rowid, 'RS', ValHis, ValAju, x-RowidN).
  /* Sub Total */
  CREATE T-BAL.
  ASSIGN        
    ConActivo = ConActivo + 1
    T-BAL.Orden = ConActivo
    T-BAL.Nota  = 'Q3'
    x-Rowid = ROWID(T-BAL).
  RUN CALCULA-SUMAS (x-Rowid, 'Q3', ValHis, ValAju, x-RowidN).
  /* TOTAL GENERAL */
  CREATE T-BAL.
  ASSIGN        
    ConActivo = ConActivo + 1
    T-BAL.Orden = ConActivo
    T-BAL.Nota  = 'RD'
    x-Rowid = ROWID(T-BAL).
  RUN CALCULA-SUMAS (x-Rowid, 'RD', ValHis, ValAju, x-RowidN).
  CREATE T-BAL.
  ASSIGN        
    ConActivo = ConActivo + 1
    T-BAL.Orden = ConActivo
    T-BAL.Nota  = 'TG'
    x-Rowid = ROWID(T-BAL).
  RUN CALCULA-SUMAS (x-Rowid, 'TG', ValHis, ValAju, x-RowidN).
  
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
DEFINE INPUT PARAMETER x-ROWIDN AS ROWID.

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
                                  cb-dbal.TpoBal = "2"      AND
                                  cb-dbal.CodBal = s-CodBal AND                                  
                                  cb-dbal.Item   = x-Item :                             
       nTotal = 0.
       x-CodCta = cb-dbal.CodCta.
       x-Signo  = cb-dbal.Signo.
       x-Metodo = cb-dbal.Metodo.
       x-CodAux = cb-dbal.CodAux.
       IF LOOKUP(x-Metodo,"X,Y") > 0 THEN 
          RUN cbd/cbd_impb.p(  s-Codcia, 
                           TRIM(x-CodCta),
                           '',      /*TRIM(f-CodDiv),*/
                           s-periodo,                        
                           s-NroMes,                        
                           C-moneda,
                           OUTPUT impca1, 
                           OUTPUT impca2, 
                           OUTPUT impca3,
                           OUTPUT impca4 ).
       ELSE     
          RUN cbd/cbd_impc (  s-Codcia, 
                           TRIM(x-CodCta),
                           '',      /*TRIM(f-CodDiv),*/
                           s-periodo,                        
                           s-NroMes,                        
                           C-moneda,
                           R-Tipo,
                           x-Cco,
                           "",      /* Operación */
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
                           cb-acmd.CodCta  = x-CodAux /*AND 
                           cb-acmd.coddiv  BEGINS F-CodDiv*/ NO-LOCK NO-ERROR .
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

 ConActivo = ConActivo + 1.
 FIND T-BAL WHERE t-bal.Orden = ConActivo NO-ERROR.
 IF NOT AVAILABLE T-BAL THEN DO :      
    CREATE T-BAL.
    T-BAL.Orden    = ConActivo.
    T-BAL.Item     = x-Item.            
 END.
 T-BAL.Glosa = cb-nbal.Glosa.
 T-BAL.Nota  = x-Nota.            

 T-BAL.a-Import = ValHis.
 T-BAL.p-Import = ValAju.

 x-Rowid = ROWID(T-BAL).

 RUN CALCULA-SUMAS (x-Rowid, x-Nota, ValHis, ValAju, x-ROWIDN).

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
DEFINE INPUT PARAMETER nValHis AS DECIMAL.
DEFINE INPUT PARAMETER nValAju AS DECIMAL.
DEFINE INPUT PARAMETER nRowid  AS ROWID.

FIND T-BAL WHERE ROWID(T-BAL) = pRowid.
FIND B-CB-NBAL WHERE ROWID(B-CB-NBAL) = nRowid.

IF pNota = "*" THEN DO :   
   x-AcumQ1[1] = x-AcumQ1[1] + nValHis.
   x-AcumQ1[2] = x-AcumQ1[2] + nValAju.
                   
   x-AcumQ2[1] = x-AcumQ2[1] + nValHis.
   x-AcumQ2[2] = x-AcumQ2[2] + nValAju.                         
   
   x-AcumQ3[1] = x-AcumQ3[1] + nValHis.
   x-AcumQ3[2] = x-AcumQ3[2] + nValAju.
             
   x-TotGen[1] = x-TotGen[1] + nValHis.
   x-TotGen[2] = x-TotGen[2] + nValAju.
END.   

IF pNota = "Q1" THEN DO :
   ASSIGN a-Import = x-AcumQ1[1] 
          p-Import = x-AcumQ1[2].
END.

IF pNota = "Q2" THEN DO :
   ASSIGN a-Import = x-AcumQ2[1] 
          p-Import = x-AcumQ2[2].
END.

IF pNota = "Q3" THEN DO :
   ASSIGN a-Import = x-AcumQ3[1] 
          p-Import = x-AcumQ3[2].
END.   


IF pNota = "C1" THEN DO :
   CASE B-CB-NBAL.SigOpe :
        WHEN "*" THEN DO :        
             ASSIGN a-Import = ROUND(x-AcumQ1[1] * B-CB-NBAL.ImpOpe, 2)
                    p-Import = ROUND(x-AcumQ1[2] * B-CB-NBAL.ImpOpe, 2).
        END. 
        WHEN "+" THEN DO :        
             ASSIGN a-Import = x-AcumQ1[1] + B-CB-NBAL.ImpOpe
                    p-Import = x-AcumQ1[2] + B-CB-NBAL.ImpOpe.
        END. 
   END CASE.                
   x-TotGen[1] = x-TotGen[1] + a-Import.
   x-TotGen[2] = x-TotGen[2] + p-Import.
END.

IF pNota = "RE" THEN DO :
END.   

IF pNota = "TG" THEN DO :
   ASSIGN a-Import = x-TotGen[1] 
          p-Import = x-TotGen[2].   
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

IF B-CB-NBAL.total% THEN DO :
   ASSIGN a-total = a-import
          p-total = p-import.
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
  DISPLAY x-Cco C-mes R-Tipo FILL-IN-NomAux c-moneda 
      WITH FRAME D-Dialog.
  ENABLE x-Cco R-Tipo c-moneda Btn_OK Btn_Cancel 
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
ASSIGN
    ConPasivo = 0
    ConActivo = 0
    s-CodBal = "02".    /* Gastos por Centro de Costo */
    
FOR EACH cb-nbal NO-LOCK WHERE cb-nbal.CodCia = 0        
        AND cb-nbal.TpoBal = "2"      
        AND cb-nbal.CodBal = s-CodBal
        BREAK BY cb-nbal.item :     
    x-Mensaje = cb-nbal.GLOSA.
    DISPLAY x-mensaje WITH FRAME f-mensaje.
    PAUSE 0.
    RUN CALCULA-NOTA(cb-nbal.Item, cb-nbal.Nota, ROWID(cb-nbal)).            
END. /*Fin del For Each*/

/* AHORA AGREGAMOS LOS GASTOS INDIRECTOS */
FIND FIRST CB-NBAL WHERE CB-NBAL.CodCia = 0
    AND CB-NBAL.TpoBal = '2'
    AND CB-NBAL.CodBal = s-CodBal
    NO-LOCK NO-ERROR.
IF AVAILABLE CB-NBAL THEN RUN CALCULA-GASTOS-INDIRECTOS (ROWID(CB-NBAL)).

HIDE FRAME f-Mensaje.

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
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo5   AS CHAR FORMAT "X(120)".
  DEFINE VAR NomMes    AS CHAR FORMAT "X(120)".
  
  RUN bin/_dia.p ( INPUT s-periodo, C-MES, OUTPUT Titulo1 ).
  RUN bin/_mes.p ( INPUT INTEGER(C-MES), 1, OUTPUT NomMes  ).    
  Titulo2 = s-NomBal + " AL MES " + " DE " + NomMes + " DE " +  STRING( s-periodo , "9999" ).

  IF c-Moneda = 1 THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  IF R-TIPO = 1  THEN Titulo4 = "MENSUAL".
                 ELSE Titulo4 = "ACUMULADO".

  FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
    AND cb-auxi.clfaux = 'CCO'
    AND cb-auxi.codaux = x-Cco
    NO-LOCK NO-ERROR.
  Titulo5 = "CENTRO DE COSTO: " + TRIM(x-Cco) + " " + cb-auxi.nomaux.
  RUN BIN/_centrar.p ( INPUT Titulo1, 120 , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, 120 , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, 120 , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, 120 , OUTPUT Titulo4).
  RUN BIN/_centrar.p ( INPUT Titulo5, 120 , OUTPUT Titulo5).
  
  DEFINE FRAME f-cab
  SPACE(34)
  x-Glosa  NO-LABEL FORMAT "X(40)"
  x-Import COLUMN-LABEL "HISTORICO" FORMAT "X(16)"
  HEADER
  {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "x(80)"
  "FECHA  : " AT 98 TODAY AT 108 SKIP
  "HORA   : " AT 98 STRING(TIME,"HH:MM:SS") AT 108 SKIP 
  Titulo1 SKIP
  Titulo2 SKIP
  Titulo3 SKIP
  Titulo4 SKIP
  Titulo5 SKIP(2)
  WITH WIDTH 120 NO-BOX DOWN STREAM-IO.

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
      CASE T-bal.Nota :
         WHEN "RS" THEN x-Import = FILL("-",16).
         WHEN "RD" THEN x-Import = FILL("=",16).
         WHEN "NE" THEN x-Glosa  = {&Prn6a} + x-Glosa + {&Prn6b}.
         OTHERWISE x-Import = IF T-BAL.a-Import = 0 THEN "" 
                                 ELSE STRING(T-BAL.a-Import,"(ZZZ,ZZZ,ZZ9.99)").                                 
      END CASE.
             
      DISPLAY STREAM REPORT SPACE(34)
                            x-Glosa
                            x-Import
                            WITH FRAME f-cab.                            
  END.

/*MLR* ***  
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

    RUN GENERA-TEMPORAL.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN IMPRE-01.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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
/*  IF AVAILABLE GN-DIV THEN F-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-div.CodDiv.*/

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

