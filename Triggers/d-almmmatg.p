TRIGGER PROCEDURE FOR DELETE OF almmmatg.

    FIND FIRST Almdmov WHERE Almdmov.CodCia = Almmmatg.codcia
        AND Almdmov.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN DO:
       MESSAGE "Este producto presenta movimientos en el almacén" almdmov.codalm
           SKIP "No se puede eliminar" 
           VIEW-AS ALERT-BOX ERROR.
       RETURN ERROR.
    END.
    /* Materiales por almacen */
    FOR EACH Almmmate EXCLUSIVE-LOCK WHERE Almmmate.CodCia = Almmmatg.codcia 
        AND Almmmate.CodMat = Almmmatg.CodMat
        ON ERROR UNDO, RETURN ERROR:
        DELETE Almmmate.
    END.
    /* Barras */
    FIND Almmmat1 OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE Almmmat1 THEN DELETE Almmmat1.

    /* ************************************************************************************** */
    /* RHC 22/08/19 NUEVAS TABLAS */
    /* ************************************************************************************** */
    /* Actualizamos VtaDctoProm */
    FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = Almmmatg.CodCia AND
        VtaDctoProm.CodMat = Almmmatg.CodMat:
        DELETE VtaDctoProm.
    END.
    /* Actualizamos VtaDctoPromMin */
    FOR EACH VtaDctoPromMin EXCLUSIVE-LOCK WHERE VtaDctoPromMin.CodCia = Almmmatg.CodCia AND
        VtaDctoPromMin.CodMat = Almmmatg.CodMat:
        DELETE VtaDctoPromMin.
    END.
    /* Actualizamos VtaDctoVol */
    FOR EACH VtaDctoVol EXCLUSIVE-LOCK WHERE VtaDctoVol.CodCia = Almmmatg.CodCia AND
        VtaDctoVol.CodMat = Almmmatg.CodMat:
        DELETE VtaDctoProm.
    END.
    /* Actualizamos VtaDctoVolSaldo */
/*     FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.CodCia = Almmmatg.codcia AND                   */
/*         FacTabla.Tabla = 'DVXSALDOD' AND                                                           */
/*         FacTabla.Campo-C[1] = Almmmatg.codmat:                                                     */
/*         FOR EACH VtaDctoVolSaldo EXCLUSIVE-LOCK WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND */
/*             VtaDctoVolSaldo.Codigo = ENTRY(1,FacTabla.Codigo,'|') AND                              */
/*             VtaDctoVolSaldo.Tabla = 'DVXSALDOC':                                                   */
/*             DELETE VtaDctoVolSaldo.                                                                */
/*         END.                                                                                       */
/*         DELETE FacTabla.                                                                           */
/*     END.                                                                                           */
    /* ************************************************************************************** */
    /* RHC 04/03/2019 Log General */
    /*{TRIGGERS/i-logtransactions.i &TableName="almmmatg" &Event="DELETE"}*/

