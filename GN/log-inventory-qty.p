&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 4.81
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pAccion AS CHAR.
DEF OUTPUT PARAMETER pOk AS LOG.
/*
C: CREATE
D: DELETE 
*/
DEF BUFFER B-CMOV FOR Almcmov.
DEF BUFFER B-DMOV FOR Almdmov.
/* FILTROS */
pOk = YES.
IF LOOKUP(pAccion, 'C,D') = 0 THEN RETURN.
FIND B-CMOV WHERE ROWID(B-CMOV) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CMOV THEN RETURN.
IF LOOKUP(B-CMOV.codalm, '506') = 0 THEN RETURN.
/* FIN DE FILTROS */

DEF VAR x-Factor AS INT NO-UNDO.
pOk = NO.
IF B-CMOV.TipMov = "I" THEN x-Factor = 1.
ELSE x-Factor = -1.
IF pAccion = "D" THEN x-Factor = x-Factor * -1.
FOR EACH B-DMOV OF B-CMOV NO-LOCK:
    CREATE le_inventory_qty.
    ASSIGN
        le_inventory_qty.CodCia = B-DMOV.codcia
        le_inventory_qty.Item_FReg = TODAY
        le_inventory_qty.Item_HReg = STRING(TIME, 'HH:MM:SS')
        le_inventory_qty.Item_Qty = x-Factor * (B-DMOV.candes * B-DMOV.factor)
        le_inventory_qty.Item_Sku = B-DMOV.codmat.
END.
RELEASE le_inventory_qty.
pOk = YES.  /* Todo bien */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


