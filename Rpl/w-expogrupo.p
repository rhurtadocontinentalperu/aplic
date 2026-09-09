TRIGGER PROCEDURE FOR REPLICATION-WRITE OF expogrupo.

    {rpl/reptrig.i
    &Table  = expogrupo
    &Key    = "string(expogrupo.codcia,'999') + expogrupo.grupo"
    &Prg    = r-expogrupo
    &Event  = WRITE
    &FlgDB0 = YES    
    &FlgDB1 = YES    
    &FlgDB2 = YES    
    &FlgDB3 = YES    
    &FlgDB4 = YES    
    &FlgDB5 = YES    
    &FlgDB6 = YES    
    &FlgDB7 = YES    
    &FlgDB8 = YES    
    &FlgDB9 = YES    
    &FlgDB10 = YES   
    &FlgDB11 = YES   
    &FlgDB12 = YES   
    &FlgDB13 = YES   
    &FlgDB14 = YES   
    &FlgDB15 = YES   
    &FlgDB16 = YES   
    &FlgDB17 = YES
    &FlgDB18 = YES   
    &FlgDB19 = NO       /* EXPOLIBRERIA */
    &FlgDB20 = YES      /* SERVIDOR CENTRAL */
    &FlgDB30 = YES      /* SERVIDOR ATE */
    }
    
