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

DEFINE VAR x-DBname AS CHAR.
DEFINE VAR x-LDname AS CHAR.
DEFINE VAR x-IP     AS CHAR.
DEFINE VAR x-PORT   AS CHAR.
DEFINE VAR x-User   AS CHAR.
DEFINE VAR x-Pass   AS CHAR.

DEFINE VAR s-codcia AS INT INIT 1. 

DEFINE VAR x-conexion-ok AS LOG.
             
x-user = 'admin'.
FIND FIRST integral.factabla WHERE integral.factabla.codcia = s-codcia AND
                    integral.factabla.tabla = 'TDAS-UTILEX' AND 
                    integral.factabla.codigo = '00501' NO-LOCK NO-ERROR.

IF AVAILABLE factabla THEN DO:
    x-DBname = "integral".
    x-LDname = "DBTDA".  /* + TRIM(factabla.codigo). */
    x-ip = TRIM(factabla.campo-c[1]).
    x-port = TRIM(factabla.campo-c[2]).
    x-Pass = TRIM(factabla.campo-c[3]).

    x-conexion-ok = NO.

    RUN lib/p-connect-db.p(INPUT x-DBname, INPUT x-LDname, INPUT x-ip, 
                         INPUT x-port, INPUT x-user, INPUT x-pass, OUTPUT x-conexion-ok).

    IF x-conexion-ok = YES THEN DO:
        RUN vtamin/w-vales-consumidos.w.
    END.
    ELSE DO:
        MESSAGE "Nose puede conectar a la base de datos " SKIP
                "Server " + x-ip + " puerto " + x-port SKIP
                "Por favor comuniquese con el area de soporte".
    END.

END.
ELSE DO:
    MESSAGE "No existe configiracion del servidor de Utilex".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


