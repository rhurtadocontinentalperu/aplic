&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE toBinLocation NO-UNDO LIKE oBinLocation.



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
      TABLE: toBinLocation T "?" NO-UNDO INTEGRAL oBinLocation
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
DEF VAR cTexto AS CHAR NO-UNDO.

DO TRANSACTION:
    FOR EACH oBinLocation EXCLUSIVE-LOCK:
        DELETE oBinLocation.
    END.
    EMPTY TEMP-TABLE toBinLocation.
END.

/* 1.- Ubicaciones Registradas */
FOR EACH pro.Almacen NO-LOCK WHERE pro.Almacen.codcia = 1 AND pro.Almacen.Campo-C[9] <> "I":
    FOR EACH pro.Almtubic NO-LOCK WHERE pro.almtubic.CodCia = 1 AND pro.almtubic.CodAlm = pro.Almacen.codalm
        BY pro.almtubic.CodUbi:
        iContador = iContador + 1.
        CREATE toBinLocation.
        ASSIGN
            toBinLocation.AbsEntry = iContador
            toBinLocation.Warehouse = pro.almtubic.CodAlm
            toBinLocation.Sublevel1 = ""
            toBinLocation.Sublevel2 = ""
            toBinLocation.Sublevel3 = ""
            toBinLocation.Sublevel4 = ""
            toBinLocation.BinCode2 = ""
            toBinLocation.codubiprogress = pro.almtubic.CodUbi.
    END.
END.

/* 2.- Ubicaciones no registradas */
FOR EACH pro.Almmmate NO-LOCK WHERE pro.Almmmate.codcia = 1 AND pro.Almmmate.stkact > 0
    BREAK BY pro.Almmmate.codalm BY pro.Almmmate.codubi:
    IF FIRST-OF(pro.Almmmate.codalm) OR FIRST-OF(pro.Almmmate.codubi) THEN DO:
        FIND FIRST toBinLocation WHERE toBinLocation.Warehouse = pro.Almmmate.codalm 
            AND toBinLocation.codubiprogress = pro.Almmmate.codubi
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE toBinLocation THEN DO:
            iContador = iContador + 1.
            CREATE toBinLocation.
            ASSIGN
                toBinLocation.AbsEntry = iContador
                toBinLocation.Warehouse = pro.Almmmate.codalm
                toBinLocation.Sublevel1 = ""
                toBinLocation.Sublevel2 = ""
                toBinLocation.Sublevel3 = ""
                toBinLocation.Sublevel4 = ""
                toBinLocation.BinCode2 = ""
                toBinLocation.codubiprogress =  pro.Almmmate.CodUbi.
        END.
    END.
END.

DEF VAR cSublevel1 AS CHAR NO-UNDO.
DEF VAR cSublevel2 AS CHAR NO-UNDO.
DEF VAR cSublevel3 AS CHAR NO-UNDO.
DEF VAR cSublevel4 AS CHAR NO-UNDO.

