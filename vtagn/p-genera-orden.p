&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DDOCU NO-UNDO LIKE VtaDDocu.



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
   Temp-Tables and Buffers:
      TABLE: T-DDOCU T "SHARED" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
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

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CanSol AS DEC NO-UNDO.
DEF VAR x-NroItm AS INT INIT 1 NO-UNDO.

DEF VAR s-FlgIgv AS LOG NO-UNDO.
DEF VAR s-PorIgv AS DEC NO-UNDO.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK.
ASSIGN
    s-FlgIgv = Vtacdocu.FlgIgv
    s-PorIgv = Vtacdocu.PorIgv.

FIND gn-divi OF Vtacdocu NO-LOCK.

FOR EACH T-DDOCU:
    DELETE T-DDOCU.
END.
FOR EACH Vtaddocu OF Vtacdocu NO-LOCK WHERE ( CanPed - CanAte ) > 0 BY Vtaddocu.NroItm:
    FIND FIRST Almmmatg OF Vtaddocu NO-LOCK.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Almmmatg.Chr__01 
        NO-LOCK NO-ERROR.
    x-CanSol = ( Vtaddocu.CanPed - Vtaddocu.CanAte ).                       /* UND venta */
    CREATE T-DDOCU.
    BUFFER-COPY Vtaddocu 
        EXCEPT VtaDDocu.CanAte VtaDDocu.CanPick
        TO T-DDOCU
        ASSIGN
        T-DDOCU.NroItm = x-NroItm
        T-DDOCU.CanPed = x-CanSol.
    x-NroItm = x-NroItm + 1.
    {vtagn/i-vtaddocu-01.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


