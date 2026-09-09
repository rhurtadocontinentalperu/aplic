
{slib/sliblog.i}

define var lOk as log no-undo.

lOk = no.

find first _DbStatus no-lock no-error.

if  avail _DbStatus
and _DbStatus._DbStatus-Tainted = 0 then

    lOk = yes.



output to value( session:param ).
export lOk.
output close.

quit.

