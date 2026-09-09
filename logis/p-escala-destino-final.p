&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.



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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.54
         WIDTH              = 50.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pRowid AS ROWID.

DEF BUFFER B-RUTAC FOR Di-RutaC.

FIND B-RUTAC WHERE ROWID(B-RUTAC) = pRowid NO-LOCK NO-ERROR.

/* ********************************************************************** */
/* RHC 13/11/2019 Guardar en una tabla auxiliar la ESCALA y DESTINO FINAL */
/* ESCALA y DESTINO FINAL */
/* ********************************************************************** */
DEF VAR x-PuntoLlegada AS CHAR NO-UNDO.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.

FOR EACH Di-RutaGRI EXCLUSIVE-LOCK WHERE Di-RutaGRI.CodCia = B-RutaC.CodCia AND
    Di-RutaGRI.CodDiv = B-RutaC.CodDiv AND
    Di-RutaGRI.CodDoc = B-RutaC.CodDoc AND
    Di-RutaGRI.NroDoc = B-RutaC.NroDoc:
    DELETE Di-RutaGRI.
END.

FOR EACH Di-RutaD OF B-RUTAC NO-LOCK,
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia AND
        Ccbcdocu.coddoc = Di-RutaD.CodRef AND   /* G/R */
        Ccbcdocu.nrodoc = Di-RutaD.NroRef,
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Ccbcdocu.codcia AND
        Faccpedi.coddoc = Ccbcdocu.codped AND   /* PED */
        Faccpedi.nroped = Ccbcdocu.nroped,
    FIRST Ccbadocu NO-LOCK WHERE CcbADocu.CodCia = Faccpedi.codcia AND
        CcbADocu.CodDiv = Faccpedi.coddiv AND
        CcbADocu.CodDoc = Faccpedi.coddoc AND
        CcbADocu.NroDoc = Faccpedi.nroped:
    FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaD.CodCia AND
        Di-RutaGRI.CodDiv = Di-RutaD.CodDiv AND
        Di-RutaGRI.CodDoc = Di-RutaD.CodDoc AND     /* H/R */
        Di-RutaGRI.NroDoc = Di-RutaD.NroDoc AND
        Di-RutaGRI.CodRef = Faccpedi.CodDoc AND     /* PED */
        Di-RutaGRI.NroRef = Faccpedi.NroPed
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaGRI THEN DO:
        CREATE Di-RutaGRI.
        ASSIGN
            Di-RutaGRI.CodCia = Di-RutaD.CodCia 
            Di-RutaGRI.CodDiv = Di-RutaD.CodDiv 
            Di-RutaGRI.CodDoc = Di-RutaD.CodDoc      /* H/R */
            Di-RutaGRI.NroDoc = Di-RutaD.NroDoc 
            Di-RutaGRI.CodRef = Faccpedi.CodDoc      /* PED */
            Di-RutaGRI.NroRef = Faccpedi.NroPed.
    END.
    ELSE DO:
        FIND CURRENT Di-RutaGRI EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Di-RutaGRI.Escala = CcbAdocu.Libre_c[12]
        Di-RutaGRI.Destino_Final = CcbAdocu.Libre_c[13]
        Di-RutaGRI.Contacto = CcbAdocu.Libre_c[14]
        Di-RutaGRI.Hora = CcbAdocu.Libre_c[15]
        Di-RutaGRI.Referencia = CcbAdocu.Libre_c[16].
    /* RHC 18/09/2019 En caso de DEJADO EN TIENDA */
    /* RHC 16/06/2019 Lugar de entrega (* O/D)*/
    RUN logis/p-lugar-de-entrega (Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-PuntoLlegada).
    IF NUM-ENTRIES(x-PuntoLlegada, '|') >= 2 THEN
        ASSIGN
        Di-RutaGRI.Escala = ENTRY(2, x-PuntoLlegada, '|').
    RUN logis/p-datos-sede-auxiliar (INPUT Faccpedi.Ubigeo[2],
                                     INPUT Faccpedi.Ubigeo[3],
                                     INPUT Faccpedi.Ubigeo[1],
                                     OUTPUT pUbigeo,
                                     OUTPUT pLongitud,
                                     OUTPUT pLatitud).
    ASSIGN
        Di-RutaGRI.Escala_Ubigeo = pUbigeo.
