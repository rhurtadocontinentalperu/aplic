{lib_errors/pedido_master.i}

DEFINE VARIABLE hProc AS HANDLE NO-UNDO.

/* 1. Cargamos el programa en memoria una sola vez */
RUN lib_errors/validador.p PERSISTENT SET hProc.

CREATE ttPedido.
ASSIGN ttPedido.Cantidad = 20 ttPedido.Precio = 5.

/* 2. Llamamos a la lógica usando el "handle" del programa */
RUN validarRegistro IN hProc (BUFFER ttPedido) NO-ERROR.

/* 3. Al terminar todo el proceso, lo borramos de memoria */
DELETE PROCEDURE hProc.

