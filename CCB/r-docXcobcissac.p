DEFINE INPUT PARAMETER itask-no AS INT.
DEFINE INPUT PARAMETER tgdudosa AS LOG.
DEFINE INPUT PARAMETER tglinea  AS LOG.
DEFINE INPUT PARAMETER cDivi    AS CHAR.
DEFINE INPUT PARAMETER cCodCli1 AS CHAR.
DEFINE INPUT PARAMETER cCodCli2 AS CHAR.
DEFINE INPUT PARAMETER cFchDoc1 AS DATE.
DEFINE INPUT PARAMETER cFchDoc2 AS DATE.
DEFINE INPUT PARAMETER cCodmon  AS INT.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEFINE VARIABLE cNomcli AS CHARACTER NO-UNDO.
DEFINE VARIABLE dImpLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE iAge_period AS INTEGER NO-UNDO.
DEFINE VARIABLE iAge_days AS INTEGER EXTENT 5 INITIAL [15, 30, 45, 60, 90].
DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DEFINE VARIABLE FSdoAct LIKE cissac.CcbCDocu.sdoact NO-UNDO.
DEFINE VARIABLE FImpTot LIKE cissac.CcbCDocu.imptot NO-UNDO.
DEFINE VARIABLE cFlgEst AS CHARACTER   NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print1" SIZE 5 BY 1.5.

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Imprimiendo...".


IF tgdudosa THEN cFlgEst = 'P,J'. ELSE cFlgEst = 'P'.

FOR EACH cissac.CcbCDocu NO-LOCK WHERE
    cissac.CcbCDocu.codcia = s-codcia AND
    LOOKUP(cissac.CcbCDocu.coddiv,cDivi) > 0 AND
    cissac.CcbCDocu.codcli >= cCodCli1 AND
    cissac.CcbCDocu.codcli <= cCodCli2 AND
    cissac.CcbCDocu.fchdoc >= cFchDoc1 AND
    cissac.CcbCDocu.fchdoc <= cFchDoc2 AND
    cissac.CcbCDocu.codmon = cCodMon   AND
