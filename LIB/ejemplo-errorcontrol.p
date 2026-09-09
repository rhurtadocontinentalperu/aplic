/* MiProcedimiento.p */
DEFINE VARIABLE hCustomer AS HANDLE NO-UNDO.

MESSAGE "Iniciando MiProcedimiento.p" VIEW-AS ALERT-BOX.

DO ON ERROR UNDO, THROW:
    /* Código que puede generar errores */
    FIND FIRST Customer WHERE Customer.CustNum = 999999 NO-ERROR. /* Esto causará un SysError si no existe */
    IF NOT AVAILABLE Customer THEN
        UNDO, THROW NEW Progress.Lang.AppError("Cliente con número 99999 no encontrado.", 200).

    CREATE Customer. /* Esto podría fallar si hay un problema con la tabla o transacciones */
    ASSIGN Customer.CustNum = 10000
           Customer.Name = "Nuevo Cliente de Prueba".

    MESSAGE "Operación completada con éxito." VIEW-AS ALERT-BOX.

CATCH eSysError AS Progress.Lang.SysError:
    /* Captura errores de sistema (ej. FIND, CREATE fallido, problemas de base de datos) */
    RUN lib/ErrorControl.p (eSysError, "LOG_AND_DISPLAY").
    /* Opcional: Relanzar si el error debe propagarse a un nivel superior */
    /* UNDO, THROW eSysError. */
END CATCH.

CATCH eAppError AS Progress.Lang.AppError:
    /* Captura errores de aplicación definidos por ti (ej. tu propio UNDO, THROW NEW AppError) */
    RUN lib/ErrorControl.p (eAppError, "LOG_AND_DISPLAY").
END CATCH.

CATCH eAnyError AS Progress.Lang.Error:
    /* Captura cualquier otro tipo de error no cubierto por los CATCH anteriores */
    RUN lib/ErrorControl.p (eAnyError, "LOG_AND_DISPLAY").
END CATCH.

END. /* Fin del DO block */

MESSAGE "Fin de MiProcedimiento.p" VIEW-AS ALERT-BOX.
