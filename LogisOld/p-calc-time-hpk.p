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

/* Calcula el tiempo estimado de piqueo (en segundos) */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pRol AS CHAR.   /* Picador, Chequeador,  vacio = ambos */
DEF OUTPUT PARAMETER pSegundosPickeador AS DEC.
DEF OUTPUT PARAMETER pSegundosChequeador AS DEC.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

/* Se supone que el documento es HPK y debe estra clasificado con ACUMULATIVO, 
RACK o ESTANTERIA */
pMensaje = ''.
pSegundosChequeador = 0.
pSegundosPickeador = 0.
FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtacdocu OR Vtacdocu.codped <> 'HPK' THEN DO:
    pMensaje = 'No se ubicó el documento HPK'.
    RETURN.
END.
IF LOOKUP(Vtacdocu.CodTer, 'ACUMULATIVO,RACK,ESTANTERIA') = 0  THEN DO:
    pMensaje = 'El documento ' + Vtacdocu.codped + ' ' + Vtacdocu.nroped + CHR(10) +
                'debería estar clasificado como ACUMULATIVO, RACK o ESTANTERIA'.
    RETURN.
END.
DEF VAR xOk AS LOG NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.
FOR EACH Vtaddocu OF Vtacdocu NO-LOCK, 
    FIRST Almmmatg OF Vtaddocu NO-LOCK:
    FIND FIRST Almmmate WHERE Almmmate.codcia = Vtaddocu.codcia AND
        Almmmate.codalm = Vtaddocu.almdes AND
        Almmmate.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        pMensaje = 'Producto: ' + Vtaddocu.codmat + ' NO está registrado en el almacén: ' + Vtaddocu.almdes.
        xOk = NO.
        LEAVE.
    END.
    /* Busquemos si cumple una regla */
    xOk = NO.
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = Vtacdocu.CodCia AND 
        VtaDTabla.Tabla = 'CFGHPKTIME' AND
        VtaDTabla.Llave = Vtacdocu.CodDiv AND
        VtaDTabla.Tipo = Vtacdocu.CodTer AND
        ( (pRol = "" AND LOOKUP(VtaDTabla.Libre_c04,"CHEQUEADOR,PICADOR") > 0 ) OR (VtaDTabla.Libre_c04 = pRol)):
        /* Sector */
        IF Vtacdocu.CodTer <> 'ACUMULATIVO' THEN DO:
            IF VtaDDocu.CodUbi <> VtaDTabla.Libre_c02 THEN NEXT.
        END.
        /* SubLinea */
        IF VtaDTabla.Libre_c01 > '' AND Almmmatg.subfam <> VtaDTabla.Libre_c01 THEN NEXT.
        /* Linea */
        IF VtaDTabla.LlaveDetalle > '' AND Almmmatg.codfam <> VtaDTabla.LlaveDetalle THEN NEXT.
        /* Calculamos */
        x-CanPed = VtaDDocu.CanPed.     /* OJO: Unidades de STOCK */
        CASE VtaDTabla.Libre_c03:
            WHEN 'MASTER' THEN DO:
                x-CanPed = x-CanPed / Almmmatg.CanEmp.  /* OJO: Unidades MASTER */
            END.
            OTHERWISE DO:
            END.
        END CASE.
        IF VtaDTabla.Libre_c04 = "CHEQUEADOR" THEN 
                pSegundosChequeador = pSegundosChequeador + ( VtaDTabla.Libre_d01 * x-CanPed / VtaDTabla.Libre_d01).
        IF VtaDTabla.Libre_c04 = "PICADOR" THEN 
                pSegundosPickeador = pSegundosPickeador + ( VtaDTabla.Libre_d01 * x-CanPed / VtaDTabla.Libre_d01).
        xOk = YES.
    END.
    IF xOk = NO THEN DO:
        pMensaje = "NO hay una regla definida de tiempo para el código " + VtaDDocu.CodMat.
        RETURN.
    END.
END.

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
         HEIGHT             = 3.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