FOR EACH toBinLocation EXCLUSIVE-LOCK:
    cSublevel1 = "".
    cSublevel2 = "".
    cSublevel3 = "".
    cSublevel4 = "".
    FIND FIRST pro.Almtubic WHERE pro.Almtubic.codcia = 1
        AND pro.Almtubic.codalm = toBinLocation.Warehouse
        AND pro.almtubic.CodUbi = toBinLocation.codubiprogress
        NO-LOCK NO-ERROR.
    IF AVAILABLE pro.Almtubic 
        THEN 
        ASSIGN toBinLocation.DESCRIPTION = pro.almtubic.DesUbi 
                cSublevel1 = REPLACE(pro.Almtubic.CodZona,"-","").
    ELSE ASSIGN cSublevel1 = REPLACE(toBinLocation.codubiprogress,"-","").
    CASE TRUE:
        WHEN TRIM(toBinLocation.codubiprogress) = "G-0" OR TRIM(toBinLocation.codubiprogress) = "G'0" THEN DO:
            ASSIGN
                cSublevel2 = "G0".
        END.
        WHEN INDEX(toBinLocation.codubiprogress,"-") > 0 THEN DO:
            IF cSubLevel1 = ENTRY(1,toBinLocation.codubiprogress,'-') THEN DO:
                /* Por ejemplo: en el almacén 31
                    Ubicación = 2A-05
                    Zona = 2A
                */
                ASSIGN
                    cSublevel2 = ENTRY(2,toBinLocation.codubiprogress,"-").
                IF NUM-ENTRIES(toBinLocation.codubiprogress,"-") >= 3 
                    THEN cSublevel3 = ENTRY(3,toBinLocation.codubiprogress,"-").
                IF NUM-ENTRIES(toBinLocation.codubiprogress,"-") >= 4
                    THEN cSublevel4 = ENTRY(4,toBinLocation.codubiprogress,"-").
            END.
            ELSE DO:
                /* Por ejemplo: en el almacén 03
                    Ubicación = 1A-01
                    Zona = Zn01
                */
                ASSIGN
                    cSublevel2 = ENTRY(1,toBinLocation.codubiprogress,"-")
                    cSublevel3 = ENTRY(2,toBinLocation.codubiprogress,"-").
                IF NUM-ENTRIES(toBinLocation.codubiprogress,"-") >= 3 
                    THEN cSublevel4 = ENTRY(3,toBinLocation.codubiprogress,"-").
            END.
        END.
        WHEN INDEX(toBinLocation.codubiprogress,"'") > 0 THEN DO:
            /* Por ejemplo: en el almacén 05
                Ubicación = 1B'04
                Zona = G-0
            */
            ASSIGN
                cSublevel2 = ENTRY(1,toBinLocation.codubiprogress,"'")
                cSublevel3 = ENTRY(2,toBinLocation.codubiprogress,"'").
            IF NUM-ENTRIES(toBinLocation.codubiprogress,"-") >= 3 
                THEN cSublevel4 = ENTRY(3,toBinLocation.codubiprogress,"'").
        END.
        WHEN AVAILABLE pro.Almtubic AND TRIM(toBinLocation.codubiprogress) BEGINS TRIM(pro.Almtubic.CodZona) THEN DO:
            /* Por ejemplo: en el almacén 11
                Ubicación = 010101A
                Zona = 01
            */
            ASSIGN
                cSublevel1 = SUBSTRING(toBinLocation.codubiprogress,1,2)
                cSublevel2 = SUBSTRING(toBinLocation.codubiprogress,3,2)
                cSublevel3 = SUBSTRING(toBinLocation.codubiprogress,5,2)
                cSublevel4 = SUBSTRING(toBinLocation.codubiprogress,7)
                .
        END.
        OTHERWISE DO:
            ASSIGN
                cSublevel2 = SUBSTRING(toBinLocation.codubiprogress,1,2)
                cSublevel3 = SUBSTRING(toBinLocation.codubiprogress,3,2)
                cSublevel4 = SUBSTRING(toBinLocation.codubiprogress,5)
                .
        END.
    END CASE.
    ASSIGN
        toBinLocation.Sublevel1 = cSubLevel1
        toBinLocation.Sublevel2 = cSubLevel2
        toBinLocation.Sublevel3 = cSubLevel3
        toBinLocation.Sublevel4 = cSubLevel4
        .
END.

FOR EACH toBinLocation EXCLUSIVE-LOCK:
    ASSIGN
        toBinLocation.Warehouse = CAPS(TRIM(toBinLocation.Warehouse))
        toBinLocation.Sublevel1 = CAPS(TRIM(toBinLocation.Sublevel1))
        toBinLocation.Sublevel2 = CAPS(TRIM(toBinLocation.Sublevel2))
        toBinLocation.Sublevel3 = CAPS(TRIM(toBinLocation.Sublevel3))
        toBinLocation.Sublevel4 = CAPS(TRIM(toBinLocation.Sublevel4))
        .
    CASE TRUE:
        WHEN toBinLocation.Sublevel4 > "" THEN DO:
             toBinLocation.BinCode2 = toBinLocation.Warehouse + "-" + toBinLocation.Sublevel1 + "-" + 
                                    toBinLocation.Sublevel2 + "-" + toBinLocation.Sublevel3 + "-" + 
                                    toBinLocation.Sublevel4.
        END.
        WHEN toBinLocation.Sublevel3 > "" THEN DO:
             toBinLocation.BinCode2 = toBinLocation.Warehouse + "-" + toBinLocation.Sublevel1 + "-" + 
                                    toBinLocation.Sublevel2 + "-" + toBinLocation.Sublevel3.
        END.
        WHEN toBinLocation.Sublevel2 > "" THEN DO:
             toBinLocation.BinCode2 = toBinLocation.Warehouse + "-" + toBinLocation.Sublevel1 + "-" + 
                                    toBinLocation.Sublevel2.
        END.
        OTHERWISE toBinLocation.BinCode2 = toBinLocation.Warehouse + "-" + toBinLocation.Sublevel1.
    END CASE.
END.

/* Pasamos a base de datos */
iContador = 0.
FOR EACH toBinLocation NO-LOCK BY toBinLocation.AbsEntry:
    IF CAN-FIND(FIRST oBinLocation WHERE oBinLocation.Warehouse = toBinLocation.Warehouse
                AND oBinLocation.Sublevel1 = toBinLocation.SubLevel1
                AND oBinLocation.Sublevel2 = toBinLocation.SubLevel2
                AND oBinLocation.Sublevel3 = toBinLocation.SubLevel3
                AND oBinLocation.Sublevel4 = toBinLocation.SubLevel4 NO-LOCK)
        THEN NEXT.
    iContador = iContador + 1.
    CREATE oBinLocation.
    BUFFER-COPY toBinLocation TO oBinLocation
        ASSIGN oBinLocation.AbsEntry = iContador.
END.


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
DEF VAR c-xls-file AS CHAR INIT 'oBinLocation' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oBinLocation:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

/* RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER oBinLocation:handle, */
/*                                   INPUT  c-csv-file,                     */
/*                                   OUTPUT c-xls-file) .                   */

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

