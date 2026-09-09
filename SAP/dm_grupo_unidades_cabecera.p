&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tbUnidadesCab NO-UNDO LIKE oMaestroGrupoUnidadesMedidaCab.



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

DEF INPUT PARAMETER pcProceso AS CHAR NO-UNDO.

CASE pcProceso:
    WHEN "To-Table" THEN RUN To-Table.
    WHEN "To-Text"  THEN RUN To-Text.
END CASE.

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
   Temp-Tables and Buffers:
      TABLE: tbUnidadesCab T "?" NO-UNDO INTEGRAL oMaestroGrupoUnidadesMedidaCab
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-To-Table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE To-Table Procedure 
PROCEDURE To-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1.- Adicionamos o Actualizamos (y verificamos por si acaso duplicados) solo ACTIVOS */
DEF VAR iContador AS INTE NO-UNDO.

DO TRANSACTION:
    DELETE FROM oMaestroGrupoUnidadesMedidaCab.
END.

DEF BUFFER bUnidadesCab FOR oMaestroGrupoUnidadesMedidaCab.

/* 1.- Las unidades básicas de stock */
FOR EACH pro.Almmmatg NO-LOCK WHERE pro.Almmmatg.codcia = 1 AND pro.Almmmatg.tpoart = "A"
    BREAK BY pro.Almmmatg.undbas:
    IF FIRST-OF(pro.Almmmatg.undbas) THEN DO:
        FIND oMaestroUnidadesDeMedida WHERE oMaestroUnidadesDeMedida.CODE = pro.Almmmatg.undbas
            NO-LOCK NO-ERROR.
        IF AVAILABLE oMaestroUnidadesDeMedida THEN DO:
            iContador = iContador + 1.
            CREATE bUnidadesCab.
            ASSIGN
                bUnidadesCab.AbsEntry = iContador
                bUnidadesCab.CODE = CAPS(pro.Almmmatg.undbas)
                bUnidadesCab.BaseUoM = oMaestroUnidadesDeMedida.AbsEntry
                bUnidadesCab.NAME = oMaestroUnidadesDeMedida.NAME
                .
        END.
    END.
END.
/* 2.- Creamos los grupos de unidades */
EMPTY TEMP-TABLE tbUnidadesCab.
FOR EACH bUnidadesCab NO-LOCK BY bUnidadesCab.AbsEntry:
    iContador = iContador + 1.
    CREATE tbUnidadesCab.
    ASSIGN
        tbUnidadesCab.AbsEntry = iContador
        tbUnidadesCab.CODE = bUnidadesCab.CODE + "_GRP"
        tbUnidadesCab.BaseUoM = bUnidadesCab.BaseUoM
        tbUnidadesCab.NAME = bUnidadesCab.NAME + "S"
        .
END.
FOR EACH tbUnidadesCab NO-LOCK:
    CREATE bUnidadesCab.
    BUFFER-COPY tbUnidadesCab TO bUnidadesCab.
END.

/* 3.- Creamos los detalles de los grupos de unidades: Solo de los grupos de unidades */
DO TRANSACTION:
    FOR EACH oMaestroGrupoUnidadesMedidaDet EXCLUSIVE-LOCK:
        DELETE oMaestroGrupoUnidadesMedidaDet.
    END.
END.

DEF VAR iLineNum AS INTE NO-UNDO.

DEF VAR cCodUnid AS CHAR NO-UNDO.
DEF VAR cCodAlter AS CHAR NO-UNDO.
DEF BUFFER boMaestroUnidadesDeMedida FOR oMaestroUnidadesDeMedida.

FOR EACH tbUnidadesCab NO-LOCK,
    FIRST boMaestroUnidadesDeMedida NO-LOCK WHERE boMaestroUnidadesDeMedida.AbsEntry = tbUnidadesCab.BaseUoM:
    cCodUnid = boMaestroUnidadesDeMedida.CODE.       /* Ejemplo UNI */
    iLineNum = 0.
    FOR EACH pro.Almtconv NO-LOCK WHERE pro.Almtconv.codunid = cCodUnid 
            AND pro.Almtconv.codalter <> pro.Almtconv.codunid,      /* Ejemlo UNI UNI */
        FIRST oMaestroUnidadesDeMedida NO-LOCK WHERE oMaestroUnidadesDeMedida.CODE = pro.Almtconv.codalter:
        /* Ejemplo CTO */
        CREATE oMaestroGrupoUnidadesMedidaDet.
        ASSIGN
            oMaestroGrupoUnidadesMedidaDet.ParentKey = tbUnidadesCab.AbsEntry
            oMaestroGrupoUnidadesMedidaDet.LineNum = iLineNum
            oMaestroGrupoUnidadesMedidaDet.AlternateUoM =  oMaestroUnidadesDeMedida.AbsEntry
            oMaestroGrupoUnidadesMedidaDet.AlternateQuantity = 1
            oMaestroGrupoUnidadesMedidaDet.BaseQuantity = Almtconv.Equival
            oMaestroGrupoUnidadesMedidaDet.ACTIVE = "tYES"
            .
        ASSIGN
            oMaestroGrupoUnidadesMedidaDet.CodUnid = pro.Almtconv.codunid
            oMaestroGrupoUnidadesMedidaDet.CodAlter = pro.Almtconv.codalter
        iLineNum = iLineNum + 1.
    END.
END.

/* FOR EACH tbUnidadesCab NO-LOCK,                                                                             */
/*     FIRST oMaestroUnidadesDeMedida NO-LOCK WHERE oMaestroUnidadesDeMedida.AbsEntry = tbUnidadesCab.BaseUoM: */
/*     iLineNum = 0.                                                                                           */
/*     FOR EACH pro.Almtconv NO-LOCK WHERE pro.Almtconv.codunid = oMaestroUnidadesDeMedida.CODE                */
/*             AND pro.Almtconv.codalter <> pro.Almtconv.codunid:                                              */
/*         CREATE oMaestroGrupoUnidadesMedidaDet.                                                              */
/*         ASSIGN                                                                                              */
/*             oMaestroGrupoUnidadesMedidaDet.ParentKey = tbUnidadesCab.AbsEntry                               */
/*             oMaestroGrupoUnidadesMedidaDet.LineNum = iLineNum                                               */
/*             oMaestroGrupoUnidadesMedidaDet.AlternateUoM =  oMaestroUnidadesDeMedida.AbsEntry                */
/*             oMaestroGrupoUnidadesMedidaDet.AlternateQuantity = 1                                            */
/*             oMaestroGrupoUnidadesMedidaDet.BaseQuantity = Almtconv.Equival                                  */
/*             oMaestroGrupoUnidadesMedidaDet.ACTIVE = "tYES"                                                  */
/*             .                                                                                               */
/*         ASSIGN                                                                                              */
/*             oMaestroGrupoUnidadesMedidaDet.CodUnid = pro.Almtconv.codunid                                   */
/*             oMaestroGrupoUnidadesMedidaDet.CodAlter = pro.Almtconv.codalter                                 */
/*         iLineNum = iLineNum + 1.                                                                            */
/*     END.                                                                                                    */
/* END.                                                                                                        */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-To-Text) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE To-Text Procedure 
PROCEDURE To-Text :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'GrupoUnidadesMedidadCabecera' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.csv'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".csv"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.
/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oMaestroGrupoUnidadesMedidaCab:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').

c-xls-file = 'GrupoUnidadesMedidadDetalle'.
SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.csv'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".csv"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.
/* Programas que generan el Excel */
SESSION:SET-WAIT-STATE('GENERAL').
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oMaestroGrupoUnidadesMedidaDet:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

