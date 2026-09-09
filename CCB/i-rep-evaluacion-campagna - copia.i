&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/*DEF VAR cTipoTerminal AS CHAR NO-UNDO.
ASSIGN cTipoTerminal = SESSION:WINDOW-SYSTEM.
/* Si es TTY => se está ejecutando en modo texto en Linux */

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 14.19
         WIDTH              = 95.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compras Include 
PROCEDURE compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cListaDocCargo AS CHAR NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.

ASSIGN cListaDocCargo = "FAC,BOL".

DEF VAR x-Item AS INTE NO-UNDO.
DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-ImpLin AS DECI NO-UNDO.
DEF VAR x-Contador AS INTE NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.

DEF VAR iControl AS INTE NO-UNDO.
DEF VAR LControl AS LOG NO-UNDO.    /* ARITMETICA DE SUNAT */

DO x-Item = 1 TO NUM-ENTRIES(cListaDocCargo):
    /* Hay que buscar 5 líneas de crédito */
    DO x-Contador = 1 TO 5:
        IF x-Contador = 2 THEN LEAVE.
        CASE x-Contador:
            WHEN 1 THEN ASSIGN x-FchIni = FILL-IN-FchIni-1 x-FchFin = FILL-IN-FchFin-1.
            WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchIni-2 x-FchFin = FILL-IN-FchFin-2.
            WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchIni-3 x-FchFin = FILL-IN-FchFin-3.
            WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchIni-4 x-FchFin = FILL-IN-FchFin-4.
            WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchIni-5 x-FchFin = FILL-IN-FchFin-5.
        END CASE.
        DO x-Fecha = x-FchIni TO x-FchFin:
            FOR EACH Ccbcdocu FIELDS(codcia coddiv fchdoc coddoc nrodoc codcli  codmon tpofac fmapgo imptot TotalPrecioVenta) NO-LOCK 
                WHERE Ccbcdocu.codcia = s-codcia AND
                    Ccbcdocu.FchDoc = x-Fecha AND
                    Ccbcdocu.coddoc = ENTRY(x-Item, cListaDocCargo) AND
                    Ccbcdocu.flgest <> "A",
                FIRST gn-clie FIELDS(codcia codcli ruc) NO-LOCK
                WHERE gn-clie.codcia = cl-codcia AND
                    gn-clie.codcli = Ccbcdocu.codcli:
                /* FILTROS */
                IF TOGGLE-Solo-Ruc = YES AND TRUE <> (gn-clie.ruc > "") THEN NEXT.
                IF LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN NEXT.
                IF LOOKUP(Ccbcdocu.FmaPgo, '899,900') > 0 THEN NEXT.
                /* 11/07/2025 Cabecera sin detalle (¿?) */
                IF NOT CAN-FIND(FIRST CcbDDocu OF CcbCDocu NO-LOCK) THEN NEXT.
                /* ****** */
                
                iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
                IF iControl MODULO 1000 = 0 THEN
                        DISPLAY "COMPRAS: " + STRING(ccbcdocu.fchdoc) + " " + 
                            ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ fi-Mensaje
                            WITH FRAME f-Proceso.
