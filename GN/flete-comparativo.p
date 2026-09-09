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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.                                                
/*DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.                                                */
/* DEF OUTPUT PARAMETER F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */ */
/* DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */         */
/* DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.       /* Descuento por evento */                          */
/* DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */        */
DEF OUTPUT PARAMETER f-FleteChen AS DEC.
DEF OUTPUT PARAMETER f-FleteHarold AS DEC.

DEF SHARED VAR s-codcia AS INT.

/*DEF VAR F-PREBAS AS DEC DECIMALS 4.*/
DEF VAR F-PREVTA AS DEC DECIMALS 4.
DEF VAR F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF VAR Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF VAR Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF VAR X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 


DEF VAR s-TpoPed AS CHAR INIT "E".
DEF VAR S-CODCLI AS CHAR INIT '11111111111'.
DEF VAR S-CODMON AS INT INIT 1.
DEF VAR S-CNDVTA AS CHAR INIT '000'.
DEF VAR x-NroDec AS INT INIT 4.
DEF VAR pError AS LOG INIT NO.

/* Factor Chen */
RUN vta2/preciomayorista-cred-v2 (s-TpoPed,
                                  pCodDiv,
                                  s-CodCli,
                                  s-CodMon,
                                  INPUT-OUTPUT s-UndVta,
                                  OUTPUT f-Factor,
                                  s-CodMat,
                                  s-CndVta,
                                  x-CanPed,
                                  x-NroDec,
                                  OUTPUT f-PreBas,
                                  OUTPUT f-PreVta,
                                  OUTPUT f-Dsctos,
                                  OUTPUT y-Dsctos,
                                  OUTPUT z-Dsctos,
                                  OUTPUT x-TipDto,
                                  OUTPUT f-FleteChen,
                                  "",
                                  pError).


/* RUN gn/flete-unitario (s-CodMat,              */
/*                        pCodDiv,               */
/*                        s-CodMon,              */
/*                        f-Factor,              */
/*                        OUTPUT f-FleteHarold). */

RUN vta2/precio-de-venta-eventos (s-TpoPed,
                                  pCodDiv,
                                  s-CodCli,
                                  s-CodMon,
                                  INPUT-OUTPUT s-UndVta,
                                  OUTPUT f-Factor,
                                  s-CodMat,
                                  s-CndVta,
                                  x-CanPed,
                                  x-NroDec,
                                  OUTPUT f-PreBas,
                                  OUTPUT f-PreVta,
                                  OUTPUT f-Dsctos,
                                  OUTPUT y-Dsctos,
                                  OUTPUT x-TipDto,
                                  "",
                                  OUTPUT f-FleteHarold,
                                  pError).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


