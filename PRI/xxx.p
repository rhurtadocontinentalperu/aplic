DEFINE INPUT PARAMETER pReemplazar AS LOG.
DEFINE INPUT PARAMETER TABLE FOR T-DPROM.
DEFINE INPUT PARAMETER x-MetodoActualizacion AS INTE.
DEFINE INPUT PARAMETER f-Division AS CHAR.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR pCuenta AS INTE NO-UNDO.
    
CASE pReemplazar:
    WHEN NO THEN DO:
        FOR EACH T-DPROM NO-LOCK WHERE T-DPROM.CodCia = s-CodCia,
            FIRST Almmmatg OF T-DPROM NO-LOCK:
            IF x-MetodoActualizacion = 2 AND T-DPROM.CodDiv <> f-Division THEN NEXT.
            FIND VtaDctoProm WHERE VtaDctoProm.CodCia = T-DPROM.CodCia AND
                VtaDctoProm.CodDiv = T-DPROM.CodDiv AND
                VtaDctoProm.CodMat = T-DPROM.CodMat AND
                VtaDctoProm.FchIni = T-DPROM.FchIni AND
                VtaDctoProm.FchFin = T-DPROM.FchFin AND
                VtaDCtoProm.FlgEst = "A"
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaDctoProm THEN DO:
                FIND CURRENT VtaDctoProm EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                    UNDO, NEXT.
                END.
                ASSIGN
                    VtaDctoProm.FchModificacion = TODAY
                    VtaDctoProm.HoraModificacion = STRING(TIME, 'HH:MM:SS')
                    VtaDctoProm.UsrModificacion = s-user-id.
            END.
            ELSE DO:
                CREATE VtaDctoProm.
                ASSIGN
                    VtaDctoProm.codcia = T-DPROM.CodCia 
                    VtaDCtoProm.FlgEst = "A"
                    VtaDctoProm.CodDiv = T-DPROM.CodDiv
                    VtaDctoProm.CodMat = T-DPROM.CodMat 
                    VtaDctoProm.FchIni = T-DPROM.FchIni 
                    VtaDctoProm.FchFin = T-DPROM.FchFin 
                    VtaDctoProm.FchCreacion = TODAY
                    VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')
                    VtaDctoProm.UsrCreacion = s-user-id.
            END.
            ASSIGN
                VtaDctoProm.Descuento    = T-DPROM.Descuento 
                VtaDctoProm.DescuentoMR  = T-DPROM.DescuentoMR 
                VtaDctoProm.DescuentoVIP = T-DPROM.DescuentoVIP 
                VtaDctoProm.Precio    = ROUND(Almmmatg.PreVta[1] * (1 - (T-DPROM.Descuento / 100)), 4)
                VtaDctoProm.PrecioMR  = ROUND(Almmmatg.PreVta[1] * (1 - (T-DPROM.DescuentoMR / 100)), 4)
                VtaDctoProm.PrecioVIP = ROUND(Almmmatg.PreVta[1] * (1 - (T-DPROM.DescuentoVIP / 100)), 4).
        END.
    END.
    WHEN YES THEN DO:
        FOR EACH T-DPROM NO-LOCK WHERE T-DPROM.CodCia = s-CodCia, FIRST Almmmatg OF T-DPROM NO-LOCK:
            IF x-MetodoActualizacion = 2 AND T-DPROM.CodDiv <> f-Division THEN NEXT.
            /* 1ro. Buscamos promoción que cuya fecha de inicio se encuentre dentro de la nueva promoción */
            FOR EACH b-VtaDctoProm EXCLUSIVE-LOCK WHERE b-VtaDctoProm.CodCia = T-DPROM.CodCia
                AND b-VtaDctoProm.CodDiv = T-DPROM.CodDiv
                AND b-VtaDctoProm.CodMat = T-DPROM.CodMat
                AND b-VtaDctoProm.FlgEst = "A"
                AND b-VtaDctoProm.FchIni >= T-DPROM.FchIni AND b-VtaDctoProm.FchIni <= T-DPROM.FchFin:
                IF b-VtaDctoProm.FchFin <= b-VtaDctoProm.FchFin THEN DO:
                    /* Es absorvida por la nueva promoción */
                    ASSIGN
                        b-VtaDctoProm.FlgEst = "I"
                        b-VtaDctoProm.FchAnulacion = TODAY 
                        b-VtaDctoProm.UsrAnulacion = s-user-id
                        b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').
                END.
                ELSE DO:
                    /* Se inactiva y se genera una nueva con nuevos vencimientos */
                    CREATE VtaDctoProm.
                    BUFFER-COPY b-VtaDctoProm TO VtaDctoProm
                        ASSIGN
                        VtaDctoProm.FlgEst = "A"
                        VtaDctoProm.FchIni = T-DPROM.FchFin + 1
                        VtaDctoProm.FchFin = b-VtaDctoProm.FchFin
                        VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')
                        VtaDctoProm.FchCreacion = TODAY
                        VtaDctoProm.UsrCreacion = s-user-id.
                    ASSIGN
                        b-VtaDctoProm.FlgEst = "I"
                        b-VtaDctoProm.FchAnulacion = TODAY 
                        b-VtaDctoProm.UsrAnulacion = s-user-id
                        b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').
                END.
            END.
        END.
    END.
END CASE.
