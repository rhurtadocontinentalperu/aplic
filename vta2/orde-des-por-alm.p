&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Resume el pedido por division y determina en que estado
                    debería generarse la orden de despacho
    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 4.38
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER s-codmon AS INT.
DEF INPUT PARAMETER s-tpocmb AS DEC.

DEF SHARED TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.
DEF SHARED TEMP-TABLE PEDI    LIKE FacDPedi.
DEF SHARED VAR s-codcia AS INT.

EMPTY TEMP-TABLE T-CPEDI.
/* ACUMULAMOS POR ALMACEN */
FOR EACH PEDI, FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia 
    AND Almacen.codalm = PEDI.AlmDes
    BREAK BY PEDI.AlmDes:
    IF FIRST-OF (PEDI.AlmDes) THEN DO:
        CREATE T-CPEDI.
        ASSIGN
            T-CPEDI.codcia = s-codcia
            T-CPEDI.coddiv = Almacen.coddiv
            T-CPEDI.codalm = PEDI.AlmDes
            T-CPEDI.nroped = STRING(RANDOM(1,999999), '999999')
            T-CPEDI.Glosa  = "OK"
            T-CPEDI.CodMon = s-codmon
            T-CPEDI.TpoCmb = s-tpocmb
            T-CPEDI.flgest = "P".       /* APROBADO */
    END.
    T-CPEDI.ImpTot = T-CPEDI.ImpTot + PEDI.ImpLin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


