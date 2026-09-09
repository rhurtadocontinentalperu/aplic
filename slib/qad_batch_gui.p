
/**
 * qad_batch_gui.p -
 *
 * By Alon Blich
 */

{slib/slibqad.i}

{slib/slibpro.i}



define input param pcUserid     as char no-undo.
define input param pcPasswd     as char no-undo.
define input param pcDomain     as char no-undo.
define input param pcProgram    as char no-undo.
define input param pcCimFile    as char no-undo.
define input param pcLogFile    as char no-undo.

define var cFileName as char no-undo.



cFileName = pro_getRunFile( "slib/qad_batch_gui1_eb21.p" ).

/***
if cFileName = ? then
   cFileName = pro_getRunFile( "qad_batch_gui1_eb21.p" ).

if cFileName = ? then
   cFileName = pro_getRunFile( "xx/qad_batch_gui1_eb21.p" ).

if cFileName = ? then
   cFileName = pro_getRunFile( "us/xx/qad_batch_gui1_eb21.p" ).
***/

run value( cFileName ) (

    input pcUserId,
    input pcPasswd,
    input pcDomain,
    input pcProgram,
    input pcCimFile,
    input pcLogFile ).
