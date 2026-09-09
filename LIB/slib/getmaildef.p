
/**
 * getmaildef.p -
 *
 * By Alon Blich
 */

{mfdeclre.i}

{slib/slibqad.i}



define output param pcMailHub   as char no-undo.
define output param pcMailFrom  as char no-undo.

find first code_mstr
     where code_fldname = "mailhub"
       and code_value   = ""

    &if {&xEb} = yes &then
       and code_domain  = global_domain
    &endif

     no-lock no-error.

if avail code_mstr 
then pcMailHub = trim( code_cmmt ).
else pcMailHub = ?.



find first code_mstr
     where code_fldname = "mailfrom"
       and code_value   = ""

    &if {&xEb} = yes &then
       and code_domain  = global_domain
    &endif

     no-lock no-error.

if avail code_mstr 
then pcMailFrom = trim( code_cmmt ).
else pcMailFrom = ?.
