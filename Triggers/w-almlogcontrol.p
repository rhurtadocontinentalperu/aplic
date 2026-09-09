TRIGGER PROCEDURE FOR WRITE OF AlmLogControl OLD BUFFER OldAlmLogControl.

DEF VAR hRutinas AS HANDLE NO-UNDO.

RUN alm\actualizaalmacen PERSISTEN SET hRutinas.
/* Actualizamos Tablas asociadas */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    IF OldAlmLogControl.CodMat <> "" THEN DO:
        RUN ExtornaMateControl IN hRutinas ( BUFFER OldAlmLogControl ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            DELETE PROCEDURE hRutinas NO-ERROR.
            UNDO, RETURN ERROR.
        END.
        RUN ExtornaMateUbic IN hRutinas ( BUFFER OldAlmLogControl ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            DELETE PROCEDURE hRutinas NO-ERROR.
            UNDO, RETURN ERROR.
        END.
        RUN ExtornaMateLote IN hRutinas ( BUFFER OldAlmLogControl ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            DELETE PROCEDURE hRutinas NO-ERROR.
            UNDO, RETURN ERROR.
        END.
        RUN ExtornaMMate IN hRutinas ( BUFFER OldAlmLogControl ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            DELETE PROCEDURE hRutinas NO-ERROR.
            UNDO, RETURN ERROR.
        END.
    END.
    RUN ActualizaMateControl IN hRutinas ( BUFFER AlmLogControl ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE PROCEDURE hRutinas NO-ERROR.
        UNDO, RETURN ERROR.
    END.
    RUN ActualizaMateUbic IN hRutinas ( BUFFER AlmLogControl ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE PROCEDURE hRutinas NO-ERROR.
        UNDO, RETURN ERROR.
    END.
    RUN ActualizaMateLote IN hRutinas ( BUFFER AlmLogControl ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE PROCEDURE hRutinas NO-ERROR.
        UNDO, RETURN ERROR.
    END.
    RUN ActualizaMMate IN hRutinas ( BUFFER AlmLogControl ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE PROCEDURE hRutinas NO-ERROR.
        UNDO, RETURN ERROR.
    END.
END.
DELETE PROCEDURE hRutinas NO-ERROR.
