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
         HEIGHT             = 3.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    DEF BUFFER B-TABGENER FOR TabGener.
    DEF VAR cClasificacion AS CHAR NO-UNDO.

    FIND FIRST factabla WHERE factabla.codcia = Almmmatg.codcia 
        AND factabla.tabla = 'RANKVTA' 
        AND factabla.codigo = almmmatg.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN DO:
        IF pTipo = "C" THEN cClasificacion = Factabla.campo-c[1].
        ELSE cClasificacion = Factabla.campo-c[4] .
    END.
    cClasificacion = TRIM(cClasificacion).

    RLOOP:
    FOR EACH Almmmate EXCLUSIVE-LOCK WHERE Almmmate.codcia = Almmmatg.codcia 
        AND Almmmate.codmat = Almmmatg.codmat,
        EACH TabGener NO-LOCK WHERE TabGener.codcia = Almmmate.codcia
        AND TabGener.clave = "ZG" 
        AND TabGener.libre_c01 = Almmmate.codalm,
        FIRST Almtabla NO-LOCK WHERE Almtabla.Tabla = TabGener.clave 
        AND Almtabla.Codigo = TabGener.Codigo:
        ASSIGN 
            Almmmate.StockMax = 0 
            Almmmate.StockSeg = 0.
        ASSIGN
            Almmmate.StockMax = (IF pTipo = "C" THEN Almmmate.VCtMn1 ELSE Almmmate.VCtMn2).
        ASSIGN
            Almmmate.Libre_f02 = ?.     /* <<<< OJO >>> */
        CREATE T-MATE.
        BUFFER-COPY Almmmate
            TO T-MATE
            ASSIGN 
            T-MATE.CodUbi    = TabGener.Codigo
            T-MATE.Libre_d01 = (IF TabGener.Libre_l01 = YES THEN 1 ELSE 0)
            T-MATE.Libre_d02 = (IF TabGener.Libre_l01 = YES THEN TabGener.Libre_d01 ELSE 50).
        /* RHC 25/05/2018 Buscamos en cascada */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
            AND VtaTabla.Tabla = "ZGL"
            AND VtaTabla.Llave_c1 = Almtabla.Codigo
            AND VtaTabla.Llave_c2 = Almmmatg.CodFam
            AND VtaTabla.LLave_c3 = Almmmatg.SubFam
            AND VtaTabla.Llave_c4 = cClasificacion
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN DO:
            IF TabGener.Libre_L01 = YES THEN DO:
                T-MATE.Libre_d02 = VtaTabla.Valor[1].
                NEXT RLOOP.
            END.
        END.
        FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
            AND VtaTabla.Tabla = "ZGL"
            AND VtaTabla.Llave_c1 = Almtabla.Codigo
            AND VtaTabla.Llave_c2 = Almmmatg.CodFam
            AND VtaTabla.LLave_c3 = Almmmatg.SubFam
            AND VtaTabla.Llave_c4 = 'Todas'
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN DO:
            IF TabGener.Libre_L01 = YES THEN DO:
                T-MATE.Libre_d02 = VtaTabla.Valor[1].
                NEXT RLOOP.
            END.
        END.
        FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
            AND VtaTabla.Tabla = "ZGL"
            AND VtaTabla.Llave_c1 = Almtabla.Codigo
            AND VtaTabla.Llave_c2 = Almmmatg.CodFam
            AND VtaTabla.Llave_c4 = cClasificacion
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN DO:
            IF TabGener.Libre_L01 = YES THEN DO:
                T-MATE.Libre_d02 = VtaTabla.Valor[1].
                NEXT RLOOP.
            END.
        END.
        FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
            AND VtaTabla.Tabla = "ZGL"
            AND VtaTabla.Llave_c1 = Almtabla.Codigo
            AND VtaTabla.Llave_c2 = Almmmatg.CodFam
            AND VtaTabla.Llave_c4 = 'Todas'
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN DO:
            IF TabGener.Libre_L01 = YES THEN DO:
                T-MATE.Libre_d02 = VtaTabla.Valor[1].
                NEXT RLOOP.
            END.
        END.
