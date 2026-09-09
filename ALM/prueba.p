DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR ix AS INT NO-UNDO.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND almacen WHERE codcia = 01 AND codalm = '03' EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE almacen THEN DO:
        MESSAGE 'creamos registro'.
    END.
    ELSE DISPLAY 'lo encontré' almacen.codalm.
    CATCH eBlockError AS PROGRESS.Lang.Error:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = "LOCO: " +  eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje.
        END.
        DELETE OBJECT eBlockError.
        RETURN ERROR.
    END CATCH.
END.
