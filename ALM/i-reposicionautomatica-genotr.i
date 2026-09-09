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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    DEF INPUT PARAMETER pTope AS INT.
    DEF VAR n-Items AS INT NO-UNDO.

    n-Items = 0.
    FOR EACH T-DREPO, FIRST Almmmatg OF T-DREPO NO-LOCK
        BREAK BY {&Orden}:
        IF {&Quiebre} THEN DO:
            s-TipMov = "A".
            IF T-DREPO.Origen = "MAN" THEN s-TipMov = "M".
            /* El almacen de despacho */
            FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
                  AND Almacen.codalm = T-DREPO.Almped NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almacen THEN DO:
                MESSAGE 'Almacen de despacho ' T-DREPO.Almped 'No existe' VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.
            lDivDespacho = Almacen.CodDiv.
            lAlmDespacho = T-DREPO.Almped.
            FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
                FacCorre.CodDiv = lDivDespacho AND
                FacCorre.CodDoc = S-CODDOC AND
                FacCorre.FlgEst = YES
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE FacCorre THEN DO:
                MESSAGE "Codigo de Documento " s-coddoc " No configurado para la division " lDivDespacho VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.
            FIND gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = lDivDespacho
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-divi THEN DO:
                MESSAGE 'División' lDivDespacho 'NO configurada' VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.
            ASSIGN
                s-DiasVtoPed = GN-DIVI.DiasVtoPed
                s-FlgEmpaque = GN-DIVI.FlgEmpaque
                s-VentaMayorista = GN-DIVI.VentaMayorista.

            FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
                AND Vtaalmdiv.coddiv = lDivDespacho
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaAlmDiv THEN DO:
                MESSAGE 'NO se han definido los almacenes de ventas para la división' lDivDespacho VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.

            DEFINE VAR lHora AS CHAR.
            DEFINE VAR lDias AS INT.
            DEFINE VAR lHoraTope AS CHAR.
            DEFINE VAR lFechaPedido AS DATE.
            
            /* La serie segun el almacen de donde se desea despachar(Almcrepo.almped) segun la R/A */
            s-NroSer = FacCorre.NroSer.

            FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                AND FacCorre.CodDoc = S-CODDOC 
                AND FacCorre.NroSer = s-NroSer
                NO-LOCK.
            IF FacCorre.FlgEst = NO THEN DO:
                MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
                RETURN 'ADM-ERROR'.
            END.
            FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

            DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
            DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

            /* Adiciono el Registro en la Cabecera */
            {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

            /* Controlar la hora de aprobacion para calcular la fecha del pedido*/
            lHora = STRING(TIME,"HH:MM:SS").
            lDias = 2.
            lHoraTope = '17'.   /* 5pm */
            lFechaPedido = TODAY.
            /* Si es SABADO o la hora es despues de la CINCO (17pm)*/
            IF WEEKDAY(TODAY) = 7  OR SUBSTRING(lHora,1,2) >= lHoraTope THEN DO:
                lDias = 1.
                /* Si es VIERNES despues de la 5pm */
                IF WEEKDAY(TODAY) = 6 THEN lDias = lDias + 1.
            END.
            lFechaPedido = lFechaPedido + lDias.
            /* RHC 27/02/17 Tomamos la fecha mayor.*/
            lFechaPedido = MAXIMUM(lFechaPedido,almcrepo.fecha).
            IF lFechaPedido <> Almcrepo.Fecha THEN pMensaje2 = "Se cambió la fecha de entrega a " + STRING(lFechaPedido).
            
            CREATE Faccpedi.

            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = s-CodAlm NO-LOCK NO-ERROR.
            ASSIGN 
                Faccpedi.CodCia = S-CODCIA
                Faccpedi.CodDoc = s-coddoc 
                Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                Faccpedi.CodRef = s-codref      /* R/A */
                Faccpedi.FchPed = TODAY
                Faccpedi.CodDiv = lDivDespacho
                Faccpedi.FlgEst = "P"       /* APROBADO */
                FacCPedi.TpoPed = s-TpoPed
                FacCPedi.FlgEnv = YES
                FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
                FacCPedi.Fchent = lFechaPedido
                Faccpedi.FchVen = lFechaPedido + 7
                Faccpedi.CodCli = Almacen.CodAlm
                Faccpedi.NomCli = Almacen.Descripcion
                Faccpedi.Dircli = Almacen.DirAlm
                /*FacCPedi.NroRef = STRING(almcrepo.nroser,"999") + STRING(almcrepo.nrodoc,"999999")*/
                FacCPedi.CodAlm = lAlmDespacho
                FacCPedi.Glosa = Fill-in-Glosa.
            /* Motivo */
            ASSIGN FacCPedi.MotReposicion = COMBO-BOX-Motivo.
            ASSIGN FacCPedi.VtaPuntual = TOGGLE-VtaPuntual.
            ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
            ASSIGN B-CREPO.Fecha = lFechaPedido.    /* OJO */
            /* TRACKING */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodPed,
                                    Faccpedi.NroPed,
                                    s-User-Id,
                                    'GOT',    /* Generación OTR */
                                    'P',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    Faccpedi.CodPed,
                                    Faccpedi.NroPed)
                NO-ERROR.
            /* Actualizamos la hora cuando lo vuelve a modificar */
            ASSIGN
                Faccpedi.Usuario = S-USER-ID
                Faccpedi.Hora   = STRING(TIME,"HH:MM").
            /* Division destino */
            FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.

            /* CONTROL DE OTROS PROCESOS POR DIVISION */
            FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
                AND gn-divi.coddiv = Faccpedi.divdes
                NO-LOCK.
            ASSIGN
                s-FlgPicking = GN-DIVI.FlgPicking
                s-FlgBarras  = GN-DIVI.FlgBarras.
            IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pre-Pickear */
            IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
            IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */


        END.
        CREATE Almdrepo.
        BUFFER-COPY T-DREPO TO Almdrepo
            ASSIGN
            almdrepo.ITEM   = n-Items + 1
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen.
        DELETE T-DREPO.
        n-Items = n-Items + 1.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


