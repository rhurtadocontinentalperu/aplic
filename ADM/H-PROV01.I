DEF VAR T-ROWID AS ROWID.
RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
IF T-ROWID <> ?
   THEN DO:
        FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov
           THEN DO:
               SELF:SCREEN-VALUE            = GN-PROV.CODPRO.
               {1}:SCREEN-VALUE             =  gn-prov.NomPro.          
            END.
        END.    