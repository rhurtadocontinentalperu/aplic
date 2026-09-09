
/* 1ra pasada: Todos */
FOR EACH sap_clientes EXCLUSIVE-LOCK:
    DISPLAY sap_clientes.cardcode WITH STREAM-IO NO-BOX.
    PAUSE 0.
    /* tratamos de emparejar con el cliente Progress */
    CASE sap_clientes.U_BPP_BPTD:
        WHEN "6" THEN DO:       /* RUC */
            FIND base.gn-clie WHERE base.gn-clie.codcia = 0
                AND base.gn-clie.codcli = sap_clientes.FederalTaxId 
                NO-LOCK NO-ERROR NO-WAIT.
            RUN Graba-Cliente.
        END.
        OTHERWISE DO:
            FIND FIRST base.gn-clie WHERE base.gn-clie.codcia = 0
                AND base.gn-clie.DNI = sap_clientes.FederalTaxId
                AND base.gn-clie.flgsit = "A"
                NO-LOCK NO-ERROR NO-WAIT.
            RUN Graba-Cliente.
        END.
    END CASE.
END.

/* 2da pasada: Los que aún no han calzado */
FOR EACH sap_clientes EXCLUSIVE-LOCK USE-INDEX Idx00 WHERE sap_clientes.codcli = '':
    DISPLAY sap_clientes.cardcode WITH STREAM-IO NO-BOX.
    PAUSE 0.
    FIND FIRST base.gn-clie WHERE base.gn-clie.codcia = 0 AND
        base.gn-clie.apepat = sap_clientes.u_bpp_bpap AND
        base.gn-clie.apemat = sap_clientes.u_bpp_bpam AND
        base.gn-clie.nombre BEGINS sap_clientes.u_bpp_bpno AND
        base.gn-clie.flgsit = "A"
        NO-LOCK NO-ERROR NO-WAIT.
    RUN Graba-Cliente.
END.

/* 3ra pasada: Las Ñ que no se ven */
DEF VAR cApePat AS CHAR NO-UNDO.
DEF VAR cApeMat AS CHAR NO-UNDO.
DEF VAR cNombre AS CHAR NO-UNDO.

FOR EACH sap_clientes EXCLUSIVE-LOCK USE-INDEX Idx00 WHERE sap_clientes.codcli = '':
    cApePat = sap_clientes.u_bpp_bpap.
    cApeMat = sap_clientes.u_bpp_bpam.
    cNombre = sap_clientes.u_bpp_bpno.
    /* Transformamos */
    cApePat = REPLACE(cApePat," ", "Ñ").
    cApeMat = REPLACE(cApeMat," ", "Ñ").
    cNombre = ENTRY(1,cNombre," ").
    DISPLAY sap_clientes.cardcode WITH STREAM-IO NO-BOX.
    PAUSE 0.
    FIND FIRST base.gn-clie WHERE base.gn-clie.codcia = 0 AND
        base.gn-clie.apepat = cApePat AND
        base.gn-clie.apemat = cApeMat AND
        base.gn-clie.nombre BEGINS cNombre AND
        base.gn-clie.flgsit = "A"
        NO-LOCK NO-ERROR NO-WAIT.
    RUN Graba-Cliente.
END.

/* 4ta pasada: por partes del apellido y primer nombre */
DEF VAR cNomCli AS CHAR NO-UNDO.

FOR EACH sap_clientes EXCLUSIVE-LOCK USE-INDEX Idx00 WHERE sap_clientes.codcli = '':
    DISPLAY sap_clientes.cardcode WITH STREAM-IO NO-BOX.
    PAUSE 0.
    cApePat = sap_clientes.u_bpp_bpap.
    cApeMat = sap_clientes.u_bpp_bpam.
    cNombre = sap_clientes.u_bpp_bpno.
    /* Transformamos */
    cNomCli = TRIM(cApePat) + " " + TRIM(cApeMat).
    cNombre = ENTRY(1,cNombre," ").
    FOR FIRST base.gn-clie NO-LOCK WHERE base.gn-clie.codcia = 0 AND
        base.gn-clie.nomcli CONTAINS cNomCli AND 
        INDEX(base.gn-clie.nombre, cNombre) > 0 AND
        base.gn-clie.flgsit = "A":
        RUN Graba-Cliente.
    END.
END.



/* ******************** */
PROCEDURE Graba-Cliente:
/* ******************** */
IF AVAILABLE base.gn-clie THEN
    ASSIGN
        sap_clientes.CodCli = base.gn-clie.codcli
        sap_clientes.NomCli = base.gn-clie.nomcli
        sap_clientes.Ruc = base.gn-clie.ruc
        sap_clientes.DNI = base.gn-clie.dni
        sap_clientes.ApeMat = base.gn-clie.apemat
        sap_clientes.ApePat = base.gn-clie.apepat
        sap_clientes.Nombre = base.gn-clie.nombre
        sap_clientes.Libre_C01 = base.gn-clie.libre_c01
        .

END PROCEDURE.