&ENDIF
                FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Detalle THEN DO:
                    CREATE Detalle.
                    ASSIGN Detalle.codcli = Ccbcdocu.codcli.
                END.

                /* ************************************************************************************************************** */
                /* 1ro CALCULAMOS A PARTIR DE LA CABECERA */
                /* ************************************************************************************************************** */
                x-ImpTot = CcbCDocu.TotalPrecioVenta.
                LControl = YES.     /* POR DEFECTO ARITMETICA DE SUNAT */
                IF x-ImpTot = 0 AND Ccbcdocu.ImpTot > 0 THEN ASSIGN x-ImpTot = Ccbcdocu.ImpTot LControl = NO.
                /* 12/09/2024: Gina Condor NO línea 011 */
                FOR EACH Ccbddocu FIELDS (codcia coddiv coddoc nrodoc codmat implin cImporteTotalConImpuesto) OF Ccbcdocu NO-LOCK, 
                    FIRST Almmmatg FIELDS (codcia codmat codfam) OF Ccbddocu NO-LOCK WHERE Almmmatg.codfam = '011':
                    x-ImpLin = Ccbddocu.cImporteTotalConImpuesto.
                    /*IF x-ImpLin = 0 AND Ccbddocu.ImpLin > 0 THEN x-ImpLin = Ccbddocu.ImpLin.*/
                    IF LControl = NO THEN x-ImpLin = Ccbddocu.ImpLin.   /* NO ES ARITMETICA DE SUNAT */
                    x-ImpTot = x-ImpTot - x-ImpLin.
                END.
                /* ************************************ */
                IF Ccbcdocu.codmon = 2 THEN DO:
                    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-tcmb THEN
                        ASSIGN
                        x-TpoCmbCmp = gn-tcmb.compra 
                        x-TpoCmbVta = gn-tcmb.venta.
                    x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
                END.
                CASE x-Contador:
                    WHEN 1 THEN ASSIGN Detalle.Compras_01 = Detalle.Compras_01 + x-ImpTot.
                    WHEN 2 THEN ASSIGN Detalle.Compras_02 = Detalle.Compras_02 + x-ImpTot.
                    WHEN 3 THEN ASSIGN Detalle.Compras_03 = Detalle.Compras_03 + x-ImpTot.
                    WHEN 4 THEN ASSIGN Detalle.Compras_04 = Detalle.Compras_04 + x-ImpTot.
                    WHEN 5 THEN ASSIGN Detalle.Compras_05 = Detalle.Compras_05 + x-ImpTot.
                END CASE.
                /* ************************************************************************************************************** */
                /* ************************************************************************************************************** */
                /* ************************************************************************************************************** */
                /* 2do. CALCULAMOS A PARTIR DEL DETALLE */
                /* 12/09/2024: Gina Condor NO línea 011 */
                /* ************************************************************************************************************** */
                FOR EACH Ccbddocu FIELDS (codcia coddiv coddoc nrodoc codmat implin cImporteTotalConImpuesto) OF Ccbcdocu NO-LOCK, 
                    FIRST Almmmatg FIELDS (codcia codmat codfam) OF Ccbddocu NO-LOCK WHERE Almmmatg.codfam <> '011':
                    x-ImpLin = Ccbddocu.cImporteTotalConImpuesto.
                    /*IF x-ImpLin = 0 AND Ccbddocu.ImpLin > 0 THEN x-ImpLin = Ccbddocu.ImpLin.*/
                    IF LControl = NO THEN x-ImpLin = Ccbddocu.ImpLin.
                    IF Ccbcdocu.codmon = 2 THEN x-ImpLin = x-ImpLin * x-TpoCmbVta.  /* Todo en SOLES */
                    RUN compras-por-linea (INPUT x-Contador, INPUT x-ImpLin).
                END.
                /* ************************************************************************************************************** */
            END.
        END.
    END.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compras-por-linea Include 
