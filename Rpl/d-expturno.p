TRIGGER PROCEDURE FOR REPLICATION-DELETE OF expturno.

    {rpl/reptrig.i
    &Table  = expturno
    &Key    = "string(expturno.codcia,'999') + string(expturno.coddiv,'x(5)') + ~
                string(expturno.block,'x(3)') + string(expturno.fecha,'99/99/9999') + ~
                expturno.tipo"
    &Prg    = r-expturno
    &Event  = DELETE
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
    
