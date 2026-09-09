DEFINE VARIABLE s-codcia AS INTEGER     NO-UNDO INIT 1.
DEFINE BUFFER b-almdinv FOR integral.almdinv.    


IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar el stock'
      VIEW-AS ALERT-BOX WARNING.
END.

/*Carga Cissac*/
FOR EACH cissac.almcinv WHERE cissac.almcinv.codcia = s-codcia
    AND cissac.almcinv.swconteo = NO NO-LOCK:
    FOR EACH cissac.almdinv WHERE cissac.almdinv.codcia = s-codcia NO-LOCK,
        FIRST integral.almdinv WHERE integral.almdinv.codcia = s-codcia
        AND integral.almdinv.codalm = cissac.almdinv.codalm
        AND integral.almdinv.codmat = cissac.almdinv.codmat NO-LOCK:
        IF cissac.almdinv.qtyfisico <= integral.almdinv.qtyreconteo THEN
            ASSIGN
                cissac.almdinv.qtyconteo   = cissac.almdinv.qtyfisico
                cissac.almdinv.qtyreconteo = cissac.almdinv.qtyfisico
                cissac.almdinv.libre_d01   = cissac.almdinv.qtyfisico.
        ELSE 
            ASSIGN
                cissac.almdinv.qtyconteo   = integral.almdinv.qtyreconteo
                cissac.almdinv.qtyreconteo = integral.almdinv.qtyreconteo
                cissac.almdinv.libre_d01   = integral.almdinv.libre_d01.
        
        FIND FIRST b-almdinv WHERE ROWID(b-almdinv) = ROWID(integral.almdinv) 
            NO-LOCK NO-ERROR.
        IF AVAIL b-almdinv THEN 
            ASSIGN 
                b-almdinv.qtyreconteo = cissac.almdinv.qtyreconteo
                b-almdinv.libre_d01   = cissac.almdinv.libre_d01.
        
    END.
    cissac.almcinv.swconteo   = YES.
    cissac.almcinv.swreconteo = YES.
END.




