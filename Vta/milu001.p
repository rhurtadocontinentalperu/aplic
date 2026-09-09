disable triggers for load of ccbcdocu.
disable triggers for load of ccbddocu.

def temp-table t-cab like ccbcdocu.
def temp-table t-det like ccbddocu.

input from c:\tmp\ccbcdocu.d.
repeat:
    create t-cab.
    import t-cab.
end.
input close.

input from c:\tmp\ccbddocu.d.
repeat:
    create t-det.
    import t-det.
end.
input close.

for each t-cab where coddoc <> '':
    find ccbcdocu of t-cab no-lock no-error.
    if available ccbcdocu then next.
    display t-cab.coddoc t-cab.nrodoc t-cab.fchdoc.
    pause 0.
    create ccbcdocu.
    buffer-copy t-cab to ccbcdocu.
    for each t-det of t-cab:
        create ccbddocu.
        buffer-copy t-det to ccbddocu.
    end.
end.


