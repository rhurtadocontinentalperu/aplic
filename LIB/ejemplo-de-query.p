DEFINE TEMP-TABLE tt-num1 NO-UNDO
    FIELD f1 AS INTEGER
    FIELD f2 AS INTEGER.

DEFINE TEMP-TABLE tt-num2 NO-UNDO
    FIELD f1 AS INTEGER
    FIELD f2 AS INTEGER.

DEFINE TEMP-TABLE tt-num3 NO-UNDO
    FIELD f1 AS INTEGER
    FIELD f2 AS INTEGER.


CREATE tt-num1.
ASSIGN 
    tt-num1.f1 = 1
    tt-num1.f2 = 1.

CREATE tt-num1.
ASSIGN 
    tt-num1.f1 = 1
    tt-num1.f2 = 2.

CREATE tt-num1.
ASSIGN 
    tt-num1.f1 = 2
    tt-num1.f2 = 1.

CREATE tt-num1.
ASSIGN 
    tt-num1.f1 = 2
    tt-num1.f2 = 2.

DEFINE VARIABLE hQuery  AS HANDLE      NO-UNDO.
DEFINE VARIABLE cBuffer AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cField  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iValue  AS INTEGER     NO-UNDO.

ASSIGN 
    cBuffer = "tt-num1"
    cField  = "f1"
    iValue  = 1.

CREATE QUERY hQuery.

hQuery:ADD-BUFFER(cBuffer).
hQuery:QUERY-PREPARE("for each " + cBuffer + " where " + cBuffer + "." + cField + " = " + STRING(iValue)).
hQuery:QUERY-OPEN().

queryLoop:
REPEAT:
    hQuery:GET-NEXT().

    IF hQuery:QUERY-OFF-END THEN LEAVE queryLoop.

    DISPLAY hQuery:GET-BUFFER-HANDLE(1):BUFFER-FIELD(cField):BUFFER-VALUE.
END.
PAUSE.

/* También puede ser así */
DO WHILE hQuery:GET-NEXT():
    DISPLAY hQuery:GET-BUFFER-HANDLE(1):BUFFER-FIELD(cField):BUFFER-VALUE.
END.
PAUSE.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.


