&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

def var x-alm11 as dec.
def var x-alm130 as dec.
def var x-alm131 as dec.
def var x-alm22 as dec.
def var x-total as dec.

output to c:\tmp\ATE11224199.txt.
for each almmmatg no-lock where codcia = 1 and tpoart <> 'D'
    and codpr1 = '11224199' by desmat:
    assign
        x-alm11 = 0
        x-alm130 = 0
        x-alm131 = 0
        x-alm22 = 0
        x-total = 0.
    for each almmmate of almmmatg no-lock:
        case almmmate.codalm:
            when '11' then x-alm11 = almmmate.stkact.
            when '130' then x-alm130 = almmmate.stkact.
            when '131' then x-alm131 = almmmate.stkact.
            when '22' then x-alm22 = almmmate.stkact.
        end.
    end.
    x-total = x-alm11 + x-alm131 + x-alm130 + x-alm22.
    if x-total <> 0 then
    display almmmatg.codmat almmmatg.desmat almmmatg.desmar
        almmmatg.codfam almmmatg.undbas 
        x-alm11 x-alm130 x-alm131 x-alm22 x-total
        with stream-io width 200.
end.
output close.
message 'archivo c:\tmp\ATE11224199.txt' view-as alert-box information.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


