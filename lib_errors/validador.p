/*MESSAGE 'aquí estoy' VIEW-AS ALERT-BOX.*/

{lib_errors/pedido_master.i}

/* El bloque principal del .p puede estar vacío o tener lógica simple */

PROCEDURE validarRegistro:
    /* AQUÍ es donde sí se permite el parámetro BUFFER */
    DEFINE PARAMETER BUFFER bPedido FOR ttPedido.

    IF bPedido.Cantidad > 100 THEN 
        RETURN ERROR "Cantidad excesiva".
        
    bPedido.Total = bPedido.Precio * bPedido.Cantidad.

END PROCEDURE.
