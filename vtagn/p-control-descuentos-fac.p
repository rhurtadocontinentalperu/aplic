&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDctos FOR VtaCDctos.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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

DEFINE INPUT PARAMETER pRowid AS ROWID.     /* De la FAC */

FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU OR LOOKUP(B-CDOCU.CodDoc, "FAC,BOL") = 0 THEN RETURN 'OK'.

/* Buscamos la Cotización */
FIND PEDIDO WHERE PEDIDO.codcia = B-CDOCU.codcia
    AND PEDIDO.coddoc = B-CDOCU.codped
    AND PEDIDO.nroped = B-CDOCU.nroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN 'OK'.
FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
    AND COTIZACION.coddoc = PEDIDO.codref
    AND COTIZACION.nroped = PEDIDO.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN RETURN 'OK'.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-CDctos WHERE B-CDctos.CodCia = COTIZACION.codcia
        AND B-CDctos.CodDiv = COTIZACION.coddiv
        AND B-CDctos.CodPed = COTIZACION.coddoc
        AND B-CDctos.NroPed = COTIZACION.nroped
        NO-LOCK NO-ERROR.
    CREATE Vtacdctos.
    ASSIGN
        VtaCDctos.CodCia = B-CDOCU.codcia
        VtaCDctos.CodDiv = B-CDOCU.coddiv
        VtaCDctos.CodPed = B-CDOCU.coddoc
        VtaCDctos.Margen_Esperado = (IF AVAILABLE B-CDctos THEN B-CDctos.Margen_Esperado ELSE 0)
        VtaCDctos.NroPed = B-CDOCU.nroped.
    FOR EACH Vtaddctos EXCLUSIVE-LOCK WHERE VtaDDctos.CodCia = B-CDOCU.codcia
        AND VtaDDctos.CodDiv = B-CDOCU.coddiv
        AND VtaDDctos.CodPed = B-CDOCU.coddoc
        AND VtaDDctos.NroPed = B-CDOCU.nrodoc:
        DELETE Vtaddctos.
    END.
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK,
        FIRST B-DPEDI OF COTIZACION NO-LOCK WHERE B-DPEDI.codmat = B-DDOCU.codmat
        AND B-DPEDI.Libre_c05 <> "OF":
        CREATE Vtaddctos.
        ASSIGN
            VtaDDctos.CodCia = B-CDOCU.codcia
            VtaDDctos.CodDiv = B-CDOCU.coddiv
            VtaDDctos.codmat = B-DDOCU.codmat
            VtaDDctos.CodPed = B-DDOCU.coddoc
            VtaDDctos.NroPed = B-DDOCU.nrodoc
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
    IF COTIZACION.CodMon = 2 THEN DO:
        FOR EACH VtaDDctos EXCLUSIVE-LOCK WHERE  VtaDDctos.CodCia = B-CDOCU.codcia
            AND VtaDDctos.CodDiv = B-CDOCU.coddiv
            AND VtaDDctos.CodPed = B-CDOCU.coddoc
            AND VtaDDctos.NroPed = B-CDOCU.nrodoc,
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
      TABLE: B-CDctos B "?" ? INTEGRAL VtaCDctos
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


