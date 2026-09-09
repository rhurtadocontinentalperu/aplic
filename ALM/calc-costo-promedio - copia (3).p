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



/* ***************************** CAMBIOS EN EL SISTEMA 

CRITERIOS CON RESPCTO AL RECALCULO DEL ARTICULO 064031

jueves, 05 de noviembre de 2015
12:59 p.m.

Asunto
CRITERIOS CON RESPCTO AL RECALCULO DEL ARTICULO 064031
De
Roxana Elera - Contabilidad
Para
Ruben Hurtado; Flor Campos; Enrique Macchiu - Analista de Sistemas
Enviado
jueves, 05 de noviembre de 2015 11:24 a.m.

 Estimado Sr Rubén, el criterio para proceder con el recalculo del artículo 064031 es que el costo 
sea "0" hasta el momento en que el artículo quede en positivo, luego de lo cual se debe tomar 
el costo del primer ingreso y proceder a hacer el cálculo normal del costo promedio a partir de allí.
Cualquier duda, por favor hágamela saber.
Gracias por su ayuda.
MREL


************************************************************************************************* */

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
         HEIGHT             = 5.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pFchDoc AS DATE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER B-STKAL FOR AlmStkAl.
DEF BUFFER B-STKGE FOR AlmStkGe.

DISABLE TRIGGERS FOR LOAD OF almcmov.
DISABLE TRIGGERS FOR LOAD OF almdmov.

DEF SHARED VAR s-codcia AS INT.

DEF VAR x-signo  AS DECI NO-UNDO.  
DEF VAR x-ctomed AS DECI NO-UNDO.
DEF VAR x-stkgen AS DECI NO-UNDO.
DEF VAR x-cto    AS DECI NO-UNDO.
DEF VAR x-factor AS INTE NO-UNDO.
DEF VAR f-candes AS DECI NO-UNDO.
DEF VAR x-SaldoActual AS DEC NO-UNDO.

DEF VAR x-Contador AS INT NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN 'OK'.
/* ********************************************************************* */
/* RHC 11/06/2020 Los productos de CATEGORIA CONTABLE = "SV" 
        NO generan KARDEX */
/* ********************************************************************* */
FIND Almtfami WHERE Almtfami.codcia = Almmmatg.codcia AND
    Almtfami.codfam = Almmmatg.codfam NO-LOCK NO-ERROR.
IF AVAILABLE Almtfami AND Almtfami.Libre_c01 = "SV" THEN RETURN "OK".
/* ********************************************************************* */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Borra-Historico.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN
        x-stkgen = 0
        x-ctomed = 0.
    FIND LAST AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA 
        AND AlmStkGe.CodMat = Almmmatg.CodMat 
        AND AlmStkGe.Fecha  < pFchDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkGe THEN DO:
        ASSIGN
            x-stkgen = AlmStkGe.StkAct
            x-ctomed = AlmStkGe.CtoUni.
    END.
    /*************Ordenes Movimiento por Producto y Fecha *******************/     
    RUN Costo-Promedio.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA NO-LOCK ON ERROR UNDO, THROW:
        FIND LAST AlmStkAl WHERE AlmStkAl.Codcia = Almacen.Codcia 
            AND AlmStkAl.CodAlm = Almacen.CodAlm 
            AND AlmStkAl.CodMat = Almmmatg.CodMat
            NO-LOCK NO-ERROR. 
        IF AVAILABLE AlmStkAl THEN DO:
            FIND FIRST Almmmate WHERE Almmmate.Codcia = S-CODCIA 
                AND Almmmate.CodAlm = Almacen.CodAlm 
                AND Almmmate.CodMat = Almmmatg.CodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN DO:
                /* Nuevo */
                CREATE Almmmate.
                ASSIGN
                    almmmate.codcia = S-CODCIA
                    almmmate.codalm = almacen.codalm
                    almmmate.codmat = almmmatg.codmat
                    almmmate.desmat = almmmatg.desmat
                    almmmate.undvta = almmmatg.undstk
                    almmmate.facequ = 1
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = NO THEN Almmmate.Stkact = AlmStkAl.StkAct.  
            END.
            ELSE DO:
                /* Existe */
                x-Contador = 0.
                REPEAT:
                    x-Contador = x-Contador + 1.
                    IF x-Contador >= 10 THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                    FIND CURRENT Almmmate EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF AVAILABLE Almmmate THEN LEAVE.
                    ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
                END.
                Almmmate.Stkact = AlmStkAl.StkAct.  
            END.
        END.
    END.
