&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 02_BPVS  Vendedores
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

DEF BUFFER bGn-Ven FOR pro.gn-ven.
DEF BUFFER bPL-Pers FOR pro.pl-pers.

/* 1.- Borramos tabla */
FOR EACH oSalesPersons EXCLUSIVE-LOCK:
    DELETE oSalesPersons.
END.

/* 2.- Cargamos los vendedores */
CREATE oSalesPersons.
ASSIGN
    oSalesPersons.SalesEmployeeCode = -1
    oSalesPersons.SalesEmployeeName = "Ningún empleado del departamento de ventas".

/* Solo activos */
DEF VAR iCodigo AS INTE NO-UNDO.
FOR EACH bGn-Ven NO-LOCK WHERE bGn-Ven.codcia = 1
    AND bGn-Ven.flgest = "A"
    BY bGn-Ven.CodVen:
    iCodigo = iCodigo + 1.
    CREATE oSalesPersons.
    ASSIGN
        oSalesPersons.SalesEmployeeCode = iCodigo
        oSalesPersons.SalesEmployeeName = SUBSTRING(TRIM(bGn-Ven.NomVen),1,32).
    ASSIGN
        oSalesPersons.CodVen = bGn-Ven.CodVen.

    IF bGn-Ven.Libre_c04 > "" THEN DO:
        FIND FIRST bPL-Pers WHERE bPL-Pers.codper = bGn-Ven.Libre_c04 NO-LOCK NO-ERROR.
        IF AVAILABLE bPL-Pers THEN oSalesPersons.U_CL_NDOC =  bPL-Pers.NroDocId.
    END.
END.

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


