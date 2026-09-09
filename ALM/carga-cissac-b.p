IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
        'NO podemos capturar el stock'
        VIEW-AS ALERT-BOX WARNING.
END.

DEFINE INPUT PARAMETER calmacen AS CHAR.
DEFINE INPUT PARAMETER dFecha   AS DATE.
DEFINE OUTPUT PARAMETER x-task-no AS INT.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE TEMP-TABLE tmp-cissac
    FIELDS tt-codcia    LIKE integral.AlmDInv.Codcia 
    FIELDS tt-almacen   LIKE integral.AlmDInv.CodAlm     
    FIELDS tt-codubi    LIKE integral.AlmDInv.CodUbi     
    FIELDS tt-codmat    LIKE integral.AlmDInv.codmat 
    FIELDS tt-canfis    LIKE integral.AlmDInv.QtyFisico .

DEFINE VARIABLE l-Ubica   AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-task-no AS INTEGER NO-UNDO.
DEFINE VARIABLE iInt      AS INTEGER NO-UNDO.
DEFINE VARIABLE lAlm      AS LOGICAL NO-UNDO INIT YES.

/* IF calmacen = "" THEN DO:                                                     */
/*     FOR EACH cissac.almacen WHERE cissac.almacen.codcia = s-codcia NO-LOCK:   */
/*         calmacen = calmacen + cissac.almacen.codalm + ",".                    */
/*     END.                                                                      */
/* END.                                                                          */
/*                                                                               */
/* /*Comprueba si la informacion ha sido cargada para los almacenes ingresados*/ */
/* DO iInt = 1 TO NUM-ENTRIES(calmacen):                                         */
/*     FIND LAST cissac.almcinv WHERE cissac.almcinv.codcia = s-codcia           */
/*         AND cissac.almcinv.codalm = ENTRY(iInt,calmacen,",")                  */
/*         AND DATE(cissac.almcinv.fecupdate) = dfecha                           */
/*         /*AND cissac.almcinv.swconteo = NO*/ NO-LOCK NO-ERROR.                */
/*     IF NOT AVAIL cissac.almcinv THEN DO:                                      */
/*         MESSAGE "CISSAC: " SKIP                                               */
/*             "Debe cargar previamente el almacen " + ENTRY(iInt,calmacen,",")  */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                */
/*         RETURN "ADM-ERROR".                                                   */
/*         lAlm = NO.                                                            */
/*         LEAVE.                                                                */
/*     END.                                                                      */
/* END.                                                                          */
/*                                                                               */
/* IF lAlm THEN                                                                  */
/* DO iInt = 1 TO NUM-ENTRIES(cAlmacen) :                                        */
/*     FOR EACH cissac.almcinv WHERE cissac.almcinv.codcia = s-codcia            */
/*         AND cissac.almcinv.codalm = ENTRY(iInt,calmacen,",")                  */
/*         AND DATE(cissac.almcinv.fecupdate) = dfecha                           */
/*         /*                                                                    */
/*         AND cissac.almcinv.swconteo = NO                                      */
/*         */,                                                                   */
/*         EACH cissac.almdinv OF cissac.almcinv NO-LOCK:                        */
/*         FIND FIRST tmp-cissac WHERE tt-codcia  = s-codcia                     */
/*             AND tt-almacen = cissac.almdinv.codalm                            */
/*             AND tt-codubi  = cissac.almdinv.codubi                            */
/*             AND tt-codmat  = cissac.almdinv.codmat NO-LOCK NO-ERROR.          */
/*         IF NOT AVAILABLE tmp-cissac THEN DO:                                  */
/*             CREATE tmp-cissac.                                                */
/*             ASSIGN                                                            */
/*                 tt-codcia  = s-codcia                                         */
/*                 tt-almacen = cissac.almdinv.codalm                            */
/*                 tt-codubi  = cissac.almdinv.codubi                            */
/*                 tt-codmat  = cissac.almdinv.codmat.                           */
/*         END.                                                                  */
/*         ASSIGN tt-canfis  = cissac.almdinv.qtyfisico.                         */
/*         PAUSE 0.                                                              */
/*     END.                                                                      */
/* END.                                                                          */


