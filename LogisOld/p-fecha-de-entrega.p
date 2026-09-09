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

RUN logis/p-datos-sede-auxiliar (INPUT Faccpedi.Ubigeo[2],      /* ClfAux */
                                 INPUT Faccpedi.Ubigeo[3],      /* CodAux */
                                 INPUT Faccpedi.Ubigeo[1],      /* Sede */
                                 OUTPUT pUbigeo,    /* Ej 150101 */
                                 OUTPUT pLongitud,
                                 OUTPUT pLatitud).

/* ************************************************************* */
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
pFchEnt = FacCPedi.FchEnt.
IF pFchEnt = ? THEN pFchEnt = TODAY.
pMensaje = ''.
/* Buscamos el almacén que va a despachar el pedido */
/* ****************************************************************************** */
/* LOGICA PRINCIPAL                                                               */
/* ****************************************************************************** */
/* Buscar la división de despacho */
FIND Almacen WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = Faccpedi.CodAlm NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Almacen.coddiv NO-LOCK.
/* Si el Cliente Recoge => se cambia el pUbigeo */
IF TRUE <> (pUbigeo > '') THEN pUbigeo = Faccpedi.CodPos.   /* Parche */
IF pUbigeo = "CR" THEN pUbigeo = "CR".
pMensaje = ''.

CASE TRUE:
    WHEN LOOKUP(pCodDoc,"O/D,O/M,PED") > 0 AND gn-divi.Campo-Char[9] = "GPS" THEN DO:
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
        RUN gn/p-fchent-v3.p (
            Faccpedi.CodAlm,              /* Almacén de despacho */
            TODAY,                        /* Fecha base */
            STRING(TIME,'HH:MM:SS'),      /* Hora base */
            Faccpedi.CodCli,              /* Cliente */
            Faccpedi.CodDiv,              /* División solicitante */
            pUbigeo,                      /* Ubigeo: CR es cuando el cliente recoje  */
            Faccpedi.CodDoc,              /* Documento actual */
            Faccpedi.NroPed,
            pNroSKU,
            pPeso,
            INPUT-OUTPUT pFchEnt,
            OUTPUT pMensaje).
    END.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


