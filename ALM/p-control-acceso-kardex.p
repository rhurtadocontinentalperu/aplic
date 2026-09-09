&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Programa disparador de error

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.


DEF INPUT PARAMETER pParam AS CHAR NO-UNDO. 
/* Ej. GRC|logis/w-mantto-gr-aut-cred */

IF NUM-ENTRIES(pParam,'|') < 2 THEN DO:
    MESSAGE 'Solo acepta 2 parámetros separados por |' SKIP
        'Sintaxis: path|program' 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

DEF VAR pProgram AS CHAR.   /* Programa a ejecutar */
DEF VAR pPath AS CHAR.

ASSIGN
    pPath = ENTRY(1,pParam,'|')
    pProgram = ENTRY(2,pParam,'|')
    .

/* IF LOOKUP(pTipoGR, 'GRC,GRE') = 0 THEN DO:             */
/*     MESSAGE 'El primer parámetro solo puede ser:' SKIP */
/*         'GRC: Guía de Remisión NO Eletrónica' SKIP     */
/*         'GRE: Guía de Remisión Electrónica'            */
/*         VIEW-AS ALERT-BOX WARNING.                     */
/*     RETURN.                                            */
/* END.                                                   */

/* Verificamos usuarios bloqueados */
FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
    AND FacTabla.Tabla = "ALM_KARDEX_ACCESS_DENIDED"
    AND FacTabla.Codigo = s-user-id
    AND FacTabla.Campo-C[1] = s-codalm
    AND TODAY >= FacTabla.Campo-D[1] 
    AND TODAY <= FacTabla.Campo-D[2] 
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    MESSAGE 'Opción restringida' SKIP
        'Consulte con logística' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

pProgram = pPath + '/' + pProgram.

RUN VALUE(pProgram) NO-ERROR.

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
         WIDTH              = 62.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


