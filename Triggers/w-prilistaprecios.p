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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

TRIGGER PROCEDURE FOR WRITE OF PriListaPrecios.

/* Actualizamos Promociones ACTIVAS */
FOR EACH pridctoprom OF prilistaprecios 
    WHERE (pridctoprom.FchIni >= TODAY OR TODAY <= pridctoprom.FchFin) EXCLUSIVE-LOCK:
    pridctoprom.Precio = ROUND(prilistaprecios.PreUni * (1 - (pridctoprom.Descuento / 100)), 4).
END.

DEF VAR x-Orden AS INT NO-UNDO.
FOR EACH PriDctoVol OF prilistaprecios
    WHERE (pridctovol.FchIni >= TODAY OR TODAY <= pridctovol.FchFin) EXCLUSIVE-LOCK:
    DO x-Orden = 1 TO 10:
        PriDctoVol.DtoVolP[x-Orden] = ROUND(prilistaprecios.PreUni * ( 1 - (PriDctoVol.DtoVolD[x-Orden] / 100)), 4).
        IF PriDctoVol.DtoVolR[x-Orden] <= 0 THEN PriDctoVol.DtoVolP[x-Orden] = 0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


