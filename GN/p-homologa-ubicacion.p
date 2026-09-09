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

DEF INPUT PARAMETER pCodCia AS INTE.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodUbi AS CHAR.
    
/* *********************************************************************** */
/* RHC 17/03/2021 homologación de ubicaciones */
/* *********************************************************************** */
/* NOTA: Como esta rutina es disparada a travéz de un WRITE PROCEDURE
        hay que desactivar el trigger para que no entre en loop */
        
DEF BUFFER b-almacen FOR almacen.
DEF BUFFER b-almmmate FOR almmmate.
DEF BUFFER b-vtatabla FOR vtatabla.

DISABLE TRIGGERS FOR LOAD OF b-almmmate.

/* Es un almacén principal? */
/*MESSAGE 'UNO' pcodalm.*/
FIND b-almacen WHERE b-almacen.codcia = pCodCia
    AND b-almacen.codalm = pCodAlm
    AND b-almacen.almprincipal = TRUE
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-almacen THEN RETURN 'OK'.

/*MESSAGE 'DOS'.*/
DEF VAR x-Rowid AS ROWID NO-UNDO.
FOR EACH b-VtaTabla NO-LOCK WHERE b-VtaTabla.CodCia = pCodCia
    AND b-VtaTabla.Llave_c1 = pCodAlm
    AND b-VtaTabla.Tabla = 'HOM_UBIC'
    AND b-VtaTabla.Llave_c2 <> pCodAlm:
    /*MESSAGE 'TRES' b-VtaTabla.Llave_c2 .*/
    FIND b-almmmate WHERE b-almmmate.codcia = pCodCia
        AND b-almmmate.codalm = b-VtaTabla.Llave_c2 
        AND b-almmmate.codmat = pCodMat
        NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE b-almmmate OR b-almmmate.codubi = pCodUbi THEN NEXT.
    x-Rowid = ROWID(b-almmmate).
    {lib/lock-genericov3.i ~
        &Tabla="b-almmmate" ~
        &Condicion="ROWID(b-almmmate) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN 
        b-almmmate.codubi = pCodUbi.
END.
IF AVAILABLE(b-almmmate) THEN RELEASE b-almmmate.
/* *********************************************************************** */
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