/*         FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.CodCia = s-CodCia                          */
/*             AND VtaTabla.Tabla = "ZGL"                                                      */
/*             AND VtaTabla.Llave_c1 = Almtabla.Codigo                                         */
/*             AND VtaTabla.Llave_c2 = Almmmatg.CodFam                                         */
/*             AND VtaTabla.LLave_c3 = Almmmatg.SubFam                                         */
/*             IF (VtaTabla.Llave_c5 = 'Todas' OR VtaTabla.Llave_c5 = cClasificacion) THEN DO: */
/*                 IF TabGener.Libre_L01 = YES THEN DO:                                        */
/*                     T-MATE.Libre_d02 = VtaTabla.Valor[1].                                   */
/*                     NEXT RLOOP.                                                             */
/*                 END.                                                                        */
/*             END.                                                                            */
/*         END.                                                                                */
/*         FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia        */
/*             AND VtaTabla.Tabla = "ZGL"                              */
/*             AND VtaTabla.Llave_c1 = Almtabla.Codigo                 */
/*             AND VtaTabla.Llave_c2 = Almmmatg.CodFam                 */
/*             NO-LOCK NO-ERROR.                                       */
/*         IF AVAILABLE VtaTabla AND TabGener.Libre_L01 = YES THEN DO: */
/*             T-MATE.Libre_d02 = VtaTabla.Valor[1].                   */
/*             NEXT RLOOP.                                             */
/*         END.                                                        */
    END.
    /* Stock de Seguridad */
    FOR EACH T-MATE WHERE T-MATE.Libre_d01 = 1:     /* PRINCIPAL */
        T-MATE.StockSeg = 0.
        FOR EACH BT-MATE WHERE BT-MATE.codubi = T-MATE.codubi:
            T-MATE.StockSeg = T-MATE.StockSeg + BT-MATE.StockMax.
        END.
        ASSIGN T-MATE.StockSeg = T-MATE.StockSeg * (T-MATE.Libre_d02 / 100).
        /* Entero superior */
        IF TRUNCATE(T-MATE.StockSeg,0) <> T-MATE.StockSeg THEN DO:
            ASSIGN T-MATE.StockSeg = TRUNCATE(T-MATE.StockSeg,0) + 1.
        END.
    END.
    /* Stock Maximo */
    FOR EACH T-MATE:
        ASSIGN T-MATE.StkMin = T-MATE.StockMax + T-MATE.StockSeg.
        /* RHC 19/06/17 Bloqueado a pedido de Max Ramos
        /* Aproximamos al empaque */
        IF T-MATE.StockSeg > 0 AND T-MATE.StkMax > 0 THEN DO:
            IF T-MATE.StkMin <= T-MATE.StkMax THEN T-MATE.StkMin = T-MATE.StkMax.
            IF T-MATE.StkMin > T-MATE.StkMax THEN DO:
                IF T-MATE.StkMin MODULO T-MATE.StkMax <> 0 
                    THEN T-MATE.StkMin = (TRUNCATE(T-MATE.StkMin / T-MATE.StkMax, 0) + 1) * T-MATE.StkMax.
            END.
        END.
        */
    END.
    /* Grabamos en la base de datos */
    FOR EACH T-MATE:
        {lib/lock-genericov2.i &Tabla="Almmmate" ~
            &Condicion="Almmmate.codcia = T-MATE.codcia ~
            AND Almmmate.codalm = T-MATE.codalm ~
            AND Almmmate.codmat = T-MATE.codmat" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="RETURN ERROR"}
            
        ASSIGN
            Almmmate.StockMax = T-MATE.StockMax
            Almmmate.StockSeg = T-MATE.StockSeg
            Almmmate.StkMin = T-MATE.StkMin.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


