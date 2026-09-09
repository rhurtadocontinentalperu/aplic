def temp-table t-cat-ate like almmmatg.
def temp-table t-cat-lima like almmmatg.

def stream s-ate.
def stream s-lima.

input stream s-ate from c:\tmp\cat-ate.d.
input stream s-lima from c:\tmp\cat-lima.d.

/* cargamos el archivo generado an ate (susana01) */
repeat:
    create t-cat-ate.
    import stream s-ate t-cat-ate.
end.

/* cargamos el archivo generado en lima (susana02) */
repeat:
    create t-cat-lima.
    import stream s-lima t-cat-lima.
end.

input stream s-ate close.
input stream s-lima close.

for each almmmatg where almmmatg.codcia = 1 and integer(almmmatg.codmat) <= 24200:
    find t-cat-ate of almmmatg no-error.
    if available t-cat-ate
    then do:
        find t-cat-lima of almmmatg no-error.
        if available t-cat-lima
        then do:
            almmmatg.tpoart = 'D'.
        end.
    end.
end.
