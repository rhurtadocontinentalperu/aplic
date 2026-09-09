DEF VAR x-linea AS CHAR NO-UNDO.
INPUT FROM d:\clientes.csv.
REPEAT :
    CREATE sap_clientes.
    IMPORT DELIMITER ";" sap_clientes.
END.
INPUT CLOSE.
