&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          cissac           PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER BDMOV FOR cissac.Almdmov.
DEFINE BUFFER BDMOV-ING FOR INTEGRAL.Almdmov.



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

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codalm AS CHAR NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.

FIND integral.Lg-cocmp WHERE ROWID(integral.Lg-cocmp) = pRowid NO-LOCK NO-ERROR.

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
      TABLE: BDMOV B "?" ? cissac Almdmov
      TABLE: BDMOV-ING B "?" ? INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DISABLE TRIGGERS FOR LOAD OF cissac.faccpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.facdpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF cissac.ccbddocu.
DISABLE TRIGGERS FOR LOAD OF cissac.almcmov.
DISABLE TRIGGERS FOR LOAD OF cissac.almdmov.
DISABLE TRIGGERS FOR LOAD OF cissac.almmmate.
DISABLE TRIGGERS FOR LOAD OF integral.almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.almmmate.

DEF BUFFER CCOT FOR cissac.faccpedi.
DEF BUFFER CPED FOR cissac.faccpedi.
DEF BUFFER CORD FOR cissac.faccpedi.
DEF BUFFER CGUI FOR cissac.ccbcdocu.
DEF BUFFER CFAC FOR cissac.ccbcdocu.

FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
    AND cissac.Almacen.codalm = integral.Lg-cocmp.codalm
    NO-LOCK NO-ERROR.
