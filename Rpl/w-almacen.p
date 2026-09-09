TRIGGER PROCEDURE FOR REPLICATION-WRITE OF almacen.

/*
    {rpl/reptrig.i
    &Table  = almacen
    &Key    = "STRING(almacen.codcia,'999') + almacen.CodAlm"
    &Prg    = r-almacen
    &Event  = WRITE
    &FlgDB0 = TRUE
    &FlgDB1 = TRUE      
    &FlgDB2 = TRUE
    &FlgDB3 = TRUE
    &FlgDB4 = TRUE
    &FlgDB5 = TRUE
    &FlgDB6 = TRUE
    &FlgDB7 = TRUE
    &FlgDB8 = TRUE
    &FlgDB9 = TRUE
    &FlgDB10 = "NOT LOOKUP(almacen.coddiv,'00065') > 0"     /* CHICLAYO */
    &FlgDB11 = TRUE
    &FlgDB12 = TRUE
    &FlgDB13 = TRUE
    &FlgDB14 = TRUE
    &FlgDB15 = TRUE
    &FlgDB16 = TRUE
    &FlgDB17 = NO
    &FlgDB18 = NO     /* AREQUIPA */
    &FlgDB19 = NO   /* TRUJILLO */
    &FlgDB20 = NO   /* UTILEX */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }

*/
