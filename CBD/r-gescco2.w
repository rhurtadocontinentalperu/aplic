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

DEFINE VAR s-CodBal AS CHAR INIT "02".
DEFINE VAR r-Tipo   AS INT  INIT 1.
DEFINE VAR x-Mensaje   AS CHAR FORMAT "X(30)".
DEFINE VAR x-Cco    AS CHAR.

DEFINE VAR impca1 AS DECIMAL.
DEFINE VAR impca2 AS DECIMAL.
DEFINE VAR impca3 AS DECIMAL.
DEFINE VAR impca4 AS DECIMAL.
DEFINE VAR impca5 AS DECIMAL.
DEFINE VAR impca6 AS DECIMAL.

DEFINE STREAM REPORT.

DEFINE BUFFER B-ACMD FOR cb-acmd.
DEFINE BUFFER B-CB-NBAL FOR CB-NBAL.

DEFINE VAR R-NBAL AS ROWID.

DEFINE VAR a-Total AS DECIMAL.
DEFINE VAR p-Total AS DECIMAL.
DEFINE VAR ConActivo AS INTEGER.
DEFINE VAR ConPasivo AS INTEGER.

DEFINE FRAME f-mensaje x-Mensaje WITH NO-LABEL VIEW-AS DIALOG-BOX
       CENTERED TITLE "Calculando ... Espere un momento ...".

DEFINE VAR x-AcumQ1  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ2  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ3  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-AcumQ4  AS DECIMAL EXTENT 10 INITIAL 0.
DEFINE VAR x-TotGen  AS DECIMAL EXTENT 10 INITIAL 0.

DEFINE TEMP-TABLE REPORTE
    FIELD CodCia    AS INTEGER
    FIELD Cco       AS CHARACTER
    FIELD Nombre    AS CHARACTER
    FIELD Importe   AS DECIMAL EXTENT 10
    INDEX Llave01 AS PRIMARY CodCia Cco.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-auxi

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 cb-auxi.Codaux cb-auxi.Nomaux 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH cb-auxi ~
      WHERE cb-auxi.CodCia = cb-codcia ~
 AND cb-auxi.Clfaux = "CCO" ~
 AND cb-auxi.Codaux <> "" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH cb-auxi ~
      WHERE cb-auxi.CodCia = cb-codcia ~
 AND cb-auxi.Clfaux = "CCO" ~
 AND cb-auxi.Codaux <> "" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 cb-auxi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 cb-auxi


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 C-mes c-moneda Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-mes c-moneda 

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

