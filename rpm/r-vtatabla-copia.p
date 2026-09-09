&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER T-ID AS INTEGER.
DEFINE OUTPUT PARAMETER L-FLG AS LOGICAL.

DISABLE TRIGGERS FOR LOAD OF base1.vtatabla.

L-FLG = NO.
FIND FIRST integral.replog WHERE integral.replog.TransactionID = T-ID NO-LOCK NO-ERROR.
IF AVAILABLE integral.replog THEN DO:
    FIND FIRST base1.vtatabla WHERE base1.vtatabla.codcia = INTEGER(SUBSTRING(integral.replog.keyvalue,1,3)) 
        AND base1.vtatabla.tabla BEGINS SUBSTRING(integral.replog.keyvalue,4,20) 
        AND base1.vtatabla.llave_c1 BEGINS SUBSTRING(integral.replog.keyvalue,24,20)
        AND base1.vtatabla.llave_c2 BEGINS SUBSTRING(integral.replog.keyvalue,44,20)
        AND base1.vtatabla.llave_c3 BEGINS SUBSTRING(integral.replog.keyvalue,64,20)
        EXCLUSIVE-LOCK NO-ERROR.
    CASE integral.replog.Event:
        WHEN 'DELETE' THEN DO:
            IF AVAILABLE base1.vtatabla THEN DO:
               DELETE base1.vtatabla.
               L-FLG = YES.    
            END.
        END.
        WHEN 'WRITE' THEN DO:
            IF NOT AVAILABLE base1.vtatabla THEN CREATE base1.vtatabla.
            RAW-TRANSFER integral.replog.DATARECORD TO base1.vtatabla.
            L-FLG = YES.
        END.
    END CASE.
    RELEASE base1.vtatabla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


