&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Determinar el orden de prioridad de atencion de los almacenes

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

DEF INPUT PARAMETER s-CodDiv AS CHAR.
DEF INPUT PARAMETER s-FlgEnv AS LOG.
DEF INPUT PARAMETER s-CodCli AS CHAR.
DEF OUTPUT PARAMETER s-CodAlm AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = s-codcli NO-LOCK NO-ERROR.

/* LOS ALMACENES SE ORDENAN DE ACUERDO AL ORDEN DE PRIORIDAD */
s-codalm = "".
IF s-FlgEnv = NO THEN DO:     /* SOLO VALEN LOS ALMACENES DE LA DIVISION */
    FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
        AND Vtaalmdiv.coddiv = s-coddiv,
        FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.coddiv = s-coddiv
        BY VtaAlmDiv.Orden:
        IF s-codalm  = '' THEN s-codalm = Vtaalmdiv.codalm.
        ELSE s-codalm = s-codalm + ',' + Vtaalmdiv.codalm.
    END.
END.
ELSE DO:                      /* TODOS LOS ALMACENES CONFIGURADOS */
    /* PRIORIDAD SEDE QUE ATIENDA AL CLIENTE */
    IF s-codcli <> '' AND AVAILABLE gn-clie THEN DO:
        FOR EACH VtaUbiDiv WHERE Vtaubidiv.codcia = s-codcia
            AND VtaUbiDiv.CodDept = gn-clie.coddept
            AND VtaUbiDiv.CodDist = gn-clie.coddist
            AND VtaUbiDiv.CodProv = gn-clie.codprov:
            FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
                AND Vtaalmdiv.coddiv = s-coddiv,
                FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.coddiv = VtaUbiDiv.coddiv
                BY VtaAlmDiv.Orden:
                IF s-codalm  = '' THEN s-codalm = Vtaalmdiv.codalm.
                ELSE s-codalm = s-codalm + ',' + Vtaalmdiv.codalm.
            END.
        END.
    END.
    /* CARGAMOS EL RESTO DE ALMACENES */
    FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
        AND Vtaalmdiv.coddiv = s-coddiv
        BY VtaAlmDiv.Orden:
        IF LOOKUP(Vtaalmdiv.codalm, s-codalm) > 0 THEN NEXT.
        IF s-codalm  = '' THEN s-codalm = Vtaalmdiv.codalm.
        ELSE s-codalm = s-codalm + ',' + Vtaalmdiv.codalm.
    END.
END.
/* FIN DE CARGA DE ALMACENES */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


