TRIGGER PROCEDURE FOR DELETE OF VtaListaMinGn.


/* RHC 04/03/2019 Log General */
/*{TRIGGERS/i-logtransactions.i &TableName="vtalistamingn" &Event="DELETE"}*/
    DEF SHARED VAR s-user-id AS CHAR.
    DEF SHARED VAR pRCID AS INT.


    /* Descuentos Promocionales */
/*     DEF VAR s-CanalVenta AS CHAR.                                                                       */
/*                                                                                                         */
/*     FIND Almmmatg OF VtaListaMinGn NO-LOCK NO-ERROR.                                                    */
/*     IF AVAILABLE Almmmatg THEN DO:                                                                      */
/*         ASSIGN                                                                                          */
/*             s-CanalVenta = 'MIN'.   /* Lista de Precios UTILEX */                                       */
/*         /* Actualizamos VtaDctoPromMin: Promociones Vigentes */                                         */
/*         FOR EACH VtaDctoPromMin EXCLUSIVE-LOCK WHERE VtaDctoPromMin.CodCia = VtaListaMinGn.CodCia       */
/*             AND VtaDctoPromMin.CodMat = VtaListaMinGn.CodMat,                                           */
/*             FIRST gn-divi OF VtaDctoPromMin NO-LOCK WHERE LOOKUP(gn-divi.CanalVenta, s-CanalVenta) > 0: */
/*             DELETE VtaDctoPromMin.                                                                      */
/*         END.                                                                                            */
/*     END.                                                                                                */

    /* LOG de control */
    CREATE LogListaMinGn.
    BUFFER-COPY VtaListaMinGn TO LogListaMinGn
        ASSIGN
        LogListaMinGn.NumId = pRCID
        LogListaMinGn.LogDate = TODAY
        LogListaMinGn.LogTime = STRING(TIME, 'HH:MM:SS')
        LogListaMinGn.LogUser = s-user-id
        LogListaMinGn.FlagFechaHora = DATETIME(TODAY, MTIME)
        /*LogListaMinGn.FlagMigracion */
        LogListaMinGn.FlagUsuario = s-user-id
        LogListaMinGn.FlagEstado = "D".


