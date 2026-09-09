&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMinoristaContado*/
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMinoristaContadoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMinorista.p

/* ***************************  Definitions  ************************** */
DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

DEF INPUT PARAMETER pRowid AS ROWID.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.

DEF VAR x-CodigoEncarte AS CHAR NO-UNDO.   /* OJO: Código del ENCARTE */

IF B-CPEDI.FlgSit = "CD" THEN x-CodigoEncarte = B-CPEDI.Libre_c05.    /* Por Defecto */

IF TRUE <> (x-CodigoEncarte > "") THEN RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
IF B-CPEDI.CodCli BEGINS 'SYS' THEN DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = B-CPEDI.codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.llave = x-CodigoEncarte    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = B-CPEDI.codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.Estado = "A"      /* Activa */
        AND TODAY >= VtaCTabla.FechaInicial
        AND TODAY <= VtaCTabla.FechaFinal
        AND VtaCTabla.llave = x-CodigoEncarte    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
END.
IF NOT AVAILABLE VtaCTabla THEN RETURN 'OK'.

IF TRUE <> (VtaCTabla.Libre_c01 > '') THEN RETURN 'OK'.

FIND FIRST AlmCKits WHERE AlmCKits.CodCia = Vtactabla.codcia
    AND AlmCKits.codmat = Vtactabla.libre_c01
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmCKits THEN RETURN 'OK'.
FIND Almmmatg OF Almckits NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN 'OK'.

DEF TEMP-TABLE Detalle   NO-UNDO LIKE Facdpedi.

FOR EACH B-DPEDI OF B-CPEDI NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY B-DPEDI TO Detalle.
END.
/* Armamos kits */
DEF VAR xCuentaKits AS INT INIT 0 NO-UNDO.
rloop:
REPEAT:
    /* 1ro. verificamos */
    FOR EACH Almdkits OF Almckits NO-LOCK:
        FIND FIRST Detalle WHERE Detalle.codmat = AlmDKits.codmat2 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle OR Almdkits.cantidad > Detalle.canped THEN LEAVE rloop.
    END.
    /* 2do actualizamos */
    FOR EACH Almdkits OF Almckits NO-LOCK:
        FIND FIRST Detalle WHERE Detalle.codmat = AlmDKits.codmat2.
        Detalle.canped = Detalle.canped - Almdkits.cantidad.
        IF Detalle.CanPed <= 0 THEN DELETE Detalle.
    END.
    xCuentaKits = xCuentaKits + 1.
    /* Control de Tope */
    IF VtaCTabla.Libre_d03 > 0 AND xCuentaKits >= VtaCTabla.Libre_d03 THEN LEAVE.
END.
/* Agregamos kits */
IF xCuentaKits > 0 THEN DO:
    RUN Rehacer-Detalle.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Rehacer-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rehacer-Detalle Procedure 
PROCEDURE Rehacer-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-NroItm AS INT NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor LIKE Facdpedi.factor NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    ASSIGN
        s-UndVta = Almmmatg.UndStk
        f-Factor = 1.
    CREATE Detalle.
    ASSIGN
        Detalle.NroItm = 999
        Detalle.codcia = B-CPEDI.codcia
        Detalle.coddiv = B-CPEDI.coddiv
        Detalle.coddoc = B-CPEDI.coddoc
        Detalle.nroped = B-CPEDI.nroped
        Detalle.fchped = B-CPEDI.fchped.
    ASSIGN 
        Detalle.CodMat = AlmCKits.codmat
        Detalle.CanPed = xCuentaKits.
    RUN {&precio-venta-general} (B-CPEDI.CodDiv,
                                 B-CPEDI.CodMon,
                                 B-CPEDI.TpoCmb,
                                 OUTPUT s-UndVta,
                                 OUTPUT f-Factor,
                                 Detalle.CodMat,
                                 Detalle.CanPed,
                                 4,
                                 "",       /* s-codbko, */
                                 "",
                                 "",
                                 "",
                                 "",
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT z-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    ASSIGN 
        Detalle.UndVta = s-UndVta
        Detalle.Factor = f-Factor
        Detalle.AlmDes = B-CPEDI.codalm
        Detalle.PreUni = f-PreBas
        Detalle.Por_Dsctos[2] = z-dsctos
        Detalle.Por_Dsctos[3] = y-Dsctos
        Detalle.PreBas = F-PreBas 
        Detalle.AftIgv = Almmmatg.AftIgv
        Detalle.AftIsc = Almmmatg.AftIsc
        Detalle.Libre_c04 = X-TIPDTO.
    ASSIGN
        Detalle.ImpLin = Detalle.CanPed * Detalle.PreUni * 
        ( 1 - Detalle.Por_Dsctos[1] / 100 ) *
        ( 1 - Detalle.Por_Dsctos[2] / 100 ) *
        ( 1 - Detalle.Por_Dsctos[3] / 100 )
        Detalle.ImpDto2 = ROUND ( Detalle.ImpLin * Detalle.PorDto2 / 100, 2).
    IF Detalle.Por_Dsctos[1] = 0 AND Detalle.Por_Dsctos[2] = 0 AND Detalle.Por_Dsctos[3] = 0 
        THEN Detalle.ImpDto = 0.
    ELSE Detalle.ImpDto = Detalle.CanPed * Detalle.PreUni - Detalle.ImpLin.
    ASSIGN
        Detalle.ImpLin = ROUND(Detalle.ImpLin, 2)
        Detalle.ImpDto = ROUND(Detalle.ImpDto, 2).
    IF Detalle.AftIsc 
        THEN Detalle.ImpIsc = ROUND(Detalle.PreBas * Detalle.CanPed * (Almmmatg.PorIsc / 100),4).
    IF Detalle.AftIgv 
        THEN Detalle.ImpIgv = Detalle.ImpLin - ROUND( Detalle.ImpLin  / ( 1 + (B-CPEDI.PorIgv / 100) ), 4 ).
    /* Regeneramos todos los items */
    FOR EACH B-DPEDI OF B-CPEDI EXCLUSIVE-LOCK:
        DELETE B-DPEDI.
    END.
    i-NroItm = 1.
    FOR EACH Detalle BY Detalle.NroItm:
        CREATE B-DPEDI.
        BUFFER-COPY Detalle
            TO B-DPEDI
            ASSIGN B-DPEDI.NroItm = i-NroItm.
        i-NroItm = i-NroItm + 1.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

