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

IF OldFaccpedi.FlgSit <> Faccpedi.FlgSit AND LOOKUP(Faccpedi.CodDoc, 'O/D,OTR,O/M') > 0 
    THEN DO:
    DEF VAR LocalTracking AS CHAR NO-UNDO.
    /* Valores por defecto */
    CASE Faccpedi.FlgSit:
        WHEN "T " THEN LocalTracking = "SE_ALM".
        WHEN "TG" THEN LocalTracking = "HP_ALM".
        WHEN "TI" THEN LocalTracking = "PI_ALM".
        WHEN "PI" THEN LocalTracking = "PC_ALM".
        WHEN "P"  THEN LocalTracking = "PC_ALM".
        WHEN "PR" THEN LocalTracking = "IC_ALM".
        WHEN "PT" THEN LocalTracking = "AM_ALM".
        WHEN "PK" THEN LocalTracking = "EC_ALM".
        WHEN "PO" THEN LocalTracking = "CO_ALM".
        WHEN "POL" THEN LocalTracking = "RC_ALM".
        WHEN "PE" THEN LocalTracking = "EM_ALM".
        WHEN "PC" THEN LocalTracking = "CH_ALM".
        WHEN "C"  THEN LocalTracking = "ID_DIS".
        WHEN "PGRE"  THEN LocalTracking = "PGRE".
    END CASE.
    CASE Faccpedi.FlgSit:
        WHEN "TG" THEN DO:
            /* RHC 01/09/2020 Tracking de Pedido Comerical */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodRef,
                                    Faccpedi.NroRef,
                                    s-User-Id,
                                    'HP_ALM',
                                    'P',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    '',
                                    '').
        END.
        WHEN "PI" THEN DO:
            /* RHC 01/09/2020 Tracking de Pedido Comercial */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodRef,
                                    Faccpedi.NroRef,
                                    s-User-Id,
                                    'PK_COM',
                                    'P',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    '',
                                    '').
        END.
        WHEN "PC" THEN DO:
            /* RHC 01/09/2020 Tracking de Pedido Comercial */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodRef,
                                    Faccpedi.NroRef,
                                    s-User-Id,
                                    'VODB',
                                    'P',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    '',
                                    '').
        END.
    END CASE.
    /* Buscamos en la tabla de configuración */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND
        FacTabla.Tabla = 'CFG_FLGSIT_LOG' AND
        FacTabla.Codigo = Faccpedi.FlgSit
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-C[1] > '' THEN DO:
        LocalTracking = FacTabla.Campo-C[1].
    END.
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 LocalTracking,
                                 '',
                                 ?).
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
         HEIGHT             = 4.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


