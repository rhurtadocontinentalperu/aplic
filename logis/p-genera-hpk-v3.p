&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE t-AlmDDocu NO-UNDO LIKE AlmDDocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE VtaDDocu.



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

/* GENERACION DE HOJAS DE PICKING (HPK) A PARTIR DE UNA PRE-HOJA DE RUTA (PHR) */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-RutaC THEN DO:
    pMensaje = "NO se ubicó la PHR" + CHR(10) + "Proceso Abortado".
    RETURN 'ADM-ERROR'.
END.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

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
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: t-AlmDDocu T "?" NO-UNDO INTEGRAL AlmDDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR x-CanMaster AS DEC NO-UNDO.
DEF VAR lSector AS CHAR NO-UNDO.
DEF VAR lUbic AS CHAR NO-UNDO.
DEF VAR lSectorOK AS LOG NO-UNDO.

pMensaje = ''.
DEFINE VAR hLibLogis AS HANDLE NO-UNDO.
RUN logis/p-genera-hpk-library.p PERSISTENT SET hLibLogis.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.CodCia AND
        FacCPedi.CodDoc = Di-RutaD.CodRef AND       /* O/D u OTR */
        FacCPedi.NroPed = Di-RutaD.NroRef AND
        (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "TG"):
        IF Faccpedi.CodDoc = 'OTR' AND Faccpedi.TpoPed = 'XD' THEN NEXT.
        /* Generamos la HPK */
        RUN HPK_Genera-HPK-Master IN hLibLogis (INPUT ROWID(DI-RutaC),
                                                INPUT ROWID(Faccpedi),
                                                OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
END.
DELETE PROCEDURE hLibLogis.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


