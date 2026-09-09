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
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT-OUTPUT PARAMETER pFchEnt AS DATE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.

FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia AND
    Faccpedi.coddoc = pCodDoc AND
    Faccpedi.nroped = pNroPed
    NO-LOCK.

/*  
    Ic - 02Ene2023
    Cualquier cambio que se realize a este programa, tener en consideracion que tambien sea
    desplegado en el servidor donde esta la base de datos (actualmente 192.168.100.210)
    Se usa para el proceso de generacion de OTR por compras - Lucy Mesia
*/

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
         HEIGHT             = 4.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* DOS métodos de cálculo:
    UBIGEO
    GPS
    En ambos casos necesito: Ubigeo y Coordenadas
*/
/* ********************************************************************* */
/* PUEDE SER EL UBIGEO DEL CLIENTE O DE LA AGENCIA DE TRANSPORTE         */
/* Campo Faccpedi.Ubigeo[2]: Guarda el valor @CL cliente o @PV proveedor */
/* ********************************************************************* */
DEF VAR pUbigeo   AS CHAR NO-UNDO.  /* Formato PPDDdd */
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud  AS DEC NO-UNDO.
DEF VAR pDivOri   AS CHAR NO-UNDO.

RUN Ubigeo-Final (OUTPUT pUbigeo,
                  OUTPUT pLongitud,
                  OUTPUT pLatitud).
IF TRUE <> (pUbigeo > '') THEN DO:
    pMensaje = "Error el en ubigeo" + CHR(10) + "Proceso abortado".
    RETURN.
END.

/* ************************************************************* */
/* Pesos y número de items por cada pedido                       */
/* ************************************************************* */
DEF VAR pNroSku     AS INT NO-UNDO.
DEF VAR pPeso       AS DEC NO-UNDO.

ASSIGN 
    pNroSku = 0 
    pPeso = 0.
FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
    pPeso = pPeso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat).
    pNroSku = pNroSku + 1.
END.
/* Valor por defecto de la Fecha de Entrega */
/* RHC 07/04/2021 Se va a tomar por defecto la fecha pactada con el cliente
pFchEnt = FacCPedi.FchEnt.
*/

CASE TRUE:
    WHEN Faccpedi.CodDoc = "OTR" THEN DO:
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.FchPed.
    END.
    WHEN Faccpedi.CodDoc = "O/D" THEN DO:
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.FchEnt.      /* Calculada por el sistema */
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.Libre_f02.   /* Pactada con el cliente */
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.FchPed.
    END.
    OTHERWISE DO:   /* PED, P/M */
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.Libre_f02.   /* Pactada con el cliente */
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.FchEnt.      /* Calculada por el sistema */
        IF pFchEnt = ? THEN pFchEnt = Faccpedi.FchPed.
    END.
END CASE.

DEFINE VAR pFechaBase AS DATE NO-UNDO.

/* pFechaBase = Faccpedi.Libre_f02.    /* Pactada con el cliente */ */
/* IF pFechaBase = ? THEN pFechaBase = Faccpedi.FchEnt.             */
/* IF pFechaBase = ? THEN pFechaBase = TODAY.                       */

pFechaBase = TODAY.     /* OJO */
/*pFechaBase = Faccpedi.FchPed.*/

/* ****************************************************************************** */
/* LOGICA PRINCIPAL                                                               */
/* ****************************************************************************** */
/* Buscar la división de despacho */
FIND Almacen WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = Faccpedi.CodAlm NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Almacen.coddiv NO-LOCK.
pMensaje = ''.
CASE TRUE:
    WHEN LOOKUP(pCodDoc,"O/D,O/M,PED,OTR") > 0 AND gn-divi.Campo-Char[9] = "GPS" THEN DO:
        RUN logis/p-fecha-entrega-gps.p (
            Faccpedi.CodAlm,              /* Almacén de despacho */
            TODAY,                        /* Fecha base */
            STRING(TIME,'HH:MM:SS'),      /* Hora base */
            Faccpedi.CodCli,              /* Cliente */
            Faccpedi.CodDiv,              /* División solicitante */
            pUbigeo,   /* Ubigeo: CR es cuando el cliente recoje  */
            pLongitud,
            pLatitud,
            Faccpedi.CodDoc,              /* Documento actual */
            Faccpedi.NroPed,
            pNroSKU,
            pPeso,
            INPUT-OUTPUT pFchEnt,
            OUTPUT pMensaje).
    END.
    OTHERWISE DO:
        /* Valor por Defecto */
        ASSIGN pDivOri = Faccpedi.CodDiv.
        IF Faccpedi.CodDoc = 'OTR' THEN DO:
            /* El destino es un almacén */
            FIND Almacen WHERE Almacen.codcia = s-codcia 
                AND Almacen.codalm = Faccpedi.codcli NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN DO:
                FIND gn-divi WHERE gn-divi.codcia = s-codcia
                    AND gn-divi.coddiv = Almacen.coddiv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN pDivOri = gn-divi.CodDiv.
            END.
        END.
        RUN logis/p-fecha-entrega-ubigeo.p (
            Faccpedi.CodAlm,              /* Almacén de despacho */
            pFechaBase,     /*TODAY,                        /* Fecha base */*/
            STRING(TIME,'HH:MM:SS'),      /* Hora base */
            Faccpedi.CodCli,              /* Cliente */
            pDivOri,                      /* División solicitante */
            pUbigeo,                      /* Ubigeo: CR es cuando el cliente recoje  */
            Faccpedi.CodDoc,              /* Documento actual */
            Faccpedi.NroPed,
            pNroSKU,
            pPeso,
            INPUT-OUTPUT pFchEnt,
            OUTPUT pMensaje).