PROCEDURE compras-por-linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEF INPUT PARAMETER x-Contador AS INTE.
    DEF INPUT PARAMETER x-ImpLin AS DECI.

    CASE Almmmatg.codfam:
        WHEN "001" THEN DO:
            CASE x-Contador:
                WHEN 1 THEN Detalle.Compras_01_01 = Detalle.Compras_01_01 + x-ImpLin.
                WHEN 2 THEN Detalle.Compras_02_01 = Detalle.Compras_02_01 + x-ImpLin.
                WHEN 3 THEN Detalle.Compras_03_01 = Detalle.Compras_03_01 + x-ImpLin.
                WHEN 4 THEN Detalle.Compras_04_01 = Detalle.Compras_04_01 + x-ImpLin.
                WHEN 5 THEN Detalle.Compras_05_01 = Detalle.Compras_05_01 + x-ImpLin.
            END CASE.
        END.
        WHEN "010" THEN DO:
            CASE x-Contador:
                WHEN 1 THEN Detalle.Compras_01_02 = Detalle.Compras_01_02 + x-ImpLin.
                WHEN 2 THEN Detalle.Compras_02_02 = Detalle.Compras_02_02 + x-ImpLin.
                WHEN 3 THEN Detalle.Compras_03_02 = Detalle.Compras_03_02 + x-ImpLin.
                WHEN 4 THEN Detalle.Compras_04_02 = Detalle.Compras_04_02 + x-ImpLin.
                WHEN 5 THEN Detalle.Compras_05_02 = Detalle.Compras_05_02 + x-ImpLin.
            END CASE.
        END.
        WHEN "012" THEN DO:
            CASE x-Contador:
                WHEN 1 THEN Detalle.Compras_01_03 = Detalle.Compras_01_03 + x-ImpLin.
                WHEN 2 THEN Detalle.Compras_02_03 = Detalle.Compras_02_03 + x-ImpLin.
                WHEN 3 THEN Detalle.Compras_03_03 = Detalle.Compras_03_03 + x-ImpLin.
                WHEN 4 THEN Detalle.Compras_04_03 = Detalle.Compras_04_03 + x-ImpLin.
                WHEN 5 THEN Detalle.Compras_05_03 = Detalle.Compras_05_03 + x-ImpLin.
            END CASE.
        END.
        WHEN "013" THEN DO:
            CASE x-Contador:
                WHEN 1 THEN Detalle.Compras_01_04 = Detalle.Compras_01_04 + x-ImpLin.
                WHEN 2 THEN Detalle.Compras_02_04 = Detalle.Compras_02_04 + x-ImpLin.
                WHEN 3 THEN Detalle.Compras_03_04 = Detalle.Compras_03_04 + x-ImpLin.
                WHEN 4 THEN Detalle.Compras_04_04 = Detalle.Compras_04_04 + x-ImpLin.
                WHEN 5 THEN Detalle.Compras_05_04 = Detalle.Compras_05_04 + x-ImpLin.
            END CASE.
        END.
        OTHERWISE DO:
            CASE x-Contador:
                WHEN 1 THEN Detalle.Compras_01_05 = Detalle.Compras_01_05 + x-ImpLin.
                WHEN 2 THEN Detalle.Compras_02_05 = Detalle.Compras_02_05 + x-ImpLin.
                WHEN 3 THEN Detalle.Compras_03_05 = Detalle.Compras_03_05 + x-ImpLin.
                WHEN 4 THEN Detalle.Compras_04_05 = Detalle.Compras_04_05 + x-ImpLin.
                WHEN 5 THEN Detalle.Compras_05_05 = Detalle.Compras_05_05 + x-ImpLin.
            END CASE.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Finales Include 
PROCEDURE Datos-Finales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cTexto AS CHAR NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

FOR EACH Detalle EXCLUSIVE-LOCK:
    IF TRUE <> (Detalle.codcli > "") THEN DO:
        DELETE Detalle.
        NEXT.
    END.

    iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
        IF iControl MODULO 1000 = 0 THEN
            DISPLAY "DATOS FINALES: " + Detalle.codcli @ fi-Mensaje WITH FRAME f-Proceso.
&ENDIF
    /* Clientes */
    FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = Detalle.codcli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN NEXT.
    ASSIGN 
        Detalle.nomcli = gn-clie.NomCli 
        Detalle.Desde = YEAR(gn-clie.Fching).
    /* Limpiamos textos */
    RUN lib/limpiar-texto-contains (Detalle.nomcli,
                                    " ",
                                    OUTPUT cTexto).
    Detalle.nomcli = cTexto.
    Detalle.RucCli = gn-clie.ruc.
    /* Grupo */
    IF Detalle.Grupo > "" THEN DO:
        FIND b-gn-clie WHERE b-gn-clie.codcia = cl-codcia AND b-gn-clie.codcli = Detalle.Grupo NO-LOCK NO-ERROR.
        IF AVAILABLE b-gn-clie THEN DO:
            Detalle.NomGrupo = b-gn-clie.nomcli.
            /* Limpiamos textos */
            RUN lib/limpiar-texto-contains (Detalle.NomGrupo,
                                            " ",
                                            OUTPUT cTexto).
            Detalle.NomGrupo = cTexto.
        END.
    END.
    /* Ubigeo */
    FIND FIRST gn-clied WHERE Gn-ClieD.CodCia = cl-codcia AND
        Gn-ClieD.CodCli = Detalle.codcli AND
        Gn-ClieD.Sede = "@@@" NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        FIND TabDepto WHERE TabDepto.CodDepto = Gn-ClieD.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
    END.