END.
/* RHC 22/06/2020 en caso de la división 00506 */
FOR EACH Di-RutaD OF B-RUTAC NO-LOCK,
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia AND
        Ccbcdocu.coddoc = Di-RutaD.CodRef AND   /* G/R */
        Ccbcdocu.nrodoc = Di-RutaD.NroRef,
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Ccbcdocu.codcia AND
        Faccpedi.coddoc = Ccbcdocu.codped AND   /* PED */
        Faccpedi.nroped = Ccbcdocu.nroped,
    FIRST COTIZACION NO-LOCK WHERE COTIZACION.codcia = Faccpedi.codcia AND
        COTIZACION.coddoc = Faccpedi.codref AND     /* COT */
        COTIZACION.nroped = Faccpedi.nroref:
    IF ( TRUE <> (COTIZACION.TelephoneContactReceptor > '') AND
         TRUE <> (COTIZACION.ReferenceAddress > '') ) THEN NEXT.
    FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaD.CodCia AND
        Di-RutaGRI.CodDiv = Di-RutaD.CodDiv AND
        Di-RutaGRI.CodDoc = Di-RutaD.CodDoc AND     /* H/R */
        Di-RutaGRI.NroDoc = Di-RutaD.NroDoc AND
        Di-RutaGRI.CodRef = Faccpedi.CodDoc AND     /* PED */
        Di-RutaGRI.NroRef = Faccpedi.NroPed
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaGRI THEN DO:
        CREATE Di-RutaGRI.
        ASSIGN
            Di-RutaGRI.CodCia = Di-RutaD.CodCia 
            Di-RutaGRI.CodDiv = Di-RutaD.CodDiv 
            Di-RutaGRI.CodDoc = Di-RutaD.CodDoc      /* H/R */
            Di-RutaGRI.NroDoc = Di-RutaD.NroDoc 
            Di-RutaGRI.CodRef = Faccpedi.CodDoc      /* PED */
            Di-RutaGRI.NroRef = Faccpedi.NroPed.
    END.
    ELSE DO:
        FIND CURRENT Di-RutaGRI EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    IF COTIZACION.TelephoneContactReceptor > '' THEN Di-RutaGRI.Contacto = COTIZACION.TelephoneContactReceptor.
    IF COTIZACION.ReferenceAddress > '' THEN Di-RutaGRI.Referencia = COTIZACION.ReferenceAddress.
