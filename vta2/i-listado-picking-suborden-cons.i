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

    lOrdenCompra = "*".
    IF pOrdenCompra > '' THEN DO:
        lOrdenCompra = fOrdenCompra(INPUT Vtacdocu.NroRef, INPUT pOrdenCompra).
    END.
    lUserImpresion = Vtacdocu.usrImpOD.
    lUserImpresion = IF (lUserImpresion = ?) THEN '' ELSE TRIM(lUserImpresion).
    RUN ue-sectores(INPUT Vtacdocu.codped, 
                    INPUT Vtacdocu.nroped,
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
    BUFFER-COPY Vtacdocu 
        TO ORDENES
        ASSIGN
        ORDENES.CodDoc    = Vtacdocu.codped
        ORDENES.Libre_c01 = gn-divi.desdiv
        ORDENES.Libre_d01 = fPeso()
        ORDENES.Libre_c02 = ""
        ORDENES.Libre_d02 = fNroItm()
        ORDENES.UsrImpOD = ENTRY(1, Vtacdocu.Libre_c02, '|')
        ORDENES.FchImpOD = (IF NUM-ENTRIES(Vtacdocu.Libre_c02, '|') > 1 THEN DATETIME(ENTRY(2, Vtacdocu.Libre_c02, '|'))
            ELSE ?).
    CASE s-CodDoc:
        WHEN 'O/D' OR WHEN 'O/M' OR WHEN "ODC" THEN DO:
            ORDENES.Libre_c01 = gn-divi.desdiv.
            ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Cliente".
        END.
        WHEN 'OTR' OR WHEN "OTC" THEN DO:
            ORDENES.Libre_c01 = Vtacdocu.codcli.
            ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Solicitante".
        END.
    END CASE.

    
    RUN ue-sectores (INPUT Ordenes.coddoc, 
                     INPUT Ordenes.nroped,
                     OUTPUT lSectores, 
                     OUTPUT lSecImp, 
                     OUTPUT lSecAsig,
                     OUTPUT lSecDev).
    ASSIGN  
        Ordenes.acubon[1] = lSectores
        Ordenes.acubon[2] = lSecImp
        Ordenes.acubon[3] = lSecAsig
        Ordenes.acubon[4] = lSecDev
        Ordenes.acubon[5] = lSectores - lSecAsig.
    IF lSectores = lSecDev THEN ORDENES.Libre_c02 = "COMPLETADO".
    IF lSecImp > 0 AND lSecAsig = 0 THEN ORDENES.Libre_c02 = "SOLO IMPRESOS".
    IF lSecAsig > 0 AND lSecAsig = lSecDev AND lSecDev <> lSectores THEN ORDENES.Libre_c02 = "PARCIAL".

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