/*RDP ****
    cissac.CcbCDocu.flgest = "P" AND
*** RDP*/
/*RDP - Considerar Documentos Cobranza Dudosa*/
    LOOKUP(cissac.CcbCDocu.flgest,cFlgEst) > 0 AND
    LOOKUP(cissac.CcbCDocu.coddoc,"FAC,BOL,N/C,N/D,LET,A/R,BD") > 0 AND
    cissac.CcbCDocu.nrodoc >= ""
    BREAK BY cissac.CcbCDocu.codcia
    BY cissac.CcbCDocu.codcli
    BY cissac.CcbCDocu.flgest
    BY cissac.CcbCDocu.coddoc
    BY cissac.CcbCDocu.nrodoc:

    IF FIRST-OF(cissac.CcbCDocu.codcli) THEN DO:
        cNomcli = "".
        dImpLC = 0.
        lEnCampan = FALSE.
        FIND cissac.gn-clie WHERE
            cissac.gn-clie.CodCia = cl-codcia AND
            cissac.gn-clie.CodCli = cissac.CcbCDocu.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-clie THEN DO:
            /* Línea Crédito Campaña */
            FOR EACH cissac.gn-clieL WHERE
                cissac.gn-clieL.CodCia = cissac.gn-clie.codcia AND
                cissac.gn-clieL.CodCli = cissac.gn-clie.codcli AND
                cissac.gn-clieL.FchIni >= TODAY AND
                cissac.gn-clieL.FchFin <= TODAY NO-LOCK:
                dImpLC = dImpLC + cissac.gn-clieL.ImpLC.
                lEnCampan = TRUE.
            END.
            /* Línea Crédito Normal */
            IF NOT lEnCampan THEN dImpLC = cissac.gn-clie.ImpLC.
            cNomcli = cissac.gn-clie.nomcli.
        END.
    END.
    /*
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST integral.w-report WHERE
            integral.w-report.task-no = s-task-no AND
            integral.w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.
    */

    
    DISPLAY
        cissac.CcbCDocu.codcli LABEL "   Cargando información para"
        WITH FRAME f-mensaje.
    READKEY PAUSE 0.
    
    IF LASTKEY = KEYCODE("F10") THEN LEAVE.

    FSdoAct = cissac.CcbCDocu.sdoact.
    FImpTot = cissac.CcbCDocu.imptot.

    IF lookup(cissac.CcbCDocu.coddoc, "N/C,A/R,BD") > 0 THEN DO:
        FSdoAct = FSdoAct * -1.
        FImpTot = FImpTot * -1.
    END.

    CREATE integral.w-report.
    ASSIGN
        integral.w-report.Task-No = itask-no                       /* ID Tarea */
        integral.w-report.Llave-C = s-user-id                       /* ID Usuario */
        integral.w-report.Campo-C[1] = cissac.CcbCDocu.codcli       /* Cliente */
        integral.w-report.Campo-C[2] = cNomcli                      /* Nombre  */
        integral.w-report.Campo-C[3] = cissac.CcbCDocu.coddoc       /* Código Documento */
        integral.w-report.Campo-C[4] = cissac.CcbCDocu.nrodoc       /* Número Documento */
        integral.w-report.Campo-C[8] = "CISSAC"                     /* Nombre Cia       */
        integral.w-report.Campo-D[1] = cissac.CcbCDocu.fchdoc       /* Fecha Emisión */
        integral.w-report.Campo-D[2] = cissac.CcbCDocu.fchvto       /* Fecha Vencimiento */
        integral.w-report.Campo-D[3] = cissac.CcbCDocu.fchcbd.      /* Fecha Recepción */
    /*Incluir lïnea de crédito*/
    IF tglinea THEN
        ASSIGN integral.w-report.Campo-F[1] = dImpLC.        /* Línea de Crédito */
    IF cissac.CcbCDocu.codmon = 2 THEN DO:
        integral.w-report.Campo-F[2] = FImpTot.              /* Importe Dólares */
        integral.w-report.Campo-F[3] = FSdoAct.              /* Saldo Dólares */
    END.
    ELSE DO:
        integral.w-report.Campo-F[4] = FImpTot.              /* Importe Soles */
        integral.w-report.Campo-F[5] = FSdoAct.              /* Saldo Soles */
    END.

    IF cissac.CcbCDocu.coddoc = "LET" THEN DO:
        CASE cissac.CcbCDocu.flgsit:
            WHEN "C" THEN integral.w-report.Campo-C[5] = "COBRANZA LIBRE".
            WHEN "D" THEN integral.w-report.Campo-C[5] = "DESCUENTO".
            WHEN "G" THEN integral.w-report.Campo-C[5] = "GARANTIA".
            WHEN "P" THEN integral.w-report.Campo-C[5] = "PROTESTADA".
        END CASE.
        /* Documentos en Banco */
        IF cissac.CcbCDocu.flgubi = "B" THEN DO:
            integral.w-report.Campo-C[6] = cissac.CcbCDocu.nrosal.      /* Letra en Banco */
            IF cissac.CcbCDocu.CodCta <> "" THEN DO:
                FIND FIRST cissac.cb-ctas WHERE
                    cissac.cb-ctas.CodCia = cb-codcia AND
                    cissac.cb-ctas.Codcta = cissac.CcbCDocu.CodCta
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cissac.cb-ctas THEN DO:
                    FIND cissac.cb-tabl WHERE
                        cissac.cb-tabl.Tabla  = "04" AND
                        cissac.cb-tabl.Codigo = cissac.cb-ctas.codbco
                    NO-LOCK NO-ERROR.
                    IF AVAILABLE cissac.cb-tabl THEN
                    integral.w-report.Campo-C[7] = cissac.cb-tabl.Nombre.   /* Banco */
                END.
            END.
        END.
    END.

    /* Documentos Vencidos */
    IF cissac.CcbCDocu.fchvto < TODAY THEN DO:
        IF cissac.CcbCDocu.coddoc = "LET" THEN DO:
            IF cissac.CcbCDocu.flgubi = "C" THEN
                integral.w-report.Campo-F[6] = FSdoAct.      /* Vencido Cartera */
            ELSE
                integral.w-report.Campo-F[7] = FSdoAct.      /* Vencido Banco */
        END.
        ELSE integral.w-report.Campo-F[6] = FSdoAct.         /* Vencido Cartera */
    END.
    /* Documentos por Vencer */
    ELSE DO:
        IF cissac.CcbCDocu.coddoc = "LET" THEN DO:
            IF cissac.CcbCDocu.flgubi = "C" THEN
                integral.w-report.Campo-F[8] = FSdoAct.      /* Por Vencer Cartera */
            ELSE
                integral.w-report.Campo-F[9] = FSdoAct.      /* Por Vencer Banco */
        END.
        ELSE integral.w-report.Campo-F[8] = FSdoAct.         /* Por Vencer Cartera */
    END.

END.