/* FOR EACH cissac.almmmatg WHERE cissac.almmmatg.codcia = s-codcia NO-LOCK,      */
/*     EACH cissac.almmmate OF cissac.Almmmatg                                    */
/*     WHERE LOOKUP(TRIM(cissac.almmmate.codalm),cAlmacen) > 0                    */
/*     AND cissac.almmmate.stkact <> 0 NO-LOCK:                                   */
/*                                                                                */
/*     IF cissac.almmmatg.tpoart <> "A" AND cissac.almmmate.stkact = 0 THEN NEXT. */
/*     FIND FIRST tmp-cissac WHERE tt-codcia  = s-codcia                          */
/*         AND tt-almacen = cissac.almmmate.codalm                                */
/*         AND tt-codubi  = cissac.almmmate.codubi                                */
/*         AND tt-codmat  = cissac.almmmatg.codmat NO-LOCK NO-ERROR.              */
/*     IF NOT AVAILABLE tmp-cissac THEN DO:                                       */
/*         CREATE tmp-cissac.                                                     */
/*         ASSIGN                                                                 */
/*             tt-codcia  = s-codcia                                              */
/*             tt-almacen = cissac.almmmate.codAlm                                */
/*             tt-codubi  = cissac.almmmate.codubi                                */
/*             tt-codmat  = cissac.almmmatg.codmat.                               */
/*     END.                                                                       */
/*     ASSIGN tt-canfis  = cissac.almmmate.stkact.                                */
/*     PAUSE 0.                                                                   */
/* END.                                                                           */
/* HIDE FRAME f-Proceso.                                                          */



/*Carga Materiales por División*/
FOR EACH cissac.almmmatg WHERE cissac.almmmatg.codcia = s-codcia NO-LOCK,
    EACH cissac.almmmate OF cissac.Almmmatg 
    WHERE LOOKUP(TRIM(cissac.almmmate.codalm),cAlmacen) > 0 
    /*AND cissac.almmmate.stkact <> 0*/ NO-LOCK:        

    FIND LAST cissac.AlmStkAl /*USE-INDEX Llave03 */
        WHERE cissac.AlmStkAl.CodCia = s-codcia
        AND cissac.AlmStkAl.CodAlm  = TRIM(almmmate.codalm)
        AND cissac.almstkal.codmat  = almmmate.codmat
        AND cissac.AlmStkal.Fecha  <= dFecha  NO-LOCK NO-ERROR. /*11/28/2009 NO-LOCK NO-ERROR.    */

    IF AVAILABLE cissac.almstkal THEN DO:
        IF cissac.AlmStkal.StkAct = 0 THEN NEXT.
        FIND FIRST tmp-cissac WHERE tmp-cissac.tt-codcia  = s-codcia
            AND tmp-cissac.tt-almacen = cissac.almmmate.codalm 
            AND tmp-cissac.tt-codubi  = cissac.almmmate.codubi 
            AND tmp-cissac.tt-codmat  = cissac.almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-cissac THEN DO:
            CREATE tmp-cissac.
            ASSIGN
                tmp-cissac.tt-codcia  = s-codcia       
                tmp-cissac.tt-almacen = cissac.almmmate.CodAlm                
                tmp-cissac.tt-codubi  = cissac.almmmate.CodUbi
                tmp-cissac.tt-codmat  = cissac.almmmatg.CodMat.
        END.
        ASSIGN tmp-cissac.tt-canfis  = cissac.almstkal.stkact.        
        PAUSE 0.
    END.
END.

l-ubica = YES.
/*Cargando en el temporal del sistema*/
REPEAT WHILE L-Ubica:
   s-task-no = RANDOM(900000,999999).
   FIND FIRST integral.w-report WHERE integral.w-report.task-no = s-task-no NO-LOCK NO-ERROR.
   IF NOT AVAILABLE integral.w-report THEN L-Ubica = NO.
END.

x-task-no = s-task-no.
FOR EACH tmp-cissac:
    CREATE integral.w-report.
    ASSIGN
        integral.w-report.Task-No    = s-task-no
        integral.w-report.Llave-I    = tmp-cissac.tt-codcia
        integral.w-report.Campo-C[1] = tmp-cissac.tt-almacen
        integral.w-report.Campo-C[2] = tmp-cissac.tt-codubi
        integral.w-report.Campo-C[3] = tmp-cissac.tt-codmat        
        integral.w-report.Campo-F[1] = tmp-cissac.tt-canfis.
END.

