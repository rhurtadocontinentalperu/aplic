&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DDOCU NO-UNDO LIKE VtaDDocu.



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
      TABLE: T-DDOCU T "SHARED" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR x-CanSol AS DEC NO-UNDO.
DEF VAR x-StkCmp AS DEC NO-UNDO.
DEF VAR x-StkDis AS DEC NO-UNDO.
DEF VAR x-NroItm AS INT INIT 1 NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR f-Dsctos-1 AS DEC NO-UNDO.

/* SE VA A REPARTIR LA DESCARGA POR CADA ALMACEN DE DECARGA POR U.N.
Y EN EL ORDEN ESTABLECIDO */
DEF VAR s-FlgIgv AS LOG NO-UNDO.
DEF VAR s-PorIgv AS DEC NO-UNDO.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK.
ASSIGN
    s-FlgIgv = Vtacdocu.FlgIgv
    s-PorIgv = Vtacdocu.PorIgv.

FIND gn-divi OF Vtacdocu NO-LOCK.

FOR EACH T-DDOCU:
    DELETE T-DDOCU.
END.
FOR EACH Vtaddocu OF Vtacdocu NO-LOCK WHERE ( CanPed - CanAte ) > 0 BY Vtaddocu.NroItm:
    FIND FIRST Almmmatg OF Vtaddocu NO-LOCK.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Almmmatg.Chr__01 
        NO-LOCK NO-ERROR.
    x-CanSol = ( Vtaddocu.CanPed - Vtaddocu.CanAte ).                       /* UND venta */
    x-CanPed = ( Vtaddocu.CanPed - Vtaddocu.CanAte ) * Vtaddocu.Factor.     /* UND stock */
    FOR EACH VtaAlmDiv NO-LOCK WHERE VtaAlmDiv.CodCia = Vtacdocu.codcia
        AND VtaAlmDiv.CodDiv = Vtacdocu.coddiv
        BY VtaAlmDiv.Orden:
        FIND Almmmate WHERE Almmmate.codcia = Vtaddocu.codcia
            AND Almmmate.codalm = VtaAlmDiv.CodAlm 
            AND Almmmate.codmat = Vtaddocu.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        RUN vtagn/p-stock-comprometido (Almmmate.codmat,
                                       Almmmate.codalm,
                                       OUTPUT x-StkCmp).
        x-StkDis = Almmmate.StkAct - x-StkCmp.
        IF x-StkDis <= 0 THEN NEXT.
        /* AJUSTAMOS EL VALOR DEL STOCK DISPONIBLE */
        IF x-StkDis > x-CanPed THEN x-StkDis = x-CanPed.
        /* por multiplos de la unidad */
        IF Almtconv.Multiplos <> 0 THEN DO:
            x-StkDis = (TRUNCATE((x-StkDis / Almtconv.Multiplos),0) * Almtconv.Multiplos).
            IF x-StkDis <= 0 THEN NEXT.
        END.
        /* por paquetes de supermercados */
        FIND FIRST supmmatg WHERE supmmatg.codcia = Vtacdocu.CodCia
            AND supmmatg.codcli = Vtacdocu.CodCli
            AND supmmatg.codmat = Vtaddocu.codmat 
            NO-LOCK NO-ERROR.
        IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
            x-StkDis = (TRUNCATE((x-StkDis / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
            IF x-StkDis <= 0 THEN NEXT.
        END.
        x-StkDis = x-StkDis / Vtaddocu.Factor.      /* UND de venta */
        /* ************ FIN DEL STOCK DISPONIBLE ************* */
        CREATE T-DDOCU.
        BUFFER-COPY Vtaddocu 
            EXCEPT VtaDDocu.CanAte VtaDDocu.CanPick
            TO T-DDOCU
            ASSIGN
            T-DDOCU.NroItm = x-NroItm
            T-DDOCU.AlmDes = Almmmate.codalm
            T-DDOCU.CanPed = x-StkDis.
        x-CanSol = x-CanSol - T-DDOCU.CanPed.
        x-NroItm = x-NroItm + 1.
        /* CONTROL DE PRECIOS */
        IF GN-DIVI.FlgPreVta = NO THEN DO:          /* SE ACTUALIZA EL PRECIO UNITARIO */
            RUN vtagn/PrecioVenta (Vtacdocu.codcia,
                                   Vtacdocu.coddiv,
                                   Vtacdocu.codcli,
                                   Vtacdocu.codmon,
                                   Vtaddocu.factor,
                                   Vtaddocu.codmat,
                                   Vtacdocu.fmapgo,
                                   6,
                                   T-DDOCU.CanPed,
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT f-Dsctos-1).
            ASSIGN
                T-DDOCU.PreBas = f-PreBas
                T-DDOCU.PorDto = f-Dsctos
                T-DDOCU.PorDto1 = f-Dsctos-1
                T-DDOCU.PreUni = f-PreVta.
        END.
        {vtagn/i-vtaddocu-01.i}
        IF x-CanSol <= 0 THEN LEAVE.
    END.
END.

FIND FIRST T-DDOCU NO-ERROR.
IF NOT AVAILABLE T-DDOCU THEN DO:
    MESSAGE 'NO hay stock suficiente para atender este pedido'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