END.
IF AVAILABLE(AlmStkAl) THEN RELEASE AlmStkAl.
IF AVAILABLE(AlmStkGe) THEN RELEASE AlmStkGe.
IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
IF AVAILABLE(Almdmov)  THEN RELEASE Almdmov.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Borra-Historico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Historico Procedure 
PROCEDURE Borra-Historico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b-StkAl FOR AlmSTkAl.
DEF BUFFER b-STkGe FOR AlmSTkGe.
DEF BUFFER b-MMate FOR Almmmate.
DEF VAR x-Contador AS INT NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BORRAMOS HISTORICOS */
    FOR EACH AlmStkAl NO-LOCK WHERE AlmStkAl.Codcia = S-CODCIA 
        AND AlmStkAl.CodMat = Almmmatg.CodMat 
        AND AlmStkAl.Fecha >= pFchDoc:
        x-Contador = 0.
        REPEAT:
            x-Contador = x-Contador + 1.
            IF x-Contador >= 10 THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
            FIND b-StkAl WHERE ROWID(b-STkAl) = ROWID(AlmStkAl) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-STkAl THEN DO:
                DELETE AlmSTkAl.
                LEAVE.
            END.
            ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        END.
    END.
    FOR EACH AlmStkGe NO-LOCK WHERE AlmStkGe.Codcia = S-CODCIA 
        AND AlmStkGe.CodMat = Almmmatg.CodMat 
        AND AlmStkGe.Fecha >= pFchDoc:
        x-Contador = 0.
        REPEAT:
            x-Contador = x-Contador + 1.
            IF x-Contador >= 10 THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
            FIND b-StkGe WHERE ROWID(b-STkGe) = ROWID(AlmStkGe) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-STkGe THEN DO:
                DELETE AlmSTkGe.
                LEAVE.
            END.
            ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        END.
    END.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.Codcia = S-CODCIA 
        AND Almmmate.CodMat = Almmmatg.CodMat:
        x-Contador = 0.
        REPEAT:
            x-Contador = x-Contador + 1.
            IF x-Contador >= 10 THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
            FIND b-Mmate WHERE ROWID(b-MMate) = ROWID(Almmmate) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-MMate THEN DO:
                b-Mmate.StkAct = 0.
                LEAVE.
            END.
            ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        END.
    END.
