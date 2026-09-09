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

  DEF VAR f-Saldo   AS DEC NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat >= DesdeC
        AND Almmmatg.codmat <= HastaC NO-LOCK:
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(8)" WITH FRAME F-Proceso.
    /* Saldo Logistico */
    F-Saldo = 0.
    FOR EACH Almacen WHERE almacen.codcia = s-codcia
            AND almacen.flgrep = YES NO-LOCK:
        FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
            AND almstkal.codalm = almacen.codalm
            AND almstkal.codmat = almmmatg.codmat
            AND almstkal.fecha <= DFecha
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkal THEN F-Saldo = F-Saldo + almstkal.stkact.
    END.
    CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE
        ASSIGN
            DETALLE.StkLog = F-Saldo.

    /* Saldo Contable */
    FIND LAST Almstkge WHERE almstkge.codcia = s-codcia
        AND almstkge.codmat = almmmatg.codmat
        AND almstkge.fecha <= DFecha
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge
    THEN DO:
        FIND DETALLE WHERE detalle.codcia = s-codcia
            AND detalle.codmat = almmmatg.codmat
            NO-ERROR.
        IF NOT AVAILABLE DETALLE
        THEN DO:
            CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE.
        END.
        DETALLE.StkCbd = Almstkge.stkact.
    END.        
  END.
  HIDE FRAME F-Proceso.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


