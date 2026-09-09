
/*
 * Archivo: cls_gestor_clientes.cls
 *
 * Descripción:
 * Clase para gestionar operaciones con clientes en la tabla gn-clie.
 * Incluye métodos para grabar nuevos clientes y buscar su nombre.
 */


CLASS cls_utilidades_clientes:
    DEFINE PUBLIC STATIC VARIABLE iCodCia AS INTEGER NO-UNDO.
    CONSTRUCTOR PUBLIC cls_utilidades_clientes(INPUT piCodCia AS INTE):
        SUPER().
        cls_utilidades_clientes:iCodCia = piCodCia.
    END CONSTRUCTOR.

  /*
   * =========================================================
   * Método Público para Grabar Cliente
   * =========================================================
   * @param pcCodcli: Código único del cliente.
   * @param pcNomcli: Nombre del cliente.
   * @return LOGICAL: TRUE si el cliente se grabó con éxito, FALSE si hubo un error.
   */
  METHOD PUBLIC LOGICAL GrabarCliente(
    INPUT pcCodcli AS CHARACTER,
    INPUT pcNomcli AS CHARACTER
  ):
    
    DEFINE VARIABLE lGrabado AS LOGICAL NO-UNDO.
    
    lGrabado = FALSE.
    
    DO TRANSACTION:
      FIND FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = iCodCia 
          AND gn-clie.codcli = pcCodcli NO-ERROR.
      
      IF AVAILABLE gn-clie THEN DO:
        MESSAGE "Error: El código de cliente " + pcCodcli + " ya existe." VIEW-AS ALERT-BOX.
        RETURN FALSE.
      END.
      
      CREATE gn-clie.
      ASSIGN
        gn-clie.codcia = iCodCia
        gn-clie.codcli = pcCodcli
        gn-clie.nomcli = pcNomcli.
        
      lGrabado = TRUE.
      
    END.
    
    RETURN lGrabado.
    
  END METHOD.

  

  /*
   * =========================================================
   * Nuevo Método Público para Buscar Nombre de Cliente
   * =========================================================
   * @param pcCodcli: Código del cliente que se desea buscar.
   * @return CHARACTER: El nombre del cliente si se encuentra, o una cadena vacía si no.
   */
  METHOD PUBLIC CHARACTER ObtenerNombreCliente(INPUT pcCodcli AS CHARACTER):
    
    DEFINE VARIABLE cNomcli AS CHARACTER NO-UNDO.
    
    /* Buscar el cliente por su código. */
    FIND FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = iCodCia 
        AND gn-clie.codcli = pcCodcli NO-ERROR.
    
    /* Si el cliente está disponible, devolver su nombre. */
    IF AVAILABLE gn-clie THEN
      cNomcli = gn-clie.nomcli.
    ELSE
      /* Si no se encuentra, devolver una cadena vacía. */
      cNomcli = "".
      
    RETURN cNomcli.
    
  END METHOD.

END CLASS.
