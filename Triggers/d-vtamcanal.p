TRIGGER PROCEDURE FOR DELETE OF Vtamcanal.


    /* Borramos comisiones por canal de ventas */
    FOR EACH TabGener WHERE TabGener.codcia = Vtamcanal.codcia
        AND TabGener.clave = "%COMI"
        AND ENTRY(1, TabGener.codigo, '|') = Vtamcanal.canalventa:
        DELETE TabGener.
    END.