ASSIGN
    s-codalm = cissac.Almacen.codalm
    s-coddiv = cissac.Almacen.coddiv.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* BARREMOS LAS COTIZACIONES */
    FOR EACH CCOT WHERE CCOT.codcia = s-codcia
        AND CCOT.coddiv = s-coddiv
        AND CCOT.coddoc = "COT"
        AND CCOT.ordcmp = STRING(integral.Lg-cocmp.nrodoc, "9999999")
        AND CCOT.fchped >= integral.Lg-cocmp.fchdoc:
        /* BARREMOS LOS PEDIDOS */
        FOR EACH CPED WHERE CPED.codcia = s-codcia
            AND CPED.coddiv = s-coddiv
            AND CPED.coddoc = "PED"
            AND CPED.codref = CCOT.coddoc
            AND CPED.nroref = CCOT.nroped:
            /* BARREMOS LAS ORDENES DE DESPACHO */
            FOR EACH CORD WHERE CORD.codcia = s-codcia
                AND CORD.coddiv = s-coddiv
                AND CORD.coddoc = "O/D"
                AND CORD.codref = CPED.coddoc
                AND CORD.nroref = CPED.nroped:
                /* BARREMOS LAS GUIAS DE REMISION */
                FOR EACH CGUI WHERE CGUI.codcia = s-codcia
                    AND CGUI.coddiv = s-coddiv
                    AND CGUI.coddoc = "G/R"
                    AND CGUI.codped = CORD.coddoc
                    AND CGUI.nroped = CORD.nroped:
                    /* BARREMOS LAS FACTURAS */
                    FOR EACH CFAC WHERE CFAC.codcia = s-codcia
                        AND CFAC.coddiv = s-coddiv
                        AND CFAC.coddoc = "FAC"
                        AND CFAC.codref = CGUI.coddoc
                        AND CFAC.nroref = CGUI.nrodoc:
                        /* ANULAMOS FACTURAS */
                        ASSIGN 
                            CFAC.FlgEst = "A"
                            CFAC.SdoAct = 0
                            CFAC.UsuAnu = S-USER-ID
                            CFAC.FchAnu = TODAY
                            CFAC.Glosa  = "A N U L A D O".
                        /*MESSAGE 'ANULADA:' CFAC.coddoc CFAC.nrodoc.*/
                    END.
                    /* ACTUALIZAMOS ALMACEN */
                    RUN des_alm ( ROWID (CGUI) ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.
                    /*MESSAGE 'ANULADO MOV ALMACEN:' CGUI.coddoc CGUI.nrodoc.*/

                    /* ANULAMOS INGRESO POR ORDEN DE COMPRA EN CONTINENTAL */
                    RUN Anula-Ingreso-por-Compra ( CGUI.NroDoc ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.
                    /*MESSAGE 'ANULADO ING X O/C CONTI:' CGUI.coddoc CGUI.nrodoc.*/

                    /* ANULAMOS GUIA */
                    ASSIGN 
                        CGUI.FlgEst = "A"
                        CGUI.SdoAct = 0
                        CGUI.Glosa  = "** A N U L A D O **"
                        CGUI.FchAnu = TODAY
                        CGUI.Usuanu = s-User-Id.
                    /*MESSAGE 'ANULADO GUIA:' CGUI.coddoc CGUI.nrodoc.*/
                END.
                /* ANULAMOS ORDENES DE DESPACHO */
                ASSIGN 
                    CORD.FlgEst = "A"
                    CORD.Glosa = " A N U L A D O".
                /*MESSAGE 'ANULADA O/D:' CORD.coddoc CORD.nroped.*/
            END.
            /* ANULAMOS PEDIDOS */
            ASSIGN 
                CPED.FlgEst = "A"
                CPED.Glosa = " A N U L A D O".
            /*MESSAGE 'ANULADA PEDIDO:' CPED.coddoc CPED.nroped.*/
        END.
        /* ANULAMOS COTIZACIONES */
        ASSIGN 
            CCOT.FlgEst = "A"
            CCOT.Glosa = " A N U L A D O".
        /*MESSAGE 'ANULADA COTIZACION:' CCOT.coddoc CCOT.nroped.*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-almacpr1) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE almacpr1 Procedure 
PROCEDURE almacpr1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE INPUT PARAMETER C-UD   AS CHAR.

DEFINE VARIABLE I-CODMAT   AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM   AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-IMPCTO   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKACT   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-INGRESO  AS LOGICAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND BDMOV WHERE ROWID(BDMOV) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE BDMOV THEN RETURN "OK".
/* Inicio de Transaccion */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************** RHC 30.03.04 ******************* */
    FIND BDMOV WHERE ROWID(BDMOV) = r-dmov NO-LOCK NO-ERROR.
    ASSIGN I-CODMAT = BDMOV.CodMaT
           C-CODALM = BDMOV.CodAlm
           F-CANDES = BDMOV.CanDes
           F-IMPCTO = BDMOV.ImpCto.
    IF BDMOV.Factor > 0 THEN ASSIGN F-CANDES = BDMOV.CanDes * BDMOV.Factor.
    /* Buscamos el stock inicial */
    FIND PREV BDMOV USE-INDEX ALMD02 WHERE BDMOV.codcia = s-codcia
        AND BDMOV.codmat = i-codmat
        AND BDMOV.codalm = c-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE BDMOV
    THEN f-StkSub = BDMOV.stksub.
    ELSE f-StkSub = 0.
    /* actualizamos el kardex por almacen */
    FIND BDMOV WHERE ROWID(BDMOV) = r-dmov EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF C-UD = 'D'       /* Eliminar */
    THEN BDMOV.candes = 0.        /* OJO */
    REPEAT WHILE AVAILABLE BDMOV:
        L-INGRESO = LOOKUP(BDMOV.TipMov,"I,U") <> 0.
        F-CANDES = BDMOV.CanDes.
        IF BDMOV.Factor > 0 THEN F-CANDES = BDMOV.CanDes * BDMOV.Factor.
        IF L-INGRESO 
        THEN F-STKSUB = F-STKSUB + F-CANDES.
        ELSE F-STKSUB = F-STKSUB - F-CANDES.
        BDMOV.StkSub = F-STKSUB.      /* OJO */
        FIND NEXT BDMOV USE-INDEX ALMD02 WHERE BDMOV.codcia = s-codcia
            AND BDMOV.codmat = i-codmat
            AND BDMOV.codalm = c-codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE BDMOV
        THEN DO:
            FIND CURRENT BDMOV EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
        END.
    END.
END.        
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ALMACPR1-ING) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALMACPR1-ING Procedure 
PROCEDURE ALMACPR1-ING :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE INPUT PARAMETER C-UD   AS CHAR.
DEFINE VARIABLE I-CODMAT   AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM   AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-IMPCTO   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKACT   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-INGRESO  AS LOGICAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND BDMOV-ING WHERE ROWID(BDMOV-ING) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE BDMOV-ING THEN RETURN 'OK'.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************** RHC 30.03.04 ******************* */
    FIND BDMOV-ING WHERE ROWID(BDMOV-ING) = r-dmov NO-LOCK NO-ERROR.
    ASSIGN I-CODMAT = BDMOV-ING.CodMaT
           C-CODALM = BDMOV-ING.CodAlm
           F-CANDES = BDMOV-ING.CanDes
           F-IMPCTO = BDMOV-ING.ImpCto.
    IF BDMOV-ING.Factor > 0 THEN ASSIGN F-CANDES = BDMOV-ING.CanDes * BDMOV-ING.Factor.
    /* Buscamos el stock inicial */
    FIND PREV BDMOV-ING USE-INDEX ALMD03 WHERE BDMOV-ING.codcia = s-codcia
        AND BDMOV-ING.codmat = i-codmat
        AND BDMOV-ING.codalm = c-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE BDMOV-ING
    THEN f-StkSub = BDMOV-ING.stksub.
    ELSE f-StkSub = 0.
    /* actualizamos el kardex por almacen */
    FIND BDMOV-ING WHERE ROWID(BDMOV-ING) = r-dmov EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
    IF C-UD = 'D'       /* Eliminar */
    THEN BDMOV-ING.candes = 0.        /* OJO */
    REPEAT WHILE AVAILABLE BDMOV-ING:
        L-INGRESO = LOOKUP(BDMOV-ING.TipMov,"I,U") <> 0.
        F-CANDES = BDMOV-ING.CanDes.
        IF BDMOV-ING.Factor > 0 THEN F-CANDES = BDMOV-ING.CanDes * BDMOV-ING.Factor.
        IF L-INGRESO 
        THEN F-STKSUB = F-STKSUB + F-CANDES.
        ELSE F-STKSUB = F-STKSUB - F-CANDES.
        BDMOV-ING.StkSub = F-STKSUB.      /* OJO */
        /*FIND NEXT BDMOV-ING USE-INDEX ALMD02 WHERE BDMOV-ING.codcia = s-codcia*/
        FIND NEXT BDMOV-ING USE-INDEX ALMD03 WHERE BDMOV-ING.codcia = s-codcia
            AND BDMOV-ING.codmat = i-codmat
            AND BDMOV-ING.codalm = c-codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE BDMOV-ING
        THEN DO:
            FIND CURRENT BDMOV-ING EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN "ADM-ERROR".
        END.
    END.
END.        
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-almacstk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE almacstk Procedure 
PROCEDURE almacstk :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.

DEFINE VARIABLE I-CODMAT AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUNI AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUMN AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUME AS DECIMAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND BDMOV WHERE ROWID(BDMOV) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE BDMOV THEN RETURN.

ASSIGN I-CODMAT = BDMOV.CodMaT
       C-CODALM = BDMOV.CodAlm
       F-CANDES = BDMOV.CanDes
       F-PREUNI = BDMOV.PreUni.
IF BDMOV.CodMon = 1 
THEN DO:
     F-PREUMN = BDMOV.PreUni.
     IF BDMOV.TpoCmb > 0 
     THEN F-PREUME = ROUND(BDMOV.PreUni / BDMOV.TpoCmb,4).
     ELSE F-PREUME = 0.
END.
ELSE ASSIGN F-PREUMN = ROUND(BDMOV.PreUni * BDMOV.TpoCmb,4)
            F-PREUME = BDMOV.PreUni.
IF BDMOV.Factor > 0 THEN ASSIGN F-CANDES = BDMOV.CanDes * BDMOV.Factor
                                  F-PREUNI = BDMOV.PreUni / BDMOV.Factor
                                  F-PREUMN = F-PREUMN / BDMOV.Factor
                                  F-PREUME = F-PREUME / BDMOV.Factor.

/* Actualizamos a los Materiales por Almacen */
FIND cissac.Almmmate WHERE cissac.Almmmate.CodCia = S-CODCIA AND
     cissac.Almmmate.CodAlm = C-CODALM AND 
     cissac.Almmmate.CodMat = I-CODMAT EXCLUSIVE-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.

ASSIGN cissac.Almmmate.StkAct = cissac.Almmmate.StkAct + F-CANDES.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ALMDCSTK) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALMDCSTK Procedure 
PROCEDURE ALMDCSTK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE VARIABLE I-CODMAT AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUNI AS DECIMAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND BDMOV-ING WHERE ROWID(BDMOV-ING) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE BDMOV-ING THEN RETURN 'OK'.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    ASSIGN 
      I-CODMAT = BDMOV-ING.CodMaT
      C-CODALM = BDMOV-ING.CodAlm
      F-CANDES = BDMOV-ING.CanDes
      F-PREUNI = BDMOV-ING.PreUni.
    IF BDMOV-ING.Factor > 0 
    THEN ASSIGN 
              F-CANDES = BDMOV-ING.CanDes * BDMOV-ING.Factor
              F-PREUNI = BDMOV-ING.PreUni / BDMOV-ING.Factor.
    /* Des-Actualizamos a los Materiales por Almacen */
    FIND integral.Almmmate WHERE integral.Almmmate.CodCia = S-CODCIA AND
          integral.Almmmate.CodAlm = C-CODALM AND 
          integral.Almmmate.CodMat = I-CODMAT EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almmmate THEN DO:
        MESSAGE 'Codigo' i-codmat 'NO asignado en el almacen' c-codalm
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    integral.Almmmate.StkAct = integral.Almmmate.StkAct - F-CANDES.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Anula-Ingreso-por-Compra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Ingreso-por-Compra Procedure 
PROCEDURE Anula-Ingreso-por-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-NroRf3 AS CHAR.