/*         RUN gn/p-fchent-v3.p (                                                          */
/*             Faccpedi.CodAlm,              /* Almacén de despacho */                     */
/*             TODAY,                        /* Fecha base */                              */
/*             STRING(TIME,'HH:MM:SS'),      /* Hora base */                               */
/*             Faccpedi.CodCli,              /* Cliente */                                 */
/*             Faccpedi.CodDiv,              /* División solicitante */                    */
/*             pUbigeo,                      /* Ubigeo: CR es cuando el cliente recoje  */ */
/*             Faccpedi.CodDoc,              /* Documento actual */                        */
/*             Faccpedi.NroPed,                                                            */
/*             pNroSKU,                                                                    */
/*             pPeso,                                                                      */
/*             INPUT-OUTPUT pFchEnt,                                                       */
/*             OUTPUT pMensaje).                                                           */
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Ubigeo-Final) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ubigeo-Final Procedure 
PROCEDURE Ubigeo-Final :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pUbigeo AS CHAR.
DEF OUTPUT PARAMETER pLongitud AS DEC.
DEF OUTPUT PARAMETER pLatitud AS DEC.

/* POR VER: cuando CLIENTE RECOGE */
CASE TRUE:
    /* 1er caso CICLO NUEVO DE PEDIDOS */
    WHEN LOOKUP(Faccpedi.CodDoc, 'COT,PED,O/D,O/M') > 0 AND LOOKUP(Faccpedi.Ubigeo[2], '@CL,@PV,@ALM') > 0 THEN DO:
        RUN logis/p-datos-sede-auxiliar (INPUT Faccpedi.Ubigeo[2],      /* ClfAux */
                                         INPUT Faccpedi.Ubigeo[3],      /* CodAux */
                                         INPUT Faccpedi.Ubigeo[1],      /* Sede */
                                         OUTPUT pUbigeo,    /* Ej 150101 */
                                         OUTPUT pLongitud,
                                         OUTPUT pLatitud).
    END.
    /* 2do caso VIENE DE UNA OTR: Depende del almacén (cliente) destino */
    WHEN LOOKUP(Faccpedi.CodDoc, 'OTR') > 0 THEN DO:
        RUN logis/p-datos-sede-auxiliar ("@ALM",                /* ClfAux */
                                         Faccpedi.CodCli,       /* CodAux */
                                         "",                    /* Sede */
                                         OUTPUT pUbigeo,        /* Ej 150101 */
                                         OUTPUT pLongitud,
                                         OUTPUT pLatitud).
    END.
END CASE.

/* RHC 19/11/2019 CASO: Trámite Documentario, Cliente Recoge */
IF Faccpedi.TipVta = "Si" OR Faccpedi.Cliente_Recoge = YES 
    THEN ASSIGN
            pUbigeo = "CR"
            pLongitud = 0
            pLatitud = 0.

IF TRUE <> (pUbigeo > '') THEN DO:
    /* Suponemos que es un Código Postal */
    FIND Almtabla WHERE Almtabla.Tabla = "CP" 
        AND Almtabla.Codigo = Faccpedi.CodPos NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN DO:
        /* CODIGO POSTAL */
        FIND TabDistr WHERE TabDistr.CodPos = Almtabla.Codigo NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN DO:
            pUbigeo = TRIM(TabDistr.CodDepto) + TRIM(TabDistr.CodProvi) + TRIM(TabDistr.CodDistr).
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

