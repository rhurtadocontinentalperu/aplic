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

            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera de Guía */
                RUN proc_CreaCabecera.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                ASSIGN
                    iCountGuide = iCountGuide + 1
                    lCreaHeader = FALSE.
            END.
            /* Crea Detalle */
            CREATE CcbDDocu.
            BUFFER-COPY PEDI TO CcbDDocu
            ASSIGN
                CcbDDocu.NroItm = iCountItem
                CcbDDocu.CodCia = CcbCDocu.CodCia
                CcbDDocu.CodDiv = CcbcDocu.CodDiv
                CcbDDocu.Coddoc = CcbCDocu.Coddoc
                CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                CcbDDocu.FchDoc = CcbCDocu.FchDoc
                CcbDDocu.CanDes = PEDI.CanAte
                Ccbddocu.impdcto_adelanto[4] = PEDI.Libre_d02.  /* Flete Unitario */
            ASSIGN
                CcbDDocu.Pesmat = Almmmatg.Pesmat * (CcbDDocu.Candes * CcbDDocu.Factor).
            /* CORREGIMOS IMPORTES */
            ASSIGN
                Ccbddocu.ImpLin = ROUND ( Ccbddocu.CanDes * Ccbddocu.PreUni * 
                                          ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                          ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                          ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ), 2 ).
            IF Ccbddocu.Por_Dsctos[1] = 0 AND Ccbddocu.Por_Dsctos[2] = 0 AND Ccbddocu.Por_Dsctos[3] = 0 
                THEN Ccbddocu.ImpDto = 0.
            ELSE Ccbddocu.ImpDto = Ccbddocu.CanDes * Ccbddocu.PreUni - Ccbddocu.ImpLin.
            ASSIGN
                Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
                Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
            IF Ccbddocu.AftIsc 
                THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
            ELSE Ccbddocu.ImpIsc = 0.
            IF Ccbddocu.AftIgv 
                THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (FacCPedi.PorIgv / 100) ), 4 ).
            ELSE Ccbddocu.ImpIgv = 0.
            /* Actualiza Detalle de la Orden de Despacho */
/*             ASSIGN                                                   */
/*                 FacDPedi.CanAte = FacDPedi.CanAte + CcbDDocu.CanDes. */
            FOR EACH ITEM WHERE ITEM.codmat = PEDI.codmat:
                FIND FIRST Facdpedi WHERE Facdpedi.codcia = ITEM.codcia
                    AND Facdpedi.coddiv = ITEM.coddiv
                    AND Facdpedi.coddoc = ITEM.coddoc
                    AND Facdpedi.nroped = ITEM.nroped
                    AND Facdpedi.codmat = ITEM.codmat
                    AND Facdpedi.libre_c05 = ITEM.libre_c05    /* Campo de control adicional */
                    EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF NOT AVAILABLE Facdpedi THEN DO:
                    MESSAGE 'NO se pudo bloquear el código' ITEM.codmat 'de la O/D'
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO TRLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    Facdpedi.canate = Facdpedi.canate + ITEM.canate.
            END.
            lItemOk = TRUE.
            iCountItem = iCountItem + 1.
            IF iCountItem > FILL-IN-items OR LAST-OF(PEDI.CodCia) /*OR LAST-OF(PEDI.Libre_c05)*/ THEN DO:
                RUN proc_GrabaTotales.
                /* APLICACION DE ADELANTOS */
                RUN Aplicacion-de-Adelantos.
                /* EN CASO DE CERRAR LAS FACTURAS APLICAMOS EL REDONDEO */
                IF LAST-OF(PEDI.CodCia) AND Faccpedi.Importe[2] <> 0 THEN DO:
                    /* NOS ASEGURAMOS QUE SEA EL ULTIMO REGISTRO */
                    IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
                                    NO-LOCK) THEN DO:
                        ASSIGN 
                            Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Faccpedi.Importe[2]
                            CcbCDocu.Libre_d02 = Faccpedi.Importe[2]
                            Ccbcdocu.ImpVta = ROUND ( (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5])/ ( 1 + Ccbcdocu.PorIgv / 100 ) , 2)
                            Ccbcdocu.ImpIgv = (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]) - Ccbcdocu.ImpVta
                            Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta + Ccbcdocu.ImpDto + Ccbcdocu.ImpExo
                            Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
                    END.
                END.
                /* FIN DE REDONDEO */

                /* Inicio - Ic - 07Mar2014 
                    Para la division 00506 = Lista Express, los comprobantes deben
                    generarse como Cancelados.
                */
/*                 IF Ccbcdocu.divori = '00506' THEN DO: */
/*                     ASSIGN Ccbcdocu.flgest = 'C'      */
/*                         Ccbcdocu.SdoAct = 0.          */
/*                 END.                                  */
                /* Termino - Ic - 07Mar2014 */

                /* GENERACION DE CONTROL DE PERCEPCIONES */
                RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
                /* ************************************* */
                /* RHC 12.07.2012 limpiamos campos para G/R */
                ASSIGN
                    Ccbcdocu.codref = ""
                    Ccbcdocu.nroref = "".
                /* RHC 30-11-2006 Transferencia Gratuita */
                IF LOOKUP(Ccbcdocu.FmaPgo, '899,900') > 0 THEN Ccbcdocu.sdoact = 0.
                IF Ccbcdocu.sdoact <= 0 
                THEN ASSIGN
                        Ccbcdocu.fchcan = TODAY
                        Ccbcdocu.flgest = 'C'.
                /* Descarga de Almacen */
                RUN vta2\act_alm (ROWID(CcbCDocu)).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                /* RHC 25-06-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */           
                /*RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES). */
                /* RHC 12-07-2012 CONTROL DE IMPRESIONES PARA CAJA */
                /* solo va a sevir para el mismo día */
/*                 CREATE w-report.                                 */
/*                 ASSIGN                                           */
/*                     w-report.Llave-I = Ccbcdocu.codcia           */
/*                     w-report.Campo-C[1] = Ccbcdocu.coddoc        */
/*                     w-report.Campo-C[2] = Ccbcdocu.nrodoc        */
/*                     w-report.Llave-C = "IMPCAJA"                 */
/*                     w-report.Llave-D = Ccbcdocu.fchdoc           */
/*                     w-report.Task-No = INTEGER(Ccbcdocu.coddiv). */
            END.
            /* RHC 11/11/2013 QUEBRAMOS POR ZONA */
            IF iCountItem > FILL-IN-items /*OR LAST-OF(PEDI.Libre_c05)*/ THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
                lItemOk = FALSE.
            END.

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
         HEIGHT             = 3.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


