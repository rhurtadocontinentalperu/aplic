&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ActualizaMateControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActualizaMateControl Procedure 
PROCEDURE ActualizaMateControl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF PARAMETER BUFFER b-LogControl FOR AlmLogControl.

    DEF VAR pMensaje AS CHAR NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.

    pMensaje = "".
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FIND AlmMateControl WHERE AlmMateControl.CodCia = b-LogControl.CodCia 
            AND AlmMateControl.CodMat = b-LogControl.CodMat 
            AND AlmMateControl.CodAlm = b-LogControl.CodAlm 
            AND AlmMateControl.CodUbic = b-LogControl.CodUbic 
            AND AlmMateControl.Lote = b-LogControl.Lote
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmMateControl THEN DO:
            CREATE AlmMateControl.
            ASSIGN
                AlmMateControl.CodCia = b-LogControl.CodCia 
                AlmMateControl.CodMat = b-LogControl.CodMat 
                AlmMateControl.CodAlm = b-LogControl.CodAlm 
                AlmMateControl.CodUbic = b-LogControl.CodUbic 
                AlmMateControl.Lote = b-LogControl.Lote.
        END.
        CASE b-LogControl.TipMov:
            WHEN "I" THEN ASSIGN
                AlmMateControl.Stock  = AlmMateControl.Stock + (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateControl.Volumen = AlmMateControl.Volumen + b-LogControl.Volumen.
            WHEN "S" THEN ASSIGN
                AlmMateControl.Stock  = AlmMateControl.Stock - (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateControl.Volumen = AlmMateControl.Volumen - b-LogControl.Volumen.
        END CASE.
        CATCH eBlockError AS PROGRESS.Lang.SysError:
            IF eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
                MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            END.
            DELETE OBJECT eBlockError.
            UNDO, RETURN ERROR.
        END CATCH.
    END.
    IF AVAILABLE(AlmMateControl) THEN RELEASE AlmMateControl.

    /*
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodUbic AS CHAR.
DEF INPUT PARAMETER pLote AS CHAR.
DEF INPUT PARAMETER pCanDes AS DEC.
DEF INPUT PARAMETER pFactor AS DEC.
DEF INPUT PARAMETER pVolumen AS DEC.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR ix AS INT NO-UNDO.

pMensaje = "".
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND AlmMateControl WHERE AlmMateControl.CodCia = pCodCia 
        AND AlmMateControl.CodMat = pCodMat 
        AND AlmMateControl.CodAlm = pCodAlm 
        AND AlmMateControl.CodUbic = pCodUbic 
        AND AlmMateControl.Lote = pLote
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmMateControl THEN DO:
        CREATE AlmMateControl.
        ASSIGN
            AlmMateControl.CodCia = pCodCia 
            AlmMateControl.CodMat = pCodMat 
            AlmMateControl.CodAlm = pCodAlm 
            AlmMateControl.CodUbic = pCodUbic 
            AlmMateControl.Lote = pLote.
    END.
    CASE AlmLogControl.TipMov:
        WHEN "I" THEN ASSIGN
            AlmMateControl.Stock  = AlmMateControl.Stock + (pCanDes * pFactor)
            AlmMateControl.Volumen = AlmMateControl.Volumen + pVolumen.
        WHEN "S" THEN ASSIGN
            AlmMateControl.Stock  = AlmMateControl.Stock - (pCanDes * pFactor)
            AlmMateControl.Volumen = AlmMateControl.Volumen - pVolumen.
    END CASE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        DELETE OBJECT eBlockError.
        UNDO, RETURN ERROR.
    END CATCH.
END.
IF AVAILABLE(AlmMateControl) THEN RELEASE AlmMateControl.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ActualizaMateLote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActualizaMateLote Procedure 
PROCEDURE ActualizaMateLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR ix AS INT NO-UNDO.

FIND AlmLogControl WHERE ROWID(AlmLogControl) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmLogControl THEN RETURN 'ADM-ERROR'.

pMensaje = "".
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND AlmMateLote WHERE AlmMateLote.CodCia = AlmLogControl.CodCia 
        AND AlmMateLote.CodMat = AlmLogControl.CodMat 
        AND AlmMateLote.CodAlm = AlmLogControl.CodAlm 
        AND AlmMateLote.Lote = AlmLogControl.Lote 
        
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmMateLote THEN DO:
        CREATE AlmMateLote.
        ASSIGN
            AlmMateLote.CodCia = AlmLogControl.CodCia 
            AlmMateLote.CodMat = AlmLogControl.CodMat 
            AlmMateLote.CodAlm = AlmLogControl.CodAlm 
            AlmMateLote.Lote = AlmLogControl.Lote.
    END.
    CASE AlmLogControl.TipMov:
        WHEN "I" THEN ASSIGN
            AlmMateLote.Stock  = AlmMateLote.Stock + (AlmLogControl.CanDes * AlmLogControl.Factor)
            AlmMateLote.Volumen = AlmMateLote.Volumen + AlmLogControl.Volumen.
        WHEN "S" THEN ASSIGN
            AlmMateLote.Stock  = AlmMateLote.Stock - (AlmLogControl.CanDes * AlmLogControl.Factor)
            AlmMateLote.Volumen = AlmMateLote.Volumen - AlmLogControl.Volumen.
    END CASE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        DELETE OBJECT eBlockError.
        UNDO, RETURN ERROR.
    END CATCH.
END.
IF AVAILABLE(AlmMateLote) THEN RELEASE AlmMateLote.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ActualizaMateUbic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActualizaMateUbic Procedure 
PROCEDURE ActualizaMateUbic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF PARAMETER BUFFER b-LogControl FOR AlmLogControl.

    DEF VAR pMensaje AS CHAR NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.

    pMensaje = "".
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FIND AlmMateUbic WHERE AlmMateUbic.CodCia = b-LogControl.CodCia 
            AND AlmMateUbic.CodMat = b-LogControl.CodMat 
            AND AlmMateUbic.CodAlm = b-LogControl.CodAlm 
            AND AlmMateUbic.CodUbic = b-LogControl.CodUbic 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmMateUbic THEN DO:
            CREATE AlmMateUbic.
            ASSIGN
                AlmMateUbic.CodCia = b-LogControl.CodCia 
                AlmMateUbic.CodMat = b-LogControl.CodMat 
                AlmMateUbic.CodAlm = b-LogControl.CodAlm 
                AlmMateUbic.CodUbic = b-LogControl.CodUbic.
        END.
        CASE b-LogControl.TipMov:
            WHEN "I" THEN ASSIGN
                AlmMateUbic.Stock  = AlmMateUbic.Stock + (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateUbic.Volumen = AlmMateUbic.Volumen + b-LogControl.Volumen.
            WHEN "S" THEN ASSIGN
                AlmMateUbic.Stock  = AlmMateUbic.Stock - (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateUbic.Volumen = AlmMateUbic.Volumen - b-LogControl.Volumen.
        END CASE.
        CATCH eBlockError AS PROGRESS.Lang.SysError:
            IF eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
                MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            END.
            DELETE OBJECT eBlockError.
            UNDO, RETURN ERROR.
        END CATCH.
    END.
    IF AVAILABLE(AlmMateUbic) THEN RELEASE AlmMateUbic.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ActualizaMMate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActualizaMMate Procedure 
PROCEDURE ActualizaMMate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR ix AS INT NO-UNDO.

FIND AlmLogControl WHERE ROWID(AlmLogControl) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmLogControl THEN RETURN ERROR.

pMensaje = "".
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND AlmMMate WHERE AlmMMate.CodCia = AlmLogControl.CodCia 
        AND AlmMMate.CodMat = AlmLogControl.CodMat 
        AND AlmMMate.CodAlm = AlmLogControl.CodAlm 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmMMate THEN DO:
        CREATE AlmMMate.
        ASSIGN
            AlmMMate.CodCia = AlmLogControl.CodCia 
            AlmMMate.CodMat = AlmLogControl.CodMat 
            AlmMMate.CodAlm = AlmLogControl.CodAlm.
    END.
    CASE AlmLogControl.TipMov:
        WHEN "I" THEN ASSIGN
            AlmMMate.StkAct  = AlmMMate.StkAct + (AlmLogControl.CanDes * AlmLogControl.Factor).
        WHEN "S" THEN ASSIGN
            AlmMMate.StkAct  = AlmMMate.StkAct - (AlmLogControl.CanDes * AlmLogControl.Factor).
    END CASE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        DELETE OBJECT eBlockError.
        UNDO, RETURN ERROR.
    END CATCH.
END.
IF AVAILABLE(AlmMMate) THEN RELEASE AlmMMate.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExtornaMateControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExtornaMateControl Procedure 
PROCEDURE ExtornaMateControl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF PARAMETER BUFFER b-LogControl FOR AlmLogControl.

    DEF VAR pMensaje AS CHAR NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FIND AlmMateControl WHERE AlmMateControl.CodCia = b-LogControl.CodCia 
            AND AlmMateControl.CodMat = b-LogControl.CodMat 
            AND AlmMateControl.CodAlm = b-LogControl.CodAlm 
            AND AlmMateControl.CodUbic = b-LogControl.CodUbic 
            AND AlmMateControl.Lote = b-LogControl.Lote
            EXCLUSIVE-LOCK.
        CASE b-LogControl.TipMov:
            WHEN "I" THEN ASSIGN
                AlmMateControl.Stock   = AlmMateControl.Stock   - (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateControl.Volumen = AlmMateControl.Volumen - b-LogControl.Volumen.
            WHEN "S" THEN ASSIGN
                AlmMateControl.Stock   = AlmMateControl.Stock   + (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateControl.Volumen = AlmMateControl.Volumen + b-LogControl.Volumen.
        END CASE.
        IF AlmMateControl.Stock = 0 THEN DELETE AlmMateControl.
        CATCH eBlockError AS PROGRESS.Lang.SysError:
            IF eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
                MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            END.
            DELETE OBJECT eBlockError.
            UNDO, RETURN ERROR.
        END CATCH.
    END.
    IF AVAILABLE(AlmMateControl) THEN RELEASE AlmMateControl.

/*
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodUbic AS CHAR.
DEF INPUT PARAMETER pLote AS CHAR.
DEF INPUT PARAMETER pCanDes AS DEC.
DEF INPUT PARAMETER pFactor AS DEC.
DEF INPUT PARAMETER pVolumen AS DEC.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR ix AS INT NO-UNDO.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND AlmMateControl WHERE AlmMateControl.CodCia = pCodCia 
        AND AlmMateControl.CodMat = pCodMat 
        AND AlmMateControl.CodAlm = pCodAlm 
        AND AlmMateControl.CodUbic = pCodUbic 
        AND AlmMateControl.Lote = pLote
        EXCLUSIVE-LOCK.
    CASE AlmLogControl.TipMov:
        WHEN "I" THEN ASSIGN
            AlmMateControl.Stock   = AlmMateControl.Stock   - (pCanDes * pFactor)
            AlmMateControl.Volumen = AlmMateControl.Volumen - pVolumen.
        WHEN "S" THEN ASSIGN
            AlmMateControl.Stock   = AlmMateControl.Stock   + (pCanDes * pFactor)
            AlmMateControl.Volumen = AlmMateControl.Volumen + pVolumen.
    END CASE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        DELETE OBJECT eBlockError.
        UNDO, RETURN ERROR.
    END CATCH.
END.
IF AVAILABLE(AlmMateControl) THEN RELEASE AlmMateControl.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExtornaMateLote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExtornaMateLote Procedure 
PROCEDURE ExtornaMateLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR ix AS INT NO-UNDO.

FIND AlmLogControl WHERE ROWID(AlmLogControl) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmLogControl THEN RETURN 'ADM-ERROR'.

pMensaje = "".
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND AlmMateLote WHERE AlmMateLote.CodCia = AlmLogControl.CodCia 
        AND AlmMateLote.CodMat = AlmLogControl.CodMat 
        AND AlmMateLote.CodAlm = AlmLogControl.CodAlm 
        AND AlmMateLote.Lote = AlmLogControl.Lote 
        
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmMateLote THEN DO:
        CREATE AlmMateLote.
        ASSIGN
            AlmMateLote.CodCia = AlmLogControl.CodCia 
            AlmMateLote.CodMat = AlmLogControl.CodMat 
            AlmMateLote.CodAlm = AlmLogControl.CodAlm 
            AlmMateLote.Lote = AlmLogControl.Lote.
    END.
    CASE AlmLogControl.TipMov:
        WHEN "I" THEN ASSIGN
            AlmMateLote.Stock  = AlmMateLote.Stock - (AlmLogControl.CanDes * AlmLogControl.Factor)
            AlmMateLote.Volumen = AlmMateLote.Volumen - AlmLogControl.Volumen.
        WHEN "S" THEN ASSIGN
            AlmMateLote.Stock  = AlmMateLote.Stock + (AlmLogControl.CanDes * AlmLogControl.Factor)
            AlmMateLote.Volumen = AlmMateLote.Volumen + AlmLogControl.Volumen.
    END CASE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        DELETE OBJECT eBlockError.
        UNDO, RETURN ERROR.
    END CATCH.
END.
IF AVAILABLE(AlmMateLote) THEN RELEASE AlmMateLote.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExtornaMateUbic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExtornaMateUbic Procedure 
PROCEDURE ExtornaMateUbic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF PARAMETER BUFFER b-LogControl FOR AlmLogControl.

    DEF VAR pMensaje AS CHAR NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FIND AlmMateUbic WHERE AlmMateUbic.CodCia = b-LogControl.CodCia 
            AND AlmMateUbic.CodMat = b-LogControl.CodMat 
            AND AlmMateUbic.CodAlm = b-LogControl.CodAlm 
            AND AlmMateUbic.CodUbic = b-LogControl.CodUbic 
            EXCLUSIVE-LOCK.
        CASE b-LogControl.TipMov:
            WHEN "I" THEN ASSIGN
                AlmMateUbic.Stock   = AlmMateUbic.Stock   - (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateUbic.Volumen = AlmMateUbic.Volumen - b-LogControl.Volumen.
            WHEN "S" THEN ASSIGN
                AlmMateUbic.Stock   = AlmMateUbic.Stock   + (b-LogControl.CanDes * b-LogControl.Factor)
                AlmMateUbic.Volumen = AlmMateUbic.Volumen + b-LogControl.Volumen.
        END CASE.
        IF AlmMateUbic.Stock = 0 THEN DELETE AlmMateUbic.
        CATCH eBlockError AS PROGRESS.Lang.SysError:
            IF eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
                MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            END.
            DELETE OBJECT eBlockError.
            UNDO, RETURN ERROR.
        END CATCH.
    END.
    IF AVAILABLE(AlmMateUbic) THEN RELEASE AlmMateUbic.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExtornaMMate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExtornaMMate Procedure 
PROCEDURE ExtornaMMate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR ix AS INT NO-UNDO.

FIND AlmLogControl WHERE ROWID(AlmLogControl) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmLogControl THEN RETURN ERROR.

pMensaje = "".
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND AlmMMate WHERE AlmMMate.CodCia = AlmLogControl.CodCia 
        AND AlmMMate.CodMat = AlmLogControl.CodMat 
        AND AlmMMate.CodAlm = AlmLogControl.CodAlm 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmMMate THEN DO:
        CREATE AlmMMate.
        ASSIGN
            AlmMMate.CodCia = AlmLogControl.CodCia 
            AlmMMate.CodMat = AlmLogControl.CodMat 
            AlmMMate.CodAlm = AlmLogControl.CodAlm.
    END.
    CASE AlmLogControl.TipMov:
        WHEN "I" THEN ASSIGN
            AlmMMate.StkAct  = AlmMMate.StkAct - (AlmLogControl.CanDes * AlmLogControl.Factor).
        WHEN "S" THEN ASSIGN
            AlmMMate.StkAct  = AlmMMate.StkAct + (AlmLogControl.CanDes * AlmLogControl.Factor).
    END CASE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF eBlockError:NumMessages > 0 THEN DO:
            pMensaje = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
            END.
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        DELETE OBJECT eBlockError.
        UNDO, RETURN ERROR.
    END CATCH.
END.
IF AVAILABLE(AlmMMate) THEN RELEASE AlmMMate.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