END.
/* *************************************************************************************** */
/* GIAS DE REMISION POR TRANSFERENCIA */
/* *************************************************************************************** */
FOR EACH Di-RutaG OF B-RUTAC NO-LOCK,
    FIRST Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia
      AND Almcmov.CodAlm = Di-RutaG.CodAlm
      AND Almcmov.TipMov = Di-RutaG.Tipmov
      AND Almcmov.CodMov = Di-RutaG.Codmov
      AND Almcmov.NroSer = Di-RutaG.serref
      AND Almcmov.NroDoc = Di-RutaG.nroref,
    FIRST Almacen NO-LOCK WHERE Almacen.CodCia = Almcmov.CodCia
      AND Almacen.CodAlm = Almcmov.AlmDes:
    FIND FIRST Faccpedi WHERE FacCPedi.CodCia = Almcmov.CodCia 
        AND FacCPedi.CodDoc = Almcmov.CodRef
        AND FacCPedi.NroPed = Almcmov.NroRef NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN NEXT.
    /* DESTINO FINAL */
    FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaG.CodCia AND
        Di-RutaGRI.CodDiv = Di-RutaG.CodDiv AND
        Di-RutaGRI.CodDoc = Di-RutaG.CodDoc AND     /* H/R */
        Di-RutaGRI.NroDoc = Di-RutaG.NroDoc AND
        Di-RutaGRI.CodRef = Faccpedi.CodRef AND     /* R/A */
        Di-RutaGRI.NroRef = Faccpedi.NroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaGRI THEN DO:
        CREATE Di-RutaGRI.
        ASSIGN
            Di-RutaGRI.CodCia = Di-RutaG.CodCia 
            Di-RutaGRI.CodDiv = Di-RutaG.CodDiv 
            Di-RutaGRI.CodDoc = Di-RutaG.CodDoc      /* H/R */
            Di-RutaGRI.NroDoc = Di-RutaG.NroDoc 
            Di-RutaGRI.CodRef = Faccpedi.CodRef      /* R/A */
            Di-RutaGRI.NroRef = Faccpedi.NroRef.
    END.
    ELSE DO:
        FIND CURRENT Di-RutaGRI EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Di-RutaGRI.Destino_Final = Almacen.DirAlm.
    RUN logis/p-datos-sede-auxiliar (INPUT "@ALM",
                                     INPUT Almacen.CodAlm,
                                     INPUT "",
                                     OUTPUT pUbigeo,
                                     OUTPUT pLongitud,
                                     OUTPUT pLatitud).
    ASSIGN
        Di-RutaGRI.Escala_Ubigeo = pUbigeo.
END.
IF AVAILABLE Di-RutaGRI THEN RELEASE Di-RutaGRI.
RETURN 'OK'.