DEFINE VARIABLE c-moneda AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 16.14 BY .69 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      cb-auxi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 D-Dialog _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      cb-auxi.Codaux FORMAT "x(8)":U
      cb-auxi.Nomaux FORMAT "x(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 45 BY 11.73
         FONT 4
         TITLE "Seleccion los Centros de Costos con un 'clic'".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-1 AT ROW 1.38 COL 30
     C-mes AT ROW 1.96 COL 8 COLON-ALIGNED
     c-moneda AT ROW 3.31 COL 10 NO-LABEL
     Btn_OK AT ROW 13.12 COL 3
     Btn_Cancel AT ROW 13.15 COL 15.86
     "Moneda" VIEW-AS TEXT
          SIZE 5.86 BY .69 AT ROW 3.31 COL 4
     SPACE(68.70) SKIP(11.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resultado del Mes por Centro de Costo".


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
/* BROWSE-TAB BROWSE-1 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.cb-auxi"
     _Where[1]         = "INTEGRAL.cb-auxi.CodCia = cb-codcia
 AND INTEGRAL.cb-auxi.Clfaux = ""CCO""
 AND INTEGRAL.cb-auxi.Codaux <> """""
     _FldNameList[1]   = INTEGRAL.cb-auxi.Codaux
     _FldNameList[2]   = INTEGRAL.cb-auxi.Nomaux
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resultado del Mes por Centro de Costo */
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
  ASSIGN C-mes c-moneda.
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 
  THEN DO:
    MESSAGE 'Al menos seleccione un registro' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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
        FIND REPORTE WHERE reporte.codcia = s-codcia
            AND reporte.cco = x-cco
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE REPORTE THEN CREATE REPORTE.
        ASSIGN
            REPORTE.codcia = s-codcia
            REPORTE.cco    = x-cco
            REPORTE.nombre = cb-auxi.nomaux
            REPORTE.Importe[6] = REPORTE.Importe[6] + ValHis.
    END.
  END.
  
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
DEFINE OUTPUT PARAMETER x-Importe AS DEC.

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
                          "",       /* Operación */
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
  ValAju = x-Saldo-A.
  ValAju = ValAju + ValHis.

  ConActivo = ConActivo + 1.

  x-Importe = ValHis.    /* OJO */

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
  DISPLAY C-mes c-moneda 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-1 C-mes c-moneda Btn_OK Btn_Cancel 
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
  DEF VAR x-Importe AS DEC.
  DEF VAR n-Items   AS INT.


  FOR EACH REPORTE:
    DELETE REPORTE.
  END.
  
  DO n-Items = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(n-Items) IN FRAME {&FRAME-NAME}
    THEN DO:
        ASSIGN
            x-Cco = CB-AUXI.CodAux
            x-Mensaje = cb-auxi.nomaux.
        DISPLAY x-mensaje WITH FRAME f-mensaje.
        PAUSE 0.
        /* PARA EL ACTIVO */
        ASSIGN
            ConPasivo = 0
            ConActivo = 0.
        FOR EACH cb-nbal NO-LOCK WHERE cb-nbal.CodCia = 0    
                AND cb-nbal.TpoBal = "2"      
                AND cb-nbal.CodBal = s-CodBal
                AND cb-nbal.Nota   = "*"        /* Solo calculos */
                BREAK BY cb-nbal.item :     
            RUN CALCULA-NOTA(cb-nbal.Item, cb-nbal.Nota, ROWID(cb-nbal), OUTPUT x-Importe).            
            FIND REPORTE WHERE reporte.codcia = s-codcia
                AND reporte.cco = x-Cco EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE REPORTE THEN CREATE REPORTE.
            ASSIGN
                REPORTE.codcia = s-codcia
                REPORTE.cco    = x-cco
                REPORTE.nombre = cb-auxi.nomaux.
            CASE CB-NBAL.Item:
                WHEN 0010 OR WHEN 0015 THEN REPORTE.Importe[1] = REPORTE.Importe[1] + x-Importe.
                WHEN 0020 THEN REPORTE.Importe[3] = REPORTE.Importe[3] + x-Importe.
                OTHERWISE REPORTE.Importe[5] = REPORTE.Importe[5] + x-Importe.
            END CASE.
        END. /*Fin del For Each*/
        
        /* AHORA AGREGAMOS LOS GASTOS INDIRECTOS */
        FIND FIRST CB-NBAL WHERE CB-NBAL.CodCia = 0
            AND CB-NBAL.TpoBal = "2"
            AND CB-NBAL.CodBal = s-CodBal
            NO-LOCK NO-ERROR.
        IF AVAILABLE CB-NBAL THEN RUN CALCULA-GASTOS-INDIRECTOS (ROWID(CB-NBAL)).
    END.
  END.
  HIDE FRAME f-Mensaje.
  
  /* TOTALES */
  FOR EACH REPORTE:
    ASSIGN
        reporte.importe[3] = reporte.importe[1] + reporte.importe[2]
        reporte.importe[4] = reporte.importe[3] / reporte.importe[2] * 100
        reporte.importe[7] = reporte.importe[3] + reporte.importe[5] + reporte.importe[6]
        reporte.importe[8] = reporte.importe[7] / reporte.importe[3] * 100.
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
  DEFINE VAR Titulo1   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo2   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo3   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo4   AS CHAR FORMAT "X(120)".
  DEFINE VAR Titulo5   AS CHAR FORMAT "X(120)".
  
  DEFINE VAR s-Ancho AS INT INIT 150.
  DEFINE VAR x-Margen-1 AS DEC.
  DEFINE VAR x-Margen-2 AS DEC.
  
  RUN bin/_mes(c-Mes, 1, OUTPUT Titulo1).
  Titulo1 = "RESULTADO DEL MES DE " + TRIM(Titulo1) + ' ' + STRING(s-Periodo, '9999').
  IF c-Moneda = 1 
  THEN Titulo3 = "(EXPRESADO EN NUEVOS SOLES)".
  ELSE Titulo3 = "(EXPRESADO EN DOLARES)".
  
  RUN BIN/_centrar.p ( INPUT Titulo1, s-Ancho , OUTPUT Titulo1).
  RUN BIN/_centrar.p ( INPUT Titulo2, s-Ancho , OUTPUT Titulo2).
  RUN BIN/_centrar.p ( INPUT Titulo3, s-Ancho , OUTPUT Titulo3).
  RUN BIN/_centrar.p ( INPUT Titulo4, s-Ancho , OUTPUT Titulo4).
  RUN BIN/_centrar.p ( INPUT Titulo5, s-Ancho , OUTPUT Titulo5).
  
  DEFINE FRAME f-cab
    reporte.cco         FORMAT 'x(3)'   COLUMN-LABEL 'CC'
    reporte.nombre      FORMAT 'x(30)'  COLUMN-LABEL 'Descricpion'
    reporte.importe[1]  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL 'Venta!Neta'
    reporte.importe[2]  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL 'Costo de!Venta'
    reporte.importe[3]  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL 'Utilidad!Bruta'
    reporte.importe[4]  FORMAT '->>>,>>9.99'    COLUMN-LABEL 'Margen!%'
    reporte.importe[5]  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL 'Gastos!Directos'
    reporte.importe[6]  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL 'Gastos!Indirectos'
    reporte.importe[7]  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL 'Resultado'
    reporte.importe[8]  FORMAT '->>>,>>9.99'    COLUMN-LABEL 'Margen Total!%'
    HEADER
    s-NomCia FORMAT "x(80)" SKIP
    "FECHA  : " AT 110 TODAY SKIP
    "HORA   : " AT 110 STRING(TIME,"HH:MM:SS") SKIP 
    Titulo1 SKIP
    Titulo2 SKIP
    Titulo3 SKIP
    Titulo4 SKIP
    Titulo5 SKIP(2)
    WITH WIDTH 150 NO-BOX DOWN STREAM-IO.

/*MLR* 10/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
* ***/

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn4} .
 
  FOR EACH REPORTE WHERE REPORTE.codcia = s-codcia BREAK BY REPORTE.codcia BY REPORTE.Cco:      
    DISPLAY STREAM REPORT
        reporte.cco         
        reporte.nombre      
        reporte.importe[1]  
        reporte.importe[2]  
        reporte.importe[3]  
        reporte.importe[4]  
        reporte.importe[5]  
        reporte.importe[6]  
        reporte.importe[7]  
        reporte.importe[8]  
        WITH FRAME F-Cab.
    ACCUMULATE reporte.importe[1] (TOTAL).
    ACCUMULATE reporte.importe[2] (TOTAL).
    ACCUMULATE reporte.importe[3] (TOTAL).
    ACCUMULATE reporte.importe[5] (TOTAL).
    ACCUMULATE reporte.importe[6] (TOTAL).
    ACCUMULATE reporte.importe[7] (TOTAL).
    IF LAST-OF(REPORTE.codcia)
    THEN DO:
        ASSIGN
            x-Margen-1 = (ACCUM TOTAL reporte.importe[3]) / (ACCUM TOTAL reporte.importe[2]) * 100
            x-Margen-2 = (ACCUM TOTAL reporte.importe[7]) / (ACCUM TOTAL reporte.importe[3]) * 100.
        UNDERLINE STREAM REPORT
            reporte.importe[1]  
            reporte.importe[2]  
            reporte.importe[3]  
            reporte.importe[4]  
            reporte.importe[5]  
            reporte.importe[6]  
            reporte.importe[7]  
            reporte.importe[8]  
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            ACCUM TOTAL reporte.importe[1] @ reporte.importe[1]
            ACCUM TOTAL reporte.importe[2] @ reporte.importe[2]
            ACCUM TOTAL reporte.importe[3] @ reporte.importe[3]
            x-Margen-1                     @ reporte.importe[4]
            ACCUM TOTAL reporte.importe[5] @ reporte.importe[5]
            ACCUM TOTAL reporte.importe[6] @ reporte.importe[6]
            ACCUM TOTAL reporte.importe[7] @ reporte.importe[7]
            x-Margen-2                     @ reporte.importe[8]
            WITH FRAME F-Cab.
    END.
  END.
/*MLR* 10/11/07 ***
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-auxi"}

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

