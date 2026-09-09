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

    FOR EACH Pl-Bole NO-LOCK WHERE Pl-Bole.CodPln = Pl-Calc.CodPln
    	   AND Pl-Bole.CodCal = Pl-Calc.CodCal  
          AND (Pl-Bole.TpoBol = "Remuneraciones"
            OR Pl-Bole.TpoBol = "Descuentos"
            OR Pl-Bole.TpoBol = "Aportes"),
            EACH Pl-Conc OF Pl-Bole NO-LOCK:
        FOR EACH Pl-Mov-Mes NO-LOCK WHERE Pl-Mov-Mes.codcia = s-codcia
                AND Pl-Mov-Mes.periodo = FILL-IN-Periodo
                AND Pl-Mov-Mes.nromes >= 01
                AND Pl-Mov-Mes.nromes <= 12
                AND Pl-Mov-Mes.codpln = Pl-Bole.codpln
                AND Pl-Mov-Mes.codcal = Pl-Bole.codcal
                AND Pl-Mov-Mes.codmov = Pl-Bole.codmov:
            FIND Detalle WHERE Detalle.codcia = s-codcia
                AND Detalle.tpobol = Pl-Bole.tpobol
                AND Detalle.codmov = Pl-Bole.codmov
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Detalle THEN DO:
                CREATE Detalle.
                ASSIGN
                    Detalle.codcia = s-codcia
                    Detalle.tpobol = Pl-Bole.tpobol
                    Detalle.codmov = Pl-Bole.codmov
                    Detalle.desmov = Pl-Conc.desmov
                    Detalle.codcta = Pl-Bole.codcta.
            END.
            ASSIGN
                Detalle.ValCal[Pl-Mov-Mes.NroMes] = Detalle.ValCal[Pl-Mov-Mes.NroMes] +
                                                    PL-MOV-MES.valcal-mes.
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