END.
HIDE FRAME f-Proceso.

/* RASTREO DE GRUPOS */
/* 1) Buscamos los grupos implicados */
EMPTY TEMP-TABLE t-gn-clie.
FOR EACH Detalle NO-LOCK WHERE Detalle.Grupo > "", 
    FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND 
        gn-clie.codcli = Detalle.grupo:
    FIND FIRST t-gn-clie WHERE t-gn-clie.codcia = cl-codcia AND
        t-gn-clie.codcli = Detalle.grupo NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-gn-clie THEN DO:
&IF {&TERMINAL-WINDOWS} &THEN
            DISPLAY "RASTREO GRUPOS: " + Detalle.grupo @ fi-Mensaje WITH FRAME f-Proceso.
&ENDIF
        CREATE t-gn-clie.
        BUFFER-COPY gn-clie TO t-gn-clie.
    END.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

/* 2) Por cada grupo buscamos sus registros en Detalle.
        Si no existe el grupo como cliente (no ha tenido venta como grupo) se crea un registro
*/
DEF VAR pJefe AS CHAR NO-UNDO.
DEF VAR x-LinCre01 LIKE Detalle.LinCred01 NO-UNDO.
DEF VAR x-LinCre02 LIKE Detalle.LinCred02 NO-UNDO.
DEF VAR x-LinCre03 LIKE Detalle.LinCred03 NO-UNDO.
DEF VAR x-LinCre04 LIKE Detalle.LinCred04 NO-UNDO.
DEF VAR x-LinCre05 LIKE Detalle.LinCred05 NO-UNDO.
DEF VAR x-NomGrupo LIKE Detalle.NomGrupo  NO-UNDO.

FOR EACH t-gn-clie NO-LOCK, 
    FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = t-gn-clie.codcia AND gn-clie.codcli = t-gn-clie.codcli:
&IF {&TERMINAL-WINDOWS} &THEN
        DISPLAY "GRUPOS FINAL: " + t-gn-clie.codcli @ fi-Mensaje WITH FRAME f-Proceso.
&ENDIF

    pJefe = t-gn-clie.codcli.
    FIND FIRST Detalle WHERE Detalle.codcli = pJefe NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN NOT AVAILABLE Detalle THEN DO:
            /* NO hay movimiento por el Jefe */
            /* Solo el Jefe debe tener información de la línea de crédito */
            FOR EACH Detalle EXCLUSIVE-LOCK WHERE Detalle.grupo = t-gn-clie.codcli:     /* OJO */
                x-LinCre01 = Detalle.LinCred01.
                x-LinCre02 = Detalle.LinCred02.
                x-LinCre03 = Detalle.LinCred03.
                x-LinCre04 = Detalle.LinCred04.
                x-LinCre05 = Detalle.LinCred05.
                x-NomGrupo = Detalle.NomGrupo.
                Detalle.LinCred01 = 0.
                Detalle.LinCred02 = 0.
                Detalle.LinCred03 = 0.
                Detalle.LinCred04 = 0.
                Detalle.LinCred05 = 0.
            END.
            /* Creamos el registro fantasma */
            CREATE Detalle.
            ASSIGN
                Detalle.CodCli = gn-clie.codcli 
                Detalle.RucCli = gn-clie.ruc
                Detalle.NomCli = x-NomGrupo
                Detalle.Grupo  = pJefe
                Detalle.NomGrupo = x-NomGrupo
                Detalle.Desde  = YEAR(gn-clie.Fching)
                Detalle.LinCred01 = x-LinCre01
                Detalle.LinCred02 = x-LinCre02
                Detalle.LinCred03 = x-LinCre03
                Detalle.LinCred04 = x-LinCre04
                Detalle.LinCred05 = x-LinCre05
                .
            /* Ubigeo */
            FIND FIRST gn-clied WHERE Gn-ClieD.CodCia = cl-codcia AND
                Gn-ClieD.CodCli = Detalle.codcli AND
                Gn-ClieD.Sede = "@@@" NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO:
                FIND TabDepto WHERE TabDepto.CodDepto = Gn-ClieD.CodDept NO-LOCK NO-ERROR.
                IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
            END.
        END.
        OTHERWISE DO:
            /* Mantenemos el Jefe */
            /* Solo el Jefe debe tener información de la línea de crédito */
            FOR EACH Detalle EXCLUSIVE-LOCK WHERE Detalle.grupo = t-gn-clie.codcli:     /* OJO */
                IF Detalle.codcli <> pJefe THEN DO:
                    Detalle.LinCred01 = 0.
                    Detalle.LinCred02 = 0.
                    Detalle.LinCred03 = 0.
                    Detalle.LinCred04 = 0.
                    Detalle.LinCred05 = 0.
                END.
            END.
        END.
    END CASE.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deuda-actual Include 
