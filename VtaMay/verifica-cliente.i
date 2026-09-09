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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  DEFINE VAR f-TotDias AS INT NO-UNDO.
  DEFINE VAR OK AS LOGICAL NO-UNDO.
  DEFINE VAR X-CREUSA AS DECIMAL NO-UNDO.
  DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE F-MRGUTI     AS INTEGER   NO-UNDO.

  IF LOOKUP(FacCPedi.Flgest, 'G,X') > 0  THEN DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Deuda vencida */
    FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia
        AND  CcbCDocu.CodCli = FacCPedi.Codcli                         
        AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0
        AND  CcbCDocu.FlgEst = "P" 
        AND  CcbCDocu.FchVto <= TODAY
        NO-LOCK NO-ERROR. 
    IF AVAIL CcbCDocu 
    THEN ASSIGN
            FacCPedi.Flgest = 'X'
            FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Doc. Venc.'.

    /* Condicion Crediticia */
    OK = TRUE.
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.cndvta NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN F-totdias = gn-convt.totdias.
    
    FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt 
    THEN IF gn-convt.totdias > F-totdias AND F-totdias > 0 THEN OK = FALSE.
 
    IF NOT OK 
    THEN ASSIGN
          FacCPedi.Flgest = 'X'
          FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Cond.Cred.'.
 
    /* Ventas Contra Entrega*/
    OK = TRUE.
    IF LOOKUP(FacCPedi.fmaPgo,"001,002") > 0 THEN OK = FALSE.
 
    IF NOT OK 
    THEN ASSIGN
          FacCPedi.Flgest = 'X'
          FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Cond.Cred.Ctra.Entr.'.
 
    /* RHC 15.10.04 Transferencias Gratuitas */
    IF FacCPedi.FmaPgo = '900' THEN FacCPedi.FlgEst = 'X'.      /* NO Aprobado */
    /* ************************************* */
    
    IF FacCPEDI.Flgest = "G" THEN FacCPEDI.Flgest = "P".

    /* Aprobacion automatica en caso de pedidos contado-contraentrega */
    IF s-CodDiv = '00015'               /* Expolibreria */
        AND FacCPedi.FmaPgo = '001'      /* Contado contra-entrega */
    THEN FacCPedi.Flgest = 'P'.

    /* RHC 05.02.10 HORIZONTAL TODO POR APROBAR */
    IF Faccpedi.coddiv = '00014' AND Faccpedi.FchPed <= 03/15/2010 THEN Faccpedi.FlgEst = 'X'.
 
    FOR EACH FacDPedi OF FacCPedi:
        ASSIGN
           FacDPedi.Flgest = FacCPedi.Flgest.
        RELEASE FacDPedi.
    END.

    IF FacCPedi.FlgEst = 'P' THEN DO:
        /* Control de tracking por cada almacen */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK,
            FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = Facdpedi.almdes
            BREAK BY Almacen.coddiv:
            IF FIRST-OF(Almacen.coddiv) THEN DO:
                /* TRACKING */
                s-FechaI = DATETIME(TODAY, MTIME).
                s-FechaT = DATETIME(TODAY, MTIME).
            END.
        END.
    END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


