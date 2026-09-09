for each ccbcdocu no-lock
use-index llave10
where codcia=001
and fchdoc >=01/01/07
and lookup(coddoc,'fac,bol,n/c')>0
and lookup(codven,'901,015,173')>0
and flgest<>'a':

display coddiv fchdoc coddoc nrodoc codven.