DEF VAR r-Rowid AS ROWID NO-UNDO.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND FIRST integral.Almcmov WHERE integral.Almcmov.CodCia  = s-CodCia 
        AND integral.Almcmov.CodAlm  = s-CodAlm 
        AND integral.Almcmov.TipMov  = "I"
        AND integral.Almcmov.CodMov  = 02
        AND integral.Almcmov.NroSer  = 000
        AND integral.Almcmov.FchDoc >= integral.Lg-cocmp.FchDoc
        AND integral.Almcmov.NroRf3  = x-NroRf3
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almcmov THEN UNDO trloop, RETURN ERROR.
    FOR EACH integral.Almdmov OF integral.Almcmov EXCLUSIVE-LOCK:
        ASSIGN R-ROWID = ROWID(integral.Almdmov).
        RUN ALMDCSTK (R-ROWID). /* Descarga del Almacen */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.

        RUN ALMACPR1-ING (R-ROWID,"D").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.

        /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
        RUN ALM\ALMACPR2 (R-ROWID,"D").
        *************************************************** */
        DELETE integral.Almdmov.
    END.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-des_alm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE des_alm Procedure 
PROCEDURE des_alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER X-ROWID AS ROWID.

FIND cissac.ccbcdocu WHERE ROWID(cissac.ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE cissac.ccbcdocu THEN RETURN ERROR.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Anulamos orden de despacho */
    FIND cissac.almcmov WHERE cissac.almcmov.codcia = cissac.ccbcdocu.codcia 
        AND cissac.almcmov.codalm = cissac.ccbcdocu.codalm 
        AND cissac.almcmov.tipmov = "S" 
        AND cissac.almcmov.codmov = cissac.ccbcdocu.codmov 
        AND cissac.almcmov.nroSer = 0  
        AND cissac.almcmov.nrodoc = INTEGER(cissac.ccbcdocu.nrosal) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE cissac.almcmov THEN DO:
        FOR EACH cissac.almdmov OF cissac.almcmov:
            /* RUN alm/almcgstk (ROWID(cissac.almdmov)). */
            RUN almacstk (ROWID(cissac.almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR.
            /* RHC 05.04.04 ACTIVAMOS KARDEX POR ALMACEN */
            RUN almacpr1 (ROWID(cissac.almdmov), 'D').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR.
            DELETE cissac.almdmov.
        END.
        ASSIGN 
            cissac.almcmov.flgest = "A".
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

