TRIGGER PROCEDURE FOR REPLICATION-DELETE OF ccbrdocu.


    FIND FIRST ccbcdocu WHERE CcbCDocu.CodCia = CcbRdocu.CodCia 
        AND CcbCDocu.CodDoc = CcbRdocu.CodDoc 
        AND CcbCDocu.NroDoc = CcbRdocu.NroDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu 
        THEN DO:
        {rpl/reptrig.i
        &Table  = ccbrdocu
        &Key    =  "string(ccbrdocu.codcia,'999') + string(ccbrdocu.coddoc,'x(3)') ~
            + string(ccbrdocu.nrodoc,'x(15)') ~
            + string(ccbrdocu.codmat,'x(6)')"
        &Prg    = r-ccbrdocu
        &Event  = DELETE
        &FlgDB0 = NO
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        &FlgDB30 = TRUE
        }
    END.