PROCEDURE deuda-actual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cListaDocCargo AS CHAR NO-UNDO.
DEF VAR cListaDocAbono AS CHAR NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR cCodRef AS CHAR NO-UNDO.
DEF VAR cNroRef AS CHAR NO-UNDO.

DEF VAR x-ImpTot AS DECI NO-UNDO.

ASSIGN
    cListaDocCargo = "FAC,BOL,N/D,LET,DCO,FAI"
    cListaDocAbono = "N/C,BD,A/R,A/C,LPA"
    .

DEF VAR iItem AS INTE NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

/* Documentos de Cargo */
DO iItem = 1 TO NUM-ENTRIES(cListaDocCargo):
    FOR EACH Ccbcdocu FIELDS(coddoc nrodoc fchdoc sdoact codmon codcli tpofac fmapgo) NO-LOCK 
        WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.flgest = "P" AND
        Ccbcdocu.coddoc = ENTRY(iItem,cListaDocCargo) AND
        Ccbcdocu.sdoact > 0,
        FIRST gn-clie FIELDS(codcia codcli ruc) NO-LOCK WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = Ccbcdocu.codcli:
        /* FILTROS */
        IF TOGGLE-Solo-Ruc = YES AND TRUE <> (gn-clie.ruc > "") THEN NEXT.
        IF LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN NEXT.
        IF LOOKUP(Ccbcdocu.FmaPgo, '899,900') > 0 THEN NEXT.
        /* ******* */
        iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
        IF iControl MODULO 1000 = 0 THEN
                DISPLAY "DEUDA ACTUAL: " + STRING(ccbcdocu.fchdoc) + " " + 
                    ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ fi-Mensaje
                    WITH FRAME f-Proceso.
&ENDIF
        x-ImpTot = Ccbcdocu.SdoAct.
        IF Ccbcdocu.CodMon = 2 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
        END.
        FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.codcli = Ccbcdocu.codcli.
        END.
        ASSIGN
            Detalle.Saldo = Detalle.Saldo + x-ImpTot.
    END.
END.

&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

/* Documentos de Abono */
DO iItem = 1 TO NUM-ENTRIES(cListaDocAbono):
    FOR EACH Ccbcdocu FIELDS(coddoc nrodoc fchdoc sdoact codmon codcli ) NO-LOCK  WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.flgest = "P" AND
        Ccbcdocu.coddoc = ENTRY(iItem,cListaDocAbono) AND
        Ccbcdocu.sdoact > 0,
        FIRST gn-clie FIELDS(codcia codcli ruc) NO-LOCK WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = Ccbcdocu.codcli:
        IF TOGGLE-Solo-Ruc = YES AND TRUE <> (gn-clie.ruc > "") THEN NEXT.
        iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
        IF iControl MODULO 1000 = 0 THEN
                DISPLAY "DEUDA ACTUAL: " + STRING(ccbcdocu.fchdoc) + " " + 
                    ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ fi-Mensaje
                    WITH FRAME f-Proceso.
