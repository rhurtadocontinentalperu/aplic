&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    /* GENERACION DE CUENTA AUTOMATICAS */        
    x-GenAut = 0.
    /* Verificamos si la Cuenta genera automaticas de Clase 9 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN
        cb-dmov.CtaAut = ""
        cb-dmov.CtrCta = "".
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            cb-dmov.CtaAut = cb-ctas.An1Cta.
            IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            cb-dmov.CtaAut = cb-ctas.An1Cta.
            IF cb-dmov.CtrCta = "" THEN
                cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
        END.
        WHEN 3 THEN DO:
            cb-dmov.CtaAut = cb-ctas.An1Cta.
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
        END.
    END CASE.
    /* Chequendo las cuentas a generar en forma autom tica */
    IF x-GenAut > 0 THEN DO:
        IF NOT CAN-FIND(FIRST cb-ctas WHERE
            cb-ctas.CodCia = cb-codcia AND
            cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
            MESSAGE
                "Cuentas Autom ticas a generar" SKIP
                "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                VIEW-AS ALERT-BOX ERROR.
            cb-dmov.CtaAut = "".
        END.
        IF NOT CAN-FIND( cb-ctas WHERE
            cb-ctas.CodCia = cb-codcia AND
            cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
            MESSAGE
                "Cuentas Autom ticas a generar" SKIP
                "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                VIEW-AS ALERT-BOX ERROR.
            cb-dmov.CtrCta = "".
        END.
    END. /*Fin del x-genaut > 0 */
    
    IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
        J = J + 1.
        CREATE DETALLE.
        BUFFER-COPY CB-DMOV TO DETALLE
            ASSIGN DETALLE.TpoItm = 'A'
                    DETALLE.Relacion = RECID(CB-DMOV)
                    DETALLE.CodCta = CB-DMOV.CtaAut
                    DETALLE.CodAux = CB-DMOV.CodCta.
        RUN cbd/cb-acmd (RECID(DETALLE), YES ,YES).
        IF detalle.tpomov THEN DO:
            h-uno = h-uno + detalle.impmn1.
            h-dos = h-dos + detalle.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.
        J = J + 1.
        CREATE detalle.
        BUFFER-COPY CB-DMOV TO DETALLE
            ASSIGN DETALLE.TpoItm = 'A'
                    DETALLE.Relacion = RECID(CB-DMOV)
                    DETALLE.CodCta = CB-DMOV.CtrCta
                    DETALLE.CodAux = CB-DMOV.CodCta
                    DETALLE.TpoMov = NOT CB-DMOV.TpoMov.
        RUN cbd/cb-acmd (RECID(DETALLE), YES ,YES).
        IF detalle.tpomov THEN DO:
            h-uno = h-uno + detalle.impmn1.
            h-dos = h-dos + detalle.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


