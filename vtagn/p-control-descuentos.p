&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.



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

DEFINE INPUT PARAMETER pRowid AS ROWID.     /* De la COT */

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI OR B-CPEDI.CodDoc <> "COT" THEN RETURN 'OK'.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Vtaddctos EXCLUSIVE-LOCK WHERE VtaDDctos.CodCia = B-CPEDI.codcia
        AND VtaDDctos.CodDiv = B-CPEDI.coddiv
        AND VtaDDctos.CodPed = B-CPEDI.coddoc
        AND VtaDDctos.NroPed = B-CPEDI.nroped:
        DELETE Vtaddctos.
    END.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK WHERE B-DPEDI.Libre_c05 <> "OF":
        CREATE Vtaddctos.
        ASSIGN
            VtaDDctos.CodCia = B-DPEDI.codcia
            VtaDDctos.CodDiv = B-DPEDI.coddiv
            VtaDDctos.codmat = B-DPEDI.codmat
            VtaDDctos.CodPed = B-DPEDI.coddoc
            VtaDDctos.NroPed = B-DPEDI.nroped
            VtaDDctos.Flete  = B-DPEDI.flete
            VtaDDctos.Dcto_Clf_Cli   = B-DPEDI.Dcto_Clf_Cli 
            VtaDDctos.Dcto_Cond_Vta  = B-DPEDI.Dcto_Cond_Vta
            .
        CASE TRUE:
            WHEN B-DPEDI.Libre_c04 = "DVXDSF" THEN DO:     /* Descuento por Volumen por Linea */
                /* Se mantiene el precio base aún si ha sido afectado por 
                    dcto x clf cli y dcto x cond de vta y flete */
                ASSIGN
                    VtaDDctos.Dcto_Vol_Linea = B-DPEDI.Por_Dsctos[3].
            END.
            WHEN B-DPEDI.Libre_c04 = "DVXSALDOC" THEN DO:  /* Descuento por Volumen por Saldo */
                /* Se mantiene el precio aún si ha sido afectado por 
                    dcto x clf cli y dcto x cond de vta y flete */
                ASSIGN
                    VtaDDctos.Dcto_Vol_Saldo = B-DPEDI.Por_Dsctos[1].
            END.
            WHEN B-DPEDI.Libre_c04 = "EDVXSALDOC" THEN DO:  /* Descuento por Volumen por Saldo Evento */
                /* Se mantiene el precio base aún si ha sido afectado por 
                    dcto x clf cli y dcto x cond de vta y flete */
                ASSIGN
                    VtaDDctos.Dcto_Vol_Saldo_Evento = B-DPEDI.Por_Dsctos[3].
            END.
            WHEN B-DPEDI.Libre_c04 = "VOL" THEN DO:  /* Descuento por Volumen */
                ASSIGN
                    VtaDDctos.Dcto_Volumen   = B-DPEDI.Por_Dsctos[3].
            END.
            WHEN B-DPEDI.Libre_c04 = "PROM" THEN DO:  /* Descuento por Volumen */
                ASSIGN
                    VtaDDctos.Dcto_Promocional   = B-DPEDI.Por_Dsctos[3].
            END.
        END CASE.
        IF VtaDDctos.Dcto_Vol_Saldo = 0 THEN VtaDDctos.Dcto_Administrador = B-DPEDI.Por_Dsctos[1].
    END.
    IF B-CPEDI.CodMon = 2 THEN DO:
        FOR EACH VtaDDctos EXCLUSIVE-LOCK WHERE  VtaDDctos.CodCia = B-CPEDI.codcia
            AND VtaDDctos.CodDiv = B-CPEDI.coddiv
            AND VtaDDctos.CodPed = B-CPEDI.coddoc
            AND VtaDDctos.NroPed = B-CPEDI.nroped,
            FIRST Almmmatg OF Vtaddctos NO-LOCK:
            ASSIGN
                VtaDDctos.Flete = VtaDDctos.Flete * Almmmatg.TpoCmb.
        END.
    END.
    IF AVAILABLE(Vtaddctos) THEN RELEASE Vtaddctos.
END.
RETURN 'OK'.

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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


