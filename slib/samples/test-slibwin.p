
{slib/slibwin.i}

define var chApplication    as com-handle no-undo.
define var chWorkbook       as com-handle no-undo.



on "ctrl-x" anywhere do:

    create "Excel.Application" chApplication.
    
    chApplication:visible = False.
    chWorkbook = chApplication:Workbooks:add( ).
    
    chApplication:visible = true.
    
    run win_bringWindowToTop( chApplication:hwnd ).
    
    release object chApplication.      
    release object chWorkbook.

end. /* ctrl-x */



view current-window.

wait-for window-close of current-window.