END.
RELEASE b-StkAl.
RELEASE b-STkGe.
RELEASE b-Mmate.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Costo-Promedio) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Costo-Promedio Procedure 
PROCEDURE Costo-Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* Hasta 10 intentos */
------------------------------------------------------------------------------*/

    DEF BUFFER B-DMOV FOR Almdmov.
    PRINCIPAL:
    FOR EACH B-DMOV USE-INDEX Almd02 NO-LOCK WHERE B-DMOV.Codcia = S-CODCIA 
        AND B-DMOV.CodMat = Almmmatg.CodMat 
        AND B-DMOV.FchDoc >= pFchDoc:
        /* Bloqueamos Almdmov */
        x-Contador = 0.
        REPEAT:
            x-Contador = x-Contador + 1.
            IF x-Contador >= 10 THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            FIND Almdmov WHERE ROWID(Almdmov) = ROWID(B-DMOV) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE Almdmov THEN DO:
                LEAVE.
            END.
            ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        END.
        /* FILTROS */
        FIND FIRST almacen WHERE almacen.codcia = almdmov.codcia
            AND almacen.codalm = almdmov.codalm  
            USE-INDEX alm01 NO-LOCK NO-ERROR.
        FIND Almtmovm WHERE almtmovm.codcia = almdmov.codcia
            AND almtmovm.tipmov = almdmov.tipmov
            AND almtmovm.codmov = almdmov.codmov
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtmovm AND almtmovm.movtrf = YES
        THEN x-Factor = 0.
        ELSE x-Factor = 1.

        /* 24/02/2020: Almacenes NO propios */
        IF AVAILABLE Almacen AND Almacen.FlgRep = NO THEN x-Factor = 0.

        IF AVAILABLE Almacen AND Almacen.AlmCsg = YES THEN x-Factor = 0.
        IF almdmov.tpocmb = 0 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= almdmov.fchdoc USE-INDEX cmb01 NO-LOCK NO-ERROR.
            IF AVAIL gn-tcmb THEN DO:
                IF almdmov.tipmov = "I" THEN almdmov.tpocmb = gn-tcmb.venta.
                IF almdmov.tipmov = "S" THEN almdmov.tpocmb = gn-tcmb.compra. 
            END.
        END.
        /* FIN DE FILTROS */
        f-candes = almdmov.candes * almdmov.factor.
        IF Almdmov.tipMov = "I" THEN x-signo = 1.
        IF Almdmov.tipMov = "S" THEN x-signo = -1.
        /***********Inicia Stock x Almacen********************/
        FIND FIRST AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA 
            AND AlmStkAl.CodAlm = Almdmov.CodAlm 
            AND AlmStkAl.CodMat = Almdmov.CodMat 
            AND AlmstkAl.Fecha  = Almdmov.FchDoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmStkAl THEN DO:      
            CREATE AlmStkAl.
            ASSIGN
               AlmStkAl.Codcia = S-CODCIA 
               AlmStkAl.CodAlm = Almdmov.CodAlm
               AlmStkAl.CodMat = Almdmov.CodMat
               AlmStkAl.Fecha  = Almdmov.FchDoc
               NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                FIND LAST AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA 
                    AND AlmStkAl.CodAlm = Almdmov.CodAlm 
                    AND AlmStkAl.CodMat = Almdmov.CodMat 
                    AND AlmstkAl.Fecha <= Almdmov.FchDoc
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE AlmStkAl THEN NEXT.
            END.
            ELSE DO:
                FIND LAST B-STKAL WHERE B-STKAL.Codcia = S-CODCIA 
                   AND B-STKAL.CodAlm = Almdmov.CodAlm 
                   AND B-STKAL.CodMat = Almdmov.CodMat 
                   AND B-STKAL.Fecha  < Almdmov.FchDoc
                   NO-LOCK NO-ERROR.
                IF AVAILABLE B-STKAL THEN AlmStkAl.StkAct = AlmStkAl.StkAct + B-STKAL.StkAct.
            END.
        END.
        x-Contador = 0.
        REPEAT:
            x-Contador = x-Contador + 1.
            IF x-Contador >= 10 THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            FIND CURRENT AlmStkAl EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE AlmStkAl THEN LEAVE.
            ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        END.
        ASSIGN
           AlmStkAl.StkAct = AlmStkAl.StkAct + (f-candes * x-signo).
        /***********Fin Stock x Almacen********************/
        FIND FIRST almtmov OF almdmov USE-INDEX mov01 NO-LOCK NO-ERROR.
        /***********Inicia Stock x Compañia********************/       
        FIND FIRST AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA 
           AND AlmStkGe.CodMat = Almdmov.CodMat 
           AND AlmstkGe.Fecha  = Almdmov.FchDoc
           NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmStkGe THEN DO:      
           CREATE AlmStkGe.
           ASSIGN
               AlmStkGe.Codcia = S-CODCIA 
               AlmStkGe.CodMat = Almdmov.CodMat
               AlmStkGe.Fecha  = Almdmov.FchDoc.
           FIND LAST B-STKGE WHERE B-STKGE.Codcia = S-CODCIA 
               AND B-STKGE.CodMat = Almdmov.CodMat 
               AND B-STKGE.Fecha  < Almdmov.FchDoc
               NO-LOCK NO-ERROR.
           IF AVAILABLE B-STKGE THEN AlmStkGe.StkAct = AlmStkGe.StkAct + B-STKGE.StkAct.                         
        END.
        x-Contador = 0.
        REPEAT:
            x-Contador = x-Contador + 1.
            IF x-Contador >= 10 THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            FIND CURRENT AlmStkGe EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE AlmStkGe THEN LEAVE.
            ELSE pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        END.
        ASSIGN
           AlmStkGe.StkAct = AlmStkGe.StkAct + (f-candes * x-signo * x-factor).
        /***********Fin Stock x Compañia********************/       
        /***********Inicia Calculo del Costo Promedio********************/       
        x-SaldoActual = AlmStkGe.StkAct - (f-candes * x-signo * x-factor).  /* Saldo en el Kardex en ese momento */
        IF AVAILABLE AlmTmov THEN DO:
           IF almtmov.TipMov = "I" AND x-Factor <> 0 THEN DO:
               x-cto = 0.
               IF Almtmov.TpoCto = 0 OR Almtmov.TpoCto = 1 THEN DO:
                   IF almdmov.codmon = 1 THEN x-cto = Almdmov.Preuni / Almdmov.factor.
                   IF almdmov.codmon = 2 THEN x-cto = Almdmov.Preuni / Almdmov.factor * Almdmov.TpoCmb.
                   /* RHC  22/01/2013 CASO DE "SOLO VALORES" */
                   IF Almtmovm.MovVal = NO THEN DO:
                       /* RHC 05/11/2015 */
                       IF x-SaldoActual > 0 AND AlmStkGe.StkAct > 0 THEN
                           x-ctomed = ((x-cto * f-candes) + (x-ctomed * x-SaldoActual)) / ( AlmStkGe.StkAct).
                       ELSE
                           x-ctomed = x-cto.
                       /* PARCHE 12.01.10 */
                       IF Almdmov.ImpCto = 0 THEN Almdmov.ImpCto = Almdmov.CanDes * Almdmov.PreUni.
                   END.
                   ELSE DO:
                       x-ctomed = ( x-cto + (x-ctomed * AlmStkGe.StkAct * x-signo) ) / AlmStkGe.StkAct.
                       /* PARCHE 12.01.10 */
                       IF Almdmov.ImpCto = 0 THEN Almdmov.ImpCto = Almdmov.PreUni.
                   END.
                   IF x-ctomed < 0 THEN x-ctomed = x-cto.
                   /*IF AlmStkGe.StkAct < f-candes AND AlmStkGe.StkAct >= 0 THEN x-ctomed = x-cto.*/
               END.
           END.
           /* RHC 08.02.2013 SALIDA por Devolución de Compras a precio de la O/C */
              IF Almtmov.TipMov = "S" AND x-Factor <> 0 AND Almdmov.FchDoc >= 12/01/2012
                  THEN DO:
                  IF ( Almtmov.MovCmp = YES AND Almtmov.CodMov = 09 )
                      OR ( Almtmov.MovCmp = YES AND Almtmov.CodMov <> 09 AND Almdmov.FchDoc > DATE(03,01,2016) )
                      THEN DO:
                      x-cto = 0.
                      IF almdmov.codmon = 1 THEN x-cto = Almdmov.Preuni / Almdmov.factor.
                      IF almdmov.codmon = 2 THEN x-cto = Almdmov.Preuni / Almdmov.factor * Almdmov.TpoCmb.
                      /* RHC  22/01/2013 CASO DE "SOLO VALORES" */
                      IF Almtmovm.MovVal = NO THEN DO:
                          IF x-SaldoActual > 0 AND AlmStkGe.StkAct > 0 THEN
                              x-ctomed = ( (x-ctomed * x-SaldoActual) - (x-cto * f-candes) ) / ( AlmStkGe.StkAct).
                          ELSE
                              x-ctomed = x-cto.
                          /* RHC 17/11/2015 Solicitado por Roxana Elera */
                          IF Almdmov.ImpCto = 0 THEN Almdmov.ImpCto = Almdmov.CanDes * Almdmov.PreUni.
                      END.
                      ELSE DO:
                          x-ctomed = ( (x-ctomed * AlmStkGe.StkAct * x-signo) - x-cto ) / AlmStkGe.StkAct.
                          IF Almdmov.ImpCto = 0 THEN Almdmov.ImpCto = Almdmov.PreUni.
                      END.
                      IF x-ctomed < 0 THEN x-ctomed = x-cto.
                      /*IF AlmStkGe.StkAct < f-candes AND AlmStkGe.StkAct >= 0 THEN x-ctomed = x-cto.*/
                  END.
              END.
          ASSIGN
               Almdmov.VctoMn1 = x-ctomed
               Almdmov.StkSub  = AlmStkAl.StkAct
               Almdmov.StkAct  = AlmStkGe.StkAct
               AlmStkGe.CtoUni = x-ctomed
               AlmStkAl.CtoUni = x-ctomed.
       END.
       ELSE DO:
          Almdmov.VctoMn1 = 0.
       END.
       /***********Fin    Calculo del Costo Promedio********************/       
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

