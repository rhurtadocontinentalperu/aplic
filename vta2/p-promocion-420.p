&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



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

/* ***************************  Definitions  ************************** */

/* Solicitamos el P/M */                                    
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER TABLE FOR ITEM.

EMPTY TEMP-TABLE ITEM.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK.
/* Buscamos la promoción */
FIND Vtactabla WHERE VTactabla.codcia = Faccpedi.codcia
    AND Vtactabla.tabla = 'PROM'
    AND Vtactabla.llave = '000000420'   /* Prom Cuad Stdf Color Entero y Diseño */
    AND Vtactabla.Estado = "I"          /* debe estar INACTIVA */
    AND Vtactabla.Libre_d01 > 0         /* Unidades (ej. 25 ) */
    NO-LOCK NO-ERROR.       
IF NOT AVAILABLE Vtactabla THEN RETURN 'OK'.

IF NOT (TODAY >= Vtactabla.FechaInicial AND TODAY <= Vtactabla.FechaFinal)
    THEN RETURN 'OK'.

FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "D"
    AND Vtadtabla.LlaveDetalle = Faccpedi.CodDiv
    AND VtaDTabla.Libre_l01 = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtadtabla THEN RETURN 'OK'.

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
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Veamos si llega a la promoción */
DEF VAR x-Cantidad AS DEC NO-UNDO.

FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
    IF CAN-FIND(FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "M"
                AND Vtadtabla.LlaveDetalle = Facdpedi.codmat NO-LOCK)
        THEN x-Cantidad = x-Cantidad + (Facdpedi.CanPed * Facdpedi.Factor).
END.
IF x-Cantidad < Vtactabla.Libre_d01 THEN RETURN 'OK'.

DEF VAR x-Factor AS INT NO-UNDO.
/* Cargamos las Promociones */
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "OF" AND Vtadtabla.Libre_d01 > 0,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Vtadtabla.codcia
    AND Almmmatg.codmat = Vtadtabla.LlaveDetalle:
    x-Factor = TRUNCATE(x-Cantidad / Vtactabla.Libre_d01, 0).
    IF x-Factor < 1 THEN NEXT.
    CREATE ITEM.
    BUFFER-COPY Faccpedi TO ITEM
        ASSIGN
        ITEM.NroItm = 1
        ITEM.AlmDes = ENTRY(1, Faccpedi.CodAlm)
        ITEM.CodMat = Almmmatg.CodMat
        ITEM.UndVta = Almmmatg.UndStk
        ITEM.Factor = 1
        ITEM.CanPed = Vtadtabla.Libre_d01 * x-Factor.
END.
/* Cargamos Precio Unitario */
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DEC NO-UNDO.

FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK:
    s-UndVta = ITEM.UndVta.
    RUN vta2/PrecioMayorista-Cred-v2 (
        "N",
        Faccpedi.CodDiv,
        Faccpedi.CodCli,
        Faccpedi.CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        ITEM.codmat,
        Faccpedi.FmaPgo,
        ITEM.CanPed,
        2,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        OUTPUT f-FleteUnitario,
        "C",    
        NO
        ).
    /* Precio de Costo */
    f-PreVta = Almmmatg.CtoTot * f-Factor.
    IF Faccpedi.CodMon <> Almmmatg.MOnVta THEN DO:
        IF Faccpedi.CodMon = 1 THEN f-PreVta = f-PreVta * Almmmatg.TpoCmb.
        ELSE f-PreVta = f-PreVta / Almmmatg.TpoCmb.
    END.
    f-PreBas = f-PreVta.
    IF f-PreVta = 0 THEN ASSIGN f-PreVta = 1.   /* CUalquier Valor */
    ASSIGN 
        ITEM.PorDto = 0
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.Libre_c04 = "".
    ASSIGN 
        ITEM.PreUni = f-PreVta
        ITEM.Por_Dsctos[1] = 0
        ITEM.Por_Dsctos[2] = 0
        ITEM.Por_Dsctos[3] = 0
        ITEM.Libre_d02 = f-FleteUnitario.         /* Flete Unitario */
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
    IF f-FleteUnitario > 0 THEN DO:
        /* Ic - 28Set2018, si el flete debe considerarse, segun Karin Roden.... */
        RUN gn/factor-porcentual-flete-v2(INPUT Faccpedi.CodDiv, 
                                          INPUT ITEM.codmat, 
                                          INPUT-OUTPUT f-FleteUnitario, 
                                          INPUT "N", 
                                          INPUT ITEM.Factor, 
                                          INPUT Faccpedi.CodMon).
        ASSIGN ITEM.Libre_d02 = f-FleteUnitario. 
        /* El flete afecta el monto final */
        IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                ITEM.PreUni = ROUND(ITEM.PreUni + f-FleteUnitario, 2)  /* Incrementamos el PreUni */
                ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
            ASSIGN
                ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
                ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, 2).
        END.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.

    ASSIGN
        ITEM.Libre_c05 = "OF".  /* LOa marcamos como REGALO */
    ASSIGN
        ITEM.Libre_d05 = 0.     /* Lo usamos para marcar la promoción seleccionada */
END.

/* Cargamos Saldo Actual */
DEF VAR pComprometido AS DEC NO-UNDO.
FOR EACH ITEM:
    FIND Almmmate WHERE Almmmate.codcia = ITEM.codcia AND
        Almmmate.codalm = ITEM.almdes AND
        Almmmate.codmat = ITEM.codmat AND
        Almmmate.stkact > 0 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        DELETE ITEM.
        NEXT.
    END.
    ASSIGN
        ITEM.Libre_d04 = Almmmate.StkAct.   /* Control del Stock Actual */
    RUN gn/stock-comprometido-v2 (INPUT ITEM.CodMat,
                                  INPUT ITEM.AlmDes,
                                  INPUT YES,
                                  OUTPUT pComprometido).
    ASSIGN
        ITEM.Libre_d04 = ITEM.Libre_d04 - pComprometido.
    /* Si no hay stock para cubrir las promociones => No va */
    IF ITEM.Libre_d04 < ITEM.CanPed THEN DO:
        DELETE ITEM.
        NEXT.
    END.
END.
FIND FIRST ITEM NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM THEN RETURN 'OK'.

/* Pantalla General para Seleccionar la Promoción a llevar */
DEF VAR pEstado AS CHAR NO-UNDO.
RUN vta2/d-promocion-420 (INPUT-OUTPUT TABLE ITEM,
                          OUTPUT pEstado).
IF pEstado = "ADM-ERROR" THEN RETURN "ADM-ERROR".
ELSE RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


