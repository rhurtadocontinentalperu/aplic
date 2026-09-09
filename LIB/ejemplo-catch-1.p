
/* myUpdateCustomer.p */

DEFINE INPUT PARAMETER pcCustNum AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNewName AS CHARACTER NO-UNDO.

MESSAGE "Intentando actualizar cliente " + pcCustNum VIEW-AS ALERT-BOX.

DO ON ERROR UNDO, THROW:
    FIND Customer WHERE Customer.CustNum = INTEGER(pcCustNum) EXCLUSIVE.
    
    ASSIGN Customer.Name = pcNewName.
    
    MESSAGE "Cliente " + Customer.CustNum + " actualizado a " + Customer.Name VIEW-AS ALERT-BOX.

CATCH eSysError AS Progress.Lang.SysError:
    /* Error del sistema: Podría ser que el cliente no se encontró (si no usamos NO-ERROR)
       o algún otro problema de base de datos. */
    MESSAGE "Error del sistema al actualizar cliente: " + eSysError:GetMessage(1)
        VIEW-AS ALERT-BOX ERROR.
    /* Aquí podrías registrar el error, notificar al usuario, etc. */
    DELETE OBJECT eSysError. /* Liberar el objeto */
END CATCH.

CATCH eAppError AS Progress.Lang.AppError:
    /* Error de aplicación: Por ejemplo, si hubiéramos lanzado uno desde otra parte.
       Aunque en este ejemplo directo no hay un THROW AppError explícito dentro del DO,
       es buena práctica incluirlo si tu aplicación usa errores personalizados. */
    MESSAGE "Error de aplicación al actualizar cliente: " + eAppError:GetMessage(1)
        VIEW-AS ALERT-BOX ERROR.
    DELETE OBJECT eAppError.
END CATCH.

CATCH eAnyError AS Progress.Lang.Error:
    /* Captura cualquier otro error no esperado */
    MESSAGE "Se produjo un error inesperado: " + eAnyError:GetMessage(1)
        VIEW-AS ALERT-BOX ERROR.
    DELETE OBJECT eAnyError.
END CATCH.

END. /* Fin del DO block */
