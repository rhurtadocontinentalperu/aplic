TRIGGER PROCEDURE FOR WRITE OF VtaCFamMat OLD BUFFER OldVtaCFamMat.

FOR EACH VtaDFamMat OF OldVtaCFamMat:
    ASSIGN
        VtaDFamMat.Grupo = VtaCFamMat.Grupo.
END.

/* CONSISTENCIAS */
FOR EACH Vtadfammat OF Vtacfammat NO-LOCK,
    FIRST Almmmatg OF Vtadfammat NO-LOCK:
    IF Almmmatg.codfam <> Vtacfammat.codfam
        OR Almmmatg.subfam <> Vtacfammat.subfam THEN DO:
        MESSAGE 'NO coincide la familia y/o la subfamilia en el código'
            Vtadfammat.codmat
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
