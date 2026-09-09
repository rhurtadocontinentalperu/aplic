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

DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-gre_detail FOR gre_detail.

DEFINE BUFFER b-oo_gre_header FOR oo_gre_header.
DEFINE BUFFER b-oo_gre_detail FOR oo_gre_detail.

DEFINE NEW SHARED VAR s-codcia AS INT.

s-codcia = 1.

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
         HEIGHT             = 6.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VAR cDivisionOrigen AS CHAR.
DEFINE VAR cDivisionDestino AS CHAR.
DEFINE VAR iItems AS INT.
DEFINE VAR lTransaccionOK AS LOG.

RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","Inicio de proceso").

FOR EACH oo_gre_header WHERE oo_gre_header.m_rspta_sunat = "" NO-LOCK:

    RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","    PGRE " + STRING(oo_gre_header.ncorrelatio)).

    FIND FIRST Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = oo_gre_header.m_codalm NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen OR almacen.campo-c[9] = "I" THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"Codigo de almacen origen (" + oo_gre_header.m_codalm + ") no existe o no esta activo").
        NEXT.
    END.
    cDivisionOrigen = almacen.coddiv.

    IF NOT (TRUE <> (oo_gre_header.m_codalmDes > ""))  THEN DO:
        FIND FIRST Almacen WHERE Almacen.CodCia = S-CODCIA 
                      AND  Almacen.CodAlm = oo_gre_header.m_codalmDes NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen OR almacen.campo-c[9] = "I" THEN DO:
            RUN graba-registro-error(ROWID(oo_gre_header),"Codigo de almacen destino (" + oo_gre_header.m_codalmdes + ") no existe o no esta activo").
            NEXT.
        END.
        cDivisionDestino = almacen.coddiv.
    END.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = cDivisionOrigen NO-LOCK NO-ERROR.   
    IF NOT AVAILABLE gn-divi THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"La division (" + cDivisionOrigen + ") a la que pertenece el almacen origen no esta registrado").
        NEXT.
    END.
    IF oo_gre_header.m_tipmov <> "S" THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"El tipo de movimiento debe contener 'S'").
        NEXT.
    END.
    FIND FIRST Almtmovm WHERE Almtmovm.codcia = 1 AND Almtmovm.tipmov = oo_gre_header.m_tipmov AND 
                    Almtmovm.codmov = oo_gre_header.m_codmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtmovm THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"El codigo de movimiento no existe").
        NEXT.
    END.

    FIND FIRST Sunat_Fact_Electr_Detail WHERE Sunat_Fact_Electr_Detail.Catalogue = 20 AND
                                                Sunat_Fact_Electr_Detail.CODE = oo_gre_header.motivoTraslado NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Sunat_Fact_Electr_Detail THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"El motivo de traslado de la SUNAT no existe").
        NEXT.
    END.
    IF oo_gre_header.numeroBultos <= 0 THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"Falta numero de Bultos").
        NEXT.
    END.
    IF oo_gre_header.pesoBrutoTotalBienes <= 0 THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"Falta el peso total").
        NEXT.
    END.
    
    FIND FIRST b-gre_header WHERE b-gre_header.ncorrelatio = oo_gre_header.ncorrelatio EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-gre_header THEN DO:
       RELEASE b-gre_header NO-ERROR.
       /**/
       RUN graba-registro-error(ROWID(oo_gre_header),"Numero de la PGRE ya existe").
       NEXT.
    END.
    
    iItems = 0.
    QITEMS:
    FOR EACH oo_gre_detail WHERE oo_gre_detail.ncorrelativo = oo_gre_header.ncorrelatio NO-LOCK:
        iItems = iItems + 1.
        LEAVE QITEMS.
    END.
    IF iItems = 0 THEN DO:
        RUN graba-registro-error(ROWID(oo_gre_header),"NO tiene Items").
        NEXT.
    END.

    RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","        TRANSACTION BEGIN ").

    lTransaccionOK = NO.

    GRABAR_GRE:
    DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
        /* Cabecera */
        CREATE b-gre_header.
        BUFFER-COPY oo_gre_header TO b-gre_header NO-ERROR.            
        IF ERROR-STATUS:ERROR THEN DO:
            RUN graba-registro-error(ROWID(oo_gre_header),"gre_header Buffer-copy: " + ERROR-STATUS:GET-MESSAGE(1)).
            RELEASE b-gre_header NO-ERROR.
            UNDO GRABAR_GRE, LEAVE GRABAR_GRE.
        END.
        ASSIGN b-gre_header.m_fechahorareg = NOW
               b-gre_header.m_rspta_sunat = "SIN ENVIAR".

        /* Detail */
        FOR EACH oo_gre_detail WHERE oo_gre_detail.ncorrelativo = oo_gre_header.ncorrelatio NO-LOCK:
            CREATE b-gre_detail.
            BUFFER-COPY oo_gre_detail TO b-gre_detail NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                RUN graba-registro-error(ROWID(oo_gre_header),"gre_detail Buffer-copy: " + ERROR-STATUS:GET-MESSAGE(1)).
                RELEASE b-gre_detail NO-ERROR.
                UNDO GRABAR_GRE, LEAVE GRABAR_GRE.
            END.
        END.
        RELEASE b-gre_header NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RUN graba-registro-error(ROWID(oo_gre_header),"b-gre_header release: " + ERROR-STATUS:GET-MESSAGE(1)).
            UNDO GRABAR_GRE, LEAVE GRABAR_GRE.
        END.
        RELEASE b-gre_detail NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RUN graba-registro-error(ROWID(oo_gre_header),"b-gre_detail release: " + ERROR-STATUS:GET-MESSAGE(1)).
            UNDO GRABAR_GRE, LEAVE GRABAR_GRE.
        END.
        /* Actualizar el estado de OO_GRE_HEADER */
        FIND FIRST b-oo_gre_header WHERE ROWID(b-oo_gre_header) = ROWID(oo_gre_header) EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED b-oo_gre_header THEN DO:
            RELEASE b-oo_gre_header.
            RUN graba-registro-error(ROWID(oo_gre_header),ERROR-STATUS:GET-MESSAGE(1)).
            UNDO GRABAR_GRE, LEAVE GRABAR_GRE.
        END.
        ASSIGN b-oo_gre_header.m_rspta_sunat = "PROCESADO".

        RELEASE b-oo_gre_header NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","        " + ERROR-STATUS:GET-MESSAGE(1)).
            UNDO GRABAR_GRE, LEAVE GRABAR_GRE.
        END.
        lTransaccionOK = YES.
    END.
    IF lTransaccionOK = YES THEN DO:
        RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","        TRANSACTION END ").
    END.
    ELSE DO:
        RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","        TRANSACTION CON ERROR ").
    END.
    RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","    PGRE " + STRING(oo_gre_header.ncorrelatio)).
END.

RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","Fin de proceso").

QUIT.

/*RETURN.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-graba-registro-error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE graba-registro-error Procedure 
PROCEDURE graba-registro-error :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowId AS ROWID.
DEFINE INPUT PARAMETER pMensaje AS CHAR.

RUN lib/p-write-log-txt.r("PGRE-OO-2-PROGRESS","            " + pMensaje).

FIND FIRST b-oo_gre_header WHERE ROWID(b-oo_gre_header) = ROWID(oo_gre_header) EXCLUSIVE-LOCK NO-ERROR.
IF LOCKED b-oo_gre_header THEN DO:
    RELEASE b-oo_gre_header.
    RETURN "ADM-ERROR".
END.
IF NOT AVAILABLE b-oo_gre_header THEN DO:
    RELEASE b-oo_gre_header.
    RETURN "ADM-ERROR".
END.

ASSIGN b-oo_gre_header.m_rspta_sunat = "REGISTRO CON ERROR"
        b-oo_gre_header.m_motivo_de_rechazo = pMensaje.

RELEASE b-oo_gre_header NO-ERROR.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

