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
MESSAGE "ENTRADA AL INCLUDE" VIEW-AS ALERT-BOX.

/*Terminales*/
  
  DEFINE VAR LIST-TERM AS CHAR INIT "".
  S-CODTER = F-TERM:SCREEN-VALUE.

  FOR EACH CcbCTerm NO-LOCK WHERE CcbCTerm.CodCia = s-CodCia AND
      CcbCTerm.CodDiv = s-CodDiv:
      LIST-TERM = LIST-TERM + "," + CcbCTerm.CodTer.
  END.         
  IF LIST-TERM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
     LIST-TERM = SUBSTRING(LIST-TERM,2,LENGTH(LIST-TERM,"CHARACTER") - 1,"CHARACTER").
     f-Term:LIST-ITEMS = LIST-TERM.
     f-Term:SCREEN-VALUE = ENTRY(1,LIST-TERM).
     ASSIGN f-Term.
     s-Codter = F-TERM:SCREEN-VALUE.

  END.

 /*Almacenes*/
    
  S-CODDIV = f-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  DEFINE VAR LIST-ALM AS CHAR INIT "".
  FIND FIRST AlmUsers WHERE AlmUsers.CodCia = S-CODCIA AND
             AlmUsers.User-Id = S-User-Id NO-LOCK NO-ERROR.
  IF AVAILABLE AlmUsers THEN DO:
        FOR EACH AlmUsers NO-LOCK WHERE AlmUsers.CodCia = S-CODCIA AND
            AlmUsers.User-Id = S-User-Id:
            FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                 Almacen.CodDiv = S-CODDIV AND
                 Almacen.CodAlm = AlmUsers.CodAlm NO-LOCK NO-ERROR.
            IF AVAILABLE  Almacen THEN 
               LIST-ALM = LIST-ALM + "," + AlmUsers.CodAlm + 
                          " - " + REPLACE(Almacen.Descripcion,","," ").
        END.
        IF LIST-ALM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
           LIST-ALM = SUBSTRING(LIST-ALM,2,LENGTH(LIST-ALM,"CHARACTER") - 1,"CHARACTER").
           CB-Almacen:LIST-ITEMS = LIST-ALM.
           CB-Almacen:SCREEN-VALUE = ENTRY(1,LIST-ALM).
           ASSIGN CB-Almacen.
           NRO-POS = INDEX(CB-Almacen, "-").
           S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
           S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
        END.
  END.
  ELSE DO:
        FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = S-CODCIA AND
            Almacen.CodDiv = S-CODDIV:
            LIST-ALM = LIST-ALM + "," + Almacen.CodAlm + " - " + REPLACE(Almacen.Descripcion,","," ").
        END.
        IF LIST-ALM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
           LIST-ALM = SUBSTRING(LIST-ALM,2,LENGTH(LIST-ALM,"CHARACTER") - 1,"CHARACTER").
           CB-Almacen:LIST-ITEMS = LIST-ALM.
           CB-Almacen:SCREEN-VALUE = ENTRY(1,LIST-ALM).
           ASSIGN CB-Almacen.
           NRO-POS = INDEX(CB-Almacen, "-").
           S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
           S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
        END.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
       Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN S-CODDIV = Almacen.CodDiv.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