&ENDIF
        x-ImpTot = Ccbcdocu.SdoAct.
        IF Ccbcdocu.CodMon = 2 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
        END.
        FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.codcli = Ccbcdocu.codcli.
        END.
        ASSIGN
            Detalle.Saldo = Detalle.Saldo - x-ImpTot.
    END.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE letras-protestadas Include 
PROCEDURE letras-protestadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR x-Documentos AS CHAR NO-UNDO.

/* Del último periodo */
x-FchIni = FILL-IN-FchIni-5.
x-FchFin = FILL-IN-FchFin-5.
x-Documentos = "P/C,P/X".

DEF VAR x-Item AS INTE NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

DO x-Item = 1 TO 2:
    FOR EACH Ccbcmvto 
        FIELDS(codcia fchdoc coddoc nrodoc)
        NO-LOCK 
        WHERE Ccbcmvto.codcia = s-codcia AND
        Ccbcmvto.coddoc = ENTRY(x-Item,x-Documentos) AND
        Ccbcmvto.fchdoc >= x-FchIni AND
        Ccbcmvto.fchdoc <= x-FchFin AND
        Ccbcmvto.flgest <> "A",
        FIRST gn-clie 
        FIELDS(codcia codcli ruc)
        NO-LOCK
        WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = Ccbcmvto.codcli:
        IF TOGGLE-Solo-Ruc = YES AND TRUE <> (gn-clie.ruc > "") THEN NEXT.

        iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
        IF iControl MODULO 1000 = 0 THEN
                DISPLAY "PROTESTO: " + STRING(Ccbcmvto.fchdoc) + " " + 
                    Ccbcmvto.coddoc + " " + Ccbcmvto.nrodoc @ fi-Mensaje
                    WITH FRAME f-Proceso.
&ENDIF
        FOR EACH Ccbdmvto NO-LOCK WHERE CcbDMvto.CodCia = Ccbcmvto.codcia AND
            CcbDMvto.CodDoc = Ccbcmvto.coddoc AND
            CcbDMvto.NroDoc = Ccbcmvto.nrodoc,
            FIRST Ccbcdocu 
            FIELDS(codcia codcli imptot codmon fchdoc coddoc nrodoc)
            NO-LOCK 
            WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.coddoc = Ccbdmvto.codref AND
            Ccbcdocu.nrodoc = Ccbdmvto.nroref:
            FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Detalle THEN DO:
                CREATE Detalle.
                ASSIGN Detalle.codcli = Ccbcdocu.codcli.
            END.
            x-ImpTot = Ccbcdocu.imptot.
            IF Ccbcdocu.codmon = 2 THEN DO:
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE gn-tcmb THEN
                    ASSIGN
                    x-TpoCmbCmp = gn-tcmb.compra
                    x-TpoCmbVta = gn-tcmb.venta.
                x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
            END.
            ASSIGN Detalle.Protesto = Detalle.Protesto + x-ImpTot.
            IF TRUE <> (Detalle.Nros_Protesto > '') THEN Detalle.Nros_Protesto = Ccbcdocu.nrodoc.
            ELSE Detalle.Nros_Protesto = Nros_Protesto + "," + Ccbcdocu.nrodoc.
            IF Detalle.Nros_Protesto > '' THEN Detalle.Qty_Protesto = NUM-ENTRIES(Detalle.Nros_Protesto).
        END.
    END.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Linea-de-credito Include 
PROCEDURE Linea-de-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************* */
/* Verificamos si es un cliente agrupado */
/* ¿es el Master? */
/* ************************************* */
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.
DEF VAR pCodCli AS CHAR NO-UNDO.
DEF VAR pImpLCred AS DECI NO-UNDO.

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-Contador AS INTE NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

FOR EACH Detalle EXCLUSIVE-LOCK:
    iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
    IF iControl MODULO 1000 = 0 THEN
            DISPLAY "LINEA DE CREDITO: " + Detalle.codcli @ fi-Mensaje
                WITH FRAME f-Proceso.
