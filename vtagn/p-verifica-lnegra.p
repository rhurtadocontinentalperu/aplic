DEFINE INPUT PARAMETER cCodCli LIKE gn-clie.codcli.
DEFINE OUTPUT PARAMETER lRpta AS LOGICAL.

DEFINE SHARED VAR cl-codcia AS INT.

FIND FIRST vtalnegra WHERE vtalnegra.codcia = cl-codcia
    AND vtalnegra.codcli = cCodCli NO-LOCK NO-ERROR.

IF AVAIL vtalnegra THEN lRpta = YES.
ELSE lRpta = NO.

