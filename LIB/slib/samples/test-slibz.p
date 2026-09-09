
{slib/slibz.i}



file-info:file-name = "c:\temp\test.p".

if file-info:full-pathname = ? then
    return.


 
run z_compressFile(
    input "c:\temp\test.p",
    input "c:\temp\test.p.z" ).

run z_uncompressFile(
    input "c:\temp\test.p.z",
    input "c:\temp\test2.p",
    input file-info:file-size ).
