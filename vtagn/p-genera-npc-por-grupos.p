&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR FacCPedi.
DEFINE BUFFER B-DDOCU FOR FacDPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



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
&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCredito.p

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.        /* o la división o la lista de precios */

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-import-ibc AS LOG.
DEF SHARED VAR s-import-b2b AS LOG.
DEF SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR S-CMPBNTE  AS CHAR.
DEF SHARED VAR s-codmon AS INT.

FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia
    AND Faccpedi.coddiv = s-CodDiv
    AND Faccpedi.coddoc = pCodDoc
    AND Faccpedi.nroped = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    pMensaje = 'Documento ' + pCodDoc + ' ' + pNroDoc + ' NO encontrado'.
    RETURN 'ADM-ERROR'.
END.

DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR s-cndvta-validos AS CHAR NO-UNDO.
DEF VAR s-codcli AS CHAR NO-UNDO.
DEF VAR s-fmapgo AS CHAR NO-UNDO.
DEF VAR x-articulo-ICBPer AS CHAR INIT '099268' NO-UNDO.

x-CodPed = Faccpedi.CodDoc + "*".       /* Ej. NPC* */
s-codcli = Faccpedi.codcli.

/* RUN vtagn/p-fmapgo-valido-lineas.p (INPUT FacCPedi.Libre_c02,                            */
/*                                     OUTPUT s-cndvta-validos).                            */
/* IF s-CodDiv = '00101' THEN DO:                                                           */
/*     /* WhatsApp */                                                                       */
/*     RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, s-CodDiv, OUTPUT s-cndvta-validos). */
/* END.                                                                                     */
/* ELSE DO:                                                                                 */
/*     RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).  */
/* END.                                                                                     */
/* s-FmaPgo = ENTRY(1, s-cndvta-validos).                                                   */

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
      TABLE: B-CDOCU B "?" ? INTEGRAL FacCPedi
      TABLE: B-DDOCU B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* 1ro limpiamos registros de control */
RUN Borra-Registros.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    pMensaje = 'Error al generar las Notas de Pedido por Grupos de Líneas'.
    RETURN 'ADM-ERROR'.
END.
/* 2do. cargamos informacion */
RUN Graba-Registros.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF TRUE <> (pMensaje > '') THEN pMensaje = 'Error al generar las Notas de Pedido por Grupos de Líneas'.
    RETURN 'ADM-ERROR'.
END.
RUN Graba-Registros-Sin-Grupo.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF TRUE <> (pMensaje > '') THEN pMensaje = 'Error al generar las Notas de Pedido por Grupos de Líneas'.
    RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Borra-Registros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Registros Procedure 
PROCEDURE Borra-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-CDOCU EXCLUSIVE-LOCK WHERE B-CDOCU.codcia = Faccpedi.codcia
        AND B-CDOCU.CodDiv = Faccpedi.coddiv
        AND B-CDOCU.CodDoc = x-CodPed
        AND B-CDOCU.NroPed BEGINS Faccpedi.nroped:
        DELETE B-CDOCU.
    END.
    FOR EACH B-DDOCU EXCLUSIVE-LOCK WHERE B-DDOCU.codcia = Faccpedi.codcia
        AND B-DDOCU.CodDiv = Faccpedi.coddiv
        AND B-DDOCU.CodDoc = x-CodPed
        AND B-DDOCU.NroPed BEGINS Faccpedi.nroped:
        DELETE B-DDOCU.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DESCUENTOS-FINALES) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES Procedure 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(B-CDOCU),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(B-CDOCU),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(B-CDOCU),
                                      INPUT s-TpoPed,
                                      INPUT pCodDiv,
                                      OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Registros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registros Procedure 