/*
DEF INPUT PARAMETER pRowid AS ROWID.

DEF BUFFER B-RUTAC FOR Di-RutaC.

FIND B-RUTAC WHERE ROWID(B-RUTAC) = pRowid NO-LOCK NO-ERROR.

    /* ********************************************************************** */
    /* RHC 13/11/2019 Guardar en una tabla auxiliar la ESCALA y DESTINO FINAL */
    /* ESCALA y DESTINO FINAL */
    /* ********************************************************************** */
    DEF VAR x-PuntoLlegada AS CHAR NO-UNDO.
    FOR EACH Di-RutaD OF B-RUTAC NO-LOCK,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia AND
            Ccbcdocu.coddoc = Di-RutaD.CodRef AND   /* G/R */
            Ccbcdocu.nrodoc = Di-RutaD.NroRef,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Ccbcdocu.codcia AND
            Faccpedi.coddoc = Ccbcdocu.codped AND   /* PED */
            Faccpedi.nroped = Ccbcdocu.nroped,
        FIRST Ccbadocu NO-LOCK WHERE CcbADocu.CodCia = Faccpedi.codcia AND
            CcbADocu.CodDiv = Faccpedi.coddiv AND
            CcbADocu.CodDoc = Faccpedi.coddoc AND
            CcbADocu.NroDoc = Faccpedi.nroped:
        FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaD.CodCia AND
            Di-RutaGRI.CodDiv = Di-RutaD.CodDiv AND
            Di-RutaGRI.CodDoc = Di-RutaD.CodDoc AND     /* H/R */
            Di-RutaGRI.NroDoc = Di-RutaD.NroDoc AND
            Di-RutaGRI.CodRef = Di-RutaD.CodRef AND     /* G/R */
            Di-RutaGRI.NroRef = Di-RutaD.NroRef     
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Di-RutaGRI THEN DO:
            CREATE Di-RutaGRI.
            ASSIGN
                Di-RutaGRI.CodCia = Di-RutaD.CodCia 
                Di-RutaGRI.CodDiv = Di-RutaD.CodDiv 
                Di-RutaGRI.CodDoc = Di-RutaD.CodDoc      /* H/R */
                Di-RutaGRI.NroDoc = Di-RutaD.NroDoc 
                Di-RutaGRI.CodRef = Di-RutaD.CodRef      /* G/R */
                Di-RutaGRI.NroRef = Di-RutaD.NroRef.  
        END.
        ELSE DO:
            FIND CURRENT Di-RutaGRI EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
        END.
        ASSIGN
            Di-RutaGRI.Libre_c01 = CcbAdocu.Libre_c[12]
            Di-RutaGRI.Libre_c02 = CcbAdocu.Libre_c[13]
            Di-RutaGRI.Libre_c03 = CcbAdocu.Libre_c[14]
            Di-RutaGRI.Libre_c04 = CcbAdocu.Libre_c[15]
            Di-RutaGRI.Libre_c05 = CcbAdocu.Libre_c[16].
        /* RHC 18/09/2019 En caso de DEJADO EN TIENDA */
        /* RHC 16/06/2019 Lugar de entrega (* O/D)*/
        RUN logis/p-lugar-de-entrega (Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-PuntoLlegada).
        IF NUM-ENTRIES(x-PuntoLlegada, '|') >= 2 THEN
            ASSIGN
            Di-RutaGRI.Libre_c01 = ENTRY(2, x-PuntoLlegada, '|').
    END.
    FOR EACH Di-RutaG OF B-RUTAC NO-LOCK,
        FIRST Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia
          AND Almcmov.CodAlm = Di-RutaG.CodAlm
          AND Almcmov.TipMov = Di-RutaG.Tipmov
          AND Almcmov.CodMov = Di-RutaG.Codmov
          AND Almcmov.NroSer = Di-RutaG.serref
          AND Almcmov.NroDoc = Di-RutaG.nroref,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Almcmov.codcia AND
            Faccpedi.coddoc = Almcmov.codref AND   /* OTR */
            Faccpedi.nroped = Almcmov.nroref,
        FIRST Ccbadocu NO-LOCK WHERE CcbADocu.CodCia = Faccpedi.codcia AND
            CcbADocu.CodDiv = Faccpedi.coddiv AND
            CcbADocu.CodDoc = Faccpedi.coddoc AND
            CcbADocu.NroDoc = Faccpedi.nroped:
        FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaG.CodCia AND
            Di-RutaGRI.CodDiv = Di-RutaG.CodDiv AND
            Di-RutaGRI.CodDoc = Di-RutaG.CodDoc AND     /* H/R */
            Di-RutaGRI.NroDoc = Di-RutaG.NroDoc AND
            Di-RutaGRI.CodRef = Di-RutaD.CodRef AND     /* G/R */
            Di-RutaGRI.NroRef = Di-RutaD.NroRef     
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Di-RutaGRI THEN DO:
            CREATE Di-RutaGRI.
            ASSIGN
                Di-RutaGRI.CodCia = Di-RutaD.CodCia 
                Di-RutaGRI.CodDiv = Di-RutaD.CodDiv 
                Di-RutaGRI.CodDoc = Di-RutaD.CodDoc      /* H/R */
                Di-RutaGRI.NroDoc = Di-RutaD.NroDoc 
                Di-RutaGRI.CodRef = Di-RutaD.CodRef      /* G/R */
                Di-RutaGRI.NroRef = Di-RutaD.NroRef.  
        END.
        ELSE DO:
            FIND CURRENT Di-RutaGRI EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
        END.
        ASSIGN
            Di-RutaGRI.Libre_c01 = CcbAdocu.Libre_c[12]
            Di-RutaGRI.Libre_c02 = CcbAdocu.Libre_c[13]
            Di-RutaGRI.Libre_c03 = CcbAdocu.Libre_c[14]
            Di-RutaGRI.Libre_c04 = CcbAdocu.Libre_c[15]
            Di-RutaGRI.Libre_c05 = CcbAdocu.Libre_c[16].
        /* RHC 18/09/2019 En caso de DEJADO EN TIENDA */
        /* RHC 16/06/2019 Lugar de entrega (* O/D)*/
        RUN logis/p-lugar-de-entrega (Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-PuntoLlegada).
        IF NUM-ENTRIES(x-PuntoLlegada, '|') >= 2 THEN
            ASSIGN
            Di-RutaGRI.Libre_c01 = ENTRY(2, x-PuntoLlegada, '|').
    END.
    /* ********************************************************************** */
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