&ENDIF
    pCodCli = Detalle.codcli.
    RUN ccb/p-cliente-master (pCodCli,
                              OUTPUT pMaster,
                              OUTPUT pRelacionados,
                              OUTPUT pAgrupados).
    IF pAgrupados = YES AND pMaster > '' THEN DO:
        pCodCli = pMaster.    /* Cambiamos al Master */
        ASSIGN
            Detalle.Grupo = pMaster.
    END.

    /* Buscamos si tiene definida LINEA DE CREDITO */
    FIND FIRST Gn-ClieL WHERE Gn-ClieL.CodCia = cl-CodCia
        AND Gn-ClieL.CodCli = pCodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-cliel THEN NEXT.

    /* Hay que buscar 5 líneas de crédito */
    x-FchIni = ?.   /* Valor de inicio */

    DO x-Contador = 1 TO 5:
        /* ******************************************** */
        /* 11/07/2025 Gina Cóndor: Siempre debe ser así */
        /* ******************************************** */
        CASE x-Contador:
            WHEN 1 THEN ASSIGN x-FchIni = FILL-IN-FchVto-1 x-FchFin = FILL-IN-FchVto-1.
            WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchVto-2 x-FchFin = FILL-IN-FchVto-2.
            WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchVto-3 x-FchFin = FILL-IN-FchVto-3.
            WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchVto-4 x-FchFin = FILL-IN-FchVto-4.
            WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchVto-5 x-FchFin = FILL-IN-FchVto-5.
        END CASE.
/*         CASE x-Contador:                                                                    */
/*             WHEN 1 THEN ASSIGN x-FchIni = FILL-IN-FchIni-1 x-FchFin = FILL-IN-FchFin-1.     */
/*             WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchIni-2 x-FchFin = FILL-IN-FchFin-2.     */
/*             WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchIni-3 x-FchFin = FILL-IN-FchFin-3.     */
/*             WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchIni-4 x-FchFin = FILL-IN-FchFin-4.     */
/*             WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchIni-5 x-FchFin = FILL-IN-FchFin-5.     */
/*         END CASE.                                                                           */
/*         /* 16/9/2024: Gina Condor, una fecha específica */                                  */
/*         IF TOGGLE-Vcto_Linea_Credito = YES THEN DO:                                         */
/*             CASE x-Contador:                                                                */
/*                 WHEN 1 THEN ASSIGN x-FchIni = FILL-IN-FchVto-1 x-FchFin = FILL-IN-FchVto-1. */
/*                 WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchVto-2 x-FchFin = FILL-IN-FchVto-2. */
/*                 WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchVto-3 x-FchFin = FILL-IN-FchVto-3. */
/*                 WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchVto-4 x-FchFin = FILL-IN-FchVto-4. */
/*                 WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchVto-5 x-FchFin = FILL-IN-FchVto-5. */
/*             END CASE.                                                                       */
/*         END.                                                                                */
        ASSIGN pImpLCred = 0.
        /* ********************************************************************** */
        /* OJO: se toma la fecha final mas no la fecha inicial */
        /* ********************************************************************** */
        FOR EACH Gn-ClieL 
            FIELDS(fchini fchfin implc)
            NO-LOCK 
            WHERE Gn-ClieL.CodCia = cl-CodCia
            AND Gn-ClieL.CodCli = pCodCli
            AND Gn-ClieL.FchFin = x-FchFin 
            BY gn-cliel.fchini BY gn-cliel.fchfin:
            pImpLCred = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */
        END.
        /* ********************************************************************** */
