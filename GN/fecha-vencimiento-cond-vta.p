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

DEFINE INPUT PARAMETER pCondVta AS CHAR.
DEFINE INPUT PARAMETER pFechaEmision AS DATE.
DEFINE OUTPUT PARAMETER pFechaVcto AS DATE.

pFechaVcto = pFechaEmision.

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

DEFINE BUFFER x-gn-convt FOR gn-convt.

FIND FIRST x-gn-convt WHERE x-gn-convt.Codig = pCondVta NO-LOCK NO-ERROR.
IF AVAILABLE x-gn-convt THEN DO:

    IF x-gn-convt.libre_f01 <> ?  THEN DO:
        /* Tiene fecha de vcto fijada x la condicion y es mayor a l fecha de emision */
        IF x-gn-convt.libre_f01 > pFechaEmision THEN pFechaVcto = x-gn-convt.libre_f01.
    END.
    ELSE pFechaVcto =  pFechaVcto + INTEGER(ENTRY(NUM-ENTRIES(x-gn-ConVt.Vencmtos),x-gn-ConVt.Vencmtos)).
    /*
    T-CDOCU.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
    T-CDOCU.FchVto = T-CDOCU.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


