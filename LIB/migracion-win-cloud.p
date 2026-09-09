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

DEFINE INPUT PARAMETER pDBfisica AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pDBlogica AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pPuerto AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pIPOrigen AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pOtrosDatos AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCadenaDeConexion AS CHAR NO-UNDO.

DEFINE VAR cTabla AS CHAR NO-UNDO.
DEFINE VAR cLlave_c1 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c2 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c3 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c4 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c5 AS CHAR NO-UNDO.

DEFINE VAR cIPDestino AS CHAR NO-UNDO.

cTabla = "CONFIG-CLOUD".
cLlave_c1 = "WIN".

/* La IP destino va ser la misma la del origen en un inicio  */
cIPDestino = pIPOrigen.

/*CONNECT -db integral -ld cissac -N TCP -H 192.168.100.202 -S 65030 - NO-ERROR.*/

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

DEFINE VAR cMigracionActiva AS CHAR.

/* Default */
pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.

RUN migracion-activado(OUTPUT cMigracionActiva).

IF cMigracionActiva <> 'ON' THEN RETURN "OK".

/*  */
RUN redireccionar-ip.
pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.


RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-migracion-activado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE migracion-activado Procedure 
PROCEDURE migracion-activado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

cLlave_c2 = "MIGRACION".
cLlave_c3 = "STATUS".

pRetVal = "OFF".

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND
                            vtatabla.tabla = cTabla AND 
                            vtatabla.llave_c1 = cLlave_c1 AND
                            vtatabla.llave_c2 = cLlave_c2 AND
                            vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

IF NOT AVAILABLE vtatabla THEN RETURN "ADM-ERROR".

pRetVal = TRIM(vtatabla.llave_c4).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-redireccionar-ip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE redireccionar-ip Procedure 
PROCEDURE redireccionar-ip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

cLlave_c2 = "SERVIDORES".
cLlave_c3 = pIPOrigen.

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND
                            vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = cLlave_c1 AND
                            vtatabla.llave_c2 = cLlave_c2 AND
                            vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

IF NOT AVAILABLE vtatabla THEN RETURN "OK".

cIPDestino = TRIM(vtatabla.llave_c4).
                            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

