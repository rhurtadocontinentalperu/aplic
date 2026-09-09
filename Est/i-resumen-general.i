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

FOR EACH dwh_ventas NO-LOCK WHERE dwh_ventas.codcia = s-codcia
    AND dwh_ventas.fecha >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99") + STRING(DAY(DesdeF), "99"))
    AND dwh_ventas.fecha <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99") + STRING(DAY(HastaF), "99"))
    AND ( x-CodMat = '' OR LOOKUP (dwh_ventas.codmat, x-CodMat) > 0 )
    AND ( x-CodCli = '' OR LOOKUP (dwh_ventas.codcli, x-CodCli) > 0 )
    AND dwh_ventas.coddiv BEGINS x-CodDiv
    AND dwh_ventas.codven BEGINS x-CodVen,
    FIRST dwh_tiempo WHERE dwh_tiempo.codcia = s-codcia
    AND dwh_tiempo.fecha = dwh_ventas.fecha NO-LOCK,
    FIRST Almmmatg OF dwh_ventas NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.CodPr1 BEGINS x-CodPro
    AND Almmmatg.subfam BEGINS x-SubFam:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA GENERAL ' + 
        ' FECHA ' + STRING (dwh_Tiempo.NroDia, '99') +
        ' ' + dwh_Tiempo.NombreMes + ' ' + STRING (dwh_Tiempo.Periodo, '9999') +
        ' DIVISION ' + dwh_ventas.coddiv + ' CLIENTE ' + dwh_ventas.codcli + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    x-Llave = ''.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroMes, '99').      /*dwh_Tiempo.NombreMes. */
        x-Llave = x-LLave + '|'.
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroDia, '99') + '/' +  
                            STRING(dwh_Tiempo.NroMes, '99') + '/' +
                            STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-LLave + '|'.
    END.
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas.coddiv + '|'.
         ELSE x-Llave = x-LLave + dwh_ventas.coddiv + '|'.
         FIND gn-divi WHERE gn-divi.codcia = s-codcia
             AND gn-divi.coddiv = dwh_ventas.coddiv
             NO-LOCK NO-ERROR.
         IF AVAILABLE gn-divi THEN x-Llave = x-Llave + gn-divi.CanalVenta + '|'.
         ELSE x-Llave = x-Llave + '|'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
             x-Canal   = ''
             x-Giro    = ''
             x-NroCard = ''
             x-Zona    = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''
             x-ClfCli  = ''.
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = dwh_ventas.codcli + '|'.
             ELSE x-Llave = x-Llave + dwh_ventas.codcli + '|'.
        END.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = dwh_ventas.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                x-Canal = gn-clie.canal
                x-Giro = gn-clie.gircli
                x-NroCard = gn-clie.nrocard
                x-CodDept = gn-clie.coddept
                x-CodProv = gn-clie.codprov
                x-CodDist = gn-clie.coddist
                x-ClfCli = gn-clie.clfcli.
            /* ZONA */
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN x-Zona = TabDepto.Zona.
            IF gn-clie.CodDept = '15' AND gn-clie.CodProv = '01' THEN x-Zona = 'LMC'.
        END.
        /* CANAL CLIENTE */
        FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
        ELSE x-Canal = x-Canal + ' - '.
        /* GIRO DEL NEGOCIO */
        FIND almtabla WHERE almtabla.Tabla = 'GN' AND almtabla.Codigo = x-Giro NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN x-Giro = x-Giro + ' - ' + TRIM(almtabla.Nombre).
        ELSE x-Giro = x-Giro + ' - '.
        /* Tarjeta Cliente Exclusivo */
        FIND gn-card WHERE gn-card.NroCard = x-NroCard NO-LOCK NO-ERROR.
        IF AVAILABLE gn-card THEN x-NroCard = x-NroCard + ' - ' + TRIM(gn-card.NomCard).
        ELSE x-NroCard = x-NroCard + ' - '.
        /* DEPARTAMENTO */
        FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
        /* PROVINCIA */
        FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
        /* DISTRITO */
        FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept AND Tabdistr.Codprovi = x-codprov
            AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
        /* ******* */
        IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
        ELSE x-CodDept = x-CodDept + ' - '.
        IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
        ELSE x-CodProv = x-CodProv + ' - '.
        IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
        ELSE x-CodDist = x-CodDist + ' - '.
        
        /* CANAL */
        IF x-Llave = '' THEN x-Llave = x-canal + '|'.
        ELSE x-Llave = x-Llave + x-canal + '|'.
        /*x-Llave = x-Llave + x-giro + '|'.*/
        x-Llave = x-Llave + x-nrocard + '|'.
        x-Llave = x-Llave + x-coddept + '|'.
        x-Llave = x-Llave + x-codprov + '|'.
        x-Llave = x-Llave + x-coddist + '|'.
        x-Llave = x-Llave + x-zona + '|'.
        x-Llave = x-Llave + x-clfcli + '|'.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = trim(dwh_ventas.codmat) + '|'.
             ELSE x-Llave = x-Llave + trim(dwh_ventas.codmat) + '|'.
             x-Llave = x-Llave + almmmatg.codfam + '|'.
             x-Llave = x-Llave + almmmatg.subfam + '|'.
             x-Llave = x-Llave + almmmatg.desmar + '|'.
             x-Llave = x-Llave + almmmatg.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.codfam + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.codfam + '|'.
                 x-Llave = x-Llave + almmmatg.subfam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = almmmatg.desmar + '|'.
                 ELSE x-Llave = x-Llave + almmmatg.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + almmmatg.licencia[1] + '|'.
         x-Llave = x-Llave + almmmatg.codpr1 + '|'.
     END.
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas.codven + '|'.
         ELSE x-Llave = x-Llave + dwh_ventas.codven + '|'.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes   = tmp-detalle.CanxMes   + dwh_Ventas.Cantidad
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + dwh_Ventas.ImpExtCIGV
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + dwh_Ventas.ImpNacCIGV
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + dwh_Ventas.CostoExtCIGV
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + dwh_Ventas.CostoNacCIGV
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + dwh_Ventas.PromExtCIGV
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + dwh_Ventas.PromNacCIGV.
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