PROCEDURE Graba-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla    = 'GRP_DIV_LIN'
    AND VtaTabla.Llave_c1 = pCodDiv
    BY Vtatabla.Libre_c01 DESC:
    /* Por cada grupo creamos su cabecera */
    RUN vtagn/p-fmapgo-valido-lineas.p (INPUT  Vtatabla.Libre_c01,
                                        OUTPUT s-cndvta-validos).
    s-FmaPgo = ENTRY(1, s-cndvta-validos).

    CREATE B-CDOCU.
    BUFFER-COPY Faccpedi TO B-CDOCU
        ASSIGN 
        B-CDOCU.CodDoc = x-CodPed
        B-CDOCU.NroPed = Faccpedi.NroPed + "|" + Vtatabla.Libre_c01     /* Ej. 00100101|000,011 */
        B-CDOCU.Libre_c02 = Vtatabla.Libre_c01
        B-CDOCU.FmaPgo = s-FmaPgo       /* Valor por Defecto */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN 'ADM-ERROR'.
    /* Por cada grupo creamos su detalle */
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
        FIRST Almmmatg OF Facdpedi NO-LOCK WHERE LOOKUP(Almmmatg.CodFam, Vtatabla.Libre_c01) > 0:
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM
            ASSIGN 
                ITEM.CodDoc = B-CDOCU.CodDoc
                ITEM.NroPed = B-CDOCU.NroPed.
    END.
    /* Definimos moneda de venta */
    FIND gn-convt WHERE gn-ConVt.Codig = s-FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CASE gn-ConVt.TipVta:
            WHEN "1" THEN DO:                 /* Contado */
                IF VtaTabla.Valor[1] = 1 OR VtaTabla.Valor[1] = 2 THEN B-CDOCU.CodMon = VtaTabla.Valor[1].
            END.
            WHEN "2" THEN DO:                 /* Crédito */
                IF VtaTabla.Valor[2] = 1 OR VtaTabla.Valor[2] = 2 THEN B-CDOCU.CodMon = VtaTabla.Valor[2].
            END.
        END CASE.
    END.
    /* Recalculamos Precios y Descuentos */
    RUN Recalcular-Precios.
    FOR EACH ITEM NO-LOCK:
        CREATE B-DDOCU.
        BUFFER-COPY ITEM TO B-DDOCU
            ASSIGN 
                B-DDOCU.CodDoc = B-CDOCU.CodDoc
                B-DDOCU.NroPed = B-CDOCU.NroPed
                B-DDOCU.CodDiv = B-CDOCU.CodDiv
                B-DDOCU.FchPed = B-CDOCU.FchPed
                B-DDOCU.CodCli = B-CDOCU.CodCli.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************************************** */
    /* RHC 09/06/2021 Verificamos si todos los productos cumplen con el margen mínimo de utilidad */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN pri/pri-librerias PERSISTENT SET hProc.
    RUN PRI_Valida-Margen-Utilidad-Total IN hProc (INPUT ROWID(B-CDOCU), OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
    /* ****************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="B-CDOCU" &Detalle="B-DDOCU"}
    /* ****************************************************************************************** */
    IF NOT CAN-FIND(FIRST B-DDOCU OF B-CDOCU NO-LOCK) THEN DELETE B-CDOCU.
END.
RETURN 'OK'.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Registros-Sin-Grupo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registros-Sin-Grupo Procedure 
PROCEDURE Graba-Registros-Sin-Grupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN vtagn/p-fmapgo-valido-lineas.p (INPUT FacCPedi.Libre_c02,
                                    OUTPUT s-cndvta-validos).
IF s-CodDiv = '00101' THEN DO:
    /* WhatsApp */
    RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, s-CodDiv, OUTPUT s-cndvta-validos).
END.
ELSE DO:
    RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).
END.
s-FmaPgo = ENTRY(1, s-cndvta-validos).

EMPTY TEMP-TABLE ITEM.
FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
    IF CAN-FIND(FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
                AND VtaTabla.Tabla    = 'GRP_DIV_LIN'
                AND VtaTabla.Llave_c1 = pCodDiv
                AND LOOKUP(TRIM(Almmmatg.CodFam), Vtatabla.Libre_c01) > 0
                NO-LOCK)
        THEN NEXT.
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
END.
IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN RETURN 'OK'.

/* Por cada grupo creamos su cabecera */
CREATE B-CDOCU.
BUFFER-COPY Faccpedi TO B-CDOCU
    ASSIGN 
    B-CDOCU.CodDoc = x-CodPed
    B-CDOCU.NroPed = Faccpedi.NroPed + "|" + "SIN GRUPO"
    B-CDOCU.Libre_c02 = "SIN GRUPO"
    B-CDOCU.FmaPgo = s-FmaPgo       /* Valor por Defecto */
    NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN 'ADM-ERROR'.
/* Recalculamos Precios y Descuentos */
RUN Recalcular-Precios.
FOR EACH ITEM NO-LOCK:
    CREATE B-DDOCU.
    BUFFER-COPY ITEM TO B-DDOCU
        ASSIGN 
            B-DDOCU.CodDoc = B-CDOCU.CodDoc
            B-DDOCU.NroPed = B-CDOCU.NroPed
            B-DDOCU.CodDiv = B-CDOCU.CodDiv
            B-DDOCU.FchPed = B-CDOCU.FchPed
            B-DDOCU.CodCli = B-CDOCU.CodCli.
END.
/* ************************************************************************************** */
/* DESCUENTOS APLICADOS A TODA LA COTIZACION */
/* ************************************************************************************** */
RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
    UNDO, RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************************** */
/* RHC 09/06/2021 Verificamos si todos los productos cumplen con el margen mínimo de utilidad */
/* ****************************************************************************************** */
DEF VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.
RUN PRI_Valida-Margen-Utilidad-Total IN hProc (INPUT ROWID(B-CDOCU), OUTPUT pMensaje).
IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
DELETE PROCEDURE hProc.
/* ****************************************************************************************** */
{vtagn/totales-cotizacion-unificada.i &Cabecera="B-CDOCU" &Detalle="B-DDOCU"}
/* ****************************************************************************************** */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Recalcular-Precio-TpoPed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precio-TpoPed Procedure 
PROCEDURE Recalcular-Precio-TpoPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pTpoPed AS CHAR.

    {vtagn/recalcular-cotizacion-unificada.i &pTpoPed=pTpoPed}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Recalcular-Precios) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios Procedure 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************************************ */
/* RHC 06/11/2017 NO recalcular precios para CANAL MODERNO NI LISTA EXPRESS */
/* ************************************************************************ */
IF s-TpoPed = "LF" THEN RETURN.     /* LISTA EXPRESS */
IF s-TpoPed = "S" AND s-Import-B2B = YES THEN RETURN.   /* SUPERMERCADOS */
IF s-TpoPed = "S" AND s-Import-IBC = YES THEN RETURN.   /* SUPERMERCADOS */
/*IF s-TpoPed = "S" AND s-Import-Cissac = YES THEN RETURN.   /* SUPERMERCADOS */*/
/* ******************************************************* */
/* ******************************************************* */
/* ARTIFICIO */
IF S-TPOMARCO = "SI" THEN RUN Recalcular-Precio-TpoPed ("M").
ELSE RUN Recalcular-Precio-TpoPed (s-TpoPed).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

