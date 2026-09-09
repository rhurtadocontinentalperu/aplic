
/* test-slibmath.p */

{slib/slibmath.i}



define var iDegree as int no-undo.

repeat iDegree = 0 to 360 by 5:

    display
        iDegree                             format ">>9"                column-label "Degree"
        math_tan( math_deg2rad( iDegree ) ) format "->9.99999999999"    column-label "tan"
        math_sin( math_deg2rad( iDegree ) ) format "->9.99999999999"    column-label "sin"
        math_cos( math_deg2rad( iDegree ) ) format "->9.99999999999"    column-label "cos"
    with width 320 stream-io.

end. /* repeat */
