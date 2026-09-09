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

    iSerieGuia = INTEGER(SUBSTRING(DI-RutaD.NroRef,1,3)).        /* G/R */
    iNroGuia = INTEGER(SUBSTRING(DI-RutaD.NroRef,4)).
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
        LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 AND
        CcbCDocu.CodPed = Faccpedi.CodRef AND   /* PED */
        CcbCDocu.NroPed = Faccpedi.NroRef AND
        CcbCDocu.Libre_c01 = Faccpedi.CodDoc AND    /* OTR */
        CcbCDocu.Libre_c02 = Faccpedi.NroPed AND
        Ccbcdocu.flgest <> 'A':
        FOR EACH gre_header NO-LOCK WHERE gre_header.m_coddoc = Ccbcdocu.coddoc AND
            gre_header.m_nroser = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,1,3)) AND
            gre_header.m_nrodoc = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,4)) AND
            gre_header.serieGuia = iSerieGuia AND gre_header.numeroGuia = iNroGuia:                    
            IF LOOKUP(gre_header.m_rspta_sunat, 'ANULADO,RECHAZADO POR SUNAT,BAJA EN SUNAT') = 0
                THEN DO:
                MESSAGE 'Se ha detectado que la GRE' SKIP
                    'Serie: ' gre_header.serieGuia 'Número:' gre_header.numeroGuia SKIP
                    'Referente a' Faccpedi.CodDoc Faccpedi.NroPed SKIP
                    'Se encuentra ' gre_header.m_rspta_sunat SKIP(1)
                    'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
                UNDO, RETURN 'ADM-ERROR'. 
            END.
        END.
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


