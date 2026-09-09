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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pControl AS CHAR.

/* pControl:
    C:  crea registro
    D:  borra registro
*/

IF LOOKUP(pControl, 'C,D') = 0 THEN RETURN "OK".

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "A/C" NO-UNDO.    /* Anticipo Campaña */
DEF BUFFER B-CDOCU FOR Ccbcdocu.

/* Chequeo de la factura:
- Tiene que ser por adelanto
- Tiene que estar cancelada
*/
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    CASE pControl:
        WHEN "C" THEN DO:
            FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcdocu THEN RETURN "OK".
            /* ******************************************************************** */
            /* RHC 13/07/2017 NO es por Adelanto de Campaña ni por Venta Anticipada */
            /* ******************************************************************** */
            IF LOOKUP(Ccbcdocu.TpoFac, "A,V") = 0 THEN RETURN "OK".      
            /* ******************************************************************** */
            /* ******************************************************************** */
            IF Ccbcdocu.FlgEst <> "C" THEN RETURN "OK".      /* NO está cancelada */
            IF Ccbcdocu.ImpTot2 > 0   THEN RETURN "OK".     /* NO antiguas */
            FIND FIRST FacCorre WHERE FacCorre.codcia = s-codcia
                AND FacCorre.coddiv = s-coddiv
                AND FacCorre.coddoc = s-coddoc
                AND FacCorre.flgest = YES
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE FacCorre THEN DO:
                MESSAGE "NO se pudo generar el control por anticipo campaña"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
            CREATE B-CDOCU.
            BUFFER-COPY Ccbcdocu 
                TO B-CDOCU
                ASSIGN
                B-CDOCU.CodDiv = Ccbcdocu.coddiv
                B-CDOCU.CodDoc = s-coddoc
                B-CDOCU.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
                /*
                B-CDOCU.NroDoc = Ccbcdocu.NroDoc    /* RHC 22.11.2011 Suponiendo que hay solo FAC ADELANTADAS */
                */
                B-CDOCU.FchDoc = Ccbcdocu.FchDoc
                B-CDOCU.FlgEst = "P"
                B-CDOCU.TpoFac = Ccbcdocu.TpoFac    /* OJO => "A" o "V" */
                B-CDOCU.CodRef = Ccbcdocu.CodDoc
                B-CDOCU.NroRef = Ccbcdocu.NroDoc
                B-CDOCU.usuario = s-user-id
                B-CDOCU.ImpTot = Ccbcdocu.ImpTot
                B-CDOCU.SdoAct = Ccbcdocu.ImpTot.
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            /* RHC 30/01/2017 Agregamos el % de descuento x A/C */
            FOR EACH Ccbtabla NO-LOCK WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla = "%AC"
                AND CcbTabla.Codigo = B-CDOCU.Libre_c01
                AND B-CDOCU.FchDoc >= CcbTabla.Libre_f01 
                AND B-CDOCU.FchDoc <= CcbTabla.Libre_f02:
                ASSIGN
                    B-CDOCU.PorDto = CcbTabla.Libre_d01.
            END.
            /* ************************************************ */
            RELEASE FacCorre.
            RELEASE B-CDOCU.
        END.
        WHEN "D" THEN DO:
            FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
            FOR EACH B-CDOCU WHERE B-CDOCU.codcia = s-codcia
                AND B-CDOCU.coddoc = s-coddoc
                AND B-CDOCU.codref = Ccbcdocu.CodDoc
                AND B-CDOCU.nroref = Ccbcdocu.NroDoc:
                /*IF B-CDOCU.ImpTot = B-CDOCU.SdoAct THEN DELETE B-CDOCU.*/
                IF B-CDOCU.ImpTot = B-CDOCU.SdoAct 
                    THEN ASSIGN 
                            B-CDOCU.FlgEst = "A"
                            B-CDOCU.UsuAnu = s-user-id
                            B-CDOCU.FchAnu = TODAY.
            END.
            IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
        END.
    END CASE.
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


