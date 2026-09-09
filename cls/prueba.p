
/*
 * Archivo: mi_programa_principal.p
 *
 * Descripción:
 * Ejemplo de cómo usar los métodos de la clase cls_gestor_clientes.
 */

DEFINE VARIABLE oGestorClientes AS cls_utilidades_clientes NO-UNDO.
DEFINE VARIABLE lExito AS LOGICAL NO-UNDO.
DEFINE VARIABLE cNombre AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodigo AS CHARACTER NO-UNDO.

oGestorClientes = NEW cls_utilidades_clientes(1).

/* 1. Grabar un nuevo cliente. */
cCodigo = "C002".
lExito = oGestorClientes:GrabarCliente(cCodigo, "Cliente de Prueba Dos S.A.").

IF lExito THEN
  MESSAGE "El cliente " + cCodigo + " se grabó con éxito." VIEW-AS ALERT-BOX.
ELSE
  MESSAGE "No se pudo grabar el cliente " + cCodigo + "." VIEW-AS ALERT-BOX.

/* 2. Usar el nuevo método para buscar el nombre del cliente que acabamos de grabar. */
cNombre = oGestorClientes:ObtenerNombreCliente(cCodigo).

IF cNombre <> "" THEN
  MESSAGE "El nombre del cliente " + cCodigo + " es: " + cNombre VIEW-AS ALERT-BOX.
ELSE
  MESSAGE "No se encontró el cliente " + cCodigo + "." VIEW-AS ALERT-BOX.

/* 3. Intentar buscar un cliente que no existe. */
cNombre = oGestorClientes:ObtenerNombreCliente("C999").
IF cNombre = "" THEN
  MESSAGE "La búsqueda del cliente C999 no devolvió resultados (como se esperaba)." VIEW-AS ALERT-BOX.

DELETE OBJECT oGestorClientes.