/*         CASE TOGGLE-Vcto_Linea_Credito:                                                               */
/*             WHEN YES THEN DO:                                                                         */
/*                 FOR EACH Gn-ClieL                                                                     */
/*                     FIELDS(fchini fchfin implc)                                                       */
/*                     NO-LOCK                                                                           */
/*                     WHERE Gn-ClieL.CodCia = cl-CodCia                                                 */
/*                     AND Gn-ClieL.CodCli = pCodCli                                                     */
/*                     AND Gn-ClieL.FchFin = x-FchFin                                                    */
/*                     BY gn-cliel.fchini BY gn-cliel.fchfin:                                            */
/*                     pImpLCred = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */ */
/*                 END.                                                                                  */
/*             END.                                                                                      */
/*             OTHERWISE DO:                                                                             */
/*                 FOR EACH Gn-ClieL                                                                     */
/*                     FIELDS(fchini fchfin implc)                                                       */
/*                     NO-LOCK                                                                           */
/*                     WHERE Gn-ClieL.CodCia = cl-CodCia                                                 */
/*                     AND Gn-ClieL.CodCli = pCodCli                                                     */
/*                     AND Gn-ClieL.FchFin <= x-FchFin                                                   */
/*                     BY gn-cliel.fchini BY gn-cliel.fchfin:                                            */
/*                     IF Gn-ClieL.FchIni = ? OR Gn-ClieL.FchFin = ? THEN NEXT.                          */
/*                     IF x-FchIni <> ? THEN IF NOT (Gn-ClieL.FchFin > x-FchIni) THEN NEXT.              */
/*                     IF x-FchIni <> ? THEN IF NOT (Gn-ClieL.FchIni >= x-FchIni) THEN NEXT.             */
/*                     pImpLCred = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */ */
/*                 END.                                                                                  */
/*             END.                                                                                      */
/*         END CASE.                                                                                     */
        IF pImpLCred < 0 THEN pImpLCred = 0.
        CASE x-Contador:
            WHEN 1 THEN ASSIGN Detalle.LinCred01 = pImpLCred.
            WHEN 2 THEN ASSIGN Detalle.LinCred02 = pImpLCred.
            WHEN 3 THEN ASSIGN Detalle.LinCred03 = pImpLCred.
            WHEN 4 THEN ASSIGN Detalle.LinCred04 = pImpLCred.
            WHEN 5 THEN ASSIGN Detalle.LinCred05 = pImpLCred.
        END CASE.
    END.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Refinanciamientos Include 
PROCEDURE Refinanciamientos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

/* Del último periodo */
x-FchIni = FILL-IN-FchIni-5.
x-FchFin = FILL-IN-FchFin-5.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
    EACH Ccbcmvto 
    FIELDS(codcia coddoc nrodoc fchdoc)
    NO-LOCK 
    WHERE Ccbcmvto.codcia = s-codcia AND
    Ccbcmvto.coddiv = gn-divi.coddiv AND
    Ccbcmvto.coddoc = "REF" AND
    Ccbcmvto.fchdoc >= x-FchIni AND
    Ccbcmvto.fchdoc <= x-FchFin AND
    CcbCMvto.FlgEst = "E",
    FIRST gn-clie 
    FIELDS(codcia codcli ruc)
    NO-LOCK
    WHERE gn-clie.codcia = cl-codcia AND
    gn-clie.codcli = Ccbcmvto.codcli:
    IF TOGGLE-Solo-Ruc = YES AND TRUE <> (gn-clie.ruc > "") THEN NEXT.

    FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = Ccbcmvto.codcia AND
        Ccbdcaja.coddoc = Ccbcmvto.coddoc AND
        Ccbdcaja.nrodoc = Ccbcmvto.nrodoc,
        FIRST Ccbcdocu 
        FIELDS(codcia codcli imptot codmon)
        NO-LOCK 
        WHERE Ccbcdocu.codcia = Ccbdcaja.codcia AND
        Ccbcdocu.coddoc = Ccbdcaja.codref AND
        Ccbcdocu.nrodoc = Ccbdcaja.nroref:
        iControl = iControl + 1.
&IF {&TERMINAL-WINDOWS} &THEN
        IF iControl MODULO 1000 = 0 THEN
                DISPLAY "PROTESTO: " + STRING(Ccbcmvto.fchdoc) + " " + 
                    Ccbcmvto.coddoc + " " + Ccbcmvto.nrodoc @ fi-Mensaje
                    WITH FRAME f-Proceso.
&ENDIF
        FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN Detalle.codcli = Ccbcdocu.codcli.
        END.
        x-ImpTot = Ccbdcaja.imptot.
        IF Ccbdcaja.codmon = 2 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbdcaja.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
        END.
        ASSIGN Detalle.Refinanciacion = Detalle.Refinanciacion + x-ImpTot.
    END.
END.
&IF {&TERMINAL-WINDOWS} &THEN
    HIDE FRAME f-Proceso.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

