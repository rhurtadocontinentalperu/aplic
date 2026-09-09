&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE A-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat.
DEFINE TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
/* Librerias para PRICING
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


*/
/* ***************************  Definitions  ************************** */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Descuento x Volumen x Saldos */
DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: A-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat
      END-FIELDS.
      TABLE: E-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-PRI_Alerta-de-Margen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Alerta-de-Margen Procedure 
PROCEDURE PRI_Alerta-de-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.                             
DEF OUTPUT PARAMETER pOk AS LOG NO-UNDO.

DEF BUFFER B-ARTICULO FOR Almmmatg.

pOk = NO.
/* ********************************************************************************************** */
/* 1ro. Por Ventas Mayores a n meses: NO pueden ser promociones o regalos */
/* ********************************************************************************************** */
DEF VAR pFchPed AS DATE NO-UNDO.

FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND FacTabla.Tabla = "MMX" NO-LOCK NO-ERROR.

IF AVAILABLE FacTabla AND FacTabla.Valor[1] > 0 THEN DO:
    RUN PRI_Ultima_Venta (INPUT pCodMat, OUTPUT pFchPed).
    IF pFchPed = ? THEN DO:
        /* Puede que sea un producto nuevo, veamos su fecha de registro */
        FIND B-ARTICULO WHERE B-ARTICULO.codcia = s-codcia
            AND B-ARTICULO.codmat = pCodMat NO-LOCK NO-ERROR.
        IF AVAILABLE B-ARTICULO THEN DO:
            IF B-ARTICULO.FchIng <= ADD-INTERVAL(TODAY, ( -1 * INTEGER(FacTabla.Valor[1]) ),'months') 
                THEN pOk = YES.     /* SOlo una Alerta */
        END.
    END.
    ELSE IF pFchPed < ADD-INTERVAL(TODAY, ( -1 * INTEGER(FacTabla.Valor[1]) ),'months') THEN DO:
        pOk = YES.     /* Solo una Alerta */
    END.
END.
/* ********************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_DctoxVolxSaldo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_DctoxVolxSaldo Procedure 
PROCEDURE PRI_DctoxVolxSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Divisiones-Validas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Divisiones-Validas Procedure 
PROCEDURE PRI_Divisiones-Validas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTipoLista AS INT.
DEF OUTPUT PARAMETER pDivisiones AS CHAR.

pDivisiones = "".
CASE pTipoLista:
    WHEN 1 THEN DO:
        /* Ventas Mayoristas Contado y Crédito - Lista General */
        /* Cualquier cambio también afectar triggers/w-almmmatg.p */
        /* RHC 07/08/2020 Increnmentamos en grupo MIN */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'ATL,HOR,INS,MOD,PRO,TDA,INT,B2C,MIN') > 0 AND
            gn-divi.ventamayorista = 1:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
    WHEN 2 THEN DO:
        /* Ventas Minoristas Contado (Utilex) - Lista General */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'MIN') > 0 AND
            gn-divi.ventamayorista = 1:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
    WHEN 3 THEN DO:
        /* Ventas Mayoristas Contado y Crédito - Lista Específica */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'ATL,HOR,INS,MOD,PRO,TDA,INT,B2C') > 0 AND
            gn-divi.ventamayorista = 2:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
    WHEN 4 THEN DO:
        /* Eventos - Lista Específica */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'FER') > 0 AND
            gn-divi.ventamayorista = 2:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Excel-Errores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Excel-Errores Procedure 
PROCEDURE PRI_Excel-Errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR E-MATG.
DEF INPUT PARAMETER TABLE FOR A-MATG.

FIND FIRST E-MATG NO-LOCK NO-ERROR.
FIND FIRST A-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE E-MATG AND NOT AVAILABLE A-MATG THEN RETURN.
MESSAGE 'Los siguientes producto NO se han actualizado o hay una ALERTA' SKIP
    'Se mostrará una lista en Excel'
    VIEW-AS ALERT-BOX INFORMATION.

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFileXls AS CHAR NO-UNDO.

lNuevoFile = YES.

{lib/excel-open-file.i}

DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "ERRORES - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "ERROR".
ASSIGN
    iRow = 2.
FOR EACH E-MATG:
    ASSIGN
        iColumn = 0
        iRow    = iRow + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = E-MATG.codmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = E-MATG.desmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = E-MATG.Libre_c01.
END.
/* 2do ALERTAS */
/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(2).
ASSIGN
    chWorkSheet:Range("A1"):Value = "ALERTAS - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "ALERTA".
ASSIGN
    iRow = 2.
FOR EACH A-MATG:
    ASSIGN
        iColumn = 0
        iRow    = iRow + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = A-MATG.codmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = A-MATG.desmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = A-MATG.Libre_c01.
END.
lCerrarAlTerminar = NO.     /* Hace visible y editable la hoja de cálculo */
lMensajeAlTerminar = NO.

{lib/excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

