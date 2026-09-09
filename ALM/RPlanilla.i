&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : 
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
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "MethodLibraryCues" Method-Library _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* Method Library,uib,70080
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

            FOR EACH Pl-Bole NO-LOCK WHERE
            Pl-Bole.Codpln = pl-cal.codpln
            AND Pl-Bole.CodCal = Pl-Cal.CodCal 
            AND (Pl-Bole.TpoBol = "Remuneraciones"
            OR Pl-Bole.TpoBol = "Descuentos"
            OR Pl-Bole.TpoBol = "Aportes"),
            FIRST Pl-Conc OF Pl-Bole NO-LOCK:
            
                FOR EACH Pl-Mov-Mes NO-LOCK 
                WHERE Pl-Mov-Mes.CodCia = S-CodCia
                AND Pl-Mov-Mes.Periodo = FILL-IN-periodo
                AND Pl-Mov-Mes.NroMes  >= 1
                AND Pl-Mov-Mes.NroMes <= 12
                AND Pl-Mov-Mes.CodPln = Pl-Bole.CodPln 
                AND Pl-Mov-Mes.CodCal = Pl-Bole.CodCal
                AND Pl-Mov-Mes.CodMov = Pl-Bole.CodMov:
                    FIND Detalle WHERE 
                        Detalle.CodCia = S-CodCia
                        AND Detalle.TpoBol = Pl-BolE.TpoBol
                        AND Detalle.CodMov = Pl-Bole.CodMov
                        Exclusive-Lock NO-ERROR.
                     IF NOT AVAILABLE DETALLE THEN DO:
                        CREATE DETALLE.
                        ASSIGN
                            DETALLE.CODCIA = S-CODCIA
                            DETALLE.TPOBOL = PL-BOLE.TPOBOL
                            DETALLE.CODMOV = PL-BOLE.CODMOV
                            DETALLE.DESMOV = PL-CONC.DESMOV
                            DETALLE.ValCal [Pl-Mov-Mes.NroMes] = Detalle.ValCal[Pl-Mov-Mes.NroMes]
                            + Pl-Mov-Mes.ValCal-Mes.        
                    END.
                END.
            END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


