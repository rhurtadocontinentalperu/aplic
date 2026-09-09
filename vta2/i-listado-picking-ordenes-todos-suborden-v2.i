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
        IF NOT (Faccpedi.fchped <= x-hasta) THEN NEXT.
        IF Faccpedi.flgest = "A" THEN NEXT.
        IF s-nro-orden > "" AND Faccpedi.nroped <> s-nro-orden THEN NEXT.
        IF NOT (faccpedi.fchent >= ltxtDesde AND faccpedi.fchent <= ltxtHasta) THEN NEXT.

        /* x Pickear */
        IF x-pickeado = 1 THEN DO:
            /* Esta Pickeado NO VA*/            
            IF NOT (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T') THEN NEXT.
        END.

       /* Pickeados */
        IF x-pickeado = 2 THEN DO:
            IF faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T' THEN NEXT.
        END.

        DISPLAY Faccpedi.coddoc + " " + Faccpedi.nroped + " " + STRING(Faccpedi.fchped) @
            Fi-Mensaje WITH FRAME F-Proceso.

        lOrdenCompra = "*".
        IF pOrdenCompra > '' THEN DO:
            lOrdenCompra = fOrdenCompra(INPUT FacCPedi.NroRef, INPUT pOrdenCompra).
        END.
    
        lUserImpresion = Faccpedi.usrImpOD.
        lUserImpresion = IF (lUserImpresion = ?) THEN '' ELSE TRIM(lUserImpresion).
    
        RUN ue-sectores(INPUT faccpedi.coddoc, 
                        INPUT faccpedi.nroped,
                        OUTPUT lSectores, 
                        OUTPUT lSecImp, 
                        OUTPUT lSecAsig,
                        OUTPUT lSecDev).
    
        /* x Asignar */
        IF i-tipo-busqueda = 2 AND (lSectores = lSecAsig ) THEN NEXT.

        /* x Recepcionar */
        IF i-tipo-busqueda = 3 AND (lSecAsig = 0 OR lSecAsig = lSecDev  ) THEN NEXT.

        /* Todos Asignados */
        IF i-tipo-busqueda = 4 AND (lSectores <> lSecAsig ) THEN NEXT.

    
        CREATE ORDENES.
        BUFFER-COPY Faccpedi TO ORDENES.
        ASSIGN
            ORDENES.Libre_c01 = gn-divi.desdiv
            ORDENES.Libre_c02 = "".
        ASSIGN 
            ORDENES.UsrImpOD = ENTRY(1, Faccpedi.Libre_c02, '|')
            ORDENES.FchImpOD = (IF NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1 THEN DATETIME(ENTRY(2, Faccpedi.Libre_c02, '|'))
                ELSE ?).

        CASE s-CodDoc:
            WHEN 'O/D' OR WHEN 'O/M' OR WHEN "ODC" THEN DO:
                ORDENES.Libre_c01 = gn-divi.desdiv.
            END.
            WHEN 'OTR' THEN DO:
                ORDENES.Libre_c01 = Faccpedi.codcli.
            END.
        END CASE.
        ASSIGN  
            Ordenes.acubon[1] = lSectores
            Ordenes.acubon[2] = lSecImp
            Ordenes.acubon[3] = lSecAsig
            Ordenes.acubon[4] = lSecDev
            Ordenes.acubon[5] = lSectores - lSecAsig.
    
        IF lSectores = lSecDev THEN ORDENES.Libre_c02 = "COMPLETADO".
        IF lSecImp > 0 AND lSecAsig = 0 THEN ORDENES.Libre_c02 = "SOLO IMPRESOS".
        IF lSecAsig > 0 AND lSecAsig = lSecDev AND lSecDev <> lSectores THEN ORDENES.Libre_c02 = "PARCIAL".
    
        /* Cesar Camus */
        RUN gn/fUbigeo (ordenes.CodDiv, 
                        ordenes.CodDoc,
                        ordenes.NroPed,
                        OUTPUT pCodDpto,
                        OUTPUT pCodProv,
                        OUTPUT pCodDist,
                        OUTPUT pCodPos,
                        OUTPUT pZona,
                        OUTPUT pSubZona
                        ).

        /* Ic - 20Set2018, correo de juan almonte 19Set2018 - Agregar Columna en "Impresión de Picking" */
        FIND FIRST TabDistr WHERE TabDistr.CodDepto = pCodDpto 
            AND TabDistr.CodProvi = pCodProv 
            AND TabDistr.CodDistr = pCodDist
            NO-LOCK NO-ERROR.
        ASSIGN  Ordenes.cdistrito = "".
        IF AVAILABLE TabDistr THEN DO:
            ASSIGN  Ordenes.cdistrito = tabdistr.nomdistr.
        END.
        /* Zona */
        FIND FIRST vtaCtabla WHERE vtaCtabla.codcia = s-codcia AND
                        vtaCtabla.tabla = 'ZGHR' AND 
                        vtaCtabla.llave = pZona NO-LOCK NO-ERROR.    
        /* SubZona */
        FIND FIRST vtaDtabla WHERE vtaDtabla.codcia = s-codcia AND
                        vtaDtabla.tabla = 'SZGHR' AND 
                        vtaDtabla.llave = pZona AND 
                        vtaDtabla.tipo = pSubZona NO-LOCK NO-ERROR.
        ASSIGN 
            ordenes.xZona = pZona
            ordenes.xSubZona = pSubZona
            ordenes.cZona = IF (AVAILABLE vtaCtabla) THEN vtaCtabla.descripcion ELSE "< No existte >"
            ordenes.cSubZona = IF (AVAILABLE vtaDtabla) THEN vtaDtabla.libre_c02 ELSE "< No existe >".
    
        RUN carga-combos IN lh_Handle (INPUT "CANAL", INPUT ordenes.coddiv, INPUT gn-divi.desdiv).
        RUN carga-combos IN lh_Handle (INPUT "ZONA", INPUT pZona, INPUT ordenes.cSubZona).

        RELEASE ORDENES.

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


