&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/* ***************************  Definitions  ************************** */

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'CODIGO'
    FIELD RucCli AS CHAR FORMAT 'x(15)' LABEL 'RUC'
    FIELD DNI AS CHAR FORMAT 'x(15)' LABEL 'DNI'
    FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'CLIENTE'
    FIELD NMRepr AS CHAR FORMAT 'x(100)' LABEL 'NOMBRE REP.LEG.'
    FIELD DRRepr AS CHAR FORMAT 'x(100)' LABEL 'DIRECCION REP.LEG.'
    FIELD DNIRepr AS CHAR FORMAT 'x(15)' LABEL 'DNI REP.LEG.'
    FIELD FNRepr AS DATE FORMAT '99/99/9999' LABEL 'FCH.NAC. REP.LEG.'
    FIELD Aval AS CHAR FORMAT 'x(200)' LABEL 'Aval'
    FIELD Grupo  AS CHAR FORMAT 'x(15)' LABEL 'GRUPO'
    FIELD NomGrupo AS CHAR FORMAT 'x(100)' LABEL 'NOMBRE GRUPO'
    FIELD Departamento AS CHAR FORMAT 'x(30)' LABEL 'DEPARTAMENTO'
    FIELD Desde     AS INTE FORMAT '9999'               LABEL 'CLIENTE DESDE'
    FIELD Saldo    AS DECI FORMAT '->>>,>>>,>>9.99'     LABEL 'DEUDA ACTUAL'
    /* Primer año línea de crédito */
    FIELD LinCredIni AS INTE FORMAT '9999'              LABEL 'CREDITO DESDE'
    /* Línea 15 */
    FIELD LinCred01 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'
    FIELD LinCred02 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'
    FIELD LinCred03 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'
    FIELD LinCred04 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'
    FIELD LinCred05 AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'LC CAMPANA'
    /* Línea 20 */
    FIELD Compras_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS'

    FIELD Protesto AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'PROTESTO'
    FIELD Nros_Protesto AS CHAR FORMAT 'x(40)' LABEL 'LETRAS EN PROTESTO'
    FIELD Qty_Protesto AS INTE FORMAT '>>9' LABEL '#LETRAS EN PROTESTO'
    FIELD Refinanciacion AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'REFINANCIAMIENTO'

    /* Línea 29 */
    FIELD Compras_01_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'
    FIELD Compras_01_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'
    FIELD Compras_01_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 011'
    FIELD Compras_01_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'
    FIELD Compras_01_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'
    FIELD Compras_01_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS'

    /* Línea 35 */
    FIELD Compras_02_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'
    FIELD Compras_02_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'
    FIELD Compras_02_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 011'
    FIELD Compras_02_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'
    FIELD Compras_02_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'
    FIELD Compras_02_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS'

    /* Línea 41 */
    FIELD Compras_03_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'
    FIELD Compras_03_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'
    FIELD Compras_03_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 011'
    FIELD Compras_03_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'
    FIELD Compras_03_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'
    FIELD Compras_03_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS'

    /* Línea 47 */
    FIELD Compras_04_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'
    FIELD Compras_04_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'
    FIELD Compras_04_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 011'
    FIELD Compras_04_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'
    FIELD Compras_04_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'
    FIELD Compras_04_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS'

    /* Línea 53 */
    FIELD Compras_05_01 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 001'
    FIELD Compras_05_02 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 010'
    FIELD Compras_05_06 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 011'
    FIELD Compras_05_03 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 012'
    FIELD Compras_05_04 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS LINEA 013'
    FIELD Compras_05_05 AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'COMPRAS OTRAS LINEAS'

    INDEX Llave01 AS PRIMARY codcli
    INDEX Llave02 grupo
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


